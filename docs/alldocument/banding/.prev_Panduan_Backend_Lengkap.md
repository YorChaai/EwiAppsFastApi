# Panduan Lengkap Backend (MiniProjectKPI_EWI_Revisi2)

Dokumen ini digenerate secara menyeluruh untuk merinci struktur, peran, dependensi, fungsi, dan isi dari setiap file Python di dalam folder backend.
Ditujukan agar developer baru atau AI (LLM) dapat memahami aplikasi backend tanpa harus membaca source code satu per satu.

## Folder: `Root (backend)`

**Tujuan Folder:** File inti atau modul pendukung backend.

### File: `app.py` (309 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `create_app()`
- `run_database_integrity_maintenance()`
- `seed_data()`

---

### File: `config.py` (50 baris)
- Perubahan pada file ini tergolong aman.

**Classes Terdeteksi:**
- `Config`

---

## Folder: `migrations`

**Tujuan Folder:** File inti atau modul pendukung backend.

### File: `migrations/env.py` (94 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_engine()`
- `get_engine_url()`
- `get_metadata()`
- `run_migrations_offline()`
- `run_migrations_online()`

---

## Folder: `migrations/versions`

**Tujuan Folder:** File inti atau modul pendukung backend.

### File: `migrations/versions/001_add_deadline_settings.py` (36 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `upgrade()`
- `downgrade()`

---

### File: `migrations/versions/15a2b38c373b_merge_heads.py` (23 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `upgrade()`
- `downgrade()`

---

### File: `migrations/versions/1c018e4753ce_add_to_bank_id_to_bank_transactions.py` (75 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `upgrade()`
- `downgrade()`

---

### File: `migrations/versions/35b95195d8d7_add_disbursement_source_id.py` (360 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `upgrade()`
- `downgrade()`

---

### File: `migrations/versions/3d3231c4f746_add_document_date.py` (223 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `upgrade()`
- `downgrade()`

---

### File: `migrations/versions/574e15ccd7bd_add_phone_and_workplace_to_users.py` (35 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `upgrade()`
- `downgrade()`

---

### File: `migrations/versions/72e16ee21ce9_add_user_id_to_bank_accounts.py` (35 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `upgrade()`
- `downgrade()`

---

### File: `migrations/versions/83c44ae4ff0d_add_base_transaction_fields_to_taxes.py` (79 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `upgrade()`
- `downgrade()`

---

### File: `migrations/versions/8c098dccca32_add_indexes_to_foreign_keys_and_search_.py` (60 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `upgrade()`
- `downgrade()`

---

### File: `migrations/versions/9b7c1f2d4a55_add_disbursement_comment_and_return_description.py` (37 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `upgrade()`
- `downgrade()`

---

### File: `migrations/versions/a7e218c38417_tambah_tabel_asosiasi_multi_kategori.py` (61 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `upgrade()`
- `downgrade()`

---

### File: `migrations/versions/ae69a3c66bb1_add_admin_fee_to_advance_and_settlement_.py` (51 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `upgrade()`
- `downgrade()`

---

### File: `migrations/versions/b766974919d9_add_main_group_to_categories.py` (33 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `upgrade()`
- `downgrade()`

---

### File: `migrations/versions/bb15b3243686_add_workflow_logs_and_stage_tracking.py` (479 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `upgrade()`
- `downgrade()`

---

### File: `migrations/versions/c1f7f67b9a12_add_date_indexes_for_report_queries.py` (44 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `upgrade()`
- `downgrade()`

---

### File: `migrations/versions/d253b8fd9fdc_add_bank_and_asset_tables.py` (69 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `upgrade()`
- `downgrade()`

---

### File: `migrations/versions/ebb645d74247_add_merged_columns_and_original_data_to_.py` (213 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `upgrade()`
- `downgrade()`

---

### File: `migrations/versions/f4b9c2d7e8a1_add_disbursement_and_return_sources.py` (46 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `upgrade()`
- `downgrade()`

---

## Folder: `models`

**Tujuan Folder:** Menyimpan Blueprint Database / SQLAlchemy Models.

### File: `models/banking.py` (149 baris)
- Perubahan pada file ini tergolong aman.

**Classes Terdeteksi:**
- `BankAccount`
- `BankTransaction`
- `BankStatusTransaction`

---

### File: `models/base.py` (17 baris)
- Perubahan pada file ini tergolong aman.

---

