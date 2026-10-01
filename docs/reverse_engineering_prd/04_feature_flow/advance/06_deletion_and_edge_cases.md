# ADVANCE: DELETION & EDGE CASES

## 1. Feature Purpose

Menghapus (Hard Delete) data Kasbon beserta data dependency-nya jika terdeteksi duplikasi, pembatalan permanen, atau error. Operasi ini berisiko tinggi karena `Advance` terikat pada log aktivitas, riwayat revisi, dan status keuangan (Virtual Plafon).

## 2. Exact Deletion Condition & Logic

**API / Endpoint:** `DELETE /api/advances/<int:advance_id>` (`backend/routes/advances_crud.py`).

**State & Role Conditions:**
*   **Staff**: HANYA diizinkan menghapus dokumen jika status parent adalah `draft`. (Diblokir pada status `submitted`, `revision`, `rejected`, `approved`, dll).
*   **Manager / Super Manager**: Diizinkan menghapus dokumen pada **SEMUA STATUS**, termasuk yang sudah `approved` atau `completed`.

**Dependency Condition:**
*   **Settlement Block**: Jika dokumen Advance ini memiliki satu atau lebih Settlement (Tabel `settlements`), penghapusan akan **diblokir mutlak** (`HTTP 400`). Dokumen Settlement harus dihapus atau di-tarik ke draft terlebih dahulu.

## 3. Bank & Plafon Rollback Behavior (The Catch)

Ketika Manager menghapus Advance yang sudah berdampak pada keuangan (`approved` / `completed`), sistem melakukan simulasi *Plafon Rollback*.

**Simulasi Rollback:**
1. Sistem menghitung sisa hutang/plafon virtual saat ini (`current_hutang = calculate_user_running_balance`).
2. Hutang berjalan karyawan adalah `total_advance - total_returned_advance` dari tabel `Advance`.
3. Saat sebuah dokumen Advance dihapus, kontribusinya (`approved_amount - returned_amount`) ikut hilang, yang secara fungsional akan *mengembalikan* plafon ke sisa yang lebih besar (hutang berkurang).
4. Namun, sistem mengecek jika `current_hutang - contribution < -0.01` (Artinya penghapusan ini membuat kalkulasi plafon menjadi tidak rasional/minus), penghapusan akan digagalkan.

## 4. Deletion Impact Matrix

| Scenario | Advance State | Outstanding/Debt (Plafon Virtual) | BankTransaction (Ledger) | Available Budget (Real Balance) | Settlement Dependency | Result |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Dihapus oleh Staff | `draft` | Tidak terdampak | Tidak terdampak | Tidak terdampak | - | Sukses, row hilang. |
| Dihapus oleh Manager | `submitted` / `rejected` | Tidak terdampak | Tidak terdampak | Tidak terdampak | - | Sukses, row hilang. |
| Dihapus oleh Manager | `approved` (Belum Final) | Dikembalikan (Debt berkurang) | Tidak terdampak | Tidak terdampak | - | Sukses, budget pulih. |
| Dihapus oleh Manager | **`completed`** | Dikembalikan (Debt berkurang) | **ORPHANED** (Expense tertinggal) | **TIDAK PULIH** (Selamanya terpotong) | Diblokir jika ada | **POTENTIAL INCONSISTENCY**, Plafon terpotong di ledger tapi tidak ada hutang. |
| Dihapus oleh Manager | **`completed` + Return `approved`**| Dikembalikan (Debt berkurang) | **ORPHANED x2** (Return Income tertinggal) | **TIDAK PULIH** | Diblokir jika ada | **POTENTIAL INCONSISTENCY**, Mutasi acak pada Main Bank dan Plafon. |

## 5. The "Orphaned Transaction" Impact (Bug vs Ledger)

Terdapat cacat desain pada logika *Hard Delete* untuk status `completed`.

Saat sebuah Advance mencapai `final_approve`, sistem mencatat mutasi *Expense* secara fisik pada tabel `BankTransaction` untuk Bank Plafon Virtual. Jika ada Return (Tabel 3) yang disetujui, dicatat pula mutasi *Income* pada Main Bank.

Namun, tabel `BankTransaction` **tidak memiliki** Foreign Key (`advance_id`) yang valid ke tabel `Advance`. Transaksi tersebut hanya menyematkan referensi via String (`description` mengandung `Ref: #ID`). 

**Dampak:**
Ketika Manager memanggil `DELETE /api/advances/<id>`, SQLAlchemy menjalankan `db.session.delete(advance)` yang menghapus row kasbon. Karena tidak ada relasi Foreign Key / Cascade Delete, **baris `BankTransaction` akan tertinggal selamanya (Orphaned)**.

Hal ini memicu **Potential Inconsistency** antara Advance-based Debt Calculation vs BankTransaction Ledger:
1.  **Outstanding / Debt**: Terpulihkan (Normal). Dikalkulasi *on-the-fly* dari row `Advance`. Saat dihapus, hutang otomatis hilang.
2.  **Real Bank Balance**: Tidak valid (Mismatch). Kalkulasi `BankTransaction` masih menghitung *expense* kasbon yang sudah dihapus.
3.  **Available Budget**: Tidak valid (Berkurang Permanen). Bergantung pada Real Bank Balance. Plafon yang uangnya sudah cair tidak kembali meskipun dokumen dihapus.
4.  **Logbook / Riwayat Mutasi**: Menampilkan transaksi hantu. Ada mutasi keluar namun tidak ada dokumen referensinya.
5.  **Laporan Tahunan (Report)**: Berisiko *mismatch* antara total biaya keluar di bank dan total rekapitulasi Advance.

### Confirmed
*   Hanya Manager yang dapat menghapus dokumen yang sudah *Approved* / *Completed*.
*   Penghapusan diblokir secara total jika Advance sudah terikat dalam tabel Settlement.
*   Plafon Debt (Outstanding) dikalkulasi *on-the-fly* dari row `Advance`. Menghapus dokumen = Otomatis memulihkan plafon hutang karyawan.

### Inferred
*   Penghapusan dokumen `completed` tidak dirancang untuk memulihkan *Available Budget* secara mulus, dan diasumsikan jarang dilakukan kecuali terjadi human error ekstrem.

### Potential Issue
*   **Ledger Divergence**: Menghapus Advance `completed` merusak keselarasan antara perhitungan Hutang Berjalan vs Saldo Riil Bank Plafon.
*   **Orphaned Ledger Rows**: `BankTransaction` akan tertinggal tanpa row asal, muncul di logbook tanpa detail dokumen.

### Evidence
*   `backend/routes/advances_crud.py` (`delete_advance`).
*   `backend/routes/advances_approval.py` (`final_approve_advance` - penciptaan expense).
*   `backend/routes/advances_disbursement.py` (`approve_return` - penciptaan income).
