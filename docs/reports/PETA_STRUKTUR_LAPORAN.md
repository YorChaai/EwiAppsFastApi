# Peta Struktur Laporan (Annual & Summary)

Dokumen ini berisi daftar file yang saling berhubungan dalam ekosistem **Laporan Tahunan** dan **Laporan Summary**, mulai dari tampilan input hingga pengolahan di backend.

## 1. Layar Laporan (Frontend Screens)
Ini adalah file utama yang menampilkan data laporan kepada pengguna:
- [annual_report_screen.dart](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/frontend/lib/screens/reports/annual_report_screen.dart) (Laporan Tahunan: Pemasukan, Biaya, Profit Loss, Neraca, Business Summary).
- [report_screen.dart](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/frontend/lib/screens/reports/report_screen.dart) (Laporan Summary / Bulanan).

## 2. Layar Input & Manajemen (Input Screens)
File ini digunakan untuk memasukkan data yang nantinya diolah ke dalam laporan:
- [revenue_management_screen.dart](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/frontend/lib/screens/management/revenue_management_screen.dart) (Input **Pemasukan**).
- [tax_management_screen.dart](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/frontend/lib/screens/management/tax_management_screen.dart) (Input **Pajak**).
- [bank_management_screen.dart](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/frontend/lib/screens/management/bank_management_screen.dart) (Manajemen **Bank Status**).
- [dividend_management_screen.dart](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/frontend/lib/screens/management/dividend_management_screen.dart) (Input **Deviden**).
- [asset_management_screen.dart](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/frontend/lib/screens/management/asset_management_screen.dart) (Input **Aset / Asset Register**).
- [settlement_detail_screen.dart](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/frontend/lib/screens/settlement/settlement_detail_screen.dart) (Input **Pengeluaran / Settlement**).
- [advance_detail_screen.dart](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/frontend/lib/screens/advance/advance_detail_screen.dart) (Input **Kasbon**).
- [balance_sheet_settings_screen.dart](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/frontend/lib/screens/settings/balance_sheet_settings_screen.dart) (Input **Saldo Awal & Pengaturan Neraca**).

## 3. Pengolah Data Backend (Python Routes)
File di server yang menerima input dan menghitung angka-angka untuk laporan:

### Laporan Utama
- [annual.py](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/backend/routes/reports/annual.py) (Otak Laporan Tahunan, perhitungan Profit Loss, Neraca, dan ekspor Excel).
- [summary.py](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/backend/routes/reports/summary.py) (Logika perhitungan Laporan Summary).
- [helpers.py](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/backend/routes/reports/helpers.py) (Fungsi bantuan perhitungan matematika laporan).

### Input-Specific Routes
- [revenues.py](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/backend/routes/revenues.py) (API Pemasukan).
- [taxes.py](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/backend/routes/taxes.py) (API Pajak).
- [banks.py](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/backend/routes/banks.py) (API Bank).
- [dividends.py](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/backend/routes/dividends.py) (API Deviden).
- [assets.py](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/backend/routes/assets.py) (API Aset).
- [settlements.py](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/backend/routes/settlements.py) (API Settlement/Pengeluaran).

## 4. Penghubung & Model (Providers & Services)
- [settlement_provider.dart](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/frontend/lib/providers/settlement_provider.dart) (Mengatur sinkronisasi **Tahun Laporan**).
- [api_service.dart](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/frontend/lib/services/api_service.dart) (Daftar semua fungsi API).

## 5. Inti Aplikasi
- [main.dart](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/frontend/lib/main.dart) (Registrasi provider).
- [main.py](file:///d:/2. Organize/1. Projects/MiniProjectKPI_EWI_Revisi2/backend/main.py) (Registrasi route backend).
