# Panduan Skrip Dokumentasi Otomatis

Dokumen ini menjelaskan **6 script Python** yang digunakan untuk menghasilkan dan membandingkan dokumentasi proyek secara otomatis, lengkap dengan kelebihan, kekurangan, dan rekomendasi penggunaan.

---

## Kelompok 1 — Script Lama (Scan Langsung ke File Kode)

| Script | Tugas |
|---|---|
| `generate_backend_docs.py` | Baca file `.py` di `backend/` langsung pakai **regex** |
| `generate_frontend_docs.py` | Baca file `.dart` di `frontend/lib/` langsung pakai **regex** |
| `auto_generate_and_compare_docs.py` | Orkestrator: jalankan keduanya + smart diff + simpan ke `docs/alldocument/` |

**Cara kerjanya:** Membuka satu per satu file kode → cari pola teks dengan regex → tulis ke `.md`.

**Output:**
- `docs/alldocument/Panduan_Backend_Lengkap.md`
- `docs/alldocument/Panduan_Frontend_Lengkap.md`

**Cara menjalankan:**
```bash
python "backend\scripts\auto_generate_and_compare_docs.py"
```

---

## Kelompok 2 — Script Baru (Baca dari Graphify Knowledge Graph)

| Script | Tugas |
|---|---|
| `generate_backend_graphify.py` | Baca `graph.json` → filter node/edge backend → tulis `.md` |
| `generate_frontend_graphify.py` | Baca `graph.json` → filter node/edge frontend → tulis `.md` |
| `auto_graphify_docs.py` | Orkestrator: jalankan keduanya + smart diff + simpan ke `docs/alldocument/graphify/` |

**Cara kerjanya:** Tidak membuka file kode sama sekali. Langsung baca `graphify-out/graph.json` yang sudah berisi **4.415 node** dan **8.396 relasi** yang sudah dianalisis oleh Graphify.

**Output:**
- `docs/alldocument/graphify/Panduan_Backend_Graphify.md`
- `docs/alldocument/graphify/Panduan_Frontend_Graphify.md`
- `docs/alldocument/graphify/banding/Laporan_Graphify_<timestamp>.md`

**Cara menjalankan:**
```bash
python "backend\scripts\graphify_docs\auto_graphify_docs.py"
```

---

## Tabel Perbedaan Utama

| Aspek | Kelompok 1 (Lama) | Kelompok 2 (Graphify) |
|---|---|---|
| **Sumber data** | Buka file kode langsung | Baca `graph.json` |
| **Teknologi parse** | Regex sederhana | Knowledge Graph (4.415 node) |
| **Daftar `def` fungsi per file** | ✅ Lengkap & eksplisit | ✅ Ada (dari callable nodes) |
| **Relasi antar file** | ❌ Tidak ada | ✅ Ada (import, calls, references) |
| **Provider dependencies** | ❌ Tidak ada | ✅ Ada (bloc_lookup edges) |
| **Community grouping** | ❌ Tidak ada | ✅ Ada (klaster file terkait) |
| **Call graph** | ❌ Tidak ada | ✅ Ada (fungsi A memanggil fungsi B) |
| **Deteksi Stateful/Stateless** | ✅ Ada (regex `extends State<X>`) | ❌ Tidak terdeteksi |
| **Deteksi risiko file besar** | ✅ Berdasarkan jumlah baris | ✅ Berdasarkan jumlah fungsi |
| **Kecepatan** | Lebih lambat (buka ratusan file) | Lebih cepat (1 file JSON) |
| **Butuh Graphify dijalankan dulu** | ❌ Tidak perlu | ✅ Perlu `graph.json` ter-update |
| **Output folder** | `docs/alldocument/` | `docs/alldocument/graphify/` |
| **Laporan banding** | `alldocument/banding/` | `alldocument/graphify/banding/` |

---

## Kelebihan & Kekurangan Detail

### Kelompok 1 — Kelebihan
**Backend (`generate_backend_docs.py`):**
- ✅ Daftar semua `def function_name()` per file secara **eksplisit dan lengkap**
- ✅ Deteksi file **besar/berisiko** berdasarkan jumlah baris kode langsung
- ✅ Tidak butuh Graphify dijalankan dulu — **bisa dipakai kapan saja**

