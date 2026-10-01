# Laporan Perubahan Kode: Unifikasi Sumber Dana (Bank)

Berikut adalah ringkasan perubahan kode yang dilakukan untuk memperbaiki masalah sinkronisasi bank (Tabel 2 & 3) dan fitur pengembalian dana.

## 1. Backend (Logic & Database)

### 📂 `backend/models.py`
- Menambahkan kolom `disbursement_source` (Tabel 2) dan `return_source` (Tabel 3) pada model `Advance` dan `Settlement`.
- Mengupdate method `to_dict()` agar field baru ini terkirim ke frontend.

### 📂 `backend/routes/settlements.py` & `advances.py`
- Memperbarui API `/save-disbursement` untuk menyimpan nama bank sederhana (BCA, BRI, dll) ke kolom baru.
- Memperbarui API `/save-return` agar bisa menyimpan "Sumber Dana" saat pengembalian uang (sebelumnya tidak ada).

### 📂 `backend/routes/reports/annual.py`
- Mengubah logika pembacaan bank pada laporan tahunan: Sekarang memprioritaskan `return_source` atau `disbursement_source` yang baru.
- Memperbaiki Table 3C (Returned Funds) agar menampilkan rincian bank pengembalian dengan benar.

### 📂 `backend/migrations/versions/f4b9c2d7e8a1_...py` (File Baru)
- Migration script untuk mengupdate struktur database PostgreSQL agar mendukung kolom baru secara permanen.

---

## 2. Frontend (UI & Integration)

### 📂 `screens/settlement_detail_screen.dart` & `advance_detail_screen.dart`
- **Tabel 2 (Pengiriman):** Dropdown sekarang menggunakan 7 pilihan standar: `BCA, BRI, Mandiri, BNI, Cash, Advance, Lainnya`. Tidak lagi memunculkan nama akun detail yang membingungkan.
- **Tabel 3 (Pengembalian):** Menambahkan field input **"Sumber Dana"** untuk memilih bank saat ada kelebihan dana yang dikembalikan.

### 📂 `screens/reports/annual_report_screen.dart`
- Memperbarui visualisasi laporan agar sinkron dengan kategori bank yang baru.
- Memastikan kolom bank di PDF dan layar laporan tidak lagi kosong atau berisi nama akun teknis.

### 📂 `providers/` & `services/api_service.dart`
- Menambah fungsi untuk mengirim data `disbursement_source` dan `return_source` dari UI ke server.

---

## 3. Tool Migrasi (Automation)

### 📂 `backend/scratch/scanner_fokus/scripts/generate_hybrid_migration_v3.py`
- Menambahkan fungsi `map_bank_source()`: Otomatis mendeteksi nama bank dari Excel (misal: "BRI GIRO") dan menyederhanakannya menjadi "BRI" di database.
- Menjamin data 2024 yang diimpor dari Excel langsung kompatibel dengan sistem baru.

---

## Hasil Akhir (After)
1. **Input User:** Lebih mudah karena pilihan bank sudah standar.
2. **Database:** Lebih lengkap karena mencatat sumber dana pengembalian.
3. **Laporan:** Lebih rapi dan akurat karena kategori bank sudah seragam antara Tabel 1, 2, dan 3.


# Laporan Komprehensif: Transformasi dan Unifikasi Logika Sumber Dana (Bank)

## 1. Pendahuluan dan Latar Belakang Masalah
Sistem sebelumnya menghadapi kendala serius dalam hal konsistensi data keuangan, khususnya pada bagian pelaporan bank dan alur pengembalian dana (returned funds). Berdasarkan analisis dari screenshot dan laporan bug, ditemukan beberapa masalah kritikal:
- **Inkonsistensi Terminologi**: Tabel 1 menggunakan kategori bank umum (BCA, BRI, Mandiri), sementara Tabel 2 dan 3 menggunakan nama akun teknis dari sistem *Bank Status* (seperti BRI Giro, Mandiri Valas). Hal ini menciptakan kebingungan bagi pengguna dan membuat audit data menjadi sangat sulit.
- **Ketiadaan Input Pengembalian**: Pada Tabel 3 (Pengembalian Dana), sistem tidak menyediakan field untuk mencatat ke mana uang dikembalikan. Ini mengakibatkan hilangnya jejak arus kas masuk (cash-in) pada laporan tahunan.
- **Ketergantungan yang Salah**: Tabel Settlement dan Advance secara keliru bergantung pada tabel *Bank Status* yang sebenarnya merupakan modul independen untuk pelaporan saldo bulanan, bukan untuk transaksi operasional harian.

## 2. Strategi Perbaikan dan Perubahan Arsitektur
Untuk menyelesaikan masalah di atas, dilakukan perombakan pada tiga lapisan utama sistem: Database, Backend API, dan Frontend Mobile.

