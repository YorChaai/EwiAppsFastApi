# Laporan Perubahan Dokumentasi Graphify
**Tanggal Generate:** 2026-09-11 07:28:32

Laporan ini mendeteksi perubahan pada dokumentasi berbasis Knowledge Graph.

---

## Perubahan Backend (Graphify)
### 🆕 File / Entitas Baru
- `backend/tests/test_annual_report_routes.py`
- `backend/tests/test_blueprint_routes.py`
- `backend/tests/test_code_hygiene_fixes.py`
- `backend/tests/test_revenue_bank_sync.py`

### ❌ File / Entitas Dihapus
- `backend/clean_all.py`
- `backend/clean_duplicate_parsing.py`
- `backend/cleanup_auth.py`
- `backend/cleanup_auth_regex.py`
- `backend/extract_funcs.py`
- `backend/fix_imports.py`
- `backend/fix_routes.py`
- `backend/fix_services.py`
- `backend/move_utils_to_services.py`
- `backend/update_parsing_imports.py`

### 📝 Konten Berubah
#### `backend/app.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Entry-point server backend. Inisialisasi aplikasi, database, middleware, dan blueprint.
 
-**Community Group:** `98` | **Lokasi:** `L155`
+**Community Group:** `56` | **Lokasi:** `L169`
 
 **Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).
@@ -13,10 +13,5 @@
 **Bergantung Pada (Internal Imports):**
 
-- `Category`
-- `Config`
-- `User`
 - `config.py`
-- `init_mail()`
-- `models/__init__.py`
 
 **Memanggil Fungsi/Modul:**
@@ -26,3 +21,9 @@
 - `init_mail()`
 
+**Dipakai Oleh:**
+
+- `backend/tests/test_annual_report_routes.py`
+- `backend/tests/test_blueprint_routes.py`
+- `backend/tests/test_revenue_bank_sync.py`
+
 ---
```

#### `backend/config.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Mengelola environment variables dan konfigurasi server (database URI, secret key, dll).
 
-**Community Group:** `98` | **Lokasi:** `L1`
+**Community Group:** `56` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
@@ -14,2 +14,6 @@
 
 ---
+
+## 📁 Folder: `backend/models`
+
+**Tujuan Folder:** Mendefinisikan skema database (ORM) dan validasi data dengan SQLAlchemy.
```

#### `backend/models/__init__.py`
```diff
@@ -20,6 +20,4 @@
 **Dipakai Oleh:**
 
-- `backend/app.py`
-- `backend/routes/advances/advances_crud.py`
 - `backend/routes/advances/advances_disbursement.py`
 - `backend/routes/advances/advances_items.py`
@@ -28,4 +26,6 @@
 - `backend/routes/core/cleanup.py`
 - `backend/routes/core/dashboard.py`
+- `backend/routes/core/notifications.py`
+- `backend/routes/master_data/bank_status.py`
 
 ---
```

#### `backend/models/banking.py`
```diff
@@ -7,7 +7,7 @@
 **Classes / Models:**
 
+- `BankTransaction` (L33)
 - `BankAccount` (L7)
-- `BankTransaction` (L33)
-- `BankStatusTransaction` (L77)
+- `BankStatusTransaction` (L98)
 
 **Fungsi / Metode:**
@@ -23,11 +23,11 @@
 
 - `backend/models/__init__.py`
-- `backend/routes/advances/advances_crud.py`
 - `backend/routes/advances/advances_disbursement.py`
 - `backend/routes/advances/advances_items.py`
 - `backend/routes/advances/advances_other.py`
 - `backend/routes/core/cleanup.py`
-- `backend/routes/master_data/bank_management.py`
 - `backend/routes/master_data/bank_status.py`
+- `backend/routes/settlements/settlements_disbursement.py`
+- `backend/services/advances/advance_approval_service.py`
 
 ---
```

#### `backend/models/core.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.
 
-**Community Group:** `98` | **Lokasi:** `L1`
+**Community Group:** `1` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (12 fungsi/metode terdeteksi).
@@ -7,12 +7,13 @@
 **Classes / Models:**
 
+- `CategoryGroup` (L125)
 - `Company` (L7)
+- `Category` (L144)
 - `User` (L23)
-- `CategoryGroup` (L125)
-- `Category` (L144)
 
 **Fungsi / Metode:**
 
 - `.to_dict()`
+- `.full_name()`
 - `.__init__()`
 - `.check_password()`
@@ -20,5 +21,4 @@
 - `.last_login_formatted()`
 - `.set_password()`
-- `.full_name()`
 
 **Bergantung Pada (Internal Imports):**
@@ -28,7 +28,5 @@
 **Dipakai Oleh:**
 
-- `backend/app.py`
 - `backend/models/__init__.py`
-- `backend/routes/advances/advances_crud.py`
 - `backend/routes/advances/advances_disbursement.py`
 - `backend/routes/advances/advances_items.py`
@@ -36,4 +34,6 @@
 - `backend/routes/core/auth.py`
 - `backend/routes/core/cleanup.py`
+- `backend/routes/core/dashboard.py`
+- `backend/routes/core/notifications.py`
 
 ---
```

#### `backend/models/system.py`
```diff
@@ -8,7 +8,7 @@
 
 - `Notification` (L7)
+- `WorkflowLog` (L92)
 - `OverrideLog` (L131)
 - `DeadlineSetting` (L59)
-- `WorkflowLog` (L92)
 
 **Fungsi / Metode:**
@@ -24,5 +24,4 @@
 
 - `backend/models/__init__.py`
-- `backend/routes/advances/advances_crud.py`
 - `backend/routes/advances/advances_other.py`
 - `backend/routes/core/cleanup.py`
@@ -31,4 +30,5 @@
 - `backend/routes/settings/deadline.py`
 - `backend/routes/settings/profile.py`
+- `backend/routes/settlements/settlements_crud.py`
 
 ---
```

#### `backend/models/transaction.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.
 
-**Community Group:** `31` | **Lokasi:** `L195`
+**Community Group:** `1` | **Lokasi:** `L195`
 
 **Risiko:** 🟢 **Aman** (39 fungsi/metode terdeteksi).
@@ -10,11 +10,11 @@
 - `AdvanceItem` (L155)
 - `Asset` (L7)
-- `Dividend` (L564)
+- `Dividend` (L571)
+- `DividendSetting` (L591)
+- `Expense` (L315)
+- `Revenue` (L394)
 - `Settlement` (L230)
-- `Tax` (L474)
-- `ManualCombineGroup` (L521)
-- `DividendSetting` (L584)
-- `Revenue` (L394)
-- `Expense` (L315)
+- `Tax` (L481)
+- `ManualCombineGroup` (L528)
 
 **Fungsi / Metode:**
@@ -25,15 +25,15 @@
 - `.rejected_count()`
 - `.revision_amount()`
+- `.to_dict()`
 - `.total_amount()`
-- `.to_dict()`
+- `.combined_subcategory_label()`
+- `.idr_amount_received()`
+- `.idr_invoice_value()`
 - `.idr_transaction_value()`
+- `.normalize_revenue_type()`
+- `.__init__()`
+- `.idr_amount()`
 - `.merged_columns()`
 - `.row_ids()`
-- `.__init__()`
-- `.idr_amount_received()`
-- `.idr_invoice_value()`
-- `.combined_subcategory_label()`
-- `.idr_amount()`
-- `.normalize_revenue_type()`
 
 **Bergantung Pada (Internal Imports):**
@@ -57,5 +57,4 @@
 
 - `backend/models/__init__.py`
-- `backend/routes/advances/advances_crud.py`
 - `backend/routes/advances/advances_disbursement.py`
 - `backend/routes/advances/advances_items.py`
@@ -63,5 +62,6 @@
 - `backend/routes/core/cleanup.py`
 - `backend/routes/core/dashboard.py`
