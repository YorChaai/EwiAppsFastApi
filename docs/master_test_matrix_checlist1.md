# MASTER TEST MATRIX & CHECKLIST PENGUJIAN MENYELURUH (100% EXHAUSTIVE)

> **EWIAPPS — Financial & Expense Management System**  
> _Audit Lengkap Setiap Form, Input Field, Popup Dialog, Kalkulasi Pajak/NDPV, Hak Akses, Multi-Tenant, dan Efek Domino Antarfitur._

---

## 📋 DAFTAR ISI SELURUH MODUL & SUB-FITUR

1. [MODUL 1: Bank Management & Rekonsiliasi Saldo](#modul-1-bank-management)
2. [MODUL 2: Logbook, Audit Trail & Workflow Timeline](#modul-2-logbook--audit-trail)
3. [MODUL 3: Kasbon / Advance (List, Detail, Form Item & State Machine)](#modul-3-kasbon--advance)
4. [MODUL 4: Settlement / Pengeluaran (Form Expense, Pajak PPN/PPh, Multi-Bukti & State Machine)](#modul-4-settlement--pengeluaran)
5. [MODUL 5: Standalone Return (Pelunasan Mandiri & Auto-Format)](#modul-5-standalone-return)
6. [MODUL 6: Manajemen Kategori, Quick-Add Inline & Kanban Tabular](#modul-6-manajemen-kategori--kanban)
7. [MODUL 7: Revenue Management (Form Pemasukan, Kategori & Efek Saldo)](#modul-7-revenue-management)
8. [MODUL 8: Tax Management, Combine Groups & Dialog Tabel NDPV](#modul-8-tax-management--ndpv)
9. [MODUL 9: Dividend Management (Form Bagi Hasil & Validasi Bank)](#modul-9-dividend-management)
10. [MODUL 10: Asset Management (Form Aset, Depresiasi & Disposal)](#modul-10-asset-management)
11. [MODUL 11: User Management & Hak Akses (Account List, Roles, Permissions)](#modul-11-user-management)
12. [MODUL 12: Company Management & Multi-Tenancy (Kelola Entitas / PT / Yayasan)](#modul-12-company-management)
13. [MODUL 13: Report Summary (12 Bulan, Sticky Diagonal Clamping & Export)](#modul-13-report-summary)
14. [MODUL 14: Annual Report Engine (Tabel 1-4, Tabel 4A-4D, Beban Bank & Zoom Scale)](#modul-14-annual-report-engine)
15. [MODUL 15: Settings, Profile Avatar Cropper & Pos Neraca (Balance Sheet)](#modul-15-settings--balance-sheet)
16. [MODUL 16: Manager Panel, Data Cleanup Selektif & Deadline Notifikasi](#modul-16-manager-panel--cleanup--deadline)
17. [MODUL 17: Database Backup, Restore Validation & Global Restart](#modul-17-database-backup--restore)
18. [MODUL 18: Authentication, Google SSO, Forgot Password OTP & Gateway](#modul-18-authentication--gateway)
19. [MODUL 19: Matriks Efek Domino & Sinkronisasi Global (Ripple Effects)](#modul-19-matriks-efek-domino--sinkronisasi-global)

---

## MODUL 1: BANK MANAGEMENT

_Pengujian rekening fisik (Bank Cash), saldo virtual staf (Bank Advance), kalkulasi matematis (+/-), dan alokasi multi-sumber._

### 1.1. Tab Bank Cash

- [ ] **BM-001** | [Daftar Rekening] Buka Bank Cash -> Cek logo, nama bank, nomor rekening, mata uang (IDR/USD), dan saldo.
- [ ] **BM-002** | [Sorting Prioritas] Verifikasi label "Giro", "Bisnis", "Valas" ditarik ke urutan teratas sebelum tabungan biasa.
- [ ] **BM-003** | [Border Warna Saldo] Saldo > 0 beraksen hijau/biru; Saldo 0 beraksen abu-abu; Saldo minus (jika ada) beraksen merah.
- [ ] **BM-004** | [Form Tambah Bank - Normal] Klik `+ Tambah Rekening` -> Nama: "Bank Mandiri Operasional", No Rek: "140001928374", Mata Uang: IDR -> Simpan -> Rekening muncul.
- [ ] **BM-005** | [Form Tambah Bank - Validasi] Klik `+ Tambah Rekening` -> Kosongkan nama & nomor rekening -> Simpan -> Peringatan field wajib diisi.
- [ ] **BM-006** | [Form Tambah Bank - Duplikasi] Masukkan nomor rekening yang sudah terdaftar sebelumnya -> Cek penolakan duplikasi sistem.
- [ ] **BM-007** | [Detail BottomSheet] Klik kartu Bank Cash -> Modal BottomSheet "Detail Bank Cash" terbuka menampilkan rincian dan riwayat.
- [ ] **BM-008** | [Form Edit Bank] Pada BottomSheet, klik "Edit Bank Cash" -> Ubah nama rekening -> Simpan -> Kartu langsung ter-update.

### 1.2. Form Kelola Cash / Uang (+ / -) & Realtime Math Preview

- [ ] **BM-009** | [Toggle Tambah (+)] Buka Kelola Cash -> Pilih `+` -> Nominal `10.000.000` -> Cek teks kalkulasi: `[Saldo Awal] + Rp 10.000.000 = [Saldo Akhir]` -> Simpan -> Saldo bertambah tepat.
- [ ] **BM-010** | [Toggle Kurang (-)] Buka Kelola Cash -> Pilih `-` -> Nominal `3.000.000` -> Cek teks kalkulasi: `[Saldo Awal] - Rp 3.000.000 = [Saldo Akhir]` -> Simpan -> Saldo berkurang tepat.
- [ ] **BM-011** | [Validasi Nominal 0] Pilih Toggle `+` -> Input `0` -> Klik Simpan -> Pesan error "Nominal harus lebih dari 0".
- [ ] **BM-012** | [Validasi Filter Karakter] Ketik `-50000` atau `abc!@#` di kolom nominal -> Textfield menolak selain angka.
- [ ] **BM-013** | [Tarik Melebihi Saldo] Saldo `1.000.000` -> Pilih `-` -> Input `5.000.000` -> Sistem menolak dengan alert saldo tidak mencukupi.
- [ ] **BM-014** | [Nominal Ekstrem] Masukkan nominal `1.000.000.000.000` (1 Triliun) -> Format Rupiah dan database memproses tanpa overflow/crash.
- [ ] **BM-015** | [Double Submit Lock] Klik tombol "Simpan" cepat berkali-kali -> Tombol langsung loading dan mencegah double entry.

### 1.3. Tab Bank Advance & Alokasi Multi-Sumber Dana

- [ ] **BM-016** | [Daftar Karyawan] Buka Bank Advance -> Cek avatar, nama, jabatan, Saldo Virtual (hijau), Saldo B (oranye).
- [ ] **BM-017** | [Badge HUTANG] Karyawan yang memiliki utang kasbon berjalan menampilkan badge merah tebal `HUTANG`.
- [ ] **BM-018** | [Pencarian Client-Side] Ketik nama staf -> Hasil menyaring seketika tanpa jeda API.
- [ ] **BM-019** | [Detail Advance BottomSheet] Klik kartu karyawan -> BottomSheet "Detail Bank Advance" muncul merangkum saldo virtual dan riwayat.
- [ ] **BM-020** | [Alokasi Single Bank] Kelola Advance -> Pilih Bank A (saldo sisa terlihat di dropdown) -> Toggle `+` Rp 2.000.000 -> Isi Catatan -> Simpan -> Saldo virtual karyawan bertambah dan Bank A berkurang Rp 2.000.000.
- [ ] **BM-021** | [Alokasi Multi-Bank (+ Tambah Sumber)] Klik "+ Tambah Sumber Dana" -> Baris 1: Bank A (Rp 3.000.000), Baris 2: Bank B (Rp 2.000.000) -> Prediksi Saldo Baru = Saldo Awal + Rp 5.000.000 -> Simpan -> Kedua bank fisik terpotong dan saldo virtual bertambah Rp 5.000.000.
- [ ] **BM-022** | [Hapus Baris Alokasi] Buat 3 baris bank -> Klik tombol silang merah pada baris ke-2 -> Baris terhapus dan kalkulasi total berkurang seketika.
- [ ] **BM-023** | [Validasi Dropdown Bank Kosong] Buat baris alokasi tanpa memilih bank -> Simpan -> Ditolak dengan pesan "Pilih bank".
- [ ] **BM-024** | [Validasi Catatan Kosong] Kosongkan field "Catatan Penyesuaian" -> Simpan -> Ditolak wajib mengisi catatan.

---

## MODUL 2: LOGBOOK, AUDIT TRAIL & WORKFLOW TIMELINE

_Pengujian pencatatan kronologis transaksi kas, audit trail aktivitas, dan visual timeline progres dokumen._

- [ ] **LB-001** | [Logbook Bank Cash] Buka Detail Bank Cash -> Klik "Riwayat Aktivitas / Log Book" -> BottomSheet logbook terbuka.
- [ ] **LB-002** | [Logbook Bank Advance] Buka Detail Bank Advance -> Klik "Riwayat Aktivitas" -> BottomSheet logbook staf terbuka.
- [ ] **LB-003** | [Urutan Kronologis Mutlak] Pastikan transaksi diurutkan Descending: tanggal terbaru disusul ID terbesar di baris paling atas.
- [ ] **LB-004** | [Pembersihan Teks Regex] Pastikan deskripsi transaksi bersih dari ID teknis acak seperti `[Ref: #12345-abc]`.
- [ ] **LB-005** | [Animasi Fullscreen 85%] Klik ikon Fullscreen di pojok Logbook -> BottomSheet membesar hingga 85% layar.
- [ ] **LB-006** | [Pencatatan Otomatis Kasbon] Cairkan Kasbon Rp 2.500.000 di Bank BCA -> Logbook BCA mencatat Pengeluaran Rp 2.500.000 dan Logbook Advance staf mencatat Penambahan Rp 2.500.000.
- [ ] **LB-007** | [Pencatatan Otomatis Settlement] Selesaikan Settlement -> Logbook mencatat pemotongan/penyesuaian dana riil sesuai nota pengeluaran.
- [ ] **LB-008** | [Pencatatan Otomatis Revenue] Input Pemasukan Rp 10.000.000 -> Logbook Bank Penerima mencatat Pemasukan Rp 10.000.000.
- [ ] **LB-009** | [Pencatatan Otomatis Dividen] Bagi dividen Rp 5.000.000 -> Logbook Bank Sumber mencatat Pengeluaran Dividen Rp 5.000.000.
- [ ] **LB-010** | [Workflow Timeline Dialog] Buka Kasbon/Settlement -> Klik Timeline Progres -> Dialog menampilkan tahap: Draft -> Submitted -> Approved -> Disbursed -> Completed beserta tanggal, jam, dan nama eksekutornya.

---

## MODUL 3: KASBON / ADVANCE

_Pengujian pembuatan, input detail form item kasbon, state machine persetujuan, dan pencairan finance._

### 3.1. Form Pembuatan Kasbon (Advance List)

- [ ] **KB-001** | [Buat Single] Klik `+ Buat` -> Radio Single -> Tahun: 2026 -> Klik Buat -> Masuk ke AdvanceDetailScreen.
- [ ] **KB-002** | [Buat Batch] Klik `+ Buat` -> Radio Batch -> Judul: "Kegiatan Riset Lapangan", Tanggal: 15 Maret 2026 -> Buat -> Berhasil.
- [ ] **KB-003** | [Pencegatan Outstanding Kasbon] Staf punya utang kasbon > Rp 0.01 -> Klik `+ Buat` -> Muncul dialog peringatan merah "Perhatian: Outstanding Kasbon" (Tombol: Batal, Kembalikan Dana Sekarang, Buat Reimbursement).
- [ ] **KB-004** | [Lanjutkan di Tengah Outstanding] Klik "Buat Reimbursement / Lanjutkan" -> Sistem mengizinkan pembuatan dokumen.
- [ ] **KB-005** | [Validasi Batch Kosong] Pilih Batch -> Kosongkan Judul atau Tanggal -> Klik Buat -> Sistem menolak dan memunculkan peringatan.

### 3.2. Detail Kasbon, Form Tambah Item & Mesin Status

- [ ] **KB-006** | [Form Tambah Item Kasbon (`dialog_add_item.dart`)] Klik `+ Tambah Item` -> Isi Tanggal, Pilih Kategori, Deskripsi Keperluan, Estimasi Nominal: Rp 1.500.000, Catatan -> Simpan -> Item masuk ke Tabel 1.
- [ ] **KB-007** | [Quick Add Category Inline] Pada dropdown kategori di form tambah item, klik tombol `+ Kategori Baru` -> Input nama kategori -> Kategori langsung terpilih tanpa keluar dari form kasbon.
- [ ] **KB-008** | [Form Edit Item Kasbon] Klik pensil edit pada baris item -> Ubah nominal dari Rp 1.500.000 menjadi Rp 2.000.000 -> Total Pengajuan di Summary Card langsung menjadi Rp 2.000.000.
- [ ] **KB-009** | [Sapu Jagat (Bulk Delete)] Centang beberapa baris item -> Klik tombol "Hapus Terpilih" -> Semua item terpilih terhapus sekaligus.
- [ ] **KB-010** | [Submit Kasbon] Staf klik tombol "Submit Kasbon" -> Status berubah menjadi `submitted` -> Tombol edit/hapus staf terkunci.
- [ ] **KB-011** | [Manager Approve Baris Item] Login Manager -> Buka dokumen `submitted` -> Klik tombol centang hijau pada baris item -> Status item menjadi `approved`.
- [ ] **KB-012** | [Manager Reject & Checklist Form (`dialog_checklist.dart`)] Klik silang merah pada baris item -> Muncul dialog checklist penolakan -> Ketik alasan (misal: "Biaya tidak masuk akal", "Lampirkan TOR") -> Simpan -> Status item menjadi `rejected`.
- [ ] **KB-013** | [Strict Reject & Fix Staf] Login Staf -> Buka dokumen `revision` -> Klik popup teguran pada baris item -> Wajib centang SEMUA kotak checklist -> Simpan -> Status item pulih menjadi `pending`.
- [ ] **KB-014** | [Strict Reject Lock] Staf hanya mencentang sebagian checklist -> Klik Simpan -> Sistem menolak dan form tidak bisa di-submit ulang.
- [ ] **KB-015** | [Gerbang Tabel 2 (Pencairan)] Tabel 2 terkunci jika masih ada item pending/rejected; Tabel 2 otomatis terbuka saat semua item di Tabel 1 sudah 100% `approved`.
- [ ] **KB-016** | [Finance Disbursement Form (`dialog_edit_disbursement.dart`)] Login Finance -> Buka Tabel 2 -> Pilih Rekening Sumber (Bank BCA), Tanggal Transfer, Upload Bukti Transfer -> Klik Approve Pencairan.
- [ ] **KB-017** | [Insufficient Balance Check] Pilih rekening dengan saldo Rp 500.000 untuk mencairkan kasbon Rp 10.000.000 -> Klik Approve Pencairan -> Sistem menolak dengan dialog alarm "Insufficient Balance / Saldo Bank Tidak Cukup".
- [ ] **KB-018** | [Setujui Final Kasbon] Klik tombol "Setujui Final Kasbon" -> Status dokumen menjadi `completed` secara permanen -> Saldo kasbon staf aktif bertambah.

---

## MODUL 4: SETTLEMENT / PENGELUARAN

_Pengujian form input nota pengeluaran detail, kalkulasi pajak PPN/PPh, multi-lampiran bukti struk, dan pencairan nombok._

### 4.1. Form Pembuatan Settlement (Settlement List)

- [ ] **ST-001** | [Buat Single] Klik `+ Buat Settlement` -> Radio Single -> Tahun 2026 -> Klik Buat -> Masuk ke SettlementDetailScreen.
- [ ] **ST-002** | [Buat Batch] Klik `+ Buat Settlement` -> Radio Batch -> Judul: "Operasional Kantor Cabang", Tanggal: 20 Feb 2026 -> Buat -> Berhasil.
- [ ] **ST-003** | [Filter Status & Search Debounce] Ketik "Cabang" di search bar (debounce 350ms) -> Filter status "Draft" -> Data tersaring tepat.
- [ ] **ST-004** | [Export Excel & PDF Guard] Filter status "Draft" -> Tombol export disembunyikan. Filter status "Completed" (sebagai Manager) -> Tombol Export Excel & PDF muncul.
- [ ] **ST-005** | [Bulk Delete Berbasis Role] Staf hanya bisa menghapus status `draft`. Manager bebas menghapus dokumen status apa pun.

### 4.2. Form Tambah Expense Detail (`dialog_add_expense.dart`) & Perhitungan Pajak

- [ ] **ST-006** | [Input Field Lengkap] Buka form `+ Tambah Expense` -> Isi Tanggal, Kategori & Sub-Kategori, Nama Pengeluaran, Qty, Satuan, Harga Satuan -> Cek kalkulasi otomatis: `Qty * Harga Satuan = Subtotal`.
- [ ] **ST-007** | [Pajak PPN Toggle & Split Tax] Aktifkan toggle "Kena Pajak" -> Pilih Jenis Pajak: PPN 11% -> Cek kalkulasi otomatis: `Nominal Pajak = Subtotal * 11%` dan `Total Akhir = Subtotal + PPN`.
- [ ] **ST-008** | [Pajak PPh Potongan] Pilih Jenis Pajak: PPh 23 (2%) -> Cek kalkulasi otomatis potongan pajak: `Total Dibayarkan = Subtotal - PPh 23`.
- [ ] **ST-009** | [Multi-Image Evidence Upload] Upload 3 foto struk (kamera / galeri / PDF) -> Thumbnail preview foto muncul dengan opsi hapus/ganti per foto.
- [ ] **ST-010** | [Image Preview & Rotate (`item_detail_preview_dialog.dart`)] Klik salah satu foto struk -> Buka modal preview -> Uji fitur Zoom In/Out dan Rotasi gambar 90°.
- [ ] **ST-011** | [Validasi Wajib Bukti Struk] Tambah expense tanpa upload foto struk -> Submit Settlement -> Sistem memblokir dengan notifikasi "Setiap baris pengeluaran wajib menyertakan bukti lampiran".
- [ ] **ST-012** | [Warning Box Proyeksi Dompet] Staf punya kasbon Rp 2.000.000. Total pengeluaran diapprove Rp 1.200.000 -> Warning box menampilkan Sisa Kasbon Rp 800.000.
- [ ] **ST-013** | [Kondisi Nombok (Reimbursement)] Total pengeluaran Rp 2.500.000 (Kasbon Rp 2.000.000) -> Warning box menampilkan Nombok Rp 500.000 -> Tabel 2 (Pencairan Penggantian Uang Pribadi) otomatis muncul.
- [ ] **ST-014** | [Pencegatan Kategori Unapproved] Manager approve baris yang kategorinya belum disahkan di pusat sistem -> Sistem menolak dan meminta approve kategori terlebih dahulu.
- [ ] **ST-015** | [Strict Reject & Fix Staf] Manager reject baris expense -> Staf buka form reject -> Checklist semua poin -> Simpan -> Siap diapprove ulang.
- [ ] **ST-016** | [Bypass Tabel 3 & Final Settlement] Tabel 1 selesai approved -> Tabel 2 diselesaikan Finance -> Klik tombol "Setujui Final Settlement" -> Dokumen menjadi `completed`.

---

## MODUL 5: STANDALONE RETURN

_Pengujian pengembalian sisa kasbon langsung tanpa settlement panjang._

- [ ] **RT-001** | [Buka Form Pengembalian Mandiri] Pada peringatan Outstanding Kasbon, klik "Kembalikan Dana Sekarang" -> Dialog Pengembalian Dana Langsung terbuka.
- [ ] **RT-002** | [Dropdown Rekening Bank Penerima] Buka dropdown bank -> Rekening yang memiliki hutang bertanda merah, rekening bersaldo lebih bertanda hijau.
- [ ] **RT-003** | [Auto-Format Currency] Ketik `1500000` di kolom Nominal -> Otomatis terformat menjadi `Rp 1.500.000`.
- [ ] **RT-004** | [Validasi Nominal 0 / Kosong] Masukkan `0` -> Klik Simpan -> Sistem menolak "Nominal tidak valid".
- [ ] **RT-005** | [Validasi Bukti Transfer] Isi nominal tanpa upload foto bukti transfer -> Klik Simpan -> Ditolak "Bukti transfer wajib diunggah".
- [ ] **RT-006** | [Visual Tombol Upload Sukses] Upload foto bukti transfer -> Tombol upload berubah warna menjadi hijau pekat dan label berganti menjadi nama file gambar.
- [ ] **RT-007** | [Eksekusi Sukses] Klik Simpan -> Loading spinner berputar -> Dialog tertutup -> Snackbar hijau muncul -> Hutang kasbon staf berkurang Rp 1.500.000, Bank Penerima bertambah Rp 1.500.000, dan Logbook mencatat transaksi.

---

## MODUL 6: MANAJEMEN KATEGORI, QUICK-ADD & KANBAN TABULAR

_Pengujian struktur Kategori Utama/Sub, approval pending, reorder drag-drop, dan papan Kanban._

### 6.1. Halaman Kategori

- [ ] **CAT-001** | [Hierarki Kategori] Kategori utama ditampilkan dalam ExpansionTile; klik untuk expand melihat sub-kategori.
- [ ] **CAT-002** | [Section Kategori Pending] Jika ada kategori baru diajukan staf, section oranye "Kategori Pending" muncul di atas dengan tanda `|-`.
- [ ] **CAT-003** | [Pencegatan Approve Sub-Kategori] Kategori Utama pending dan Sub-kategori pending -> Tombol approve sub-kategori di-disable dengan label "• Approve kategori utama dulu".
- [ ] **CAT-004** | [Approve Berurutan] Approve Kategori Utama -> Tombol approve sub-kategori langsung aktif dan bisa diklik.
- [ ] **CAT-005** | [Form Tambah Kategori Utama] Klik `+ Tambah Kategori` -> Radio "Kategori Utama" -> Nama: "Beban Operasional" -> Simpan -> Berhasil.
- [ ] **CAT-006** | [Form Tambah Sub-Kategori] Klik `+ Tambah Kategori` -> Radio "Sub Kategori" -> Pilih Utama: "Beban Operasional" -> Nama: "Konsumsi Rapat" -> Simpan -> Berhasil.
- [ ] **CAT-007** | [Validasi Sub Kategori Tanpa Parent] Pilih Radio "Sub Kategori" -> Kosongkan dropdown Kategori Utama -> Simpan -> Ditolak "Pilih Kategori Utama terlebih dahulu".
- [ ] **CAT-008** | [Hapus Kategori Berelasi] Hapus kategori yang sudah terpakai di nota expense -> Dialog konfirmasi memberi peringatan "Kategori akan dihapus permanen. Pastikan tidak ada expense yang terkait".

### 6.2. Kategori Tabular & Papan Kanban

- [ ] **CAT-009** | [Buka Kategori Tabular] Klik tombol "Kategori Tabular" -> Layar urutan kolom Excel terbuka.
- [ ] **CAT-010** | [Drag-and-Drop Reorder] Tahan ikon drag handle pada Kategori 3, geser ke posisi 1 -> Nomor urut badge biru otomatis berubah menjadi 1.
- [ ] **CAT-011** | [Buka Dialog Kanban] Klik "Atur Grup & Urutan" -> Dialog papan Kanban interaktif terbuka (Horizontal scroll di PC, vertikal di HP).
- [ ] **CAT-012** | [Pindah Grup via Panah Kanan] Klik ikon panah kanan pada kartu kategori -> Kategori pindah siklus ke kolom grup berikutnya di urutan terbawah.
- [ ] **CAT-013** | [Orphan Fallback "LAINNYA"] Kategori dengan `main_group` null/rusak otomatis ditampung di kolom abu-abu "LAINNYA" di paling kanan tanpa crash.
- [ ] **CAT-014** | [Simpan Perubahan Tabular] Klik tombol hijau besar "Simpan Perubahan" -> Loading blocking -> Urutan kolom Excel tahunan tersimpan ke server.

---

## MODUL 7: REVENUE MANAGEMENT (PEMASUKAN & PENDAPATAN)

_Pengujian form pemasukan uang masuk, bukti setor, dan pengaruh langsung ke rekening bank._

- [ ] **REV-001** | [Form Tambah Revenue] Buka Revenue Management -> Klik `+ Tambah Pemasukan` -> Pilih Kategori: "Donasi / Hibah", Rekening Penerima: "Bank BCA", Nominal: Rp 25.000.000, Tanggal: 10 Jan 2026, Upload Bukti Setor -> Simpan -> Data tersimpan.
- [ ] **REV-002** | [Efek Langsung ke Bank Cash] Periksa saldo Bank BCA di Bank Management -> Saldo bertambah tepat Rp 25.000.000.
- [ ] **REV-003** | [Efek Langsung ke Logbook] Periksa Logbook Bank BCA -> Tercatat transaksi Pemasukan (Revenue) Rp 25.000.000.
- [ ] **REV-004** | [Validasi Nominal 0 / Minus] Input nominal 0 atau minus pada form Revenue -> Sistem menolak dengan validasi error.
- [ ] **REV-005** | [Filter Tahun & Kategori] Filter revenue berdasarkan Tahun 2026 dan Kategori tertentu -> Tabel rekap revenue menyaring data dengan benar.
- [ ] **REV-006** | [Edit Revenue] Ubah nominal pemasukan dari Rp 25.000.000 menjadi Rp 30.000.000 -> Saldo bank penerima terkoreksi bertambah Rp 5.000.000.
- [ ] **REV-007** | [Hapus Revenue] Hapus salah satu data revenue Rp 5.000.000 -> Saldo bank penerima otomatis terpotong Rp 5.000.000 dan logbook mencatat penyesuaian.

---

## MODUL 8: TAX MANAGEMENT, COMBINE GROUPS & DIALOG TABEL NDPV

_Pengujian manajemen tarif pajak, pengelompokan pajak tahunan, dan kalkulator tabel NDPV._

- [ ] **TAX-001** | [Form Tambah Pajak] Buka Tax Management -> Klik `+ Tambah Pajak` -> Nama: "PPh 21 Pegawai", Persentase: 5%, Tahun: 2026 -> Simpan -> Pajak terdaftar.
- [ ] **TAX-002** | [Combine Groups Pajak] Buka fitur "Combine Groups" -> Kelompokkan pajak PPh 21 dan PPh 23 ke dalam 1 grup tahunan -> Simpan -> Struktur grup tersimpan.
- [ ] **TAX-003** | [Dialog Tabel NDPV (`dialog_ndpv_table.dart`)] Buka dialog tabel NDPV -> Cek kolom Nilai Dasar Pengenaan Pajak (DPP), Tarif Pajak, dan Pajak Terutang terhitung akurat.
- [ ] **TAX-004** | [Integrasi ke Laporan Tahunan Sheet 2] Buka Annual Report Sheet 2 -> Pastikan baris-baris pajak terhitung dan terkelompokkan sesuai konfigurasi Tax Management.

---

## MODUL 9: DIVIDEND MANAGEMENT (BAGI HASIL & DIVIDEN)

_Pengujian pembagian dividen ke pemegang saham, pemotongan kas bank, dan bukti transfer._

- [ ] **DIV-001** | [Form Bagi Dividen] Buka Dividend Management -> Klik `+ Bagi Dividen` -> Nama Pemegang Saham: "Investor Utama", Rekening Sumber: "Bank Giro", Nominal: Rp 20.000.000, Tanggal: 15 Jan 2026, Upload Bukti -> Simpan -> Berhasil.
- [ ] **DIV-002** | [Efek ke Bank Cash] Saldo rekening "Bank Giro" otomatis berkurang Rp 20.000.000.
- [ ] **DIV-003** | [Efek ke Logbook] Logbook Bank Giro mencatat pengeluaran dividen Rp 20.000.000.
- [ ] **DIV-004** | [Validasi Saldo Tidak Cukup] Pilih rekening dengan saldo Rp 5.000.000 untuk bagi dividen Rp 15.000.000 -> Sistem menolak transaksi dengan peringatan saldo tidak cukup.

---

## MODUL 10: ASSET MANAGEMENT (INVENTARIS & PENYUSUTAN)

_Pengujian form aset, umur ekonomis, penyusutan otomatis, dan disposal._

- [ ] **AST-001** | [Form Tambah Aset (`dialog_asset_form.dart`)] Buka Asset Management -> Klik `+ Tambah Aset` -> Nama: "Laptop MacBook Pro", Tanggal Perolehan: 1 Feb 2026, Harga Perolehan: Rp 30.000.000, Umur Ekonomis: 4 Tahun, Nilai Residu: Rp 2.000.000 -> Simpan -> Aset terdaftar.
- [ ] **AST-002** | [Kalkulasi Penyusutan Otomatis] Cek tabel penyusutan aset -> Sistem menghitung depresiasi per bulan/tahun secara otomatis.
- [ ] **AST-003** | [Nilai Buku Terkini] Pastikan Nilai Buku = Harga Perolehan - Akumulasi Penyusutan.
- [ ] **AST-004** | [Penghapusan / Disposal Aset] Klik opsi "Disposal / Hapus Aset" -> Masukkan nilai jual (jika ada) -> Status aset berubah menjadi disposed.

---

## MODUL 11: USER MANAGEMENT & HAK AKSES (MANAGER ONLY)

_Pengujian pembuatan akun, assign role, ganti password user, dan status aktif/nonaktif._

- [ ] **USR-001** | [Lihat Account List (`account_list_dialog.dart`)] Login Manager -> Buka Settings -> Klik "Lihat Account List" -> Daftar seluruh user termuat.
- [ ] **USR-002** | [Form Buat User Baru (`dialog_create_user.dart`)] Klik `+ Tambah Pengguna` -> Isi Username, Nama Lengkap, Email, Password, Pilih Role (Staff / Manager / Finance / Admin), Pilih Perusahaan -> Simpan -> Akun baru tercipta.
- [ ] **USR-003** | [Form Edit User (`dialog_edit_user.dart`)] Klik edit pada salah satu akun -> Ubah Role atau Reset Password -> Simpan -> Akun ter-update.
- [ ] **USR-004** | [Nonaktifkan User] Ubah status user menjadi Nonaktif -> User yang dinonaktifkan tidak bisa login ke aplikasi.
- [ ] **USR-005** | [User Detail Dialog (`user_detail_dialog.dart`)] Klik nama user pada daftar -> Modal profil user muncul merangkum riwayat peran dan aktivitas.

---

## MODUL 12: COMPANY MANAGEMENT & MULTI-TENANCY

_Pengujian entitas perusahaan, logo, switch active company, dan isolasi data._

- [ ] **CMP-001** | [Kelola Perusahaan Dialog (`manage_companies_dialog.dart`)] Login Admin/Manager -> Buka menu kelola perusahaan -> Daftar PT/Yayasan muncul.
- [ ] **CMP-002** | [Form Tambah Perusahaan Baru] Klik `+ Tambah Perusahaan` -> Nama: "PT Inovasi Solusi", Kode: "INS", Alamat, Upload Logo -> Simpan -> Perusahaan baru terdaftar.
- [ ] **CMP-003** | [Form Edit Perusahaan] Ubah nama atau alamat perusahaan -> Simpan -> Informasi ter-update di header aplikasi.
- [ ] **CMP-004** | [Isolasi Data Antar-Perusahaan] Login ke Perusahaan A -> Catat data transaksi. Pindah ke Perusahaan B -> Pastikan transaksi dari Perusahaan A TIDAK PERNAH BOCOR ke Perusahaan B.

---

## MODUL 13: REPORT SUMMARY (LAPORAN BULANAN)

_Pengujian tabel 12 bulan, sticky scroll headers, dan kalkulasi client-side._

- [ ] **RP-001** | [Tampilan Matriks 12 Bulan] Buka Report Summary -> Tabel membentang dari Jan hingga Des, diapit kolom Kategori di kiri dan TOTAL di kanan.
- [ ] **RP-002** | [Diagonal Clamping Sync (Sticky)] Scroll tabel ke kanan -> Kolom Kategori tetap terkunci di kiri, Baris Header (Bulan) terkunci di atas, Baris Grand Total terkunci di bawah.
- [ ] **RP-003** | [Kalkulasi Grand Total Client-Side] Verifikasi bahwa total pada baris terbawah ("GRAND TOTAL") adalah hasil penjumlahan akurat dari Jan s/d Des tanpa selisih 1 rupiah pun.
- [ ] **RP-004** | [Zebra Striping & Indentasi] Baris ganjil-genap memiliki warna latar selang-seling; teks sub-kategori memiliki indentasi ke dalam dari kategori induknya.
- [ ] **RP-005** | [Cache Info Badge] Periksa kotak label Cache Info di header: menunjukkan "CACHE" atau "REFRESH" beserta timestamp waktu pengambilan data.
- [ ] **RP-006** | [Export Naming Format] Pilih rentang tanggal 1 Jan 2026 s/d 31 Jan 2026 -> Klik Export PDF -> Nama file yang terunduh berformat: `summary_20260101_20260131.pdf`.

---

## MODUL 14: ANNUAL REPORT ENGINE (MULTI-TABEL & ZOOM)

_Pengujian mahadata tahunan, Tabel 1-4, Tabel 4A-4D, Beban Bank, dan Zoom Engine._

- [ ] **AR-001** | [Zoom Engine (Ctrl + Mouse Wheel)] Tekan tahan tombol `Ctrl` lalu putar roda mouse ke bawah -> Tabel mengecil perlahan hingga batas minimal 52% (skala 0.52). Putar ke atas -> Membesar kembali hingga 100%.
- [ ] **AR-002** | [Massive Horizontal Scroll Sync] Geser scrollbar horizontal pada Tabel 1 -> Seluruh tabel di bawahnya (Tabel 2 s/d Tabel 10) otomatis bergeser sejajar secara sinkron (_jumpTo sync_).
- [ ] **AR-003** | [Direct Reference Routing] Klik salah satu ID transaksi pada sel tabel laporan tahunan -> Aplikasi langsung membuka layar Detail transaksi bersangkutan.
- [ ] **AR-004** | [Sheet 1 (Pemasukan & Beban Langsung)] Cek tabel Pemasukan, Tabel Biaya Operasi, dan Tabel Biaya Riset -> Pastikan total per bulan sesuai.
- [ ] **AR-005** | [Sheet 2 (Pajak & Potongan - Tabel 4A, 4B, 4C, 4D)] Cek Tabel 4A (PPh 21), Tabel 4B (PPh 23), Tabel 4C (PPN), Tabel 4D (Dividen) -> Pastikan perhitungan potongan terdistribusi akurat.
- [ ] **AR-006** | [Tabel Beban Bank (`widget_bank_expense_table.dart`)] Periksa tabel pengeluaran per rekening bank di Annual Report -> Pastikan total per bank cocok dengan mutasi riil.
- [ ] **AR-007** | [Sheet 3 (Neraca & Saldo Akhir)] Buka Sheet 3 -> Cek posisi kas akhir tahun dan perbandingan aset/liabilitas.
- [ ] **AR-008** | [Popup Bukti Lampiran Sel (`widget_show_evidence_popup.dart`)] Klik ikon klip dokumen pada salah satu sel angka -> Pop-up gambar bukti pendukung terbuka.

---

## MODUL 15: SETTINGS, PROFILE & BALANCE SHEET CONFIGURATION

_Pengujian profil pengguna, avatar cropper, switch tema, dan konfigurasi neraca._

- [ ] **SET-001** | [Ubah Profil & Avatar Cropper (`image_cropper_dialog.dart`)] Buka Settings -> Klik pensil edit profil -> Upload foto avatar baru -> Dialog cropper terbuka -> Potong foto -> Simpan -> Avatar ter-update.
- [ ] **SET-002** | [Toggle Tema Gelap/Terang] Klik tombol tema (Light / Dark / System) -> UI seketika berubah warna tanpa reload.
- [ ] **SET-003** | [Ganti Default Tahun Laporan] Ubah dropdown Default Tahun dari 2026 ke 2025 -> Klik "Simpan Default Tahun" -> Sinyal _Sync All From Settings_ terpicu -> Buka halaman Kasbon/Settlement -> Semua data menampilkan tahun 2025.
- [ ] **SET-004** | [Google Account Link/Unlink] Klik "Hubungkan Google" -> Selesaikan otentikasi -> Tombol berubah menjadi hijau "Google Terhubung". Klik lagi -> Konfirmasi putus tautan.
- [ ] **SET-005** | [Balance Sheet Settings Screen] Buka pengaturan neraca -> Konfigurasi pos akun aktiva lancar dan pasiva -> Simpan -> Format neraca ter-update.

---

## MODUL 16: MANAGER PANEL, DATA CLEANUP SELEKTIF & DEADLINE NOTIFIKASI

_Pengujian fitur eksklusif Manager: batas waktu notifikasi lonceng dan pembersihan darurat._

- [ ] **MGR-001** | [Manager Panel Toggle] Login Staf -> Tombol "Manager Panel" disembunyikan. Login Manager -> Tombol "Manager Panel" muncul di AppBar.
- [ ] **MGR-002** | [Deadline Manager Screen] Buka "Kelola Deadline Notifikasi" -> Atur batas waktu submit settlement (misal tanggal 25 setiap bulan) -> Simpan -> Pengaturan tersimpan.
- [ ] **MGR-003** | [Lonceng Notifikasi (`notification_bell_icon.dart`)] Lewat batas deadline -> Ikon lonceng menampilkan badge merah angka dan daftar pesan teguran.
- [ ] **MGR-004** | [Selective Data Cleanup Screen (`data_cleanup_screen.dart`)] Buka menu Pembersihan Data Selektif -> Pilih Perusahaan, Tahun: 2023, Tipe: "Settlement Draft" -> Klik "Bersihkan Data" -> Konfirmasi dengan ketik "DELETE" -> Hanya data spesifik tersebut yang terhapus permanen.

---

## MODUL 17: DATABASE BACKUP & RESTORE

_Pengujian export/import basis data, validasi format, dan restart global._

- [ ] **DB-001** | [Export Database] Klik "Export Database" -> File cadangan `.db` / `.sql` berhasil dibuat -> Dialog sukses menampilkan direktori file backup.
- [ ] **DB-002** | [Import: Validasi Ekstensi] Klik "Import Database" -> Pilih file berekstensi `.pdf` atau `.txt` -> Sistem menolak keras file tidak valid.
- [ ] **DB-003** | [Import: Preview & Peringatan] Pilih file valid `.db` -> Dialog preview muncul menampilkan ringkasan jumlah tabel & baris, dengan kotak peringatan merah bahwa database lama akan ditimpa.
- [ ] **DB-004** | [Import: Eksekusi & Global Restart] Setujui Import -> Sistem merestore DB -> Trigger `Navigator.pushAndRemoveUntil` me-restart UI dari titik awal -> Aplikasi berjalan dengan data baru yang bersih.

---

## MODUL 18: AUTHENTICATION, SSO, & COMPANY GATEWAY

_Pengujian login, register, Google SSO, lupa password OTP, dan gateway perusahaan._

- [ ] **AUT-001** | [Login Normal] Masukkan username & password benar -> Centang Remember Me -> Klik Login -> Berhasil masuk.
- [ ] **AUT-002** | [Validasi Login Kosong] Kosongkan field -> Klik Login -> Pesan peringatan "Field wajib diisi" muncul.
- [ ] **AUT-003** | [Validasi Password Pendek] Masukkan password 3 karakter -> Klik Login -> Peringatan "Password minimal 6 karakter".
- [ ] **AUT-004** | [Error Jaringan & Tombol Cek IP] Matikan backend -> Klik Login -> Muncul pesan error jaringan disertai tombol "CEK IP" / popup ubah Server URL.
- [ ] **AUT-005** | [Lupa Password Flow] Klik "Lupa Password" -> Masukkan email -> Minta OTP -> Masukkan kode OTP valid -> Buat password baru -> Berhasil login dengan password baru.
- [ ] **AUT-006** | [Google SSO Email Baru] Klik Login Google dengan akun Gmail belum terdaftar di DB -> Popup konfirmasi pembuatan akun -> Redirect ke Register dengan Email & Nama terkunci (read-only).
- [ ] **AUT-007** | [Register Normal] Isi username, nama, password minimal 6 karakter, konfirmasi password sama -> Pilih Role & Company -> Daftar -> Dialog sukses muncul dengan delay transisi 300ms.
- [ ] **AUT-008** | [Company Selection: Single Company Auto-Bypass] Akun user hanya terdaftar di 1 perusahaan -> Setelah login, halaman pemilihan perusahaan otomatis di-_bypass_ langsung ke Dashboard Utama tanpa klik manual.
- [ ] **AUT-009** | [Company Selection: Multi Company] Akun terdaftar di 2 perusahaan -> Halaman "Pilih Perusahaan" menampilkan kartu-kartu perusahaan -> Klik salah satu kartu -> Masuk ke dashboard perusahaan terpilih.

---

## MODUL 19: MATRIKS EFEK DOMINO & SINKRONISASI GLOBAL (RIPPLE EFFECTS)

_Pengujian apakah tindakan pada SATU fitur secara otomatis mengalir dan memperbarui fitur-fitur lainnya secara tepat._

| Kode Test   | Tindakan Awal                                                 | Fitur yang Diuji    | Hasil yang Wajib Terjadi (Expected Ripple Effect)                                                                   | Status |
| :---------- | :------------------------------------------------------------ | :------------------ | :------------------------------------------------------------------------------------------------------------------ | :----: |
| **INT-001** | Finance menyetujui Pencairan Kasbon Rp 5.000.000 di Bank BCA  | Bank Cash           | Saldo Bank BCA berkurang Rp 5.000.000                                                                               |  [ ]   |
| **INT-002** | (Lanjutan INT-001)                                            | Bank Advance        | Saldo virtual staf pemohon bertambah Rp 5.000.000                                                                   |  [ ]   |
| **INT-003** | (Lanjutan INT-001)                                            | Logbook             | Logbook BCA mencatat Pengeluaran Rp 5.000.000                                                                       |  [ ]   |
| **INT-004** | (Lanjutan INT-001)                                            | Settings Profil     | Panel Saldo Kasbon pada Profil Staf ter-update menjadi Rp 5.000.000                                                 |  [ ]   |
| **INT-005** | (Lanjutan INT-001)                                            | Settlement List     | Saat staf ingin buat Settlement baru, dialog "Perhatian: Outstanding Kasbon" langsung aktif mencegat                |  [ ]   |
| **INT-006** | Staf submit Settlement dengan total nota Rp 3.000.000         | Kasbon Detail       | Kotak Warning Proyeksi menampilkan sisa kasbon staf berkurang menjadi Rp 2.000.000                                  |  [ ]   |
| **INT-007** | Manager & Finance menekan "Setujui Final Settlement"          | Kasbon Active       | Utang kasbon staf resmi berkurang Rp 3.000.000 di database                                                          |  [ ]   |
| **INT-008** | (Lanjutan INT-007)                                            | Report Summary      | Angka pada tabel bulan bersangkutan otomatis bertambah Rp 3.000.000 pada kategori terkait                           |  [ ]   |
| **INT-009** | (Lanjutan INT-007)                                            | Annual Report       | Seluruh Sheet (Sheet 1, 2, 3) merefleksikan penambahan pengeluaran Rp 3.000.000                                     |  [ ]   |
| **INT-010** | Staf melakukan Standalone Return Rp 2.000.000 ke Bank Mandiri | Kasbon Active       | Sisa kasbon staf kini menjadi Rp 0 (Lunas / Bebas Hutang)                                                           |  [ ]   |
| **INT-011** | (Lanjutan INT-010)                                            | Bank Cash           | Saldo fisik Bank Mandiri bertambah Rp 2.000.000                                                                     |  [ ]   |
| **INT-012** | (Lanjutan INT-010)                                            | Logbook             | Logbook Bank Mandiri mencatat Pemasukan Rp 2.000.000                                                                |  [ ]   |
| **INT-013** | (Lanjutan INT-010)                                            | Settlement List     | Staf klik `+ Buat Settlement` -> Dialog Outstanding Kasbon TIDAK MUNCUL lagi (langsung masuk form pembuatan normal) |  [ ]   |
| **INT-014** | Tambah Revenue Rp 50.000.000 di Revenue Management            | Bank Cash & Sheet 1 | Saldo Bank bertambah Rp 50.000.000 dan Laporan Tahunan Sheet 1 (Pemasukan) bertambah Rp 50.000.000                  |  [ ]   |
| **INT-015** | Bagi Dividen Rp 10.000.000 di Dividend Management             | Bank Cash & Sheet 2 | Saldo Bank terpotong Rp 10.000.000 dan Laporan Sheet 2 (Dividen) mencatat pemotongan                                |  [ ]   |
| **INT-016** | Manager mengubah urutan Kategori di Kategori Tabular          | Excel Export        | Saat download Laporan Excel Tahunan, kolom-kolom tabel tersusun persis sesuai urutan baru                           |  [ ]   |
| **INT-017** | Manager ganti Default Tahun di Settings dari 2026 ke 2024     | Global Sync         | Halaman Kasbon, Settlement, Bank, Revenue, dan Report seketika memuat data tahun 2024 secara serentak               |  [ ]   |
| **INT-018** | Manager Restore database backup `.db` baru                    | Global Reset        | Seluruh cache lokal terhapus, aplikasi ter-reset dari halaman login, dan saldo menampilkan isi database baru        |  [ ]   |

---

## 🎯 PETUNJUK PENGGUNAAN CHECKLIST

1. Buka file [master_test_matrix_checklist.md](file:///D:/Aplikasi/EWIApps/docs/master_test_matrix_checklist.md).
2. Anda dapat mencentang kotak `[x]` secara langsung di editor markdown setiap kali selesai menguji satu skenario.
3. Jika menemukan ketidaksesuaian atau bug saat mencentang, catat ID Test-nya (misal: `BM-014`, `ST-007`, `REV-002`, atau `INT-005`) agar bisa langsung kita telusuri dan perbaiki bersama.
