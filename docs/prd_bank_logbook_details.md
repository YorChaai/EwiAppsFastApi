# Product Requirement Document (PRD)
## Peningkatan Detail Terminologi Logbook Bank & Advance

### 1. Latar Belakang
Saat ini, logbook di halaman "Kelola Bank Advance" dan "Kelola Bank Cash" menampilkan judul aliran dana (flow) secara umum, seperti `Bank Cash -> Bank Advance` atau `Kasbon -> Bank Advance`. 
Sistem ini menggunakan logika "Strict 1-to-1" (1 Kasbon = 1 Settlement). Karyawan akan lebih mudah mengerti jika logbook merefleksikan alur hutang dengan bahasa yang lebih spesifik dan manusiawi, seperti `Bank Cash ➔ Hutang Karyawan (Kasbon)` atau `Hutang Karyawan ➔ Settlement ➔ Bank Cash`.

### 2. Tujuan
Meningkatkan kejelasan pencatatan histori transaksi (Audit Trail / Logbook) dengan mengubah label arah aliran dana (Flow Header) agar secara eksplisit menyebutkan status "Hutang" dan "Settlement".

### 3. Lingkup Perubahan
Perubahan hanya dilakukan pada sisi **Frontend (UI/UX)**, tepatnya pada fungsi formatter yang mengubah data log JSON dari backend menjadi teks UI di Logbook.

**File yang Terdampak:**
1. `frontend/lib/screens/management/bank_management_screen_layout.dart`
2. `frontend/lib/screens/management/bank_advance_screen.dart`

### 4. Detail Mapping Terminologi Baru

| Kode Tipe (Backend) | Nominal | Teks Header Lama | Teks Header Baru (Usulan) |
| :--- | :--- | :--- | :--- |
| `rebalance` | `+` (Penambahan) | `Bank Cash ➔ Bank Advance` | `Bank Cash ➔ Saldo Virtual (Top Up)` |
| `rebalance` | `-` (Penarikan) | `Bank Advance ➔ Bank Cash` | `Saldo Virtual ➔ Bank Cash (Penarikan)` |
| `disbursement` | `+` | `Kasbon ➔ Bank Advance` | `Bank Cash ➔ Hutang Karyawan (Kasbon)` |
| `netting` | `-` | `Settlement ➔ Bank Advance` | `Hutang Karyawan ➔ Settlement ➔ Bank Cash` |
| `settlement_combined` | `-` | `Settlement ➔ Bank Advance` | `Hutang Karyawan ➔ Settlement ➔ Bank Cash` |
| `withdrawal` | `-` | `Bank Advance ➔ Bank Cash` | `Saldo Virtual ➔ Bank Cash (Penarikan)` |
| `reversal` | `+` | `Pembatalan (Move to Draft)` | `Pembatalan ➔ Kembali ke Draft` |

### 5. Kriteria Penerimaan (Acceptance Criteria)
- [ ] Ketika pengguna menekan tombol "Riwayat Aktivitas", kotak hijau/merah yang menunjukkan arah dana sudah memuat teks terminologi baru.
- [ ] Riwayat Kasbon yang dicairkan menampilkan tulisan "Bank Cash ➔ Hutang Karyawan (Kasbon)".
- [ ] Riwayat Settlement yang mengembalikan sisa dana menampilkan tulisan "Hutang Karyawan ➔ Settlement ➔ Bank Cash".
