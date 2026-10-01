# Panduan Lengkap Frontend (MiniProjectKPI_EWI_Revisi2)

Dokumen ini digenerate secara menyeluruh untuk merinci struktur, peran, dependensi, fungsi, dan isi dari setiap file di dalam `frontend/lib`.
Ditujukan agar developer baru atau AI (LLM) dapat memahami aplikasi tanpa harus membaca source code satu per satu.

## Folder: `Root (lib)`

**Tujuan Folder:** Berisi konfigurasi dasar aplikasi atau inisialisasi awal.

### File: `main.dart` (318 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `MyCustomScrollBehavior`
- `ExpenseApp`
- `AuthWrapper`

**Fungsi Utama Terdeteksi:**
- `buildScrollbar()`
- `main()`
- `build()`

---

## Folder: `controllers`

**Tujuan Folder:** Berisi konfigurasi dasar aplikasi atau inisialisasi awal.

### File: `controllers/settlement_list_controller.dart` (135 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementListController`

**Fungsi Utama Terdeteksi:**
- `setFilterMode()`
- `setStatusFilter()`
- `setDateRange()`
- `setSearchQuery()`
- `setSelectionType()`
- `toggleItemSelection()`
- `clearSelection()`
- `resetFilters()`
- `reloadSettlements()`

---

## Folder: `models`

**Tujuan Folder:** Mendefinisikan struktur data (Blueprint/Model) dan fungsi konversi (fromJson/toJson).

### File: `models/advance_item_model.dart` (100 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceItemModel`

---

### File: `models/advance_model.dart` (272 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceModel`

---

### File: `models/enums.dart` (84 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `DocumentStatusExt`
- `AdvanceTypeExt`

**Fungsi Utama Terdeteksi:**
- `fromString()`

---

### File: `models/notification_model.dart` (92 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `NotificationModel`

**Fungsi Utama Terdeteksi:**
- `copyWith()`

---

## Folder: `models/dto`

**Tujuan Folder:** Mendefinisikan struktur data (Blueprint/Model) dan fungsi konversi (fromJson/toJson).

### File: `models/dto/advance_requests.dart` (38 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceItemRequest`

---

## Folder: `providers/advance`

**Tujuan Folder:** Mengelola state aplikasi (State Management) dan logika bisnis utama (Controllers).

### File: `providers/advance/advance_provider.dart` (408 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `InsufficientAdvanceBalanceException`
- `AdvanceProvider`

**Fungsi Utama Terdeteksi:**
- `setFilterMode()`
- `updateToken()`
- `clearData()`
- `submitStandaloneReturn()`
- `saveFirstItemAndCommitAdvance()`
- `cleanupEmptyDraft()`
- `updateAdvance()`
- `deleteAdvance()`
- `updateItemPartial()`
- `moveAdvanceToDraft()`
- `getEvidenceUrl()`
- `finalApproveAdvance()`

---

### File: `providers/advance/advance_provider_finance_ext.dart` (98 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceProviderFinanceExt`

**Fungsi Utama Terdeteksi:**
- `saveDisbursement()`
- `approveDisbursement()`
- `saveReturn()`

---

### File: `providers/advance/advance_provider_item_ext.dart` (106 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceProviderItemExt`

**Fungsi Utama Terdeteksi:**
- `addAdvanceItem()`
- `updateAdvanceItem()`
- `deleteAdvanceItem()`
- `bulkDeleteAdvanceItems()`
- `updateAdvanceItemsBulk()`

---

### File: `providers/advance/advance_provider_list_ext.dart` (155 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceProviderListExt`

**Fungsi Utama Terdeteksi:**
- `loadAdvances()`
- `clearFilters()`
- `syncReportYear()`
- `setReportYear()`
- `setFilterYear()`
- `loadAdvance()`
- `loadHistory()`

---

### File: `providers/advance/advance_provider_workflow_ext.dart` (126 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceProviderWorkflowExt`

**Fungsi Utama Terdeteksi:**
- `submitAdvance()`
- `approveAdvance()`
- `approveAdvanceItem()`
- `rejectAdvance()`
- `startRevision()`

---

## Folder: `providers/auth`

**Tujuan Folder:** Mengelola state aplikasi (State Management) dan logika bisnis utama (Controllers).

### File: `providers/auth/auth_provider.dart` (663 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `AuthProvider`

**Fungsi Utama Terdeteksi:**
- `clearActiveCompany()`
- `setActiveCompany()`
- `resetLoading()`
- `dispose()`
- `_loadToken()`
- `login()`
- `forgotPassword()`
- `resetPassword()`
- `register()`
- `createUser()`
- `reloadUser()`
- `updateUser()`
- `updateProfile()`
- `updateUserData()`
- `linkGoogleAccount()`
- *(dan 7 fungsi lainnya...)*

---

## Folder: `providers/core`

**Tujuan Folder:** Mengelola state aplikasi (State Management) dan logika bisnis utama (Controllers).

### File: `providers/core/base_provider.dart` (57 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `BaseTransactionProvider`

**Fungsi Utama Terdeteksi:**
- `loading()`
- `error()`
- `updateToken()`
- `clearData()`
- `syncReportYear()`

---

### File: `providers/core/cascade_provider.dart` (105 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `CascadeProvider`

**Fungsi Utama Terdeteksi:**
- `syncReportYear()`
- `syncAllFromSettings()`

---

### File: `providers/core/notification_provider.dart` (186 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `NotificationProvider`

**Fungsi Utama Terdeteksi:**
- `startPolling()`
- `stopPolling()`
- `fetchNotifications()`
- `fetchUnreadNotifications()`
- `markAsRead()`
- `markAllAsRead()`
- `deleteNotification()`
- `updateStatus()`
- `dispose()`

---

### File: `providers/core/theme_provider.dart` (45 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ThemeProvider`

**Fungsi Utama Terdeteksi:**
- `_loadThemeMode()`
- `setThemeMode()`
- `_parseThemeMode()`

---

## Folder: `providers/master_data`

**Tujuan Folder:** Mengelola state aplikasi (State Management) dan logika bisnis utama (Controllers).

### File: `providers/master_data/bank_management_provider.dart` (230 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `BankManagementProvider`

**Fungsi Utama Terdeteksi:**
- `updateToken()`
- `syncReportYear()`
- `setReportYear()`
- `loadBanks()`
- `loadTransactions()`
- `createTransaction()`
- `updateTransaction()`
- `deleteTransaction()`
- `createBankAccount()`
- `updateBankAccount()`
- `deleteBankAccount()`

---

### File: `providers/master_data/bank_status_provider.dart` (181 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `BankStatusProvider`

**Fungsi Utama Terdeteksi:**
- `updateToken()`
- `syncReportYear()`
- `setReportYear()`
- `loadBanks()`
- `loadTransactions()`
- `createTransaction()`
- `updateTransaction()`
- `deleteTransaction()`

---

### File: `providers/master_data/tax_provider.dart` (230 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `TaxProvider`

**Fungsi Utama Terdeteksi:**
- `updateToken()`
- `syncReportYear()`
- `setReportYear()`
- `loadTaxes()`
- `fetchTaxCombineGroups()`
- `createTax()`
- `updateTax()`
- `deleteTax()`
- `createTaxCombineGroup()`
- `deleteTaxCombineGroup()`

---

## Folder: `providers/settlement`

**Tujuan Folder:** Mengelola state aplikasi (State Management) dan logika bisnis utama (Controllers).

### File: `providers/settlement/settlement_provider.dart` (207 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementProvider`

**Fungsi Utama Terdeteksi:**
- `_loadSortMode()`
- `initialize()`
- `dispose()`
- `updateToken()`
- `clearData()`
- `setSortMode()`
- `getEvidenceUrl()`

---

### File: `providers/settlement/settlement_provider_bank_ext.dart` (32 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementProviderBankExt`

**Fungsi Utama Terdeteksi:**
- `loadBanks()`
- `loadAdvanceBanks()`

---

### File: `providers/settlement/settlement_provider_category_ext.dart` (89 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementProviderCategoryExt`

**Fungsi Utama Terdeteksi:**
- `loadCategories()`
- `loadPendingCategories()`
- `createCategory()`
- `updateCategory()`
- `reorderCategories()`
- `deleteCategory()`
- `approveCategory()`

---

### File: `providers/settlement/settlement_provider_crud_ext.dart` (81 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementProviderCrudExt`

**Fungsi Utama Terdeteksi:**
- `updateSettlement()`
- `deleteSettlement()`

---

### File: `providers/settlement/settlement_provider_expense_ext.dart` (210 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementProviderExpenseExt`

