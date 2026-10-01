# Aplikasi EwiApps

Disini ada aplikais terdiri dari

1. login
2. register
3. settlement list
4. kasbon list
5. settlement detail
6. Kasbon detail
7. kategori management
8. laporan
9. setting

---

## bagian detail nya

### 1. login
**File:** `frontend/lib/screens/auth/login_screen.dart`

**Tujuan Utama**
Halaman Login berfungsi sebagai gerbang utama autentikasi pengguna untuk mengakses ekosistem EwiApps. Fitur ini dirancang untuk memastikan keamanan akses melalui verifikasi identitas pengguna, baik menggunakan kredensial internal maupun penyedia pihak ketiga (Google).

**Komponen UI & Fitur Utama**
*   **Formulir Kredensial:** Input untuk *Username* dan *Password*. Field password dilengkapi fitur *visibility toggle* (ikon mata) untuk melihat/menyembunyikan karakter.
*   **Remember Me:** Opsi untuk menyimpan data login secara lokal menggunakan `SharedPreferences`, memudahkan pengguna masuk kembali tanpa mengetik ulang.
*   **Integrasi Google Login:** Mendukung autentikasi satu klik menggunakan akun Google. Jika email Google belum terdaftar, sistem secara cerdas akan mengarahkan pengguna ke halaman registrasi dengan data yang sudah terisi otomatis.
*   **Pengaturan Server URL:** Terdapat dialog tersembunyi/khusus untuk mengubah alamat IP server (API Base URL), memberikan fleksibilitas saat server berpindah alamat atau dalam mode pengembangan.
*   **Lupa Password (OTP):** Alur reset password yang lengkap, mulai dari pengiriman kode OTP ke email hingga pembuatan password baru di dalam aplikasi.

**Logika Kodingan (State & Controller)**
*   **Manajemen State:** Menggunakan pola **Provider** (`AuthProvider`) untuk memisahkan logika bisnis (pemanggilan API) dari tampilan UI.
*   **Controller & Lifecycle:** Menggunakan `TextEditingController` untuk menangkap input dan `AnimationController` untuk memberikan efek visual *fade-in* saat halaman dimuat.
*   **Validasi Input:** Dilakukan secara *real-time* sebelum data dikirim ke server (misal: pengecekan field kosong atau panjang password minimal 6 karakter).

**Error Handling & Feedback**
*   **Deteksi Koneksi:** Sistem mampu mendeteksi apakah kegagalan login disebabkan oleh salah password atau masalah jaringan (seperti *timeout* atau IP server salah), serta memberikan saran perbaikan yang relevan kepada pengguna melalui *SnackBar*.
*   **Status Loading:** Menampilkan indikator loading visual untuk mencegah pengguna menekan tombol berkalikali saat proses autentikasi sedang berlangsung.

---

### 2. register
**File:** `frontend/lib/screens/auth/register_screen.dart`

**Tujuan Utama**
Halaman Register memungkinkan pengguna baru untuk membuat akun di sistem EwiApps secara mandiri. Halaman ini dirancang untuk mengumpulkan data identitas dan informasi profesional pengguna agar sistem dapat memberikan hak akses dan klasifikasi data yang tepat.

**Komponen UI & Fitur Utama**
*   **Formulir Identitas Lengkap:** Menyediakan input mendetail mulai dari *Username*, Nama Lengkap, Email, Nomor HP (dengan validasi hanya angka), hingga Tempat Kerja.
*   **Pemilihan Role & Perusahaan:** Dilengkapi dengan menu *dropdown* untuk memilih peran pengguna (Staff atau Mitra) serta daftar perusahaan yang terintegrasi (contoh: EWI Foundation).
*   **Keamanan Input Password:** Menggunakan sistem verifikasi ganda (Password dan Konfirmasi Password) dengan fitur *toggle* visibilitas untuk meminimalisir kesalahan pengetikan.
*   **Layout Responsif:** Mendukung tampilan *Portrait* dan *Landscape*, memastikan formulir tetap mudah diisi baik di perangkat *mobile* maupun *tablet/web*.
*   **Pre-fill Data Google:** Jika pengguna datang dari alur Google Login, field Email dan Nama akan terisi otomatis, dan field email akan dikunci (*read-only*) untuk menjaga validitas akun pihak ketiga.

