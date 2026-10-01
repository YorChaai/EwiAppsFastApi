# 📋 Dokumentasi Struktur Header Excel (EWI Financial Report)

Dokumen ini berfungsi sebagai acuan (mapping) untuk kodingan scanner dalam membaca 3 sheet utama.

## 🛠️ Aturan Umum
- **Tahun Dinamis:** Nama sheet bisa berubah (misal: `2024` jadi `2025`). Kodingan harus mencari sheet yang mengandung kata kunci tersebut.
- **Pembersihan:** Abaikan baris total, subtotal, logo, dan tanda tangan.

---

## 📄 Sheet 1: Revenue-Cost (Dinamis Tahun)
*Contoh Nama: `Revenue-Cost_2024`*

Terdiri dari 3 area tabel utama:

### 1. Tabel: REVENUE & TAX
**Header (2 Baris/Merged):**
- `Invoice Date`, `#`, `Detail/Description`, `INVOICE VALUE`, `Currency`, `Currency Exchange`, `INVOICE Number`, `Client`, `Receive Date`, `AMOUNT RECEIVED IDR`, `Biaya transfer`, `Remark`.
- **Khusus Pajak (Sub-header):**
    - `PPn` -> `11%`
    - `PPH (Pasal 23)` -> `2%`

### 2. Tabel: Tax Transaction Details
**Header Utama:**
- `Date`, `#`, `Detail/Description`, `Transaction Value`, `Currency`, `Currency Exchange`.
- **Sub-header Pajak:**
    - `PPN` -> `Transaction`, `PPN`
    - `PPh (pasal 21)` -> `Transaction`, `PPh - 21`
    - `PPh (pasal 23)` -> `Transaction`, `PPh - 23`
    - `PPh (pasal 26)` -> `Transaction`, `PPh - 26`

### 3. Tabel: Biaya Operasi / Activity
**Header (1 Baris Utama):**
- `Date`, `#`, `Activity`, `Source`, `Jumlah`, `Currency`, `Currency Exchange`.
- **Kolom Kategori:**
    - `Biaya Operasi` (Isi: Gaji, Tunjangan Lapangan, Training, THR, Transport, Meal, Hotel, Laundry).
    - `Biaya Research (R & D)`
    - `Biaya Sewa Peralatan`
    - `Biaya Interpretasi Log Data`
    - `Administrasi`
    - `Pembelian Barang`
    - `Sewa Kantor`
    - `Kesehatan`
    - `Bisnis Dev`

---

## 📄 Sheet 2: Laba rugi (Dinamis Tahun)
*Contoh Nama: `Laba rugi -2024`*

### 1. Tabel LABA RUGI (Kiri)
**Ambil Kolom:**
- `PENDAPATAN LAINNYA`
- `CORPORATE TAX (PPh 29)`

### 2. Tabel NERACA (Kanan)
**Ambil Kolom:**
- `KAS DAN SETARA KAS TAHUN SEBELUMNYA` & `TAHUN LAPORAN`
- `PIUTANG USAHA`, `PAJAK BAYAR DI MUKA (pph23)`, `BIAYA BAYAR DI MUKA`, `PIUTANG LAIN LAIN`
- `INVENTARIS KANTOR`
- `HUTANG USAHA`, `HUTANG GAJI`, `HUTANG PEMEGANG SAHAM`, `BIAYA YANG MASIH HARUS DI BAYAR`
- `MODAL SAHAM`, `LABA DI TAHAN`

---

## 📄 Sheet 3: Business Summary
**Fokus: Section DEVIDEN**
- **Aturan:** Cari teks "DEVIDEN".
- **Target:** Ambil hanya Nama Orang pada setiap baris di bawahnya.
- **Ignore:** Angka, mata uang, dan catatan pajak.
- **Expected Result:** List Nama (String).
