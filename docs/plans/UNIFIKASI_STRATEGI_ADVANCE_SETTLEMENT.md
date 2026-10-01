# Strategi Unifikasi: Advance & Settlement (Universal Transaction System)

## 1. Pendahuluan & Masalah Utama
Saat ini, kodingan untuk **Advance (Kasbon)** dan **Settlement (Penyelesaian)** memiliki duplikasi logika hampir 90%. File detail screen mencapai **>6.000 baris**, yang mengakibatkan:
* **Inkonsistensi Data:** Jumlah total di Kasbon dan Settlement bisa berbeda karena perbedaan cara hitung di UI.
* **Bug Table 2 Advance:** Fitur di Settlement sudah benar, namun di Advance masih gagal submit karena logika validasi yang tertinggal.
* **Sulit Maintenance:** Memperbaiki satu warna tema harus dilakukan di banyak tempat.

## 2. Arsitektur Target (Single Engine)
Kita akan menggunakan logika **Settlement sebagai standar utama** dan menerapkannya ke Advance dengan sistem "Shared Components". Target akhir adalah setiap file detail screen berada di bawah **1.000 baris**.

### A. UI Layer (Penyusutan 3.000+ Baris)
* **`UniversalTransactionTable`**: Widget mandiri untuk menampilkan list item. Kode tabel yang tadinya ada di `advance_detail_screen` dan `settlement_detail_screen` akan dihapus dan diganti dengan satu baris pemanggilan widget ini.
* **`UniversalItemDialog`**: Satu dialog cerdas untuk Tambah/Edit item. Dialog ini akan mendeteksi apakah dia sedang dalam mode "Estimasi" (Advance) atau "Realisasi" (Settlement).
* **`Context Extensions`**: Pemindahan semua fungsi warna tema (`_surfaceColor`, `_cardColor`) ke `BuildContext` agar bisa dipanggil secara global.

### B. Business Logic Layer (Penyusutan 1.500+ Baris)
* **`TransactionLogicMixin`**: Memindahkan fungsi stateful seperti `pickDate`, `pickFiles`, `calculateTotal`, dan `deleteItem` ke dalam Mixin. Kedua screen detail akan menggunakan Mixin ini.
* **`BaseProvider`**: Menyatukan state manajemen (loading, error, token, syncYear) ke dalam satu parent class provider.

## 3. Detail Fungsi yang Digabungkan
| Fungsi | Asal (Source) | Tujuan (Target) |
| :--- | :--- | :--- |
| Perhitungan Total & Pajak | Settlement (Sudah Benar) | `UniversalTransactionTable` |
| Validasi Input & Currency | Settlement | `UniversalItemDialog` |
| Upload & Preview Lampiran | Settlement | `Shared FileHelper` |
| Sinkronisasi Tahun Laporan | Settlement/Advance | `BaseProvider` |

## 4. Rencana Eksekusi
1. **Fase Fondasi:** Membuat file extension untuk warna dan helper angka.
2. **Fase Komponen:** Mengekstraksi Dialog Tambah Item dari Settlement menjadi widget global.
3. **Fase Tabel:** Mengekstraksi UI Tabel Settlement menjadi widget global.
4. **Fase Injeksi:** Mengganti kodingan di Advance Detail dengan komponen baru tersebut untuk memperbaiki bug Table 2.
5. **Fase Final:** Refactoring Provider untuk menghapus kodingan duplikat.

---
**Dokumen ini berfungsi sebagai panduan teknis utama dalam proses reorganisasi kode MiniProjectKPI.**
