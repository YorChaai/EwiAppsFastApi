# LAPORAN AUDIT & VERIFIKASI SETTLEMENT (2024 - 2026)
**File Excel Sumber:** `data/excel/20250427_EWI Financial-Repport_2024-2026 (version 2).xlsx`  
**Database Target:** PostgreSQL `miniproject_revisi_db` (Skrip Migrasi `generate_hybrid_migration_v14.py`)  
**Tanggal Audit:** 21 September 2026

---

## 1. Executive Summary & Verifikasi Angka

Berdasarkan audit komprehensif baris-demi-baris pada file Excel dan rekonsiliasi data pada database PostgreSQL:
**Semua angka Single dan Batch untuk tahun 2024, 2025, dan 2026 adalah 100% TEPAT dan BENAR.**

### 📊 Tabel Rekapitulasi Multi-Tahun

| Tahun Laporan | Sheet Excel | Single (Settlement / Item) | Batch (Settlement) | Batch Items | Total Settlement | Total Pengeluaran (IDR) |
| :---: | :--- | :---: | :---: | :---: | :---: | :---: |
| **2024** | `Rev VS Ops cost th 2024` | **188** | **40** | 406 | **228** | Rp 4.533.729.033,68 |
| **2025** | `Rev VS Ops cost th 2025_Final` | **335** | **45** | 706 | **380** | Rp 6.871.192.108,23 |
| **2026** | `Rev VS Ops cost th 2026_` | **176** | **27** | 392 | **203** | Rp 3.643.104.841,66 |
| **TOTAL** | *3 Lembar Kerja* | **699** | **112** | **1.504** | **811** | **Rp 15.048.025.983,57** |

---

## 🛠️ Skrip Pengecekan Mandiri (Python Tool)
Tersedia skrip interaktif dan otomatis di folder backend:
```bash
# Mode Cepat (Audit Seluruh Tahun Otomatis):
python backend/scripts/cek_keselarasan_excel_db.py --all

# Mode Interaktif (Pilih Menu / Tahun Tertentu):
python backend/scripts/cek_keselarasan_excel_db.py
```
Skrip ini membaca file Excel mentah dan membandingkannya berdampingan dengan isi database PostgreSQL secara real-time.

---

## 2. Audit Detail Tahun 2026 (`Rev VS Ops cost th 2026_`)

### A. Rentang Baris
* **Baris 174 - 175**: Header Section `PENGELUARAN` dan header kolom tabel.
* **Baris 176 - 390 (Single Mode)**:
  * Total baris: 215 baris.
  * **Baris valid transaksi: 176 baris** (menghasilkan tepat 176 Single Settlement).
  * **Baris dilewati (skip): 39 baris**
    * 11 Baris label/header rekening (`Transfer from BCA account`, `Transfer from BRI`, `Transfer from Mandiri`, `Giro Mandiri`, `Bisnis Mandiri`, `Valas Mandiri`, `Direct Transfer from EWI`, `From Rekening BCA Giro`, `From Rek BRI Giro`, `Biaya Admin BCA`, `Biaya Admin BRI`).
    * 28 Baris kosong/spacer antar-rekening (baris 206-207, 255-257, 261-262, 266-267, 278, 293-295, 319-322, 328-332, 385-390).
* **Baris 391 - 830 (Batch Mode)**:
  * Baris 391: Header pembatas `OPERATION COST AND OFFICE`.
  * Baris 392 - 830: **27 Grup Batch Laporan Perjalanan/Pekerjaan** (392 item pengeluaran).
  * Baris 830: Item terakhir (`Know Your Well Seminar`, Rp 1.500.000).
  * Baris 831 - 1192: **KOSONG TOTAL** (tidak ada data pengeluaran setelah baris 830).

