# Laporan Perubahan Dokumentasi
**Tanggal Generate:** 2026-09-05 16:59:00

Laporan ini mendeteksi perubahan struktur kode (file ditambahkan, dihapus, atau dimodifikasi) yang berdampak pada dokumentasi.

---

## Perubahan Backend
### 🆕 File Baru / Dokumentasi Ditambahkan
- `advances\advances.py`
- `advances\advances_approval.py`
- `advances\advances_crud.py`
- `advances\advances_disbursement.py`
- `advances\advances_items.py`
- `advances\advances_other.py`
- `core\auth.py`
- `core\cleanup.py`
- `core\dashboard.py`
- `core\notifications.py`
- `master_data\bank_management.py`
- `master_data\bank_status.py`
- `master_data\categories.py`
- `master_data\companies.py`
- `master_data\taxes.py`
- `settings\db_storage.py`
- `settings\deadline.py`
- `settings\profile.py`
- `settlements\settlements.py`
- `settlements\settlements_approval.py`
- `settlements\settlements_crud.py`
- `settlements\settlements_disbursement.py`
- `settlements\settlements_expenses.py`
- `settlements\settlements_other.py`
- `transactions\assets.py`
- `transactions\dividends.py`
- `transactions\expenses.py`
- `transactions\revenues.py`

### ❌ File Dihapus / Dokumentasi Dihapus
- `advances.py`
- `advances_approval.py`
- `advances_crud.py`
- `advances_disbursement.py`
- `advances_items.py`
- `advances_other.py`
- `advances_utils.py`
- `assets.py`
- `auth.py`
- `bank_management.py`
- `bank_status.py`
- `categories.py`
- `cleanup.py`
- `common_utils.py`
- `companies.py`
- `dashboard.py`
- `dividends.py`
- `expenses.py`
- `notifications.py`
- `reports\annual backup.py`
- `reports\annual copy1.py`
- `reports\annualcopy.py`
- `reports\helpers.py`
- `revenues.py`
- `scratch/scanner_fokus/scripts/generate_hybrid_migration_v14.py`
- `settings.py`
- `settlements.py`
- `settlements_approval.py`
- `settlements_crud.py`
- `settlements_disbursement.py`
- `settlements_expenses.py`
- `settlements_other.py`
- `settlements_utils.py`
- `taxes.py`

### 📝 Dokumentasi Diedit
#### Perubahan pada: `reports\annual.py`
```diff
@@ -3,18 +3,13 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 3 dependensi (baik internal maupun eksternal).
+- **Dependencies (Menggunakan):** Meng-import 5 dependensi (baik internal maupun eksternal).
 
 **Hal Penting & Risiko:**
-- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.
+- Perubahan pada file ini tergolong aman.
 
 **Fungsi Utama (Metode/Endpoint):**
-- `_is_true()`
-- `_annual_cache_paths()`
-- `_load_annual_payload_cache()`
-- `_save_annual_payload_cache()`
-- `_save_annual_pdf_cache()`
+- `_default_report_year()`
 - `get_annual_report()`
 - `get_annual_report_pdf()`
-- `get_annual_report_excel()`
 
 ---
```

#### Perubahan pada: `reports\annual_data.py`
```diff
@@ -3,22 +3,8 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi (baik internal maupun eksternal).
 
 **Hal Penting & Risiko:**
-- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.
-
-**Fungsi Utama (Metode/Endpoint):**
-- `_tagged_ids_for_year()`
-- `_has_any_report_tags()`
-- `_compute_dividend_distribution()`
-- `_fetch_revenue_data()`
-- `_fetch_expense_data()`
-- `_fetch_asset_data()`
-- `_fetch_bank_transaction_data()`
-- `_fetch_tax_data()`
-- `_fetch_advance_items_data()`
-- `_fetch_dividend_data()`
-- `_calculate_asset_depreciation()`
-- `_build_annual_payload_from_db()`
+- Perubahan pada file ini tergolong aman.
 
 ---
```

#### Perubahan pada: `reports\annual_tables.py`
```diff
@@ -3,24 +3,8 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 2 dependensi (baik internal maupun eksternal).
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi (baik internal maupun eksternal).
 
 **Hal Penting & Risiko:**
-- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.
-
-**Fungsi Utama (Metode/Endpoint):**
-- `_build_annual_pdf_bytes()`
-- `_expense_column_mapping_name()`
-- `_expense_amount_for_display()`
-- `_expense_subcategory_label()`
-- `_group_expenses_by_subcategory()`
-- `_render_expense_section_from_data()`
-- `_manual_combine_groups_by_table()`
-- `_manual_combine_groups_by_rows()`
-- `_apply_manual_revenue_combine_groups()`
-- `_apply_manual_tax_combine_groups()`
-- `_operation_cost_totals_by_column()`
-- `_get_revenue_bounds()`
-- `_group_revenues_by_type()`
-- `_validate_revenue_data()`
+- Perubahan pada file ini tergolong aman.
 
 ---
```

#### Perubahan pada: `reports\summary.py`
```diff
@@ -6,24 +6,11 @@
 
 **Hal Penting & Risiko:**
-- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.
+- Perubahan pada file ini tergolong aman.
 
 **Fungsi Utama (Metode/Endpoint):**
-- `_validate_date()`
-- `_display_settlement_status()`
-- `_get_summary_approved_expenses()`
-- `_expense_amount_for_summary()`
-- `_get_display_subcategory()`
-- `_summary_display_category()`
-- `_build_summary_payload()`
 - `get_summary_report()`
 - `export_summary_pdf()`
-- `generate_excel_report()`
-- `generate_excel_advance_report()`
-- `generate_pdf_advance_report()`
-- `generate_settlement_receipt()`
-- `generate_bulk_settlements_pdf()`
-- `generate_bulk_advances_pdf()`
 
 ---
 
-## Folder: `scratch/scanner_fokus/scripts`
+## Folder: `settings`
```

---
## Perubahan Frontend
### 🆕 File Baru / Dokumentasi Ditambahkan
- `controllers\settlement_list_controller.dart`
- `providers\advance\advance_provider.dart`
- `providers\auth\auth_provider.dart`
- `providers\core\base_provider.dart`
- `providers\core\cascade_provider.dart`
- `providers\core\notification_provider.dart`
- `providers\core\theme_provider.dart`
- `providers\master_data\bank_management_provider.dart`
- `providers\master_data\bank_status_provider.dart`
- `providers\master_data\tax_provider.dart`
- `providers\settlement\settlement_provider.dart`
- `providers\transactions\asset_provider.dart`
- `providers\transactions\dividend_provider.dart`
- `providers\transactions\revenue_provider.dart`
- `screens\advance\advances_screen_dialogs.dart`
- `screens\dashboard\dashboard_screen.dart`
- `screens\layout\main_layout.dart`
- `screens\layout\main_layout_settlement_list.dart`
- `screens\layout\main_layout_settlement_list_dialogs.dart`
- `screens\layout\main_layout_widgets.dart`
- `screens\main_layout_components\widget_summary_cards.dart`
- `screens\management\dialogs\dialog_asset_form.dart`
- `screens\management\dialogs\dialog_ndpv_table.dart`
- `screens\manager\widgets\widget_manager_approval_table.dart`
- `screens\manager\widgets\widget_manager_summary_cards.dart`
- `screens\scratch\main_layout_combined.dart`
- `screens\settings\dialog_custom_bank_order.dart`
- `screens\settings\widget_bank_order_settings_card.dart`
- `screens\settlement\widgets\widget_expense_form_fields.dart`
- `screens\settlement\widgets\widget_settlement_expense_table.dart`
- `screens\settlement\widgets\widget_settlement_summary_cards.dart`
- `screens\widgets\widget_scrollable_settlement_header.dart`
- `screens\widgets\widget_summary_cards.dart`
- `screens\widgets\widget_toggle_button.dart`
- `screens\widgets\widget_type_toggle.dart`
- `services\bank_order_preferences.dart`
- `widgets\core\_fast_range_picker_dialog.dart`
- `widgets\core\_menu_item_label.dart`
- `widgets\core\app_date_range_picker.dart`
- `widgets\core\cascading_menu_custom.dart`
- `widgets\core\cascading_menu_item.dart`
- `widgets\core\cascading_status_filter.dart`
- `widgets\core\cascading_year_filter.dart`
- `widgets\core\format_utils.dart`
- `widgets\core\status_filter_chip.dart`
- `widgets\core\year_filter_button.dart`
- `widgets\dialog_create_user.dart`
- `widgets\dialog_edit_user.dart`

### ❌ File Dihapus / Dokumentasi Dihapus
- `providers\advance_provider.dart`
- `providers\asset_provider.dart`
- `providers\auth_provider.dart`
- `providers\bank_management_provider.dart`
- `providers\bank_status_provider.dart`
- `providers\base_provider.dart`
- `providers\cascade_provider.dart`
- `providers\dividend_provider.dart`
- `providers\notification_provider.dart`
- `providers\revenue_provider.dart`
- `providers\settlement_provider.dart`
- `providers\tax_provider.dart`
- `providers\theme_provider.dart`
- `screens\advance\dialogs\dialog_edit_return.dart`
- `screens\advance\dialogs\dialog_reject_return.dart`
- `screens\advance\dialogs\dialog_return_checklist.dart`
- `screens\advance\dialogs\dialog_return_checklist_tile.dart`
- `screens\dashboard_screen.dart`
- `screens\main_layout.dart`
- `screens\main_layout_settlement_list.dart`
- `screens\main_layout_widgets.dart`
- `screens\settlement\dialogs\dialog_edit_return.dart`
- `screens\settlement\dialogs\dialog_reject_return.dart`
- `screens\settlement\dialogs\dialog_return_checklist.dart`
- `screens\widget_scrollable_settlement_header.dart`
- `screens\widget_summary_cards.dart`
- `screens\widget_toggle_button.dart`
- `screens\widget_type_toggle.dart`
- `screens\widgets\sidebar.dart`