**Fungsi Utama Terdeteksi:**
- `saveFirstExpenseAndCommitSettlement()`
- `cleanupEmptyDraft()`
- `addExpense()`
- `updateExpense()`
- `updateExpenseData()`
- `updateExpensesBulk()`
- `deleteExpense()`
- `bulkDeleteExpenses()`

---

### File: `providers/settlement/settlement_provider_finance_ext.dart` (147 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementProviderFinanceExt`

**Fungsi Utama Terdeteksi:**
- `saveDisbursement()`
- `approveDisbursement()`
- `saveReturn()`
- `finalApproveSettlement()`

---

### File: `providers/settlement/settlement_provider_list_ext.dart` (147 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementProviderListExt`

**Fungsi Utama Terdeteksi:**
- `loadSettlements()`
- `clearFilters()`
- `loadSettlement()`
- `loadHistory()`
- `syncReportYear()`
- `setReportYear()`
- `setFilterYear()`
- `setFilterMode()`

---

### File: `providers/settlement/settlement_provider_workflow_ext.dart` (140 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementProviderWorkflowExt`

**Fungsi Utama Terdeteksi:**
- `submitSettlement()`
- `completeSettlement()`
- `approveSettlement()`
- `approveExpense()`
- `approveAllSettlement()`
- `rejectAllSettlement()`
- `rejectAllExpenses()`
- `moveSettlementToDraft()`

---

## Folder: `providers/transactions`

**Tujuan Folder:** Mengelola state aplikasi (State Management) dan logika bisnis utama (Controllers).

### File: `providers/transactions/asset_provider.dart` (291 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AssetProvider`

**Fungsi Utama Terdeteksi:**
- `resetToRecent()`
- `updateProjection()`
- `updateAbsolute()`
- `updateToken()`
- `syncReportYear()`
- `setReportYear()`
- `loadAssets()`
- `createAsset()`
- `updateAsset()`
- `deleteAsset()`

---

### File: `providers/transactions/dividend_provider.dart` (155 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `DividendProvider`

**Fungsi Utama Terdeteksi:**
- `updateToken()`
- `syncReportYear()`
- `setReportYear()`
- `fetchDividends()`
- `createDividend()`
- `updateDividend()`
- `deleteDividend()`
- `updateDividendSetting()`

---

### File: `providers/transactions/revenue_provider.dart` (230 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `RevenueProvider`

**Fungsi Utama Terdeteksi:**
- `updateToken()`
- `syncReportYear()`
- `setReportYear()`
- `loadRevenues()`
- `fetchRevenueCombineGroups()`
- `createRevenue()`
- `updateRevenue()`
- `deleteRevenue()`
- `createRevenueCombineGroup()`
- `deleteRevenueCombineGroup()`

---

## Folder: `screens/advance`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/advance/advance_detail_actions.dart` (782 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `AdvanceDetailActionsExt`

**Fungsi Utama Terdeteksi:**
- `showGlobalSnackBar()`
- `moveToDraft()`
- `approveAdvance()`
- `rejectItem()`
- `fetchBadgeCounts()`
- `deleteItem()`
- `downloadReceipt()`
- `submitAdvance()`
- `bulkDeleteItems()`
- `buildSaveChecklistButton()`
- `approveItem()`
- `exportAdvanceExcel()`
- `canEditCurrentRevision()`
- `canApproveAdvanceItems()`
- `canSubmitAdvanceItems()`
- *(dan 1 fungsi lainnya...)*

---

### File: `screens/advance/advance_detail_previews.dart` (405 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailPreviewsExt`

**Fungsi Utama Terdeteksi:**
- `buildPreviewRow()`
- `showAllItemsPreview()`
- `showDisbursementPreview()`
- `showItemPreview()`

---

### File: `screens/advance/advance_detail_screen.dart` (994 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `AdvanceDetailScreen`
- `AdvanceDetailScreenState`

**Fungsi Utama Terdeteksi:**
- `handleMobilePageSelection()`
- `confirmLogout()`
- `dispose()`
- `initState()`
- `handleNotificationTap()`
- `statusColor()`
- `advanceStatusColor()`
- `advanceFundSource()`
- `advanceDisbursementSourceLabel()`
- `collect()`
- `displayAdvanceStatus()`
- `headerText()`
- `displayAdvanceTitle()`
- `toDouble()`
- `updateState()`
- *(dan 3 fungsi lainnya...)*

---

### File: `screens/advance/advances_screen.dart` (793 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `AdvancesScreen`
- `AdvancesScreenState`

**Fungsi Utama Terdeteksi:**
- `handleListScroll()`
- `scrollToTop()`
- `resetFilters()`
- `scheduleAdvanceReload()`
- `canDeleteAdvanceCard()`
- `toggleItemSelection()`
- `bulkDeleteItems()`
- `setState()`
- `loadAnnualAdvanceSummary()`
- `updateState()`
- `reloadAdvances()`
- `pickDateRange()`
- `exportExcel()`
- `exportPdf()`
- `initState()`
- *(dan 5 fungsi lainnya...)*

---

### File: `screens/advance/advances_screen_dialogs.dart` (660 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `AdvancesScreenDialogs`

**Fungsi Utama Terdeteksi:**
- `showStandaloneReturnDialog()`
- `showCreateDialog()`

---

## Folder: `screens/advance/dialogs`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/advance/dialogs/dialog_add_category.dart` (116 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailDialogsExpenseshowAddCategoryDialogExt`

---

### File: `screens/advance/dialogs/dialog_add_item.dart` (913 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `AdvanceDetailDialogsExpenseshowAddItemDialogExt`

**Fungsi Utama Terdeteksi:**
- `showAddItemDialog()`

---

### File: `screens/advance/dialogs/dialog_checklist.dart` (188 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailDialogsGeneralshowChecklistDialogExt`

**Fungsi Utama Terdeteksi:**
- `showChecklistDialog()`
- `buildChecklistTile()`

---

### File: `screens/advance/dialogs/dialog_comments.dart` (13 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailDialogsGeneralshowCommentsDialogExt`

**Fungsi Utama Terdeteksi:**
- `showCommentsDialog()`

---

### File: `screens/advance/dialogs/dialog_disbursement_evidence_cell.dart` (34 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailDialogsGeneralbuildDisbursementEvidenceCellExt`

**Fungsi Utama Terdeteksi:**
- `buildDisbursementEvidenceCell()`

---

### File: `screens/advance/dialogs/dialog_edit_advance.dart` (101 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailDialogsGeneralshowEditAdvanceDialogExt`

**Fungsi Utama Terdeteksi:**
- `showEditAdvanceDialog()`

---

### File: `screens/advance/dialogs/dialog_edit_disbursement.dart` (366 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailDialogsGeneralshowEditDisbursementDialogExt`

**Fungsi Utama Terdeteksi:**
- `showEditDisbursementDialog()`

---

### File: `screens/advance/dialogs/dialog_evidence.dart` (180 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailDialogsGeneralshowEvidenceExt`

**Fungsi Utama Terdeteksi:**
- `showEvidence()`
- `InkWell()`

---

### File: `screens/advance/dialogs/dialog_get_comments_from_notes.dart` (51 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailDialogsGeneralgetCommentsFromNotesExt`

---

### File: `screens/advance/dialogs/dialog_insufficient_balance.dart` (206 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailDialogsGeneralshowInsufficientBalanceDialogExt`

**Fungsi Utama Terdeteksi:**
- `showInsufficientBalanceDialog()`

---

### File: `screens/advance/dialogs/dialog_parse_plain_comments.dart` (28 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailDialogsGeneralparsePlainCommentsExt`

---

### File: `screens/advance/dialogs/dialog_plain_comments.dart` (81 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailDialogsGeneralshowPlainCommentsDialogExt`

**Fungsi Utama Terdeteksi:**
- `showPlainCommentsDialog()`

---

### File: `screens/advance/dialogs/dialog_workflow_timeline.dart` (45 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailDialogsGeneralshowWorkflowTimelineDialogExt`

**Fungsi Utama Terdeteksi:**
- `showWorkflowTimelineDialog()`

---

## Folder: `screens/advance/layouts`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/advance/layouts/advance_detail_layout.dart` (25 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailLayoutExt`

**Fungsi Utama Terdeteksi:**
- `formatItemAmount()`
- `hasUncheckedChecklist()`

---

### File: `screens/advance/layouts/advance_detail_tables.dart` (996 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `AdvanceDetailTablesExt`

**Fungsi Utama Terdeteksi:**
- `buildChecklistTile()`
- `buildPendingRichText()`
- `buildItemsTable()`
- `buildAdvanceFundTransferSection()`

---

## Folder: `screens/advance/widgets`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/advance/widgets/advances_widgets.dart` (4 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvancesWidgetsExt`

---

### File: `screens/advance/widgets/widget_add_comment_button.dart` (31 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailLayoutAddCommentButtonExt`

**Fungsi Utama Terdeteksi:**
- `buildAddCommentButton()`

---

### File: `screens/advance/widgets/widget_advance_detail_actions.dart` (213 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailLayoutAdvanceDetailActionsExt`

---

### File: `screens/advance/widgets/widget_content.dart` (478 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailLayoutContentExt`

**Fungsi Utama Terdeteksi:**
- `buildContent()`

---

### File: `screens/advance/widgets/widget_empty_state.dart` (41 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailLayoutEmptyStateExt`

**Fungsi Utama Terdeteksi:**
- `buildEmptyState()`

---

### File: `screens/advance/widgets/widget_file_list.dart` (165 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailLayoutFileListExt`

---

### File: `screens/advance/widgets/widget_insuff_balance_row.dart` (28 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailLayoutinsuffBalanceRowExt`

**Fungsi Utama Terdeteksi:**
- `insuffBalanceRow()`

---

### File: `screens/advance/widgets/widget_mobile_advance_action_bar.dart` (71 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailLayoutMobileAdvanceActionBarExt`

**Fungsi Utama Terdeteksi:**
- `buildMobileAdvanceActionBar()`

---

### File: `screens/advance/widgets/widget_scrollable_advance_header.dart` (207 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvancesWidgetsScrollableAdvanceHeaderExt`

**Fungsi Utama Terdeteksi:**
- `buildScrollableAdvanceHeader()`

---

### File: `screens/advance/widgets/widget_toggle_button.dart` (82 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvancesWidgetsToggleButtonExt`

**Fungsi Utama Terdeteksi:**
- `buildToggleButton()`

---

### File: `screens/advance/widgets/widget_type_toggle.dart` (57 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvancesWidgetsTypeToggleExt`

**Fungsi Utama Terdeteksi:**
- `buildTypeToggle()`

---

### File: `screens/advance/widgets/widget_warning_box.dart` (20 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvanceDetailLayoutWarningBoxExt`

**Fungsi Utama Terdeteksi:**
- `buildWarningBox()`

---

### File: `screens/advance/widgets/widget_year_summary_card.dart` (70 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AdvancesWidgetsYearSummaryCardExt`

**Fungsi Utama Terdeteksi:**
- `buildYearSummaryCard()`

---

## Folder: `screens/auth`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/auth/loading_screen.dart` (76 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `LoadingScreen`
- `LoadingScreenState`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `dispose()`
- `build()`

---

### File: `screens/auth/login_screen.dart` (661 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `LoginScreen`
- `LoginScreenState`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `loadSavedCredentials()`
- `dispose()`
- `loadServerUrl()`
- `showServerUrlDialog()`
- `login()`
- `navigateToRegister()`
- `showMessage()`
- `handleGoogleLogin()`
- `showForgotPasswordDialog()`
- `StatefulBuilder()`
- `submit()`
- `build()`

---

### File: `screens/auth/login_widget_gmail_login_button.dart` (61 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `GmailLoginButton`

**Fungsi Utama Terdeteksi:**
- `build()`
- `Material()`

---

### File: `screens/auth/login_widget_landscape_intro_panel.dart` (62 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `LandscapeIntroPanel`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/login_widget_landscape_login_content.dart` (124 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `LandscapeLoginContent`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/login_widget_login_brand_icon.dart` (34 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `LoginBrandIcon`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/login_widget_login_button.dart` (41 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `LoginButton`

**Fungsi Utama Terdeteksi:**
- `build()`
- `SizedBox()`

---

### File: `screens/auth/login_widget_login_hint_card.dart` (39 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `LoginHintCard`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/login_widget_password_field.dart` (52 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `PasswordField`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/login_widget_portrait_login_content.dart` (166 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `PortraitLoginContent`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/login_widget_register_link.dart` (33 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `RegisterLink`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/login_widget_username_field.dart` (40 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `UsernameField`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/register_screen.dart` (381 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `RegisterScreen`
- `RegisterScreenState`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `dispose()`
- `register()`
- `build()`

---

### File: `screens/auth/register_widget_back_button.dart` (33 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `CustomBackButton`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/register_widget_company_dropdown.dart` (53 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `CompanyDropdown`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/register_widget_confirm_password_field.dart` (51 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ConfirmPasswordField`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/register_widget_email_field.dart` (42 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `EmailField`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/register_widget_full_name_field.dart` (36 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `FullNameField`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/register_widget_landscape_intro_panel.dart` (63 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `LandscapeIntroPanel`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/register_widget_landscape_register_content.dart` (135 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `LandscapeRegisterContent`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/register_widget_password_field.dart` (50 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `PasswordField`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/register_widget_phone_field.dart` (38 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `PhoneField`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/register_widget_portrait_register_content.dart` (143 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `PortraitRegisterContent`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/register_widget_register_brand_icon.dart` (37 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `RegisterBrandIcon`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/register_widget_register_button.dart` (45 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `RegisterButton`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/register_widget_role_dropdown.dart` (52 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `RoleDropdown`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/register_widget_username_field.dart` (36 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `UsernameField`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/register_widget_workplace_field.dart` (35 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `WorkplaceField`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/auth/server_error_screen.dart` (212 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ServerErrorScreen`
- `ServerErrorScreenState`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `dispose()`
- `showServerUrlDialog()`
- `retry()`
- `build()`

---

## Folder: `screens/dashboard`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/dashboard/dashboard_screen.dart` (204 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `DashboardScreen`
- `_DashboardScreenState`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `_selectCompany()`
- `build()`
- `Wrap()`
- `_buildCompanyCard()`

---

## Folder: `screens/layout`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/layout/main_layout.dart` (474 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `MainLayout`
- `MainLayoutState`

**Fungsi Utama Terdeteksi:**
- `switchToTab()`
- `initState()`
- `_setupNotificationListener()`
- `_onNotificationUpdate()`
- `_showNotificationSnackBar()`
- `dispose()`
- `_fetchBadgeCounts()`
- `_handleNotificationTap()`
- `_confirmLogout()`
- `build()`
- `PopScope()`

---

### File: `screens/layout/main_layout_settlement_list.dart` (835 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `SettlementListView`
- `SettlementListViewState`

**Fungsi Utama Terdeteksi:**
- `handleListScroll()`
- `scrollToTop()`
- `scheduleSettlementReload()`
- `resetFilters()`
- `toggleItemSelection()`
- `bulkDeleteItems()`
- `setState()`
- `initState()`
- `onProviderChange()`
- `dispose()`
- `loadDefaultReportYearAndReload()`
- `loadDashboardSummary()`
- `loadAnnualSettlementSummary()`
- `updateState()`
- `reloadSettlements()`
- *(dan 5 fungsi lainnya...)*

---

### File: `screens/layout/main_layout_settlement_list_dialogs.dart` (697 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `SettlementListDialogs`

**Fungsi Utama Terdeteksi:**
- `showStandaloneReturnDialog()`
- `showCreateDialog()`

---

### File: `screens/layout/main_layout_widgets.dart` (108 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `DashboardWidgetsExt`
- `_FilterChipWidget`
- `StatusFilterChip`

**Fungsi Utama Terdeteksi:**
- `deleteSettlement()`
- `build()`

---

## Folder: `screens/main_layout_components`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/main_layout_components/widget_summary_cards.dart` (90 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `WidgetSummaryCards`

**Fungsi Utama Terdeteksi:**
- `build()`

---

## Folder: `screens/management`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/management/asset_management_screen.dart` (414 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AssetManagementScreen`
- `AssetManagementScreenState`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `dispose()`
- `loadData()`
- `clampInput()`
- `displayDate()`
- `confirmDelete()`
- `build()`

---

### File: `screens/management/bank_advance_screen.dart` (1064 baris)
- **Peringatan Kritis:** File ini tergolong "Monster File" (>1000 baris). Mengubahnya memiliki risiko regresi tinggi. Disarankan untuk memecah komponen ke sub-widget terpisah.

**Classes/Widgets:**
- `BankAdvanceScreen`
- `BankAdvanceScreenState`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `dispose()`
- `loadData()`
- `showManageBalanceDialog()`
- `getBankSortIndex()`
- `getTotalAllocation()`
- `build()`

---

### File: `screens/management/bank_management_screen.dart` (148 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `BankManagementScreen`
- `BankManagementScreenState`

**Fungsi Utama Terdeteksi:**
- `updateState()`
- `loadPreferenceOrders()`
- `initState()`
- `dispose()`
- `build()`

---

### File: `screens/management/bank_management_screen_actions.dart` (164 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `BankManagementActionsExt`

**Fungsi Utama Terdeteksi:**
- `loadData()`
- `loadAdvanceData()`
- `displayDate()`
- `getBankSortIndex()`

---

