# INDEX — Dokumentasi Proyek MiniProjectKPI_EWI_Revisi2

> **Terakhir di-generate:** 2026-09-11 07:28:32
> **Status Graphify:** Graphify tidak di-update sesi ini (lewati atau belum di-setup)

---

## 1. Panduan Arsitektur & Kode (`panduan/`)

| Dokumen | Deskripsi | Ukuran | Status |
|---|---|---|---|
| [Panduan_Backend_Lengkap.md](panduan/Panduan_Backend_Lengkap.md) | Seluruh fungsi & class Python per file backend | 36 KB | Tersedia |
| [Panduan_Frontend_Lengkap.md](panduan/Panduan_Frontend_Lengkap.md) | Seluruh widget & fungsi Dart di frontend/lib | 82 KB | Tersedia |
| [Panduan_Skrip_Dokumentasi.md](panduan/Panduan_Skrip_Dokumentasi.md) | Panduan teknis cara pakai generator dokumentasi | 6 KB | Tersedia |

---

## 2. Laporan Proyek & Pengujian (`laporan/`)

| Dokumen | Deskripsi | Ukuran | Status |
|---|---|---|---|
| [Handover_Progress_Report.md](laporan/Handover_Progress_Report.md) | Laporan progres handover & checklist fitur | 3 KB | Tersedia |
| [Metode_Pengujian_Backend.md](laporan/Metode_Pengujian_Backend.md) | Standar metode audit keamanan & testing backend | 5 KB | Tersedia |

---

## 3. Dokumentasi Berbasis Knowledge Graph (`graphify/`)

| Dokumen | Deskripsi | Ukuran | Status |
|---|---|---|---|
| [Panduan_Backend_Graphify.md](graphify/Panduan_Backend_Graphify.md) | Relasi antar file backend, dependency map & call graph | 182 KB | Tersedia |
| [Panduan_Frontend_Graphify.md](graphify/Panduan_Frontend_Graphify.md) | Provider deps, import internal, relasi antar Dart file | 689 KB | Tersedia |

---

## 4. Riwayat Perubahan & Perbandingan (`banding/`)

| Folder / File | Deskripsi |
|---|---|
| [Laporan_Perbandingan_Terakhir.md](banding/Laporan_Perbandingan_Terakhir.md) | Laporan diff terakhir (scan regex) |
| [banding/](banding/) | Arsip lengkap riwayat perubahan kode versi sebelumnya |
| [graphify/banding/](graphify/banding/) | Riwayat perbandingan versi Graphify |

---

## Struktur Folder Dokumentasi Bersih

```text
docs/alldocument/
|-- INDEX.md              <- Hub navigasi utama (file ini)
|-- panduan/              <- Seluruh panduan arsitektur & kode
|-- laporan/              <- Laporan progres, handover, & audit
|-- banding/              <- Laporan diff kode versi sebelumnya
\`-- graphify/             <- Knowledge graph dokumentasi & relasi
    \`-- banding/          <- Riwayat perbandingan graphify
```
