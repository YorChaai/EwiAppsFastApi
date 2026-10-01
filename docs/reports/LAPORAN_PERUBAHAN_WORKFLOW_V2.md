# Laporan Perubahan Alur Kerja & Perbaikan Bug (Mei 2026)

Dokumen ini menjelaskan secara mendetail perubahan teknis yang dilakukan pada sistem Kasbon (Advance) dan Settlement untuk meningkatkan akurasi data, fleksibilitas hak akses Manager, serta implementasi alur kerja (workflow) pengembalian dana yang lebih formal.

## 1. Perbaikan Bug Input Mata Uang (Currency Bug)
**Masalah:** 
Pengguna melaporkan bahwa saat mengetik angka ribuan (misal: 1111), input otomatis berubah menjadi desimal (1.11). Hal ini disebabkan oleh `CurrencyInputFormatter` yang salah menginterpretasikan titik (`.`) sebagai pemisah desimal, padahal dalam locale `id_ID`, titik adalah pemisah ribuan yang dimasukkan secara otomatis oleh formatter itu sendiri.

**Solusi:**
- Memperbarui `CurrencyInputFormatter` agar hanya menganggap koma (`,`) sebagai pemisah desimal.
- Titik (`.`) sekarang dianggap sepenuhnya sebagai pemisah ribuan dan akan diabaikan saat perhitungan angka.
- Memperbaiki fungsi pembantu `_toDouble()` di seluruh aplikasi untuk memastikan angka seperti `1.234` dibaca sebagai **seribu dua ratus tiga puluh empat**, bukan satu koma sekian.

## 2. Ekspansi Hak Akses Manager (Role-Based Permissions)
**Masalah:**
Sebelumnya, Manager hanya bisa menyetujui (Approve) atau menolak (Reject) item, namun tidak bisa mengedit informasi dasar (Header) jika dokumen tersebut dibuat oleh Staff. Hal ini menghambat operasional jika ada kesalahan ketik kecil yang seharusnya bisa langsung diperbaiki oleh Manager.

**Solusi:**
- Mengubah logika `canEditHeader` dan `canEditItems` pada layar detail. Kini, Manager memiliki hak akses penuh untuk mengedit judul, deskripsi, kategori, dan rincian item pada dokumen siapapun, selama dokumen tersebut belum berstatus *Final Approved*.
- Staff tetap dibatasi hanya bisa melihat dan mengelola dokumen miliknya sendiri (keamanan data tetap terjaga di sisi Backend).

## 3. Implementasi Workflow Baru Tabel 3 (Pengembalian Dana)
**Masalah:**
Tabel 3 sebelumnya hanya bisa diisi oleh Manager. Tidak ada mekanisme bagi Staff untuk secara formal melaporkan bahwa mereka telah mentransfer balik sisa dana. Selain itu, tidak ada fitur komentar jika data pengembalian yang diinput salah.

**Solusi:**
Dibuatlah sistem **"Draft Khusus Tabel 3"** yang memungkinkan interaksi dua arah:
- **Staff Interaction:** Staff sekarang bisa membuka form edit di Tabel 3, memasukkan nominal kembalian, bank, deskripsi pengembalian, dan mengunggah bukti transfer.
- **Tombol Submit (stbl3):** Menambahkan tombol "Submit Pengembalian" bagi Staff untuk menandai bahwa proses pengembalian dana dari sisi mereka telah selesai.
- **Manager Interaction (Reject & Comment):** Manager kini memiliki tombol **Reject (Silang)** khusus Tabel 3. Jika data salah, Manager bisa memberikan komentar alasan penolakan.
- **Sistem Checklist:** Jika Manager menolak, Staff akan melihat daftar komentar Manager di Tabel 3. Staff wajib memperbaiki data dan mencentang (resolve) komentar tersebut sebelum bisa klik Submit kembali.
- **Status Independent:** Status Tabel 3 (`PENDING`, `SUBMITTED`, `REJECTED`, `APPROVED`) berjalan secara independen tanpa harus mengembalikan seluruh dokumen Kasbon/Settlement ke status Draft awal, sehingga data di Tabel 1 dan Tabel 2 yang sudah benar tidak terganggu.

## 4. Perubahan Teknis Lainnya
- **Backend:** Menambahkan kolom `return_status` dan `return_notes` pada model database. Membuat endpoint baru untuk menangani transisi status pengembalian.
- **Frontend:** Memperbarui `api_service.dart`, `AdvanceProvider`, dan `SettlementProvider` untuk mendukung fungsi-fungsi baru tersebut.
- **Keamanan:** Menambahkan mekanisme *locking* (`_isSaving`) untuk mencegah pengiriman data ganda jika pengguna menekan tombol berkali-kali secara cepat.

Dengan perubahan ini, aplikasi sekarang jauh lebih stabil dalam menangani angka besar dan memberikan alur kerja yang lebih transparan antara Staff dan Manager dalam hal pengelolaan keuangan perusahaan.