### 2.1 Perubahan pada Lapisan Database (PostgreSQL)
Langkah pertama adalah melakukan de-coupling (pemutusan hubungan) antara transaksi operasional dengan tabel Bank Status yang detail. Kami menambahkan kolom baru pada tabel `settlements` dan `advances`:
- `disbursement_source` (VARCHAR 50): Menyimpan kategori bank sederhana saat pengiriman dana.
- `return_source` (VARCHAR 50): Menyimpan kategori bank saat ada pengembalian kelebihan dana.
- `admin_fee`: Memastikan biaya admin bank dicatat secara eksplisit untuk kebutuhan Table 3b.

Struktur baru ini memungkinkan sistem untuk tetap memiliki catatan sejarah yang akurat meskipun akun bank teknis di modul *Bank Status* dihapus atau diubah di masa depan.

### 2.2 Transformasi Logika Backend (Python/Flask)
Di sisi server, logika pengolahan data diubah secara signifikan:
- **Normalisasi API**: Endpoint `/save-disbursement` dan `/save-return` di `settlements.py` dan `advances.py` kini menerima input string sederhana. Sistem tidak lagi mencari ID bank yang rumit, melainkan menyimpan label kategori yang langsung bisa dibaca oleh manusia.
- **Logika Laporan Tahunan (annual.py)**: Kode laporan tahunan dirombak untuk memprioritaskan field baru ini. Jika `return_source` tersedia, laporan akan menampilkannya. Jika tidak, ia akan mundur (fallback) ke `disbursement_source`. Ini menjamin Table 3C (Returned Funds) selalu memiliki informasi bank yang valid.
- **Otomasi Biaya Admin**: Sistem sekarang secara otomatis mendeteksi jika terjadi selisih antara dana yang dikirim dan dana yang disetujui, lalu menyarankannya sebagai `returned_amount` dan meminta input `return_source`.

### 2.3 Pembaruan Antarmuka Pengguna (Flutter)
Pada sisi Frontend, perubahan difokuskan pada UX (User Experience) agar kesalahan input dapat diminimalisir:
- **Standardisasi Dropdown**: Semua dropdown pemilihan bank di seluruh aplikasi (Settlement Detail dan Advance Detail) kini menggunakan satu daftar konstanta yang sama: `BCA, BRI, Mandiri, BNI, Cash, Advance, Lainnya`.
- **Integrasi Tabel 3**: Sesuai dengan permintaan pada Screenshot (5172), kami menambahkan baris input baru di bawah kolom pengembalian dana. Sekarang manager dapat memilih bank tujuan pengembalian, melengkapi rantai data keuangan yang sebelumnya terputus.
- **Visualisasi Laporan**: `annual_report_screen.dart` diperbarui untuk menangani skema data baru, memastikan bahwa PDF yang dihasilkan memiliki kolom bank yang rapi dan seragam.

## 3. Optimasi Tool Migrasi Excel (Hybrid Migration)
Salah satu bagian paling krusial adalah memastikan data lama (tahun 2024) dari file Excel dapat masuk ke sistem baru tanpa merusak format. Script `generate_hybrid_migration_v3.py` telah diperbarui dengan:
- **Fungsi `map_bank_source`**: Sebuah mesin penerjemah yang menggunakan teknik pencocokan string. Jika di Excel tertulis "BRI BISNIS", "BRI GIRO", atau "ATM BRI", script otomatis mengonversinya menjadi "BRI".
- **Batch Processing**: Untuk laporan pengeluaran batch, script akan mengambil sampel sumber dana dari item pertama dan menerapkannya pada header settlement secara otomatis.

## 4. Dampak dan Hasil Akhir (Before vs After)
Dengan implementasi ini, perbedaan yang akan dirasakan adalah:
1. **Ketepatan Data**: Tidak akan ada lagi baris laporan yang bertuliskan "BRI Giro" di satu tempat dan "BRI" di tempat lain. Semuanya akan teragregasi di bawah satu nama "BRI".
2. **Kemudahan Audit**: Auditor dapat dengan mudah melacak bahwa pengeluaran sebesar Rp 100.000 keluar dari "BCA" dan jika ada sisa Rp 10.000, kembali masuk ke "BCA" juga.
3. **Kepatuhan Laporan**: Tabel 3A (Admin Fee Sub-item), 3B (Admin Fee Bank), dan 3C (Returned Funds) pada laporan tahunan kini terisi secara otomatis dan akurat.
4. **Fleksibilitas**: Sistem tidak lagi terkunci pada daftar akun bank yang kaku, memberikan fleksibilitas bagi admin untuk mencatat transaksi tunai maupun transfer dengan standar yang sama.

Laporan ini menandakan bahwa bug pada sinkronisasi Tabel 2 dan Tabel 3 telah diselesaikan secara tuntas melalui pendekatan unifikasi sumber dana.
