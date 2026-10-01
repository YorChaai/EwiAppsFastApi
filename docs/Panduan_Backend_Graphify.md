# 📘 Panduan Backend (Graphify Knowledge Graph)

Dokumen ini digenerate dari **graphify-out/graph.json** — bukan dari scan regex/AST langsung.
Setiap entitas dan relasi di bawah ini dibangun dari Knowledge Graph proyek ini.

> **Script:** `backend/scripts/graphify_docs/generate_backend_graphify.py`

---

## 📊 Ringkasan Statistik

| Metrik | Nilai |
|---|---|
| Total File Backend (aktif) | **200** |
| Total Class/Model | **28** |
| Total Fungsi/Metode | **478** |
| Total Relasi (edges) | **2605** |
| Total Folder | **23** |

---

## 📁 Folder: `backend`

**Tujuan Folder:** File inti / konfigurasi utama aplikasi backend.

### File: `backend/app.py`

**Tanggung Jawab:** Entry-point server backend. Inisialisasi aplikasi, database, middleware, dan blueprint.

**Community Group:** `98` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_app()`
- `run_database_integrity_maintenance()`
- `seed_data()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `Config`
- `User`
- `config.py`
- `init_mail()`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `Category`
- `User`
- `init_mail()`

---

### File: `backend/app.py`

**Tanggung Jawab:** Entry-point server backend. Inisialisasi aplikasi, database, middleware, dan blueprint.

**Community Group:** `98` | **Lokasi:** `L155`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_app()`
- `run_database_integrity_maintenance()`
- `seed_data()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `Config`
- `User`
- `config.py`
- `init_mail()`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `Category`
- `User`
- `init_mail()`

---

### File: `backend/clean_all.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `183` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `clean_and_replace()`

---

### File: `backend/clean_duplicate_parsing.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `203` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/cleanup_auth.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `184` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `remove_function()`

---

### File: `backend/cleanup_auth_regex.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `185` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `remove_function()`

---

### File: `backend/config.py`

**Tanggung Jawab:** Mengelola environment variables dan konfigurasi server (database URI, secret key, dll).

**Community Group:** `98` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Classes / Models:**

- `Config` (L11)

**Dipakai Oleh:**

- `backend/app.py`

---

### File: `backend/extract_funcs.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `186` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `extract_and_move()`

---

### File: `backend/fix_imports.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `187` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `fix_imports()`

---

### File: `backend/fix_routes.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `188` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `fix_route_imports()`

---

### File: `backend/fix_services.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `189` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `fix_service()`

---

### File: `backend/move_utils_to_services.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `180` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `append_to_file()`
- `extract_funcs()`

---

### File: `backend/update_parsing_imports.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `193` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `replace_imports()`

---

## 📁 Folder: `backend/models`

**Tujuan Folder:** Mendefinisikan skema database (ORM) dan validasi data dengan SQLAlchemy.

### File: `backend/models/__init__.py`

**Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.

**Community Group:** `1` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `Asset`
- `BankAccount`
- `BankStatusTransaction`
- `BankTransaction`
- `Category`
- `CategoryGroup`
- `Company`
- `DeadlineSetting`

**Dipakai Oleh:**

- `backend/app.py`
- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_items.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth.py`
- `backend/routes/core/cleanup.py`
- `backend/routes/core/dashboard.py`

---

### File: `backend/models/banking.py`

**Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.

**Community Group:** `1` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Classes / Models:**

- `BankAccount` (L7)
- `BankTransaction` (L33)
- `BankStatusTransaction` (L77)

**Fungsi / Metode:**

- `.to_dict()`
- `.__init__()`

**Bergantung Pada (Internal Imports):**

- `base.py`

**Dipakai Oleh:**

- `backend/models/__init__.py`
- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_items.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/cleanup.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`

---

### File: `backend/models/base.py`

**Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.

**Community Group:** `1` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Dipakai Oleh:**

- `backend/models/banking.py`
- `backend/models/core.py`
- `backend/models/system.py`
- `backend/models/transaction.py`

---

### File: `backend/models/core.py`

**Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.

**Community Group:** `98` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (12 fungsi/metode terdeteksi).

**Classes / Models:**

- `Company` (L7)
- `User` (L23)
- `CategoryGroup` (L125)
- `Category` (L144)

**Fungsi / Metode:**

- `.to_dict()`
- `.__init__()`
- `.check_password()`
- `.is_online()`
- `.last_login_formatted()`
- `.set_password()`
- `.full_name()`

**Bergantung Pada (Internal Imports):**

- `base.py`

**Dipakai Oleh:**

- `backend/app.py`
- `backend/models/__init__.py`
- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_items.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth.py`
- `backend/routes/core/cleanup.py`

---

### File: `backend/models/system.py`

**Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.

**Community Group:** `1` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Classes / Models:**

- `Notification` (L7)
- `OverrideLog` (L131)
- `DeadlineSetting` (L59)
- `WorkflowLog` (L92)

**Fungsi / Metode:**

- `.to_dict()`
- `.__init__()`

**Bergantung Pada (Internal Imports):**

- `base.py`

**Dipakai Oleh:**

- `backend/models/__init__.py`
- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/cleanup.py`
- `backend/routes/core/notifications.py`
- `backend/routes/settings/db_storage.py`
- `backend/routes/settings/deadline.py`
- `backend/routes/settings/profile.py`

---

### File: `backend/models/transaction.py`

**Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.

**Community Group:** `1` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (39 fungsi/metode terdeteksi).

**Classes / Models:**

- `Advance` (L44)
- `AdvanceItem` (L155)
- `Asset` (L7)
- `Dividend` (L564)
- `Settlement` (L230)
- `Tax` (L474)
- `ManualCombineGroup` (L521)
- `DividendSetting` (L584)
- `Revenue` (L394)
- `Expense` (L315)

**Fungsi / Metode:**

- `.approved_amount()`
- `.base_amount()`
- `.max_revision_no()`
- `.rejected_count()`
- `.revision_amount()`
- `.total_amount()`
- `.to_dict()`
- `.idr_transaction_value()`
- `.merged_columns()`
- `.row_ids()`
- `.__init__()`
- `.idr_amount_received()`
- `.idr_invoice_value()`
- `.combined_subcategory_label()`
- `.idr_amount()`
- `.normalize_revenue_type()`

**Bergantung Pada (Internal Imports):**

- `TransactionDTO`
- `base.py`

**Memanggil Fungsi/Modul:**

- `.advance_to_dict()`
- `.advanceitem_to_dict()`
- `.dividend_to_dict()`
- `.dividendsetting_to_dict()`
- `.expense_to_dict()`
- `.manualcombinegroup_to_dict()`
- `.revenue_to_dict()`
- `.settlement_to_dict()`
- `.tax_to_dict()`

**Dipakai Oleh:**

- `backend/models/__init__.py`
- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_items.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/cleanup.py`
- `backend/routes/core/dashboard.py`
- `backend/routes/master_data/bank_management.py`

---

### File: `backend/models/transaction.py`

**Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.

**Community Group:** `31` | **Lokasi:** `L195`

**Risiko:** 🟢 **Aman** (39 fungsi/metode terdeteksi).

**Classes / Models:**

- `Advance` (L44)
- `AdvanceItem` (L155)
- `Asset` (L7)
- `Dividend` (L564)
- `Settlement` (L230)
- `Tax` (L474)
- `ManualCombineGroup` (L521)
- `DividendSetting` (L584)
- `Revenue` (L394)
- `Expense` (L315)

**Fungsi / Metode:**

- `.approved_amount()`
- `.base_amount()`
- `.max_revision_no()`
- `.rejected_count()`
- `.revision_amount()`
- `.total_amount()`
- `.to_dict()`
- `.idr_transaction_value()`
- `.merged_columns()`
- `.row_ids()`
- `.__init__()`
- `.idr_amount_received()`
- `.idr_invoice_value()`
- `.combined_subcategory_label()`
- `.idr_amount()`
- `.normalize_revenue_type()`

**Bergantung Pada (Internal Imports):**

- `TransactionDTO`
- `base.py`

**Memanggil Fungsi/Modul:**

- `.advance_to_dict()`
- `.advanceitem_to_dict()`
- `.dividend_to_dict()`
- `.dividendsetting_to_dict()`
- `.expense_to_dict()`
- `.manualcombinegroup_to_dict()`
- `.revenue_to_dict()`
- `.settlement_to_dict()`
- `.tax_to_dict()`

**Dipakai Oleh:**

- `backend/models/__init__.py`
- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_items.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/cleanup.py`
- `backend/routes/core/dashboard.py`
- `backend/routes/master_data/bank_management.py`

---

## 📁 Folder: `backend/routes`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `backend/routes/__init__.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `206` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

## 📁 Folder: `backend/routes/advances`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `backend/routes/advances/__init__.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `204` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/routes/advances/advances.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `13` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `advances_approval.py`
- `advances_crud.py`
- `advances_disbursement.py`
- `advances_items.py`
- `advances_other.py`

---

### File: `backend/routes/advances/advances_approval.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `32` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `approve_advance()`
- `approve_advance_item()`
- `final_approve_advance()`
- `reject_advance()`
- `reject_advance_item()`
- `start_revision()`
- `submit_advance()`

**Bergantung Pada (Internal Imports):**

- `process_approve_advance()`
- `process_approve_advance_item()`
- `process_final_approve_advance()`
- `process_reject_advance()`
- `process_reject_advance_item()`
- `process_start_revision()`
- `process_submit_advance()`

**Memanggil Fungsi/Modul:**

- `process_approve_advance()`
- `process_approve_advance_item()`
- `process_final_approve_advance()`
- `process_reject_advance()`
- `process_reject_advance_item()`
- `process_start_revision()`
- `process_submit_advance()`

**Dipakai Oleh:**

- `backend/routes/advances/advances.py`

---

### File: `backend/routes/advances/advances_crud.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `26` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_advance()`
- `delete_advance()`
- `get_advance()`
- `get_advance_history()`
- `list_advances()`
- `update_advance()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `BankAccount`
- `User`
- `WorkflowLog`
- `_advance_view_status_filter()`
- `_req_company()`
- `auth_helper.py`
- `calculate_user_running_balance()`
- `get_cash_composition_for_error()`

**Memanggil Fungsi/Modul:**

- `Advance`
- `_advance_view_status_filter()`
- `_req_company()`
- `calculate_user_running_balance()`
- `get_cash_composition_for_error()`

**Dipakai Oleh:**

- `backend/routes/advances/advances.py`

---

### File: `backend/routes/advances/advances_disbursement.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `1` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `approve_disbursement()`
- `save_disbursement()`
- `save_return()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `User`
- `allowed_file()`
- `calculate_bank_composition()`
- `get_cash_composition_for_error()`
- `log_workflow()`
- `models/__init__.py`
- `normalize_source()`
- `update_document_stage()`

**Memanggil Fungsi/Modul:**

- `allowed_file()`
- `calculate_bank_composition()`
- `get_cash_composition_for_error()`
- `log_workflow()`
- `normalize_source()`
- `update_document_stage()`

**Dipakai Oleh:**

- `backend/routes/advances/advances.py`

---

### File: `backend/routes/advances/advances_items.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `13` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `add_advance_item()`
- `bulk_delete_advance_items()`
- `delete_advance_item()`
- `update_advance_item()`
- `update_advance_items_bulk()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `AdvanceItemsService`
- `BankAccount`
- `Category`
- `User`
- `_editable_revision_no()`
- `_has_unchecked_checklist()`
- `_items_for_revision()`
- `_req_company()`

**Memanggil Fungsi/Modul:**

- `.add_advance_item()`
- `.bulk_delete_advance_items()`
- `.delete_advance_item()`
- `.update_advance_item()`
- `.update_advance_items_bulk()`

**Dipakai Oleh:**

- `backend/routes/advances/advances.py`

---

### File: `backend/routes/advances/advances_other.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `1` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_override_logs_list()`
- `get_user_balances()`
- `initialize_balance()`
- `move_advance_to_draft()`
- `override_advance()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `OverrideLog`
- `Settlement`
- `TxTemplates`
- `User`
- `auth_helper.py`
- `calculate_bank_real_balance()`
- `calculate_user_available_budget()`

