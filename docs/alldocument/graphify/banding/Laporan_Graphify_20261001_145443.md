# Laporan Perubahan Dokumentasi Graphify
**Tanggal Generate:** 2026-10-01 14:54:43

Laporan ini mendeteksi perubahan pada dokumentasi berbasis Knowledge Graph.

---

## Perubahan Backend (Graphify)
### 🆕 File / Entitas Baru
- `backend/cek_keselarasan_excel_db.py`
- `backend/core/__init__.py`
- `backend/core/database.py`
- `backend/core/rate_limit.py`
- `backend/core/security.py`
- `backend/main.py`
- `backend/routes/core/auth_fastapi.py`
- `backend/routes/master_data/companies_fastapi.py`
- `backend/routes/reports/annual_fastapi.py`
- `backend/schemas/__init__.py`
- `backend/schemas/auth.py`
- `backend/schemas/cleanup.py`
- `backend/schemas/companies.py`
- `backend/schemas/settings.py`
- `backend/tests/test_financial_math_logic.py`

### 📝 Konten Berubah
#### `backend/app.py`
```diff
@@ -1,23 +1,21 @@
 **Tanggung Jawab:** Entry-point server backend. Inisialisasi aplikasi, database, middleware, dan blueprint.
 
-**Community Group:** `56` | **Lokasi:** `L169`
+**Community Group:** `-` | **Lokasi:** `L8`
 
-**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
 
 **Fungsi / Metode:**
 
 - `create_app()`
-- `run_database_integrity_maintenance()`
-- `seed_data()`
 
 **Bergantung Pada (Internal Imports):**
 
-- `config.py`
+- `Config`
+- `configure_database()`
+- `database.py`
 
 **Memanggil Fungsi/Modul:**
 
-- `Category`
-- `User`
-- `init_mail()`
+- `configure_database()`
 
 **Dipakai Oleh:**
@@ -25,4 +23,5 @@
 - `backend/tests/test_annual_report_routes.py`
 - `backend/tests/test_blueprint_routes.py`
+- `backend/tests/test_financial_math_logic.py`
 - `backend/tests/test_revenue_bank_sync.py`
 
```

#### `backend/config.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Mengelola environment variables dan konfigurasi server (database URI, secret key, dll).
 
-**Community Group:** `56` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
@@ -12,8 +12,11 @@
 
 - `backend/app.py`
+- `backend/core/database.py`
+- `backend/core/security.py`
+- `backend/main.py`
+- `backend/routes/advances/advances_disbursement.py`
+- `backend/routes/core/auth_fastapi.py`
+- `backend/routes/settings/db_storage.py`
+- `backend/routes/settings/profile.py`
 
 ---
-
-## 📁 Folder: `backend/models`
-
-**Tujuan Folder:** Mendefinisikan skema database (ORM) dan validasi data dengan SQLAlchemy.
```

#### `backend/models/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
@@ -20,12 +20,12 @@
 **Dipakai Oleh:**
 
+- `backend/routes/advances/advances_approval.py`
+- `backend/routes/advances/advances_crud.py`
 - `backend/routes/advances/advances_disbursement.py`
 - `backend/routes/advances/advances_items.py`
 - `backend/routes/advances/advances_other.py`
-- `backend/routes/core/auth.py`
+- `backend/routes/core/auth_fastapi.py`
 - `backend/routes/core/cleanup.py`
 - `backend/routes/core/dashboard.py`
-- `backend/routes/core/notifications.py`
-- `backend/routes/master_data/bank_status.py`
 
 ---
```

#### `backend/models/banking.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).
@@ -7,12 +7,12 @@
 **Classes / Models:**
 
+- `BankAccount` (L7)
 - `BankTransaction` (L33)
-- `BankAccount` (L7)
 - `BankStatusTransaction` (L98)
 
 **Fungsi / Metode:**
 
+- `.__init__()`
 - `.to_dict()`
-- `.__init__()`
 
 **Bergantung Pada (Internal Imports):**
@@ -23,11 +23,11 @@
 
 - `backend/models/__init__.py`
+- `backend/routes/advances/advances_crud.py`
 - `backend/routes/advances/advances_disbursement.py`
-- `backend/routes/advances/advances_items.py`
 - `backend/routes/advances/advances_other.py`
 - `backend/routes/core/cleanup.py`
+- `backend/routes/master_data/bank_management.py`
 - `backend/routes/master_data/bank_status.py`
 - `backend/routes/settlements/settlements_disbursement.py`
-- `backend/services/advances/advance_approval_service.py`
 
 ---
```

#### `backend/models/base.py`
```diff
@@ -1,10 +1,31 @@
 **Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
-**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).
+
+**Classes / Models:**
+
+- `SQLAlchemyAdapter` (L9)
+
+**Fungsi / Metode:**
+
+- `.engine()`
+- `.create_all()`
+- `.drop_all()`
+
+**Bergantung Pada (Internal Imports):**
+
+- `Base`
+- `database.py`
+- `get_engine()`
+
+**Memanggil Fungsi/Modul:**
+
+- `get_engine()`
 
 **Dipakai Oleh:**
 
+- `backend/models/__init__.py`
 - `backend/models/banking.py`
 - `backend/models/core.py`
```

#### `backend/models/core.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (12 fungsi/metode terdeteksi).
@@ -7,18 +7,18 @@
 **Classes / Models:**
 
+- `Company` (L7)
+- `User` (L23)
 - `CategoryGroup` (L125)
-- `Company` (L7)
 - `Category` (L144)
-- `User` (L23)
 
 **Fungsi / Metode:**
 
 - `.to_dict()`
+- `.__init__()`
+- `.set_password()`
+- `.check_password()`
+- `.last_login_formatted()`
+- `.is_online()`
 - `.full_name()`
-- `.__init__()`
-- `.check_password()`
-- `.is_online()`
-- `.last_login_formatted()`
-- `.set_password()`
 
 **Bergantung Pada (Internal Imports):**
@@ -28,12 +28,12 @@
 **Dipakai Oleh:**
 
+- `backend/core/security.py`
+- `backend/main.py`
 - `backend/models/__init__.py`
+- `backend/routes/advances/advances_approval.py`
+- `backend/routes/advances/advances_crud.py`
 - `backend/routes/advances/advances_disbursement.py`
 - `backend/routes/advances/advances_items.py`
 - `backend/routes/advances/advances_other.py`
-- `backend/routes/core/auth.py`
-- `backend/routes/core/cleanup.py`
-- `backend/routes/core/dashboard.py`
-- `backend/routes/core/notifications.py`
 
 ---
```

#### `backend/models/system.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).
@@ -8,12 +8,12 @@
 
 - `Notification` (L7)
+- `DeadlineSetting` (L59)
 - `WorkflowLog` (L92)
 - `OverrideLog` (L131)
-- `DeadlineSetting` (L59)
 
 **Fungsi / Metode:**
 
+- `.__init__()`
 - `.to_dict()`
-- `.__init__()`
 
 **Bergantung Pada (Internal Imports):**
@@ -24,8 +24,8 @@
 
 - `backend/models/__init__.py`
+- `backend/routes/advances/advances_crud.py`
 - `backend/routes/advances/advances_other.py`
 - `backend/routes/core/cleanup.py`
 - `backend/routes/core/notifications.py`
-- `backend/routes/settings/db_storage.py`
 - `backend/routes/settings/deadline.py`
 - `backend/routes/settings/profile.py`
```

#### `backend/models/transaction.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.
 
-**Community Group:** `1` | **Lokasi:** `L195`
+**Community Group:** `-` | **Lokasi:** `L358`
 
 **Risiko:** 🟢 **Aman** (39 fungsi/metode terdeteksi).
@@ -7,33 +7,33 @@
 **Classes / Models:**
 
+- `Asset` (L7)
 - `Advance` (L44)
 - `AdvanceItem` (L155)
-- `Asset` (L7)
+- `Settlement` (L230)
+- `Expense` (L315)
+- `Revenue` (L394)
+- `Tax` (L481)
+- `ManualCombineGroup` (L528)
 - `Dividend` (L571)
 - `DividendSetting` (L591)
-- `Expense` (L315)
-- `Revenue` (L394)
-- `Settlement` (L230)
-- `Tax` (L481)
-- `ManualCombineGroup` (L528)
 
 **Fungsi / Metode:**
 
+- `.__init__()`
+- `.to_dict()`
+- `.total_amount()`
 - `.approved_amount()`
 - `.base_amount()`
+- `.revision_amount()`
 - `.max_revision_no()`
 - `.rejected_count()`
-- `.revision_amount()`
-- `.to_dict()`
-- `.total_amount()`
 - `.combined_subcategory_label()`
+- `.idr_amount()`
+- `.normalize_revenue_type()`
+- `.idr_invoice_value()`
 - `.idr_amount_received()`
-- `.idr_invoice_value()`
 - `.idr_transaction_value()`
-- `.normalize_revenue_type()`
-- `.__init__()`
-- `.idr_amount()`
+- `.row_ids()`
 - `.merged_columns()`
-- `.row_ids()`
 
 **Bergantung Pada (Internal Imports):**
@@ -57,11 +57,11 @@
 
 - `backend/models/__init__.py`
+- `backend/routes/advances/advances_crud.py`
 - `backend/routes/advances/advances_disbursement.py`
-- `backend/routes/advances/advances_items.py`
 - `backend/routes/advances/advances_other.py`
 - `backend/routes/core/cleanup.py`
 - `backend/routes/core/dashboard.py`
+- `backend/routes/master_data/bank_management.py`
 - `backend/routes/master_data/categories.py`
-- `backend/routes/master_data/taxes.py`
 
 ---
```

#### `backend/routes/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `219` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/advances/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `217` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/advances/advances.py`
```diff
@@ -1,15 +1,7 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `13` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L2`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
 
-**Bergantung Pada (Internal Imports):**
-
-- `advances_approval.py`
-- `advances_crud.py`
-- `advances_disbursement.py`
-- `advances_items.py`
-- `advances_other.py`
-
 ---
```

#### `backend/routes/advances/advances_approval.py`
```diff
@@ -1,30 +1,24 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `14` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
-**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).
 
 **Fungsi / Metode:**
 
-- `approve_advance()`
-- `approve_advance_item()`
-- `final_approve_advance()`
-- `reject_advance()`
-- `reject_advance_item()`
+- `_read_request_data()`
 - `start_revision()`
 - `submit_advance()`
+- `approve_advance()`
+- `reject_advance()`
+- `approve_advance_item()`
+- `reject_advance_item()`
+- `final_approve_advance()`
 
 **Bergantung Pada (Internal Imports):**
 
-- `process_approve_advance()`
-- `process_approve_advance_item()`
-- `process_final_approve_advance()`
-- `process_reject_advance()`
-- `process_reject_advance_item()`
-- `process_start_revision()`
-- `process_submit_advance()`
-
-**Memanggil Fungsi/Modul:**
-
+- `User`
+- `__init__.py`
+- `get_current_user()`
 - `process_approve_advance()`
 - `process_approve_advance_item()`
@@ -37,5 +31,5 @@
 **Dipakai Oleh:**
 
-- `backend/routes/advances/advances.py`
+- `backend/main.py`
 
 ---
```

#### `backend/routes/advances/advances_crud.py`
```diff
@@ -1,20 +1,31 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `13` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
-**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).
 
 **Fungsi / Metode:**
 
+- `_query_int()`
+- `_read_payload()`
+- `list_advances()`
 - `create_advance()`
+- `get_advance()`
+- `update_advance()`
 - `delete_advance()`
-- `get_advance()`
 - `get_advance_history()`
-- `list_advances()`
-- `update_advance()`
 
 **Bergantung Pada (Internal Imports):**
 
-- `auth_helper.py`
+- `Advance`
+- `AdvanceItem`
+- `BankAccount`
+- `User`
+- `WorkflowLog`
+- `__init__.py`
+- `_advance_view_status_filter()`
+- `calculate_user_running_balance()`
+- `get_cash_composition_for_error()`
+- `get_current_user()`
 
 **Memanggil Fungsi/Modul:**
@@ -22,5 +33,4 @@
 - `Advance`
 - `_advance_view_status_filter()`
-- `_req_company()`
 - `calculate_user_running_balance()`
 - `get_cash_composition_for_error()`
@@ -28,5 +38,5 @@
 **Dipakai Oleh:**
 
-- `backend/routes/advances/advances.py`
+- `backend/main.py`
 
 ---
```

