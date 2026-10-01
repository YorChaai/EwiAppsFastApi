# Blueprint: Rencana Pemecahan Arsitektur Backend (Refactoring)

Dokumen ini mencatat seluruh rencana pemecahan file-file "raksasa" (di atas 500 baris) di dalam folder `backend` agar kode menjadi lebih rapi, mudah di-maintain, dan mengurangi risiko *conflict* saat bekerja dalam tim.

---

## ✅ FASE 1: YANG SUDAH SELESAI

### 1. `models.py` (Tadinya 1450 baris)
File ini berisi seluruh definisi tabel database. Sudah dipecah menjadi folder/package `models/`:
- **`models/core.py`** (Berisi model dasar: `User`, `Company`, `Category`)
- **`models/banking.py`** (Berisi model bank: `BankAccount`, `BankTransaction`, `BankStatusTransaction`)
- **`models/transaction.py`** (Berisi model transaksi: `Advance`, `Settlement`, `Expense`, `Revenue`)
- **`models/system.py`** (Berisi model sistem: `Notification`, `DeadlineSetting`, `WorkflowLog`)
- **`models/__init__.py`** (Penyambung agar `app.py` tetap bisa mengimpor seperti biasa)

### 2. `routes/settings.py` (Tadinya 870 baris)
Berisi rute untuk pengaturan profil, database, dan tenggat waktu (deadline). Sudah dipecah menjadi folder `routes/settings/`:
- **`routes/settings/profile.py`** (Pengaturan profil dan report year)
- **`routes/settings/db_storage.py`** (Fungsi Export/Import Database & Backup)
- **`routes/settings/deadline.py`** (Pengaturan aturan deadline settlement/kasbon)
- **`routes/settings/__init__.py`** (Penyambung rute Blueprint)

---

## ⏳ FASE 2: RENCANA SELANJUTNYA (Belum Dieksekusi)

Berikut adalah sisa 14 file raksasa yang masih perlu dipecah/dirapikan. Strategi utamanya adalah **Service Layer Pattern**: memindahkan logika rumus/perhitungan/query berat dari folder `routes` ke folder `services`. 

### 3. Modul Laporan (`routes/reports/`) - Target Paling Berat
*Masalah: Mencampuradukkan logika query database, rumus perhitungan, format tampilan, dan route API dalam satu file panjang.*
**File yang akan dirapikan:**
- `annual_tables.py` (2154 baris)
- `annual_data.py` (1620 baris)
- `annual.py` (1587 baris)
- `annual_excel.py` (1445 baris)
- `summary.py` (1105 baris)
- `helpers.py` (875 baris)

**Rencana Pemecahan:**
- Rute API akan dibiarkan di dalam `routes/reports/` tetapi ukurannya akan sangat pendek.
- Logika query/perhitungan dipindah ke **`services/reports/annual_service.py`**
- Logika format Excel dipindah ke **`services/reports/excel_service.py`**
- Logika format tabel web dipindah ke **`services/reports/table_service.py`**

### 4. Modul Autentikasi (`routes/auth.py` - 845 baris)
*Masalah: Logika kirim Email, kirim OTP, dan manipulasi foto profil bercampur aduk.*
**Rencana Pemecahan:**
- Logika Email & OTP dipindah ke **`services/email_service.py`**
- Logika unggah dan kompresi Foto dipindah ke **`services/storage_service.py`**
- `routes/auth.py` HANYA mengurus terima dan kirim JSON login/register.

### 5. Modul Approval (`routes/settlements_approval.py` & `routes/advances_approval.py`)
*Masalah: Fungsi ACC (`approve`) sangat panjang karena membuat notifikasi, jurnal keuangan, dll.*
**Rencana Pemecahan:**
- Semua logika proses persetujuan (ACC/Tolak) dipindah ke **`services/approval_service.py`**
- File route HANYA akan memanggil fungsi dari service tersebut.

### 6. Rute Transaksi Inti (5 File)
*Masalah: Validasi data dan insert/update database yang sangat rumit dan tebal.*
**File yang akan dirapikan:**
- `routes/expenses.py` (656 baris)
- `routes/advances_items.py` (642 baris)
- `routes/revenues.py` (572 baris)
- `routes/advances_other.py` (532 baris)
- `routes/settlements_disbursement.py` (527 baris)

**Rencana Pemecahan:**
- Dibuatkan service masing-masing: **`services/expense_service.py`**, **`services/advance_service.py`**, dan **`services/revenue_service.py`**. 

---
*Dokumen ini dibuat otomatis sebagai panduan kerja tim.*
