# Panduan Lengkap Frontend (MiniProjectKPI_EWI_Revisi2)

Dokumen ini digenerate secara menyeluruh untuk merinci struktur, peran, dependensi, fungsi, dan isi dari setiap file di dalam `frontend/lib`.
Ditujukan agar developer baru atau AI (LLM) dapat memahami aplikasi tanpa harus membaca source code satu per satu.

## Folder: `Root (lib)`

### File: `main.dart`

**Tanggung Jawab (Responsibility):**
- File entry-point utama aplikasi. Menginisialisasi service, provider global, dan routing aplikasi.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 26 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `MyCustomScrollBehavior`
- `ExpenseApp`
- `AuthWrapper`

**Fungsi / Logika Utama:**
- `buildScrollbar()`
- `main()`
- `build()`: Membangun struktur UI/widget.

---

## Folder: `models`

**Tujuan Folder:** Mendefinisikan struktur data (Blueprint/Model) dan fungsi konversi (fromJson/toJson).

### File: `models\advance_item_model.dart`

**Tanggung Jawab (Responsibility):**
- Mendefinisikan entitas data agar dapat dikenali dan diproses dengan aman (Type-safe) oleh Dart.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `models\advance_model.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceItemModel`

---

### File: `models\advance_model.dart`

**Tanggung Jawab (Responsibility):**
- Mendefinisikan entitas data agar dapat dikenali dan diproses dengan aman (Type-safe) oleh Dart.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `providers\advance_provider.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceModel`

---

### File: `models\enums.dart`