#### `backend/routes/advances/advances_disbursement.py`
```diff
@@ -1,13 +1,14 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `13` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
-**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).
 
 **Fungsi / Metode:**
 
-- `approve_disbursement()`
+- `_read_payload()`
 - `save_disbursement()`
 - `save_return()`
+- `approve_disbursement()`
 
 **Bergantung Pada (Internal Imports):**
@@ -15,12 +16,12 @@
 - `Advance`
 - `BankAccount`
+- `Config`
 - `User`
+- `__init__.py`
 - `allowed_file()`
 - `calculate_bank_composition()`
 - `get_cash_composition_for_error()`
+- `get_current_user()`
 - `log_workflow()`
-- `models/__init__.py`
-- `normalize_source()`
-- `update_document_stage()`
 
 **Memanggil Fungsi/Modul:**
@@ -35,5 +36,5 @@
 **Dipakai Oleh:**
 
-- `backend/routes/advances/advances.py`
+- `backend/main.py`
 
 ---
```

#### `backend/routes/advances/advances_items.py`
```diff
@@ -1,40 +1,32 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `26` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
-**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).
 
 **Fungsi / Metode:**
 
+- `_read_payload()`
 - `add_advance_item()`
+- `update_advance_item()`
+- `delete_advance_item()`
 - `bulk_delete_advance_items()`
-- `delete_advance_item()`
-- `update_advance_item()`
 - `update_advance_items_bulk()`
 
 **Bergantung Pada (Internal Imports):**
 
-- `Advance`
-- `AdvanceItem`
 - `AdvanceItemsService`
-- `BankAccount`
-- `Category`
 - `User`
-- `_editable_revision_no()`
-- `_has_unchecked_checklist()`
-- `_items_for_revision()`
-- `_req_company()`
+- `__init__.py`
+- `get_current_user()`
+- `security.py`
 
 **Memanggil Fungsi/Modul:**
 
-- `.add_advance_item()`
-- `.bulk_delete_advance_items()`
 - `.delete_advance_item()`
-- `.update_advance_item()`
-- `.update_advance_items_bulk()`
 
 **Dipakai Oleh:**
 
-- `backend/routes/advances/advances.py`
+- `backend/main.py`
 
 ---
```

#### `backend/routes/advances/advances_other.py`
```diff
@@ -1,15 +1,16 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `13` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
-**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).
 
 **Fungsi / Metode:**
 
+- `_query_int()`
+- `override_advance()`
+- `move_advance_to_draft()`
+- `initialize_balance()`
 - `get_override_logs_list()`
 - `get_user_balances()`
-- `initialize_balance()`
-- `move_advance_to_draft()`
-- `override_advance()`
 
 **Bergantung Pada (Internal Imports):**
@@ -22,5 +23,5 @@
 - `TxTemplates`
 - `User`
-- `auth_helper.py`
+- `__init__.py`
 - `calculate_bank_real_balance()`
 - `calculate_user_available_budget()`
@@ -39,5 +40,5 @@
 **Dipakai Oleh:**
 
-- `backend/routes/advances/advances.py`
+- `backend/main.py`
 
 ---
```

#### `backend/routes/core/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `218` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/core/auth.py`
```diff
@@ -1,53 +1,11 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `38` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
-**Risiko:** 🟢 **Aman** (17 fungsi/metode terdeteksi).
-
-**Fungsi / Metode:**
-
-- `create_user()`
-- `forgot_password()`
-- `get_all_active_advance_balances()`
-- `get_my_outstanding()`
-- `get_user_active_advance_balance()`
-- `get_user_detail()`
-- `google_login()`
-- `google_login_browser()`
-- `link_google()`
-- `list_users()`
-- `login()`
-- `me()`
-- `register()`
-- `reset_password()`
-- `unlink_google()`
-- `update_profile()`
-- `update_user_by_manager()`
+**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
 
 **Bergantung Pada (Internal Imports):**
 
-- `User`
-- `_internal_login()`
-- `allowed_file()`
-- `auth_helper.py`
-- `calculate_user_running_balance()`
-- `current_user()`
-- `generate_otp()`
-- `get_all_users_balance_breakdown()`
-- `get_user_balance_breakdown()`
-- `handle_profile_image_removal()`
-
-**Memanggil Fungsi/Modul:**
-
-- `User`
-- `_internal_login()`
-- `calculate_user_running_balance()`
-- `generate_otp()`
-- `get_all_users_balance_breakdown()`
-- `get_user_balance_breakdown()`
-- `handle_profile_image_removal()`
-- `handle_profile_image_upload()`
-- `notify_user_registered()`
-- `send_reset_password_otp()`
+- `auth_fastapi.py`
 
 ---
```

#### `backend/routes/core/cleanup.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
@@ -7,6 +7,6 @@
 **Fungsi / Metode:**
 
+- `cleanup_preview()`
 - `cleanup_execute()`
-- `cleanup_preview()`
 
 **Bergantung Pada (Internal Imports):**
@@ -16,4 +16,5 @@
 - `Asset`
 - `BankTransaction`
+- `CleanupRequest`
 - `Dividend`
 - `Expense`
@@ -21,9 +22,8 @@
 - `Notification`
 - `Revenue`
-- `Settlement`
 
-**Memanggil Fungsi/Modul:**
+**Dipakai Oleh:**
 
-- `_require_manager()`
+- `backend/main.py`
 
 ---
```

#### `backend/routes/core/dashboard.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
@@ -15,11 +15,11 @@
 - `Settlement`
 - `User`
-- `_req_company()`
-- `auth_helper.py`
-- `models/__init__.py`
+- `__init__.py`
+- `get_current_user()`
+- `security.py`
 
-**Memanggil Fungsi/Modul:**
+**Dipakai Oleh:**
 
-- `_req_company()`
+- `backend/main.py`
 
 ---
```

#### `backend/routes/core/notifications.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `2` | **Lokasi:** `L96`
+**Community Group:** `-` | **Lokasi:** `L160`
 
 **Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).
@@ -7,9 +7,9 @@
 **Fungsi / Metode:**
 
+- `get_notifications()`
+- `mark_notification_as_read()`
+- `mark_all_notifications_as_read()`
 - `delete_notification()`
-- `get_notifications()`
 - `get_unread_count()`
-- `mark_all_notifications_as_read()`
-- `mark_notification_as_read()`
 
 **Bergantung Pada (Internal Imports):**
@@ -17,13 +17,16 @@
 - `Notification`
 - `User`
+- `__init__.py`
 - `_can_access_notification()`
-- `_req_company()`
-- `auth_helper.py`
-- `models/__init__.py`
+- `get_current_user()`
+- `security.py`
 
 **Memanggil Fungsi/Modul:**
 
 - `_can_access_notification()`
-- `_req_company()`
+
+**Dipakai Oleh:**
+
+- `backend/main.py`
 
 ---
```

#### `backend/routes/master_data/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `220` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/master_data/bank_management.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `24` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).
@@ -7,16 +7,25 @@
 **Fungsi / Metode:**
 
+- `list_management_banks()`
 - `create_management_bank()`
+- `update_management_bank()`
+- `delete_management_bank()`
+- `list_management_transactions()`
 - `create_management_transaction()`
-- `delete_management_bank()`
+- `update_management_transaction()`
 - `delete_management_transaction()`
-- `list_management_banks()`
-- `list_management_transactions()`
-- `update_management_bank()`
-- `update_management_transaction()`
 
 **Bergantung Pada (Internal Imports):**
 
-- `auth_helper.py`
+- `BankAccount`
+- `BankTransaction`
+- `Settlement`
+- `TxTemplates`
+- `User`
+- `__init__.py`
+- `get_all_bank_real_balances()`
+- `get_current_user()`
+- `notify_bank_created()`
+- `notify_bank_transaction_created()`
 
 **Memanggil Fungsi/Modul:**
@@ -24,8 +33,11 @@
 - `BankAccount`
 - `BankTransaction`
-- `_req_company()`
 - `get_all_bank_real_balances()`
 - `notify_bank_created()`
 - `notify_bank_transaction_created()`
 
+**Dipakai Oleh:**
+
+- `backend/main.py`
+
 ---
```

#### `backend/routes/master_data/bank_status.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `24` | **Lokasi:** `L22`
+**Community Group:** `-` | **Lokasi:** `L24`
 
 **Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).
@@ -7,9 +7,9 @@
 **Fungsi / Metode:**
 
-- `create_status_transaction()`
-- `delete_status_transaction()`
 - `list_all_banks_for_status()`
 - `list_status_transactions()`
+- `create_status_transaction()`
 - `update_status_transaction()`
+- `delete_status_transaction()`
 
 **Bergantung Pada (Internal Imports):**
@@ -18,16 +18,19 @@
 - `BankStatusTransaction`
 - `User`
-- `_req_company()`
-- `auth_helper.py`
+- `__init__.py`
 - `get_all_bank_real_balances()`
-- `models/__init__.py`
+- `get_current_user()`
 - `notify_bank_transaction_created()`
+- `security.py`
 
 **Memanggil Fungsi/Modul:**
 
 - `BankStatusTransaction`
-- `_req_company()`
 - `get_all_bank_real_balances()`
 - `notify_bank_transaction_created()`
 
+**Dipakai Oleh:**
+
+- `backend/main.py`
+
 ---
```

#### `backend/routes/master_data/categories.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `27` | **Lokasi:** `L194`
+**Community Group:** `-` | **Lokasi:** `L191`
 
 **Risiko:** 🟢 **Aman** (12 fungsi/metode terdeteksi).
@@ -7,16 +7,16 @@
 **Fungsi / Metode:**
 
-- `approve_category()`
-- `create_category()`
+- `list_category_groups()`
 - `create_category_group()`
-- `delete_category()`
+- `update_category_group()`
+- `reorder_category_groups()`
 - `delete_category_group()`
 - `list_categories()`
-- `list_category_groups()`
+- `reorder_categories()`
 - `list_pending()`
-- `reorder_categories()`
-- `reorder_category_groups()`
+- `create_category()`
 - `update_category()`
-- `update_category_group()`
+- `delete_category()`
+- `approve_category()`
 
 **Bergantung Pada (Internal Imports):**
@@ -27,9 +27,9 @@
 - `Expense`
 - `User`
-- `_req_company()`
-- `auth_helper.py`
+- `__init__.py`
 - `clear_annual_report_cache()`
-- `models/__init__.py`
+- `get_current_user()`
 - `notify_category_approved()`
+- `notify_category_created()`
 
 **Memanggil Fungsi/Modul:**
@@ -37,5 +37,4 @@
 - `Category`
 - `CategoryGroup`
-- `_req_company()`
 - `clear_annual_report_cache()`
 - `notify_category_approved()`
@@ -43,3 +42,7 @@
 - `notify_category_rejected()`
 
+**Dipakai Oleh:**
+
+- `backend/main.py`
+
 ---
```

#### `backend/routes/master_data/companies.py`
```diff
@@ -1,25 +1,11 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `132` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
-**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).
-
-**Fungsi / Metode:**
-
-- `create_company()`
-- `delete_company()`
-- `get_companies()`
-- `reorder_companies()`
-- `update_company()`
+**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
 
 **Bergantung Pada (Internal Imports):**
 
