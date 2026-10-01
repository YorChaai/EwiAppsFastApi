Tentu! Berikut adalah versi **baru dan lebih sempurna** dari Prompt Template Reorganize Project Structure, yang sudah menggabungkan semua masukan peningkatan tadi.

---

# 🌟 Prompt Template: Reorganize Project Structure (Universal & Aman)

Template ini bisa langsung kamu salin-tempel untuk merapikan struktur proyek apa pun—Python, Node.js, PHP, Flutter atau lainnya—dengan aman tanpa kehilangan satu file pun.

---

## 📝 PROMPT TEMPLATE

````
Saya ingin merapikan proyek ini. Ikuti instruksi lengkap di bawah.

## 🎯 TUJUAN AKHIR
- Root folder hanya berisi file konfigurasi penting dan launcher utama.
- Semua kode sumber, skrip, dokumen, dan alat bantu rapi dalam subfolder.
- Tidak ada error, semua path dan import berfungsi.
- **Tidak ada satu file pun yang dihapus.** Semua file yang “tidak terpakai” tetap disimpan di folder backup `_backup_/`.

---

## ⚠️ PERSIAPAN (WAJIB SEBELUM MULAI)
1. **Backup proyek** (zip atau copy ke tempat lain).
   Jika pakai Git, buat branch baru:
   `git checkout -b refactor/struktur` dan commit kondisi terakhir (`git add -A && git commit -m "backup sebelum reorganisasi"`).
2. Catat daftar dependensi/build yang sudah ada (misal `package.json`, `requirements.txt`) agar bisa dicek ulang nanti.

---

## 📋 LANGKAH DEMI LANGKAH

### 🔍 STEP 1: PEMETAAN PROYEK MENYELURUH
- Tampilkan struktur folder & file **dari root hingga kedalaman 2-3 level** (abaikan `.git`, `node_modules`, `venv`, dll).
- Kategorikan setiap file:
  - **Core source code** (script utama, library, modul, komponen)
  - **Launcher / entry-point** (bash, batch, PS1, command)
  - **Dokumentasi** (.md, .txt, .pdf, laporan)
  - **File konfigurasi** (.env, .json, .yaml, .toml)
  - **Asset / data** (gambar, audio, CSV, dll)
  - **Temporary / debug** (log, cache, testing sementara)
  - **Tools / helper scripts** (migrasi, analisis, utilitas)
  - **Lainnya / tidak jelas** → kandidat backup
- Tentukan **file mana yang WAJIB tetap di root** (misal: `.gitignore`, `README.md`, `package.json`, `docker-compose.yml`, file CI/CD). Jangan pindahkan file-file ini kecuali benar-benar yakin.

---

### 📁 STEP 2: RANCANG STRUKTUR BARU
Buat folder baru berikut **sesuai jenis proyek**:

| Folder         | Isi                                                                 |
|----------------|----------------------------------------------------------------------|
| `src/`         | Semua kode sumber utama (module, class, fungsi)                      |
| `scripts/`     | Skrip peluncur, build, deploy, cron                                 |
| `docs/`        | Dokumentasi, panduan, laporan                                       |
| `tools/`       | Skrip migrasi, analisis, converter, dll.                            |
| `temp/`        | File sementara, debug, cache (bisa dimasukkan .gitignore)           |
| `_backup_/`    | **Folder aman** untuk semua file yang dipindahkan dari root tapi tidak jelas masuk ke mana. **Tidak boleh dihapus.** |
| `output/` / `dist/` / `build/` | Output build, hasil compile (sesuaikan)                      |

**Catatan**: Jika folder sudah ada, gunakan nama lain seperti `_temp_debug/` atau gabungkan isinya dengan hati-hati.

---

### 🚚 STEP 3: PINDAHKAN FILE (TANPA MENGHAPUS)
- Pindahkan file sesuai kategorinya ke folder baru.
- **Jangan hapus!** Gunakan perintah pindah (move) atau copy lalu verifikasi dulu.
- File yang tidak masuk kategori jelas → masukkan ke `_backup_/`.
- Setelah semua dipindah, **jumlah file total harus sama** seperti sebelum reorganisasi (bisa dicek dengan `find . -type f | wc -l` atau sejenisnya).

---

### 🔗 STEP 4: PERBAIKI PATH & IMPORT (LANGKAH KRITIS)
**A. Tentukan file konfigurasi root path tunggal**
Buat satu file (misal `src/config.js`, `src/settings.py`, `src/paths.ts`) yang mendefinisikan **ROOT_DIR** secara dinamis. Contoh:

*Python*
```python
from pathlib import Path
ROOT_DIR = Path(__file__).parent.parent   # naik satu level dari src/
````

_Node.js_

```js
const path = require("path");
const ROOT_DIR = path.resolve(__dirname, "..");
```

**B. Ganti semua path hardcoded**
Cari seluruh kode (grep/regex) yang mengandung:

- `"../` atau `"./` yang mengarah ke aset/data
- `open('data.csv')` tanpa prefix root
- `load_dotenv()` tanpa path absolut
- Referensi ke folder seperti `audio/`, `output/`, dll.

Ganti dengan `ROOT_DIR + '/data.csv'`, `ROOT_DIR + '/.env'`, dsb. **Gunakan ROOT_DIR dari file config terpusat**, jangan hitung manual `parent.parent.parent`.

**C. Perbarui skrip launcher di `scripts/`**

- Ganti path ke entry-point (misal: `python ../src/main.py`, `node ../src/index.js`).
- Pastikan working directory tetap sesuai (gunakan `cd` atau absolut path).

**D. Buat file launcher singkat di root (opsional)**
Buat `run.bat` / `run.sh` yang hanya berisi navigasi ke `src/` dan menjalankan aplikasi. Ini memudahkan pengguna menjalankan tanpa masuk ke dalam folder.

Contoh `run.bat`:

```bat
@echo off
cd /d "%~dp0src"
python main.py
pause
```

---

### 🧪 STEP 5: UJI COBA & DETEKSI ERROR

- Jalankan aplikasi utama, cek semua fitur dasar.
- Jika proyek punya test suite (unit test, e2e), **jalankan semua** dan pastikan lulus.
- Cek manual:
  - Pembacaan file konfigurasi (`.env`, `settings.json`)
  - Akses ke folder asset/data
  - Log error (pastikan tidak ada path error)
- Jika ada error, periksa kembali path di kode. Jangan lanjut sebelum semua bersih.

---

### ✅ STEP 6: VERIFIKASI AKHIR & RAPIKAN

- Hitung jumlah file sebelum dan sesudah → harus sama (tidak ada yang hilang).
- Pastikan folder `_backup_/` berisi file-file yang dipindahkan dari root (bukan hasil generate baru).
- Update dokumentasi: tulis struktur folder baru di `docs/` atau `README.md`, jelaskan alasan perubahan, dan cara menjalankan ulang proyek.

---

## 📦 OUTPUT YANG DIHARAPKAN

- Root hanya berisi file penting (misal: `.gitignore`, `package.json`, `README.md`, `.env`, `docker-compose.yml`, `run.bat/sh`).
- Semua kode sumber di `src/`, skrip di `scripts/`, dokumen di `docs/`.
- Tidak ada error saat menjalankan, test, atau build.
- Backup lengkap di `_backup_/` (bisa dihapus manual nanti jika sudah yakin).
- Dokumentasi terbaru tentang struktur dan cara menjalankan.

---

## ❗ ATURAN BESI

- **JANGAN PERNAH HAPUS FILE.** Jika ragu, backup dulu.
- **Uji setiap langkah**, terutama setelah pemindahan massal.
- **Gunakan ROOT_DIR tunggal** agar tidak ada path rusak di sub-direktori.
- **Selalu verifikasi dengan test suite** jika tersedia.

```

---

## 🧩 CONTOH PENGGUNAAN

### Python + FastAPI
```

Project: backend-fastapi
Root sebelumnya: main.py, database.py, .env, start.sh, README.md, tests/
Setelah reorganisasi:

- src/main.py, src/database.py, src/config.py (ROOT_DIR)
- scripts/start.sh (berisi: cd src && uvicorn main:app)
- .env, README.md, requirements.txt tetap di root
- tests/ tetap (jika sudah ada folder sendiri)

```

### Node.js + Express
```

Root sebelum: index.js, routes/, .env, start.cmd
Setelah:

- src/index.js, src/routes/
- scripts/start.cmd (node ../src/index.js)
- Buat src/config.js: const ROOT_DIR = path.resolve(\_\_dirname, '..');

```

---

## ✅ CHECKLIST SETELAH REORGANISASI
- [ ] Folder root rapi (hanya file konfigurasi/launcher)
- [ ] Semua kode sumber ada di `src/`
- [ ] Launcher & skrip di `scripts/`
- [ ] Dokumentasi di `docs/`
- [ ] Backup lama di `_backup_/` (tidak ada file yang hilang)
- [ ] ROOT_DIR / base path didefinisikan terpusat dan digunakan di seluruh kode
- [ ] Import/path beres, tidak ada error `module not found` atau file tidak ditemukan
- [ ] `.env` atau file konfigurasi lain termuat dengan benar
- [ ] Aplikasi berjalan normal (uji fitur utama)
- [ ] Test suite lulus (jika ada)
- [ ] README / dokumentasi diperbarui

---

**Template Version:** 2.0 (universal, aman, dengan penanganan path dinamis)
**Dibuat untuk:** Semua jenis proyek (Python, Node.js, PHP, Go, dll.)

---

Silakan langsung dipakai, dan sesuaikan detail folder dengan kebutuhan proyek kamu. Kalau ada yang ingin ditambahkan lagi, beri tahu saya.
```