### File: `models/core.py` (191 baris)
- Perubahan pada file ini tergolong aman.

**Classes Terdeteksi:**
- `Company`
- `User`
- `CategoryGroup`
- `Category`

---

### File: `models/system.py` (159 baris)
- Perubahan pada file ini tergolong aman.

**Classes Terdeteksi:**
- `Notification`
- `DeadlineSetting`
- `WorkflowLog`
- `OverrideLog`

---

### File: `models/transaction.py` (623 baris)
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

## Folder: `routes/advances`

**Tujuan Folder:** Menyimpan API Endpoints / Blueprints yang dapat diakses oleh client / frontend.

### File: `routes/advances/advances.py` (12 baris)
- Perubahan pada file ini tergolong aman.

---

### File: `routes/advances/advances_approval.py` (63 baris)
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

### File: `routes/advances/advances_crud.py` (323 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `list_advances()`
- `create_advance()`
- `get_advance()`
- `update_advance()`
- `delete_advance()`
- `get_advance_history()`

---

### File: `routes/advances/advances_disbursement.py` (405 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `save_disbursement()`
- `save_return()`
- `approve_disbursement()`

---

### File: `routes/advances/advances_items.py` (55 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `add_advance_item()`
- `update_advance_item()`
- `delete_advance_item()`
- `bulk_delete_advance_items()`
- `update_advance_items_bulk()`

---

### File: `routes/advances/advances_other.py` (596 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `override_advance()`
- `move_advance_to_draft()`
- `initialize_balance()`
- `get_override_logs_list()`
- `get_user_balances()`

---

## Folder: `routes/core`

**Tujuan Folder:** Menyimpan API Endpoints / Blueprints yang dapat diakses oleh client / frontend.

### File: `routes/core/auth.py` (560 baris)
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

### File: `routes/core/cleanup.py` (220 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `cleanup_preview()`
- `cleanup_execute()`

---

### File: `routes/core/dashboard.py` (80 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_summary()`

---

### File: `routes/core/notifications.py` (170 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_notifications()`
- `mark_notification_as_read()`
- `mark_all_notifications_as_read()`
- `delete_notification()`
- `get_unread_count()`

---

## Folder: `routes/master_data`

**Tujuan Folder:** Menyimpan API Endpoints / Blueprints yang dapat diakses oleh client / frontend.

### File: `routes/master_data/bank_management.py` (383 baris)
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

### File: `routes/master_data/bank_status.py` (169 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `list_all_banks_for_status()`
- `list_status_transactions()`
- `create_status_transaction()`
- `update_status_transaction()`
- `delete_status_transaction()`

---

### File: `routes/master_data/categories.py` (462 baris)
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

### File: `routes/master_data/companies.py` (119 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_companies()`
- `create_company()`
- `update_company()`
- `delete_company()`
- `reorder_companies()`

---

### File: `routes/master_data/taxes.py` (358 baris)
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

## Folder: `routes/reports`

**Tujuan Folder:** Menyimpan API Endpoints / Blueprints yang dapat diakses oleh client / frontend.

### File: `routes/reports/annual.py` (99 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_default_report_year()`
- `get_annual_report()`
- `get_annual_report_pdf()`
- `export_annual_report_excel()`

---

### File: `routes/reports/annual_constants.py` (49 baris)
- Perubahan pada file ini tergolong aman.

---

### File: `routes/reports/annual_data.py` (36 baris)
- Perubahan pada file ini tergolong aman.

---

### File: `routes/reports/annual_excel.py` (1446 baris)
- **Peringatan (God Object / Overly Long):** File ini sangat besar (>1000 baris). Rentan menimbulkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.

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

### File: `routes/reports/annual_helpers.py` (295 baris)
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

### File: `routes/reports/annual_tables.py` (83 baris)
- Perubahan pada file ini tergolong aman.

---

### File: `routes/reports/summary.py` (281 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_summary_report()`
- `export_summary_pdf()`

---

## Folder: `routes/settings`

**Tujuan Folder:** Menyimpan API Endpoints / Blueprints yang dapat diakses oleh client / frontend.

### File: `routes/settings/db_storage.py` (575 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `manage_storage()`
- `export_database()`
- `import_database_preview()`
- `import_database_confirm()`

---

### File: `routes/settings/deadline.py` (174 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `manage_deadline_settings()`

---

### File: `routes/settings/profile.py` (100 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_companies()`
- `manage_report_year()`