-- `Company`
-- `User`
-- `models/__init__.py`
-
-**Memanggil Fungsi/Modul:**
-
-- `Company`
+- `companies_fastapi.py`
 
 ---
```

#### `backend/routes/master_data/taxes.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `111` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).
@@ -7,12 +7,12 @@
 **Fungsi / Metode:**
 
+- `get_taxes()`
+- `get_tax()`
 - `create_tax()`
+- `update_tax()`
+- `delete_tax()`
+- `get_tax_combine_groups()`
 - `create_tax_combine_group()`
-- `delete_tax()`
 - `delete_tax_combine_group()`
-- `get_tax()`
-- `get_tax_combine_groups()`
-- `get_taxes()`
-- `update_tax()`
 
 **Bergantung Pada (Internal Imports):**
@@ -21,11 +21,11 @@
 - `Tax`
 - `User`
+- `__init__.py`
 - `_parse_date()`
 - `_parse_float_safe()`
 - `_parse_number_value()`
-- `_req_company()`
 - `_validate_manual_tax_group()`
-- `auth_helper.py`
-- `models/__init__.py`
+- `get_current_user()`
+- `parsing_helper.py`
 
 **Memanggil Fungsi/Modul:**
@@ -36,6 +36,9 @@
 - `_parse_float_safe()`
 - `_parse_number_value()`
-- `_req_company()`
 - `_validate_manual_tax_group()`
+
+**Dipakai Oleh:**
+
+- `backend/main.py`
 
 ---
```

#### `backend/routes/reports/__init__.py`
```diff
@@ -1,15 +1,7 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `42` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
 
-**Bergantung Pada (Internal Imports):**
-
-- `summary.py`
-
-**Dipakai Oleh:**
-
-- `backend/routes/reports/annual.py`
-
 ---
```

#### `backend/routes/reports/annual.py`
```diff
@@ -1,28 +1,14 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `75` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
-**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
 
-**Fungsi / Metode:**
+**Bergantung Pada (Internal Imports):**
 
-- `_default_report_year()`
+- `annual_fastapi.py`
 - `export_annual_report_excel()`
 - `get_annual_report()`
 - `get_annual_report_pdf()`
 
-**Bergantung Pada (Internal Imports):**
-
-- `get_annual_report_excel()`
-- `parsing_helper.py`
-- `reports/__init__.py`
-
-**Memanggil Fungsi/Modul:**
-
-- `_build_annual_payload_from_db()`
-- `_build_annual_pdf_bytes()`
-- `_save_annual_payload_cache()`
-- `_save_annual_pdf_cache()`
-- `get_annual_report_excel()`
-
 ---
```

#### `backend/routes/reports/annual_constants.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `45` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/reports/annual_data.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/reports/annual_excel.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `45` | **Lokasi:** `L53`
+**Community Group:** `-` | **Lokasi:** `L206`
 
 **Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).
@@ -7,18 +7,18 @@
 **Fungsi / Metode:**
 
+- `_clone_row_format()`
+- `_replace_text_in_sheet()`
+- `_copy_template_row()`
+- `_copy_template_row_from_backup()`
+- `_sum_sheet_column_formula()`
+- `_safe_merge_cells_sheet()`
 - `_add_image_to_sheet()`
 - `_apply_autofit_sheet1()`
-- `_clone_row_format()`
+- `_sheet_ref()`
+- `_write_secondary_summary_sheets()`
+- `_set_merged_top_alignment()`
+- `_sync_formatted_secondary_sheets()`
 - `_clone_sheet_from_template()`
-- `_copy_template_row()`
-- `_copy_template_row_from_backup()`
 - `_ensure_formatted_secondary_sheets()`
-- `_replace_text_in_sheet()`
-- `_safe_merge_cells_sheet()`
-- `_set_merged_top_alignment()`
-- `_sheet_ref()`
-- `_sum_sheet_column_formula()`
-- `_sync_formatted_secondary_sheets()`
-- `_write_secondary_summary_sheets()`
 
 **Bergantung Pada (Internal Imports):**
@@ -26,4 +26,5 @@
 - `Category`
 - `CategoryGroup`
+- `__init__.py`
 - `_clear_merged_ranges_in_region()`
 - `_clear_range_force()`
@@ -33,5 +34,4 @@
 - `_safe_set_cell_with_merge()`
 - `_set_dividend_row_border()`
-- `_to_float()`
 
 **Memanggil Fungsi/Modul:**
```

#### `backend/routes/reports/annual_helpers.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `45` | **Lokasi:** `L74`
+**Community Group:** `-` | **Lokasi:** `L189`
 
 **Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).
@@ -7,11 +7,11 @@
 **Fungsi / Metode:**
 
-- `_compute_dividend_distribution_v2()`
-- `_clear_merged_ranges_in_region()`
 - `_extract_subcategory_from_description()`
 - `_root_category_info()`
+- `_subcategory_sort_key()`
+- `_clear_merged_ranges_in_region()`
+- `_write_dynamic_category_headers()`
 - `_set_dividend_row_border()`
-- `_subcategory_sort_key()`
-- `_write_dynamic_category_headers()`
+- `_compute_dividend_distribution_v2()`
 
 **Bergantung Pada (Internal Imports):**
```

#### `backend/routes/reports/annual_tables.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `20` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
@@ -9,4 +9,5 @@
 - `Category`
 - `ManualCombineGroup`
+- `__init__.py`
 - `_apply_manual_revenue_combine_groups()`
 - `_apply_manual_tax_combine_groups()`
@@ -16,5 +17,4 @@
 - `_clean_settlement_title()`
 - `_clear_merged_ranges_in_region()`
-- `_clear_range()`
 
 ---
```

#### `backend/routes/reports/summary.py`
```diff
@@ -1,12 +1,15 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `42` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
-**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).
 
 **Fungsi / Metode:**
 
+- `_query_int()`
+- `get_summary_report()`
 - `export_summary_pdf()`
-- `get_summary_report()`
+- `export_summary_excel()`
+- `export_advance_excel()`
 
 **Bergantung Pada (Internal Imports):**
@@ -17,20 +20,23 @@
 - `Settlement`
 - `User`
+- `__init__.py`
 - `_build_summary_payload()`
 - `_default_report_year()`
 - `_display_settlement_status()`
 - `_expense_amount_for_summary()`
-- `_get_display_subcategory()`
 
 **Memanggil Fungsi/Modul:**
 
 - `_build_summary_payload()`
+- `_default_report_year()`
 - `_get_summary_approved_expenses()`
 - `_parse_iso_date()`
 - `_year_date_bounds()`
+- `generate_excel_advance_report()`
+- `generate_excel_report()`
 
 **Dipakai Oleh:**
 
-- `backend/routes/reports/__init__.py`
+- `backend/main.py`
 
 ---
```

#### `backend/routes/settings/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `2` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
@@ -7,10 +7,10 @@
 **Bergantung Pada (Internal Imports):**
 
-- `profile.py`
+- `db_storage.py`
 
 **Dipakai Oleh:**
 
+- `backend/main.py`
 - `backend/routes/settings/db_storage.py`
-- `backend/routes/settings/deadline.py`
 
 ---
```

#### `backend/routes/settings/db_storage.py`
```diff
@@ -1,28 +1,28 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `2` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
-**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).
 
 **Fungsi / Metode:**
 
+- `get_storage_directory()`
+- `update_storage_directory()`
 - `export_database()`
+- `import_database_preview()`
 - `import_database_confirm()`
-- `import_database_preview()`
-- `manage_storage()`
 
 **Bergantung Pada (Internal Imports):**
 
-- `DeadlineSetting`
+- `Config`
 - `Expense`
 - `User`
-- `_require_manager()`
-- `auth_helper.py`
-- `models/__init__.py`
-- `settings/__init__.py`
+- `__init__.py`
+- `require_role()`
+- `security.py`
 
-**Memanggil Fungsi/Modul:**
+**Dipakai Oleh:**
 
-- `_require_manager()`
+- `backend/routes/settings/__init__.py`
 
 ---
```

#### `backend/routes/settings/deadline.py`
```diff
@@ -1,11 +1,14 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `2` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
-**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).
 
 **Fungsi / Metode:**
 
-- `manage_deadline_settings()`
+- `_manager_error()`
+- `get_deadline_settings()`
+- `create_deadline_setting()`
+- `update_deadline_setting()`
 
 **Bergantung Pada (Internal Imports):**
@@ -13,11 +16,10 @@
 - `DeadlineSetting`
 - `User`
+- `__init__.py`
 - `_find_deadline_setting()`
 - `_normalize_deadline_rule_key()`
-- `_require_manager()`
 - `_sanitize_deadline_days()`
-- `auth_helper.py`
-- `models/__init__.py`
-- `settings/__init__.py`
+- `get_current_user()`
+- `security.py`
 
 **Memanggil Fungsi/Modul:**
@@ -26,6 +28,9 @@
 - `_find_deadline_setting()`
 - `_normalize_deadline_rule_key()`
-- `_require_manager()`
 - `_sanitize_deadline_days()`
 
+**Dipakai Oleh:**
+
+- `backend/main.py`
+
 ---
```

#### `backend/routes/settings/profile.py`
```diff
@@ -1,22 +1,28 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `2` | **Lokasi:** `L13`
+**Community Group:** `-` | **Lokasi:** `L17`
 
-**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).
 
 **Fungsi / Metode:**
 
 - `get_companies()`
-- `manage_report_year()`
+- `get_report_year()`
+- `update_report_year()`
 
 **Bergantung Pada (Internal Imports):**
 
+- `Config`
 - `DeadlineSetting`
+- `ReportYearUpdate`
 - `User`
-- `models/__init__.py`
+- `__init__.py`
+- `get_current_user()`
+- `security.py`
+- `settings.py`
 
 **Dipakai Oleh:**
 
-- `backend/routes/settings/__init__.py`
+- `backend/main.py`
 
 ---
```

#### `backend/routes/settlements/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `221` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/settlements/settlements.py`
```diff
@@ -1,15 +1,7 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `2` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
 
-**Bergantung Pada (Internal Imports):**
-
-- `settlements_approval.py`
-- `settlements_crud.py`
-- `settlements_disbursement.py`
-- `settlements_expenses.py`
-- `settlements_other.py`
-
 ---
```

#### `backend/routes/settlements/settlements_approval.py`
```diff
@@ -1,18 +1,22 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `14` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
-**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).
 
 **Fungsi / Metode:**
 
+- `_read_request_data()`
+- `submit_settlement()`
 - `approve_settlement()`
 - `complete_settlement()`
+- `reject_all_expenses()`
 - `final_approve_settlement()`
-- `reject_all_expenses()`
-- `submit_settlement()`
 
 **Bergantung Pada (Internal Imports):**
 
+- `User`
+- `__init__.py`
+- `get_current_user()`
 - `process_approve_settlement()`
 - `process_complete_settlement()`
@@ -20,16 +24,14 @@
 - `process_reject_all_expenses()`
 - `process_submit_settlement()`
+- `security.py`
 
 **Memanggil Fungsi/Modul:**
 
-- `process_approve_settlement()`
 - `process_complete_settlement()`
-- `process_final_approve_settlement()`
-- `process_reject_all_expenses()`
 - `process_submit_settlement()`
 
 **Dipakai Oleh:**
 
-- `backend/routes/settlements/settlements.py`
+- `backend/main.py`
 
 ---
```

#### `backend/routes/settlements/settlements_crud.py`
```diff
@@ -1,16 +1,18 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `24` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
-**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).
 
 **Fungsi / Metode:**
 
+- `_query_int()`
+- `_company_or_default()`
+- `list_settlements()`
 - `create_settlement()`
+- `get_settlement()`
+- `update_settlement()`
 - `delete_settlement()`
-- `get_settlement()`
 - `get_settlement_history()`
-- `list_settlements()`
-- `update_settlement()`
 
 **Bergantung Pada (Internal Imports):**
