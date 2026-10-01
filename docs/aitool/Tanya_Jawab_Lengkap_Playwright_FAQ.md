# PANDUAN LENGKAP & TANYA JAWAB OPERASIONAL PLAYWRIGHT (FAQ LENGKAP)

> **Dokumentasi Resmi AI Tools Control Center**  
> **Lokasi File Proyek:** `docs/aitool/Tanya_Jawab_Lengkap_Playwright_FAQ.md`  
> **Lokasi File Pusat AI Tool:** `D:\Aplikasi\aitool\docs\Tanya_Jawab_Lengkap_Playwright_FAQ.md`  
> **Deskripsi:** Dokumentasi lengkap 100% yang mencakup seluruh bedah menu Playwright (Menu 30–38), tabel perbandingan, panduan 4 jendela di layar, strategi bypass login (`auth.json`), penanganan multi-role, pengujian Flutter Web vs Website publik, dan rekaman tanya jawab tanya jawab interaktif.

---

## 📑 DAFTAR ISI
1. [Bedah Detail Menu 30–38: Apa yang Terjadi Saat Ditekan?](#1-bedah-detail-menu-3038-apa-yang-terjadi-saat-ditekan)
2. [Tabel Perbandingan & Perbedaan Utama](#2-tabel-perbandingan--perbedaan-utama)
3. [Apakah Harus Ditekan Berurutan (30 ke 33 ke 31)?](#3-apakah-harus-ditekan-berurutan-30-ke-33-ke-31)
4. [Apakah Harus Website atau Bisa Aplikasi Desktop / HP?](#4-apakah-harus-website-atau-bisa-aplikasi-desktop--hp)
5. [Apakah Aplikasinya Harus Dihidupkan (Flutter Run) Dulu?](#5-apakah-aplikasinya-harus-dihidupkan-flutter-run-dulu)
6. [Tampilan Browser & Ukuran Jendela (Apakah Harus Full Screen?)](#6-tampilan-browser--ukuran-jendela-apakah-harus-full-screen)
7. [Fungsi Menu 33 (playwright open) & Menu yang Bisa Melakukan Aksi](#7-fungsi-menu-33-playwright-open--menu-yang-bisa-melakukan-aksi)
8. [Rekam Aksi Otomatis (Menu 31 CodeGen) & Lampu Merah Record 🔴](#8-rekam-aksi-otomatis-menu-31-codegen--lampu-merah-record-)
9. [Penjelasan 4 Jendela di Layar Saat Perekaman Berjalan](#9-penjelasan-4-jendela-di-layar-saat-perekaman-berjalan)
10. [Kenapa Muncul Jendela Chrome Ganda & Cara Menjalankan Headless Web-Server](#10-kenapa-muncul-jendela-chrome-ganda--cara-menjalankan-headless-web-server)
11. [Apakah Tombol "Ingat Saya" di Form Login Perlu Dicentang?](#11-apakah-tombol-ingat-saya-di-form-login-perlu-dicentang)
12. [Kenapa Playwright Selalu Minta Login dari Nol & Solusi Kunci Login (auth.json)](#12-kenapa-playwright-selalu-minta-login-dari-nol--solusi-kunci-login-authjson)
13. [Strategi Testing Halaman Report / Settlement: Mulai dari Login atau Dashboard?](#13-strategi-testing-halaman-report--settlement-mulai-dari-login-atau-dashboard)
14. [Penanganan Multi-Role (Admin, Finance, User) dengan File Auth Terpisah](#14-penanganan-multi-role-admin-finance-user-dengan-file-auth-terpisah)
15. [Kenapa di Flutter Web Tidak Bisa Langsung Mengetik URL Report?](#15-kenapa-di-flutter-web-tidak-bisa-langsung-mengetik-url-report)
16. [Keamanan Testing Melompati Login Langsung ke Dashboard](#16-keamanan-testing-melompati-login-langsung-ke-dashboard)
17. [Panduan Praktis 1 Menit: Rekam & Uji Langsung dari Dashboard](#17-panduan-praktis-1-menit-rekam--uji-langsung-dari-dashboard)

---

## 1. 🔍 BEDAH DETAIL MENU 30–38: APA YANG TERJADI SAAT DITEKAN?

### [30] Download / Install Browser Driver (`playwright install`)
* **Kapan dipakai?** Pertama kali setup komputer baru, atau jika ada update browser engine.
* **Apa yang terjadi saat ditekan?**
  * Terminal akan mendownload binary mesin browser resmi Chromium (~150MB), Firefox (~80MB), dan WebKit (~70MB).
  * Browser ini disimpan di folder sistem Windows (`%USERPROFILE%\AppData\Local\ms-playwright`).
* **Apakah meminta input?** Tidak ada. Berjalan otomatis sampai selesai.
* **Hasil Akhir:** Komputer Anda siap menjalankan otomasi browser apa pun tanpa perlu konfigurasi driver manual.

---

### [31] Rekam Aksi Otomatis / CodeGen (`playwright codegen`)
* **Kapan dipakai?** Saat Anda ingin membuat skrip otomasi tanpa mengetik kode sama sekali.
* **Apa yang terjadi saat ditekan?**
  1. Terminal meminta Anda: `Masukkan URL target (default: http://localhost:3000):`
  2. Begitu Anda tekan Enter, akan muncul **2 jendela sekaligus** di layar:
     * **Jendela Kiri:** Browser Google Chrome / Chromium.
     * **Jendela Kanan:** Jendela *"Playwright Inspector"* (perekam kode).
  3. Sekarang, Anda tinggal beraksi di jendela browser:
     * Klik tombol Login -> Di jendela kanan otomatis tertulis kode `page.click('button#login')`.
     * Ketik email/password -> Otomatis tertulis `page.fill('input#email', 'dio@gmail.com')`.
     * Klik menu, pindah halaman -> Semua terekam real-time.
* **Hasil Akhir:** Di jendela kanan ada tombol **"Copy"**. Anda tinggal klik Copy untuk menyimpan seluruh langkah tersebut menjadi file script (`test.js` atau `test.py`).

---

### [32] Ambil Screenshot Website Biasa (`playwright screenshot`)
* **Kapan dipakai?** Saat ingin mendokumentasikan tampilan web lokal (misal Flutter Web di `localhost:5000` / `localhost:60360`) atau web umum.
* **Apa yang terjadi saat ditekan?**
  1. Meminta: `Masukkan URL:` (misal: `http://localhost:60360`)
  2. Meminta: `Nama file gambar:` (default: `screenshot.png`)
  3. Meminta: `Screenshot satu halaman penuh (full-page)? (y/n):`
     * Jika Anda pilih **y**: Playwright akan memotret dari paling atas header sampai footer paling bawah (meskipun harus di-scroll panjang).
     * Jika Anda pilih **n**: Hanya memotret apa yang tampak di layar monitor (*viewport*).
  4. Browser bekerja sekejap di latar belakang (*headless*), lalu tertutup otomatis.
* **Hasil Akhir:** File gambar `.png` langsung tersimpan di folder project aktif Anda.

---

### [33] Buka Browser Uji Coba Cepat (`playwright open`)
* **Kapan dipakai?** Hanya untuk mengetes apakah URL target bisa diakses oleh mesin Playwright tanpa error.
* **Apa yang terjadi saat ditekan?**
  1. Meminta input: `Masukkan URL:` (default: `https://google.com` atau alamat localhost Anda).
  2. Jendela browser Chromium Playwright akan terbuka ke halaman tersebut.
* **Hasil Akhir:** Browser terbuka biasa untuk Anda lihat langsung bahwa koneksi dan rendering halaman berhasil.

---

### [34] Jalankan Tes Playwright di Terminal (`playwright test`)
* **Kapan dipakai?** Saat project Anda sudah punya file skrip pengujian (folder `tests/`) dan Anda ingin mengujinya secara massal dan cepat.
* **Apa yang terjadi saat ditekan?**
  * Playwright menjalankan semua skrip tes di latar belakang (*headless*, tanpa jendela muncul).
  * Di terminal akan muncul centang hijau `✓` jika sukses, atau tanda silang merah `✕` jika ada tombol yang rusak/gagal.
* **Hasil Akhir:** Ringkasan hasil tes di terminal: *"15 passed, 0 failed"*.

---

### [35] Jalankan Tes Mode Interaktif Modern (`playwright test --ui`)
* **Kapan dipakai?** Ini adalah fitur terhebat Playwright untuk developer.
* **Apa yang terjadi saat ditekan?**
  * Membuka aplikasi visual dashboard modern Playwright di layar.
  * Anda bisa mengeklik tombol **"Play"** pada tes tertentu.
  * Ada fitur **Time-Travel (Mesin Waktu)**:
    * Anda bisa menggeser garis waktu (*timeline*) detik demi detik untuk melihat persis kondisi website sebelum tombol diklik dan sesudah diklik.
    * Jika ada tombol yang error, Anda bisa melihat foto tepat saat error terjadi.
* **Hasil Akhir:** Tidak perlu menebak-nebak kenapa tes gagal karena ada rekaman visualnya secara menyeluruh.

---

### [36] Buka Laporan Hasil Tes Terakhir (`playwright show-report`)
* **Kapan dipakai?** Setelah Anda menjalankan tes di Menu 34.
* **Apa yang terjadi saat ditekan?**
  * Playwright membuka tab baru di browser default Anda yang menampilkan dashboard HTML laporan lengkap: grafik keberhasilan, durasi loading, dan cuplikan error jika ada.
* **Hasil Akhir:** Dashboard interaktif laporan kualitas web.

---

### [37] [STEALTH] Buka Browser Penyamaran Anti-Bot
* **Kapan dipakai?** Saat Anda ingin membuka website yang memakai proteksi ketat (Cloudflare, reCAPTCHA, atau anti-scraper) yang biasanya memblokir bot biasa.
* **Apa yang terjadi saat ditekan?**
  1. Meminta: `Masukkan URL target (default: https://bot.sannysoft.com)`.
  2. Mesin Chromium terbuka dalam mode penyamaran penuh:
     * Variabel robot `navigator.webdriver` dihapus.
     * Ciri-ciri hardware, plugin Chrome, dan audio context disamarkan seperti laptop manusia biasa.
  3. Jendela browser terbuka maksimal. Anda bisa mengetik, login, atau melewati halaman yang biasanya memunculkan error Captcha.
* **Hasil Akhir:** Anda bisa berselancar/login di situs berproteksi tanpa terdeteksi sebagai script otomasi.

---

### [38] [STEALTH] Ambil Screenshot Halaman Berproteksi
* **Kapan dipakai?** Sama seperti Menu 32, tetapi khusus untuk website yang menolak screenshot bot biasa (misalnya website perbankan, portal korporat, atau e-commerce ber-Cloudflare).
* **Apa yang terjadi saat ditekan?**
  1. Meminta URL dan nama file gambar.
  2. Menggunakan plugin Stealth untuk menyusup dan merender halaman tanpa terdeteksi.
  3. Mengambil screenshot halaman penuh (*full-page*).
* **Hasil Akhir:** Gambar `.png` tersimpan mulus tanpa terblokir halaman *"Access Denied / 403 Forbidden"*.

---

## 2. ⚖️ TABEL PERBANDINGAN & PERBEDAAN UTAMA

| Yang Dibandingkan | Opsi Biasa | Opsi Stealth / Canggih | Bedanya Apa? |
| :--- | :--- | :--- | :--- |
| **Buka Browser** | **Menu 33** (`open`) | **Menu 37** (`stealth`) | Menu 33 terdeteksi robot oleh Cloudflare; **Menu 37 lolos verifikasi anti-bot**. |
| **Screenshot** | **Menu 32** (Biasa) | **Menu 38** (Stealth) | Menu 32 bisa diblokir halaman 403 Forbidden; **Menu 38 menembus proteksi**. |
| **Jalankan Tes** | **Menu 34** (Terminal Teks) | **Menu 35** (UI Mode) | Menu 34 cuma teks terminal; **Menu 35 punya visual time-travel rekaman layar**. |
| **Membuat Skrip** | Menulis kode manual | **Menu 31** (CodeGen) | Menu 31 **merekam klik mouse Anda** jadi kode tanpa perlu ngoding manual. |

---

## 3. ❓ APAKAH HARUS DITEKAN BERURUTAN (30 KE 33 KE 31)?

**Pertanyaan:**  
*"dari 30 ke 33 gitu? baru ke 31? saya gak paham"*

**Jawaban:**  
**❌ Anda TIDAK PERLU menekannya secara berurutan!**  
Menu 30 sampai 38 itu **BUKAN tahapan yang harus ditekan satu per satu**. Itu adalah **Menu Pilihan Bebas (seperti menu di restoran)**:

> Kalau Anda mau makan mie ayam, Anda tidak perlu beli bakso dulu.  
> Langsung pilih menu yang sedang Anda butuhkan saat itu!

### Kenapa Nomornya 30, 31, 32, 33...?
Hanya sebagai nomor kode tombol di keyboard Anda untuk pengelompokan modul:
* **Nomor 1–10** = Menu Project Control (Flutter Run, Backend Flask, Clean, Build)
* **Nomor 11–16** = Menu Graphify Knowledge Graph
* **Nomor 21–23** = Menu 9Router AI Gateway
* **Nomor 30–38** = Kelompok Fitur Playwright

### Tabel Pilihan Cepat Kebutuhan Anda:
| Jika Keinginan Anda adalah: | CUKUP TEKAN TOMBOL INI SAJA: |
| :--- | :--- |
| *"Saya mau merekam gerakan klik mouse saya di web biar jadi kode otomatis"* | **Langsung tekan 31** |
| *"Saya cuma mau foto / screenshot halaman web dari atas sampai bawah"* | **Langsung tekan 32** |
| *"Saya mau buka website tapi kena blokir Cloudflare / ada Captcha"* | **Langsung tekan 37** |
| *"Saya mau tes apakah browsernya jalan atau tidak"* | **Langsung tekan 33** |
| *"Komputer saya baru pertama kali setup, belum ada browser Playwright"* | **Tekan 30 (cukup 1x seumur hidup)** |

**Kesimpulan:**  
Anda **TIDAK PERLU** menekan 30 lalu 33 lalu 31.  
Jika hari ini Anda hanya butuh rekam klik otomatis, buka AI Tool lalu langsung ketik `31` lalu Enter. Selesai!

---

## 4. 💻 APAKAH HARUS WEBSITE ATAU BISA APLIKASI DESKTOP / HP?

**Pertanyaan:**  
*"bisa di apliaski atauh arus website?"*

**Jawaban:**  
👉 **HARUS BERUPA WEBSITE (Buka di Browser)!**

1. Playwright adalah alat pengendali **Browser Web** (Google Chrome, Edge, Firefox, WebKit).
2. Playwright tidak bisa mengendalikan aplikasi Windows `.exe` murni atau HP Android `.apk` secara langsung.
3. **Tetapi aplikasi Flutter Anda BISA dijadikan Website!**  
   Flutter memiliki fitur kompilasi bawaan ke Web. Jika Anda ingin mengetes aplikasi Flutter Anda dengan Playwright, jalankan Flutter dalam mode Web (Chrome / Web Server).

---

## 5. 🔌 APAKAH APLIKASINYA HARUS DIHIDUPKAN (FLUTTER RUN) DULU?

**Pertanyaan:**  
*"harus hipudin dulu kah apliaksi di flutter run?"*

**Jawaban:**  
Tergantung target yang ingin Anda tuju:

### Skenario A: Jika ingin mengetes APLIKASI FLUTTER ANDA SENDIRI
👉 **YA, HARUS DIHIDUPKAN DULU!**
* Hidupkan dulu aplikasinya di mode Web (bisa pilih Menu `[2] Full Stack Web` di `menu.bat`).
* Aplikasi Flutter Web Anda akan aktif di browser (misalnya di alamat: `http://localhost:60360`).
* Setelah aplikasinya hidup, baru Anda buka Playwright (misal tekan `31` untuk rekam aksi atau `32` untuk screenshot) dan masukkan alamat `http://localhost:...` tersebut.

### Skenario B: Jika ingin membuka WEBSITE UMUM DI INTERNET
👉 **TIDAK PERLU HIDUPKAN APA-APA!**
* Jika Anda mau screenshot atau scraping website online (misal: `https://google.com`, web portal kantor, atau website e-commerce):
* Anda tidak perlu menjalankan Flutter sama sekali.
* Langsung buka Playwright, masukkan URL website publik tersebut, dan Playwright akan langsung membukanya.

**Ringkasannya:**
* Playwright hanya bekerja di halaman web / browser.
* Kalau mau tes project lokal Anda, hidupkan dulu via Flutter Web.
* Kalau mau buka website orang lain / online, langsung pakai saja tanpa perlu start apa-apa.

---

## 6. 🖥️ TAMPILAN BROWSER & UKURAN JENDELA (APAKAH HARUS FULL SCREEN?)

**Pertanyaan:**  
*"Apakah jendela browser yang ada harus di-full screen?"*

**Jawaban:**  
👉 **TIDAK PERLU Full Screen sama sekali!**  
Biarkan saja ukuran jendelanya seperti itu, jangan ditutup.

**Kenapa?**  
Karena Playwright nantinya akan membuka jendela browser miliknya sendiri secara terpisah. Jadi ukuran jendela Chrome yang sedang terbuka di layar sama sekali tidak berpengaruh pada proses otomasi Playwright.

### Langkah untuk Mencobanya:
1. Buka terminal AI Tool Anda (`runaitool.bat`).
2. Tekan angka `33` lalu tekan Enter.
3. Di terminal akan muncul pertanyaan:
   ```text
   Masukkan URL yang ingin dibuka:
   ```
4. Ketik (atau paste) alamat web aplikasi Anda:
   ```text
   http://localhost:60360
   ```
5. Tekan Enter! Playwright akan langsung membuka jendela browser miliknya dan menampilkan halaman aplikasi Anda.

---

## 7. ⚙️ FUNGSI MENU 33 (playwright open) & MENU YANG BISA MELAKUKAN AKSI

**Pertanyaan:**  
*"33 kaya gini ... ohh cuman bukna tetap igka bisa apa apin ya?"*

**Jawaban:**  
**Iya, BETUL SEKALI!**  
Untuk Menu 33 (`playwright open`), fungsinya memang **HANYA MEMBUKA** saja. Ibaratnya seperti menyalakan mesin mobil dan membiarkannya diam di tempat untuk memastikan mesinnya hidup dan tidak mogok.

### Menu yang "BISA MELAKUKAN SESUATU" Ada di Menu Lain:
Jika Anda ingin Playwright melakukan aksi nyata, gunakan menu-menu ini:

| Menu | Apa yang Bisa Dilakukannya? |
| :--- | :--- |
| **Menu 31 (CodeGen)** | **MEREKAM:** Saat Anda klik tombol atau ketik teks di web, dia mencatat semuanya menjadi skrip robot otomatis. |
| **Menu 32 (Screenshot)** | **MEMOTRET:** Mengambil foto gambar web dari header sampai footer dan menyimpannya jadi file `.png`. |
| **Menu 35 (UI Mode)** | **MENGUJI & MENGETES:** Robot menjalankan tes otomatis sambil menampilkan rekaman video time-travel (bisa dimaju-mundurkan untuk mencari error). |
| **Menu 37 (Stealth)** | **MENYAMAR:** Membuka browser dengan mematikan deteksi robot agar tidak diblokir oleh Captcha / Cloudflare. |

---

## 8. 🔴 REKAM AKSI OTOMATIS (MENU 31 CODEGEN) & LAMPU MERAH RECORD

**Pertanyaan:**  
*"Bagaimana cara kerja Menu 31 CodeGen dan apa tanda lampu merah di atas?"*

**Jawaban:**  
Saat Menu 31 aktif, muncul jendela browser dengan **titik merah 🔴** di bagian atas bar:
* Itu tanda bahwa **PEREKAM SUDAH AKTIF (Recording Mode On)**!
* Di layar ada 2 jendela utama Playwright:
  1. **Jendela Browser (di depan):** Tempat Anda berinteraksi dengan aplikasi.
  2. **Jendela Playwright Inspector (di kanan atas):** Tempat teks kode otomatis ditulis.

### Apa yang Harus Anda Lakukan?
👉 **Anda TIDAK PERLU mengubah kode apa pun!** Cukup berinteraksi di browser depan layaknya manusia biasa:
1. Klik kotak *"Username atau Email"* di browser, lalu ketik username/email Anda.
2. Klik kotak *"Password"*, lalu ketik password Anda.
3. Klik tombol biru *"Masuk"*.

### Apa yang Terjadi di Jendela Kanan Atas (Playwright Inspector)?
Setiap kali Anda mengeklik atau mengetik, jendela kanan atas otomatis menambahkan baris kode baru:
```javascript
await page.getByPlaceholder('Username atau Email').fill('nama_user');
await page.getByPlaceholder('Password').fill('rahasia123');
await page.getByRole('button', { name: 'Masuk' }).click();
```
Playwright sedang mencatat setiap gerakan tangan Anda ke dalam bahasa pemrograman komputer!

### Cara Menyelesaikan dan Menyimpan Hasil Rekamannya:
1. Di jendela kanan atas (Playwright Inspector), ada ikon dua lembar kertas (**Copy**) di baris atas. Klik ikon itu untuk menyalin seluruh kode yang baru saja direkam.
2. Paste kode tersebut ke file teks / file pengujian Anda.
3. Untuk mengakhiri, tinggal tutup jendela browsernya (klik tanda X). Rekaman selesai!

---

## 9. 🪟 PENJELASAN 4 JENDELA DI LAYAR SAAT PEREKAMAN BERJALAN

**Pertanyaan:**  
*"gak disini ada 4 jendel kasih atu itu jenderal apa kalo itu ada cmd sama braower saya teptai diistu kebukna 2 brwoser rekaman dan koding brwwoser rekaman itu apakah saya harsu otak atik disitu atau di browoser saya?"*

**Jawaban:**  
Biar tidak bingung, ini rincian lengkap 4 jendela yang ada di monitor Anda:

### 1. Jendela 1: CMD / Terminal Hitam di Paling Kiri
* Ini terminal AI Tools tempat Anda menekan angka `31`.
* **Fungsinya:** Mesin penggerak yang menyalakan Playwright.
* **Tindakan Anda:** *Biarkan saja berjalan di background.*

### 2. Jendela 2: Browser Asli Anda di Belakang
* Ini Chrome biasa Anda yang membuka aplikasi dari awal (`http://localhost:60360`).
* **Fungsinya:** Server utama yang melayani tampilan web lokal Flutter.
* **Tindakan Anda:** *Biarkan saja, jangan diotak-atik.*

### 3. Jendela 3: Browser Rekaman di Depan (Yang Ada Toolbar Merah 🔴 di Atas)
* **Ciri khasnya:** Di bagian atas halaman web ada bar kecil dengan bulatan merah 🔴.
* **👉 DI SINI TEMPAT ANDA MENGKLIK, MENGETIK, DAN BERINTERAKSI!**
* Jangan klik di browser asli Anda di belakang, melainkan klik dan ketiklah di Jendela 3 ini.

### 4. Jendela 4: Playwright Inspector di Kanan Atas
* Jendela hitam kecil yang menampilkan teks kode otomatis (`import { test, expect }...`).
* **Fungsinya:** *"Kertas catatan otomatis"*. Dia yang mencatat semua ketikan dan klik tombol Anda dari Jendela 3 secara instan.
* **Tindakan Anda:** *Lihat kodenya bertambah, lalu klik tombol Copy jika rekaman selesai.*

---

## 10. 🏪 KENAPA MUNCUL JENDELA CHROME GANDA & CARA MENJALANKAN HEADLESS WEB-SERVER

**Pertanyaan:**  
*"beararti jedneal 2 itu gak perlu dong berarti tnapa hidpuip web harunsay bisa jaha langsung ke jnedela 3?"*

**Jawaban:**  
Tampilan Jendela 2 sebenarnya tidak perlu Anda lihat, **TETAPI "Mesin Webnya" HARUS TETAP NYALA!**

### Analogi Toko & Pengunjung:
* **Mesin Flutter (Jendela 2)** = **"Toko & Pelayannya"** yang menjual aplikasi di alamat `http://localhost:60360`.
* **Playwright (Jendela 3)** = **"Pembeli / Pengunjung"** yang datang ke toko tersebut.
* **Kalau Tokonya tidak dibuka dulu (Flutter tidak dihidupkan):** Saat Playwright (Jendela 3) datang ke alamat `http://localhost:60360`, pintunya tertutup / gelap gulita dan muncul error: *"This site can't be reached (Situs tidak ditemukan)"*.

### Kenapa Ada 2 Jendela Chrome Sekaligus di Layar?
* Saat Anda memilih Flutter Web Chrome biasa, Flutter secara otomatis memunculkan Jendela Chrome (Jendela 2).
* Lalu saat Anda menyalakan Playwright (Menu 31), Playwright memunculkan lagi Jendela Chrome miliknya sendiri (Jendela 3). Akhirnya jadi ada 2 jendela di layar Anda.

### Apakah Bisa Supaya Jendela 2 Tidak Perlu Muncul di Layar?
👉 **BISA BANGET!**  
Di Flutter ada perintah khusus untuk menjalankan server web tanpa membuka browser:
```bash
flutter run -d web-server --web-port 8080
```
Jika memakai cara ini:
* Mesin aplikasi Anda menyala di latar belakang tanpa memunculkan jendela Chrome apa pun di layar.
* Sehingga saat Anda menekan `31` di Playwright, **di layar Anda HANYA ADA 1 JENDELA SAJA (Jendela 3 Playwright)**, tidak ada jendela Chrome ganda yang membingungkan!

### Bedanya dengan Website Publik (Misal google.com):
* Kalau Anda mau buka `https://google.com`: Anda tidak perlu hidupkan apa-apa di laptop, langsung ke Jendela 3 Playwright saja, karena server Google sudah menyala 24 jam di internet.
* Tapi kalau aplikasi lokal di laptop Anda: laptop Anda harus menyalakan servernya dulu agar Playwright punya halaman untuk dibuka.

---

## 11. ☑️ APAKAH TOMBOL "INGAT SAYA" DI FORM LOGIN PERLU DICENTANG?

**Pertanyaan:**  
*"terus ini kna di login yah apkaah ingetin saya itu perlu di tekne juga?"*

**Jawaban:**  
**BEBAS! Tidak wajib ditekan.**

Playwright itu seperti kamera video yang merekam apa pun yang Anda lakukan:
* **Kalau Anda CENTANG "Ingat Saya":**  
  Playwright di jendela kanan atas akan otomatis mencatat perintah centang:
  ```javascript
  await page.getByLabel('Ingat Saya').check();
  ```
* **Kalau Anda TIDAK CENTANG:**  
  Playwright tidak mencatat aksi itu, dan akan langsung lanjut ke tombol Masuk.

### Saran Praktis:
* Kalau Anda cuma mau tes login biasa: Tidak perlu dicentang, langsung saja klik tombol biru **"Masuk"**.
* Kalau Anda penasaran ingin melihat Playwright merekam klik centang: Klik saja kotak *"Ingat Saya"* tersebut, dan perhatikan jendela kanan atas langsung bertambah satu baris kode rekaman baru.

---

## 12. 🔑 KENAPA PLAYWRIGHT SELALU MINTA LOGIN DARI NOL & SOLUSI KUNCI LOGIN (auth.json)

**Pertanyaan:**  
*"kalo seadinaya sayamulai dari dashboard gitu dan fitur itu untuk import database, tetapi saat di cobain tenryata itu dari plauwithnya login gimana ccara loginnay kalo gak ad ariawat untuk lakuin login itu?"*

**Jawaban:**  
### Kenapa Playwright Selalu Minta Login dari Nol?
Secara default, Playwright selalu membuka browser dalam mode **"Private / Incognito Bersih"**. Dia tidak membaca cookies atau riwayat login yang ada di browser Chrome harian laptop Anda.  
Akibatnya, saat Anda mau langsung buka halaman Dashboard atau Import Database, sistem mendeteksi Anda belum punya tiket login, lalu otomatis dilempar kembali ke halaman Login.

### Solusi Terbaik: "Fitur Simpan Kunci Login" (`storage-state`)
Playwright punya fitur bawaan bernama `storage-state`.  
**Konsepnya:** Anda login **SEKALI SAJA**, lalu Playwright menyimpan kunci/tiket loginnya ke dalam file kecil bernama `auth.json`.

Setelah punya file `auth.json` itu:
* Anda **TIDAK PERLU LOGIN LAGI**.
* Playwright bisa langsung membuka Dashboard atau Halaman Import Database dalam kondisi **SUDAH LOGIN OTOMATIS!**

### Cara Menggunakannya (Cuma 2 Langkah):

#### Langkah 1: Simpan Kunci Login (Cukup 1 Kali Saja)
Buka terminal dan jalankan perintah ini:
```bash
npx playwright codegen --save-storage=auth.json http://localhost:60360
```
1. Jendela browser akan terbuka.
2. Anda login seperti biasa (masukkan username & password lalu klik Masuk).
3. Begitu sudah berhasil masuk ke halaman dalam (Dashboard), tutup browsernya.
4. 🎉 **SELESAI!** Sebuah file bernama `auth.json` otomatis tersimpan di laptop Anda (berisi token & tiket login Anda).

#### Langkah 2: Langsung Buka Dashboard / Import Database (Tanpa Lewat Login)
Kapan pun Anda mau menguji fitur Dashboard atau Import Database, gunakan perintah ini:
```bash
npx playwright codegen --load-storage=auth.json http://localhost:60360
```
🚀 **BUM!** Browser akan langsung terbuka di halaman Dashboard / Import Database. Anda tidak akan melihat halaman login lagi karena Playwright sudah otomatis membawa "kunci masuk" dari file `auth.json` tadi!

---

## 13. 📊 STRATEGI TESTING HALAMAN REPORT / SETTLEMENT: MULAI DARI LOGIN ATAU DASHBOARD?

**Pertanyaan:**  
*"dan sata melakuakn report gitu, apkaha awlanya harus dari login atau dari halam reoprt atau halaman setlmetn atau halaman dashboard ya?"*

**Jawaban:**  
Tergantung apa tujuan pengujian Anda! Di dunia testing profesional, ada 2 Pilihan Strategi:

### PILIHAN 1: Mulai Langsung dari Halaman Report / Settlement (Paling Direkomendasikan & Hemat Waktu ⚡)
* **Caranya:** Gunakan file kunci login (`auth.json`).
* **Alurnya:** Begitu Playwright jalan, browser langsung loncat terbuka di Halaman Settlement atau Halaman Report.
* **Kapan Pakai Cara Ini?**  
  Saat Anda sedang fokus memperbaiki/mengembangkan fitur Report atau Settlement. Anda tidak mau buang-buang waktu harus klik Login -> pilih perusahaan -> klik menu setiap kali menjalankan tes.
* **Kelebihan:** Sangat cepat dan langsung ke sasaran yang ingin dites.

### PILIHAN 2: Mulai dari Halaman Login (Uji Coba Alur Penuh / End-to-End)
* **Alurnya:** Login ➔ Pilih Perusahaan ➔ Dashboard ➔ Klik Menu Settlement ➔ Buka Report.
* **Kapan Pakai Cara Ini?**  
  Saat Anda ingin membuat Laporan Pengujian Menyeluruh (Laporan Resmi QA) sebelum aplikasi dirilis ke user, membuktikan seluruh rantai perjalanan user tidak ada yang macet.
* **Kelebihan:** Meniru 100% pengalaman nyata pengguna dari awal membuka aplikasi.

---

## 14. 👥 PENANGANAN MULTI-ROLE (ADMIN, FINANCE, USER) DENGAN FILE AUTH TERPISAH

**Pertanyaan:**  
*"ohh berarti kalo seadinaya saya blm login ini yah dan melkaukan testing di reportg itu bsia bisa ajah gitu ya tetpai disini kan banay role ya? nanti loginnya dai pakai kaun apa? dan apakah dia lnagusng bisa gitu atau gimana?"*

**Jawaban:**  

### 1. Kalau Belum Login Sama Sekali, Apakah Bisa Langsung Loncat ke Report?
👉 **TIDAK BISA!**  
Sistem aplikasi Anda memiliki keamanan autentikasi. Kalau ada yang mencoba langsung membuka halaman Report tanpa login, sistem Backend Flask Anda akan memblokir dan mengarahkan kembali ke halaman Login. Jadi tetap harus ada sesi login yang valid.

### 2. Akun Apa yang Dipakai Jika Banyak Role?
👉 **ANDALAH YANG MENENTUKAN akun mana yang ingin dites!**  
Playwright tidak menebak-nebak password Anda. Akun yang dipakai adalah akun yang Anda ketikkan saat merekam.

### Solusi Multi-Role: Simpan File Kunci Berbeda untuk Setiap Role:
* 🔑 `auth_admin.json` = Simpan sesi saat Anda login sebagai **Super Admin**.
* 🔑 `auth_finance.json` = Simpan sesi saat Anda login sebagai **Staff Finance**.
* 🔑 `auth_user.json` = Simpan sesi saat Anda login sebagai **Pegawai Biasa**.

### Cara Mengujinya Sangat Cepat:
* **Mau tes menu laporan keuangan sebagai Finance?**
  ```bash
  npx playwright codegen --load-storage=auth_finance.json http://localhost:60360
  ```
  ➔ Browser langsung terbuka sebagai Finance!
* **Mau tes apakah Pegawai Biasa bisa menghapus data (uji celah keamanan)?**
  ```bash
  npx playwright codegen --load-storage=auth_user.json http://localhost:60360
  ```
  ➔ Browser terbuka sebagai Pegawai, dan Anda bisa memastikan apakah sistem berhasil menolak aksesnya!

> **Analogi:**  
> Playwright itu seperti *"Satpam Robot"*.  
> File `auth.json` itu seperti *"Kartu Akses / ID Card"*.  
> Kartu ID Card mana yang Anda pasangkan ke robot (Admin atau Finance), maka seperti itulah robot tersebut akan masuk dan melihat aplikasi Anda!

---

## 15. 🧭 KENAPA DI FLUTTER WEB TIDAK BISA LANGSUNG MENGETIK URL REPORT?

**Pertanyaan:**  
*"gak mkd saya tuh kalo saya mau melakuakn testing report apakah bisa mulai dari halman report atau harus dari login aatau dari dashboard?"*

**Jawaban:**  
Di aplikasi Flutter Anda ini, jawabannya adalah:  
👉 **HARUS DIMULAI DARI LOGIN ATAU DASHBOARD DULU!**

Ada 2 alasan teknis yang pasti pada aplikasi Anda:

### 1. Aplikasi Anda adalah Single Page Application (SPA)
* Aplikasi Flutter Web Anda bekerja di 1 alamat URL saja, yaitu `http://localhost:60360/`.
* Anda tidak bisa mengetik langsung `http://localhost:60360/report` di address bar browser, karena Flutter secara bawaan merender tampilan berdasarkan state widget di dalam memori, bukan sistem tautan halaman HTML konvensional.
* Semua menu (Dashboard, Settlement, Report) berada di dalam satu aplikasi utuh yang baru bisa terbuka setelah Anda login.

### 2. Halaman Report Membutuhkan Data "Pilih Perusahaan"
Di aplikasi Anda, alurnya membutuhkan urutan data yang saling terkait:
1. **Login:** Mendapatkan token izin akses JWT.
2. **Pilih Perusahaan:** Memilih apakah mau mengelola *EWI Foundation* atau *Expans Wireless Indo*.
3. **Dashboard:** Memuat data transaksi perusahaan terpilih.
4. **Halaman Report:** Menampilkan laporan keuangan berdasarkan perusahaan yang dipilih tadi.

Jika langsung melompat ke halaman Report tanpa melewati Login dan Pilih Perusahaan, sistem akan bingung: *"Ini mau menampilkan laporan untuk perusahaan yang mana?"*

### 🚀 Cara Terbaik Melakukan Testing Report:
Saat Anda merekam (Menu 31):
1. Masukkan URL: `http://localhost:60360/`
2. Lakukan alurnya secara wajar sekali saja:
   * Ketik Username & Password ➔ Klik Masuk
   * Klik Pilih Perusahaan (misal: EWI Foundation)
   * Di Dashboard, klik menu Report / Laporan
   * Lakukan pengujian di halaman Report tersebut (misal filter tahun 2024, cek angka, dll).
3. Selesai! Tutup browsernya.

**Hasilnya:**  
Skrip pengujian report Anda tersimpan utuh. Nanti saat robot Playwright disuruh mengetes report lagi (di Menu 34 atau 35), robot akan melewati proses login dan pilih perusahaan itu secepat kilat (hanya dalam 1–2 detik) lalu langsung menguji halaman Report untuk Anda!

---

## 16. 🛡️ KEAMANAN TESTING MELOMPATI LOGIN LANGSUNG KE DASHBOARD

**Pertanyaan:**  
*"seadnay sudha lgin dna saya sudha inget gitu tetpai testing dari login apakah aman aman ajh gitu kaya longkapin ke dashboarrd gitu?"*

**Jawaban:**  
**SANGAT AMAN! 100% Aman dan Tidak Ada Masalah Sama Sekali!**

### 1. Apa yang Terjadi Kalau Anda Sudah Centang "Ingat Saya"?
Di aplikasi Flutter Anda, saat Anda mencentang "Ingat Saya", token login disimpan di memori browser (`localStorage`).  
Sehingga saat halaman `http://localhost:60360/` dibuka kembali:
* Aplikasi Anda secara otomatis memeriksa: *"Oh, orang ini kemarin sudah login dan pilih 'Ingat Saya'."*
* Layar Login otomatis dilewati (*di-skip*), dan aplikasi langsung menampilkan Pilih Perusahaan / Dashboard!

### 2. "Apakah Aman Kalau Testing Mulai dari Login atau Melompat ke Dashboard?"
Kedua-duanya **SANGAT AMAN**:
* **Jika Melompat Langsung ke Dashboard (Karena 'Ingat Saya'):**  
  Sangat Aman! Karena token login Anda yang sah tetap dikirimkan ke backend Flask. Backend tetap mengizinkan Anda melihat data transaksi dan report dengan aman. Anda tidak perlu mengetik username dan password lagi, jadi proses pengetesan berjalan jauh lebih cepat!
* **Jika Testing Mulai dari Form Login Lagi:**  
  Juga Sangat Aman! Karena proses login itu hanya mencocokkan kata sandi (*bersifat read-only*). Dia tidak mengubah, menambah, atau menghapus data kasbon/settlement apa pun di database Anda.

**Kesimpulan:**  
Mau dia otomatis melompat langsung ke Dashboard, atau mau dia mulai mengetik login lagi dari awal, keduanya 100% aman dan tidak akan merusak database atau sistem Anda sama sekali!

---

## 17. ⚡ PANDUAN PRAKTIS 1 MENIT: REKAM & UJI LANGSUNG DARI DASHBOARD

**Pertanyaan:**  
*"Layar Login otomatis dilewati (di-skip), dan aplikasi langsung menampilkan Pilih Perusahaan / Dashboard! berarti dai bsia skip gitu yah langsung ke dashboard ya? jadi saya rekamn dari testing dan melkauakn testing dari rekaman itu dari dashborad bisa gitu ya?"*

**Jawaban:**  
**BISA BANGET! TEPAT SEKALI! 🎯**

Anda **BISA** mulai merekam dari Dashboard, dan **BISA** menjalankan pengujian berulang kali langsung dari Dashboard tanpa melihat halaman login lagi!

### Trik Kunci Agar Playwright Bisa Melakukan Ini:
Secara default, browser Playwright itu seperti orang baru yang baru pertama kali menyalakan laptop, jadi dia belum tahu kalau Anda sudah pernah login.  
Agar Playwright bisa otomatis loncat langsung ke Dashboard, Anda cukup memberinya **Kunci Akses (`auth.json`)**:

### Cara Praktisnya (Cuma Butuh 1 Menit):

#### Langkah 1: Sekali Saja Simpan Kuncinya
Buka terminal dan jalankan:
```bash
npx playwright codegen --save-storage=auth.json http://localhost:60360
```
* Browser terbuka ➔ Centang "Ingat Saya" ➔ Ketik user & password ➔ Klik Masuk ➔ Pilih Perusahaan ➔ Masuk Dashboard.
* Tutup browsernya. Kuncinya sudah tersimpan di file `auth.json`.

#### Langkah 2: Sekarang Anda Bebas Rekam & Tes Mulai dari Dashboard!
Kapan pun Anda mau merekam fitur apa pun (Settlement, Report, Import Database), jalankan perintah ini:
```bash
npx playwright codegen --load-storage=auth.json http://localhost:60360
```

**HASILNYA:**
* Halaman Login **100% DILEWATI (DI-SKIP)!**
* Browser Playwright **LANGSUNG TERBUKA DI DASHBOARD!**
* Anda tinggal mulai merekam dari Dashboard ke halaman Report atau Settlement sesuka hati Anda!
* Nanti saat skrip tes dijalankan, robot Playwright juga akan langsung mulai dari Dashboard tanpa perlu login berulang-ulang!

---

*Dokumentasi ini disinkronisasikan otomatis dengan menu AI Tools `[39]` pada `runaitool.bat`.*
