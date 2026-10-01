# Rencana Reorganisasi UI Laporan (Sistem Cascading Sheet)

Dokumen ini merinci rencana perubahan tampilan Laporan Tahunan dari sistem tombol berjejer menjadi sistem **Triple Cascading Header** yang sangat bersih dan terorganisir.

---

## 1. Struktur Triple Cascading Header (Menu Atas)
Kita akan mengganti barisan tombol lama dengan 3 tombol menu utama yang semuanya menggunakan sistem **Cascading** (bertingkat):

### A. 📥 Tombol: INPUT (Paling Kiri)
Memudahkan user untuk menambah semua jenis data keuangan langsung dari satu tempat.
*   **Menu:**
    *   ➔ **Input Pemasukan** (Invoice, Bunga, Investasi)
    *   ➔ **Input Pengeluaran** (Biaya Operasional)
    *   ➔ **Input Aset Baru** (Registrasi barang berharga)
    *   ➔ **Input Transfer Bank** (Pemindahbukuan antar rekening)
    *   ➔ **Input Dividen** (Pencatatan pembagian keuntungan)
    *   ➔ **Input Neraca / Modal** (Input saldo awal, modal, atau penyesuaian neraca)

### B. 📂 Tombol: SHEET (Tengah)
Untuk berpindah fokus tampilan laporan utama.
*   **Menu:**
    *   ➔ **Sheet 1: Revenue Cost** (Detail Transaksi)
    *   ➔ **Sheet 2: Laba Rugi & Neraca** (Kesehatan Keuangan & Aset)
    *   ➔ **Sheet 3: Business Summary** (Ringkasan Eksekutif & Dividen)

### C. ⚙️ Tombol: KOLOM / TABEL (Kanan)
Tombol ini bersifat **DINAMIS**. Isinya akan menyesuaikan dengan Sheet yang dipilih.
*   **Jika Pilih Sheet 1:** Menu isinya pilihan Show/Hide untuk (Tabel 1, 2, 4, 6).
*   **Jika Pilih Sheet 2:** Menu isinya pilihan Show/Hide untuk (Laba Rugi, Neraca, Aset).
*   **Jika Pilih Sheet 3:** Menu isinya pilihan Show/Hide untuk (Summary, Dividen).

---

## 2. Detail Konten Tiap Sheet

### Sheet 1: Revenue Cost
*   **Tabel:** Pemasukan (T1), Pajak (T2), Bank Status (T6), Pengeluaran (T4).

### Sheet 2: Laba Rugi & Neraca
*   **Tabel:** Laba Rugi (PDF Style), Neraca (T5), Asset Register (T7).

### Sheet 3: Business Summary
*   **Tabel:** Business Summary (Tabel 10 Item), Dividen (T3).

---

## 3. Logika Export & Interaksi
*   **Export:** Tetap ada opsi Export per-sheet atau Full Report.
*   **Search:** Kotak pencarian tersedia di tiap sheet untuk mencari data spesifik.

---

## 4. Daftar Perubahan Koding (Frontend Logic)

### File: `lib/screens/reports/annual_report_screen.dart`
1.  **State Baru:** `_activeSheet` (untuk sheet) dan `_visibleTables` (untuk filter kolom).
2.  **UI Layout:** 
    *   Membuat barisan `Row` yang berisi 3 widget `CascadingMenu`.
    *   Memasukkan logika **Switch Case** untuk mengganti isi menu pada tombol ketiga (Tombol Kolom).
3.  **Rendering:**
    *   Hanya me-render tabel yang statusnya `visible` dan masuk dalam kategori `activeSheet` tersebut.

---

## 5. Keuntungan Sistem Triple Cascading:
1.  **Satu Tempat untuk Semua:** User tidak perlu bingung mencari di mana tombol input dividen atau modal, semuanya ada di Tombol 1.
2.  **Minimalis:** Header tetap bersih meskipun fitur bertambah banyak.
3.  **User Experience:** Aplikasi terasa sangat terstruktur dan rapi.

> [!IMPORTANT]
> **Catatan Teknis:** 
> Untuk menu "Input Neraca / Modal", kita perlu membuat form khusus yang bisa mengupdate saldo awal kas atau catatan modal investor agar Neraca di Tabel 5 selalu seimbang (Balance).