@@ -21,9 +23,9 @@
 - `User`
 - `WorkflowLog`
-- `_req_company()`
+- `__init__.py`
 - `_sync_advance_after_settlement()`
-- `auth_helper.py`
-- `models/__init__.py`
+- `get_current_user()`
 - `rollback_settlement_transactions()`
+- `security.py`
 
 **Memanggil Fungsi/Modul:**
@@ -31,5 +33,4 @@
 - `Expense`
 - `Settlement`
-- `_req_company()`
 - `_sync_advance_after_settlement()`
 - `rollback_settlement_transactions()`
@@ -37,5 +38,5 @@
 **Dipakai Oleh:**
 
-- `backend/routes/settlements/settlements.py`
+- `backend/main.py`
 
 ---
```

#### `backend/routes/settlements/settlements_disbursement.py`
```diff
@@ -1,13 +1,14 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `13` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
-**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).
 
 **Fungsi / Metode:**
 
-- `approve_disbursement()`
+- `_read_payload()`
 - `save_disbursement()`
 - `save_return()`
+- `approve_disbursement()`
 - `standalone_return()`
 
@@ -17,11 +18,11 @@
 - `BankAccount`
 - `BankTransaction`
+- `Config`
 - `OverrideLog`
 - `Settlement`
 - `User`
+- `__init__.py`
 - `allowed_file()`
 - `calculate_bank_composition()`
-- `calculate_bank_real_balance()`
-- `calculate_user_available_budget()`
 
 **Memanggil Fungsi/Modul:**
@@ -32,13 +33,13 @@
 - `Settlement`
 - `allowed_file()`
+- `calculate_bank_composition()`
 - `calculate_bank_real_balance()`
 - `calculate_user_available_budget()`
 - `calculate_user_running_balance()`
 - `get_all_users_balance_breakdown()`
-- `log_workflow()`
 
 **Dipakai Oleh:**
 
-- `backend/routes/settlements/settlements.py`
+- `backend/main.py`
 
 ---
```

#### `backend/routes/settlements/settlements_expenses.py`
```diff
@@ -1,10 +1,11 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `26` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
-**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
 
 **Fungsi / Metode:**
 
+- `_read_payload()`
 - `update_expense()`
 
@@ -14,7 +15,9 @@
 - `Expense`
 - `User`
+- `__init__.py`
 - `_has_unchecked_checklist()`
-- `models/__init__.py`
+- `get_current_user()`
 - `parsing_helper.py`
+- `security.py`
 
 **Memanggil Fungsi/Modul:**
@@ -24,5 +27,5 @@
 **Dipakai Oleh:**
 
-- `backend/routes/settlements/settlements.py`
+- `backend/main.py`
 
 ---
```

#### `backend/routes/settlements/settlements_other.py`
```diff
@@ -1,12 +1,13 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `2` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
-**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).
 
 **Fungsi / Metode:**
 
+- `_read_json()`
+- `override_settlement()`
 - `move_to_draft()`
-- `override_settlement()`
 
 **Bergantung Pada (Internal Imports):**
@@ -14,6 +15,8 @@
 - `Settlement`
 - `User`
-- `models/__init__.py`
+- `__init__.py`
+- `get_current_user()`
 - `rollback_settlement_transactions()`
+- `security.py`
 
 **Memanggil Fungsi/Modul:**
@@ -23,5 +26,5 @@
 **Dipakai Oleh:**
 
-- `backend/routes/settlements/settlements.py`
+- `backend/main.py`
 
 ---
```

#### `backend/routes/transactions/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `222` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/routes/transactions/assets.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `24` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).
@@ -7,8 +7,8 @@
 **Fungsi / Metode:**
 
+- `list_assets()`
 - `create_asset()`
+- `update_asset()`
 - `delete_asset()`
-- `list_assets()`
-- `update_asset()`
 
 **Bergantung Pada (Internal Imports):**
@@ -16,8 +16,8 @@
 - `Asset`
 - `User`
+- `__init__.py`
 - `_calculate_asset_depreciation()`
-- `_req_company()`
-- `auth_helper.py`
-- `models/__init__.py`
+- `get_current_user()`
+- `security.py`
 
 **Memanggil Fungsi/Modul:**
@@ -25,5 +25,8 @@
 - `Asset`
 - `_calculate_asset_depreciation()`
-- `_req_company()`
+
+**Dipakai Oleh:**
+
+- `backend/main.py`
 
 ---
```

#### `backend/routes/transactions/dividends.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `122` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).
@@ -7,10 +7,10 @@
 **Fungsi / Metode:**
 
+- `get_dividends()`
+- `get_dividend()`
 - `create_dividend()`
-- `delete_dividend()`
-- `get_dividend()`
-- `get_dividends()`
 - `update_dividend()`
 - `update_dividend_setting()`
+- `delete_dividend()`
 
 **Bergantung Pada (Internal Imports):**
@@ -22,8 +22,8 @@
 - `Settlement`
 - `User`
+- `__init__.py`
 - `_build_dividend_payload()`
 - `_compute_dividend_distribution_v2()`
 - `_fetch_revenues_and_expenses_for_year()`
-- `_parse_date()`
 
 **Memanggil Fungsi/Modul:**
@@ -34,5 +34,8 @@
 - `_parse_date()`
 - `_parse_float_safe()`
-- `_req_company()`
+
+**Dipakai Oleh:**
+
+- `backend/main.py`
 
 ---
```

#### `backend/routes/transactions/expenses.py`
```diff
@@ -1,31 +1,38 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `26` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L25`
 
-**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (15 fungsi/metode terdeteksi).
 
 **Fungsi / Metode:**
 
+- `_form_payload()`
+- `_form_int()`
+- `_form_float()`
+- `_optional_int()`
+- `_optional_float()`
+- `_save_upload()`
+- `_evidence_response()`
+- `create_expense()`
+- `update_expense()`
+- `bulk_delete_expenses()`
+- `delete_expense()`
 - `approve_expense()`
-- `bulk_delete_expenses()`
-- `create_expense()`
-- `delete_expense()`
-- `list_categories()`
 - `reject_expense()`
 - `serve_evidence()`
-- `update_expense()`
+- `list_categories()`
 
 **Bergantung Pada (Internal Imports):**
 
 - `Category`
+- `Config`
 - `Expense`
 - `Settlement`
 - `User`
-- `_merge_rejection_notes()`
+- `__init__.py`
 - `_parse_category_ids()`
-- `_parse_checklist_notes()`
-- `_req_company()`
 - `allowed_file()`
-- `auth_helper.py`
+- `delete_evidence_file()`
+- `get_current_user()`
 
 **Memanggil Fungsi/Modul:**
@@ -34,5 +41,4 @@
 - `_merge_rejection_notes()`
 - `_parse_category_ids()`
-- `_req_company()`
 - `allowed_file()`
 - `delete_evidence_file()`
@@ -40,3 +46,7 @@
 - `notify_expense_rejected()`
 
+**Dipakai Oleh:**
+
+- `backend/main.py`
+
 ---
```

#### `backend/routes/transactions/revenues.py`
```diff
@@ -1,25 +1,34 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `108` | **Lokasi:** `L16`
+**Community Group:** `-` | **Lokasi:** `L17`
 
-**Risiko:** 🟢 **Aman** (10 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (11 fungsi/metode terdeteksi).
 
 **Fungsi / Metode:**
 
+- `sync_revenue_bank_transaction()`
+- `get_revenues()`
+- `get_revenue()`
 - `create_revenue()`
+- `update_revenue()`
+- `toggle_tax_offset()`
+- `delete_revenue()`
+- `get_revenue_combine_groups()`
 - `create_revenue_combine_group()`
-- `delete_revenue()`
 - `delete_revenue_combine_group()`
-- `get_revenue()`
-- `get_revenue_combine_groups()`
-- `get_revenues()`
-- `sync_revenue_bank_transaction()`
-- `toggle_tax_offset()`
-- `update_revenue()`
+- `_query_int()`
 
 **Bergantung Pada (Internal Imports):**
 
-- `auth_helper.py`
-- `parsing_helper.py`
+- `BankTransaction`
+- `ManualCombineGroup`
+- `Revenue`
+- `User`
+- `__init__.py`
+- `_parse_date()`
+- `_parse_float_safe()`
+- `_parse_number_value()`
+- `_validate_manual_revenue_group()`
+- `get_current_user()`
 
 **Memanggil Fungsi/Modul:**
@@ -32,14 +41,14 @@
 - `_parse_float_safe()`
 - `_parse_number_value()`
-- `_req_company()`
 - `_validate_manual_revenue_group()`
 
 **Dipakai Oleh:**
 
+- `backend/main.py`
 - `backend/tests/test_revenue_bank_sync.py`
 
 ---
 
-## 📁 Folder: `backend/services/advances`
+## 📁 Folder: `backend/schemas`
 
-**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.
+**Tujuan Folder:** File inti / konfigurasi utama aplikasi backend.
```

#### `backend/services/advances/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `224` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/advances/advance_approval_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `14` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).
@@ -7,11 +7,11 @@
 **Fungsi / Metode:**
 
-- `process_approve_advance()`
-- `process_approve_advance_item()`
-- `process_final_approve_advance()`
-- `process_reject_advance()`
-- `process_reject_advance_item()`
 - `process_start_revision()`
 - `process_submit_advance()`
+- `process_approve_advance()`
+- `process_reject_advance()`
+- `process_approve_advance_item()`
+- `process_reject_advance_item()`
+- `process_final_approve_advance()`
 
 **Bergantung Pada (Internal Imports):**
@@ -25,6 +25,6 @@
 - `Settlement`
 - `User`
+- `__init__.py`
 - `_advance_view_status_filter()`
-- `_editable_revision_no()`
 
 **Memanggil Fungsi/Modul:**
```

#### `backend/services/advances/advance_items_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `26` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).
@@ -12,7 +12,7 @@
 
 - `.add_advance_item()`
+- `.update_advance_item()`
+- `.delete_advance_item()`
 - `.bulk_delete_advance_items()`
-- `.delete_advance_item()`
-- `.update_advance_item()`
 - `.update_advance_items_bulk()`
 
@@ -23,9 +23,9 @@
 - `BankAccount`
 - `Category`
-- `User`
+- `Config`
+- `__init__.py`
 - `_editable_revision_no()`
 - `_has_unchecked_checklist()`
 - `_items_for_revision()`
-- `_req_company()`
 - `allowed_file()`
 
@@ -36,5 +36,4 @@
 - `_has_unchecked_checklist()`
 - `_items_for_revision()`
-- `_req_company()`
 - `allowed_file()`
 - `calculate_bank_real_balance()`
```

#### `backend/services/approvals/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `225` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/approvals/advance_helpers.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `13` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).
@@ -7,11 +7,11 @@
 **Fungsi / Metode:**
 
-- `_advance_view_status_filter()`
 - `get_cash_composition_for_error()`
 - `normalize_source()`
+- `_advance_view_status_filter()`
+- `_editable_revision_no()`
+- `_items_for_revision()`
 - `_next_revision_no()`
 - `_status_after_approval()`
-- `_editable_revision_no()`
-- `_items_for_revision()`
 
 **Bergantung Pada (Internal Imports):**
@@ -20,7 +20,7 @@
 - `AdvanceItem`
 - `BankAccount`
+- `__init__.py`
 - `calculate_bank_composition()`
 - `calculate_bank_real_balance()`
-- `models/__init__.py`
 
 **Memanggil Fungsi/Modul:**
@@ -31,6 +31,6 @@
 **Dipakai Oleh:**
 
+- `backend/routes/advances/advances_crud.py`
 - `backend/routes/advances/advances_disbursement.py`
-- `backend/routes/advances/advances_items.py`
 - `backend/routes/settlements/settlements_disbursement.py`
 - `backend/services/advances/advance_approval_service.py`