-- `backend/routes/master_data/bank_management.py`
+- `backend/routes/master_data/categories.py`
+- `backend/routes/master_data/taxes.py`
 
 ---
```

#### `backend/routes/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `206` | **Lokasi:** `L1`
+**Community Group:** `219` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/advances/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `204` | **Lokasi:** `L1`
+**Community Group:** `217` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/advances/advances_approval.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `32` | **Lokasi:** `L1`
+**Community Group:** `14` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).
```

#### `backend/routes/advances/advances_crud.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `26` | **Lokasi:** `L1`
+**Community Group:** `13` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).
@@ -16,14 +16,5 @@
 **Bergantung Pada (Internal Imports):**
 
-- `Advance`
-- `AdvanceItem`
-- `BankAccount`
-- `User`
-- `WorkflowLog`
-- `_advance_view_status_filter()`
-- `_req_company()`
 - `auth_helper.py`
-- `calculate_user_running_balance()`
-- `get_cash_composition_for_error()`
 
 **Memanggil Fungsi/Modul:**
```

#### `backend/routes/advances/advances_disbursement.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `13` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).
```

#### `backend/routes/advances/advances_items.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `13` | **Lokasi:** `L1`
+**Community Group:** `26` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).
```

#### `backend/routes/advances/advances_other.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `13` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).
```

#### `backend/routes/core/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `205` | **Lokasi:** `L1`
+**Community Group:** `218` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/core/auth.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `30` | **Lokasi:** `L1`
+**Community Group:** `38` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (17 fungsi/metode terdeteksi).
```

#### `backend/routes/core/dashboard.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `27` | **Lokasi:** `L1`
+**Community Group:** `1` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
```

#### `backend/routes/core/notifications.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `110` | **Lokasi:** `L96`
+**Community Group:** `2` | **Lokasi:** `L96`
 
 **Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).
```

#### `backend/routes/master_data/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `207` | **Lokasi:** `L1`
+**Community Group:** `220` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/master_data/bank_management.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `26` | **Lokasi:** `L1`
+**Community Group:** `24` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).
@@ -18,14 +18,5 @@
 **Bergantung Pada (Internal Imports):**
 
-- `BankAccount`
-- `BankTransaction`
-- `Settlement`
-- `TxTemplates`
-- `User`
-- `_req_company()`
 - `auth_helper.py`
-- `get_all_bank_real_balances()`
-- `models/__init__.py`
-- `notify_bank_created()`
 
 **Memanggil Fungsi/Modul:**
```

#### `backend/routes/master_data/bank_status.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `26` | **Lokasi:** `L22`
+**Community Group:** `24` | **Lokasi:** `L22`
 
 **Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).
```

#### `backend/routes/master_data/categories.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `88` | **Lokasi:** `L194`
+**Community Group:** `27` | **Lokasi:** `L194`
 
 **Risiko:** 🟢 **Aman** (12 fungsi/metode terdeteksi).
```

#### `backend/routes/master_data/taxes.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `55` | **Lokasi:** `L1`
+**Community Group:** `111` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).
```

#### `backend/routes/reports/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `31` | **Lokasi:** `L1`
+**Community Group:** `42` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/reports/annual.py`
```diff
@@ -1,11 +1,12 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `126` | **Lokasi:** `L1`
+**Community Group:** `75` | **Lokasi:** `L1`
 
-**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).
 
 **Fungsi / Metode:**
 
 - `_default_report_year()`
+- `export_annual_report_excel()`
 - `get_annual_report()`
 - `get_annual_report_pdf()`
@@ -13,14 +14,7 @@
 **Bergantung Pada (Internal Imports):**
 
-- `Category`
-- `User`
-- `_annual_cache_paths()`
-- `_build_annual_payload_from_db()`
-- `_build_annual_pdf_bytes()`
-- `_is_true()`
-- `_load_annual_payload_cache()`
-- `_parse_iso_date()`
-- `_save_annual_payload_cache()`
-- `_save_annual_pdf_cache()`
+- `get_annual_report_excel()`
+- `parsing_helper.py`
+- `reports/__init__.py`
 
 **Memanggil Fungsi/Modul:**
@@ -28,7 +22,7 @@
 - `_build_annual_payload_from_db()`
 - `_build_annual_pdf_bytes()`
-- `_parse_iso_date()`
 - `_save_annual_payload_cache()`
 - `_save_annual_pdf_cache()`
+- `get_annual_report_excel()`
 
 ---
```

#### `backend/routes/reports/annual_constants.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `44` | **Lokasi:** `L1`
+**Community Group:** `45` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/reports/annual_data.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `64` | **Lokasi:** `L1`
+**Community Group:** `1` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/reports/annual_excel.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `44` | **Lokasi:** `L53`
+**Community Group:** `45` | **Lokasi:** `L53`
 
 **Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).
```

#### `backend/routes/reports/annual_helpers.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `44` | **Lokasi:** `L74`
+**Community Group:** `45` | **Lokasi:** `L74`
 
 **Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).
@@ -7,6 +7,6 @@
 **Fungsi / Metode:**
 
+- `_compute_dividend_distribution_v2()`
 - `_clear_merged_ranges_in_region()`
-- `_compute_dividend_distribution_v2()`
 - `_extract_subcategory_from_description()`
 - `_root_category_info()`
```

#### `backend/routes/reports/annual_tables.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `15` | **Lokasi:** `L1`
+**Community Group:** `20` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/reports/summary.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `31` | **Lokasi:** `L1`
+**Community Group:** `42` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
```

#### `backend/routes/settings/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `27` | **Lokasi:** `L1`
+**Community Group:** `2` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/settings/db_storage.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `27` | **Lokasi:** `L1`
+**Community Group:** `2` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).
```

#### `backend/routes/settings/deadline.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `27` | **Lokasi:** `L1`
+**Community Group:** `2` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
```

#### `backend/routes/settings/profile.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `27` | **Lokasi:** `L13`
+**Community Group:** `2` | **Lokasi:** `L13`
 
 **Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
```

#### `backend/routes/settlements/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `208` | **Lokasi:** `L1`
+**Community Group:** `221` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/settlements/settlements.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `13` | **Lokasi:** `L1`
+**Community Group:** `2` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/settlements/settlements_approval.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `37` | **Lokasi:** `L1`
+**Community Group:** `14` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).
```

#### `backend/routes/settlements/settlements_crud.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `138` | **Lokasi:** `L1`
+**Community Group:** `24` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).
```

#### `backend/routes/settlements/settlements_disbursement.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `13` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).
```

#### `backend/routes/settlements/settlements_expenses.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `13` | **Lokasi:** `L1`
+**Community Group:** `26` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
```

#### `backend/routes/settlements/settlements_other.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `13` | **Lokasi:** `L1`
+**Community Group:** `2` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
```

#### `backend/routes/transactions/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `209` | **Lokasi:** `L1`
+**Community Group:** `222` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/transactions/assets.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `26` | **Lokasi:** `L1`
+**Community Group:** `24` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).
```

#### `backend/routes/transactions/dividends.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `20` | **Lokasi:** `L1`
+**Community Group:** `122` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).
```

#### `backend/routes/transactions/expenses.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `13` | **Lokasi:** `L1`
+**Community Group:** `26` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).
```

#### `backend/routes/transactions/revenues.py`
```diff
@@ -1,7 +1,7 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `55` | **Lokasi:** `L1`
+**Community Group:** `108` | **Lokasi:** `L16`
 
