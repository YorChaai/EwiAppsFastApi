# 📋 Master Plan Implementasi: Sistem Cash Bank, Settlement & Manajemen Kategori (REVISED)

Dokumen ini merangkum secara mendetail (komprehensif) rencana perubahan teknis dan fungsional pada aplikasi berdasarkan hasil analisis transkrip pertemuan (`meeting3all.md`) dan referensi visual logika papan tulis. 

Tujuan utama dari fase pengembangan ini adalah mengubah fundamental cara sistem menangani "Uang Muka" (*Cash Advance*), "Pelaporan Pengeluaran" (*Settlement/Expense*), dan Manajemen Kategori, beserta perubahan antarmuka (*UI/UX*) dan output pelaporan (Excel).

---

## 1. Konsep Fundamental: "Rekening Bank Virtual" Karyawan (Pindah Kantong)

**Konteks Masalah (Before):**
Sebelumnya, *Cash Advance* (kasbon) dan *Settlement* (klaim pengeluaran) diperlakukan sebagai dua dokumen entitas yang terpisah, kaku, dan laporan keuangannya sering tercampur. Kasbon dianggap sebagai pengeluaran perusahaan secara langsung saat disetujui, dan jika ada sisa/kekurangan, pencatatannya menjadi rumit dan sulit dilacak secara lintas-dokumen (tidak berkesinambungan).

**Solusi yang Diharapkan (After):**
Sistem akan mengadopsi konsep **Rekening Bank Virtual** yang dibagi menjadi dua pilar utama:
1.  **Bank Cash (Kas Riil):** Uang fisik yang ada di rekening perusahaan (BCA, Mandiri, dll).
2.  **Bank Advance (Kas Virtual):** Uang titipan yang ada di "kantong" karyawan (Andi, Budi, Titis, dll).

*   **Cash Advance (Kasbon):** Adalah murni **dana titipan** (saldo mengendap) dan **TIDAK** masuk ke dalam laporan pengeluaran keuangan perusahaan. Ibaratnya, perusahaan memindahkan uang dari "Bank Cash" ke "Bank Advance" milik karyawan.
    *   **Single Advance:** Permintaan satu per satu.
    *   **Bud (Totaled) Advance:** Permintaan yang digabungkan (misal: 5 kali ajuan @2jt menjadi 10jt).
*   **Settlement (Expense):** Adalah bukti nyata pengeluaran (nota belanja). **HANYA** item settlement inilah yang akan masuk ke dalam Laporan Keuangan resmi.
*   **Logika Kalkulasi Otomatis (Running Balance):** Saat karyawan membuat Settlement, sistem akan langsung mengecek saldo "Bank Advance" karyawan tersebut. 
    *   **Saldo Awal Akun Baru:** Setiap akun baru otomatis dimulai dengan saldo **Rp 0**. Saldo hanya akan bertambah melalui ajuan Advance yang disetujui.
    *   **Penanganan Saldo Lama (Legacy Balance):** Jika karyawan sudah memegang uang sebelum sistem ini aktif, saldo tersebut harus dimasukkan sebagai "Advance Awal" agar tercatat di Bank Advance.
    *   **Trigger UI:** Saat user mengklik tombol "Total" pada form Settlement, sistem secara otomatis akan bertanya: *"Apakah ada saldo Advance?"*. Jika ada, maka akan dikurangi dari total tersebut.
    *   **Jika Hasil Positif (+):** Artinya `Pengeluaran > Kasbon`. Maka muncul istilah **"Balance to Employee"** (Perusahaan harus membayar kekurangan dana ke pegawai).
    *   **Jika Hasil Negatif (-):** Artinya `Kasbon > Pengeluaran`. Pegawai memiliki **"Sisa Advance"**. Uang sisa ini tidak perlu disebut "Balance to Company", melainkan otomatis kembali menggantung di "Bank Advance" karyawan tersebut atau dikembalikan ke "Bank Cash".

**Logika Keuangan: Mengapa Kasbon "Menggantung"?**
*   **Kasbon = Pindah Kantong (Bukan Pengeluaran):**
    Ketika pegawai meminta kasbon, uang dipindahkan dari Bank Cash (Kantong Kiri) ke Bank Advance Karyawan (Kantong Ranan). Uang tersebut **masih berstatus milik perusahaan**.
*   **Mencegah Double Entry:**
    Memasukkan kasbon dan settlement secara bersamaan ke dalam Laporan Keuangan Tahunan **sangat dilarang**. Laporan Excel hanya akan mencatat transaksi Settlement.
