# MASTER PLAN: Pengembangan Sistem Akuntansi & Manajemen Aset (Revisi Total)

Dokumen ini adalah panduan tunggal yang menggabungkan visi strategis, logika bisnis, dan instruksi teknis untuk pengembangan sistem Laporan Tahunan Proyek Dio.

---

## I. VISI & STRATEGI BISNIS
Tujuan akhir dari proyek ini bukan sekadar pencatat uang, melainkan menjadi **Sistem Manajemen Keuangan Profesional** yang siap dijadikan produk bisnis.

### 1. Perubahan Mindset: Pemasukan vs Revenue
*   **Masalah:** Selama ini semua uang masuk dianggap "Revenue". Ini salah secara akuntansi pajak.
*   **Solusi:** Ganti istilah "Revenue" menjadi **"Pemasukan"**.
*   **Kategori Pemasukan:**
    *   **Pendapatan Usaha:** Hasil tagihan invoice proyek.
    *   **Bunga Bank:** Uang dari bunga tabungan.
    *   **Investasi:** Modal dari investor/owner.
    *   **Pengembalian:** Uang piutang atau refund yang kembali.

### 2. Tantangan Pengembangan (Pesan Strategis)
*   **Kemitraan:** Dio disarankan bekerja sama dengan ahli pajak untuk validasi rumus flowchart di masa depan.
*   **Fokus:** *"Yang penting jalan dulu"*. Jangan dibuat terlalu rumit di awal, kuasai pencatatan dasarnya.

---

## II. STRUKTUR 7 TABEL LAPORAN TAHUNAN
Berikut adalah kegunaan dari 7 kotak informasi utama dalam laporan tahunan:

| No | Nama Tabel | Kegunaan Utama |
|:---|:---|:---|
| **1** | **Pemasukan** | Mencatat semua uang masuk (Invoice, Bunga, Investasi, Refund). |
| **2** | **Pajak** | Monitoring kewajiban pajak perusahaan (PPN, PPh 21/23/26). |
| **3** | **Dividen** | Pembagian laba bersih untuk pemilik/pemegang saham. |
| **4** | **Pengeluaran** | Mencatat biaya operasional (Gaji, Makan, Bensin, dll). |
| **5** | **Neraca** | Ringkasan kesehatan perusahaan (Uang + Piutang - Hutang). |
| **6** | **Bank Status** | Monitoring saldo di tiap rekening (BRI, BCA, Mandiri, Cash). |
| **7** | **Asset Register** | Daftar barang berharga (Mobil, Bangunan) yang harganya menyusut. |

---

## III. DEEP DIVE: SISTEM MANAJEMEN ASET
Mengapa Aset Register berbeda dengan Pengeluaran Biasa?

### 1. Logika Depresiasi (Penyusutan)
*   **Nasi Bungkus (Pengeluaran):** Sekali makan, habis. Tidak perlu didepresiasi.
*   **Mobil/Ruko (Aset):** Barang tetap ada, tapi nilainya turun setiap bulan.
*   **Manfaat Pajak:** Nilai penyusutan bulanan digunakan untuk mengurangi profit di laporan pajak secara legal, sehingga pajak yang dibayar perusahaan lebih kecil.

### 2. Kasus Properti (Workshop/Ruko)
Harus dipecah menjadi dua komponen:
*   **Bangunan:** Mengalami **Depresiasi** (Nilai turun).
*   **Tanah:** Mengalami **Apresiasi** (Nilai naik).

---

## IV. DEEP DIVE: BANK STATUS & PEMINDAHBUKUAN
Mengelola banyak "kantong" uang (BRI, BCA, Mandiri, Cash).

### 1. Konsep Pemindahbukuan (Internal Transfer)
Adalah proses pindah uang antar rekening perusahaan sendiri.
*   **Contoh:** Pindah dari BRI ke BCA, atau Tarik Tunai ke Cash.
*   **Karakteristik:** Tidak menambah atau mengurangi total kekayaan perusahaan, hanya lokasinya yang pindah. Ini krusial agar saldo di aplikasi sama dengan saldo di Bank asli (Rekonsiliasi).

### 2. Alur Verifikasi di Settlement Detail
1.  **Status Belum Approve:** Muncul notifikasi "Belum semua item di-approve".
2.  **Status Approved:** Muncul tabel "Pengiriman Dana" otomatis.
3.  **Input Sumber Dana:** Finance memilih **Nama Bank** (bukan mata uang) yang dipakai untuk membayar.
4.  **Approved Final:** Hanya bisa diklik jika Nama Bank sudah diisi.
5.  **Auto-Post:** Setelah klik Final, data otomatis masuk ke **Tabel 4 (Pengeluaran)** dan **Tabel 6 (Bank Status)**.

---

## V. RENCANA IMPLEMENTASI TEKNIS (KODING)

### 1. Perubahan Backend (Python/Flask)
*   **File `models.py`:** Menambah tabel `Asset` dan `BankAccount`. Update tabel `Settlement` dengan kolom `bank_id`.
*   **File `routes/reports/annual.py`:** Update logika laporan agar bisa membaca data dari tabel Aset dan Mutasi Bank.

### 2. Perubahan Frontend (Flutter/Dart)
*   **File `annual_report_screen.dart`:** Implementasi tampilan Tabel 6 dan 7. Ubah label "Revenue" ke "Pemasukan".
*   **File `settlement_detail_screen.dart`:** Implementasi tabel verifikasi dana di bawah dan sistem penguncian tombol "Approved Final".

---

## VI. CARA SISTEM "NYAMBUNG" OTOMATIS
Data dari **Settlement** bisa muncul di **Laporan Bank Status** melalui sistem ID:
1. User pilih **Bank BCA (ID 2)** di layar Settlement.
2. Database mencatat: *"Uang keluar dari Bank ID 2"*.
3. Laporan Laporan Tahunan mencari: *"Tampilkan mutasi untuk Bank ID 2"*.

> [!IMPORTANT]
> **Kesimpulan Akhir:** 
> Sistem ini dirancang untuk **Transparansi Total**. Om Anda ingin tahu uang datang dari mana, disimpan di bank mana, dan barang apa saja yang dimiliki perusahaan secara real-time.