-**Risiko:** 🟢 **Aman** (9 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (10 fungsi/metode terdeteksi).
 
 **Fungsi / Metode:**
@@ -14,4 +14,5 @@
 - `get_revenue_combine_groups()`
 - `get_revenues()`
+- `sync_revenue_bank_transaction()`
 - `toggle_tax_offset()`
 - `update_revenue()`
@@ -19,18 +20,11 @@
 **Bergantung Pada (Internal Imports):**
 
-- `ManualCombineGroup`
-- `Revenue`
-- `User`
-- `_parse_date()`
-- `_parse_float_safe()`
-- `_parse_number_value()`
-- `_req_company()`
-- `_validate_manual_revenue_group()`
 - `auth_helper.py`
-- `models/__init__.py`
+- `parsing_helper.py`
 
 **Memanggil Fungsi/Modul:**
 
 - `.normalize_revenue_type()`
+- `BankTransaction`
 - `ManualCombineGroup`
 - `Revenue`
@@ -41,4 +35,8 @@
 - `_validate_manual_revenue_group()`
 
+**Dipakai Oleh:**
+
+- `backend/tests/test_revenue_bank_sync.py`
+
 ---
 
```

#### `backend/services/advances/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `211` | **Lokasi:** `L1`
+**Community Group:** `224` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/advances/advance_approval_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `14` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).
@@ -8,6 +8,6 @@
 
 - `process_approve_advance()`
+- `process_approve_advance_item()`
 - `process_final_approve_advance()`
-- `process_approve_advance_item()`
 - `process_reject_advance()`
 - `process_reject_advance_item()`
```

#### `backend/services/advances/advance_items_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `13` | **Lokasi:** `L1`
+**Community Group:** `26` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).
```

#### `backend/services/approvals/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `212` | **Lokasi:** `L1`
+**Community Group:** `225` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/approvals/advance_helpers.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `13` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).
@@ -7,11 +7,11 @@
 **Fungsi / Metode:**
 
+- `_advance_view_status_filter()`
 - `get_cash_composition_for_error()`
-- `_items_for_revision()`
+- `normalize_source()`
 - `_next_revision_no()`
-- `normalize_source()`
 - `_status_after_approval()`
 - `_editable_revision_no()`
-- `_advance_view_status_filter()`
+- `_items_for_revision()`
 
 **Bergantung Pada (Internal Imports):**
@@ -31,5 +31,4 @@
 **Dipakai Oleh:**
 
-- `backend/routes/advances/advances_crud.py`
 - `backend/routes/advances/advances_disbursement.py`
 - `backend/routes/advances/advances_items.py`
```

#### `backend/services/approvals/settlement_helpers.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `37` | **Lokasi:** `L7`
+**Community Group:** `14` | **Lokasi:** `L7`
 
 **Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
```

#### `backend/services/balance/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `213` | **Lokasi:** `L1`
+**Community Group:** `226` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/balance/balance_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `26` | **Lokasi:** `L171`
+**Community Group:** `24` | **Lokasi:** `L171`
 
 **Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).
@@ -9,8 +9,8 @@
 - `calculate_bank_composition()`
 - `calculate_bank_real_balance()`
-- `calculate_user_available_budget()`
 - `calculate_user_running_balance()`
 - `calculate_user_running_balance_per_bank()`
 - `_get_user_advance_banks()`
+- `calculate_user_available_budget()`
 - `get_all_bank_real_balances()`
 
@@ -26,12 +26,12 @@
 **Dipakai Oleh:**
 
-- `backend/routes/advances/advances_crud.py`
 - `backend/routes/advances/advances_disbursement.py`
 - `backend/routes/advances/advances_other.py`
 - `backend/routes/core/auth.py`
-- `backend/routes/master_data/bank_management.py`
 - `backend/routes/master_data/bank_status.py`
 - `backend/routes/settlements/settlements_disbursement.py`
 - `backend/services/advances/advance_approval_service.py`
+- `backend/services/advances/advance_items_service.py`
+- `backend/services/approvals/advance_helpers.py`
 
 ---
```

#### `backend/services/balance/user_balance_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `13` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
```

#### `backend/services/core/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `214` | **Lokasi:** `L1`
+**Community Group:** `227` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/core/auth_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `27` | **Lokasi:** `L1`
+**Community Group:** `38` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
```

#### `backend/services/core/email_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `30` | **Lokasi:** `L1`
+**Community Group:** `38` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).
@@ -8,10 +8,9 @@
 
 - `generate_otp()`
+- `init_mail()`
 - `send_reset_password_otp()`
-- `init_mail()`
 
 **Dipakai Oleh:**
 
-- `backend/app.py`
 - `backend/routes/core/auth.py`
 
```

#### `backend/services/core/notification_events.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `32` | **Lokasi:** `L52`
+**Community Group:** `27` | **Lokasi:** `L52`
 
 **Risiko:** 🟢 **Aman** (33 fungsi/metode terdeteksi).
@@ -7,15 +7,17 @@
 **Fungsi / Metode:**
 
-- `notify_advance_approved_final()`
+- `notify_advance_item_approved()`
+- `notify_advance_item_rejected()`
+- `notify_advance_revision_started()`
+- `notify_settlement_approved_item()`
+- `notify_settlement_submitted()`
 - `_can_access_notification()`
+- `notify_bank_transaction_created()`
 - `notify_expense_approved()`
 - `notify_expense_rejected()`
-- `notify_bank_transaction_created()`
 - `create_notification()`
 - `_expense_owner_id()`
-- `notify_advance_item_approved()`
-- `notify_advance_item_rejected()`
+- `notify_advance_approved_final()`
 - `notify_advance_rejected_final()`
-- `notify_advance_revision_started()`
 - `notify_advance_submitted()`
 - `notify_asset_created()`
@@ -23,8 +25,6 @@
 - `notify_asset_updated()`
 - `notify_bank_created()`
-- `notify_category_rejected()`
-- `notify_managers()`
-- `notify_revenue_created()`
-- `notify_revenue_deleted()`
+- `notify_category_approved()`
+- `notify_category_created()`
 - *(... dan 13 fungsi lainnya)*
 
@@ -46,5 +46,4 @@
 - `backend/routes/core/auth.py`
 - `backend/routes/core/notifications.py`
-- `backend/routes/master_data/bank_management.py`
 - `backend/routes/master_data/bank_status.py`
 - `backend/routes/master_data/categories.py`
@@ -52,4 +51,5 @@
 - `backend/services/advances/advance_approval_service.py`
 - `backend/services/core/auth_service.py`
+- `backend/services/settlements/settlement_approval_service.py`
 
 ---
```

#### `backend/services/core/settings_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `27` | **Lokasi:** `L1`
+**Community Group:** `2` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).
```

#### `backend/services/core/storage_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `30` | **Lokasi:** `L41`
+**Community Group:** `38` | **Lokasi:** `L41`
 
 **Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).
```

#### `backend/services/dto/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `215` | **Lokasi:** `L1`
+**Community Group:** `228` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/dto/transaction_dto.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `20` | **Lokasi:** `L297`
+**Community Group:** `2` | **Lokasi:** `L295`
 
 **Risiko:** 🟢 **Aman** (9 fungsi/metode terdeteksi).
@@ -11,5 +11,4 @@
 **Fungsi / Metode:**
 
-- `.manualcombinegroup_to_dict()`
 - `.advance_to_dict()`
 - `.advanceitem_to_dict()`
@@ -20,8 +19,5 @@
 - `.settlement_to_dict()`
 - `.tax_to_dict()`
-
-**Bergantung Pada (Internal Imports):**
-
-- `calculate_user_running_balance()`
+- `.manualcombinegroup_to_dict()`
 
 **Memanggil Fungsi/Modul:**
@@ -32,4 +28,6 @@
 
 - `backend/models/transaction.py`
+- `backend/tests/test_code_hygiene_fixes.py`
+- `backend/tests/test_revenue_bank_sync.py`
 
 ---
```

#### `backend/services/master_data/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `216` | **Lokasi:** `L1`
+**Community Group:** `229` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/reports/annual_service/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `217` | **Lokasi:** `L1`
+**Community Group:** `230` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/reports/annual_service/annual_constants.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `21` | **Lokasi:** `L1`
+**Community Group:** `60` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/reports/annual_service/annual_data.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `64` | **Lokasi:** `L1`
+**Community Group:** `1` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/reports/annual_service/annual_excel.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `21` | **Lokasi:** `L53`
+**Community Group:** `75` | **Lokasi:** `L177`
 
 **Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).
