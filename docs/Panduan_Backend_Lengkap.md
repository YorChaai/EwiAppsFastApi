# Panduan Lengkap Backend (MiniProjectKPI_EWI_Revisi2)

Dokumen ini digenerate secara menyeluruh untuk merinci struktur, peran, dependensi, fungsi, dan isi dari setiap file Python di dalam folder `backend`.
Ditujukan agar developer baru atau AI (LLM) dapat memahami aplikasi backend (Flask/FastAPI/lainnya) tanpa harus membaca source code satu per satu.

## Folder: `Root (backend)`

### File: `app.py`

**Tanggung Jawab (Responsibility):**
- Entry-point server backend. Melakukan inisialisasi aplikasi, database, middleware, dan mendaftarkan blueprint/routes.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `create_app()`
- `run_database_integrity_maintenance()`
- `seed_data()`

---

### File: `config.py`

**Tanggung Jawab (Responsibility):**
- Mengelola environment variables dan konfigurasi server.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Classes Terdeteksi:**
- `Config`

---

## Folder: `models`

**Tujuan Folder:** Mendefinisikan skema database (ORM) dan validasi data.

### File: `models\banking.py`

**Tanggung Jawab (Responsibility):**
- Merepresentasikan tabel database (SQLAlchemy/lainnya) dan skema data.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Classes Terdeteksi:**
- `BankAccount`
- `BankTransaction`
- `BankStatusTransaction`

---

### File: `models\base.py`

**Tanggung Jawab (Responsibility):**
- Merepresentasikan tabel database (SQLAlchemy/lainnya) dan skema data.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

---

### File: `models\core.py`

**Tanggung Jawab (Responsibility):**
- Merepresentasikan tabel database (SQLAlchemy/lainnya) dan skema data.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Classes Terdeteksi:**
- `Company`
- `User`
- `CategoryGroup`
- `Category`

---

### File: `models\system.py`

**Tanggung Jawab (Responsibility):**
- Merepresentasikan tabel database (SQLAlchemy/lainnya) dan skema data.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Classes Terdeteksi:**
- `Notification`
- `DeadlineSetting`
- `WorkflowLog`
- `OverrideLog`

---

### File: `models\transaction.py`

**Tanggung Jawab (Responsibility):**
- Merepresentasikan tabel database (SQLAlchemy/lainnya) dan skema data.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Classes Terdeteksi:**
- `Asset`
- `Advance`
- `AdvanceItem`
- `Settlement`
- `Expense`
- `Revenue`
- `Tax`
- `ManualCombineGroup`
- `Dividend`
- `DividendSetting`

---

## Folder: `routes\advances`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `routes\advances\advances.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

---

### File: `routes\advances\advances_approval.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `start_revision()`
- `submit_advance()`
- `approve_advance()`
- `reject_advance()`
- `approve_advance_item()`
- `reject_advance_item()`
- `final_approve_advance()`

---

### File: `routes\advances\advances_crud.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `list_advances()`
- `create_advance()`
- `get_advance()`
- `update_advance()`
- `delete_advance()`
- `get_advance_history()`

---

### File: `routes\advances\advances_disbursement.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `save_disbursement()`
- `save_return()`
- `approve_disbursement()`

---

### File: `routes\advances\advances_items.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `add_advance_item()`
- `update_advance_item()`
- `delete_advance_item()`
- `bulk_delete_advance_items()`
- `update_advance_items_bulk()`

---

### File: `routes\advances\advances_other.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `override_advance()`
- `move_advance_to_draft()`
- `initialize_balance()`
- `get_override_logs_list()`
- `get_user_balances()`

---

## Folder: `routes\core`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `routes\core\auth.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `forgot_password()`
- `reset_password()`
- `google_login()`
- `login()`
- `register()`
- `me()`
- `update_profile()`
- `get_my_outstanding()`
- `list_users()`
- `create_user()`
- `update_user_by_manager()`
- `get_user_active_advance_balance()`
- `get_all_active_advance_balances()`
- `get_user_detail()`
- `link_google()`
- `unlink_google()`
- `google_login_browser()`

---

### File: `routes\core\cleanup.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `cleanup_preview()`
- `cleanup_execute()`

---

### File: `routes\core\dashboard.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_summary()`

