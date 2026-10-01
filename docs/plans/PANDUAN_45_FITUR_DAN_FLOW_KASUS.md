# BUKU PANDUAN LENGKAP: 45 FITUR PLAYWRIGHT & 20 FLOW SKENARIO KASUS NYATA

> **Lokasi File:** `D:\Aplikasi\aitool\docs\PANDUAN_45_FITUR_DAN_FLOW_KASUS.md`  
> **Target:** Panduan operasional praktis agar Anda tahu kegunaan setiap menu (1-45), tingkat frekuensi pemakaian (rating bintang 1-5), dan alur kombinasi menu (*flow*) berdasarkan 20 studi kasus nyata.

---

## BAGIAN I: BEDAH LENGKAP 45 FITUR PLAYWRIGHT & RATING FREKUENSI

Berikut adalah rincian seluruh fitur beserta rating frekuensi pemakaian:
* ⭐⭐⭐⭐⭐ (5 Bintang) : **Sangat Sering** – Wajib dipakai hampir setiap hari / inti alur kerja.
* ⭐⭐⭐⭐☆ (4 Bintang) : **Sering** – Sangat berguna untuk kebutuhan pengujian rutin & debugging.
* ⭐⭐⭐☆☆ (3 Bintang) : **Cukup Sering** – Dipakai pada kebutuhan spesifik (misal mobile, multi-browser).
* ⭐⭐☆☆☆ (2 Bintang) : **Jarang** – Fitur penunjang untuk skenario khusus (misal audit jaringan, PDF).
* ⭐☆☆☆☆ (1 Bintang) : **Sangat Jarang** – Fitur darurat / pembersihan berkala saja.

---

### [KATEGORI 1] PEREKAMAN & CODEGEN (RECORDING)

| No | Nama Fitur | Rating | Deskripsi & Kegunaan |
|:---:|---|:---:|---|
| **1** | **CodeGen Standar** | ⭐⭐⭐⭐⭐ | Merekam klik & ketik tangan langsung tersimpan ke `tests/` sebagai skrip `.spec.js`. Dilengkapi **Auto-Repair Flutter Web** otomatis agar skrip langsung jalan tanpa diedit manual. |
| **2** | **CodeGen Mode Layar Bersih** | ⭐⭐⭐⭐⭐ | Merekam dengan mematikan highlight kotak merah & tooltip penutup selector (`PW_HIDE_HIGHLIGHT=1`). Sangat disukai karena tidak menutupi dropdown atau tombol kecil saat merekam. |
| **3** | **CodeGen Rekam Kunci Sesi Login** | ⭐⭐⭐⭐⭐ | Merekam proses login 1 kali saja dan menyimpan sesi (cookies & token) ke `auth.json`. Menghemat waktu agar Anda tidak perlu login berulang-ulang di setiap test. |
| **4** | **CodeGen Pakai Sesi Login** | ⭐⭐⭐⭐⭐ | Membuka browser perekam yang **sudah langsung berstatus Login** menggunakan tiket `auth.json`. Anda langsung berada di dalam dashboard aplikasi tanpa ketik username/password lagi. |
| **5** | **CodeGen Emulasi iPhone 14 Pro** | ⭐⭐⭐☆☆ | Membuka perekam dengan viewport dan touch-screen emulasi iPhone 14 Pro. Berguna untuk menguji apakah tampilan form di HP rapi atau rusak. |
| **6** | **CodeGen Emulasi Pixel 7 (Android)** | ⭐⭐⭐☆☆ | Membuka perekam dengan ukuran layar dan rasio ponsel Android Google Pixel. |
| **7** | **CodeGen Emulasi iPad Pro 11** | ⭐⭐☆☆☆ | Membuka perekam dengan rasio layar tablet. Berguna jika aplikasi kasir/POS digunakan di iPad. |
| **8** | **CodeGen Emulasi Dark Mode** | ⭐⭐⭐☆☆ | Memaksa browser dalam skema warna gelap (`color-scheme: dark`) untuk menguji kontras tombol dan teks. |
| **9** | **CodeGen Emulasi Geolocation & Waktu** | ⭐⭐☆☆☆ | Mengunci koordinat GPS di Jakarta (WIB - UTC+7) dan bahasa `id-ID` agar formatting tanggal dan rupiah tidak berubah-ubah. |
| **10** | **CodeGen Simpan Traffic Jaringan (HAR)** | ⭐⭐☆☆☆ | Merekam seluruh request/response API ke file `.har` untuk dianalisis performa endpoint backend-nya. |