### File: `screens/management/bank_management_screen_layout.dart` (5 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `BankManagementLayoutExt`

---

### File: `screens/management/bank_management_screen_tables.dart` (24 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `BankManagementTablesExt`

**Fungsi Utama Terdeteksi:**
- `buildLogGridItem()`

---

### File: `screens/management/bank_status_screen.dart` (602 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `BankStatusScreen`
- `BankStatusScreenState`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `loadData()`
- `displayDate()`
- `getBankSortIndex()`
- `showTransactionDialog()`
- `deleteTransaction()`
- `build()`
- `buildBankFilter()`

---

### File: `screens/management/category_management_screen.dart` (797 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `CategoryManagementView`
- `CategoryManagementViewState`

**Fungsi Utama Terdeteksi:**
- `dispose()`
- `initState()`
- `build()`
- `LayoutBuilder()`
- `buildCategoryTile()`
- `buildPendingItem()`
- `showAddCategoryDialog()`
- `showEditCategoryDialog()`
- `deleteCategory()`
- `approveCategory()`

---

### File: `screens/management/category_tabular_screen.dart` (674 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `CategoryTabularScreen`
- `CategoryTabularScreenState`

**Fungsi Utama Terdeteksi:**
- `dispose()`
- `initState()`
- `loadData()`
- `saveChanges()`
- `showSnackBar()`
- `build()`
- `saveAllGroupsAndCategories()`
- `showManageGroupsDialog()`
- `addGroup()`
- `editGroup()`
- `deleteGroup()`
- `syncTempCatsOrderDynamic()`

---

### File: `screens/management/dialog_advance_log_book.dart` (709 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `BankManagementDialogsshowAdvanceLogBookDialogExt`
- `AdvanceLogBookModal`
- `_AdvanceLogBookModalState`

**Fungsi Utama Terdeteksi:**
- `showAdvanceLogBookDialogHelper()`
- `initState()`
- `dispose()`
- `fetchLogs()`
- `buildLogGridItem()`
- `buildAuditTrailLogItem()`
- `build()`

---

### File: `screens/management/dialog_bank_account.dart` (529 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `BankManagementDialogsshowBankAccountDialogExt`

**Fungsi Utama Terdeteksi:**
- `showBankAccountDialog()`
- `Builder()`
- `_showDeleteConfirmation()`
- `StatefulBuilder()`

---

### File: `screens/management/dialog_bank_advance_detail.dart` (422 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `BankManagementDialogsshowBankAdvanceDetailModalExt`

**Fungsi Utama Terdeteksi:**
- `showBankAdvanceDetailModal()`

---

### File: `screens/management/dialog_bank_cash_detail.dart` (174 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `BankManagementDialogsshowBankCashDetailModalExt`

**Fungsi Utama Terdeteksi:**
- `showBankCashDetailModal()`

---

### File: `screens/management/dialog_bank_cash_log_book.dart` (501 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `BankManagementDialogsshowBankCashLogBookDialogExt`

**Fungsi Utama Terdeteksi:**
- `showBankCashLogBookDialog()`
- `AppScrollbar()`

---

### File: `screens/management/dialog_edit_advance_balance.dart` (500 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `BankManagementDialogsshowEditAdvanceBalanceDialogExt`

**Fungsi Utama Terdeteksi:**
- `showEditAdvanceBalanceDialog()`
- `getTotalAllocation()`

---

### File: `screens/management/dialog_edit_advance_opening_balance.dart` (237 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `BankManagementDialogsshowEditAdvanceOpeningBalanceDialogExt`

**Fungsi Utama Terdeteksi:**
- `showEditAdvanceOpeningBalanceDialog()`

---

### File: `screens/management/dividend_management_screen.dart` (679 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `DividendManagementScreen`
- `DividendManagementScreenState`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `dispose()`
- `loadData()`
- `toDouble()`
- `fmtMoney()`
- `formatForInput()`
- `showRecipientDialog()`
- `pickDate()`
- `saveProfitRetained()`
- `deleteDividend()`
- `textField()`
- `buildCalculationCard()`
- `metric()`
- `LayoutBuilder()`
- `build()`

---

### File: `screens/management/logbook_screen.dart` (704 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `LogbookScreen`
- `LogbookScreenState`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `fetchLogs()`
- `buildLogGridItem()`
- `buildAuditTrailLogItem()`
- `build()`

---

### File: `screens/management/revenue_management_screen.dart` (655 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `RevenueManagementScreen`
- `RevenueManagementScreenState`

**Fungsi Utama Terdeteksi:**
- `updateState()`
- `initState()`
- `build()`
- `Column()`

---

### File: `screens/management/revenue_management_screen_actions.dart` (924 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `RevenueManagementActionsExt`

**Fungsi Utama Terdeteksi:**
- `displayDate()`
- `loadData()`
- `saveRevenue()`
- `deleteRevenue()`
- `itemId()`
- `manageRevenueCombine()`
- `showDialog()`
- `StatefulBuilder()`
- `Flexible()`
- `startCombineWizard()`
- `isRowAvailable()`
- `releaseSelectedRevenueCombine()`
- `textField()`
- `numberField()`

---

### File: `screens/management/revenue_management_screen_dialogs.dart` (505 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `RevenueManagementDialogsExt`

**Fungsi Utama Terdeteksi:**
- `formatNumericInput()`
- `showRevenueDialog()`
- `recalcDualCurrency()`
- `pickDate()`
- `showConfirmDialog()`

---

### File: `screens/management/revenue_management_screen_tables.dart` (53 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `RevenueManagementTablesExt`

**Fungsi Utama Terdeteksi:**
- `buildCell()`

---

### File: `screens/management/tax_management_screen.dart` (687 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `TaxManagementScreen`
- `TaxManagementScreenState`

**Fungsi Utama Terdeteksi:**
- `updateState()`
- `initState()`
- `build()`
- `Column()`

---

### File: `screens/management/tax_management_screen_actions.dart` (912 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `TaxManagementActionsExt`

**Fungsi Utama Terdeteksi:**
- `displayDate()`
- `loadData()`
- `saveTax()`
- `deleteTax()`
- `itemId()`
- `manageTaxCombine()`
- `showDialog()`
- `StatefulBuilder()`
- `Flexible()`
- `startTaxCombineWizard()`
- `isRowAvailable()`
- `releaseSelectedTaxCombine()`
- `textField()`
- `numberField()`
- `fmtMoney()`

---

### File: `screens/management/tax_management_screen_dialogs.dart` (292 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `TaxManagementDialogsExt`

**Fungsi Utama Terdeteksi:**
- `formatNumericInput()`
- `showTaxDialog()`
- `pickDate()`
- `StatefulBuilder()`
- `showConfirmDialog()`

---

### File: `screens/management/tax_management_screen_tables.dart` (53 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `TaxManagementTablesExt`

**Fungsi Utama Terdeteksi:**
- `buildCell()`

---

### File: `screens/management/widget_advance_section.dart` (495 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `BankManagementLayoutAdvanceSectionExt`

**Fungsi Utama Terdeteksi:**
- `buildAdvanceSection()`
- `Builder()`

---

### File: `screens/management/widget_audit_trail_log_item.dart` (603 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `BankManagementLayoutAuditTrailLogItemExt`

**Fungsi Utama Terdeteksi:**
- `buildAuditTrailLogItem()`

---

### File: `screens/management/widget_bank_accounts_tab.dart` (246 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `BankManagementLayoutBankAccountsTabExt`

**Fungsi Utama Terdeteksi:**
- `buildBankAccountsTab()`

---

### File: `screens/management/widget_group_management_dialog.dart` (234 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `CategoryTabularScreenGroupManagementDialogExt`

**Fungsi Utama Terdeteksi:**
- `showGroupManagementDialog()`
- `moveItem()`
- `buildKanbanContent()`

---

### File: `screens/management/widget_kanban_column_dynamic.dart` (131 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `CategoryTabularScreenKanbanColumnDynamicExt`

---

### File: `screens/management/widget_section_toggle.dart` (203 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `BankManagementLayoutSectionToggleExt`

**Fungsi Utama Terdeteksi:**
- `buildSectionToggle()`

---

### File: `screens/management/widget_simple_category_card.dart` (104 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `CategoryTabularScreenSimpleCategoryCardExt`

**Fungsi Utama Terdeteksi:**
- `buildSimpleCategoryCard()`

---

### File: `screens/management/widget_toggle_button.dart` (52 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `BankManagementLayoutToggleButtonExt`

**Fungsi Utama Terdeteksi:**
- `buildToggleButton()`

---

## Folder: `screens/management/dialogs`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/management/dialogs/dialog_asset_form.dart` (376 baris)
- File ini berukuran ringkas/standar.