@@ -7,18 +7,18 @@
 **Fungsi / Metode:**
 
+- `_copy_template_row()`
+- `_copy_template_row_from_backup()`
 - `_set_merged_top_alignment()`
 - `_add_image_to_sheet()`
-- `_apply_autofit_sheet1()`
-- `_clone_row_format()`
 - `_clone_sheet_from_template()`
-- `_copy_template_row()`
-- `_copy_template_row_from_backup()`
 - `_ensure_formatted_secondary_sheets()`
 - `_replace_text_in_sheet()`
-- `_safe_merge_cells_sheet()`
 - `_sheet_ref()`
 - `_sum_sheet_column_formula()`
 - `_sync_formatted_secondary_sheets()`
 - `_write_secondary_summary_sheets()`
+- `_apply_autofit_sheet1()`
+- `_clone_row_format()`
+- `_safe_merge_cells_sheet()`
 
 **Bergantung Pada (Internal Imports):**
@@ -51,5 +51,4 @@
 
 - `backend/services/reports/annual_service/caching.py`
-- `backend/services/reports/annual_service/excel_generator.py`
 - `backend/services/reports/table_builder/expense_renderer.py`
 - `backend/services/reports/table_builder/revenue_helpers.py`
```

#### `backend/services/reports/annual_service/annual_helpers.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `21` | **Lokasi:** `L74`
+**Community Group:** `60` | **Lokasi:** `L189`
 
 **Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).
@@ -7,11 +7,11 @@
 **Fungsi / Metode:**
 
-- `_subcategory_sort_key()`
+- `_compute_dividend_distribution_v2()`
 - `_clear_merged_ranges_in_region()`
 - `_extract_subcategory_from_description()`
+- `_subcategory_sort_key()`
+- `_write_dynamic_category_headers()`
 - `_root_category_info()`
 - `_set_dividend_row_border()`
-- `_write_dynamic_category_headers()`
-- `_compute_dividend_distribution_v2()`
 
 **Bergantung Pada (Internal Imports):**
@@ -30,7 +30,7 @@
 - `backend/services/reports/annual_service/annual_tables.py`
 - `backend/services/reports/annual_service/caching.py`
-- `backend/services/reports/annual_service/excel_generator.py`
 - `backend/services/reports/data_fetcher/db_fetchers.py`
 - `backend/services/reports/data_fetcher/depreciation.py`
+- `backend/services/reports/data_fetcher/payload_builder.py`
 
 ---
```

#### `backend/services/reports/annual_service/annual_tables.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `15` | **Lokasi:** `L1`
+**Community Group:** `20` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/reports/annual_service/caching.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `88` | **Lokasi:** `L152`
+**Community Group:** `75` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).
@@ -7,4 +7,5 @@
 **Fungsi / Metode:**
 
+- `clear_annual_report_cache()`
 - `_annual_cache_paths()`
 - `_is_true()`
@@ -12,5 +13,4 @@
 - `_save_annual_payload_cache()`
 - `_save_annual_pdf_cache()`
-- `clear_annual_report_cache()`
 
 **Bergantung Pada (Internal Imports):**
@@ -30,6 +30,4 @@
 
 - `backend/routes/master_data/categories.py`
-- `backend/routes/reports/annual.py`
-- `backend/services/reports/annual_service/excel_generator.py`
 
 ---
```

#### `backend/services/reports/annual_service/excel_generator.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `21` | **Lokasi:** `L506`
+**Community Group:** `75` | **Lokasi:** `L118`
 
 **Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
@@ -11,31 +11,23 @@
 **Bergantung Pada (Internal Imports):**
 
-- `Category`
-- `User`
-- `_add_image_to_sheet()`
-- `_annual_cache_paths()`
-- `_apply_autofit_sheet1()`
-- `_clean_currency()`
-- `_clear_merged_ranges_in_region()`
-- `_clear_range()`
-- `_clear_range_force()`
-- `_clone_row_format()`
+- `report_helpers.py`
 
 **Memanggil Fungsi/Modul:**
 
-- `_add_image_to_sheet()`
 - `_annual_cache_paths()`
-- `_apply_autofit_sheet1()`
 - `_apply_manual_revenue_combine_groups()`
 - `_apply_manual_tax_combine_groups()`
 - `_build_annual_payload_from_db()`
 - `_clean_currency()`
-- `_clear_merged_ranges_in_region()`
 - `_clear_range()`
 - `_clear_range_force()`
+- `_default_report_year()`
+- `_expense_amount_for_display()`
+- `_idr_from_currency()`
 
 **Dipakai Oleh:**
 
 - `backend/routes/reports/annual.py`
+- `backend/tests/test_annual_report_routes.py`
 
 ---
```

#### `backend/services/reports/data_fetcher/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `218` | **Lokasi:** `L1`
+**Community Group:** `231` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/reports/data_fetcher/db_fetchers.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `64` | **Lokasi:** `L1`
+**Community Group:** `1` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (9 fungsi/metode terdeteksi).
```

#### `backend/services/reports/data_fetcher/payload_builder.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `64` | **Lokasi:** `L1`
+**Community Group:** `1` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
@@ -38,5 +38,4 @@
 **Dipakai Oleh:**
 
-- `backend/routes/reports/annual.py`
 - `backend/routes/reports/annual_data.py`
 - `backend/services/reports/annual_service/annual_data.py`
```

#### `backend/services/reports/summary_service/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `219` | **Lokasi:** `L1`
+**Community Group:** `232` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/reports/summary_service/data_helpers.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `31` | **Lokasi:** `L97`
+**Community Group:** `42` | **Lokasi:** `L97`
 
 **Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).
```

#### `backend/services/reports/summary_service/excel_generator.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `31` | **Lokasi:** `L1`
+**Community Group:** `175` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
@@ -12,14 +12,6 @@
 **Bergantung Pada (Internal Imports):**
 
-- `Advance`
-- `AdvanceItem`
-- `Category`
-- `Expense`
-- `Settlement`
-- `User`
-- `_build_summary_payload()`
-- `_default_report_year()`
-- `_get_summary_approved_expenses()`
-- `_parse_iso_date()`
+- `data_helpers.py`
+- `parsing_helper.py`
 
 **Memanggil Fungsi/Modul:**
@@ -28,9 +20,9 @@
 - `_default_report_year()`
 - `_get_summary_approved_expenses()`
-- `_parse_iso_date()`
 
 **Dipakai Oleh:**
 
 - `backend/routes/reports/summary.py`
+- `backend/tests/test_code_hygiene_fixes.py`
 
 ---
```

#### `backend/services/reports/summary_service/pdf_generator.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `31` | **Lokasi:** `L1`
+**Community Group:** `42` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).
```

#### `backend/services/reports/table_builder/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `220` | **Lokasi:** `L1`
+**Community Group:** `233` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/reports/table_builder/expense_renderer.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `15` | **Lokasi:** `L1`
+**Community Group:** `20` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
```

#### `backend/services/reports/table_builder/expense_renderer_utils.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `15` | **Lokasi:** `L50`
+**Community Group:** `60` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).
@@ -7,8 +7,8 @@
 **Fungsi / Metode:**
 
-- `_expense_amount_for_display()`
 - `_expense_column_mapping_name()`
 - `_expense_subcategory_label()`
 - `_group_expenses_by_subcategory()`
+- `_expense_amount_for_display()`
 
 **Bergantung Pada (Internal Imports):**
```

#### `backend/services/reports/table_builder/pdf_builder.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `15` | **Lokasi:** `L1`
+**Community Group:** `20` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
@@ -37,5 +37,4 @@
 **Dipakai Oleh:**
 
