# Rencana Implementasi: Revisi Asset Register & Rekonsiliasi Pajak 2026 (LENGKAP)

Dokumen ini adalah panduan tunggal pengerjaan revisi yang menggabungkan kebutuhan dari `assetregisterrevisi.md`, gambar whiteboard, dan hasil diskusi Meeting 3.

---

## 1. Topik Utama: Asset Register & NDPV (Net Book Value)

### Permasalahan
*   Depresiasi belum mendukung biaya perbaikan (Repair) yang menambah nilai aset.
*   Masa depresiasi kaku (tidak bisa fleksibel 5-15 tahun untuk mengatur profit).
*   Belum ada tabel NDPV (Net Price Asset) yang mendetailkan nilai aset per bulan.

### Kebutuhan Bisnis (Meeting 3 & Whiteboard)
*   **Istilah:** Menggunakan "Nilai Sisa" atau **NDPV** (Net Depreciated Purchase Value).
*   **Capitalization:** Biaya "Bengkel" menambah nilai barang (NBV melompat naik) di tengah masa manfaat (sesuai coretan 10jt di papan tulis).
*   **Detail Bulanan:** Tabel rincian harus per bulan (YYYY-MM) sesuai coretan "1M x 1/60".
*   **Valuasi Proyeksi:** Mampu memprediksi kekayaan fisik perusahaan di masa depan (2, 5, hingga 15 tahun lagi).

### Solusi & Perubahan Koding
1.  **Link Expense ke Asset:** Menambahkan field `asset_id` pada model `Expense` dan `AdvanceItem`.
2.  **Logika Capitalization:** Mengubah fungsi `_calculate_asset_depreciation` untuk menjumlahkan `Purchase Price + Total Repair Expenses`.
3.  **Monthly Engine:** Mengubah rincian dari Tahunan menjadi **Bulanan** (Format YYYY-MM).
4.  **Multi-Asset Recap:** Tombol di Header untuk melihat TOTAL kekayaan seluruh barang per bulan.

---

## 2. Topik Utama: Rekonsiliasi Pajak (Tabel 4)

### Permasalahan
*   PPH 23 (2%) dari pemasukan diambil secara total (gelondongan), berisiko audit jika "lebih bayar" (restitusi).
*   Strategi perusahaan adalah memilih transaksi 2% secara manual agar totalnya sedikit di bawah utang pajak final.
*   Tarif PPH Badan harus fleksibel (11%, 22%, 50%).

### Kebutuhan Bisnis (Meeting 3)
*   **Tujuan:** Menghindari audit negara dengan strategi "Kurang Bayar Sedikit".
*   **Mekanisme:** Memilih manual transaksi PPH 23 (potongan 2% dari klien) untuk menutupi PPH Badan (untung rugi perusahaan).
*   **Audit Avoidance:** Total pilihan tidak boleh melebihi utang pajak (restitusi = audit).

### Solusi & Perubahan Koding
1.  **Manual Tagging PPH 23:** Menambahkan kolom `is_selected_for_tax_offset` (boolean) pada tabel `Revenue`.
2.  **Pajak Picker UI:** Dashboard "Pajak Final" di Annual Report dengan Checkbox untuk memilih transaksi A, B, C...
3.  **Variable Corporate Tax:** Menggunakan `corporate_tax_rate` (11/22/50%) sesuai setting user.
4.  **Live Counter:** Menampilkan "Kurang Bayar" (Utang - PPH Terpilih) secara real-time untuk memastikan status AMAN.

---

## 3. Daftar Tugas (Task List)

| No | Task | Deskripsi Teknis | Status |
| :--- | :--- | :--- | :--- |
| **1** | **Database Schema Update** | Tambah `asset_id` di Expense/AdvanceItem. Tambah `tax_offset` di Revenue. | ✅ Completed |
| **2** | **Asset Repair Logic** | Implementasi capitalization biaya bengkel ke basis nilai aset. | ✅ Completed |
| **3** | **Monthly NDPV Engine** | Ubah backend breakdown dari Tahunan ke **Bulanan**. | ✅ Completed |
| **4** | **3-Mode Header UI** | Input Thn/Bln (Mode 2) & YYYY-MM-DD (Mode 3) dengan Smart Sync. | ✅ Completed |
| **5** | **Multi-Asset Recap UI** | Tabel global gabungan nilai sisa seluruh aset per bulan. | ✅ Completed |
| **6** | **Tax Reconciliation UI** | Fitur pilih transaksi PPH 23 (A, B, C...) di Laporan Tabel 4. | ⏳ Pending |
| **7** | **Final Verification** | Simulasi "Garis Waktu" (Papan Tulis) & Simulasi "Net Off" Pajak. | ⏳ Pending |

---

## 4. Strategi Testing & Validasi

1.  **Simulasi Whiteboard:** Input Aset 1M, masa 60 bln. Di bulan 30 tambah Bengkel 10jt. Cek apakah Nilai Sisa naik 10jt dan menyusut kembali dari titik tersebut.
2.  **Simulasi Audit:** Profit 500jt (Tax 110jt). Pilih transaksi PPH 23 total 109jt. Pastikan sistem melaporkan "Kurang Bayar 1jt" (Status: AMAN).
3.  **Simulasi Navigasi:** Pindah menu dan pastikan filter tanggal di Header tidak hilang.

---
*Dokumen ini adalah panduan tunggal pengerjaan revisi Asset & Pajak 2026.*
