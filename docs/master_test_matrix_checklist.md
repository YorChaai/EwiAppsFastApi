# Master Test Matrix & QA Checklist (19 Modul Lengkap)

> **Panduan QA:** Gunakan daftar uji ini untuk memvalidasi seluruh fungsionalitas sistem secara bertahap. Setiap skenario mencantumkan menu persis, tombol yang ditekan, data yang dimasukkan, dan hasil verifikasi di layar.

## MODUL 01: BANK MANAGEMENT & REKONSILIASI SALDO
_Pengujian rekening fisik (Bank Cash), saldo virtual staf (Bank Advance), kalkulasi matematis (+/-), dan alokasi multi-sumber._

- [ ] **BM-001** | **[Daftar Rekening]** 1. Buka Sidebar -> Klik menu **BANK**. 2. Pilih tab **Bank Cash**. 3. Verifikasi: Logo bank, nama rekening, nomor rekening, mata uang (IDR/USD), dan saldo riil tampil lengkap pada setiap kartu.
- [ ] **BM-002** | **[Sorting Prioritas]** 1. Buka Sidebar -> Klik menu **BANK** -> tab **Bank Cash**. 2. Verifikasi urutan grup kartu: Rekening Biasa -> Giro -> Bisnis -> TabBis -> Valas -> Rekening Baru di posisi paling bawah.
- [ ] **BM-003** | **[Border Warna Saldo]** 1. Buka Sidebar -> Klik menu **BANK** -> tab **Bank Cash**. 2. Amati garis border samping kartu bank: Saldo > 0 beraksen Biru/Hijau, Saldo Rp 0 beraksen Abu-abu, Saldo minus beraksen Merah.
- [ ] **BM-004** | **[Form Tambah Bank]** 1. Buka Sidebar -> Klik menu **BANK** -> tab **Bank Cash**. 2. Klik tombol **+ Tambah Rekening** di kanan bawah. 3. Isi Nama: 'Bank Mandiri Operasional', No Rek: '140001928374', Saldo Awal: 100000. 4. Klik **Simpan**. 5. Verifikasi: Kartu rekening baru langsung muncul di daftar.
- [ ] **BM-005** | **[Validasi Form Kosong]** 1. Buka menu **BANK** -> Klik **+ Tambah Rekening**. 2. Kosongkan semua isian form nama bank dan nomor rekening. 3. Klik **Simpan**. 4. Verifikasi: Muncul pesan error merah di bawah kolom dan form tidak tersimpan.
- [ ] **BM-006** | **[Duplikasi No Rek]** 1. Buka menu **BANK** -> Klik **+ Tambah Rekening**. 2. Masukkan nomor rekening yang sudah terdaftar sebelumnya (contoh: 140001928374). 3. Klik **Simpan**. 4. Verifikasi: Muncul notifikasi penolakan duplikat nomor rekening.
- [ ] **BM-007** | **[Detail BottomSheet]** 1. Buka Sidebar -> Klik menu **BANK** -> tab **Bank Cash**. 2. Klik salah satu kartu bank (contoh: BRI). 3. Verifikasi: Muncul modal popup 'Detail Bank Cash' yang menampilkan Total Bank Cash, tombol Edit Bank Cash, tombol Kelola Cash/Uang, dan Riwayat Aktivitas.
- [ ] **BM-008** | **[Edit Bank]** 1. Buka menu **BANK** -> Klik salah satu kartu bank -> Klik tombol oranye **Edit Bank Cash**. 2. Ubah nama rekening (contoh: BNI menjadi BNI1). 3. Klik **Simpan**. 4. Verifikasi: Muncul notifikasi hijau 'Data rekening berhasil diperbarui' dan nama di kartu bank langsung berganti.
- [ ] **BM-009** | **[Toggle Tambah (+)]** 1. Buka menu **BANK** -> Klik kartu bank -> Klik tombol hijau **Kelola Cash/Uang**. 2. Pilih toggle hijau **(+)**. 3. Masukkan nominal Rp 10.000.000. 4. Cek teks kalkulasi: [Saldo Awal] + Rp 10.000.000 = [Saldo Akhir]. 5. Klik **Simpan** -> Verifikasi saldo bertambah tepat Rp 10.000.000.
- [ ] **BM-010** | **[Toggle Kurang (-)]** 1. Buka menu **BANK** -> Klik kartu bank -> Klik tombol hijau **Kelola Cash/Uang**. 2. Pilih toggle merah **(-)**. 3. Masukkan nominal Rp 3.000.000. 4. Cek teks kalkulasi: [Saldo Awal] - Rp 3.000.000 = [Saldo Akhir]. 5. Klik **Simpan** -> Verifikasi saldo berkurang tepat Rp 3.000.000.
- [ ] **BM-011** | **[Validasi Nominal < Rp 100]** 1. Buka menu **BANK** -> Klik kartu bank -> Klik tombol hijau **Kelola Cash/Uang**. 2. Masukkan nominal '0' atau '99'. 3. Klik **Simpan**. 4. Verifikasi: Muncul pesan error merah 'Nominal penyesuaian minimal Rp 100' dan form tidak tersimpan.
- [ ] **BM-012** | **[Filter Karakter Huruf/Minus]** 1. Buka menu **BANK** -> Klik kartu bank -> Klik **Kelola Cash/Uang**. 2. Pada kolom input nominal, coba ketik karakter huruf 'abc' atau simbol '@#$'. 3. Verifikasi: Kolom input menolak karakter selain angka numerik.
- [ ] **BM-013** | **[Tarik Melebihi Saldo]** 1. Buka menu **BANK** -> Klik kartu bank dengan saldo Rp 1.000.000 -> Klik **Kelola Cash/Uang**. 2. Pilih toggle merah (-) Kurang -> Masukkan nominal Rp 5.000.000. 3. Klik **Simpan**. 4. Verifikasi: Sistem menolak dengan peringatan 'Saldo tidak mencukupi (Maks: Rp1.000.000)'.
- [ ] **BM-014** | **[Nominal Ekstrem 1 Triliun]** 1. Buka menu **BANK** -> Klik kartu bank -> Klik **Kelola Cash/Uang**. 2. Masukkan nominal 1.000.000.000.000 (1 Triliun). 3. Klik **Simpan**. 4. Verifikasi: Format rupiah dan database memproses dengan presisi tanpa overflow/crash.
- [ ] **BM-015** | **[Double Submit Lock]** 1. Buka menu **BANK** -> Klik kartu bank -> Klik tombol hijau **Kelola Cash/Uang**. 2. Masukkan nominal (contoh: 500.000). 3. Klik tombol **Simpan** secara sangat cepat berkali-kali (spam click 3-5x). 4. Verifikasi: Tombol langsung terkunci (disabled/loading) dan transaksi hanya tersimpan tepat 1 kali tanpa duplikasi saldo.
- [ ] **BM-016** | **[Daftar Bank Advance]** 1. Buka Sidebar -> Klik menu **BANK** -> Klik tab **Bank Advance**. 2. Verifikasi: Avatar staf, nama karyawan, jabatan, Saldo Virtual (hijau), dan Saldo B (oranye) tampil rapi.
- [ ] **BM-017** | **[Badge HUTANG]** 1. Buka menu **BANK** -> tab **Bank Advance**. 2. Cari karyawan yang memiliki utang kasbon berjalan aktif. 3. Verifikasi: Tampil badge merah tebal bertuliskan 'HUTANG' di kartu staf bersangkutan.
- [ ] **BM-018** | **[Search Client-Side]** 1. Buka menu **BANK** -> tab **Bank Advance**. 2. Ketik nama staf di kolom pencarian atas. 3. Verifikasi: Daftar staf menyaring seketika secara instan tanpa loading lama.
- [ ] **BM-019** | **[Alokasi Single Bank]** 1. Buka tab Bank Advance -> Klik salah satu staf -> Klik **Kelola Advance/Uang**. 2. Pilih Bank Sumber (misal: Bank BCA) -> Toggle (+) Rp 2.000.000. 3. Klik **Simpan**. 4. Verifikasi: Saldo virtual staf bertambah Rp 2.000.000 dan fisik Bank BCA berkurang Rp 2.000.000 secara real-time.
- [ ] **BM-020** | **[Alokasi Multi-Bank]** 1. Di modal Kelola Advance, klik **+ Tambah Sumber Dana**. 2. Baris 1: Bank BCA (Rp 3.000.000), Baris 2: Bank Mandiri (Rp 2.000.000). 3. Cek kalkulasi total = Saldo Awal + Rp 5.000.000. 4. Klik **Simpan** -> Verifikasi kedua bank fisik terpotong otomatis.

---

## MODUL 02: LOGBOOK, AUDIT TRAIL & WORKFLOW TIMELINE
_Pengujian pencatatan kronologis transaksi kas, audit trail aktivitas, dan visual timeline progres dokumen._

