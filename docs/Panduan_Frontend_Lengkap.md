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

## Folder: `controllers`

### File: `controllers\settlement_list_controller.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementListController`

**Fungsi / Logika Utama:**
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

### File: `models\advance_item_model.dart`

**Tanggung Jawab (Responsibility):**
- Mendefinisikan entitas data agar dapat dikenali dan diproses dengan aman (Type-safe) oleh Dart.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceItemRequest`

---

## Folder: `providers\advance`

**Tujuan Folder:** Mengelola state aplikasi (State Management) dan logika bisnis utama (Controllers).

### File: `providers\advance\advance_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `InsufficientAdvanceBalanceException`
- `AdvanceProvider`

**Fungsi / Logika Utama:**
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

### File: `providers\advance\advance_provider_finance_ext.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceProviderFinanceExt`

**Fungsi / Logika Utama:**
- `saveDisbursement()`
- `approveDisbursement()`
- `saveReturn()`

---

### File: `providers\advance\advance_provider_item_ext.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceProviderItemExt`

**Fungsi / Logika Utama:**
- `addAdvanceItem()`
- `updateAdvanceItem()`
- `deleteAdvanceItem()`
- `bulkDeleteAdvanceItems()`
- `updateAdvanceItemsBulk()`

---

### File: `providers\advance\advance_provider_list_ext.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceProviderListExt`

**Fungsi / Logika Utama:**
- `loadAdvances()`
- `clearFilters()`
- `syncReportYear()`
- `setReportYear()`
- `setFilterYear()`
- `loadAdvance()`
- `loadHistory()`

---

### File: `providers\advance\advance_provider_workflow_ext.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceProviderWorkflowExt`

**Fungsi / Logika Utama:**
- `submitAdvance()`
- `approveAdvance()`
- `approveAdvanceItem()`
- `rejectAdvance()`
- `startRevision()`

---

## Folder: `providers\auth`

**Tujuan Folder:** Mengelola state aplikasi (State Management) dan logika bisnis utama (Controllers).

### File: `providers\auth\auth_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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

## Folder: `providers\core`

**Tujuan Folder:** Mengelola state aplikasi (State Management) dan logika bisnis utama (Controllers).

### File: `providers\core\base_provider.dart`

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

### File: `providers\core\cascade_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 10 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `CascadeProvider`

**Fungsi / Logika Utama:**
- `syncReportYear()`
- `syncAllFromSettings()`

---

### File: `providers\core\notification_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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

### File: `providers\core\theme_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ThemeProvider`

**Fungsi / Logika Utama:**
- `_loadThemeMode()`
- `setThemeMode()`
- `_parseThemeMode()`

---

## Folder: `providers\master_data`

**Tujuan Folder:** Mengelola state aplikasi (State Management) dan logika bisnis utama (Controllers).

### File: `providers\master_data\bank_management_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- `deleteBankAccount()`

---

### File: `providers\master_data\bank_status_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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

### File: `providers\master_data\tax_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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

## Folder: `providers\settlement`

**Tujuan Folder:** Mengelola state aplikasi (State Management) dan logika bisnis utama (Controllers).

### File: `providers\settlement\settlement_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementProvider`

**Fungsi / Logika Utama:**
- `_loadSortMode()`
- `initialize()`
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `updateToken()`
- `clearData()`
- `setSortMode()`
- `getEvidenceUrl()`

---

### File: `providers\settlement\settlement_provider_bank_ext.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementProviderBankExt`

**Fungsi / Logika Utama:**
- `loadBanks()`
- `loadAdvanceBanks()`

---

### File: `providers\settlement\settlement_provider_category_ext.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementProviderCategoryExt`

**Fungsi / Logika Utama:**
- `loadCategories()`
- `loadPendingCategories()`
- `createCategory()`
- `updateCategory()`
- `reorderCategories()`
- `deleteCategory()`
- `approveCategory()`

---

### File: `providers\settlement\settlement_provider_crud_ext.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementProviderCrudExt`

**Fungsi / Logika Utama:**
- `updateSettlement()`
- `deleteSettlement()`

---

### File: `providers\settlement\settlement_provider_expense_ext.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementProviderExpenseExt`

**Fungsi / Logika Utama:**
- `saveFirstExpenseAndCommitSettlement()`
- `cleanupEmptyDraft()`
- `addExpense()`
- `updateExpense()`
- `updateExpenseData()`
- `updateExpensesBulk()`
- `deleteExpense()`
- `bulkDeleteExpenses()`

---

### File: `providers\settlement\settlement_provider_finance_ext.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementProviderFinanceExt`

**Fungsi / Logika Utama:**
- `saveDisbursement()`
- `approveDisbursement()`
- `saveReturn()`
- `finalApproveSettlement()`

---

### File: `providers\settlement\settlement_provider_list_ext.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementProviderListExt`

**Fungsi / Logika Utama:**
- `loadSettlements()`
- `clearFilters()`
- `loadSettlement()`
- `loadHistory()`
- `syncReportYear()`
- `setReportYear()`
- `setFilterYear()`
- `setFilterMode()`

---

### File: `providers\settlement\settlement_provider_workflow_ext.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementProviderWorkflowExt`

**Fungsi / Logika Utama:**
- `submitSettlement()`
- `completeSettlement()`
- `approveSettlement()`
- `approveExpense()`
- `approveAllSettlement()`
- `rejectAllSettlement()`
- `rejectAllExpenses()`
- `moveSettlementToDraft()`

