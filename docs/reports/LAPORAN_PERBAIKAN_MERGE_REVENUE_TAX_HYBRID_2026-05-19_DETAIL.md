# Laporan Detail Perubahan Merge Revenue, Pajak, dan Generate Hybrid

## Konteks dan Tujuan

Dokumen ini merangkum perbaikan yang dilakukan pada 19 Mei 2026 untuk menyelesaikan isu merge Revenue dan Pajak, sinkronisasi annual report (table 1, 2, 4, 5), serta konsistensi hasil import melalui generator hybrid migration. Fokus utamanya adalah membuat hasil baca data stabil dari sumber Excel sampai tampil di aplikasi dan tersimpan aman di database.

## Kondisi Sebelum Perubahan (Before)

Kondisi awal yang ditemukan:

1. Merge Revenue dan Pajak sudah tersedia, tetapi perilakunya tidak konsisten karena sebagian proses masih bergantung pada urutan sort tanggal, bukan urutan input asli.
2. Saat import dari file Excel mergen, Revenue bisa terbaca 0 baris walaupun data ada.
3. Batch Mode di Pengeluaran terbaca 0 baris, padahal data transaksi batch ada.
4. Annual report untuk bagian terkait merge belum sepenuhnya menerapkan combine group yang sama antara data mentah dan hasil render laporan.
5. Muncul error import/restore di runtime:
   - `psycopg2.errors.UndefinedColumn`
   - contoh: `settlements.disbursement_comment does not exist`
6. Parsing file Excel sensitif terhadap:
   - merged cell (header bertingkat)
   - variasi nama kolom (misalnya `INVOICE Number` vs `INVOICE NO`)
   - baris noise seperti subtotal/total

Akibat bisnis dari kondisi before:

1. User harus cek manual lebih lama karena angka tidak langsung dipercaya.
2. Hasil laporan tahunan berisiko beda dengan data source.
3. Proses import backup lama berpotensi gagal setelah update schema aplikasi.

## Rencana Perubahan

Rencana dipecah menjadi 4 jalur agar aman dan terukur:

1. Standarisasi urutan merge Revenue/Pajak berdasarkan `id ASC` (urutan input), bukan date sort.
2. Penguatan parser hybrid terhadap merged cells, fallback header, dan deteksi batas section.
3. Sinkronisasi mapping combine untuk annual report (table 1, 2, 4, 5) agar merge visual dan agregasi nilai konsisten.
4. Hardening import database: tambah schema sync pasca-restore agar kolom baru otomatis tersedia.

## Detail Perubahan yang Dikerjakan

### A. Backend Merge Revenue dan Pajak

File utama:
- `backend/routes/revenues.py`
- `backend/routes/taxes.py`

Perubahan:

1. Query list Revenue/Pajak diseragamkan ke `id ASC`.
2. Validasi manual combine untuk "pilihan berurutan" disesuaikan dengan posisi data asli per tahun laporan.
3. Pengecekan tanggal diperketat agar null date tidak menyebabkan false-pass/fail combine.

Dampak:

1. User combine manual tidak lagi tertipu oleh urutan hasil sort yang berubah.
2. Hasil merge lebih stabil ketika dipakai ulang untuk render laporan.

### B. Annual Report (Table 1, 2, 4, 5)

File utama:
- `backend/routes/reports/annual.py`
- `frontend/lib/screens/reports/annual_report_screen.dart`

Perubahan:

1. Combine group Revenue yang sebelumnya sudah tersedia tetapi tidak selalu diaplikasikan, sekarang dipastikan dipakai saat render annual.
2. Rentang merge Revenue diperbaiki sesuai struktur kolom saat ini (kolom receive date dan amount received).
3. Mapping agregasi Tax diselaraskan dengan struktur transaksi/PPN/PPH yang berlaku di template sekarang.
4. Perbaikan fallback tampilan deskripsi agar kolom tidak kosong total ketika nilai null.

Dampak:

1. Hasil merge visual di report lebih selaras dengan logika combine backend.
2. Risiko pergeseran angka antar kolom pada table 1 dan 2 menurun.
3. Table 4 mengikuti aturan khusus: tidak menarik `Sub total`, `Total`, `From`, `To` sebagai data transaksi.

### C. Generate Hybrid Migration (Excel -> SQL/Data)

File utama:
- `backend/scratch/scanner_fokus/scripts/generate_hybrid_migration_v9.py`

Perubahan:

