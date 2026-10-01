# Phase 1: System Discovery (Application Map)

## Tujuan

Memetakan aplikasi secara faktual berdasarkan source code sebelum masuk ke detail business flow.

Phase 1 hanya menjawab:

- Aplikasi terdiri dari apa saja?
- Dari mana aplikasi dimulai?
- Bagaimana authentication bekerja?
- Bagaimana user masuk ke company context?
- Menu/module utama apa saja?
- Role memengaruhi akses di level mana?
- Frontend, provider, API, backend, dan database saling terhubung bagaimana?
- Dependency apa yang sudah terbukti dan apa yang masih perlu diverifikasi?

Phase ini **tidak membedah detail workflow Kasbon/Settlement**. Detail tersebut dilakukan pada Phase 4.

---

# 1. Feature Inventory

| Feature / Module | Entry Point | Backend / API Area | Known Access | Known Dependency | Confidence |
|---|---|---|---|---|---|
| Authentication | `login_screen.dart` | `routes/auth.py` | Authenticated entry | `AuthProvider` | Confirmed |
| Company Selector | `dashboard_screen.dart` | `routes/companies.py` | Authenticated users | `AuthProvider`, `activeCompany` | Confirmed |
| Advance / Kasbon | `advances_screen.dart` | `routes/advances_*.py` | Authenticated users; actions are role-dependent | Company context | Confirmed |
| Settlement / Pertanggungjawaban | `main_layout_settlement_list.dart` | `routes/settlements_*.py` | Authenticated users; actions are role-dependent | Company context | Confirmed |
| Reports | `report_screen.dart` | `routes/reports/` | Manager / Super Manager | Advance, Settlement | Confirmed |
| Category Management | `category_management_screen.dart` | `routes/categories.py` | Manager / Super Manager | — | Confirmed |
| Bank Management | `bank_management_screen.dart` | `routes/bank_management.py` | Manager / Super Manager | — | Confirmed |
| Settings | `settings_screen.dart` | `routes/settings.py` | All roles | Authentication | Confirmed |

---

# 2. Application Entry Points

## Frontend

**Entry Point:** `frontend/lib/main.dart`

Tanggung jawab awal:

- memuat environment;
- menginisialisasi Provider;
- menginisialisasi service/global state;
- memeriksa status authentication;
- menentukan layar awal aplikasi.

## Backend

**Entry Point:** `backend/app.py`

Tanggung jawab awal:

- membuat Flask application;
- menyiapkan database;
- JWT authentication;
- CORS;
- rate limiting;
- mendaftarkan blueprint/route backend.

---

# 3. Authentication Flow

## Confirmed Behavior

```text
Application Start
      ↓
AuthProvider checks local authentication state
      ↓
Valid session?
 ├── NO
 │    ↓
 │  LoginScreen
 │    ↓
 │  Login / Google Sign-In
 │    ↓
 │  Backend Authentication
 │
 └── YES
      ↓
   DashboardScreen
```

Hal yang teridentifikasi:

- token/session disimpan dan diperiksa melalui `AuthProvider`;
- aplikasi mendukung login Email/Password;
- terdapat dukungan Google Sign-In;
- authentication menggunakan JWT;
- JWT expiration dikonfigurasi pada backend.

### Evidence

- `frontend/lib/main.dart`
- `frontend/lib/providers/auth_provider.dart`
- `backend/routes/auth.py`
- `backend/app.py`

---

# 4. Company Context & Selection

## Confirmed Behavior

Company selection ditangani oleh `DashboardScreen`.

Flow:

```text
Authenticated User
       ↓
DashboardScreen
       ↓
Accessible Companies
 ├── 1 company
 │     ↓
 │   activeCompany dapat ditetapkan langsung
 │
 └── >1 company
       ↓
    User memilih Company
       ↓
    setActiveCompany()
       ↓
    activeCompany
```

`activeCompany` disimpan pada `AuthProvider` dan diteruskan ke API context melalui `ApiService`.

### Evidence

- `frontend/lib/screens/dashboard_screen.dart`
- `frontend/lib/providers/auth_provider.dart`
- `frontend/lib/services/api_service.dart`

### Important Boundary

Yang **confirmed** pada Phase 1 adalah keberadaan dan penggunaan `activeCompany` sebagai API context.

Apakah setiap endpoint Kasbon, Settlement, Bank, dan module lain benar-benar melakukan filtering database berdasarkan company tersebut **harus diverifikasi di backend pada phase berikutnya**.

---

# 5. Main Navigation

Main navigation berada pada `main_layout.dart`.

