# Phase 1: System Discovery (Application Map)

**Tujuan:** Memetakan arsitektur, navigasi, module, aliran otentikasi, state management, dan interaksi frontend-backend secara faktual berdasarkan *source code*. Tidak memuat detail *business flow* di level fitur.

---

## 1. Feature Inventory

| Feature / Module | Entry Point (Frontend) | Related Backend Routes | Known Role Access | Known Dependency | Current Confidence |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Authentication** | `login_screen.dart` | `routes/auth.py` | All | - | Confirmed |
| **Company Selector** | `dashboard_screen.dart` | `routes/companies.py` | All | `AuthProvider` | Confirmed |
| **Advance (Kasbon)** | `advances_screen.dart` | `routes/advances_*.py` | Authenticated users; role-specific actions | Company Context | Confirmed |
| **Settlement** | `main_layout_settlement_list.dart`| `routes/settlements_*.py` | Authenticated users; role-specific actions | Company Context | Confirmed |
| **Reports** | `report_screen.dart` | `routes/reports/` | Manager, Super Manager | Advance, Settlement | Confirmed |
| **Category Mgt** | `category_management_screen.dart` | `routes/categories.py` | Manager, Super Manager | - | Confirmed |
| **Bank Mgt** | `bank_management_screen.dart` | `routes/bank_management.py`| Manager, Super Manager | - | Confirmed |
| **Settings** | `settings_screen.dart` | `routes/settings.py` | All | - | Confirmed |

---

## 2. High-Level Architecture Flow
*Catatan: Ini adalah alur arsitektural aplikasi, bukan alur bisnis/operasional Kasbon.*

```text
[APP START] -> main.dart
  ↓
[INIT] -> Load .env, Init Providers (Auth, Theme, Notification, dll)
  ↓
[CHECK TOKEN] -> AuthProvider.checkLoginStatus()
  ├── Tidak Valid/Kosong
  │      ↓
  │   LoginScreen (Email/Password or Google Sign-In)
  │      ↓
  │   Backend /api/auth -> Validasi JWT
  │
  └── Valid
         ↓
      [COMPANY CONTEXT] -> DashboardScreen
         ├── User punya 1 Company -> Otomatis Set activeCompany
         └── User punya >1 Company -> Tampilkan pilihan Company Card
               ↓
            [MAIN NAVIGATION] -> MainLayout
               ├── Check Role (isManager)
               │      ├── True: Tampilkan semua tab (termasuk Report, Bank, Category)
               │      └── False: Sembunyikan tab khusus
               │
               └── Load Data Tab Aktif (fetch data dari Backend via ApiService)
```

---

## 3. Cross-Feature Dependency

**Confirmed:**
- **Company Context ↔ API Service:** API Service mengirim header/query berdasarkan `activeCompany`.
- **Notification Polling:** Aplikasi (Frontend) melakukan *listening* dan *polling* notifikasi dari *backend* menggunakan `NotificationProvider`.

**Inferred (Perlu Divalidasi di Fase Selanjutnya):**
- **Semua Modul ↔ Company Filtering di Backend:** Diduga backend melakukan filter data berdasarkan `company_id` yang dikirim dari `activeCompany`. Belum diverifikasi sampai ke level SQL Query.
- **Notification Creation:** Diduga aksi spesifik di modul Kasbon/Settlement (seperti Approve/Reject) akan men-trigger *creation* notifikasi baru di *backend*.
- **Advance ↔ Settlement:** Kemungkinan ada logika di mana sisa/tagihan Kasbon dihubungkan saat user membuat Settlement.
- **Advance/Settlement ↔ Bank Management:** Diduga pencairan (*Disbursement*) Kasbon/Settlement otomatis memotong/menambah entri di *Bank Management* atau *Expenses*.

---

## 4. Evidence Index

| Temuan Penting | Lokasi Evidence | Keterangan |
| :--- | :--- | :--- |
| **Bypass Pemilihan Perusahaan** | `frontend/lib/screens/dashboard_screen.dart:22-26` | Jika `accessibleCompanies.length == 1`, sistem mem-bypass layar pilihan. |
| **Gating Menu Berdasarkan Role** | `frontend/lib/screens/main_layout.dart:274-277` | Menu *Report*, *Category*, dan *Bank* di-*render* hanya `if (auth.isManager)`. |
| **Definisi Role Sistem** | `frontend/lib/providers/auth_provider.dart:30-34` | Mendefinisikan *getter* boolean untuk: `isManager`, `isSuperManager`, `isStaff`, `isMitraEks`. |
| **Aturan `isManager`** | `frontend/lib/providers/auth_provider.dart:30-31` | `isManager` bernilai *true* untuk *role* `manager` **ATAU** `super_manager`. |
| **Google Sign-In Support** | `backend/routes/auth.py` | Import `google.oauth2.id_token` ada, membuktikan opsi G-Login aktif. |
| **Backend Rate Limiting** | `backend/app.py:28-33` | Ada mekanisme *Rate Limit* (Anti-Bot) 10.000/day, 2000/hour. |
| **JWT Expiration** | `backend/app.py:20` | Token JWT diatur kedaluwarsa dalam 7 hari. |

---

## 5. Contradiction & Unknowns

### Contradictions Found
- No contradiction identified within the analyzed scope.

### Remaining Unknowns
- **Definisi `mitra_eks`:** Role ini ada di *database* dan di `auth_provider.dart`, tapi belum ditemukan kondisional UI spesifik yang membedakan `mitra_eks` dari `staff` biasa (pada level menu utama).
- **Hard Delete vs Soft Delete:** Belum diketahui apakah data transaksi dihapus secara permanen atau *soft delete* di level *database*.
- **Hubungan Relasional Advance-Settlement:** Belum dibuktikan di source code apakah *Advance ID* wajib dimasukkan saat membuat *Settlement*.