---

### [KATEGORI 2] EKSEKUSI PENGUJIAN (TEST RUNNER)

| No | Nama Fitur | Rating | Deskripsi & Kegunaan |
|:---:|---|:---:|---|
| **11** | **Jalankan Semua Test (Headless)** | ⭐⭐⭐⭐⭐ | Menjalankan seluruh test di folder `tests/` di background tanpa memunculkan browser. Mode tercepat untuk verifikasi kilat. |
| **12** | **Jalankan Semua Test (Headed)** | ⭐⭐⭐⭐☆ | Membuka browser fisik di layar saat test jalan. Sangat memuaskan karena Anda bisa menonton robot menjalankan form otomatis seperti hantu. |
| **13** | **Pilih File Test Spesifik** | ⭐⭐⭐⭐⭐ | Memilih 1 file test saja (misal `test_revenue.spec.js`) tanpa harus menjalankan file test lainnya. Sangat hemat waktu. |
| **14** | **Test di Chromium (Chrome) Saja** | ⭐⭐⭐⭐☆ | Menjalankan test hanya pada browser Google Chrome/Chromium. |
| **15** | **Test di Firefox Saja** | ⭐⭐⭐☆☆ | Menjalankan test pada engine Mozilla Firefox untuk memastikan kompatibilitas non-Chromium. |
| **16** | **Test di WebKit (Safari) Saja** | ⭐⭐⭐☆☆ | Menjalankan test pada engine Apple Safari untuk pengguna Mac & iPhone. |
| **17** | **Filter Kata Kunci (-g Tag)** | ⭐⭐⭐⭐☆ | Menjalankan test berdasarkan kata tertentu (contoh: hanya test yang ada kata "revenue", "bank", atau "login"). |
| **18** | **Auto-Retry (Ulang 2x Jika Gagal)** | ⭐⭐⭐☆☆ | Jika ada test gagal akibat server lambat sesaat, Playwright akan mencoba lagi otomatis sebelum menyatakan gagal. |
| **19** | **Mode 1 Worker (Sequential)** | ⭐⭐⭐⭐☆ | Menjalankan test satu per satu secara antre (bukan paralel). Wajib dipakai jika test berhubungan dengan modifikasi saldo database agar tidak bentrok (race condition). |
| **20** | **Perekaman Video Nyata** | ⭐⭐⭐☆☆ | Merekam seluruh aksi test menjadi video `.webm`. Berguna untuk bukti ke atasan atau klien jika ada bug. |
| **21** | **Perekaman Trace Lengkap** | ⭐⭐⭐⭐☆ | Mencatat riwayat lengkap DOM, timeline, dan screenshot setiap langkah test untuk diselidiki di Trace Viewer. |

---

### [KATEGORI 3] DEBUGGING & VISUAL INVESTIGATION

| No | Nama Fitur | Rating | Deskripsi & Kegunaan |
|:---:|---|:---:|---|
| **22** | **Playwright UI Mode** | ⭐⭐⭐⭐⭐ | **Fitur Paling Juara!** Membuka dashboard interaktif dengan time-travel debugger, watch mode, dan log konsol visual. Wajib saat sedang aktif membuat skrip test baru. |
| **23** | **Inspector Step-by-Step (--debug)** | ⭐⭐⭐⭐☆ | Menjalankan test dengan jeda di setiap aksi. Anda bisa klik tombol "Next Step" layaknya debugger kode. |
| **24** | **Buka Laporan HTML (show-report)** | ⭐⭐⭐⭐⭐ | Membuka laporan resmi Playwright di browser, menampilkan statistik berapa test lulus, berapa detik durasi, dan di mana baris yang error. |
| **25** | **Buka Trace Viewer (show-trace)** | ⭐⭐⭐⭐☆ | Membedah rekaman file `trace.zip` untuk melihat kondisi DOM tepat 1 milidetik sebelum tombol gagal diklik. |
| **26** | **Update Baseline Snapshots** | ⭐⭐⭐☆☆ | Memperbarui gambar referensi visual regression saat ada perubahan desain UI yang memang disengaja. |
| **27** | **Buka Browser Uji Coba Cepat** | ⭐⭐⭐⭐☆ | Membuka jendela browser kosong Playwright dalam 1 detik untuk uji coba manual tanpa setup. |

---