**Frontend (`generate_frontend_docs.py`):**
- ✅ Deteksi **Stateful vs Stateless** widget dari pola `extends State<X>`
- ✅ Daftar semua fungsi Dart per file (`Widget build(...)`, `Future<> xxx()`)
- ✅ Lebih lengkap untuk file Dart karena Graphify tidak selalu menandai Dart class/function sebagai `_callable_class`

### Kelompok 1 — Kekurangan
- ❌ Tidak tahu file A bergantung pada file mana (tidak ada dep-graph)
- ❌ Tidak tahu screen pakai Provider apa
- ❌ Buka ratusan file satu per satu (lebih lambat)
- ❌ Regex bisa salah tangkap pola yang tidak standar

---

### Kelompok 2 — Kelebihan
- ✅ **Relasi antar file** — file A memanggil / di-import oleh file B
- ✅ **Provider dependencies** — screen ini mengkonsumsi provider mana
- ✅ **Community grouping** — file-file mana yang "satu klaster"
- ✅ **Call graph** — fungsi mana memanggil fungsi mana
- ✅ Lebih cepat (cukup baca 1 file `graph.json`)
- ✅ Data relasi jauh lebih akurat (dianalisis AST oleh Graphify)

### Kelompok 2 — Kekurangan
- ❌ **Butuh `graph.json` ter-update** — jika kode berubah tapi Graphify belum dijalankan ulang, data bisa kadaluarsa
- ❌ Tidak mendeteksi Stateful/Stateless widget Dart
- ❌ Daftar fungsi Dart kurang lengkap (Graphify tidak selalu tag `_callable_class` untuk class Dart)

---

## Kesimpulan — Keduanya Saling Melengkapi

| Kebutuhan | Pakai Kelompok |
|---|---|
| "Fungsi `def` apa saja yang ada di file Python ini?" | **Kelompok 1** |
| "File ini bergantung pada file mana saja?" | **Kelompok 2** |
| "Screen Flutter ini pakai Provider apa?" | **Kelompok 2** |
| "Widget ini Stateful atau Stateless?" | **Kelompok 1** |
| "File ini risikonya tinggi/rendah?" | **Keduanya** |
| "Saya tidak punya `graph.json` terbaru" | **Kelompok 1** |
| "Butuh gambaran arsitektur & dependency keseluruhan" | **Kelompok 2** |
| "Butuh daftar fungsi lengkap per file untuk AI context" | **Kelompok 1** |

## Cara Regenerasi Semua Dokumen

```bash
# Regenerasi semua (Kelompok 1 + 2, graphify auto-update):
python "backend\scripts\run_all_docs.py"

# Hanya Kelompok 1 (tanpa Graphify, lebih cepat):
python "backend\scripts\run_all_docs.py" --skip-graphify
```

> [!IMPORTANT]
> Saat `run_all_docs.py` dijalankan **tanpa** `--skip-graphify`, script otomatis
> menjalankan `graphify --update` terlebih dahulu sebelum membaca `graph.json`.
> Tidak perlu update Graphify manual lagi — sudah otomatis setiap kali script dijalankan.

---

## Lokasi File Script

```
backend/scripts/
├── auto_generate_and_compare_docs.py    ← Kelompok 1 Orkestrator
├── generate_backend_docs.py            ← Kelompok 1 Backend
├── generate_frontend_docs.py          ← Kelompok 1 Frontend
└── graphify_docs/
    ├── auto_graphify_docs.py           ← Kelompok 2 Orkestrator
    ├── generate_backend_graphify.py   ← Kelompok 2 Backend
    └── generate_frontend_graphify.py  ← Kelompok 2 Frontend
```

## Lokasi Output

```
docs/
└── alldocument/
    ├── Panduan_Backend_Lengkap.md      ← Output Kelompok 1
    ├── Panduan_Frontend_Lengkap.md     ← Output Kelompok 1
    ├── banding/                        ← Laporan diff Kelompok 1
    └── graphify/
        ├── Panduan_Backend_Graphify.md ← Output Kelompok 2
        ├── Panduan_Frontend_Graphify.md← Output Kelompok 2
        ├── archive/                    ← Arsip untuk diff Kelompok 2
        └── banding/                    ← Laporan diff Kelompok 2
```