### 📝 Dokumentasi Diedit
#### Perubahan pada: `main.dart`
```diff
@@ -21,5 +21,3 @@
 ---
 
-## Folder: `models`
-
-**Tujuan Folder:** Mendefinisikan struktur data (Blueprint/Model) dan fungsi konversi (fromJson/toJson).
+## Folder: `controllers`
```

#### Perubahan pada: `models\advance_item_model.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `models\advance_model.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `models\advance_model.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `providers\advance_provider.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `models\dto\advance_requests.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `providers\advance_provider.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -14,5 +14,5 @@
 ---
 
-## Folder: `providers`
+## Folder: `providers\advance`
 
 **Tujuan Folder:** Mengelola state aplikasi (State Management) dan logika bisnis utama (Controllers).
```

#### Perubahan pada: `models\enums.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 4 file lokal (contoh: `models\advance_item_model.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `models\notification_model.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 4 file lokal (contoh: `providers\notification_provider.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `providers\advance\advance_provider_finance_ext.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -16,8 +16,4 @@
 - `approveDisbursement()`
 - `saveReturn()`
-- `submitReturn()`
-- `rejectReturn()`
-- `updateReturnNotes()`
-- `approveReturn()`
 
 ---
```

#### Perubahan pada: `providers\advance\advance_provider_item_ext.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `providers\advance\advance_provider_list_ext.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `providers\advance\advance_provider_workflow_ext.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -21,5 +21,5 @@
 ---
 
-## Folder: `providers\settlement`
+## Folder: `providers\auth`
 
 **Tujuan Folder:** Mengelola state aplikasi (State Management) dan logika bisnis utama (Controllers).
```

#### Perubahan pada: `providers\settlement\settlement_provider_bank_ext.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `providers\settlement\settlement_provider_category_ext.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `providers\settlement\settlement_provider_crud_ext.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `providers\settlement\settlement_provider_expense_ext.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `providers\settlement\settlement_provider_finance_ext.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -16,8 +16,4 @@
 - `approveDisbursement()`
 - `saveReturn()`
-- `submitReturn()`
-- `rejectReturn()`
-- `updateReturnNotes()`
-- `approveReturn()`
 - `finalApproveSettlement()`
 
```

#### Perubahan pada: `providers\settlement\settlement_provider_list_ext.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `providers\settlement\settlement_provider_workflow_ext.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -24,5 +24,5 @@
 ---
 
-## Folder: `screens`
+## Folder: `providers\transactions`
 
-**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).
+**Tujuan Folder:** Mengelola state aplikasi (State Management) dan logika bisnis utama (Controllers).
```

#### Perubahan pada: `screens\advance\advance_detail_actions.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 13 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,23 +10,23 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailActionsExt`
+- `AdvanceDetailActionsExt`
 
 **Fungsi / Logika Utama:**
-- `_showGlobalSnackBar()`
-- `_moveToDraft()`
-- `_approveAdvance()`
-- `_rejectItem()`
-- `_fetchBadgeCounts()`
-- `_deleteItem()`
-- `_downloadReceipt()`
-- `_submitAdvance()`
-- `_bulkDeleteItems()`
-- `_buildSaveChecklistButton()`
-- `_approveItem()`
-- `_approveReturn()`
-- `_exportAdvanceExcel()`
-- `_canEditCurrentRevision()`
-- `_canApproveAdvanceItems()`
-- `_canSubmitAdvanceItems()`
+- `showGlobalSnackBar()`
+- `moveToDraft()`
+- `approveAdvance()`
+- `rejectItem()`
+- `fetchBadgeCounts()`
+- `deleteItem()`
+- `downloadReceipt()`
+- `submitAdvance()`
+- `bulkDeleteItems()`
+- `buildSaveChecklistButton()`
+- `approveItem()`
+- `exportAdvanceExcel()`
+- `canEditCurrentRevision()`
+- `canApproveAdvanceItems()`
+- `canSubmitAdvanceItems()`
+- `fetchActiveAdvanceBalance()`
 
 ---
```

#### Perubahan pada: `screens\advance\advance_detail_previews.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 12 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,12 +10,11 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailPreviewsExt`
+- `AdvanceDetailPreviewsExt`
 
 **Fungsi / Logika Utama:**
-- `_buildPreviewRow()`
-- `_showAllItemsPreview()`
-- `_showDisbursementPreview()`
-- `_showReturnPreview()`
-- `_showItemPreview()`
+- `buildPreviewRow()`
+- `showAllItemsPreview()`
+- `showDisbursementPreview()`
+- `showItemPreview()`
 
 ---
```

#### Perubahan pada: `screens\advance\advance_detail_screen.dart`
```diff
@@ -3,6 +3,6 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 30 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 4 file lokal (contoh: `screens\main_layout.dart`).
+- **Dependencies (Menggunakan):** Meng-import 25 dependensi/file lain.
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -11,23 +11,21 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `AdvanceDetailScreen`
-- `_AdvanceDetailScreenState`
+- `AdvanceDetailScreenState`
 
 **Fungsi / Logika Utama:**
-- `_handleMobilePageSelection()`
-- `_confirmLogout()`
+- `handleMobilePageSelection()`
+- `confirmLogout()`
 - `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
 - `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
-- `_fetchActiveAdvanceBalance()`
-- `_handleNotificationTap()`
-- `_statusColor()`
-- `_advanceStatusColor()`
-- `_advanceFundSource()`
-- `_advanceDisbursementSourceLabel()`
-- `_advanceReturnSourceLabel()`
+- `handleNotificationTap()`
+- `statusColor()`
+- `advanceStatusColor()`
+- `advanceFundSource()`
+- `advanceDisbursementSourceLabel()`
 - `collect()`
-- `_displayAdvanceStatus()`
-- `_headerText()`
-- `_displayAdvanceTitle()`
-- `_toDouble()`
+- `displayAdvanceStatus()`
+- `headerText()`
+- `displayAdvanceTitle()`
+- `toDouble()`
 - `updateState()`
 - `build()`: Membangun struktur UI/widget.
```

#### Perubahan pada: `screens\advance\advances_screen.dart`
```diff
@@ -3,9 +3,9 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 23 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\main_layout.dart`).
+- **Dependencies (Menggunakan):** Meng-import 18 dependensi/file lain.
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
-- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.
+- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.
 
 **Classes / Mixins / Widgets Terdeteksi:**
@@ -14,30 +14,24 @@
 
 **Fungsi / Logika Utama:**
-- `_handleListScroll()`
+- `handleListScroll()`
 - `scrollToTop()`
 - `resetFilters()`
-- `_scheduleAdvanceReload()`
-- `_canDeleteAdvanceCard()`
-- `_toggleItemSelection()`
-- `_bulkDeleteItems()`
+- `scheduleAdvanceReload()`
+- `canDeleteAdvanceCard()`
+- `toggleItemSelection()`
+- `bulkDeleteItems()`
 - `setState()`
-- `_loadAnnualAdvanceSummary()`
+- `loadAnnualAdvanceSummary()`
 - `updateState()`
 - `reloadAdvances()`
-- `_pickDateRange()`
-- `_exportExcel()`
-- `_exportPdf()`
-- `_showStandaloneReturnDialog()`
-- `_showCreateDialog()`
+- `pickDateRange()`
+- `exportExcel()`
+- `exportPdf()`
 - `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
-- `_onProviderChange()`
+- `onProviderChange()`
 - `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
 - `build()`: Membangun struktur UI/widget.
 - `LayoutBuilder()`
-- `_deleteAdvance()`
+- `deleteAdvance()`
 
 ---
-
-## Folder: `screens\advance\dialogs`
-
-**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).
```

#### Perubahan pada: `screens\advance\dialogs\dialog_add_category.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailDialogsExpenseshowAddCategoryDialogExt`
+- `AdvanceDetailDialogsExpenseshowAddCategoryDialogExt`
 
 ---
```

#### Perubahan pada: `screens\advance\dialogs\dialog_add_item.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 16 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailDialogsExpenseshowAddItemDialogExt`
+- `AdvanceDetailDialogsExpenseshowAddItemDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showAddItemDialog()`
+- `showAddItemDialog()`
 
 ---
```

#### Perubahan pada: `screens\advance\dialogs\dialog_checklist.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,9 +10,9 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailDialogsGeneralshowChecklistDialogExt`
+- `AdvanceDetailDialogsGeneralshowChecklistDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showChecklistDialog()`
-- `_buildChecklistTile()`
+- `showChecklistDialog()`
+- `buildChecklistTile()`
 
 ---
```

#### Perubahan pada: `screens\advance\dialogs\dialog_comments.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailDialogsGeneralshowCommentsDialogExt`
+- `AdvanceDetailDialogsGeneralshowCommentsDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showCommentsDialog()`
+- `showCommentsDialog()`
 
 ---
```

#### Perubahan pada: `screens\advance\dialogs\dialog_disbursement_evidence_cell.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailDialogsGeneralbuildDisbursementEvidenceCellExt`
+- `AdvanceDetailDialogsGeneralbuildDisbursementEvidenceCellExt`
 
 **Fungsi / Logika Utama:**
-- `_buildDisbursementEvidenceCell()`
+- `buildDisbursementEvidenceCell()`
 
 ---
```

#### Perubahan pada: `screens\advance\dialogs\dialog_edit_advance.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailDialogsGeneralshowEditAdvanceDialogExt`
+- `AdvanceDetailDialogsGeneralshowEditAdvanceDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showEditAdvanceDialog()`
+- `showEditAdvanceDialog()`
 
 ---
```

#### Perubahan pada: `screens\advance\dialogs\dialog_edit_disbursement.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 10 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailDialogsGeneralshowEditDisbursementDialogExt`
+- `AdvanceDetailDialogsGeneralshowEditDisbursementDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showEditDisbursementDialog()`
+- `showEditDisbursementDialog()`
 
 ---
```

#### Perubahan pada: `screens\advance\dialogs\dialog_evidence.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailDialogsGeneralshowEvidenceExt`
+- `AdvanceDetailDialogsGeneralshowEvidenceExt`
 
 **Fungsi / Logika Utama:**
