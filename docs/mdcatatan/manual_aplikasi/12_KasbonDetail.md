# Product Requirements Document (PRD) - Kasbon Detail (Advance Detail)

## 1. Overview
Halaman **Kasbon Detail** adalah modul persetujuan modal awal. Berbeda dengan _Settlement_ yang berorientasi pada kalkulasi utang pasca-kegiatan, Kasbon berfokus pada pelacakan ketersediaan uang perusahaan (*real-time bank balance*) sebelum diserahkan ke tangan karyawan untuk membiayai rencana kegiatan. Secara arsitektur, UI modul ini dibangun menggunakan *layout* berlapis yang dapat beradaptasi dari Desktop (*Action Bar* di atas) menjadi Mobile (*Sticky Footer*). 

## 2. Fitur Utama & UI Components
- **Adaptive Action Bar:** Deretan tombol perintah (Approve, Submit, Reject, Export) yang menyesuaikan posisi secara responsif berdasarkan dimensi layar perangkat.
- **Summary Cards (Metrik Ringkasan):** Menampilkan metrik Total Pengajuan, Angka Disetujui, Reimbursement, Outstanding (Sisa uang yang belum dicairkan), dan Jumlah Item pengeluaran.
- **Panel Saldo Bank Advance (Kotak Biru):** Elemen pembeda khas Kasbon yang secara transparan menjabarkan komposisi uang riil/tunai yang saat itu juga sedang dipegang oleh pengguna pemohon.
- **Metadata & Warning Box:** Menyajikan informasi identitas Pembuat, Tanggal, peringatan catatan Revisi (warna kuning), dan peringatan kebijakan/limit berlebih (warna merah).
- **Sistem Tabel Bersyarat:** Rangkaian tabel berlapis (Tabel 1: Daftar Permintaan, Tabel 2: Pengiriman Dana) yang akan terbuka satu per satu secara logis dan berurut.

## 3. Sistem Alur Kerja Bersyarat (State Machine)
Sistem dikawal secara terpusat oleh fungsi algoritma penjaga gawang `_canSubmitAdvanceItems` yang mengatur pergantian wewenang (State) dalam lima fase mutlak:

### 3.1. Fase 1: Draft & Bulk Delete (Wewenang: Staf)
- Berlaku ketika status dokumen `draft` atau `revision`.
- Staf dapat mendaftarkan rincian item, mengubah angka pengajuan, dan menghapus item. 
- Tersedia fasilitas khusus **Sapu Jagat (Bulk Delete)** `_bulkDeleteItems` yang memungkinkan staf memilih lebih dari satu baris pengajuan (*checkbox selection*) dan memusnahkannya secara bersamaan (*batch execution*).

### 3.2. Fase 2: Penguncian & Penyerahan (Wewenang: Manajer)
- Saat staf menekan **Submit**, seluruh hak perombakan data (Edit/Delete) staf seketika dicabut.
- Setiap baris item berpindah ke yurisdiksi Manajer, yang kini disuguhi sepasang tombol *Approve* (centang hijau) atau *Reject* (silang merah).

### 3.3. Fase 3: Evaluasi Manajer & Hukum Revisi
- Jika Manajer mengeksekusi **Reject**, sistem mewajibkannya menyertakan daftar _checklist_ keluhan atau alasan teguran.
- **Hukum Perbaikan Mutlak (Strict Reject & Fix):** Staf yang tertolak tidak dizinkan untuk asal mengajukan ulang. Mereka diwajibkan membuka *popup* alasan penolakan Manajer, merapikan kekeliruan mereka, dan **mencentang paksa seluruh kotak teguran (`checked: true`)** satu demi satu secara sadar. Hanya setelah semua kotak tercentang, status baris tersebut dimaafkan kembali menjadi `pending` untuk bisa dinilai ulang.

### 3.4. Fase 4: Gerbang Pencairan (Tabel 2 - Wewenang: Finance)
- Akses ke arena Tabel 2 (*Disbursement/Pencairan*) mustahil terbuka kecuali seluruh baris di Tabel 1 sudah bersih memegang status 100% `approved`.
- Setelah terbuka, tim Keuangan (Finance) mengambil alih kekuasaan; mereka diwajibkan untuk menentukan dan memilih "Sumber Dana" rekening mana yang akan didebet, serta menautkan bukti gambarnya ("Bukti Transfer").

### 3.5. Fase 5: Proteksi Saldo & Penutupan Dokumen
- **Insufficient Balance Check:** Tepat pada persekian detik saat *Finance* mencoba menekan *Approve* pencairan di Tabel 2 (maupun klik Final), sebuah kode pengaman _try-catch InsufficientAdvanceBalanceException_ akan meluncur. Sistem menarik nominal aktual `_officeBankBalances` di _database_ hari itu. Jika angka Kasbon yang dituntut lebih besar dari brankas perusahaan yang tersedia, prosedur itu ditolak mentah-mentah dan membunyikan alarm *Popup* Saldo Kosong.
- **Bypass Tabel 3 (Finalisasi):** Walau kerangka program (_source code_) mewariskan bentuk Tabel 3 (Pengembalian), alur bisnis aslinya melewati rintangan tersebut (_bypass_). Lolosnya Tabel 2 langsung memicu munculnya tombol dewa di pucuk halaman: **"Setujui Final Kasbon"**.
- Pukulan pada persetujuan akhir tersebut akan menggembok rapat riwayat pengajuan selamanya dengan memutakhirkan status sistem menjadi `completed`.

## 4. Mekanisme Keamanan Khusus
- **Double-Tap Lock (`_isSaving = true`):** Setiap tombol operasi vital di halaman ini dilapisi variabel keamanan anti-spam yang sigap melumpuhkan dirinya sendiri (*disable*) sedetik seusai disentuh, membunuh risiko pencatatan ganda akibat klik brutal.
- **Silent Background Auto-Refresh:** Memperalat kemampuan pustaka `GlobalEventBus`, layar ini berfungsi layaknya alat sadap tak kasatmata. Saat ada layar aplikasi lain yang merubah nilai saldo bank, halaman Kasbon Detail akan merespons panggilan gaib dengan memutakhirkan nominal Panel Saldo miliknya seketika, dan luar biasanya: tanpa me-_reload_ halaman yang bisa mengganggu titik konsentrasi baca pengguna.
