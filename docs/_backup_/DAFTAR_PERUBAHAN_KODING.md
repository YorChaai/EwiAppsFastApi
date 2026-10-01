# Checklist Teknis: Daftar Perubahan Koding (Revisi Total)

Dokumen ini adalah panduan file-file yang perlu dimodifikasi untuk mengimplementasikan sistem Akuntansi, Aset, dan UI baru.

---

## 1. BACKEND (Python / Flask)

### A. Database Models (`backend/models.py`)
*   [ ] **[NEW]** Buat tabel `Asset` (ID, Nama, Harga, Tanggal Beli, Masa Manfaat).
*   [ ] **[NEW]** Buat tabel `BankAccount` (ID, Nama Bank, Nomor Rekening, Saldo Awal).
*   [ ] **[MODIFY]** Update tabel `Settlement` & `Advance`: Tambahkan kolom `bank_id` (ForeignKey ke `BankAccount`).
*   [ ] **[MODIFY]** Tambahkan kolom `pph29` dan `pendapatan_lain` pada tabel Neraca/Summary.

### B. Business Logic (`backend/routes/reports/annual.py`)
*   [ ] **[MODIFY]** Update fungsi Laporan Tahunan untuk menghasilkan data 7 Tabel.
*   [ ] **[MODIFY]** Implementasi rumus Depresiasi Aset (Linear 1/60 per bulan).
*   [ ] **[MODIFY]** Implementasi logika saldo Bank (Mutasi otomatis saat Settlement/Kasbon Final).

### C. API Endpoints
*   [ ] **[NEW]** Endpoint untuk Input Dividen dan Input Modal/Neraca.
*   [ ] **[MODIFY]** Endpoint Settlement/Kasbon: Izinkan Manager mengupdate data meskipun status sudah `Approved Final`.

---

## 2. FRONTEND (Flutter / Dart)

### A. Layar Laporan Tahunan (`lib/screens/reports/annual_report_screen.dart`)
*   [ ] **[MODIFY]** Implementasi **Triple Cascading Header** (Input, Sheet, Kolom).
*   [ ] **[MODIFY]** Logika `_activeSheet`: Membagi tampilan menjadi 3 sheet (Revenue Cost, Laba Rugi, Business Summary).
*   [ ] **[MODIFY]** Rebranding label "Revenue" menjadi "Pemasukan".

### B. Layar Settlement Detail (`lib/screens/settlement/settlement_detail_screen.dart`)
*   [ ] **[MODIFY]** Upgrade menjadi **4 Summary Cards** (Total, Approved, Reimbursement, Expense).
*   [ ] **[MODIFY]** Hapus kolom "Sumber" pada tabel rincian item atas.
*   [ ] **[MODIFY]** Implementasi **Tabel Pengiriman Dana Dinamis** di bagian bawah.
*   [ ] **[MODIFY]** Tambahkan validasi: Tombol verifikasi muncul hanya jika `bank_id` sudah dipilih.

### C. Layar Kasbon / Advance (`lib/screens/advance/`)
*   [ ] **[CLEAN UP]** Hapus kodingan Kasbon yang lama/salah arah.
*   [ ] **[REFACTOR]** Copy-paste logika dari `settlement_detail_screen.dart` dan sesuaikan teks label menjadi "Permintaan Kasbon".

### D. Global Widgets
*   [ ] **[NEW]** Widget `CascadingMenuCustom` untuk header yang konsisten di semua layar.

---

## 3. LOGIKA OVERRIDE (MANAGER ONLY)
*   [ ] Tambahkan pengecekan `user_role == 'manager'` pada tombol edit di layar yang sudah terkunci.
*   [ ] Pastikan perubahan oleh manager otomatis mentrigger update pada Tabel 6 (Bank Status).

---

## 4. ENVIRONMENT SETUP
*   [ ] Jalankan `run.bat` menu nomor **4 (Setup Environment)** untuk memastikan `python-dotenv` dan `sqlalchemy` sudah terinstal sempurna.

> [!TIP]
> **Urutan Pengerjaan Disarankan:**
> 1. Mulai dari **Models** (Database) ➔ 2. **Backend Routes** (Logic) ➔ 3. **Frontend UI** (Layout).

#baru

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


Saya sudah buatkan daftar file yang perlu diubah di docs/DAFTAR_PERUBAHAN_KODING.md.

Penjelasan Sederhana Mengenai "Cara Nyambungnya":
Dio bingung bagaimana Tabel 6 (Bank Status) bisa tahu ada uang keluar? Jawabannya ada di ID Bank.

Di Database: Kita akan punya daftar Bank. Contohnya: ID 1 = BRI, ID 2 = BCA.
Di Layar Settlement Detail: Saat Dio pilih "BCA", sebenarnya aplikasi Dio mencatat ID 2.
Saat Klik Approve: Sistem akan membuat catatan di tabel mutasi bank: "Uang keluar dari ID 2 sebesar Rp 1 Juta".
Di Laporan (Tabel 6): Kodingan laporan cuma perlu bilang: "Hey Database, tampilkan semua uang keluar yang ID-nya 2 (BCA)".
Itulah kenapa mereka otomatis nyambung. Dio tidak perlu input dua kali. Input di Settlement, Laporan langsung terupdate sendiri.

File yang Perlu Dio Perhatikan:
backend/models.py: Untuk membuat "wadah" datanya (Tabel Aset dan Tabel Bank).
frontend/.../settlement_detail_screen.dart: Untuk membuat tabel "Pengiriman Dana" di bawah dan pilihan Bank-nya.
frontend/.../annual_report_screen.dart: Untuk memunculkan Tabel 6 dan Tabel 7 di layar laporan tahunan.
Saya sudah tulis detail teknisnya di file .md tersebut sebagai panduan Dio nanti kalau sudah siap koding.

Apakah daftar file dan penjelasan "Cara Nyambung" ini sudah bisa dipahami, Dio?_