-- `_showEvidence()`
+- `showEvidence()`
 - `InkWell()`
 
```

#### Perubahan pada: `screens\advance\dialogs\dialog_get_comments_from_notes.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailDialogsGeneralgetCommentsFromNotesExt`
+- `AdvanceDetailDialogsGeneralgetCommentsFromNotesExt`
 
 ---
```

#### Perubahan pada: `screens\advance\dialogs\dialog_insufficient_balance.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailDialogsGeneralshowInsufficientBalanceDialogExt`
+- `AdvanceDetailDialogsGeneralshowInsufficientBalanceDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showInsufficientBalanceDialog()`
+- `showInsufficientBalanceDialog()`
 
 ---
```

#### Perubahan pada: `screens\advance\dialogs\dialog_parse_plain_comments.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailDialogsGeneralparsePlainCommentsExt`
+- `AdvanceDetailDialogsGeneralparsePlainCommentsExt`
 
 ---
```

#### Perubahan pada: `screens\advance\dialogs\dialog_plain_comments.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailDialogsGeneralshowPlainCommentsDialogExt`
+- `AdvanceDetailDialogsGeneralshowPlainCommentsDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showPlainCommentsDialog()`
+- `showPlainCommentsDialog()`
 
 ---
```

#### Perubahan pada: `screens\advance\dialogs\dialog_workflow_timeline.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailDialogsGeneralshowWorkflowTimelineDialogExt`
+- `AdvanceDetailDialogsGeneralshowWorkflowTimelineDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showWorkflowTimelineDialog()`
+- `showWorkflowTimelineDialog()`
 
 ---
```

#### Perubahan pada: `screens\advance\layouts\advance_detail_layout.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,9 +10,9 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailLayoutExt`
+- `AdvanceDetailLayoutExt`
 
 **Fungsi / Logika Utama:**
-- `_formatItemAmount()`
-- `_hasUncheckedChecklist()`
+- `formatItemAmount()`
+- `hasUncheckedChecklist()`
 
 ---
```

#### Perubahan pada: `screens\advance\layouts\advance_detail_tables.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 19 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,11 +10,11 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailTablesExt`
+- `AdvanceDetailTablesExt`
 
 **Fungsi / Logika Utama:**
-- `_buildAdvanceFundReturnSection()`
-- `_buildChecklistTile()`
-- `_buildItemsTable()`
-- `_buildAdvanceFundTransferSection()`
+- `buildChecklistTile()`
+- `buildPendingRichText()`
+- `buildItemsTable()`
+- `buildAdvanceFundTransferSection()`
 
 ---
```

#### Perubahan pada: `screens\advance\widgets\advances_widgets.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `screens\advance\widgets\widget_add_comment_button.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailLayoutAddCommentButtonExt`
+- `AdvanceDetailLayoutAddCommentButtonExt`
 
 **Fungsi / Logika Utama:**
-- `_buildAddCommentButton()`
+- `buildAddCommentButton()`
 
 ---
```

#### Perubahan pada: `screens\advance\widgets\widget_advance_detail_actions.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 12 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailLayoutAdvanceDetailActionsExt`
+- `AdvanceDetailLayoutAdvanceDetailActionsExt`
 
 ---
```

#### Perubahan pada: `screens\advance\widgets\widget_content.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 10 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailLayoutContentExt`
+- `AdvanceDetailLayoutContentExt`
 
 **Fungsi / Logika Utama:**
-- `_buildContent()`
+- `buildContent()`
 
 ---
```

#### Perubahan pada: `screens\advance\widgets\widget_empty_state.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailLayoutEmptyStateExt`
+- `AdvanceDetailLayoutEmptyStateExt`
 
 **Fungsi / Logika Utama:**
-- `_buildEmptyState()`
+- `buildEmptyState()`
 
 ---
```

#### Perubahan pada: `screens\advance\widgets\widget_file_list.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailLayoutFileListExt`
+- `AdvanceDetailLayoutFileListExt`
 
 ---
```

#### Perubahan pada: `screens\advance\widgets\widget_insuff_balance_row.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailLayoutinsuffBalanceRowExt`
+- `AdvanceDetailLayoutinsuffBalanceRowExt`
 
 **Fungsi / Logika Utama:**
-- `_insuffBalanceRow()`
+- `insuffBalanceRow()`
 
 ---
```

#### Perubahan pada: `screens\advance\widgets\widget_mobile_advance_action_bar.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailLayoutMobileAdvanceActionBarExt`
+- `AdvanceDetailLayoutMobileAdvanceActionBarExt`
 
 **Fungsi / Logika Utama:**
-- `_buildMobileAdvanceActionBar()`
+- `buildMobileAdvanceActionBar()`
 
 ---
```

#### Perubahan pada: `screens\advance\widgets\widget_scrollable_advance_header.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 10 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -13,6 +13,5 @@
 
 **Fungsi / Logika Utama:**
-- `_buildScrollableAdvanceHeader()`
-- `CascadingYearFilter()`
+- `buildScrollableAdvanceHeader()`
 
 ---
```

#### Perubahan pada: `screens\advance\widgets\widget_toggle_button.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -13,5 +13,5 @@
 
 **Fungsi / Logika Utama:**
-- `_buildToggleButton()`
+- `buildToggleButton()`
 
 ---
```

#### Perubahan pada: `screens\advance\widgets\widget_type_toggle.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -13,5 +13,5 @@
 
 **Fungsi / Logika Utama:**
-- `_buildTypeToggle()`
+- `buildTypeToggle()`
 
 ---
```

#### Perubahan pada: `screens\advance\widgets\widget_warning_box.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AdvanceDetailLayoutWarningBoxExt`
+- `AdvanceDetailLayoutWarningBoxExt`
 
 **Fungsi / Logika Utama:**
-- `_buildWarningBox()`
+- `buildWarningBox()`
 
 ---
```

#### Perubahan pada: `screens\advance\widgets\widget_year_summary_card.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -13,5 +13,5 @@
 
 **Fungsi / Logika Utama:**
-- `_buildYearSummaryCard()`
+- `buildYearSummaryCard()`
 
 ---
```

#### Perubahan pada: `screens\auth\loading_screen.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `main.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -11,5 +11,5 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `LoadingScreen`
-- `_LoadingScreenState`
+- `LoadingScreenState`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\login_screen.dart`
```diff
@@ -3,6 +3,6 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `main.dart`).
+- **Dependencies (Menggunakan):** Meng-import 11 dependensi/file lain.
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -11,17 +11,17 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `LoginScreen`
-- `_LoginScreenState`
+- `LoginScreenState`
 
 **Fungsi / Logika Utama:**
 - `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
-- `_loadSavedCredentials()`
+- `loadSavedCredentials()`
 - `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
-- `_loadServerUrl()`
-- `_showServerUrlDialog()`
-- `_login()`
-- `_navigateToRegister()`
-- `_showMessage()`
-- `_handleGoogleLogin()`
-- `_showForgotPasswordDialog()`
+- `loadServerUrl()`
+- `showServerUrlDialog()`
+- `login()`
+- `navigateToRegister()`
+- `showMessage()`
+- `handleGoogleLogin()`
+- `showForgotPasswordDialog()`
 - `StatefulBuilder()`
 - `submit()`
```

#### Perubahan pada: `screens\auth\login_widget_gmail_login_button.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_GmailLoginButton`
+- `GmailLoginButton`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\login_widget_landscape_intro_panel.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_LandscapeIntroPanel`
+- `LandscapeIntroPanel`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\login_widget_landscape_login_content.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_LandscapeLoginContent`
+- `LandscapeLoginContent`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\login_widget_login_brand_icon.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_LoginBrandIcon`
+- `LoginBrandIcon`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\login_widget_login_button.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_LoginButton`
+- `LoginButton`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\login_widget_login_hint_card.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_LoginHintCard`
+- `LoginHintCard`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\login_widget_password_field.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_PasswordField`
+- `PasswordField`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\login_widget_portrait_login_content.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_PortraitLoginContent`
+- `PortraitLoginContent`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\login_widget_register_link.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_RegisterLink`
+- `RegisterLink`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\login_widget_username_field.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_UsernameField`
+- `UsernameField`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\register_screen.dart`
```diff
@@ -3,6 +3,6 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\auth\login_screen.dart`).
+- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -11,10 +11,10 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `RegisterScreen`
-- `_RegisterScreenState`
+- `RegisterScreenState`
 
 **Fungsi / Logika Utama:**
 - `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
 - `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
-- `_register()`
+- `register()`
 - `build()`: Membangun struktur UI/widget.
 
```

#### Perubahan pada: `screens\auth\register_widget_back_button.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_BackButton`
+- `CustomBackButton`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\register_widget_company_dropdown.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_CompanyDropdown`
+- `CompanyDropdown`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\register_widget_confirm_password_field.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_ConfirmPasswordField`
+- `ConfirmPasswordField`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\register_widget_email_field.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_EmailField`
+- `EmailField`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\register_widget_full_name_field.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_FullNameField`
+- `FullNameField`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\register_widget_landscape_intro_panel.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_LandscapeIntroPanel`
+- `LandscapeIntroPanel`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\register_widget_landscape_register_content.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 14 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_LandscapeRegisterContent`
+- `LandscapeRegisterContent`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\register_widget_password_field.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_PasswordField`
+- `PasswordField`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\register_widget_phone_field.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_PhoneField`
+- `PhoneField`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\register_widget_portrait_register_content.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 14 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_PortraitRegisterContent`
+- `PortraitRegisterContent`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\register_widget_register_brand_icon.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_RegisterBrandIcon`
+- `RegisterBrandIcon`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\register_widget_register_button.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_RegisterButton`
+- `RegisterButton`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\register_widget_role_dropdown.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_RoleDropdown`
+- `RoleDropdown`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\register_widget_username_field.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_UsernameField`
+- `UsernameField`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\register_widget_workplace_field.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_WorkplaceField`
+- `WorkplaceField`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\auth\server_error_screen.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `main.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -11,16 +11,16 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `ServerErrorScreen`
-- `_ServerErrorScreenState`
+- `ServerErrorScreenState`
 
 **Fungsi / Logika Utama:**
 - `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
 - `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
