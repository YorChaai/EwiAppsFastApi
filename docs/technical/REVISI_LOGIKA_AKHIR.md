# Addendum: Revisi Final Logika & Alur Sistem

Dokumen ini berisi penyesuaian terakhir berdasarkan diskusi mendalam untuk memastikan sistem memiliki fleksibilitas tinggi dan data yang akurat 100%.

---

## 1. Penegasan Logika Mata Uang (USD/IDR)
Untuk setiap inputan yang menggunakan mata uang asing (USD), sistem akan tetap menggunakan logika yang sudah ada:
*   **Input:** User memasukkan `Amount (USD)` dan `Kurs/Rate (ke IDR)`.
*   **Proses:** Sistem otomatis menghitung `Total IDR = Amount * Kurs`.
*   **Laporan:** Semua angka yang masuk ke Laporan Tahunan (Tabel 1-7) akan menggunakan nilai **IDR** hasil konversi tersebut agar perhitungan total (Sum) tetap akurat.

---

## 2. Kelengkapan Laba Rugi (Input PPh 29 & Pendapatan Lain)
Agar Laba Rugi di **Sheet 2** sesuai dengan standar perusahaan, kita menambahkan dua inputan baru di menu **Input Neraca / Modal**:
*   **Pendapatan Lain-lain:** Untuk mencatat uang masuk yang tidak terduga atau di luar proyek utama.
*   **Corporate Tax (PPh 29):** Untuk mencatat pembayaran pajak badan di akhir tahun.
*   **Tujuan:** Agar nilai "Laba Bersih Setelah Pajak" di Laporan Tahunan muncul secara otomatis dan akurat.

---

## 3. Fitur "Manager Override" (Edit Data Final)
Untuk mempermudah perbaikan jika terjadi salah input oleh Finance atau User, Manager diberikan akses khusus:

### Akses Edit pada Status "Approved Final":
Meskipun data sudah terkunci untuk user biasa, Manager dapat mengubah kolom berikut di layar Settlement/Kasbon Detail:
1.  **Sumber Dana (Bank):** Jika salah pilih bank saat pengiriman dana.
2.  **Sub-Kategori:** Jika terjadi salah pengelompokan biaya.
3.  **Deskripsi:** Jika ada typo atau keterangan yang kurang jelas.
4.  **Status:** Manager bisa mengembalikan status dari "Approved Final" ke "Draft" jika diperlukan perbaikan total.

### Keuntungan:
*   Proses perbaikan data menjadi lebih cepat tanpa harus menghapus dan input ulang dari nol.
*   Manager memiliki kontrol penuh atas integritas data bank dan kategori.

---

## 4. Kesimpulan Akhir Alur Kerja (Workflow)

1.  **Input:** User/Finance input data (dengan kurs jika USD).
2.  **Verification:** Finance memilih Bank Sumber Dana.
3.  **Approval:** Manager menyetujui (Status: Approved Final).
4.  **Correction:** Jika ada salah, Manager bisa langsung edit di tempat (Override).
5.  **Reporting:** Data otomatis masuk ke Sheet 1, 2, atau 3 sesuai kategorinya.

> [!IMPORTANT]
> Dengan adanya fitur **Manager Override**, Dio tidak perlu khawatir sistem menjadi terlalu kaku. Kesalahan input adalah hal manusiawi, dan sistem ini sudah siap untuk menanganinya dengan mudah lewat akun Manager.