### B. Daftar 27 Batch Settlement Tahun 2026
1. `[ID 785]` 2026-01-01 (16 item | Rp 21.737.650) : 20260109_L5A-086 Expenses 4 Januari 2026_DS
2. `[ID 786]` 2026-01-02 (13 item | Rp 26.206.800) : 20250109_MJ-161 Expenses 4 Februari 2026_DS
3. `[ID 787]` 2026-01-03 (7 item | Rp 3.435.350) : 20260127_Expenses_Job ALFA_L5A-086_PHR Zona4_Elnusa_Andi Liem
4. `[ID 788]` 2026-01-04 (7 item | Rp 4.152.100) : 20260204_Job ALFA_MJ-161_PHR zona 4_Elnusa_Andi Liem
5. `[ID 789]` 2026-01-05 (6 item | Rp 10.121.789) : 20260227_EXPENSES -Operation- trip job to Kandang Haur Timur_Andi Liem
6. `[ID 790]` 2026-01-06 (20 item | Rp 5.031.346) : 20260309_ Non Trip expenses Des 2025 - Feb 2026_AC
7. `[ID 791]` 2026-01-07 (7 item | Rp 3.323.000) : 20260309_trip ke Solo meeting presentasi with PEP zona 7_under Elnusa
8. `[ID 792]` 2026-01-08 (20 item | Rp 17.617.716) : 20260311_ Trip To Prabumulih_Job ALFA_KRG-037_PHR Z4_Elnusa_dwiyanto
9. `[ID 793]` 2026-01-09 (19 item | Rp 16.769.791) : 20260303_ Trip To Prabumulih_Job ALFA_KRG-037_PHR Z4_Elnusa_Ttitis
10. `[ID 794]` 2026-01-10 (13 item | Rp 15.416.930) : 20260313_ Trip To Prabumulih_Job ALFA_KRG-037_trip 2nd_PHR Z4_Elnusa_Ttitis
11. `[ID 795]` 2026-01-11 (13 item | Rp 10.127.251) : 20260313_ Trip To Prabumulih_Job ALFA_JRK-144 (pending job)_PHR Z4_Elnusa_Ttitis
12. `[ID 796]` 2026-01-12 (10 item | Rp 17.068.000) : 20260317_Trip to SBG-17 and BDA-08_ALFA job _Elnusa_Andi liem
13. `[ID 797]` 2026-01-13 (2 item | Rp 10.674.403) : 20260416_Exspenses Pembelian Office Chair_via Titis
14. `[ID 798]` 2026-01-14 (14 item | Rp 33.101.667) : 20260509_EXPENSES-Report-ALFA_KJH-01_ Titis Maulana Akbar
15. `[ID 799]` 2026-01-15 (6 item | Rp 7.234.470) : 20260516_Form_Expenses Job Trip to Kijahan-01_1-8May 2026-Andi Liem
16. `[ID 800]` 2026-01-16 (3 item | Rp 6.651.434) : MCU _+ Biaya Konsul tahun 2026 _dwiyanto
17. `[ID 801]` 2026-01-17 (6 item | Rp 20.000.000) : 20260519_Shipment of Baterai Tadiran SL 560 from Singapore to Jakarta Via Batam_Aneldy
18. `[ID 802]` 2026-01-18 (14 item | Rp 22.162.259) : 20260516_ALFA JRK-47i_Run2_PHR Z4_SIJAK_Titis
19. `[ID 803]` 2026-01-19 (9 item | Rp 7.476.211) : 20260526_trip ke Jirak(JRK-047i) MWT to SI Project with PHR zona 4_under SIJak
20. `[ID 804]` 2026-01-20 (8 item | Rp 23.934.400) : Trip to Non Trip Medical Mai 2026_AC
21. `[ID 805]` 2026-01-21 (33 item | Rp 30.942.625) : Shipment of Baterai Tadiran SL 560 from Singapore to Jakarta Via Batam
22. `[ID 806]` 2026-01-22 (18 item | Rp 12.936.470) : 202600623_Operation- trip job to Limau_L5A-141_PHR-Z4_Under Sijak_Andi LS_20260609
23. `[ID 807]` 2026-01-23 (13 item | Rp 15.228.384) : 20260630_Operation- trip job to Limau_L5A-234_PHR-Z4_Under Sijak_Titis Ma_20260626
24. `[ID 808]` 2026-01-24 (64 item | Rp 80.287.385) : 20260723_General Operation July 2025 - July 2026_Alan AM
25. `[ID 809]` 2026-01-25 (36 item | Rp 30.488.890) : 20260813_Operation- trip job to Limau_L5A-084_PHR-Z4_Under Sijak_Titis Ma_20260806
26. `[ID 810]` 2026-01-26 (5 item | Rp 6.827.962) : 20260824_EXPENSES-Report-ALFA_AMJ-003_Titis Maulana Akbar
27. `[ID 811]` 2026-01-27 (10 item | Rp 18.938.447) : 20260907_EXPENSES-Report-ALFA_SKW-17ST_Titis Maulana Akbar

---

## 3. Audit Detail Tahun 2025 (`Rev VS Ops cost th 2025_Final`)