**Fungsi Utama Terdeteksi:**
- `showAssetDialog()`
- `calculatePreview()`
- `parseVal()`

---

### File: `screens/management/dialogs/dialog_ndpv_table.dart` (156 baris)
- File ini berukuran ringkas/standar.

**Fungsi Utama Terdeteksi:**
- `showNdpvTable()`

---

## Folder: `screens/manager`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/manager/manager_dashboard_screen.dart` (455 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ManagerDashboardScreen`
- `_ManagerDashboardScreenState`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `dispose()`
- `build()`
- `_buildSettlementsForApproval()`
- `_buildAdvancesForApproval()`
- `_showAdvanceApprovalDialog()`
- `_showInsufficientBalanceDialog()`
- `_balanceRow()`

---

### File: `screens/manager/manager_settlement_detail_screen.dart` (660 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `ManagerSettlementDetailScreen`
- `_ManagerSettlementDetailScreenState`

**Fungsi Utama Terdeteksi:**
- `_toDouble()`
- `_formatExpenseAmount()`
- `initState()`
- `build()`
- `_editExpense()`
- `_deleteExpense()`
- `_showManagerEditExpenseDialog()`
- `_buildApprovalActions()`
- `_getStatusColor()`
- `_getIconForStatus()`
- `_approveExpense()`
- `setState()`
- `_rejectExpense()`
- `_approveAll()`
- `_rejectAll()`
- *(dan 1 fungsi lainnya...)*

---

## Folder: `screens/manager/widgets`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/manager/widgets/widget_manager_approval_table.dart` (181 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `WidgetManagerApprovalTable`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/manager/widgets/widget_manager_summary_cards.dart` (58 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `WidgetManagerSummaryCards`

**Fungsi Utama Terdeteksi:**
- `build()`

---

## Folder: `screens/reports`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/reports/report_screen.dart` (780 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `ReportScreen`
- `_ReportScreenState`

**Fungsi Utama Terdeteksi:**
- `dispose()`
- `initState()`
- `_onProviderChange()`
- `_loadSummary()`
- `_pickDateRange()`
- `build()`
- `_buildHeaderInfo()`
- `_buildActions()`
- `Row()`
- `_buildSummaryCell()`
- `_buildSummaryTableScrollableBody()`
- `SizedBox()`
- `_exportFullExcel()`
- `_exportSummaryPdf()`
- `_fmtDate()`
- *(dan 1 fungsi lainnya...)*

---

## Folder: `screens/reports/annual_report`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/reports/annual_report/annual_report_helpers.dart` (142 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AnnualReportHelpersExt`

**Fungsi Utama Terdeteksi:**
- `toDouble()`
- `fmtMoney()`
- `fmtPlain()`
- `fmtAmount()`
- `normalizeCurrency()`
- `fmtDate()`
- `extractBatchNumber()`
- `isBatchSettlement()`
- `extractNoteSubcategory()`
- `subcategorySortBucket()`
- `expenseSubcategoryLabel()`

---

### File: `screens/reports/annual_report/annual_report_screen.dart` (915 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `AnnualReportScreen`
- `AnnualReportScreenState`

**Fungsi Utama Terdeteksi:**
- `updateState()`
- `initState()`
- `onProviderChange()`
- `dispose()`
- `syncScroll()`
- `syncHorizontal()`
- `fetchCategories()`
- `loadDefaultReportYearAndFetch()`
- `fetchReport()`
- `pickDateRange()`
- `exportExcel()`
- `applySheet()`
- `toggleTableVisibility()`
- `showUnavailableInputMessage()`
- `handleInputMenuSelection()`
- *(dan 5 fungsi lainnya...)*

---

### File: `screens/reports/annual_report/annual_report_state.dart` (25 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ReportTableData`

---

### File: `screens/reports/annual_report/annual_report_tables.dart` (738 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `AnnualReportTablesExt`

**Fungsi Utama Terdeteksi:**
- `mergeInto()`
- `addExpenseGroup()`
- `isNumericLikeCell()`

---

### File: `screens/reports/annual_report/annual_report_widgets.dart` (5 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AnnualReportWidgetsExt`

---

### File: `screens/reports/annual_report/widget_all_tables.dart` (301 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AnnualReportTablesAllTablesExt`

**Fungsi Utama Terdeteksi:**
- `processAllTables()`

---

### File: `screens/reports/annual_report/widget_bank_expense_table.dart` (350 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AnnualReportTablesBankExpenseTableExt`

---

### File: `screens/reports/annual_report/widget_cache_info.dart` (40 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AnnualReportWidgetsCacheInfoExt`

**Fungsi Utama Terdeteksi:**
- `buildCacheInfo()`

---

### File: `screens/reports/annual_report/widget_card.dart` (51 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AnnualReportWidgetsCardExt`

**Fungsi Utama Terdeteksi:**
- `buildCard()`

---

### File: `screens/reports/annual_report/widget_display_tables.dart` (335 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AnnualReportWidgetsDisplayTablesExt`

---

### File: `screens/reports/annual_report/widget_evidence_button.dart` (44 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AnnualReportWidgetsEvidenceButtonExt`

**Fungsi Utama Terdeteksi:**
- `buildEvidenceButton()`

---

### File: `screens/reports/annual_report/widget_expense_table_cell.dart` (88 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AnnualReportWidgetsExpenseTableCellExt`

**Fungsi Utama Terdeteksi:**
- `buildExpenseTableCell()`

---

### File: `screens/reports/annual_report/widget_report_header.dart` (199 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AnnualReportWidgetsReportHeaderExt`

**Fungsi Utama Terdeteksi:**
- `buildReportHeader()`

---

### File: `screens/reports/annual_report/widget_show_evidence_popup.dart` (151 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AnnualReportWidgetsshowEvidencePopupExt`

**Fungsi Utama Terdeteksi:**
- `showEvidencePopup()`

---

### File: `screens/reports/annual_report/widget_status_cell.dart` (29 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AnnualReportWidgetsStatusCellExt`

**Fungsi Utama Terdeteksi:**
- `buildStatusCell()`

---

### File: `screens/reports/annual_report/widget_summary_cards.dart` (50 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AnnualReportWidgetsSummaryCardsExt`

**Fungsi Utama Terdeteksi:**
- `buildSummaryCards()`

---

### File: `screens/reports/annual_report/widget_table4_a_and4_b.dart` (428 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AnnualReportTablesTable4AAnd4BExt`

**Fungsi Utama Terdeteksi:**
- `processTable4AAnd4B()`
- `getFilteredCatIndex()`

---

### File: `screens/reports/annual_report/widget_table4_c_and4_d.dart` (423 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AnnualReportTablesTable4CAnd4DExt`

**Fungsi Utama Terdeteksi:**
- `processTable4CAnd4D()`
- `getFilteredCatIndex()`

---

### File: `screens/reports/annual_report/widget_table_card.dart` (649 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `AnnualReportWidgetsTableCardExt`

**Fungsi Utama Terdeteksi:**
- `buildTableCard()`
- `Builder()`
- `SizedBox()`
- `Column()`

---

### File: `screens/reports/annual_report/widget_tax_toggle_cell.dart` (27 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AnnualReportWidgetsTaxToggleCellExt`

**Fungsi Utama Terdeteksi:**
- `buildTaxToggleCell()`

---

## Folder: `screens/scratch`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/scratch/main_layout_combined.dart` (2377 baris)
- **Peringatan Kritis:** File ini tergolong "Monster File" (>1000 baris). Mengubahnya memiliki risiko regresi tinggi. Disarankan untuk memecah komponen ke sub-widget terpisah.

**Classes/Widgets:**
- `MainLayout`
- `MainLayoutState`
- `_DashboardWidgetsExt`
- `_FilterChipWidget`
- `StatusFilterChip`
- `_MainLayoutWidgetsTypeToggleExt`
- `_MainLayoutWidgetsToggleButtonExt`
- `_MainLayoutWidgetsScrollableSettlementHeaderExt`
- `_MainLayoutWidgetsSummaryCardsExt`
- `_SettlementListView`
- `_SettlementListViewState`
- `_SettlementListDialogs`

**Fungsi Utama Terdeteksi:**
- `switchToTab()`
- `initState()`
- `_setupNotificationListener()`
- `_onNotificationUpdate()`
- `_showNotificationSnackBar()`
- `dispose()`
- `_fetchBadgeCounts()`
- `_handleNotificationTap()`
- `_confirmLogout()`
- `build()`
- `PopScope()`
- `_deleteSettlement()`
- `_buildTypeToggle()`
- `_buildToggleButton()`
- `_buildScrollableSettlementHeader()`
- *(dan 21 fungsi lainnya...)*

---