**Tanggung Jawab (Responsibility):**
- Mendefinisikan entitas data agar dapat dikenali dan diproses dengan aman (Type-safe) oleh Dart.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** 4 file lokal (contoh: `models\advance_item_model.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `DocumentStatusExt`
- `AdvanceTypeExt`

**Fungsi / Logika Utama:**
- `fromString()`

---

### File: `models\notification_model.dart`

**Tanggung Jawab (Responsibility):**
- Mendefinisikan entitas data agar dapat dikenali dan diproses dengan aman (Type-safe) oleh Dart.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** 4 file lokal (contoh: `providers\notification_provider.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `NotificationModel`

**Fungsi / Logika Utama:**
- `copyWith()`

---

## Folder: `models\dto`

**Tujuan Folder:** Mendefinisikan struktur data (Blueprint/Model) dan fungsi konversi (fromJson/toJson).

### File: `models\dto\advance_requests.dart`

**Tanggung Jawab (Responsibility):**
- Mendefinisikan entitas data agar dapat dikenali dan diproses dengan aman (Type-safe) oleh Dart.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `providers\advance_provider.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceItemRequest`

---

## Folder: `providers`

**Tujuan Folder:** Mengelola state aplikasi (State Management) dan logika bisnis utama (Controllers).

### File: `providers\advance_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** 10 file lokal (contoh: `main.dart`).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `InsufficientAdvanceBalanceException`
- `AdvanceProvider`

**Fungsi / Logika Utama:**
- `setFilterMode()`
- `updateToken()`
- `clearData()`
- `submitStandaloneReturn()`
- `loadAdvances()`
- `clearFilters()`
- `syncReportYear()`
- `setReportYear()`
- `setFilterYear()`
- `loadAdvance()`
- `loadHistory()`
- `saveFirstItemAndCommitAdvance()`
- `cleanupEmptyDraft()`
- `updateAdvance()`
- `deleteAdvance()`
- `addAdvanceItem()`
- `updateAdvanceItem()`
- `updateItemPartial()`
- `deleteAdvanceItem()`
- `bulkDeleteAdvanceItems()`
- `submitAdvance()`
- `approveAdvance()`
- `approveAdvanceItem()`
- `rejectAdvance()`
- `startRevision()`
- `moveAdvanceToDraft()`
- `getEvidenceUrl()`
- `saveDisbursement()`
- `approveDisbursement()`
- `saveReturn()`
- `submitReturn()`
- `rejectReturn()`
- `updateReturnNotes()`
- `approveReturn()`
- `finalApproveAdvance()`
- `updateAdvanceItemsBulk()`

---

### File: `providers\asset_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** 4 file lokal (contoh: `main.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AssetProvider`

**Fungsi / Logika Utama:**
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

### File: `providers\auth_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** 20 file lokal (contoh: `main.dart`).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `AuthProvider`

**Fungsi / Logika Utama:**
- `clearActiveCompany()`
- `setActiveCompany()`
- `resetLoading()`
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
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
- `unlinkGoogleAccount()`
- `logout()`
- `retryInitialization()`
- `debugLogin()`
- `debugLinkGoogle()`
- `debugForgotPassword()`
- `debugResetPassword()`

---

### File: `providers\bank_management_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** 5 file lokal (contoh: `main.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankManagementProvider`

**Fungsi / Logika Utama:**
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

---

### File: `providers\bank_status_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** 5 file lokal (contoh: `main.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankStatusProvider`

**Fungsi / Logika Utama:**
- `updateToken()`
- `syncReportYear()`
- `setReportYear()`
- `loadBanks()`
- `loadTransactions()`
- `createTransaction()`
- `updateTransaction()`
- `deleteTransaction()`

---

### File: `providers\base_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BaseTransactionProvider`

**Fungsi / Logika Utama:**
- `loading()`
- `error()`
- `updateToken()`
- `clearData()`
- `syncReportYear()`

---

### File: `providers\cascade_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 10 dependensi/file lain.
- **Used By (Digunakan Oleh):** 7 file lokal (contoh: `main.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `CascadeProvider`

**Fungsi / Logika Utama:**
- `syncReportYear()`
- `syncAllFromSettings()`

---

### File: `providers\dividend_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** 5 file lokal (contoh: `main.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `DividendProvider`

**Fungsi / Logika Utama:**
- `updateToken()`
- `syncReportYear()`
- `setReportYear()`
- `fetchDividends()`
- `createDividend()`
- `updateDividend()`
- `deleteDividend()`
- `updateDividendSetting()`

---

### File: `providers\notification_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** 4 file lokal (contoh: `main.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `NotificationProvider`

**Fungsi / Logika Utama:**
- `startPolling()`
- `stopPolling()`
- `fetchNotifications()`
- `fetchUnreadNotifications()`
- `markAsRead()`
- `markAllAsRead()`
- `deleteNotification()`
- `updateStatus()`
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.

---

### File: `providers\revenue_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** 4 file lokal (contoh: `main.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `RevenueProvider`

**Fungsi / Logika Utama:**
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

### File: `providers\settlement_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** 16 file lokal (contoh: `main.dart`).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementProvider`

**Fungsi / Logika Utama:**
- `SettlementProvider()`
- `_loadSortMode()`
- `initialize()`
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `updateToken()`
- `clearData()`
- `loadSettlements()`
- `clearFilters()`
- `loadSettlement()`
- `loadHistory()`
- `syncReportYear()`
- `setReportYear()`
- `setFilterYear()`
- `setFilterMode()`
- `setSortMode()`
- `loadCategories()`
- `updateSettlement()`
- `deleteSettlement()`
- `submitSettlement()`
- `completeSettlement()`
- `approveSettlement()`
- `saveDisbursement()`
- `approveDisbursement()`
- `saveReturn()`
- `submitReturn()`
- `rejectReturn()`
- `updateReturnNotes()`
- `approveReturn()`
- `finalApproveSettlement()`
- `rejectAllExpenses()`
- `moveSettlementToDraft()`
- `saveFirstExpenseAndCommitSettlement()`
- `cleanupEmptyDraft()`
- `addExpense()`
- `updateExpense()`
- `updateExpenseData()`
- `updateExpensesBulk()`
- `deleteExpense()`
- `bulkDeleteExpenses()`
- `approveExpense()`
- `approveAllSettlement()`
- `rejectAllSettlement()`
- `createCategory()`
- `loadBanks()`
- `loadAdvanceBanks()`
- `updateCategory()`
- `reorderCategories()`
- `deleteCategory()`
- `loadPendingCategories()`
- `approveCategory()`
- `getEvidenceUrl()`

---

### File: `providers\tax_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** 4 file lokal (contoh: `main.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `TaxProvider`

**Fungsi / Logika Utama:**
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

### File: `providers\theme_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `main.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ThemeProvider`

**Fungsi / Logika Utama:**
- `_loadThemeMode()`
- `setThemeMode()`
- `_parseThemeMode()`

---

## Folder: `screens`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\dashboard_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `main.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `DashboardScreen`
- `_DashboardScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_selectCompany()`
- `build()`: Membangun struktur UI/widget.
- `Wrap()`
- `_buildCompanyCard()`

---

### File: `screens\main_layout.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 38 dependensi/file lain.
- **Used By (Digunakan Oleh):** 4 file lokal (contoh: `screens\dashboard_screen.dart`).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `MainLayout`
- `MainLayoutState`
- `_SettlementListView`
- `_SettlementListViewState`

**Fungsi / Logika Utama:**
- `switchToTab()`
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_setupNotificationListener()`
- `_onNotificationUpdate()`
- `_showNotificationSnackBar()`
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `_fetchBadgeCounts()`
- `_handleNotificationTap()`
- `_confirmLogout()`
- `build()`: Membangun struktur UI/widget.
- `PopScope()`
- `_handleListScroll()`
- `scrollToTop()`
- `_scheduleSettlementReload()`
- `resetFilters()`
- `_toggleItemSelection()`
- `_bulkDeleteItems()`
- `setState()`
- `_onProviderChange()`
- `_loadDefaultReportYearAndReload()`
- `_loadDashboardSummary()`
- `_loadAnnualSettlementSummary()`
- `updateState()`
- `reloadSettlements()`
- `_pickDateRange()`
- `_exportExcel()`
- `_exportPdf()`
- `_showStandaloneReturnDialog()`
- `_showCreateDialog()`
- `LayoutBuilder()`

---

### File: `screens\main_layout_widgets.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_DashboardWidgetsExt`
- `_FilterChipWidget`
- `StatusFilterChip`

**Fungsi / Logika Utama:**
- `_deleteSettlement()`
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\widget_scrollable_settlement_header.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_MainLayoutWidgetsScrollableSettlementHeaderExt`

**Fungsi / Logika Utama:**
- `_buildScrollableSettlementHeader()`
- `CascadingYearFilter()`

---

### File: `screens\widget_summary_cards.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_MainLayoutWidgetsSummaryCardsExt`

**Fungsi / Logika Utama:**
- `_buildSummaryCards()`

---

### File: `screens\widget_toggle_button.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_MainLayoutWidgetsToggleButtonExt`

**Fungsi / Logika Utama:**
- `_buildToggleButton()`

---

### File: `screens\widget_type_toggle.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_MainLayoutWidgetsTypeToggleExt`

**Fungsi / Logika Utama:**
- `_buildTypeToggle()`

---

## Folder: `screens\advance`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\advance\advance_detail_actions.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailActionsExt`

**Fungsi / Logika Utama:**
- `_showGlobalSnackBar()`
- `_moveToDraft()`
- `_approveAdvance()`
- `_rejectItem()`
- `_fetchBadgeCounts()`
- `_deleteItem()`
- `_downloadReceipt()`
- `_submitAdvance()`
- `_bulkDeleteItems()`
- `_buildSaveChecklistButton()`
- `_approveItem()`
- `_approveReturn()`
- `_exportAdvanceExcel()`
- `_canEditCurrentRevision()`
- `_canApproveAdvanceItems()`
- `_canSubmitAdvanceItems()`

---

### File: `screens\advance\advance_detail_previews.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailPreviewsExt`

**Fungsi / Logika Utama:**
- `_buildPreviewRow()`
- `_showAllItemsPreview()`
- `_showDisbursementPreview()`
- `_showReturnPreview()`
- `_showItemPreview()`

---

### File: `screens\advance\advance_detail_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 27 dependensi/file lain.
- **Used By (Digunakan Oleh):** 4 file lokal (contoh: `screens\main_layout.dart`).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailScreen`
- `_AdvanceDetailScreenState`

**Fungsi / Logika Utama:**
- `_handleMobilePageSelection()`
- `_confirmLogout()`
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_fetchActiveAdvanceBalance()`
- `_handleNotificationTap()`
- `_statusColor()`
- `_advanceStatusColor()`
- `_advanceFundSource()`
- `_advanceDisbursementSourceLabel()`
- `_advanceReturnSourceLabel()`
- `collect()`
- `_displayAdvanceStatus()`
- `_headerText()`
- `_displayAdvanceTitle()`
- `_toDouble()`
- `updateState()`
- `build()`: Membangun struktur UI/widget.
- `handlePop()`
- `PopScope()`

---

### File: `screens\advance\advances_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 20 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\main_layout.dart`).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvancesScreen`
- `AdvancesScreenState`

**Fungsi / Logika Utama:**
- `_handleListScroll()`
- `scrollToTop()`
- `resetFilters()`
- `_scheduleAdvanceReload()`
- `_canDeleteAdvanceCard()`
- `_toggleItemSelection()`
- `_bulkDeleteItems()`
- `setState()`
- `_loadAnnualAdvanceSummary()`
- `updateState()`
- `reloadAdvances()`
- `_pickDateRange()`
- `_exportExcel()`
- `_exportPdf()`
- `_showStandaloneReturnDialog()`
- `_showCreateDialog()`
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_onProviderChange()`
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `build()`: Membangun struktur UI/widget.
- `LayoutBuilder()`
- `_deleteAdvance()`

---

## Folder: `screens\advance\dialogs`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\advance\dialogs\dialog_add_category.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailDialogsExpenseshowAddCategoryDialogExt`

---

### File: `screens\advance\dialogs\dialog_add_item.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailDialogsExpenseshowAddItemDialogExt`

**Fungsi / Logika Utama:**
- `_showAddItemDialog()`

---

### File: `screens\advance\dialogs\dialog_checklist.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailDialogsGeneralshowChecklistDialogExt`

**Fungsi / Logika Utama:**
- `_showChecklistDialog()`
- `_buildChecklistTile()`

---

### File: `screens\advance\dialogs\dialog_comments.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailDialogsGeneralshowCommentsDialogExt`

**Fungsi / Logika Utama:**
- `_showCommentsDialog()`

---

### File: `screens\advance\dialogs\dialog_disbursement_evidence_cell.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailDialogsGeneralbuildDisbursementEvidenceCellExt`

**Fungsi / Logika Utama:**
- `_buildDisbursementEvidenceCell()`

---

### File: `screens\advance\dialogs\dialog_edit_advance.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailDialogsGeneralshowEditAdvanceDialogExt`

**Fungsi / Logika Utama:**
- `_showEditAdvanceDialog()`

---

### File: `screens\advance\dialogs\dialog_edit_disbursement.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailDialogsGeneralshowEditDisbursementDialogExt`

**Fungsi / Logika Utama:**
- `_showEditDisbursementDialog()`

---

### File: `screens\advance\dialogs\dialog_edit_return.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailDialogsGeneralshowEditReturnDialogExt`

**Fungsi / Logika Utama:**
- `_showEditReturnDialog()`

---

### File: `screens\advance\dialogs\dialog_evidence.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailDialogsGeneralshowEvidenceExt`

**Fungsi / Logika Utama:**
- `_showEvidence()`
- `InkWell()`

---

### File: `screens\advance\dialogs\dialog_get_comments_from_notes.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailDialogsGeneralgetCommentsFromNotesExt`

---

### File: `screens\advance\dialogs\dialog_insufficient_balance.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailDialogsGeneralshowInsufficientBalanceDialogExt`

**Fungsi / Logika Utama:**
- `_showInsufficientBalanceDialog()`

---

### File: `screens\advance\dialogs\dialog_parse_plain_comments.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailDialogsGeneralparsePlainCommentsExt`

---

### File: `screens\advance\dialogs\dialog_plain_comments.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailDialogsGeneralshowPlainCommentsDialogExt`

**Fungsi / Logika Utama:**
- `_showPlainCommentsDialog()`

---

### File: `screens\advance\dialogs\dialog_reject_return.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailDialogsGeneralshowRejectReturnDialogExt`

**Fungsi / Logika Utama:**
- `_showRejectReturnDialog()`

---

### File: `screens\advance\dialogs\dialog_return_checklist.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailDialogsGeneralshowReturnChecklistDialogExt`

**Fungsi / Logika Utama:**
- `_showReturnChecklistDialog()`
- `_buildReturnChecklistTile()`

---

### File: `screens\advance\dialogs\dialog_return_checklist_tile.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailDialogsGeneralbuildReturnChecklistTileExt`

**Fungsi / Logika Utama:**
- `_buildReturnChecklistTile()`

---

### File: `screens\advance\dialogs\dialog_workflow_timeline.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailDialogsGeneralshowWorkflowTimelineDialogExt`

**Fungsi / Logika Utama:**
- `_showWorkflowTimelineDialog()`

---

## Folder: `screens\advance\layouts`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\advance\layouts\advance_detail_layout.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailLayoutExt`

**Fungsi / Logika Utama:**
- `_formatItemAmount()`
- `_hasUncheckedChecklist()`

---

### File: `screens\advance\layouts\advance_detail_tables.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailTablesExt`

**Fungsi / Logika Utama:**
- `_buildAdvanceFundReturnSection()`
- `_buildChecklistTile()`
- `_buildItemsTable()`
- `_buildAdvanceFundTransferSection()`

---

## Folder: `screens\advance\widgets`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\advance\widgets\advances_widgets.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvancesWidgetsExt`

---

### File: `screens\advance\widgets\widget_add_comment_button.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailLayoutAddCommentButtonExt`

**Fungsi / Logika Utama:**
- `_buildAddCommentButton()`

---

### File: `screens\advance\widgets\widget_advance_detail_actions.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailLayoutAdvanceDetailActionsExt`

---

### File: `screens\advance\widgets\widget_content.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailLayoutContentExt`

**Fungsi / Logika Utama:**
- `_buildContent()`

---

### File: `screens\advance\widgets\widget_empty_state.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailLayoutEmptyStateExt`

**Fungsi / Logika Utama:**
- `_buildEmptyState()`

---

### File: `screens\advance\widgets\widget_file_list.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailLayoutFileListExt`

---

### File: `screens\advance\widgets\widget_insuff_balance_row.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailLayoutinsuffBalanceRowExt`

**Fungsi / Logika Utama:**
- `_insuffBalanceRow()`

---

### File: `screens\advance\widgets\widget_mobile_advance_action_bar.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailLayoutMobileAdvanceActionBarExt`

**Fungsi / Logika Utama:**
- `_buildMobileAdvanceActionBar()`

---

### File: `screens\advance\widgets\widget_scrollable_advance_header.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvancesWidgetsScrollableAdvanceHeaderExt`

**Fungsi / Logika Utama:**
- `_buildScrollableAdvanceHeader()`
- `CascadingYearFilter()`

---

### File: `screens\advance\widgets\widget_toggle_button.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvancesWidgetsToggleButtonExt`

**Fungsi / Logika Utama:**
- `_buildToggleButton()`

---

### File: `screens\advance\widgets\widget_type_toggle.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvancesWidgetsTypeToggleExt`

**Fungsi / Logika Utama:**
- `_buildTypeToggle()`

---

### File: `screens\advance\widgets\widget_warning_box.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AdvanceDetailLayoutWarningBoxExt`

**Fungsi / Logika Utama:**
- `_buildWarningBox()`

---

### File: `screens\advance\widgets\widget_year_summary_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvancesWidgetsYearSummaryCardExt`

**Fungsi / Logika Utama:**
- `_buildYearSummaryCard()`

---

## Folder: `screens\auth`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\auth\loading_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `main.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `LoadingScreen`
- `_LoadingScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\login_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `main.dart`).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `LoginScreen`
- `_LoginScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_loadSavedCredentials()`
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `_loadServerUrl()`
- `_showServerUrlDialog()`
- `_login()`
- `_navigateToRegister()`
- `_showMessage()`
- `_handleGoogleLogin()`
- `_showForgotPasswordDialog()`
- `StatefulBuilder()`
- `submit()`
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\login_widget_gmail_login_button.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_GmailLoginButton`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.
- `Material()`

---

### File: `screens\auth\login_widget_landscape_intro_panel.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_LandscapeIntroPanel`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\login_widget_landscape_login_content.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_LandscapeLoginContent`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\login_widget_login_brand_icon.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_LoginBrandIcon`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\login_widget_login_button.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_LoginButton`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.
- `SizedBox()`

---

### File: `screens\auth\login_widget_login_hint_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_LoginHintCard`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\login_widget_password_field.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_PasswordField`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\login_widget_portrait_login_content.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_PortraitLoginContent`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\login_widget_register_link.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_RegisterLink`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\login_widget_username_field.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_UsernameField`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\auth\login_screen.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `RegisterScreen`
- `_RegisterScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `_register()`
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_back_button.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_BackButton`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_company_dropdown.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_CompanyDropdown`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_confirm_password_field.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_ConfirmPasswordField`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_email_field.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_EmailField`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_full_name_field.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_FullNameField`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_landscape_intro_panel.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_LandscapeIntroPanel`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_landscape_register_content.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_LandscapeRegisterContent`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_password_field.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_PasswordField`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_phone_field.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_PhoneField`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_portrait_register_content.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_PortraitRegisterContent`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_register_brand_icon.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_RegisterBrandIcon`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_register_button.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_RegisterButton`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_role_dropdown.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_RoleDropdown`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_username_field.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_UsernameField`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_workplace_field.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_WorkplaceField`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\server_error_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `main.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ServerErrorScreen`
- `_ServerErrorScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `_showServerUrlDialog()`
- `_retry()`
- `build()`: Membangun struktur UI/widget.

---

## Folder: `screens\management`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\management\asset_management_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\reports\annual_report\annual_report_screen.dart`).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `AssetManagementScreen`
- `_AssetManagementScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `_loadData()`
- `_clampInput()`
- `_displayDate()`
- `_showAssetDialog()`
- `calculatePreview()`
- `parseVal()`
- `_showNdpvTable()`
- `_confirmDelete()`
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\management\bank_advance_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankAdvanceScreen`
- `_BankAdvanceScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_loadData()`
- `_showManageBalanceDialog()`
- `getBankSortIndex()`
- `getTotalAllocation()`
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\management\bank_management_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\main_layout.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankManagementScreen`
- `_BankManagementScreenState`

**Fungsi / Logika Utama:**
- `updateState()`
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\management\bank_management_screen_actions.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_BankManagementActionsExt`

**Fungsi / Logika Utama:**
- `_loadData()`
- `_loadAdvanceData()`
- `_displayDate()`
- `_getBankSortIndex()`

---

### File: `screens\management\bank_management_screen_layout.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_BankManagementLayoutExt`

---

### File: `screens\management\bank_management_screen_tables.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_BankManagementTablesExt`

**Fungsi / Logika Utama:**
- `_buildLogGridItem()`

---

### File: `screens\management\bank_status_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\reports\annual_report\annual_report_screen.dart`).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankStatusScreen`
- `_BankStatusScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_loadData()`
- `_displayDate()`
- `_getBankSortIndex()`
- `_showTransactionDialog()`
- `_deleteTransaction()`
- `build()`: Membangun struktur UI/widget.
- `_buildBankFilter()`

---

### File: `screens\management\category_management_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `screens\main_layout.dart`).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `CategoryManagementView`
- `_CategoryManagementViewState`

**Fungsi / Logika Utama:**
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `build()`: Membangun struktur UI/widget.
- `LayoutBuilder()`
- `_buildCategoryTile()`
- `_buildPendingItem()`
- `_showAddCategoryDialog()`
- `_showEditCategoryDialog()`
- `_deleteCategory()`
- `_approveCategory()`

---

### File: `screens\management\category_tabular_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `screens\management\category_management_screen.dart`).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `CategoryTabularScreen`
- `_CategoryTabularScreenState`

**Fungsi / Logika Utama:**
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_loadData()`
- `_saveChanges()`
- `_showSnackBar()`
- `build()`: Membangun struktur UI/widget.
- `_saveAllGroupsAndCategories()`
- `_showManageGroupsDialog()`
- `addGroup()`
- `editGroup()`
- `deleteGroup()`
- `_syncTempCatsOrderDynamic()`

---

### File: `screens\management\dialog_advance_log_book.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_BankManagementDialogsshowAdvanceLogBookDialogExt`

**Fungsi / Logika Utama:**
- `_showAdvanceLogBookDialog()`

---

### File: `screens\management\dialog_bank_account.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_BankManagementDialogsshowBankAccountDialogExt`

**Fungsi / Logika Utama:**
- `_showBankAccountDialog()`
- `Builder()`

---

### File: `screens\management\dialog_bank_advance_detail.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_BankManagementDialogsshowBankAdvanceDetailModalExt`

**Fungsi / Logika Utama:**
- `_showBankAdvanceDetailModal()`

---

### File: `screens\management\dialog_bank_cash_detail.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_BankManagementDialogsshowBankCashDetailModalExt`

**Fungsi / Logika Utama:**
- `_showBankCashDetailModal()`

---

### File: `screens\management\dialog_bank_cash_log_book.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_BankManagementDialogsshowBankCashLogBookDialogExt`

**Fungsi / Logika Utama:**
- `_showBankCashLogBookDialog()`
- `AppScrollbar()`

---

### File: `screens\management\dialog_edit_advance_balance.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_BankManagementDialogsshowEditAdvanceBalanceDialogExt`

**Fungsi / Logika Utama:**
- `_showEditAdvanceBalanceDialog()`
- `getTotalAllocation()`

---

### File: `screens\management\dividend_management_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\reports\annual_report\annual_report_screen.dart`).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `DividendManagementScreen`
- `_DividendManagementScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `_loadData()`
- `_toDouble()`
- `_fmtMoney()`
- `_formatForInput()`
- `_showRecipientDialog()`
- `pickDate()`
- `_saveProfitRetained()`
- `_deleteDividend()`
- `_textField()`
- `_buildCalculationCard()`
- `metric()`
- `LayoutBuilder()`
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\management\logbook_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `screens\management\bank_advance_screen.dart`).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `LogbookScreen`
- `_LogbookScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_fetchLogs()`
- `_buildLogGridItem()`
- `_buildAuditTrailLogItem()`
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\management\revenue_management_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\reports\annual_report\annual_report_screen.dart`).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `RevenueManagementScreen`
- `_RevenueManagementScreenState`

**Fungsi / Logika Utama:**
- `updateState()`
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `build()`: Membangun struktur UI/widget.
- `Column()`

---

### File: `screens\management\revenue_management_screen_actions.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `_RevenueManagementActionsExt`

**Fungsi / Logika Utama:**
- `_displayDate()`
- `_loadData()`
- `_saveRevenue()`
- `_deleteRevenue()`
- `_itemId()`
- `_manageRevenueCombine()`
- `showDialog()`
- `StatefulBuilder()`
- `Flexible()`
- `_startCombineWizard()`
- `isRowAvailable()`
- `_releaseSelectedRevenueCombine()`
- `_textField()`
- `_numberField()`

---

### File: `screens\management\revenue_management_screen_dialogs.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_RevenueManagementDialogsExt`

**Fungsi / Logika Utama:**
- `_formatNumericInput()`
- `_showRevenueDialog()`
- `pickDate()`
- `_showConfirmDialog()`

---

### File: `screens\management\revenue_management_screen_tables.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_RevenueManagementTablesExt`

**Fungsi / Logika Utama:**
- `_buildCell()`

---

### File: `screens\management\tax_management_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\reports\annual_report\annual_report_screen.dart`).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `TaxManagementScreen`
- `_TaxManagementScreenState`

**Fungsi / Logika Utama:**
- `updateState()`
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `build()`: Membangun struktur UI/widget.
- `Column()`

---

### File: `screens\management\tax_management_screen_actions.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `_TaxManagementActionsExt`

**Fungsi / Logika Utama:**
- `_displayDate()`
- `_loadData()`
- `_saveTax()`
- `_deleteTax()`
- `_itemId()`
- `_manageTaxCombine()`
- `showDialog()`
- `StatefulBuilder()`
- `Flexible()`
- `_startTaxCombineWizard()`
- `isRowAvailable()`
- `_releaseSelectedTaxCombine()`
- `_textField()`
- `_numberField()`
- `_fmtMoney()`

---

### File: `screens\management\tax_management_screen_dialogs.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_TaxManagementDialogsExt`

**Fungsi / Logika Utama:**
- `_formatNumericInput()`
- `_showTaxDialog()`
- `pickDate()`
- `StatefulBuilder()`
- `_showConfirmDialog()`

---

### File: `screens\management\tax_management_screen_tables.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_TaxManagementTablesExt`

**Fungsi / Logika Utama:**
- `_buildCell()`

---

### File: `screens\management\widget_advance_section.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_BankManagementLayoutAdvanceSectionExt`

**Fungsi / Logika Utama:**
- `_buildAdvanceSection()`
- `Builder()`

---

### File: `screens\management\widget_audit_trail_log_item.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_BankManagementLayoutAuditTrailLogItemExt`

**Fungsi / Logika Utama:**
- `_buildAuditTrailLogItem()`

---

### File: `screens\management\widget_bank_accounts_tab.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_BankManagementLayoutBankAccountsTabExt`

**Fungsi / Logika Utama:**
- `_buildBankAccountsTab()`

---

### File: `screens\management\widget_group_management_dialog.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_CategoryTabularScreenGroupManagementDialogExt`

**Fungsi / Logika Utama:**
- `_showGroupManagementDialog()`
- `moveItem()`
- `buildKanbanContent()`

---

### File: `screens\management\widget_kanban_column_dynamic.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_CategoryTabularScreenKanbanColumnDynamicExt`

---

### File: `screens\management\widget_section_toggle.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_BankManagementLayoutSectionToggleExt`

**Fungsi / Logika Utama:**
- `_buildSectionToggle()`

---

### File: `screens\management\widget_simple_category_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_CategoryTabularScreenSimpleCategoryCardExt`

**Fungsi / Logika Utama:**
- `_buildSimpleCategoryCard()`

---

### File: `screens\management\widget_toggle_button.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_BankManagementLayoutToggleButtonExt`

**Fungsi / Logika Utama:**
- `_buildToggleButton()`

---

## Folder: `screens\manager`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\manager\manager_dashboard_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 11 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ManagerDashboardScreen`
- `_ManagerDashboardScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `build()`: Membangun struktur UI/widget.
- `_buildSettlementsForApproval()`
- `_buildAdvancesForApproval()`
- `_showAdvanceApprovalDialog()`
- `_showInsufficientBalanceDialog()`
- `_balanceRow()`

---

### File: `screens\manager\manager_settlement_detail_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\manager\manager_dashboard_screen.dart`).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `ManagerSettlementDetailScreen`
- `_ManagerSettlementDetailScreenState`

**Fungsi / Logika Utama:**
- `_toDouble()`
- `_formatExpenseAmount()`
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `build()`: Membangun struktur UI/widget.
- `_buildSettlementInfo()`
- `_buildExpensesList()`
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
- `_deleteSettlement()`

---

## Folder: `screens\reports`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\reports\report_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 12 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\main_layout.dart`).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `ReportScreen`
- `_ReportScreenState`

**Fungsi / Logika Utama:**
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_onProviderChange()`
- `_loadSummary()`
- `_pickDateRange()`
- `build()`: Membangun struktur UI/widget.
- `_buildHeaderInfo()`
- `_buildActions()`
- `Row()`
- `_buildSummaryCell()`
- `_buildSummaryTableScrollableBody()`
- `SizedBox()`
- `_exportFullExcel()`
- `_exportSummaryPdf()`
- `_fmtDate()`
- `_buildCacheInfo()`

---

## Folder: `screens\reports\annual_report`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\reports\annual_report\annual_report_helpers.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AnnualReportHelpersExt`

**Fungsi / Logika Utama:**
- `_toDouble()`
- `_fmtMoney()`
- `_fmtPlain()`
- `_fmtAmount()`
- `_normalizeCurrency()`
- `_fmtDate()`
- `_extractBatchNumber()`
- `_isBatchSettlement()`
- `_extractNoteSubcategory()`
- `_subcategorySortBucket()`
- `_expenseSubcategoryLabel()`

---

### File: `screens\reports\annual_report\annual_report_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 24 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\reports\report_screen.dart`).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportScreen`
- `_AnnualReportScreenState`

**Fungsi / Logika Utama:**
- `updateState()`
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_onProviderChange()`
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `_syncScroll()`
- `_syncHorizontal()`
- `_fetchCategories()`
- `_loadDefaultReportYearAndFetch()`
- `_fetchReport()`
- `_pickDateRange()`
- `_exportExcel()`
- `_applySheet()`
- `_toggleTableVisibility()`
- `_showUnavailableInputMessage()`
- `_handleInputMenuSelection()`
- `_navToDetail()`
- `_parseDate()`
- `build()`: Membangun struktur UI/widget.
- `Listener()`
- `_navTo()`

---

### File: `screens\reports\annual_report\annual_report_state.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\reports\annual_report\annual_report_screen.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ReportTableData`

---

### File: `screens\reports\annual_report\annual_report_tables.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AnnualReportTablesExt`

**Fungsi / Logika Utama:**
- `mergeInto()`
- `addExpenseGroup()`
- `_isNumericLikeCell()`

---

### File: `screens\reports\annual_report\annual_report_widgets.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AnnualReportWidgetsExt`

**Fungsi / Logika Utama:**
- `_toggleTaxOffset()`

---

### File: `screens\reports\annual_report\widget_all_tables.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AnnualReportTablesAllTablesExt`

**Fungsi / Logika Utama:**
- `_processAllTables()`

---

### File: `screens\reports\annual_report\widget_bank_expense_table.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AnnualReportTablesBankExpenseTableExt`

---

### File: `screens\reports\annual_report\widget_cache_info.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AnnualReportWidgetsCacheInfoExt`

**Fungsi / Logika Utama:**
- `_buildCacheInfo()`

---

### File: `screens\reports\annual_report\widget_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AnnualReportWidgetsCardExt`

**Fungsi / Logika Utama:**
- `_buildCard()`

---

### File: `screens\reports\annual_report\widget_display_tables.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AnnualReportWidgetsDisplayTablesExt`

---

### File: `screens\reports\annual_report\widget_evidence_button.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AnnualReportWidgetsEvidenceButtonExt`

**Fungsi / Logika Utama:**
- `_buildEvidenceButton()`

---

### File: `screens\reports\annual_report\widget_expense_table_cell.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AnnualReportWidgetsExpenseTableCellExt`

**Fungsi / Logika Utama:**
- `_buildExpenseTableCell()`

---

### File: `screens\reports\annual_report\widget_report_header.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AnnualReportWidgetsReportHeaderExt`

**Fungsi / Logika Utama:**
- `_buildReportHeader()`

---

### File: `screens\reports\annual_report\widget_show_evidence_popup.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AnnualReportWidgetsshowEvidencePopupExt`

**Fungsi / Logika Utama:**
- `_showEvidencePopup()`

---

### File: `screens\reports\annual_report\widget_status_cell.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AnnualReportWidgetsStatusCellExt`

**Fungsi / Logika Utama:**
- `_buildStatusCell()`

---

### File: `screens\reports\annual_report\widget_summary_cards.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AnnualReportWidgetsSummaryCardsExt`

**Fungsi / Logika Utama:**
- `_buildSummaryCards()`

---

### File: `screens\reports\annual_report\widget_table4_a_and4_b.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AnnualReportTablesTable4AAnd4BExt`

**Fungsi / Logika Utama:**
- `_processTable4AAnd4B()`
- `getFilteredCatIndex()`

---

### File: `screens\reports\annual_report\widget_table4_c_and4_d.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AnnualReportTablesTable4CAnd4DExt`

**Fungsi / Logika Utama:**
- `_processTable4CAnd4D()`
- `getFilteredCatIndex()`

---

### File: `screens\reports\annual_report\widget_table_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AnnualReportWidgetsTableCardExt`

**Fungsi / Logika Utama:**
- `_buildTableCard()`
- `Builder()`
- `SizedBox()`
- `Column()`

---

### File: `screens\reports\annual_report\widget_tax_toggle_cell.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_AnnualReportWidgetsTaxToggleCellExt`

**Fungsi / Logika Utama:**
- `_buildTaxToggleCell()`

---

## Folder: `screens\settings`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\settings\balance_sheet_settings_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\reports\annual_report\annual_report_screen.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BalanceSheetSettingsScreen`
- `_BalanceSheetSettingsScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `_loadData()`
- `_toDouble()`
- `_formatPlain()`
- `_saveSettings()`
- `_field()`
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\settings\data_cleanup_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\settings\settings_screen.dart`).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `DataCleanupScreen`
- `_DataCleanupScreenState`

**Fungsi / Logika Utama:**
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `_nextPage()`
- `_prevPage()`
- `_fetchPreview()`
- `_executeCleanup()`
- `_showError()`
- `_isNextEnabled()`
- `build()`: Membangun struktur UI/widget.
- `_buildProgressIndicator()`
- `_buildYearSelection()`
- `_buildModuleSelection()`
- `_buildPreviewStep()`
- `_buildConfirmationStep()`
- `_buildSelectionCard()`
- `_buildBottomNav()`

---

### File: `screens\settings\deadline_manager_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\settings\settings_screen.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `DeadlineManagerScreen`
- `_DeadlineRuleConfig`
- `_DeadlineManagerScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_loadDeadlineSettings()`
- `_saveSetting()`
- `_showAddDayDialog()`
- `_removeDay()`
- `build()`: Membangun struktur UI/widget.
- `_buildHeaderInfo()`
- `_buildModernRuleCard()`
- `_buildDayChip()`

---

### File: `screens\settings\settings_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 19 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\main_layout.dart`).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettingsScreen`
- `_SettingsScreenState`
- `EditProfileDialog`
- `_EditProfileDialogState`

**Fungsi / Logika Utama:**
- `updateState()`
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `build()`: Membangun struktur UI/widget.
- `_pickImage()`
- `_submit()`

---

### File: `screens\settings\settings_screen_actions.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettingsActionsExt`

**Fungsi / Logika Utama:**
- `_loadSettings()`
- `_saveSettings()`
- `_saveReportYearSettings()`
- `_exportDatabase()`
- `_importDatabase()`
- `_confirmImport()`
- `_showAccountList()`
- `_toggleManagerSection()`
- `_profileColumn()`

---

### File: `screens\settings\settings_screen_dialogs.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettingsDialogsExt`

**Fungsi / Logika Utama:**
- `_showImportPreviewDialog()`
- `_showEditProfileDialog()`

---

### File: `screens\settings\settings_screen_layout.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettingsLayoutExt`

---

### File: `screens\settings\widget_bank_advance_widget.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettingsLayoutBankAdvanceWidgetExt`

**Fungsi / Logika Utama:**
- `_buildBankAdvanceWidget()`

---

### File: `screens\settings\widget_cleanup_settings_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettingsLayoutCleanupSettingsCardExt`

**Fungsi / Logika Utama:**
- `_buildCleanupSettingsCard()`

---

### File: `screens\settings\widget_database_settings_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettingsLayoutDatabaseSettingsCardExt`

**Fungsi / Logika Utama:**
- `_buildDatabaseSettingsCard()`

---

### File: `screens\settings\widget_deadline_settings_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettingsLayoutDeadlineSettingsCardExt`

**Fungsi / Logika Utama:**
- `_buildDeadlineSettingsCard()`

---

### File: `screens\settings\widget_logbook_button.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettingsLayoutLogbookButtonExt`

**Fungsi / Logika Utama:**
- `_buildLogbookButton()`

---

### File: `screens\settings\widget_manager_section.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettingsLayoutManagerSectionExt`

**Fungsi / Logika Utama:**
- `_buildManagerSection()`

---

### File: `screens\settings\widget_profile_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettingsLayoutProfileCardExt`

**Fungsi / Logika Utama:**
- `_buildProfileCard()`

---

### File: `screens\settings\widget_report_year_settings_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettingsLayoutReportYearSettingsCardExt`

**Fungsi / Logika Utama:**
- `_buildReportYearSettingsCard()`

---

### File: `screens\settings\widget_storage_settings_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettingsLayoutStorageSettingsCardExt`

**Fungsi / Logika Utama:**
- `_buildStorageSettingsCard()`

---

### File: `screens\settings\widget_theme_settings_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettingsLayoutThemeSettingsCardExt`

**Fungsi / Logika Utama:**
- `_buildThemeSettingsCard()`

---

## Folder: `screens\settlement`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\settlement\settlement_detail_actions.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailActionsExt`

**Fungsi / Logika Utama:**
- `_approveTable1()`
- `_approveSettlement()`
- `_handleNotificationTap()`
- `_downloadReceipt()`
- `_showGlobalSnackBar()`
- `_approveReturn()`
- `_deleteExpense()`
- `_moveToDraft()`
- `_buildSaveChecklistButton()`
- `_submitSettlement()`
- `_exportSettlementExcel()`
- `_rejectSettlement()`
- `_fetchBadgeCounts()`
- `_approveExpense()`
- `_bulkDeleteExpenses()`
- `_confirmLogout()`

---

### File: `screens\settlement\settlement_detail_previews.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailPreviewsExt`

**Fungsi / Logika Utama:**
- `_showReturnPreview()`
- `_showItemPreview()`
- `_showAllItemsPreview()`
- `StatefulBuilder()`
- `_buildPreviewRow()`
- `_buildDisbursementPreviewContent()`
- `_buildReturnPreviewContent()`
- `_buildAllItemsPreviewList()`
- `_showDisbursementPreview()`

---

### File: `screens\settlement\settlement_detail_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 26 dependensi/file lain.
- **Used By (Digunakan Oleh):** 4 file lokal (contoh: `screens\main_layout.dart`).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementDetailScreen`
- `_SettlementDetailScreenState`

**Fungsi / Logika Utama:**
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_fetchActiveAdvanceBalance()`
- `_statusColor()`
- `_toDouble()`
- `_formatExpenseAmount()`
- `_displaySettlementStatus()`
- `_expenseFundSource()`
- `_settlementDisbursementSourceLabel()`
- `_settlementReturnSourceLabel()`
- `collect()`
- `_settlementReimbursementAmount()`
- `_buildDisbursementDataRow()`
- `_showWorkflowTimelineDialog()`
- `_displaySettlementTitle()`
- `_hasUncheckedChecklist()`
- `_canSubmitSettlementItems()`
- `_canApproveSettlementItems()`
- `updateState()`
- `build()`: Membangun struktur UI/widget.
- `handlePop()`
- `PopScope()`

---

## Folder: `screens\settlement\dialogs`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\settlement\dialogs\dialog_add_category.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailDialogsExpenseshowAddCategoryDialogExt`

---

### File: `screens\settlement\dialogs\dialog_add_expense.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailDialogsExpenseshowAddExpenseDialogExt`

**Fungsi / Logika Utama:**
- `_showAddExpenseDialog()`

---

### File: `screens\settlement\dialogs\dialog_checklist.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailDialogsGeneralshowChecklistDialogExt`

**Fungsi / Logika Utama:**
- `_showChecklistDialog()`
- `_buildChecklistTile()`

---

### File: `screens\settlement\dialogs\dialog_comments.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailDialogsGeneralshowCommentsDialogExt`

**Fungsi / Logika Utama:**
- `_showCommentsDialog()`

---

### File: `screens\settlement\dialogs\dialog_edit_disbursement.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailDialogsGeneralshowEditDisbursementDialogExt`

**Fungsi / Logika Utama:**
- `_showEditDisbursementDialog()`

---

### File: `screens\settlement\dialogs\dialog_edit_expense.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailDialogsExpenseshowEditExpenseDialogExt`

**Fungsi / Logika Utama:**
- `_showEditExpenseDialog()`

---

### File: `screens\settlement\dialogs\dialog_edit_return.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailDialogsGeneralshowEditReturnDialogExt`

**Fungsi / Logika Utama:**
- `_showEditReturnDialog()`

---

### File: `screens\settlement\dialogs\dialog_edit_settlement.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailDialogsGeneralshowEditSettlementDialogExt`

**Fungsi / Logika Utama:**
- `_showEditSettlementDialog()`

---

### File: `screens\settlement\dialogs\dialog_evidence.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailDialogsGeneralshowEvidenceExt`

**Fungsi / Logika Utama:**
- `_showEvidence()`
- `InkWell()`

---

### File: `screens\settlement\dialogs\dialog_plain_comments.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailDialogsGeneralshowPlainCommentsDialogExt`

**Fungsi / Logika Utama:**
- `_showPlainCommentsDialog()`

---

### File: `screens\settlement\dialogs\dialog_reject_return.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailDialogsGeneralshowRejectReturnDialogExt`

**Fungsi / Logika Utama:**
- `_showRejectReturnDialog()`

---

### File: `screens\settlement\dialogs\dialog_return_checklist.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailDialogsGeneralshowReturnChecklistDialogExt`

**Fungsi / Logika Utama:**
- `_showReturnChecklistDialog()`
- `_buildReturnChecklistTile()`

---

## Folder: `screens\settlement\layouts`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\settlement\layouts\settlement_detail_layout.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailLayoutExt`

**Fungsi / Logika Utama:**
- `_buildMobileSettlementActionBar()`
- `_buildContent()`
- `LayoutBuilder()`
- `_headerText()`
- `_buildAddCommentButton()`
- `_buildEmptyState()`
- `_buildTabButton()`

---

### File: `screens\settlement\layouts\settlement_detail_tables.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailTablesExt`

**Fungsi / Logika Utama:**
- `_buildFundTransferSection()`
- `_buildReturnChecklistTile()`
- `_buildActionCell()`
- `_buildFundReturnSection()`
- `_buildChecklistTile()`

---

## Folder: `screens\settlement\widgets`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\settlement\widgets\widget_file_list.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailFileListExt`

---

### File: `screens\settlement\widgets\widget_insuff_balance_row.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailinsuffBalanceRowExt`

**Fungsi / Logika Utama:**
- `_insuffBalanceRow()`

---

### File: `screens\settlement\widgets\widget_insufficient_balance_dialog.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailInsufficientBalanceDialogExt`

**Fungsi / Logika Utama:**
- `_showInsufficientBalanceDialog()`

---

### File: `screens\settlement\widgets\widget_settlement_detail_actions.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `_SettlementDetailSettlementDetailActionsExt`

---

## Folder: `screens\widgets`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\widgets\common_widgets.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** 10 file lokal (contoh: `screens\main_layout.dart`).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `StatusFilterChip`
- `YearFilterButton`
- `CascadingYearFilter`
- `CascadingMenuItem`
- `CascadingMenuCustom`
- `AppDateRangePicker`
- `_FastRangePickerDialog`
- `_FastRangePickerDialogState`
- `_MenuItemLabel`
- `CascadingStatusFilter`

**Fungsi / Logika Utama:**
- `formatNumber()`
- `build()`: Membangun struktur UI/widget.
- `Material()`
- `show()`
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_onMonthSelected()`
- `_onYearSelected()`
- `_buildPickerContent()`
- `_buildHeaderWithNav()`
- `_buildDayGrid()`
- `GestureDetector()`
- `_buildHeader()`
- `_getMonthName()`
- `_buildTabButton()`

---

### File: `screens\widgets\page_selector.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `screens\main_layout.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `PageSelector`

**Fungsi / Logika Utama:**
- `_getPageName()`
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\widgets\settlement_detail_widgets.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `screens\advance\advance_detail_screen.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SummaryCard`
- `SettlementActionButton`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\widgets\sidebar.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
- **Used By (Digunakan Oleh):** 3 file lokal (contoh: `screens\main_layout.dart`).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `DashboardSidebar`
- `_SidebarNavItem`
- `_SidebarNavItemState`
- `_ExpandedUserPanel`
- `_MiniUserPanel`
- `_BadgePill`
- `_BadgeDot`
- `_SquareIconBtn`
- `_SidebarParentNavItem`
- `_SidebarParentNavItemState`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\widgets\transaction_cards.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `screens\main_layout.dart`).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementCard`
- `_SettlementCardState`
- `AdvanceCard`
- `_AdvanceCardState`
- `StatusBadge`
- `AppRadioGroup`
- `_AppRadioGroupScope`
- `AppRadioItem`

**Fungsi / Logika Utama:**
- `_getDisplayTitle()`
- `_statusColor()`
- `_getRoleName()`
- `_getDateDisplay()`
- `build()`: Membangun struktur UI/widget.
- `_advanceStatusColor()`

---

## Folder: `services`

**Tujuan Folder:** Menangani komunikasi ke luar, seperti pemanggilan API ke backend (HTTP requests).

### File: `services\api_advances.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `ApiServiceAdvancesExt`

---

### File: `services\api_assets.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ApiServiceAssetsExt`

---

### File: `services\api_auth.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ApiServiceAuthExt`

---

### File: `services\api_banks.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ApiServiceBanksExt`

---

### File: `services\api_categories.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ApiServiceCategoriesExt`

---

### File: `services\api_companies.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ApiServiceCompaniesExt`

---

### File: `services\api_database.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ApiServiceDatabaseExt`

**Fungsi / Logika Utama:**
- `getStorageSettings()`
- `updateStorageSettings()`
- `syncDatabase()`

---

### File: `services\api_dividends.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ApiServiceDividendsExt`

---

### File: `services\api_expenses.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ApiServiceExpensesExt`

---

### File: `services\api_master.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ApiServiceMasterExt`

**Fungsi / Logika Utama:**
- `setToken()`
- `setCompany()`
- `getEvidenceUrl()`
- `_networkHint()`

---

### File: `services\api_reports.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ApiServiceReportsExt`

**Fungsi / Logika Utama:**
- `getReportYearSettings()`
- `updateReportYearSettings()`

---

### File: `services\api_revenues.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ApiServiceRevenuesExt`

---

### File: `services\api_service.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
- **Used By (Digunakan Oleh):** 13 file lokal (contoh: `providers\advance_provider.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ApiService`

**Fungsi / Logika Utama:**
- `_buildUrl()`
- `loadSavedBaseUrl()`
- `saveBaseUrl()`
- `checkConnectivity()`
- `_loadTokenFromStorage()`
- `ensureTokenLoaded()`

---

### File: `services\api_settlements.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ApiServiceSettlementsExt`

---

### File: `services\api_taxes.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ApiServiceTaxesExt`

---

### File: `services\api_users.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ApiServiceUsersExt`

---

### File: `services\notification_service.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `providers\notification_provider.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `NotificationService`

---

## Folder: `theme`

**Tujuan Folder:** Menyimpan fungsi-fungsi pembantu (Helpers), utilitas, dan konfigurasi tema global.

### File: `theme\app_theme.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** 47 file lokal (contoh: `main.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AppSpacing`
- `AppBorderRadius`
- `AppFontSize`
- `AppTheme`

**Fungsi / Logika Utama:**
- `getSurfaceColor()`
- `getCardColor()`
- `getTextColor()`
- `getSecondaryTextColor()`
- `getDividerColor()`
- `getCreamColor()`

---

## Folder: `utils`

**Tujuan Folder:** Menyimpan fungsi-fungsi pembantu (Helpers), utilitas, dan konfigurasi tema global.

### File: `utils\app_dialogs.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** 3 file lokal (contoh: `screens\main_layout.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AppDialogs`

**Fungsi / Logika Utama:**
- `InkWell()`
- `showExitConfirmation()`
- `showConfirmDialog()`

---

### File: `utils\app_formatters.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
- **Used By (Digunakan Oleh):** 7 file lokal (contoh: `models\advance_item_model.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AppFormatters`

**Fungsi / Logika Utama:**
- `formatDateForApi()`
- `formatDateForDisplay()`
- `formatDateForFilename()`
- `formatDateTime()`
- `formatCurrency()`
- `formatCurrencyPlain()`
- `_toDouble()`
- `formatTimestamp()`

---

### File: `utils\app_logger.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `services\api_service.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

---

### File: `utils\app_snackbar.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** 4 file lokal (contoh: `main.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AppSnackbar`

---

### File: `utils\context_extensions.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** 9 file lokal (contoh: `screens\dashboard_screen.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ContextExtensions`

---

### File: `utils\currency_formatter.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** 7 file lokal (contoh: `screens\advance\advance_detail_screen.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `CurrencyInputFormatter`

**Fungsi / Logika Utama:**
- `formatEditUpdate()`

---

### File: `utils\exceptions.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

---

### File: `utils\file_helper.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** 6 file lokal (contoh: `screens\main_layout.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `FileHelper`

**Fungsi / Logika Utama:**
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

### File: `utils\responsive_layout.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
- **Used By (Digunakan Oleh):** 8 file lokal (contoh: `screens\main_layout.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ResponsiveLayout`
- `ResponsivePage`
- `ResponsiveScrollView`

**Fungsi / Logika Utama:**
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
- `shouldStackHeaderActions()`
- `build()`: Membangun struktur UI/widget.
- `LayoutBuilder()`

---

### File: `utils\status_colors.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `StatusColors`

**Fungsi / Logika Utama:**
- `getStatusColor()`
- `getStatusDisplay()`
- `getStatusBadgeColor()`

---

## Folder: `widgets`

**Tujuan Folder:** Menyimpan komponen visual (Widget) yang dapat digunakan berulang (Reusable) di berbagai layar.

### File: `widgets\account_list_dialog.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\settings\settings_screen.dart`).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `AccountListDialog`
- `_AccountListDialogState`
- `CreateUserDialog`
- `_CreateUserDialogState`
- `EditUserByManagerDialog`
- `_EditUserByManagerDialogState`
- `_InfoChip`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_loadUsers()`
- `_showCreateUserDialog()`
- `_showEditUserByManager()`
- `_showManageCompaniesDialog()`
- `_canEdit()`
- `_showUserDetail()`
- `build()`: Membangun struktur UI/widget.
- `_buildHeader()`
- `_buildDesktopTable()`
- `_buildRoleBadge()`
- `_buildStatusIndicator()`
- `_getRoleName()`
- `_loadCompanies()`
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `_buildCompanyCheckboxes()`
- `_submit()`

---

### File: `widgets\app_brand_logo.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
- **Used By (Digunakan Oleh):** 4 file lokal (contoh: `screens\auth\loading_screen.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AppBrandLogo`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `widgets\app_scrollbar.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** 13 file lokal (contoh: `main.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AppScrollbar`
- `_AppScrollbarState`
- `_CenteredArrow`

**Fungsi / Logika Utama:**
- `_startScrolling()`
- `_stopScrolling()`
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `build()`: Membangun struktur UI/widget.
- `Listener()`
- `_buildArrows()`

---

### File: `widgets\category_preview_dialog.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `screens\advance\advance_detail_screen.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `CategoryPreviewDialog`
- `_CategoryPreviewDialogState`

**Fungsi / Logika Utama:**
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `build()`: Membangun struktur UI/widget.
- `showCategoryPreviewDialog()`

---

### File: `widgets\image_cropper_dialog.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `screens\settings\settings_screen.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ImageCropperDialog`
- `_ImageCropperDialogState`
- `CircleMaskPainter`

**Fungsi / Logika Utama:**
- `_cropAndSave()`
- `build()`: Membangun struktur UI/widget.
- `paint()`

---

### File: `widgets\item_detail_preview_dialog.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `screens\advance\advance_detail_screen.dart`).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `ItemDetailPreviewDialog`
- `_ItemDetailPreviewDialogState`

**Fungsi / Logika Utama:**
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `_formatAmount()`
- `build()`: Membangun struktur UI/widget.
- `_buildFieldRow()`
- `_showCommentsDialog()`
- `_getStatusColor()`
- `_getStatusIcon()`

---

### File: `widgets\manage_companies_dialog.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** 1 file lokal (contoh: `widgets\account_list_dialog.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ManageCompaniesDialog`
- `_ManageCompaniesDialogState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_loadCompanies()`
- `_addCompany()`
- `_editCompany()`
- `_deleteCompany()`
- `_saveReorder()`
- `build()`: Membangun struktur UI/widget.

---

### File: `widgets\notification_bell_icon.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** 3 file lokal (contoh: `screens\main_layout.dart`).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `NotificationBellIcon`
- `_NotificationBellIconState`

**Fungsi / Logika Utama:**
- `_closeNotificationPanel()`
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_onScroll()`
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `_toggleNotificationPanel()`
- `_showNotificationPanel()`
- `IconButton()`
- `Expanded()`
- `_hasNavigablePath()`
- `_openButtonLabel()`
- `_openNotificationTarget()`
- `_buildNotificationItem()`
- `build()`: Membangun struktur UI/widget.

---

### File: `widgets\user_detail_dialog.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `screens\widgets\transaction_cards.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `UserDetailDialog`
- `_UserDetailDialogState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_fetchUserData()`
- `build()`: Membangun struktur UI/widget.
- `_buildContent()`
- `_detailItem()`
- `_getRoleName()`

---

### File: `widgets\workflow_timeline.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** 2 file lokal (contoh: `screens\advance\advance_detail_screen.dart`).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `WorkflowTimeline`
- `_TimelineItem`
- `_InfoPill`
- `_EmptyTimeline`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.
- `_stageLabel()`
- `_actionLabel()`
- `_actionIcon()`
- `_actionColor()`

---

## Folder: `widgets\details`

**Tujuan Folder:** Menyimpan komponen visual (Widget) yang dapat digunakan berulang (Reusable) di berbagai layar.

### File: `widgets\details\evidence_viewer.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `EvidenceViewer`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.
- `_buildPdfPlaceholder()`
- `_buildImage()`

---