```text
MainLayout
├── Pertanggungjawaban / Settlement
├── Kasbon / Advance
├── Reports
├── Category Management
├── Bank Management
└── Settings
```

Beberapa menu menggunakan role gating.

Contohnya:

```text
isManager
 ├── TRUE  → menu manager tersedia
 └── FALSE → menu manager disembunyikan
```

`isManager` mencakup:

- `manager`
- `super_manager`

### Evidence

- `frontend/lib/screens/main_layout.dart`
- `frontend/lib/providers/auth_provider.dart`

---

# 6. Main Frontend Modules

## Authentication

`auth/`

Berisi screen dan logic terkait authentication.

## Advance

`advance/`

Berhubungan dengan:

- Advance List;
- Create Advance;
- Advance Detail;
- item;
- approval;
- revision;
- disbursement;
- return.

Detail lifecycle akan dibongkar pada Phase 4.

## Settlement

`settlement/`

Berhubungan dengan:

- Settlement List;
- Settlement Detail;
- expense/item;
- approval;
- disbursement;
- return;
- workflow.

Detail lifecycle akan dibongkar pada Phase 4.

## Management

`management/`

Berhubungan dengan master data dan financial management seperti:

- categories;
- bank management;
- bank status.

## Reports

`reports/`

Berhubungan dengan:

- report/dashboard;
- summary;
- export;
- data analitik.

---

# 7. State Management / Provider Map

Frontend menggunakan Provider sebagai state-management layer.

Provider yang teridentifikasi antara lain:

- `AuthProvider`
- `NotificationProvider`
- `AdvanceProvider`
- `SettlementProvider`
- `RevenueProvider`
- `TaxProvider`
- `DividendProvider`
- `AssetProvider`
- `BankManagementProvider`
- `BankStatusProvider`
- `CascadeProvider`
- `ThemeProvider`

Untuk Advance dan Settlement, logic juga dipisah ke beberapa extension.

### Advance

```text
AdvanceProvider
├── List Extension
├── Item Extension
├── Workflow Extension
└── Finance Extension
```

### Settlement

```text
SettlementProvider
├── List Extension
├── CRUD Extension
├── Expense Extension
├── Workflow Extension
├── Finance Extension
├── Bank Extension
└── Category Extension
```

Ini merupakan peta struktur implementation, bukan detail business flow.

---

# 8. Frontend → Backend Boundary

Arsitektur komunikasi:

```text
UI
 ↓
Provider
 ↓
ApiService
 ↓
REST API
 ↓
Backend Route
 ↓
Backend Service / Utility
 ↓
Database
```

Provider menerima response dari backend, mengubah state, lalu UI melakukan rebuild berdasarkan perubahan state.

### Evidence

- `frontend/lib/services/api_service.dart`
- Provider files
- `backend/app.py`
- `backend/routes/`

---

# 9. Backend Module Map

Backend menggunakan Flask dan route/blueprint yang dipisahkan berdasarkan domain.

Kelompok utama:

```text
Authentication
Companies
Advances
Settlements
Reports
Categories
Bank Management
Expenses
Revenues
Dividends
Taxes
```

Advance dan Settlement memiliki beberapa route terpisah untuk operasi yang lebih spesifik seperti:

- CRUD;
- items / expenses;
- approval;
- disbursement;
- return;
- utility / workflow-related operations.

Detail masing-masing route akan ditelusuri pada Phase 4.

---

# 10. Database / Entity Map

Backend menggunakan SQLite dengan Flask-SQLAlchemy.

Entity utama yang sudah teridentifikasi:

```text
User
Company
Category
Advance
AdvanceItem
Settlement
SettlementItem
Expense
```

Entity tambahan akan ditambahkan pada map ini jika ditemukan relevan pada feature tracing.

## Basic Relationship

```text
User
 ├── creates → Advance
 │              └── AdvanceItem
 │
 └── creates → Settlement
                └── SettlementItem
```

Relationship yang lebih spesifik, terutama hubungan Advance ↔ Settlement, **belum dianggap confirmed pada Phase 1** sampai ditelusuri langsung melalui model/API/database logic.

---

# 11. Role Overview

Aplikasi mengenal empat role:

- `staff`
- `mitra_eks`
- `manager`
- `super_manager`

Role gating utama di frontend menggunakan `isManager`, yang bernilai true untuk:

```text
manager
super_manager
```

Role dan permission detail dibahas secara khusus pada:

`02_role_permission.md`

Phase 1 hanya mencatat role sebagai bagian dari application map.

---

# 12. High-Level Application Flow

