# Daftar Rencana Perubahan Koding (Update 7 Tabel)

Dokumen ini merinci file-file mana saja yang perlu diubah untuk mengimplementasikan fitur Bank Status, Asset Register, dan Verifikasi Dana.

## 1. Perubahan pada Backend (Python/Flask)

### A. File: `backend/models.py`
*   **Tambah Model `BankAccount`:** Untuk menyimpan daftar nama bank (BCA, BRI, Mandiri, Cash).
*   **Tambah Model `Asset`:** Untuk menyimpan daftar aset perusahaan (Mobil, Laptop, dll).
*   **Update Model `Settlement`:** Menambah kolom `source_bank_id` (FK ke BankAccount) untuk mencatat bank mana yang digunakan untuk membayar.
*   **Update Model `BankTransaction`:** Untuk mencatat mutasi uang (Pemasukan, Pengeluaran, Pemindahbukuan).

### B. File: `backend/routes/reports/annual.py`
*   **Update Fungsi `get_annual_report`:** 
    *   Menambah query untuk mengambil data dari tabel `assets`.
    *   Menambah query untuk mengambil mutasi bank dari tabel `bank_transactions` yang dikelompokkan per nama bank.

---

## 2. Perubahan pada Frontend (Flutter/Dart)

### A. File: `lib/screens/reports/annual_report_screen.dart`
*   **Update Fungsi `_buildDisplayTables`:**
    *   Menambah UI untuk **Tabel 6 (Bank Status)**.
    *   Menambah UI untuk **Tabel 7 (Asset Register)**.
*   **Update Label:** Mengganti semua teks "Revenue" menjadi "Pemasukan".

### B. File: `lib/screens/settlements/settlement_detail_screen.dart`
Ini adalah bagian yang paling banyak berubah (Logika Verifikasi):
*   **Fungsi `_buildFundTransferTable`:** Membuat tabel baru di bagian bawah.
*   **Logika `if (itemsNotApproved)`:** Menampilkan kotak teks "Belum semua item di-approve" jika status belum valid.
*   **Dropdown Pilihan Bank:** Menambahkan pilihan Sumber Dana (BRI, BCA, Mandiri) di baris tabel pengiriman dana.
*   **Validasi Approved Final:** Menambahkan pengecekan `if (bankSelected == null)` maka tombol Approve tidak aktif.

---

## 3. Cara Sistem "Nyambung" Secara Otomatis

Banyak yang bingung bagaimana data dari Settlement bisa muncul di Report Tabel 6. Begini alur datanya:

1.  **INPUT:** User di `settlement_detail_screen.dart` memilih **BCA** sebagai sumber dana.
2.  **SAVE:** Saat klik "Approved Final", aplikasi mengirim data ke API: `{ settlement_id: 50, bank_id: 2 }`.
3.  **PROCESS:** Backend menyimpan di tabel `bank_transactions` bahwa ada uang keluar Rp XXX dari Bank ID 2.
4.  **REPORT:** Saat buka `annual_report_screen.dart`, sistem memanggil API Report. API tersebut mencari semua transaksi di `bank_transactions` dan menampilkannya di **Tabel 6**.

> [!TIP]
> **Urutan Pengerjaan:**
> 1. Perbaiki **Database** dulu (models.py).
> 2. Perbaiki **Inputan** (settlement_detail_screen.dart).
> 3. Terakhir baru buat **Tampilan Laporannya** (annual_report_screen.dart).
