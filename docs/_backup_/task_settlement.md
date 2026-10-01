# Task List: Perbaikan Tabel Visibilitas Settlement

- [ ] **1. Menghilangkan Bypass di Table 2 (Pengiriman Dana)**
  - Mengedit `frontend/lib/screens/settlement/settlement_detail_widgets.dart` fungsi `_buildDisbursementSection`.
  - Menghapus logika `isStandalone = expenses.isEmpty`.
  - Memastikan validasi `!allApproved` memunculkan UI *warning* jika `expenses.isEmpty` atau ada item yang belum di-approve.

- [ ] **2. Menghilangkan Bypass dan Memperketat Syarat di Table 3 (Pengembalian Dana)**
  - Mengedit `frontend/lib/screens/settlement/settlement_detail_widgets.dart` fungsi `_buildFundReturnSection`.
  - Memastikan Table 3 tidak muncul (return `SizedBox.shrink()`) apabila `isDisbursementApproved == false`.
  - Menyembunyikan Table 3 jika ini adalah `Pengeluaran Sendiri` yang tidak memerlukan pengembalian dana (atau memastikan saldo Hutang > 0 yang dikembalikan).

- [ ] **3. Handle "Standalone Return" (Jika Diperlukan)**
  - Menerapkan *handler* khusus jika user konfirmasi bahwa pengembalian kasbon 100% tanpa belanja itu diizinkan. Jika diizinkan, kita harus membuat pengecekan `if (advanceId != null && expenses.isEmpty)` maka Table 2 dan 3 boleh tampil khusus untuk pengembalian dana.

- [ ] **4. Verifikasi UI Re-rendering**
  - Pastikan setiap ada event perubahan (edit item / reject item), State me-reset `isDisbursementApproved` dan `isReturnApproved` di UI, sehingga State Management otomatis menyembunyikan tabel yang di bawahnya.