- [ ] **LB-001** | **[Buka Riwayat Bank Cash]** 1. Buka Sidebar -> Klik menu **BANK** -> Klik tab **Bank Cash**. 2. Klik salah satu kartu bank fisik (misal: Bank Mandiri atau BCA1). 3. Pada popup detail, klik tombol putih **Riwayat Aktivitas / Log Book**. 4. Verifikasi: Lembar riwayat terbuka menampilkan daftar mutasi kas masuk (hijau) dan kas keluar (merah).
- [ ] **LB-002** | **[Buka Riwayat Bank Advance]** 1. Buka Sidebar -> Klik menu **BANK** -> Klik tab **Bank Advance**. 2. Klik salah satu kartu staf (misal: Manager 1). 3. Pada popup detail, klik tombol putih **Riwayat Aktivitas / Log Book**. 4. Verifikasi: Lembar riwayat terbuka menampilkan mutasi alokasi dana virtual dan kasbon staf.
- [ ] **LB-003** | **[Urutan Riwayat Terbaru Paling Atas]** 1. Buka menu **BANK** -> Klik tab **Bank Advance** -> Klik salah satu staf -> Klik tombol putih **Riwayat Aktivitas / Log Book**. 2. Perhatikan baris transaksi paling atas. 3. Verifikasi: Transaksi yang baru saja dilakukan dengan jam/menit paling terkini selalu berada di baris pertama paling atas (bukan di bawah).
- [ ] **LB-004** | **[Kerapian Teks Riwayat]** 1. Buka menu **BANK** -> Buka **Riwayat Aktivitas / Log Book** pada bank fisik atau staf. 2. Baca teks judul dan deskripsi di kartu riwayat. 3. Verifikasi: Kalimat tersusun rapi (contoh: 'Terima Alokasi - Manager 1'), tidak ada simbol pipa '|', kurung kurawal '{}', atau teks kode sistem yang bocor.
- [ ] **LB-005** | **[Layar Penuh Riwayat (Fullscreen)]** 1. Buka menu **BANK** -> Buka **Riwayat Aktivitas / Log Book**. 2. Di pojok kanan atas lembar riwayat, klik ikon **Fullscreen (Kotak Persegi / Panah Melebar)**. 3. Verifikasi: Lembar riwayat langsung membesar memenuhi seluruh layar.
- [ ] **LB-006** | **[Riwayat Catatan Alasan Alokasi Masuk]** 1. Buka menu **BANK** -> tab **Bank Advance** -> Klik staf Manager 1 -> Klik tombol hijau **Kelola Advance/Uang**. 2. Pada 'Pilih Bank Cash', pilih **Mandiri**. 3. Pada nominal, ketik **2.000.000**. 4. Pada kolom 'Catatan / Alasan Alokasi', ketik: **Dana Operasional Proyek A**. 5. Klik **Simpan Penyesuaian Saldo**. 6. Buka tombol putih **Riwayat Aktivitas / Log Book** staf -> Verifikasi: Judul baris atas tertulis **Terima Alokasi - Manager 1: Dana Operasional Proyek A** dengan nominal **+ Rp 2.000.000**.
- [ ] **LB-007** | **[Riwayat Catatan Alasan Penarikan Alokasi]** 1. Buka menu **BANK** -> tab **Bank Advance** -> Klik staf Manager 1 -> Klik tombol hijau **Kelola Advance/Uang**. 2. Klik tombol toggle ikon minus merah **(-) Kurang**. 3. Pada 'Pilih Bank Cash', pilih **Mandiri** -> Masukkan nominal **500.000**. 4. Pada kolom catatan, ketik: **Koreksi Kelebihan Saldo**. 5. Klik **Simpan Penyesuaian Saldo**. 6. Buka **Riwayat Aktivitas / Log Book** staf -> Verifikasi: Judul baris atas tertulis **Tarik Alokasi - Manager 1: Koreksi Kelebihan Saldo** dengan nominal **- Rp 500.000**.
- [ ] **LB-008** | **[Pencatatan Ganda (Bank Cash & Advance)]** 1. Buka tab **Bank Advance** -> Klik Manager 1 -> Kelola Advance/Uang -> Pilih Bank Mandiri -> Nominal Rp 1.000.000 -> Simpan. 2. Buka tab **Bank Cash** -> Klik Mandiri -> Buka **Riwayat Aktivitas** -> Verifikasi: Tercatat pengeluaran merah **- Rp 1.000.000** ke virtual Manager 1. 3. Buka tab **Bank Advance** -> Klik Manager 1 -> Buka **Riwayat Aktivitas** -> Verifikasi: Tercatat pemasukan hijau **+ Rp 1.000.000** dari Bank Mandiri.
- [ ] **LB-009** | **[Riwayat Kasbon Single Dicairkan]** 1. Buka Sidebar -> Menu **KASBON** -> Klik **+ Buat Pengajuan** -> Pilih **Single** -> Tahun 2026 -> Klik **Buat**. 2. Di Tabel 1, klik **+ Tambah Item** -> Keperluan: 'Beli ATK Kantor', Estimasi: Rp 1.500.000 -> Simpan. 3. Klik **Submit Kasbon** -> Klik centang hijau **Approve Item**. 4. Di Tabel 2 Pencairan, pilih Bank Sumber: **Mandiri** (atau bank yang ada saldonya) -> Klik **Approve Pencairan** -> Klik **Setujui Final Kasbon** di kanan bawah. 5. Buka menu **BANK** -> tab **Bank Cash** -> Buka Riwayat Bank Mandiri (Verifikasi: Tercatat pengeluaran kasbon **- Rp 1.500.000**). 6. Buka tab **Bank Advance** -> Buka Riwayat staf pengaju (Verifikasi: Tercatat pencairan kasbon **+ Rp 1.500.000** dan hutang kasbon bertambah).
- [ ] **LB-010** | **[Riwayat Kasbon Batch Dicairkan]** 1. Buka Sidebar -> Menu **KASBON** -> Klik **+ Buat Pengajuan** -> Pilih **Batch** -> Ketik Judul: **Operasional Event Cabang** -> Klik **Buat**. 2. Tambah item: 'Sewa Booth Pameran', Estimasi: Rp 5.000.000 -> Simpan. 3. Klik **Submit Kasbon** -> Approve item di Tabel 1. 4. Di Tabel 2, pilih Bank Sumber yang ada saldo -> Approve Pencairan -> Klik **Setujui Final Kasbon**. 5. Buka menu **BANK** -> Buka Riwayat Bank Cash sumber dan Riwayat Bank Advance staf pengaju. 6. Verifikasi: Di kedua riwayat tercantum judul kegiatan **Operasional Event Cabang** dan nominal Rp 5.000.000.
- [ ] **LB-011** | **[Riwayat Pengembalian Sisa Kasbon]** 1. Buka Sidebar -> Menu **KASBON** -> Klik tombol biru **+ Buat Kasbon** di pojok kanan atas -> Muncul dialog peringatan *'Perhatian: Outstanding Kasbon'*. 2. Pada dialog tersebut, klik tombol **Kembalikan Dana Sekarang** -> Terbuka form 'Pengembalian Dana Langsung'. 3. Pilih Sumber Bank: **Mandiri** -> Masukkan Nominal: **100.000** -> Unggah bukti transfer -> Klik tombol biru **Simpan**. 4. Buka menu **BANK** -> tab **Bank Advance** -> Buka Riwayat staf peminjam. 5. Verifikasi: Tercatat pemulihan Saldo Virtual Advance (**+ Rp 100.000**) dan pelunasan/pengurangan Hutang Kasbon berjalan (**- Rp 100.000**).
- [ ] **LB-012** | **[Riwayat Settlement Selesai Pas Kasbon]** 1. Buka Sidebar -> Menu **SETTLEMENTS** -> Klik **+ Buat Settlement** -> Pilih Single -> Buat. 2. Di Tabel 1, klik **+ Tambah Pengeluaran** -> Nama: 'Belanja Perlengkapan', Qty: 1, Harga: Rp 2.000.000 (sama persis dengan kasbon Rp 2.000.000 yang dimiliki staf) -> Upload bukti struk -> Simpan. 3. Submit Settlement -> Approve nota pengeluaran -> Klik **Setujui Final Settlement**. 4. Buka menu **BANK** -> tab **Bank Advance** -> Buka Riwayat staf -> Verifikasi: Tercatat realisasi belanja dan sisa hutang kasbon staf lunas (Rp 0).
- [ ] **LB-013** | **[Riwayat Settlement Nombok Reimbursement]** 1. Buka Sidebar -> Menu **SETTLEMENTS** -> Buat pengajuan settlement di mana total nota belanja lebih besar dari kasbon staf (misal: Kasbon staf Rp 2.000.000, tapi staf input belanja Rp 2.500.000 sehingga nombok Rp 500.000). 2. Approve nota belanja di Tabel 1. 3. Di Tabel 2 Reimbursement, pilih Bank Cash sumber penggantian: **Mandiri** -> Klik Approve -> Klik **Setujui Final Settlement**. 4. Buka menu **BANK** -> tab **Bank Cash** -> Buka Riwayat Bank Mandiri -> Verifikasi: Tercatat pengeluaran ganti nombok kantor merah **- Rp 500.000**.
- [ ] **LB-014** | **[Riwayat Settlement Lebih & Kembalian Sisa]** 1. Buka Sidebar -> Menu **SETTLEMENTS** -> Buat settlement di mana total belanja lebih kecil dari kasbon (misal: Kasbon staf Rp 2.000.000, tapi staf hanya belanja Rp 1.200.000 sehingga ada sisa uang kasbon Rp 800.000). 2. Di bagian pengembalian sisa, pilih Bank Cash penerima: **Mandiri** dan upload bukti setor kembalian Rp 800.000 -> Klik **Setujui Final Settlement**. 3. Buka menu **BANK** -> tab **Bank Cash** -> Buka Riwayat Bank Mandiri -> Verifikasi: Tercatat uang masuk pengembalian sisa hijau **+ Rp 800.000**.
- [ ] **LB-015** | **[Riwayat Revenue Pemasukan]** 1. Buka Sidebar -> Menu **Revenue Management** -> Klik tombol **+ Tambah Pemasukan**. 2. Isi Kategori: 'Pendapatan Proyek', Pilih Bank: **Mandiri**, Nominal: **25.000.000**, Upload Bukti Setor -> Klik **Simpan**. 3. Buka menu **BANK** -> tab **Bank Cash** -> Klik Mandiri -> Buka **Riwayat Aktivitas / Log Book**. 4. Verifikasi: Tercatat transaksi Revenue uang masuk **+ Rp 25.000.000**.
- [ ] **LB-016** | **[Riwayat Pembagian Dividen]** 1. Buka Sidebar -> Menu **Dividend Management** -> Klik tombol **+ Bagi Dividen**. 2. Isi Nama Penerima: 'Pemegang Saham A', Pilih Bank Sumber: **Mandiri**, Nominal: **10.000.000**, Upload Bukti -> Klik **Simpan**. 3. Buka menu **BANK** -> tab **Bank Cash** -> Klik Mandiri -> Buka **Riwayat Aktivitas / Log Book**. 4. Verifikasi: Tercatat transaksi Dividen uang keluar **- Rp 10.000.000**.
- [ ] **LB-017** | **[Riwayat Tambah Kas Manual (+)]** 1. Buka menu **BANK** -> tab **Bank Cash** -> Klik kartu Bank Mandiri -> Klik tombol hijau **Kelola Cash/Uang**. 2. Pilih toggle hijau **(+) Tambah** -> Ketik nominal **5.000.000** -> Klik **Simpan**. 3. Buka tombol putih **Riwayat Aktivitas / Log Book** Bank Mandiri. 4. Verifikasi: Tercatat transaksi 'Penambahan Saldo Kas Riil' sebesar **+ Rp 5.000.000** lengkap dengan nama akun Anda sebagai pengubah.
- [ ] **LB-018** | **[Riwayat Tarik Kas Manual (-)]** 1. Buka menu **BANK** -> tab **Bank Cash** -> Klik kartu Bank Mandiri -> Klik tombol hijau **Kelola Cash/Uang**. 2. Pilih toggle merah **(-) Kurang** -> Ketik nominal **1.000.000** -> Klik **Simpan**. 3. Buka tombol putih **Riwayat Aktivitas / Log Book** Bank Mandiri. 4. Verifikasi: Tercatat transaksi 'Pengurangan Saldo Kas Riil' sebesar **- Rp 1.000.000**.
- [ ] **LB-019** | **[Pencegahan Riwayat Palsu Saat Transaksi Gagal]** 1. Buka menu **BANK** -> tab **Bank Cash** -> Klik Bank Mandiri (saldo misal Rp 10.000.000) -> Klik **Kelola Cash/Uang**. 2. Pilih toggle merah (-) Kurang -> Masukkan nominal melebihi saldo: **50.000.000** -> Klik Simpan. 3. Sistem menolak dengan notifikasi 'Saldo tidak mencukupi'. 4. Buka **Riwayat Aktivitas / Log Book** Bank Mandiri -> Verifikasi: TIDAK ADA catatan mutasi yang masuk (riwayat tetap bersih karena transaksi gagal).
- [ ] **LB-020** | **[Riwayat Penolakan Kasbon di Timeline]** 1. Buka menu **KASBON** -> Buka salah satu kasbon staf yang berstatus 'Submitted'. 2. Di Tabel 1, klik ikon silang merah **Reject** pada salah satu item -> Ketik catatan teguran: 'Lampiran estimasi belum lengkap' -> Kirim. 3. Klik tombol **Timeline Progres** di pojok kanan atas layar kasbon. 4. Verifikasi: Tercatat riwayat penolakan lengkap dengan nama manager, jam penolakan, dan isi teguran 'Lampiran estimasi belum lengkap'.
- [ ] **LB-021** | **[Riwayat Siklus Dokumen Lengkap di Timeline]** 1. Pada dokumen Kasbon, lakukan alur lengkap: Staf Submit -> Manager Tolak -> Staf Perbaiki & Submit Ulang -> Manager Setujui -> Finance Cairkan. 2. Klik tombol **Timeline Progres** di kanan atas kasbon. 3. Verifikasi: Seluruh jejak proses persetujuan (Draft -> Submitted -> Rejected -> Resubmitted -> Approved -> Disbursed) tersusun urut dari awal hingga akhir.
- [ ] **LB-022** | **[Timeline Progres Dokumen Settlement]** 1. Buka menu **SETTLEMENTS** -> Buka salah satu dokumen settlement yang sudah disetujui atau berstatus 'Completed'. 2. Klik tombol **Timeline Progres** di pojok kanan atas. 3. Verifikasi: Menampilkan visual tahapan persetujuan pengeluaran lengkap dengan nama penanggung jawab dan tanggal/jam eksekusi.
- [ ] **LB-023** | **[Pencegahan Riwayat Ganda (Anti Spam Klik)]** 1. Buka menu **BANK** -> tab **Bank Advance** -> Klik salah satu staf -> Klik **Kelola Advance/Uang** -> Isi nominal Rp 100.000. 2. Klik tombol **Simpan Penyesuaian Saldo** berkali-kali secara sangat cepat (spam click 3-5 kali). 3. Buka **Riwayat Aktivitas / Log Book** staf. 4. Verifikasi: Transaksi hanya tercatat tepat 1 baris mutasi Rp 100.000 (tidak ada duplikasi/baris ganda).
- [ ] **LB-024** | **[Pemisahan Riwayat Antar Perusahaan]** 1. Buka menu **BANK** -> Buka Riwayat Aktivitas pada Perusahaan A. 2. Buka Sidebar -> Menu **Pengaturan** -> Ganti ke Perusahaan B -> Buka menu **BANK** di Perusahaan B. 3. Verifikasi: Riwayat transaksi Perusahaan A tidak muncul di Perusahaan B (data terpisah 100% per perusahaan).
- [ ] **LB-025** | **[Riwayat Tetap Utuh Pasca Restart]** 1. Buka menu **BANK** -> Lakukan transaksi alokasi saldo atau kasbon. 2. Lakukan Hot Restart aplikasi atau tekan F5 pada browser. 3. Buka kembali **Riwayat Aktivitas / Log Book**. 4. Verifikasi: Seluruh daftar riwayat tetap tersimpan utuh di database dan tidak ada data yang hilang.

