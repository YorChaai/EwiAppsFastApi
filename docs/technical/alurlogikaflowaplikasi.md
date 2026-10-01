#

# Aplikasi EwiApps

Disini ada aplikais terdiri dari

1. login
2. register
3. dashboard / pilihan perusahaan
4. settlement list
5. kasbon list
6. settlement detail
7. Kasbon detail
8. kategori management
9. laporan
10. setting

—

login
di login bisa melakukan login atau register akun
dimana tuh kalo login harus isi username dan password untuk masuk aplikasi dan ada button ingat saya biar bisa inget data account biar nanti keluar aplikasi gak ush login kembali, disini juga ada login as google jika sudha terdaftar google, dan ada tempat ganti api semisalnya server berubah

register
di register terdapat kolom form yang harus diisi yaitu, username, email, nama lengkap, no hp, tempat kerja,password, konfimasi password, dan pilih sebagai (staff,mitra), dan pilih aplikasi(ewi foundation, exspan wireless indonesia, dan nanti kalo sudah terisi dna berhasil bikin account maka lanjut ke login page

dashboard

disini tempat untuk memilih mau buka aplikasi untuk perusahaan mana, dan sebagai role yang punya 2 akses kedua apliaksi maka akna harus teken peruhsaan manabyang mau di tuju, jika di role itu cuman bisa akses 1 aplikasi maka dia tidak perlu teken untuk aplikasi itu dan langsung masuk ke aplikasi perusahaan yang di tuju

settlement list
disini settelment list berisi sidebar, dan settlementlist sendiri untuk informasi sidebar akan di bahas di point 10, dan di settlmetn ini ada tempat search bar dimana tuh bisa cari dokument expensve , bisa bikin expseve settlment dimana haurs di pilih mau bacth atau single, kalo single langsung lanjut ajh bikin nya kalo btahc harus isi judul expseve dan tnaggal pembuatan juga, dan disitu terdapata card juga yang bisa di teken unutk masuk ke detail masing masing itu dimana terdapat card settlmetn dan kasbon biar saling tupukan disana, dan juga ada tempat hapus card gitu di select itu bisa kmau lihat disana untuk bisa select 1 atau selec multiple,

kasbon list
disini pada dasarnya 100 persen mirip kaya settlment list

settlment list

Berikut adalah perbaikan dan penyusunan ulang teks Anda agar jauh lebih rapi, terstruktur, dan telah memasukkan **alur _Komentar Reject_ (Revisi)** secara lengkap sesuai dengan logika sistem yang Anda deskripsikan:

# Alur Pembuatan Detail Settlement (Expense) & Sistem Revisi

Bagian ini merupakan langkah lanjutan setelah pembuatan _Settlement Expense_, di mana pengguna harus menambahkan detail item pengeluaran. Terdapat dua ketentuan dasar:

- **Tipe Single:** Hanya bisa mengisi 1 detail item pengeluaran.
- **Tipe Batch:** Bisa membuat lebih dari 1 detail item pengeluaran.

### logika redudant yang harus di baca

⚠️ Aturan Hierarki & Visibilitas Tabel (_Table Hiding Logic_)

Sistem ini menggunakan logika hierarki berurutan yang sangat ketat. Tabel di bawahnya sangat bergantung pada status persetujuan (_Approved_) tabel di atasnya.

1. **Jika dalam keadaan sudah mengisi sampai ke table 3 dan Mengedit Table 1:** Apabila pengguna menekan tombol edit pada Table 1, maka secara otomatis **Table 2 dan Table 3 akan disembunyikan (_hide_)**.
   - Table 2 baru akan muncul kembali jika Table 1 sudah di approved item detailnya
   - Table 3 baru akan menyusul muncul setelah Table 2 juga selesai di-_approve_.
2. **Jika Mengedit Table 2:** Apabila pengguna menekan tombol edit pada Table 2, maka secara otomatis **Table 3 akan disembunyikan (_hide_)**.
   - Table 3 baru akan muncul kembali setelah Table 2 tuntas dan berstatus _Approved_.

### ⚠️ Aturan Revisi & Komentar Reject

Mekanisme revisi pada seluruh tabel (Table 1, Table 2, dan Table 3) menggunakan alur yang sama.

1. Jika verifikator menekan ikon **Silang (Reject)**, maka status data akan berubah menjadi **Revision**.
2. Sistem akan menampilkan form **Komentar Reject**.
3. Verifikator dapat menambahkan satu atau lebih komentar revisi dan menyimpannya.
4. Untuk melakukan perbaikan, pengguna harus mengubah status kembali ke **Draft** melalui tombol **Move to Draft**.
5. Setelah status menjadi **Draft**, pengguna dapat memperbaiki data sesuai komentar yang diberikan.
6. Pengguna wajib mencentang setiap komentar reject yang telah diselesaikan.
7. Data hanya dapat di-_Submit_ kembali apabila seluruh komentar reject telah ditandai selesai.
8. Setelah di-_Submit_ ulang, data akan masuk kembali ke proses verifikasi hingga memperoleh status **Approved**.

fungsi tambahan
Fungsi nambah kategori baru dan sub kategori baru

Pembuatan kategori dan subkategori dilakukan melalui menu **Tambah** atau **Edit** pada Table 1. kategori bisa di buat langsung di button tambah kategori dan khusus Subkategori hanya dapat dibuat setelah memilih kategori. Jika ingin membuat kategori dan subkategori baru, maka keduanya harus dibuat terlebih dahulu di dibikin secara secara gantian.

Kategori dan subkategori yang baru dibuat akan berstatus **Pending**, tetapi tetap tersimpan di database dan dapat digunakan untuk mengisi item detail serta tetap dapat di-_Submit_.

Saat manager melakukan verifikasi, item detail yang menggunakan kategori atau subkategori berstatus **Pending** tidak dapat di-_Approve_ saat di apprvoed munucl pop up yang akna mengarah ke management kategori. Kategori dan subkategori tersebut harus terlebih dahulu di-_Approve_ melalui halaman **Management Kategori**.

Setelah kategori dan subkategori berhasil di-_Approve_, proses verifikasi dapat dilanjutkan dan kategori maupun subkategori tersebut akan menjadi bagian resmi dari master kategori aplikasi.

### Tahap 1: Pengisian Table 1 (Rincian Item)

1. Tekan tombol **"Tambah Expense"** untuk memunculkan formulir **Table 1 (Rincian)**.
2. Isi semua kolom inputan yang tersedia (termasuk penamaan dan unggah file _evidence_ / bukti).
3. **Validasi Wajib:** Tidak boleh ada inputan yang kosong. Jika saat disimpan masih ada kolom yang kosong, sistem akan menampilkan peringatan dan meminta pengguna untuk melengkapinya.
4. Jika data sudah disimpan, pengguna bisa mengubahnya dengan menekan tombol **Edit** di kolom aksi.
5. Jika semua inputan sudah dipastikan benar dan aman, tekan tombol **Submit**. Status pengajuan akan langsung berubah dari _Draft_ menjadi _Submit_.

### Tahap 2: Verifikasi Table 1 & Alur Komentar Reject

1. Pada status _Submit_, verifikasi dilakukan pada bagian item detail. Gunakan ikon **Centang** untuk menyetujui (_Approve_) atau ikon **Silang** untuk menolak (_Reject_ / Revisi).
2. **Skenario Approve:** Jika dicentang, status item akan menjadi **Approved**.
3. **Skenario Reject & Revisi”: maka akan munucl komentar reject dan status berubah jadi revison**
4. **Logika Khusus Batch:** Seluruh item detail di dalam _batch_ wajib diverifikasi. Jika masih terdapat minimal satu item detail yang belum diverifikasi (_Approve_) atau berstatus **Revision** (_Reject_) di kolom aksi, maka status keseluruhan _batch_ tetap **Revision**. Status keseluruhan baru akan berubah menjadi **Approved** apabila seluruh item detail di dalam _batch_ telah berstatus **Approved**.

### Tahap 3: Pengisian & Verifikasi Table 2 (Pencairan Dana)

1. Setelah Table 1 berstatus keseluruhan _Approved_, **Table 2** akan muncul secara otomatis.
2. Table 2 akan menarik data secara otomatis:
   - **Deskripsi:** Mengambil data deskripsi (jika tipe _Single_) atau judul (jika tipe _Batch_) dari Table 1.
   - **Nominal (_Amount_):** Ditarik langsung dari data Table 1.
3. **Membuka Kunci Edit:** Jika status saat ini masih _Submit_ atau _Approved_, data tidak bisa diedit. Pengguna harus menekan tombol **"Move to Draft"** di bagian atas (_header_).
4. Setelah status kembali menjadi _Draft_, tekan tombol **Edit** untuk mengisi data di Table 2.
5. Pastikan semua inputan wajib diisi (sistem akan memberi peringatan jika kosong), kecuali kolom _Komentar Biasa_ yang bersifat opsional. Simpan data.
6. Tekan **Submit**, lalu lakukan verifikasi.
7. maka status langusng mau kke approved

### Tahap 4: Pengisian & Verifikasi Table 3 (Pengembalian Dana)

1. **Table 3** akan otomatis muncul setelah Table 2 yang berstatus _Approved_.
2. Table 3 menarik data secara otomatis:
   - **Deskripsi:** kalo single Mengambil data deskripsi table 2 dan batch akan ambil judul dokument expense.
   - **Sumber Dana:** Mengambil data dari Table 2.
3. Sama seperti sebelumnya, tekan tombol **"Move to Draft"** agar status kembali ke _Draft_ untuk bisa mengubah data.
4. Tekan tombol **Edit** di kolom aksi, lalu lengkapi data yang belum terisi (kolom komentar biasa tetap opsional). Simpan data.
5. Tekan **Submit**, lalu lakukan verifikasi.
6. **Catatan Revisi:** Sama seperti Table 1, jika terjadi _Reject_, selesaikan melalui alur **Komentar Reject** yang sama. Jika disetujui, status menjadi **Approved**.

### Tahap 5: Approval Final (Masuk ke Laporan)

1. Ketika Table 1 dan Table 2 sudah berstatus _Approved_, tombol **Approval Final** sebenarnya sudah muncul. Tombol ini adalah kunci utama untuk memasukkan data ke dalam Laporan Keuangan.
2. Sifat penekanan tombol ini **Opsional pada saat itu**: Bisa langsung ditekan setelah Table 2 selesai, atau menunggu sampai Table 3 selesai dikerjakan dan di-_approve_.
3. Jika seluruh _Settlement List_ (termasuk Table 3 jika ada) sudah berstatus _Approved_, pengguna tinggal menekan tombol **Approval Final** ini untuk menyelesaikan seluruh siklus.

## kasbon list

ini sudha sangat mirip kaya di settlement list ini 100 persen

## kategori management

Kumpulan kategori dan subkategori, di mana kategori dan subkategori yang sudah ada dapat diubah namanya (_Edit_) maupun dihapus (_Delete_). Jika suatu kategori dihapus, maka seluruh subkategori yang berada di dalam kategori tersebut akan otomatis ikut terhapus.

Pada halaman ini pengguna juga dapat menambahkan kategori baru melalui tombol **Tambah Kategori**. Sedangkan subkategori hanya dapat dibuat setelah pengguna memilih kategori yang diinginkan. Jika ingin membuat kategori dan subkategori baru, maka keduanya harus dibuat secara berurutan.

Kategori dan subkategori yang baru dibuat akan berstatus **Pending** dan masuk ke proses verifikasi. Verifikator dapat melakukan **Approve** (ikon centang) atau **Reject** (ikon silang).

Jika di-_Approve_, maka kategori atau subkategori yang sebelumnya berstatus **Pending** akan menjadi kategori atau subkategori resmi yang dapat digunakan di aplikasi. Jika di-_Reject_, maka data kategori atau subkategori tersebut akan dihapus dari database.

## Laporan Summary

Halaman ini berfungsi sebagai dashboard ringkasan eksekutif untuk melihat "kesehatan keuangan" secara sekilas tanpa harus pusing melihat detail satu per satu.

- **Fungsinya:** Untuk melihat total uang masuk dan keluar secara cepat. Kamu bisa langsung melihat kategori apa yang paling banyak menghabiskan biaya.
- **Fitur Utama:**
  - **Filter Waktu (Cascading):** Kamu cukup pilih rentang waktu (misal: bulan ini, tahun 2024, atau custom range), maka sistem akan menampilkan dan menjumlahkan semua datanya secara otomatis.
  - **Tombol Laporan Tahunan (Penting!):** Di halaman ini terdapat tombol khusus yang sangat penting untuk langsung mengakses halaman **Laporan Tahunan**.
  - **Visualisasi Data:** Terdapat chart/grafik untuk melihat persentase kategori biaya terbesar dan perbandingan uang masuk vs keluar.

## Laporan Tahunan

Halaman ini jauh lebih kompleks dan sangat lengkap, berfungsi untuk melihat laporan laba rugi (_Profit & Loss_), neraca keuangan, dan kepatuhan pajak perusahaan dalam skala satu tahun penuh.

- **Daftar Menu Input (Wajib Diisi):** Agar laporannya terbentuk sempurna, kamu harus input data manual dari tombol-tombol menu yang disediakan di halaman ini. Setiap menu input punya logikanya masing-masing:
  1. **Input Revenue:** Tempat kamu mencatat uang masuk / invoice dari klien.
     - _Logika Isian:_ Kamu wajib mengisi Nomor Invoice, Nama Klien, Nilai Tagihan (USD/IDR), Tanggal Terima Uang, serta nominal potongan pajak (kalau ada).
     - _Fitur Combine:_ Di sini ada fitur **Combine**. Jadi kalau ada 2 atau lebih data item revenue (misal dari klien yang sama atau proyek yang sama), kamu bisa centang data-datanya lalu tekan _combine_ agar di dalam tabel laporannya nanti tergabung jadi 1 baris saja biar jauh lebih rapi.
       **Syarat Penting:** Ada batasan (_restriction_) dalam melakukan combine. Jika baris 4 sampai 7 sudah digabungkan (_di-grup_), kamu tidak bisa lagi memilih baris 3 sampai 5 untuk digabungkan, karena baris 4 dan 5 sudah terkunci di dalam grup sebelumnya.
  2. **Input Pajak:** Untuk mencatat rincian potongan atau pembayaran pajak perusahaan.
     - _Logika Isian:_ Kamu harus memilih Jenis Pajak (PPN, PPh 21, PPh 23, dll), lalu masukkan Nomor Bukti Potong, Dasar Pengenaan Pajak (DPP), dan Nominal Pajaknya.
     - _Fitur Combine:_ Sama seperti revenue, di sini juga ada fitur **Combine** untuk menggabungkan beberapa baris item pajak sejenis menjadi 1 baris laporan.
       **Syarat Penting:** Logika batasannya juga sama; item pajak yang sudah masuk ke dalam satu grup _combine_ tidak bisa dipilih silang (overlapping) lagi untuk digabungkan dengan baris lain.
  3. **Input Bank Status:** Untuk mencatat transaksi bank yang tidak masuk di alur _settlement_ biasa (contoh: pendapatan bunga bank atau biaya admin bulanan).
     - _Logika Isian:_ Kamu harus membuat/memilih _Group Name_ (misal: "Bank Interest"), lalu isi deskripsi, tanggal, dan nominal transaksinya (USD/IDR).
  4. **Input Neraca Awal:** Sangat penting agar Tabel Neraca (_Balance Sheet_) bisa seimbang (_balance_).
     - _Logika Isian:_ Di sini kamu mensetting angka patokan awal seperti Kas Tahun Sebelumnya, total Piutang, Hutang Usaha, Modal Saham, dan Laba Ditahan. Sistem akan mengolah angka ini secara otomatis dengan Laba Tahun Berjalan di laporannya.
  5. **Input Dividend:** Untuk mencatat pembagian deviden secara proporsional.
     - _Logika Isian:_ Kamu memasukkan nama penerima dan **Persentase Kepemilikannya (%)**.
     - _Catatan:_ Sistem mengharuskan total persentase seluruh orang jika digabungkan harus pas **100%**. Sisa "Profit After Tax" yang dikurangi dengan "Profit Ditahan" (yang kamu atur secara manual), akan dibagikan sesuai dengan angka persen tersebut kepada setiap orang.
  6. **Input Aset:** Untuk mencatat daftar kekayaan atau inventaris fisik perusahaan.
     - _Logika Isian:_ Kamu harus memasukkan Kode Aset, Nama, Harga Beli, dan yang paling penting adalah **Umur Ekonomis (dalam bulan)**. Sistem akan otomatis menghitung nilai penyusutan bulanannya (_Depreciation_) dan Nilai Buku akhirnya.

- **Tiga Sheet (Halaman) Utama Laporan:**
  1. **Sheet 1 (Data Transaksi Detail):** Ini tempat berkumpulnya semua data transaksi mentah. Terdiri dari banyak tabel, seperti:
     - **Tabel Revenue (Pendapatan) & Tax (Pajak):** Data dari inputan manual kamu.
     - **Tabel Bank Status, Biaya Admin Bank, & Dana Kembalian (Returned Funds):** Untuk melacak arus kas bank yang lebih detail.
     - **Tabel Expenses (Biaya):** Kolom di tabel ini **otomatis dinamis**. Datanya langsung ditarik dari Settlement yang sudah kamu klik **"Approval Final"**. Kamu tidak perlu input manual lagi di sini.
     - **Tabel Asset Register:** Daftar aset dan nilai bukunya.
  2. **Sheet 2 (Profit Loss & Neraca):** Di sini data dari Sheet 1 dirangkum otomatis jadi format laporan akuntansi baku.
     - **Tabel Laba Rugi:** Menghitung Total Pendapatan dikurangi Total Biaya untuk mendapatkan Laba Bersih.
     - **Tabel Neraca (Balance Sheet):** Mencocokkan nilai Total Aktiva (harta) agar _balance_ dengan Total Hutang dan Modal.
  3. **Sheet 3 (Business Summary & Dividend):**
     - **Tabel Business Summary:** Menampilkan kesimpulan laba dan **Status Keamanan Pajak**. _Info Penting:_ Sistem memiliki 2 indikator peringatan otomatis terkait keamanan pajak:
       - 🔴 **BAHAYA (Restitusi/Audit):** Terjadi jika potongan PPh 23 dari klien **Lebih Besar** dari total kewajiban PPh Badan. Artinya perusahaan dalam posisi Lebih Bayar pajak, yang berisiko sangat tinggi memicu pemeriksaan (audit) menyeluruh oleh DJP jika meminta pengembalian dana (restitusi).
       - 🟢 **AMAN (Kurang Bayar):** Terjadi jika potongan PPh 23 dari klien **Lebih Kecil atau Sama Dengan** kewajiban PPh Badan. Ini adalah status yang paling ideal dan dianjurkan karena perusahaan cukup menyetorkan sisa kekurangannya di akhir tahun tanpa memicu audit, serta membantu menjaga _cash flow_ perusahaan tetap sehat.
     - **Tabel Deviden:** Daftar nama pemegang saham yang menerima uang tunai beserta nominalnya.

- **Fitur Khusus Tambahan:**
  - **Fitur Combine:** Jika kamu punya banyak data Revenue atau Tax dari klien yang sama, kamu bisa centang beberapa data lalu tekan tombol **Combine** agar laporannya jadi satu baris dan lebih rapi.
  - **Zoom & Scroll:** Kalau layarnya terasa sempit karena tabelnya banyak, kamu bisa atur persentase zoom (atau pakai `Ctrl + Scroll` mouse) biar tampilannya lebih luas.
  - **Export Data:** Semua kelengkapan laporan di atas bisa kamu _download_ langsung dalam bentuk **Excel**.