-- `backend/routes/reports/annual.py`
 - `backend/routes/reports/annual_tables.py`
 - `backend/services/reports/annual_service/annual_tables.py`
```

#### `backend/services/reports/table_builder/revenue_helpers.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `44` | **Lokasi:** `L334`
+**Community Group:** `75` | **Lokasi:** `L366`
 
 **Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).
@@ -13,6 +13,6 @@
 - `_manual_combine_groups_by_table()`
 - `_operation_cost_totals_by_column()`
+- `_get_revenue_bounds()`
 - `_validate_revenue_data()`
-- `_get_revenue_bounds()`
 
 **Bergantung Pada (Internal Imports):**
```

#### `backend/services/settlements/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `221` | **Lokasi:** `L1`
+**Community Group:** `234` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/settlements/settlement_approval_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `37` | **Lokasi:** `L23`
+**Community Group:** `14` | **Lokasi:** `L23`
 
 **Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).
```

#### `backend/services/transactions/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `222` | **Lokasi:** `L1`
+**Community Group:** `235` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/transactions/dividend_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `20` | **Lokasi:** `L13`
+**Community Group:** `122` | **Lokasi:** `L13`
 
 **Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
```

#### `backend/services/transactions/revenue_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `20` | **Lokasi:** `L1`
+**Community Group:** `1` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
@@ -21,11 +21,7 @@
 - `_req_company()`
 
-**Dipakai Oleh:**
-
-- `backend/routes/transactions/revenues.py`
-
 ---
 
-## 📁 Folder: `backend/utils`
+## 📁 Folder: `backend/tests`
 
-**Tujuan Folder:** Menyimpan fungsi utilitas umum (formatting, perhitungan, auth helpers).
+**Tujuan Folder:** File inti / konfigurasi utama aplikasi backend.
```

#### `backend/utils/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.
 
-**Community Group:** `223` | **Lokasi:** `L1`
+**Community Group:** `236` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/utils/auth_helper.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `27` | **Lokasi:** `L18`
+**Community Group:** `24` | **Lokasi:** `L6`
 
 **Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).
@@ -7,7 +7,7 @@
 **Fungsi / Metode:**
 
-- `_req_company()`
 - `current_user()`
 - `_require_manager()`
+- `_req_company()`
 
 **Bergantung Pada (Internal Imports):**
```

#### `backend/utils/constants.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.
 
-**Community Group:** `157` | **Lokasi:** `L1`
+**Community Group:** `176` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/utils/deadline_worker.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.
 
-**Community Group:** `142` | **Lokasi:** `L23`
+**Community Group:** `2` | **Lokasi:** `L23`
 
 **Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).
```

#### `backend/utils/parsing_helper.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `13` | **Lokasi:** `L45`
+**Community Group:** `26` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (12 fungsi/metode terdeteksi).
@@ -7,7 +7,11 @@
 **Fungsi / Metode:**
 
+- `_parse_date()`
+- `_parse_float_safe()`
+- `_parse_number_value()`
+- `_merge_rejection_notes()`
 - `allowed_file()`
 - `_has_unchecked_checklist()`
-- `_merge_rejection_notes()`
+- `_has_unchecked_return_checklist()`
 - `_parse_category_ids()`
 - `_parse_checklist_notes()`
@@ -15,8 +19,4 @@
 - `_parse_iso_date()`
 - `_year_date_bounds()`
-- `_has_unchecked_return_checklist()`
-- `_parse_date()`
-- `_parse_float_safe()`
-- `_parse_number_value()`
 
 **Dipakai Oleh:**
```

#### `backend/utils/report_helpers.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `70` | **Lokasi:** `L654`
+**Community Group:** `60` | **Lokasi:** `L56`
 
 **Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).
@@ -7,16 +7,18 @@
 **Fungsi / Metode:**
 
+- `_group_annual_expenses()`
+- `_year_date_bounds()`
 - `_as_iso_date()`
+- `_clean_currency()`
 - `_clean_settlement_title()`
 - `_clear_range()`
 - `_extract_imported_row()`
 - `_get_dynamic_row_height()`
-- `_idr_from_currency()`
 - `_is_batch_settlement()`
 - `_map_expense_category_index_from_name()`
 - `_map_expense_column()`
 - `_parse_iso_date()`
+- `_safe_set_cell()`
 - `_safe_set_number()`
-- `_safe_text()`
 - `_set_date_with_format()`
 - `_set_formula_with_format()`
@@ -24,7 +26,5 @@
 - `_shorten()`
 - `_clear_range_force()`
-- `_default_report_year()`
-- `_get_top_left_cell()`
-- `_merge_description_cell()`
+- `_clear_data_keep_formulas()`
 - *(... dan 23 fungsi lainnya)*
 
```

#### `backend/utils/storage.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.
 
-**Community Group:** `13` | **Lokasi:** `L5`
+**Community Group:** `26` | **Lokasi:** `L5`
 
 **Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
```

#### `backend/utils/transaction_templates.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.
 
-**Community Group:** `127` | **Lokasi:** `L1`
+**Community Group:** `128` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (9 fungsi/metode terdeteksi).
@@ -24,5 +24,4 @@
 
 - `backend/routes/advances/advances_other.py`
-- `backend/routes/master_data/bank_management.py`
 
 ---
```

#### `backend/utils/workflow_helper.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `37` | **Lokasi:** `L9`
+**Community Group:** `14` | **Lokasi:** `L9`
 
 **Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
```

---

## Perubahan Frontend (Graphify)
### 📝 Konten Berubah
#### `frontend/lib/controllers/settlement_list_controller.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Controller layer yang memisahkan logika UI dari tampilan Screen.
 
-**Community Group:** `71`
+**Community Group:** `70`
 
 ---
```

#### `frontend/lib/main.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Entry-point aplikasi Flutter. Inisialisasi providers global dan routing.
 
-**Community Group:** `56`
+**Community Group:** `62`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/models/advance_item_model.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Mendefinisikan entitas data agar dapat dikenali dan diproses secara type-safe oleh Dart.
 
-**Community Group:** `72`
+**Community Group:** `71`
 
 ---
```

#### `frontend/lib/models/advance_model.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Mendefinisikan entitas data agar dapat dikenali dan diproses secara type-safe oleh Dart.
 
-**Community Group:** `9`
+**Community Group:** `12`
 
 ---
```

#### `frontend/lib/models/dto/advance_requests.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Mendefinisikan entitas data agar dapat dikenali dan diproses secara type-safe oleh Dart.
 
-**Community Group:** `30`
+**Community Group:** `95`
 
 ---
```

#### `frontend/lib/models/enums.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Mendefinisikan entitas data agar dapat dikenali dan diproses secara type-safe oleh Dart.
 
-**Community Group:** `39`
+**Community Group:** `136`
 
 ---
```

#### `frontend/lib/models/notification_model.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Mendefinisikan entitas data agar dapat dikenali dan diproses secara type-safe oleh Dart.
 
-**Community Group:** `100`
+**Community Group:** `101`
 
 ---
```

#### `frontend/lib/providers/advance/advance_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `4`
+**Community Group:** `17`
 
 ---
```

#### `frontend/lib/providers/advance/advance_provider_finance_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `38`
+**Community Group:** `172`
 
 ---
```

#### `frontend/lib/providers/advance/advance_provider_item_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `143`
+**Community Group:** `152`
 
 ---
```

#### `frontend/lib/providers/advance/advance_provider_list_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `104`
+**Community Group:** `144`
 
 ---
```

#### `frontend/lib/providers/advance/advance_provider_workflow_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `104`
+**Community Group:** `153`
 
 ---
```

#### `frontend/lib/providers/auth/auth_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `24`
+**Community Group:** `23`
 
 ---
```

#### `frontend/lib/providers/core/base_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `45`
+**Community Group:** `102`
 
 ---