-- `_showServerUrlDialog()`
-- `_retry()`
+- `showServerUrlDialog()`
+- `retry()`
 - `build()`: Membangun struktur UI/widget.
 
 ---
 
-## Folder: `screens\management`
+## Folder: `screens\dashboard`
 
 **Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).
```

#### Perubahan pada: `screens\management\asset_management_screen.dart`
```diff
@@ -3,25 +3,21 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\reports\annual_report\annual_report_screen.dart`).
+- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
-- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.
+- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.
 
 **Classes / Mixins / Widgets Terdeteksi:**
 - `AssetManagementScreen`
-- `_AssetManagementScreenState`
+- `AssetManagementScreenState`
 
 **Fungsi / Logika Utama:**
 - `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
 - `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
-- `_loadData()`
-- `_clampInput()`
-- `_displayDate()`
-- `_showAssetDialog()`
-- `calculatePreview()`
-- `parseVal()`
-- `_showNdpvTable()`
-- `_confirmDelete()`
+- `loadData()`
+- `clampInput()`
+- `displayDate()`
+- `confirmDelete()`
 - `build()`: Membangun struktur UI/widget.
 
```

#### Perubahan pada: `screens\management\bank_advance_screen.dart`
```diff
@@ -11,11 +11,11 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `BankAdvanceScreen`
-- `_BankAdvanceScreenState`
+- `BankAdvanceScreenState`
 
 **Fungsi / Logika Utama:**
 - `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
 - `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
-- `_loadData()`
-- `_showManageBalanceDialog()`
+- `loadData()`
+- `showManageBalanceDialog()`
 - `getBankSortIndex()`
 - `getTotalAllocation()`
```

#### Perubahan pada: `screens\management\bank_management_screen.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 12 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\main_layout.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -11,8 +11,9 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `BankManagementScreen`
-- `_BankManagementScreenState`
+- `BankManagementScreenState`
 
 **Fungsi / Logika Utama:**
 - `updateState()`
+- `loadPreferenceOrders()`
 - `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
 - `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
```

#### Perubahan pada: `screens\management\bank_management_screen_actions.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,11 +10,11 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_BankManagementActionsExt`
+- `BankManagementActionsExt`
 
 **Fungsi / Logika Utama:**
-- `_loadData()`
-- `_loadAdvanceData()`
-- `_displayDate()`
-- `_getBankSortIndex()`
+- `loadData()`
+- `loadAdvanceData()`
+- `displayDate()`
+- `getBankSortIndex()`
 
 ---
```

#### Perubahan pada: `screens\management\bank_management_screen_layout.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_BankManagementLayoutExt`
+- `BankManagementLayoutExt`
 
 ---
```

#### Perubahan pada: `screens\management\bank_management_screen_tables.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_BankManagementTablesExt`
+- `BankManagementTablesExt`
 
 **Fungsi / Logika Utama:**
-- `_buildLogGridItem()`
+- `buildLogGridItem()`
 
 ---
```

#### Perubahan pada: `screens\management\bank_status_screen.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\reports\annual_report\annual_report_screen.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -11,15 +11,15 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `BankStatusScreen`
-- `_BankStatusScreenState`
+- `BankStatusScreenState`
 
 **Fungsi / Logika Utama:**
 - `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
-- `_loadData()`
-- `_displayDate()`
-- `_getBankSortIndex()`
-- `_showTransactionDialog()`
-- `_deleteTransaction()`
+- `loadData()`
+- `displayDate()`
+- `getBankSortIndex()`
+- `showTransactionDialog()`
+- `deleteTransaction()`
 - `build()`: Membangun struktur UI/widget.
-- `_buildBankFilter()`
+- `buildBankFilter()`
 
 ---
```

#### Perubahan pada: `screens\management\category_management_screen.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 3 file lokal (contoh: `screens\main_layout.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -11,5 +11,5 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `CategoryManagementView`
-- `_CategoryManagementViewState`
+- `CategoryManagementViewState`
 
 **Fungsi / Logika Utama:**
@@ -18,10 +18,10 @@
 - `build()`: Membangun struktur UI/widget.
 - `LayoutBuilder()`
-- `_buildCategoryTile()`
-- `_buildPendingItem()`
-- `_showAddCategoryDialog()`
-- `_showEditCategoryDialog()`
-- `_deleteCategory()`
-- `_approveCategory()`
+- `buildCategoryTile()`
+- `buildPendingItem()`
+- `showAddCategoryDialog()`
+- `showEditCategoryDialog()`
+- `deleteCategory()`
+- `approveCategory()`
 
 ---
```

#### Perubahan pada: `screens\management\category_tabular_screen.dart`
```diff
@@ -3,6 +3,6 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `screens\management\category_management_screen.dart`).
+- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -11,19 +11,19 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `CategoryTabularScreen`
-- `_CategoryTabularScreenState`
+- `CategoryTabularScreenState`
 
 **Fungsi / Logika Utama:**
 - `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
 - `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
-- `_loadData()`
-- `_saveChanges()`
-- `_showSnackBar()`
+- `loadData()`
+- `saveChanges()`
+- `showSnackBar()`
 - `build()`: Membangun struktur UI/widget.
-- `_saveAllGroupsAndCategories()`
-- `_showManageGroupsDialog()`
+- `saveAllGroupsAndCategories()`
+- `showManageGroupsDialog()`
 - `addGroup()`
 - `editGroup()`
 - `deleteGroup()`
-- `_syncTempCatsOrderDynamic()`
+- `syncTempCatsOrderDynamic()`
 
 ---
```

#### Perubahan pada: `screens\management\dialog_advance_log_book.dart`
```diff
@@ -3,15 +3,23 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
-- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.
+- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_BankManagementDialogsshowAdvanceLogBookDialogExt`
+- `BankManagementDialogsshowAdvanceLogBookDialogExt`
+- `AdvanceLogBookModal`
+- `_AdvanceLogBookModalState`
 
 **Fungsi / Logika Utama:**
-- `_showAdvanceLogBookDialog()`
+- `showAdvanceLogBookDialogHelper()`
+- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
+- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
+- `fetchLogs()`
+- `buildLogGridItem()`
+- `buildAuditTrailLogItem()`
+- `build()`: Membangun struktur UI/widget.
 
 ---
```

#### Perubahan pada: `screens\management\dialog_bank_account.dart`
```diff
@@ -3,16 +3,18 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 10 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
-- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.
+- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_BankManagementDialogsshowBankAccountDialogExt`
+- `BankManagementDialogsshowBankAccountDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showBankAccountDialog()`
+- `showBankAccountDialog()`
 - `Builder()`
+- `_showDeleteConfirmation()`
+- `StatefulBuilder()`
 
 ---
```

#### Perubahan pada: `screens\management\dialog_bank_advance_detail.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 11 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_BankManagementDialogsshowBankAdvanceDetailModalExt`
+- `BankManagementDialogsshowBankAdvanceDetailModalExt`
 
 **Fungsi / Logika Utama:**
-- `_showBankAdvanceDetailModal()`
+- `showBankAdvanceDetailModal()`
 
 ---
```

#### Perubahan pada: `screens\management\dialog_bank_cash_detail.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_BankManagementDialogsshowBankCashDetailModalExt`
+- `BankManagementDialogsshowBankCashDetailModalExt`
 
 **Fungsi / Logika Utama:**
-- `_showBankCashDetailModal()`
+- `showBankCashDetailModal()`
 
 ---
```

#### Perubahan pada: `screens\management\dialog_bank_cash_log_book.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 10 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_BankManagementDialogsshowBankCashLogBookDialogExt`
+- `BankManagementDialogsshowBankCashLogBookDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showBankCashLogBookDialog()`
+- `showBankCashLogBookDialog()`
 - `AppScrollbar()`
 
```

#### Perubahan pada: `screens\management\dialog_edit_advance_balance.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 10 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_BankManagementDialogsshowEditAdvanceBalanceDialogExt`
+- `BankManagementDialogsshowEditAdvanceBalanceDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showEditAdvanceBalanceDialog()`
+- `showEditAdvanceBalanceDialog()`
 - `getTotalAllocation()`
 
```

#### Perubahan pada: `screens\management\dialog_edit_advance_opening_balance.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_BankManagementDialogsshowEditAdvanceOpeningBalanceDialogExt`
+- `BankManagementDialogsshowEditAdvanceOpeningBalanceDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showEditAdvanceOpeningBalanceDialog()`
+- `showEditAdvanceOpeningBalanceDialog()`
 
 ---
```

#### Perubahan pada: `screens\management\dividend_management_screen.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\reports\annual_report\annual_report_screen.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -11,19 +11,19 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `DividendManagementScreen`
-- `_DividendManagementScreenState`
+- `DividendManagementScreenState`
 
 **Fungsi / Logika Utama:**
 - `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
 - `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
-- `_loadData()`
-- `_toDouble()`
-- `_fmtMoney()`
-- `_formatForInput()`
-- `_showRecipientDialog()`
+- `loadData()`
+- `toDouble()`
+- `fmtMoney()`
+- `formatForInput()`
+- `showRecipientDialog()`
 - `pickDate()`
-- `_saveProfitRetained()`
-- `_deleteDividend()`
-- `_textField()`
-- `_buildCalculationCard()`
+- `saveProfitRetained()`
+- `deleteDividend()`
+- `textField()`
+- `buildCalculationCard()`
 - `metric()`
 - `LayoutBuilder()`
```

#### Perubahan pada: `screens\management\logbook_screen.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `screens\management\bank_advance_screen.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -11,11 +11,11 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `LogbookScreen`
-- `_LogbookScreenState`
+- `LogbookScreenState`
 
 **Fungsi / Logika Utama:**
 - `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