```

#### `backend/services/approvals/settlement_helpers.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `14` | **Lokasi:** `L7`
+**Community Group:** `-` | **Lokasi:** `L7`
 
 **Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
@@ -7,6 +7,6 @@
 **Fungsi / Metode:**
 
+- `_sync_advance_after_settlement()`
 - `rollback_settlement_transactions()`
-- `_sync_advance_after_settlement()`
 
 **Bergantung Pada (Internal Imports):**
@@ -15,9 +15,9 @@
 - `BankTransaction`
 - `OverrideLog`
+- `__init__.py`
 - `calculate_user_available_budget()`
 - `calculate_user_running_balance()`
 - `get_all_users_balance_breakdown()`
 - `log_workflow()`
-- `models/__init__.py`
 - `workflow_helper.py`
 
```

#### `backend/services/balance/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `226` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/balance/balance_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `24` | **Lokasi:** `L171`
+**Community Group:** `-` | **Lokasi:** `L241`
 
 **Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).
@@ -7,11 +7,11 @@
 **Fungsi / Metode:**
 
+- `calculate_bank_real_balance()`
+- `_get_user_advance_banks()`
+- `calculate_user_running_balance()`
+- `calculate_user_available_budget()`
+- `calculate_user_running_balance_per_bank()`
+- `get_all_bank_real_balances()`
 - `calculate_bank_composition()`
-- `calculate_bank_real_balance()`
-- `calculate_user_running_balance()`
-- `calculate_user_running_balance_per_bank()`
-- `_get_user_advance_banks()`
-- `calculate_user_available_budget()`
-- `get_all_bank_real_balances()`
 
 **Bergantung Pada (Internal Imports):**
@@ -22,16 +22,16 @@
 - `Settlement`
 - `User`
-- `models/__init__.py`
+- `__init__.py`
 
 **Dipakai Oleh:**
 
+- `backend/routes/advances/advances_crud.py`
 - `backend/routes/advances/advances_disbursement.py`
 - `backend/routes/advances/advances_other.py`
-- `backend/routes/core/auth.py`
+- `backend/routes/core/auth_fastapi.py`
+- `backend/routes/master_data/bank_management.py`
 - `backend/routes/master_data/bank_status.py`
 - `backend/routes/settlements/settlements_disbursement.py`
 - `backend/services/advances/advance_approval_service.py`
-- `backend/services/advances/advance_items_service.py`
-- `backend/services/approvals/advance_helpers.py`
 
 ---
```

#### `backend/services/balance/user_balance_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `13` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
@@ -16,8 +16,8 @@
 - `Settlement`
 - `User`
+- `__init__.py`
 - `calculate_bank_composition()`
 - `calculate_bank_real_balance()`
 - `calculate_user_running_balance()`
-- `models/__init__.py`
 
 **Memanggil Fungsi/Modul:**
@@ -29,5 +29,5 @@
 **Dipakai Oleh:**
 
-- `backend/routes/core/auth.py`
+- `backend/routes/core/auth_fastapi.py`
 - `backend/routes/settlements/settlements_disbursement.py`
 - `backend/services/advances/advance_approval_service.py`
```

#### `backend/services/core/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `227` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/core/auth_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `38` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
@@ -12,14 +12,17 @@
 
 - `User`
-- `models/__init__.py`
+- `__init__.py`
+- `create_access_token()`
 - `notify_user_returned()`
+- `security.py`
 
 **Memanggil Fungsi/Modul:**
 
+- `create_access_token()`
 - `notify_user_returned()`
 
 **Dipakai Oleh:**
 
-- `backend/routes/core/auth.py`
+- `backend/routes/core/auth_fastapi.py`
 
 ---
```

#### `backend/services/core/email_service.py`
```diff
@@ -1,17 +1,27 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `38` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L42`
 
-**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).
+**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).
+
+**Classes / Models:**
+
+- `Message` (L16)
+- `_MailSender` (L22)
 
 **Fungsi / Metode:**
 
+- `.send()`
+- `init_mail()`
 - `generate_otp()`
-- `init_mail()`
 - `send_reset_password_otp()`
+
+**Bergantung Pada (Internal Imports):**
+
+- `Config`
 
 **Dipakai Oleh:**
 
-- `backend/routes/core/auth.py`
+- `backend/routes/core/auth_fastapi.py`
 
 ---
```

#### `backend/services/core/notification_events.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `27` | **Lokasi:** `L52`
+**Community Group:** `-` | **Lokasi:** `L344`
 
 **Risiko:** 🟢 **Aman** (33 fungsi/metode terdeteksi).
@@ -7,24 +7,24 @@
 **Fungsi / Metode:**
 
+- `create_notification()`
+- `notify_managers()`
+- `notify_staff()`
+- `notify_advance_submitted()`
+- `notify_advance_revision_started()`
+- `notify_advance_approved_final()`
+- `notify_advance_rejected_final()`
 - `notify_advance_item_approved()`
 - `notify_advance_item_rejected()`
-- `notify_advance_revision_started()`
+- `notify_settlement_submitted()`
 - `notify_settlement_approved_item()`
-- `notify_settlement_submitted()`
-- `_can_access_notification()`
-- `notify_bank_transaction_created()`
+- `notify_settlement_rejected()`
+- `notify_settlement_approved_final()`
+- `_expense_owner_id()`
 - `notify_expense_approved()`
 - `notify_expense_rejected()`
-- `create_notification()`
-- `_expense_owner_id()`
-- `notify_advance_approved_final()`
-- `notify_advance_rejected_final()`
-- `notify_advance_submitted()`
-- `notify_asset_created()`
-- `notify_asset_deleted()`
-- `notify_asset_updated()`
-- `notify_bank_created()`
+- `notify_category_created()`
 - `notify_category_approved()`
-- `notify_category_created()`
+- `notify_category_rejected()`
+- `notify_user_registered()`
 - *(... dan 13 fungsi lainnya)*
 
@@ -33,17 +33,15 @@
 - `Notification`
 - `User`
-- `_req_company()`
-- `auth_helper.py`
-- `models/__init__.py`
+- `__init__.py`
 
 **Memanggil Fungsi/Modul:**
 
 - `Notification`
-- `_req_company()`
 
 **Dipakai Oleh:**
 
-- `backend/routes/core/auth.py`
+- `backend/routes/core/auth_fastapi.py`
 - `backend/routes/core/notifications.py`
+- `backend/routes/master_data/bank_management.py`
 - `backend/routes/master_data/bank_status.py`
 - `backend/routes/master_data/categories.py`
@@ -51,5 +49,4 @@
 - `backend/services/advances/advance_approval_service.py`
 - `backend/services/core/auth_service.py`
-- `backend/services/settlements/settlement_approval_service.py`
 
 ---
```

#### `backend/services/core/settings_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `2` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).
@@ -7,6 +7,6 @@
 **Fungsi / Metode:**
 
+- `_normalize_deadline_rule_key()`
 - `_find_deadline_setting()`
-- `_normalize_deadline_rule_key()`
 - `_sanitize_deadline_days()`
 
@@ -14,5 +14,5 @@
 
 - `DeadlineSetting`
-- `models/__init__.py`
+- `__init__.py`
 
 **Dipakai Oleh:**
```

#### `backend/services/core/storage_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `38` | **Lokasi:** `L41`
+**Community Group:** `-` | **Lokasi:** `L46`
 
 **Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).
@@ -8,11 +8,14 @@
 
 - `allowed_file()`
+- `handle_profile_image_upload()`
 - `handle_profile_image_removal()`
-- `handle_profile_image_upload()`
+
+**Bergantung Pada (Internal Imports):**
+
+- `Config`
 
 **Dipakai Oleh:**
 
 - `backend/routes/advances/advances_disbursement.py`
-- `backend/routes/core/auth.py`
 - `backend/routes/settlements/settlements_disbursement.py`
 
```

#### `backend/services/dto/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `228` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/dto/transaction_dto.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `2` | **Lokasi:** `L295`
+**Community Group:** `-` | **Lokasi:** `L285`
 
 **Risiko:** 🟢 **Aman** (9 fungsi/metode terdeteksi).
@@ -7,5 +7,5 @@
 **Classes / Models:**
 
-- `TransactionDTO` (L7)
+- `TransactionDTO` (L6)
 
 **Fungsi / Metode:**
@@ -13,11 +13,15 @@
 - `.advance_to_dict()`
 - `.advanceitem_to_dict()`
+- `.settlement_to_dict()`
+- `.expense_to_dict()`
+- `.revenue_to_dict()`
+- `.tax_to_dict()`
+- `.manualcombinegroup_to_dict()`
 - `.dividend_to_dict()`
 - `.dividendsetting_to_dict()`
-- `.expense_to_dict()`
-- `.revenue_to_dict()`
-- `.settlement_to_dict()`
-- `.tax_to_dict()`
-- `.manualcombinegroup_to_dict()`
+
+**Bergantung Pada (Internal Imports):**
+
+- `calculate_user_running_balance()`
 
 **Memanggil Fungsi/Modul:**
```

#### `backend/services/master_data/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `229` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/master_data/tax_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
@@ -13,11 +13,5 @@
 - `ManualCombineGroup`
 - `Tax`
-- `_req_company()`
-- `auth_helper.py`
-- `models/__init__.py`
-
-**Memanggil Fungsi/Modul:**
-
-- `_req_company()`
+- `__init__.py`
 
 **Dipakai Oleh:**
```

#### `backend/services/reports/annual_service/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `230` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/reports/annual_service/annual_constants.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `60` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/reports/annual_service/annual_data.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/reports/annual_service/annual_excel.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `75` | **Lokasi:** `L177`
+**Community Group:** `-` | **Lokasi:** `L206`
 
 **Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).
@@ -7,18 +7,18 @@
 **Fungsi / Metode:**
 
+- `_clone_row_format()`
+- `_replace_text_in_sheet()`
 - `_copy_template_row()`
 - `_copy_template_row_from_backup()`
+- `_sum_sheet_column_formula()`
+- `_safe_merge_cells_sheet()`
+- `_add_image_to_sheet()`
+- `_apply_autofit_sheet1()`
+- `_sheet_ref()`
+- `_write_secondary_summary_sheets()`
 - `_set_merged_top_alignment()`
-- `_add_image_to_sheet()`
+- `_sync_formatted_secondary_sheets()`
 - `_clone_sheet_from_template()`
 - `_ensure_formatted_secondary_sheets()`
-- `_replace_text_in_sheet()`
-- `_sheet_ref()`
-- `_sum_sheet_column_formula()`
-- `_sync_formatted_secondary_sheets()`
-- `_write_secondary_summary_sheets()`
-- `_apply_autofit_sheet1()`
-- `_clone_row_format()`
-- `_safe_merge_cells_sheet()`
 
 **Bergantung Pada (Internal Imports):**
@@ -26,4 +26,5 @@
 - `Category`
 - `CategoryGroup`
+- `__init__.py`
 - `_clear_merged_ranges_in_region()`
 - `_clear_range_force()`
@@ -33,5 +34,4 @@
 - `_safe_set_cell_with_merge()`
 - `_set_dividend_row_border()`
-- `_to_float()`
 
 **Memanggil Fungsi/Modul:**
@@ -50,5 +50,5 @@
 **Dipakai Oleh:**
 
-- `backend/services/reports/annual_service/caching.py`
+- `backend/services/reports/annual_service/excel_generator.py`
 - `backend/services/reports/table_builder/expense_renderer.py`
 - `backend/services/reports/table_builder/revenue_helpers.py`
```

#### `backend/services/reports/annual_service/annual_helpers.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `60` | **Lokasi:** `L189`
+**Community Group:** `-` | **Lokasi:** `L189`
 
 **Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).
@@ -7,11 +7,11 @@
 **Fungsi / Metode:**
 