```

#### `frontend/lib/providers/core/cascade_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `61`
+**Community Group:** `3`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/providers/core/notification_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `57`
+**Community Group:** `91`
 
 ---
```

#### `frontend/lib/providers/master_data/bank_management_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `89`
+**Community Group:** `92`
 
 ---
```

#### `frontend/lib/providers/master_data/bank_status_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `61`
+**Community Group:** `54`
 
 ---
```

#### `frontend/lib/providers/master_data/tax_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `93`
+**Community Group:** `97`
 
 ---
```

#### `frontend/lib/providers/settlement/settlement_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `23`
+**Community Group:** `3`
 
 ---
```

#### `frontend/lib/providers/settlement/settlement_provider_bank_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `38`
+**Community Group:** `116`
 
 ---
```

#### `frontend/lib/providers/settlement/settlement_provider_category_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `94`
+**Community Group:** `145`
 
 ---
```

#### `frontend/lib/providers/settlement/settlement_provider_crud_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `152`
+**Community Group:** `165`
 
 ---
```

#### `frontend/lib/providers/settlement/settlement_provider_expense_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `38`
+**Community Group:** `137`
 
 ---
```

#### `frontend/lib/providers/settlement/settlement_provider_finance_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `38`
+**Community Group:** `166`
 
 ---
```

#### `frontend/lib/providers/settlement/settlement_provider_list_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `94`
+**Community Group:** `138`
 
 ---
```

#### `frontend/lib/providers/transactions/asset_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `65`
+**Community Group:** `58`
 
 ---
```

#### `frontend/lib/providers/transactions/dividend_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `46`
+**Community Group:** `40`
 
 ---
```

#### `frontend/lib/providers/transactions/revenue_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `95`
+**Community Group:** `98`
 
 ---
```

#### `frontend/lib/screens/advance/advance_detail_actions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `4`
+**Community Group:** `32`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/advance_detail_previews.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `134`
+**Community Group:** `49`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/advance_detail_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `7`
+**Community Group:** `8`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/advances_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `84`
+**Community Group:** `17`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/advances_screen_dialogs.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `84`
+**Community Group:** `9`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/dialogs/dialog_add_category.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `2`
+**Community Group:** `9`
 
 ---
```

#### `frontend/lib/screens/advance/dialogs/dialog_add_item.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `19`
+**Community Group:** `9`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/dialogs/dialog_checklist.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `2`
+**Community Group:** `6`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/dialogs/dialog_comments.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `2`
+**Community Group:** `6`
 
 ---
```

#### `frontend/lib/screens/advance/dialogs/dialog_disbursement_evidence_cell.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `2`
+**Community Group:** `6`
 
 ---
```

#### `frontend/lib/screens/advance/dialogs/dialog_edit_advance.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `9`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/dialogs/dialog_edit_disbursement.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `38`
+**Community Group:** `9`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/dialogs/dialog_evidence.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `4`
+**Community Group:** `9`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/dialogs/dialog_insufficient_balance.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `38`
+**Community Group:** `9`
 
 ---
```

#### `frontend/lib/screens/advance/dialogs/dialog_parse_plain_comments.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `2`
+**Community Group:** `85`
 
 ---
```

#### `frontend/lib/screens/advance/dialogs/dialog_plain_comments.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `2`
+**Community Group:** `32`
 
 ---
```

#### `frontend/lib/screens/advance/dialogs/dialog_workflow_timeline.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `2`
+**Community Group:** `9`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/layouts/advance_detail_layout.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `78`
+**Community Group:** `6`
 
 ---
```

#### `frontend/lib/screens/advance/layouts/advance_detail_tables.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `2`
+**Community Group:** `6`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/widgets/advances_widgets.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `84`
+**Community Group:** `17`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_add_comment_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `6`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_advance_detail_actions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `2`
+**Community Group:** `6`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/widgets/widget_content.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `2`
+**Community Group:** `6`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_empty_state.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `2`
+**Community Group:** `6`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_file_list.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `2`
+**Community Group:** `6`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_insuff_balance_row.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `2`
+**Community Group:** `6`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_mobile_advance_action_bar.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `2`
+**Community Group:** `6`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_scrollable_advance_header.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `84`
+**Community Group:** `130`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_toggle_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `4`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_type_toggle.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `84`
+**Community Group:** `9`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/widgets/widget_warning_box.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `2`
+**Community Group:** `6`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_year_summary_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `84`
+**Community Group:** `17`
 
 ---
```

#### `frontend/lib/screens/auth/loading_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `52`
+**Community Group:** `16`
 
 ---
```

#### `frontend/lib/screens/auth/login_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `53`
+**Community Group:** `47`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/auth/login_widget_gmail_login_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `58`
+**Community Group:** `33`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/auth/login_widget_landscape_intro_panel.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `28`
+**Community Group:** `29`
 
 ---
```

#### `frontend/lib/screens/auth/login_widget_landscape_login_content.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `28`
+**Community Group:** `29`
 
 ---
```

#### `frontend/lib/screens/auth/login_widget_login_brand_icon.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `73`
+**Community Group:** `72`
 
 ---
```

#### `frontend/lib/screens/auth/login_widget_login_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `16`
+**Community Group:** `18`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/auth/login_widget_login_hint_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `4`
 
 ---
```

#### `frontend/lib/screens/auth/login_widget_password_field.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `147`
+**Community Group:** `50`
 
 ---
```

#### `frontend/lib/screens/auth/login_widget_portrait_login_content.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `28`
+**Community Group:** `29`
 
 ---
```

#### `frontend/lib/screens/auth/login_widget_register_link.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `58`
+**Community Group:** `50`
 
 ---
```

#### `frontend/lib/screens/auth/login_widget_username_field.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `106`
 
 ---
```

#### `frontend/lib/screens/auth/register_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `54`
+**Community Group:** `16`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/auth/register_widget_back_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `58`
+**Community Group:** `73`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_company_dropdown.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `79`
+**Community Group:** `95`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_confirm_password_field.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `50`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_email_field.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `173`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_full_name_field.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `106`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_landscape_intro_panel.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `178`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_landscape_register_content.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `34`
+**Community Group:** `48`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_password_field.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `50`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_phone_field.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `139`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_portrait_register_content.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `34`
+**Community Group:** `51`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_register_brand_icon.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `73`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_register_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `58`
+**Community Group:** `50`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_role_dropdown.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `112`
+**Community Group:** `63`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_username_field.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `106`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_workplace_field.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `106`
 
 ---
```

#### `frontend/lib/screens/auth/server_error_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `16`
+**Community Group:** `18`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/dashboard/dashboard_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `16`
+**Community Group:** `18`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/layout/main_layout.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `52`
+**Community Group:** `18`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/layout/main_layout_settlement_list.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `52`
+**Community Group:** `28`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/layout/main_layout_settlement_list_dialogs.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `19`
+**Community Group:** `9`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/layout/main_layout_widgets.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `85`
+**Community Group:** `81`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/main_layout_components/widget_summary_cards.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `10`
+**Community Group:** `3`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/asset_management_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `40`
+**Community Group:** `39`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/bank_advance_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `74`
+**Community Group:** `77`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/bank_management_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `82`
+**Community Group:** `5`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/bank_management_screen_actions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `111`
+**Community Group:** `5`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/bank_management_screen_layout.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `82`
+**Community Group:** `5`
 
 ---
```

#### `frontend/lib/screens/management/bank_management_screen_tables.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `82`
+**Community Group:** `5`
 
 ---
```

#### `frontend/lib/screens/management/bank_status_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `61`
+**Community Group:** `54`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/category_management_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `10`
+**Community Group:** `86`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/category_tabular_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `59`
+**Community Group:** `55`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/dialog_advance_log_book.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `82`
+**Community Group:** `64`
 
 ---
```

#### `frontend/lib/screens/management/dialog_bank_account.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `78`
+**Community Group:** `9`
 
 ---