*   **Audit Karyawan Keluar (Resignation Check):**
    Sistem harus memudahkan pengecekan: "Apakah Titis masih punya Advance?" saat ia akan keluar/resign. Semua sisa Advance wajib dilunasi.

**Tindakan Teknis (Action Plan):**
*   **EDIT:** Mengubah logika *query* pada laporan pelaporan (Dashboard/Excel) agar mengecualikan data nominal dari model `Advance`, dan murni mengambil agregasi dari model `Expense` (Settlement).
*   **TAMBAH:** Membuat fungsi agregasi baru di backend (kemungkinan di `services/` atau metode pada model `User`) untuk menghitung *Running Balance* (Saldo Berjalan) per karyawan (Total Advance Disetujui - Total Settlement Disetujui + Total Pengembalian).
*   **TAMBAH:** Membuat API Endpoint khusus untuk mengambil "Available Cash Advance" berdasarkan `user_id`.

---

## 2. Fleksibilitas Pengaturan Kategori & Penyembunyian Kolom Kosong

**Konteks Masalah (Before):**
Kategori pelaporan (Beban Langsung, Beban Tidak Langsung, Admin Umum) berifat statis. Kolom-kolom di dalam tabel laporan Excel akan selalu muncul semuanya (melebar) meskipun pada kategori tertentu sama sekali tidak ada transaksi (nilainya nol), sehingga laporan sulit dibaca.

**Solusi yang Diharapkan (After):**
Kategori harus bersifat dinamis dan dapat dikelola langsung oleh manajer bisnis (*Business Dev/Manager*). Jika di masa depan kantor pusat menambah kategori baru, sistem sudah siap.

*   **10 Slot Kategori Independen:** Sistem menyiapkan kapasitas logis untuk menampung lebih banyak kategori (disarankan 10 *reserve slots*), meskipun saat ini hanya 3 yang aktif.
*   **Manajemen Mandiri:** Kategori tidak saling terhubung di Excel, dan penambahannya bisa dilakukan via Pop-up UI (harus disetujui Manajer/Superman).
*   **Smart Excel Export (Hide Empty Columns):** Algoritma akan mendeteksi: Jika di bulan atau rentang waktu tersebut suatu kategori nilainya `0` (tidak ada transaksi sama sekali), maka kolom tersebut akan **disembunyikan (hidden/dihilangkan)** dari output laporan Excel.
*   **Struktur Kolom Sederhana:** Berdasarkan arahan terbaru, laporan Excel difokuskan pada kolom utama:
    1.  **Tanggal**
    2.  **Deskripsi**
    3.  **Kategori** (misal: Gaji, Operasional, dll)
    4.  **Total** (Nilai per kategori)

**Tindakan Teknis (Action Plan):**
*   **EDIT:** Meninjau model `Category` di `models.py`. Memastikan `parent_id` dan `status` (untuk approval kategori baru) berfungsi penuh.
*   **TAMBAH:** Membangun atau menyempurnakan rute `/api/categories` untuk mendukung pembuatan (Create), perubahan nama (Update), dan penonaktifan (Soft-Delete) kategori oleh role Manajer.
*   **EDIT:** Modifikasi masif pada skrip ekspor (misal: `utils/excel_generator.py` atau `fix_exports.py`). Menambahkan logika kondisional: sebelum merender kolom, hitung total nilainya. Jika `sum == 0`, kecualikan kolom tersebut dari proses pemetaan (*mapping*) ke sel Excel.

---

## 3. Sistem Persetujuan (Approval Override) & Logbook Transparansi (Audit Trail)

**Konteks Masalah (Before):**
Jika karyawan mengajukan Rp 5.000.000, manajer hanya bisa menerima atau menolak. Tidak ada fleksibilitas untuk menyesuaikan angka dan tidak ada catatan jika terjadi perubahan.

**Solusi yang Diharapkan (After):**
Manajer dan Super Manager diberikan **Otoritas Override Penuh** untuk mengubah nominal ajuan secara sepihak di sistem.

*   **Fleksibilitas Tanpa Batas:** 
    *   **Menambah Nominal:** Jika karyawan minta Rp 4 Juta, Manajer bisa menaikkannya menjadi **Rp 10 Juta** (misal: jika Manajer tahu biaya lapangan meningkat).
    *   **Mengurangi Nominal:** Jika karyawan minta Rp 5 Juta, Manajer bisa menurunkannya menjadi Rp 2 Juta (misal: penyesuaian anggaran).
