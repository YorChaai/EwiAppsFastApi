# ADVANCE: RETURN (TABEL 3)

## 1. Feature Purpose

Mengelola pengembalian dana (Refund / Kembalian) dari Karyawan ke Perusahaan pada tahap Kasbon. Tabel ini (Tabel 3) *hanya* aktif dan diwajibkan jika nominal Pencairan (Tabel 2) lebih besar daripada Total Pengajuan yang disetujui (Tabel 1). 

Contoh Kasus: Karyawan mengajukan Rp 950.000, namun Manager mencairkan Rp 1.000.000 (pembulatan tunai). Karyawan harus mengembalikan Rp 50.000 saat itu juga.

## 2. Amount Relationship

Hubungan antara setiap nilai sangat menentukan apakah Tabel 3 akan diaktifkan atau tidak.

*   `approved_amount`: Total nilai yang disetujui oleh Manager dari semua item di Tabel 1.
*   `disbursed_amount`: Nilai riil yang dicairkan oleh Manager, diinput manual pada Tabel 2.
*   `diff`: Selisih antara pencairan dan yang disetujui (`disbursed_amount - approved_amount`).
*   `returned_amount`: Jika `diff > 0.01`, maka `returned_amount = diff`. Jika tidak, `0.0`.

**Source of Truth:**
*   `approved_amount` dihitung dari agregasi `AdvanceItem` yang berstatus `approved` saat *Approve Tabel 2*.
*   `disbursed_amount` di-save oleh `save_disbursement` saat manajer mengubah dropdown atau mengisi nominal di Tabel 2.

## 3. Exact Gate Conditions

*   **Save Return** (`save_return`): Hanya dapat diakses saat parent `Advance` berstatus `draft`, `revision`, atau `rejected`.
*   **Submit Return** (`submit_return`): Syaratnya `returned_amount > 0`, memiliki `return_source` (Bank Tujuan valid), dan memiliki `return_evidence_path` (Bukti transfer ada).
*   **Approve Return** (`approve_return`): Syarat mutlaknya adalah `is_disbursement_approved == True` (Tabel 2 sudah disetujui).
*   **Reject Return** (`reject_return`): Sama seperti Approve, namun membutuhkan keterangan (notes).

## 4. Negative / Blocked Flows

*   **Missing Source**: Jika user men-submit tanpa memilih Bank Tujuan, diblokir (`HTTP 400 - Pilih Sumber Dana`).
*   **Missing Evidence**: Jika men-submit tanpa mengunggah bukti transfer, diblokir (`HTTP 400 - Upload bukti transfer`).
*   **Amount <= 0**: Jika mencoba men-submit Tabel 3 dengan `returned_amount = 0`, diblokir (`HTTP 400 - Nominal pengembalian harus lebih dari 0`).
*   **Tabel 2 Belum Approved**: Jika Manager mencoba Approve Tabel 3 padahal Tabel 2 belum approved, diblokir (`HTTP 400`).
*   **Unauthorized Role**: Staff biasa tidak bisa melihat atau mengedit Advance milik user lain.

## 5. Return Rejection Loop

Jika Manager menolak pengembalian:
1.  **Reject**: Manager memanggil `reject_return` dan memasukkan notes penolakan.
2.  **State Change**: `return_status` menjadi `rejected`, `is_return_approved = False`.
3.  **Notes Array**: Catatan dimasukkan ke `return_notes` dalam format JSON.
4.  **Edit**: Karyawan dapat mengunggah bukti baru atau merevisi pengembalian melalui `save_return`.
5.  **Resolve Checklist**: Karyawan dapat men-centang checklist penolakan via `update_return_notes`.
6.  **Submit Again**: Karyawan mengklik *Submit Return* yang mengubah `return_status` kembali menjadi `submitted`.
7.  **Manager Review**: Manager dapat mengevaluasi dan akhirnya men-klik *Approve Return*.

## 6. Exact Parent State Transition

Berbeda dengan ekspektasi, pengembalian dana (Return) **tidak secara langsung memengaruhi `advance.status`**.