### [KATEGORI 4] SCREENSHOT, PDF & MEDIA

| No | Nama Fitur | Rating | Deskripsi & Kegunaan |
|:---:|---|:---:|---|
| **28** | **Screenshot Cepat (Viewport)** | ⭐⭐⭐⭐☆ | Mengambil foto layar instan ukuran monitor normal. |
| **29** | **Screenshot Full-Page (Scroll Penuh)** | ⭐⭐⭐⭐⭐ | Mengambil foto seluruh halaman web dari paling atas sampai paling bawah ke dalam 1 gambar panjang tanpa terpotong scrollbar. |
| **30** | **Screenshot Mode Mobile** | ⭐⭐⭐☆☆ | Mengambil screenshot persis seperti tampilan di layar smartphone. |
| **31** | **Cetak / Ekspor Dokumen PDF** | ⭐⭐⭐☆☆ | Mengonversi halaman web (misal faktur invoice atau laporan tahunan) langsung menjadi dokumen cetak PDF resmi. |

---

### [KATEGORI 5] STEALTH & BYPASS ANTI-BOT

| No | Nama Fitur | Rating | Deskripsi & Kegunaan |
|:---:|---|:---:|---|
| **32** | **Browser Stealth Penyamaran** | ⭐⭐⭐☆☆ | Menggunakan teknik penyamaran anti-bot (`playwright-stealth`) agar web target tidak mendeteksi bahwa browser dijalankan oleh robot. |
| **33** | **Screenshot Halaman Terproteksi** | ⭐⭐☆☆☆ | Memotret halaman web yang memasang sistem proteksi Cloudflare / Captcha. |
| **34** | **Uji Deteksi Bot di Sannysoft** | ⭐⭐☆☆☆ | Mengecek apakah sidik jari browser kita terdeteksi sebagai robot atau lolos sensor di `bot.sannysoft.com`. |

---

### [KATEGORI 6] GENERATOR TEMPLATE & SCAFFOLD

| No | Nama Fitur | Rating | Deskripsi & Kegunaan |
|:---:|---|:---:|---|
| **35** | **Template: Login & Otentikasi** | ⭐⭐⭐⭐☆ | Menghasilkan file template test login siap pakai di folder `tests/`. |
| **36** | **Template: Form Finansial (Revenue & Bank)** | ⭐⭐⭐⭐⭐ | Menghasilkan skrip template pengujian pengisian Revenue, pemilihan Bank Cash BNI, dan validasi saldo bank. |
| **37** | **Template: API Testing Langsung** | ⭐⭐⭐⭐☆ | Menghasilkan skrip test REST API langsung via HTTP request tanpa perlu antarmuka browser. |
| **38** | **Template: Visual Regression Testing** | ⭐⭐⭐☆☆ | Menghasilkan skrip pengujian perbandingan piksel visual (`toHaveScreenshot`). |
| **39** | **Generator playwright.config.js** | ⭐⭐⭐⭐☆ | Membuatkan file konfigurasi resmi standar produksi secara otomatis jika proyek belum punya. |

---

### [KATEGORI 7] PEMELIHARAAN & UTILITAS

| No | Nama Fitur | Rating | Deskripsi & Kegunaan |
|:---:|---|:---:|---|
| **40** | **Install / Update Semua Driver Browser** | ⭐⭐⭐⭐⭐ | Mengunduh biner resmi Chromium, Firefox, dan WebKit (`playwright install --with-deps`). Wajib di awal 1x. |
| **41** | **Batch Auto-Repair Flutter Web** | ⭐⭐⭐⭐⭐ | Memindai seluruh skrip di folder `tests/` dan otomatis membenahi kelemahan klik Flutter Web (CanvasKit & Semantics) agar tidak macet. |
| **42** | **Bersihkan File Sampah & Laporan Lama** | ⭐⭐⭐☆☆ | Menghapus folder `test-results/` dan laporan lama yang menumpuk agar kapasitas SSD laptop tetap lega. |
| **43** | **Buka Folder tests/ di Explorer** | ⭐⭐⭐⭐☆ | Membuka folder `tests/` langsung di Windows Explorer untuk melihat file skrip `.spec.js`. |
| **44** | **Buka Folder Laporan di Explorer** | ⭐⭐⭐☆☆ | Membuka folder laporan HTML di Windows Explorer. |
| **45** | **Baca Panduan Lengkap (.md)** | ⭐⭐⭐⭐☆ | Membuka dokumen panduan dan arsitektur pengujian. |

