# Panduan & Logika Alur Settlement (Pertanggungjawaban Biaya)

Dokumen ini menjelaskan spesifikasi lengkap alur bisnis, mekanisme perhitungan, serta keterkaitan antara **Tabel 1 (Rincian Item)**, **Tabel 2 (Pengiriman Dana / Reimbursement)**, **Tabel 3 (Pengembalian Dana)**, dan **Dompet Kasbon (Per-Bank Balance)** pada sistem Settlement.

---

## 1. Konsep Dasar & Sumber Dana

Dalam setiap item pengeluaran di **Tabel 1**, pengguna memilih **Sumber Dana**:
1. **Dompet Kasbon Tertentu (misal: Mandiri, BCA, BRI, dsb.)**: Pengeluaran dibayar menggunakan uang muka (kasbon) yang sebelumnya sudah dicairkan ke karyawan dari bank tersebut.
2. **Tanpa Kasbon / Reimbursement (`-` / `Reimbursement`)**: Pengeluaran dibayar menggunakan uang pribadi karyawan (tanpa kasbon).

---

## 2. Empat (4) Skenario Utama Settlement

```
                              ┌──────────────────────────────────┐
                              │     Input Item Pengeluaran       │
                              │            (Tabel 1)             │
                              └────────────────┬─────────────────┘
                                               │
                                               ▼
                        ┌──────────────────────────────────────────────┐
                        │ Apakah Item Memilih Sumber Dana Kasbon Bank? │
                        └──────────────┬────────────────┬──────────────┘
                                       │                │
                                   TIDAK                YA
                                       │                │
                                       │                ▼
                                       │    ┌──────────────────────────────────────┐
                                       │    │ Bandingkan Pengeluaran vs Saldo Bank │
                                       │    └───────┬──────────────┬───────────────┘
                                       │            │              │
                                       │    Expense > Kasbon   Expense <= Kasbon
                                       │            │              │
                                       ▼            ▼              ▼
                              ┌────────────────────────┐     ┌──────────────────────┐
                              │ Skenario 4 & 1         │     │ Skenario 2 & 3       │
                              │ Reimbursement Murni    │     │ Kasbon Pas / Sisa    │
                              │ atau Kasbon Kurang     │     │                      │
                              │ ---------------------- │     │ -------------------- │
                              │ Tabel 2 MUNCUL         │     │ Tabel 2 TERSEMBUNYI  │
                              └────────────────────────┘     └──────────────────────┘
```

---

### Skenario 1: Kasbon Kurang / Kurang Bayar Hutang (*Expense > Kasbon Bank Terkait*)

* **Kondisi:** Karyawan memiliki Kasbon Bank A sebesar **Rp 10.000**, namun pengeluaran riil di lapangan sebesar **Rp 15.000** dengan Sumber Dana memilih **Bank A**.
* **Tabel 1 (Rincian Item):**
  * Diinput pengeluaran Rp 15.000 (Sumber Dana: Bank A).
* **Perhitungan Dompet Kasbon:**
  * Hutang Kasbon Bank A dipotong maksimal sebesar saldo kasbonnya: $\text{Rp } 10.000 \rightarrow \mathbf{\text{Sisa Hutang Bank A = Rp 0}}$.
  * **PENTING (Isolasi Antar Bank):** Saldo kasbon bank lain (misal Bank B Rp 9.000) **tidak boleh terpotong sama sekali**.
  * Selisih lebih pengeluaran: $\text{Rp } 15.000 - \text{Rp } 10.000 = \mathbf{\text{Rp } 5.000}$ dialokasikan sebagai **Reimbursement (Kurang Bayar)**.
* **Tabel 2 (Pengiriman Dana / Reimbursement):**
  * **WAJIB MUNCUL** dengan nominal **Rp 5.000** (selisih uang pribadi yang terpakai).
  * Manager memilih rekening bank kantor pembayar, upload bukti transfer reimbursement, lalu klik **Setujui (Approve)**.
* **Tabel 3 (Pengembalian Dana):**
  * **TIDAK MUNCUL / TERSEMBUNYI**.
* **Final Approval:**
  * Tombol persetujuan akhir (*Complete*) aktif setelah Tabel 2 di-approve. Hutang kasbon Bank A lunas, dan kas kantor berkurang Rp 5.000.

---

### Skenario 2: Kasbon Pas / Hutang Lunas Pas (*Expense == Kasbon Bank Terkait*)

* **Kondisi:** Karyawan memiliki Kasbon Bank A sebesar **Rp 10.000**, dan pengeluaran riil persis **Rp 10.000** (Sumber Dana: Bank A).
* **Tabel 1 (Rincian Item):**
  * Diinput pengeluaran Rp 10.000 (Sumber Dana: Bank A).
* **Perhitungan Dompet Kasbon:**
  * Hutang Kasbon Bank A terpotong lunas: $\text{Rp } 10.000 \rightarrow \mathbf{\text{Rp 0}}$.
* **Tabel 2 (Pengiriman Dana):**
  * **TIDAK MUNCUL / OTOMATIS TERSEMBUNYI**, karena kantor tidak perlu mentransfer dana tambahan ke karyawan.
* **Tabel 3 (Pengembalian Dana):**
  * **TIDAK MUNCUL**.