State Machine untuk Return:
1.  `approve_disbursement` (Tabel 2) mengubah parent status menjadi `approved`. Jika `returned_amount > 0`, workflow stage dokumen menjadi `t3_pending`.
2.  `submit_return` mengubah status *Tabel 3* (`return_status`) menjadi `submitted`. Parent status tetap `approved`.
3.  `approve_return` merubah status *Tabel 3* (`return_status`) menjadi `approved`, mengatur `is_return_approved = True`, dan mengubah workflow stage menjadi `final_pending`. Parent status tetap `approved`.
4.  Manager kemudian menekan tombol "Complete" (`final_approve`), yang baru akan mengubah parent status dari `approved` menjadi `completed`.

**Terminal State**:
*   Status Dokumen (Parent) = `completed`
*   Workflow Stage = (Tidak berubah / final_pending)
*   `return_status` = `approved`

## 7. Bank Side Effects (Divergent Ledger Logic)

Terdapat pemisahan mekanisme antara **Advance-based debt calculation** (Hutang Karyawan) dengan **BankTransaction ledger** (Saldo Fisik Bank/Plafon). Hal ini menyebabkan laporan keuangan *Bank Ledger* dan *Debt Calculation* berjalan dengan sumber data yang berbeda dan berpotensi inkonsisten.

**1. Advance-based Debt Calculation (`calculate_user_running_balance`)**
Dihitung secara *on-the-fly* dari row database tabel `Advance`:
`Total Hutang = sum(approved_amount) - sum(returned_amount)`.
*Hasil*: Hutang berjalan (outstanding) **dikalkulasi secara akurat** dan langsung berkurang saat Tabel 3 (Return) di-approve.

**2. BankTransaction Ledger / Real Bank Balance (`calculate_user_available_budget`)**
Dihitung berdasarkan agregasi `BankTransaction` fisik (`Income - Expense`):
*   **Disbursement (Final Approve)**: Membuat *Expense* sebesar `disbursed_amount` pada **Advance Bank / Plafon Karyawan**.
*   **Return (Approve Return)**: Membuat *Income* sebesar `returned_amount` pada **Main Bank (Bank Pusat)**. 

**Impact (Bank Ledger Inconsistency):**
Uang kembalian karyawan terekam masuk ke Main Bank secara Ledger. Namun, *Advance Bank* (Plafon Karyawan) **tidak menerima Income** dari pengembalian ini secara ledger `BankTransaction`. Akibatnya:
*   Hutang karyawan (Outstanding) di sistem = Benar (Berkurang).
*   Sisa Plafon/Available Budget (Real Balance) = **Terus berkurang full (`disbursed_amount`)** dan tidak pulih karena tidak ada `BankTransaction` Income ke bank Plafon.

## 8. Role Matrix

*   **Staff**: Hanya dapat `save_return`, `submit_return`, dan mencentang checklist (`update_return_notes`).
*   **Manager / Super Manager**: Memiliki hak prerogatif. Dapat melakukan bypass `save_return` atau `submit_return` mewakili staff, dapat `approve_return`, dan `reject_return`.

### Critical Findings
*   Status induk (Advance status) tidak berubah saat Return disubmit maupun diapprove.
*   Approval Return mengubah *Workflow Stage* menjadi `final_pending`.

### State Transition
*   `T2 Approved (T3 Pending)` -> `Submit Return` -> `T3 Submitted` -> `Approve Return` -> `T3 Approved (Final Pending)`.

### Bank Side Effects
*   `approve_return` = Income (Main Bank).
*   `final_approve` = Expense (Plafon Virtual Bank).
*   Bank ledger dan debt calculation menggunakan mekanisme yang berbeda: Outstanding dihitung valid dari row `Advance`, sedangkan Available Budget dihitung cacat dari row `BankTransaction`.

### Potential Issue
*   **Plafon Budget Mismatch**: Uang return masuk ke Main Bank ledger, namun tidak mengkredit Plafon Virtual Bank ledger, menyebabkan `Available Budget` karyawan habis sebelum waktunya.

### Confirmed
*   Tabel 3 merupakan sub-cycle dari Advance, tidak merusak status parent selama siklus revisinya berjalan.

### Evidence
*   `backend/routes/advances_disbursement.py` (`approve_return`, `submit_return`).
*   `backend/routes/advances_approval.py` (`final_approve_advance`).
