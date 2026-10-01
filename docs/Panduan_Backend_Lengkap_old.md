# Panduan Lengkap Backend (MiniProjectKPI_EWI_Revisi2)

Dokumen ini digenerate secara menyeluruh untuk merinci struktur, peran, dependensi, fungsi, dan isi dari setiap file Python di dalam folder `backend`.
Ditujukan agar developer baru atau AI (LLM) dapat memahami aplikasi backend (Flask/FastAPI/lainnya) tanpa harus membaca source code satu per satu.

## Folder: `Root (backend)`

### File: `advances.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

---

### File: `advances_approval.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `start_revision()`
- `submit_advance()`
- `approve_advance()`
- `reject_advance()`
- `approve_advance_item()`
- `reject_advance_item()`
- `final_approve_advance()`

---

### File: `advances_crud.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

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

### File: `advances_disbursement.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `save_disbursement()`
- `save_return()`
- `approve_disbursement()`
- `submit_return()`
- `approve_return()`
- `reject_return()`
- `update_return_notes()`

---

### File: `advances_items.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `add_advance_item()`
- `update_advance_item()`
- `delete_advance_item()`
- `bulk_delete_advance_items()`
- `update_advance_items_bulk()`

---

### File: `advances_other.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

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

### File: `advances_utils.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi (baik internal maupun eksternal).

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

### File: `assets.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

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

### File: `auth.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `init_mail()`
- `generate_otp()`
- `forgot_password()`
- `reset_password()`
- `google_login()`
- `login()`
- `_internal_login()`
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

### File: `bank_management.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

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

### File: `bank_status.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `list_all_banks_for_status()`
- `list_status_transactions()`
- `create_status_transaction()`
- `update_status_transaction()`
- `delete_status_transaction()`

---

### File: `categories.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `clear_annual_report_cache()`
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

### File: `cleanup.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_require_manager()`
- `cleanup_preview()`
- `cleanup_execute()`

---

### File: `common_utils.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_req_company()`
- `allowed_file()`
- `_parse_checklist_notes()`
- `_has_unchecked_checklist()`
- `_has_unchecked_return_checklist()`
- `_merge_rejection_notes()`
- `_parse_date()`
- `_parse_number_value()`

---

### File: `companies.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `current_user()`
- `get_companies()`
- `create_company()`
- `update_company()`
- `delete_company()`
- `reorder_companies()`

---

### File: `dashboard.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_summary()`

---

### File: `dividends.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_fetch_revenues_and_expenses_for_year()`
- `_build_dividend_payload()`
- `get_dividends()`
- `get_dividend()`
- `create_dividend()`
- `update_dividend()`
- `update_dividend_setting()`
- `delete_dividend()`

---

### File: `expenses.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `_parse_category_ids()`
- `create_expense()`
- `update_expense()`
- `bulk_delete_expenses()`
- `delete_expense()`
- `approve_expense()`
- `reject_expense()`
- `serve_evidence()`
- `list_categories()`

---

### File: `notifications.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_notifications()`
- `_can_access_notification()`
- `mark_notification_as_read()`
- `mark_all_notifications_as_read()`
- `delete_notification()`
- `get_unread_count()`
- `create_notification()`
- `notify_managers()`
- `notify_staff()`

---

### File: `revenues.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `_validate_manual_revenue_group()`
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

### File: `settings.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `_require_manager()`
- `_normalize_deadline_rule_key()`
- `_find_deadline_setting()`
- `_sanitize_deadline_days()`
- `get_companies()`
- `manage_storage()`
- `manage_report_year()`
- `export_database()`
- `import_database_preview()`
- `import_database_confirm()`
- `manage_deadline_settings()`

---

### File: `settlements.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

---

### File: `settlements_approval.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `submit_settlement()`
- `approve_settlement()`
- `complete_settlement()`
- `reject_all_expenses()`
- `final_approve_settlement()`

---

### File: `settlements_crud.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi (baik internal maupun eksternal).

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

### File: `settlements_disbursement.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `save_disbursement()`
- `save_return()`
- `approve_disbursement()`
- `submit_return()`
- `approve_return()`
- `reject_return()`
- `update_return_notes()`
- `standalone_return()`

