# ROADMAP PENGGUNAAN & PANDUAN DETAIL MENU PLAYWRIGHT (OPSI 30–38)

> **Dokumentasi Praktis Operasional AI Tools Control Center**  
> **Lokasi File:** `docs/aitool/Roadmap_dan_Panduan_Menu_Playwright.md` & `D:\Aplikasi\aitool\docs\`  
> **Target:** Panduan langkah demi langkah saat menekan menu, ekspektasi output, dan perbedaan fungsional.

---

## 1. 🗺️ ROADMAP ALUR KERJA (DARI NOL SAMPAI MAHIR)

Jika Anda baru pertama kali menggunakan Playwright atau ingin mengotomasi tugas web, ikuti peta jalan (roadmap) 6 langkah berikut:

```
┌────────────────────────────────────────────────────────────────────────┐
│  [LANGKAH 1] Tekan 30  ──> Download Browser Driver (1x saat setup)     │
│       │                                                                │
│  [LANGKAH 2] Tekan 33  ──> Cek Buka Browser (Pastikan Chromium lancar) │
│       │                                                                │
│  [LANGKAH 3] Tekan 31  ──> Rekam Aksi Tangan Jadi Kode (CodeGen)       │
│       │                                                                │
│  [LANGKAH 4] Tekan 32  ──> Ambil Screenshot Arsip Tampilan Web         │
│       │                                                                │
│  [LANGKAH 5] Tekan 35  ──> Uji Coba UI Mode (Time-Travel Debugger)     │
│       │                                                                │
│  [LANGKAH 6] Tekan 37  ──> Hadapi Web Ber-Cloudflare/Captcha (Stealth) │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 2. 🔍 BEDAH DETAIL MENU 30–38: APA YANG TERJADI SAAT DITEKAN?

---

### [30] Download / Install Browser Driver (`playwright install`)
* **Tujuan:** Menyiapkan mesin browser resmi yang dibutuhkan Playwright.
* **Kapan Dipakai?** Pertama kali saat komputer belum memiliki browser Playwright, atau saat ada pembaruan versi.
* **Alur Saat Ditekan:**
  1. Terminal akan langsung mendownload file biner Chromium (~150MB), Firefox (~80MB), dan WebKit (~70MB).
  2. File disimpan di folder sistem Windows: `%USERPROFILE%\AppData\Local\ms-playwright`.
* **Input yang Diminta:** Tidak ada (otomatis).
* **Hasil / Output:** Lingkungan Playwright di komputer Anda siap 100%.

---

### [31] Rekam Aksi Otomatis / CodeGen (`playwright codegen`)
* **Tujuan:** Membuat skrip otomasi pengujian **tanpa perlu menulis kode manual**.
* **Kapan Dipakai?** Saat Anda ingin membuat alur otomasi login, pengisian form, atau navigasi web secara instan.
* **Alur Saat Ditekan:**
  1. Terminal meminta: `Masukkan URL target (default: http://localhost:3000):`
  2. Tekan Enter, maka akan muncul **2 jendela secara berdampingan**:
     * **Jendela Kiri:** Browser Google Chrome / Chromium.
     * **Jendela Kanan:** Jendela *"Playwright Inspector"* (perekam kode).
  3. Lakukan interaksi di browser kiri:
     * Mengklik tombol Login -> Jendela kanan otomatis mencatat: `page.click('button#login')`.
     * Mengetik email/password -> Jendela kanan mencatat: `page.fill('input#email', 'dio@gmail.com')`.
     * Mengisi formulir, berpindah halaman -> Semua terekam *real-time*.
* **Input yang Diminta:** URL halaman yang ingin dikunjungi.
* **Hasil / Output:** Tombol **"Copy"** di jendela kanan untuk menyalin skrip rekaman menjadi file script pengujian (`.js` atau `.py`).

---

### [32] Ambil Screenshot Website Biasa (`playwright screenshot`)
* **Tujuan:** Mengambil tangkapan layar halaman web secara cepat via CLI tanpa ekstensi browser.
* **Kapan Dipakai?** Untuk mendokumentasikan tampilan antarmuka web lokal (misal Flutter Web di `localhost:5000`) atau web publik.
* **Alur Saat Ditekan:**
  1. Terminal meminta: `Masukkan URL:` (misal: `http://localhost:5000`).
  2. Terminal meminta: `Nama file gambar:` (default: `screenshot.png`).
  3. Terminal meminta: `Screenshot satu halaman penuh (full-page)? (y/n):`
     * **y:** Memotret seluruh halaman dari header paling atas sampai footer paling bawah (*full scroll*).
     * **n:** Hanya memotret apa yang tampak di layar monitor (*viewport*).
  4. Browser bekerja sekejap di latar belakang (mode headless), lalu otomatis menutup.
* **Hasil / Output:** File gambar `.png` berkualitas tinggi tersimpan langsung di folder project aktif Anda.

---

### [33] Buka Browser Uji Coba Cepat (`playwright open`)
* **Tujuan:** Membuka browser Playwright standar untuk memverifikasi apakah URL target dapat diakses.
* **Kapan Dipakai?** Untuk pengecekan awal konektivitas dan tampilan dasar website.
* **Alur Saat Ditekan:**
  1. Terminal meminta: `Masukkan URL yang ingin dibuka:` (default: `https://google.com`).
  2. Jendela browser Chromium Playwright akan langsung terbuka ke halaman tersebut.
* **Hasil / Output:** Browser terbuka secara interaktif di layar monitor Anda.

---