+- `_extract_subcategory_from_description()`
+- `_root_category_info()`
+- `_subcategory_sort_key()`
+- `_clear_merged_ranges_in_region()`
+- `_write_dynamic_category_headers()`
+- `_set_dividend_row_border()`
 - `_compute_dividend_distribution_v2()`
-- `_clear_merged_ranges_in_region()`
-- `_extract_subcategory_from_description()`
-- `_subcategory_sort_key()`
-- `_write_dynamic_category_headers()`
-- `_root_category_info()`
-- `_set_dividend_row_border()`
 
 **Bergantung Pada (Internal Imports):**
@@ -29,5 +29,5 @@
 - `backend/services/reports/annual_service/annual_excel.py`
 - `backend/services/reports/annual_service/annual_tables.py`
-- `backend/services/reports/annual_service/caching.py`
+- `backend/services/reports/annual_service/excel_generator.py`
 - `backend/services/reports/data_fetcher/db_fetchers.py`
 - `backend/services/reports/data_fetcher/depreciation.py`
```

#### `backend/services/reports/annual_service/annual_tables.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `20` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
@@ -9,4 +9,5 @@
 - `Category`
 - `ManualCombineGroup`
+- `__init__.py`
 - `_apply_manual_revenue_combine_groups()`
 - `_apply_manual_tax_combine_groups()`
@@ -16,5 +17,4 @@
 - `_clean_settlement_title()`
 - `_clear_merged_ranges_in_region()`
-- `_clear_range()`
 
 ---
```

#### `backend/services/reports/annual_service/caching.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `75` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L55`
 
 **Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).
@@ -7,27 +7,16 @@
 **Fungsi / Metode:**
 
-- `clear_annual_report_cache()`
+- `_is_true()`
 - `_annual_cache_paths()`
-- `_is_true()`
 - `_load_annual_payload_cache()`
 - `_save_annual_payload_cache()`
 - `_save_annual_pdf_cache()`
-
-**Bergantung Pada (Internal Imports):**
-
-- `Category`
-- `User`
-- `_add_image_to_sheet()`
-- `_apply_autofit_sheet1()`
-- `_clean_currency()`
-- `_clear_merged_ranges_in_region()`
-- `_clear_range()`
-- `_clear_range_force()`
-- `_clone_row_format()`
-- `_copy_template_row_from_backup()`
+- `clear_annual_report_cache()`
 
 **Dipakai Oleh:**
 
 - `backend/routes/master_data/categories.py`
+- `backend/routes/reports/annual_fastapi.py`
+- `backend/services/reports/annual_service/excel_generator.py`
 
 ---
```

#### `backend/services/reports/annual_service/excel_generator.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `75` | **Lokasi:** `L118`
+**Community Group:** `-` | **Lokasi:** `L497`
 
 **Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
@@ -11,22 +11,31 @@
 **Bergantung Pada (Internal Imports):**
 
-- `report_helpers.py`
+- `Category`
+- `__init__.py`
+- `_add_image_to_sheet()`
+- `_annual_cache_paths()`
+- `_apply_autofit_sheet1()`
+- `_clean_currency()`
+- `_clear_merged_ranges_in_region()`
+- `_clear_range()`
+- `_clear_range_force()`
+- `_clone_row_format()`
 
 **Memanggil Fungsi/Modul:**
 
+- `_add_image_to_sheet()`
 - `_annual_cache_paths()`
+- `_apply_autofit_sheet1()`
 - `_apply_manual_revenue_combine_groups()`
 - `_apply_manual_tax_combine_groups()`
 - `_build_annual_payload_from_db()`
 - `_clean_currency()`
+- `_clear_merged_ranges_in_region()`
 - `_clear_range()`
 - `_clear_range_force()`
-- `_default_report_year()`
-- `_expense_amount_for_display()`
-- `_idr_from_currency()`
 
 **Dipakai Oleh:**
 
-- `backend/routes/reports/annual.py`
+- `backend/routes/reports/annual_fastapi.py`
 - `backend/tests/test_annual_report_routes.py`
 
```

#### `backend/services/reports/data_fetcher/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `231` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/reports/data_fetcher/db_fetchers.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (9 fungsi/metode terdeteksi).
@@ -7,13 +7,13 @@
 **Fungsi / Metode:**
 
-- `_fetch_advance_items_data()`
+- `_tagged_ids_for_year()`
+- `_has_any_report_tags()`
+- `_fetch_revenue_data()`
+- `_fetch_expense_data()`
 - `_fetch_asset_data()`
 - `_fetch_bank_transaction_data()`
+- `_fetch_tax_data()`
+- `_fetch_advance_items_data()`
 - `_fetch_dividend_data()`
-- `_fetch_expense_data()`
-- `_fetch_revenue_data()`
-- `_fetch_tax_data()`
-- `_has_any_report_tags()`
-- `_tagged_ids_for_year()`
 
 **Bergantung Pada (Internal Imports):**
```

#### `backend/services/reports/data_fetcher/depreciation.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
```

#### `backend/services/reports/data_fetcher/payload_builder.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
@@ -7,6 +7,6 @@
 **Fungsi / Metode:**
 
+- `_compute_dividend_distribution()`
 - `_build_annual_payload_from_db()`
-- `_compute_dividend_distribution()`
 
 **Bergantung Pada (Internal Imports):**
@@ -39,4 +39,5 @@
 
 - `backend/routes/reports/annual_data.py`
+- `backend/routes/reports/annual_fastapi.py`
 - `backend/services/reports/annual_service/annual_data.py`
 
```

#### `backend/services/reports/summary_service/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `232` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/reports/summary_service/data_helpers.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `42` | **Lokasi:** `L97`
+**Community Group:** `-` | **Lokasi:** `L97`
 
 **Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).
@@ -7,11 +7,11 @@
 **Fungsi / Metode:**
 
-- `_build_summary_payload()`
+- `_validate_date()`
 - `_display_settlement_status()`
+- `_get_summary_approved_expenses()`
 - `_expense_amount_for_summary()`
 - `_get_display_subcategory()`
-- `_get_summary_approved_expenses()`
 - `_summary_display_category()`
-- `_validate_date()`
+- `_build_summary_payload()`
 
 **Bergantung Pada (Internal Imports):**
@@ -21,5 +21,5 @@
 - `Expense`
 - `Settlement`
-- `models/__init__.py`
+- `__init__.py`
 
 **Dipakai Oleh:**
```

#### `backend/services/reports/summary_service/excel_generator.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `175` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
@@ -7,16 +7,23 @@
 **Fungsi / Metode:**
 
+- `generate_excel_report()`
 - `generate_excel_advance_report()`
-- `generate_excel_report()`
 
 **Bergantung Pada (Internal Imports):**
 
-- `data_helpers.py`
-- `parsing_helper.py`
+- `Advance`
+- `AdvanceItem`
+- `Category`
+- `Expense`
+- `Settlement`
+- `__init__.py`
+- `_build_summary_payload()`
+- `_default_report_year()`
+- `_get_summary_approved_expenses()`
+- `_parse_iso_date()`
 
 **Memanggil Fungsi/Modul:**
 
 - `_build_summary_payload()`
-- `_default_report_year()`
 - `_get_summary_approved_expenses()`
 
```

#### `backend/services/reports/summary_service/pdf_generator.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `42` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).
@@ -7,8 +7,8 @@
 **Fungsi / Metode:**
 
-- `generate_bulk_advances_pdf()`
-- `generate_bulk_settlements_pdf()`
 - `generate_pdf_advance_report()`
 - `generate_settlement_receipt()`
+- `generate_bulk_settlements_pdf()`
+- `generate_bulk_advances_pdf()`
 
 **Bergantung Pada (Internal Imports):**
@@ -19,8 +19,8 @@
 - `Settlement`
 - `User`
+- `__init__.py`
 - `_display_settlement_status()`
 - `_validate_date()`
 - `data_helpers.py`
-- `models/__init__.py`
 
 **Memanggil Fungsi/Modul:**
```

#### `backend/services/reports/table_builder/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `233` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/reports/table_builder/expense_renderer.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `20` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
@@ -13,4 +13,5 @@
 - `Category`
 - `ManualCombineGroup`
+- `__init__.py`
 - `_as_iso_date()`
 - `_clean_currency()`
@@ -20,5 +21,4 @@
 - `_clear_range_force()`
 - `_clone_row_format()`
-- `_expense_amount_for_display()`
 
 **Memanggil Fungsi/Modul:**
```

#### `backend/services/reports/table_builder/expense_renderer_utils.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `60` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L133`
 
 **Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).
@@ -8,15 +8,15 @@
 
 - `_expense_column_mapping_name()`
+- `_expense_amount_for_display()`
 - `_expense_subcategory_label()`
 - `_group_expenses_by_subcategory()`
-- `_expense_amount_for_display()`
 
 **Bergantung Pada (Internal Imports):**
 
 - `Category`
+- `__init__.py`
 - `_idr_from_currency()`
 - `_safe_text()`
 - `_to_float()`
-- `models/__init__.py`
 - `report_helpers.py`
 
```

#### `backend/services/reports/table_builder/pdf_builder.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `20` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
@@ -13,4 +13,5 @@
 - `Category`
 - `ManualCombineGroup`
+- `__init__.py`
 - `_apply_manual_revenue_combine_groups()`
 - `_apply_manual_tax_combine_groups()`
@@ -20,5 +21,4 @@
 - `_clear_merged_ranges_in_region()`
 - `_clear_range()`
-- `_clear_range_force()`
 
 **Memanggil Fungsi/Modul:**
@@ -37,4 +37,5 @@
 **Dipakai Oleh:**
 
+- `backend/routes/reports/annual_fastapi.py`
 - `backend/routes/reports/annual_tables.py`
 - `backend/services/reports/annual_service/annual_tables.py`
```

#### `backend/services/reports/table_builder/revenue_helpers.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `75` | **Lokasi:** `L366`
+**Community Group:** `-` | **Lokasi:** `L366`
 
 **Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).
@@ -7,11 +7,11 @@
 **Fungsi / Metode:**
 
+- `_manual_combine_groups_by_table()`
+- `_manual_combine_groups_by_rows()`
 - `_apply_manual_revenue_combine_groups()`
 - `_apply_manual_tax_combine_groups()`
-- `_group_revenues_by_type()`
-- `_manual_combine_groups_by_rows()`
-- `_manual_combine_groups_by_table()`
 - `_operation_cost_totals_by_column()`
 - `_get_revenue_bounds()`
+- `_group_revenues_by_type()`
 - `_validate_revenue_data()`
 
@@ -20,4 +20,5 @@
 - `Category`
 - `ManualCombineGroup`
+- `__init__.py`
 - `_as_iso_date()`
 - `_clean_currency()`
@@ -27,5 +28,4 @@
 - `_clear_range_force()`
 - `_expense_amount_for_display()`
-- `_expense_column_mapping_name()`
 
 **Memanggil Fungsi/Modul:**
```

#### `backend/services/settlements/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `234` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/settlements/settlement_approval_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `14` | **Lokasi:** `L23`
+**Community Group:** `-` | **Lokasi:** `L23`
 
 **Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).
@@ -8,9 +8,9 @@
 
 - `_calculate_settlement_per_bank_netting()`
+- `process_submit_settlement()`
 - `process_approve_settlement()`
 - `process_complete_settlement()`
+- `process_reject_all_expenses()`
 - `process_final_approve_settlement()`
-- `process_reject_all_expenses()`
-- `process_submit_settlement()`
 
 **Bergantung Pada (Internal Imports):**
@@ -19,11 +19,11 @@
 - `BankAccount`
 - `BankTransaction`
+- `Config`
 - `Notification`
 - `OverrideLog`
 - `Settlement`
 - `User`
+- `__init__.py`
 - `_has_unchecked_checklist()`
-- `_has_unchecked_return_checklist()`
-- `_merge_rejection_notes()`
 
 **Memanggil Fungsi/Modul:**