**Logika Kodingan (State & Controller)**
*   **Pengelolaan Input:** Menggunakan `TextEditingController` untuk setiap field guna menangkap data secara *real-time*.
*   **Validasi Berlapis:** Melakukan pengecekan ketat sebelum data dikirim ke API, termasuk validasi format email, kecocokan kedua password, dan panjang karakter minimal.
*   **Navigasi Otomatis:** Setelah proses registrasi berhasil melalui `AuthProvider`, sistem akan menampilkan dialog sukses dengan ikon *check-circle* dan mengarahkan pengguna kembali ke halaman Login.

**Error Handling & Feedback**
*   **Pesan Validasi Instan:** Menggunakan *SnackBar* untuk memberikan peringatan langsung jika ada field yang kosong atau tidak memenuhi syarat (misal: "Password minimal 6 karakter").
*   **Indikator Proses:** Tombol "Daftar" akan berubah menjadi status *loading* dan dinonaktifkan selama proses pengiriman data ke server untuk menghindari klik ganda.

---

### 3 & 4. Unified Transaction List (Settlement & Kasbon List)
**File:** `frontend/lib/screens/main_layout_widgets.dart` & `frontend/lib/screens/advance/advances_screen.dart`

**Tujuan Utama**
Kedua fitur ini secara teknis adalah satu kesatuan sistem pemantauan transaksi. Developer menggunakan logika dan komponen UI yang sama (Shared Widget) agar pengguna dapat melihat seluruh siklus dana—mulai dari uang muka hingga laporan akhir—dalam satu alur yang konsisten dan familiar.

**Komponen UI & Fitur Utama (Sama untuk Keduanya)**
*   **Satu Tampilan (Unified View):** Menggunakan widget kartu transaksi yang identik. Perbedaan utamanya hanya pada label data apakah itu Kasbon atau Settlement.
*   **Fitur "GABUNG/PISAHKAN":** Tombol interaktif untuk menyatukan daftar Kasbon dan Settlement dalam satu urutan kronologis atau memisahkannya kembali untuk fokus pada salah satu jenis transaksi.
*   **Sistem Filter & Pencarian:** Keduanya berbagi fitur filter tahun (Cascading Year), rentang tanggal kustom, status persetujuan, dan kolom pencarian dengan fitur *debounce*.
*   **Summary Cards:** Kartu ringkasan di bagian atas yang menghitung total pengeluaran tahunan secara otomatis dalam format Rupiah.

**Perbedaan Fitur Kasbon dibandingkan Settlement**
*   **Dialog Pembuatan:** Kasbon memiliki dialog khusus untuk input estimasi dana awal (Single/Batch), sementara Settlement lebih diarahkan untuk pelaporan nota dan bukti belanja.
*   **Sinkronisasi Otomatis:** Di balik layar, setiap kali daftar Kasbon diperbarui, sistem secara otomatis memicu pembaruan data Settlement terkait agar saldo akhir yang ditampilkan tetap akurat.
*   **Aksi Cepat:** Terdapat fitur *Scroll-to-Top otomatis* di bagian Kasbon untuk memudahkan navigasi saat daftar transaksi sudah sangat panjang.

**Logika Kodingan (State & Controller)**
*   **Unified Provider:** Menggunakan sinkronisasi antara `SettlementProvider` dan `AdvanceProvider`.
*   **Export Engine:** Keduanya mendukung ekspor data ke format **Excel** dan **PDF** (khusus untuk akses Manager).

---

### 5 & 6. Unified Transaction Detail (Settlement & Kasbon Detail)
**File:** `frontend/lib/screens/settlement/settlement_detail_screen.dart` & `frontend/lib/screens/advance/advance_detail_screen.dart`