---

## MODUL 03: KASBON / ADVANCE (LIST, DETAIL & STATE MACHINE)
_Pengujian pembuatan, input detail form item kasbon, state machine persetujuan, dan pencairan finance._

- [ ] **KB-001** | **[Buat Kasbon Single]** 1. Buka Sidebar -> Klik menu **KASBON**. 2. Klik tombol biru **+ Buat Kasbon** di pojok kanan atas (Jika muncul popup peringatan outstanding, klik tombol *Lanjut Buat Pengeluaran*). 3. Pilih radio **Single** -> Pilih Tahun: **2026** -> Klik tombol biru **Buat**. 4. Verifikasi: Layar langsung masuk ke halaman formulir detail kasbon baru.
- [ ] **KB-002** | **[Buat Kasbon Batch]** 1. Buka Sidebar -> Klik menu **KASBON**. 2. Klik tombol biru **+ Buat Kasbon** di pojok kanan atas. 3. Pilih radio **Batch** -> Masukkan Judul Kegiatan: **'Kegiatan Riset Lapangan'** -> Pilih Tanggal. 4. Klik tombol biru **Buat**. 5. Verifikasi: Dokumen kasbon Batch berhasil terbuat dan masuk ke halaman formulir item batch.
- [ ] **KB-003** | **[Outstanding Kasbon Guard]** 1. Buka menu **KASBON** menggunakan akun staf yang sedang memiliki sisa hutang kasbon berjalan. 2. Klik tombol biru **+ Buat Kasbon** di pojok kanan atas. 3. Verifikasi: Muncul modal dialog peringatan bertuliskan merah *'Perhatian: Outstanding Kasbon'* beserta nominal sisa kasbon yang belum dipertanggungjawabkan.
- [ ] **KB-004** | **[Lanjutkan di Tengah Outstanding]** 1. Pada dialog peringatan Outstanding Kasbon, klik tombol biru **Lanjut Buat Pengeluaran**. 2. Verifikasi: Dialog tertutup dan form pilihan Single/Batch terbuka sehingga staf tetap dapat membuat pengajuan kasbon baru.
- [ ] **KB-005** | **[Validasi Batch Kosong]** 1. Buka menu **KASBON** -> Klik tombol **+ Buat Kasbon** -> Pilih opsi **Batch**. 2. Kosongkan kolom 'Judul Kegiatan' -> Klik tombol **Buat**. 3. Verifikasi: Sistem menolak dan memunculkan pesan error merah 'Judul kegiatan wajib diisi'.
- [ ] **KB-006** | **[Form Tambah Item Kasbon]** 1. Di dalam halaman detail Kasbon, klik tombol hijau **+ Tambah Item** di Tabel 1. 2. Isi Form: Pilih Tanggal, Pilih Kategori (misal: 'ATK & Perlengkapan'), Ketik Deskripsi Keperluan: 'Beli ATK Kantor', Ketik Estimasi: **1.500.000**. 3. Klik **Simpan**. 4. Verifikasi: Baris item baru muncul di Tabel 1 dengan nominal Rp 1.500.000.
- [ ] **KB-007** | **[Quick Add Category Inline]** 1. Pada modal popup Tambah Item Kasbon, klik tombol **+ Kategori Baru** di samping dropdown kategori. 2. Masukkan nama kategori baru: 'Operasional Lapangan' -> Klik Simpan. 3. Verifikasi: Kategori baru langsung tersimpan dan otomatis terpilih di dropdown kategori.
- [ ] **KB-008** | **[Form Edit Item Kasbon]** 1. Di Tabel 1 Kasbon, klik ikon pensil / edit pada baris item kasbon. 2. Ubah nominal estimasi dari Rp 1.500.000 menjadi **2.000.000** -> Klik Simpan. 3. Verifikasi: Total Pengajuan di kartu ringkasan atas langsung naik menjadi Rp 2.000.000.
- [ ] **KB-009** | **[Sapu Jagat Bulk Delete]** 1. Centang kotak checkbox di samping 2 atau lebih baris item di Tabel 1 kasbon. 2. Klik tombol merah bertuliskan **Hapus Terpilih** di toolbar tabel atas. 3. Verifikasi: Semua baris yang dicentang terhapus sekaligus.
- [ ] **KB-010** | **[Submit Kasbon]** 1. Setelah mengisi item belanja di Tabel 1, staf klik tombol hijau **Submit Kasbon** di pojok kanan bawah. 2. Pada dialog konfirmasi, klik tombol **Ya, Kirim**. 3. Verifikasi: Status dokumen berubah menjadi 'Submitted' dan tombol edit item terkunci.
- [ ] **KB-011** | **[Manager Approve Item]** 1. Login sebagai Manager -> Buka dokumen kasbon berstatus 'Submitted'. 2. Di Tabel 1, klik ikon centang hijau **Approve** pada baris item belanja. 3. Verifikasi: Status item berubah menjadi 'Approved' berwarna hijau.
- [ ] **KB-012** | **[Manager Reject & Checklist Form]** 1. Login sebagai Manager -> Di Tabel 1, klik ikon silang merah **Reject** pada baris item. 2. Muncul dialog checklist penolakan -> Ketik alasan teguran: 'Lampiran estimasi belum lengkap' -> Klik **Kirim Teguran**. 3. Verifikasi: Status item berubah menjadi 'Rejected' (merah).
- [ ] **KB-013** | **[Strict Reject & Fix Staf]** 1. Login sebagai Staf pengaju -> Buka dokumen kasbon yang itemnya ditolak. 2. Klik ikon teguran merah pada baris item -> Centang SEMUA poin checklist perbaikan -> Klik tombol **Simpan Perbaikan**. 3. Verifikasi: Status item pulih kembali menjadi pending/submitted.
- [ ] **KB-014** | **[Strict Reject Lock]** 1. Pada modal popup teguran perbaikan item, centang hanya sebagian poin (jangan centang semua poin). 2. Klik tombol Simpan. 3. Verifikasi: Sistem menolak submit ulang dan memberi peringatan 'Wajib menyelesaikan semua poin perbaikan'.
- [ ] **KB-015** | **[Gerbang Tabel 2 Terkunci]** 1. Amati Tabel 2 (Pencairan Dana) saat masih ada item di Tabel 1 yang statusnya Pending atau Rejected (Tabel 2 dalam kondisi abu-abu/terkunci). 2. Klik centang hijau Approve pada 100% item di Tabel 1 -> Verifikasi: Tabel 2 otomatis terbuka dan siap diproses.
- [ ] **KB-016** | **[Finance Disbursement Form]** 1. Login sebagai Finance / Manager -> Buka bagian Tabel 2 Pencairan. 2. Pilih Bank Sumber (misal: **Mandiri**), pilih Tanggal Transfer, upload foto struk transfer -> Klik tombol hijau **Approve Pencairan**. 3. Verifikasi: Status pencairan di Tabel 2 berubah menjadi 'Disbursed'.
- [ ] **KB-017** | **[Insufficient Balance Check]** 1. Di Tabel 2 Pencairan, pilih rekening bank yang saldonya lebih kecil dari nominal kasbon (misal pilih bank bersaldo Rp 500.000 untuk mencairkan kasbon Rp 10.000.000). 2. Klik tombol Approve Pencairan. 3. Verifikasi: Sistem menolak dengan dialog alarm peringatan 'Saldo Bank Tidak Mencukupi'.
- [ ] **KB-018** | **[Setujui Final Kasbon]** 1. Setelah Tabel 1 dan Tabel 2 selesai disetujui, klik tombol biru **Setujui Final Kasbon** di pojok kanan bawah. 2. Verifikasi: Status dokumen berubah permanen menjadi 'Completed' dan saldo hutang kasbon staf resmi bertambah.