* **Final Approval:**
  * Tombol *Final Approve* langsung aktif begitu Tabel 1 di-approve manager. Hutang kasbon langsung selesai.

---

### Skenario 3: Kelebihan Kasbon / Sisa Kasbon (*Expense < Kasbon Bank Terkait*)

* **Kondisi:** Karyawan memiliki Kasbon Bank A sebesar **Rp 10.000**, namun pengeluaran riil hanya **Rp 6.000** (Sumber Dana: Bank A).
* **Tabel 1 (Rincian Item):**
  * Diinput pengeluaran Rp 6.000 (Sumber Dana: Bank A).
* **Perhitungan Dompet Kasbon:**
  * Hutang Kasbon Bank A terpotong Rp 6.000 $\rightarrow$ **Sisa Hutang Bank A = Rp 4.000**.
* **Tabel 2 (Pengiriman Dana):**
  * **TIDAK MUNCUL** (karena kantor tidak berhutang ke karyawan).
* **Penyelesaian Sisa Kasbon Rp 4.000 (Dua Pilihan Flow):**
  * **Opsi A (Sistem Plafon / Hutang Berjalan):** Sisa Rp 4.000 tetap tinggal di dompet kasbon Bank A karyawan untuk digunakan pada laporan settlement berikutnya. Dokumen settlement bisa langsung di-Final Approve.
  * **Opsi B (Pengembalian Tunai / Tabel 3):** Karyawan mentransfer balik sisa Rp 4.000 ke rekening kantor, mengisi **Tabel 3 (Pengembalian Dana)** dan mengunggah bukti transfer. Begitu Tabel 3 disetujui, sisa hutang Bank A menjadi Rp 0.

---

### Skenario 4: Reimbursement Murni / Tanpa Kasbon (*Uang Pribadi*)

* **Kondisi:** Karyawan mengeluarkan uang pribadi sebesar **Rp 15.000** tanpa menggunakan kasbon.
* **Tabel 1 (Rincian Item):**
  * Diinput pengeluaran Rp 15.000 (Sumber Dana: `-` / `Reimbursement`).
* **Perhitungan Dompet Kasbon:**
  * Tidak ada kasbon yang dipotong (Dompet Kasbon / Hutang karyawan tidak berubah).
  * Perusahaan berhutang penuh **Rp 15.000** kepada karyawan.
* **Tabel 2 (Pengiriman Dana):**
  * **WAJIB MUNCUL PENUH** dengan nominal **Rp 15.000**.
  * Manager memilih rekening kantor pembayar, upload bukti transfer Rp 15.000, lalu menyetujui Tabel 2.
* **Tabel 3 (Pengembalian Dana):**
  * **TIDAK MUNCUL**.
* **Final Approval:**
  * Setelah Tabel 2 disetujui, tombol *Complete* ditekan $\rightarrow$ Kas kantor keluar Rp 15.000 mengganti uang karyawan.

---

## 3. Matriks Perbandingan Antar Skenario

| Parameter | Skenario 1 (Kasbon Kurang) | Skenario 2 (Kasbon Pas) | Skenario 3 (Kasbon Sisa) | Skenario 4 (Reimbursement Murni) |
| :--- | :--- | :--- | :--- | :--- |
| **Sumber Dana Tabel 1** | Kasbon Bank A | Kasbon Bank A | Kasbon Bank A | `-` / Reimbursement |
| **Nominal Expense vs Kasbon** | Expense > Kasbon | Expense == Kasbon | Expense < Kasbon | Expense Murni |
| **Pemotongan Kasbon** | Sebesar saldo Bank A | Lunas Bank A | Sebesar nominal expense | Rp 0 (Tidak ada kasbon) |
| **Efek ke Bank Lain (Bank B)** | Utuh (Tidak terpotong) | Utuh | Utuh | Utuh |
| **Status Tabel 2** | **MUNCUL (Nominal Selisih)** | **TERSEMBUNYI** | **TERSEMBUNYI** | **MUNCUL (Nominal Penuh)** |
| **Status Tabel 3** | Tersembunyi | Tersembunyi | Opsional (Jika setor tunai) | Tersembunyi |
| **Syarat Final Approve** | Tabel 1 & Tabel 2 Approved | Tabel 1 Approved | Tabel 1 Approved (atau +T3) | Tabel 1 & Tabel 2 Approved |

---

## 4. Aturan Integritas Data Sistem (System Invariants)

1. **Prinsip Isolasi Bank (*No Cross-Bank Spillover*):**
   * Pengeluaran yang dibebankan ke Bank X tidak boleh memotong saldo kasbon Bank Y, meskipun total hutang global mencukupi.
2. **Kalkulasi Reimbursement Presisi:**
   * $\text{Nominal Tabel 2} = \text{Pengeluaran Reimbursement Murni} + \sum \max(0, \text{Pengeluaran Bank}_i - \text{Saldo Kasbon Bank}_i)$.
3. **Penyimpanan Sumber Dana Tabel 2:**
   * Bank pembayar yang dipilih di Tabel 2 tidak boleh di-overwrite secara sepihak oleh backend menjadi `"Lain-lainnya"` atau `None`.
4. **Pencegahan Overwrite Nominal Final:**
   * Saat Final Approval, backend tidak boleh menimpa nilai `disbursed_amount` dengan `approved_amount` jika transaksi merupakan kombinasi kasbon dan reimbursement.