---

## Folder: `providers\transactions`

**Tujuan Folder:** Mengelola state aplikasi (State Management) dan logika bisnis utama (Controllers).

### File: `providers\transactions\asset_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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

### File: `providers\transactions\dividend_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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

### File: `providers\transactions\revenue_provider.dart`

**Tanggung Jawab (Responsibility):**
- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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

## Folder: `screens\advance`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\advance\advance_detail_actions.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 13 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailActionsExt`

**Fungsi / Logika Utama:**
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
- `fetchActiveAdvanceBalance()`

---

### File: `screens\advance\advance_detail_previews.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 12 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailPreviewsExt`

**Fungsi / Logika Utama:**
- `buildPreviewRow()`
- `showAllItemsPreview()`
- `showDisbursementPreview()`
- `showItemPreview()`

---

### File: `screens\advance\advance_detail_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 25 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailScreen`
- `AdvanceDetailScreenState`

**Fungsi / Logika Utama:**
- `handleMobilePageSelection()`
- `confirmLogout()`
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
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
- `build()`: Membangun struktur UI/widget.
- `handlePop()`
- `PopScope()`

---

### File: `screens\advance\advances_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 18 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvancesScreen`
- `AdvancesScreenState`

**Fungsi / Logika Utama:**
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
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `onProviderChange()`
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `build()`: Membangun struktur UI/widget.
- `LayoutBuilder()`
- `deleteAdvance()`

---

### File: `screens\advance\advances_screen_dialogs.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 16 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvancesScreenDialogs`

**Fungsi / Logika Utama:**
- `showStandaloneReturnDialog()`
- `showCreateDialog()`

---

## Folder: `screens\advance\dialogs`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\advance\dialogs\dialog_add_category.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailDialogsExpenseshowAddCategoryDialogExt`

---

### File: `screens\advance\dialogs\dialog_add_item.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 16 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailDialogsExpenseshowAddItemDialogExt`

**Fungsi / Logika Utama:**
- `showAddItemDialog()`

---

### File: `screens\advance\dialogs\dialog_checklist.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailDialogsGeneralshowChecklistDialogExt`

**Fungsi / Logika Utama:**
- `showChecklistDialog()`
- `buildChecklistTile()`

---

### File: `screens\advance\dialogs\dialog_comments.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailDialogsGeneralshowCommentsDialogExt`

**Fungsi / Logika Utama:**
- `showCommentsDialog()`

---

### File: `screens\advance\dialogs\dialog_disbursement_evidence_cell.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailDialogsGeneralbuildDisbursementEvidenceCellExt`

**Fungsi / Logika Utama:**
- `buildDisbursementEvidenceCell()`

---

### File: `screens\advance\dialogs\dialog_edit_advance.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailDialogsGeneralshowEditAdvanceDialogExt`

**Fungsi / Logika Utama:**
- `showEditAdvanceDialog()`

---

### File: `screens\advance\dialogs\dialog_edit_disbursement.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 10 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailDialogsGeneralshowEditDisbursementDialogExt`

**Fungsi / Logika Utama:**
- `showEditDisbursementDialog()`

---

### File: `screens\advance\dialogs\dialog_evidence.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailDialogsGeneralshowEvidenceExt`

**Fungsi / Logika Utama:**
- `showEvidence()`
- `InkWell()`

---

### File: `screens\advance\dialogs\dialog_get_comments_from_notes.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailDialogsGeneralgetCommentsFromNotesExt`

---

### File: `screens\advance\dialogs\dialog_insufficient_balance.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailDialogsGeneralshowInsufficientBalanceDialogExt`

**Fungsi / Logika Utama:**
- `showInsufficientBalanceDialog()`

---

### File: `screens\advance\dialogs\dialog_parse_plain_comments.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailDialogsGeneralparsePlainCommentsExt`

---

### File: `screens\advance\dialogs\dialog_plain_comments.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailDialogsGeneralshowPlainCommentsDialogExt`

**Fungsi / Logika Utama:**
- `showPlainCommentsDialog()`

---

### File: `screens\advance\dialogs\dialog_workflow_timeline.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailDialogsGeneralshowWorkflowTimelineDialogExt`

**Fungsi / Logika Utama:**
- `showWorkflowTimelineDialog()`

---

## Folder: `screens\advance\layouts`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\advance\layouts\advance_detail_layout.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailLayoutExt`

**Fungsi / Logika Utama:**
- `formatItemAmount()`
- `hasUncheckedChecklist()`

---

### File: `screens\advance\layouts\advance_detail_tables.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 19 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailTablesExt`

**Fungsi / Logika Utama:**
- `buildChecklistTile()`
- `buildPendingRichText()`
- `buildItemsTable()`
- `buildAdvanceFundTransferSection()`

---

