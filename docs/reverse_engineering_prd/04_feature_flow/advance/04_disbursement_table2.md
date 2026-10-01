# ADVANCE: DISBURSEMENT (TABEL 2)

## 1. Feature Purpose

Mencatat dan memproses pencairan kasbon (Disbursement). Tabel 2 dikelola secara eksklusif oleh Manager untuk menentukan dari mana sumber dana (Plafon Bank Virtual) diambil dan berapa nominal yang disetujui.

## 2. Normal Flow: Manager Mengedit Tabel 2

**Exact Gate Conditions (Negative/Blocked Flows):**
1. **Status Lock**: Backend menolak jika `advance.status` BUKAN `draft`, `revision`, atau `rejected` (HTTP 400: "Tabel ini hanya bisa diubah dalam mode Draft atau Revisi").
2. **Missing Source/Bank**: Dropdown sumber dana wajib valid terhadap `BankAccount` yang ada.

**Backend Logic & Side Effects:**
1. Update field: `disbursement_source`, `admin_fee`, `disbursement_comment`, `disbursed_amount`.
2. Set flag `modified_t2 = True`.
3. Mereset `is_disbursement_approved = False`.
4. **Parent-Child Synchronization (Sinkronisasi ke Tabel 3)**:
   * Menghitung selisih: `diff = disbursed_amount - approved_amount` (dari Tabel 1).
   * Jika `diff <= 0.01` (uang pas), `returned_amount = 0`, Tabel 3 direset ke `pending`, `modified_t3 = False`.
   * Jika `diff > 0.01` (ada kembalian), Tabel 3 otomatis diset dengan deskripsi dan sumber dana yang sama dengan Tabel 2.

**Status After:**
Tetap pada status sebelumnya (`draft` / `revision` / `rejected`).

---

## 3. Manager Approve Tabel 2

**Exact Gate Conditions:**
1. **UI Block**: Tombol centang (Approve) di Tabel 2 HANYA MUNCUL JIKA dokumen berstatus `submitted` dan `is_disbursement_approved == False`.
2. **Data Block**: Sumber dana (Disbursement Source) wajib diisi, evidence wajib ada, dan amount > 0.
3. **Backend Validation**: Plafon balance (ketersediaan budget perusahaan untuk ditarik ke plafon) harus cukup.

**System Behavior / API:**
Memanggil `POST /api/advances/<advance_id>/approve-disbursement`.

**Deep Trace Endpoint (`approve_disbursement`):**
1. Mencari *Main Bank* (Bank Utama Perusahaan) berdasarkan string nama yang diinput manager (contoh: "BCA").
2. Mencari *Advance Bank* (Rekening Virtual Plafon Karyawan) yang sesuai.
3. **Plafon Balance Check (`calculate_bank_composition`)**:
   Sistem mengecek komposisi uang di dalam *Advance Bank* karyawan. Apakah saldo plafon yang bersumber dari *Main Bank* tersebut mencukupi untuk membiayai nominal `disburse_amount`?
4. Jika kurang: Memblokir approval (`HTTP 422 - insufficient_advance_balance`), dengan UI error "Saldo X Anda di akun Advance tidak mencukupi".
5. Jika lolos:
   * Set `is_disbursement_approved = True`.
   * Merubah `advance.bank_id` ke ID *Advance Bank* karyawan (Sebagai preparasi pencairan).
   * Merubah `advance.disbursement_source_id` ke ID *Main Bank*.
6. **Parent State Effect (PENTING)**: Mengecek seluruh item T1. Jika semua item T1 sudah berstatus `"approved"`, maka sistem **OTOMATIS** menggeser Parent `Advance.status` dari `"submitted"` menjadi `"approved"`.
7. Sinkronisasi ulang Tabel 3.

---

## 4. Final Approve / Complete Advance

**Trigger:**
Manager menekan tombol "Complete" / "Final Approve" di detail screen (Atau menekan "Setujui" dari Dashboard yang berujung eksekusi fungsi yang sama).