---

## MODUL 04: SETTLEMENT / PENGELUARAN (FORM EXPENSE & PAJAK)
_Pengujian form input nota pengeluaran detail, kalkulasi pajak PPN/PPh, multi-lampiran bukti struk, dan pencairan nombok._

- [ ] **ST-001** | **[Buat Settlement Single]** 1. Buka Sidebar -> Klik menu **SETTLEMENTS**. 2. Klik tombol biru **+ Buat Settlement** di pojok kanan atas. 3. Pilih radio **Single** -> Pilih Tahun: **2026** -> Klik tombol biru **Buat**. 4. Verifikasi: Layar langsung masuk ke halaman detail form Settlement baru.
- [ ] **ST-002** | **[Buat Settlement Batch]** 1. Buka Sidebar -> Klik menu **SETTLEMENTS**. 2. Klik tombol biru **+ Buat Settlement**. 3. Pilih radio **Batch** -> Masukkan Judul Kegiatan: **'Operasional Kantor Cabang'** -> Pilih Tanggal. 4. Klik **Buat**. 5. Verifikasi: Dokumen settlement Batch berhasil terbuat.
- [ ] **ST-003** | **[Filter & Search Debounce]** 1. Buka menu **SETTLEMENTS**. 2. Ketik kata 'Cabang' di kolom pencarian atas. 3. Pada filter dropdown status, pilih 'Draft'. 4. Verifikasi: Daftar dokumen langsung menyaring hasil pencarian secara instan dan tepat.
- [ ] **ST-004** | **[Export Excel & PDF Guard]** 1. Buka dokumen settlement berstatus 'Draft' -> Verifikasi: Tombol Export di pojok kanan atas disembunyikan/disabled. 2. Buka dokumen yang sudah berstatus 'Completed' -> Verifikasi: Tombol Export Excel & PDF muncul aktif di pojok kanan atas.
- [ ] **ST-005** | **[Bulk Delete Berbasis Role]** 1. Login sebagai Staf -> Masuk menu Settlements -> Verifikasi staf hanya diizinkan menghapus dokumen berstatus 'Draft'. 2. Login sebagai Manager -> Verifikasi Manager memiliki opsi menghapus dokumen status apa pun dengan konfirmasi dialog.
- [ ] **ST-006** | **[Form Tambah Expense Detail]** 1. Di Tabel 1 Settlement, klik tombol hijau **+ Tambah Pengeluaran**. 2. Isi Form: Pilih Tanggal, Pilih Kategori: 'ATK & Perlengkapan', Nama Pengeluaran: 'Kertas HVS A4', Qty: **5**, Satuan: 'Rim', Harga: **50.000**. 3. Verifikasi: Kolom Subtotal otomatis terhitung **Rp 250.000**.
- [ ] **ST-007** | **[Pajak PPN 11% Toggle]** 1. Pada form tambah pengeluaran, aktifkan switch toggle **Kena Pajak**. 2. Pilih jenis pajak: **PPN 11%**. 3. Verifikasi: Nominal PPN otomatis terhitung **Rp 27.500** dan Total Akhir belanja menjadi **Rp 277.500**.
- [ ] **ST-008** | **[Pajak PPh 23 Potongan]** 1. Pada form tambah pengeluaran, aktifkan toggle Pajak -> Pilih jenis pajak: **PPh 23 (2%)**. 2. Verifikasi: Nilai potongan pajak otomatis dihitung sebagai pengurang dan total yang dibayarkan berkurang sesuai rumus potongan.
- [ ] **ST-009** | **[Multi-Image Evidence Upload]** 1. Pada form pengeluaran, klik area hijau **Upload Bukti Struk**. 2. Pilih 2 atau 3 file foto struk/PDF sekaligus. 3. Verifikasi: Seluruh thumbnail gambar struk muncul di form dengan tombol ikon sampah merah untuk hapus per file.
- [ ] **ST-010** | **[Image Preview Zoom & Rotate]** 1. Klik salah satu thumbnail gambar bukti struk yang telah diunggah. 2. Muncul modal preview gambar besar -> Coba klik tombol Zoom In (+), Zoom Out (-), dan tombol Putar/Rotasi 90°. 3. Verifikasi: Tampilan gambar merespons mulus sesuai tombol interaksi.
- [ ] **ST-011** | **[Validasi Wajib Bukti Struk]** 1. Tambah baris pengeluaran tanpa melampirkan foto bukti struk sama sekali. 2. Coba klik tombol **Submit Settlement**. 3. Verifikasi: Sistem menolak submit dan menampilkan pesan error peringatan 'Setiap baris belanja wajib melampirkan bukti struk'.
- [ ] **ST-012** | **[Warning Box Proyeksi Dompet]** 1. Pada staf yang memiliki kasbon Rp 2.000.000, input total nota belanja yang disetujui sebesar Rp 1.200.000. 2. Periksa kartu Proyeksi Dompet di atas. 3. Verifikasi: Kotak Proyeksi menampilkan status hijau bertuliskan **'Sisa Kasbon Rp 800.000'**.
- [ ] **ST-013** | **[Kondisi Nombok (Reimbursement)]** 1. Pada staf yang memiliki kasbon Rp 2.000.000, input total nota belanja sebesar Rp 2.500.000. 2. Periksa kartu Proyeksi Dompet. 3. Verifikasi: Kotak Proyeksi menampilkan status merah bertuliskan **'Nombok / Reimbursement Rp 500.000'** dan Tabel 2 (Pencairan Nombok) otomatis aktif.
- [ ] **ST-014** | **[Pencegatan Kategori Unapproved]** 1. Coba klik centang approve pada baris pengeluaran yang kategorinya masih berstatus Pending/Unapproved di menu Kategori. 2. Verifikasi: Sistem menolak approve dan menampilkan pesan 'Kategori harus disahkan terlebih dahulu'.
- [ ] **ST-015** | **[Strict Reject & Fix Staf]** 1. Manager klik tolak (silang merah) pada salah satu nota pengeluaran -> Ketik catatan teguran. 2. Staf buka dialog teguran -> Centang semua poin perbaikan -> Klik Simpan. 3. Verifikasi: Baris pengeluaran pulih dan siap diapprove ulang oleh Manager.
- [ ] **ST-016** | **[Final Settlement]** 1. Pastikan seluruh nota belanja di Tabel 1 sudah diapprove dan Tabel 2 (jika ada nombok) selesai diproses. 2. Klik tombol biru **Setujui Final Settlement** di pojok kanan bawah. 3. Verifikasi: Status dokumen berubah menjadi 'Completed' dan riwayat mutasi otomatis terposting.

