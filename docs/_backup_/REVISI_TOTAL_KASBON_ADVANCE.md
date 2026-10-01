# Master Plan: Revisi Total Fitur Kasbon (Advance)

Dokumen ini merinci rencana penyatuan logika Kasbon dan Settlement agar sesuai dengan standar akuntansi dan mempermudah pelaporan.

---

## 1. Masalah Utama & Perubahan Filosofi
*   **Masalah:** Fitur Kasbon saat ini "salah arah" dan terlalu berbeda dengan Settlement.
*   **Filosofi Baru:** Kasbon dan Settlement adalah dua sisi dari koin yang sama (Sama-sama Pengeluaran).
    *   **Settlement:** Talangi pakai duit pribadi ➔ Perusahaan ganti.
    *   **Kasbon (Advance):** Minta duit perusahaan dulu ➔ Baru dipakai belanja.
*   **Target:** Keduanya harus masuk ke **Tabel 4 (Pengeluaran)** dan **Tabel 6 (Bank Status)** dengan format yang sama.

---

## 2. Penyatuan UI & Logika
Daripada memiliki dua sistem yang berbeda, kita akan menyamakan alur Kasbon dengan Settlement:

### A. Form Buat Baru (Mode Selection)
Saat user klik tombol "Tambah", akan muncul pilihan:
1.  **Settlement (Reimbursement):** Mengganti uang pribadi yang sudah terpakai.
2.  **Kasbon (Cash Advance):** Meminta dana di muka untuk keperluan tugas.

### B. UI Detail (Menyamakan dengan Settlement)
Kita akan menghapus file Kasbon yang lama dan menggunakan template dari Settlement:
*   **Tabel Item:** Sama (Tanggal, Deskripsi, Amount, Evidence).
*   **Tabel Pengiriman Dana (Bawah):** SAMA PERSIS. 
    *   Muncul box "Belum di-approve" jika status masih draft.
    *   Muncul tabel "Pengiriman Dana" setelah Manager approve.
    *   Finance memilih **Sumber Dana (Bank)**.
    *   Manager melakukan **Approved Final** untuk mengunci data.

---

## 3. Alur Data ke Laporan (Tabel 6 & Tabel 4)
*   **Otomatisasi:** Begitu status menjadi "Approved Final", data Kasbon langsung masuk ke Laporan Tahunan sebagai pengeluaran resmi.
*   **Sinkronisasi:** Uang yang dikirim dari Bank (misal: BCA) untuk Kasbon akan muncul di **Tabel 6 (Bank Status)** sebagai mutasi keluar.

---

## 4. Perbaikan pada Setting Deadline
Fitur deadline juga harus diperbaiki agar:
*   Jika Kasbon sudah cair tapi user belum mengupload bukti (Evidence) dalam waktu tertentu, sistem akan memberi peringatan (Notification).

---

## 5. Rencana Teknis (Koding)
*   **Refactor:** Meng-copy logika `settlement_detail_screen.dart` ke `advance_detail_screen.dart`.
*   **Hapus:** Menghapus file-file Kasbon yang tidak perlu (Clean up).
*   **Backend:** Menyatukan tabel database atau memastikan kolom-kolomnya identik agar query laporan tahunan menjadi sangat mudah (Cukup satu query untuk tarik data Settlement + Kasbon).

> [!IMPORTANT]
> **Kesimpulan:** 
> Dio tidak perlu pusing lagi dengan dua fitur yang berbeda. Kita akan buat Kasbon menjadi "kembaran" Settlement. Ini akan menghemat waktu koding Dio dan membuat laporan Om Anda menjadi sangat akurat.


#baru

# Master Plan: Revisi Total Fitur Kasbon (Advance)

Dokumen ini merinci rencana penyatuan logika Kasbon dan Settlement serta perombakan UI Detail untuk kemudahan verifikasi dana.

---

## 1. Penyatuan Filosofi
*   **Settlement:** Pakai duit pribadi ➔ Ganti rugi (Reimbursement).
*   **Kasbon (Advance):** Minta duit depan ➔ Pengiriman dana awal (Cash Advance).
*   **Output:** Keduanya wajib masuk ke Tabel 4 (Pengeluaran) dan Tabel 6 (Bank Status).

---

## 2. Perubahan UI Detail (Unifikasi Kasbon & Settlement)

### A. Summary Cards (Upgrade ke 4 Kartu)
Bagian atas layar rincian sekarang menampilkan 4 informasi ringkas:
1.  **Total:** Total nilai pengajuan (Draft + Approved).
2.  **Approved:** Total nilai item yang sudah disetujui Manager.
3.  **Reimbursement:** Total dana yang wajib dikirim oleh Finance ke User (Dana cair).
4.  **Expense:** Jumlah total item yang ada dalam batch tersebut (Contoh: "15 Item").

### B. Pembersihan Tabel Utama (Item List)
*   **Hapus Kolom "Sumber":** Kolom "Sumber" di tabel rincian belanja (tabel atas) harus dihapus karena sudah tidak relevan di sana.
*   **Tujuan:** Agar tampilan tabel lebih bersih dan fokus pada deskripsi belanja dan jumlah uang.

### C. Seksi Verifikasi Dana Dinamis (Bagian Bawah)
Bagian bawah layar akan berubah secara otomatis tergantung status item:

1.  **Kondisi 1: Belum Ada Item Approved**
    *   Tampilkan kotak pesan simpel: **“Belum semua item di-approve.”**
    *   Sembunyikan tabel pengiriman dana agar UI tidak penuh/berantakan.
2.  **Kondisi 2: Minimal Satu Item Approved**
    *   Kotak pesan hilang, ganti menjadi **Tabel Pengiriman Dana** secara otomatis.
    *   **Struktur Kolom Tabel Bawah:** No, Tanggal, Sumber Dana, Deskripsi, Amount, Evidence, Status, dan Aksi.
    *   Data di tabel ini otomatis sinkron dengan item yang sudah di-approve di atas (Tidak perlu input manual lagi).

---

## 3. Alur Verifikasi & Validasi Akhir
*   **Pilihan Bank:** Finance wajib memilih **Sumber Dana (Bank)** pada tabel bawah.
*   **Kunci Verifikasi:** Tombol centang/verifikasi Manager tidak akan muncul selama kolom Sumber Dana masih kosong.
*   **Approved Final:** Setelah semua data terisi dan dicentang, tombol "Approved Final" baru aktif. Klik tombol ini akan otomatis memotong saldo di Tabel 6 (Bank Status).

---

## 4. Strategi Implementasi: "Hapus & Mirror"
*   Karena fitur Kasbon lama "salah arah", strategi terbaik adalah **menghapus** file detail kasbon lama.
*   Gunakan kodingan `settlement_detail_screen.dart` sebagai template utama.
*   Lakukan pencerminan (mirroring) logika sehingga keduanya memiliki fitur verifikasi dana yang sama persis.

> [!IMPORTANT]
> **Pesan Utama:** 
> Perubahan ini memastikan Manager memiliki kontrol penuh atas dari mana uang perusahaan keluar (Sumber Dana) dan memastikan laporan pengeluaran (Tabel 4) selalu akurat.