**Tujuan Utama**
Halaman Detail Kasbon dan Settlement dibangun di atas pondasi arsitektur yang sama (Shared Architecture). Tujuannya adalah untuk mendisiplinkan alur keuangan perusahaan dengan memastikan tidak ada selisih sekecil apapun antara dana yang diminta (Kasbon), dana yang dibelanjakan (Settlement), dan sisa dana yang dikembalikan. Hal ini dicapai melalui sistem **3 Tabel Utama** yang saling mengunci (*Gating System*).

**Struktur 3 Tabel Utama (Deep Dive)**

1.  **Tabel 1: Rincian Item (Expenses)**
    Tabel ini adalah jantung pencatatan operasional.
    *   **Input Multi-Layer:** Saat pengguna menekan "Tambah Item", muncul dialog komprehensif. Pengguna harus memilih *Kategori Utama* (Dropdown), kemudian dapat mencentang lebih dari satu *Sub-Kategori* (Checkbox) untuk satu item.
    *   **Sistem Mata Uang Fleksibel:** Mendukung berbagai mata uang (IDR, USD, EUR, SGD, dll). Jika memilih USD, form kurs (exchange rate) otomatis muncul untuk mengkonversi nilai ke IDR secara *real-time*.
    *   **Toggle Nilai (+/-):** Terdapat tombol interaktif untuk mengubah nominal menjadi minus (kredit/diskon) atau plus (debit/beban).
    *   **Evidence Manager:** Dilengkapi `FilePicker` yang mendukung unggah banyak file sekaligus (PDF, JPG, PNG) sebagai bukti nota/invoice.

2.  **Tabel 2: Pencairan Dana (Disbursement)**
    Tabel ini melacak aliran dana aktual dari kas perusahaan ke tangan pengaju.
    *   **Perhitungan Otomatis:** Nominal "Target Disbursed" otomatis mengambil angka dari Total Approved di Tabel 1.
    *   **Pemisahan Biaya Bank:** Menyediakan field khusus untuk mencatat `Admin Fee` (Biaya Transfer Bank). Ini sangat krusial agar biaya transfer tidak dianggap sebagai biaya operasional/belanja, sehingga laporan laba rugi (*Profit/Loss*) tetap akurat.
    *   **Validasi Bukti Transfer:** Manager diwajibkan mengunggah bukti transfer sebelum tabel ini bisa disetujui (*Approve*).

3.  **Tabel 3: Pengembalian Dana (Return)**
    Sistem "Detektor Selisih" otomatis.
    *   **Trigger Otomatis:** Tabel ini hanya muncul jika `Total Dana Dicairkan (Tabel 2) > Total Belanja Disetujui (Tabel 1)`.
    *   **Pemilihan Sumber Bank:** Pengguna harus memilih ke rekening bank perusahaan mana sisa dana tersebut ditransfer balik, lengkap beserta unggahan struk transfernya.

**Logika Kodingan & Keamanan Data**
*   **Dual-Axis Scrolling:** Karena jumlah kolom di Tabel 1 sangat banyak, developer menggunakan `AppScrollbar` vertikal dan horizontal secara bersamaan agar tabel tetap bisa digeser dengan rapi di layar kecil maupun besar.
*   **Strict Gating System (Penguncian Alur):**
    *   Tabel 2 tidak bisa disetujui (Disabled) jika masih ada item di Tabel 1 yang berstatus *Pending* atau *Rejected* (tanpa perbaikan). Syarat utamanya: `allApproved = true`.
    *   Tabel 3 (jika ada kembalian) terkunci total dan tidak bisa diisi sebelum Manager menyetujui Tabel 2. Hal ini mencegah pengajuan pengembalian fiktif.
*   **Sistem Komentar (Reject Notes):** Jika Manager menolak sebuah item atau tabel, mereka wajib mengisi alasan di pop-up komentar. Sistem menggunakan `jsonDecode/jsonEncode` untuk menyimpan log komentar ini secara terstruktur.
*   **Perlindungan Draft:** Terdapat mekanisme `cleanupEmptyDraft()`. Jika pengguna membuat pengajuan baru tapi keluar aplikasi sebelum mengisi item pertama, sistem akan menghapus draf kosong tersebut dari database agar tidak menjadi data sampah (junk data).