---

## MODUL 05: STANDALONE RETURN (PELUNASAN KASBON MANDIRI)
_Pengujian pengembalian sisa kasbon langsung tanpa melalui settlement panjang._

- [ ] **RT-001** | **[Buka Form Pengembalian Mandiri]** 1. Buka Sidebar -> Menu **KASBON** -> Klik tombol biru **+ Buat Kasbon** di kanan atas -> Pada popup dialog 'Perhatian: Outstanding Kasbon', klik **Kembalikan Dana Sekarang**. 2. Verifikasi: Modal dialog 'Pengembalian Dana Langsung' terbuka.
- [ ] **RT-002** | **[Dropdown Rekening Bank Penerima]** 1. Di dalam form 'Pengembalian Dana Langsung', klik dropdown **Sumber Bank**. 2. Verifikasi: Daftar rekening bank kantor muncul lengkap dengan informasi saldo fisik masing-masing bank.
- [ ] **RT-003** | **[Auto-Format Currency]** 1. Ketik angka '1500000' di kolom nominal pengembalian. 2. Verifikasi: Teks otomatis terformat dengan separator ribuan menjadi **Rp 1.500.000**.
- [ ] **RT-004** | **[Validasi Nominal < Rp 100]** 1. Pada kolom nominal pengembalian, masukkan angka '0' atau '50'. 2. Klik tombol **Simpan**. 3. Verifikasi: Sistem menolak dan memunculkan notifikasi error merah 'Nominal minimal Rp 100'.
- [ ] **RT-005** | **[Validasi Bukti Transfer]** 1. Masukkan nominal Rp 500.000 tanpa memilih file bukti transfer. 2. Klik tombol **Simpan**. 3. Verifikasi: Sistem menolak dengan notifikasi 'Bukti transfer wajib diunggah'.
- [ ] **RT-006** | **[Visual Tombol Upload Sukses]** 1. Klik area hijau **Pilih File Bukti Transfer** -> Pilih 1 foto struk atau file PDF transfer. 2. Verifikasi: Tombol berubah warna hijau pekat dan menampilkan nama file yang diunggah.
- [ ] **RT-007** | **[Eksekusi Sukses & Sinkronisasi]** 1. Isi lengkap: Pilih Sumber Bank **Mandiri**, Pilih Kasbon bersisa, Nominal: **100.000**, Upload bukti -> Klik tombol **Simpan**. 2. Buka tab **Bank Advance** -> Verifikasi: Hutang kasbon staf berkurang Rp 100.000 dan saldo virtual Bank Advance staf pulih bertambah kembali Rp 100.000 secara real-time.

---

## MODUL 06: MANAJEMEN KATEGORI & KANBAN TABULAR
_Pengujian struktur Kategori Utama/Sub, approval pending, reorder drag-drop, dan papan Kanban._

- [ ] **CAT-001** | **[Hierarki Kategori]** 1. Buka Sidebar -> Klik menu **Kategori**. 2. Klik salah satu Kategori Utama. 3. Verifikasi: Expansion tile terbuka menampilkan daftar sub-kategori di dalamnya.
- [ ] **CAT-002** | **[Section Kategori Pending]** 1. Buka menu Kategori. 2. Jika ada kategori baru diajukan staf, periksa bagian atas layar. 3. Verifikasi: Muncul kotak oranye 'Kategori Pending' dengan tanda tree |-.
- [ ] **CAT-003** | **[Pencegatan Approve Sub-Kategori]** 1. Saat Kategori Utama & Sub-kategori sama-sama pending, coba klik tombol approve sub. 2. Verifikasi: Tombol disabled dengan pesan 'Approve kategori utama dulu'.
- [ ] **CAT-004** | **[Approve Berurutan]** 1. Klik tombol hijau Approve pada Kategori Utama. 2. Verifikasi: Tombol approve pada sub-kategori langsung menyala aktif dan siap diklik.
- [ ] **CAT-005** | **[Form Tambah Kategori Utama]** 1. Buka menu Kategori -> Klik tombol **+ Tambah Kategori**. 2. Pilih Radio 'Kategori Utama' -> Nama: 'Beban Operasional' -> Klik Simpan. 3. Verifikasi: Kategori utama baru terdaftar.
- [ ] **CAT-006** | **[Form Tambah Sub-Kategori]** 1. Klik + Tambah Kategori -> Pilih Radio 'Sub Kategori' -> Pilih Utama: 'Beban Operasional' -> Nama: 'Konsumsi Rapat'. 2. Simpan. 3. Verifikasi: Sub-kategori baru terdaftar di bawah induknya.
- [ ] **CAT-007** | **[Validasi Sub Kategori Tanpa Parent]** 1. Pilih Radio 'Sub Kategori' -> Kosongkan pilihan Kategori Utama. 2. Klik Simpan. 3. Verifikasi: Sistem menolak 'Pilih Kategori Utama terlebih dahulu'.
- [ ] **CAT-008** | **[Hapus Kategori Berelasi]** 1. Coba hapus kategori yang sudah pernah digunakan pada nota expense. 2. Verifikasi: Muncul dialog peringatan ketat integritas database menolak penghapusan.
- [ ] **CAT-009** | **[Buka Kategori Tabular]** 1. Buka menu Kategori -> Klik tombol **Kategori Tabular** di kanan atas. 2. Verifikasi: Layar konfigurasi urutan kolom Excel tahunan terbuka.
- [ ] **CAT-010** | **[Drag-and-Drop Reorder]** 1. Tahan handle ikon drag pada Kategori urutan 3, geser ke posisi 1. 2. Verifikasi: Badge nomor urut biru seketika berganti menjadi angka 1.
- [ ] **CAT-011** | **[Buka Dialog Kanban]** 1. Buka Kategori Tabular -> Klik tombol **Atur Grup & Urutan**. 2. Verifikasi: Papan Kanban interaktif terbuka (horizontal scroll di laptop, vertikal di HP).
- [ ] **CAT-012** | **[Pindah Grup via Panah Kanan]** 1. Klik ikon panah kanan (->) pada salah satu kartu kategori di Kanban. 2. Verifikasi: Kartu berpindah ke kolom grup berikutnya di posisi paling bawah.
- [ ] **CAT-013** | **[Orphan Fallback 'LAINNYA']** 1. Periksa kategori yang tidak memiliki grup induk di Kanban. 2. Verifikasi: Ditampung otomatis pada kolom abu-abu 'LAINNYA' di ujung kanan tanpa crash.
- [ ] **CAT-014** | **[Simpan Perubahan Tabular]** 1. Klik tombol hijau besar **Simpan Perubahan** di Kanban Tabular. 2. Verifikasi: Muncul loading spinner blocking dan susunan kolom tersimpan ke database.