---

## Folder: `routes/settlements`

**Tujuan Folder:** Menyimpan API Endpoints / Blueprints yang dapat diakses oleh client / frontend.

### File: `routes/settlements/settlements.py` (11 baris)
- Perubahan pada file ini tergolong aman.

---

### File: `routes/settlements/settlements_approval.py` (37 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `submit_settlement()`
- `approve_settlement()`
- `complete_settlement()`
- `reject_all_expenses()`
- `final_approve_settlement()`

---

### File: `routes/settlements/settlements_crud.py` (390 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `list_settlements()`
- `create_settlement()`
- `get_settlement()`
- `update_settlement()`
- `delete_settlement()`
- `get_settlement_history()`

---

### File: `routes/settlements/settlements_disbursement.py` (544 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `save_disbursement()`
- `save_return()`
- `approve_disbursement()`
- `standalone_return()`

---

### File: `routes/settlements/settlements_expenses.py` (140 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `update_expense()`

---

### File: `routes/settlements/settlements_other.py` (93 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `override_settlement()`
- `move_to_draft()`

---

## Folder: `routes/transactions`

**Tujuan Folder:** Menyimpan API Endpoints / Blueprints yang dapat diakses oleh client / frontend.

### File: `routes/transactions/assets.py` (128 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `list_assets()`
- `create_asset()`
- `update_asset()`
- `delete_asset()`

---

### File: `routes/transactions/dividends.py` (179 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_dividends()`
- `get_dividend()`
- `create_dividend()`
- `update_dividend()`
- `update_dividend_setting()`
- `delete_dividend()`

---

### File: `routes/transactions/expenses.py` (557 baris)
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

### File: `routes/transactions/revenues.py` (513 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
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

---

## Folder: `scripts`

**Tujuan Folder:** Script CLI bantuan / utilitas perbaikan data dan otomatisasi.

### File: `scripts/auto_generate_and_compare_docs.py` (162 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `run_generators()`
- `parse_sections()`
- `compare_sections()`
- `build_diff_report()`
- `main()`

---

### File: `scripts/backup_db.py` (76 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `do_backup()`

---

### File: `scripts/generate_backend_docs.py` (129 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `parse_python_file()`

---

### File: `scripts/generate_frontend_docs.py` (149 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `parse_dart_file()`

---

### File: `scripts/generate_hybrid_migration_v14.py` (4698 baris)
- **Peringatan (God Object / Overly Long):** File ini sangat besar (>1000 baris). Rentan menimbulkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.

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

### File: `scripts/inspect_dashboard.py` (11 baris)
- Perubahan pada file ini tergolong aman.

---

### File: `scripts/run_all_docs.py` (209 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `run()`
- `generate_index()`
- `main()`

---

### File: `scripts/sync_checklist_md.py` (35 baris)
- Perubahan pada file ini tergolong aman.

---

### File: `scripts/update_test_matrix_steps.py` (364 baris)
- Perubahan pada file ini tergolong aman.

---

## Folder: `scripts/graphify_docs`

**Tujuan Folder:** Script CLI bantuan / utilitas perbaikan data dan otomatisasi.

### File: `scripts/graphify_docs/auto_graphify_docs.py` (206 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `run_generators()`
- `parse_sections()`
- `compare_sections()`
- `build_diff_section()`
- `cleanup_old_reports()`
- `main()`

---

### File: `scripts/graphify_docs/generate_backend_graphify.py` (265 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `should_exclude()`
- `file_key()`
- `folder_role()`
- `file_role()`
- `risk_badge()`
- `main()`

---

### File: `scripts/graphify_docs/generate_frontend_graphify.py` (237 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `should_exclude()`
- `folder_role()`
- `file_role()`
- `main()`

---

## Folder: `scripts/s`

**Tujuan Folder:** Script CLI bantuan / utilitas perbaikan data dan otomatisasi.

### File: `scripts/s/auto_generate_and_compare_docs.py` (162 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `run_generators()`
- `parse_sections()`
- `compare_sections()`
- `build_diff_report()`
- `main()`

---

### File: `scripts/s/generate_backend_docs.py` (129 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `parse_python_file()`

---

### File: `scripts/s/generate_frontend_docs.py` (149 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `parse_dart_file()`

---

## Folder: `services/advances`

**Tujuan Folder:** Menyimpan Business Logic terpisah dari Route handler.

