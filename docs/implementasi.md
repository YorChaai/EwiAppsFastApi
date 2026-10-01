# Rencana Implementasi (Implementation Plan)

## 1. Perbaikan Bug 1 (Sub Kategori Settlement)
**File Terlibat:**
- `frontend/lib/screens/settlement/settlement_detail_dialogs_expense.dart`

**Langkah Implementasi:**
- **Poin 1:** Temukan variabel deklarasi `int? selectedSubCategoryId;` di dalam fungsi pembentuk dialog dan ganti definisinya menjadi himpunan kosong `Set<int> selectedSubCategoryIds = {};` agar dapat menyimpan multiselection.
- **Poin 2:** Cari komponen rendering UI sub-kategori yang saat ini menggunakan iterasi `RadioListTile` (atau serupa). Rombak komponen tersebut menjadi `CheckboxListTile`.
- **Poin 3:** Atur properti `value` dari `CheckboxListTile` agar bernilai `true` apabila `selectedSubCategoryIds.contains(subCatId)`.
- **Poin 4:** Pada properti `onChanged`, gunakan fungsi `setDialogState` untuk memodifikasi state `selectedSubCategoryIds` (tambahkan jika di-check, dan *remove* jika di-uncheck).
- **Poin 5:** Perbarui validasi form pada tombol simpan (Save) yang semula memeriksa "apakah ID tidak null" menjadi memeriksa "apakah himpunan *Set* memiliki `.isNotEmpty`". Terakhir, parsing array set tersebut saat memanggil method pada provider (Backend API `Expense` sudah bisa menerima list dari `subcategory_ids`).

## 2. Perbaikan Bug 2 (Saldo Hutang Outstanding)
**File Terlibat:**
- `backend/routes/advances_other.py` (pada fungsi `get_user_balances`)

**Langkah Implementasi:**
- **Poin 1:** Di `advances_other.py` fungsi `get_user_balances`, ubah kembali pengelompokkan _key_ menggunakan `(adv.bank_id, source_name)` dengan mengambil `adv.disbursement_source` agar UI dapat menampilkan rincian nama bank asli (seperti BCA TabBis, BRI, IDR).
- **Poin 2:** Karena *dummy Advance* buatan Settlement tidak memiliki nama `disbursement_source` (bernilai null), pisahkan pengecekan antara hutang positif dan pengurang hutang negatif secara global (`total_global_deduction`).
- **Poin 3:** Kumpulkan total pengurangan hutang dari seluruh *dummy Advance*, lalu gunakan metode _FIFO (First-In First-Out)_ untuk mendistribusikan / mengurangi saldo positif yang sudah dikelompokkan ke setiap bank. Ini menjamin nama asli bank tetap terjaga sementara total hutang sukses berkurang hingga lunas (0).
- **Poin 4:** Pastikan kita tetap mengambil nama bank dari tabel `BankAccount` dengan _fallback_ ke string `disbursement_source` jika entitas bank tersebut tidak memiliki field terhubung (`source_name = adv.bank.name if adv.bank else ...`).
- **Poin 5:** Di proses final, filter yang menghasilkan balikan ke klien (`if bal > 0.01:`) baru dieksekusi setelah perhitungan _running balance_ per *bank_id* selesai diakumulasi.

## 3. Perbaikan Bug 3 (Fitur "Buat Settlement")
**File Terlibat:**
- `frontend/lib/screens/advance/advance_detail_layout.dart`
- `backend/routes/settlements_crud.py`

**Langkah Implementasi:**
- **Poin 1:** Pada frontend, di fungsi onClick tombol "Buat Settlement", tambahkan properti boolean flag `copy_from_advance_id: adv['id']` ke payload API (atau tambahkan `is_copy_items=true`), lalu set `advance_id` sebagai `null` secara eksplisit pada payload.
- **Poin 2:** Pada backend `settlements_crud.py`, cegah masuknya `advance_id` ke instance model `Settlement` jika pengguna memintanya tidak ada hubungan (pastikan `.advance_id = None`).
- **Poin 3:** Jika flag `copy_from_advance_id` diberikan, buat query untuk mengambil semua data `AdvanceItem` yang berelasi dengan ID kasbon sumber tersebut.
- **Poin 4:** Buat *looping* untuk mengkonversi setiap baris `AdvanceItem` menjadi `Expense` baru. Hati-hati karena `AdvanceItem` tidak punya kolom `amount`, jadi pastikan kita aman menggunakan `getattr(item, 'estimated_amount', 0.0)`.
- **Poin 5:** Di `advance_detail_screen.dart`, perbarui filter `canCreateSettlement` (dan `canStartRevision`) agar mengizinkan visibilitas tombol "Buat Settlement" hanya pada status `completed` (setelah dana di-*disburse*), bukan sejak `approved`.

## 4. Perbaikan Bug 4 (Hapus Evidence Saat Tambah Item)
**File Terlibat:**
- `frontend/lib/screens/advance/advance_detail_dialogs_expense.dart`
- `frontend/lib/screens/settlement/settlement_detail_dialogs_expense.dart`

**Langkah Implementasi:**
- **Poin 1:** Temukan lokasi blok kode rendering untuk daftar `Evidence` (file bukti) yang berada di dalam `StatefulBuilder` atau loop perenderan form "Tambah Item".
- **Poin 2:** Bungkus setiap item di dalam loop perenderan `List.generate` menggunakan widget `Key` unik di Flutter (misal: `ValueKey(file.path)`). Ini mencegah perenderan UI cache mem-bypass update ketika urutan array dimanipulasi.
- **Poin 3:** Cari elemen `GestureDetector` pada tombol penghapus (ikon "X"), lalu tambahkan argumen spesifik: `behavior: HitTestBehavior.opaque`. Hal ini agar _touch event_ tertangkap walau pengguna tidak klik pas di piksel garis ikon.
- **Poin 4:** Bungkus widget `Icon` hapus (X) dengan widget `Padding(padding: EdgeInsets.all(8.0))` untuk membesarkan area sentuhan minimal menjadi setara standar UX, yang sangat penting saat digunakan dari Mobile / layar sentuh kecil.
- **Poin 5:** Periksa mekanisme `removeAt` dari list state lokal (`selectedFilePaths` dan `selectedFileNames`) agar eksekusinya tepat berada di dalam pemanggilan fungsi `setDialogState(() { ... })`, memastikan *widget tree* pada list diberitahu untuk me-render ulang seketika.

---

**Mohon konfirmasi Anda:**
Silakan ditinjau rancangan implementasi dan PRD yang lebih terperinci di atas. Jika penjabaran 5 poin per bug ini sudah sesuai, mohon persetujuannya (klik Proceed / konfirmasi) agar saya dapat mulai melakukan penulisan ulang kodenya.