---

## BAGIAN II: 20 FLOW SKENARIO KASUS NYATA (KAPAN HARUS PAKAI FLOW APA?)

Berikut adalah 20 alur (*chain flow*) nyata dari awal sampai akhir beserta alasan mengapa Anda memilih urutan tersebut:

---

### 🔹 KELOMPOK A: SETUP & PEREKAMAN HARIAN

#### 1. Setup Proyek Baru yang Belum Pernah Ada Playwright
* **Alur Flow:** `[40] Install Driver` ➔ `[39] Buat Config` ➔ `[27] Uji Buka Browser`
* **Kasus:** Anda baru membuat proyek atau baru clone dari GitHub dan ingin mulai pasang Playwright.
* **Alasan Urutan:** Anda harus punya driver browser dulu (40), lalu siapkan konfigurasi base URL aplikasi (39), baru tes buka browser (27) untuk memastikan semuanya berjalan lancar.

#### 2. Merekam Alur Fitur Tanpa Harus Login Berulang Kali (Alur Favorit Developer)
* **Alur Flow:** `[3] Rekam Login (auth.json)` ➔ `[4] CodeGen Pakai Sesi Login` ➔ `[13] Jalankan Test`
* **Kasus:** Anda ingin merekam fitur dalam aplikasi (misal tambah Revenue), tapi malas mengetik username/password setiap kali rekaman dimulai.
* **Alasan Urutan:** Rekam login 1x dan simpan tiketnya (3). Selanjutnya buka perekam yang sudah otomatis dalam status login (4). Terakhir jalankan hasil tesnya (13).

#### 3. Merekam Form yang Banyak Dropdown Tanpa Tertutup Kotak Merah
* **Alur Flow:** `[2] CodeGen Layar Bersih` ➔ `[41] Auto-Repair Flutter` ➔ `[13] Jalankan Test`
* **Kasus:** Saat merekam dropdown "Sumber Dana (Bank Cash)", kotak merah Playwright menutupi item pilihan sehingga sulit diklik.
* **Alasan Urutan:** Matikan highlight merah agar tampilan bersih (2), rapikan skrip otomatis dari flakiness (41), lalu uji coba (13).

---

### 🔹 KELOMPOK B: INTEGRASI LOGIKA & BISNIS APLIKASI (REVENUE & BANK CASH)

#### 4. Pengujian Fitur Integrasi Revenue Masuk ke Bank Cash BNI
* **Alur Flow:** `[36] Template Finansial` ➔ `[19] Jalankan Mode 1 Worker` ➔ `[24] Buka Laporan`
* **Kasus:** Anda baru mengubah logika backend: saat Revenue disimpan dengan Bank BNI, saldo BNI harus bertambah dan baris tidak boleh kuning.
* **Alasan Urutan:** Gunakan template finansial yang sudah siap (36), jalankan dengan 1 worker agar urutan mutasi saldo di database tidak balapan/bentrok (19), lalu cek hasilnya di laporan (24).

#### 5. Merekam Alur Lengkap Revenue dengan Sumber Dana `-` (Verifikasi Baris Kuning)
* **Alur Flow:** `[4] CodeGen Pakai Sesi` ➔ `[41] Auto-Repair` ➔ `[22] Playwright UI Mode`
* **Kasus:** Ingin memastikan baris Revenue berwarna kuning jika sumber dananya `-`, dan warnanya hilang saat diubah ke BNI.
* **Alasan Urutan:** Buka perekam langsung berstatus login (4), perbaiki kelemahan selector (41), lalu buka di UI Mode (22) untuk menggeser timeline menit demi menit melihat perubahan warna tabel.

---

### 🔹 KELOMPOK C: INVESTIGASI BUG & DEBUGGING

#### 6. Test Mendadak Gagal di Terminal, Mau Tahu Kenapa Tombol Gagal Diklik
* **Alur Flow:** `[21] Test dengan Trace ON` ➔ `[25] Buka Trace Viewer`
* **Kasus:** Di terminal muncul `TimeoutError: element not found`. Anda tidak tahu apakah tombolnya belum muncul atau posisinya bergeser.
* **Alasan Urutan:** Jalankan ulang test dengan perekaman trace lengkap (21). Buka Trace Viewer (25) untuk memutar rekaman frame demi frame melihat kondisi layar saat error terjadi.

