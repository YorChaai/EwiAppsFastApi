# Implementasi Logika Visibilitas Tabel Settlement (Pengeluaran)

## Goal Description
Memperbaiki logika kemunculan Table 2 (Pengiriman Dana) dan Table 3 (Pengembalian Dana) pada halaman detail Settlement, agar seragam dengan Kasbon. Tabel-tabel tersebut tidak boleh muncul di awal jika Table sebelumnya belum tuntas, dan harus disembunyikan / di-reset apabila ada perubahan status di Table sebelumnya (misal dari Approved menjadi Pending). 

## User Review Required

> [!WARNING]
> **Pertanyaan Terkait "Standalone Return" (Pengembalian Tanpa Belanja):**
> Jika ada karyawan yang meminjam Kasbon (misal Rp 1.000.000), tetapi ternyata kegiatannya batal sehingga ia **tidak membeli apapun (Table 1 kosong)** dan ingin langsung mengembalikan utuh uang tersebut Rp 1.000.000. 
> 
> Jika kita menerapkan aturan "Table 2 dan Table 3 tidak akan muncul jika Table 1 kosong", maka karyawan tidak akan bisa melakukan pengembalian dana batal ini. 
> 
> **Pertanyaan:** Apakah kita harus tetap mengizinkan kemunculan Table 2 & 3 jika Table 1 kosong **HANYA JIKA** settlement tersebut terhubung dengan Kasbon (memiliki Hutang)? Ataukah harus wajib isi Table 1 dengan nominal 0? Mohon konfirmasinya.

> [!IMPORTANT]
> **Aturan Visibilitas yang Akan Diterapkan:**
> 1. **Table 2 (Pengiriman Dana):** Hanya muncul jika **Table 1 tidak kosong** dan **SEMUA item di Table 1 sudah berstatus Approved**. Jika ada 1 item saja yang di-reject atau diubah ke pending, Table 2 akan kembali disembunyikan (muncul warning).
> 2. **Table 3 (Pengembalian Dana):** Hanya muncul jika **Table 2 sudah berstatus Approved**. Jika Table 2 diubah/dibatalkan persetujuannya, Table 3 akan kembali disembunyikan. Khusus untuk tipe "Pengeluaran Sendiri" (tidak terhubung Kasbon), Table 3 kemungkinan tidak perlu ada/ditampilkan jika tidak ada dana yang harus dikembalikan.

## Proposed Changes

### 1. Frontend - Logika Settlement
#### [MODIFY] `frontend/lib/screens/settlement/settlement_detail_widgets.dart`
- Mengubah fungsi `_buildDisbursementSection` (Table 2):
  - Menghapus *bypass* `isStandalone` yang membuat tabel ini langsung terbuka ketika item masih kosong.
  - Menambahkan validasi ketat `allApproved`. Jika tidak semua disetujui, kembalikan UI *warning message*.
- Mengubah fungsi `_buildFundReturnSection` (Table 3):
  - Menambahkan pengecekan ketat `isDisbursementApproved`. Jika Table 2 belum di-approve, Table 3 **wajib** return `SizedBox.shrink()` (disembunyikan).
  - Menghapus logika yang secara tidak sengaja memunculkan Table 3 di awal pembuatan dokumen.

### 2. Backend - Logika Reset Otomatis
#### [MODIFY] `backend/routes/settlements.py` (opsional jika dibutuhkan pengamanan ekstra)
- Menambahkan logika *auto-reset* pada *endpoint* persetujuan/perubahan item. Jika ada item di Table 1 yang berubah status, maka status persetujuan Table 2 dan Table 3 diubah menjadi `False` atau dikosongkan.

## Verification Plan

### Manual Verification
1. Membuat Settlement baru "Pengeluaran Sendiri" tanpa Kasbon. Memastikan Table 2 berupa warning, dan Table 3 tidak ada.
2. Menambahkan 1 item di Table 1. Table 2 tetap berupa warning.
3. Melakukan *Approve* item di Table 1. Memastikan Table 2 muncul. Table 3 belum muncul.
4. Melakukan *Approve* di Table 2. Memastikan Table 3 muncul (atau memvalidasi flow pengembalian dana jika ada).
5. Mengubah (Edit) item di Table 1 setelah Table 3 muncul. Memastikan Table 2 dan Table 3 langsung tertutup/tersembunyi kembali.
