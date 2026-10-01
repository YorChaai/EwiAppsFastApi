# Rencana Implementasi: Unifikasi Kasbon (Advance) & Settlement

Dokumen ini merinci langkah-langkah teknis untuk menyatukan logika dan tampilan Kasbon dan Settlement agar konsisten, profesional, dan akurat secara akuntansi.

---

## 1. Perubahan Filosofi & Alur Kerja
*   **Filosofi:** Kasbon dan Settlement adalah sama-sama **Pengeluaran**. Perbedaannya hanya pada waktu pengiriman dana (Kasbon di awal, Settlement di akhir/reimbursement).
*   **Alur Baru:** Kasbon tidak lagi perlu disalin ke Settlement. Kasbon akan diselesaikan (Final Approved) langsung di layarnya sendiri.
*   **Output:** Semua Kasbon yang sudah "Approved Final" akan otomatis masuk ke **Tabel 4 (Pengeluaran)** dan **Tabel 6 (Bank Status)** di Laporan Tahunan.

---

## 2. Perubahan Frontend (UI/UX)

### A. Tampilan List (Dashboard & Semua Kasbon)
*   **Label Identitas:** Menambahkan teks label "Kasbon" atau "Settlement" di sisi kanan setiap kartu pengajuan (dekat status) agar user mudah membedakan jenis transaksi dalam satu daftar.
*   **Konsistensi Desain:** Menyamakan desain kartu antara daftar Settlement dan daftar Kasbon.

### B. Upgrade Layar Detail (Mirroring)
Strategi utama adalah membuat `advance_detail_screen.dart` menjadi "kembaran" `settlement_detail_screen.dart`.

1.  **4 Kartu Ringkasan (Summary Cards):**
    *   **Total:** Total pengajuan (Draft + Approved).
    *   **Approved:** Total yang disetujui Manager.
    *   **Dana Cair (Reimbursement):** Jumlah uang yang harus dikirim Bank ke User.
    *   **Item:** Jumlah total item (contoh: "12 Item").
2.  **Pembersihan Tabel Utama:**
    *   Menghapus kolom **"Sumber"** di tabel daftar item (tabel atas) karena sudah tidak relevan di sana.
3.  **Tabel Verifikasi Dana (Bawah):**
    *   Mengimplementasikan tabel konsolidasi (1 baris) di bagian bawah untuk pemilihan Bank oleh Finance.
    *   Tombol **"Approved Final"** untuk Manager hanya aktif jika Bank sudah dipilih.
4.  **Pembersihan Fitur Lama:**
    *   Menghapus tombol **"Salin ke Settlement"** pada layar Kasbon.

---

## 3. Perubahan Backend (API & Laporan)

### A. Endpoint Baru untuk Kasbon
*   `POST /api/advances/<id>/final_approve`: Mencatat transaksi ke `BankTransaction` dan mengubah status menjadi `completed`.
*   `PUT /api/advances/<id>/items/bulk`: Memungkinkan Finance memilih sumber dana (Bank) untuk banyak item sekaligus.

### B. Penyatuan Laporan Tahunan
*   Update `annual.py`: Mengubah query **Tabel 4 (Expenses)** agar menarik data dari `Settlement` DAN `Advance` yang berstatus `approved/completed`.
*   Update **Tabel 6 (Bank Status)**: Memastikan mutasi keluar dari Kasbon tercatat otomatis saat Final Approve.

---

## 4. Langkah Kerja Teknis

1.  **Fase 1: Backend & Database**
    *   Implementasi endpoint `final_approve` di `advances.py`.
    *   Update logika query laporan tahunan di `annual.py`.
2.  **Fase 2: Frontend Service & Provider**
    *   Update `ApiService` dan `AdvanceProvider` untuk mendukung bulk update dan final approval.
3.  **Fase 3: Unifikasi UI Detail**
    *   Update `settlement_detail_screen.dart` (tambah kartu ke-4, hapus kolom Sumber).
    *   Rewrite `advance_detail_screen.dart` dengan template dari Settlement.
4.  **Fase 4: List View Enhancement**
    *   Update kartu list di `dashboard_screen.dart` dan `advances_screen.dart` untuk menampilkan label jenis transaksi.

---

## 5. Verifikasi
*   Memastikan Kasbon bisa diselesaikan sampai status "Completed" dan muncul di Laporan Tahunan.
*   Memastikan saldo bank di Tabel 6 berkurang sesuai dana Kasbon yang cair.
*   Memastikan tampilan di Mobile dan Desktop tetap responsif dan rapi.