-- `_fetchLogs()`
-- `_buildLogGridItem()`
-- `_buildAuditTrailLogItem()`
+- `fetchLogs()`
+- `buildLogGridItem()`
+- `buildAuditTrailLogItem()`
 - `build()`: Membangun struktur UI/widget.
 
```

#### Perubahan pada: `screens\management\revenue_management_screen.dart`
```diff
@@ -3,6 +3,6 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\reports\annual_report\annual_report_screen.dart`).
+- **Dependencies (Menggunakan):** Meng-import 12 dependensi/file lain.
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -11,5 +11,5 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `RevenueManagementScreen`
-- `_RevenueManagementScreenState`
+- `RevenueManagementScreenState`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\management\revenue_management_screen_actions.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,21 +10,21 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_RevenueManagementActionsExt`
+- `RevenueManagementActionsExt`
 
 **Fungsi / Logika Utama:**
-- `_displayDate()`
-- `_loadData()`
-- `_saveRevenue()`
-- `_deleteRevenue()`
-- `_itemId()`
-- `_manageRevenueCombine()`
+- `displayDate()`
+- `loadData()`
+- `saveRevenue()`
+- `deleteRevenue()`
+- `itemId()`
+- `manageRevenueCombine()`
 - `showDialog()`
 - `StatefulBuilder()`
 - `Flexible()`
-- `_startCombineWizard()`
+- `startCombineWizard()`
 - `isRowAvailable()`
-- `_releaseSelectedRevenueCombine()`
-- `_textField()`
-- `_numberField()`
+- `releaseSelectedRevenueCombine()`
+- `textField()`
+- `numberField()`
 
 ---
```

#### Perubahan pada: `screens\management\revenue_management_screen_dialogs.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,11 +10,11 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_RevenueManagementDialogsExt`
+- `RevenueManagementDialogsExt`
 
 **Fungsi / Logika Utama:**
-- `_formatNumericInput()`
-- `_showRevenueDialog()`
+- `formatNumericInput()`
+- `showRevenueDialog()`
 - `pickDate()`
-- `_showConfirmDialog()`
+- `showConfirmDialog()`
 
 ---
```

#### Perubahan pada: `screens\management\revenue_management_screen_tables.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_RevenueManagementTablesExt`
+- `RevenueManagementTablesExt`
 
 **Fungsi / Logika Utama:**
-- `_buildCell()`
+- `buildCell()`
 
 ---
```

#### Perubahan pada: `screens\management\tax_management_screen.dart`
```diff
@@ -3,6 +3,6 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\reports\annual_report\annual_report_screen.dart`).
+- **Dependencies (Menggunakan):** Meng-import 12 dependensi/file lain.
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -11,5 +11,5 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `TaxManagementScreen`
-- `_TaxManagementScreenState`
+- `TaxManagementScreenState`
 
 **Fungsi / Logika Utama:**
```

#### Perubahan pada: `screens\management\tax_management_screen_actions.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,22 +10,22 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_TaxManagementActionsExt`
+- `TaxManagementActionsExt`
 
 **Fungsi / Logika Utama:**
-- `_displayDate()`
-- `_loadData()`
-- `_saveTax()`
-- `_deleteTax()`
-- `_itemId()`
-- `_manageTaxCombine()`
+- `displayDate()`
+- `loadData()`
+- `saveTax()`
+- `deleteTax()`
+- `itemId()`
+- `manageTaxCombine()`
 - `showDialog()`
 - `StatefulBuilder()`
 - `Flexible()`
-- `_startTaxCombineWizard()`
+- `startTaxCombineWizard()`
 - `isRowAvailable()`
-- `_releaseSelectedTaxCombine()`
-- `_textField()`
-- `_numberField()`
-- `_fmtMoney()`
+- `releaseSelectedTaxCombine()`
+- `textField()`
+- `numberField()`
+- `fmtMoney()`
 
 ---
```

#### Perubahan pada: `screens\management\tax_management_screen_dialogs.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,12 +10,12 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_TaxManagementDialogsExt`
+- `TaxManagementDialogsExt`
 
 **Fungsi / Logika Utama:**
-- `_formatNumericInput()`
-- `_showTaxDialog()`
+- `formatNumericInput()`
+- `showTaxDialog()`
 - `pickDate()`
 - `StatefulBuilder()`
-- `_showConfirmDialog()`
+- `showConfirmDialog()`
 
 ---
```

#### Perubahan pada: `screens\management\tax_management_screen_tables.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_TaxManagementTablesExt`
+- `TaxManagementTablesExt`
 
 **Fungsi / Logika Utama:**
-- `_buildCell()`
+- `buildCell()`
 
 ---
```

#### Perubahan pada: `screens\management\widget_advance_section.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_BankManagementLayoutAdvanceSectionExt`
+- `BankManagementLayoutAdvanceSectionExt`
 
 **Fungsi / Logika Utama:**
-- `_buildAdvanceSection()`
+- `buildAdvanceSection()`
 - `Builder()`
 
```

#### Perubahan pada: `screens\management\widget_audit_trail_log_item.dart`
```diff
@@ -3,15 +3,15 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
-- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.
+- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_BankManagementLayoutAuditTrailLogItemExt`
+- `BankManagementLayoutAuditTrailLogItemExt`
 
 **Fungsi / Logika Utama:**
-- `_buildAuditTrailLogItem()`
+- `buildAuditTrailLogItem()`
 
 ---
```

#### Perubahan pada: `screens\management\widget_bank_accounts_tab.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_BankManagementLayoutBankAccountsTabExt`
+- `BankManagementLayoutBankAccountsTabExt`
 
 **Fungsi / Logika Utama:**
-- `_buildBankAccountsTab()`
+- `buildBankAccountsTab()`
 
 ---
```

#### Perubahan pada: `screens\management\widget_group_management_dialog.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_CategoryTabularScreenGroupManagementDialogExt`
+- `CategoryTabularScreenGroupManagementDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showGroupManagementDialog()`
+- `showGroupManagementDialog()`
 - `moveItem()`
 - `buildKanbanContent()`
```

#### Perubahan pada: `screens\management\widget_kanban_column_dynamic.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_CategoryTabularScreenKanbanColumnDynamicExt`
+- `CategoryTabularScreenKanbanColumnDynamicExt`
 
 ---
```

#### Perubahan pada: `screens\management\widget_section_toggle.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_BankManagementLayoutSectionToggleExt`
+- `BankManagementLayoutSectionToggleExt`
 
 **Fungsi / Logika Utama:**
-- `_buildSectionToggle()`
+- `buildSectionToggle()`
 
 ---
```

#### Perubahan pada: `screens\management\widget_simple_category_card.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_CategoryTabularScreenSimpleCategoryCardExt`
+- `CategoryTabularScreenSimpleCategoryCardExt`
 
 **Fungsi / Logika Utama:**
-- `_buildSimpleCategoryCard()`
+- `buildSimpleCategoryCard()`
 
 ---
```

#### Perubahan pada: `screens\management\widget_toggle_button.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,12 +10,12 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_BankManagementLayoutToggleButtonExt`
+- `BankManagementLayoutToggleButtonExt`
 
 **Fungsi / Logika Utama:**
-- `_buildToggleButton()`
+- `buildToggleButton()`
 
 ---
 
-## Folder: `screens\manager`
+## Folder: `screens\management\dialogs`
 
 **Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).
```

#### Perubahan pada: `screens\manager\manager_settlement_detail_screen.dart`
```diff
@@ -3,6 +3,6 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\manager\manager_dashboard_screen.dart`).
+- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -18,6 +18,4 @@
 - `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
 - `build()`: Membangun struktur UI/widget.
-- `_buildSettlementInfo()`
-- `_buildExpensesList()`
 - `_editExpense()`
 - `_deleteExpense()`
@@ -35,5 +33,5 @@
 ---
 
-## Folder: `screens\reports`
+## Folder: `screens\manager\widgets`
 
 **Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).
```

#### Perubahan pada: `screens\reports\annual_report\annual_report_helpers.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,18 +10,18 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AnnualReportHelpersExt`
+- `AnnualReportHelpersExt`
 
 **Fungsi / Logika Utama:**
-- `_toDouble()`
-- `_fmtMoney()`
-- `_fmtPlain()`
-- `_fmtAmount()`
-- `_normalizeCurrency()`
-- `_fmtDate()`
-- `_extractBatchNumber()`
-- `_isBatchSettlement()`
-- `_extractNoteSubcategory()`
-- `_subcategorySortBucket()`
-- `_expenseSubcategoryLabel()`
+- `toDouble()`
+- `fmtMoney()`
+- `fmtPlain()`
+- `fmtAmount()`
+- `normalizeCurrency()`
+- `fmtDate()`
+- `extractBatchNumber()`
+- `isBatchSettlement()`
+- `extractNoteSubcategory()`
+- `subcategorySortBucket()`
+- `expenseSubcategoryLabel()`
 
 ---
```

#### Perubahan pada: `screens\reports\annual_report\annual_report_screen.dart`
```diff
@@ -3,6 +3,6 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 24 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\reports\report_screen.dart`).
+- **Dependencies (Menggunakan):** Meng-import 29 dependensi/file lain.
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -11,27 +11,27 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `AnnualReportScreen`
-- `_AnnualReportScreenState`
+- `AnnualReportScreenState`
 
 **Fungsi / Logika Utama:**
 - `updateState()`
 - `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
-- `_onProviderChange()`
+- `onProviderChange()`
 - `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
-- `_syncScroll()`
-- `_syncHorizontal()`
-- `_fetchCategories()`
-- `_loadDefaultReportYearAndFetch()`
-- `_fetchReport()`
-- `_pickDateRange()`
-- `_exportExcel()`
-- `_applySheet()`
-- `_toggleTableVisibility()`
-- `_showUnavailableInputMessage()`
-- `_handleInputMenuSelection()`
-- `_navToDetail()`
-- `_parseDate()`
+- `syncScroll()`
+- `syncHorizontal()`
+- `fetchCategories()`
+- `loadDefaultReportYearAndFetch()`
+- `fetchReport()`
+- `pickDateRange()`
+- `exportExcel()`
+- `applySheet()`
+- `toggleTableVisibility()`
+- `showUnavailableInputMessage()`
+- `handleInputMenuSelection()`
+- `navToDetail()`
+- `parseDate()`
 - `build()`: Membangun struktur UI/widget.
 - `Listener()`