## Folder: `screens\advance\widgets`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\advance\widgets\advances_widgets.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
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
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailLayoutAddCommentButtonExt`

**Fungsi / Logika Utama:**
- `buildAddCommentButton()`

---

### File: `screens\advance\widgets\widget_advance_detail_actions.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 12 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailLayoutAdvanceDetailActionsExt`

---

### File: `screens\advance\widgets\widget_content.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 10 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailLayoutContentExt`

**Fungsi / Logika Utama:**
- `buildContent()`

---

### File: `screens\advance\widgets\widget_empty_state.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailLayoutEmptyStateExt`

**Fungsi / Logika Utama:**
- `buildEmptyState()`

---

### File: `screens\advance\widgets\widget_file_list.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailLayoutFileListExt`

---

### File: `screens\advance\widgets\widget_insuff_balance_row.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailLayoutinsuffBalanceRowExt`

**Fungsi / Logika Utama:**
- `insuffBalanceRow()`

---

### File: `screens\advance\widgets\widget_mobile_advance_action_bar.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailLayoutMobileAdvanceActionBarExt`

**Fungsi / Logika Utama:**
- `buildMobileAdvanceActionBar()`

---

### File: `screens\advance\widgets\widget_scrollable_advance_header.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 10 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvancesWidgetsScrollableAdvanceHeaderExt`

**Fungsi / Logika Utama:**
- `buildScrollableAdvanceHeader()`

---

### File: `screens\advance\widgets\widget_toggle_button.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvancesWidgetsToggleButtonExt`

**Fungsi / Logika Utama:**
- `buildToggleButton()`

---

### File: `screens\advance\widgets\widget_type_toggle.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvancesWidgetsTypeToggleExt`

**Fungsi / Logika Utama:**
- `buildTypeToggle()`

---

### File: `screens\advance\widgets\widget_warning_box.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvanceDetailLayoutWarningBoxExt`

**Fungsi / Logika Utama:**
- `buildWarningBox()`

---

### File: `screens\advance\widgets\widget_year_summary_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AdvancesWidgetsYearSummaryCardExt`

**Fungsi / Logika Utama:**
- `buildYearSummaryCard()`

---

## Folder: `screens\auth`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\auth\loading_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `LoadingScreen`
- `LoadingScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\login_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 11 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `LoginScreen`
- `LoginScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `loadSavedCredentials()`
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `loadServerUrl()`
- `showServerUrlDialog()`
- `login()`
- `navigateToRegister()`
- `showMessage()`
- `handleGoogleLogin()`
- `showForgotPasswordDialog()`
- `StatefulBuilder()`
- `submit()`
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\login_widget_gmail_login_button.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `GmailLoginButton`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.
- `Material()`

---

### File: `screens\auth\login_widget_landscape_intro_panel.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `LandscapeIntroPanel`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\login_widget_landscape_login_content.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `LandscapeLoginContent`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\login_widget_login_brand_icon.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `LoginBrandIcon`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\login_widget_login_button.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `LoginButton`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.
- `SizedBox()`

---

### File: `screens\auth\login_widget_login_hint_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `LoginHintCard`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\login_widget_password_field.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `PasswordField`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\login_widget_portrait_login_content.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `PortraitLoginContent`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\login_widget_register_link.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `RegisterLink`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\login_widget_username_field.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `UsernameField`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `RegisterScreen`
- `RegisterScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `register()`
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_back_button.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `CustomBackButton`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_company_dropdown.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `CompanyDropdown`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_confirm_password_field.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ConfirmPasswordField`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_email_field.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `EmailField`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_full_name_field.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `FullNameField`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_landscape_intro_panel.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `LandscapeIntroPanel`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_landscape_register_content.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 14 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `LandscapeRegisterContent`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_password_field.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `PasswordField`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_phone_field.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `PhoneField`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_portrait_register_content.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 14 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `PortraitRegisterContent`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_register_brand_icon.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `RegisterBrandIcon`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_register_button.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `RegisterButton`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_role_dropdown.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `RoleDropdown`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_username_field.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `UsernameField`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\register_widget_workplace_field.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `WorkplaceField`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\auth\server_error_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ServerErrorScreen`
- `ServerErrorScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `showServerUrlDialog()`
- `retry()`
- `build()`: Membangun struktur UI/widget.

---

## Folder: `screens\dashboard`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\dashboard\dashboard_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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

## Folder: `screens\layout`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\layout\main_layout.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 31 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `MainLayout`
- `MainLayoutState`

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

---

### File: `screens\layout\main_layout_settlement_list.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 19 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementListView`
- `SettlementListViewState`

**Fungsi / Logika Utama:**
- `handleListScroll()`
- `scrollToTop()`
- `scheduleSettlementReload()`
- `resetFilters()`
- `toggleItemSelection()`
- `bulkDeleteItems()`
- `setState()`
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `onProviderChange()`
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `loadDefaultReportYearAndReload()`
- `loadDashboardSummary()`
- `loadAnnualSettlementSummary()`
- `updateState()`
- `reloadSettlements()`
- `pickDateRange()`
- `exportExcel()`
- `exportPdf()`
- `build()`: Membangun struktur UI/widget.
- `LayoutBuilder()`

---

### File: `screens\layout\main_layout_settlement_list_dialogs.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 15 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementListDialogs`

**Fungsi / Logika Utama:**
- `showStandaloneReturnDialog()`
- `showCreateDialog()`

---

### File: `screens\layout\main_layout_widgets.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `DashboardWidgetsExt`
- `_FilterChipWidget`
- `StatusFilterChip`

**Fungsi / Logika Utama:**
- `deleteSettlement()`
- `build()`: Membangun struktur UI/widget.

---

## Folder: `screens\main_layout_components`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\main_layout_components\widget_summary_cards.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `WidgetSummaryCards`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

