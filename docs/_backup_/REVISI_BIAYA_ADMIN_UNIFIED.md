# Master Plan: Unifikasi & Tabel Khusus Biaya Admin

Dokumen ini merinci rencana teknis untuk menyempurnakan pencatatan dan pelaporan biaya administrasi bank, agar memiliki alur input yang lebih mudah dan laporan yang transparan bagi Manager.

---

## 1. Tujuan Revisi
1. **Input Instan:** Memungkinkan Finance/Manager memasukkan biaya admin langsung di Tabel Pengiriman Dana tanpa harus membuat item detail baru.
2. **Transparansi Maksimal:** Membuat tabel laporan khusus untuk biaya admin agar tidak bercampur dengan biaya operasional proyek.
3. **Akurasi Batch:** Memisahkan biaya admin yang "nyelip" di dalam transaksi Batch.

---

## 2. Perubahan Arsitektur & Database

### A. Database (`backend/models.py`)
* **Modifikasi Tabel `Settlement`:** Tambahkan kolom `admin_fee` (Float, default=0.0).
* **Modifikasi Tabel `Advance`:** Tambahkan kolom `admin_fee` (Float, default=0.0).
* **Tujuan:** Menyimpan nilai biaya transaksi bank yang diinput langsung saat proses pengiriman dana.

### B. Backend Logic (`backend/routes/reports/`)
* **`helpers.py`:** Update fungsi `_group_annual_expenses` untuk mendukung "Sub-Grouping" biaya admin di dalam transaksi Batch.
* **`annual.py`:** 
    * Implementasi **Tabel Khusus Biaya Admin** setelah Tabel Bank Status.
    * Struktur Kolom: `Date`, `#`, `Activity`, `Source`, `Jumlah`, `Currency`, `Exchange`, `ADMINISTRASI`, `Type (Single/Batch)`, `Sub Total`, `Total`.

---

## 3. Perubahan Antarmuka (Frontend)

### A. Tabel Pengiriman Dana (`settlement_detail_screen.dart` & `advance_detail_screen.dart`)
* Menambahkan kolom **"Fee Admin"** di antara kolom *Amount* dan *Evidence*.
* Kolom ini dapat diedit oleh Finance/Manager.
* Nilai yang diinput akan dikirim ke API saat melakukan verifikasi dana atau approval final.

---

## 4. Logika Laporan (Excel)

### A. Sub-Grouping di Tabel Pengeluaran
* Jika item memiliki sub-kategori "Biaya Bank", sistem akan menariknya keluar dari daftar utama dan menaruhnya di bawah header **"Biaya Admin - [Konteks]"**.

### B. Tabel Rekap Khusus (Tabel 7 Baru)
* Tabel ini akan merangkum SEMUA biaya admin, baik yang berasal dari:
    1. Kolom `admin_fee` di tabel Settlement/Advance.
    2. Item belanja yang dikategorikan sebagai "Biaya Bank".
* Hal ini memastikan "Preview" yang diminta Papa tersedia secara lengkap di satu tempat.

---

## 5. Rencana Aksi (Step-by-Step)
1. **Fase 1:** Migrasi Database (Tambah kolom `admin_fee`).
2. **Fase 2:** Update Backend (Logika ekstraksi admin fee dari model & item belanja).
3. **Fase 3:** Update Laporan Excel (Pembuatan Tabel Khusus & Sub-grouping).
4. **Fase 4:** Update Frontend UI (Menampilkan kolom Fee Admin).

---
*Dibuat pada: 7 Mei 2026*
*Status: In Progress / Execution Stage 1*