#### 7. Menjalankan Uji Coba Langkah demi Langkah Sambil Ngopi (Step-by-Step)
* **Alur Flow:** `[23] Inspector Debug Mode` ➔ `[43] Buka Folder Tests`
* **Kasus:** Skrip test Anda panjang dan Anda ingin mengecek setiap kali robot mengetik apakah field terisi dengan benar.
* **Alasan Urutan:** Buka inspector (23) sehingga Anda bisa klik tombol panah "Step Over" langkah demi langkah. Jika ada selector salah, Anda bisa langsung edit file di folder tests (43).

#### 8. Live Testing Saat Sedang Koding (Interactive Watch Mode)
* **Alur Flow:** `[22] Playwright UI Mode`
* **Kasus:** Anda sedang mengedit tampilan form di Flutter dan ingin setiap kali Anda save, Playwright otomatis menguji ulang di samping layar Anda.
* **Alasan Urutan:** UI Mode memiliki tombol "Watch" yang otomatis mengeksekusi ulang begitu kode aplikasi Anda berubah.

---

### 🔹 KELOMPOK D: TAMPILAN RESPONSIP & MULTI-DEVICE

#### 9. Pengujian Responsif Layar Mobile Smartphone (Untuk Klien / Bos)
* **Alur Flow:** `[5] CodeGen iPhone 14 Pro` ➔ `[30] Screenshot Mobile` ➔ `[43] Buka Folder Tests`
* **Kasus:** Klien komplain bahwa form di HP terpotong atau tulisan tabel bertumpuk.
* **Alasan Urutan:** Rekam dan uji dalam ukuran layar iPhone (5), potret bukti tampilan layar HP (30), lalu ambil filenya di Explorer (43).

#### 10. Pengujian Kompatibilitas Khusus Pengguna Apple Safari (Mac/iOS)
* **Alur Flow:** `[16] Test di WebKit Saja` ➔ `[24] Buka Laporan`
* **Kasus:** Pengguna MacBook melaporkan bahwa tombol login tidak bisa diklik di browser Safari, padahal di Chrome lancar.
* **Alasan Urutan:** Jalankan pengujian eksklusif di mesin WebKit (16) dan lihat laporan apakah ada CSS/JS yang tidak didukung Safari (24).

---

### 🔹 KELOMPOK E: PENGUJIAN REGRESI VISUAL & CETAK DOKUMEN

#### 11. Pengujian Desain UI Tidak Boleh Bergeser 1 Piksel Pun (Visual Regression)
* **Alur Flow:** `[38] Template Visual` ➔ `[11] Jalankan Test` ➔ `[26] Update Baseline jika Memang Berubah`
* **Kasus:** Anda mengganti tema atau padding tabel dan ingin memastikan tidak ada tombol lain yang terdorong keluar layar.
* **Alasan Urutan:** Pasang assert `expect(page).toHaveScreenshot()` (38), jalankan untuk membandingkan piksel gambar (11), jika perubahan desain memang diinginkan, perbarui foto referensinya (26).

#### 12. Cetak Otomatis Halaman Laporan Tahunan ke Dokumen PDF
* **Alur Flow:** `[3] Login auth.json` ➔ `[31] Cetak PDF`
* **Kasus:** Anda ingin mengonversi hasil Laporan Tahunan di browser menjadi file PDF resmi tanpa harus menekan tombol Ctrl+P manual.
* **Alasan Urutan:** Siapkan login (3), lalu perintahkan Playwright mengonversi halaman laporan menjadi file PDF beresolusi tinggi (31).

---

### 🔹 KELOMPOK F: PENGUJIAN API & BACKEND CEPAT

#### 13. Pengujian Endpoint REST API Tanpa Menjalankan Antarmuka Browser
* **Alur Flow:** `[37] Template API` ➔ `[13] Jalankan Test File Tersebut`
* **Kasus:** Anda hanya ingin menguji endpoint backend `/api/revenues` atau `/api/bank-management/banks` apakah mengembalikan status 200 dan JSON yang benar tanpa beban rendering browser.
* **Alasan Urutan:** Buat template API testing (37) lalu eksekusi langsung (13). Waktu pengujian biasanya selesai dalam waktu kurang dari 0.5 detik!