## Folder: `screens\management`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\management\asset_management_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AssetManagementScreen`
- `AssetManagementScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `loadData()`
- `clampInput()`
- `displayDate()`
- `confirmDelete()`
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\management\bank_advance_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankAdvanceScreen`
- `BankAdvanceScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `loadData()`
- `showManageBalanceDialog()`
- `getBankSortIndex()`
- `getTotalAllocation()`
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\management\bank_management_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 12 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankManagementScreen`
- `BankManagementScreenState`

**Fungsi / Logika Utama:**
- `updateState()`
- `loadPreferenceOrders()`
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\management\bank_management_screen_actions.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankManagementActionsExt`

**Fungsi / Logika Utama:**
- `loadData()`
- `loadAdvanceData()`
- `displayDate()`
- `getBankSortIndex()`

---

### File: `screens\management\bank_management_screen_layout.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankManagementLayoutExt`

---

### File: `screens\management\bank_management_screen_tables.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankManagementTablesExt`

**Fungsi / Logika Utama:**
- `buildLogGridItem()`

---

### File: `screens\management\bank_status_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankStatusScreen`
- `BankStatusScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `loadData()`
- `displayDate()`
- `getBankSortIndex()`
- `showTransactionDialog()`
- `deleteTransaction()`
- `build()`: Membangun struktur UI/widget.
- `buildBankFilter()`

---

### File: `screens\management\category_management_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `CategoryManagementView`
- `CategoryManagementViewState`

**Fungsi / Logika Utama:**
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `build()`: Membangun struktur UI/widget.
- `LayoutBuilder()`
- `buildCategoryTile()`
- `buildPendingItem()`
- `showAddCategoryDialog()`
- `showEditCategoryDialog()`
- `deleteCategory()`
- `approveCategory()`

---

### File: `screens\management\category_tabular_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `CategoryTabularScreen`
- `CategoryTabularScreenState`

**Fungsi / Logika Utama:**
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `loadData()`
- `saveChanges()`
- `showSnackBar()`
- `build()`: Membangun struktur UI/widget.
- `saveAllGroupsAndCategories()`
- `showManageGroupsDialog()`
- `addGroup()`
- `editGroup()`
- `deleteGroup()`
- `syncTempCatsOrderDynamic()`

---

### File: `screens\management\dialog_advance_log_book.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankManagementDialogsshowAdvanceLogBookDialogExt`
- `AdvanceLogBookModal`
- `_AdvanceLogBookModalState`

**Fungsi / Logika Utama:**
- `showAdvanceLogBookDialogHelper()`
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `fetchLogs()`
- `buildLogGridItem()`
- `buildAuditTrailLogItem()`
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\management\dialog_bank_account.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 10 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankManagementDialogsshowBankAccountDialogExt`

**Fungsi / Logika Utama:**
- `showBankAccountDialog()`
- `Builder()`
- `_showDeleteConfirmation()`
- `StatefulBuilder()`

---

### File: `screens\management\dialog_bank_advance_detail.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 11 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankManagementDialogsshowBankAdvanceDetailModalExt`

**Fungsi / Logika Utama:**
- `showBankAdvanceDetailModal()`

---

### File: `screens\management\dialog_bank_cash_detail.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankManagementDialogsshowBankCashDetailModalExt`

**Fungsi / Logika Utama:**
- `showBankCashDetailModal()`

---

### File: `screens\management\dialog_bank_cash_log_book.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 10 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankManagementDialogsshowBankCashLogBookDialogExt`

**Fungsi / Logika Utama:**
- `showBankCashLogBookDialog()`
- `AppScrollbar()`

---

### File: `screens\management\dialog_edit_advance_balance.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 10 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankManagementDialogsshowEditAdvanceBalanceDialogExt`

**Fungsi / Logika Utama:**
- `showEditAdvanceBalanceDialog()`
- `getTotalAllocation()`

---

### File: `screens\management\dialog_edit_advance_opening_balance.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankManagementDialogsshowEditAdvanceOpeningBalanceDialogExt`

**Fungsi / Logika Utama:**
- `showEditAdvanceOpeningBalanceDialog()`

---

### File: `screens\management\dividend_management_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `DividendManagementScreen`
- `DividendManagementScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
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
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\management\logbook_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `LogbookScreen`
- `LogbookScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `fetchLogs()`
- `buildLogGridItem()`
- `buildAuditTrailLogItem()`
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\management\revenue_management_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 12 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `RevenueManagementScreen`
- `RevenueManagementScreenState`

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
- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `RevenueManagementActionsExt`

**Fungsi / Logika Utama:**
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

### File: `screens\management\revenue_management_screen_dialogs.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `RevenueManagementDialogsExt`

**Fungsi / Logika Utama:**
- `formatNumericInput()`
- `showRevenueDialog()`
- `pickDate()`
- `showConfirmDialog()`

---

### File: `screens\management\revenue_management_screen_tables.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `RevenueManagementTablesExt`

**Fungsi / Logika Utama:**
- `buildCell()`

---

### File: `screens\management\tax_management_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 12 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `TaxManagementScreen`
- `TaxManagementScreenState`

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
- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `TaxManagementActionsExt`

**Fungsi / Logika Utama:**
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

### File: `screens\management\tax_management_screen_dialogs.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `TaxManagementDialogsExt`

**Fungsi / Logika Utama:**
- `formatNumericInput()`
- `showTaxDialog()`
- `pickDate()`
- `StatefulBuilder()`
- `showConfirmDialog()`