**Perbedaan Spesifik Kasbon vs Settlement Detail**
*   **Kasbon Detail:** Digunakan *sebelum* eksekusi. Tabel 1 di sini murni berisi "Rencana Anggaran Biaya (RAB)".
*   **Settlement Detail:** Digunakan *setelah* eksekusi. Tabel 1 di sini adalah "Realisasi". Sistem otomatis akan menyandingkan total Settlement dengan total Kasbon yang sudah diambil sebelumnya.

---

### 7. kategori management
**Tujuan Utama**
Halaman ini digunakan untuk mengelola hirarki kategori biaya yang digunakan di seluruh aplikasi. Fitur ini memastikan pengelompokan biaya dilakukan secara terstandarisasi untuk kebutuhan audit dan laporan tahunan.

**Komponen UI & Fitur Utama**
*   **Sistem Hirarki (Induk & Anak):** Menampilkan kategori dalam bentuk *ExpansionTile* yang bisa dibuka-tutup. Satu Kategori Utama dapat memiliki banyak Sub-Kategori.
*   **Moderasi Kategori (Approval System):** Terdapat area khusus "Kategori Pending". Jika Staff menambahkan kategori baru saat mengisi settlement, kategori tersebut harus disetujui (*Approve*) oleh Manager di halaman ini sebelum menjadi kategori resmi.
*   **Smart Validation:** Sub-kategori tidak dapat disetujui jika Kategori Induknya sendiri masih berstatus *Pending*.
*   **Akses Kategori Tabular:** Terdapat tombol navigasi cepat untuk mengakses fitur **Kategori Tabular** yang menyajikan data dalam format berbeda.

**Logika Kodingan (State & Controller)**
*   **CRUD Operation:** Mendukung operasi Tambah, Edit, dan Hapus kategori secara *real-time* yang terhubung langsung ke `SettlementProvider`.
*   **Live Search & Filter:** Memisahkan tampilan antara kategori yang sudah disetujui (*Approved*) dan yang masih menunggu antrian (*Pending*) untuk memudahkan kerja Manager.
Pusat kendali klasifikasi biaya yang menggunakan sistem **Moderasi Bertingkat**. Memastikan setiap kategori biaya yang dibuat oleh Staff telah divalidasi oleh Manager sebelum dapat digunakan dalam pelaporan keuangan resmi.

**Komponen UI & Detail Fitur**
*   **Manajemen Area Pending (Moderasi):** 
    *   Menampilkan antrian kategori baru dengan visualisasi khusus (latar belakang kuning transparan).
    *   **Orphan Pending Logic:** Secara cerdas mengelompokkan sub-kategori yang induknya sudah disetujui, sehingga Manager tahu konteks posisi kategori tersebut.
    *   **Hierarchical Locking:** Tombol *Approve* pada sub-kategori akan otomatis terkunci (*disabled*) jika Kategori Induknya masih dalam status *Pending*.
*   **Expansion Tree View:** Menampilkan seluruh kategori yang telah disetujui dalam bentuk pohon (*tree*) yang dapat dibuka-tutup untuk menghemat ruang layar.
*   **Interactive CRUD Dialogs:**
    *   Mendukung pembuatan Kategori Utama atau Sub-Kategori via *Radio Button*.
    *   Dialog Edit yang terintegrasi dengan sinkronisasi database instan.

**Logika Kodingan Lanjutan**
*   **Status Tracking:** Menggunakan filter status berbasis teks (Approved/Pending/Rejected) untuk memilah tampilan di UI.
*   **Snack-bar Feedback:** Memberikan notifikasi instan setelah aksi Approve/Reject dilakukan guna memberikan kepastian status pada pengguna.

---

### 8. laporan

#### **a. laporan (Laporan Summary)**
**File:** `frontend/lib/screens/reports/report_screen.dart`