```text
APP START
   ↓
main.dart
   ↓
Initialize App / Providers
   ↓
Check Authentication
   ├── Not Authenticated
   │       ↓
   │    LoginScreen
   │       ↓
   │    Authenticate
   │
   └── Authenticated
           ↓
     DashboardScreen
           ↓
      Company Context
           ↓
       MainLayout
           ↓
      Role-Based Menu
           ↓
     Select Feature
           ↓
     Feature Screen
           ↓
       Provider
           ↓
      ApiService
           ↓
      REST Backend
           ↓
      Backend Route
           ↓
   Backend Logic / Database
           ↓
       API Response
           ↓
        Provider State
           ↓
           UI
```

Ini adalah **architecture-level flow**, bukan business flow.

---

# 13. Cross-Feature Dependency

## Confirmed

### Company Context → API Context

`activeCompany` diteruskan ke API context.

### Notification Polling

Frontend memiliki `NotificationProvider` yang melakukan polling/listening terhadap notification dari backend.

## Inferred / Needs Verification

### Advance ↔ Settlement

Terdapat indikasi hubungan antara Advance dan Settlement, tetapi apakah hubungan tersebut wajib, opsional, atau hanya digunakan untuk kondisi tertentu belum ditentukan pada Phase 1.

### Advance / Settlement ↔ Bank

Terdapat indikasi bahwa Disbursement dan financial operation berkaitan dengan bank/financial records, tetapi efek database yang tepat harus diverifikasi pada feature/backend tracing.

### Advance / Settlement ↔ Reports

Kemungkinan data status/transaksi digunakan oleh report, tetapi kontribusi tepat masing-masing status harus diverifikasi pada report backend.

---

# 14. Evidence Index

| Temuan | Evidence |
|---|---|
| Frontend entry point | `frontend/lib/main.dart` |
| Backend entry point | `backend/app.py` |
| Authentication state | `frontend/lib/providers/auth_provider.dart` |
| Company selection | `frontend/lib/screens/dashboard_screen.dart` |
| Active company | `frontend/lib/providers/auth_provider.dart` |
| Role definitions | `frontend/lib/providers/auth_provider.dart` / `backend/models.py` |
| Manager gating | `frontend/lib/screens/main_layout.dart` |
| Provider architecture | `frontend/lib/main.dart` dan provider files |
| REST boundary | `frontend/lib/services/api_service.dart` |
| Backend routes | `backend/routes/` |
| Database entities | `backend/models.py` |

---

# 15. Confirmed

- Frontend menggunakan Flutter.
- Backend menggunakan Python/Flask.
- Frontend menggunakan Provider.
- Frontend berkomunikasi dengan backend melalui REST API.
- Authentication menggunakan JWT.
- Terdapat Email/Password dan Google Sign-In.
- Terdapat company context melalui `activeCompany`.
- Terdapat empat role:
  `staff`, `mitra_eks`, `manager`, `super_manager`.
- `manager` dan `super_manager` termasuk dalam `isManager`.
- MainLayout mempunyai role-based menu gating.
- Advance dan Settlement merupakan feature/module utama.
- Backend menggunakan SQLite dan Flask-SQLAlchemy.

---

# 16. Inferred

- Advance kemungkinan memiliki hubungan dengan Settlement.
- Financial operation kemungkinan mempunyai hubungan dengan Bank Management.
- Data Advance/Settlement kemungkinan digunakan oleh Reports.

Semua poin di atas harus diverifikasi pada Phase 4 dan tidak boleh dianggap sebagai business requirement.

---

# 17. Unknown / Needs Verification

- Apakah semua endpoint benar-benar melakukan company filtering pada database.
- Bagaimana tepatnya Advance berhubungan dengan Settlement.
- Apakah Advance ID wajib ketika membuat Settlement.
- Bagaimana tepatnya Disbursement memengaruhi bank/cash/expense.
- Bagaimana notification dibuat oleh backend.
- Apakah `staff` dan `mitra_eks` memiliki perbedaan pada feature yang belum dianalisis.
- Hard delete atau soft delete untuk setiap entity transaksi.
- Terminal state setiap lifecycle feature.

---

# 18. Scope Boundary

Phase 1 **tidak** menentukan:

- detail tombol setiap feature;
- detail field form;
- detail rejection;
- detail revision;
- detail approval per item;
- detail disbursement;
- detail return;
- detail balance calculation;
- detail terminal state.

Semua itu merupakan pekerjaan Phase 4 — Feature Flow Reverse Engineering.

---

## Status

**Phase 1 Application Map: READY FOR PHASE 2 / PHASE 3 VALIDATION**

File ini merupakan versi gabungan dari beberapa draft Application Map. Versi lama tidak perlu digunakan sebagai source of truth setelah file ini ditetapkan.