---

### File: `settlements_expenses.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `update_expense()`

---

### File: `settlements_other.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `override_settlement()`
- `move_to_draft()`

---

### File: `settlements_utils.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_sync_advance_after_settlement()`

---

### File: `taxes.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_validate_manual_tax_group()`
- `get_taxes()`
- `get_tax()`
- `create_tax()`
- `update_tax()`
- `delete_tax()`
- `get_tax_combine_groups()`
- `create_tax_combine_group()`
- `delete_tax_combine_group()`

---

## Folder: `reports`

### File: `reports\annual.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.

**Fungsi Utama (Metode/Endpoint):**
- `_is_true()`
- `_annual_cache_paths()`
- `_load_annual_payload_cache()`
- `_save_annual_payload_cache()`
- `_save_annual_pdf_cache()`
- `get_annual_report()`
- `get_annual_report_pdf()`
- `get_annual_report_excel()`

---

### File: `reports\annual_constants.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman.

---

### File: `reports\annual_data.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.

**Fungsi Utama (Metode/Endpoint):**
- `_tagged_ids_for_year()`
- `_has_any_report_tags()`
- `_compute_dividend_distribution()`
- `_fetch_revenue_data()`
- `_fetch_expense_data()`
- `_fetch_asset_data()`
- `_fetch_bank_transaction_data()`
- `_fetch_tax_data()`
- `_fetch_advance_items_data()`
- `_fetch_dividend_data()`
- `_calculate_asset_depreciation()`
- `_build_annual_payload_from_db()`

---

### File: `reports\annual_excel.py`

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

### File: `reports\annual_helpers.py`

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

### File: `reports\annual_tables.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.

**Fungsi Utama (Metode/Endpoint):**
- `_build_annual_pdf_bytes()`
- `_expense_column_mapping_name()`
- `_expense_amount_for_display()`
- `_expense_subcategory_label()`
- `_group_expenses_by_subcategory()`
- `_render_expense_section_from_data()`
- `_manual_combine_groups_by_table()`
- `_manual_combine_groups_by_rows()`
- `_apply_manual_revenue_combine_groups()`
- `_apply_manual_tax_combine_groups()`
- `_operation_cost_totals_by_column()`
- `_get_revenue_bounds()`
- `_group_revenues_by_type()`
- `_validate_revenue_data()`

---

### File: `reports\helpers.py`

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

### File: `reports\summary.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.

**Fungsi Utama (Metode/Endpoint):**
- `_validate_date()`
- `_display_settlement_status()`
- `_get_summary_approved_expenses()`
- `_expense_amount_for_summary()`
- `_get_display_subcategory()`
- `_summary_display_category()`
- `_build_summary_payload()`
- `get_summary_report()`
- `export_summary_pdf()`
- `generate_excel_report()`
- `generate_excel_advance_report()`
- `generate_pdf_advance_report()`
- `generate_settlement_receipt()`
- `generate_bulk_settlements_pdf()`
- `generate_bulk_advances_pdf()`

---

## Folder: `scratch/scanner_fokus/scripts`

### File: `scratch/scanner_fokus/scripts/generate_hybrid_migration_v14.py`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.

**Fungsi Utama (Metode/Endpoint):**
- `load_old_evidence_data()`
- `normalize_match_text()`
- `normalize_match_date()`
- `evidence_file_exists()`
- `match_evidence_fuzzy()`
- `get_cell_effective_value()`
- `get_merge_range()`
- `find_column_index()`
- `is_numeric_value()`
- `to_num_cell()`
- `to_sql_val()`
- `detect_cat()`
- `map_bank_source()`
- `detect_subheader()`
- `detect_master_year()`
- `_is_anchor_cell()`
- `_is_bank_source_cell()`
- `_is_subcategory_cell()`
- `is_divider_row()`
- `is_bank_header_row()`
- `find_table_range()`
- `_pick_sheet_by_spec()`
- `_pick_sheet_auto()`
- `list_excel_sheets()`
- `scan_sheet_analysis()`
- `preview_sheet()`
- `migrate()`
- `get_companies_from_db()`
- `run_interactive()`
- `main()`

---

