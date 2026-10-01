### **Bank Management**

Halaman ini merupakan pusat kendali seluruh arus kas perusahaan yang dibagi menjadi dua sistem utama: **Bank Cash** (Uang fisik di rekening bank) dan **Bank Advance** (Uang virtual yang dipegang oleh staf/karyawan).

### **A. Bank Cash (Kas Riil)**

Digunakan untuk mengelola daftar rekening bank resmi perusahaan (seperti BCA, Mandiri, BRI) serta kas tunai fisik.

- **Kelola Rekening:** Kamu bisa menambah rekening baru, mengatur mata uang (IDR/USD), dan mengisi **Saldo Awal**. Saldo awal ini sangat krusial karena menjadi titik nol perhitungan neraca keuangan.
- **Log Book / Riwayat Transaksi:** Setiap bank memiliki buku log otomatis. Segala transaksi dari *Settlement*, *Revenue*, atau *Bank Status* yang menyentuh rekening tersebut akan tercatat rapi di sini, lengkap dengan saldo sebelum dan sesudah transaksi (*Before-After balance*).
- **Real-Time Balance:** Sistem menampilkan saldo aktual yang ada di bank secara instan berdasarkan seluruh aktivitas yang sudah disetujui.

### **B. Bank Advance (Kas Virtual / Karyawan)**

Fitur unik untuk melacak dana perusahaan yang sedang dibawa oleh karyawan (staf/mitra) melalui alur Kasbon.

- **Saldo Virtual Karyawan:** Menampilkan daftar karyawan beserta total dana yang mereka pegang saat ini.
- **Sistem Monitoring Hutang:** Secara otomatis melacak berapa dana yang belum dipertanggungjawabkan (*Outstanding*) dan berapa dana yang sudah selesai dilaporkan melalui settlement.
- **Penyesuaian Saldo (Inisialisasi):** Manager dapat melakukan penyesuaian saldo virtual secara manual jika terjadi selisih atau pemberian dana awal, lengkap dengan pemilihan sumber bank cash-nya.
- **Audit Trail:** Memiliki riwayat aktivitas detail untuk setiap karyawan, mencatat kapan mereka menerima dana (Kasbon), kapan mengembalikan dana (Return), atau kapan saldo didebet untuk belanja (Settlement).

Settlement List (Daftar Pengajuan Biaya)**

Halaman utama untuk memantau dan mengelola seluruh dokumen pengeluaran (*expense*) yang sedang berjalan maupun yang sudah selesai.

- **Pencarian & Navigasi:** Dilengkapi dengan *sidebar* untuk akses menu cepat dan *search bar* yang memungkinkan kamu mencari dokumen pengeluaran berdasarkan judul atau kata kunci tertentu secara instan.
- **Pembuatan Dokumen (Single vs Batch):** Saat membuat pengajuan baru, sistem memberikan dua pilihan metode:
    - **Single:** Digunakan untuk pengajuan tunggal yang ringkas (kamu bisa langsung masuk ke tahap pengisian rincian biaya).
    - **Batch:** Digunakan untuk pengajuan berkelompok dalam jumlah banyak. Pada metode ini, kamu wajib mengisi **Judul Pengajuan** dan **Tanggal Pembuatan** sebagai identitas utama grup dokumen tersebut.
- **Tampilan Kartu (Unified Cards):** Seluruh dokumen ditampilkan dalam bentuk kartu interaktif. Uniknya, kartu **Settlement** dan kartu **Kasbon** ditampilkan bersamaan dalam satu daftar (saling bertumpuk secara kronologis). Hal ini dirancang agar kamu bisa melihat hubungan antara uang muka (Kasbon) dan pertanggungjawabannya (Settlement) di satu layar yang sama.
- **Manajemen Data (Selection Mode):** Terdapat fitur seleksi yang fleksibel. Kamu bisa memilih satu kartu atau memilih banyak kartu sekaligus (*multiple select*) untuk melakukan penghapusan data secara masal dengan cepat.

kasbon list
disini pada dasarnya 100 persen mirip kaya settlment list

settlment detail

Berikut adalah perbaikan dan penyusunan ulang teks Anda agar jauh lebih rapi, terstruktur, dan telah memasukkan **alur *Komentar Reject* (Revisi)** secara lengkap sesuai dengan logika sistem yang Anda deskripsikan:

# Alur Pembuatan Detail Settlement (Expense) & Sistem Revisi

Bagian ini merupakan langkah lanjutan setelah pembuatan *Settlement Expense*, di mana pengguna harus menambahkan detail item pengeluaran. Terdapat dua ketentuan dasar:

- **Tipe Single:** Hanya bisa mengisi 1 detail item pengeluaran.
- **Tipe Batch:** Bisa membuat lebih dari 1 detail item pengeluaran.

### logika redudant yang harus di baca

Aturan Hierarki & Visibilitas Tabel (*Table Hiding Logic*)

Sistem ini menggunakan logika hierarki berurutan yang sangat ketat. Tabel di bawahnya sangat bergantung pada status persetujuan (*Approved*) tabel di atasnya.

1. **Jika dalam keadaan sudah mengisi sampai ke table 3 dan Mengedit Table 1:** Apabila pengguna menekan tombol edit pada Table 1, maka secara otomatis **Table 2 dan Table 3 akan disembunyikan (*hide*)**.
    - Table 2 baru akan muncul kembali jika Table 1 sudah di approved item detailnya
    - Table 3 baru akan menyusul muncul setelah Table 2 juga selesai di-*approve*.
2. **Jika Mengedit Table 2:** Apabila pengguna menekan tombol edit pada Table 2, maka secara otomatis **Table 3 akan disembunyikan (*hide*)**.
    - Table 3 baru akan muncul kembali setelah Table 2 tuntas dan berstatus *Approved*.

### Aturan Revisi & Komentar Reject

Mekanisme revisi pada seluruh tabel (Table 1, Table 2, dan Table 3) menggunakan alur yang sama.

1. Jika verifikator menekan ikon **Silang (Reject)**, maka status data akan berubah menjadi **Revision**.
2. Sistem akan menampilkan form **Komentar Reject**.
3. Verifikator dapat menambahkan satu atau lebih komentar revisi dan menyimpannya.
4. Untuk melakukan perbaikan, pengguna harus mengubah status kembali ke **Draft** melalui tombol **Move to Draft**.
5. Setelah status menjadi **Draft**, pengguna dapat memperbaiki data sesuai komentar yang diberikan.
6. Pengguna wajib mencentang setiap komentar reject yang telah diselesaikan.
7. Data hanya dapat di-*Submit* kembali apabila seluruh komentar reject telah ditandai selesai.
8. Setelah di-*Submit* ulang, data akan masuk kembali ke proses verifikasi hingga memperoleh status **Approved**.

fungsi tambahan 
Fungsi nambah kategori baru dan sub kategori baru

Pembuatan kategori dan subkategori dilakukan melalui menu **Tambah** atau **Edit** pada Table 1. kategori bisa di buat langsung di button tambah kategori dan khusus Subkategori hanya dapat dibuat setelah memilih kategori. Jika ingin membuat kategori dan subkategori baru, maka keduanya harus dibuat terlebih dahulu  di dibikin secara secara gantian.

Kategori dan subkategori yang baru dibuat akan berstatus **Pending**, tetapi tetap tersimpan di database dan dapat digunakan untuk mengisi item detail serta tetap dapat di-*Submit*.

Saat manager melakukan verifikasi, item detail yang menggunakan kategori atau subkategori berstatus **Pending** tidak dapat di-*Approve* saat di apprvoed munucl pop up yang akna mengarah ke management kategori. Kategori dan subkategori tersebut harus terlebih dahulu di-*Approve* melalui halaman **Management Kategori**.

Setelah kategori dan subkategori berhasil di-*Approve*, proses verifikasi dapat dilanjutkan dan kategori maupun subkategori tersebut akan menjadi bagian resmi dari master kategori aplikasi.

### Tahap 1: Pengisian Table 1 (Rincian Item)