## Folder: `screens/settings`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/settings/balance_sheet_settings_screen.dart` (371 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `BalanceSheetSettingsScreen`
- `BalanceSheetSettingsScreenState`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `dispose()`
- `loadData()`
- `toDouble()`
- `formatPlain()`
- `saveSettings()`
- `field()`
- `build()`

---

### File: `screens/settings/data_cleanup_screen.dart` (616 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `DataCleanupScreen`
- `DataCleanupScreenState`

**Fungsi Utama Terdeteksi:**
- `dispose()`
- `nextPage()`
- `prevPage()`
- `fetchPreview()`
- `executeCleanup()`
- `showError()`
- `isNextEnabled()`
- `build()`
- `buildProgressIndicator()`
- `buildYearSelection()`
- `buildModuleSelection()`
- `buildPreviewStep()`
- `buildConfirmationStep()`
- `buildSelectionCard()`
- `buildBottomNav()`

---

### File: `screens/settings/deadline_manager_screen.dart` (416 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `DeadlineManagerScreen`
- `DeadlineRuleConfig`
- `DeadlineManagerScreenState`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `loadDeadlineSettings()`
- `saveSetting()`
- `showAddDayDialog()`
- `removeDay()`
- `build()`
- `buildHeaderInfo()`
- `buildModernRuleCard()`
- `buildDayChip()`

---

### File: `screens/settings/dialog_custom_bank_order.dart` (584 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `DialogCustomBankOrder`
- `_DialogCustomBankOrderState`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `dispose()`
- `_loadData()`
- `_saveOrder()`
- `_resetOrder()`
- `build()`
- `_buildCashReorderList()`
- `_buildAdvanceReorderList()`
- `_getTemplateSortIndex()`

---

### File: `screens/settings/settings_screen.dart` (531 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `SettingsScreen`
- `SettingsScreenState`
- `EditProfileDialog`
- `EditProfileDialogState`

**Fungsi Utama Terdeteksi:**
- `updateState()`
- `initState()`
- `dispose()`
- `build()`
- `pickImage()`
- `submit()`

---

### File: `screens/settings/settings_screen_actions.dart` (387 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettingsActionsExt`

**Fungsi Utama Terdeteksi:**
- `loadSettings()`
- `saveSettings()`
- `saveReportYearSettings()`
- `exportDatabase()`
- `importDatabase()`
- `confirmImport()`
- `showAccountList()`
- `toggleManagerSection()`
- `profileColumn()`

---

### File: `screens/settings/settings_screen_dialogs.dart` (135 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettingsDialogsExt`

**Fungsi Utama Terdeteksi:**
- `showImportPreviewDialog()`
- `showEditProfileDialog()`

---

### File: `screens/settings/settings_screen_layout.dart` (5 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettingsLayoutExt`

---

### File: `screens/settings/widget_bank_advance_widget.dart` (394 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettingsLayoutBankAdvanceWidgetExt`

**Fungsi Utama Terdeteksi:**
- `buildBankAdvanceWidget()`
- `GestureDetector()`

---

### File: `screens/settings/widget_bank_order_settings_card.dart` (66 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettingsLayoutBankOrderSettingsCardExt`

**Fungsi Utama Terdeteksi:**
- `buildBankOrderSettingsCard()`

---

### File: `screens/settings/widget_cleanup_settings_card.dart` (70 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettingsLayoutCleanupSettingsCardExt`

**Fungsi Utama Terdeteksi:**
- `buildCleanupSettingsCard()`

---

### File: `screens/settings/widget_database_settings_card.dart` (115 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettingsLayoutDatabaseSettingsCardExt`

**Fungsi Utama Terdeteksi:**
- `buildDatabaseSettingsCard()`

---

### File: `screens/settings/widget_deadline_settings_card.dart` (69 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettingsLayoutDeadlineSettingsCardExt`

**Fungsi Utama Terdeteksi:**
- `buildDeadlineSettingsCard()`

---

### File: `screens/settings/widget_logbook_button.dart` (43 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettingsLayoutLogbookButtonExt`

**Fungsi Utama Terdeteksi:**
- `buildLogbookButton()`

---

### File: `screens/settings/widget_manager_section.dart` (109 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettingsLayoutManagerSectionExt`

**Fungsi Utama Terdeteksi:**
- `buildManagerSection()`

---

### File: `screens/settings/widget_profile_card.dart` (259 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettingsLayoutProfileCardExt`

**Fungsi Utama Terdeteksi:**
- `buildProfileCard()`

---

### File: `screens/settings/widget_report_year_settings_card.dart` (89 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettingsLayoutReportYearSettingsCardExt`

**Fungsi Utama Terdeteksi:**
- `buildReportYearSettingsCard()`

---

### File: `screens/settings/widget_storage_settings_card.dart` (64 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettingsLayoutStorageSettingsCardExt`

**Fungsi Utama Terdeteksi:**
- `buildStorageSettingsCard()`

---

### File: `screens/settings/widget_theme_settings_card.dart` (83 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettingsLayoutThemeSettingsCardExt`

**Fungsi Utama Terdeteksi:**
- `buildThemeSettingsCard()`

---

## Folder: `screens/settlement`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/settlement/settlement_detail_actions.dart` (940 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `SettlementDetailActionsExt`

**Fungsi Utama Terdeteksi:**
- `approveTable1()`
- `approveSettlement()`
- `handleNotificationTap()`
- `downloadReceipt()`
- `showGlobalSnackBar()`
- `deleteExpense()`
- `moveToDraft()`
- `buildSaveChecklistButton()`
- `submitSettlement()`
- `exportSettlementExcel()`
- `rejectSettlement()`
- `fetchBadgeCounts()`
- `approveExpense()`
- `bulkDeleteExpenses()`
- `confirmLogout()`
- *(dan 2 fungsi lainnya...)*

---

### File: `screens/settlement/settlement_detail_previews.dart` (503 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `SettlementDetailPreviewsExt`

**Fungsi Utama Terdeteksi:**
- `showItemPreview()`
- `showAllItemsPreview()`
- `StatefulBuilder()`
- `buildPreviewRow()`
- `buildDisbursementPreviewContent()`
- `buildAllItemsPreviewList()`
- `showDisbursementPreview()`

---

### File: `screens/settlement/settlement_detail_screen.dart` (1203 baris)
- **Peringatan Kritis:** File ini tergolong "Monster File" (>1000 baris). Mengubahnya memiliki risiko regresi tinggi. Disarankan untuk memecah komponen ke sub-widget terpisah.

**Classes/Widgets:**
- `SettlementDetailScreen`
- `SettlementDetailScreenState`

**Fungsi Utama Terdeteksi:**
- `dispose()`
- `initState()`
- `getStatusColor()`
- `toDouble()`
- `formatExpenseAmount()`
- `displaySettlementStatus()`
- `expenseFundSource()`
- `settlementDisbursementSourceLabel()`
- `collect()`
- `settlementReimbursementAmount()`
- `buildDisbursementDataRow()`
- `displaySettlementTitle()`
- `hasUncheckedChecklist()`
- `canSubmitSettlementItems()`
- `canApproveSettlementItems()`
- *(dan 4 fungsi lainnya...)*

---

## Folder: `screens/settlement/dialogs`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/settlement/dialogs/dialog_add_category.dart` (118 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementDetailDialogsExpenseshowAddCategoryDialogExt`

---

### File: `screens/settlement/dialogs/dialog_add_expense.dart` (1286 baris)
- **Peringatan Kritis:** File ini tergolong "Monster File" (>1000 baris). Mengubahnya memiliki risiko regresi tinggi. Disarankan untuk memecah komponen ke sub-widget terpisah.

**Classes/Widgets:**
- `SettlementDetailDialogsExpenseshowAddExpenseDialogExt`

**Fungsi Utama Terdeteksi:**
- `showAddExpenseDialog()`
- `calculateRemainingForSource()`
- `StatefulBuilder()`

---

### File: `screens/settlement/dialogs/dialog_checklist.dart` (203 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementDetailDialogsGeneralshowChecklistDialogExt`

**Fungsi Utama Terdeteksi:**
- `showChecklistDialog()`
- `buildChecklistTile()`

---

### File: `screens/settlement/dialogs/dialog_comments.dart` (18 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementDetailDialogsGeneralshowCommentsDialogExt`

**Fungsi Utama Terdeteksi:**
- `showCommentsDialog()`

---

### File: `screens/settlement/dialogs/dialog_edit_disbursement.dart` (423 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementDetailDialogsGeneralshowEditDisbursementDialogExt`

**Fungsi Utama Terdeteksi:**
- `showEditDisbursementDialog()`

---

### File: `screens/settlement/dialogs/dialog_edit_expense.dart` (1235 baris)
- **Peringatan Kritis:** File ini tergolong "Monster File" (>1000 baris). Mengubahnya memiliki risiko regresi tinggi. Disarankan untuk memecah komponen ke sub-widget terpisah.

