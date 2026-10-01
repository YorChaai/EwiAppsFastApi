I telah menganalisis kode sumber dan struktur database saat ini. Berikut adalah perencanaan lengkap untuk mengimplementasikan pengelolaan kategori dinamis pada fitur "Atur Grup & Urutan".

### **Permasalahan**
1. **Grup Kategori Statis:** Fitur "Atur Grup & Urutan" saat ini menggunakan template hardcoded (Beban Langsung, Beban Tidak Langsung, dan Administrasi Umum).
2. **Tidak Ada CRUD Grup:** Pengguna tidak dapat menambah, mengubah, atau menghapus grup kategori secara mandiri.
3. **Logika Laporan Kaku:** Pembuatan Laporan Tahunan (Sheet 2) dan Export Excel saat ini masih bergantung pada pengecekan string grup yang kaku (`BEBAN LANGSUNG`, dll.), sehingga kategori baru dalam grup baru tidak akan muncul otomatis.

---

### **Solusi Perubahan**

#### **1. Backend (Data & API)**
*   **Model Baru (`CategoryGroup`):** Membuat tabel database baru untuk menyimpan daftar grup secara dinamis.
    *   Kolom: `id`, `name` (Nama Grup), `sort_order` (Urutan Tampil), `company` (Multi-tenant).
*   **API CRUD Baru:** Membuat endpoint `/api/category-groups` untuk mendukung operasi:
    *   `GET`: Mengambil semua grup yang aktif.
    *   `POST`: Menambah grup baru.
    *   `PUT`: Mengubah nama atau urutan grup.
    *   `DELETE`: Menghapus grup (hanya jika sudah kosong/kategori dipindahkan).
*   **Sinkronisasi Kategori:** Mengaitkan field `main_group` pada tabel `Category` dengan nama grup yang ada di tabel `CategoryGroup`.

#### **2. Frontend (Flutter UI)**
*   **Dynamic Kanban Dialog:** Mengubah dialog "Atur Grup & Urutan" agar jumlah kolomnya tidak lagi statis (3 kolom), melainkan di-render berdasarkan data dari API.
*   **Fitur Manajemen Grup di UI:**
    *   Tombol **"Tambah Grup"** di dalam dialog.
    *   Opsi **"Ubah Nama"** dan **"Hapus"** pada setiap header kolom grup.
    *   Fitur **Reorder Kolom** (Drag-and-drop antar header kolom) untuk mengatur urutan grup di laporan.
*   **Drag-and-Drop Kategori:** Mempertahankan fitur pindah kategori antar grup yang sekarang sudah ada, namun kini bisa ke grup mana saja yang baru dibuat.

#### **3. Integrasi Laporan (Excel & UI)**
*   **Dynamic Looping:** Mengubah logika di `annual_excel.py` dan `annual_data.py`. Alih-alih mencari "Beban Langsung", sistem akan melakukan loop pada daftar `CategoryGroup` yang tersimpan di database.
*   **Layouting Otomatis:** Sistem akan menyisipkan blok grup baru di antara blok "PENDAPATAN" dan "LABA RUGI SEBELUM PAJAK".
*   **Auto-Total:** Setiap grup baru akan otomatis mendapatkan baris "TOTAL [NAMA GRUP]" dengan formula SUM yang sesuai di Excel.

---

### **Hasil Akhir (Flow & Tampilan)**

1.  **Alur Pengguna:**
    *   Buka **Kategori Tabular** > Klik **Atur Grup & Urutan**.
    *   Tambah grup baru, misalnya: *"Beban Research & Development"*.
    *   Geser grup tersebut ke posisi paling atas (setelah Pendapatan).
    *   Pindahkan kategori *"Biaya Research (R&D)"* dari Beban Langsung ke grup baru tersebut.
    *   Klik **Simpan**.

2.  **Tampilan Laporan (Sheet 2 & Excel):**
    *   **Blok 1:** Pendapatan (Tetap).
    *   **Blok 2 (Dinamis):** Muncul header baru **"BEBAN RESEARCH & DEVELOPMENT"**.
    *   **Blok 3 (Dinamis):** Muncul header **"BEBAN LANGSUNG"** (yang isinya sudah berkurang).
    *   **Blok Berikutnya:** Grup lainnya sesuai urutan yang diatur.
    *   **Blok Akhir:** Laba Rugi Sebelum Pajak (Tetap di bawah semua blok beban).