---

## MODUL 07: REVENUE MANAGEMENT (PEMASUKAN & PENDAPATAN)
_Pengujian form pemasukan uang masuk, bukti setor, dan pengaruh langsung ke rekening bank._

- [ ] **REV-001** | **[Form Tambah Revenue]** 1. Buka Sidebar -> Masuk ke **Revenue Management**. 2. Klik tombol hijau **+ Tambah Pemasukan** -> Kategori: 'Donasi / Hibah', Pilih Bank: **Mandiri**, Nominal: **25.000.000**, Upload Bukti Transfer. 3. Klik tombol biru **Simpan**. 4. Verifikasi: Transaksi baru muncul di tabel pemasukan.
- [ ] **REV-002** | **[Efek ke Bank Cash]** 1. Buka Sidebar -> Klik menu **BANK** -> tab **Bank Cash**. 2. Cek kartu Bank Mandiri. 3. Verifikasi: Saldo fisik Bank Mandiri bertambah tepat Rp 25.000.000.
- [ ] **REV-003** | **[Efek ke Logbook]** 1. Buka Detail Bank Mandiri -> Klik tombol putih **Riwayat Aktivitas / Log Book**. 2. Verifikasi: Tercatat mutasi transaksi Pemasukan (Revenue) hijau sebesar **+ Rp 25.000.000**.
- [ ] **REV-004** | **[Validasi Nominal < Rp 100]** 1. Pada form Tambah Pemasukan, masukkan nominal '0' atau '50'. 2. Klik tombol Simpan. 3. Verifikasi: Sistem menolak dengan pesan validasi error merah 'Nominal minimal Rp 100'.
- [ ] **REV-005** | **[Filter Tahun & Kategori]** 1. Buka menu Revenue Management. 2. Pilih dropdown Tahun: 2026 dan Kategori tertentu. 3. Verifikasi: Tabel rekap pemasukan menyaring data dengan presisi.
- [ ] **REV-006** | **[Edit Revenue]** 1. Edit nominal revenue dari Rp 25.000.000 menjadi Rp 30.000.000 -> Simpan. 2. Verifikasi: Saldo rekening penerima terkoreksi bertambah selisih Rp 5.000.000.
- [ ] **REV-007** | **[Hapus Revenue]** 1. Hapus salah satu data revenue Rp 5.000.000. 2. Verifikasi: Saldo bank penerima terpotong kembali Rp 5.000.000 dan logbook mencatat penyesuaian.

---

## MODUL 08: TAX MANAGEMENT, COMBINE GROUPS & TABEL NDPV
_Pengujian manajemen tarif pajak, pengelompokan pajak tahunan, dan kalkulator tabel NDPV._

- [ ] **TAX-001** | **[Form Tambah Pajak]** 1. Buka Sidebar -> Masuk ke **Tax Management**. 2. Klik **+ Tambah Pajak** -> Nama: 'PPh 21 Pegawai', Persentase: 5%, Tahun: 2026 -> Klik **Simpan**. 3. Verifikasi: Pajak baru terdaftar.
- [ ] **TAX-002** | **[Combine Groups Pajak]** 1. Di menu Tax Management, buka fitur **Combine Groups**. 2. Kelompokkan pajak PPh 21 dan PPh 23 ke dalam 1 grup tahunan -> Klik Simpan. 3. Verifikasi: Struktur grup tersimpan.
- [ ] **TAX-003** | **[Dialog Tabel NDPV]** 1. Di menu Tax Management, buka dialog tabel NDPV. 2. Verifikasi: Kolom Nilai Dasar Pengenaan Pajak (DPP), Tarif Pajak, dan Pajak Terutang terhitung akurat sesuai rumus.
- [ ] **TAX-004** | **[Integrasi ke Laporan Tahunan Sheet 2]** 1. Buka Laporan Tahunan (Annual Report) Sheet 2. 2. Verifikasi: Baris pajak terhitung dan terkelompokkan persis sesuai konfigurasi Tax Management.

---

## MODUL 09: DIVIDEND MANAGEMENT (BAGI HASIL & DIVIDEN)
_Pengujian pembagian dividen ke pemegang saham, pemotongan kas bank, dan bukti transfer._

- [ ] **DIV-001** | **[Form Bagi Dividen]** 1. Buka Sidebar -> Masuk ke **Dividend Management**. 2. Klik tombol hijau **+ Bagi Dividen** -> Nama Penerima: 'Pemegang Saham A', Pilih Bank Sumber: **Mandiri**, Nominal: **10.000.000**, Upload Bukti Transfer. 3. Klik tombol biru **Simpan**.
- [ ] **DIV-002** | **[Efek ke Bank Cash]** 1. Buka Sidebar -> Klik menu **BANK** -> tab **Bank Cash**. 2. Cek saldo Bank Mandiri. 3. Verifikasi: Saldo fisik Bank Mandiri otomatis terpotong Rp 10.000.000.
- [ ] **DIV-003** | **[Efek ke Logbook]** 1. Buka Detail Bank Mandiri -> Klik Riwayat Aktivitas / Log Book. 2. Verifikasi: Tercatat mutasi Pengeluaran Dividen merah sebesar **- Rp 10.000.000**.
- [ ] **DIV-004** | **[Validasi Saldo Kurang]** 1. Pilih rekening dengan saldo Rp 5.000.000 untuk membagikan dividen Rp 15.000.000. 2. Klik Simpan. 3. Verifikasi: Sistem menolak dengan notifikasi 'Saldo tidak mencukupi'.

---

## MODUL 10: ASSET MANAGEMENT (INVENTARIS & PENYUSUTAN)
_Pengujian form aset, umur ekonomis, penyusutan otomatis, dan disposal._

- [ ] **AST-001** | **[Form Tambah Aset]** 1. Buka Sidebar -> Masuk ke **Asset Management**. 2. Klik **+ Tambah Aset** -> Nama: 'MacBook Pro M3', Tgl: 1 Feb 2026, Harga: Rp 30.000.000, Umur: 4 Tahun, Residu: Rp 2.000.000 -> Simpan.
- [ ] **AST-002** | **[Kalkulasi Penyusutan Otomatis]** 1. Buka tabel rincian aset di Asset Management. 2. Verifikasi: Sistem menghitung nilai penyusutan depresiasi per bulan/tahun secara otomatis tanpa manual.
- [ ] **AST-003** | **[Nilai Buku Terkini]** 1. Cek kolom Nilai Buku pada tabel aset. 2. Verifikasi: Nilai Buku = Harga Perolehan - Akumulasi Penyusutan.
- [ ] **AST-004** | **[Penghapusan / Disposal Aset]** 1. Klik opsi **Disposal / Hapus Aset** -> Masukkan nilai jual sisa (jika ada). 2. Simpan. 3. Verifikasi: Status aset berubah menjadi 'Disposed'.

---

## MODUL 11: USER MANAGEMENT & HAK AKSES (MANAGER ONLY)
_Pengujian pembuatan akun, assign role, ganti password user, dan status aktif/nonaktif._

- [ ] **USR-001** | **[Lihat Account List]** 1. Login sebagai Manager -> Buka Sidebar menu **Pengaturan**. 2. Klik **Lihat Account List** di panel Manager. 3. Verifikasi: Daftar seluruh akun pengguna muncul.
- [ ] **USR-002** | **[Form Buat User Baru]** 1. Di panel Account List, klik tombol **+ Tambah Pengguna**. 2. Isi Username, Nama, Email, Password, Role (Staff/Manager/Finance/Admin), Perusahaan -> Simpan. 3. Verifikasi: User baru terdaftar.
- [ ] **USR-003** | **[Form Edit User]** 1. Klik ikon edit pada salah satu akun user di daftar. 2. Ubah Role atau Reset Password -> Simpan. 3. Verifikasi: Data akun berhasil ter-update.
- [ ] **USR-004** | **[Nonaktifkan User]** 1. Ubah status akun user menjadi 'Nonaktif' -> Simpan. 2. Coba logout dan login menggunakan akun tersebut. 3. Verifikasi: Sistem menolak login akun nonaktif.
- [ ] **USR-005** | **[User Detail Dialog]** 1. Klik nama user pada daftar akun. 2. Verifikasi: Modal profil user terbuka menampilkan ringkasan peran, email, dan tanggal bergabung.