**Tujuan Utama**
Menyajikan ringkasan pengeluaran perusahaan secara agregat yang dikelompokkan berdasarkan kategori biaya dan periode bulan dalam satu tahun untuk melihat tren pengeluaran bulanan secara cepat.

**Komponen UI & Detail Fitur**
*   **Tabel Summary Matrix:** Baris berisi Kategori/Sub-Kategori dengan indentasi visual, dan kolom berisi Bulan (Jan-Des).
*   **Hierarchical View:** Menampilkan data secara berjenjang; baris kategori utama ditampilkan lebih tebal (*bold*) untuk membedakannya dengan sub-kategori.
*   **Cascading Periode Filter:** Memungkinkan sinkronisasi tahun laporan ke modul lain (Revenue, Tax, dll) secara otomatis melalui `CascadeProvider`.
*   **Cache Indicator:** Memberikan informasi transparansi sumber data (apakah data diambil dari *Cache* aplikasi atau *Refresh* terbaru dari database).
*   **Dual Format Export:** Mendukung ekspor laporan ke dalam format **PDF** (layout siap cetak) dan **Excel** (data mentah untuk pengolahan lanjut).

**Logika Kodingan Lanjutan**
*   **Dual-Axis Scroll Synchronization:** Sinkronisasi antara `ScrollController` vertikal dan horizontal agar judul kolom (Bulan) dan judul baris (Kategori) tetap terlihat saat tabel digeser (*Sticky Effect*).
*   **Performance Optimization:** Menggunakan `RepaintBoundary` dan `ListView.builder` dengan `cacheExtent` tinggi untuk menjaga kelancaran tampilan meskipun kategori biaya berjumlah banyak.

#### **b. laporan (Laporan Tahunan)**
**File:** `frontend/lib/screens/reports/annual_report/annual_report_screen.dart` & `annual_report_tables.dart`

**Tujuan Utama**
Modul analisis finansial terdalam yang menyusun laporan keuangan komprehensif (Audit-Ready) dalam format **Multi-Sheet** (Sheet 1-3). Halaman ini juga bertindak sebagai pintu masuk untuk mengelola data mentah perusahaan melalui *Menu Input Mandiri*.

**Sistem Input Data Manajemen (Detail Operasional Form)**
Berbeda dengan laporan biasa, Laporan Tahunan menyediakan menu Input khusus dengan logika form yang sangat detail:

1.  **Input Pemasukan (Revenue Management):**
    *   **Pilihan Mata Uang Dinamis (IDR/USD):** Saat pengguna memilih input USD, field IDR akan terkunci, begitu pula sebaliknya.
    *   **Kalkulasi Pajak Otomatis (Live Math):** Saat field "Invoice Value" diisi angka, sistem akan secara instan *(real-time)* menghitung dan mengisi field **PPn (11%)** dan **PPh 23 (2%)** tanpa perlu dihitung manual. Field ini di-set *ReadOnly*.
    *   **Pilihan Jenis Pendapatan:** Tersedia *dropdown* untuk memisahkan "Pendapatan Langsung" dan "Pendapatan Lain-lain".
    *   **Kelengkapan Field:** Mencakup Tahun Laporan, Invoice Date, Detail/Description, Currency, Rate (Exchange), Invoice Number, Client, Receive Date, Amount Received (IDR/USD), Transfer Fee, dan Remark.
    *   **Fitur Manager Gabungan Baris:** Bisa memilih beberapa baris pemasukan sekaligus untuk dikelompokkan (*Combine Manual*) asalkan memiliki *Receive Date* yang sama persis.

2.  **Input Pajak (Tax Management):**
    *   **Auto-Fill Base Logic:** Saat field "Transaction Value" diketik, nominal tersebut akan secara otomatis diduplikasikan (*auto-fill*) ke field nilai dasar lainnya: **PPN Base, PPh 21 Base, PPh 23 Base, PPh 26 Base**, dan **Pemasukan Negara Base**.
    *   **Live IDR Calculation Card:** Jika transaksi menggunakan mata uang asing, terdapat kotak khusus (*StatefulBuilder*) yang langsung menampilkan hasil konversi ke Rupiah secara instan berdasarkan nilai tukar (*Rate*) yang diketik.