#### 14. Audit Kecepatan & Jaringan Backend (Merekam File HAR)
* **Alur Flow:** `[10] CodeGen Simpan HAR` ➔ `[27] Buka Browser`
* **Kasus:** Aplikasi terasa berat dan Anda ingin memeriksa endpoint mana yang responsenya memakan waktu lebih dari 3 detik.
* **Alasan Urutan:** Rekam seluruh traffic jaringan ke file `.har` (10), lalu buka dan inspect timing waterfall-nya.

---

### 🔹 KELOMPOK G: PENYAMARAN & BYPASS WEB TERPROTEKSI

#### 15. Mengakses Web Eksternal yang Dilindungi Cloudflare / Anti-Bot
* **Alur Flow:** `[34] Uji Deteksi di Sannysoft` ➔ `[32] Buka Stealth Browser` ➔ `[33] Screenshot Stealth`
* **Kasus:** Anda ingin mengotomasi pengambilan data kurs dollar dari web perbankan atau web eksternal yang memblokir robot Playwright.
* **Alasan Urutan:** Periksa celah fingerprint (34), buka dengan mode penyamaran stealth (32), lalu potret hasilnya (33).

---

### 🔹 KELOMPOK H: PEMELIHARAAN, RUTINITAS & BUKTI DEMO

#### 16. Rutinitas Wajib Sebelum Git Push / Rilis Aplikasi (Sanity Check)
* **Alur Flow:** `[41] Auto-Repair Semua Test` ➔ `[11] Jalankan Semua Test` ➔ `[24] Cek Laporan`
* **Kasus:** Anda sudah selesai koding seharian dan ingin memastikan tidak ada fitur lama yang rusak sebelum di-commit ke Git repository.
* **Alasan Urutan:** Rapikan semua skrip (41), jalankan seluruh suite pengujian secara headless (11), dan pastikan laporan berwarna hijau 100% (24).

#### 17. Merekam Bukti Video Aksi Otomasi untuk Klien / Demo Manajemen
* **Alur Flow:** `[20] Test dengan Video ON` ➔ `[44] Buka Folder Laporan / Test-Results`
* **Kasus:** Manajemen meminta bukti bahwa fitur otomatisasi input data keuangan sudah berjalan sempurna.
* **Alasan Urutan:** Jalankan test dengan opsi video hidup (20), lalu buka folder hasil rekaman untuk mengambil file video `.webm` (44).

#### 18. Memperbaiki Skrip Test Flutter Web yang Tiba-Tiba Flaky / Macet
* **Alur Flow:** `[41] Batch Auto-Repair tests/` ➔ `[13] Jalankan Test Terkait`
* **Kasus:** Skrip rekaman Flutter Web sering macet karena selector teks tidak terdeteksi atau animasi render belum selesai.
* **Alasan Urutan:** Jalankan batch auto-repair (41) yang otomatis menyuntikkan `waitForLoadState` dan perbaikan `role-name`, lalu uji coba (13).

#### 19. Bersihkan Kapasitas SSD Laptop Setelah Seminggu Pengujian
* **Alur Flow:** `[42] Bersihkan Sampah test-results/ & Report`
* **Kasus:** Folder proyek membengkak sampai beberapa gigabyte akibat video, screenshot, dan trace lama yang sudah tidak dipakai.
* **Alasan Urutan:** Jalankan pembersihan sampah 1-klik (42) untuk menghapus seluruh file cache dan artefak sementara.

#### 20. Uji Coba Cepat Suatu Alur Tertentu Menggunakan Filter Tag
* **Alur Flow:** `[17] Test dengan Filter Kata Kunci (-g "bank")` ➔ `[12] Jalankan Mode Headed`
* **Kasus:** Anda punya 30 file test di folder `tests/`, tapi hari ini Anda hanya mengutak-atik fitur Bank Cash dan tidak mau menunggu 29 test lainnya jalan.
* **Alasan Urutan:** Gunakan filter tag kata kunci (17) dan lihat langsung aksinya di layar (12).

---

## RANGKUMAN CHEAT SHEET PALING SERING DIGUNAKAN (TOP 5)

Jika Anda bingung harus mulai dari mana setiap hari, gunakan kombinasi sakti ini:

1. **Rekam Login 1x:** Menu **3** (`auth.json`)
2. **Rekam Fitur Baru:** Menu **4** (Langsung dalam kondisi login)
3. **Lihat & Debug Interaktif:** Menu **22** (UI Mode)
4. **Jalankan Test Rutin:** Menu **13** (Pilih file test)
5. **Lihat Laporan:** Menu **24** (Buka show-report)
