# PANDUAN LENGKAP PLAYWRIGHT: DARI DASAR HINGGA MODE STEALTH

> **Dokumentasi Resmi AI Tools Control Center**  
> **Lokasi File:** `docs/aitool/Panduan_Lengkap_Playwright.md` & `D:\Aplikasi\aitool\docs\`  
> **Target:** Panduan Komprehensif Automasi Browser, Pengujian, Scraping, dan Penyamaran Anti-Bot.

---

## 1. PENDAHULUAN: APA ITU PLAYWRIGHT?

**Playwright** adalah framework otomasi browser modern open-source yang dikembangkan oleh **Microsoft**. 

Secara konvensional, Playwright sering dikenal sebagai alat *End-to-End (E2E) Testing*. Namun, secara arsitektur, Playwright sebenarnya adalah **"Mesin Pengendali Browser Lengkap (Universal Browser Automation Engine)"**.

Apa pun yang bisa dilakukan manusia di browser Google Chrome, Microsoft Edge, Firefox, maupun Safari (WebKit), **bisa diotomasi dan diprogram menggunakan Playwright**.

### Arsitektur Inti Playwright:
```
┌────────────────────────────────────────────────────────┐
│               SKRIP ANDA / AI AGENT                    │
│        (Python, Node.js, atau CLI Menu AI Tools)       │
└──────────────────────────┬─────────────────────────────┘
                           │ Chrome DevTools Protocol (CDP) / WebSocket
                           ▼
┌────────────────────────────────────────────────────────┐
│                   BROWSER SERVER                       │
│    ┌──────────────┐  ┌──────────────┐  ┌──────────────┐│
│    │   Chromium   │  │   Firefox    │  │    WebKit    ││
│    │(Chrome, Edge)│  │              │  │   (Safari)   ││
│    └──────┬───────┘  └──────────────┘  └──────────────┘│
└───────────┼────────────────────────────────────────────┘
            ▼
┌────────────────────────────────────────────────────────┐
│               BROWSER CONTEXT (ISOLASI SESI)           │
│   ┌────────────────────────────────────────────────┐   │
│   │ Cookies, Cache, LocalStorage Mandiri           │   │
│   │   ┌──────────────┐      ┌──────────────┐       │   │
│   │   │    Page 1    │      │    Page 2    │       │   │
│   │   │  (Tab Web A) │      │  (Tab Web B) │       │   │
│   │   └──────────────┘      └──────────────┘       │   │
│   └────────────────────────────────────────────────┘   │
└────────────────────────────────────────────────────────┘
```

---

## 2. FITUR UNGGULAN: MENGAPA LEBIH BAIK DARI SELENIUM?

1. **Auto-Waiting Cerdas (Tidak Perlu `sleep()` Kaku)**:
   * Pada alat lama seperti Selenium, programmer sering menulis `time.sleep(5)` untuk menunggu tombol muncul. Jika internet lambat, script gagal (*crash*).
   * Playwright **secara otomatis menunggu** elemen web selesai dimuat, terlihat di layar (*visible*), tidak tertutup elemen lain, dan siap diklik sebelum mengeksekusi aksi.
2. **Dukungan Multi-Tab dan Multi-User Sekaligus**:
   * Melalui konsep `BrowserContext`, Anda bisa membuka 2 sesi yang terisolasi total dalam 1 browser (misalnya: Tab 1 login sebagai Admin, Tab 2 login sebagai User biasa tanpa saling bentrok cookies).
3. **Headless & Headful Mode**:
   * **Headful:** Jendela browser muncul di layar (bagus untuk melihat langsung proses kerja).
   * **Headless:** Browser berjalan tanpa antarmuka visual di latar belakang (sangat cepat, hemat RAM, dan ideal untuk server/background task).
4. **Network Interception**:
   * Mampu mencegat, memodifikasi, atau memantau request API dan response data yang lewat di jaringan browser.

---

## 3. PANDUAN FITUR PLAYWRIGHT DI AI TOOLS CONTROL CENTER

Di dalam menu AI Tools (`runaitool.bat` atau `app.py`), tersedia rangkaian opsi siap pakai:

| Nomor Menu | Nama Fitur | Kegunaan Praktis |
| :--- | :--- | :--- |
| **[30]** | `playwright install` | Mengunduh browser binaries resmi (Chromium, Firefox, WebKit) ke sistem. |
| **[31]** | `CodeGen (Perekam Aksi)` | Merekam klik dan ketikan tangan Anda di browser menjadi kode otomatis. |
| **[32]** | `Screenshot Website` | Mengambil screenshot tampilan web (mendukung mode *Full-Page*). |
| **[33]** | `Playwright Open` | Membuka jendela browser pengujian cepat ke URL target. |
| **[34]** | `Playwright Test (Terminal)` | Menjalankan seluruh skrip pengujian otomatis di console. |
| **[35]** | `Playwright UI Mode` | Menjalankan runner interaktif dengan fitur *Time-Travel Debugger*. |
| **[36]** | `Playwright Show-Report` | Membuka laporan visual hasil tes dalam format dashboard HTML. |
| **[37]** | `[STEALTH] Browser Penyamaran` | **Membuka browser anti-deteksi bot (Bypass Cloudflare / Captcha)**. |
| **[38]** | `[STEALTH] Screenshot Anti-Bot` | Mengambil gambar halaman web yang memblokir bot biasa. |

---

## 4. BEDAH MENDALAM: CODEGEN & UI MODE

### A. CodeGen: Rekam Gerakan Menjadi Kode (Menu 31)
* **Apa itu?** Fitur di mana Anda berselancar seperti biasa, dan Playwright akan mencatat setiap langkah Anda dalam bentuk script kode (Python / JavaScript).
* **Cara Pakai:**
  1. Pilih Menu **31**.
  2. Masukkan URL (misal: `http://localhost:5000` atau website lain).
  3. Browser akan terbuka berdampingan dengan jendela *"Playwright Inspector"*.
  4. Klik tombol, ketik form login, scroll halaman.
  5. Seluruh kode yang dihasilkan bisa langsung Anda copy-paste untuk diulang kapan saja!

