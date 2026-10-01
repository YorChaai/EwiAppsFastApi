# ADVANCE: SUBMIT & APPROVAL LOOP

## 1. Feature Purpose

Meneruskan dokumen kasbon (Tabel 1, 2, dan 3) ke Manager untuk dievaluasi. Manager dapat menyetujui, menolak, atau meminta revisi melalui komentar/checklist. User dapat mengedit kembali jika ditolak (Move to Draft / Revision Loop).

## 2. Exact State Transition & State Machine Final

Melalui penelusuran Front-End dan Back-End secara menyeluruh, ditemukan ada dua jalur (`endpoint`) yang memiliki skrip untuk merubah status parent dari `submitted` ke `approved`. Namun, hanya satu yang merupakan *Normal Flow*.

**Urutan Normal (Healthy Path):**
1. **T1 Approval**: Manager menekan tombol *Approve* pada setiap baris item (Endpoint `approve_advance_item`).
   * *Status Induk*: Tetap `submitted`.
   * *Tabel 2*: Mereset `is_disbursement_approved = False`.
2. **T2 Approval**: Manager menekan tombol *Checkmark* pada Tabel 2 (Endpoint `approve-disbursement`). Syarat tombol ini muncul di UI: Status **wajib** `submitted` dan `is_disbursement_approved == False`.
   * *Trigger*: Di dalam backend, jika semua T1 sudah `approved`, maka `approve-disbursement` akan **memicu otomatis** perubahan status induk menjadi `approved`.
3. **Final Approve**: Manager menekan tombol "Complete" (Endpoint `final_approve`).
   * *Trigger*: Mengubah `approved` menjadi `completed`.

**Potential Issue / Bug (Stuck Flows):**
*   **Tabel 2 Bank Source Mismatch (UI Auto-Save Bug)**: UI Detail mengizinkan Manager mengubah Dropdown Bank saat dokumen berstatus `submitted` lalu menekan Approve Tabel 2. UI akan diam-diam memanggil `save_disbursement` dulu. Backend akan **MENOLAK (HTTP 400)** karena `save_disbursement` khusus status `draft`/`revision`. Manager akan stuck tidak bisa nge-klik Approve Tabel 2 jika nekat mengubah bank.
*   **Quick Action "Setujui" Trap (Dashboard Bug)**: Tombol "Setujui" di Dashboard memanggil `approve_all`. Ini bukan 1-click magic, karena: (1) Ia akan gagal HTTP 400 jika masih ada item T1 yang pending; (2) Jika sukses, ia mengubah status Parent jadi `approved` tapi membiarkan T2 *unapproved*. Hal ini membuat UI Detail menyembunyikan tombol *Approve Tabel 2*, sehingga dokumen tidak akan pernah bisa di "Complete" / Final Approve. Manager akan terjebak selamanya di status `approved`.

**Jawaban Final Atas Endpoint Transisi:**
*   `approve-disbursement` adalah *Normal Flow* dan *exact trigger* perubahan `submitted` -> `approved`.
*   `approve_all` adalah *Alternate Flow* (Dashboard) yang memiliki cacat logika (bug) jika digunakan pada Kasbon karena menyebabkan status *stuck*. Keduanya tidak bisa dipakai bersamaan pada jalur yang normal.

---

## 3. Submit Advance

**Condition Before:**
Advance berstatus `draft` (atau `revision`, atau `rejected`), memiliki setidaknya 1 item, dan tidak ada catatan revisi (checklist) yang belum dicentang/diselesaikan.

**Actor / Role:**
Staff / Pembuat Dokumen.

**User Action:**
Klik tombol "Submit".

**System Behavior / API:**
Memanggil `POST /api/advances/<advance_id>/submit` (`backend/routes/advances_approval.py`).
Manager tidak dapat langsung melakukan "Approve All". Terdapat mekanisme **Gate** di mana Manager harus menyetujui setiap item (Tabel 1) secara individual terlebih dahulu.

### 3.1 Item Approval (`POST /api/advances/items/<int:item_id>/approve`)

1. **Category Validation**: Jika kategori yang dipilih pada item masih berstatus `pending` (belum disetujui master datanya), sistem akan memblokir dan meminta manager menyetujui kategori tersebut terlebih dahulu (`HTTP 400`).
2. **Balance Check**: Sistem memanggil `calculate_user_available_budget()`. Jika uang (plafon virtual bank perusahaan) tidak mencukupi untuk membiayai item tersebut, approval diblokir (`HTTP 422 - insufficient_advance_balance`).
3. Jika lolos, status item menjadi `approved`.