1. Ditambah helper pembacaan effective value merged cells (nilai sel kiri-atas area merge).
2. Parsing numeric/string kini membaca nilai efektif agar header child merge (USD/IDR) tidak hilang.
3. Header detection Revenue ditambah fallback label sehingga variasi penamaan tetap terbaca.
4. Fallback batas section ditambah ketika marker akhir tidak ada, supaya parser tidak berhenti terlalu cepat.
5. Filter noise ditambah untuk subtotal/total/non-data.
6. Logika deteksi batch expense disesuaikan agar data batch tidak selalu jatuh ke single.
7. Perbaikan typo argumen CLI pada mode eksekusi script.

Dampak:

1. Revenue tidak lagi drop ke 0 hanya karena struktur merge header.
2. Batch expense mulai terbaca lagi.
3. Hasil ekstraksi lebih tahan terhadap format Excel real di lapangan.

### D. Import/Restore Database dan Kompatibilitas Schema

File utama:
- `backend/routes/settings.py`

Perubahan:

1. Setelah restore database (`/db/import-confirm`), ditambahkan langkah schema sync eksplisit untuk menambah kolom yang belum ada.
2. Fokus sinkronisasi pada field disbursement/return yang sering muncul di error legacy dump.

Dampak:

1. Mengurangi error `UndefinedColumn` setelah import backup lama.
2. Proses restore jadi lebih kompatibel antar versi data.

## Perbandingan Before vs After (Ringkas dan Terukur)

1. Revenue import:
   - Before: bisa 0 baris pada file yang sebenarnya punya data.
   - After: pada uji sample `excelewi mergen.xlsx`, Revenue kembali terbaca (bukan 0).
2. Tax import:
   - Before: terbaca, tetapi merge/mapping lintas report belum sepenuhnya konsisten.
   - After: mapping agregasi di annual lebih sinkron.
3. Batch expense:
   - Before: 0 (tidak terdeteksi).
   - After: batch mulai terdeteksi kembali.
4. Urutan merge:
   - Before: berpotensi bergeser akibat date sort.
   - After: stabil mengikuti urutan input (`id ASC`).
5. Database import:
   - Before: bisa gagal karena kolom tidak ada.
   - After: ada mekanisme schema sync untuk menutup gap kolom.

## Timeline Before vs After per Alur

1. Sebelum perbaikan:
   - Excel dibaca parser lama -> beberapa header child merge gagal dikenali -> Revenue bisa 0.
   - Data masuk backend -> list/merge bercampur dengan sorting tanggal -> validasi urutan combine bisa berbeda dengan urutan input.
   - Annual report dirender -> sebagian combine group belum benar-benar diterapkan di kolom agregasi terbaru.
   - Import backup lama -> endpoint read tertentu gagal karena kolom baru belum ada.

2. Sesudah perbaikan:
   - Excel dibaca parser baru berbasis effective merged value -> kolom child merge lebih konsisten terbaca.
   - Data masuk backend dengan urutan `id ASC` -> validasi combine sesuai urutan sumber.
   - Annual report menerapkan combine Revenue/Tax dengan mapping kolom terbaru -> output tabel lebih konsisten.
   - Import backup lama melewati schema sync -> endpoint lebih aman dari error kolom hilang.

## Validasi Teknis yang Dilakukan

Validasi yang sudah dilakukan:

1. `py_compile` pada file Python yang diubah: lolos.
2. Uji parser hybrid pada file sample: Revenue tidak lagi 0; batch tidak lagi 0.
3. Review alur annual report: combine Revenue dan Tax kini diterapkan dengan mapping yang diperbarui.

Catatan penting:

1. `flutter analyze` tetap wajib dijalankan di environment utama project sebelum final release.
2. Bank Status masih bisa terlihat lebih kecil dari ekspektasi jika source bank section tidak memenuhi pola tanggal + nominal yang dikenali parser. Ini bukan data hilang permanen, tetapi rule parsing yang masih konservatif.

## Kesimpulan Akhir

Secara akhir, perubahan ini memperbaiki tiga jalur penting sekaligus:

1. Jalur input dan merge di aplikasi (Revenue/Pajak) menjadi lebih konsisten.
2. Jalur generate hybrid menjadi lebih tahan terhadap variasi struktur Excel mergen.
3. Jalur import database lama menjadi lebih aman melalui schema sync.

Dengan kondisi ini, proses dari Excel -> generate hybrid -> import DB -> tampil annual report sudah jauh lebih sinkron dibanding before. Risiko mismatch angka karena urutan merge, kolom child header, dan gap schema berkurang signifikan. Area lanjutan yang masih bisa ditingkatkan adalah tuning parser Bank Status agar coverage mutasi lebih luas tanpa menaikkan false-positive.
