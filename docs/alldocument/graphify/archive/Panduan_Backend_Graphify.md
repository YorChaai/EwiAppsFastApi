# 📘 Panduan Backend (Graphify Knowledge Graph)

Dokumen ini digenerate dari **graphify-out/graph.json** — bukan dari scan regex/AST langsung.
Setiap entitas dan relasi di bawah ini dibangun dari Knowledge Graph proyek ini.

> **Script:** `backend/scripts/graphify_docs/generate_backend_graphify.py`

---

## 📊 Ringkasan Statistik

| Metrik | Nilai |
|---|---|
| Total File Backend (aktif) | **249** |
| Total Class/Model | **46** |
| Total Fungsi/Metode | **542** |
| Total Relasi (edges) | **3922** |
| Total Folder | **26** |

---

## 📁 Folder: `backend`

**Tujuan Folder:** File inti / konfigurasi utama aplikasi backend.

### File: `backend/app.py`

**Tanggung Jawab:** Entry-point server backend. Inisialisasi aplikasi, database, middleware, dan blueprint.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_app()`

**Bergantung Pada (Internal Imports):**

- `Config`
- `configure_database()`
- `database.py`

**Memanggil Fungsi/Modul:**

- `configure_database()`

**Dipakai Oleh:**

- `backend/tests/test_annual_report_routes.py`
- `backend/tests/test_blueprint_routes.py`
- `backend/tests/test_financial_math_logic.py`
- `backend/tests/test_revenue_bank_sync.py`

---

### File: `backend/app.py`

**Tanggung Jawab:** Entry-point server backend. Inisialisasi aplikasi, database, middleware, dan blueprint.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_app()`

**Bergantung Pada (Internal Imports):**

- `Config`
- `configure_database()`
- `database.py`

**Memanggil Fungsi/Modul:**

- `configure_database()`

**Dipakai Oleh:**

- `backend/tests/test_annual_report_routes.py`
- `backend/tests/test_blueprint_routes.py`
- `backend/tests/test_financial_math_logic.py`
- `backend/tests/test_revenue_bank_sync.py`

---

### File: `backend/app.py`

**Tanggung Jawab:** Entry-point server backend. Inisialisasi aplikasi, database, middleware, dan blueprint.

**Community Group:** `-` | **Lokasi:** `L8`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_app()`

**Bergantung Pada (Internal Imports):**

- `Config`
- `configure_database()`
- `database.py`

**Memanggil Fungsi/Modul:**

- `configure_database()`

**Dipakai Oleh:**

- `backend/tests/test_annual_report_routes.py`
- `backend/tests/test_blueprint_routes.py`
- `backend/tests/test_financial_math_logic.py`
- `backend/tests/test_revenue_bank_sync.py`

---

### File: `backend/cek_keselarasan_excel_db.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/cek_keselarasan_excel_db.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/config.py`

**Tanggung Jawab:** Mengelola environment variables dan konfigurasi server (database URI, secret key, dll).

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Classes / Models:**

- `Config` (L11)

**Dipakai Oleh:**

- `backend/app.py`
- `backend/core/database.py`
- `backend/core/security.py`
- `backend/main.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/core/auth_fastapi.py`
- `backend/routes/settings/db_storage.py`
- `backend/routes/settings/profile.py`

---

### File: `backend/main.py`

**Tanggung Jawab:** Entry-point server backend. Inisialisasi aplikasi, database, middleware, dan blueprint.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `lifespan()`
- `cleanup_scoped_database_session()`
- `_touch_authenticated_user()`
- `serve_upload()`
- `health_check()`
- `root_info()`

**Bergantung Pada (Internal Imports):**

- `Base`
- `Config`
- `User`
- `__init__.py`
- `advances_approval.py`
- `advances_crud.py`
- `advances_disbursement.py`
- `advances_items.py`
- `advances_other.py`
- `annual_fastapi.py`

**Memanggil Fungsi/Modul:**

- `get_engine()`
- `reset_session_scope()`
- `set_session_scope()`

---

## 📁 Folder: `backend/core`

**Tujuan Folder:** File inti / konfigurasi utama aplikasi backend.

### File: `backend/core/__init__.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/core/database.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Classes / Models:**

- `Base` (L48)

**Fungsi / Metode:**

- `_make_engine()`
- `_scope_key()`
- `set_session_scope()`
- `reset_session_scope()`
- `get_engine()`
- `configure_database()`
- `get_db()`

**Bergantung Pada (Internal Imports):**

- `Config`

**Dipakai Oleh:**

- `backend/app.py`
- `backend/core/security.py`
- `backend/main.py`
- `backend/models/base.py`
- `backend/routes/core/auth_fastapi.py`
- `backend/routes/master_data/companies_fastapi.py`

---

### File: `backend/core/database.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L40`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Classes / Models:**

- `Base` (L48)

**Fungsi / Metode:**

- `_make_engine()`
- `_scope_key()`
- `set_session_scope()`
- `reset_session_scope()`
- `get_engine()`
- `configure_database()`
- `get_db()`

**Bergantung Pada (Internal Imports):**

- `Config`

**Dipakai Oleh:**

- `backend/app.py`
- `backend/core/security.py`
- `backend/main.py`
- `backend/models/base.py`
- `backend/routes/core/auth_fastapi.py`
- `backend/routes/master_data/companies_fastapi.py`

---

### File: `backend/core/database.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L55`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Classes / Models:**

- `Base` (L48)

**Fungsi / Metode:**

- `_make_engine()`
- `_scope_key()`
- `set_session_scope()`
- `reset_session_scope()`
- `get_engine()`
- `configure_database()`
- `get_db()`

**Bergantung Pada (Internal Imports):**

- `Config`

**Dipakai Oleh:**

- `backend/app.py`
- `backend/core/security.py`
- `backend/main.py`
- `backend/models/base.py`
- `backend/routes/core/auth_fastapi.py`
- `backend/routes/master_data/companies_fastapi.py`

---

### File: `backend/core/rate_limit.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `enforce_login_limit()`

**Dipakai Oleh:**

- `backend/routes/core/auth_fastapi.py`

---

### File: `backend/core/rate_limit.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `enforce_login_limit()`

**Dipakai Oleh:**

- `backend/routes/core/auth_fastapi.py`

---

### File: `backend/core/security.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `verify_password()`
- `get_password_hash()`
- `create_access_token()`
- `decode_access_token()`
- `get_current_user()`
- `require_role()`

**Bergantung Pada (Internal Imports):**

- `Config`
- `User`
- `database.py`
- `get_db()`

**Dipakai Oleh:**

- `backend/routes/advances/advances_approval.py`
- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_items.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth_fastapi.py`
- `backend/routes/core/cleanup.py`
- `backend/routes/core/dashboard.py`

---

### File: `backend/core/security.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L53`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `verify_password()`
- `get_password_hash()`
- `create_access_token()`
- `decode_access_token()`
- `get_current_user()`
- `require_role()`

**Bergantung Pada (Internal Imports):**

- `Config`
- `User`
- `database.py`
- `get_db()`

**Dipakai Oleh:**

- `backend/routes/advances/advances_approval.py`
- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_items.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth_fastapi.py`
- `backend/routes/core/cleanup.py`
- `backend/routes/core/dashboard.py`

---

### File: `backend/core/security.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L79`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `verify_password()`
- `get_password_hash()`
- `create_access_token()`
- `decode_access_token()`
- `get_current_user()`
- `require_role()`

**Bergantung Pada (Internal Imports):**

- `Config`
- `User`
- `database.py`
- `get_db()`

**Dipakai Oleh:**

- `backend/routes/advances/advances_approval.py`
- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_items.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth_fastapi.py`
- `backend/routes/core/cleanup.py`
- `backend/routes/core/dashboard.py`

---

## 📁 Folder: `backend/models`

**Tujuan Folder:** Mendefinisikan skema database (ORM) dan validasi data dengan SQLAlchemy.

### File: `backend/models/__init__.py`

**Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.

**Community Group:** `-` | **Lokasi:** `L1`

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

- `backend/routes/advances/advances_approval.py`
- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_items.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth_fastapi.py`
- `backend/routes/core/cleanup.py`
- `backend/routes/core/dashboard.py`

---

### File: `backend/models/banking.py`

**Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Classes / Models:**

- `BankAccount` (L7)
- `BankTransaction` (L33)
- `BankStatusTransaction` (L98)

**Fungsi / Metode:**

- `.__init__()`
- `.to_dict()`

**Bergantung Pada (Internal Imports):**

- `base.py`

**Dipakai Oleh:**

- `backend/models/__init__.py`
- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/cleanup.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/settlements/settlements_disbursement.py`

---

### File: `backend/models/base.py`

**Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Classes / Models:**

- `SQLAlchemyAdapter` (L9)

**Fungsi / Metode:**

- `.engine()`
- `.create_all()`
- `.drop_all()`

**Bergantung Pada (Internal Imports):**

- `Base`
- `database.py`
- `get_engine()`

**Memanggil Fungsi/Modul:**

- `get_engine()`

**Dipakai Oleh:**

- `backend/models/__init__.py`
- `backend/models/banking.py`
- `backend/models/core.py`
- `backend/models/system.py`
- `backend/models/transaction.py`

---

### File: `backend/models/core.py`

**Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (12 fungsi/metode terdeteksi).

**Classes / Models:**

- `Company` (L7)
- `User` (L23)
- `CategoryGroup` (L125)
- `Category` (L144)

**Fungsi / Metode:**

- `.to_dict()`
- `.__init__()`
- `.set_password()`
- `.check_password()`
- `.last_login_formatted()`
- `.is_online()`
- `.full_name()`

**Bergantung Pada (Internal Imports):**

- `base.py`

**Dipakai Oleh:**

- `backend/core/security.py`
- `backend/main.py`
- `backend/models/__init__.py`
- `backend/routes/advances/advances_approval.py`
- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_items.py`
- `backend/routes/advances/advances_other.py`

---

### File: `backend/models/system.py`

**Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Classes / Models:**

- `Notification` (L7)
- `DeadlineSetting` (L59)
- `WorkflowLog` (L92)
- `OverrideLog` (L131)

**Fungsi / Metode:**

- `.__init__()`
- `.to_dict()`

**Bergantung Pada (Internal Imports):**

- `base.py`

**Dipakai Oleh:**

- `backend/models/__init__.py`
- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/cleanup.py`
- `backend/routes/core/notifications.py`
- `backend/routes/settings/deadline.py`
- `backend/routes/settings/profile.py`
- `backend/routes/settlements/settlements_crud.py`

---

### File: `backend/models/transaction.py`

**Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (39 fungsi/metode terdeteksi).

**Classes / Models:**

- `Asset` (L7)
- `Advance` (L44)
- `AdvanceItem` (L155)
- `Settlement` (L230)
- `Expense` (L315)
- `Revenue` (L394)
- `Tax` (L481)
- `ManualCombineGroup` (L528)
- `Dividend` (L571)
- `DividendSetting` (L591)

**Fungsi / Metode:**

- `.__init__()`
- `.to_dict()`
- `.total_amount()`
- `.approved_amount()`
- `.base_amount()`
- `.revision_amount()`
- `.max_revision_no()`
- `.rejected_count()`
- `.combined_subcategory_label()`
- `.idr_amount()`
- `.normalize_revenue_type()`
- `.idr_invoice_value()`
- `.idr_amount_received()`
- `.idr_transaction_value()`
- `.row_ids()`
- `.merged_columns()`

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
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/cleanup.py`
- `backend/routes/core/dashboard.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/categories.py`

---

### File: `backend/models/transaction.py`

**Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.

**Community Group:** `-` | **Lokasi:** `L195`

**Risiko:** 🟢 **Aman** (39 fungsi/metode terdeteksi).

**Classes / Models:**

- `Asset` (L7)
- `Advance` (L44)
- `AdvanceItem` (L155)
- `Settlement` (L230)
- `Expense` (L315)
- `Revenue` (L394)
- `Tax` (L481)
- `ManualCombineGroup` (L528)
- `Dividend` (L571)
- `DividendSetting` (L591)

**Fungsi / Metode:**

- `.__init__()`
- `.to_dict()`
- `.total_amount()`
- `.approved_amount()`
- `.base_amount()`
- `.revision_amount()`
- `.max_revision_no()`
- `.rejected_count()`
- `.combined_subcategory_label()`
- `.idr_amount()`
- `.normalize_revenue_type()`
- `.idr_invoice_value()`
- `.idr_amount_received()`
- `.idr_transaction_value()`
- `.row_ids()`
- `.merged_columns()`

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
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/cleanup.py`
- `backend/routes/core/dashboard.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/categories.py`

---

### File: `backend/models/transaction.py`

**Tanggung Jawab:** Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data.

**Community Group:** `-` | **Lokasi:** `L358`

**Risiko:** 🟢 **Aman** (39 fungsi/metode terdeteksi).

**Classes / Models:**

- `Asset` (L7)
- `Advance` (L44)
- `AdvanceItem` (L155)
- `Settlement` (L230)
- `Expense` (L315)
- `Revenue` (L394)
- `Tax` (L481)
- `ManualCombineGroup` (L528)
- `Dividend` (L571)
- `DividendSetting` (L591)

**Fungsi / Metode:**

- `.__init__()`
- `.to_dict()`
- `.total_amount()`
- `.approved_amount()`
- `.base_amount()`
- `.revision_amount()`
- `.max_revision_no()`
- `.rejected_count()`
- `.combined_subcategory_label()`
- `.idr_amount()`
- `.normalize_revenue_type()`
- `.idr_invoice_value()`
- `.idr_amount_received()`
- `.idr_transaction_value()`
- `.row_ids()`
- `.merged_columns()`

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
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/cleanup.py`
- `backend/routes/core/dashboard.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/categories.py`

