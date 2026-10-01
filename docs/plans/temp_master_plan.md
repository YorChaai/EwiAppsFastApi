# 📋 Master Plan Implementasi: Sistem Cash Bank, Settlement & Manajemen Kategori

Dokumen ini merangkum secara mendetail (komprehensif) rencana perubahan teknis dan fungsional pada aplikasi berdasarkan hasil analisis transkrip pertemuan (`meeting3all.md`) dan referensi visual logika papan tulis. 

Tujuan utama dari fase pengembangan ini adalah mengubah fundamental cara sistem menangani "Uang Muka" (*Cash Advance*), "Pelaporan Pengeluaran" (*Settlement/Expense*), dan Manajemen Kategori, beserta perubahan antarmuka (*UI/UX*) dan output pelaporan (Excel).

---

## 1. Konsep Fundamental: "Rekening Bank Virtual" Karyawan (Pindah Kantong)

**Konteks Masalah (Before):**
Sebelumnya, *Cash Advance* (kasbon) dan *Settlement* (klaim pengeluaran) diperlakukan sebagai dua dokumen entitas yang terpisah, kaku, dan laporan keuangannya sering tercampur. Kasbon dianggap sebagai pengeluaran perusahaan secara langsung saat disetujui, dan jika ada sisa/kekurangan, pencatatannya menjadi rumit dan sulit dilacak secara lintas-dokumen (tidak berkesinambungan).

**Solusi yang Diharapkan (After):**
Sistem akan mengadopsi konsep **Rekening Bank Virtual**. Setiap karyawan yang menerima *Cash Advance* dianggap seperti "rekening bank" tempat perusahaan menitipkan dana (contoh: "Bank Andi", "Bank Budi"). 

*   **Cash Advance (Kasbon):** Adalah murni **dana titipan** (saldo mengendap) dan **TIDAK** masuk ke dalam laporan pengeluaran keuangan perusahaan. Ibaratnya, perusahaan memindahkan uang dari "kantong utama" ke "rekening bank virtual" milik karyawan. Karena uang tersebut belum dibelanjakan dan wujudnya masih berupa uang tunai di tangan karyawan, uang itu masih berstatus milik perusahaan (aset).
*   **Settlement (Expense):** Adalah bukti nyata pengeluaran (nota belanja). **HANYA** item settlement inilah yang akan masuk ke dalam Laporan Keuangan resmi.
*   **Logika Kalkulasi Otomatis (Running Balance):** Saat karyawan membuat Settlement, sistem akan langsung mengecek saldo "rekening virtual" karyawan tersebut (`Realisasi Expense` vs `Saldo Advance yang Aktif`).
    *   **Jika Hasil Positif (+):** Artinya `Pengeluaran > Kasbon`. Pegawai nombok, sehingga *Company Pays* (Perusahaan harus mentransfer kekurangan dana ke pegawai).
    *   **Jika Hasil Negatif (-):** Artinya `Kasbon > Pengeluaran`. Pegawai masih memegang sisa uang perusahaan (utang), sehingga harus mengembalikan sisa uangnya atau membiarkannya tetap menggantung di dompet virtualnya.

**Logika Keuangan: Mengapa Kasbon "Menggantung"?**
*   **Kasbon = Pindah Kantong (Bukan Pengeluaran):**
    Ketika pegawai meminta kasbon, uang dipindahkan dari Rekening Perusahaan (Kantong Kiri) ke Rekening/Dompet Karyawan (Kantong Kanan). Uang tersebut **masih berstatus milik perusahaan** yang dititipkan pada pegawai. Karena belum dibelanjakan, maka kasbon **TIDAK boleh** dicatat sebagai pengeluaran (*expense*) di Laporan Keuangan Tahunan.
*   **Settlement = Uang Benar-benar Hangus:**
    Ketika pegawai akhirnya menggunakan uang titipan tersebut dan melampirkan nota bukti belanja (*Settlement*), barulah uang tersebut diakui secara finansial sebagai pengeluaran resmi perusahaan.
*   **Mengapa Karyawan Dianggap Berutang?**
    Uang kasbon yang dipegang karyawan statusnya akan terus "menggantung". Jika karyawan menerima uang kasbon tersebut tetapi tidak pernah membuat settlement (klaim pengeluaran) atau tidak mengembalikan sisa uangnya, status uang itu secara internal dicatat sebagai **"utang" karyawan kepada perusahaan**. Jika suatu saat karyawan resign, utang yang menggantung ini **wajib dilunasi atau dipotong dari gaji terakhirnya**.
*   **Mencegah Pencatatan Ganda (Double Entry):**
    Memasukkan kasbon dan settlement secara bersamaan ke dalam Laporan Keuangan Tahunan **sangat dilarang** karena akan memicu *Double Entry*. Jika kasbon Rp 5 juta dan settlement Rp 5 juta dua-duanya dicatat, sistem akan salah membaca bahwa perusahaan keluar uang Rp 10 juta, padahal realitasnya hanya Rp 5 juta.

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