-- `_navTo()`
+- `navTo()`
 
 ---
```

#### Perubahan pada: `screens\reports\annual_report\annual_report_state.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\reports\annual_report\annual_report_screen.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `screens\reports\annual_report\annual_report_tables.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,10 +10,10 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AnnualReportTablesExt`
+- `AnnualReportTablesExt`
 
 **Fungsi / Logika Utama:**
 - `mergeInto()`
 - `addExpenseGroup()`
-- `_isNumericLikeCell()`
+- `isNumericLikeCell()`
 
 ---
```

#### Perubahan pada: `screens\reports\annual_report\annual_report_widgets.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AnnualReportWidgetsExt`
+- `AnnualReportWidgetsExt`
 
 ---
```

#### Perubahan pada: `screens\reports\annual_report\widget_all_tables.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AnnualReportTablesAllTablesExt`
+- `AnnualReportTablesAllTablesExt`
 
 **Fungsi / Logika Utama:**
-- `_processAllTables()`
+- `processAllTables()`
 
 ---
```

#### Perubahan pada: `screens\reports\annual_report\widget_bank_expense_table.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AnnualReportTablesBankExpenseTableExt`
+- `AnnualReportTablesBankExpenseTableExt`
 
 ---
```

#### Perubahan pada: `screens\reports\annual_report\widget_cache_info.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AnnualReportWidgetsCacheInfoExt`
+- `AnnualReportWidgetsCacheInfoExt`
 
 **Fungsi / Logika Utama:**
-- `_buildCacheInfo()`
+- `buildCacheInfo()`
 
 ---
```

#### Perubahan pada: `screens\reports\annual_report\widget_card.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AnnualReportWidgetsCardExt`
+- `AnnualReportWidgetsCardExt`
 
 **Fungsi / Logika Utama:**
-- `_buildCard()`
+- `buildCard()`
 
 ---
```

#### Perubahan pada: `screens\reports\annual_report\widget_display_tables.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AnnualReportWidgetsDisplayTablesExt`
+- `AnnualReportWidgetsDisplayTablesExt`
 
 ---
```

#### Perubahan pada: `screens\reports\annual_report\widget_evidence_button.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AnnualReportWidgetsEvidenceButtonExt`
+- `AnnualReportWidgetsEvidenceButtonExt`
 
 **Fungsi / Logika Utama:**
-- `_buildEvidenceButton()`
+- `buildEvidenceButton()`
 
 ---
```

#### Perubahan pada: `screens\reports\annual_report\widget_expense_table_cell.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AnnualReportWidgetsExpenseTableCellExt`
+- `AnnualReportWidgetsExpenseTableCellExt`
 
 **Fungsi / Logika Utama:**
-- `_buildExpenseTableCell()`
+- `buildExpenseTableCell()`
 
 ---
```

#### Perubahan pada: `screens\reports\annual_report\widget_report_header.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AnnualReportWidgetsReportHeaderExt`
+- `AnnualReportWidgetsReportHeaderExt`
 
 **Fungsi / Logika Utama:**
-- `_buildReportHeader()`
+- `buildReportHeader()`
 
 ---
```

#### Perubahan pada: `screens\reports\annual_report\widget_show_evidence_popup.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AnnualReportWidgetsshowEvidencePopupExt`
+- `AnnualReportWidgetsshowEvidencePopupExt`
 
 **Fungsi / Logika Utama:**
-- `_showEvidencePopup()`
+- `showEvidencePopup()`
 
 ---
```

#### Perubahan pada: `screens\reports\annual_report\widget_status_cell.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AnnualReportWidgetsStatusCellExt`
+- `AnnualReportWidgetsStatusCellExt`
 
 **Fungsi / Logika Utama:**
-- `_buildStatusCell()`
+- `buildStatusCell()`
 
 ---
```

#### Perubahan pada: `screens\reports\annual_report\widget_summary_cards.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AnnualReportWidgetsSummaryCardsExt`
+- `AnnualReportWidgetsSummaryCardsExt`
 
 **Fungsi / Logika Utama:**
-- `_buildSummaryCards()`
+- `buildSummaryCards()`
 
 ---
```

#### Perubahan pada: `screens\reports\annual_report\widget_table4_a_and4_b.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AnnualReportTablesTable4AAnd4BExt`
+- `AnnualReportTablesTable4AAnd4BExt`
 
 **Fungsi / Logika Utama:**
-- `_processTable4AAnd4B()`
+- `processTable4AAnd4B()`
 - `getFilteredCatIndex()`
 
```

#### Perubahan pada: `screens\reports\annual_report\widget_table4_c_and4_d.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AnnualReportTablesTable4CAnd4DExt`
+- `AnnualReportTablesTable4CAnd4DExt`
 
 **Fungsi / Logika Utama:**
-- `_processTable4CAnd4D()`
+- `processTable4CAnd4D()`
 - `getFilteredCatIndex()`
 
```

#### Perubahan pada: `screens\reports\annual_report\widget_table_card.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AnnualReportWidgetsTableCardExt`
+- `AnnualReportWidgetsTableCardExt`
 
 **Fungsi / Logika Utama:**
-- `_buildTableCard()`
+- `buildTableCard()`
 - `Builder()`
 - `SizedBox()`
```

#### Perubahan pada: `screens\reports\annual_report\widget_tax_toggle_cell.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,12 +10,12 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_AnnualReportWidgetsTaxToggleCellExt`
+- `AnnualReportWidgetsTaxToggleCellExt`
 
 **Fungsi / Logika Utama:**
-- `_buildTaxToggleCell()`
+- `buildTaxToggleCell()`
 
 ---
 
-## Folder: `screens\settings`
+## Folder: `screens\scratch`
 
 **Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).
```

#### Perubahan pada: `screens\reports\report_screen.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 14 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\main_layout.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `screens\settings\balance_sheet_settings_screen.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\reports\annual_report\annual_report_screen.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -11,14 +11,14 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `BalanceSheetSettingsScreen`
-- `_BalanceSheetSettingsScreenState`
+- `BalanceSheetSettingsScreenState`
 
 **Fungsi / Logika Utama:**
 - `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
 - `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
-- `_loadData()`
-- `_toDouble()`
-- `_formatPlain()`
-- `_saveSettings()`
-- `_field()`
+- `loadData()`
+- `toDouble()`
+- `formatPlain()`
+- `saveSettings()`
+- `field()`
 - `build()`: Membangun struktur UI/widget.
 
```

#### Perubahan pada: `screens\settings\data_cleanup_screen.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\settings\settings_screen.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -11,22 +11,22 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `DataCleanupScreen`
-- `_DataCleanupScreenState`
+- `DataCleanupScreenState`
 
 **Fungsi / Logika Utama:**
 - `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
-- `_nextPage()`
-- `_prevPage()`
-- `_fetchPreview()`
-- `_executeCleanup()`
-- `_showError()`
-- `_isNextEnabled()`
+- `nextPage()`
+- `prevPage()`
+- `fetchPreview()`
+- `executeCleanup()`
+- `showError()`
+- `isNextEnabled()`
 - `build()`: Membangun struktur UI/widget.
-- `_buildProgressIndicator()`
-- `_buildYearSelection()`
-- `_buildModuleSelection()`
-- `_buildPreviewStep()`
-- `_buildConfirmationStep()`
-- `_buildSelectionCard()`
-- `_buildBottomNav()`
+- `buildProgressIndicator()`
+- `buildYearSelection()`
+- `buildModuleSelection()`
+- `buildPreviewStep()`
+- `buildConfirmationStep()`
+- `buildSelectionCard()`
+- `buildBottomNav()`
 
 ---
```

#### Perubahan pada: `screens\settings\deadline_manager_screen.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\settings\settings_screen.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -11,17 +11,17 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `DeadlineManagerScreen`
-- `_DeadlineRuleConfig`
-- `_DeadlineManagerScreenState`
+- `DeadlineRuleConfig`
+- `DeadlineManagerScreenState`
 
 **Fungsi / Logika Utama:**
 - `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
-- `_loadDeadlineSettings()`
-- `_saveSetting()`
-- `_showAddDayDialog()`
-- `_removeDay()`
+- `loadDeadlineSettings()`
+- `saveSetting()`
+- `showAddDayDialog()`
+- `removeDay()`
 - `build()`: Membangun struktur UI/widget.
-- `_buildHeaderInfo()`
-- `_buildModernRuleCard()`
-- `_buildDayChip()`
+- `buildHeaderInfo()`
+- `buildModernRuleCard()`
+- `buildDayChip()`
 
 ---
```

#### Perubahan pada: `screens\settings\settings_screen.dart`
```diff
@@ -3,6 +3,6 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 21 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\main_layout.dart`).
+- **Dependencies (Menggunakan):** Meng-import 16 dependensi/file lain.
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -11,7 +11,7 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `SettingsScreen`
-- `_SettingsScreenState`
+- `SettingsScreenState`
 - `EditProfileDialog`
-- `_EditProfileDialogState`
+- `EditProfileDialogState`
 
 **Fungsi / Logika Utama:**
@@ -20,6 +20,6 @@
 - `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
 - `build()`: Membangun struktur UI/widget.
-- `_pickImage()`
-- `_submit()`
+- `pickImage()`
+- `submit()`
 
 ---
```

#### Perubahan pada: `screens\settings\settings_screen_actions.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 14 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,16 +10,16 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettingsActionsExt`
+- `SettingsActionsExt`
 
 **Fungsi / Logika Utama:**
