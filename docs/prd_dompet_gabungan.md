# Product Requirement Document (PRD)
## Migrasi Sistem Kasbon "Strict 1-to-1" ke "Dompet Gabungan"

### 1. Latar Belakang
Saat ini, sistem menggunakan logika "Strict 1-to-1" di mana satu dokumen Settlement dikunci (terikat) dengan satu dokumen Kasbon (`advance_id`). Karyawan merasa sistem ini kurang fleksibel karena mereka tidak dapat melunasi/menggunakan sisa hutang Kasbon sebelumnya untuk pengeluaran (Settlement) yang baru. Karyawan menginginkan sistem "Dompet Gabungan" di mana seluruh Kasbon mereka ditampung dalam Saldo Virtual, dan setiap Settlement bebas memotong dari saldo bank mana saja.

### 2. Tujuan
- **Fleksibilitas Settlement:** Memungkinkan karyawan untuk menggunakan atau melunasi sisa saldo Kasbon mereka pada dokumen Settlement apa pun.
- **Transparansi Saldo Global:** Menampilkan keseluruhan Saldo Virtual / Hutang karyawan secara global di dalam layar Settlement, bukan hanya berdasarkan satu Kasbon yang terhubung.
- **Melepas Keterikatan 1-to-1:** Dokumen Kasbon tetap ada sebagai jejak pengajuan dana, namun Settlement tidak lagi dibatasi oleh nominal atau ID spesifik Kasbon tersebut.

### 3. Lingkup Perubahan (Scope of Work)

#### A. Backend (Logika & API)
- **Hapus Validasi Strict:** Hapus validasi di `settlements_crud.py` yang memblokir pembuatan Settlement jika `advance_id` sudah pernah dipakai.
- **Endpoint Saldo Virtual:** Sediakan endpoint khusus (misalnya `/user_balances/<user_id>`) untuk menghitung dan mengembalikan komposisi Hutang/Saldo Virtual karyawan berdasarkan masing-masing Bank Cash.
- **Logika Potong/Netting:** Saat Settlement di-complete, potong saldo (override log / netting) dari Bank Cash yang dipilih pengguna di dalam Settlement (Tabel 2/3), terlepas dari bank asal Kasbon.

#### B. Frontend (UI/UX)
- **Settlement Detail Screen:** 
  - Ganti nilai `_activeAdvanceBalance` yang awalnya hanya menarik dari `advance.disbursed_amount` menjadi menarik dari **Total Saldo Virtual Gabungan** (Hutang Global).
  - Tampilkan list rincian "Dompet Kasbon / Hutang Anda" per Bank (misal: BRI Rp 100.000, Mandiri Rp 0) di bagian atas layar Settlement.
- **Tombol "Buat Settlement":** Saat diklik dari halaman Kasbon, sistem akan membuat dokumen Settlement baru yang bebas memotong saldo dari bank mana saja.

### 4. Kriteria Penerimaan (Acceptance Criteria)
- [ ] Pengguna (Karyawan) dapat melihat total Hutang Global mereka (misal Rp 100.000 di BRI) saat membuka halaman dokumen Settlement apa pun.
- [ ] Pengguna dapat membuat dua Settlement berbeda dari satu riwayat Kasbon yang sama tanpa diblokir sistem.
- [ ] Sistem akan meng-update Dompet Gabungan (Saldo Virtual) secara otomatis saat Settlement diklaim (netting) menggunakan bank yang dipilih.
