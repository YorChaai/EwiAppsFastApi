# Laporan Refaktorisasi Sistem Evidence & Perbaikan Modul Settlement

Dokumen ini merangkum seluruh perubahan yang dilakukan untuk meningkatkan sistem manajemen bukti (evidence) menjadi multi-file dan memperbaiki kerusakan struktural pada modul Settlement.

## 1. Ringkasan Tujuan
Refaktorisasi ini bertujuan untuk:
- Mengganti sistem bukti tunggal (single-file) menjadi sistem multi-file (List of Files).
- Memperbaiki lebih dari 129 error sintaksis pada `SettlementDetailScreen`.
- Menstandarisasi interaksi API untuk pengunggahan bukti di seluruh modul Kasbon (Advance) dan Settlement.

---

## 2. Detail Implementasi Arsitektural

### A. Lapisan API (`ApiService`)
Kami memperbarui metode `finalApproveAdvance` dan `finalApproveSettlement` untuk menerima `List<String> evidencePaths`. 
- **Teknis**: Menggunakan `http.MultipartRequest` yang melakukan iterasi pada list file dan menambahkannya ke request fields dengan key yang sama (`evidence` dan `return_evidence`).
- **Kompatibilitas**: Data dikirim sedemikian rupa sehingga backend dapat menerima beberapa file sekaligus.

### B. Lapisan Provider (`AdvanceProvider` & `SettlementProvider`)
- Menambahkan parameter `evidencePaths` dan `returnEvidencePaths` pada fungsi approval.
- Memastikan state diperbarui secara reaktif setelah pengunggahan berhasil.

### C. Lapisan UI (`SettlementDetailScreen` & `AdvanceDetailScreen`)
- **Peningkatan Dialog**: Dialog "Tambah Expense" dan "Approval" kini mendukung pemilihan beberapa file sekaligus menggunakan `FilePicker`.
- **Carousel Viewer**: Mengganti tampilan gambar statis dengan `PageView.builder`. Jika terdapat lebih dari satu bukti, pengguna dapat menggeser (swipe) untuk melihat seluruh dokumen.
- **Daftar File Terpilih**: Menambahkan UI list di dalam dialog agar pengguna dapat melihat file apa saja yang telah dipilih sebelum menekan tombol simpan, lengkap dengan opsi untuk menghapus file dari daftar.

---

## 3. Perbaikan Kritikal (Bug Fixes)

| Masalah Sebelumnya | Solusi yang Diimplementasikan |
| :--- | :--- |
| **Bracket Mismatch (Settlement)** | Memperbaiki penutupan fungsi `_showAddExpenseDialog` yang salah, sehingga metode di bawahnya tidak lagi dianggap sebagai *nested function expressions*. |
| **Undefined Methods** | Mengembalikan akses ke fungsi `_showEvidence`, `_showFinalApproveDialog`, dan `_submitSettlement` yang sebelumnya tidak terdeteksi karena error scoping. |
| **Invalid EdgeInsets** | Mengganti `EdgeInsets.top(8.0)` (sintaks ilegal) menjadi `EdgeInsets.only(top: 8.0)`. |
| **FilePicker Errors** | Memperbaiki pemanggilan `FilePicker.platform.pickFiles()` menjadi `FilePicker.pickFiles()` untuk kompatibilitas versi library. |

---

## 4. Perbandingan "Before & After"

### Fitur Evidence
| Aspek | Sebelum Refactor | Sesudah Refactor |
| :--- | :--- | :--- |
| **Kapasitas Bukti** | Terbatas hanya 1 file per transaksi/approval. | Mendukung banyak file (Unlimited) per transaksi. |
| **Pemilihan File** | Memilih satu per satu (overwrite). | Dapat memilih banyak file sekaligus dalam satu jendela picker. |
| **Tampilan Preview** | Gambar statis tunggal. | Carousel interaktif dengan indikator titik (dot indicators). |
| **Manajemen File** | Tidak bisa melihat list file sebelum upload. | List file terlihat di dialog dengan tombol hapus (X). |

### Kualitas Kode
| Aspek | Sebelum Refactor | Sesudah Refactor |
| :--- | :--- | :--- |
| **Error Analyze** | 129+ Error (Merah di IDE). | **0 Error** (Clean State). |
| **Struktur File** | Berantakan (Function nesting error). | Terstruktur dan mengikuti standar Flutter. |
| **Format Mata Uang** | Tidak konsisten. | Standar menggunakan `AppFormatters.formatCurrency`. |

---

## 5. Cara Penggunaan Baru

1.  **Memilih Bukti**: Saat menekan tombol "Pilih File" di dialog Expense atau Approval, Anda dapat memilih beberapa file sekaligus (tahan tombol Ctrl/Shift atau pilih beberapa di mobile).
2.  **Melihat Bukti**: Pada tabel utama, klik ikon informasi/bukti. Akan muncul popup dialog. Jika ada lebih dari satu gambar, cukup **geser ke kanan/kiri** untuk melihat bukti lainnya.
3.  **Menghapus Bukti**: Di dalam dialog input, klik ikon **X** merah di samping nama file untuk membatalkan pilihan file tersebut sebelum disimpan.

---
**Status Akhir**: Berhasil Diimplementasikan & Diverifikasi (Flutter Analyze Clean).