**Tindakan Teknis (Action Plan):**
*   **EDIT:** Meninjau model `Category` di `models.py`. Memastikan `parent_id` dan `status` (untuk approval kategori baru) berfungsi penuh.
*   **TAMBAH:** Membangun atau menyempurnakan rute `/api/categories` untuk mendukung pembuatan (Create), perubahan nama (Update), dan penonaktifan (Soft-Delete) kategori oleh role Manajer.
*   **EDIT:** Modifikasi masif pada skrip ekspor (misal: `utils/excel_generator.py` atau `fix_exports.py`). Menambahkan logika kondisional: sebelum merender kolom, hitung total nilainya. Jika `sum == 0`, kecualikan kolom tersebut dari proses pemetaan (*mapping*) ke sel Excel.

---

## 3. Sistem Persetujuan (Approval Override) & Logbook Transparansi

**Konteks Masalah (Before):**
Jika karyawan mengajukan Rp 5.000.000, manajer hanya memiliki dua opsi mutlak: Menerima (Approve) Rp 5.000.000 atau Menolak (Reject) seluruhnya. Tidak ada ruang fleksibilitas untuk mengubah angka secara langsung, dan tidak ada rekam jejak (*history*) yang jelas jika angka berubah.

**Solusi yang Diharapkan (After):**
Manajer (Approver) diberikan kekuasaan penuh (Override Authority) untuk mengubah nominal ajuan secara sepihak. 

*   **Fleksibilitas Angka:** Jika karyawan minta Rp 5 Juta, manajer bisa menggantinya menjadi Rp 2 Juta (karena dinilai kemahalan) atau bahkan menaikkannya menjadi Rp 10 Juta (jika manajer tahu biayanya akan lebih besar).
*   **Angka Valid:** Nominal yang akhirnya dicatat dan diproses adalah **angka yang disetujui Manajer**, bukan angka awal dari karyawan.
*   **Logbook Otomatis:** Setiap kali manajer mengubah angka, sistem akan mencatatnya di Logbook. Logbook mencatat: (A) Siapa yang mengajukan, (B) Waktu pengajuan, (C) Angka Asli, dan (D) Angka Hasil Revisi Manajer.
*   **Logbook Toggle:** Di antarmuka pengguna (UI), *Logbook* ini secara *default* disembunyikan (*hidden*) agar tidak membuat layar penuh, dan hanya muncul jika tombol "Lihat Riwayat/Logbook" ditekan.

**Tindakan Teknis (Action Plan):**
*   **EDIT:** Mengubah rute approval pada `routes/advances.py` dan `routes/settlements.py`. Mengizinkan *payload* (body request) yang berisi nominal baru (`approved_amount` atau modifikasi nilai per-item) saat status diubah menjadi `approved`.
*   **TAMBAH:** Memanfaatkan model `WorkflowLog` (yang sudah ada di database) untuk menyuntikkan data spesifik setiap kali terjadi perubahan nilai sebelum status disetujui.
*   **TAMBAH/EDIT:** Memastikan respons API mengembalikan data `history` atau `revision_summaries` yang utuh untuk di-konsumsi UI frontend.

---

## 4. Perubahan UI/UX Fungsional di Frontend

**Konteks Masalah (Before):**
Input kategori sering memungkinkan *multiple selection* yang membingungkan. Verifikasi membutuhkan navigasi yang panjang. Karyawan tidak tahu berapa sisa uang kasbon yang mereka pegang saat membuat settlement.

**Solusi yang Diharapkan (After):**
*   **Tampilan Saldo Live:** Saat user membuka form "Buat Settlement Baru", di bagian bawah (atau atas) form akan muncul bar informasi: `"Available Cash Advance: Rp 3.000.000"`. Angka ini terikat dengan akun mereka.
*   **Radio Button Kategori:** Memastikan pemilihan Kategori/Sub-kategori menggunakan elemen *Radio Button* (bukan *Checkbox* atau *Multi-select Dropdown*) untuk memaksa user hanya bisa memilih **satu** opsi per item transaksi. Dilarang ada item yang sama ter-input dua kali di tempat berbeda.
*   **Quick Verify (Centang/Silang):** Di halaman Manajer, setiap baris item pengeluaran memiliki tombol cepat berupa Ikon Centang (Setuju) dan Silang (Tolak) untuk mempercepat proses verifikasi baris-demi-baris tanpa harus masuk ke halaman detail yang dalam.

**Tindakan Teknis (Action Plan):**
*   (Fokus Frontend, namun membutuhkan dukungan Backend):
*   **TAMBAH:** Menyiapkan *Endpoint* Backend untuk Frontend memanggil data: `GET /api/users/<id>/active_advance_balance`.
*   **EDIT:** Memastikan *Endpoint* persetujuan mendukung skema per-item (bulk status update: `[{id: 1, status: 'approved'}, {id: 2, status: 'rejected'}]`).

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