**Classes/Widgets:**
- `SettlementDetailDialogsExpenseshowEditExpenseDialogExt`

**Fungsi Utama Terdeteksi:**
- `showEditExpenseDialog()`
- `calculateRemainingForSource()`
- `StatefulBuilder()`

---

### File: `screens/settlement/dialogs/dialog_edit_settlement.dart` (128 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementDetailDialogsGeneralshowEditSettlementDialogExt`

**Fungsi Utama Terdeteksi:**
- `showEditSettlementDialog()`

---

### File: `screens/settlement/dialogs/dialog_evidence.dart` (186 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementDetailDialogsGeneralshowEvidenceExt`

**Fungsi Utama Terdeteksi:**
- `showEvidence()`
- `InkWell()`

---

### File: `screens/settlement/dialogs/dialog_plain_comments.dart` (86 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementDetailDialogsGeneralshowPlainCommentsDialogExt`

**Fungsi Utama Terdeteksi:**
- `showPlainCommentsDialog()`

---

## Folder: `screens/settlement/layouts`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/settlement/layouts/settlement_detail_layout.dart` (518 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `SettlementDetailLayoutExt`

**Fungsi Utama Terdeteksi:**
- `buildMobileSettlementActionBar()`
- `buildContent()`
- `headerText()`
- `buildAddCommentButton()`
- `buildEmptyState()`
- `buildPendingRichText()`
- `buildTabButton()`

---

### File: `screens/settlement/layouts/settlement_detail_tables.dart` (360 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementDetailTablesExt`

**Fungsi Utama Terdeteksi:**
- `buildFundTransferSection()`
- `buildActionCell()`
- `buildChecklistTile()`

---

## Folder: `screens/settlement/widgets`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/settlement/widgets/widget_expense_form_fields.dart` (63 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `WidgetExpenseFormFields`

**Fungsi Utama Terdeteksi:**
- `buildDescriptionField()`
- `buildAmountField()`
- `buildExchangeRateField()`

---

### File: `screens/settlement/widgets/widget_file_list.dart` (84 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementDetailFileListExt`

---

### File: `screens/settlement/widgets/widget_insuff_balance_row.dart` (33 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementDetailinsuffBalanceRowExt`

**Fungsi Utama Terdeteksi:**
- `insuffBalanceRow()`

---

### File: `screens/settlement/widgets/widget_insufficient_balance_dialog.dart` (156 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementDetailInsufficientBalanceDialogExt`

**Fungsi Utama Terdeteksi:**
- `showInsufficientBalanceDialog()`

---

### File: `screens/settlement/widgets/widget_settlement_detail_actions.dart` (180 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SettlementDetailSettlementDetailActionsExt`

---

### File: `screens/settlement/widgets/widget_settlement_expense_table.dart` (404 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `WidgetSettlementExpenseTable`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/settlement/widgets/widget_settlement_summary_cards.dart` (226 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `WidgetSettlementSummaryCards`

**Fungsi Utama Terdeteksi:**
- `toDouble()`
- `build()`
- `LayoutBuilder()`

---

## Folder: `screens/widgets`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens/widgets/common_widgets.dart` (11 baris)
- File ini berukuran ringkas/standar.

---

### File: `screens/widgets/page_selector.dart` (210 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `PageSelector`

**Fungsi Utama Terdeteksi:**
- `_getPageName()`
- `build()`

---

