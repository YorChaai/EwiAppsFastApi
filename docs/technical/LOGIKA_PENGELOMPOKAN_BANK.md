# Logika Pengelompokan Pengeluaran Bank (Tabel 5)

Dokumen ini menjelaskan bagaimana sistem memisahkan antara transaksi **Transfer** (Pengeluaran Rutin) dan **Biaya Admin** pada laporan tahunan di aplikasi.

## 1. Mekanisme Identifikasi
Sistem menggunakan deteksi otomatis berbasis kata kunci (*keywords*) pada **Sub-Kategori** pengeluaran. Logika ini diterapkan secara otomatis di frontend agar laporan terlihat profesional dan terstruktur.

### Kata Kunci (Keywords)
Transaksi akan diklasifikasikan sebagai **Biaya Admin** jika nama sub-kategorinya mengandung salah satu kata berikut (pemeriksaan dilakukan secara *case-insensitive*):
- `biaya bank`
- `biaya admin`

### Aturan Filter:
- **Admin Fees**: Sub-kategori mengandung kata "biaya bank" ATAU "biaya admin".
- **Transfers**: Semua pengeluaran lain yang TIDAK mengandung kata-kata di atas.

## 2. Struktur Tampilan di Aplikasi (Tabel 5)
Berdasarkan pemisahan di atas, Tabel 5 akan membagi tampilan menjadi dua blok utama per Bank:

1.  **Header: Transfer from [Nama Bank] account**
    *   Berisi item seperti Gaji, Rental Tool, Pembelian Material, dll.
    *   Menampilkan detail per baris dan total grup di akhir blok.

2.  **Header: Biaya Admin [Nama Bank]**
    *   Hanya berisi item biaya administrasi, provisi, atau biaya transfer bank.
    *   Memisahkan biaya ini agar tidak bercampur dengan pengeluaran operasional utama.

## 3. Penentuan Sumber Dana (Nama Bank)
Sistem menentukan label bank (BCA, BRI, Mandiri, dll) menggunakan urutan prioritas (*fallback logic*):
1.  **Bank Account Linked**: Nama bank resmi yang dipilih saat approval/settlement.
2.  **Source Field**: Jika poin 1 kosong, sistem mengambil teks dari kolom `Source` (BCA/BRI/dll).
3.  **Default (-)**: Jika keduanya tidak ditemukan, akan ditampilkan sebagai `-`.

## 4. Lokasi Kode Referensi
Logika ini dapat ditemukan di file:
`frontend/lib/screens/reports/annual_report_screen.dart` pada fungsi `_processBankExpenseTable`.

---
*Dokumentasi ini dibuat untuk memastikan transparansi logika laporan keuangan.*
