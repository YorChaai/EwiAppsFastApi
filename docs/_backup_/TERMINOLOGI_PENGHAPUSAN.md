# Terminologi Penghapusan Data (Settlement & Kasbon)

Dokumen ini menjelaskan perbedaan antara menghapus dokumen utama dan menghapus item rincian untuk mempermudah komunikasi pengembangan.

## 1. Hapus Dokumen Utama (Settlement / Kasbon)
**Lokasi:** Halaman Dashboard, Halaman List Settlement, atau Halaman List Kasbon.
**Aksi:** Menyeleksi satu atau lebih dokumen dari daftar, lalu menekan tombol hapus (ikon tong sampah).

- **Analogi:** Membuang satu map folder penuh berisi banyak kuitansi ke tempat sampah.
- **Efek:** Seluruh dokumen beserta rincian di dalamnya akan terhapus total dari sistem.
- **Aturan Keamanan:** 
    - **Manager:** Bisa menghapus dokumen dalam status apa pun (kecuali yang sudah difinalisasi secara finansial).
    - **Staff/Mitra:** **HANYA bisa menghapus dokumen berstatus DRAFT**. Jika sudah disubmit atau diapprove, Staff tidak bisa menghapus dokumen utama ini.
- **Solusi jika ingin menghapus:** Jika dokumen sudah disubmit, Staff harus meminta Manager untuk me-reject atau mengubah status ke Revision (Draft) terlebih dahulu.

## 2. Hapus Item Rincian (Expense / Item Kasbon)
**Lokasi:** Di dalam halaman DETAIL Settlement atau Kasbon (Tabel Rincian).
**Aksi:** Menekan tombol hapus pada salah satu baris di dalam tabel rincian pengeluaran.

- **Analogi:** Membuka map folder, lalu mengambil satu lembar kuitansi saja untuk dibuang. Map utamanya tetap ada.
- **Efek:** Hanya satu baris pengeluaran itu saja yang terhapus. Total nilai dokumen utama akan otomatis terupdate.
- **Aturan Keamanan:** Bergantung pada status dokumen utama. Jika dokumen utama sudah dikunci oleh Manager, rincian tidak bisa dihapus kecuali statusnya dikembalikan ke Draft/Revision.

---

**Catatan Penting:**
Pastikan selalu mengecek status dokumen sebelum melakukan penghapusan. Jika sistem menolak, periksa apakah Anda (sebagai Staff/Mitra) mencoba menghapus dokumen yang statusnya sudah bukan lagi Draft.