### B. UI Mode: Time-Travel Debugger (Menu 35)
* **Apa itu?** Antarmuka visual paling canggih untuk menguji aplikasi web.
* **Fitur Utama:**
  * **Time-Travel:** Anda bisa menggeser slider waktu ke belakang untuk melihat kondisi layar sebelum tombol diklik, saat tombol diklik, dan setelah halaman berganti.
  * **DOM Snapshot:** Melihat isi kode HTML pada setiap milidetik pengujian.
  * **Network Tab:** Melihat API apa saja yang dipanggil saat tombol diklik.

---

## 5. BEDAH MENDALAM: MODE STEALTH (PENYAMARAN ANTI-BOT)

### Mengapa Website Tahu Bahwa Itu Bot?
Saat browser dibuka secara otomatis, browser menyematkan variabel rahasia:
```javascript
// Browser normal manusia:
navigator.webdriver === undefined (atau false)

// Browser otomatis biasa (Playwright standar):
navigator.webdriver === true  <-- INI BENDERA PERINGATAN!
```
Sistem keamanan seperti **Cloudflare Turnstile**, **DataDome**, dan **Google reCAPTCHA** langsung mendeteksi variabel ini dan memunculkan blokir/Captcha.

### Bagaimana Mode Stealth Bekerja? (Menu 37 & 38)
Fitur Stealth yang telah dipasang di `D:\Aplikasi\aitool` menggunakan `playwright-stealth`:
1. **Menonaktifkan `navigator.webdriver`:** Menghapus bendera otomatisasi sehingga bernilai `undefined`.
2. **Memalsukan Ciri Khas Perangkat (*Fingerprinting*):**
   * Memberikan daftar plugin Chrome resmi (PDF Viewer, Chrome Native Client).
   * Memalsukan WebGL Vendor & Renderer (tampak seperti kartu grafis Intel/NVIDIA asli).
   * Menyamarkan User-Agent dan header `Sec-Ch-Ua` agar identik dengan Google Chrome reguler.
3. **Menguji Keberhasilan Penyamaran:**
   * Kunjungi: `https://bot.sannysoft.com`
   * Periksa baris `WebDriver (New)` dan `Chrome`: Semuanya akan berwarna **HIJAU (PASS)**, membuktikan penyamaran berhasil 100%.

---

## 6. STUDI KASUS PENGGUNAAN DI LUAR TESTING

Playwright sangat kuat digunakan untuk 4 kebutuhan nyata berikut:

### 1. Web Scraping Halaman Dinamis (Single Page Applications)
Situs modern (React, Vue, Flutter Web) memuat data melalui panggilan asynchronous (XHR/Fetch). Library scraping biasa (`requests`/`BeautifulSoup`) hanya melihat layar kosong. Playwright menunggu data dirender secara utuh sebelum mengambil teks atau tabelnya.

### 2. Otomasi Pekerjaan Kantor Berulang (Robotic Process Automation / RPA)
* Membaca ribuan baris data dari Excel.
* Mengisi form web kantor / portal internal secara otomatis.
* Mengunggah lampiran dokumen secara terjadwal setiap pagi.

### 3. Generate Dokumen PDF dari Halaman Web
Playwright bisa merender halaman web laporan dan mencetaknya ke file PDF beresolusi tinggi:
```python
page.pdf(path="laporan_kpi_2026.pdf", format="A4", print_background=True)
```

### 4. Tangan dan Mata bagi AI Agent
AI Agent (seperti Antigravity / LLM) tidak memiliki mata fisik. Playwright menjadi jembatan agar AI bisa menjelajahi web, menganalisis tampilan, dan melakukan tugas atas perintah manusia.

---

## 7. CHEAT SHEET CONTOH KODE PYTHON

Berikut contoh script Python jika Anda ingin membuat otomasi mandiri:

```python
from playwright.sync_api import sync_playwright
from playwright_stealth import Stealth

def run_automation():
    # Menggunakan mode Stealth agar tidak terdeteksi bot
    with Stealth().use_sync(sync_playwright()) as p:
        # Buka Chrome terlihat (headless=False)
        browser = p.chromium.launch(headless=False)
        context = browser.new_context(viewport={"width": 1280, "height": 720})
        page = context.new_page()

        # 1. Kunjungi halaman
        page.goto("https://contoh-website.com/login")

        # 2. Isi formulir
        page.fill("input[name='username']", "user_admin")
        page.fill("input[name='password']", "rahasia123")

        # 3. Klik tombol submit
        page.click("button[type='submit']")

        # 4. Tunggu halaman dashboard terbuka
        page.wait_for_url("**/dashboard")

        # 5. Ambil screenshot bukti
        page.screenshot(path="dashboard_sukses.png", full_page=True)
        print("Login berhasil dan screenshot tersimpan!")

        browser.close()

if __name__ == "__main__":
    run_automation()
```

---

## 8. KESIMPULAN

Playwright di ekosistem **AI Tools Control Center** dirancang bukan sekadar untuk mengecek error kode, melainkan sebagai **asisten otomasi serbaguna**. Dengan hadirnya **Mode Stealth**, batasan proteksi bot dan Cloudflare kini dapat dilewati dengan aman untuk keperluan pengujian maupun produktivitas kerja harian Anda.