```

#### `frontend/lib/screens/management/dialog_bank_advance_detail.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `82`
+**Community Group:** `5`
 
 ---
```

#### `frontend/lib/screens/management/dialog_bank_cash_detail.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `78`
+**Community Group:** `5`
 
 ---
```

#### `frontend/lib/screens/management/dialog_bank_cash_log_book.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `78`
+**Community Group:** `5`
 
 ---
```

#### `frontend/lib/screens/management/dialog_edit_advance_balance.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `111`
+**Community Group:** `9`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/dialog_edit_advance_opening_balance.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `19`
+**Community Group:** `5`
 
 ---
```

#### `frontend/lib/screens/management/dialogs/dialog_asset_form.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `40`
+**Community Group:** `9`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/dialogs/dialog_ndpv_table.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `19`
+**Community Group:** `9`
 
 ---
```

#### `frontend/lib/screens/management/dividend_management_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `46`
+**Community Group:** `40`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/logbook_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `79`
+**Community Group:** `109`
 
 ---
```

#### `frontend/lib/screens/management/revenue_management_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `62`
+**Community Group:** `80`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/revenue_management_screen_actions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `45`
+**Community Group:** `80`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/revenue_management_screen_dialogs.dart`
```diff
@@ -1,5 +1,9 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `108`
+**Community Group:** `5`
+
+**Mengkonsumsi Provider:**
+
+- `BankManagementProvider`
 
 ---
```

#### `frontend/lib/screens/management/revenue_management_screen_tables.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `45`
+**Community Group:** `155`
 
 ---
```

#### `frontend/lib/screens/management/tax_management_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `18`
+**Community Group:** `97`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/tax_management_screen_actions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `18`
+**Community Group:** `97`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/tax_management_screen_dialogs.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `18`
+**Community Group:** `117`
 
 ---
```

#### `frontend/lib/screens/management/tax_management_screen_tables.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `108`
+**Community Group:** `117`
 
 ---
```

#### `frontend/lib/screens/management/widget_advance_section.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `103`
+**Community Group:** `5`
 
 ---
```

#### `frontend/lib/screens/management/widget_audit_trail_log_item.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `82`
+**Community Group:** `5`
 
 ---
```

#### `frontend/lib/screens/management/widget_bank_accounts_tab.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `78`
+**Community Group:** `5`
 
 ---
```

#### `frontend/lib/screens/management/widget_group_management_dialog.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `103`
+**Community Group:** `55`
 
 ---
```

#### `frontend/lib/screens/management/widget_kanban_column_dynamic.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `59`
+**Community Group:** `55`
 
 ---
```

#### `frontend/lib/screens/management/widget_section_toggle.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `82`
+**Community Group:** `5`
 
 ---
```

#### `frontend/lib/screens/management/widget_simple_category_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `103`
+**Community Group:** `55`
 
 ---
```

#### `frontend/lib/screens/management/widget_toggle_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `82`
+**Community Group:** `5`
 
 ---
```

#### `frontend/lib/screens/manager/manager_dashboard_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `83`
+**Community Group:** `82`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/manager/manager_settlement_detail_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `80`
+**Community Group:** `66`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/manager/widgets/widget_manager_approval_table.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `148`
+**Community Group:** `62`
 
 ---
```

#### `frontend/lib/screens/manager/widgets/widget_manager_summary_cards.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `114`
+**Community Group:** `112`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/annual_report_helpers.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `63`
+**Community Group:** `34`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/annual_report_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `63`
+**Community Group:** `7`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/reports/annual_report/annual_report_state.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `145`
+**Community Group:** `156`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/annual_report_tables.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `63`
+**Community Group:** `84`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/annual_report_widgets.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `63`
+**Community Group:** `34`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_all_tables.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `90`
+**Community Group:** `84`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_bank_expense_table.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `90`
+**Community Group:** `34`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_cache_info.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `90`
+**Community Group:** `34`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `63`
+**Community Group:** `34`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_display_tables.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `63`
+**Community Group:** `84`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_evidence_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `63`
+**Community Group:** `34`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_expense_table_cell.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `153`
+**Community Group:** `167`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_report_header.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `128`
+**Community Group:** `84`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_show_evidence_popup.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `63`
+**Community Group:** `84`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_status_cell.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `63`
+**Community Group:** `34`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_summary_cards.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `159`
+**Community Group:** `34`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_table4_a_and4_b.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `90`
+**Community Group:** `34`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_table4_c_and4_d.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `90`
+**Community Group:** `34`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_table_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `128`
+**Community Group:** `84`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_tax_toggle_cell.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `63`
+**Community Group:** `34`
 
 ---
```

#### `frontend/lib/screens/reports/report_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `45`
+**Community Group:** `3`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/balance_sheet_settings_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `50`
+**Community Group:** `43`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/data_cleanup_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `60`
+**Community Group:** `52`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/deadline_manager_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `75`
+**Community Group:** `74`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/dialog_custom_bank_order.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `96`
+**Community Group:** `87`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/settings_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `25`
+**Community Group:** `4`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/settings_screen_actions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `17`
+**Community Group:** `80`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/settings_screen_dialogs.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `17`
+**Community Group:** `4`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/settings_screen_layout.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `17`
+**Community Group:** `4`
 
 ---
```

#### `frontend/lib/screens/settings/widget_bank_advance_widget.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `16`
+**Community Group:** `4`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/widget_bank_order_settings_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `17`
+**Community Group:** `4`
 
 ---
```

#### `frontend/lib/screens/settings/widget_cleanup_settings_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `17`
+**Community Group:** `4`
 
 ---
```

#### `frontend/lib/screens/settings/widget_database_settings_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `17`
+**Community Group:** `4`
 
 ---
```

#### `frontend/lib/screens/settings/widget_deadline_settings_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `17`
+**Community Group:** `4`
 
 ---
```

#### `frontend/lib/screens/settings/widget_logbook_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `17`
+**Community Group:** `4`
 
 ---
```

#### `frontend/lib/screens/settings/widget_manager_section.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `17`
+**Community Group:** `4`
 
 ---
```

#### `frontend/lib/screens/settings/widget_profile_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `17`
+**Community Group:** `4`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/widget_report_year_settings_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `17`
+**Community Group:** `4`
 
 ---
```

#### `frontend/lib/screens/settings/widget_storage_settings_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `17`
+**Community Group:** `4`
 
 ---
```

#### `frontend/lib/screens/settings/widget_theme_settings_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `56`
+**Community Group:** `4`
 
 ---
```

#### `frontend/lib/screens/settlement/dialogs/dialog_add_category.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `19`
+**Community Group:** `9`
 
 ---
```

#### `frontend/lib/screens/settlement/dialogs/dialog_add_expense.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `19`
+**Community Group:** `9`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settlement/dialogs/dialog_checklist.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `106`
+**Community Group:** `33`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settlement/dialogs/dialog_comments.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `76`
+**Community Group:** `78`
 
 ---
```

#### `frontend/lib/screens/settlement/dialogs/dialog_edit_disbursement.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `19`
+**Community Group:** `9`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settlement/dialogs/dialog_edit_expense.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `19`
+**Community Group:** `9`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settlement/dialogs/dialog_edit_settlement.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `10`
+**Community Group:** `9`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settlement/dialogs/dialog_evidence.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `10`
+**Community Group:** `9`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settlement/dialogs/dialog_plain_comments.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `76`
+**Community Group:** `78`
 
 ---
```

#### `frontend/lib/screens/settlement/layouts/settlement_detail_layout.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `76`
+**Community Group:** `78`
 
 ---
```

#### `frontend/lib/screens/settlement/layouts/settlement_detail_tables.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `106`
+**Community Group:** `33`
 
 ---
