# Laporan Perbaikan Merge Revenue, Pajak, dan Generate Hybrid

## Ringkasan Masalah Awal

Sebelum perbaikan, alur merge Revenue dan Pajak di aplikasi sudah tersedia, tetapi hasilnya belum konsisten antara tampilan tabel, urutan data, dan hasil generate hybrid migration. Gejala yang terlihat di lapangan:

1. Data Revenue tidak terbaca (0 baris) pada proses import tertentu.
2. Batch mode pada Pengeluaran belum terbaca (0), padahal seharusnya ada data batch.
3. Bank Status hanya terbaca sebagian kecil.
4. Annual report (khusus table 1, 2, 4, 5) belum sepenuhnya sinkron dengan mapping merge terbaru.
5. Ada error database saat import/restore, seperti kolom `settlements.disbursement_comment` tidak ditemukan.

Masalah inti ada pada tiga titik: logika urutan merge, ketahanan parser Excel (terutama merged cells dan header bertingkat), dan kesesuaian schema database setelah import data lama.

## Rencana Perubahan yang Dilakukan

Rencana kerja dibagi menjadi empat tahap supaya aman:

1. Menyamakan logika urutan data (no-sort berdasarkan tanggal) menjadi urutan input asli (`id ASC`) untuk Revenue dan Pajak.
2. Memperbaiki parser generate hybrid agar tahan terhadap merged cells, fallback header, dan variasi label kolom.
3. Menyesuaikan mapping combine group pada annual report agar kolom gabungan sesuai struktur header terbaru (table 1/2/4/5).
4. Menambahkan pengamanan schema sync pada import-confirm agar restore database lama tidak gagal karena kolom baru belum ada.

## Perubahan Teknis yang Sudah Dikerjakan

Perubahan utama mencakup:

1. Backend Revenue/Tax:
   - Endpoint list Revenue/Pajak sekarang menjaga urutan berdasarkan `id ASC`.
   - Validasi manual combine diperbaiki agar referensi “berurutan” mengikuti urutan data asli per tahun laporan, bukan urutan date-sort.
   - Konsistensi pengecekan tanggal diperbaiki agar lebih aman saat ada nilai tanggal kosong/null.

2. Annual Report:
   - Grup combine Revenue kini benar-benar dimuat dan diterapkan (sebelumnya sempat tidak diaplikasikan).
   - Rentang merge kolom Revenue disesuaikan ke struktur kolom terbaru (receive date + amount received).
   - Mapping agregasi Tax diperbarui agar cocok dengan kolom transaksi dan komponen PPN/PPH saat ini.

3. Generator Hybrid:
   - Ditambah pembacaan “effective value” untuk merged cells (ambil nilai sel kiri-atas merge area).
   - Header detection Revenue diperkuat (termasuk fallback untuk kolom USD/IDR child merge).
   - Deteksi batas section diperbaiki ketika marker akhir tidak ditemukan.
   - Parsing Expense batch/single disesuaikan agar batch tidak selalu 0.
   - Noise filtering ditambah untuk baris subtotal/total/non-data.

4. Import Database:
   - Proses `/db/import-confirm` ditambah langkah schema sync pasca-restore, termasuk kolom disbursement/return yang sering hilang pada dump lama.

## Hasil Akhir (Before vs After)

Sebelum perbaikan:
- Revenue bisa terbaca 0.
- Batch mode bisa 0 walau ada data batch.
- Merge annual report belum konsisten dengan logika combine terbaru.
- Restore/import bisa gagal karena mismatch kolom schema.

Sesudah perbaikan:
- Revenue kembali terbaca pada uji file sample (bukan 0 lagi).
- Batch mode mulai terdeteksi kembali pada parsing pengeluaran.
- Mapping merge annual report lebih sinkron dengan struktur tabel yang dipakai aplikasi.
- Risiko error “undefined column” saat import berkurang karena ada schema sync tambahan.

Kesimpulan: perbaikan ini tidak hanya merapikan tampilan merge di aplikasi, tetapi juga menyelaraskan jalur end-to-end dari Excel -> generate hybrid -> database -> annual report. Dengan begitu, data Revenue dan Pajak lebih konsisten terbaca, bisa digabung sesuai logika bisnis, dan lebih aman terhadap variasi file maupun backup database lama.