### File: `services/advances/advance_approval_service.py` (731 baris)
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

### File: `services/advances/advance_items_service.py` (625 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Classes Terdeteksi:**
- `AdvanceItemsService`

---

## Folder: `services/approvals`

**Tujuan Folder:** Menyimpan Business Logic terpisah dari Route handler.

### File: `services/approvals/advance_helpers.py` (106 baris)
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

### File: `services/approvals/settlement_helpers.py` (168 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_sync_advance_after_settlement()`
- `rollback_settlement_transactions()`

---

## Folder: `services/balance`

**Tujuan Folder:** Menyimpan Business Logic terpisah dari Route handler.

### File: `services/balance/balance_service.py` (411 baris)
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

### File: `services/balance/user_balance_service.py` (237 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `get_all_users_balance_breakdown()`
- `get_user_balance_breakdown()`

---

## Folder: `services/core`

**Tujuan Folder:** Menyimpan Business Logic terpisah dari Route handler.

### File: `services/core/auth_service.py` (50 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_internal_login()`

---

### File: `services/core/email_service.py` (31 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `init_mail()`
- `generate_otp()`
- `send_reset_password_otp()`

---

### File: `services/core/notification_events.py` (350 baris)
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

### File: `services/core/settings_service.py` (40 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_normalize_deadline_rule_key()`
- `_find_deadline_setting()`
- `_sanitize_deadline_days()`

---

### File: `services/core/storage_service.py` (54 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `allowed_file()`
- `handle_profile_image_upload()`
- `handle_profile_image_removal()`

---

## Folder: `services/dto`

**Tujuan Folder:** Menyimpan Business Logic terpisah dari Route handler.

### File: `services/dto/transaction_dto.py` (408 baris)
- Perubahan pada file ini tergolong aman.

**Classes Terdeteksi:**
- `TransactionDTO`

---

## Folder: `services/master_data`

**Tujuan Folder:** Menyimpan Business Logic terpisah dari Route handler.

### File: `services/master_data/tax_service.py` (72 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_validate_manual_tax_group()`

---

## Folder: `services/reports/annual_service`

**Tujuan Folder:** Menyimpan Business Logic terpisah dari Route handler.

### File: `services/reports/annual_service/annual_constants.py` (49 baris)
- Perubahan pada file ini tergolong aman.

---

### File: `services/reports/annual_service/annual_data.py` (36 baris)
- Perubahan pada file ini tergolong aman.

---

### File: `services/reports/annual_service/annual_excel.py` (1446 baris)
- **Peringatan (God Object / Overly Long):** File ini sangat besar (>1000 baris). Rentan menimbulkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.

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

### File: `services/reports/annual_service/annual_helpers.py` (295 baris)
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

### File: `services/reports/annual_service/annual_tables.py` (83 baris)
- Perubahan pada file ini tergolong aman.

---

### File: `services/reports/annual_service/caching.py` (163 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_is_true()`
- `_annual_cache_paths()`
- `_load_annual_payload_cache()`
- `_save_annual_payload_cache()`
- `_save_annual_pdf_cache()`
- `clear_annual_report_cache()`

---

### File: `services/reports/annual_service/excel_generator.py` (1488 baris)
- **Peringatan (God Object / Overly Long):** File ini sangat besar (>1000 baris). Rentan menimbulkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.

**Fungsi Utama (Metode/Endpoint):**
- `get_annual_report_excel()`

---

## Folder: `services/reports/data_fetcher`

**Tujuan Folder:** Menyimpan Business Logic terpisah dari Route handler.

### File: `services/reports/data_fetcher/db_fetchers.py` (309 baris)
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

### File: `services/reports/data_fetcher/depreciation.py` (151 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_calculate_asset_depreciation()`

---

### File: `services/reports/data_fetcher/payload_builder.py` (1191 baris)
- **Peringatan (God Object / Overly Long):** File ini sangat besar (>1000 baris). Rentan menimbulkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.

**Fungsi Utama (Metode/Endpoint):**
- `_compute_dividend_distribution()`
- `_build_annual_payload_from_db()`

---

## Folder: `services/reports/summary_service`

**Tujuan Folder:** Menyimpan Business Logic terpisah dari Route handler.

### File: `services/reports/summary_service/data_helpers.py` (309 baris)
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

### File: `services/reports/summary_service/excel_generator.py` (275 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `generate_excel_report()`
- `generate_excel_advance_report()`