---

## MODUL 12: COMPANY MANAGEMENT & MULTI-TENANCY
_Pengujian entitas perusahaan, logo, switch active company, dan isolasi data._

- [ ] **CMP-001** | **[Kelola Perusahaan Dialog]** 1. Login sebagai Admin/Manager -> Buka Sidebar menu **Pengaturan** -> Klik **Kelola Perusahaan**. 2. Verifikasi: Daftar PT/Yayasan yang terdaftar ditampilkan.
- [ ] **CMP-002** | **[Form Tambah Perusahaan Baru]** 1. Di modal Kelola Perusahaan, klik **+ Tambah Perusahaan**. 2. Isi Nama: 'PT Inovasi Solusi', Kode: 'INS', Alamat, Upload Logo -> Klik Simpan. 3. Verifikasi: Perusahaan baru berhasil dibuat.
- [ ] **CMP-003** | **[Form Edit Perusahaan]** 1. Klik tombol Edit pada perusahaan -> Ubah nama atau alamat -> Klik Simpan. 2. Verifikasi: Nama perusahaan langsung ter-update di header aplikasi.
- [ ] **CMP-004** | **[Isolasi Data Antar-Perusahaan]** 1. Login ke Perusahaan A -> Catat data transaksi. 2. Pindah/Switch ke Perusahaan B -> Verifikasi: Data Perusahaan A TIDAK PERNAH BOCOR ke Perusahaan B.

---

## MODUL 13: REPORT SUMMARY (LAPORAN BULANAN)
_Pengujian tabel 12 bulan, sticky scroll headers, dan kalkulasi client-side._

- [ ] **RP-001** | **[Tampilan Matriks 12 Bulan]** 1. Buka Sidebar -> Klik menu **Laporan** -> tab **Report Summary**. 2. Verifikasi: Tabel membentang dari Jan s/d Des, diapit kolom Kategori di kiri dan TOTAL di kanan.
- [ ] **RP-002** | **[Diagonal Clamping Sync]** 1. Buka menu Laporan -> tab Report Summary. 2. Scroll tabel ke arah kanan dan bawah. 3. Verifikasi: Kolom Kategori tetap terkunci di kiri, Baris Bulan terkunci di atas, dan Grand Total terkunci di bawah.
- [ ] **RP-003** | **[Kalkulasi Grand Total Client-Side]** 1. Amati baris paling bawah (GRAND TOTAL) di Report Summary. 2. Verifikasi: Nilai grand total adalah hasil penjumlahan akurat dari Jan s/d Des tanpa selisih 1 rupiah pun.
- [ ] **RP-004** | **[Zebra Striping & Indentasi]** 1. Amati tampilan baris tabel Report Summary. 2. Verifikasi: Baris ganjil-genap memiliki warna selang-seling, dan sub-kategori memiliki indentasi masuk ke dalam.
- [ ] **RP-005** | **[Cache Info Badge]** 1. Periksa kotak label Cache Info di header laporan Report Summary. 2. Verifikasi: Menampilkan status 'CACHE' atau 'REFRESH' beserta jam pengambilan data.
- [ ] **RP-006** | **[Export Naming Format]** 1. Pilih rentang tanggal 1 Jan 2026 s/d 31 Jan 2026 -> Klik Export PDF. 2. Verifikasi: File yang terunduh bernama format 'summary_20260101_20260131.pdf'.

---

## MODUL 14: ANNUAL REPORT ENGINE (MULTI-TABEL & ZOOM)
_Pengujian mahadata tahunan, Tabel 1-4, Tabel 4A-4D, Beban Bank, dan Zoom Engine._

- [ ] **AR-001** | **[Zoom Engine (Ctrl + Mouse Wheel)]** 1. Buka Sidebar -> Klik menu **Laporan** -> tab **Annual Report**. 2. Tekan tahan tombol Ctrl lalu putar scroll mouse ke bawah. 3. Verifikasi: Tabel mengecil bertahap hingga batas 52%. Putar ke atas untuk membesar 100%.
- [ ] **AR-002** | **[Massive Horizontal Scroll Sync]** 1. Buka Annual Report. 2. Geser scrollbar horizontal pada Tabel 1. 3. Verifikasi: Seluruh tabel di bawahnya (Tabel 2 s/d Tabel 10) otomatis bergeser sejajar sinkron.
- [ ] **AR-003** | **[Direct Reference Routing]** 1. Klik salah satu ID transaksi pada sel tabel laporan tahunan. 2. Verifikasi: Aplikasi langsung melompat membuka layar Detail transaksi bersangkutan.
- [ ] **AR-004** | **[Sheet 1 (Pemasukan & Beban Langsung)]** 1. Buka Annual Report -> Pilih Sheet 1. 2. Verifikasi: Tabel Pemasukan, Biaya Operasi, dan Biaya Riset menampilkan total per bulan dengan akurat.
- [ ] **AR-005** | **[Sheet 2 (Pajak & Potongan - Tabel 4A-4D)]** 1. Buka Annual Report -> Pilih Sheet 2. 2. Verifikasi: Tabel 4A (PPh 21), 4B (PPh 23), 4C (PPN), dan 4D (Dividen) terhitung dan terdistribusi presisi.
- [ ] **AR-006** | **[Tabel Beban Bank]** 1. Buka Annual Report -> Periksa tabel pengeluaran per rekening bank. 2. Verifikasi: Total pengeluaran per bank cocok dengan mutasi riil di Bank Cash.
- [ ] **AR-007** | **[Sheet 3 (Neraca & Saldo Akhir)]** 1. Buka Annual Report -> Pilih Sheet 3. 2. Verifikasi: Tampil posisi kas akhir tahun dan perbandingan aset lancar/liabilitas.
- [ ] **AR-008** | **[Popup Bukti Lampiran Sel]** 1. Klik ikon klip dokumen pada salah satu sel angka transaksi di Annual Report. 2. Verifikasi: Pop-up gambar bukti pendukung terbuka.

---

## MODUL 15: SETTINGS, PROFILE & BALANCE SHEET CONFIGURATION
_Pengujian profil pengguna, avatar cropper, switch tema, dan konfigurasi neraca._

- [ ] **SET-001** | **[Ubah Profil & Avatar Cropper]** 1. Buka Sidebar -> Klik menu **Pengaturan**. 2. Klik pensil edit avatar -> Upload foto -> Potong foto di dialog cropper -> Simpan. 3. Verifikasi: Avatar profil ter-update.
- [ ] **SET-002** | **[Toggle Tema Gelap/Terang]** 1. Buka menu Pengaturan. 2. Klik tombol tema (Light / Dark / System). 3. Verifikasi: Seluruh warna UI aplikasi seketika berubah instan tanpa perlu reload.
- [ ] **SET-003** | **[Ganti Default Tahun Laporan]** 1. Buka menu Pengaturan. 2. Ubah dropdown Default Tahun dari 2026 ke 2025 -> Klik 'Simpan Default Tahun'. 3. Buka Kasbon/Settlement -> Verifikasi: Data otomatis menampilkan tahun 2025.
- [ ] **SET-004** | **[Google Account Link/Unlink]** 1. Buka menu Pengaturan -> Klik 'Hubungkan Google' -> Selesaikan login Google. 2. Verifikasi: Tombol berubah hijau 'Google Terhubung'. Klik lagi untuk putus tautan.
- [ ] **SET-005** | **[Balance Sheet Settings Screen]** 1. Buka Sidebar -> Menu Pengaturan -> Buka menu pengaturan neraca. 2. Konfigurasi pos akun aktiva lancar dan pasiva -> Simpan. 3. Verifikasi: Format neraca di laporan ter-update.

---

## MODUL 16: MANAGER PANEL, DATA CLEANUP & DEADLINE NOTIFIKASI
_Pengujian fitur eksklusif Manager: batas waktu notifikasi lonceng dan pembersihan darurat._

- [ ] **MGR-001** | **[Manager Panel Toggle]** 1. Login sebagai Staf -> Verifikasi tombol Manager Panel disembunyikan. 2. Login sebagai Manager -> Verifikasi tombol Manager Panel muncul di AppBar.
- [ ] **MGR-002** | **[Deadline Manager Screen]** 1. Buka Sidebar -> Menu Pengaturan -> Klik **Kelola Deadline Notifikasi**. 2. Atur batas waktu submit settlement (misal tanggal 25 setiap bulan) -> Klik Simpan. 3. Verifikasi: Pengaturan deadline tersimpan.
- [ ] **MGR-003** | **[Lonceng Notifikasi]** 1. Saat lewat batas tanggal deadline, amati ikon lonceng di AppBar atas. 2. Verifikasi: Muncul badge merah penanda angka dan daftar notifikasi teguran.
- [ ] **MGR-004** | **[Selective Data Cleanup Screen]** 1. Buka Sidebar -> Menu Pengaturan -> Buka menu Pembersihan Data Selektif -> Pilih Tahun: 2023, Tipe: 'Settlement Draft'. 2. Klik Bersihkan Data -> Ketik 'DELETE'. 3. Verifikasi: Hanya data spesifik terhapus.

