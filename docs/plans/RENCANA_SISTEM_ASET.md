# Rencana Pengembangan: Sistem Akuntansi & Manajemen Aset (Proyek Dio)

Dokumen ini merangkum visi pengembangan aplikasi dari hasil diskusi mengenai sistem akuntansi yang lebih komprehensif, mencakup manajemen aset, depresiasi, dan kategorisasi pemasukan yang lebih akurat.

## 1. Transformasi Terminologi & Kategori
Sesuai arahan, istilah "Revenue" akan diganti menjadi "Pemasukan" untuk menghindari salah tafsir akuntansi. Pemasukan tidak hanya berasal dari hasil usaha.

### Kategori Pemasukan (Tabel 1)
1. **Pendapatan Usaha (Revenue):** Hasil dari penagihan invoice proyek.
2. **Bunga Bank:** Pendapatan pasif dari rekening perusahaan.
3. **Investasi:** Modal masuk dari investor/owner.
4. **Pengembalian (Refund):** Uang yang kembali (misal: pengembalian kelebihan bayar atau piutang yang dibayar balik).

## 2. Sistem Registrasi Aset (Asset Register)
Menambahkan modul baru untuk mencatat barang berharga perusahaan yang memiliki masa manfaat panjang.

### Logika Integrasi Pengeluaran ➔ Aset
* Setiap input **Pengeluaran (Expense)** akan memiliki kategori baru yaitu **"Aset"**.
* Jika pengeluaran ditandai sebagai aset (misal: Beli Mobil, TV, atau Ruko), sistem secara otomatis akan menambahkannya ke dalam **Tabel Asset Register**.
* Barang kecil (kursi, printer) tetap masuk ke Pengeluaran biasa (langsung habis dikonsumsi/expensed), bukan aset yang didepresiasi.

### Komponen Data Aset
* **Nilai Perolehan:** Harga beli awal barang.
* **Tanggal Perolehan:** Kapan barang dibeli.
* **Masa Manfaat:** Jangka waktu penyusutan (contoh: 5 tahun / 60 bulan).
* **Nilai Buku:** Nilai aset saat ini setelah dikurangi depresiasi.

## 3. Mekanisme Depresiasi & Pajak
Tujuan utama dari pencatatan aset adalah untuk menghitung **Depresiasi (Penyusutan)** guna mengurangi beban pajak perusahaan secara legal.

* **Perhitungan:** Nilai Perolehan dibagi Masa Manfaat (Bulan/Tahun).
* **Implementasi Laporan:** Nilai penyusutan bulanan akan muncul di Laporan Tahunan sebagai "Beban Depresiasi" (Non-Tunai).
* **NPV (Net Present Value):** Memantau nilai perusahaan saat ini berdasarkan aset yang dimiliki.

## 4. Kasus Khusus: Properti (Tanah & Bangunan)
Untuk pembelian properti (Workshop/Ruko), sistem harus mampu memecah komponennya:
* **Bangunan:** Mengalami **Depresiasi** (penurunan nilai karena usia).
* **Tanah:** Mengalami **Apresiasi** (kenaikan nilai pasar).
* Sistem akan menghitung *Net Value* dari gabungan keduanya untuk laporan neraca yang akurat.

## 5. Roadmap Pengembangan Teknis

### Tahap 1: Rebranding & UI (Mudah)
* Mengubah label "Revenue" menjadi "Pemasukan" di seluruh layar aplikasi dan laporan Excel/PDF.
* Menambah pilihan kategori pada form input Pemasukan.

### Tahap 2: Database & Modul Aset (Menengah)
* Membuat tabel SQL baru `assets` untuk menyimpan daftar aset.
* Membuat layar **"Manajemen Aset"** di aplikasi Flutter.

### Tahap 3: Logika Kalkulasi (Kompleks)
* Membuat fungsi backend untuk menghitung depresiasi otomatis setiap bulan.
* Mengintegrasikan nilai depresiasi ke dalam Laporan Tahunan (Tabel Baru).

---

> [!TIP]
> **Saran Strategis:** Sebaiknya Dio fokus mematangkan alur penginputan aset terlebih dahulu sebelum masuk ke rumus pajak yang rumit. Seperti kata Om Anda, nantinya kita bisa menggandeng ahli pajak untuk memvalidasi rumus "flowchart" perpajakannya.

**Target Akhir:** Aplikasi ini akan menjadi produk bisnis yang siap dipakai oleh perusahaan untuk menghasilkan laporan keuangan standar akuntansi profesional.



# Panduan Sistem Akuntansi & Manajemen Aset (7 Tabel Utama)

Dokumen ini menjelaskan fungsi, kegunaan, dan alur data dari 7 tabel yang akan ada di dalam sistem Laporan Tahunan Dio.

## 1. Analisis Fungsi 7 Tabel Utama

| No | Nama Tabel | Kegunaan / Fungsi Utama |
|:---|:---|:---|
| **1** | **Pemasukan** | Mencatat semua uang yang masuk ke perusahaan. Bukan cuma hasil proyek, tapi juga bunga bank dan uang investor. |
| **2** | **Pajak** | Mencatat kewajiban pajak (PPN, PPh) agar perusahaan tidak kena denda dan laporan ke negara jelas. |
| **3** | **Dividen** | Mencatat pembagian keuntungan untuk pemilik perusahaan setelah dikurangi biaya-biaya. |
| **4** | **Pengeluaran** | Mencatat semua uang yang keluar untuk operasional (bensin, makan, gaji, beli alat). |
| **5** | **Neraca** | Ringkasan saldo akhir. Menghitung (Uang di Bank + Piutang) dikurangi (Hutang). Menunjukkan kesehatan perusahaan. |
| **6** | **Bank Status** | Memantau saldo di tiap rekening (BCA, Mandiri, Kas Tunai). Memastikan uang di kodingan sama dengan uang di bank asli. |
| **7** | **Asset Register** | Daftar inventaris barang berharga (Mobil, Bangunan, Laptop) yang nilainya menyusut setiap bulan. |