1. Tekan tombol **"Tambah Expense"** untuk memunculkan formulir **Table 1 (Rincian)**.
2. Isi semua kolom inputan yang tersedia (termasuk penamaan dan unggah file *evidence* / bukti).
3. **Validasi Wajib:** Tidak boleh ada inputan yang kosong. Jika saat disimpan masih ada kolom yang kosong, sistem akan menampilkan peringatan dan meminta pengguna untuk melengkapinya.
4. Jika data sudah disimpan, pengguna bisa mengubahnya dengan menekan tombol **Edit** di kolom aksi.
5. Jika semua inputan sudah dipastikan benar dan aman, tekan tombol **Submit**. Status pengajuan akan langsung berubah dari *Draft* menjadi *Submit*.

### Tahap 2: Verifikasi Table 1 & Alur Komentar Reject

1. Pada status *Submit*, verifikasi dilakukan pada bagian item detail. Gunakan ikon **Centang** untuk menyetujui (*Approve*) atau ikon **Silang** untuk menolak (*Reject* / Revisi).
2. **Skenario Approve:** Jika dicentang, status item akan menjadi **Approved**.
3. **Skenario Reject & Revisi”: maka akan munucl komentar reject dan status berubah jadi revison**
4. **Logika Khusus Batch:** Seluruh item detail di dalam *batch* wajib diverifikasi. Jika masih terdapat minimal satu item detail yang belum diverifikasi (*Approve*) atau berstatus **Revision** (*Reject*) di kolom aksi, maka status keseluruhan *batch* tetap **Revision**. Status keseluruhan baru akan berubah menjadi **Approved** apabila seluruh item detail di dalam *batch* telah berstatus **Approved**.

### Tahap 3: Pengisian & Verifikasi Table 2 (Pencairan Dana)

1. Setelah Table 1 berstatus keseluruhan *Approved*, **Table 2** akan muncul secara otomatis.
2. Table 2 akan menarik data secara otomatis:
    - **Deskripsi:** Mengambil data deskripsi (jika tipe *Single*) atau judul (jika tipe *Batch*) dari Table 1.
    - **Nominal (*Amount*):** Ditarik langsung dari data Table 1.
3. **Membuka Kunci Edit:** Jika status saat ini masih *Submit* atau *Approved*, data tidak bisa diedit. Pengguna harus menekan tombol **"Move to Draft"** di bagian atas (*header*).
4. Setelah status kembali menjadi *Draft*, tekan tombol **Edit** untuk mengisi data di Table 2.
5. Pastikan semua inputan wajib diisi (sistem akan memberi peringatan jika kosong), kecuali kolom *Komentar Biasa* yang bersifat opsional. Simpan data.
6. Tekan **Submit**, lalu lakukan verifikasi.
7. maka status langusng mau kke approved

### Tahap 4: Pengisian & Verifikasi Table 3 (Pengembalian Dana)

1. **Table 3** akan otomatis muncul setelah Table 2 yang berstatus *Approved*.
2. Table 3 menarik data secara otomatis:
    - **Deskripsi:** kalo single Mengambil data deskripsi table 2 dan batch akan ambil judul dokument expense.
    - **Sumber Dana:** Mengambil data dari Table 2.
3. Sama seperti sebelumnya, tekan tombol **"Move to Draft"** agar status kembali ke *Draft* untuk bisa mengubah data.
4. Tekan tombol **Edit** di kolom aksi, lalu lengkapi data yang belum terisi (kolom komentar biasa tetap opsional). Simpan data.
5. Tekan **Submit**, lalu lakukan verifikasi.
6. **Catatan Revisi:** Sama seperti Table 1, jika terjadi *Reject*, selesaikan melalui alur **Komentar Reject** yang sama. Jika disetujui, status menjadi **Approved**.

### Tahap 5: Approval Final (Masuk ke Laporan)

1. Ketika Table 1 dan Table 2 sudah berstatus *Approved*, tombol **Approval Final** sebenarnya sudah muncul. Tombol ini adalah kunci utama untuk memasukkan data ke dalam Laporan Keuangan.
2. Sifat penekanan tombol ini **Opsional pada saat itu**: Bisa langsung ditekan setelah Table 2 selesai, atau menunggu sampai Table 3 selesai dikerjakan dan di-*approve*.
3. Jika seluruh *Settlement List* (termasuk Table 3 jika ada) sudah berstatus *Approved*, pengguna tinggal menekan tombol **Approval Final** ini untuk menyelesaikan seluruh siklus.

## kasbon list

ini sudha sangat mirip kaya di settlement list ini 100 persen