```

#### `backend/services/transactions/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `235` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/services/transactions/dividend_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `122` | **Lokasi:** `L13`
+**Community Group:** `-` | **Lokasi:** `L13`
 
 **Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
@@ -7,6 +7,6 @@
 **Fungsi / Metode:**
 
+- `_fetch_revenues_and_expenses_for_year()`
 - `_build_dividend_payload()`
-- `_fetch_revenues_and_expenses_for_year()`
 
 **Bergantung Pada (Internal Imports):**
@@ -17,6 +17,6 @@
 - `Revenue`
 - `Settlement`
+- `__init__.py`
 - `_compute_dividend_distribution_v2()`
-- `models/__init__.py`
 
 **Memanggil Fungsi/Modul:**
```

#### `backend/services/transactions/revenue_service.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `1` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
@@ -13,11 +13,9 @@
 - `ManualCombineGroup`
 - `Revenue`
-- `_req_company()`
-- `auth_helper.py`
-- `models/__init__.py`
+- `__init__.py`
 
-**Memanggil Fungsi/Modul:**
+**Dipakai Oleh:**
 
-- `_req_company()`
+- `backend/routes/transactions/revenues.py`
 
 ---
```

#### `backend/tests/test_annual_report_routes.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `123` | **Lokasi:** `L44`
+**Community Group:** `-` | **Lokasi:** `L55`
 
 **Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).
@@ -9,15 +9,14 @@
 - `app()`
 - `client()`
+- `test_excel_generator_logger_and_function_exist()`
+- `test_annual_routes_registered()`
 - `test_annual_excel_requires_auth()`
+- `test_annual_pdf_requires_auth()`
 - `test_annual_json_requires_auth()`
-- `test_annual_pdf_requires_auth()`
-- `test_annual_routes_registered()`
-- `test_excel_generator_logger_and_function_exist()`
 
 **Bergantung Pada (Internal Imports):**
 
-- `annual_service/excel_generator.py`
-- `app.py`
 - `create_app()`
+- `excel_generator.py`
 
 **Memanggil Fungsi/Modul:**
```

#### `backend/tests/test_blueprint_routes.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.
 
-**Community Group:** `56` | **Lokasi:** `L71`
+**Community Group:** `-` | **Lokasi:** `L73`
 
 **Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).
@@ -9,11 +9,10 @@
 - `app()`
 - `client()`
-- `test_all_blueprints_registered()`
+- `test_native_routers_registered()`
+- `test_reports_endpoints_methods()`
 - `test_auth_login_endpoint()`
-- `test_reports_endpoints_methods()`
 
 **Bergantung Pada (Internal Imports):**
 
-- `app.py`
 - `create_app()`
 
```

#### `backend/tests/test_code_hygiene_fixes.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.
 
-**Community Group:** `175` | **Lokasi:** `L16`
+**Community Group:** `-` | **Lokasi:** `L23`
 
 **Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
@@ -7,11 +7,11 @@
 **Fungsi / Metode:**
 
+- `test_summary_excel_generator_logger()`
 - `test_transaction_dto_keys_not_duplicated()`
-- `test_summary_excel_generator_logger()`
 
 **Bergantung Pada (Internal Imports):**
 
 - `TransactionDTO`
-- `summary_service/excel_generator.py`
+- `excel_generator.py`
 
 **Memanggil Fungsi/Modul:**
```

#### `backend/tests/test_revenue_bank_sync.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.
 
-**Community Group:** `56` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L209`
 
 **Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).
@@ -7,15 +7,20 @@
 **Fungsi / Metode:**
 
+- `app()`
+- `test_revenue_model_has_bank_relationship()`
 - `test_bank_transaction_has_revenue_relationship()`
+- `test_revenue_to_dict_includes_bank_info()`
+- `test_sync_revenue_bank_transaction_creates_and_updates_and_deletes()`
 - `test_revenue_and_bank_transaction_tracks_creator()`
-- `test_revenue_to_dict_includes_bank_info()`
-- `test_revenue_model_has_bank_relationship()`
-- `test_sync_revenue_bank_transaction_creates_and_updates_and_deletes()`
-- `app()`
 
 **Bergantung Pada (Internal Imports):**
 
+- `BankAccount`
+- `BankTransaction`
+- `Revenue`
 - `TransactionDTO`
-- `app.py`
+- `User`
+- `__init__.py`
+- `calculate_bank_real_balance()`
 - `create_app()`
 - `revenues.py`
```

#### `backend/utils/__init__.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.
 
-**Community Group:** `236` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
```

#### `backend/utils/auth_helper.py`
```diff
@@ -1,29 +1,13 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `24` | **Lokasi:** `L6`
+**Community Group:** `-` | **Lokasi:** `L1`
 
-**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).
-
-**Fungsi / Metode:**
-
-- `current_user()`
-- `_require_manager()`
-- `_req_company()`
+**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
 
 **Bergantung Pada (Internal Imports):**
 
-- `User`
-- `core.py`
-
-**Dipakai Oleh:**
-
-- `backend/routes/advances/advances_crud.py`
-- `backend/routes/advances/advances_items.py`
-- `backend/routes/advances/advances_other.py`
-- `backend/routes/core/auth.py`
-- `backend/routes/core/cleanup.py`
-- `backend/routes/core/dashboard.py`
-- `backend/routes/core/notifications.py`
-- `backend/routes/master_data/bank_management.py`
+- `get_current_user()`
+- `require_role()`
+- `security.py`
 
 ---
```

#### `backend/utils/constants.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.
 
-**Community Group:** `176` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).
@@ -7,6 +7,6 @@
 **Classes / Models:**
 
+- `Status` (L1)
 - `RevenueType` (L18)
-- `Status` (L1)
 - `UserRole` (L22)
 
```

#### `backend/utils/deadline_worker.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.
 
-**Community Group:** `2` | **Lokasi:** `L23`
+**Community Group:** `-` | **Lokasi:** `L229`
 
 **Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).
@@ -7,8 +7,8 @@
 **Fungsi / Metode:**
 
+- `_normalize_rule_key()`
 - `check_and_create_deadline_notifications()`
 - `_cleanup_stale_deadline_notifications()`
 - `_create_deadline_notification_if_missing()`
-- `_normalize_rule_key()`
 
 **Bergantung Pada (Internal Imports):**
@@ -19,5 +19,5 @@
 - `Settlement`
 - `User`
-- `models/__init__.py`
+- `__init__.py`
 
 **Memanggil Fungsi/Modul:**
```

#### `backend/utils/parsing_helper.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `26` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L42`
 
 **Risiko:** 🟢 **Aman** (12 fungsi/metode terdeteksi).
@@ -7,27 +7,31 @@
 **Fungsi / Metode:**
 
+- `allowed_file()`
+- `_parse_checklist_notes()`
+- `_has_unchecked_checklist()`
+- `_has_unchecked_return_checklist()`
+- `_merge_rejection_notes()`
 - `_parse_date()`
 - `_parse_float_safe()`
 - `_parse_number_value()`
-- `_merge_rejection_notes()`
-- `allowed_file()`
-- `_has_unchecked_checklist()`
-- `_has_unchecked_return_checklist()`
 - `_parse_category_ids()`
-- `_parse_checklist_notes()`
 - `_default_report_year()`
+- `_year_date_bounds()`
 - `_parse_iso_date()`
-- `_year_date_bounds()`
+
+**Bergantung Pada (Internal Imports):**
+
+- `Config`
 
 **Dipakai Oleh:**
 
-- `backend/routes/advances/advances_items.py`
-- `backend/routes/core/auth.py`
 - `backend/routes/master_data/taxes.py`
-- `backend/routes/reports/annual.py`
+- `backend/routes/reports/annual_fastapi.py`
 - `backend/routes/reports/summary.py`
 - `backend/routes/settlements/settlements_expenses.py`
 - `backend/routes/transactions/dividends.py`
 - `backend/routes/transactions/expenses.py`
+- `backend/routes/transactions/revenues.py`
+- `backend/services/advances/advance_approval_service.py`
 
 ---
```

#### `backend/utils/report_helpers.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `60` | **Lokasi:** `L56`
+**Community Group:** `-` | **Lokasi:** `L649`
 
 **Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).
@@ -7,25 +7,29 @@
 **Fungsi / Metode:**
 
-- `_group_annual_expenses()`
+- `_default_report_year()`
 - `_year_date_bounds()`
-- `_as_iso_date()`
-- `_clean_currency()`
-- `_clean_settlement_title()`
+- `_safe_set_cell()`
+- `_get_top_left_cell()`
+- `_safe_set_cell_with_merge()`
+- `_get_dynamic_row_height()`
+- `_merge_description_cell()`
+- `_get_column_letter()`
+- `_safe_set_number()`
+- `_unmerge_region()`
+- `_normalize_external_formula_refs()`
 - `_clear_range()`
+- `_clear_data_keep_formulas()`
+- `_clear_range_force()`
+- `_set_rows_hidden()`
+- `_safe_text()`
 - `_extract_imported_row()`
-- `_get_dynamic_row_height()`
-- `_is_batch_settlement()`
-- `_map_expense_category_index_from_name()`
-- `_map_expense_column()`
-- `_parse_iso_date()`
-- `_safe_set_cell()`
-- `_safe_set_number()`
-- `_set_date_with_format()`
-- `_set_formula_with_format()`
-- `_set_rows_hidden()`
-- `_shorten()`
-- `_clear_range_force()`
-- `_clear_data_keep_formulas()`
+- `_extract_imported_sheet_row()`
+- `_is_date_like()`
+- `_is_template_detail_data_row()`
 - *(... dan 23 fungsi lainnya)*
+
+**Bergantung Pada (Internal Imports):**
+
+- `Config`
 
 **Dipakai Oleh:**
```

#### `backend/utils/storage.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.
 
-**Community Group:** `26` | **Lokasi:** `L5`
+**Community Group:** `-` | **Lokasi:** `L7`
 
 **Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).
@@ -9,7 +9,10 @@
 - `delete_evidence_file()`
 
+**Bergantung Pada (Internal Imports):**
+
+- `Config`
+
 **Dipakai Oleh:**
 
-- `backend/routes/advances/advances_items.py`
 - `backend/routes/transactions/expenses.py`
 - `backend/services/advances/advance_items_service.py`
```

#### `backend/utils/transaction_templates.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.
 
-**Community Group:** `128` | **Lokasi:** `L1`
+**Community Group:** `-` | **Lokasi:** `L1`
 
 **Risiko:** 🟢 **Aman** (9 fungsi/metode terdeteksi).
@@ -11,17 +11,18 @@
 **Fungsi / Metode:**
 
+- `.allocation_notes()`
 - `.advance_approved_final()`
+- `.advance_rejected_final()`
+- `.settlement_approved_final()`
+- `.settlement_rejected_final()`
+- `.advance_revision_requested()`
 - `.advance_move_to_draft()`
-- `.advance_rejected_final()`
-- `.advance_revision_requested()`
-- `.allocation_notes()`
 - `.disbursement()`
 - `.refund_notes()`
-- `.settlement_approved_final()`
-- `.settlement_rejected_final()`
 
 **Dipakai Oleh:**
 
 - `backend/routes/advances/advances_other.py`
+- `backend/routes/master_data/bank_management.py`
 
 ---
```

#### `backend/utils/workflow_helper.py`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.
 
-**Community Group:** `14` | **Lokasi:** `L9`
+**Community Group:** `-` | **Lokasi:** `L59`
 
 **Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).
@@ -13,5 +13,5 @@
 
 - `WorkflowLog`
-- `models/__init__.py`
+- `__init__.py`
 
 **Memanggil Fungsi/Modul:**
```

---

## Perubahan Frontend (Graphify)
### 📝 Konten Berubah
#### `frontend/lib/controllers/settlement_list_controller.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Controller layer yang memisahkan logika UI dari tampilan Screen.
 