3.  **Input Bank Status:**
    *   **3 Mode Transaksi (Dynamic Dropdown):** Menyediakan opsi *Income* (Masuk), *Expense* (Keluar), dan *Transfer* (Pemindahbukuan).
    *   **Auto-Naming Group:** Saat pengguna memilih mode "Transfer", sistem memaksa user memilih "Bank Asal" dan "Bank Tujuan". Sistem kemudian akan membuat nama grup transaksi secara otomatis, contohnya: *"Pemindahbukuan dari BCA ke Mandiri"*.
    *   **Field Nominal Ganda:** Menyediakan kolom input angka terpisah untuk Nominal IDR dan Nominal USD dalam satu kali simpan.

4.  **Input Aset Baru (Asset Management):**
    *   Fokus pada *Asset Register*. Memiliki field detail seperti *Asset Code / SKU*, Nama Aset, Tanggal Pembelian, Jenis Aset, Harga Barang, Nilai Sisa, Status Aktif, serta Keterangan/Lokasi/PIC.

5.  **Input Dividen:**
    *   Mencatat pembagian laba tahunan dengan field: Nama Penerima, Profil Profit (Laba Ditahan), dan total Dividen Dibagi.

6.  **Pengaturan Laba Rugi/Neraca (Balance Sheet Settings):**
    *   Modul untuk melakukan pemetaan ulang (*re-mapping*) akun atau kategori biaya agar nilai tersebut masuk ke blok yang tepat pada tampilan Laba Rugi dan Neraca.

**Komponen UI & Fitur Utama (Multi-Sheet)**
*   **Sheet 1: Operasional (Tabel 1 - 6):** Pemasukan, Pajak, Bank Status, Biaya Admin Bank, Pengeluaran, dan *Asset Register*.
*   **Sheet 2: Keuangan (Tabel 7 - 8):** Laporan Laba Rugi (*Profit/Loss*) dan Neraca Keuangan (*Balance Sheet*).
*   **Sheet 3: Analisis (Tabel 9 - 10):** *Business Summary* dan detail pembagian Dividen.

**Fitur Tekunggulan**
*   **Dual-Axis Table Engine:** Tabel dirancang untuk geseran vertikal/horizontal yang mulus tanpa kehilangan orientasi baris.
*   **Zoom & Scaling System:** Pengaturan tingkat perbesaran laporan secara dinamis agar data tetap nyaman dibaca.
*   **Tax Safety Gating:** Fitur interaktif untuk memilih pengurang pajak (*Tax Offset*) yang langsung mengubah kalkulasi laba bersih secara otomatis.
*   **Horizontal Sync:** Logika khusus yang memastikan jika satu tabel digeser ke samping, tabel lain di bawahnya ikut bergeser secara sinkron (sejajar).

**Logika Kodingan Lanjutan**
*   **Table Data Cache:** Menyimpan hasil pemrosesan tabel yang berat untuk menghindari kalkulasi ulang saat perpindahan tab atau zoom.
*   **Combine Grouping:** Mengelompokkan baris transaksi terkait (seperti item settlement dalam satu transfer bank) agar visualisasinya tetap menyatu dan mudah diaudit.

---

### 9. setting
**File:** `frontend/lib/screens/settings/settings_screen.dart`

**Tujuan Utama**
Halaman Setting adalah pusat konfigurasi aplikasi yang melayani dua peran berbeda: sebagai pengelola identitas pribadi bagi seluruh pengguna, dan sebagai pusat kendali infrastruktur (Database, Storage, & Deadline) khusus bagi pengguna dengan akses **Manager**.