---

### File: `routes\core\notifications.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_notifications()`
- `mark_notification_as_read()`
- `mark_all_notifications_as_read()`
- `delete_notification()`
- `get_unread_count()`

---

## Folder: `routes\master_data`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `routes\master_data\bank_management.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `list_management_banks()`
- `create_management_bank()`
- `update_management_bank()`
- `delete_management_bank()`
- `list_management_transactions()`
- `create_management_transaction()`
- `update_management_transaction()`
- `delete_management_transaction()`

---

### File: `routes\master_data\bank_status.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `list_all_banks_for_status()`
- `list_status_transactions()`
- `create_status_transaction()`
- `update_status_transaction()`
- `delete_status_transaction()`

---

### File: `routes\master_data\categories.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
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

---

### File: `routes\master_data\companies.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_companies()`
- `create_company()`
- `update_company()`
- `delete_company()`
- `reorder_companies()`

---

### File: `routes\master_data\taxes.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_taxes()`
- `get_tax()`
- `create_tax()`
- `update_tax()`
- `delete_tax()`
- `get_tax_combine_groups()`
- `create_tax_combine_group()`
- `delete_tax_combine_group()`

---

## Folder: `routes\reports`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `routes\reports\annual.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_default_report_year()`
- `get_annual_report()`
- `get_annual_report_pdf()`

---

### File: `routes\reports\annual_constants.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

---

### File: `routes\reports\annual_data.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

---

### File: `routes\reports\annual_excel.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.

**Fungsi Utama (Metode/Endpoint):**
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

---

### File: `routes\reports\annual_helpers.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_extract_subcategory_from_description()`
- `_root_category_info()`
- `_subcategory_sort_key()`
- `_clear_merged_ranges_in_region()`
- `_write_dynamic_category_headers()`
- `_set_dividend_row_border()`
- `_compute_dividend_distribution_v2()`

---

### File: `routes\reports\annual_tables.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

---

### File: `routes\reports\summary.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_summary_report()`
- `export_summary_pdf()`

---

## Folder: `routes\settings`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `routes\settings\db_storage.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `manage_storage()`
- `export_database()`
- `import_database_preview()`
- `import_database_confirm()`

---

### File: `routes\settings\deadline.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `manage_deadline_settings()`

---

### File: `routes\settings\profile.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_companies()`
- `manage_report_year()`

---

## Folder: `routes\settlements`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `routes\settlements\settlements.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

---

### File: `routes\settlements\settlements_approval.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `submit_settlement()`
- `approve_settlement()`
- `complete_settlement()`
- `reject_all_expenses()`
- `final_approve_settlement()`

---

### File: `routes\settlements\settlements_crud.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `list_settlements()`
- `create_settlement()`
- `get_settlement()`
- `update_settlement()`
- `delete_settlement()`
- `get_settlement_history()`

---

### File: `routes\settlements\settlements_disbursement.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `save_disbursement()`
- `save_return()`
- `approve_disbursement()`
- `standalone_return()`

---

### File: `routes\settlements\settlements_expenses.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `update_expense()`

---

### File: `routes\settlements\settlements_other.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `override_settlement()`
- `move_to_draft()`

---

## Folder: `routes\transactions`

**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.

### File: `routes\transactions\assets.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `list_assets()`
- `create_asset()`
- `update_asset()`
- `delete_asset()`

---

### File: `routes\transactions\dividends.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_dividends()`
- `get_dividend()`
- `create_dividend()`
- `update_dividend()`
- `update_dividend_setting()`
- `delete_dividend()`

---

### File: `routes\transactions\expenses.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `create_expense()`
- `update_expense()`
- `bulk_delete_expenses()`
- `delete_expense()`
- `approve_expense()`
- `reject_expense()`
- `serve_evidence()`
- `list_categories()`

---

### File: `routes\transactions\revenues.py`

**Tanggung Jawab (Responsibility):**
- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_revenues()`
- `get_revenue()`
- `create_revenue()`
- `update_revenue()`
- `toggle_tax_offset()`
- `delete_revenue()`
- `get_revenue_combine_groups()`
- `create_revenue_combine_group()`
- `delete_revenue_combine_group()`

---

## Folder: `services\advances`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak terlalu besar.

### File: `services\advances\advance_approval_service.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `process_start_revision()`
- `process_submit_advance()`
- `process_approve_advance()`
- `process_reject_advance()`
- `process_approve_advance_item()`
- `process_reject_advance_item()`
- `process_final_approve_advance()`