---

## 2. Bedah Detail: Tabel ke-7 (Asset Register)

Banyak yang bingung bedanya **Pengeluaran** (Tabel 4) dengan **Aset** (Tabel 7). Berikut adalah penjelasan detailnya:

### A. Kenapa butuh Tabel Aset?
Kalau Dio beli **Nasi Bungkus** (100 ribu), besok nasinya habis. Ini namanya **Pengeluaran Biasa**.
Tapi kalau Dio beli **Mobil** (200 juta), besok mobilnya masih ada. Mobil ini adalah **Kekayaan (Aset)**. Namun, meskipun mobilnya masih ada, harganya turun terus tiap tahun. Penurunan harga inilah yang disebut **Depresiasi**.

### B. Cara Kerja Asset Register di Sistem:
1. **Input Pembelian:** Dio input di Tabel 4 (Pengeluaran): "Beli Laptop Rp 12 Juta". Dio pilih kategori "Aset".
2. **Auto-Register:** Sistem otomatis mendaftarkan Laptop itu ke Tabel 7 (Asset Register).
3. **Setting Depresiasi:** Dio masukkan: "Laptop ini dipakai selama 4 tahun (48 bulan)".
4. **Hitung Bulanan:** Sistem akan menghitung: `12 Juta / 48 Bulan = 250 Ribu`.
5. **Efek ke Laporan:** Tiap bulan, nilai Laptop di Tabel 7 berkurang 250 ribu, dan di laporan rugi laba, muncul biaya "Penyusutan" 250 ribu.

### C. Manfaat untuk Om Anda:
* **Mengurangi Pajak:** Pemerintah mengizinkan biaya penyusutan aset untuk mengurangi laba. Kalau laba terlihat lebih kecil karena ada penyusutan aset, maka **pajak yang dibayar perusahaan jadi lebih kecil**.
* **NPV (Nilai Perusahaan):** Om Anda bisa tahu: "Tahun 2026 ini, semua aset kantor saya kalau dijual total harganya masih berapa?".

---

## 3. Alur Hubungan Antar Tabel (Workflow)

Untuk memudahkan Dio, bayangkan alur ini:

1. Ada **Pemasukan** (Tabel 1) masuk ke **Bank** (Tabel 6).
2. Dio belanja **Pengeluaran** (Tabel 4) ambil uang dari **Bank** (Tabel 6).
3. Jika yang dibeli adalah barang mahal, masuk ke **Asset Register** (Tabel 7).
4. Di akhir tahun, semua dihitung pajaknya di **Tabel 2**.
5. Sisa uang bersihnya dibagi ke pemilik di **Tabel 3**.
6. Posisi uang dan hutang terakhir dilihat di **Neraca** (Tabel 5).

---

## 4. Rencana Implementasi Bertahap

Jangan langsung kerjakan semua. Om Anda menyarankan "yang penting jalan dulu". 

1. **Minggu 1:** Ganti nama "Revenue" jadi "Pemasukan" dan tambah kategori (Bunga, Investasi, dll).
2. **Minggu 2:** Tambah kolom "Bank" di setiap transaksi agar **Bank Status** bisa jalan.
3. **Minggu 3:** Mulai buat tabel **Asset Register** dan logika hitung depresiasi sederhana.

> [!IMPORTANT]
> Intinya adalah **Transparansi**. Om Anda ingin tahu uang masuk dari mana, keluar lewat bank mana, dan barang apa saja yang sekarang dimiliki perusahaan.


Saya sudah mengupdate file docs/RENCANA_SISTEM_ASET.md dengan penjelasan yang jauh lebih detail.

Sekarang di dalam file tersebut ada bagian "Bedah 7 Tabel Utama". Saya sudah tuliskan fungsi tiap tabel dengan bahasa yang lebih sederhana:

Pemasukan, Pajak, Dividen, Pengeluaran, Neraca: Sudah saya jelaskan kegunaan masing-masing.
Bank Status: Penjelasan kenapa kita butuh tahu uang ada di bank mana saja.
Asset Register: Saya buatkan bagian khusus yang menjelaskan bedanya beli Nasi Bungkus (Pengeluaran) vs beli Mobil (Aset), serta bagaimana cara hitung penyusutannya.
Point Penting yang Saya Masukkan:
Cara kerja otomatis: Dio input sekali, 3 tabel terupdate sekaligus.
Manfaat Pajak: Kenapa Om Anda sangat ingin ada sistem depresiasi aset (untuk legalitas dan hemat pajak).
Alur Kerja: Bagaimana hubungan antara uang masuk di Bank ➔ belanja barang ➔ jadi Aset.
Silakan dibaca filenya, Dio. Semoga dengan penjelasan analogi "Nasi Bungkus vs Mobil" tersebut, konsep Asset Register jadi jauh lebih mudah dipahami!

Apakah penjelasannya sudah cukup jelas, atau ada bagian tabel tertentu yang ingin saya perdalam lagi?_