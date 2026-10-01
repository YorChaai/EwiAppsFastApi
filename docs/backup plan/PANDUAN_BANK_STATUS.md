# Panduan Lengkap: Pengelolaan Bank Status & Alur Verifikasi Dana

Dokumen ini adalah panduan utama untuk memahami **Tabel ke-6 (Bank Status)** dan bagaimana tabel tersebut terhubung dengan transaksi harian (Settlement/Kasbon).

---

## 1. Daftar "Kantong" Uang Perusahaan
Perusahaan memiliki banyak tempat penyimpanan uang (rekening). Setiap uang yang keluar atau masuk harus jelas berasal dari "kantong" mana.

### Daftar Rekening Aktif:
*   **BRI:** BRI Giro & BRI Bisnis.
*   **BCA:** BCA EWI (Rupiah).
*   **Mandiri:** Mandiri Giro, Mandiri TabBis (Tabungan Bisnis), & Mandiri Valas (Mata Uang Asing/USD).
*   **Cash:** Uang tunai fisik yang ada di kantor (Brankas).

---

## 2. Memahami Jenis Transaksi Bank

Dalam Tabel 6 (Bank Status), transaksi dibagi menjadi tiga kategori utama:

### A. Pemasukan (External Income)
Uang yang datang dari pihak luar ke bank kita.
*   **Contoh:** Bunga Bank (Bank Interest).
*   **Efek:** Saldo Bank Bertambah, dianggap sebagai Pendapatan di Tabel 1.

### B. Pengeluaran (Expense/Payment)
Uang yang keluar dari bank kita untuk membayar keperluan.
*   **Contoh:** Pembayaran Settlement/Kasbon kepada karyawan.
*   **Efek:** Saldo Bank Berkurang, dianggap sebagai Pengeluaran di Tabel 4.

### C. Pemindahbukuan (Internal Transfer / "Pindah Kantong")
Uang yang pindah antar rekening milik perusahaan sendiri.
*   **Contoh:** Pindah dari BRI Giro ke BCA, atau Tarik Tunai (BRI ke Cash).
*   **Prinsip Penting:** Uang perusahaan **TIDAK** bertambah dan **TIDAK** berkurang secara total. Hanya lokasinya yang pindah.
*   **Kegunaan:** Agar saldo di tiap bank tetap akurat (Rekonsiliasi).

---

## 3. Alur Verifikasi di Settlement & Kasbon

Ini adalah bagian paling penting dalam aplikasi Dio untuk memastikan data bank selalu sinkron.

### Tampilan di Screen Settlement Detail:
1.  **Box Notifikasi:** Jika item-item settlement di atas belum di-approve oleh Manager, maka di bagian bawah muncul kotak: **“Belum semua item di-approve.”** (Tabel pengiriman dana belum muncul).
2.  **Muncul Tabel Otomatis:** Begitu minimal satu item di-approve, kotak notifikasi hilang dan diganti dengan **Tabel Pengiriman Dana**.
3.  **Isi Data Otomatis:** Tabel ini otomatis mengambil data (No, Tanggal, Deskripsi, Amount) dari item yang sudah di-approve. User tidak perlu mengetik ulang.

### Kolom "Sumber Dana" (Point Kritis):
Di tabel pengiriman dana ini, ada kolom **Sumber Dana**. 
*   **Bukan Mata Uang:** Jangan diisi USD atau IDR.
*   **Isi Nama Bank:** Pilih dari daftar rekening (BCA, Mandiri, BRI, dll).
*   **Fungsi:** Menentukan bank mana yang saldonya akan berkurang di Tabel 6 nanti.

### Validasi Approved Final:
*   Manager tidak bisa melakukan **Approved Final** jika kolom **Sumber Dana** masih kosong.
*   Setelah Sumber Dana diisi dan status dikirim, Manager memberikan centang konfirmasi terakhir.
*   **Hasil Akhir:** Setelah Approved Final, sistem otomatis mencatat transaksi tersebut ke dalam **Tabel 6 (Bank Status)** sesuai bank yang dipilih.

---

## 4. Struktur Laporan Tabel 6 (Bank Status)
Laporan ini nantinya akan mengelompokkan transaksi berdasarkan jenisnya agar Om Anda mudah membaca:

*   **Grup 1: Bank Interest (BRI)** ➔ Berisi daftar bunga bank tiap bulan.
*   **Grup 2: Pemindahbukuan BRI ke BCA** ➔ Daftar mutasi pindah uang.
*   **Grup 3: Pemindahbukuan Mandiri Valas ke TabBis** ➔ Daftar konversi mata uang.
*   **Grup 4: Pembayaran Settlement** ➔ Daftar uang yang keluar untuk operasional.

---

## 5. Kesimpulan Workflow (Aliran Data)

1.  **Dio Input Settlement** ➔ Manager Approve Item.
2.  **Finance Isi Sumber Dana (Bank)** ➔ Memilih bank pembayar.
3.  **Manager Approved Final** ➔ Transaksi dianggap sah.
4.  **Sistem Auto-Post** ➔ Data otomatis muncul di **Tabel 4 (Pengeluaran)** dan **Tabel 6 (Bank Status)**.

> [!IMPORTANT]
> Dengan sistem ini, Om Anda bisa melihat transparansi penuh: 
> "Uang keluar 10 juta untuk beli bensin, diambil dari bank BCA pada tanggal 12 Mei." 
> Tidak ada lagi uang yang hilang tanpa penjelasan.