*   **Transparansi Mutlak (Logbook):**
    Setiap perubahan angka **WAJIB** tercatat secara otomatis ke dalam sistem database. Logbook akan menyimpan data sebagai berikut:
    1.  **Siapa** yang melakukan perubahan (Nama Manager/Super Manager).
    2.  **Kapan** waktu perubahan dilakukan (Tanggal & Jam).
    3.  **Nominal Asal** (Angka yang diajukan staf, misal: 4 Juta).
    4.  **Nominal Revisi** (Angka hasil editan Manager, misal: 10 Juta).
    5.  **Catatan (Notes):** Alasan mengapa angka tersebut diubah.
*   **Angka Final yang Berlaku:** Angka yang masuk ke dalam hitungan saldo dan laporan adalah **Angka Hasil Revisi**, sementara angka awal hanya menjadi catatan sejarah (*History*).

**Tindakan Teknis (Action Plan):**
*   **TAMBAH:** Field `approved_amount` pada model transaksi untuk menyimpan angka final.
*   **TAMBAH:** Tabel `OverrideLog` untuk merekam detail setiap kali terjadi perubahan nilai oleh atasan.
*   **TAMBAH:** Panel "Riwayat Perubahan" di UI agar Super Manager bisa melihat siapa yang mengedit uang tersebut dari berapa menjadi berapa.

---

## 4. Perubahan UI/UX Fungsional di Frontend

**Konteks Masalah (Before):**
Navigasi masih tercampur atau belum spesifik membedakan antara dana operasional harian perusahaan dengan dana titipan karyawan.

**Solusi yang Diharapkan (After):**
Sidebar akan memiliki struktur menu **"BANK"** yang bersifat hierarkis (Parent-Child) untuk transparansi dana total:

1.  **Induk Menu: "BANK" (Pusat Kendali Kas)**
    *   **Sub-Menu 1: "Cash Bank" (Kas Riil)**
        *   Khusus untuk Manajer memantau saldo riil di rekening perusahaan (BCA, Mandiri, dll) dan transaksi admin bank (bunga, biaya admin).
        *   Tempat mencatat **Pengembalian Dana** dari karyawan agar saldo "Bank" perusahaan bertambah kembali secara riil.
    *   **Sub-Menu 2: "Cash Advance" (Kas Virtual / Kasbon)**
        *   Khusus untuk mengelola dana titipan/piutang karyawan (Pindah Kantong).
        *   Menampilkan daftar saldo "menggantung" yang masih dibawa oleh masing-masing karyawan.
        *   **Tampilan Saldo Live:** Saat user membuka form "Buat Settlement Baru", muncul bar informasi: `"Available Cash Advance: Rp 3.000.000"`.
    *   **Personal Balance di Profil:** Karena Role *Staff* tidak bisa melihat menu "BANK", maka informasi saldo "Bank Advance" pribadi akan ditampilkan di halaman **Pengaturan/Profil**. Ini memungkinkan setiap user (Staff s/d Super Manager) memantau uang titipan yang masih mereka bawa tanpa harus bertanya ke Manager.

**Fitur Tambahan UI:**
*   **Radio Button Kategori:** Memaksa user hanya bisa memilih **satu** opsi per item transaksi.
*   **Quick Verify (Centang/Silang):** Tombol cepat di halaman Manajer untuk verifikasi baris-demi-baris.

**Tindakan Teknis (Action Plan):**
*   **TAMBAH:** Struktur menu *dropdown* atau *expandable list* untuk "BANK" di sidebar.
*   **TAMBAH:** Endpoint `GET /api/users/<id>/active_advance_balance` untuk sinkronisasi menu Cash Advance.

---

## 5. Ringkasan Migrasi (Summary of Changes)

1.  **Dihapus (Removed):** 
    *   Penggabungan total *Cash Advance* ke dalam Laporan Pengeluaran Finansial Perusahaan.
    *   Sistem kolom statis di export Excel.
2.  **Ditambah (Added):** 
    *   Logika *Virtual Bank Balance* per user_id.
    *   Algoritma *Hide Empty Columns* pada ekspor Excel.
    *   Sistem rekam jejak revisi nilai (*Logbook*) untuk *override* nilai oleh Manajer.
    *   Fasilitas Pop-up manajemen Kategori.
3.  **Diedit (Edited):** 
    *   Alur *Settlement* dipaksa untuk membaca saldo *Advance* yang masih aktif (menggantung).
    *   UI *Settlement* and *Advance* untuk mengakomodasi riwayat dan verifikasi cepat.