---

### File: `screens\management\tax_management_screen_tables.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `TaxManagementTablesExt`

**Fungsi / Logika Utama:**
- `buildCell()`

---

### File: `screens\management\widget_advance_section.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankManagementLayoutAdvanceSectionExt`

**Fungsi / Logika Utama:**
- `buildAdvanceSection()`
- `Builder()`

---

### File: `screens\management\widget_audit_trail_log_item.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankManagementLayoutAuditTrailLogItemExt`

**Fungsi / Logika Utama:**
- `buildAuditTrailLogItem()`

---

### File: `screens\management\widget_bank_accounts_tab.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankManagementLayoutBankAccountsTabExt`

**Fungsi / Logika Utama:**
- `buildBankAccountsTab()`

---

### File: `screens\management\widget_group_management_dialog.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `CategoryTabularScreenGroupManagementDialogExt`

**Fungsi / Logika Utama:**
- `showGroupManagementDialog()`
- `moveItem()`
- `buildKanbanContent()`

---

### File: `screens\management\widget_kanban_column_dynamic.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `CategoryTabularScreenKanbanColumnDynamicExt`

---

### File: `screens\management\widget_section_toggle.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankManagementLayoutSectionToggleExt`

**Fungsi / Logika Utama:**
- `buildSectionToggle()`

---

### File: `screens\management\widget_simple_category_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `CategoryTabularScreenSimpleCategoryCardExt`

**Fungsi / Logika Utama:**
- `buildSimpleCategoryCard()`

---

### File: `screens\management\widget_toggle_button.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankManagementLayoutToggleButtonExt`

**Fungsi / Logika Utama:**
- `buildToggleButton()`

---

## Folder: `screens\management\dialogs`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\management\dialogs\dialog_asset_form.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Fungsi / Logika Utama:**
- `showAssetDialog()`
- `calculatePreview()`
- `parseVal()`

---

### File: `screens\management\dialogs\dialog_ndpv_table.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Fungsi / Logika Utama:**
- `showNdpvTable()`

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
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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

## Folder: `screens\manager\widgets`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\manager\widgets\widget_manager_approval_table.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `WidgetManagerApprovalTable`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\manager\widgets\widget_manager_summary_cards.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `WidgetManagerSummaryCards`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

## Folder: `screens\reports`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\reports\report_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 14 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportHelpersExt`

**Fungsi / Logika Utama:**
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

### File: `screens\reports\annual_report\annual_report_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 29 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportScreen`
- `AnnualReportScreenState`

**Fungsi / Logika Utama:**
- `updateState()`
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `onProviderChange()`
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
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
- `navToDetail()`
- `parseDate()`
- `build()`: Membangun struktur UI/widget.
- `Listener()`
- `navTo()`

---

### File: `screens\reports\annual_report\annual_report_state.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ReportTableData`

---

### File: `screens\reports\annual_report\annual_report_tables.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportTablesExt`

**Fungsi / Logika Utama:**
- `mergeInto()`
- `addExpenseGroup()`
- `isNumericLikeCell()`

---

### File: `screens\reports\annual_report\annual_report_widgets.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportWidgetsExt`

---

### File: `screens\reports\annual_report\widget_all_tables.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportTablesAllTablesExt`

**Fungsi / Logika Utama:**
- `processAllTables()`

---

### File: `screens\reports\annual_report\widget_bank_expense_table.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportTablesBankExpenseTableExt`

---

### File: `screens\reports\annual_report\widget_cache_info.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportWidgetsCacheInfoExt`

**Fungsi / Logika Utama:**
- `buildCacheInfo()`

---

### File: `screens\reports\annual_report\widget_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportWidgetsCardExt`

**Fungsi / Logika Utama:**
- `buildCard()`

---

### File: `screens\reports\annual_report\widget_display_tables.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportWidgetsDisplayTablesExt`

---

### File: `screens\reports\annual_report\widget_evidence_button.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportWidgetsEvidenceButtonExt`

**Fungsi / Logika Utama:**
- `buildEvidenceButton()`

---

### File: `screens\reports\annual_report\widget_expense_table_cell.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportWidgetsExpenseTableCellExt`

**Fungsi / Logika Utama:**
- `buildExpenseTableCell()`

---

### File: `screens\reports\annual_report\widget_report_header.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportWidgetsReportHeaderExt`

**Fungsi / Logika Utama:**
- `buildReportHeader()`

---

### File: `screens\reports\annual_report\widget_show_evidence_popup.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportWidgetsshowEvidencePopupExt`

**Fungsi / Logika Utama:**
- `showEvidencePopup()`

---

### File: `screens\reports\annual_report\widget_status_cell.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportWidgetsStatusCellExt`

**Fungsi / Logika Utama:**
- `buildStatusCell()`

---

### File: `screens\reports\annual_report\widget_summary_cards.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportWidgetsSummaryCardsExt`

**Fungsi / Logika Utama:**
- `buildSummaryCards()`

---

### File: `screens\reports\annual_report\widget_table4_a_and4_b.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportTablesTable4AAnd4BExt`

**Fungsi / Logika Utama:**
- `processTable4AAnd4B()`
- `getFilteredCatIndex()`

---

### File: `screens\reports\annual_report\widget_table4_c_and4_d.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportTablesTable4CAnd4DExt`

