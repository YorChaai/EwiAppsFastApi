# Product Requirements Document (PRD)

## 1. Bug 1: Pemilihan Sub Kategori di Settlement
- **Latar Belakang:** Pada form Kasbon Detail, pengguna sudah bisa memilih lebih dari satu Sub Kategori. Namun, pada form Settlement, komponen UI masih menggunakan Radio Button yang membatasi pemilihan hanya pada satu Sub Kategori tunggal.
- **Dampak:** Ketidakkonsistenan antarmuka antara Kasbon dan Settlement. Pengguna kesulitan jika ada satu transaksi Settlement (pengeluaran) yang mencakup beberapa Sub Kategori yang perlu dilaporkan sekaligus.
- **Kebutuhan Fungsional (Requirements):**
  1. Komponen UI pada dialog tambah/edit expense Settlement harus diganti dari Single Selection (Radio) menjadi Multiple Selection (Checkbox).
  2. Variabel state yang menyimpan nilai pilihan harus diubah dari nilai tunggal (`int?`) menjadi tipe himpunan (`Set<int>`) agar mendukung penyimpanan banyak ID secara bersamaan.
  3. Sistem harus memvalidasi bahwa pengguna setidaknya memilih minimum satu Sub Kategori sebelum dapat menekan tombol Simpan.
  4. Komponen Checkbox yang dibangun harus memiliki tata letak (layout) dan desain visual yang sama persis dengan yang sudah diimplementasikan di halaman Kasbon (konsistensi UI/UX).
  5. Format data (payload JSON) yang dikirim ke backend API Settlement harus dipastikan berbentuk array/list dari ID Sub Kategori, kompatibel dengan skema tabel relasi yang sudah ada.

## 2. Bug 2: Saldo Hutang Belum Terbarui (Outstanding Debt)
- **Latar Belakang:** Ketika pengguna menerima dana Kasbon (hutang), saldo "Dompet Kasbon / Hutang Anda" akan bertambah. Sayangnya, ketika pengguna sudah melaporkan dan menyelesaikan pengeluaran tersebut melalui Settlement yang berstatus disetujui, nominal hutang tetap tidak berkurang di tampilan.
- **Dampak:** Tampilan saldo virtual/hutang pengguna tidak mencerminkan kenyataan. Pengguna bisa merasa bingung atau mengira laporannya belum masuk, yang menyebabkan kesalahan dalam permintaan kasbon baru.
- **Kebutuhan Fungsional (Requirements):**
  1. Perhitungan hutang di backend (endpoint `/api/user_balances/`) tidak boleh hanya memperhitungkan uang yang diretur (`returned_amount`), tetapi juga harus memperhitungkan jumlah yang telah diselesaikan (Settle).
  2. Query backend harus mengambil data dari tabel `Settlement` yang berstatus `approved` atau `completed` dan terhubung dengan pengguna tersebut.
  3. Sistem perlu mengelompokkan pengeluaran Settlement tersebut berdasarkan sumber bank/dompet asalnya, agar dapat dipasangkan dengan sumber hutang Kasbon yang sesuai.
  4. Total hutang akhir (`net_amount`) harus dikurangi dengan `approved_amount` dari seluruh Settlement yang valid.
  5. Perubahan ini harus bekerja untuk transaksi historis maupun transaksi baru tanpa merusak kalkulasi data Kasbon yang tidak memiliki settlement.

## 3. Bug 3 (Fitur): "Buat Settlement" Button Behavior
- **Latar Belakang:** Saat ini tombol "Buat Settlement" di halaman Kasbon berfungsi untuk membuat entri Settlement baru yang tertaut langsung (linked) dengan ID Kasbon. Namun, item-item detailnya tidak tersalin secara otomatis, dan tautan langsung ke Kasbon seringkali mengunci fleksibilitas.
- **Dampak:** Pengguna membuang waktu untuk menginput ulang semua rincian barang/pengeluaran satu-per-satu di Settlement padahal datanya sama dengan yang diajukan di Kasbon.
- **Kebutuhan Fungsional (Requirements):**
  1. Tombol "Buat Settlement" dari halaman Kasbon akan difungsikan sebagai "Auto Copy-Paste" rincian item, bukan sekadar penaut (linker) relasional.
  2. Saat tombol ditekan, backend harus secara otomatis menyalin (duplicate) semua baris data dari `AdvanceItem` menjadi `Expense` (SettlementItem).
  3. Field data yang disalin mencakup nilai nominal (amount), deskripsi, kategori, serta daftar sub kategori terkait dengan akurat.
  4. Entri Settlement yang terbentuk dari proses ini harus disetel secara otomatis ke status "Draft" agar pengguna masih bisa mengubah (menambah/menghapus/mengedit) isinya sebelum pengajuan.
  5. ID Kasbon (`advance_id`) pada objek Settlement baru harus diatur menjadi NULL (atau tidak menjadi relasi absolut) untuk memenuhi syarat bisnis bahwa "Settlement yang dibuat tidak memiliki keterkaitan dengan data Kasbon secara sistem".

## 4. Bug 4: Evidence Tidak Bisa Dihapus Saat Menambah Item
- **Latar Belakang:** Pada mode "Tambah Item" di halaman Kasbon dan Settlement, pengguna bisa mengunggah bukti (evidence). Namun, apabila mereka menekan tombol "X" (Hapus) pada file yang baru diunggah tersebut, file tetap bertahan di UI. Anehnya, hal ini berfungsi normal pada mode "Edit Item".
- **Dampak:** Pengguna tidak bisa membatalkan atau mengganti file yang salah unggah saat mengisi form Tambah. Mereka terpaksa harus membatalkan (cancel) keseluruhan form dan mengulang proses input dari awal.
- **Kebutuhan Fungsional (Requirements):**
  1. Aksi klik pada tombol X (hapus file) harus ditangkap dengan baik oleh aplikasi tanpa terhalang elemen lain di sekitarnya.
  2. Pembaruan state (`setDialogState`) pada array file internal (`selectedFilePaths` dan `selectedFileNames`) harus segera memicu _rebuild_ (render ulang) pada daftar file yang ditampilkan.
  3. Daftar file harus mengimplementasikan penggunaan identifier (Key) secara eksplisit di Flutter agar engine dapat mendeteksi adanya penghapusan baris dari hirarki list.
  4. Area klik (Hit Box) pada ikon X perlu diperbesar untuk memudahkan sentuhan jari atau klik kursor, serta memastikan event _touch_ selalu terdeteksi (opaque).
  5. Logika penghapusan array tidak boleh menyebabkan kondisi error/out-of-bounds yang membuat fungsi UI membeku (frozen) di pertengahan eksekusi.