### A. Rentang Baris
* **Baris 160 - 161**: Header Section `PENGELUARAN` dan header kolom tabel.
* **Baris 162 - 516 (Single Mode)**:
  * Total baris rentang: 355 baris.
  * **Baris valid transaksi: 335 baris** (menghasilkan tepat 335 Single Settlement).
  * **Baris dilewati (skip): 20 baris** (header akun bank dan spacer antar-bagian).
* **Baris 517 - 1307 (Batch Mode)**:
  * Baris 517: Header pembatas `OPERATION COST AND OFFICE`.
  * Baris 518 - 1307: **45 Grup Batch Laporan Operasional** (706 item pengeluaran).

### B. Total Pengeluaran Tahun 2025
* **Single Mode (335)**: Rp 5.416.977.463,58
* **Batch Mode (45)**: Rp 1.454.214.644,65
* **TOTAL PENGELUARAN 2025**: **Rp 6.871.192.108,23**

---

## 4. Audit Detail Tahun 2024 (`Rev VS Ops cost th 2024`)

### A. Rentang Baris
* **Baris 69 - 70**: Header Section `PENGELUARAN` dan header kolom tabel.
* **Baris 71 - 263 (Single Mode)**:
  * Total baris rentang: 193 baris.
  * **Baris valid transaksi: 188 baris** (menghasilkan tepat 188 Single Settlement).
  * **Baris dilewati (skip): 5 baris** (header rekening dan spasi kosong).
* **Baris 264 - 864 (Batch Mode)**:
  * Baris 264: Header pembatas `OPERATION COST AND OFFICE`.
  * Baris 265 - 864: **40 Grup Batch Laporan Operasional** (406 item pengeluaran).

### B. Total Pengeluaran Tahun 2024
* **Single Mode (188)**: Rp 4.004.844.640,00
* **Batch Mode (40)**: Rp 528.884.393,68
* **TOTAL PENGELUARAN 2024**: **Rp 4.533.729.033,68**

---

## 5. Temuan Masalah & Perbaikan Penting pada Database & Skrip v14

### 🔍 Masalah Kurs IDR (Currency Exchange Anomaly)
Pada ekstraksi v14 sebelumnya, ditemukan bug logika kurs:
* Pada 3 baris di tahun 2024 (ID 288, 337, 363), transaksi ber-mata uang **IDR** (Rupiah) salah mendeteksi kolom catatan kurs (misal: 16.200) sebagai pengali `currency_exchange`. Akibatnya, nilai IDR dikalikan kembali 16.200x lipat dan membuat total pengeluaran 2024 membengkak fiktif hingga **Rp 353 Miliar**.
* Pada 12 baris di tahun 2025 (ID 1349 - 1353, dll), kolom nomor urut `#` (2, 3, 4, 5, 6) salah terdeteksi sebagai `RATE` dan mengalikan nominal IDR.

### ✅ Solusi & Status Perbaikan
1. **Perbaikan Skrip Migrasi (`generate_hybrid_migration_v14.py`)**:
   Ditambahkan proteksi absolut:
   ```python
   rat_val = to_num_cell(ws_f, ws_v, r, col_rate, 1.0)
   calc_rat = rat_val if rat_val and rat_val > 0 else 1.0
   if cur in ["IDR", "-", ""]:
       calc_rat = 1.0
   rat = to_sql_val(calc_rat)
   ```
   Setiap transaksi ber-mata uang IDR atau kosong dipaksa berkurs `1.0`.
2. **Perbaikan Database (PostgreSQL)**:
   Seluruh 15 baris yang terdampak di database sudah di-update ke `currency_exchange = 1.0` dan nilai `disbursed_amount` pada settlement terkait telah dihitung ulang secara sinkron:
   * **Settlement ID 200**: Rp 4.544.420,00 (sebelumnya Rp 39 Miliar)
   * **Settlement ID 207**: Rp 22.469.994,00 (sebelumnya Rp 183 Miliar)
   * **Settlement ID 211**: Rp 12.338.300,00 (sebelumnya Rp 126 Miliar)
   * **Settlement ID 598**: Rp 10.024.601,00
3. **Integritas Akhir**:
   * Selisih Settlement vs Rincian Expense: **0 (Nol)**
   * Transaksi IDR dengan kurs != 1.0: **0 (Nol)**
   * Transaksi tanpa subkategori: **0 (Nol)**