1.  **Profil Pengguna (Profile Management)**
    *   **Kartu Identitas Visual:** Menampilkan foto profil, Nama Lengkap, dan Username. Jika foto belum diunggah, sistem secara otomatis menampilkan inisial nama dengan latar belakang warna tema.
    *   **Edit Profil:** Dialog khusus untuk memperbarui Nama Lengkap, Nomor HP, dan Tempat Kerja secara instan yang langsung disinkronkan ke database server.
    *   **Google Account Linkage:** Fitur keamanan untuk menghubungkan atau memutuskan akun Google. Dilengkapi indikator status visual (Hijau untuk terhubung, Merah untuk belum terhubung).
    *   **Display Role & Info:** Menampilkan detail hak akses (Staff/Mitra/Manager) dan informasi profesional lainnya secara statis di bawah kartu profil.

2.  **Tema Aplikasi (Theme Switcher)**
    *   **3 Mode Tampilan:** Memungkinkan pengguna beralih antara mode **Light** (Terang), **Dark** (Gelap), atau mengikuti pengaturan **System** perangkat.
    *   **State Persistence:** Pilihan tema disimpan secara lokal, sehingga tampilan tetap konsisten setiap kali aplikasi dibuka kembali.

3.  **Master Tahun Laporan (Default Report Year)**
    *   **Fungsi Pemicu Sinkronisasi:** Menentukan tahun fiskal default aplikasi yang tersedia bagi seluruh pengguna.
    *   **Global Reset:** Saat pengguna mengubah tahun di sini, `CascadeProvider` akan memicu sinkronisasi ke seluruh modul (Settlement, Kasbon, Laporan, Revenue, dll) agar aplikasi menampilkan periode data yang seragam sesuai pilihan user.

manager only

4.  **Manajemen Database (Export & Import):**
    *   **Export Data:** Mencadangkan seluruh database ke folder cadangan sistem dengan notifikasi lokasi folder transparan.
    *   **Import Data:** Memulihkan database dari file `.sql` atau `.db`. Dilengkapi sistem **Preview Isi** (menghitung jumlah baris data) dan peringatan keamanan sebelum menghapus database lama.
    *   **Auto-Reload:** Aplikasi akan memuat ulang seluruh provider data secara otomatis setelah import berhasil.

5.  **Manajemen Pengguna (Account List)**
    *   **Daftar Akun Terpusat:** Akses ke dialog `AccountListDialog` untuk melihat seluruh daftar akun yang terdaftar dalam sistem.
    *   **Moderasi Akun:** Memberikan kemampuan bagi Manager untuk memverifikasi atau mengelola status aktif/nonaktif akun staf.

6.  **Manajemen Database (Export & Import)**
    *   **Export Database:** Fitur untuk mencadangkan seluruh isi database aplikasi menjadi file cadangan. Sistem memberikan informasi lokasi folder dan nama folder hasil ekspor secara transparan.
    *   **Import Database:** Fitur untuk memulihkan data dari file ekspor sebelumnya. Dilengkapi sistem **Preview Ringkasan Isi** (menampilkan jumlah baris per tabel) dan peringatan keamanan tingkat tinggi (Danger Alert) sebelum data lama dihapus dan diganti dengan data baru.
    *   **Auto-Reload System:** Setelah proses import berhasil, aplikasi secara otomatis memicu pemuatan ulang seluruh *provider* data untuk memastikan sinkronisasi instan.

7.  **Pengaturan Deadline Notifikasi**
    *   **Deadline Manager:** Navigasi ke layar khusus untuk mengatur ambang batas waktu (deadline) pengajuan Kasbon dan Settlement, yang nantinya akan memicu notifikasi peringatan kepada Staff.

8.  **Konfigurasi Penyimpanan (Storage Settings)**
    *   **Path Relocation:** Fitur teknis bagi Manager untuk mengatur direktori penyimpanan file (nota, bukti transfer, dll) di sisi server secara dinamis melalui interface aplikasi.

9.  **Pembersihan Data (Data Cleanup)**
    *   **Optimization Tool:** Akses ke fitur pembersihan draf kosong atau data sampah lainnya guna menjaga performa database tetap optimal.