-**Community Group:** `70`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/main.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Entry-point aplikasi Flutter. Inisialisasi providers global dan routing.
 
-**Community Group:** `62`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/models/advance_item_model.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Mendefinisikan entitas data agar dapat dikenali dan diproses secara type-safe oleh Dart.
 
-**Community Group:** `71`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/models/advance_model.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Mendefinisikan entitas data agar dapat dikenali dan diproses secara type-safe oleh Dart.
 
-**Community Group:** `12`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/models/dto/advance_requests.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Mendefinisikan entitas data agar dapat dikenali dan diproses secara type-safe oleh Dart.
 
-**Community Group:** `95`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/models/enums.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Mendefinisikan entitas data agar dapat dikenali dan diproses secara type-safe oleh Dart.
 
-**Community Group:** `136`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/models/notification_model.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Mendefinisikan entitas data agar dapat dikenali dan diproses secara type-safe oleh Dart.
 
-**Community Group:** `101`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/advance/advance_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `17`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/advance/advance_provider_finance_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `172`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/advance/advance_provider_item_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `152`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/advance/advance_provider_list_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `144`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/advance/advance_provider_workflow_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `153`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/auth/auth_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `23`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/core/base_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `102`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/core/cascade_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `3`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/providers/core/notification_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `91`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/core/theme_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `25`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/master_data/bank_management_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `92`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/master_data/bank_status_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `54`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/master_data/tax_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `97`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/settlement/settlement_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `3`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/settlement/settlement_provider_bank_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `116`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/settlement/settlement_provider_category_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `145`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/settlement/settlement_provider_crud_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `165`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/settlement/settlement_provider_expense_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `137`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/settlement/settlement_provider_finance_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `166`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/settlement/settlement_provider_list_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `138`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/settlement/settlement_provider_workflow_ext.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `129`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/transactions/asset_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `58`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/transactions/dividend_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `40`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/providers/transactions/revenue_provider.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah.
 
-**Community Group:** `98`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/advance/advance_detail_actions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `32`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/advance_detail_previews.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `49`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/advance_detail_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `8`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/advances_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `17`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/advances_screen_dialogs.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/dialogs/dialog_add_category.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/advance/dialogs/dialog_add_item.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/dialogs/dialog_checklist.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/dialogs/dialog_comments.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/advance/dialogs/dialog_disbursement_evidence_cell.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/advance/dialogs/dialog_edit_advance.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/dialogs/dialog_edit_disbursement.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/dialogs/dialog_evidence.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/dialogs/dialog_get_comments_from_notes.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/advance/dialogs/dialog_insufficient_balance.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/advance/dialogs/dialog_parse_plain_comments.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `85`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/advance/dialogs/dialog_plain_comments.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `32`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/advance/dialogs/dialog_workflow_timeline.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/layouts/advance_detail_layout.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/advance/layouts/advance_detail_tables.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/widgets/advances_widgets.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `17`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_add_comment_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_advance_detail_actions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/widgets/widget_content.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_empty_state.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_file_list.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_insuff_balance_row.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_mobile_advance_action_bar.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_scrollable_advance_header.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `130`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_toggle_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `4`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_type_toggle.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/advance/widgets/widget_warning_box.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `6`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/advance/widgets/widget_year_summary_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `17`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/loading_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `16`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/login_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `47`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/auth/login_widget_gmail_login_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `33`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/auth/login_widget_landscape_intro_panel.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `29`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/login_widget_landscape_login_content.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `29`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/login_widget_login_brand_icon.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `72`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/login_widget_login_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `18`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/auth/login_widget_login_hint_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `4`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/login_widget_password_field.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `50`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/login_widget_portrait_login_content.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `29`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/login_widget_register_link.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `50`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/login_widget_username_field.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `106`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/register_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `16`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/auth/register_widget_back_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `73`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_company_dropdown.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `95`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_confirm_password_field.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `50`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_email_field.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `173`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_full_name_field.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `106`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_landscape_intro_panel.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `178`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_landscape_register_content.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `48`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_password_field.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `50`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_phone_field.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `139`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_portrait_register_content.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `51`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_register_brand_icon.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `73`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_register_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `50`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_role_dropdown.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `63`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_username_field.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `106`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/register_widget_workplace_field.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `106`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/auth/server_error_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `18`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/dashboard/dashboard_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `18`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/layout/main_layout.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `18`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/layout/main_layout_settlement_list.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `28`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/layout/main_layout_settlement_list_dialogs.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/layout/main_layout_widgets.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `81`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/main_layout_components/widget_summary_cards.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `3`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/asset_management_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `39`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/bank_advance_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `77`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/bank_management_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/bank_management_screen_actions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/bank_management_screen_layout.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/bank_management_screen_tables.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/bank_status_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `54`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/category_management_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `86`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/category_tabular_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `55`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/dialog_advance_log_book.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `64`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/dialog_bank_account.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/dialog_bank_advance_detail.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/dialog_bank_cash_detail.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/dialog_bank_cash_log_book.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/dialog_edit_advance_balance.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/dialog_edit_advance_opening_balance.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/dialogs/dialog_asset_form.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/dialogs/dialog_ndpv_table.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/dividend_management_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `40`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/logbook_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `109`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/revenue_management_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `80`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/revenue_management_screen_actions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `80`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/revenue_management_screen_dialogs.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/revenue_management_screen_tables.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `155`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/tax_management_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `97`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/tax_management_screen_actions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `97`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/management/tax_management_screen_dialogs.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `117`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/tax_management_screen_tables.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `117`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/widget_advance_section.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/widget_audit_trail_log_item.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/widget_bank_accounts_tab.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/widget_group_management_dialog.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `55`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/widget_kanban_column_dynamic.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `55`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/widget_section_toggle.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/widget_simple_category_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `55`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/management/widget_toggle_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `5`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/manager/manager_dashboard_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `82`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/manager/manager_settlement_detail_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `66`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/manager/widgets/widget_manager_approval_table.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `62`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/manager/widgets/widget_manager_summary_cards.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `112`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/annual_report_helpers.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `34`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/annual_report_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `7`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/reports/annual_report/annual_report_state.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `156`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/annual_report_tables.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `84`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/annual_report_widgets.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `34`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_all_tables.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `84`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_bank_expense_table.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `34`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_cache_info.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `34`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `34`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_display_tables.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `84`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_evidence_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `34`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_expense_table_cell.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `167`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_report_header.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `84`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_show_evidence_popup.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `84`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_status_cell.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `34`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_summary_cards.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `34`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_table4_a_and4_b.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `34`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_table4_c_and4_d.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `34`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_table_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `84`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/annual_report/widget_tax_toggle_cell.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `34`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/reports/report_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `3`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/balance_sheet_settings_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `43`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/data_cleanup_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `52`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/deadline_manager_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `74`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/dialog_custom_bank_order.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `87`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/settings_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `4`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/settings_screen_actions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `80`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/settings_screen_dialogs.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `4`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/settings_screen_layout.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `4`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settings/widget_bank_advance_widget.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `4`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/widget_bank_order_settings_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `4`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settings/widget_cleanup_settings_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `4`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settings/widget_database_settings_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `4`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settings/widget_deadline_settings_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `4`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settings/widget_logbook_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `4`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settings/widget_manager_section.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `4`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settings/widget_profile_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `4`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settings/widget_report_year_settings_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `4`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settings/widget_storage_settings_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `4`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settings/widget_theme_settings_card.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `4`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settlement/dialogs/dialog_add_category.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settlement/dialogs/dialog_add_expense.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settlement/dialogs/dialog_checklist.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `33`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settlement/dialogs/dialog_comments.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `78`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settlement/dialogs/dialog_edit_disbursement.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settlement/dialogs/dialog_edit_expense.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settlement/dialogs/dialog_edit_settlement.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settlement/dialogs/dialog_evidence.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settlement/dialogs/dialog_plain_comments.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `78`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settlement/layouts/settlement_detail_layout.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `78`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settlement/layouts/settlement_detail_tables.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `33`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settlement/settlement_detail_actions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `88`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settlement/settlement_detail_previews.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `49`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settlement/settlement_detail_screen.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `88`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/settlement/widgets/widget_expense_form_fields.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `139`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settlement/widgets/widget_file_list.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `78`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settlement/widgets/widget_insuff_balance_row.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `78`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settlement/widgets/widget_insufficient_balance_dialog.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settlement/widgets/widget_settlement_detail_actions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `33`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settlement/widgets/widget_settlement_expense_table.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `113`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/settlement/widgets/widget_settlement_summary_cards.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `112`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/widgets/common_widgets.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `131`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/widgets/page_selector.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `63`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/widgets/settlement_detail_widgets.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `67`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/widgets/sidebar.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `72`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/widgets/transaction_cards.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `73`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/widgets/widget_scrollable_settlement_header.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `168`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/widgets/widget_sidebar_components.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `73`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/widgets/widget_summary_cards.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/screens/widgets/widget_toggle_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `81`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/screens/widgets/widget_type_toggle.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait.
 
-**Community Group:** `9`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/services/api_advances.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `59`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/services/api_assets.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `59`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/services/api_auth.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `124`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/services/api_banks.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `89`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/services/api_categories.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `59`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/services/api_companies.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `59`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/services/api_database.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `85`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/services/api_dividends.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `116`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/services/api_expenses.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `59`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/services/api_master.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `125`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/services/api_reports.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `181`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/services/api_revenues.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `140`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/services/api_service.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `59`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/services/api_settlements.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `93`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/services/api_taxes.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `146`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/services/api_users.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `159`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/services/bank_order_preferences.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `99`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/services/notification_service.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait.
 
-**Community Group:** `147`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/theme/app_theme.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `21`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/utils/app_dialogs.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `4`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/utils/app_formatters.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `103`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/utils/app_logger.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `179`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/utils/app_snackbar.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `157`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/utils/context_extensions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `100`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/utils/controller_disposable_wrapper.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Controller layer yang memisahkan logika UI dari tampilan Screen.
 
-**Community Group:** `135`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/utils/currency_formatter.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `169`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/utils/event_bus.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `160`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/utils/exceptions.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `208`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/utils/file_helper.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `110`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/utils/responsive_layout.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `73`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/utils/status_colors.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `4`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/utils/transaction_templates.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file.
 
-**Community Group:** `161`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/widgets/account_list_dialog.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `73`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/widgets/app_brand_logo.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `143`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/widgets/app_scrollbar.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `37`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/widgets/category_preview_dialog.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `141`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/widgets/core/_fast_range_picker_dialog.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `61`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/widgets/core/_menu_item_label.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `67`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/widgets/core/app_date_range_picker.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `61`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/widgets/core/cascading_menu_custom.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `63`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/widgets/core/cascading_menu_item.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `67`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/widgets/core/cascading_status_filter.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `102`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/widgets/core/cascading_year_filter.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `126`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/widgets/core/format_utils.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `180`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/widgets/core/status_filter_chip.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `81`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/widgets/core/year_filter_button.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `148`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/widgets/details/evidence_viewer.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `149`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/widgets/dialog_create_user.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `79`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/widgets/dialog_edit_user.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `94`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/widgets/image_cropper_dialog.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `76`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/widgets/item_detail_preview_dialog.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `107`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/widgets/manage_companies_dialog.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `120`
+**Community Group:** `-`
 
 ---
```

#### `frontend/lib/widgets/notification_bell_icon.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `68`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/widgets/user_detail_dialog.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `90`
+**Community Group:** `-`
 
 **Mengkonsumsi Provider:**
```

#### `frontend/lib/widgets/workflow_timeline.dart`
```diff
@@ -1,5 +1,5 @@
 **Tanggung Jawab:** Komponen UI terpisah (reusable widget) agar kode lebih modular.
 
-**Community Group:** `69`
+**Community Group:** `-`
 
 ---
```

---

