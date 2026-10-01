# Plan: Fixing Report Generation Logic for Settlement Titles and Admin Fees

## Permasalahan (Masalah yang Dihadapi)
1. **Tabel 3C (PENGEMBALIAN DANA):** 
   - Kolom "Item / Title" tidak konsisten. Jika tipe *Batch*, seharusnya menampilkan judul (title) settlement. Namun jika tipe *Single*, seharusnya menampilkan *Deskripsi* dari item biaya tersebut agar lebih deskriptif.
   - Kolom ID (di paling kanan) dianggap tidak perlu dan membuat tabel menjadi aneh.
   - Lebar tabel 3C tidak proporsional dan harus disamakan gaya lebarnya seperti Tabel 3A dan 3B.
   - Header kolom perlu diubah menjadi: date, # Deskripsi, Source, Approved, Disbursed, Returned, Type.

sumber dana itu mkdnya source

2. **Tabel 4 & Tabel 5 (PENGELUARAN & EXPENSES):**
   - Terdapat redudansi data "Admin Fee" (Biaya Admin). Biaya admin yang berasal dari "Pengiriman Dana" otomatis masuk juga ke dalam Tabel 4 & 5. 
   - Seharusnya, Tabel 4 & 5 *hanya* menampilkan Biaya Bank (Admin) yang diinput manual sebagai *Detail Item* (seperti di Tabel 3A), dan membuang Biaya Bank otomatis dari *Pengiriman Dana* (yang tampil di Tabel 3B) agar tidak ada pengeluaran ganda.

## Rencana Perbaikan (Execution Plan)

### 1. Backend (`backend/routes/reports/annual.py`)
- **Perbaikan Deskripsi Tabel 3C:** Pada saat mengumpulkan data `returned_funds_data` (untuk Kasbon dan Settlement), tambahkan logika pengecekan tipe dokumen. Jika tipenya `single` dan memiliki item, ambil `description` dari item pertama untuk menggantikan `title` bawaan dokumen. Jika `batch`, tetap gunakan `title` dokumen.
- **Penyaringan Admin Fee Tabel 4 & 5:** Ubah cara `ordered_expense_data` diproses. Khusus untuk data pengeluaran (yang akan dikirim ke *operation_cost*), singkirkan (filter out) item-item *virtual* yang dihasilkan oleh sistem secara otomatis untuk biaya admin pengiriman dana (`is_admin_fee_extra == True`). Filter ini harus dilakukan *setelah* menghitung total untuk Tabel 7 (Laba Rugi) agar *Profit Before Tax* tetap seimbang.

### 2. Frontend (`frontend/lib/screens/reports/annual_report_screen.dart`)
- **Perubahan Tabel 3C (Pengembalian Dana):**
  - Hapus kolom `ID` pada header.
  - Ubah nama header dari `Item / Title` menjadi `Deskripsi`.
  - Hapus data index ke-8 (ID) dari proses `mapped` saat membuat `returnedFundsRows`.
  - Ubah pengaturan `_getColumnWidths` untuk `'Tabel 3C'` agar proporsional dan tidak terpotong, menyesuaikan total 8 kolom: `[100, 50, 350, 150, 150, 150, 150, 150]`.

## Hasil Akhir yang Diharapkan (Expected Results)
1. **Tabel 3C Lebih Jelas:** Pengembalian sisa dana dari kegiatan tunggal (*Single*) akan langsung memperlihatkan apa nama kegiatan/belanjanya di kolom Deskripsi, bukan judul dokumen yang kaku. Kolom lebih rapi tanpa ID.
2. **Tabel 4 & 5 Bersih dari Duplikat:** Tidak akan ada lagi baris aneh seperti "Admin Fee - settlement 1" pada daftar pengeluaran operasional.
3. **Laba Rugi Tetap Balance:** Walaupun dihilangkan dari Tabel 4 & 5, Biaya Admin dari transfer bank tetap tercatat di Tabel 3B dan di total Laba Rugi.