---

## 📁 Folder: `backend/routes`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `backend/routes/__init__.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

## 📁 Folder: `backend/routes/advances`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `backend/routes/advances/__init__.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/routes/advances/advances.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/routes/advances/advances.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L2`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/routes/advances/advances_approval.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_read_request_data()`
- `start_revision()`
- `submit_advance()`
- `approve_advance()`
- `reject_advance()`
- `approve_advance_item()`
- `reject_advance_item()`
- `final_approve_advance()`

**Bergantung Pada (Internal Imports):**

- `User`
- `__init__.py`
- `get_current_user()`
- `process_approve_advance()`
- `process_approve_advance_item()`
- `process_final_approve_advance()`
- `process_reject_advance()`
- `process_reject_advance_item()`
- `process_start_revision()`
- `process_submit_advance()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/advances/advances_crud.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_query_int()`
- `_read_payload()`
- `list_advances()`
- `create_advance()`
- `get_advance()`
- `update_advance()`
- `delete_advance()`
- `get_advance_history()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `BankAccount`
- `User`
- `WorkflowLog`
- `__init__.py`
- `_advance_view_status_filter()`
- `calculate_user_running_balance()`
- `get_cash_composition_for_error()`
- `get_current_user()`

**Memanggil Fungsi/Modul:**

- `Advance`
- `_advance_view_status_filter()`
- `calculate_user_running_balance()`
- `get_cash_composition_for_error()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/advances/advances_disbursement.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_read_payload()`
- `save_disbursement()`
- `save_return()`
- `approve_disbursement()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `Config`
- `User`
- `__init__.py`
- `allowed_file()`
- `calculate_bank_composition()`
- `get_cash_composition_for_error()`
- `get_current_user()`
- `log_workflow()`

**Memanggil Fungsi/Modul:**

- `allowed_file()`
- `calculate_bank_composition()`
- `get_cash_composition_for_error()`
- `log_workflow()`
- `normalize_source()`
- `update_document_stage()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/advances/advances_items.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_read_payload()`
- `add_advance_item()`
- `update_advance_item()`
- `delete_advance_item()`
- `bulk_delete_advance_items()`
- `update_advance_items_bulk()`

**Bergantung Pada (Internal Imports):**

- `AdvanceItemsService`
- `User`
- `__init__.py`
- `get_current_user()`
- `security.py`

**Memanggil Fungsi/Modul:**

- `.delete_advance_item()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/advances/advances_other.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_query_int()`
- `override_advance()`
- `move_advance_to_draft()`
- `initialize_balance()`
- `get_override_logs_list()`
- `get_user_balances()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `OverrideLog`
- `Settlement`
- `TxTemplates`
- `User`
- `__init__.py`
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

- `backend/main.py`

---

## 📁 Folder: `backend/routes/core`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `backend/routes/core/__init__.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/routes/core/auth.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `auth_fastapi.py`

---

### File: `backend/routes/core/auth.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `auth_fastapi.py`

---

### File: `backend/routes/core/auth_fastapi.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (17 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `login()`
- `register()`
- `forgot_password()`
- `reset_password()`
- `google_login()`
- `get_me()`
- `update_profile()`
- `get_outstanding()`
- `list_users()`
- `create_user()`
- `update_user_by_manager()`
- `get_user_active_advance_balance()`
- `get_all_active_advance_balances()`
- `get_user_detail()`
- `link_google()`
- `unlink_google()`
- `google_login_browser()`

**Bergantung Pada (Internal Imports):**

- `Config`
- `CreateUserSchema`
- `ForgotPasswordSchema`
- `GoogleLoginSchema`
- `LinkGoogleSchema`
- `LoginSchema`
- `ProfileUpdateSchema`
- `RegisterSchema`
- `ResetPasswordSchema`
- `UpdateUserSchema`

**Memanggil Fungsi/Modul:**

- `User`
- `_internal_login()`
- `calculate_user_running_balance()`
- `create_access_token()`
- `enforce_login_limit()`
- `generate_otp()`
- `get_all_users_balance_breakdown()`
- `get_user_balance_breakdown()`
- `notify_user_registered()`
- `send_reset_password_otp()`

**Dipakai Oleh:**

- `backend/main.py`
- `backend/routes/core/auth.py`

---

### File: `backend/routes/core/auth_fastapi.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (17 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `login()`
- `register()`
- `forgot_password()`
- `reset_password()`
- `google_login()`
- `get_me()`
- `update_profile()`
- `get_outstanding()`
- `list_users()`
- `create_user()`
- `update_user_by_manager()`
- `get_user_active_advance_balance()`
- `get_all_active_advance_balances()`
- `get_user_detail()`
- `link_google()`
- `unlink_google()`
- `google_login_browser()`

**Bergantung Pada (Internal Imports):**

- `Config`
- `CreateUserSchema`
- `ForgotPasswordSchema`
- `GoogleLoginSchema`
- `LinkGoogleSchema`
- `LoginSchema`
- `ProfileUpdateSchema`
- `RegisterSchema`
- `ResetPasswordSchema`
- `UpdateUserSchema`

**Memanggil Fungsi/Modul:**

- `User`
- `_internal_login()`
- `calculate_user_running_balance()`
- `create_access_token()`
- `enforce_login_limit()`
- `generate_otp()`
- `get_all_users_balance_breakdown()`
- `get_user_balance_breakdown()`
- `notify_user_registered()`
- `send_reset_password_otp()`

**Dipakai Oleh:**

- `backend/main.py`
- `backend/routes/core/auth.py`

---

### File: `backend/routes/core/cleanup.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `cleanup_preview()`
- `cleanup_execute()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `Asset`
- `BankTransaction`
- `CleanupRequest`
- `Dividend`
- `Expense`
- `ManualCombineGroup`
- `Notification`
- `Revenue`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/core/dashboard.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_summary()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `Expense`
- `Settlement`
- `User`
- `__init__.py`
- `get_current_user()`
- `security.py`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/core/notifications.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_notifications()`
- `mark_notification_as_read()`
- `mark_all_notifications_as_read()`
- `delete_notification()`
- `get_unread_count()`

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `__init__.py`
- `_can_access_notification()`
- `get_current_user()`
- `security.py`

**Memanggil Fungsi/Modul:**

- `_can_access_notification()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/core/notifications.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L18`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_notifications()`
- `mark_notification_as_read()`
- `mark_all_notifications_as_read()`
- `delete_notification()`
- `get_unread_count()`

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `__init__.py`
- `_can_access_notification()`
- `get_current_user()`
- `security.py`

**Memanggil Fungsi/Modul:**

- `_can_access_notification()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/core/notifications.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L69`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_notifications()`
- `mark_notification_as_read()`
- `mark_all_notifications_as_read()`
- `delete_notification()`
- `get_unread_count()`

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `__init__.py`
- `_can_access_notification()`
- `get_current_user()`
- `security.py`

**Memanggil Fungsi/Modul:**

- `_can_access_notification()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/core/notifications.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L102`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_notifications()`
- `mark_notification_as_read()`
- `mark_all_notifications_as_read()`
- `delete_notification()`
- `get_unread_count()`

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `__init__.py`
- `_can_access_notification()`
- `get_current_user()`
- `security.py`

**Memanggil Fungsi/Modul:**

- `_can_access_notification()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/core/notifications.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L128`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_notifications()`
- `mark_notification_as_read()`
- `mark_all_notifications_as_read()`
- `delete_notification()`
- `get_unread_count()`

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `__init__.py`
- `_can_access_notification()`
- `get_current_user()`
- `security.py`

**Memanggil Fungsi/Modul:**

- `_can_access_notification()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/core/notifications.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L160`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_notifications()`
- `mark_notification_as_read()`
- `mark_all_notifications_as_read()`
- `delete_notification()`
- `get_unread_count()`

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `__init__.py`
- `_can_access_notification()`
- `get_current_user()`
- `security.py`

**Memanggil Fungsi/Modul:**

- `_can_access_notification()`

**Dipakai Oleh:**

- `backend/main.py`

---

## 📁 Folder: `backend/routes/master_data`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `backend/routes/master_data/__init__.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/routes/master_data/bank_management.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `list_management_banks()`
- `create_management_bank()`
- `update_management_bank()`
- `delete_management_bank()`
- `list_management_transactions()`
- `create_management_transaction()`
- `update_management_transaction()`
- `delete_management_transaction()`

**Bergantung Pada (Internal Imports):**

- `BankAccount`
- `BankTransaction`
- `Settlement`
- `TxTemplates`
- `User`
- `__init__.py`
- `get_all_bank_real_balances()`
- `get_current_user()`
- `notify_bank_created()`
- `notify_bank_transaction_created()`

**Memanggil Fungsi/Modul:**

- `BankAccount`
- `BankTransaction`
- `get_all_bank_real_balances()`
- `notify_bank_created()`
- `notify_bank_transaction_created()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/master_data/bank_management.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `list_management_banks()`
- `create_management_bank()`
- `update_management_bank()`
- `delete_management_bank()`
- `list_management_transactions()`
- `create_management_transaction()`
- `update_management_transaction()`
- `delete_management_transaction()`

**Bergantung Pada (Internal Imports):**

- `BankAccount`
- `BankTransaction`
- `Settlement`
- `TxTemplates`
- `User`
- `__init__.py`
- `get_all_bank_real_balances()`
- `get_current_user()`
- `notify_bank_created()`
- `notify_bank_transaction_created()`

**Memanggil Fungsi/Modul:**

- `BankAccount`
- `BankTransaction`
- `get_all_bank_real_balances()`
- `notify_bank_created()`
- `notify_bank_transaction_created()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/master_data/bank_status.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `list_all_banks_for_status()`
- `list_status_transactions()`
- `create_status_transaction()`
- `update_status_transaction()`
- `delete_status_transaction()`

**Bergantung Pada (Internal Imports):**

- `BankAccount`
- `BankStatusTransaction`
- `User`
- `__init__.py`
- `get_all_bank_real_balances()`
- `get_current_user()`
- `notify_bank_transaction_created()`
- `security.py`

**Memanggil Fungsi/Modul:**