**System Behavior / API:**
Memanggil `POST /api/advances/<advance_id>/final_approve`.

**Exact Gate Conditions:**
1. **Concurrency Lock**: Menggunakan `with_for_update()` pada record `User` untuk mencegah *race condition*.
2. **Parent Status**: Harus `submitted` atau `approved`.
3. **Tabel 1 Sync**: Loop mengecek item: Tidak boleh ada item yang `pending`. Jika ada, `HTTP 400` ("Item masih berstatus pending. Semua item harus disetujui secara individu").
4. **Tabel 2 Check**: `is_disbursement_approved` WAJIB `True`. Jika `False` -> HTTP 400 ("Tabel Pengiriman Dana belum disetujui").
5. **Main Budget Check**: Memanggil `calculate_user_available_budget`. Jika budget utama Perusahaan tidak cukup -> `HTTP 422`.

**State Effect:**
Mengubah status dokumen menjadi `completed` secara final.
Update Workflow log menjadi `completed`.

**Database / Side Effects (PENTING):**
Sistem **tidak** memotong saldo dari Bank Utama Perusahaan secara langsung, melainkan:
1. Mengidentifikasi atau membuat (auto-create) rekening virtual plafon untuk karyawan (`BankAccount` dengan `account_type = 'advance'`).
2. Membuat `BankTransaction` bertipe `expense` sebesar `disburse_amount` yang diarahkan ke **Advance Bank (Plafon Virtual)**.
3. Transaksi ini menyebabkan *Available Budget* (Plafon) karyawan berkurang, dan secara tidak langsung mencatat *Hutang Karyawan* (Piutang Perusahaan) bertambah.
4. Membuat log transaksi (`OverrideLog`) yang akan muncul di Log Book / Riwayat Aktivitas karyawan.

---

## Evidence Summary

**Confirmed:**
*   Proses kasbon tidak mendebit *Main Bank* pada saat Final Approve. Kasbon hanya mendebit *Advance Bank* (Plafon Virtual Karyawan), yang berfungsi sebagai pencatat hutang.
*   Approval Tabel 2 (`approve_disbursement`) dan Final Approve (`final_approve_advance`) dikawal oleh validasi saldo yang sangat ketat hingga level komposisi asal usul uang (Main Bank) di dalam akun Plafon.
*   *Concurrency lock* diterapkan pada saat final approve.

**Documentation vs Implementation Mismatch:**
*   Sebelum verifikasi, diduga Tabel 2 (`save_disbursement`) dapat diedit kapan saja setelah status parent menjadi `approved` (Disbursement Phase). Namun aktual di Backend (`save_disbursement` baris 43), edit hanya diperbolehkan di mode `draft` atau `revision`.
*   Status `approved` bukanlah gate masuk ke Tabel 2. Sebaliknya, menyetujui Tabel 2-lah (`approve_disbursement`) yang akan memicu dokumen berubah status menjadi `approved` (Jika semua item Tabel 1 juga sudah *approved*).

**Potential Issue:**
*   **UI Auto-Save Bug**: Di Flutter UI (`advance_detail_tables.dart` baris 1184), jika Manager menekan tombol *Approve Tabel 2*, ada skrip yang mencoba melakukan "Sinkronisasi data ke DB" dengan memanggil `saveDisbursement` secara diam-diam apabila dropdown sumber dana berbeda dengan Database. Jika ini terjadi saat dokumen berstatus `submitted` (kondisi default saat tombol Approve Tabel 2 muncul), backend akan merespon dengan `HTTP 400` ("Tabel ini hanya bisa diubah dalam mode Draft"), sehingga proses Approval GAGAL dan Manager *stuck*. Manager harus mengembalikan dokumen ke Draft jika ingin merubah Sumber Bank.

## Cross-Feature Dependency

*   **Bank Management (Plafon)**: Modul Advance sangat bergantung pada fitur *Advance Bank* dan komposisi saldo.
*   **Log Book**: Transaksi dicatat ke `OverrideLog` dengan format JSON yang kompleks.
