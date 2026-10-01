# Analisis Perbandingan Pendekatan Refactoring: Frontend (Dart) vs Backend (Python)

Pada proses pemangkasan file raksasa (refactoring), kita telah memecah `annual_report_screen.dart` (Frontend) dan `annual.py` (Backend). Walaupun tujuannya sama (memecah file 3000-6000 baris menjadi modular), pendekatan (metode) yang digunakan sangat **berbeda** karena ekosistem dan karakteristik bahasa pemrogramannya.

### 1. Metode Refactoring Backend (Python / FastAPI)
- **Metode yang Digunakan:** **Modular Imports & Local Injection**
- **Cara Kerja:** Di Python, kita memindahkan fungsi ke file baru (seperti `annual_data.py`, `annual_tables.py`, `annual_excel.py`) dan menggunakan perintah `from .annual_data import get_revenue` di file utama.
- **Tantangan Utama (Circular Import):** Python membaca file dari atas ke bawah. Jika `File A` mengimpor `File B`, dan `File B` mengimpor `File A`, aplikasi akan *crash* (Circular Import Error). 
- **Solusinya:** Menggunakan *Local Import* (memasukkan perintah import di dalam fungsi/metode, bukan di paling atas file) sehingga modul hanya dipanggil saat fungsi tersebut benar-benar dieksekusi.

### 2. Metode Refactoring Frontend (Dart / Flutter)
- **Metode yang Digunakan:** **Dart `part` dan `part of` (Library Splitting) & `extension`**
- **Cara Kerja:** Di Flutter, `annual_report_screen.dart` adalah sebuah `StatefulWidget` yang memiliki *State* `_AnnualReportScreenState`. Memindahkan fungsi UI (yang butuh `context` atau variabel *state* internal) ke file import biasa sangatlah sulit karena file baru tidak bisa mengakses variabel *private* (berawalan `_`) di file utama.
- **Solusinya:** Kita memecah satu *class* utuh ke dalam beberapa file menggunakan `part` dan `part of`. File `annual_report_widgets.dart`, `annual_report_tables.dart`, dan `annual_report_helpers.dart` dideklarasikan sebagai bagian dari (part of) `annual_report_screen.dart`.
- Selain itu, kita menggunakan **Dart Extension** (`extension AnnualReportWidgetsExt on _AnnualReportScreenState`) agar fungsi raksasa bisa menempel seakan-akan berada di dalam *class* aslinya, tanpa mengubah lingkup *state* (variabel privat tetap terbaca tanpa di-*passing* satu per satu).

### Kenapa Pendekatannya Berbeda?
Perbedaan ini murni lahir dari **arsitektur bahasanya**:
1. **Python** adalah bahasa *scripting* berbasis **Module**. Satu file adalah satu modul mandiri. Membagi kode berarti merangkai modul lewat *Import*.
2. **Dart/Flutter** sangat terikat pada **State & Class Object**. Dalam membangun UI, fungsi-fungsi builder membutuhkan akses mutlak ke *State* (seperti `setState`, `context`, variabel tabel lokal). Dart memecahkan masalah ini dengan fitur `part of` (menggabungkan banyak file fisik menjadi satu kesatuan logika *library*) dan `extension` (menambahkan fungsi/kemampuan ke *class* yang sudah ada dari luar file).

Dengan menggunakan `part` dan `extension` di Flutter, kita sukses "mengelabui" sistem. Secara fisik kodenya terpisah menjadi 5 file pendek yang mudah dibaca, namun saat aplikasi di-compile, Flutter membaca ke-5 file tersebut seolah-olah masih satu file raksasa yang sama. Hal ini memastikan 0% perubahan logika dan 0% risiko *error* pada UI!