**Memanggil Fungsi/Modul:**

- `.allocation_notes()`
- `BankAccount`
- `BankTransaction`
- `OverrideLog`
- `calculate_bank_real_balance()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance()`
- `calculate_user_running_balance_per_bank()`

**Dipakai Oleh:**

- `backend/routes/advances/advances.py`

---

## 📁 Folder: `backend/routes/core`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `backend/routes/core/__init__.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `205` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/routes/core/auth.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `30` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (17 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_user()`
- `forgot_password()`
- `get_all_active_advance_balances()`
- `get_my_outstanding()`
- `get_user_active_advance_balance()`
- `get_user_detail()`
- `google_login()`
- `google_login_browser()`
- `link_google()`
- `list_users()`
- `login()`
- `me()`
- `register()`
- `reset_password()`
- `unlink_google()`
- `update_profile()`
- `update_user_by_manager()`

**Bergantung Pada (Internal Imports):**

- `User`
- `_internal_login()`
- `allowed_file()`
- `auth_helper.py`
- `calculate_user_running_balance()`
- `current_user()`
- `generate_otp()`
- `get_all_users_balance_breakdown()`
- `get_user_balance_breakdown()`
- `handle_profile_image_removal()`

**Memanggil Fungsi/Modul:**

- `User`
- `_internal_login()`
- `calculate_user_running_balance()`
- `generate_otp()`
- `get_all_users_balance_breakdown()`
- `get_user_balance_breakdown()`
- `handle_profile_image_removal()`
- `handle_profile_image_upload()`
- `notify_user_registered()`
- `send_reset_password_otp()`

---

### File: `backend/routes/core/cleanup.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `1` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `cleanup_execute()`
- `cleanup_preview()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `Asset`
- `BankTransaction`
- `Dividend`
- `Expense`
- `ManualCombineGroup`
- `Notification`
- `Revenue`
- `Settlement`

**Memanggil Fungsi/Modul:**

- `_require_manager()`

---

### File: `backend/routes/core/dashboard.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `27` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_summary()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `Expense`
- `Settlement`
- `User`
- `_req_company()`
- `auth_helper.py`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `_req_company()`

---

### File: `backend/routes/core/notifications.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `110` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `delete_notification()`
- `get_notifications()`
- `get_unread_count()`
- `mark_all_notifications_as_read()`
- `mark_notification_as_read()`

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `_can_access_notification()`
- `_req_company()`
- `auth_helper.py`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `_can_access_notification()`
- `_req_company()`

---

### File: `backend/routes/core/notifications.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `110` | **Lokasi:** `L120`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `delete_notification()`
- `get_notifications()`
- `get_unread_count()`
- `mark_all_notifications_as_read()`
- `mark_notification_as_read()`

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `_can_access_notification()`
- `_req_company()`
- `auth_helper.py`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `_can_access_notification()`
- `_req_company()`

---

### File: `backend/routes/core/notifications.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `110` | **Lokasi:** `L14`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `delete_notification()`
- `get_notifications()`
- `get_unread_count()`
- `mark_all_notifications_as_read()`
- `mark_notification_as_read()`

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `_can_access_notification()`
- `_req_company()`
- `auth_helper.py`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `_can_access_notification()`
- `_req_company()`

---

### File: `backend/routes/core/notifications.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `110` | **Lokasi:** `L150`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `delete_notification()`
- `get_notifications()`
- `get_unread_count()`
- `mark_all_notifications_as_read()`
- `mark_notification_as_read()`

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `_can_access_notification()`
- `_req_company()`
- `auth_helper.py`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `_can_access_notification()`
- `_req_company()`

---

### File: `backend/routes/core/notifications.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `110` | **Lokasi:** `L65`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `delete_notification()`
- `get_notifications()`
- `get_unread_count()`
- `mark_all_notifications_as_read()`
- `mark_notification_as_read()`

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `_can_access_notification()`
- `_req_company()`
- `auth_helper.py`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `_can_access_notification()`
- `_req_company()`

---

### File: `backend/routes/core/notifications.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `110` | **Lokasi:** `L96`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `delete_notification()`
- `get_notifications()`
- `get_unread_count()`
- `mark_all_notifications_as_read()`
- `mark_notification_as_read()`

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `_can_access_notification()`
- `_req_company()`
- `auth_helper.py`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `_can_access_notification()`
- `_req_company()`

---

## 📁 Folder: `backend/routes/master_data`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `backend/routes/master_data/__init__.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `207` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/routes/master_data/bank_management.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `26` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_management_bank()`
- `create_management_transaction()`
- `delete_management_bank()`
- `delete_management_transaction()`
- `list_management_banks()`
- `list_management_transactions()`
- `update_management_bank()`
- `update_management_transaction()`

**Bergantung Pada (Internal Imports):**

- `BankAccount`
- `BankTransaction`
- `Settlement`
- `TxTemplates`
- `User`
- `_req_company()`
- `auth_helper.py`
- `get_all_bank_real_balances()`
- `models/__init__.py`
- `notify_bank_created()`

**Memanggil Fungsi/Modul:**

- `BankAccount`
- `BankTransaction`
- `_req_company()`
- `get_all_bank_real_balances()`
- `notify_bank_created()`
- `notify_bank_transaction_created()`

---

### File: `backend/routes/master_data/bank_status.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `26` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_status_transaction()`
- `delete_status_transaction()`
- `list_all_banks_for_status()`
- `list_status_transactions()`
- `update_status_transaction()`

**Bergantung Pada (Internal Imports):**

- `BankAccount`
- `BankStatusTransaction`
- `User`
- `_req_company()`
- `auth_helper.py`
- `get_all_bank_real_balances()`
- `models/__init__.py`
- `notify_bank_transaction_created()`

**Memanggil Fungsi/Modul:**

- `BankStatusTransaction`
- `_req_company()`
- `get_all_bank_real_balances()`
- `notify_bank_transaction_created()`

---

### File: `backend/routes/master_data/bank_status.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `26` | **Lokasi:** `L22`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_status_transaction()`
- `delete_status_transaction()`
- `list_all_banks_for_status()`
- `list_status_transactions()`
- `update_status_transaction()`

**Bergantung Pada (Internal Imports):**

- `BankAccount`
- `BankStatusTransaction`
- `User`
- `_req_company()`
- `auth_helper.py`
- `get_all_bank_real_balances()`
- `models/__init__.py`
- `notify_bank_transaction_created()`

**Memanggil Fungsi/Modul:**

- `BankStatusTransaction`
- `_req_company()`
- `get_all_bank_real_balances()`
- `notify_bank_transaction_created()`

---

### File: `backend/routes/master_data/categories.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `88` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (12 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `approve_category()`
- `create_category()`
- `create_category_group()`
- `delete_category()`
- `delete_category_group()`
- `list_categories()`
- `list_category_groups()`
- `list_pending()`
- `reorder_categories()`
- `reorder_category_groups()`
- `update_category()`
- `update_category_group()`

**Bergantung Pada (Internal Imports):**

- `AdvanceItem`
- `Category`
- `CategoryGroup`
- `Expense`
- `User`
- `_req_company()`
- `auth_helper.py`
- `clear_annual_report_cache()`
- `models/__init__.py`
- `notify_category_approved()`

**Memanggil Fungsi/Modul:**

- `Category`
- `CategoryGroup`
- `_req_company()`
- `clear_annual_report_cache()`
- `notify_category_approved()`
- `notify_category_created()`
- `notify_category_rejected()`

---

### File: `backend/routes/master_data/categories.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `88` | **Lokasi:** `L194`