-- `_loadSettings()`
-- `_saveSettings()`
-- `_saveReportYearSettings()`
-- `_exportDatabase()`
-- `_importDatabase()`
-- `_confirmImport()`
-- `_showAccountList()`
-- `_toggleManagerSection()`
-- `_profileColumn()`
+- `loadSettings()`
+- `saveSettings()`
+- `saveReportYearSettings()`
+- `exportDatabase()`
+- `importDatabase()`
+- `confirmImport()`
+- `showAccountList()`
+- `toggleManagerSection()`
+- `profileColumn()`
 
 ---
```

#### Perubahan pada: `screens\settings\settings_screen_dialogs.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,9 +10,9 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettingsDialogsExt`
+- `SettingsDialogsExt`
 
 **Fungsi / Logika Utama:**
-- `_showImportPreviewDialog()`
-- `_showEditProfileDialog()`
+- `showImportPreviewDialog()`
+- `showEditProfileDialog()`
 
 ---
```

#### Perubahan pada: `screens\settings\settings_screen_layout.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettingsLayoutExt`
+- `SettingsLayoutExt`
 
 ---
```

#### Perubahan pada: `screens\settings\widget_bank_advance_widget.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,9 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettingsLayoutBankAdvanceWidgetExt`
+- `SettingsLayoutBankAdvanceWidgetExt`
 
 **Fungsi / Logika Utama:**
-- `_buildBankAdvanceWidget()`
+- `buildBankAdvanceWidget()`
+- `GestureDetector()`
 
 ---
```

#### Perubahan pada: `screens\settings\widget_cleanup_settings_card.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettingsLayoutCleanupSettingsCardExt`
+- `SettingsLayoutCleanupSettingsCardExt`
 
 **Fungsi / Logika Utama:**
-- `_buildCleanupSettingsCard()`
+- `buildCleanupSettingsCard()`
 
 ---
```

#### Perubahan pada: `screens\settings\widget_database_settings_card.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettingsLayoutDatabaseSettingsCardExt`
+- `SettingsLayoutDatabaseSettingsCardExt`
 
 **Fungsi / Logika Utama:**
-- `_buildDatabaseSettingsCard()`
+- `buildDatabaseSettingsCard()`
 
 ---
```

#### Perubahan pada: `screens\settings\widget_deadline_settings_card.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettingsLayoutDeadlineSettingsCardExt`
+- `SettingsLayoutDeadlineSettingsCardExt`
 
 **Fungsi / Logika Utama:**
-- `_buildDeadlineSettingsCard()`
+- `buildDeadlineSettingsCard()`
 
 ---
```

#### Perubahan pada: `screens\settings\widget_logbook_button.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettingsLayoutLogbookButtonExt`
+- `SettingsLayoutLogbookButtonExt`
 
 **Fungsi / Logika Utama:**
-- `_buildLogbookButton()`
+- `buildLogbookButton()`
 
 ---
```

#### Perubahan pada: `screens\settings\widget_manager_section.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettingsLayoutManagerSectionExt`
+- `SettingsLayoutManagerSectionExt`
 
 **Fungsi / Logika Utama:**
-- `_buildManagerSection()`
+- `buildManagerSection()`
 
 ---
```

#### Perubahan pada: `screens\settings\widget_profile_card.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettingsLayoutProfileCardExt`
+- `SettingsLayoutProfileCardExt`
 
 **Fungsi / Logika Utama:**
-- `_buildProfileCard()`
+- `buildProfileCard()`
 
 ---
```

#### Perubahan pada: `screens\settings\widget_report_year_settings_card.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettingsLayoutReportYearSettingsCardExt`
+- `SettingsLayoutReportYearSettingsCardExt`
 
 **Fungsi / Logika Utama:**
-- `_buildReportYearSettingsCard()`
+- `buildReportYearSettingsCard()`
 
 ---
```

#### Perubahan pada: `screens\settings\widget_storage_settings_card.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettingsLayoutStorageSettingsCardExt`
+- `SettingsLayoutStorageSettingsCardExt`
 
 **Fungsi / Logika Utama:**
-- `_buildStorageSettingsCard()`
+- `buildStorageSettingsCard()`
 
 ---
```

#### Perubahan pada: `screens\settings\widget_theme_settings_card.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettingsLayoutThemeSettingsCardExt`
+- `SettingsLayoutThemeSettingsCardExt`
 
 **Fungsi / Logika Utama:**
-- `_buildThemeSettingsCard()`
+- `buildThemeSettingsCard()`
 
 ---
```

#### Perubahan pada: `screens\settlement\dialogs\dialog_add_category.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettlementDetailDialogsExpenseshowAddCategoryDialogExt`
+- `SettlementDetailDialogsExpenseshowAddCategoryDialogExt`
 
 ---
```

#### Perubahan pada: `screens\settlement\dialogs\dialog_add_expense.dart`
```diff
@@ -3,15 +3,17 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 13 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
-- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.
+- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettlementDetailDialogsExpenseshowAddExpenseDialogExt`
+- `SettlementDetailDialogsExpenseshowAddExpenseDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showAddExpenseDialog()`
+- `showAddExpenseDialog()`
+- `calculateRemainingForSource()`
+- `StatefulBuilder()`
 
 ---
```

#### Perubahan pada: `screens\settlement\dialogs\dialog_checklist.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,9 +10,9 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettlementDetailDialogsGeneralshowChecklistDialogExt`
+- `SettlementDetailDialogsGeneralshowChecklistDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showChecklistDialog()`
-- `_buildChecklistTile()`
+- `showChecklistDialog()`
+- `buildChecklistTile()`
 
 ---
```

#### Perubahan pada: `screens\settlement\dialogs\dialog_comments.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettlementDetailDialogsGeneralshowCommentsDialogExt`
+- `SettlementDetailDialogsGeneralshowCommentsDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showCommentsDialog()`
+- `showCommentsDialog()`
 
 ---
```

#### Perubahan pada: `screens\settlement\dialogs\dialog_edit_disbursement.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 11 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettlementDetailDialogsGeneralshowEditDisbursementDialogExt`
+- `SettlementDetailDialogsGeneralshowEditDisbursementDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showEditDisbursementDialog()`
+- `showEditDisbursementDialog()`
 
 ---
```

#### Perubahan pada: `screens\settlement\dialogs\dialog_edit_expense.dart`
```diff
@@ -3,15 +3,17 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 12 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
-- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.
+- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettlementDetailDialogsExpenseshowEditExpenseDialogExt`
+- `SettlementDetailDialogsExpenseshowEditExpenseDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showEditExpenseDialog()`
+- `showEditExpenseDialog()`
+- `calculateRemainingForSource()`
+- `StatefulBuilder()`
 
 ---
```

#### Perubahan pada: `screens\settlement\dialogs\dialog_edit_settlement.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettlementDetailDialogsGeneralshowEditSettlementDialogExt`
+- `SettlementDetailDialogsGeneralshowEditSettlementDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showEditSettlementDialog()`
+- `showEditSettlementDialog()`
 
 ---
```

#### Perubahan pada: `screens\settlement\dialogs\dialog_evidence.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettlementDetailDialogsGeneralshowEvidenceExt`
+- `SettlementDetailDialogsGeneralshowEvidenceExt`
 
 **Fungsi / Logika Utama:**
-- `_showEvidence()`
+- `showEvidence()`
 - `InkWell()`
 
```

#### Perubahan pada: `screens\settlement\dialogs\dialog_plain_comments.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,12 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettlementDetailDialogsGeneralshowPlainCommentsDialogExt`
+- `SettlementDetailDialogsGeneralshowPlainCommentsDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showPlainCommentsDialog()`
+- `showPlainCommentsDialog()`
 
 ---
+
+## Folder: `screens\settlement\layouts`
+
+**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).
```

#### Perubahan pada: `screens\settlement\layouts\settlement_detail_layout.dart`
```diff
@@ -3,21 +3,21 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 14 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
-- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.
+- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettlementDetailLayoutExt`
+- `SettlementDetailLayoutExt`
 
 **Fungsi / Logika Utama:**
-- `_buildMobileSettlementActionBar()`
-- `_buildContent()`
-- `LayoutBuilder()`
-- `_headerText()`
-- `_buildAddCommentButton()`
-- `_buildEmptyState()`
-- `_buildTabButton()`
+- `buildMobileSettlementActionBar()`
+- `buildContent()`
+- `headerText()`
+- `buildAddCommentButton()`
+- `buildEmptyState()`
+- `buildPendingRichText()`
+- `buildTabButton()`
 
 ---
```

#### Perubahan pada: `screens\settlement\layouts\settlement_detail_tables.dart`
```diff
@@ -3,19 +3,17 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
-- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.
+- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettlementDetailTablesExt`
+- `SettlementDetailTablesExt`
 
 **Fungsi / Logika Utama:**
-- `_buildFundTransferSection()`
-- `_buildReturnChecklistTile()`
-- `_buildActionCell()`
-- `_buildFundReturnSection()`
-- `_buildChecklistTile()`
+- `buildFundTransferSection()`
+- `buildActionCell()`
+- `buildChecklistTile()`
 
 ---
```

#### Perubahan pada: `screens\settlement\settlement_detail_actions.dart`
```diff
@@ -3,30 +3,31 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 15 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
-- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.
+- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettlementDetailActionsExt`
+- `SettlementDetailActionsExt`
 
 **Fungsi / Logika Utama:**
-- `_approveTable1()`
-- `_approveSettlement()`
-- `_handleNotificationTap()`
-- `_downloadReceipt()`
-- `_showGlobalSnackBar()`
-- `_approveReturn()`
-- `_deleteExpense()`
-- `_moveToDraft()`
-- `_buildSaveChecklistButton()`
-- `_submitSettlement()`
-- `_exportSettlementExcel()`
-- `_rejectSettlement()`
-- `_fetchBadgeCounts()`
-- `_approveExpense()`
-- `_bulkDeleteExpenses()`
-- `_confirmLogout()`
+- `approveTable1()`
+- `approveSettlement()`
+- `handleNotificationTap()`
+- `downloadReceipt()`
+- `showGlobalSnackBar()`
+- `deleteExpense()`
+- `moveToDraft()`
+- `buildSaveChecklistButton()`
+- `submitSettlement()`
+- `exportSettlementExcel()`
+- `rejectSettlement()`
+- `fetchBadgeCounts()`
+- `approveExpense()`
+- `bulkDeleteExpenses()`
+- `confirmLogout()`
+- `fetchActiveAdvanceBalance()`
+- `showWorkflowTimelineDialog()`
 
 ---