---

### File: `services/reports/summary_service/pdf_generator.py` (313 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `generate_pdf_advance_report()`
- `generate_settlement_receipt()`
- `generate_bulk_settlements_pdf()`
- `generate_bulk_advances_pdf()`

---

## Folder: `services/reports/table_builder`

**Tujuan Folder:** Menyimpan Business Logic terpisah dari Route handler.

### File: `services/reports/table_builder/expense_renderer.py` (684 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `_render_expense_section_from_data()`

---

### File: `services/reports/table_builder/expense_renderer_utils.py` (166 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_expense_column_mapping_name()`
- `_expense_amount_for_display()`
- `_expense_subcategory_label()`
- `_group_expenses_by_subcategory()`

---

### File: `services/reports/table_builder/pdf_builder.py` (1072 baris)
- **Peringatan (God Object / Overly Long):** File ini sangat besar (>1000 baris). Rentan menimbulkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.

**Fungsi Utama (Metode/Endpoint):**
- `_build_annual_pdf_bytes()`

---

### File: `services/reports/table_builder/revenue_helpers.py` (387 baris)
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

## Folder: `services/settlements`

**Tujuan Folder:** Menyimpan Business Logic terpisah dari Route handler.

### File: `services/settlements/settlement_approval_service.py` (834 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.

**Fungsi Utama (Metode/Endpoint):**
- `_calculate_settlement_per_bank_netting()`
- `process_submit_settlement()`
- `process_approve_settlement()`
- `process_complete_settlement()`
- `process_reject_all_expenses()`
- `process_final_approve_settlement()`

---

## Folder: `services/transactions`

**Tujuan Folder:** Menyimpan Business Logic terpisah dari Route handler.

### File: `services/transactions/dividend_service.py` (100 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_fetch_revenues_and_expenses_for_year()`
- `_build_dividend_payload()`

---

### File: `services/transactions/revenue_service.py` (81 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_validate_manual_revenue_group()`

---

## Folder: `tests`

**Tujuan Folder:** File inti atau modul pendukung backend.

### File: `tests/test_annual_report_routes.py` (59 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `app()`
- `client()`
- `test_excel_generator_logger_and_function_exist()`
- `test_annual_routes_registered()`
- `test_annual_excel_requires_auth()`
- `test_annual_pdf_requires_auth()`
- `test_annual_json_requires_auth()`

---

### File: `tests/test_blueprint_routes.py` (75 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `app()`
- `client()`
- `test_all_blueprints_registered()`
- `test_reports_endpoints_methods()`
- `test_auth_login_endpoint()`

---

### File: `tests/test_code_hygiene_fixes.py` (64 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `test_summary_excel_generator_logger()`
- `test_transaction_dto_keys_not_duplicated()`

---

### File: `tests/test_revenue_bank_sync.py` (251 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `app()`
- `test_revenue_model_has_bank_relationship()`
- `test_bank_transaction_has_revenue_relationship()`
- `test_revenue_to_dict_includes_bank_info()`
- `test_sync_revenue_bank_transaction_creates_and_updates_and_deletes()`
- `test_revenue_and_bank_transaction_tracks_creator()`

---

## Folder: `utils`

**Tujuan Folder:** File inti atau modul pendukung backend.

### File: `utils/auth_helper.py` (21 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_req_company()`
- `_require_manager()`
- `current_user()`

---

### File: `utils/constants.py` (26 baris)
- Perubahan pada file ini tergolong aman.

**Classes Terdeteksi:**
- `Status`
- `RevenueType`
- `UserRole`

---

### File: `utils/deadline_worker.py` (277 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `_normalize_rule_key()`
- `check_and_create_deadline_notifications()`
- `_cleanup_stale_deadline_notifications()`
- `_create_deadline_notification_if_missing()`

---

### File: `utils/parsing_helper.py` (190 baris)
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

### File: `utils/report_helpers.py` (876 baris)
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

### File: `utils/storage.py` (26 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `delete_evidence_file()`

---

### File: `utils/transaction_templates.py` (60 baris)
- Perubahan pada file ini tergolong aman.

**Classes Terdeteksi:**
- `TxTemplates`

---

### File: `utils/workflow_helper.py` (64 baris)
- Perubahan pada file ini tergolong aman.

**Fungsi Utama (Metode/Endpoint):**
- `log_workflow()`
- `update_document_stage()`

---