### File: `screens/widgets/settlement_detail_widgets.dart` (180 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `SummaryCard`
- `SettlementActionButton`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `screens/widgets/transaction_cards.dart` (751 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `SettlementCard`
- `_SettlementCardState`
- `AdvanceCard`
- `_AdvanceCardState`
- `StatusBadge`
- `AppRadioGroup`
- `_AppRadioGroupScope`
- `AppRadioItem`

**Fungsi Utama Terdeteksi:**
- `_getDisplayTitle()`
- `_statusColor()`
- `_getRoleName()`
- `_getDateDisplay()`
- `build()`
- `_advanceStatusColor()`

---

### File: `screens/widgets/widget_scrollable_settlement_header.dart` (204 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `MainLayoutWidgetsScrollableSettlementHeaderExt`

**Fungsi Utama Terdeteksi:**
- `buildScrollableSettlementHeader()`
- `CascadingYearFilter()`

---

### File: `screens/widgets/widget_summary_cards.dart` (71 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `MainLayoutWidgetsSummaryCardsExt`

**Fungsi Utama Terdeteksi:**
- `buildSummaryCards()`

---

### File: `screens/widgets/widget_toggle_button.dart` (84 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `MainLayoutWidgetsToggleButtonExt`

**Fungsi Utama Terdeteksi:**
- `buildToggleButton()`

---

### File: `screens/widgets/widget_type_toggle.dart` (64 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `MainLayoutWidgetsTypeToggleExt`

**Fungsi Utama Terdeteksi:**
- `buildTypeToggle()`

---

## Folder: `services`

**Tujuan Folder:** Menangani komunikasi ke luar, seperti pemanggilan API ke backend (HTTP requests).

### File: `services/api_advances.dart` (711 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `ApiServiceAdvancesExt`

---

### File: `services/api_assets.dart` (57 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ApiServiceAssetsExt`

---

### File: `services/api_auth.dart` (166 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ApiServiceAuthExt`

---

### File: `services/api_banks.dart` (234 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ApiServiceBanksExt`

---

### File: `services/api_categories.dart` (133 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ApiServiceCategoriesExt`

---

### File: `services/api_companies.dart` (65 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ApiServiceCompaniesExt`

---

### File: `services/api_database.dart` (120 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ApiServiceDatabaseExt`

**Fungsi Utama Terdeteksi:**
- `getStorageSettings()`
- `updateStorageSettings()`
- `syncDatabase()`

---

### File: `services/api_dividends.dart` (61 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ApiServiceDividendsExt`

---

### File: `services/api_expenses.dart` (155 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ApiServiceExpensesExt`

---

### File: `services/api_master.dart` (155 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ApiServiceMasterExt`

**Fungsi Utama Terdeteksi:**
- `setToken()`
- `setCompany()`
- `getEvidenceUrl()`
- `networkHint()`

---

### File: `services/api_reports.dart` (238 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ApiServiceReportsExt`

**Fungsi Utama Terdeteksi:**
- `getReportYearSettings()`
- `updateReportYearSettings()`

---

### File: `services/api_revenues.dart` (105 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ApiServiceRevenuesExt`

---

### File: `services/api_service.dart` (196 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ApiService`

**Fungsi Utama Terdeteksi:**
- `buildUrl()`
- `loadSavedBaseUrl()`
- `saveBaseUrl()`
- `checkConnectivity()`
- `loadTokenFromStorage()`
- `ensureTokenLoaded()`

---

### File: `services/api_settlements.dart` (453 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ApiServiceSettlementsExt`

---

### File: `services/api_taxes.dart` (97 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ApiServiceTaxesExt`

---

### File: `services/api_users.dart` (112 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ApiServiceUsersExt`

---

### File: `services/bank_order_preferences.dart` (161 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `BankOrderPreferences`

**Fungsi Utama Terdeteksi:**
- `saveBankCashOrder()`
- `resetBankCashOrder()`
- `saveBankAdvanceOrder()`
- `resetBankAdvanceOrder()`
- `getBankCashSortMode()`
- `saveBankCashSortMode()`
- `getBankAdvanceSortMode()`
- `saveBankAdvanceSortMode()`
- `getTemplateSortIndex()`
- `compareBankNames()`
- `_extractId()`
- `sortBankMaps()`

---

### File: `services/notification_service.dart` (162 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `NotificationService`

---

## Folder: `theme`

**Tujuan Folder:** Berisi konfigurasi dasar aplikasi atau inisialisasi awal.

### File: `theme/app_theme.dart` (369 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AppSpacing`
- `AppBorderRadius`
- `AppFontSize`
- `AppTheme`

**Fungsi Utama Terdeteksi:**
- `getSurfaceColor()`
- `getCardColor()`
- `getTextColor()`
- `getSecondaryTextColor()`
- `getDividerColor()`
- `getCreamColor()`

---

## Folder: `utils`

**Tujuan Folder:** Fungsi bantuan, formatter, helper tanggal/uang, dan konstanta aplikasi.

### File: `utils/app_dialogs.dart` (340 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AppDialogs`

**Fungsi Utama Terdeteksi:**
- `InkWell()`
- `showExitConfirmation()`
- `showConfirmDialog()`

---

### File: `utils/app_formatters.dart` (120 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AppFormatters`

**Fungsi Utama Terdeteksi:**
- `formatDateForApi()`
- `formatDateForDisplay()`
- `formatDateForFilename()`
- `formatDateTime()`
- `formatCurrency()`
- `formatCurrencyPlain()`
- `_toDouble()`
- `formatTimestamp()`

---

### File: `utils/app_logger.dart` (13 baris)
- File ini berukuran ringkas/standar.

---

### File: `utils/app_snackbar.dart` (44 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AppSnackbar`

---

### File: `utils/context_extensions.dart` (24 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ContextExtensions`

---

### File: `utils/controller_disposable_wrapper.dart` (33 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ControllerDisposableWrapper`
- `_ControllerDisposableWrapperState`

**Fungsi Utama Terdeteksi:**
- `dispose()`
- `build()`

---

### File: `utils/currency_formatter.dart` (155 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `CurrencyInputFormatter`

**Fungsi Utama Terdeteksi:**
- `formatEditUpdate()`

---

### File: `utils/event_bus.dart` (13 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `GlobalEventBus`

**Fungsi Utama Terdeteksi:**
- `triggerRefresh()`

---

### File: `utils/exceptions.dart` (5 baris)
- File ini berukuran ringkas/standar.

---

### File: `utils/file_helper.dart` (307 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `FileHelper`

**Fungsi Utama Terdeteksi:**
- `_resolveExportDirectory()`
- `saveAndOpenFolder()`
- `saveAndOpenFile()`
- `saveFile()`
- `_resolveWritableFilePath()`
- `_ensureTimestampedFilename()`
- `openExportFolder()`
- `openFile()`
- `formatTimestamp()`
- `setWindowsExportPath()`
- `getExportPath()`

---

### File: `utils/responsive_layout.dart` (305 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ResponsiveLayout`
- `ResponsivePage`
- `ResponsiveScrollView`

**Fungsi Utama Terdeteksi:**
- `safeWidth()`
- `safeHeight()`
- `horizontalPadding()`
- `verticalPadding()`
- `gapXS()`
- `gapS()`
- `gapM()`
- `gapL()`
- `sidePanelWidth()`
- `adaptiveColumns()`
- `adaptiveChildAspectRatio()`
- `headingSize()`
- `bodySize()`
- `pagePadding()`
- `shouldUseCompactControls()`
- *(dan 3 fungsi lainnya...)*

---

### File: `utils/status_colors.dart` (57 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `StatusColors`

**Fungsi Utama Terdeteksi:**
- `getStatusColor()`
- `getStatusDisplay()`
- `getStatusBadgeColor()`

---

### File: `utils/transaction_templates.dart` (31 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `TxTemplates`

**Fungsi Utama Terdeteksi:**
- `allocationNotes()`

---

## Folder: `widgets`

**Tujuan Folder:** Komponen UI modular yang dapat digunakan kembali lintas screen (Reusable Widgets).

### File: `widgets/account_list_dialog.dart` (483 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AccountListDialog`
- `_AccountListDialogState`
- `_InfoChip`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `_loadUsers()`
- `_showCreateUserDialog()`
- `_showEditUserByManager()`
- `_showManageCompaniesDialog()`
- `_canEdit()`
- `_showUserDetail()`
- `build()`
- `_buildHeader()`
- `_buildDesktopTable()`
- `_buildRoleBadge()`
- `_buildStatusIndicator()`
- `_getRoleName()`

---

### File: `widgets/app_brand_logo.dart` (54 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AppBrandLogo`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `widgets/app_scrollbar.dart` (335 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AppScrollbar`
- `_AppScrollbarState`
- `_CenteredArrow`

**Fungsi Utama Terdeteksi:**
- `_startScrolling()`
- `_stopScrolling()`
- `dispose()`
- `build()`
- `Listener()`
- `_buildArrows()`

---

### File: `widgets/category_preview_dialog.dart` (192 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `CategoryPreviewDialog`
- `_CategoryPreviewDialogState`

**Fungsi Utama Terdeteksi:**
- `dispose()`
- `build()`
- `showCategoryPreviewDialog()`

---

### File: `widgets/dialog_create_user.dart` (240 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `CreateUserDialog`
- `_CreateUserDialogState`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `_loadCompanies()`
- `dispose()`
- `_buildCompanyCheckboxes()`
- `_submit()`
- `build()`

---

### File: `widgets/dialog_edit_user.dart` (219 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `EditUserByManagerDialog`
- `_EditUserByManagerDialogState`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `_loadCompanies()`
- `dispose()`
- `_buildCompanyCheckboxes()`
- `build()`

---

### File: `widgets/image_cropper_dialog.dart` (229 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ImageCropperDialog`
- `_ImageCropperDialogState`
- `CircleMaskPainter`

**Fungsi Utama Terdeteksi:**
- `_cropAndSave()`
- `build()`
- `paint()`

---

### File: `widgets/item_detail_preview_dialog.dart` (595 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `ItemDetailPreviewDialog`
- `_ItemDetailPreviewDialogState`

**Fungsi Utama Terdeteksi:**
- `dispose()`
- `_formatAmount()`
- `build()`
- `_buildFieldRow()`
- `_showCommentsDialog()`
- `_getStatusColor()`
- `_getStatusIcon()`

---

### File: `widgets/manage_companies_dialog.dart` (285 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `ManageCompaniesDialog`
- `_ManageCompaniesDialogState`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `_loadCompanies()`
- `_addCompany()`
- `_editCompany()`
- `_deleteCompany()`
- `_saveReorder()`
- `build()`

---

### File: `widgets/notification_bell_icon.dart` (605 baris)
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.

**Classes/Widgets:**
- `NotificationBellIcon`
- `_NotificationBellIconState`

**Fungsi Utama Terdeteksi:**
- `_closeNotificationPanel()`
- `initState()`
- `_onScroll()`
- `dispose()`
- `_toggleNotificationPanel()`
- `_showNotificationPanel()`
- `IconButton()`
- `Expanded()`
- `_hasNavigablePath()`
- `_openButtonLabel()`
- `_openNotificationTarget()`
- `_buildNotificationItem()`
- `build()`

---

### File: `widgets/user_detail_dialog.dart` (320 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `UserDetailDialog`
- `_UserDetailDialogState`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `_fetchUserData()`
- `build()`
- `_buildContent()`
- `_detailItem()`
- `_getRoleName()`

---

### File: `widgets/workflow_timeline.dart` (429 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `WorkflowTimeline`
- `_TimelineItem`
- `_InfoPill`
- `_EmptyTimeline`

**Fungsi Utama Terdeteksi:**
- `build()`
- `_stageLabel()`
- `_actionLabel()`
- `_actionIcon()`
- `_actionColor()`

---

## Folder: `widgets/core`

**Tujuan Folder:** Komponen UI modular yang dapat digunakan kembali lintas screen (Reusable Widgets).

### File: `widgets/core/_fast_range_picker_dialog.dart` (493 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `FastRangePickerDialog`
- `FastRangePickerDialogState`

**Fungsi Utama Terdeteksi:**
- `initState()`
- `_onMonthSelected()`
- `_onYearSelected()`
- `build()`
- `_buildPickerContent()`
- `_buildHeaderWithNav()`
- `_buildDayGrid()`
- `GestureDetector()`
- `_buildHeader()`
- `_getMonthName()`
- `_buildTabButton()`

---

### File: `widgets/core/_menu_item_label.dart` (59 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `MenuItemLabel`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `widgets/core/app_date_range_picker.dart` (16 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `AppDateRangePicker`

**Fungsi Utama Terdeteksi:**
- `show()`

---

### File: `widgets/core/cascading_menu_custom.dart` (165 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `CascadingMenuCustom`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `widgets/core/cascading_menu_item.dart` (17 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `CascadingMenuItem`

---

### File: `widgets/core/cascading_status_filter.dart` (141 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `CascadingStatusFilter`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `widgets/core/cascading_year_filter.dart` (201 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `CascadingYearFilter`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `widgets/core/format_utils.dart` (9 baris)
- File ini berukuran ringkas/standar.

**Fungsi Utama Terdeteksi:**
- `formatNumber()`

---

### File: `widgets/core/status_filter_chip.dart` (59 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `StatusFilterChip`

**Fungsi Utama Terdeteksi:**
- `build()`

---

### File: `widgets/core/year_filter_button.dart` (159 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `YearFilterButton`

**Fungsi Utama Terdeteksi:**
- `build()`
- `Material()`

---

## Folder: `widgets/details`

**Tujuan Folder:** Komponen UI modular yang dapat digunakan kembali lintas screen (Reusable Widgets).

### File: `widgets/details/evidence_viewer.dart` (140 baris)
- File ini berukuran ringkas/standar.

**Classes/Widgets:**
- `EvidenceViewer`

**Fungsi Utama Terdeteksi:**
- `build()`
- `_buildPdfPlaceholder()`
- `_buildImage()`

---