### [34] Jalankan Tes Playwright di Terminal (`playwright test`)
* **Tujuan:** Menjalankan seluruh skrip pengujian unit/E2E yang ada di project secara serempak.
* **Kapan Dipakai?** Sebelum rilis aplikasi atau setelah update kode besar untuk memastikan tidak ada fitur yang rusak (*regression testing*).
* **Alur Saat Ditekan:**
  * Playwright mengeksekusi semua file tes di latar belakang (*headless mode*).
  * Di terminal muncul status *progress bar* dan indikator:
    * `✓` hijau untuk tes yang berhasil.
    * `✕` merah untuk tes yang gagal / ada tombol yang tidak merespons.
* **Hasil / Output:** Ringkasan status akhir di console terminal (contoh: *18 passed, 0 failed*).

---

### [35] Jalankan Tes Mode Interaktif Modern (`playwright test --ui`)
* **Tujuan:** Antarmuka pengujian visual paling canggih dengan fitur **Time-Travel Debugger**.
* **Kapan Dipakai?** Saat sebuah tes gagal dan Anda ingin melihat rekaman visual persis di detik mana kegagalan itu terjadi.
* **Alur Saat Ditekan:**
  * Membuka aplikasi desktop Playwright UI di layar monitor.
  * Menampilkan daftar skrip tes, pohon DOM elemen web, dan panel jaringan (*network call*).
  * **Fitur Time-Travel:** Anda bisa menggeser garis waktu (*timeline*) maju-mundur untuk melihat kondisi visual halaman sebelum tombol diklik, saat tombol diklik, dan setelah halaman berganti.
* **Hasil / Output:** Investigasi visual tanpa perlu menebak-nebak penyebab error.

---

### [36] Buka Laporan Hasil Tes Terakhir (`playwright show-report`)
* **Tujuan:** Membuka dashboard HTML resmi hasil pengujian dari Menu 34.
* **Kapan Dipakai?** Untuk melihat laporan visual rapi yang bisa diekspor atau ditunjukkan ke tim.
* **Alur Saat Ditekan:**
  * Playwright menjalankan server lokal kecil dan otomatis membuka tab baru di browser default Anda.
  * Menampilkan grafik persentase sukses, durasi eksekusi tiap langkah, cuplikan video tes, dan log error.
* **Hasil / Output:** Dashboard web interaktif di `localhost:9323`.

---

### [37] [STEALTH] Buka Browser Penyamaran Anti-Bot
* **Tujuan:** Menembus website yang memiliki proteksi ketat (Cloudflare, reCAPTCHA, atau anti-scraper).
* **Kapan Dipakai?** Saat Anda membuka web di Menu 33 dan terkena blokir *"Checking if you are human"* atau halaman blank 403 Forbidden.
* **Alur Saat Ditekan:**
  1. Terminal meminta: `Masukkan URL target (default: https://bot.sannysoft.com):`
  2. Mesin Chromium terbuka dengan **penyamaran penuh**:
     * Variabel robot `navigator.webdriver` dinonaktifkan (diubah jadi `undefined`).
     * Daftar plugin, hardware concurrency, dan WebGL disamarkan menyerupai laptop manusia asli.
  3. Anda dapat berinteraksi, login, atau menyelesaikan transaksi dengan aman tanpa dicurigai sebagai skrip otomasi.
* **Hasil / Output:** Jendela browser penyamaran aktif dan aman dari blokir bot.

---

### [38] [STEALTH] Ambil Screenshot Halaman Berproteksi
* **Tujuan:** Mengambil gambar website yang menolak atau memblokir bot screenshot biasa.
* **Kapan Dipakai?** Saat website target menerapkan proteksi anti-crawler/bot sehingga Menu 32 hanya menghasilkan gambar kosong atau gambar halaman Captcha.
* **Alur Saat Ditekan:**
  1. Terminal meminta URL target dan nama file output gambar.
  2. Playwright Stealth membuka halaman di background, meniru handshake browser manusia asli sampai seluruh elemen ter-render sempurna.
  3. Memotret seluruh halaman (*full-page*).
* **Hasil / Output:** File gambar `.png` tersimpan mulus tanpa terhalang proteksi Cloudflare.

---

## 3. ⚖️ TABEL PERBANDINGAN FITUR: APA BEDANYA?

| Kategori | Opsi Standar / Biasa | Opsi Canggih / Stealth | Perbedaan Mendasar |
| :--- | :--- | :--- | :--- |
| **Buka Browser** | **Menu [33]** (`open`) | **Menu [37]** (`[STEALTH]`) | Menu 33 terdeteksi robot oleh Cloudflare; **Menu 37 100% lolos verifikasi anti-bot**. |
| **Screenshot** | **Menu [32]** (Biasa) | **Menu [38]** (`[STEALTH]`) | Menu 32 bisa terblokir halaman 403; **Menu 38 menembus proteksi dan menangkap gambar asli**. |
| **Eksekusi Tes** | **Menu [34]** (Terminal) | **Menu [35]** (UI Mode) | Menu 34 hanya teks terminal; **Menu 35 memiliki visual time-travel rekaman layar**. |
| **Pembuatan Skrip** | Menulis kode manual | **Menu [31]** (CodeGen) | Menu 31 **merekam klik mouse Anda** menjadi kode otomatis tanpa perlu mengetik manual. |

---

## 4. 💡 KESIMPULAN RINGKAS

* **Untuk Mengetes Aplikasi Sendiri (Flutter Web / Lokal):** Gunakan **31 (CodeGen)** untuk membuat alur, lalu **35 (UI Mode)** untuk melihat jalannya pengetesan.
* **Untuk Mengambil Gambar / Scraping:** Gunakan **32** untuk web biasa, atau **38** untuk web yang memiliki proteksi ketat.
* **Untuk Mengatasi Captcha / Blokir:** Selalu gunakan **37 (Stealth Browser)**.
