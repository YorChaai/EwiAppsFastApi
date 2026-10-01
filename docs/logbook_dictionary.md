# 📖 Kamus Logbook & Mutasi Transaksi (Template Dictionary)

Dokumen ini berisi daftar **semua kemungkinan teks** yang akan muncul di halaman Logbook, Bank Advance, maupun Bank Cash berdasarkan file template `transaction_templates`. 

Teks di bawah ini sudah dirancang agar ringkas (*clean*) dan dinamis sesuai pelakunya.

---

### 1. Bank Cash (Mutasi Kas Riil)
Teks ini muncul saat terjadi penambahan atau pengurangan nominal uang fisik di Bank Kas:

| Kode Template | Contoh Teks / Output Akhir | Kapan Muncul? |
| --- | --- | --- |
| `ADD_REAL_CASH` | **"Penambahan Saldo Kas Riil"** | Saat Staff Finance memasukkan pemasukan (Top Up Bank Cash) |
| `SUB_REAL_CASH` | **"Pengurangan Saldo Kas Riil"** | Saat Staff Finance mencatat pengeluaran di luar Settlement |

---

### 2. Bank Advance (Alokasi Saldo Virtual)
Teks ini muncul di histori "Bank Advance" saat saldo virtual seorang karyawan diubah (baik di-Top Up maupun dikurangi).

| Skenario | Contoh Teks / Output Akhir | Keterangan |
| --- | --- | --- |
| **Biasa (Default)** | **"Terima Alokasi - Manager 1: Penyesuaian Saldo Virtual"** | Jika Manager 1 mengalokasikan saldonya sendiri tanpa catatan khusus. |
| **Dengan Catatan** | **"Terima Alokasi - Manager 1: Buat Bensin Proyek"** | Jika Manager 1 mengalokasikan saldo sendiri dan mengetikkan catatan. |
| **Dilakukan Orang Lain** | **"Terima Alokasi - Manager 1 (oleh Admin): Penyesuaian Saldo Virtual"** | Jika Admin/Direktur yang memasukkan alokasi untuk si Manager 1. |
| **Pengurangan (Tarik)** | **"Tarik Alokasi - Manager 1: Koreksi Saldo"** | Jika alokasinya bernilai minus (pengurangan plafon). |

---

### 3. Mutasi Pencairan (Disbursement & Refund)
Teks ini tercatat di **Bank Cash** pada saat pencairan (transfer) uang sungguhan, atau pengembalian (Refund) uang sisa ke perusahaan.

| Kode Template | Contoh Teks / Output Akhir |
| --- | --- |
| `disbursement` | **"Disbursement Saldo Advance Manager 1 (Staff Finance)"** <br>*(Artinya: Uang kas keluar untuk Advance Manager 1, dieksekusi oleh Finance)* |
| `refund_notes` | **"Pengembalian Dana - Manager 1: Sisa Uang Tiket (Ref: #102)"** <br>*(Artinya: Manager 1 mengembalikan sisa uang, uang masuk ke Bank Cash)* |

---

### 4. Notifikasi Logbook Workflow (Advance & Settlement)
Teks ini muncul murni di halaman **Log Book** untuk melacak *history/audit trail* perubahan status suatu pengajuan.

| Kode Template | Teks Output di Logbook |
| --- | --- |
| `advance_approved_final()` | **"Advance Approved (Final)"** |
| `advance_rejected_final()` | **"Advance Rejected (Final)"** |
| `settlement_approved_final()`| **"Settlement Approved (Final)"** |
| `settlement_rejected_final()`| **"Settlement Rejected (Final)"** |
| `advance_revision_requested()`| **"Revision Requested"** |
| `advance_move_to_draft()` | **"Dipindahkan ke Draft"** |

---

### 💡 Cara Mengubah Teks:
Jika sewaktu-waktu direksi ingin mengubah istilah *"Disbursement"* menjadi *"Pencairan Kasbon"*, Anda **tidak perlu mengutak-atik routing API yang rumit**. 
Cukup buka file `backend/utils/transaction_templates.py` dan ubah teksnya di sana!