```

#### Perubahan pada: `screens\settlement\settlement_detail_previews.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 11 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,16 +10,14 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettlementDetailPreviewsExt`
+- `SettlementDetailPreviewsExt`
 
 **Fungsi / Logika Utama:**
-- `_showReturnPreview()`
-- `_showItemPreview()`
-- `_showAllItemsPreview()`
+- `showItemPreview()`
+- `showAllItemsPreview()`
 - `StatefulBuilder()`
-- `_buildPreviewRow()`
-- `_buildDisbursementPreviewContent()`
-- `_buildReturnPreviewContent()`
-- `_buildAllItemsPreviewList()`
-- `_showDisbursementPreview()`
+- `buildPreviewRow()`
+- `buildDisbursementPreviewContent()`
+- `buildAllItemsPreviewList()`
+- `showDisbursementPreview()`
 
 ---
```

#### Perubahan pada: `screens\settlement\settlement_detail_screen.dart`
```diff
@@ -3,6 +3,6 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 28 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 4 file lokal (contoh: `screens\main_layout.dart`).
+- **Dependencies (Menggunakan):** Meng-import 25 dependensi/file lain.
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -11,25 +11,22 @@
 **Classes / Mixins / Widgets Terdeteksi:**
 - `SettlementDetailScreen`
-- `_SettlementDetailScreenState`
+- `SettlementDetailScreenState`
 
 **Fungsi / Logika Utama:**
 - `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
 - `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
-- `_fetchActiveAdvanceBalance()`
-- `_statusColor()`
-- `_toDouble()`
-- `_formatExpenseAmount()`
-- `_displaySettlementStatus()`
-- `_expenseFundSource()`
-- `_settlementDisbursementSourceLabel()`
-- `_settlementReturnSourceLabel()`
+- `getStatusColor()`
+- `toDouble()`
+- `formatExpenseAmount()`
+- `displaySettlementStatus()`
+- `expenseFundSource()`
+- `settlementDisbursementSourceLabel()`
 - `collect()`
-- `_settlementReimbursementAmount()`
-- `_buildDisbursementDataRow()`
-- `_showWorkflowTimelineDialog()`
-- `_displaySettlementTitle()`
-- `_hasUncheckedChecklist()`
-- `_canSubmitSettlementItems()`
-- `_canApproveSettlementItems()`
+- `settlementReimbursementAmount()`
+- `buildDisbursementDataRow()`
+- `displaySettlementTitle()`
+- `hasUncheckedChecklist()`
+- `canSubmitSettlementItems()`
+- `canApproveSettlementItems()`
 - `updateState()`
 - `build()`: Membangun struktur UI/widget.
```

#### Perubahan pada: `screens\settlement\widgets\widget_file_list.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,5 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettlementDetailFileListExt`
+- `SettlementDetailFileListExt`
 
 ---
```

#### Perubahan pada: `screens\settlement\widgets\widget_insuff_balance_row.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettlementDetailinsuffBalanceRowExt`
+- `SettlementDetailinsuffBalanceRowExt`
 
 **Fungsi / Logika Utama:**
-- `_insuffBalanceRow()`
+- `insuffBalanceRow()`
 
 ---
```

#### Perubahan pada: `screens\settlement\widgets\widget_insufficient_balance_dialog.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,8 +10,8 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettlementDetailInsufficientBalanceDialogExt`
+- `SettlementDetailInsufficientBalanceDialogExt`
 
 **Fungsi / Logika Utama:**
-- `_showInsufficientBalanceDialog()`
+- `showInsufficientBalanceDialog()`
 
 ---
```

#### Perubahan pada: `screens\settlement\widgets\widget_settlement_detail_actions.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -10,9 +10,5 @@
 
 **Classes / Mixins / Widgets Terdeteksi:**
-- `_SettlementDetailSettlementDetailActionsExt`
+- `SettlementDetailSettlementDetailActionsExt`
 
 ---
-
-## Folder: `screens\widgets`
-
-**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).
```

#### Perubahan pada: `screens\widgets\common_widgets.dart`
```diff
@@ -3,37 +3,9 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 10 file lokal (contoh: `screens\main_layout.dart`).
+- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
-- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.
-
-**Classes / Mixins / Widgets Terdeteksi:**
-- `StatusFilterChip`
-- `YearFilterButton`
-- `CascadingYearFilter`
-- `CascadingMenuItem`
-- `CascadingMenuCustom`
-- `AppDateRangePicker`
-- `_FastRangePickerDialog`
-- `_FastRangePickerDialogState`
-- `_MenuItemLabel`
-- `CascadingStatusFilter`
-
-**Fungsi / Logika Utama:**
-- `formatNumber()`
-- `build()`: Membangun struktur UI/widget.
-- `Material()`
-- `show()`
-- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
-- `_onMonthSelected()`
-- `_onYearSelected()`
-- `_buildPickerContent()`
-- `_buildHeaderWithNav()`
-- `_buildDayGrid()`
-- `GestureDetector()`
-- `_buildHeader()`
-- `_getMonthName()`
-- `_buildTabButton()`
+- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.
 
 ---
```

#### Perubahan pada: `screens\widgets\page_selector.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `screens\main_layout.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `screens\widgets\settlement_detail_widgets.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `screens\advance\advance_detail_screen.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `screens\widgets\transaction_cards.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `screens\main_layout.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -28,6 +28,2 @@
 
 ---
-
-## Folder: `services`
-
-**Tujuan Folder:** Menangani komunikasi ke luar, seperti pemanggilan API ke backend (HTTP requests).
```

#### Perubahan pada: `services\api_advances.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `services\api_assets.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `services\api_auth.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `services\api_banks.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `services\api_categories.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `services\api_companies.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `services\api_database.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `services\api_dividends.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `services\api_expenses.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `services\api_master.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
@@ -16,5 +16,5 @@
 - `setCompany()`
 - `getEvidenceUrl()`
-- `_networkHint()`
+- `networkHint()`
 
 ---
```

#### Perubahan pada: `services\api_reports.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `services\api_revenues.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `services\api_service.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 13 file lokal (contoh: `providers\advance_provider.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -13,9 +13,9 @@
 
 **Fungsi / Logika Utama:**
-- `_buildUrl()`
+- `buildUrl()`
 - `loadSavedBaseUrl()`
 - `saveBaseUrl()`
 - `checkConnectivity()`
-- `_loadTokenFromStorage()`
+- `loadTokenFromStorage()`
 - `ensureTokenLoaded()`
 
```

#### Perubahan pada: `services\api_settlements.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `services\api_taxes.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `services\api_users.dart`
```diff
@@ -3,5 +3,5 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
+- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
 - **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
```

#### Perubahan pada: `services\notification_service.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `providers\notification_provider.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `theme\app_theme.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 47 file lokal (contoh: `main.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `utils\app_dialogs.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 3 file lokal (contoh: `screens\main_layout.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `utils\app_formatters.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 7 file lokal (contoh: `models\advance_item_model.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `utils\app_logger.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `services\api_service.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `utils\app_snackbar.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 4 file lokal (contoh: `main.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `utils\context_extensions.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 9 file lokal (contoh: `screens\dashboard_screen.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `utils\currency_formatter.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 9 file lokal (contoh: `screens\main_layout.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `utils\event_bus.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 10 file lokal (contoh: `providers\advance_provider.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `utils\file_helper.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 6 file lokal (contoh: `screens\main_layout.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `utils\responsive_layout.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 8 file lokal (contoh: `screens\main_layout.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `utils\transaction_templates.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\management\bank_management_screen.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `widgets\account_list_dialog.dart`
```diff
@@ -3,17 +3,13 @@
 
 **Hubungan & Alur Data:**
-- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\settings\settings_screen.dart`).
+- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
-- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.
+- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.
 
 **Classes / Mixins / Widgets Terdeteksi:**
 - `AccountListDialog`
 - `_AccountListDialogState`
-- `CreateUserDialog`
-- `_CreateUserDialogState`
-- `EditUserByManagerDialog`
-- `_EditUserByManagerDialogState`
 - `_InfoChip`
 
@@ -32,8 +28,4 @@
 - `_buildStatusIndicator()`
 - `_getRoleName()`
-- `_loadCompanies()`
-- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
-- `_buildCompanyCheckboxes()`
-- `_submit()`
 
 ---
```

#### Perubahan pada: `widgets\app_brand_logo.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 4 file lokal (contoh: `screens\auth\loading_screen.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `widgets\app_scrollbar.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 13 file lokal (contoh: `main.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `widgets\category_preview_dialog.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `screens\advance\advance_detail_screen.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `widgets\image_cropper_dialog.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\settings\settings_screen.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `widgets\item_detail_preview_dialog.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `screens\advance\advance_detail_screen.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `widgets\manage_companies_dialog.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `widgets\account_list_dialog.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `widgets\notification_bell_icon.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 3 file lokal (contoh: `screens\main_layout.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `widgets\user_detail_dialog.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `screens\widgets\transaction_cards.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
```

#### Perubahan pada: `widgets\workflow_timeline.dart`
```diff
@@ -4,5 +4,5 @@
 **Hubungan & Alur Data:**
 - **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
-- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `screens\advance\advance_detail_screen.dart`).
+- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).
 
 **Hal Penting & Risiko:**
@@ -24,5 +24,5 @@
 ---
 
-## Folder: `widgets\details`
+## Folder: `widgets\core`
 
 **Tujuan Folder:** Menyimpan komponen visual (Widget) yang dapat digunakan berulang (Reusable) di berbagai layar.
```

---