**Fungsi / Logika Utama:**
- `processTable4CAnd4D()`
- `getFilteredCatIndex()`

---

### File: `screens\reports\annual_report\widget_table_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportWidgetsTableCardExt`

**Fungsi / Logika Utama:**
- `buildTableCard()`
- `Builder()`
- `SizedBox()`
- `Column()`

---

### File: `screens\reports\annual_report\widget_tax_toggle_cell.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AnnualReportWidgetsTaxToggleCellExt`

**Fungsi / Logika Utama:**
- `buildTaxToggleCell()`

---

## Folder: `screens\scratch`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\scratch\main_layout_combined.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 40 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
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
- `_deleteSettlement()`
- `_buildTypeToggle()`
- `_buildToggleButton()`
- `_buildScrollableSettlementHeader()`
- `CascadingYearFilter()`
- `_buildSummaryCards()`
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
- `LayoutBuilder()`
- `_showStandaloneReturnDialog()`
- `_showCreateDialog()`

---

## Folder: `screens\settings`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\settings\balance_sheet_settings_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BalanceSheetSettingsScreen`
- `BalanceSheetSettingsScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `loadData()`
- `toDouble()`
- `formatPlain()`
- `saveSettings()`
- `field()`
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\settings\data_cleanup_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `DataCleanupScreen`
- `DataCleanupScreenState`

**Fungsi / Logika Utama:**
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `nextPage()`
- `prevPage()`
- `fetchPreview()`
- `executeCleanup()`
- `showError()`
- `isNextEnabled()`
- `build()`: Membangun struktur UI/widget.
- `buildProgressIndicator()`
- `buildYearSelection()`
- `buildModuleSelection()`
- `buildPreviewStep()`
- `buildConfirmationStep()`
- `buildSelectionCard()`
- `buildBottomNav()`

---

### File: `screens\settings\deadline_manager_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `DeadlineManagerScreen`
- `DeadlineRuleConfig`
- `DeadlineManagerScreenState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `loadDeadlineSettings()`
- `saveSetting()`
- `showAddDayDialog()`
- `removeDay()`
- `build()`: Membangun struktur UI/widget.
- `buildHeaderInfo()`
- `buildModernRuleCard()`
- `buildDayChip()`

---

### File: `screens\settings\dialog_custom_bank_order.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `DialogCustomBankOrder`
- `_DialogCustomBankOrderState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `_loadData()`
- `_saveOrder()`
- `_resetOrder()`
- `build()`: Membangun struktur UI/widget.
- `_buildCashReorderList()`
- `_buildAdvanceReorderList()`
- `_getTemplateSortIndex()`

---

### File: `screens\settings\settings_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 16 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettingsScreen`
- `SettingsScreenState`
- `EditProfileDialog`
- `EditProfileDialogState`

**Fungsi / Logika Utama:**
- `updateState()`
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `build()`: Membangun struktur UI/widget.
- `pickImage()`
- `submit()`

---

### File: `screens\settings\settings_screen_actions.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 14 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettingsActionsExt`

**Fungsi / Logika Utama:**
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

### File: `screens\settings\settings_screen_dialogs.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettingsDialogsExt`

**Fungsi / Logika Utama:**
- `showImportPreviewDialog()`
- `showEditProfileDialog()`

---

### File: `screens\settings\settings_screen_layout.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettingsLayoutExt`

---

### File: `screens\settings\widget_bank_advance_widget.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettingsLayoutBankAdvanceWidgetExt`

**Fungsi / Logika Utama:**
- `buildBankAdvanceWidget()`
- `GestureDetector()`

---

### File: `screens\settings\widget_bank_order_settings_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettingsLayoutBankOrderSettingsCardExt`

**Fungsi / Logika Utama:**
- `buildBankOrderSettingsCard()`

---

### File: `screens\settings\widget_cleanup_settings_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettingsLayoutCleanupSettingsCardExt`

**Fungsi / Logika Utama:**
- `buildCleanupSettingsCard()`

---

### File: `screens\settings\widget_database_settings_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettingsLayoutDatabaseSettingsCardExt`

**Fungsi / Logika Utama:**
- `buildDatabaseSettingsCard()`

---

### File: `screens\settings\widget_deadline_settings_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettingsLayoutDeadlineSettingsCardExt`

**Fungsi / Logika Utama:**
- `buildDeadlineSettingsCard()`

---

### File: `screens\settings\widget_logbook_button.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettingsLayoutLogbookButtonExt`

**Fungsi / Logika Utama:**
- `buildLogbookButton()`

---

### File: `screens\settings\widget_manager_section.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettingsLayoutManagerSectionExt`

**Fungsi / Logika Utama:**
- `buildManagerSection()`

---

### File: `screens\settings\widget_profile_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettingsLayoutProfileCardExt`

**Fungsi / Logika Utama:**
- `buildProfileCard()`

---

### File: `screens\settings\widget_report_year_settings_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettingsLayoutReportYearSettingsCardExt`

**Fungsi / Logika Utama:**
- `buildReportYearSettingsCard()`

---

### File: `screens\settings\widget_storage_settings_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettingsLayoutStorageSettingsCardExt`

**Fungsi / Logika Utama:**
- `buildStorageSettingsCard()`

---

### File: `screens\settings\widget_theme_settings_card.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettingsLayoutThemeSettingsCardExt`

**Fungsi / Logika Utama:**
- `buildThemeSettingsCard()`

---

## Folder: `screens\settlement`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\settlement\settlement_detail_actions.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 15 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementDetailActionsExt`

