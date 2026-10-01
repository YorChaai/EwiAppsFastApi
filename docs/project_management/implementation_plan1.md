# Perbaikan Merge Revenue & Tax — Sinkronisasi Backend ↔ Frontend ↔ Migration

## Ringkasan Masalah

Setelah menganalisis seluruh kode, saya menemukan **3 masalah utama** yang saling terhubung:

### 1. Annual Report Backend TIDAK mengirim data `combine_groups` ke frontend
- `_build_annual_payload_from_db()` (line 1229-1327 di `annual.py`) **tidak menyertakan combine groups** dalam JSON response.
- Combine groups **hanya dipakai saat generate Excel** (`_apply_manual_revenue_combine_groups` line 2909 dan `_apply_manual_tax_combine_groups` line 3014).
- Artinya: **Laporan Tahunan di Flutter tidak pernah tahu data mana yang harus di-merge**.

### 2. Frontend Annual Report Table tidak mendukung cell merging
- `_buildTableCard()` (line 2116-2431 di `annual_report_screen.dart`) menggunakan `ListView.builder` biasa — setiap row dirender flat, tidak ada konsep `rowSpan`.
- Meskipun combine group dikirim, UI saat ini **tidak bisa menampilkan merged cells**.

### 3. Revenue/Tax Management Screen — Combine sudah bekerja, tapi ada bug validasi
- **Batasan Receive Date harus sama**: `_validate_manual_revenue_group()` (line 20-84 di `revenues.py`) mensyaratkan semua row punya `receive_date` yang **persis sama** — ini terlalu ketat untuk data Excel yang berantakan (banyak `receive_date` kosong).
- **Tax validation juga terlalu ketat**: `_validate_manual_tax_group()` mensyaratkan semua `date` sama persis.

---

## User Review Required

> [!IMPORTANT]
> **Pilihan desain penting untuk tampilan merge di Laporan Tahunan:**
> Merge cell di Flutter tidak bisa dilakukan dengan `DataTable`/`ListView.builder` biasa. Saya mengusulkan pendekatan **visual grouping** (background warna berbeda + garis pembatas grup) daripada true `rowSpan`, karena:
> - True rowSpan memerlukan rewrite total ke `Table` widget (sangat mahal)
> - Visual grouping lebih ringan, tetap informatif, dan konsisten dengan data flat
>
> Apakah pendekatan ini bisa diterima?

> [!WARNING]
> **Relaxasi validasi combine:**
> Saat ini combine revenue mengharuskan Receive Date sama persis. Saya ingin melonggarkan menjadi:
> - Minimal 1 baris punya date (tidak semuanya harus sama)
> - Baris berurutan (tetap dipertahankan)
>
> Apakah ini sesuai dengan kebutuhan Anda?

---

## Open Questions

1. **Apakah Anda ingin combine groups otomatis dari migration script?** Saat ini combine groups hanya bisa dibuat manual lewat UI management screen. Apakah `generate_hybrid_migration_v9.py` juga perlu generate SQL `INSERT INTO manual_combine_groups` berdasarkan detected merge cells di Excel?

2. **Berapa banyak baris yang biasanya di-combine?** Biasanya 2-3 baris, atau bisa sampai 5-10 baris?

---

## Proposed Changes

### Komponen 1: Backend Annual Report — Kirim Combine Groups ke Frontend

#### [MODIFY] [annual.py](file:///D:/Aplikasi/EWIApps/backend/routes/reports/annual.py)

**Ubah `_build_annual_payload_from_db()`** untuk menyertakan combine groups dalam response JSON:

```diff
 return {
     "year": year,
     "revenue": {
         "data": revenue_data,
+        "combine_groups": _manual_combine_groups_by_table("revenues", year),
         "total_invoice_value": ...,
     },
     "tax": {
         "data": tax_data,
+        "combine_groups": _manual_combine_groups_by_table("taxes", year),
         "total_trans_val_idr": ...,
     },
```

Ini memungkinkan frontend mengetahui baris mana yang harus di-group secara visual.

---

### Komponen 2: Backend — Relaxasi Validasi Combine