---

### File: `services\advances\advance_items_service.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Classes Terdeteksi:**
- `AdvanceItemsService`

---

## Folder: `services\approvals`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak terlalu besar.

### File: `services\approvals\advance_helpers.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_cash_composition_for_error()`
- `normalize_source()`
- `_advance_view_status_filter()`
- `_editable_revision_no()`
- `_items_for_revision()`
- `_next_revision_no()`
- `_status_after_approval()`

---

### File: `services\approvals\settlement_helpers.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_sync_advance_after_settlement()`
- `rollback_settlement_transactions()`

---

## Folder: `services\balance`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak terlalu besar.

### File: `services\balance\balance_service.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `calculate_bank_real_balance()`
- `_get_user_advance_banks()`
- `calculate_user_running_balance()`
- `calculate_user_available_budget()`
- `calculate_user_running_balance_per_bank()`
- `get_all_bank_real_balances()`
- `calculate_bank_composition()`

---

### File: `services\balance\user_balance_service.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_all_users_balance_breakdown()`
- `get_user_balance_breakdown()`

---

## Folder: `services\core`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak terlalu besar.

### File: `services\core\auth_service.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_internal_login()`

---

### File: `services\core\email_service.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `init_mail()`
- `generate_otp()`
- `send_reset_password_otp()`

---

### File: `services\core\notification_events.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
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
- `notify_user_returned()`
- `notify_revenue_created()`
- `notify_revenue_updated()`
- `notify_revenue_deleted()`
- `notify_tax_created()`
- `notify_tax_updated()`
- `notify_tax_deleted()`
- `notify_bank_created()`
- `notify_bank_transaction_created()`
- `notify_asset_created()`
- `notify_asset_updated()`
- `notify_asset_deleted()`
- `_can_access_notification()`

---

### File: `services\core\settings_service.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_normalize_deadline_rule_key()`
- `_find_deadline_setting()`
- `_sanitize_deadline_days()`

---

### File: `services\core\storage_service.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `allowed_file()`
- `handle_profile_image_upload()`
- `handle_profile_image_removal()`

---

## Folder: `services\dto`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak terlalu besar.

### File: `services\dto\transaction_dto.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Classes Terdeteksi:**
- `TransactionDTO`

---

## Folder: `services\master_data`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak terlalu besar.

### File: `services\master_data\tax_service.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_validate_manual_tax_group()`

---

## Folder: `services\reports\annual_service`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak terlalu besar.

### File: `services\reports\annual_service\annual_constants.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

---

### File: `services\reports\annual_service\annual_data.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

---

### File: `services\reports\annual_service\annual_excel.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.

**Fungsi Utama (Metode/Endpoint):**
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

---

### File: `services\reports\annual_service\annual_helpers.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_extract_subcategory_from_description()`
- `_root_category_info()`
- `_subcategory_sort_key()`
- `_clear_merged_ranges_in_region()`
- `_write_dynamic_category_headers()`
- `_set_dividend_row_border()`
- `_compute_dividend_distribution_v2()`

---

### File: `services\reports\annual_service\annual_tables.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

---

### File: `services\reports\annual_service\caching.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_is_true()`
- `_annual_cache_paths()`
- `_load_annual_payload_cache()`
- `_save_annual_payload_cache()`
- `_save_annual_pdf_cache()`
- `clear_annual_report_cache()`

---

### File: `services\reports\annual_service\excel_generator.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.

**Fungsi Utama (Metode/Endpoint):**
- `get_annual_report_excel()`

---

## Folder: `services\reports\data_fetcher`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak terlalu besar.

### File: `services\reports\data_fetcher\db_fetchers.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_tagged_ids_for_year()`
- `_has_any_report_tags()`
- `_fetch_revenue_data()`
- `_fetch_expense_data()`
- `_fetch_asset_data()`
- `_fetch_bank_transaction_data()`
- `_fetch_tax_data()`
- `_fetch_advance_items_data()`
- `_fetch_dividend_data()`

