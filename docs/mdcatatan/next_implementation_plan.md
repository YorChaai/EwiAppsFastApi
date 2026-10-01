# Rencana Implementasi (Next Refactoring Plan)

Dokumen ini berisi daftar prioritas refactoring untuk file-file berukuran raksasa (>500 baris) berdasarkan laporan analisis codebase. Tujuan utama adalah **menghilangkan arsitektur God Object (`part of`)**, memecah file besar menjadi komponen modular, dan menerapkan _Single Responsibility Principle_ (SRP).

---

## 🛑 Prioritas 1: Pembongkaran "God Object" (Frontend)

File-file berikut menggunakan arsitektur `part of` yang saling mengunci _state_ dan sangat berbahaya untuk maintainability jangka panjang. Ini adalah prioritas tertinggi untuk direfactor dengan teknik de-coupling (sama seperti `main_layout` dan `settlement_detail_screen`).

### Layar Laporan Tahunan (Annual Report)

- `frontend/lib/screens/reports/annual_report/annual_report_screen.dart` (Parent) - **925 baris**
- `frontend/lib/screens/reports/annual_report/annual_report_tables.dart` (Child) - **732 baris**
- `frontend/lib/screens/reports/annual_report/widget_table_card.dart` (Child) - **633 baris**
  > **Aksi:** Menghapus `part of`, ubah ekstensi private menjadi public, injeksi dependency eksplisit (impor standar).

### Layar Advances (Kasbon)

- `frontend/lib/screens/advance/advance_detail_screen.dart` (Parent) - **1031 baris**
- `frontend/lib/screens/advance/layouts/advance_detail_tables.dart` (Child) - **980 baris**
- `frontend/lib/screens/advance/dialogs/dialog_add_item.dart` (Child) - **891 baris**
- `frontend/lib/screens/advance/advances_screen.dart` (Parent) - **802 baris**
- `frontend/lib/screens/advance/advance_detail_actions.dart` (Child) - **761 baris**
  > **Aksi:** Memisahkan logika tabel, aksi, dan dialog menjadi file mandiri. Menghilangkan `part of`.

### Layar Manajemen (Bank, Revenue, Tax, Category)

- `frontend/lib/screens/management/revenue_management_screen_actions.dart` (Child) - **914 baris**
- `frontend/lib/screens/management/tax_management_screen_actions.dart` (Child) - **902 baris**
- `frontend/lib/screens/management/tax_management_screen.dart` (Parent) - **686 baris**
- `frontend/lib/screens/management/category_tabular_screen.dart` (Parent) - **673 baris**
- `frontend/lib/screens/management/revenue_management_screen.dart` (Parent) - **632 baris**
  > **Aksi:** Refactoring secara bertahap setiap modul manajemen untuk menggunakan struktur import standar.

### Modul Inti & Autentikasi

- `frontend/lib/services/api_advances.dart` (Child) - **703 baris**
- `frontend/lib/screens/auth/login_screen.dart` (Parent) - **667 baris**
- `frontend/lib/screens/settings/settings_screen.dart` (Parent) - **546 baris**

---

## ⚠️ Prioritas 2: Pemecahan File Besar Tanpa `part of` (Frontend)

File-file ini bukan merupakan "God Object" (`part of`), namun ukurannya sudah terlalu masif sehingga menyulitkan navigasi.

- `frontend/lib/screens/settlement/layouts/settlement_detail_layout.dart` - **1017 baris**
- `frontend/lib/screens/settlement/settlement_detail_actions.dart` - **967 baris**
- `frontend/lib/screens/management/asset_management_screen.dart` - **932 baris**
- `frontend/lib/widgets/account_list_dialog.dart` - **928 baris**
- `frontend/lib/screens/settlement/dialogs/dialog_add_expense.dart` - **912 baris**
- `frontend/lib/screens/settlement/dialogs/dialog_edit_expense.dart` - **860 baris**
- `frontend/lib/screens/main_layout_settlement_list.dart` - **858 baris**
- `frontend/lib/screens/widgets/sidebar.dart` - **858 baris**
- `frontend/lib/screens/manager/manager_settlement_detail_screen.dart` - **831 baris**
  > **Aksi:** Memecah _widget tree_ yang sangat panjang menjadi komponen-komponen Stateless/Stateful yang lebih kecil dan dapat di-_reusable_.

---

## 🛠️ Prioritas 3: Refactoring Backend (Python)

File backend yang terlalu besar umumnya karena fungsi bisnis (_business logic_) dan routing bercampur.

- `backend/models/transaction.py` - **969 baris**
- `backend/services/settlement_approval_service.py` - **954 baris**
- `backend/routes/reports/helpers.py` - **875 baris**
- `backend/services/reports/annual_service/helpers.py` - **875 baris**
- `backend/services/reports/table_builder/expense_renderer.py` - **830 baris**
- `backend/services/advance_approval_service.py` - **809 baris**
- `backend/routes/advances_items.py` - **639 baris**
  > **Aksi:** Memisahkan _Fat Models_ (model yang terlalu banyak fungsi logic) menjadi _Services_. Mengurangi duplikasi _helpers_ pada module reports.

---

**Catatan Penting:**
Refactoring pada "Prioritas 1" akan memunculkan ratusan hingga ribuan _syntax error_ sementara akibat pemutusan dependensi `part of`. Langkah mitigasi: Lakukan penggantian _private variable_ (menggunakan awalan `_`) menjadi _public_ sebelum menghapus struktur `part of` (seperti yang sukses kita terapkan pada `main_layout` dan `settlement_detail_screen`).