**Fungsi / Logika Utama:**
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
- `fetchActiveAdvanceBalance()`
- `showWorkflowTimelineDialog()`

---

### File: `screens\settlement\settlement_detail_previews.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 11 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementDetailPreviewsExt`

**Fungsi / Logika Utama:**
- `showItemPreview()`
- `showAllItemsPreview()`
- `StatefulBuilder()`
- `buildPreviewRow()`
- `buildDisbursementPreviewContent()`
- `buildAllItemsPreviewList()`
- `showDisbursementPreview()`

---

### File: `screens\settlement\settlement_detail_screen.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 25 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementDetailScreen`
- `SettlementDetailScreenState`

**Fungsi / Logika Utama:**
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
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
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementDetailDialogsExpenseshowAddCategoryDialogExt`

---

### File: `screens\settlement\dialogs\dialog_add_expense.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 13 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementDetailDialogsExpenseshowAddExpenseDialogExt`

**Fungsi / Logika Utama:**
- `showAddExpenseDialog()`
- `calculateRemainingForSource()`
- `StatefulBuilder()`

---

### File: `screens\settlement\dialogs\dialog_checklist.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementDetailDialogsGeneralshowChecklistDialogExt`

**Fungsi / Logika Utama:**
- `showChecklistDialog()`
- `buildChecklistTile()`

---

### File: `screens\settlement\dialogs\dialog_comments.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementDetailDialogsGeneralshowCommentsDialogExt`

**Fungsi / Logika Utama:**
- `showCommentsDialog()`

---

### File: `screens\settlement\dialogs\dialog_edit_disbursement.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 11 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementDetailDialogsGeneralshowEditDisbursementDialogExt`

**Fungsi / Logika Utama:**
- `showEditDisbursementDialog()`

---

### File: `screens\settlement\dialogs\dialog_edit_expense.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 12 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementDetailDialogsExpenseshowEditExpenseDialogExt`

**Fungsi / Logika Utama:**
- `showEditExpenseDialog()`
- `calculateRemainingForSource()`
- `StatefulBuilder()`

---

### File: `screens\settlement\dialogs\dialog_edit_settlement.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementDetailDialogsGeneralshowEditSettlementDialogExt`

**Fungsi / Logika Utama:**
- `showEditSettlementDialog()`

---

### File: `screens\settlement\dialogs\dialog_evidence.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementDetailDialogsGeneralshowEvidenceExt`

**Fungsi / Logika Utama:**
- `showEvidence()`
- `InkWell()`

---

### File: `screens\settlement\dialogs\dialog_plain_comments.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementDetailDialogsGeneralshowPlainCommentsDialogExt`

**Fungsi / Logika Utama:**
- `showPlainCommentsDialog()`

---

## Folder: `screens\settlement\layouts`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\settlement\layouts\settlement_detail_layout.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 14 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementDetailLayoutExt`

**Fungsi / Logika Utama:**
- `buildMobileSettlementActionBar()`
- `buildContent()`
- `headerText()`
- `buildAddCommentButton()`
- `buildEmptyState()`
- `buildPendingRichText()`
- `buildTabButton()`

---

### File: `screens\settlement\layouts\settlement_detail_tables.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementDetailTablesExt`

**Fungsi / Logika Utama:**
- `buildFundTransferSection()`
- `buildActionCell()`
- `buildChecklistTile()`

---

## Folder: `screens\settlement\widgets`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\settlement\widgets\widget_expense_form_fields.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `WidgetExpenseFormFields`

**Fungsi / Logika Utama:**
- `buildDescriptionField()`
- `buildAmountField()`
- `buildExchangeRateField()`

---

### File: `screens\settlement\widgets\widget_file_list.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementDetailFileListExt`

---

### File: `screens\settlement\widgets\widget_insuff_balance_row.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementDetailinsuffBalanceRowExt`

**Fungsi / Logika Utama:**
- `insuffBalanceRow()`

---

### File: `screens\settlement\widgets\widget_insufficient_balance_dialog.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementDetailInsufficientBalanceDialogExt`

**Fungsi / Logika Utama:**
- `showInsufficientBalanceDialog()`

---

### File: `screens\settlement\widgets\widget_settlement_detail_actions.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 8 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SettlementDetailSettlementDetailActionsExt`

---

### File: `screens\settlement\widgets\widget_settlement_expense_table.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `WidgetSettlementExpenseTable`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\settlement\widgets\widget_settlement_summary_cards.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `WidgetSettlementSummaryCards`

**Fungsi / Logika Utama:**
- `toDouble()`
- `build()`: Membangun struktur UI/widget.
- `LayoutBuilder()`

---

## Folder: `screens\widgets`

**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).

### File: `screens\widgets\common_widgets.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

---

### File: `screens\widgets\page_selector.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `SummaryCard`
- `SettlementActionButton`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `screens\widgets\transaction_cards.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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

### File: `screens\widgets\widget_scrollable_settlement_header.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `MainLayoutWidgetsScrollableSettlementHeaderExt`

**Fungsi / Logika Utama:**
- `buildScrollableSettlementHeader()`
- `CascadingYearFilter()`

---

### File: `screens\widgets\widget_summary_cards.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `MainLayoutWidgetsSummaryCardsExt`