10.  **Pembersihan Data Selektif (Data Cleanup):**
    *   Navigasi ke `DataCleanupScreen` untuk menghapus data transaksi secara permanen berdasarkan filter tahun pilihan guna mengoptimalkan performa database.

---

### 10. Tambahan (Sistem Lanjutan & Struktur Data)

#### **A. Cascading Report Year System (Relation Mapping)**
**File:** `frontend/lib/providers/cascade_provider.dart`

Ini adalah sistem "Efek Domino" yang mengatur konsistensi data di seluruh aplikasi.
*   **Mekanisme Sinkronisasi:** Saat pengguna mengubah tahun laporan di satu halaman (misal: di Laporan Tahunan), `CascadeProvider` akan secara otomatis mengirimkan sinyal ke 7 provider lainnya (Revenue, Tax, Dividend, Asset, Bank, Settlement, dan Advance).
*   **Pemisahan Grup State:**
    1.  **Grup Laporan:** Perubahan tahun bersifat absolut dan menyinkronkan semua modul manajemen (Revenue, Tax, dll).
    2.  **Grup List (Settlement/Kasbon):** Perubahan tahun di daftar transaksi bersifat independen (menggunakan `_filterYear`), kecuali jika fitur "GABUNG" diaktifkan, maka tahun akan mengikuti sinkronisasi global.
*   **Global Reset:** Pengaturan tahun di halaman *Settings* bertindak sebagai "Master Reset" yang akan mengembalikan seluruh halaman aplikasi ke tahun default yang baru.
Ini adalah "Otak Sinkronisasi" aplikasi yang mengatur relasi antar modul dalam 4 tier utama:
1.  **Tier Laporan (Group Laporan):** Menyinkronkan secara otomatis modul Laporan Summary, Laporan Tahunan, Revenue, Tax, Dividend, Asset, dan Bank Status.
2.  **Tier Settlement (Independen):** Memiliki filter tahun sendiri agar user bisa melihat daftar transaksi tanpa mengganggu tampilan laporan tahunan di tab lain.
3.  **Tier Kasbon (Independen):** Sama seperti settlement, memiliki state tahun mandiri untuk fleksibilitas navigasi.
4.  **Tier Global Settings:** Bertindak sebagai pemicu *Master Reset* yang akan menyelaraskan seluruh tier di atas ke tahun default yang baru ditentukan.

#### **B. Kategori Tabular & Group Management (Kanban Logic)**
**File:** `frontend/lib/screens/management/category_tabular_screen.dart`

Fitur ini menyajikan data kategori dalam format tabel yang lebih teknis dan terstruktur.
*   **Tujuan:** Memudahkan audit masal terhadap seluruh kategori dan sub-kategori tanpa harus membuka satu per satu *ExpansionTile*.
*   **Fitur Utama:** Menampilkan pemetaan lengkap kode kategori, nama induk, nama anak, serta status approval dalam satu tampilan tabel yang lebar.
*   **Keunggulan:** Sangat berguna bagi admin untuk melakukan pengecekan duplikasi kategori atau kesalahan penulisan kode kategori secara cepat.
Fitur teknis untuk mengatur struktur data kategori yang akan diekspor ke Excel.
*   **Kanban Grouping:** Dialog khusus yang membagi kategori ke dalam 3 kolom utama: **BEBAN LANGSUNG**, **BEBAN TIDAK LANGSUNG**, dan **BIAYA ADMINISTRASI DAN UMUM**.
*   **Drag-and-Drop Reordering:** Manager dapat mengurutkan baris kategori menggunakan `ReorderableListView`. Urutan (index) di halaman ini secara otomatis menentukan **urutan kolom pada Sheet 1 laporan Excel Tahunan**.
*   **Sort Mode Switcher:** Fitur untuk beralih antara "Mode Kategori" (berdasarkan hirarki) atau "Mode Tanggal" (berdasarkan kronologi), yang tersimpan secara persisten di `SharedPreferences`.
*   **Bulk Payload Saving:** Mengirimkan seluruh urutan baru dalam satu kali permintaan API (`reorderCategories`) untuk efisiensi performa.
