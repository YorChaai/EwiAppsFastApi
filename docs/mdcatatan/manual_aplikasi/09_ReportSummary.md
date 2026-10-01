# Product Requirements Document (PRD)

## Modul: Report Summary (Laporan Ringkasan)

Halaman **Report Summary** adalah layar utama penganalisisan data finansial yang dikhususkan untuk rekapitulasi nilai transaksi lintas bulan. Di awal pemuatan, layar memunculkan indikator *loading* berputar selama pengambilan data dari pangkalan data berlangsung secara _asynchronous_. Setelah data sukses dirender, antarmuka terpecah menjadi tiga segmen visual dan fungsional: bagian identitas laporan (_Header & Cache Info_), panel penyaring navigasi (_Actions_), serta hamparan tabel finansial ekstensif (_Summary Table_). Bagian _Header_ menampilkan judul besar dengan sub-judul penegas "Per kategori per bulan". Tepat di sebelahnya, disematkan kotak label _Cache Info_ yang berfungsi sebagai stempel jejak digital; kotak kecil ini secara transparan memberitahu pengguna dari mana sumber data tersebut ditarik (seperti "CACHE" untuk riwayat lokal, atau "REFRESH" untuk tarikan langsung pangkalan data) beserta cap waktu pengambilan secara presisi. Apabila pengguna mengaktifkan mode filter rentang waktu tertentu, baris rentang tanggal yang disorot dengan warna aksen (_Accent Color_) akan muncul mendampingi judul.

Kendali data terpusat pada deretan alat interaktif yang menyamping (atau berpindah ke bawah jika diakses melalui lebar layar sempit/_Mobile_). Terdapat filter _dropdown_ tahun laporan yang juga melayani pemicu kalender *Range* (batas hari). Pada fitur inilah bersembunyi logika inti bernama **Global Sync State**: ketika pengguna mengubah rentang kalibrasi waktu di sini, modul pusat (_CascadeProvider_) akan melepaskan sinyal ke bawah yang memaksa *seluruh modul lain di aplikasi* (seperti modul Kasbon dan modul Settlement) agar mereset dan memuat ulang datanya sesuai dengan rentang waktu yang baru. Hebatnya, mekanisme ini bekerja dua arah; halaman Summary juga dibekali *Event Listener* pasif yang memungkinkannya memperbarui seluruh isi tabelnya sendiri secara diam-diam (otomatis) apabila ia mendeteksi adanya pergantian _setting_ tahun dari halaman lain. Selain filter kalender, tersedia tombol pintas berikon diagram kotak untuk memindahkan pengguna ke layar modul Laporan Tahunan. Sistem turut menyediakan tombol laci _Export_ berisi fitur unduhan ganda (dokumen PDF berikon merah dan format Excel berikon hijau). Sebagai penambah detail kemudahan, nama fail hasil unduhan dirakit secara cerdas oleh sistem dengan menyematkan parameter tanggal secara spesifik (contoh penamaan: `summary_20240101_20240131.pdf`) apabila di-ekspor pada mode rentang khusus demi menghindari penumpukan *file* usang.