- `BankStatusTransaction`
- `get_all_bank_real_balances()`
- `notify_bank_transaction_created()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/master_data/bank_status.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `list_all_banks_for_status()`
- `list_status_transactions()`
- `create_status_transaction()`
- `update_status_transaction()`
- `delete_status_transaction()`

**Bergantung Pada (Internal Imports):**

- `BankAccount`
- `BankStatusTransaction`
- `User`
- `__init__.py`
- `get_all_bank_real_balances()`
- `get_current_user()`
- `notify_bank_transaction_created()`
- `security.py`

**Memanggil Fungsi/Modul:**

- `BankStatusTransaction`
- `get_all_bank_real_balances()`
- `notify_bank_transaction_created()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/master_data/bank_status.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L24`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `list_all_banks_for_status()`
- `list_status_transactions()`
- `create_status_transaction()`
- `update_status_transaction()`
- `delete_status_transaction()`

**Bergantung Pada (Internal Imports):**

- `BankAccount`
- `BankStatusTransaction`
- `User`
- `__init__.py`
- `get_all_bank_real_balances()`
- `get_current_user()`
- `notify_bank_transaction_created()`
- `security.py`

**Memanggil Fungsi/Modul:**

- `BankStatusTransaction`
- `get_all_bank_real_balances()`
- `notify_bank_transaction_created()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/master_data/categories.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (12 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `list_category_groups()`
- `create_category_group()`
- `update_category_group()`
- `reorder_category_groups()`
- `delete_category_group()`
- `list_categories()`
- `reorder_categories()`
- `list_pending()`
- `create_category()`
- `update_category()`
- `delete_category()`
- `approve_category()`

**Bergantung Pada (Internal Imports):**

- `AdvanceItem`
- `Category`
- `CategoryGroup`
- `Expense`
- `User`
- `__init__.py`
- `clear_annual_report_cache()`
- `get_current_user()`
- `notify_category_approved()`
- `notify_category_created()`

**Memanggil Fungsi/Modul:**

- `Category`
- `CategoryGroup`
- `clear_annual_report_cache()`
- `notify_category_approved()`
- `notify_category_created()`
- `notify_category_rejected()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/master_data/categories.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L191`

**Risiko:** 🟢 **Aman** (12 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `list_category_groups()`
- `create_category_group()`
- `update_category_group()`
- `reorder_category_groups()`
- `delete_category_group()`
- `list_categories()`
- `reorder_categories()`
- `list_pending()`
- `create_category()`
- `update_category()`
- `delete_category()`
- `approve_category()`

**Bergantung Pada (Internal Imports):**

- `AdvanceItem`
- `Category`
- `CategoryGroup`
- `Expense`
- `User`
- `__init__.py`
- `clear_annual_report_cache()`
- `get_current_user()`
- `notify_category_approved()`
- `notify_category_created()`

**Memanggil Fungsi/Modul:**

- `Category`
- `CategoryGroup`
- `clear_annual_report_cache()`
- `notify_category_approved()`
- `notify_category_created()`
- `notify_category_rejected()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/master_data/companies.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `companies_fastapi.py`

---

### File: `backend/routes/master_data/companies.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `companies_fastapi.py`

---

### File: `backend/routes/master_data/companies_fastapi.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_companies()`
- `create_company()`
- `update_company()`
- `delete_company()`
- `reorder_companies()`

**Bergantung Pada (Internal Imports):**

- `Company`
- `CompanyOrderPayload`
- `CompanyPayload`
- `User`
- `__init__.py`
- `companies.py`
- `database.py`
- `get_current_user()`
- `get_db()`
- `security.py`

**Memanggil Fungsi/Modul:**

- `Company`

**Dipakai Oleh:**

- `backend/main.py`
- `backend/routes/master_data/companies.py`

---

### File: `backend/routes/master_data/companies_fastapi.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_companies()`
- `create_company()`
- `update_company()`
- `delete_company()`
- `reorder_companies()`

**Bergantung Pada (Internal Imports):**

- `Company`
- `CompanyOrderPayload`
- `CompanyPayload`
- `User`
- `__init__.py`
- `companies.py`
- `database.py`
- `get_current_user()`
- `get_db()`
- `security.py`

**Memanggil Fungsi/Modul:**

- `Company`

**Dipakai Oleh:**

- `backend/main.py`
- `backend/routes/master_data/companies.py`

---

### File: `backend/routes/master_data/taxes.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_taxes()`
- `get_tax()`
- `create_tax()`
- `update_tax()`
- `delete_tax()`
- `get_tax_combine_groups()`
- `create_tax_combine_group()`
- `delete_tax_combine_group()`

**Bergantung Pada (Internal Imports):**

- `ManualCombineGroup`
- `Tax`
- `User`
- `__init__.py`
- `_parse_date()`
- `_parse_float_safe()`
- `_parse_number_value()`
- `_validate_manual_tax_group()`
- `get_current_user()`
- `parsing_helper.py`

**Memanggil Fungsi/Modul:**

- `ManualCombineGroup`
- `Tax`
- `_parse_date()`
- `_parse_float_safe()`
- `_parse_number_value()`
- `_validate_manual_tax_group()`

**Dipakai Oleh:**

- `backend/main.py`

---

## 📁 Folder: `backend/routes/reports`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `backend/routes/reports/__init__.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/routes/reports/__init__.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/routes/reports/annual.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `annual_fastapi.py`
- `export_annual_report_excel()`
- `get_annual_report()`
- `get_annual_report_pdf()`

---

### File: `backend/routes/reports/annual.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `annual_fastapi.py`
- `export_annual_report_excel()`
- `get_annual_report()`
- `get_annual_report_pdf()`

---

### File: `backend/routes/reports/annual_constants.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Dipakai Oleh:**

- `backend/routes/reports/annual_excel.py`
- `backend/routes/reports/annual_tables.py`

---

### File: `backend/routes/reports/annual_data.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

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

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_clone_row_format()`
- `_replace_text_in_sheet()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_sum_sheet_column_formula()`
- `_safe_merge_cells_sheet()`
- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_sheet_ref()`
- `_write_secondary_summary_sheets()`
- `_set_merged_top_alignment()`
- `_sync_formatted_secondary_sheets()`
- `_clone_sheet_from_template()`
- `_ensure_formatted_secondary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `__init__.py`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

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

**Community Group:** `-` | **Lokasi:** `L53`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_clone_row_format()`
- `_replace_text_in_sheet()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_sum_sheet_column_formula()`
- `_safe_merge_cells_sheet()`
- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_sheet_ref()`
- `_write_secondary_summary_sheets()`
- `_set_merged_top_alignment()`
- `_sync_formatted_secondary_sheets()`
- `_clone_sheet_from_template()`
- `_ensure_formatted_secondary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `__init__.py`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

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

**Community Group:** `-` | **Lokasi:** `L119`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_clone_row_format()`
- `_replace_text_in_sheet()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_sum_sheet_column_formula()`
- `_safe_merge_cells_sheet()`
- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_sheet_ref()`
- `_write_secondary_summary_sheets()`
- `_set_merged_top_alignment()`
- `_sync_formatted_secondary_sheets()`
- `_clone_sheet_from_template()`
- `_ensure_formatted_secondary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `__init__.py`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

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

**Community Group:** `-` | **Lokasi:** `L177`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_clone_row_format()`
- `_replace_text_in_sheet()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_sum_sheet_column_formula()`
- `_safe_merge_cells_sheet()`
- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_sheet_ref()`
- `_write_secondary_summary_sheets()`
- `_set_merged_top_alignment()`
- `_sync_formatted_secondary_sheets()`
- `_clone_sheet_from_template()`
- `_ensure_formatted_secondary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `__init__.py`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

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

**Community Group:** `-` | **Lokasi:** `L206`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_clone_row_format()`
- `_replace_text_in_sheet()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_sum_sheet_column_formula()`
- `_safe_merge_cells_sheet()`
- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_sheet_ref()`
- `_write_secondary_summary_sheets()`
- `_set_merged_top_alignment()`
- `_sync_formatted_secondary_sheets()`
- `_clone_sheet_from_template()`
- `_ensure_formatted_secondary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `__init__.py`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

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

### File: `backend/routes/reports/annual_fastapi.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_query_int()`
- `_query_company()`
- `get_annual_report()`
- `get_annual_report_pdf()`
- `export_annual_report_excel()`

**Bergantung Pada (Internal Imports):**

- `User`
- `__init__.py`
- `_build_annual_payload_from_db()`
- `_build_annual_pdf_bytes()`
- `_parse_iso_date()`
- `_save_annual_payload_cache()`
- `_save_annual_pdf_cache()`
- `get_annual_report_excel()`
- `parsing_helper.py`
- `require_role()`

**Memanggil Fungsi/Modul:**

- `_build_annual_payload_from_db()`
- `_build_annual_pdf_bytes()`
- `_parse_iso_date()`
- `_save_annual_payload_cache()`
- `_save_annual_pdf_cache()`
- `get_annual_report_excel()`

**Dipakai Oleh:**

- `backend/main.py`
- `backend/routes/reports/annual.py`

---

### File: `backend/routes/reports/annual_helpers.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_extract_subcategory_from_description()`
- `_root_category_info()`
- `_subcategory_sort_key()`
- `_clear_merged_ranges_in_region()`
- `_write_dynamic_category_headers()`
- `_set_dividend_row_border()`
- `_compute_dividend_distribution_v2()`

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

**Community Group:** `-` | **Lokasi:** `L74`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_extract_subcategory_from_description()`
- `_root_category_info()`
- `_subcategory_sort_key()`
- `_clear_merged_ranges_in_region()`
- `_write_dynamic_category_headers()`
- `_set_dividend_row_border()`
- `_compute_dividend_distribution_v2()`

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

**Community Group:** `-` | **Lokasi:** `L103`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_extract_subcategory_from_description()`
- `_root_category_info()`
- `_subcategory_sort_key()`
- `_clear_merged_ranges_in_region()`
- `_write_dynamic_category_headers()`
- `_set_dividend_row_border()`
- `_compute_dividend_distribution_v2()`

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

**Community Group:** `-` | **Lokasi:** `L189`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_extract_subcategory_from_description()`
- `_root_category_info()`
- `_subcategory_sort_key()`
- `_clear_merged_ranges_in_region()`
- `_write_dynamic_category_headers()`
- `_set_dividend_row_border()`
- `_compute_dividend_distribution_v2()`

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

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `Category`
- `ManualCombineGroup`
- `__init__.py`
- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_as_iso_date()`
- `_build_annual_pdf_bytes()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_clear_merged_ranges_in_region()`

---

### File: `backend/routes/reports/summary.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_query_int()`
- `get_summary_report()`
- `export_summary_pdf()`
- `export_summary_excel()`
- `export_advance_excel()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `Category`
- `Expense`
- `Settlement`
- `User`
- `__init__.py`
- `_build_summary_payload()`
- `_default_report_year()`
- `_display_settlement_status()`
- `_expense_amount_for_summary()`

**Memanggil Fungsi/Modul:**

- `_build_summary_payload()`
- `_default_report_year()`
- `_get_summary_approved_expenses()`
- `_parse_iso_date()`
- `_year_date_bounds()`
- `generate_excel_advance_report()`
- `generate_excel_report()`

**Dipakai Oleh:**

- `backend/main.py`

---

## 📁 Folder: `backend/routes/settings`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `backend/routes/settings/__init__.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `db_storage.py`

**Dipakai Oleh:**

- `backend/main.py`
- `backend/routes/settings/db_storage.py`

---

### File: `backend/routes/settings/db_storage.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_storage_directory()`
- `update_storage_directory()`
- `export_database()`
- `import_database_preview()`
- `import_database_confirm()`

**Bergantung Pada (Internal Imports):**

- `Config`
- `Expense`
- `User`
- `__init__.py`
- `require_role()`
- `security.py`

**Dipakai Oleh:**

- `backend/routes/settings/__init__.py`

---

### File: `backend/routes/settings/deadline.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_manager_error()`
- `get_deadline_settings()`
- `create_deadline_setting()`
- `update_deadline_setting()`

**Bergantung Pada (Internal Imports):**

- `DeadlineSetting`
- `User`
- `__init__.py`
- `_find_deadline_setting()`
- `_normalize_deadline_rule_key()`
- `_sanitize_deadline_days()`
- `get_current_user()`
- `security.py`

**Memanggil Fungsi/Modul:**

- `DeadlineSetting`
- `_find_deadline_setting()`
- `_normalize_deadline_rule_key()`
- `_sanitize_deadline_days()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/settings/profile.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_companies()`
- `get_report_year()`
- `update_report_year()`

**Bergantung Pada (Internal Imports):**

- `Config`
- `DeadlineSetting`
- `ReportYearUpdate`
- `User`
- `__init__.py`
- `get_current_user()`
- `security.py`
- `settings.py`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/settings/profile.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L17`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_companies()`
- `get_report_year()`
- `update_report_year()`

**Bergantung Pada (Internal Imports):**

- `Config`
- `DeadlineSetting`
- `ReportYearUpdate`
- `User`
- `__init__.py`
- `get_current_user()`
- `security.py`
- `settings.py`

**Dipakai Oleh:**

- `backend/main.py`

---

## 📁 Folder: `backend/routes/settlements`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `backend/routes/settlements/__init__.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/routes/settlements/settlements.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/routes/settlements/settlements.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/routes/settlements/settlements_approval.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_read_request_data()`
- `submit_settlement()`
- `approve_settlement()`
- `complete_settlement()`
- `reject_all_expenses()`
- `final_approve_settlement()`

**Bergantung Pada (Internal Imports):**

- `User`
- `__init__.py`
- `get_current_user()`
- `process_approve_settlement()`
- `process_complete_settlement()`
- `process_final_approve_settlement()`
- `process_reject_all_expenses()`
- `process_submit_settlement()`
- `security.py`

**Memanggil Fungsi/Modul:**

- `process_complete_settlement()`
- `process_submit_settlement()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/settlements/settlements_crud.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_query_int()`
- `_company_or_default()`
- `list_settlements()`
- `create_settlement()`
- `get_settlement()`
- `update_settlement()`
- `delete_settlement()`
- `get_settlement_history()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `Expense`
- `Settlement`
- `User`
- `WorkflowLog`
- `__init__.py`
- `_sync_advance_after_settlement()`
- `get_current_user()`
- `rollback_settlement_transactions()`
- `security.py`

**Memanggil Fungsi/Modul:**

- `Expense`
- `Settlement`
- `_sync_advance_after_settlement()`
- `rollback_settlement_transactions()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/settlements/settlements_disbursement.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_read_payload()`
- `save_disbursement()`
- `save_return()`
- `approve_disbursement()`
- `standalone_return()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `Config`
- `OverrideLog`
- `Settlement`
- `User`
- `__init__.py`
- `allowed_file()`
- `calculate_bank_composition()`

**Memanggil Fungsi/Modul:**

- `Advance`
- `BankTransaction`
- `OverrideLog`
- `Settlement`
- `allowed_file()`
- `calculate_bank_composition()`
- `calculate_bank_real_balance()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance()`
- `get_all_users_balance_breakdown()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/settlements/settlements_expenses.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_read_payload()`
- `update_expense()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `Expense`
- `User`
- `__init__.py`
- `_has_unchecked_checklist()`
- `get_current_user()`
- `parsing_helper.py`
- `security.py`

**Memanggil Fungsi/Modul:**

- `_has_unchecked_checklist()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/settlements/settlements_other.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_read_json()`
- `override_settlement()`
- `move_to_draft()`

**Bergantung Pada (Internal Imports):**

- `Settlement`
- `User`
- `__init__.py`
- `get_current_user()`
- `rollback_settlement_transactions()`
- `security.py`

**Memanggil Fungsi/Modul:**

- `rollback_settlement_transactions()`

**Dipakai Oleh:**

- `backend/main.py`

---

## 📁 Folder: `backend/routes/transactions`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `backend/routes/transactions/__init__.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/routes/transactions/assets.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `list_assets()`
- `create_asset()`
- `update_asset()`
- `delete_asset()`

**Bergantung Pada (Internal Imports):**

- `Asset`
- `User`
- `__init__.py`
- `_calculate_asset_depreciation()`
- `get_current_user()`
- `security.py`

**Memanggil Fungsi/Modul:**

- `Asset`
- `_calculate_asset_depreciation()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/transactions/dividends.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_dividends()`
- `get_dividend()`
- `create_dividend()`
- `update_dividend()`
- `update_dividend_setting()`
- `delete_dividend()`

**Bergantung Pada (Internal Imports):**

- `Dividend`
- `DividendSetting`
- `Expense`
- `Revenue`
- `Settlement`
- `User`
- `__init__.py`
- `_build_dividend_payload()`
- `_compute_dividend_distribution_v2()`
- `_fetch_revenues_and_expenses_for_year()`

**Memanggil Fungsi/Modul:**

- `Dividend`
- `DividendSetting`
- `_build_dividend_payload()`
- `_parse_date()`
- `_parse_float_safe()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/transactions/expenses.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (15 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_form_payload()`
- `_form_int()`
- `_form_float()`
- `_optional_int()`
- `_optional_float()`
- `_save_upload()`
- `_evidence_response()`
- `create_expense()`
- `update_expense()`
- `bulk_delete_expenses()`
- `delete_expense()`
- `approve_expense()`
- `reject_expense()`
- `serve_evidence()`
- `list_categories()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `Config`
- `Expense`
- `Settlement`
- `User`
- `__init__.py`
- `_parse_category_ids()`
- `allowed_file()`
- `delete_evidence_file()`
- `get_current_user()`

**Memanggil Fungsi/Modul:**

- `Expense`
- `_merge_rejection_notes()`
- `_parse_category_ids()`
- `allowed_file()`
- `delete_evidence_file()`
- `notify_expense_approved()`
- `notify_expense_rejected()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/transactions/expenses.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L25`

**Risiko:** 🟢 **Aman** (15 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_form_payload()`
- `_form_int()`
- `_form_float()`
- `_optional_int()`
- `_optional_float()`
- `_save_upload()`
- `_evidence_response()`
- `create_expense()`
- `update_expense()`
- `bulk_delete_expenses()`
- `delete_expense()`
- `approve_expense()`
- `reject_expense()`
- `serve_evidence()`
- `list_categories()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `Config`
- `Expense`
- `Settlement`
- `User`
- `__init__.py`
- `_parse_category_ids()`
- `allowed_file()`
- `delete_evidence_file()`
- `get_current_user()`

**Memanggil Fungsi/Modul:**

- `Expense`
- `_merge_rejection_notes()`
- `_parse_category_ids()`
- `allowed_file()`
- `delete_evidence_file()`
- `notify_expense_approved()`
- `notify_expense_rejected()`

**Dipakai Oleh:**

- `backend/main.py`

---

### File: `backend/routes/transactions/revenues.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (11 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `sync_revenue_bank_transaction()`
- `get_revenues()`
- `get_revenue()`
- `create_revenue()`
- `update_revenue()`
- `toggle_tax_offset()`
- `delete_revenue()`
- `get_revenue_combine_groups()`
- `create_revenue_combine_group()`
- `delete_revenue_combine_group()`
- `_query_int()`

**Bergantung Pada (Internal Imports):**

- `BankTransaction`
- `ManualCombineGroup`
- `Revenue`
- `User`
- `__init__.py`
- `_parse_date()`
- `_parse_float_safe()`
- `_parse_number_value()`
- `_validate_manual_revenue_group()`
- `get_current_user()`

**Memanggil Fungsi/Modul:**

- `.normalize_revenue_type()`
- `BankTransaction`
- `ManualCombineGroup`
- `Revenue`
- `_parse_date()`
- `_parse_float_safe()`
- `_parse_number_value()`
- `_validate_manual_revenue_group()`

**Dipakai Oleh:**

- `backend/main.py`
- `backend/tests/test_revenue_bank_sync.py`

---

### File: `backend/routes/transactions/revenues.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L17`

**Risiko:** 🟢 **Aman** (11 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `sync_revenue_bank_transaction()`
- `get_revenues()`
- `get_revenue()`
- `create_revenue()`
- `update_revenue()`
- `toggle_tax_offset()`
- `delete_revenue()`
- `get_revenue_combine_groups()`
- `create_revenue_combine_group()`
- `delete_revenue_combine_group()`
- `_query_int()`

**Bergantung Pada (Internal Imports):**

- `BankTransaction`
- `ManualCombineGroup`
- `Revenue`
- `User`
- `__init__.py`
- `_parse_date()`
- `_parse_float_safe()`
- `_parse_number_value()`
- `_validate_manual_revenue_group()`
- `get_current_user()`

**Memanggil Fungsi/Modul:**

- `.normalize_revenue_type()`
- `BankTransaction`
- `ManualCombineGroup`
- `Revenue`
- `_parse_date()`
- `_parse_float_safe()`
- `_parse_number_value()`
- `_validate_manual_revenue_group()`

**Dipakai Oleh:**

- `backend/main.py`
- `backend/tests/test_revenue_bank_sync.py`

---

## 📁 Folder: `backend/schemas`

**Tujuan Folder:** File inti / konfigurasi utama aplikasi backend.

### File: `backend/schemas/__init__.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/schemas/__init__.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/schemas/auth.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Classes / Models:**

- `LoginSchema` (L6)
- `RegisterSchema` (L11)
- `ForgotPasswordSchema` (L23)
- `ResetPasswordSchema` (L27)
- `GoogleLoginSchema` (L33)
- `ProfileUpdateSchema` (L37)
- `CreateUserSchema` (L45)
- `UpdateUserSchema` (L55)
- `LinkGoogleSchema` (L64)

**Dipakai Oleh:**

- `backend/routes/core/auth_fastapi.py`

---

### File: `backend/schemas/cleanup.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Classes / Models:**

- `CleanupRequest` (L4)

**Dipakai Oleh:**

- `backend/routes/core/cleanup.py`

---

### File: `backend/schemas/companies.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Classes / Models:**

- `CompanyPayload` (L4)
- `CompanyOrderItem` (L8)
- `CompanyOrderPayload` (L12)

**Dipakai Oleh:**

- `backend/routes/master_data/companies_fastapi.py`

---

### File: `backend/schemas/settings.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Classes / Models:**

- `ReportYearUpdate` (L4)

**Dipakai Oleh:**

- `backend/routes/settings/profile.py`

---

## 📁 Folder: `backend/services/advances`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/advances/__init__.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/advances/advance_approval_service.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `process_start_revision()`
- `process_submit_advance()`
- `process_approve_advance()`
- `process_reject_advance()`
- `process_approve_advance_item()`
- `process_reject_advance_item()`
- `process_final_approve_advance()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `BankAccount`
- `BankTransaction`
- `Notification`
- `OverrideLog`
- `Settlement`
- `User`
- `__init__.py`
- `_advance_view_status_filter()`

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

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Classes / Models:**

- `AdvanceItemsService` (L14)

**Fungsi / Metode:**

- `.add_advance_item()`
- `.update_advance_item()`
- `.delete_advance_item()`
- `.bulk_delete_advance_items()`
- `.update_advance_items_bulk()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `BankAccount`
- `Category`
- `Config`
- `__init__.py`
- `_editable_revision_no()`
- `_has_unchecked_checklist()`
- `_items_for_revision()`
- `allowed_file()`

**Memanggil Fungsi/Modul:**

- `AdvanceItem`
- `_editable_revision_no()`
- `_has_unchecked_checklist()`
- `_items_for_revision()`
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

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/approvals/advance_helpers.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_cash_composition_for_error()`
- `normalize_source()`
- `_advance_view_status_filter()`
- `_editable_revision_no()`
- `_items_for_revision()`
- `_next_revision_no()`
- `_status_after_approval()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `BankAccount`
- `__init__.py`
- `calculate_bank_composition()`
- `calculate_bank_real_balance()`

**Memanggil Fungsi/Modul:**

- `calculate_bank_composition()`
- `calculate_bank_real_balance()`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`
- `backend/services/advances/advance_items_service.py`

---

### File: `backend/services/approvals/settlement_helpers.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_sync_advance_after_settlement()`
- `rollback_settlement_transactions()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankTransaction`
- `OverrideLog`
- `__init__.py`
- `calculate_user_available_budget()`
- `calculate_user_running_balance()`
- `get_all_users_balance_breakdown()`
- `log_workflow()`
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

**Community Group:** `-` | **Lokasi:** `L7`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_sync_advance_after_settlement()`
- `rollback_settlement_transactions()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankTransaction`
- `OverrideLog`
- `__init__.py`
- `calculate_user_available_budget()`
- `calculate_user_running_balance()`
- `get_all_users_balance_breakdown()`
- `log_workflow()`
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

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/balance/balance_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `calculate_bank_real_balance()`
- `_get_user_advance_banks()`
- `calculate_user_running_balance()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance_per_bank()`
- `get_all_bank_real_balances()`
- `calculate_bank_composition()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `__init__.py`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth_fastapi.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`

---

### File: `backend/services/balance/balance_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L5`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `calculate_bank_real_balance()`
- `_get_user_advance_banks()`
- `calculate_user_running_balance()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance_per_bank()`
- `get_all_bank_real_balances()`
- `calculate_bank_composition()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `__init__.py`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth_fastapi.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`

---

### File: `backend/services/balance/balance_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L79`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `calculate_bank_real_balance()`
- `_get_user_advance_banks()`
- `calculate_user_running_balance()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance_per_bank()`
- `get_all_bank_real_balances()`
- `calculate_bank_composition()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `__init__.py`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth_fastapi.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`

---

### File: `backend/services/balance/balance_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L105`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `calculate_bank_real_balance()`
- `_get_user_advance_banks()`
- `calculate_user_running_balance()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance_per_bank()`
- `get_all_bank_real_balances()`
- `calculate_bank_composition()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `__init__.py`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth_fastapi.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`

---

### File: `backend/services/balance/balance_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L122`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `calculate_bank_real_balance()`
- `_get_user_advance_banks()`
- `calculate_user_running_balance()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance_per_bank()`
- `get_all_bank_real_balances()`
- `calculate_bank_composition()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `__init__.py`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth_fastapi.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`

---

### File: `backend/services/balance/balance_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L171`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `calculate_bank_real_balance()`
- `_get_user_advance_banks()`
- `calculate_user_running_balance()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance_per_bank()`
- `get_all_bank_real_balances()`
- `calculate_bank_composition()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `__init__.py`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth_fastapi.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`

---

### File: `backend/services/balance/balance_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L241`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `calculate_bank_real_balance()`
- `_get_user_advance_banks()`
- `calculate_user_running_balance()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance_per_bank()`
- `get_all_bank_real_balances()`
- `calculate_bank_composition()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `__init__.py`

**Dipakai Oleh:**

- `backend/routes/advances/advances_crud.py`
- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/advances/advances_other.py`
- `backend/routes/core/auth_fastapi.py`
- `backend/routes/master_data/bank_management.py`
- `backend/routes/master_data/bank_status.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`

---

### File: `backend/services/balance/user_balance_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_all_users_balance_breakdown()`
- `get_user_balance_breakdown()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `Settlement`
- `User`
- `__init__.py`
- `calculate_bank_composition()`
- `calculate_bank_real_balance()`
- `calculate_user_running_balance()`

**Memanggil Fungsi/Modul:**

- `calculate_bank_composition()`
- `calculate_bank_real_balance()`
- `calculate_user_running_balance()`

**Dipakai Oleh:**

- `backend/routes/core/auth_fastapi.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`
- `backend/services/approvals/settlement_helpers.py`
- `backend/services/settlements/settlement_approval_service.py`

---

## 📁 Folder: `backend/services/core`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/core/__init__.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/core/auth_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_internal_login()`

**Bergantung Pada (Internal Imports):**

- `User`
- `__init__.py`
- `create_access_token()`
- `notify_user_returned()`
- `security.py`

**Memanggil Fungsi/Modul:**

- `create_access_token()`
- `notify_user_returned()`

**Dipakai Oleh:**

- `backend/routes/core/auth_fastapi.py`

---

### File: `backend/services/core/email_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Classes / Models:**

- `Message` (L16)
- `_MailSender` (L22)

**Fungsi / Metode:**

- `.send()`
- `init_mail()`
- `generate_otp()`
- `send_reset_password_otp()`

**Bergantung Pada (Internal Imports):**

- `Config`

**Dipakai Oleh:**

- `backend/routes/core/auth_fastapi.py`

---

### File: `backend/services/core/email_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Classes / Models:**

- `Message` (L16)
- `_MailSender` (L22)

**Fungsi / Metode:**

- `.send()`
- `init_mail()`
- `generate_otp()`
- `send_reset_password_otp()`

**Bergantung Pada (Internal Imports):**

- `Config`

**Dipakai Oleh:**

- `backend/routes/core/auth_fastapi.py`

---

### File: `backend/services/core/email_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L42`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Classes / Models:**

- `Message` (L16)
- `_MailSender` (L22)

**Fungsi / Metode:**

- `.send()`
- `init_mail()`
- `generate_otp()`
- `send_reset_password_otp()`

**Bergantung Pada (Internal Imports):**

- `Config`

**Dipakai Oleh:**

- `backend/routes/core/auth_fastapi.py`

---

### File: `backend/services/core/notification_events.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (33 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_notification()`
- `notify_managers()`
- `notify_staff()`
- `notify_advance_submitted()`
- `notify_advance_revision_started()`
- `notify_advance_approved_final()`
- `notify_advance_rejected_final()`
- `notify_advance_item_approved()`
- `notify_advance_item_rejected()`
- `notify_settlement_submitted()`
- `notify_settlement_approved_item()`
- `notify_settlement_rejected()`
- `notify_settlement_approved_final()`
- `_expense_owner_id()`
- `notify_expense_approved()`
- `notify_expense_rejected()`
- `notify_category_created()`
- `notify_category_approved()`
- `notify_category_rejected()`
- `notify_user_registered()`
- *(... dan 13 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `__init__.py`

**Memanggil Fungsi/Modul:**

- `Notification`

**Dipakai Oleh:**

- `backend/routes/core/auth_fastapi.py`
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

**Community Group:** `-` | **Lokasi:** `L6`

**Risiko:** 🟢 **Aman** (33 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_notification()`
- `notify_managers()`
- `notify_staff()`
- `notify_advance_submitted()`
- `notify_advance_revision_started()`
- `notify_advance_approved_final()`
- `notify_advance_rejected_final()`
- `notify_advance_item_approved()`
- `notify_advance_item_rejected()`
- `notify_settlement_submitted()`
- `notify_settlement_approved_item()`
- `notify_settlement_rejected()`
- `notify_settlement_approved_final()`
- `_expense_owner_id()`
- `notify_expense_approved()`
- `notify_expense_rejected()`
- `notify_category_created()`
- `notify_category_approved()`
- `notify_category_rejected()`
- `notify_user_registered()`
- *(... dan 13 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `__init__.py`

**Memanggil Fungsi/Modul:**

- `Notification`

**Dipakai Oleh:**

- `backend/routes/core/auth_fastapi.py`
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

**Community Group:** `-` | **Lokasi:** `L30`

**Risiko:** 🟢 **Aman** (33 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_notification()`
- `notify_managers()`
- `notify_staff()`
- `notify_advance_submitted()`
- `notify_advance_revision_started()`
- `notify_advance_approved_final()`
- `notify_advance_rejected_final()`
- `notify_advance_item_approved()`
- `notify_advance_item_rejected()`
- `notify_settlement_submitted()`
- `notify_settlement_approved_item()`
- `notify_settlement_rejected()`
- `notify_settlement_approved_final()`
- `_expense_owner_id()`
- `notify_expense_approved()`
- `notify_expense_rejected()`
- `notify_category_created()`
- `notify_category_approved()`
- `notify_category_rejected()`
- `notify_user_registered()`
- *(... dan 13 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `__init__.py`

**Memanggil Fungsi/Modul:**

- `Notification`

**Dipakai Oleh:**

- `backend/routes/core/auth_fastapi.py`
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

**Community Group:** `-` | **Lokasi:** `L47`

**Risiko:** 🟢 **Aman** (33 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_notification()`
- `notify_managers()`
- `notify_staff()`
- `notify_advance_submitted()`
- `notify_advance_revision_started()`
- `notify_advance_approved_final()`
- `notify_advance_rejected_final()`
- `notify_advance_item_approved()`
- `notify_advance_item_rejected()`
- `notify_settlement_submitted()`
- `notify_settlement_approved_item()`
- `notify_settlement_rejected()`
- `notify_settlement_approved_final()`
- `_expense_owner_id()`
- `notify_expense_approved()`
- `notify_expense_rejected()`
- `notify_category_created()`
- `notify_category_approved()`
- `notify_category_rejected()`
- `notify_user_registered()`
- *(... dan 13 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `__init__.py`

**Memanggil Fungsi/Modul:**

- `Notification`

**Dipakai Oleh:**

- `backend/routes/core/auth_fastapi.py`
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

**Community Group:** `-` | **Lokasi:** `L344`

**Risiko:** 🟢 **Aman** (33 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `create_notification()`
- `notify_managers()`
- `notify_staff()`
- `notify_advance_submitted()`
- `notify_advance_revision_started()`
- `notify_advance_approved_final()`
- `notify_advance_rejected_final()`
- `notify_advance_item_approved()`
- `notify_advance_item_rejected()`
- `notify_settlement_submitted()`
- `notify_settlement_approved_item()`
- `notify_settlement_rejected()`
- `notify_settlement_approved_final()`
- `_expense_owner_id()`
- `notify_expense_approved()`
- `notify_expense_rejected()`
- `notify_category_created()`
- `notify_category_approved()`
- `notify_category_rejected()`
- `notify_user_registered()`
- *(... dan 13 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Notification`
- `User`
- `__init__.py`

**Memanggil Fungsi/Modul:**

- `Notification`

**Dipakai Oleh:**

- `backend/routes/core/auth_fastapi.py`
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

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_normalize_deadline_rule_key()`
- `_find_deadline_setting()`
- `_sanitize_deadline_days()`

**Bergantung Pada (Internal Imports):**

- `DeadlineSetting`
- `__init__.py`

**Dipakai Oleh:**

- `backend/routes/settings/deadline.py`

---

### File: `backend/services/core/storage_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `allowed_file()`
- `handle_profile_image_upload()`
- `handle_profile_image_removal()`

**Bergantung Pada (Internal Imports):**

- `Config`

**Dipakai Oleh:**

- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/settlements/settlements_disbursement.py`

---

### File: `backend/services/core/storage_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L11`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `allowed_file()`
- `handle_profile_image_upload()`
- `handle_profile_image_removal()`

**Bergantung Pada (Internal Imports):**

- `Config`

**Dipakai Oleh:**

- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/settlements/settlements_disbursement.py`

---

### File: `backend/services/core/storage_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L46`

**Risiko:** 🟢 **Aman** (3 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `allowed_file()`
- `handle_profile_image_upload()`
- `handle_profile_image_removal()`

**Bergantung Pada (Internal Imports):**

- `Config`

**Dipakai Oleh:**

- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/settlements/settlements_disbursement.py`

---

## 📁 Folder: `backend/services/dto`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/dto/__init__.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/dto/transaction_dto.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (9 fungsi/metode terdeteksi).

**Classes / Models:**

- `TransactionDTO` (L6)

**Fungsi / Metode:**

- `.advance_to_dict()`
- `.advanceitem_to_dict()`
- `.settlement_to_dict()`
- `.expense_to_dict()`
- `.revenue_to_dict()`
- `.tax_to_dict()`
- `.manualcombinegroup_to_dict()`
- `.dividend_to_dict()`
- `.dividendsetting_to_dict()`

**Bergantung Pada (Internal Imports):**

- `calculate_user_running_balance()`

**Memanggil Fungsi/Modul:**

- `calculate_user_running_balance()`

**Dipakai Oleh:**

- `backend/models/transaction.py`
- `backend/tests/test_code_hygiene_fixes.py`
- `backend/tests/test_revenue_bank_sync.py`

---

### File: `backend/services/dto/transaction_dto.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L285`

**Risiko:** 🟢 **Aman** (9 fungsi/metode terdeteksi).

**Classes / Models:**

- `TransactionDTO` (L6)

**Fungsi / Metode:**

- `.advance_to_dict()`
- `.advanceitem_to_dict()`
- `.settlement_to_dict()`
- `.expense_to_dict()`
- `.revenue_to_dict()`
- `.tax_to_dict()`
- `.manualcombinegroup_to_dict()`
- `.dividend_to_dict()`
- `.dividendsetting_to_dict()`

**Bergantung Pada (Internal Imports):**

- `calculate_user_running_balance()`

**Memanggil Fungsi/Modul:**

- `calculate_user_running_balance()`

**Dipakai Oleh:**

- `backend/models/transaction.py`
- `backend/tests/test_code_hygiene_fixes.py`
- `backend/tests/test_revenue_bank_sync.py`

---

## 📁 Folder: `backend/services/master_data`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/master_data/__init__.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/master_data/tax_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_validate_manual_tax_group()`

**Bergantung Pada (Internal Imports):**

- `ManualCombineGroup`
- `Tax`
- `__init__.py`

**Dipakai Oleh:**

- `backend/routes/master_data/taxes.py`

---

## 📁 Folder: `backend/services/reports/annual_service`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/reports/annual_service/__init__.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/reports/annual_service/annual_constants.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Dipakai Oleh:**

- `backend/services/reports/annual_service/annual_excel.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/services/reports/annual_service/annual_data.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

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

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_clone_row_format()`
- `_replace_text_in_sheet()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_sum_sheet_column_formula()`
- `_safe_merge_cells_sheet()`
- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_sheet_ref()`
- `_write_secondary_summary_sheets()`
- `_set_merged_top_alignment()`
- `_sync_formatted_secondary_sheets()`
- `_clone_sheet_from_template()`
- `_ensure_formatted_secondary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `__init__.py`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

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

- `backend/services/reports/annual_service/excel_generator.py`
- `backend/services/reports/table_builder/expense_renderer.py`
- `backend/services/reports/table_builder/revenue_helpers.py`

---

### File: `backend/services/reports/annual_service/annual_excel.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L53`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_clone_row_format()`
- `_replace_text_in_sheet()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_sum_sheet_column_formula()`
- `_safe_merge_cells_sheet()`
- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_sheet_ref()`
- `_write_secondary_summary_sheets()`
- `_set_merged_top_alignment()`
- `_sync_formatted_secondary_sheets()`
- `_clone_sheet_from_template()`
- `_ensure_formatted_secondary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `__init__.py`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

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

- `backend/services/reports/annual_service/excel_generator.py`
- `backend/services/reports/table_builder/expense_renderer.py`
- `backend/services/reports/table_builder/revenue_helpers.py`

---

### File: `backend/services/reports/annual_service/annual_excel.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L119`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_clone_row_format()`
- `_replace_text_in_sheet()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_sum_sheet_column_formula()`
- `_safe_merge_cells_sheet()`
- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_sheet_ref()`
- `_write_secondary_summary_sheets()`
- `_set_merged_top_alignment()`
- `_sync_formatted_secondary_sheets()`
- `_clone_sheet_from_template()`
- `_ensure_formatted_secondary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `__init__.py`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

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

- `backend/services/reports/annual_service/excel_generator.py`
- `backend/services/reports/table_builder/expense_renderer.py`
- `backend/services/reports/table_builder/revenue_helpers.py`

---

### File: `backend/services/reports/annual_service/annual_excel.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L177`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_clone_row_format()`
- `_replace_text_in_sheet()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_sum_sheet_column_formula()`
- `_safe_merge_cells_sheet()`
- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_sheet_ref()`
- `_write_secondary_summary_sheets()`
- `_set_merged_top_alignment()`
- `_sync_formatted_secondary_sheets()`
- `_clone_sheet_from_template()`
- `_ensure_formatted_secondary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `__init__.py`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

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

- `backend/services/reports/annual_service/excel_generator.py`
- `backend/services/reports/table_builder/expense_renderer.py`
- `backend/services/reports/table_builder/revenue_helpers.py`

---

### File: `backend/services/reports/annual_service/annual_excel.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L206`

**Risiko:** 🟢 **Aman** (14 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_clone_row_format()`
- `_replace_text_in_sheet()`
- `_copy_template_row()`
- `_copy_template_row_from_backup()`
- `_sum_sheet_column_formula()`
- `_safe_merge_cells_sheet()`
- `_add_image_to_sheet()`
- `_apply_autofit_sheet1()`
- `_sheet_ref()`
- `_write_secondary_summary_sheets()`
- `_set_merged_top_alignment()`
- `_sync_formatted_secondary_sheets()`
- `_clone_sheet_from_template()`
- `_ensure_formatted_secondary_sheets()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `CategoryGroup`
- `__init__.py`
- `_clear_merged_ranges_in_region()`
- `_clear_range_force()`
- `_idr_from_currency()`
- `_parse_iso_date()`
- `_root_category_info()`
- `_safe_set_cell_with_merge()`
- `_set_dividend_row_border()`

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

- `backend/services/reports/annual_service/excel_generator.py`
- `backend/services/reports/table_builder/expense_renderer.py`
- `backend/services/reports/table_builder/revenue_helpers.py`

---

### File: `backend/services/reports/annual_service/annual_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_extract_subcategory_from_description()`
- `_root_category_info()`
- `_subcategory_sort_key()`
- `_clear_merged_ranges_in_region()`
- `_write_dynamic_category_headers()`
- `_set_dividend_row_border()`
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
- `backend/services/reports/annual_service/excel_generator.py`
- `backend/services/reports/data_fetcher/db_fetchers.py`
- `backend/services/reports/data_fetcher/depreciation.py`
- `backend/services/reports/data_fetcher/payload_builder.py`

---

### File: `backend/services/reports/annual_service/annual_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L74`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_extract_subcategory_from_description()`
- `_root_category_info()`
- `_subcategory_sort_key()`
- `_clear_merged_ranges_in_region()`
- `_write_dynamic_category_headers()`
- `_set_dividend_row_border()`
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
- `backend/services/reports/annual_service/excel_generator.py`
- `backend/services/reports/data_fetcher/db_fetchers.py`
- `backend/services/reports/data_fetcher/depreciation.py`
- `backend/services/reports/data_fetcher/payload_builder.py`

---

### File: `backend/services/reports/annual_service/annual_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L103`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_extract_subcategory_from_description()`
- `_root_category_info()`
- `_subcategory_sort_key()`
- `_clear_merged_ranges_in_region()`
- `_write_dynamic_category_headers()`
- `_set_dividend_row_border()`
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
- `backend/services/reports/annual_service/excel_generator.py`
- `backend/services/reports/data_fetcher/db_fetchers.py`
- `backend/services/reports/data_fetcher/depreciation.py`
- `backend/services/reports/data_fetcher/payload_builder.py`

---

### File: `backend/services/reports/annual_service/annual_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L189`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_extract_subcategory_from_description()`
- `_root_category_info()`
- `_subcategory_sort_key()`
- `_clear_merged_ranges_in_region()`
- `_write_dynamic_category_headers()`
- `_set_dividend_row_border()`
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
- `backend/services/reports/annual_service/excel_generator.py`
- `backend/services/reports/data_fetcher/db_fetchers.py`
- `backend/services/reports/data_fetcher/depreciation.py`
- `backend/services/reports/data_fetcher/payload_builder.py`

---

### File: `backend/services/reports/annual_service/annual_tables.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `Category`
- `ManualCombineGroup`
- `__init__.py`
- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_as_iso_date()`
- `_build_annual_pdf_bytes()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_clear_merged_ranges_in_region()`

---

### File: `backend/services/reports/annual_service/caching.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_is_true()`
- `_annual_cache_paths()`
- `_load_annual_payload_cache()`
- `_save_annual_payload_cache()`
- `_save_annual_pdf_cache()`
- `clear_annual_report_cache()`

**Dipakai Oleh:**

- `backend/routes/master_data/categories.py`
- `backend/routes/reports/annual_fastapi.py`
- `backend/services/reports/annual_service/excel_generator.py`

---

### File: `backend/services/reports/annual_service/caching.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_is_true()`
- `_annual_cache_paths()`
- `_load_annual_payload_cache()`
- `_save_annual_payload_cache()`
- `_save_annual_pdf_cache()`
- `clear_annual_report_cache()`

**Dipakai Oleh:**

- `backend/routes/master_data/categories.py`
- `backend/routes/reports/annual_fastapi.py`
- `backend/services/reports/annual_service/excel_generator.py`

---

### File: `backend/services/reports/annual_service/caching.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L55`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_is_true()`
- `_annual_cache_paths()`
- `_load_annual_payload_cache()`
- `_save_annual_payload_cache()`
- `_save_annual_pdf_cache()`
- `clear_annual_report_cache()`

**Dipakai Oleh:**

- `backend/routes/master_data/categories.py`
- `backend/routes/reports/annual_fastapi.py`
- `backend/services/reports/annual_service/excel_generator.py`

---

### File: `backend/services/reports/annual_service/excel_generator.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_annual_report_excel()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `__init__.py`
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

- `backend/routes/reports/annual_fastapi.py`
- `backend/tests/test_annual_report_routes.py`

---

### File: `backend/services/reports/annual_service/excel_generator.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L118`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_annual_report_excel()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `__init__.py`
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

- `backend/routes/reports/annual_fastapi.py`
- `backend/tests/test_annual_report_routes.py`

---

### File: `backend/services/reports/annual_service/excel_generator.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L497`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `get_annual_report_excel()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `__init__.py`
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

- `backend/routes/reports/annual_fastapi.py`
- `backend/tests/test_annual_report_routes.py`

---

## 📁 Folder: `backend/services/reports/data_fetcher`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/reports/data_fetcher/__init__.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/reports/data_fetcher/db_fetchers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (9 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_tagged_ids_for_year()`
- `_has_any_report_tags()`
- `_fetch_revenue_data()`
- `_fetch_expense_data()`
- `_fetch_asset_data()`
- `_fetch_bank_transaction_data()`
- `_fetch_tax_data()`
- `_fetch_advance_items_data()`
- `_fetch_dividend_data()`

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

**Community Group:** `-` | **Lokasi:** `L1`

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

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_compute_dividend_distribution()`
- `_build_annual_payload_from_db()`

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

- `backend/routes/reports/annual_data.py`
- `backend/routes/reports/annual_fastapi.py`
- `backend/services/reports/annual_service/annual_data.py`

---

## 📁 Folder: `backend/services/reports/summary_service`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/reports/summary_service/__init__.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/reports/summary_service/data_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_validate_date()`
- `_display_settlement_status()`
- `_get_summary_approved_expenses()`
- `_expense_amount_for_summary()`
- `_get_display_subcategory()`
- `_summary_display_category()`
- `_build_summary_payload()`

**Bergantung Pada (Internal Imports):**

- `BankTransaction`
- `Category`
- `Expense`
- `Settlement`
- `__init__.py`

**Dipakai Oleh:**

- `backend/routes/reports/summary.py`
- `backend/services/reports/summary_service/excel_generator.py`
- `backend/services/reports/summary_service/pdf_generator.py`

---

### File: `backend/services/reports/summary_service/data_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L30`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_validate_date()`
- `_display_settlement_status()`
- `_get_summary_approved_expenses()`
- `_expense_amount_for_summary()`
- `_get_display_subcategory()`
- `_summary_display_category()`
- `_build_summary_payload()`

**Bergantung Pada (Internal Imports):**

- `BankTransaction`
- `Category`
- `Expense`
- `Settlement`
- `__init__.py`

**Dipakai Oleh:**

- `backend/routes/reports/summary.py`
- `backend/services/reports/summary_service/excel_generator.py`
- `backend/services/reports/summary_service/pdf_generator.py`

---

### File: `backend/services/reports/summary_service/data_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L49`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_validate_date()`
- `_display_settlement_status()`
- `_get_summary_approved_expenses()`
- `_expense_amount_for_summary()`
- `_get_display_subcategory()`
- `_summary_display_category()`
- `_build_summary_payload()`

**Bergantung Pada (Internal Imports):**

- `BankTransaction`
- `Category`
- `Expense`
- `Settlement`
- `__init__.py`

**Dipakai Oleh:**

- `backend/routes/reports/summary.py`
- `backend/services/reports/summary_service/excel_generator.py`
- `backend/services/reports/summary_service/pdf_generator.py`

---

### File: `backend/services/reports/summary_service/data_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L59`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_validate_date()`
- `_display_settlement_status()`
- `_get_summary_approved_expenses()`
- `_expense_amount_for_summary()`
- `_get_display_subcategory()`
- `_summary_display_category()`
- `_build_summary_payload()`

**Bergantung Pada (Internal Imports):**

- `BankTransaction`
- `Category`
- `Expense`
- `Settlement`
- `__init__.py`

**Dipakai Oleh:**

- `backend/routes/reports/summary.py`
- `backend/services/reports/summary_service/excel_generator.py`
- `backend/services/reports/summary_service/pdf_generator.py`

---

### File: `backend/services/reports/summary_service/data_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L93`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_validate_date()`
- `_display_settlement_status()`
- `_get_summary_approved_expenses()`
- `_expense_amount_for_summary()`
- `_get_display_subcategory()`
- `_summary_display_category()`
- `_build_summary_payload()`

**Bergantung Pada (Internal Imports):**

- `BankTransaction`
- `Category`
- `Expense`
- `Settlement`
- `__init__.py`

**Dipakai Oleh:**

- `backend/routes/reports/summary.py`
- `backend/services/reports/summary_service/excel_generator.py`
- `backend/services/reports/summary_service/pdf_generator.py`

---

### File: `backend/services/reports/summary_service/data_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L97`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_validate_date()`
- `_display_settlement_status()`
- `_get_summary_approved_expenses()`
- `_expense_amount_for_summary()`
- `_get_display_subcategory()`
- `_summary_display_category()`
- `_build_summary_payload()`

**Bergantung Pada (Internal Imports):**

- `BankTransaction`
- `Category`
- `Expense`
- `Settlement`
- `__init__.py`

**Dipakai Oleh:**

- `backend/routes/reports/summary.py`
- `backend/services/reports/summary_service/excel_generator.py`
- `backend/services/reports/summary_service/pdf_generator.py`

---

### File: `backend/services/reports/summary_service/excel_generator.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `generate_excel_report()`
- `generate_excel_advance_report()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `Category`
- `Expense`
- `Settlement`
- `__init__.py`
- `_build_summary_payload()`
- `_default_report_year()`
- `_get_summary_approved_expenses()`
- `_parse_iso_date()`

**Memanggil Fungsi/Modul:**

- `_build_summary_payload()`
- `_get_summary_approved_expenses()`

**Dipakai Oleh:**

- `backend/routes/reports/summary.py`
- `backend/tests/test_code_hygiene_fixes.py`

---

### File: `backend/services/reports/summary_service/pdf_generator.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `generate_pdf_advance_report()`
- `generate_settlement_receipt()`
- `generate_bulk_settlements_pdf()`
- `generate_bulk_advances_pdf()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `AdvanceItem`
- `Expense`
- `Settlement`
- `User`
- `__init__.py`
- `_display_settlement_status()`
- `_validate_date()`
- `data_helpers.py`

**Memanggil Fungsi/Modul:**

- `_display_settlement_status()`

**Dipakai Oleh:**

- `backend/routes/reports/summary.py`

---

## 📁 Folder: `backend/services/reports/table_builder`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak.

### File: `backend/services/reports/table_builder/__init__.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/reports/table_builder/expense_renderer.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_render_expense_section_from_data()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `ManualCombineGroup`
- `__init__.py`
- `_as_iso_date()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`
- `_clone_row_format()`

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

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_expense_column_mapping_name()`
- `_expense_amount_for_display()`
- `_expense_subcategory_label()`
- `_group_expenses_by_subcategory()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `__init__.py`
- `_idr_from_currency()`
- `_safe_text()`
- `_to_float()`
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

**Community Group:** `-` | **Lokasi:** `L50`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_expense_column_mapping_name()`
- `_expense_amount_for_display()`
- `_expense_subcategory_label()`
- `_group_expenses_by_subcategory()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `__init__.py`
- `_idr_from_currency()`
- `_safe_text()`
- `_to_float()`
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

**Community Group:** `-` | **Lokasi:** `L133`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_expense_column_mapping_name()`
- `_expense_amount_for_display()`
- `_expense_subcategory_label()`
- `_group_expenses_by_subcategory()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `__init__.py`
- `_idr_from_currency()`
- `_safe_text()`
- `_to_float()`
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

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_build_annual_pdf_bytes()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `ManualCombineGroup`
- `__init__.py`
- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_as_iso_date()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`

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

- `backend/routes/reports/annual_fastapi.py`
- `backend/routes/reports/annual_tables.py`
- `backend/services/reports/annual_service/annual_tables.py`

---

### File: `backend/services/reports/table_builder/revenue_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_manual_combine_groups_by_table()`
- `_manual_combine_groups_by_rows()`
- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_operation_cost_totals_by_column()`
- `_get_revenue_bounds()`
- `_group_revenues_by_type()`
- `_validate_revenue_data()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `ManualCombineGroup`
- `__init__.py`
- `_as_iso_date()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`
- `_expense_amount_for_display()`

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

**Community Group:** `-` | **Lokasi:** `L99`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_manual_combine_groups_by_table()`
- `_manual_combine_groups_by_rows()`
- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_operation_cost_totals_by_column()`
- `_get_revenue_bounds()`
- `_group_revenues_by_type()`
- `_validate_revenue_data()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `ManualCombineGroup`
- `__init__.py`
- `_as_iso_date()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`
- `_expense_amount_for_display()`

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

**Community Group:** `-` | **Lokasi:** `L334`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_manual_combine_groups_by_table()`
- `_manual_combine_groups_by_rows()`
- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_operation_cost_totals_by_column()`
- `_get_revenue_bounds()`
- `_group_revenues_by_type()`
- `_validate_revenue_data()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `ManualCombineGroup`
- `__init__.py`
- `_as_iso_date()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`
- `_expense_amount_for_display()`

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

**Community Group:** `-` | **Lokasi:** `L350`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_manual_combine_groups_by_table()`
- `_manual_combine_groups_by_rows()`
- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_operation_cost_totals_by_column()`
- `_get_revenue_bounds()`
- `_group_revenues_by_type()`
- `_validate_revenue_data()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `ManualCombineGroup`
- `__init__.py`
- `_as_iso_date()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`
- `_expense_amount_for_display()`

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

**Community Group:** `-` | **Lokasi:** `L366`

**Risiko:** 🟢 **Aman** (8 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_manual_combine_groups_by_table()`
- `_manual_combine_groups_by_rows()`
- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_operation_cost_totals_by_column()`
- `_get_revenue_bounds()`
- `_group_revenues_by_type()`
- `_validate_revenue_data()`

**Bergantung Pada (Internal Imports):**

- `Category`
- `ManualCombineGroup`
- `__init__.py`
- `_as_iso_date()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_clear_merged_ranges_in_region()`
- `_clear_range()`
- `_clear_range_force()`
- `_expense_amount_for_display()`

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

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/settlements/settlement_approval_service.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_calculate_settlement_per_bank_netting()`
- `process_submit_settlement()`
- `process_approve_settlement()`
- `process_complete_settlement()`
- `process_reject_all_expenses()`
- `process_final_approve_settlement()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `Config`
- `Notification`
- `OverrideLog`
- `Settlement`
- `User`
- `__init__.py`
- `_has_unchecked_checklist()`

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

**Community Group:** `-` | **Lokasi:** `L23`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_calculate_settlement_per_bank_netting()`
- `process_submit_settlement()`
- `process_approve_settlement()`
- `process_complete_settlement()`
- `process_reject_all_expenses()`
- `process_final_approve_settlement()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `BankAccount`
- `BankTransaction`
- `Config`
- `Notification`
- `OverrideLog`
- `Settlement`
- `User`
- `__init__.py`
- `_has_unchecked_checklist()`

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

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/services/transactions/dividend_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_fetch_revenues_and_expenses_for_year()`
- `_build_dividend_payload()`

**Bergantung Pada (Internal Imports):**

- `Dividend`
- `DividendSetting`
- `Expense`
- `Revenue`
- `Settlement`
- `__init__.py`
- `_compute_dividend_distribution_v2()`

**Memanggil Fungsi/Modul:**

- `_compute_dividend_distribution_v2()`

**Dipakai Oleh:**

- `backend/routes/transactions/dividends.py`

---

### File: `backend/services/transactions/dividend_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L13`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_fetch_revenues_and_expenses_for_year()`
- `_build_dividend_payload()`

**Bergantung Pada (Internal Imports):**

- `Dividend`
- `DividendSetting`
- `Expense`
- `Revenue`
- `Settlement`
- `__init__.py`
- `_compute_dividend_distribution_v2()`

**Memanggil Fungsi/Modul:**

- `_compute_dividend_distribution_v2()`

**Dipakai Oleh:**

- `backend/routes/transactions/dividends.py`

---

### File: `backend/services/transactions/revenue_service.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_validate_manual_revenue_group()`

**Bergantung Pada (Internal Imports):**

- `ManualCombineGroup`
- `Revenue`
- `__init__.py`

**Dipakai Oleh:**

- `backend/routes/transactions/revenues.py`

---

## 📁 Folder: `backend/tests`

**Tujuan Folder:** File inti / konfigurasi utama aplikasi backend.

### File: `backend/tests/test_annual_report_routes.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `client()`
- `test_excel_generator_logger_and_function_exist()`
- `test_annual_routes_registered()`
- `test_annual_excel_requires_auth()`
- `test_annual_pdf_requires_auth()`
- `test_annual_json_requires_auth()`

**Bergantung Pada (Internal Imports):**

- `create_app()`
- `excel_generator.py`

**Memanggil Fungsi/Modul:**

- `create_app()`

---

### File: `backend/tests/test_annual_report_routes.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L26`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `client()`
- `test_excel_generator_logger_and_function_exist()`
- `test_annual_routes_registered()`
- `test_annual_excel_requires_auth()`
- `test_annual_pdf_requires_auth()`
- `test_annual_json_requires_auth()`

**Bergantung Pada (Internal Imports):**

- `create_app()`
- `excel_generator.py`

**Memanggil Fungsi/Modul:**

- `create_app()`

---

### File: `backend/tests/test_annual_report_routes.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L35`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `client()`
- `test_excel_generator_logger_and_function_exist()`
- `test_annual_routes_registered()`
- `test_annual_excel_requires_auth()`
- `test_annual_pdf_requires_auth()`
- `test_annual_json_requires_auth()`

**Bergantung Pada (Internal Imports):**

- `create_app()`
- `excel_generator.py`

**Memanggil Fungsi/Modul:**

- `create_app()`

---

### File: `backend/tests/test_annual_report_routes.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L43`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `client()`
- `test_excel_generator_logger_and_function_exist()`
- `test_annual_routes_registered()`
- `test_annual_excel_requires_auth()`
- `test_annual_pdf_requires_auth()`
- `test_annual_json_requires_auth()`

**Bergantung Pada (Internal Imports):**

- `create_app()`
- `excel_generator.py`

**Memanggil Fungsi/Modul:**

- `create_app()`

---

### File: `backend/tests/test_annual_report_routes.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L49`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `client()`
- `test_excel_generator_logger_and_function_exist()`
- `test_annual_routes_registered()`
- `test_annual_excel_requires_auth()`
- `test_annual_pdf_requires_auth()`
- `test_annual_json_requires_auth()`

**Bergantung Pada (Internal Imports):**

- `create_app()`
- `excel_generator.py`

**Memanggil Fungsi/Modul:**

- `create_app()`

---

### File: `backend/tests/test_annual_report_routes.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L55`

**Risiko:** 🟢 **Aman** (7 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `client()`
- `test_excel_generator_logger_and_function_exist()`
- `test_annual_routes_registered()`
- `test_annual_excel_requires_auth()`
- `test_annual_pdf_requires_auth()`
- `test_annual_json_requires_auth()`

**Bergantung Pada (Internal Imports):**

- `create_app()`
- `excel_generator.py`

**Memanggil Fungsi/Modul:**

- `create_app()`

---

### File: `backend/tests/test_blueprint_routes.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `client()`
- `test_native_routers_registered()`
- `test_reports_endpoints_methods()`
- `test_auth_login_endpoint()`

**Bergantung Pada (Internal Imports):**

- `create_app()`

**Memanggil Fungsi/Modul:**

- `create_app()`

---

### File: `backend/tests/test_blueprint_routes.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L24`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `client()`
- `test_native_routers_registered()`
- `test_reports_endpoints_methods()`
- `test_auth_login_endpoint()`

**Bergantung Pada (Internal Imports):**

- `create_app()`

**Memanggil Fungsi/Modul:**

- `create_app()`

---

### File: `backend/tests/test_blueprint_routes.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L53`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `client()`
- `test_native_routers_registered()`
- `test_reports_endpoints_methods()`
- `test_auth_login_endpoint()`

**Bergantung Pada (Internal Imports):**

- `create_app()`

**Memanggil Fungsi/Modul:**

- `create_app()`

---

### File: `backend/tests/test_blueprint_routes.py`

**Tanggung Jawab:** Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Community Group:** `-` | **Lokasi:** `L73`

**Risiko:** 🟢 **Aman** (5 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `client()`
- `test_native_routers_registered()`
- `test_reports_endpoints_methods()`
- `test_auth_login_endpoint()`

**Bergantung Pada (Internal Imports):**

- `create_app()`

**Memanggil Fungsi/Modul:**

- `create_app()`

---

### File: `backend/tests/test_code_hygiene_fixes.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `test_summary_excel_generator_logger()`
- `test_transaction_dto_keys_not_duplicated()`

**Bergantung Pada (Internal Imports):**

- `TransactionDTO`
- `excel_generator.py`

**Memanggil Fungsi/Modul:**

- `.advance_to_dict()`
- `.settlement_to_dict()`

---

### File: `backend/tests/test_code_hygiene_fixes.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L16`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `test_summary_excel_generator_logger()`
- `test_transaction_dto_keys_not_duplicated()`

**Bergantung Pada (Internal Imports):**

- `TransactionDTO`
- `excel_generator.py`

**Memanggil Fungsi/Modul:**

- `.advance_to_dict()`
- `.settlement_to_dict()`

---

### File: `backend/tests/test_code_hygiene_fixes.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L23`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `test_summary_excel_generator_logger()`
- `test_transaction_dto_keys_not_duplicated()`

**Bergantung Pada (Internal Imports):**

- `TransactionDTO`
- `excel_generator.py`

**Memanggil Fungsi/Modul:**

- `.advance_to_dict()`
- `.settlement_to_dict()`

---

### File: `backend/tests/test_financial_math_logic.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `test_bank_real_balance_calculation()`
- `test_parsing_helpers_safety()`
- `test_settlement_reimbursement_virtual_bank_deduction()`

**Bergantung Pada (Internal Imports):**

- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `__init__.py`
- `_clean_currency()`
- `_to_float()`
- `_year_date_bounds()`
- `calculate_bank_composition()`
- `calculate_bank_real_balance()`

**Memanggil Fungsi/Modul:**

- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `_clean_currency()`
- `_to_float()`
- `_year_date_bounds()`
- `calculate_bank_composition()`
- `calculate_bank_real_balance()`
- `create_app()`

---

### File: `backend/tests/test_financial_math_logic.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L28`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `test_bank_real_balance_calculation()`
- `test_parsing_helpers_safety()`
- `test_settlement_reimbursement_virtual_bank_deduction()`

**Bergantung Pada (Internal Imports):**

- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `__init__.py`
- `_clean_currency()`
- `_to_float()`
- `_year_date_bounds()`
- `calculate_bank_composition()`
- `calculate_bank_real_balance()`

**Memanggil Fungsi/Modul:**

- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `_clean_currency()`
- `_to_float()`
- `_year_date_bounds()`
- `calculate_bank_composition()`
- `calculate_bank_real_balance()`
- `create_app()`

---

### File: `backend/tests/test_financial_math_logic.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L65`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `test_bank_real_balance_calculation()`
- `test_parsing_helpers_safety()`
- `test_settlement_reimbursement_virtual_bank_deduction()`

**Bergantung Pada (Internal Imports):**

- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `__init__.py`
- `_clean_currency()`
- `_to_float()`
- `_year_date_bounds()`
- `calculate_bank_composition()`
- `calculate_bank_real_balance()`

**Memanggil Fungsi/Modul:**

- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `_clean_currency()`
- `_to_float()`
- `_year_date_bounds()`
- `calculate_bank_composition()`
- `calculate_bank_real_balance()`
- `create_app()`

---

### File: `backend/tests/test_financial_math_logic.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L88`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `test_bank_real_balance_calculation()`
- `test_parsing_helpers_safety()`
- `test_settlement_reimbursement_virtual_bank_deduction()`

**Bergantung Pada (Internal Imports):**

- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `__init__.py`
- `_clean_currency()`
- `_to_float()`
- `_year_date_bounds()`
- `calculate_bank_composition()`
- `calculate_bank_real_balance()`

**Memanggil Fungsi/Modul:**

- `BankAccount`
- `BankTransaction`
- `Settlement`
- `User`
- `_clean_currency()`
- `_to_float()`
- `_year_date_bounds()`
- `calculate_bank_composition()`
- `calculate_bank_real_balance()`
- `create_app()`

---

### File: `backend/tests/test_revenue_bank_sync.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `test_revenue_model_has_bank_relationship()`
- `test_bank_transaction_has_revenue_relationship()`
- `test_revenue_to_dict_includes_bank_info()`
- `test_sync_revenue_bank_transaction_creates_and_updates_and_deletes()`
- `test_revenue_and_bank_transaction_tracks_creator()`

**Bergantung Pada (Internal Imports):**

- `BankAccount`
- `BankTransaction`
- `Revenue`
- `TransactionDTO`
- `User`
- `__init__.py`
- `calculate_bank_real_balance()`
- `create_app()`
- `revenues.py`
- `sync_revenue_bank_transaction()`

**Memanggil Fungsi/Modul:**

- `.revenue_to_dict()`
- `BankAccount`
- `BankTransaction`
- `Revenue`
- `User`
- `calculate_bank_real_balance()`
- `create_app()`
- `sync_revenue_bank_transaction()`

---

### File: `backend/tests/test_revenue_bank_sync.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L30`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `test_revenue_model_has_bank_relationship()`
- `test_bank_transaction_has_revenue_relationship()`
- `test_revenue_to_dict_includes_bank_info()`
- `test_sync_revenue_bank_transaction_creates_and_updates_and_deletes()`
- `test_revenue_and_bank_transaction_tracks_creator()`

**Bergantung Pada (Internal Imports):**

- `BankAccount`
- `BankTransaction`
- `Revenue`
- `TransactionDTO`
- `User`
- `__init__.py`
- `calculate_bank_real_balance()`
- `create_app()`
- `revenues.py`
- `sync_revenue_bank_transaction()`

**Memanggil Fungsi/Modul:**

- `.revenue_to_dict()`
- `BankAccount`
- `BankTransaction`
- `Revenue`
- `User`
- `calculate_bank_real_balance()`
- `create_app()`
- `sync_revenue_bank_transaction()`

---

### File: `backend/tests/test_revenue_bank_sync.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L61`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `test_revenue_model_has_bank_relationship()`
- `test_bank_transaction_has_revenue_relationship()`
- `test_revenue_to_dict_includes_bank_info()`
- `test_sync_revenue_bank_transaction_creates_and_updates_and_deletes()`
- `test_revenue_and_bank_transaction_tracks_creator()`

**Bergantung Pada (Internal Imports):**

- `BankAccount`
- `BankTransaction`
- `Revenue`
- `TransactionDTO`
- `User`
- `__init__.py`
- `calculate_bank_real_balance()`
- `create_app()`
- `revenues.py`
- `sync_revenue_bank_transaction()`

**Memanggil Fungsi/Modul:**

- `.revenue_to_dict()`
- `BankAccount`
- `BankTransaction`
- `Revenue`
- `User`
- `calculate_bank_real_balance()`
- `create_app()`
- `sync_revenue_bank_transaction()`

---

### File: `backend/tests/test_revenue_bank_sync.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L97`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `test_revenue_model_has_bank_relationship()`
- `test_bank_transaction_has_revenue_relationship()`
- `test_revenue_to_dict_includes_bank_info()`
- `test_sync_revenue_bank_transaction_creates_and_updates_and_deletes()`
- `test_revenue_and_bank_transaction_tracks_creator()`

**Bergantung Pada (Internal Imports):**

- `BankAccount`
- `BankTransaction`
- `Revenue`
- `TransactionDTO`
- `User`
- `__init__.py`
- `calculate_bank_real_balance()`
- `create_app()`
- `revenues.py`
- `sync_revenue_bank_transaction()`

**Memanggil Fungsi/Modul:**

- `.revenue_to_dict()`
- `BankAccount`
- `BankTransaction`
- `Revenue`
- `User`
- `calculate_bank_real_balance()`
- `create_app()`
- `sync_revenue_bank_transaction()`

---

### File: `backend/tests/test_revenue_bank_sync.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L138`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `test_revenue_model_has_bank_relationship()`
- `test_bank_transaction_has_revenue_relationship()`
- `test_revenue_to_dict_includes_bank_info()`
- `test_sync_revenue_bank_transaction_creates_and_updates_and_deletes()`
- `test_revenue_and_bank_transaction_tracks_creator()`

**Bergantung Pada (Internal Imports):**

- `BankAccount`
- `BankTransaction`
- `Revenue`
- `TransactionDTO`
- `User`
- `__init__.py`
- `calculate_bank_real_balance()`
- `create_app()`
- `revenues.py`
- `sync_revenue_bank_transaction()`

**Memanggil Fungsi/Modul:**

- `.revenue_to_dict()`
- `BankAccount`
- `BankTransaction`
- `Revenue`
- `User`
- `calculate_bank_real_balance()`
- `create_app()`
- `sync_revenue_bank_transaction()`

---

### File: `backend/tests/test_revenue_bank_sync.py`

**Tanggung Jawab:** Modul pendukung spesifik sesuai nama file.

**Community Group:** `-` | **Lokasi:** `L209`

**Risiko:** 🟢 **Aman** (6 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `app()`
- `test_revenue_model_has_bank_relationship()`
- `test_bank_transaction_has_revenue_relationship()`
- `test_revenue_to_dict_includes_bank_info()`
- `test_sync_revenue_bank_transaction_creates_and_updates_and_deletes()`
- `test_revenue_and_bank_transaction_tracks_creator()`

**Bergantung Pada (Internal Imports):**

- `BankAccount`
- `BankTransaction`
- `Revenue`
- `TransactionDTO`
- `User`
- `__init__.py`
- `calculate_bank_real_balance()`
- `create_app()`
- `revenues.py`
- `sync_revenue_bank_transaction()`

**Memanggil Fungsi/Modul:**

- `.revenue_to_dict()`
- `BankAccount`
- `BankTransaction`
- `Revenue`
- `User`
- `calculate_bank_real_balance()`
- `create_app()`
- `sync_revenue_bank_transaction()`

---

## 📁 Folder: `backend/utils`

**Tujuan Folder:** Menyimpan fungsi utilitas umum (formatting, perhitungan, auth helpers).

### File: `backend/utils/__init__.py`

**Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

---

### File: `backend/utils/auth_helper.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `get_current_user()`
- `require_role()`
- `security.py`

---

### File: `backend/utils/auth_helper.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Bergantung Pada (Internal Imports):**

- `get_current_user()`
- `require_role()`
- `security.py`

---

### File: `backend/utils/constants.py`

**Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (0 fungsi/metode terdeteksi).

**Classes / Models:**

- `Status` (L1)
- `RevenueType` (L18)
- `UserRole` (L22)

---

### File: `backend/utils/deadline_worker.py`

**Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_normalize_rule_key()`
- `check_and_create_deadline_notifications()`
- `_cleanup_stale_deadline_notifications()`
- `_create_deadline_notification_if_missing()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `DeadlineSetting`
- `Notification`
- `Settlement`
- `User`
- `__init__.py`

**Memanggil Fungsi/Modul:**

- `Notification`

---

### File: `backend/utils/deadline_worker.py`

**Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_normalize_rule_key()`
- `check_and_create_deadline_notifications()`
- `_cleanup_stale_deadline_notifications()`
- `_create_deadline_notification_if_missing()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `DeadlineSetting`
- `Notification`
- `Settlement`
- `User`
- `__init__.py`

**Memanggil Fungsi/Modul:**

- `Notification`

---

### File: `backend/utils/deadline_worker.py`

**Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.

**Community Group:** `-` | **Lokasi:** `L23`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_normalize_rule_key()`
- `check_and_create_deadline_notifications()`
- `_cleanup_stale_deadline_notifications()`
- `_create_deadline_notification_if_missing()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `DeadlineSetting`
- `Notification`
- `Settlement`
- `User`
- `__init__.py`

**Memanggil Fungsi/Modul:**

- `Notification`

---

### File: `backend/utils/deadline_worker.py`

**Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.

**Community Group:** `-` | **Lokasi:** `L229`

**Risiko:** 🟢 **Aman** (4 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_normalize_rule_key()`
- `check_and_create_deadline_notifications()`
- `_cleanup_stale_deadline_notifications()`
- `_create_deadline_notification_if_missing()`

**Bergantung Pada (Internal Imports):**

- `Advance`
- `DeadlineSetting`
- `Notification`
- `Settlement`
- `User`
- `__init__.py`

**Memanggil Fungsi/Modul:**

- `Notification`

---

### File: `backend/utils/parsing_helper.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (12 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `allowed_file()`
- `_parse_checklist_notes()`
- `_has_unchecked_checklist()`
- `_has_unchecked_return_checklist()`
- `_merge_rejection_notes()`
- `_parse_date()`
- `_parse_float_safe()`
- `_parse_number_value()`
- `_parse_category_ids()`
- `_default_report_year()`
- `_year_date_bounds()`
- `_parse_iso_date()`

**Bergantung Pada (Internal Imports):**

- `Config`

**Dipakai Oleh:**

- `backend/routes/master_data/taxes.py`
- `backend/routes/reports/annual_fastapi.py`
- `backend/routes/reports/summary.py`
- `backend/routes/settlements/settlements_expenses.py`
- `backend/routes/transactions/dividends.py`
- `backend/routes/transactions/expenses.py`
- `backend/routes/transactions/revenues.py`
- `backend/services/advances/advance_approval_service.py`

---

### File: `backend/utils/parsing_helper.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L42`

**Risiko:** 🟢 **Aman** (12 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `allowed_file()`
- `_parse_checklist_notes()`
- `_has_unchecked_checklist()`
- `_has_unchecked_return_checklist()`
- `_merge_rejection_notes()`
- `_parse_date()`
- `_parse_float_safe()`
- `_parse_number_value()`
- `_parse_category_ids()`
- `_default_report_year()`
- `_year_date_bounds()`
- `_parse_iso_date()`

**Bergantung Pada (Internal Imports):**

- `Config`

**Dipakai Oleh:**

- `backend/routes/master_data/taxes.py`
- `backend/routes/reports/annual_fastapi.py`
- `backend/routes/reports/summary.py`
- `backend/routes/settlements/settlements_expenses.py`
- `backend/routes/transactions/dividends.py`
- `backend/routes/transactions/expenses.py`
- `backend/routes/transactions/revenues.py`
- `backend/services/advances/advance_approval_service.py`

---

### File: `backend/utils/report_helpers.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L27`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L36`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L44`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L56`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L65`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L91`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L132`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L139`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L151`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L221`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L324`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L455`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L468`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L482`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L501`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L515`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L529`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L617`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L638`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L649`

**Risiko:** 🟢 **Aman** (43 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `_default_report_year()`
- `_year_date_bounds()`
- `_safe_set_cell()`
- `_get_top_left_cell()`
- `_safe_set_cell_with_merge()`
- `_get_dynamic_row_height()`
- `_merge_description_cell()`
- `_get_column_letter()`
- `_safe_set_number()`
- `_unmerge_region()`
- `_normalize_external_formula_refs()`
- `_clear_range()`
- `_clear_data_keep_formulas()`
- `_clear_range_force()`
- `_set_rows_hidden()`
- `_safe_text()`
- `_extract_imported_row()`
- `_extract_imported_sheet_row()`
- `_is_date_like()`
- `_is_template_detail_data_row()`
- *(... dan 23 fungsi lainnya)*

**Bergantung Pada (Internal Imports):**

- `Config`

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

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `delete_evidence_file()`

**Bergantung Pada (Internal Imports):**

- `Config`

**Dipakai Oleh:**

- `backend/routes/transactions/expenses.py`
- `backend/services/advances/advance_items_service.py`

---

### File: `backend/utils/storage.py`

**Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.

**Community Group:** `-` | **Lokasi:** `L7`

**Risiko:** 🟢 **Aman** (1 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `delete_evidence_file()`

**Bergantung Pada (Internal Imports):**

- `Config`

**Dipakai Oleh:**

- `backend/routes/transactions/expenses.py`
- `backend/services/advances/advance_items_service.py`

---

### File: `backend/utils/transaction_templates.py`

**Tanggung Jawab:** Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (9 fungsi/metode terdeteksi).

**Classes / Models:**

- `TxTemplates` (L1)

**Fungsi / Metode:**

- `.allocation_notes()`
- `.advance_approved_final()`
- `.advance_rejected_final()`
- `.settlement_approved_final()`
- `.settlement_rejected_final()`
- `.advance_revision_requested()`
- `.advance_move_to_draft()`
- `.disbursement()`
- `.refund_notes()`

**Dipakai Oleh:**

- `backend/routes/advances/advances_other.py`
- `backend/routes/master_data/bank_management.py`

---

### File: `backend/utils/workflow_helper.py`

**Tanggung Jawab:** Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route.

**Community Group:** `-` | **Lokasi:** `L1`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `log_workflow()`
- `update_document_stage()`

**Bergantung Pada (Internal Imports):**

- `WorkflowLog`
- `__init__.py`

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

**Community Group:** `-` | **Lokasi:** `L9`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `log_workflow()`
- `update_document_stage()`

**Bergantung Pada (Internal Imports):**

- `WorkflowLog`
- `__init__.py`

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

**Community Group:** `-` | **Lokasi:** `L54`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `log_workflow()`
- `update_document_stage()`

**Bergantung Pada (Internal Imports):**

- `WorkflowLog`
- `__init__.py`

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

**Community Group:** `-` | **Lokasi:** `L59`

**Risiko:** 🟢 **Aman** (2 fungsi/metode terdeteksi).

**Fungsi / Metode:**

- `log_workflow()`
- `update_document_stage()`

**Bergantung Pada (Internal Imports):**

- `WorkflowLog`
- `__init__.py`

**Memanggil Fungsi/Modul:**

- `WorkflowLog`

**Dipakai Oleh:**

- `backend/routes/advances/advances_disbursement.py`
- `backend/routes/settlements/settlements_disbursement.py`
- `backend/services/advances/advance_approval_service.py`
- `backend/services/approvals/settlement_helpers.py`
- `backend/services/settlements/settlement_approval_service.py`

---