---

## MODUL 17: DATABASE BACKUP, RESTORE & GLOBAL RESTART
_Pengujian export/import basis data, validasi format, dan restart global._

- [ ] **DB-001** | **[Export Database]** 1. Buka Sidebar -> Menu Pengaturan (sebagai Manager). 2. Klik tombol **Export Database**. 3. Verifikasi: File backup .sql / .db berhasil di-generate dan lokasi path file ditampilkan.
- [ ] **DB-002** | **[Import: Validasi Ekstensi]** 1. Di menu Pengaturan, klik tombol **Import Database**. 2. Coba pilih file berekstensi .pdf atau .txt. 3. Verifikasi: Sistem menolak keras file dengan pesan format tidak valid.
- [ ] **DB-003** | **[Import: Preview & Peringatan]** 1. Di menu Pengaturan, klik **Import Database** -> Pilih file backup valid .db. 2. Verifikasi: Muncul dialog preview tabel dan kotak peringatan merah bahwa database lama akan ditimpa.
- [ ] **DB-004** | **[Import: Eksekusi & Global Restart]** 1. Setujui proses import database valid. 2. Verifikasi: Sistem merestore DB dan otomatis me-restart UI aplikasi ke titik awal dengan data baru yang bersih.

---

## MODUL 18: AUTHENTICATION, SSO, OTP & COMPANY GATEWAY
_Pengujian login, register, Google SSO, lupa password OTP, dan gateway perusahaan._

- [ ] **AUT-001** | **[Login Normal]** 1. Buka layar Login -> Masukkan username & password yang benar. 2. Centang 'Remember Me' -> Klik **Login**. 3. Verifikasi: Berhasil masuk ke aplikasi.
- [ ] **AUT-002** | **[Validasi Login Kosong]** 1. Di layar Login, kosongkan username dan password. 2. Klik tombol **Login**. 3. Verifikasi: Muncul pesan validasi merah 'Field wajib diisi'.
- [ ] **AUT-003** | **[Validasi Password Pendek]** 1. Di layar Login, masukkan password kurang dari 6 karakter (contoh: 123). 2. Klik Login. 3. Verifikasi: Muncul peringatan 'Password minimal 6 karakter'.
- [ ] **AUT-004** | **[Error Jaringan & Tombol Cek IP]** 1. Putuskan koneksi backend -> Coba klik Login. 2. Verifikasi: Muncul pesan error jaringan disertai tombol bantuan **CEK IP** untuk ubah Server URL.
- [ ] **AUT-005** | **[Lupa Password Flow]** 1. Di layar Login, klik **Lupa Password** -> Masukkan email -> Minta OTP. 2. Masukkan kode OTP valid -> Buat password baru. 3. Verifikasi: Password berhasil diubah dan bisa login.
- [ ] **AUT-006** | **[Google SSO Email Baru]** 1. Klik Login Google dengan akun Gmail yang belum terdaftar. 2. Verifikasi: Redirect ke form Register dengan Email & Nama terkunci otomatis (read-only).
- [ ] **AUT-007** | **[Register Normal]** 1. Di form Register, isi form pendaftaran lengkap -> Klik Daftar. 2. Verifikasi: Muncul dialog registrasi sukses dengan delay transisi mulus mencegah layar berkedip putih.
- [ ] **AUT-008** | **[Single Company Auto-Bypass]** 1. Login menggunakan akun user yang hanya terdaftar di 1 perusahaan. 2. Verifikasi: Layar pemilihan perusahaan otomatis di-bypass langsung ke Dashboard.
- [ ] **AUT-009** | **[Multi Company Gateway]** 1. Login menggunakan user yang terdaftar di 2 perusahaan (misal: EWI & EXPANS). 2. Verifikasi: Muncul halaman gateway 'Pilih Perusahaan' -> Klik kartu -> Masuk ke dashboard.

---

## MODUL 19: MATRIKS EFEK DOMINO & SINKRONISASI GLOBAL
_Pengujian apakah tindakan pada SATU fitur secara otomatis mengalir dan memperbarui fitur-fitur lainnya secara tepat._

- [ ] **INT-001** | **[Pencairan Kasbon -> Bank Cash]** 1. Finance approve Pencairan Kasbon Rp 5.000.000 dari Bank BCA. 2. Buka menu BANK -> tab Bank Cash. 3. Verifikasi: Saldo fisik Bank BCA terpotong Rp 5.000.000.
- [ ] **INT-002** | **[Pencairan Kasbon -> Bank Advance]** 1. Setelah pencairan kasbon disetujui, buka tab Bank Advance. 2. Verifikasi: Saldo virtual staf pemohon otomatis bertambah Rp 5.000.000.
- [ ] **INT-003** | **[Pencairan Kasbon -> Logbook BCA]** 1. Buka Logbook Bank BCA. 2. Verifikasi: Tercatat mutasi Pengeluaran Kasbon sebesar Rp 5.000.000.
- [ ] **INT-004** | **[Pencairan Kasbon -> Profil Staf]** 1. Buka profil staf pemohon kasbon. 2. Verifikasi: Panel Saldo Kasbon Berjalan ter-update menjadi Rp 5.000.000.
- [ ] **INT-005** | **[Pencairan Kasbon -> Settlement Guard]** 1. Staf mencoba klik + Buat Settlement baru. 2. Verifikasi: Dialog 'Perhatian: Outstanding Kasbon' langsung aktif mencegat.
- [ ] **INT-006** | **[Submit Settlement -> Proyeksi Kasbon]** 1. Staf submit Settlement nota total Rp 3.000.000. 2. Verifikasi: Warning box proyeksi dompet menampilkan sisa kasbon staf berkurang menjadi Rp 2.000.000.
- [ ] **INT-007** | **[Final Settlement -> Hutang Berkurang]** 1. Manager klik 'Setujui Final Settlement'. 2. Verifikasi: Hutang kasbon staf di database resmi berkurang Rp 3.000.000.
- [ ] **INT-008** | **[Final Settlement -> Report Summary]** 1. Buka menu Laporan -> Report Summary. 2. Verifikasi: Angka pengeluaran pada bulan bersangkutan otomatis bertambah Rp 3.000.000.
- [ ] **INT-009** | **[Final Settlement -> Annual Report]** 1. Buka menu Laporan -> Annual Report. 2. Verifikasi: Seluruh Sheet (Sheet 1, 2, 3) merefleksikan penambahan pengeluaran Rp 3.000.000.
- [ ] **INT-010** | **[Standalone Return -> Kasbon Lunas]** 1. Staf mengembalikan sisa kasbon Rp 2.000.000 via Standalone Return ke Bank Mandiri. 2. Verifikasi: Sisa hutang kasbon staf menjadi Rp 0 (Lunas).
- [ ] **INT-011** | **[Standalone Return -> Bank Advance Staf]** 1. Buka menu BANK -> tab Bank Advance. 2. Verifikasi: Saldo virtual Bank Advance staf bertambah pulih kembali Rp 2.000.000.
- [ ] **INT-012** | **[Standalone Return -> Logbook Advance]** 1. Buka Logbook Bank Advance staf. 2. Verifikasi: Tercatat mutasi Pemasukan Pengembalian Dana (Plafon Virtual) Rp 2.000.000 dan pengurangan hutang.
- [ ] **INT-013** | **[Kasbon Lunas -> Bebas Peringatan]** 1. Setelah kasbon lunas Rp 0, staf klik + Buat Settlement. 2. Verifikasi: Dialog Outstanding Kasbon TIDAK MUNCUL lagi (langsung masuk form normal).
- [ ] **INT-014** | **[Revenue Baru -> Bank & Sheet 1]** 1. Tambah Revenue pemasukan Rp 50.000.000. 2. Verifikasi: Saldo Bank bertambah Rp 50.000.000 dan Laporan Tahunan Sheet 1 bertambah Rp 50.000.000.
- [ ] **INT-015** | **[Bagi Dividen -> Bank & Sheet 2]** 1. Lakukan bagi dividen Rp 10.000.000. 2. Verifikasi: Saldo Bank terpotong Rp 10.000.000 dan Laporan Sheet 2 mencatat potongan dividen.
- [ ] **INT-016** | **[Urutan Kategori -> Excel Export]** 1. Ubah urutan di Kategori Tabular -> Simpan. 2. Download Excel Tahunan. 3. Verifikasi: Kolom-kolom di Excel tersusun persis sesuai urutan baru.
- [ ] **INT-017** | **[Ganti Tahun di Settings -> Global Sync]** 1. Ganti default tahun ke 2024 di Pengaturan. 2. Verifikasi: Seluruh modul Kasbon, Settlement, Bank, Revenue, dan Report serentak memuat tahun 2024.
- [ ] **INT-018** | **[Restore DB Backup -> Global Reset]** 1. Lakukan restore database baru. 2. Verifikasi: Seluruh cache lokal terhapus, aplikasi ter-reset dari halaman login, dan menampilkan isi DB baru.

---