Fondasi fungsional dari halaman ini bergantung seutuhnya pada Tabel Ringkasan. Tabel tersebut dirancang membentang horizontal menampung kolom-kolom untuk seluruh dua belas bulan (Jan-Des), diapit oleh kolom "Kategori" di sisi kiri dan kolom "TOTAL" gabungan di sisi kanan. Untuk menanggulangi luasnya tabel, kerangka tabel direkayasa dengan interaksi **Diagonal Clamping Sync**. Mekanisme _scroll_ pintar ini memastikan bahwa saat pengguna menggulir deretan data bulanan ke arah samping, deret baris _Header_ di plafon tabel dan blok baris _Grand Total_ di dasar tabel akan tetap melekat erat mengunci posisinya (bersifat _Sticky_), agar konteks identitas angka tiap bulan tak pernah luput dari pandangan pengguna. Guna meringankan bobot muatan pangkalan data API, perhitungan kumulatif pada lajur "GRAND TOTAL" di lantai tabel sebenarnya tidak dikirim dari peladen (_server_), melainkan dihitung sendiri oleh perangkat gawai pengguna lewat proses kalkulasi berulang (_client-side looping_) di layar peramban. Dalam hal keterbacaan, daftar nama kategori memanfaatkan teknik pergeseran (*indentation*) bertingkat untuk mempertegas identitas hierarki turunan (*parent-child*), diperkuat dengan corak latar dua warna bergelombang bergiliran (*zebra-striping / Even-Odd*) untuk memudahkan pembacaan deret angka bernilai jutaan. Sistem pun memiliki penanganan hampa: apabila tak ada sedikitpun data yang dikembalikan oleh sistem, antarmuka yang kompleks ini akan disembunyikan sepenuhnya, digantikan oleh teks peringatan lugas "Tidak ada data" yang mengambang di pusat layar kosong.

## Developer Tasks

### UI
- [ ] Buat layout utama dengan tiga segmen: Header & Cache Info, Actions, dan Summary Table.
- [ ] Tampilkan indikator Cache Info (sumber "CACHE"/"REFRESH" dan cap waktu) pada Header.
- [ ] Tampilkan baris indikator rentang tanggal di sebelah judul jika filter rentang waktu aktif.
- [ ] Buat komponen Summary Table dengan kolom bulan (Jan-Des), kategori, dan total gabungan.
- [ ] Implementasikan efek sticky (Diagonal Clamping Sync) pada baris Header (atas) dan baris Grand Total (bawah) saat tabel digulir horizontal.
- [ ] Terapkan indentation bertingkat pada teks kategori untuk merepresentasikan hierarki parent-child.
- [ ] Terapkan zebra-striping (warna latar bergantian) pada baris tabel untuk kemudahan membaca.
- [ ] Tampilkan indikator loading berputar (spinner) saat proses pengambilan data awal berlangsung.
- [ ] Tampilkan empty state dengan teks "Tidak ada data" di tengah layar apabila hasil kembalian dari API kosong (tabel disembunyikan).

### Interaction
- [ ] Buat komponen filter dropdown tahun laporan dan filter kalender Range (rentang tanggal).
- [ ] Sesuaikan letak deretan filter menjadi di samping untuk desktop dan berpindah ke bawah pada mode mobile.
- [ ] Buat laci Export dengan pilihan unduh format PDF dan Excel.
- [ ] Hasilkan format nama file unduhan dinamis sesuai rentang tanggal yang dipilih pengguna (contoh: `summary_YYYYMMDD_YYYYMMDD.pdf`).
- [ ] Hitung akumulasi angka pada lajur Grand Total secara otomatis di sisi klien (client-side) tanpa melibatkan API backend.

### Validation
- [ ] Pastikan pergantian filter rentang waktu tervalidasi dengan benar sebelum melakukan proses pengambilan data.

### Error & Edge Cases
- [ ] Cegah crash bila struktur data tabel kategori parent-child tidak lengkap atau null dari server.
- [ ] Pastikan tidak ada duplikasi data cache ketika reload diinisiasi berulang kali.

### Navigation
- [ ] Buat tombol pintas untuk navigasi berpindah ke layar Laporan Tahunan.

### Testing
- [ ] Verifikasi keakuratan kalkulasi Grand Total client-side sesuai dengan data bulan-bulan yang dijumlahkan.
- [ ] Pastikan format nama file export PDF/Excel benar sesuai rentang tanggal yang sedang aktif.
- [ ] Uji responsivitas tabel (Diagonal Clamping Sync) pada resolusi layar sempit dan lebar.
- [ ] Uji kemunculan empty state "Tidak ada data" saat response API sengaja dikosongkan.
- [ ] Pastikan perubahan waktu dari layar Laporan Ringkasan memicu Global Sync State ke halaman lain dengan benar.
- [ ] Pastikan Event Listener bereaksi dan me-reload tabel ketika tahun diganti dari modul eksternal.