---

### File: `services\reports\data_fetcher\depreciation.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_calculate_asset_depreciation()`

---

### File: `services\reports\data_fetcher\payload_builder.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.

**Fungsi Utama (Metode/Endpoint):**
- `_compute_dividend_distribution()`
- `_build_annual_payload_from_db()`

---

## Folder: `services\reports\summary_service`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak terlalu besar.

### File: `services\reports\summary_service\data_helpers.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_validate_date()`
- `_display_settlement_status()`
- `_get_summary_approved_expenses()`
- `_expense_amount_for_summary()`
- `_get_display_subcategory()`
- `_summary_display_category()`
- `_build_summary_payload()`

---

### File: `services\reports\summary_service\excel_generator.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `generate_excel_report()`
- `generate_excel_advance_report()`

---

### File: `services\reports\summary_service\pdf_generator.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `generate_pdf_advance_report()`
- `generate_settlement_receipt()`
- `generate_bulk_settlements_pdf()`
- `generate_bulk_advances_pdf()`

---

## Folder: `services\reports\table_builder`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak terlalu besar.

### File: `services\reports\table_builder\expense_renderer.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `_render_expense_section_from_data()`

---

### File: `services\reports\table_builder\expense_renderer_utils.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_expense_column_mapping_name()`
- `_expense_amount_for_display()`
- `_expense_subcategory_label()`
- `_group_expenses_by_subcategory()`

---

### File: `services\reports\table_builder\pdf_builder.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.

**Fungsi Utama (Metode/Endpoint):**
- `_build_annual_pdf_bytes()`

---

### File: `services\reports\table_builder\revenue_helpers.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_manual_combine_groups_by_table()`
- `_manual_combine_groups_by_rows()`
- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_operation_cost_totals_by_column()`
- `_get_revenue_bounds()`
- `_group_revenues_by_type()`
- `_validate_revenue_data()`

---

## Folder: `services\settlements`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak terlalu besar.

### File: `services\settlements\settlement_approval_service.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `_calculate_settlement_per_bank_netting()`
- `process_submit_settlement()`
- `process_approve_settlement()`
- `process_complete_settlement()`
- `process_reject_all_expenses()`
- `process_final_approve_settlement()`

---

## Folder: `services\transactions`

**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak terlalu besar.

### File: `services\transactions\dividend_service.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_fetch_revenues_and_expenses_for_year()`
- `_build_dividend_payload()`

---

### File: `services\transactions\revenue_service.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_validate_manual_revenue_group()`

---

## Folder: `utils`

**Tujuan Folder:** Menyimpan fungsi utilitas umum (formatting, perhitungan, auth helpers).

### File: `utils\auth_helper.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_req_company()`
- `_require_manager()`
- `current_user()`

---

### File: `utils\constants.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Classes Terdeteksi:**
- `Status`
- `RevenueType`
- `UserRole`

---

### File: `utils\deadline_worker.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_normalize_rule_key()`
- `check_and_create_deadline_notifications()`
- `_cleanup_stale_deadline_notifications()`
- `_create_deadline_notification_if_missing()`

---

### File: `utils\parsing_helper.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
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

---

### File: `utils\report_helpers.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
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
- `_map_expense_category_index()`
- `_map_expense_category_index_from_name()`
- `_pick_template_formula_col()`
- `_write_expense_line()`
- `_write_expense_detail_line()`
- `_get_expense_blocks()`
- `_parse_iso_date()`
- `_parse_to_date_obj()`
- `_format_date_dd_mmm_yy()`
- `_to_float()`
- `_set_formula_with_format()`
- `_set_date_with_format()`
- `_as_iso_date()`
- `_idr_from_currency()`
- `_shorten()`
- `_map_expense_column()`
- `_extract_batch_number()`
- `_is_batch_settlement()`
- `_clean_currency()`
- `_clean_settlement_title()`
- `_extract_note_subcategory()`
- `_expense_subcategory_label()`
- `_group_annual_expenses()`

---

### File: `utils\storage.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `delete_evidence_file()`

---

### File: `utils\transaction_templates.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Classes Terdeteksi:**
- `TxTemplates`

---

### File: `utils\workflow_helper.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `log_workflow()`
- `update_document_stage()`

---