**Pendekatan Terbaik:** 
Menggunakan tabel referensi `CategoryGroup` adalah cara paling aman. Dengan cara ini, laporan tidak perlu "menebak" lagi grup apa saja yang ada, melainkan cukup membaca urutan dari database dan merendernya satu per satu secara berurutan di antara blok pendapatan dan hasil akhir.

Apakah rencana ini sudah sesuai dengan ekspektasi Anda? Jika ya, saya dapat mulai menyiapkan langkah teknis detailnya.

Saya mengerti kekhawatiran Anda mengenai integritas formula di Excel. Jika formula SUM atau referensi sel bergeser sedikit saja, hasil akhirnya akan salah. 

Berdasarkan saran Anda dan analisis kode `annual_excel.py`, saya telah menyempurnakan rencana teknis untuk memastikan Excel tetap akurat meskipun grup ditambah atau dikurangi secara dinamis.

### **Penyempurnaan Rencana (Fokus pada Keamanan Excel)**

#### **1. Mekanisme "Dynamic Row Tracking" di Excel**
Agar formula tidak rusak, saya tidak akan menggunakan referensi sel statis (seperti `E805`). Sebagai gantinya, sistem akan:
*   **Mencatat Row Index secara Real-time:** Saat melakukan loop untuk setiap grup kategori (misal: Beban Langsung, Beban R&D, dsb), sistem akan menyimpan nomor baris "TOTAL" dari masing-masing grup ke dalam sebuah daftar (*list*).
*   **Formula TOTAL BIAYA yang Adaptif:** Di baris "TOTAL BIAYA", sistem akan membangun formula SUM berdasarkan daftar baris yang dicatat tadi. 
    *   *Contoh:* Jika ada 4 grup di baris 20, 35, 50, dan 65, maka rumusnya otomatis menjadi `=E20+E35+E50+E65`.
*   **Formula LABA RUGI SEBELUM PAJAK:** Akan selalu merujuk pada `TOTAL PENDAPATAN - TOTAL BIAYA` (menggunakan koordinat baris yang baru saja dicatat).

#### **2. Struktur Urutan Laporan (Sesuai Gambar)**
Urutan di Sheet 2 (Excel) akan dipastikan mengikuti alur berikut:
1.  **PENDAPATAN** (Statis di atas).
2.  **BAGIAN DINAMIS (Isi dari Atur Grup):**
    *   *Loop Group 1* -> List Kategori -> Total Group 1.
    *   *Loop Group 2* -> List Kategori -> Total Group 2.
    *   *(Dan seterusnya sesuai tambahan user)*.
3.  **TOTAL BIAYA** (Hasil penjumlahan semua Total Group di atas).
4.  **PENDAPATAN/BEBAN LAIN-LAIN** (Statis).
5.  **LABA RUGI SEBELUM PAJAK** (Total Pendapatan - Total Biaya).

#### **3. Backend & UI (Dukungan CRUD Grup)**
*   **Tabel `category_groups`:** Saya akan membuat tabel ini untuk menyimpan nama grup dan urutannya.
*   **UI Kanban Dinamis:** Kolom di pop-up "Atur Grup & Urutan" akan di-render sesuai jumlah grup di database. Saya akan menambahkan tombol **"+"** untuk menambah grup baru dan ikon **"sampah"** untuk menghapus grup (dengan validasi: kategori di dalamnya harus dipindahkan dulu).

---

### **Hasil Akhir yang Dijamin**
*   **Flow:** User menambah grup "Biaya Marketing" -> User memindahkan kategori terkait ke sana -> User download Excel -> Excel otomatis memiliki blok "BIAYA MARKETING" di antara Pendapatan dan Laba Rugi dengan formula yang sudah terkoneksi otomatis ke TOTAL BIAYA.
*   **Tampilan:** Rapih, mengikuti style zebra-cross (abu-putih) yang sudah ada, dan margin serta font yang konsisten dengan template asli.

**Apakah logika "Dynamic Row Tracking" ini sudah selaras dengan maksud Anda untuk menjaga keamanan perhitungan Excel?** Jika sudah ok, saya akan mulai melakukan perubahan kodingan secara bertahap (Database -> API -> Frontend -> Report).