**Fungsi / Logika Utama:**
- `buildSummaryCards()`

---

### File: `screens\widgets\widget_toggle_button.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `MainLayoutWidgetsToggleButtonExt`

**Fungsi / Logika Utama:**
- `buildToggleButton()`

---

### File: `screens\widgets\widget_type_toggle.dart`

**Tanggung Jawab (Responsibility):**
- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `MainLayoutWidgetsTypeToggleExt`

**Fungsi / Logika Utama:**
- `buildTypeToggle()`

---

## Folder: `services`

**Tujuan Folder:** Menangani komunikasi ke luar, seperti pemanggilan API ke backend (HTTP requests).

### File: `services\api_advances.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
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
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
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
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
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
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
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
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
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
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
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
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
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
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
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
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
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
- **Dependencies (Menggunakan):** Meng-import 6 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ApiServiceMasterExt`

**Fungsi / Logika Utama:**
- `setToken()`
- `setCompany()`
- `getEvidenceUrl()`
- `networkHint()`

---

### File: `services\api_reports.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
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
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ApiService`

**Fungsi / Logika Utama:**
- `buildUrl()`
- `loadSavedBaseUrl()`
- `saveBaseUrl()`
- `checkConnectivity()`
- `loadTokenFromStorage()`
- `ensureTokenLoaded()`

---

### File: `services\api_settlements.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
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
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
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
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ApiServiceUsersExt`

---

### File: `services\bank_order_preferences.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `BankOrderPreferences`

**Fungsi / Logika Utama:**
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
- `sortBankMaps()`

---

### File: `services\notification_service.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

---

### File: `utils\app_snackbar.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ContextExtensions`

---

### File: `utils\controller_disposable_wrapper.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `ControllerDisposableWrapper`
- `_ControllerDisposableWrapperState`

**Fungsi / Logika Utama:**
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `build()`: Membangun struktur UI/widget.

---

### File: `utils\currency_formatter.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `CurrencyInputFormatter`

**Fungsi / Logika Utama:**
- `formatEditUpdate()`

---

### File: `utils\event_bus.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `GlobalEventBus`

**Fungsi / Logika Utama:**
- `triggerRefresh()`

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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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

### File: `utils\transaction_templates.dart`

**Tanggung Jawab (Responsibility):**
- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `TxTemplates`

**Fungsi / Logika Utama:**
- `allocationNotes()`

---

## Folder: `widgets`

**Tujuan Folder:** Menyimpan komponen visual (Widget) yang dapat digunakan berulang (Reusable) di berbagai layar.

### File: `widgets\account_list_dialog.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 9 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AccountListDialog`
- `_AccountListDialogState`
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

---

### File: `widgets\app_brand_logo.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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

### File: `widgets\dialog_create_user.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `CreateUserDialog`
- `_CreateUserDialogState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_loadCompanies()`
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `_buildCompanyCheckboxes()`
- `_submit()`
- `build()`: Membangun struktur UI/widget.

---

### File: `widgets\dialog_edit_user.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 5 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `EditUserByManagerDialog`
- `_EditUserByManagerDialogState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_loadCompanies()`
- `dispose()`: Membersihkan memori (cleanup) saat komponen ditutup.
- `_buildCompanyCheckboxes()`
- `build()`: Membangun struktur UI/widget.

---

### File: `widgets\image_cropper_dialog.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 7 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

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

## Folder: `widgets\core`

**Tujuan Folder:** Menyimpan komponen visual (Widget) yang dapat digunakan berulang (Reusable) di berbagai layar.

### File: `widgets\core\_fast_range_picker_dialog.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `FastRangePickerDialog`
- `FastRangePickerDialogState`

**Fungsi / Logika Utama:**
- `initState()`: Inisialisasi awal (lifecycle) saat komponen diload.
- `_onMonthSelected()`
- `_onYearSelected()`
- `build()`: Membangun struktur UI/widget.
- `_buildPickerContent()`
- `_buildHeaderWithNav()`
- `_buildDayGrid()`
- `GestureDetector()`
- `_buildHeader()`
- `_getMonthName()`
- `_buildTabButton()`

---

### File: `widgets\core\_menu_item_label.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `MenuItemLabel`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `widgets\core\app_date_range_picker.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `AppDateRangePicker`

**Fungsi / Logika Utama:**
- `show()`

---

### File: `widgets\core\cascading_menu_custom.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `CascadingMenuCustom`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `widgets\core\cascading_menu_item.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 1 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `CascadingMenuItem`

---

### File: `widgets\core\cascading_status_filter.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `CascadingStatusFilter`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `widgets\core\cascading_year_filter.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 3 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `CascadingYearFilter`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `widgets\core\format_utils.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 0 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Fungsi / Logika Utama:**
- `formatNumber()`

---

### File: `widgets\core\status_filter_chip.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 4 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `StatusFilterChip`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.

---

### File: `widgets\core\year_filter_button.dart`

**Tanggung Jawab (Responsibility):**
- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.

**Hubungan & Alur Data:**
- **Dependencies (Menggunakan):** Meng-import 2 dependensi/file lain.
- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).

**Hal Penting & Risiko:**
- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.

**Classes / Mixins / Widgets Terdeteksi:**
- `YearFilterButton`

**Fungsi / Logika Utama:**
- `build()`: Membangun struktur UI/widget.
- `Material()`

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

