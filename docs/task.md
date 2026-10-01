# Checklist Pengerjaan Bug & Fitur (Task List)

## Bug 1: Settlement Sub Kategori
- `[x]` 1.1 Buka file `settlement_detail_dialogs_expense.dart` dan temukan bagian form Tambah/Edit Item.
- `[x]` 1.2 Ubah deklarasi inisial `selectedSubCategoryId` dari variabel tunggal (tipe `int?`) menjadi `Set<int>` agar mendukung list (himpunan).
- `[x]` 1.3 Ganti blok kode rendering list Sub Kategori yang menggunakan `RadioListTile` (atau RadioButton) menjadi `CheckboxListTile`.
- `[x]` 1.4 Sesuaikan callback `onChanged` dari checkbox untuk menambahkan ID (add) bila tercentang, atau membuang ID (remove) bila tidak tercentang pada object Set tersebut.
- `[x]` 1.5 Lakukan update parameter saat menyimpan agar properti _Sub Kategori_ dikirimkan sebagai list array JSON yang sesuai dengan standar API dari model tabel `Expense`.

## Bug 2: Kalkulasi Saldo Hutang (Dompet Kasbon)
- `[x]` 2.1 Buka file backend `backend/routes/advances_other.py` pada fungsi API `get_user_balances`.
- `[x]` 2.2 Setelah iterasi pengumpulan data hutang pengguna (dari instance model `Advance`), buat sebuah query ORM baru untuk tabel `Settlement`.
- `[x]` 2.3 Atur filter *WHERE* query agar hanya membaca Settlement dari pengguna tersebut (current user) dengan `status.in_(['approved', 'completed'])`.
- `[x]` 2.4 Jalankan loop pada hasil Settlement. Pasangkan `disbursement_source` dengan dompet Kasbon terkait, lalu totalkan semua nilai persetujuannya (`approved_amount`).
- `[x]` 2.5 Kurangi saldo `net_amount` Kasbon pada dompet sumber tersebut (`source_balances`) dengan total dari iterasi `approved_amount` Settlement agar mendapatkan angka balance hutang riil/net.

## Bug 3: Copy Data saat "Buat Settlement"
- `[x]` 3.1 Buka file frontend `frontend/lib/screens/advance/advance_detail_layout.dart`. Di tombol "Buat Settlement", kirim sebuah identifier baru: `copy_from_advance_id = adv['id']`.
- `[x]` 3.2 Buka backend `backend/routes/settlements_crud.py`. Pastikan pembuatan Settlement mengatur referensi foreign key langsung (`advance_id`) ke `None` atau tidak ada keterkaitan, melainkan baca properti flag `copy_from_advance_id`.
- `[x]` 3.3 Jika parameter tersebut terdeteksi di API POST, jalankan query pengambilan (fetch) secara terperinci untuk mengambil list array `AdvanceItem` berdasarkan ID tersebut.
- `[x]` 3.4 Bikin object `Expense` per baris (berdasarkan rincian `AdvanceItem`) dan hubungkan object tersebut ke ID `Settlement` yang baru terbuat.
- `[x]` 3.5 Salin (Copy/Map) properti utama seperti `amount`, `category_id`, array `subcategory_ids`, dan `description` agar pengguna tidak perlu input detail pengeluaran dari kosong.

## Bug 4: Bug Hapus Evidence Tambah Item
- `[x]` 4.1 Buka `frontend/lib/screens/advance/advance_detail_dialogs_expense.dart`.
- `[x]` 4.2 Tambahkan argumen Flutter unik `Key: ValueKey(file.path)` pada iterasi form Tambah Item agar Widget List.generate tidak tumpang-tindih saat item didelete.
- `[x]` 4.3 Navigasikan kursor ke ikon X (Tombol Hapus), lalu temukan objek `GestureDetector` atau setara yang membungkusnya.
- `[x]` 4.4 Pastikan memberikan parameter area jangkauan tak tembus: `behavior: HitTestBehavior.opaque` di dalam objek event `GestureDetector` tersebut.
- `[x]` 4.5 Masukkan widget `Padding` di dalam pembungkus ikon agar rasio _clickable box_ lebih lebar, kemudian terapkan fix yang persis sama ke `frontend/lib/screens/settlement/settlement_detail_dialogs_expense.dart` untuk bug yang sejenis.