**Risiko:** 🟢 **Aman** (12 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `approve_category()`
- `create_category()`
- `create_category_group()`
- `delete_category()`
- `delete_category_group()`
- `list_categories()`
- `list_category_groups()`
- `list_pending()`
- `reorder_categories()`
- `reorder_category_groups()`
- `update_category()`
- `update_category_group()`

**Bergantung Pada (Internal Imports):**

- `AdvanceItem`
- `Category`
- `CategoryGroup`
- `Expense`
- `User`
- `_req_company()`
- `auth_helper.py`
- `clear_annual_report_cache()`
- `models/__init__.py`
- `notify_category_approved()`

**Memanggil Fungsi/Modul:**

- `Category`
- `CategoryGroup`
- `_req_company()`
- `clear_annual_report_cache()`
- `notify_category_approved()`
- `notify_category_created()`
- `notify_category_rejected()`

---

### File: `backend/routes/master_data/companies.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `132` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_company()`
- `delete_company()`
- `get_companies()`
- `reorder_companies()`
- `update_company()`

**Bergantung Pada (Internal Imports):**

- `Company`
- `User`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `Company`

---

### File: `backend/routes/master_data/taxes.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `55` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_tax()`
- `create_tax_combine_group()`
- `delete_tax()`
- `delete_tax_combine_group()`
- `get_tax()`
- `get_tax_combine_groups()`
- `get_taxes()`
- `update_tax()`

**Bergantung Pada (Internal Imports):**

- `ManualCombineGroup`
- `Tax`
- `User`
- `_parse_date()`
- `_parse_float_safe()`
- `_parse_number_value()`
- `_req_company()`
- `_validate_manual_tax_group()`
- `auth_helper.py`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `ManualCombineGroup`
- `Tax`
- `_parse_date()`
- `_parse_float_safe()`
- `_parse_number_value()`
- `_req_company()`
- `_validate_manual_tax_group()`

---

## 📁 Folder: `backend/routes/reports`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `backend/routes/reports/__init__.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `31` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `summary.py`

**Dipakai Oleh:**

- `backend/routes/reports/annual.py`

---

### File: `backend/routes/reports/annual.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `126` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `get_annual_report()`
- `get_annual_report_pdf()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `User`
- `_annual_cache_paths()`
- `_build_annual_payload_from_db()`
- `_build_annual_pdf_bytes()`
- `_is_true()`
- `_load_annual_payload_cache()`
- `_parse_iso_date()`
- `_save_annual_payload_cache()`
- `_save_annual_pdf_cache()`

**Memanggil Fungsi/Modul:**

- `_build_annual_payload_from_db()`
- `_build_annual_pdf_bytes()`
- `_parse_iso_date()`
- `_save_annual_payload_cache()`
- `_save_annual_pdf_cache()`

---

### File: `backend/routes/reports/annual_constants.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `44` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Dipakai Oleh:**

- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_tables.py`

---

### File: `backend/routes/reports/annual_data.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `64` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `Category`
- `CategoryGroup`
- `Dividend`
- `DividendSetting`
- `Expense`
- `Revenue`
- `Settlement`
- `Tax`

---

### File: `backend/routes/reports/annual_excel.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `44` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_clone_row_format()`
- `_clone_sheet_from_template()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_ensure_formatted_secondary_sheets()`
- `_replace_text_in_sheet()`
- `_safe_merge_cells_sheet()`
- `_set_merged_top_alignment()`
- `_sheet_ref()`
- `_sum_sheet_column_formula()`
- `_sync_formatted_secondary_sheets()`
- `_write_secondary_summary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`
- `_to_float()`

**Memanggil Fungsi/Modul:**

- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_expense_amount_for_display()`
- `_get_revenue_bounds()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

---

### File: `backend/routes/reports/annual_excel.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `44` | **Lokasi:** `L119`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_clone_row_format()`
- `_clone_sheet_from_template()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_ensure_formatted_secondary_sheets()`
- `_replace_text_in_sheet()`
- `_safe_merge_cells_sheet()`
- `_set_merged_top_alignment()`
- `_sheet_ref()`
- `_sum_sheet_column_formula()`
- `_sync_formatted_secondary_sheets()`
- `_write_secondary_summary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`
- `_to_float()`

**Memanggil Fungsi/Modul:**

- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_expense_amount_for_display()`
- `_get_revenue_bounds()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

---

### File: `backend/routes/reports/annual_excel.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `44` | **Lokasi:** `L177`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_clone_row_format()`
- `_clone_sheet_from_template()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_ensure_formatted_secondary_sheets()`
- `_replace_text_in_sheet()`
- `_safe_merge_cells_sheet()`
- `_set_merged_top_alignment()`
- `_sheet_ref()`
- `_sum_sheet_column_formula()`
- `_sync_formatted_secondary_sheets()`
- `_write_secondary_summary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`
- `_to_float()`

**Memanggil Fungsi/Modul:**

- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_expense_amount_for_display()`
- `_get_revenue_bounds()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

---

### File: `backend/routes/reports/annual_excel.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `44` | **Lokasi:** `L206`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_clone_row_format()`
- `_clone_sheet_from_template()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_ensure_formatted_secondary_sheets()`
- `_replace_text_in_sheet()`
- `_safe_merge_cells_sheet()`
- `_set_merged_top_alignment()`
- `_sheet_ref()`
- `_sum_sheet_column_formula()`
- `_sync_formatted_secondary_sheets()`
- `_write_secondary_summary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`
- `_to_float()`

**Memanggil Fungsi/Modul:**

- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_expense_amount_for_display()`
- `_get_revenue_bounds()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

---

### File: `backend/routes/reports/annual_excel.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `44` | **Lokasi:** `L53`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_clone_row_format()`
- `_clone_sheet_from_template()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_ensure_formatted_secondary_sheets()`
- `_replace_text_in_sheet()`
- `_safe_merge_cells_sheet()`
- `_set_merged_top_alignment()`
- `_sheet_ref()`
- `_sum_sheet_column_formula()`
- `_sync_formatted_secondary_sheets()`
- `_write_secondary_summary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`
- `_to_float()`

**Memanggil Fungsi/Modul:**

- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_expense_amount_for_display()`
- `_get_revenue_bounds()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

---

### File: `backend/routes/reports/annual_helpers.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `44` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_clear_merged_ranges_in_region()`
- `_compute_dividend_distribution_v2()`
- `_extract_subcategory_from_description()`
- `_root_category_info()`
- `_set_dividend_row_border()`
- `_subcategory_sort_key()`
- `_write_dynamic_category_headers()`

**Bergantung Pada (Internal Imports):**

- `_safe_text()`

**Memanggil Fungsi/Modul:**

- `_safe_text()`

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_tables.py`

---

### File: `backend/routes/reports/annual_helpers.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `44` | **Lokasi:** `L103`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_clear_merged_ranges_in_region()`
- `_compute_dividend_distribution_v2()`
- `_extract_subcategory_from_description()`
- `_root_category_info()`
- `_set_dividend_row_border()`
- `_subcategory_sort_key()`
- `_write_dynamic_category_headers()`

**Bergantung Pada (Internal Imports):**

- `_safe_text()`

**Memanggil Fungsi/Modul:**

- `_safe_text()`

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_tables.py`

---

### File: `backend/routes/reports/annual_helpers.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `44` | **Lokasi:** `L189`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_clear_merged_ranges_in_region()`
- `_compute_dividend_distribution_v2()`
- `_extract_subcategory_from_description()`
- `_root_category_info()`
- `_set_dividend_row_border()`
- `_subcategory_sort_key()`
- `_write_dynamic_category_headers()`

**Bergantung Pada (Internal Imports):**

- `_safe_text()`

**Memanggil Fungsi/Modul:**

- `_safe_text()`

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_tables.py`

---

### File: `backend/routes/reports/annual_helpers.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `44` | **Lokasi:** `L74`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_clear_merged_ranges_in_region()`
- `_compute_dividend_distribution_v2()`
- `_extract_subcategory_from_description()`
- `_root_category_info()`
- `_set_dividend_row_border()`
- `_subcategory_sort_key()`
- `_write_dynamic_category_headers()`

**Bergantung Pada (Internal Imports):**

- `_safe_text()`

**Memanggil Fungsi/Modul:**

- `_safe_text()`

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_tables.py`

---

### File: `backend/routes/reports/annual_tables.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `15` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `Category`
- `ManualCombineGroup`
- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_as_iso_date()`
- `_build_annual_pdf_bytes()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`

---

### File: `backend/routes/reports/summary.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `31` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `export_summary_pdf()`
- `get_summary_report()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `Category`
- `Expense`
- `Settlement`
- `User`
- `_build_summary_payload()`
- `_default_report_year()`
- `_display_settlement_status()`
- `_expense_amount_for_summary()`
- `_get_display_subcategory()`

**Memanggil Fungsi/Modul:**

- `_build_summary_payload()`
- `_get_summary_approved_expenses()`
- `_parse_iso_date()`
- `_year_date_bounds()`

**Dipakai Oleh:**

- `backend/routes/reports/__init__.py`

---

## 📁 Folder: `backend/routes/settings`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `backend/routes/settings/__init__.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `27` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `profile.py`

**Dipakai Oleh:**

- `backend/routes/settings/db_storage.py`
- `backend/routes/settings/deadline.py`

---

### File: `backend/routes/settings/db_storage.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `27` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `export_database()`
- `import_database_confirm()`
- `import_database_preview()`
- `manage_storage()`

**Bergantung Pada (Internal Imports):**

- `DeadlineSetting`
- `Expense`
- `User`
- `_require_manager()`
- `auth_helper.py`
- `models/__init__.py`
- `settings/__init__.py`

**Memanggil Fungsi/Modul:**

- `_require_manager()`

---

### File: `backend/routes/settings/deadline.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `27` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `manage_deadline_settings()`

**Bergantung Pada (Internal Imports):**

- `DeadlineSetting`
- `User`
- `_find_deadline_setting()`
- `_normalize_deadline_rule_key()`
- `_require_manager()`
- `_sanitize_deadline_days()`
- `auth_helper.py`
- `models/__init__.py`
- `settings/__init__.py`

**Memanggil Fungsi/Modul:**

- `DeadlineSetting`
- `_find_deadline_setting()`
- `_normalize_deadline_rule_key()`
- `_require_manager()`
- `_sanitize_deadline_days()`

---

### File: `backend/routes/settings/profile.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `27` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_companies()`
- `manage_report_year()`

**Bergantung Pada (Internal Imports):**

- `DeadlineSetting`
- `User`
- `models/__init__.py`

**Dipakai Oleh:**

- `backend/routes/settings/__init__.py`

---

### File: `backend/routes/settings/profile.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `27` | **Lokasi:** `L13`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_companies()`
- `manage_report_year()`

**Bergantung Pada (Internal Imports):**

- `DeadlineSetting`
- `User`
- `models/__init__.py`

**Dipakai Oleh:**

- `backend/routes/settings/__init__.py`

---

## 📁 Folder: `backend/routes/settlements`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `backend/routes/settlements/__init__.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `208` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/routes/settlements/settlements.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `13` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `settlements_approval.py`
- `settlements_crud.py`
- `settlements_disbursement.py`
- `settlements_expenses.py`
- `settlements_other.py`

---

### File: `backend/routes/settlements/settlements_approval.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `37` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `approve_settlement()`
- `complete_settlement()`
- `final_approve_settlement()`
- `reject_all_expenses()`
- `submit_settlement()`

**Bergantung Pada (Internal Imports):**

- `process_approve_settlement()`
- `process_complete_settlement()`
- `process_final_approve_settlement()`
- `process_reject_all_expenses()`
- `process_submit_settlement()`

**Memanggil Fungsi/Modul:**

- `process_approve_settlement()`
- `process_complete_settlement()`
- `process_final_approve_settlement()`
- `process_reject_all_expenses()`
- `process_submit_settlement()`

**Dipakai Oleh:**

- `backend/routes/settlements/settlements.py`

---

### File: `backend/routes/settlements/settlements_crud.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `138` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_settlement()`
- `delete_settlement()`
- `get_settlement()`
- `get_settlement_history()`
- `list_settlements()`
- `update_settlement()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `Expense`
- `Settlement`
- `User`
- `WorkflowLog`
- `_req_company()`
- `_sync_advance_after_settlement()`
- `auth_helper.py`
- `models/__init__.py`
- `rollback_settlement_transactions()`

**Memanggil Fungsi/Modul:**

- `Expense`
- `Settlement`
- `_req_company()`
- `_sync_advance_after_settlement()`
- `rollback_settlement_transactions()`

**Dipakai Oleh:**

- `backend/routes/settlements/settlements.py`

---

### File: `backend/routes/settlements/settlements_disbursement.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `1` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `approve_disbursement()`
- `save_disbursement()`
- `save_return()`
- `standalone_return()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `OverrideLog`
- `Settlement`
- `User`
- `allowed_file()`
- `calculate_bank_composition()`
- `calculate_bank_real_balance()`
- `calculate_user_available_budget()`

**Memanggil Fungsi/Modul:**

- `Advance`
- `BankTransaction`
- `OverrideLog`
- `Settlement`
- `allowed_file()`
- `calculate_bank_real_balance()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance()`
- `get_all_users_balance_breakdown()`
- `log_workflow()`

**Dipakai Oleh:**

- `backend/routes/settlements/settlements.py`

---

### File: `backend/routes/settlements/settlements_expenses.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `13` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `update_expense()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `Expense`
- `User`
- `_has_unchecked_checklist()`
- `models/__init__.py`
- `parsing_helper.py`

**Memanggil Fungsi/Modul:**

- `_has_unchecked_checklist()`

**Dipakai Oleh:**

- `backend/routes/settlements/settlements.py`

---

### File: `backend/routes/settlements/settlements_other.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `13` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `move_to_draft()`
- `override_settlement()`

**Bergantung Pada (Internal Imports):**

- `Settlement`
- `User`
- `models/__init__.py`
- `rollback_settlement_transactions()`

**Memanggil Fungsi/Modul:**

- `rollback_settlement_transactions()`

**Dipakai Oleh:**

- `backend/routes/settlements/settlements.py`

---

## 📁 Folder: `backend/routes/transactions`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `backend/routes/transactions/__init__.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `209` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/routes/transactions/assets.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `26` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_asset()`
- `delete_asset()`
- `list_assets()`
- `update_asset()`

**Bergantung Pada (Internal Imports):**

- `Asset`
- `User`
- `_calculate_asset_depreciation()`
- `_req_company()`
- `auth_helper.py`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `Asset`
- `_calculate_asset_depreciation()`
- `_req_company()`

---

### File: `backend/routes/transactions/dividends.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `20` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_dividend()`
- `delete_dividend()`
- `get_dividend()`
- `get_dividends()`
- `update_dividend()`
- `update_dividend_setting()`

**Bergantung Pada (Internal Imports):**

- `Dividend`
- `DividendSetting`
- `Expense`
- `Revenue`
- `Settlement`
- `User`
- `_build_dividend_payload()`
- `_compute_dividend_distribution_v2()`
- `_fetch_revenues_and_expenses_for_year()`
- `_parse_date()`

**Memanggil Fungsi/Modul:**

- `Dividend`
- `DividendSetting`
- `_build_dividend_payload()`
- `_parse_date()`
- `_parse_float_safe()`
- `_req_company()`

---

### File: `backend/routes/transactions/expenses.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `13` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `approve_expense()`
- `bulk_delete_expenses()`
- `create_expense()`
- `delete_expense()`
- `list_categories()`
- `reject_expense()`
- `serve_evidence()`
- `update_expense()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `Expense`
- `Settlement`
- `User`
- `_merge_rejection_notes()`
- `_parse_category_ids()`
- `_parse_checklist_notes()`
- `_req_company()`
- `allowed_file()`
- `auth_helper.py`

**Memanggil Fungsi/Modul:**

- `Expense`
- `_merge_rejection_notes()`
- `_parse_category_ids()`
- `_req_company()`
- `allowed_file()`
- `delete_evidence_file()`
- `notify_expense_approved()`
- `notify_expense_rejected()`

---

### File: `backend/routes/transactions/revenues.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `55` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (9 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_revenue()`
- `create_revenue_combine_group()`
- `delete_revenue()`
- `delete_revenue_combine_group()`
- `get_revenue()`
- `get_revenue_combine_groups()`
- `get_revenues()`
- `toggle_tax_offset()`
- `update_revenue()`

**Bergantung Pada (Internal Imports):**

- `ManualCombineGroup`
- `Revenue`
- `User`
- `_parse_date()`
- `_parse_float_safe()`
- `_parse_number_value()`
- `_req_company()`
- `_validate_manual_revenue_group()`
- `auth_helper.py`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `.normalize_revenue_type()`
- `ManualCombineGroup`
- `Revenue`
- `_parse_date()`
- `_parse_float_safe()`
- `_parse_number_value()`
- `_req_company()`
- `_validate_manual_revenue_group()`

---

## 📁 Folder: `backend/services/advances`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/advances/__init__.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `211` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/advances/advance_approval_service.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `1` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `process_approve_advance()`
- `process_final_approve_advance()`
- `process_approve_advance_item()`
- `process_reject_advance()`
- `process_reject_advance_item()`
- `process_start_revision()`
- `process_submit_advance()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `BankAccount`
- `BankTransaction`
- `Notification`
- `OverrideLog`
- `Settlement`
- `User`
- `_advance_view_status_filter()`
- `_editable_revision_no()`

**Memanggil Fungsi/Modul:**

- `BankAccount`
- `BankTransaction`
- `OverrideLog`
- `_has_unchecked_checklist()`
- `_has_unchecked_return_checklist()`
- `_items_for_revision()`
- `_merge_rejection_notes()`
- `_next_revision_no()`
- `_status_after_approval()`
- `calculate_user_available_budget()`

**Dipakai Oleh:**

- `backend/routes/advances/advances_approval.py`

---

### File: `backend/services/advances/advance_items_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `13` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Classes / Models:**

- `AdvanceItemsService` (L14)

**Fungsi / Metode:**

- `.add_advance_item()`
- `.bulk_delete_advance_items()`
- `.delete_advance_item()`
- `.update_advance_item()`
- `.update_advance_items_bulk()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `BankAccount`
- `Category`
- `User`
- `_editable_revision_no()`
- `_has_unchecked_checklist()`
- `_items_for_revision()`
- `_req_company()`
- `allowed_file()`

**Memanggil Fungsi/Modul:**

- `AdvanceItem`
- `_editable_revision_no()`
- `_has_unchecked_checklist()`
- `_items_for_revision()`
- `_req_company()`
- `allowed_file()`
- `calculate_bank_real_balance()`
- `calculate_user_running_balance()`
- `delete_evidence_file()`
- `get_cash_composition_for_error()`

**Dipakai Oleh:**

- `backend/routes/advances/advances_items.py`

---

## 📁 Folder: `backend/services/approvals`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/approvals/__init__.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `212` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/approvals/advance_helpers.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `1` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_cash_composition_for_error()`
- `_items_for_revision()`
- `_next_revision_no()`
- `normalize_source()`
- `_status_after_approval()`
- `_editable_revision_no()`
- `_advance_view_status_filter()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `BankAccount`
- `calculate_bank_composition()`
- `calculate_bank_real_balance()`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `calculate_bank_composition()`
- `calculate_bank_real_balance()`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_items.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`
- `backend/services/advances/advance_items_service.py`

---

### File: `backend/services/approvals/settlement_helpers.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `1` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `rollback_settlement_transactions()`
- `_sync_advance_after_settlement()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankTransaction`
- `OverrideLog`
- `calculate_user_available_budget()`
- `calculate_user_running_balance()`
- `get_all_users_balance_breakdown()`
- `log_workflow()`
- `models/__init__.py`
- `workflow_helper.py`

**Memanggil Fungsi/Modul:**

- `OverrideLog`
- `calculate_user_available_budget()`
- `calculate_user_running_balance()`
- `get_all_users_balance_breakdown()`

**Dipakai Oleh:**

- `backend/routes/settlements/settlements_crud.py`
- `backend/routes/settlements/settlements_other.py`
- `backend/services/settlements/settlement_approval_service.py`

---

### File: `backend/services/approvals/settlement_helpers.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `37` | **Lokasi:** `L7`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `rollback_settlement_transactions()`
- `_sync_advance_after_settlement()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankTransaction`
- `OverrideLog`
- `calculate_user_available_budget()`
- `calculate_user_running_balance()`
- `get_all_users_balance_breakdown()`
- `log_workflow()`
- `models/__init__.py`
- `workflow_helper.py`

**Memanggil Fungsi/Modul:**

- `OverrideLog`
- `calculate_user_available_budget()`
- `calculate_user_running_balance()`
- `get_all_users_balance_breakdown()`

**Dipakai Oleh:**

- `backend/routes/settlements/settlements_crud.py`
- `backend/routes/settlements/settlements_other.py`
- `backend/services/settlements/settlement_approval_service.py`

---

## 📁 Folder: `backend/services/balance`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/balance/__init__.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `213` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/balance/balance_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `1` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `calculate_bank_composition()`
- `calculate_bank_real_balance()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance()`
- `calculate_user_running_balance_per_bank()`
- `_get_user_advance_banks()`
- `get_all_bank_real_balances()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `models/__init__.py`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`

---

### File: `backend/services/balance/balance_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `1` | **Lokasi:** `L105`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `calculate_bank_composition()`
- `calculate_bank_real_balance()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance()`
- `calculate_user_running_balance_per_bank()`
- `_get_user_advance_banks()`
- `get_all_bank_real_balances()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `models/__init__.py`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`

---

### File: `backend/services/balance/balance_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `1` | **Lokasi:** `L122`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `calculate_bank_composition()`
- `calculate_bank_real_balance()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance()`
- `calculate_user_running_balance_per_bank()`
- `_get_user_advance_banks()`
- `get_all_bank_real_balances()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `models/__init__.py`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`

---

### File: `backend/services/balance/balance_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `1` | **Lokasi:** `L241`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `calculate_bank_composition()`
- `calculate_bank_real_balance()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance()`
- `calculate_user_running_balance_per_bank()`
- `_get_user_advance_banks()`
- `get_all_bank_real_balances()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `models/__init__.py`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`

---

### File: `backend/services/balance/balance_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `1` | **Lokasi:** `L5`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `calculate_bank_composition()`
- `calculate_bank_real_balance()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance()`
- `calculate_user_running_balance_per_bank()`
- `_get_user_advance_banks()`
- `get_all_bank_real_balances()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `models/__init__.py`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`

---

### File: `backend/services/balance/balance_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `1` | **Lokasi:** `L79`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `calculate_bank_composition()`
- `calculate_bank_real_balance()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance()`
- `calculate_user_running_balance_per_bank()`
- `_get_user_advance_banks()`
- `get_all_bank_real_balances()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `models/__init__.py`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`

---

### File: `backend/services/balance/balance_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `26` | **Lokasi:** `L171`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `calculate_bank_composition()`
- `calculate_bank_real_balance()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance()`
- `calculate_user_running_balance_per_bank()`
- `_get_user_advance_banks()`
- `get_all_bank_real_balances()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `models/__init__.py`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`

---

### File: `backend/services/balance/user_balance_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `1` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_all_users_balance_breakdown()`
- `get_user_balance_breakdown()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `Settlement`
- `User`
- `calculate_bank_composition()`
- `calculate_bank_real_balance()`
- `calculate_user_running_balance()`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `calculate_bank_composition()`
- `calculate_bank_real_balance()`
- `calculate_user_running_balance()`

**Dipakai Oleh:**

- `backend/routes/core/auth.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`
- `backend/services/approvals/settlement_helpers.py`
- `backend/services/settlements/settlement_approval_service.py`

---

## 📁 Folder: `backend/services/core`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/core/__init__.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `214` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/core/auth_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `27` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_internal_login()`

**Bergantung Pada (Internal Imports):**

- `User`
- `models/__init__.py`
- `notify_user_returned()`

**Memanggil Fungsi/Modul:**

- `notify_user_returned()`

**Dipakai Oleh:**

- `backend/routes/core/auth.py`

---

### File: `backend/services/core/email_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `30` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `generate_otp()`
- `send_reset_password_otp()`
- `init_mail()`

**Dipakai Oleh:**

- `backend/app.py`
- `backend/routes/core/auth.py`

---

### File: `backend/services/core/notification_events.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `110` | **Lokasi:** `L344`

**Risiko:** 🟢 **Aman** (33 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `notify_advance_approved_final()`
- `_can_access_notification()`
- `notify_expense_approved()`
- `notify_expense_rejected()`
- `notify_bank_transaction_created()`
- `create_notification()`
- `_expense_owner_id()`
- `notify_advance_item_approved()`
- `notify_advance_item_rejected()`
- `notify_advance_rejected_final()`
- `notify_advance_revision_started()`
- `notify_advance_submitted()`
- `notify_asset_created()`
- `notify_asset_deleted()`
- `notify_asset_updated()`
- `notify_bank_created()`
- `notify_category_rejected()`
- `notify_managers()`
- `notify_revenue_created()`
- `notify_revenue_deleted()`
- *(... dan 13 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `_req_company()`
- `auth_helper.py`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `Notification`
- `_req_company()`

**Dipakai Oleh:**

- `backend/routes/core/auth.py`
- `backend/routes/core/notifications.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/master_data/categories.py`
- `backend/routes/transactions/expenses.py`
- `backend/services/advances/advance_approval_service.py`
- `backend/services/core/auth_service.py`

---

### File: `backend/services/core/notification_events.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `32` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (33 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `notify_advance_approved_final()`
- `_can_access_notification()`
- `notify_expense_approved()`
- `notify_expense_rejected()`
- `notify_bank_transaction_created()`
- `create_notification()`
- `_expense_owner_id()`
- `notify_advance_item_approved()`
- `notify_advance_item_rejected()`
- `notify_advance_rejected_final()`
- `notify_advance_revision_started()`
- `notify_advance_submitted()`
- `notify_asset_created()`
- `notify_asset_deleted()`
- `notify_asset_updated()`
- `notify_bank_created()`
- `notify_category_rejected()`
- `notify_managers()`
- `notify_revenue_created()`
- `notify_revenue_deleted()`
- *(... dan 13 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `_req_company()`
- `auth_helper.py`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `Notification`
- `_req_company()`

**Dipakai Oleh:**

- `backend/routes/core/auth.py`
- `backend/routes/core/notifications.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/master_data/categories.py`
- `backend/routes/transactions/expenses.py`
- `backend/services/advances/advance_approval_service.py`
- `backend/services/core/auth_service.py`

---

### File: `backend/services/core/notification_events.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `32` | **Lokasi:** `L32`

**Risiko:** 🟢 **Aman** (33 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `notify_advance_approved_final()`
- `_can_access_notification()`
- `notify_expense_approved()`
- `notify_expense_rejected()`
- `notify_bank_transaction_created()`
- `create_notification()`
- `_expense_owner_id()`
- `notify_advance_item_approved()`
- `notify_advance_item_rejected()`
- `notify_advance_rejected_final()`
- `notify_advance_revision_started()`
- `notify_advance_submitted()`
- `notify_asset_created()`
- `notify_asset_deleted()`
- `notify_asset_updated()`
- `notify_bank_created()`
- `notify_category_rejected()`
- `notify_managers()`
- `notify_revenue_created()`
- `notify_revenue_deleted()`
- *(... dan 13 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `_req_company()`
- `auth_helper.py`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `Notification`
- `_req_company()`

**Dipakai Oleh:**

- `backend/routes/core/auth.py`
- `backend/routes/core/notifications.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/master_data/categories.py`
- `backend/routes/transactions/expenses.py`
- `backend/services/advances/advance_approval_service.py`
- `backend/services/core/auth_service.py`

---

### File: `backend/services/core/notification_events.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `32` | **Lokasi:** `L5`

**Risiko:** 🟢 **Aman** (33 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `notify_advance_approved_final()`
- `_can_access_notification()`
- `notify_expense_approved()`
- `notify_expense_rejected()`
- `notify_bank_transaction_created()`
- `create_notification()`
- `_expense_owner_id()`
- `notify_advance_item_approved()`
- `notify_advance_item_rejected()`
- `notify_advance_rejected_final()`
- `notify_advance_revision_started()`
- `notify_advance_submitted()`
- `notify_asset_created()`
- `notify_asset_deleted()`
- `notify_asset_updated()`
- `notify_bank_created()`
- `notify_category_rejected()`
- `notify_managers()`
- `notify_revenue_created()`
- `notify_revenue_deleted()`
- *(... dan 13 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `_req_company()`
- `auth_helper.py`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `Notification`
- `_req_company()`

**Dipakai Oleh:**

- `backend/routes/core/auth.py`
- `backend/routes/core/notifications.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/master_data/categories.py`
- `backend/routes/transactions/expenses.py`
- `backend/services/advances/advance_approval_service.py`
- `backend/services/core/auth_service.py`

---

### File: `backend/services/core/notification_events.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `32` | **Lokasi:** `L52`

**Risiko:** 🟢 **Aman** (33 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `notify_advance_approved_final()`
- `_can_access_notification()`
- `notify_expense_approved()`
- `notify_expense_rejected()`
- `notify_bank_transaction_created()`
- `create_notification()`
- `_expense_owner_id()`
- `notify_advance_item_approved()`
- `notify_advance_item_rejected()`
- `notify_advance_rejected_final()`
- `notify_advance_revision_started()`
- `notify_advance_submitted()`
- `notify_asset_created()`
- `notify_asset_deleted()`
- `notify_asset_updated()`
- `notify_bank_created()`
- `notify_category_rejected()`
- `notify_managers()`
- `notify_revenue_created()`
- `notify_revenue_deleted()`
- *(... dan 13 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `_req_company()`
- `auth_helper.py`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `Notification`
- `_req_company()`

**Dipakai Oleh:**

- `backend/routes/core/auth.py`
- `backend/routes/core/notifications.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/master_data/categories.py`
- `backend/routes/transactions/expenses.py`
- `backend/services/advances/advance_approval_service.py`
- `backend/services/core/auth_service.py`

---

### File: `backend/services/core/settings_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `27` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_find_deadline_setting()`
- `_normalize_deadline_rule_key()`
- `_sanitize_deadline_days()`

**Bergantung Pada (Internal Imports):**

- `DeadlineSetting`
- `models/__init__.py`

**Dipakai Oleh:**

- `backend/routes/settings/deadline.py`

---

### File: `backend/services/core/storage_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `30` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `allowed_file()`
- `handle_profile_image_removal()`
- `handle_profile_image_upload()`

**Dipakai Oleh:**

- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/core/auth.py`
- `backend/routes/settlements/settlements_disbursement.py`

---

### File: `backend/services/core/storage_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `30` | **Lokasi:** `L12`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `allowed_file()`
- `handle_profile_image_removal()`
- `handle_profile_image_upload()`

**Dipakai Oleh:**

- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/core/auth.py`
- `backend/routes/settlements/settlements_disbursement.py`

---

### File: `backend/services/core/storage_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `30` | **Lokasi:** `L41`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `allowed_file()`
- `handle_profile_image_removal()`
- `handle_profile_image_upload()`

**Dipakai Oleh:**

- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/core/auth.py`
- `backend/routes/settlements/settlements_disbursement.py`

---

## 📁 Folder: `backend/services/dto`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/dto/__init__.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `215` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/dto/transaction_dto.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `20` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (9 fungsi/metode terdeteksi).

**Classes / Models:**

- `TransactionDTO` (L7)

**Fungsi / Metode:**

- `.manualcombinegroup_to_dict()`
- `.advance_to_dict()`
- `.advanceitem_to_dict()`
- `.dividend_to_dict()`
- `.dividendsetting_to_dict()`
- `.expense_to_dict()`
- `.revenue_to_dict()`
- `.settlement_to_dict()`
- `.tax_to_dict()`

**Bergantung Pada (Internal Imports):**

- `calculate_user_running_balance()`

**Memanggil Fungsi/Modul:**

- `calculate_user_running_balance()`

**Dipakai Oleh:**

- `backend/models/transaction.py`

---

### File: `backend/services/dto/transaction_dto.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `20` | **Lokasi:** `L297`

**Risiko:** 🟢 **Aman** (9 fungsi/metode terdeteksi).

**Classes / Models:**

- `TransactionDTO` (L7)

**Fungsi / Metode:**

- `.manualcombinegroup_to_dict()`
- `.advance_to_dict()`
- `.advanceitem_to_dict()`
- `.dividend_to_dict()`
- `.dividendsetting_to_dict()`
- `.expense_to_dict()`
- `.revenue_to_dict()`
- `.settlement_to_dict()`
- `.tax_to_dict()`

**Bergantung Pada (Internal Imports):**

- `calculate_user_running_balance()`

**Memanggil Fungsi/Modul:**

- `calculate_user_running_balance()`

**Dipakai Oleh:**

- `backend/models/transaction.py`

---

## 📁 Folder: `backend/services/master_data`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/master_data/__init__.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `216` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/master_data/tax_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `1` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_validate_manual_tax_group()`

**Bergantung Pada (Internal Imports):**

- `ManualCombineGroup`
- `Tax`
- `_req_company()`
- `auth_helper.py`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `_req_company()`

**Dipakai Oleh:**

- `backend/routes/master_data/taxes.py`

---

## 📁 Folder: `backend/services/reports/annual_service`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/reports/annual_service/__init__.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `217` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/reports/annual_service/annual_constants.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Dipakai Oleh:**

- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/services/reports/annual_service/annual_data.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `64` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `Category`
- `CategoryGroup`
- `Dividend`
- `DividendSetting`
- `Expense`
- `Revenue`
- `Settlement`
- `Tax`

---

### File: `backend/services/reports/annual_service/annual_excel.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_set_merged_top_alignment()`
- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_clone_row_format()`
- `_clone_sheet_from_template()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_ensure_formatted_secondary_sheets()`
- `_replace_text_in_sheet()`
- `_safe_merge_cells_sheet()`
- `_sheet_ref()`
- `_sum_sheet_column_formula()`
- `_sync_formatted_secondary_sheets()`
- `_write_secondary_summary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`
- `_to_float()`

**Memanggil Fungsi/Modul:**

- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_expense_amount_for_display()`
- `_get_revenue_bounds()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

**Dipakai Oleh:**

- `backend/services/reports/annual_service/caching.py`
- `backend/services/reports/annual_service/excel_generator.py`
- `backend/services/reports/table_builder/expense_renderer.py`
- `backend/services/reports/table_builder/revenue_helpers.py`

---

### File: `backend/services/reports/annual_service/annual_excel.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L119`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_set_merged_top_alignment()`
- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_clone_row_format()`
- `_clone_sheet_from_template()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_ensure_formatted_secondary_sheets()`
- `_replace_text_in_sheet()`
- `_safe_merge_cells_sheet()`
- `_sheet_ref()`
- `_sum_sheet_column_formula()`
- `_sync_formatted_secondary_sheets()`
- `_write_secondary_summary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`
- `_to_float()`

**Memanggil Fungsi/Modul:**

- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_expense_amount_for_display()`
- `_get_revenue_bounds()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

**Dipakai Oleh:**

- `backend/services/reports/annual_service/caching.py`
- `backend/services/reports/annual_service/excel_generator.py`
- `backend/services/reports/table_builder/expense_renderer.py`
- `backend/services/reports/table_builder/revenue_helpers.py`

---

### File: `backend/services/reports/annual_service/annual_excel.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L177`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_set_merged_top_alignment()`
- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_clone_row_format()`
- `_clone_sheet_from_template()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_ensure_formatted_secondary_sheets()`
- `_replace_text_in_sheet()`
- `_safe_merge_cells_sheet()`
- `_sheet_ref()`
- `_sum_sheet_column_formula()`
- `_sync_formatted_secondary_sheets()`
- `_write_secondary_summary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`
- `_to_float()`

**Memanggil Fungsi/Modul:**

- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_expense_amount_for_display()`
- `_get_revenue_bounds()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

**Dipakai Oleh:**

- `backend/services/reports/annual_service/caching.py`
- `backend/services/reports/annual_service/excel_generator.py`
- `backend/services/reports/table_builder/expense_renderer.py`
- `backend/services/reports/table_builder/revenue_helpers.py`

---

### File: `backend/services/reports/annual_service/annual_excel.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L206`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_set_merged_top_alignment()`
- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_clone_row_format()`
- `_clone_sheet_from_template()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_ensure_formatted_secondary_sheets()`
- `_replace_text_in_sheet()`
- `_safe_merge_cells_sheet()`
- `_sheet_ref()`
- `_sum_sheet_column_formula()`
- `_sync_formatted_secondary_sheets()`
- `_write_secondary_summary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`
- `_to_float()`

**Memanggil Fungsi/Modul:**

- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_expense_amount_for_display()`
- `_get_revenue_bounds()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

**Dipakai Oleh:**

- `backend/services/reports/annual_service/caching.py`
- `backend/services/reports/annual_service/excel_generator.py`
- `backend/services/reports/table_builder/expense_renderer.py`
- `backend/services/reports/table_builder/revenue_helpers.py`

---

### File: `backend/services/reports/annual_service/annual_excel.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L53`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_set_merged_top_alignment()`
- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_clone_row_format()`
- `_clone_sheet_from_template()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_ensure_formatted_secondary_sheets()`
- `_replace_text_in_sheet()`
- `_safe_merge_cells_sheet()`
- `_sheet_ref()`
- `_sum_sheet_column_formula()`
- `_sync_formatted_secondary_sheets()`
- `_write_secondary_summary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`
- `_to_float()`

**Memanggil Fungsi/Modul:**

- `CategoryGroup`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_expense_amount_for_display()`
- `_get_revenue_bounds()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

**Dipakai Oleh:**

- `backend/services/reports/annual_service/caching.py`
- `backend/services/reports/annual_service/excel_generator.py`
- `backend/services/reports/table_builder/expense_renderer.py`
- `backend/services/reports/table_builder/revenue_helpers.py`

---

### File: `backend/services/reports/annual_service/annual_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_subcategory_sort_key()`
- `_clear_merged_ranges_in_region()`
- `_extract_subcategory_from_description()`
- `_root_category_info()`
- `_set_dividend_row_border()`
- `_write_dynamic_category_headers()`
- `_compute_dividend_distribution_v2()`

**Bergantung Pada (Internal Imports):**

- `_safe_text()`

**Memanggil Fungsi/Modul:**

- `_safe_text()`

**Dipakai Oleh:**

- `backend/routes/transactions/dividends.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_tables.py`
- `backend/services/reports/annual_service/caching.py`
- `backend/services/reports/annual_service/excel_generator.py`
- `backend/services/reports/data_fetcher/db_fetchers.py`
- `backend/services/reports/data_fetcher/depreciation.py`

---

### File: `backend/services/reports/annual_service/annual_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L103`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_subcategory_sort_key()`
- `_clear_merged_ranges_in_region()`
- `_extract_subcategory_from_description()`
- `_root_category_info()`
- `_set_dividend_row_border()`
- `_write_dynamic_category_headers()`
- `_compute_dividend_distribution_v2()`

**Bergantung Pada (Internal Imports):**

- `_safe_text()`

**Memanggil Fungsi/Modul:**

- `_safe_text()`

**Dipakai Oleh:**

- `backend/routes/transactions/dividends.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_tables.py`
- `backend/services/reports/annual_service/caching.py`
- `backend/services/reports/annual_service/excel_generator.py`
- `backend/services/reports/data_fetcher/db_fetchers.py`
- `backend/services/reports/data_fetcher/depreciation.py`

---

### File: `backend/services/reports/annual_service/annual_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L189`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_subcategory_sort_key()`
- `_clear_merged_ranges_in_region()`
- `_extract_subcategory_from_description()`
- `_root_category_info()`
- `_set_dividend_row_border()`
- `_write_dynamic_category_headers()`
- `_compute_dividend_distribution_v2()`

**Bergantung Pada (Internal Imports):**

- `_safe_text()`

**Memanggil Fungsi/Modul:**

- `_safe_text()`

**Dipakai Oleh:**

- `backend/routes/transactions/dividends.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_tables.py`
- `backend/services/reports/annual_service/caching.py`
- `backend/services/reports/annual_service/excel_generator.py`
- `backend/services/reports/data_fetcher/db_fetchers.py`
- `backend/services/reports/data_fetcher/depreciation.py`

---

### File: `backend/services/reports/annual_service/annual_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L74`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_subcategory_sort_key()`
- `_clear_merged_ranges_in_region()`
- `_extract_subcategory_from_description()`
- `_root_category_info()`
- `_set_dividend_row_border()`
- `_write_dynamic_category_headers()`
- `_compute_dividend_distribution_v2()`

**Bergantung Pada (Internal Imports):**

- `_safe_text()`

**Memanggil Fungsi/Modul:**

- `_safe_text()`

**Dipakai Oleh:**

- `backend/routes/transactions/dividends.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_tables.py`
- `backend/services/reports/annual_service/caching.py`
- `backend/services/reports/annual_service/excel_generator.py`
- `backend/services/reports/data_fetcher/db_fetchers.py`
- `backend/services/reports/data_fetcher/depreciation.py`

---

### File: `backend/services/reports/annual_service/annual_tables.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `15` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `Category`
- `ManualCombineGroup`
- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_as_iso_date()`
- `_build_annual_pdf_bytes()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`

---

### File: `backend/services/reports/annual_service/caching.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_annual_cache_paths()`
- `_is_true()`
- `_load_annual_payload_cache()`
- `_save_annual_payload_cache()`
- `_save_annual_pdf_cache()`
- `clear_annual_report_cache()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `User`
- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_clean_currency()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`
- `_clone_row_format()`
- `_copy_template_row_from_backup()`

**Dipakai Oleh:**

- `backend/routes/master_data/categories.py`
- `backend/routes/reports/annual.py`
- `backend/services/reports/annual_service/excel_generator.py`

---

### File: `backend/services/reports/annual_service/caching.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `88` | **Lokasi:** `L152`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_annual_cache_paths()`
- `_is_true()`
- `_load_annual_payload_cache()`
- `_save_annual_payload_cache()`
- `_save_annual_pdf_cache()`
- `clear_annual_report_cache()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `User`
- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_clean_currency()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`
- `_clone_row_format()`
- `_copy_template_row_from_backup()`

**Dipakai Oleh:**

- `backend/routes/master_data/categories.py`
- `backend/routes/reports/annual.py`
- `backend/services/reports/annual_service/excel_generator.py`

---

### File: `backend/services/reports/annual_service/excel_generator.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_annual_report_excel()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `User`
- `_add_image_to_sheet()`
- `_annual_cache_paths()`
- `_apply_autofit_sheet1()`
- `_clean_currency()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`
- `_clone_row_format()`

**Memanggil Fungsi/Modul:**

- `_add_image_to_sheet()`
- `_annual_cache_paths()`
- `_apply_autofit_sheet1()`
- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_build_annual_payload_from_db()`
- `_clean_currency()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`

**Dipakai Oleh:**

- `backend/routes/reports/annual.py`

---

### File: `backend/services/reports/annual_service/excel_generator.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L116`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_annual_report_excel()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `User`
- `_add_image_to_sheet()`
- `_annual_cache_paths()`
- `_apply_autofit_sheet1()`
- `_clean_currency()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`
- `_clone_row_format()`

**Memanggil Fungsi/Modul:**

- `_add_image_to_sheet()`
- `_annual_cache_paths()`
- `_apply_autofit_sheet1()`
- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_build_annual_payload_from_db()`
- `_clean_currency()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`

**Dipakai Oleh:**

- `backend/routes/reports/annual.py`

---

### File: `backend/services/reports/annual_service/excel_generator.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L506`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_annual_report_excel()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `User`
- `_add_image_to_sheet()`
- `_annual_cache_paths()`
- `_apply_autofit_sheet1()`
- `_clean_currency()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`
- `_clone_row_format()`

**Memanggil Fungsi/Modul:**

- `_add_image_to_sheet()`
- `_annual_cache_paths()`
- `_apply_autofit_sheet1()`
- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_build_annual_payload_from_db()`
- `_clean_currency()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`

**Dipakai Oleh:**

- `backend/routes/reports/annual.py`

---

## 📁 Folder: `backend/services/reports/data_fetcher`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/reports/data_fetcher/__init__.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `218` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/reports/data_fetcher/db_fetchers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `64` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (9 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_fetch_advance_items_data()`
- `_fetch_asset_data()`
- `_fetch_bank_transaction_data()`
- `_fetch_dividend_data()`
- `_fetch_expense_data()`
- `_fetch_revenue_data()`
- `_fetch_tax_data()`
- `_has_any_report_tags()`
- `_tagged_ids_for_year()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `Asset`
- `BankStatusTransaction`
- `Category`
- `CategoryGroup`
- `Dividend`
- `DividendSetting`
- `Expense`
- `Revenue`

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/data_fetcher/payload_builder.py`

---

### File: `backend/services/reports/data_fetcher/depreciation.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `1` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_calculate_asset_depreciation()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `Category`
- `CategoryGroup`
- `Dividend`
- `DividendSetting`
- `Expense`
- `Revenue`
- `Settlement`
- `Tax`

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/transactions/assets.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/data_fetcher/payload_builder.py`

---

### File: `backend/services/reports/data_fetcher/payload_builder.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `64` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_build_annual_payload_from_db()`
- `_compute_dividend_distribution()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `Category`
- `CategoryGroup`
- `Dividend`
- `DividendSetting`
- `Expense`
- `Revenue`
- `Settlement`
- `Tax`

**Memanggil Fungsi/Modul:**

- `_calculate_asset_depreciation()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_compute_dividend_distribution_v2()`
- `_fetch_advance_items_data()`
- `_fetch_asset_data()`
- `_fetch_bank_transaction_data()`
- `_fetch_dividend_data()`
- `_fetch_expense_data()`
- `_fetch_revenue_data()`

**Dipakai Oleh:**

- `backend/routes/reports/annual.py`
- `backend/routes/reports/annual_data.py`
- `backend/services/reports/annual_service/annual_data.py`

---

## 📁 Folder: `backend/services/reports/summary_service`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/reports/summary_service/__init__.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `219` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/reports/summary_service/data_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `31` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_build_summary_payload()`
- `_display_settlement_status()`
- `_expense_amount_for_summary()`
- `_get_display_subcategory()`
- `_get_summary_approved_expenses()`
- `_summary_display_category()`
- `_validate_date()`

**Bergantung Pada (Internal Imports):**

- `BankTransaction`
- `Category`
- `Expense`
- `Settlement`
- `models/__init__.py`

**Dipakai Oleh:**

- `backend/routes/reports/summary.py`
- `backend/services/reports/summary_service/excel_generator.py`
- `backend/services/reports/summary_service/pdf_generator.py`

---

### File: `backend/services/reports/summary_service/data_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `31` | **Lokasi:** `L30`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_build_summary_payload()`
- `_display_settlement_status()`
- `_expense_amount_for_summary()`
- `_get_display_subcategory()`
- `_get_summary_approved_expenses()`
- `_summary_display_category()`
- `_validate_date()`

**Bergantung Pada (Internal Imports):**

- `BankTransaction`
- `Category`
- `Expense`
- `Settlement`
- `models/__init__.py`

**Dipakai Oleh:**

- `backend/routes/reports/summary.py`
- `backend/services/reports/summary_service/excel_generator.py`
- `backend/services/reports/summary_service/pdf_generator.py`

---

### File: `backend/services/reports/summary_service/data_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `31` | **Lokasi:** `L49`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_build_summary_payload()`
- `_display_settlement_status()`
- `_expense_amount_for_summary()`
- `_get_display_subcategory()`
- `_get_summary_approved_expenses()`
- `_summary_display_category()`
- `_validate_date()`

**Bergantung Pada (Internal Imports):**

- `BankTransaction`
- `Category`
- `Expense`
- `Settlement`
- `models/__init__.py`

**Dipakai Oleh:**

- `backend/routes/reports/summary.py`
- `backend/services/reports/summary_service/excel_generator.py`
- `backend/services/reports/summary_service/pdf_generator.py`

---

### File: `backend/services/reports/summary_service/data_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `31` | **Lokasi:** `L59`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_build_summary_payload()`
- `_display_settlement_status()`
- `_expense_amount_for_summary()`
- `_get_display_subcategory()`
- `_get_summary_approved_expenses()`
- `_summary_display_category()`
- `_validate_date()`

**Bergantung Pada (Internal Imports):**

- `BankTransaction`
- `Category`
- `Expense`
- `Settlement`
- `models/__init__.py`

**Dipakai Oleh:**

- `backend/routes/reports/summary.py`
- `backend/services/reports/summary_service/excel_generator.py`
- `backend/services/reports/summary_service/pdf_generator.py`

---

### File: `backend/services/reports/summary_service/data_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `31` | **Lokasi:** `L93`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_build_summary_payload()`
- `_display_settlement_status()`
- `_expense_amount_for_summary()`
- `_get_display_subcategory()`
- `_get_summary_approved_expenses()`
- `_summary_display_category()`
- `_validate_date()`

**Bergantung Pada (Internal Imports):**

- `BankTransaction`
- `Category`
- `Expense`
- `Settlement`
- `models/__init__.py`

**Dipakai Oleh:**

- `backend/routes/reports/summary.py`
- `backend/services/reports/summary_service/excel_generator.py`
- `backend/services/reports/summary_service/pdf_generator.py`

---

### File: `backend/services/reports/summary_service/data_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `31` | **Lokasi:** `L97`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_build_summary_payload()`
- `_display_settlement_status()`
- `_expense_amount_for_summary()`
- `_get_display_subcategory()`
- `_get_summary_approved_expenses()`
- `_summary_display_category()`
- `_validate_date()`

**Bergantung Pada (Internal Imports):**

- `BankTransaction`
- `Category`
- `Expense`
- `Settlement`
- `models/__init__.py`

**Dipakai Oleh:**

- `backend/routes/reports/summary.py`
- `backend/services/reports/summary_service/excel_generator.py`
- `backend/services/reports/summary_service/pdf_generator.py`

---

### File: `backend/services/reports/summary_service/excel_generator.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `31` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `generate_excel_advance_report()`
- `generate_excel_report()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `Category`
- `Expense`
- `Settlement`
- `User`
- `_build_summary_payload()`
- `_default_report_year()`
- `_get_summary_approved_expenses()`
- `_parse_iso_date()`

**Memanggil Fungsi/Modul:**

- `_build_summary_payload()`
- `_default_report_year()`
- `_get_summary_approved_expenses()`
- `_parse_iso_date()`

**Dipakai Oleh:**

- `backend/routes/reports/summary.py`

---

### File: `backend/services/reports/summary_service/pdf_generator.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `31` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `generate_bulk_advances_pdf()`
- `generate_bulk_settlements_pdf()`
- `generate_pdf_advance_report()`
- `generate_settlement_receipt()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `Expense`
- `Settlement`
- `User`
- `_display_settlement_status()`
- `_validate_date()`
- `data_helpers.py`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `_display_settlement_status()`

**Dipakai Oleh:**

- `backend/routes/reports/summary.py`

---

## 📁 Folder: `backend/services/reports/table_builder`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/reports/table_builder/__init__.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `220` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/reports/table_builder/expense_renderer.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `15` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_render_expense_section_from_data()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `ManualCombineGroup`
- `_as_iso_date()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`
- `_clone_row_format()`
- `_expense_amount_for_display()`

**Memanggil Fungsi/Modul:**

- `_clean_currency()`
- `_clean_settlement_title()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`
- `_clone_row_format()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_group_expenses_by_subcategory()`
- `_is_batch_settlement()`

**Dipakai Oleh:**

- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_tables.py`
- `backend/services/reports/table_builder/pdf_builder.py`

---

### File: `backend/services/reports/table_builder/expense_renderer_utils.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `15` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_expense_amount_for_display()`
- `_expense_column_mapping_name()`
- `_expense_subcategory_label()`
- `_group_expenses_by_subcategory()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `_idr_from_currency()`
- `_safe_text()`
- `_to_float()`
- `models/__init__.py`
- `report_helpers.py`

**Memanggil Fungsi/Modul:**

- `_idr_from_currency()`
- `_safe_text()`
- `_to_float()`

**Dipakai Oleh:**

- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_tables.py`
- `backend/services/reports/table_builder/expense_renderer.py`
- `backend/services/reports/table_builder/pdf_builder.py`
- `backend/services/reports/table_builder/revenue_helpers.py`

---

### File: `backend/services/reports/table_builder/expense_renderer_utils.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `15` | **Lokasi:** `L133`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_expense_amount_for_display()`
- `_expense_column_mapping_name()`
- `_expense_subcategory_label()`
- `_group_expenses_by_subcategory()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `_idr_from_currency()`
- `_safe_text()`
- `_to_float()`
- `models/__init__.py`
- `report_helpers.py`

**Memanggil Fungsi/Modul:**

- `_idr_from_currency()`
- `_safe_text()`
- `_to_float()`

**Dipakai Oleh:**

- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_tables.py`
- `backend/services/reports/table_builder/expense_renderer.py`
- `backend/services/reports/table_builder/pdf_builder.py`
- `backend/services/reports/table_builder/revenue_helpers.py`

---

### File: `backend/services/reports/table_builder/expense_renderer_utils.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `15` | **Lokasi:** `L50`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_expense_amount_for_display()`
- `_expense_column_mapping_name()`
- `_expense_subcategory_label()`
- `_group_expenses_by_subcategory()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `_idr_from_currency()`
- `_safe_text()`
- `_to_float()`
- `models/__init__.py`
- `report_helpers.py`

**Memanggil Fungsi/Modul:**

- `_idr_from_currency()`
- `_safe_text()`
- `_to_float()`

**Dipakai Oleh:**

- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_tables.py`
- `backend/services/reports/table_builder/expense_renderer.py`
- `backend/services/reports/table_builder/pdf_builder.py`
- `backend/services/reports/table_builder/revenue_helpers.py`

---

### File: `backend/services/reports/table_builder/pdf_builder.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `15` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_build_annual_pdf_bytes()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `ManualCombineGroup`
- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_as_iso_date()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`

**Memanggil Fungsi/Modul:**

- `_as_iso_date()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_expense_amount_for_display()`
- `_group_expenses_by_subcategory()`
- `_group_revenues_by_type()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_column()`
- `_root_category_info()`

**Dipakai Oleh:**

- `backend/routes/reports/annual.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/services/reports/table_builder/revenue_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `15` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_group_revenues_by_type()`
- `_manual_combine_groups_by_rows()`
- `_manual_combine_groups_by_table()`
- `_operation_cost_totals_by_column()`
- `_validate_revenue_data()`
- `_get_revenue_bounds()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `ManualCombineGroup`
- `_as_iso_date()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`
- `_expense_amount_for_display()`
- `_expense_column_mapping_name()`

**Memanggil Fungsi/Modul:**

- `_expense_amount_for_display()`
- `_expense_column_mapping_name()`
- `_map_expense_category_index_from_name()`
- `_set_merged_top_alignment()`
- `_to_float()`

**Dipakai Oleh:**

- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_tables.py`
- `backend/services/reports/table_builder/pdf_builder.py`

---

### File: `backend/services/reports/table_builder/revenue_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `15` | **Lokasi:** `L350`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_group_revenues_by_type()`
- `_manual_combine_groups_by_rows()`
- `_manual_combine_groups_by_table()`
- `_operation_cost_totals_by_column()`
- `_validate_revenue_data()`
- `_get_revenue_bounds()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `ManualCombineGroup`
- `_as_iso_date()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`
- `_expense_amount_for_display()`
- `_expense_column_mapping_name()`

**Memanggil Fungsi/Modul:**

- `_expense_amount_for_display()`
- `_expense_column_mapping_name()`
- `_map_expense_category_index_from_name()`
- `_set_merged_top_alignment()`
- `_to_float()`

**Dipakai Oleh:**

- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_tables.py`
- `backend/services/reports/table_builder/pdf_builder.py`

---

### File: `backend/services/reports/table_builder/revenue_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `15` | **Lokasi:** `L366`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_group_revenues_by_type()`
- `_manual_combine_groups_by_rows()`
- `_manual_combine_groups_by_table()`
- `_operation_cost_totals_by_column()`
- `_validate_revenue_data()`
- `_get_revenue_bounds()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `ManualCombineGroup`
- `_as_iso_date()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`
- `_expense_amount_for_display()`
- `_expense_column_mapping_name()`

**Memanggil Fungsi/Modul:**

- `_expense_amount_for_display()`
- `_expense_column_mapping_name()`
- `_map_expense_category_index_from_name()`
- `_set_merged_top_alignment()`
- `_to_float()`

**Dipakai Oleh:**

- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_tables.py`
- `backend/services/reports/table_builder/pdf_builder.py`

---

### File: `backend/services/reports/table_builder/revenue_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `15` | **Lokasi:** `L99`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_group_revenues_by_type()`
- `_manual_combine_groups_by_rows()`
- `_manual_combine_groups_by_table()`
- `_operation_cost_totals_by_column()`
- `_validate_revenue_data()`
- `_get_revenue_bounds()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `ManualCombineGroup`
- `_as_iso_date()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`
- `_expense_amount_for_display()`
- `_expense_column_mapping_name()`

**Memanggil Fungsi/Modul:**

- `_expense_amount_for_display()`
- `_expense_column_mapping_name()`
- `_map_expense_category_index_from_name()`
- `_set_merged_top_alignment()`
- `_to_float()`

**Dipakai Oleh:**

- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_tables.py`
- `backend/services/reports/table_builder/pdf_builder.py`

---

### File: `backend/services/reports/table_builder/revenue_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `44` | **Lokasi:** `L334`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_group_revenues_by_type()`
- `_manual_combine_groups_by_rows()`
- `_manual_combine_groups_by_table()`
- `_operation_cost_totals_by_column()`
- `_validate_revenue_data()`
- `_get_revenue_bounds()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `ManualCombineGroup`
- `_as_iso_date()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`
- `_expense_amount_for_display()`
- `_expense_column_mapping_name()`

**Memanggil Fungsi/Modul:**

- `_expense_amount_for_display()`
- `_expense_column_mapping_name()`
- `_map_expense_category_index_from_name()`
- `_set_merged_top_alignment()`
- `_to_float()`

**Dipakai Oleh:**

- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_tables.py`
- `backend/services/reports/table_builder/pdf_builder.py`

---

## 📁 Folder: `backend/services/settlements`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/settlements/__init__.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `221` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/settlements/settlement_approval_service.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `37` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_calculate_settlement_per_bank_netting()`
- `process_approve_settlement()`
- `process_complete_settlement()`
- `process_final_approve_settlement()`
- `process_reject_all_expenses()`
- `process_submit_settlement()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `Notification`
- `OverrideLog`
- `Settlement`
- `User`
- `_has_unchecked_checklist()`
- `_has_unchecked_return_checklist()`
- `_merge_rejection_notes()`

**Memanggil Fungsi/Modul:**

- `Advance`
- `BankTransaction`
- `OverrideLog`
- `_has_unchecked_checklist()`
- `_has_unchecked_return_checklist()`
- `_merge_rejection_notes()`
- `_sync_advance_after_settlement()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance()`
- `get_all_users_balance_breakdown()`

**Dipakai Oleh:**

- `backend/routes/settlements/settlements_approval.py`

---

### File: `backend/services/settlements/settlement_approval_service.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `37` | **Lokasi:** `L23`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_calculate_settlement_per_bank_netting()`
- `process_approve_settlement()`
- `process_complete_settlement()`
- `process_final_approve_settlement()`
- `process_reject_all_expenses()`
- `process_submit_settlement()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `Notification`
- `OverrideLog`
- `Settlement`
- `User`
- `_has_unchecked_checklist()`
- `_has_unchecked_return_checklist()`
- `_merge_rejection_notes()`

**Memanggil Fungsi/Modul:**

- `Advance`
- `BankTransaction`
- `OverrideLog`
- `_has_unchecked_checklist()`
- `_has_unchecked_return_checklist()`
- `_merge_rejection_notes()`
- `_sync_advance_after_settlement()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance()`
- `get_all_users_balance_breakdown()`

**Dipakai Oleh:**

- `backend/routes/settlements/settlements_approval.py`

---

## 📁 Folder: `backend/services/transactions`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/transactions/__init__.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `222` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/transactions/dividend_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `20` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_build_dividend_payload()`
- `_fetch_revenues_and_expenses_for_year()`

**Bergantung Pada (Internal Imports):**

- `Dividend`
- `DividendSetting`
- `Expense`
- `Revenue`
- `Settlement`
- `_compute_dividend_distribution_v2()`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `_compute_dividend_distribution_v2()`

**Dipakai Oleh:**

- `backend/routes/transactions/dividends.py`

---

### File: `backend/services/transactions/dividend_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `20` | **Lokasi:** `L13`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_build_dividend_payload()`
- `_fetch_revenues_and_expenses_for_year()`

**Bergantung Pada (Internal Imports):**

- `Dividend`
- `DividendSetting`
- `Expense`
- `Revenue`
- `Settlement`
- `_compute_dividend_distribution_v2()`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `_compute_dividend_distribution_v2()`

**Dipakai Oleh:**

- `backend/routes/transactions/dividends.py`

---

### File: `backend/services/transactions/revenue_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `20` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_validate_manual_revenue_group()`

**Bergantung Pada (Internal Imports):**

- `ManualCombineGroup`
- `Revenue`
- `_req_company()`
- `auth_helper.py`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `_req_company()`

**Dipakai Oleh:**

- `backend/routes/transactions/revenues.py`

---

## 📁 Folder: `backend/utils`

**Tujuan Folder:** Menyimpan fungsi utilitas umum (formatting, perhitungan, auth helpers).

### File: `backend/utils/__init__.py`

**Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.

**Community Group:** `223` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/utils/auth_helper.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `26` | **Lokasi:** `L6`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_req_company()`
- `current_user()`
- `_require_manager()`

**Bergantung Pada (Internal Imports):**

- `User`
- `core.py`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_items.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth.py`
- `backend/routes/core/cleanup.py`
- `backend/routes/core/dashboard.py`
- `backend/routes/core/notifications.py`
- `backend/routes/master_data/bank_management.py`

---

### File: `backend/utils/auth_helper.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `27` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_req_company()`
- `current_user()`
- `_require_manager()`

**Bergantung Pada (Internal Imports):**

- `User`
- `core.py`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_items.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth.py`
- `backend/routes/core/cleanup.py`
- `backend/routes/core/dashboard.py`
- `backend/routes/core/notifications.py`
- `backend/routes/master_data/bank_management.py`

---

### File: `backend/utils/auth_helper.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `27` | **Lokasi:** `L10`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_req_company()`
- `current_user()`
- `_require_manager()`

**Bergantung Pada (Internal Imports):**

- `User`
- `core.py`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_items.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth.py`
- `backend/routes/core/cleanup.py`
- `backend/routes/core/dashboard.py`
- `backend/routes/core/notifications.py`
- `backend/routes/master_data/bank_management.py`

---

### File: `backend/utils/auth_helper.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `27` | **Lokasi:** `L18`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_req_company()`
- `current_user()`
- `_require_manager()`

**Bergantung Pada (Internal Imports):**

- `User`
- `core.py`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_items.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth.py`
- `backend/routes/core/cleanup.py`
- `backend/routes/core/dashboard.py`
- `backend/routes/core/notifications.py`
- `backend/routes/master_data/bank_management.py`

---

### File: `backend/utils/constants.py`

**Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.

**Community Group:** `157` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Classes / Models:**

- `RevenueType` (L18)
- `Status` (L1)
- `UserRole` (L22)

---

### File: `backend/utils/deadline_worker.py`

**Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.

**Community Group:** `142` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `check_and_create_deadline_notifications()`
- `_cleanup_stale_deadline_notifications()`
- `_create_deadline_notification_if_missing()`
- `_normalize_rule_key()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `DeadlineSetting`
- `Notification`
- `Settlement`
- `User`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `Notification`

---

### File: `backend/utils/deadline_worker.py`

**Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.

**Community Group:** `142` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `check_and_create_deadline_notifications()`
- `_cleanup_stale_deadline_notifications()`
- `_create_deadline_notification_if_missing()`
- `_normalize_rule_key()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `DeadlineSetting`
- `Notification`
- `Settlement`
- `User`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `Notification`

---

### File: `backend/utils/deadline_worker.py`

**Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.

**Community Group:** `142` | **Lokasi:** `L229`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `check_and_create_deadline_notifications()`
- `_cleanup_stale_deadline_notifications()`
- `_create_deadline_notification_if_missing()`
- `_normalize_rule_key()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `DeadlineSetting`
- `Notification`
- `Settlement`
- `User`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `Notification`

---

### File: `backend/utils/deadline_worker.py`

**Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.

**Community Group:** `142` | **Lokasi:** `L23`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `check_and_create_deadline_notifications()`
- `_cleanup_stale_deadline_notifications()`
- `_create_deadline_notification_if_missing()`
- `_normalize_rule_key()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `DeadlineSetting`
- `Notification`
- `Settlement`
- `User`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `Notification`

---

### File: `backend/utils/parsing_helper.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `13` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (12 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `allowed_file()`
- `_has_unchecked_checklist()`
- `_merge_rejection_notes()`
- `_parse_category_ids()`
- `_parse_checklist_notes()`
- `_default_report_year()`
- `_parse_iso_date()`
- `_year_date_bounds()`
- `_has_unchecked_return_checklist()`
- `_parse_date()`
- `_parse_float_safe()`
- `_parse_number_value()`

**Dipakai Oleh:**

- `backend/routes/advances/advances_items.py`
- `backend/routes/core/auth.py`
- `backend/routes/master_data/taxes.py`
- `backend/routes/reports/annual.py`
- `backend/routes/reports/summary.py`
- `backend/routes/settlements/settlements_expenses.py`
- `backend/routes/transactions/dividends.py`
- `backend/routes/transactions/expenses.py`

---

### File: `backend/utils/parsing_helper.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `13` | **Lokasi:** `L45`

**Risiko:** 🟢 **Aman** (12 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `allowed_file()`
- `_has_unchecked_checklist()`
- `_merge_rejection_notes()`
- `_parse_category_ids()`
- `_parse_checklist_notes()`
- `_default_report_year()`
- `_parse_iso_date()`
- `_year_date_bounds()`
- `_has_unchecked_return_checklist()`
- `_parse_date()`
- `_parse_float_safe()`
- `_parse_number_value()`

**Dipakai Oleh:**

- `backend/routes/advances/advances_items.py`
- `backend/routes/core/auth.py`
- `backend/routes/master_data/taxes.py`
- `backend/routes/reports/annual.py`
- `backend/routes/reports/summary.py`
- `backend/routes/settlements/settlements_expenses.py`
- `backend/routes/transactions/dividends.py`
- `backend/routes/transactions/expenses.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `15` | **Lokasi:** `L144`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `15` | **Lokasi:** `L460`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `15` | **Lokasi:** `L520`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `15` | **Lokasi:** `L534`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `15` | **Lokasi:** `L65`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L226`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L36`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L44`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L506`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L56`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `21` | **Lokasi:** `L96`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `64` | **Lokasi:** `L27`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `64` | **Lokasi:** `L622`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `70` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `70` | **Lokasi:** `L137`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `70` | **Lokasi:** `L156`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `70` | **Lokasi:** `L329`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `70` | **Lokasi:** `L473`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `70` | **Lokasi:** `L487`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `70` | **Lokasi:** `L643`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `70` | **Lokasi:** `L654`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_as_iso_date()`
- `_clean_settlement_title()`
- `_clear_range()`
- `_extract_imported_row()`
- `_get_dynamic_row_height()`
- `_idr_from_currency()`
- `_is_batch_settlement()`
- `_map_expense_category_index_from_name()`
- `_map_expense_column()`
- `_parse_iso_date()`
- `_safe_set_number()`
- `_safe_text()`
- `_set_date_with_format()`
- `_set_formula_with_format()`
- `_set_rows_hidden()`
- `_shorten()`
- `_clear_range_force()`
- `_default_report_year()`
- `_get_top_left_cell()`
- `_merge_description_cell()`
- *(... dan 23 fungsi lainnya)*

**Dipakai Oleh:**

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_helpers.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_data.py`
- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_helpers.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/utils/storage.py`

**Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.

**Community Group:** `13` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `delete_evidence_file()`

**Dipakai Oleh:**

- `backend/routes/advances/advances_items.py`
- `backend/routes/transactions/expenses.py`
- `backend/services/advances/advance_items_service.py`

---

### File: `backend/utils/storage.py`

**Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.

**Community Group:** `13` | **Lokasi:** `L5`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `delete_evidence_file()`

**Dipakai Oleh:**

- `backend/routes/advances/advances_items.py`
- `backend/routes/transactions/expenses.py`
- `backend/services/advances/advance_items_service.py`

---

### File: `backend/utils/transaction_templates.py`

**Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.

**Community Group:** `127` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (9 fungsi/metode terdeteksi).

**Classes / Models:**

- `TxTemplates` (L1)

**Fungsi / Metode:**

- `.advance_approved_final()`
- `.advance_move_to_draft()`
- `.advance_rejected_final()`
- `.advance_revision_requested()`
- `.allocation_notes()`
- `.disbursement()`
- `.refund_notes()`
- `.settlement_approved_final()`
- `.settlement_rejected_final()`

**Dipakai Oleh:**

- `backend/routes/advances/advances_other.py`
- `backend/routes/master_data/bank_management.py`

---

### File: `backend/utils/workflow_helper.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `37` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `log_workflow()`
- `update_document_stage()`

**Bergantung Pada (Internal Imports):**

- `WorkflowLog`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `WorkflowLog`

**Dipakai Oleh:**

- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`
- `backend/services/approvals/settlement_helpers.py`
- `backend/services/settlements/settlement_approval_service.py`

---

### File: `backend/utils/workflow_helper.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `37` | **Lokasi:** `L54`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `log_workflow()`
- `update_document_stage()`

**Bergantung Pada (Internal Imports):**

- `WorkflowLog`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `WorkflowLog`

**Dipakai Oleh:**

- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`
- `backend/services/approvals/settlement_helpers.py`
- `backend/services/settlements/settlement_approval_service.py`

---

### File: `backend/utils/workflow_helper.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `37` | **Lokasi:** `L59`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `log_workflow()`
- `update_document_stage()`

**Bergantung Pada (Internal Imports):**

- `WorkflowLog`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `WorkflowLog`

**Dipakai Oleh:**

- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`
- `backend/services/approvals/settlement_helpers.py`
- `backend/services/settlements/settlement_approval_service.py`

---

### File: `backend/utils/workflow_helper.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `37` | **Lokasi:** `L9`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `log_workflow()`
- `update_document_stage()`

**Bergantung Pada (Internal Imports):**

- `WorkflowLog`
- `models/__init__.py`

**Memanggil Fungsi/Modul:**

- `WorkflowLog`

**Dipakai Oleh:**

- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`
- `backend/services/approvals/settlement_helpers.py`
- `backend/services/settlements/settlement_approval_service.py`

---

