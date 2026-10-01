# Spesifikasi Struktur Laporan Tahunan V2

Dokumen ini merinci aturan baru untuk struktur **Tabel 5: Pengeluaran (Bank)** dan perbaikan UI pada Laporan Tahunan.

## 1. Kebijakan Export (Excel & PDF)
- **Status Saat Ini**: Tidak ada perubahan pada logic export Excel/PDF.
- Kolom yang dipertahankan: Pemasukan, Pajak, Pengeluaran (Matrix), Laba Rugi, Neraca, Dividen.
- Perubahan hanya akan diterapkan pada **tampilan UI Aplikasi**.

## 2. Struktur Tabel 5: Pengeluaran (Bank)
Tabel ini akan membagi pengeluaran menjadi dua bagian besar: **Single** dan **Batch**.

### A. Bagian Single (Dinamis per Bank)
Setiap "Sumber Dana" (Bank Account) yang terdaftar di aplikasi akan memiliki 2 grup otomatis:
1. **Transfer from [Nama Bank] account**: Berisi semua pengeluaran single dari bank tersebut.
2. **Biaya Admin [Nama Bank]**: Berisi semua item biaya administrasi dari bank tersebut.

*Contoh jika ada 5 Bank:*
- Akan ada 5 grup "Transfer from..."
- Akan ada 5 grup "Biaya Admin..."
- Total 10 grup utama di bagian Single. Jumlah ini akan bertambah otomatis jika Sumber Dana di aplikasi ditambah.

### B. Bagian Batch
- Tidak dibedakan per Bank secara header utama, tetap sebagai satu kesatuan "Batch Expenses".
- Namun, di dalam daftar item batch tersebut, akan dilakukan **Group By** berdasarkan **Bank** dan **Sub-Kategori**.

## 3. Fitur Crosscheck (Kolom Tambahan)
Pada Tabel 4 (Pengeluaran Matrix) dan Tabel 5 (Pengeluaran Bank), akan ditambahkan 2 kolom di sisi paling kanan setelah kolom kategori terakhir:

1. **Kolom Sub Total**: 
   - Menghitung jumlah secara **Horizontal** untuk setiap baris.
   - Rumus: `Sum (semua kolom kategori pada baris tersebut)`.
2. **Kolom Total**:
   - Menghitung jumlah secara **Vertikal** dari kolom Sub Total.
   - Berfungsi sebagai verifikasi akhir (Crosscheck) bahwa total horizontal sama dengan total pengeluaran.

## 4. Penanganan Data Kosong
- Semua pilihan Bank yang masih kosong atau null akan ditampilkan sebagai `-` (strip).
- Aturan ini berlaku di:
    - Tabel Pengiriman Dana (Detail Settlement).
    - Semua tabel di Laporan Tahunan.

---
## 5. Referensi File Kode
Untuk keperluan pengembangan atau referensi bagi AI lain, berikut adalah lokasi file utama yang menangani data dan tampilan Tabel 4 (Pengeluaran):

### A. Backend (Python)
- **Path**: `backend/routes/reports/annual.py`
- **Fungsi Utama**: 
    - `_build_annual_payload_from_db`: Mengambil dan memproses data dari database.
    - `_group_annual_expenses`: Logika pengelompokan (Batch vs Single) yang digunakan saat ini.

### B. Frontend (Dart/Flutter)
- **Path**: `frontend/lib/screens/reports/annual_report_screen.dart`
- **Widget Utama**:
    - `_buildExpenseTable`: Widget yang merender Tabel 4 (Pengeluaran).
    - `_buildAssetTable`: Referensi untuk Tabel 5 yang lama (Asset Register) yang akan digeser ke Tabel 6.

### C. Helper & Pendukung Lainnya
- **Backend Helpers**: `backend/routes/reports/helpers.py` (Berisi fungsi pembantu untuk format data dan perhitungan tanggal).
- **Backend Models**: `backend/models.py` (Definisi tabel `Expense`, `Settlement`, dan `BankAccount`).
- **Frontend Service**: `frontend/lib/services/api_service.dart` (Mengatur pengambilan data dari backend ke frontend).
- **Frontend Settlement UI**: `frontend/lib/screens/settlement/settlement_detail_screen.dart` (Tampilan "Tabel Pengiriman Dana" yang perlu simbol `-` jika bank kosong).

---
**Catatan**: Implementasi ini akan difokuskan pada fleksibilitas UI agar bisa menangani jumlah Bank yang dinamis tanpa perlu mengubah kode setiap kali ada bank baru.