```

#### `frontend/lib/screens/settlement/settlement_detail_actions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `76`
+**Community Group:** `88`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settlement/settlement_detail_previews.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `76`
+**Community Group:** `49`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settlement/settlement_detail_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `8`
+**Community Group:** `88`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settlement/widgets/widget_expense_form_fields.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `124`
+**Community Group:** `139`
 
 ---
```

#### `frontend/lib/screens/settlement/widgets/widget_file_list.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `76`
+**Community Group:** `78`
 
 ---
```

#### `frontend/lib/screens/settlement/widgets/widget_insuff_balance_row.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `76`
+**Community Group:** `78`
 
 ---
```

#### `frontend/lib/screens/settlement/widgets/widget_insufficient_balance_dialog.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `76`
+**Community Group:** `9`
 
 ---
```

#### `frontend/lib/screens/settlement/widgets/widget_settlement_detail_actions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `106`
+**Community Group:** `33`
 
 ---
```

#### `frontend/lib/screens/settlement/widgets/widget_settlement_expense_table.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `115`
+**Community Group:** `113`
 
 ---
```

#### `frontend/lib/screens/settlement/widgets/widget_settlement_summary_cards.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `114`
+**Community Group:** `112`
 
 ---
```

#### `frontend/lib/screens/widgets/common_widgets.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `130`
+**Community Group:** `131`
 
 ---
```

#### `frontend/lib/screens/widgets/page_selector.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `112`
+**Community Group:** `63`
 
 ---
```

#### `frontend/lib/screens/widgets/settlement_detail_widgets.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `131`
+**Community Group:** `67`
 
 ---
```

#### `frontend/lib/screens/widgets/sidebar.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `73`
+**Community Group:** `72`
 
 ---
```

#### `frontend/lib/screens/widgets/transaction_cards.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `35`
+**Community Group:** `73`
 
 ---
```

#### `frontend/lib/screens/widgets/widget_scrollable_settlement_header.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `113`
+**Community Group:** `168`
 
 ---
```

#### `frontend/lib/screens/widgets/widget_sidebar_components.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `52`
+**Community Group:** `73`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/widgets/widget_summary_cards.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `19`
+**Community Group:** `9`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/widgets/widget_toggle_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `85`
+**Community Group:** `81`
 
 ---
```

#### `frontend/lib/screens/widgets/widget_type_toggle.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `19`
+**Community Group:** `9`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/services/api_advances.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `59`
 
 ---
```

#### `frontend/lib/services/api_assets.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `59`
 
 ---
```

#### `frontend/lib/services/api_auth.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `51`
+**Community Group:** `124`
 
 ---
```

#### `frontend/lib/services/api_banks.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `86`
+**Community Group:** `89`
 
 ---
```

#### `frontend/lib/services/api_categories.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `119`
+**Community Group:** `59`
 
 ---
```

#### `frontend/lib/services/api_companies.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `59`
 
 ---
```

#### `frontend/lib/services/api_database.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `85`
 
 ---
```

#### `frontend/lib/services/api_dividends.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `116`
 
 ---
```

#### `frontend/lib/services/api_expenses.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `59`
 
 ---
```

#### `frontend/lib/services/api_master.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `51`
+**Community Group:** `125`
 
 ---
```

#### `frontend/lib/services/api_reports.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `116`
+**Community Group:** `181`
 
 ---
```

#### `frontend/lib/services/api_revenues.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `136`
+**Community Group:** `140`
 
 ---
```

#### `frontend/lib/services/api_service.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `59`
 
 ---
```

#### `frontend/lib/services/api_settlements.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `91`
+**Community Group:** `93`
 
 ---
```

#### `frontend/lib/services/api_taxes.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `146`
 
 ---
```

#### `frontend/lib/services/api_users.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `159`
 
 ---
```

#### `frontend/lib/services/bank_order_preferences.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `97`
+**Community Group:** `99`
 
 ---
```

#### `frontend/lib/services/notification_service.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `57`
+**Community Group:** `147`
 
 ---
```

#### `frontend/lib/theme/app_theme.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `22`
+**Community Group:** `21`
 
 ---
```

#### `frontend/lib/utils/app_dialogs.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `5`
+**Community Group:** `4`
 
 ---
```

#### `frontend/lib/utils/app_formatters.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `101`
+**Community Group:** `103`
 
 ---
```

#### `frontend/lib/utils/app_logger.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `160`
+**Community Group:** `179`
 
 ---
```

#### `frontend/lib/utils/app_snackbar.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `146`
+**Community Group:** `157`
 
 ---
```

#### `frontend/lib/utils/context_extensions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `99`
+**Community Group:** `100`
 
 ---
```

#### `frontend/lib/utils/controller_disposable_wrapper.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Controller layer yang memisahkan logika UI dari tampilan Screen.
 
-**Community Group:** `133`
+**Community Group:** `135`
 
 ---
```

#### `frontend/lib/utils/currency_formatter.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `124`
+**Community Group:** `169`
 
 ---
```

#### `frontend/lib/utils/event_bus.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `149`
+**Community Group:** `160`
 
 ---
```

#### `frontend/lib/utils/exceptions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `198`
+**Community Group:** `208`
 
 ---
```

#### `frontend/lib/utils/file_helper.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `109`
+**Community Group:** `110`
 
 ---
```

#### `frontend/lib/utils/responsive_layout.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `34`
+**Community Group:** `73`
 
 ---
```

#### `frontend/lib/utils/status_colors.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `5`
+**Community Group:** `4`
 
 ---
```

#### `frontend/lib/utils/transaction_templates.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `150`
+**Community Group:** `161`
 
 ---
```

#### `frontend/lib/widgets/account_list_dialog.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `52`
+**Community Group:** `73`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/widgets/app_brand_logo.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `139`
+**Community Group:** `143`
 
 ---
```

#### `frontend/lib/widgets/app_scrollbar.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `43`
+**Community Group:** `37`
 
 ---
```

#### `frontend/lib/widgets/category_preview_dialog.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `137`
+**Community Group:** `141`
 
 ---
```

#### `frontend/lib/widgets/core/_fast_range_picker_dialog.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `67`
+**Community Group:** `61`
 
 ---
```

#### `frontend/lib/widgets/core/_menu_item_label.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `77`
+**Community Group:** `67`
 
 ---
```

#### `frontend/lib/widgets/core/app_date_range_picker.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `67`
+**Community Group:** `61`
 
 ---
```

#### `frontend/lib/widgets/core/cascading_menu_custom.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `77`
+**Community Group:** `63`
 
 ---
```

#### `frontend/lib/widgets/core/cascading_menu_item.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `77`
+**Community Group:** `67`
 
 ---
```

#### `frontend/lib/widgets/core/cascading_status_filter.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `154`
+**Community Group:** `102`
 
 ---
```

#### `frontend/lib/widgets/core/cascading_year_filter.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `125`
+**Community Group:** `126`
 
 ---
```

#### `frontend/lib/widgets/core/format_utils.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `161`
+**Community Group:** `180`
 
 ---
```

#### `frontend/lib/widgets/core/status_filter_chip.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `85`
+**Community Group:** `81`
 
 ---
```

#### `frontend/lib/widgets/core/year_filter_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `141`
+**Community Group:** `148`
 
 ---
```

#### `frontend/lib/widgets/details/evidence_viewer.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `58`
+**Community Group:** `149`
 
 ---
```

#### `frontend/lib/widgets/dialog_create_user.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `81`
+**Community Group:** `79`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/widgets/dialog_edit_user.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `92`
+**Community Group:** `94`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/widgets/image_cropper_dialog.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `102`
+**Community Group:** `76`
 
 ---
```

#### `frontend/lib/widgets/manage_companies_dialog.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `122`
+**Community Group:** `120`
 
 ---
```

#### `frontend/lib/widgets/notification_bell_icon.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `66`
+**Community Group:** `68`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/widgets/user_detail_dialog.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `87`
+**Community Group:** `90`
 
 **Mengkonsumsi Provider:**
```

---