### 3.2 Alternate Approval Path — `approve_all` (`POST /api/advances/<advance_id>/approve_all`)

Ini BUKAN merupakan *Normal Flow*, melainkan Quick Action yang dapat menyebabkan *stuck* di UI.

**Condition Before:**
Seluruh item di dalam dokumen harus berstatus `approved` secara individual.

**Backend Logic:**
1. Manager dapat melakukan **Override Nominal** (`approved_amount_override`). Jika terjadi, backend mencatatnya ke tabel `OverrideLog`.
2. **Final Gate**: Cek ulang apakah ada item yang belum di-approve.
3. **Final Balance Check**: Cek ulang `calculate_user_available_budget()`.
4. Jika lolos, status header menjadi `approved`.
5. Sync ulang T2 `disbursed_amount = advance.approved_amount` (menggunakan nilai yang sudah diapprove/di-override).
6. Reset `modified_t2 = False` dan `is_disbursement_approved = False`.
7. Mengubah stage workflow ke `t2_pending`.
8. Men-trigger notifikasi `notify_advance_approved_final`.

---

## 4. Rejection & Revision Loop

### 4.1 Manager Reject Item / Add Notes
Manager dapat menolak item spesifik (`POST /api/advances/items/<item_id>/reject`) atau memberikan komentar revisi. Item menjadi `rejected` dan disisipkan _notes_ berbentuk checklist.

### 4.2 Manager Reject All (`POST /api/advances/<advance_id>/reject_all`)
1. Status header dikembalikan menjadi `draft`.
2. Seluruh item diubah menjadi `rejected`.
3. Notifikasi `notify_advance_rejected_final` dikirimkan.
4. User (Staff) kemudian bisa memperbaiki dokumen. Sistem kembali ke mode Draft, namun _notes_ (checklist revisi) harus dicentang sebelum dokumen bisa di-submit ulang (Lihat bagian Submit Advance).

---

## 5. Override / Move to Draft Flow

Fitur pengaman untuk membatalkan proses dan mengembalikan dokumen ke draf untuk diperbaiki secara manual.

**Condition Before:**
Dokumen sudah terlanjur disubmit atau di-approve, namun user/manager menemukan kesalahan.

**API:**
`POST /api/advances/<advance_id>/move_to_draft` (`backend/routes/advances_other.py`)

**Backend Logic:**
1. Cek role: Staff tidak boleh menarik dokumen yang sudah `approved` atau `completed`. Hanya manager yang bisa (atau user jika statusnya masih `submitted`).
2. **Dependency Block**: Jika kasbon sudah dipakai dalam transaksi `Settlement`, tarik draf diblokir (`HTTP 400`).
3. **Balance Rollback Check**: Jika kasbon sudah `approved` (sudah mengurangi plafon), sistem mensimulasikan pengembalian saldo. Jika pengembalian ini menyebabkan saldo minus (karena dipakai oleh settlement lain), tarik draf ditolak.
4. Mengembalikan status menjadi `draft`.
5. Mereset flag `modified_t1`, `modified_t2`, `modified_t3`.
6. Menghapus (Hard Delete) transaksi perbankan (`BankTransaction`) yang mungkin sudah terlanjur di-generate pada tahap pencairan, sehingga *Hutang* dan *Saldo* kembali nol.

---

## Evidence

*   **Viewed File:** `frontend/lib/screens/advance/advance_detail_actions.dart` (`_submitAdvance`, `_moveToDraft`, `_approveAdvance`).
*   **Viewed File:** `backend/routes/advances_approval.py` (`submit_advance`, `approve_advance`, `reject_advance`, `approve_advance_item`).
*   **Viewed File:** `backend/routes/advances_other.py` (`move_advance_to_draft`).

## Confirmed

*   Submit tidak akan bisa dilakukan jika ada item dengan komentar revisi yang belum diselesaikan (checklist constraint).
*   Approval Kasbon dilakukan secara bertahap: Approve semua child items terlebih dahulu, baru bisa Approve parent document.
*   Plafon saldo bank dicek ketat pada saat approve item dan approve final.
*   Tarik draf memiliki constraint ketat terhadap Settlement dan Saldo Bank.

## Cross-Feature Dependency

*   **Category Management**: Kategori item harus berstatus `approved`.
*   **Settlement**: Tarik draf diblokir jika dokumen terikat ke Settlement.
*   **Bank Management (Plafon)**: Approval ditolak jika plafon/saldo bank peruntukkan tidak mencukupi. Terdapat logic rollback `BankTransaction` saat *Move to Draft*.