#### [MODIFY] [revenues.py](file:///D:/Aplikasi/EWIApps/backend/routes/revenues.py)

Ubah `_validate_manual_revenue_group()`:
- Hapus requirement "semua receive_date harus sama persis"
- Ganti dengan: "minimal 1 baris punya receive_date" (date pertama yang ditemukan jadi `group_date`)

```diff
-    non_null_receive_dates = [item.receive_date for item in items if item.receive_date]
-    if not non_null_receive_dates:
-        return None, "Combine revenue perlu minimal satu Receive Date yang terisi."
-    if len(set(non_null_receive_dates)) != 1:
-        return None, "Combine revenue hanya bisa jika Receive Date sama persis."
+    non_null_receive_dates = [item.receive_date for item in items if item.receive_date]
+    if not non_null_receive_dates:
+        # Fallback ke invoice_date jika receive_date kosong semua
+        non_null_receive_dates = [item.invoice_date for item in items if item.invoice_date]
+    if not non_null_receive_dates:
+        return None, "Combine revenue perlu minimal satu tanggal yang terisi."
```

#### [MODIFY] [taxes.py](file:///D:/Aplikasi/EWIApps/backend/routes/taxes.py)

Ubah `_validate_manual_tax_group()` dengan cara serupa:
- Hapus requirement "semua date harus sama persis"
- Ganti dengan: "minimal 1 baris punya date"

---

### Komponen 3: Frontend Annual Report — Visual Merge Grouping

#### [MODIFY] [annual_report_screen.dart](file:///D:/Aplikasi/EWIApps/frontend/lib/screens/reports/annual_report_screen.dart)

1. **Parse combine_groups dari API response** di `_processAllTables()`:
   - Baca `_reportData['revenue']['combine_groups']` dan `_reportData['tax']['combine_groups']`
   - Bangun map `rowIndex → groupId` untuk tahu row mana yang termasuk dalam combine group

2. **Update `_buildTableCard()`** untuk mendukung visual grouping:
   - Row dalam combine group mendapat **background warna yang sama** (alternating group colors)
   - Baris pertama group mendapat **border atas tebal**
   - Baris terakhir group mendapat **border bawah tebal**  
   - Badge kecil "C#1", "C#2" di kolom pertama untuk menandakan grup

3. **Extend `ReportTableData`** class:
   ```dart
   class ReportTableData {
     final List<List<String>> rows;
     final Set<int> boldRows;
     final List<String>? headers;
     final Map<int, int>? combineGroupMap; // rowIndex → groupId
   }
   ```

---

### Komponen 4: Management Screens — Perbaikan Minor

#### [MODIFY] [revenue_management_screen.dart](file:///D:/Aplikasi/EWIApps/frontend/lib/screens/management/revenue_management_screen.dart)

- Tampilkan warna row berbeda per combine group (saat ini hanya text "C#1" di kolom Group)
- Tambahkan visual indicator yang lebih jelas (warna latar per grup)

#### [MODIFY] [tax_management_screen.dart](file:///D:/Aplikasi/EWIApps/frontend/lib/screens/management/tax_management_screen.dart)

- Sama seperti revenue management — visual indicator per combine group

---

## Verification Plan

### Automated Tests
```bash
# 1. Run backend
cd backend && python -m flask run

# 2. Cek API response mengandung combine_groups
curl http://localhost:5000/api/reports/annual?year=2024&mode=report | python -m json.tool | grep combine_groups

# 3. Run Flutter
cd frontend && flutter run -d chrome
```

### Manual Verification
1. **Buat combine group** di Revenue Management → pilih 2-3 row → klik "Combine Manual"
2. **Buka Laporan Tahunan** → Tabel 1 harus menunjukkan visual grouping (warna berbeda) untuk row yang di-combine
3. **Download Excel** → Tabel 1 harus menunjukkan merged cells yang benar
4. **Test dengan data kosong** → Row tanpa receive_date harus tetap bisa di-combine
5. **Test relax validasi** → Combine revenue dengan receive_date berbeda harus berhasil
