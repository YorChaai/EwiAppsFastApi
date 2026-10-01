# Roadmap Unifikasi & Perbaikan Bug Table 2

## Tahap 1: Pembersihan & Fondasi (UI Boilerplate)
- [x] Buat `lib/utils/context_extensions.dart` (Helper Warna & Tema)
- [x] Implementasi `ContextExtensions` di `SettlementDetailScreen`
- [x] Implementasi `ContextExtensions` di `AdvanceDetailScreen`
- [x] Validasi: Pastikan warna UI tidak berubah setelah pembersihan.

## Tahap 2: Ekstraksi Komponen Utama (The "Big Cut")
- [x] Buat `lib/widgets/universal_item_dialog.dart` (Ambil logika dari Settlement)
- [x] Buat `lib/widgets/universal_transaction_table.dart` (Ambil logika dari Settlement)
- [x] Ganti Dialog Tambah/Edit di `SettlementDetailScreen` dengan widget baru.
- [x] Ganti Tabel di `SettlementDetailScreen` dengan widget baru.
- [x] Validasi: Settlement tetap berjalan normal 100%.

## Tahap 3: Perbaikan Advance (The "Bug Fix")
- [x] Ganti Dialog Tambah/Edit di `AdvanceDetailScreen` dengan `UniversalItemDialog`.
- [x] Ganti Tabel di `AdvanceDetailScreen` dengan `UniversalTransactionTable`.
- [x] Restorasi Fitur Sidebar & Tabel 2/3 di Advance.
- [x] Tes Submit Table 2 di Advance (Harus berhasil mengikuti standar Settlement).
- [x] Validasi: Jumlah total Kasbon harus akurat sesuai perhitungan Settlement.

## Tahap 4: Refactoring Logic (The "Brain")
- [x] Buat `lib/providers/base_provider.dart` (Unifikasi State Provider)
- [ ] Buat `lib/mixins/transaction_logic_mixin.dart` (Unifikasi Fungsi State Screen)
- [ ] Update `AdvanceProvider` agar extend `BaseTransactionProvider`.
- [ ] Update `SettlementProvider` agar extend `BaseTransactionProvider`.

## Tahap 5: Final Cleanup
- [x] Pastikan ukuran file `advance_detail_screen.dart` di bawah 1.000 baris (Saat ini ~350 baris).
- [x] Pastikan ukuran file `settlement_detail_screen.dart` di bawah 1.000 baris (Saat ini ~350 baris).
- [ ] Hapus file-file backup jika semua sudah stabil.

