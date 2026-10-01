# Phase 1: System Discovery (Application Map)

**Tujuan:** Memetakan arsitektur, navigasi, _module_, aliran otentikasi, _state management_, dan interaksi _frontend-backend_ sebelum masuk ke detail proses bisnis.

---

## 1. Entry Point

### Frontend

- **Entry Point Utama:** `frontend/lib/main.dart`
- **Inisialisasi:** Memuat _environment_ (`.env`), _Provider_ (State Management), dan mengecek status _login_.
- **Routing Awal:** Tergantung status autentikasi di `AuthProvider`, _user_ dilempar ke `LoginScreen` atau `DashboardScreen` (Pemilihan Perusahaan).

### Backend

- **Entry Point Utama:** `backend/app.py`
- **Inisialisasi:** Memuat _Flask App_, SQLite Database (`models.py`), JWT Authentication, CORS, Rate Limiting, dan me-_register_ 17+ _Blueprints_ (Routes).

---

## 2. Authentication Flow

**Confirmed Behavior**

1. User membuka aplikasi.
2. `AuthProvider` mengecek token lokal (`SharedPreferences`).
3. Jika tidak ada token → diarahkan ke `LoginScreen`.
4. Jika ada token → `DashboardScreen` (Pemilih Perusahaan).
5. Proses Login: Mendukung Email/Password biasa dan Google Sign-In (`google_id`).
6. Token yang digunakan: JWT (Berlaku 7 hari - dikonfigurasi di `app.py`).

---

## 3. Company Context & Selection

**Confirmed Behavior**

- **Pemilihan Perusahaan:** Dilakukan di `DashboardScreen` (`frontend/lib/screens/dashboard_screen.dart:30-40`).
- **Logic Pilihan:** Jika _user_ hanya punya akses ke 1 perusahaan, layar ini dilewati (_bypassed_) dan langsung masuk ke `MainLayout`. Jika >1, user harus memilih kartu perusahaan.
- **Dampak:** Perusahaan yang dipilih disimpan sebagai `activeCompany` di `AuthProvider` dan di-_inject_ ke setiap HTTP Request Header/Parameter via `ApiService`. Data yang ditarik (Kasbon, Settlement) difilter berdasarkan perusahaan ini.

---

## 4. Main Navigation / Menu

**Confirmed Behavior**
Berada di `frontend/lib/screens/main_layout.dart`. Tab/Menu yang tersedia di _Sidebar_/_Bottom Nav_:

1. **Pertanggungjawaban (Settlements)** - `main_layout_settlement_list.dart`
2. **Kasbon (Advances)** - `advances_screen.dart`
3. **Laporan (Reports)** - `report_screen.dart` _(Khusus Manager/Admin)_
4. **Kategori (Categories)** - `category_management_screen.dart` _(Khusus Manager)_
5. **Manajemen Bank (Bank/Finance)** - `bank_management_screen.dart` _(Khusus Manager)_
6. **Pengaturan (Settings)** - `settings_screen.dart`

---

## 5. Main Modules / Features

**Frontend Modules (di `lib/screens/`):**

- `auth/`: Login, Loading, Error Screens.
- `advance/`: Pengajuan dan persetujuan Kasbon (Draft, Pending, Approve, Reject, Pencairan).
- `settlement/`: Pengajuan dan persetujuan Pertanggungjawaban dana.
- `management/`: Master data kategori dan manajemen saldo bank.
- `reports/`: Dashboard analitik dan _export_ data.

**Backend Modules (di `backend/routes/`):**

- `auth.py`: JWT, User info, Login.
- `companies.py`: Data perusahaan.
- `advances_*.py` & `settlements_*.py`: CRUD, Approval, Items, dan Disbursement untuk Kasbon dan Settlement.
- `expenses.py`, `revenues.py`, `dividends.py`, `taxes.py`: Pencatatan arus kas operasional.
- `bank_management.py`: Mutasi dan status bank.

---

## 6. Roles Affecting Access

**Confirmed Behavior** (Evidence: `auth_provider.dart:30-34`)
Aplikasi mengenal 4 _role_ utama yang tersimpan di _database_ (`models.py:67`):

- `staff`
- `manager`
- `super_manager`
- `mitra_eks`

**Dampak (_Gating_):**
Di `main_layout.dart:274-277`, menu Laporan, Kategori, dan Bank **dikunci** di balik kode `if (auth.isManager)`. Status `isManager` bernilai `true` untuk `manager` dan `super_manager`.

---

## 7. State Management / Providers

Seluruh arsitektur Frontend bergantung pada `provider` (Evidence: `main.dart:185`).
Provider Utama:

- `AuthProvider`: Menangani _Role_, _Token_, dan _Active Company_.
- `NotificationProvider`: Menangani sistem notifikasi _real-time/polling_.
- `AdvanceProvider`: Menangani _state_ list kasbon dan aksi persetujuan.
- `SettlementProvider`: Menangani _state_ list settlement.
- _Lainnya:_ `RevenueProvider`, `TaxProvider`, `DividendProvider`, `AssetProvider`, `BankManagementProvider`.

---

## 8. Service / API Boundary

**Confirmed Behavior**

- Komunikasi FE ke BE murni melalui **REST API** (`lib/services/api_service.dart`).
- Response dari BE ditangkap oleh `Provider`, diubah menjadi _state_, lalu memicu _rebuild_ UI (Consumer/Selector).

---

## 9. Database & Entity (Backend)

**Confirmed Behavior** (Evidence: `backend/models.py`)
Menggunakan **SQLite** (`main.db` dkk) dengan ORM Flask-SQLAlchemy.
Entitas Utama:

- `User`: Akun pengguna.
- `Company`: Data perusahaan.
- `Category` & Pivot `expense_subcategories`: Kategori keuangan.
- `Advance` & `AdvanceItem`: Header dan Rincian Kasbon.
- `Settlement` & `SettlementItem`: Header dan Rincian Pertanggungjawaban.
- `Expense`: Pengeluaran operasional.

---

## 10. High-Level End-to-End Application Flow

```text
Aplikasi Dibuka
       ↓
    Cek Token (AuthProvider)
    ├── [TIDAK ADA] → Login Screen → Autentikasi API
    └── [ADA]
           ↓
    Dashboard Screen (Company Context)
       ├── Punya 1 Company → Langsung set activeCompany
       └── Punya >1 Company → User memilih Company Card
           ↓
    Main Layout (Sidebar / Bottom Nav)
           ↓
    Role Check (isManager?)
    ├── [TIDAK] → Menu Laporan, Bank, Kategori disembunyikan.
    └── [YA] → Semua menu muncul.
           ↓
    Aktivitas Utama (Misal: Menu Kasbon)
    User mengisi Form (Frontend UI)
           ↓
    Advance Provider (State Management) memproses Input
           ↓
    Api Service (mengirim token JWT + Company-ID di Header)
           ↓
    Backend Route (`/api/advances`)
           ↓
    Backend Model menyimpan ke SQLite Database
```

---

## 11. Cross-Feature Dependency Map

Bagaimana modul saling bergantung:

1. **Company Context ↔ All Modules:** Hampir seluruh modul (Kasbon, Settlement, Bank) tidak bisa menampilkan data sebelum _Company_ di-set.
2. **Advance ↔ Settlement:** (Inferred) Dana dari Kasbon biasanya menjadi modal awal untuk Pertanggungjawaban (Settlement).
3. **Advance/Settlement ↔ Bank Management:** Pencairan dana (_Disbursement_) pada Kasbon/Settlement akan memengaruhi / memotong saldo di Bank Management.
4. **Advance/Settlement ↔ Reports:** Status `Completed` pada Kasbon/Settlement menyumbang data grafik pada _Report Module_.

---

## 12. Kepastian Temuan (Confidence Level)

### Confirmed (Fakta dari Kode)

- Ada 4 role di database (`staff`, `manager`, `super_manager`, `mitra_eks`).
- UI Menu Laporan, Kategori, Bank dikunci hanya untuk `manager` / `super_manager` (`main_layout.dart`).
- Frontend di-_trigger_ oleh perubahan _State_ (Provider).
- Backend adalah REST API Python (Flask) + SQLite.
- _Rate Limiting_ (Anti Bot) aktif di Backend (`app.py:28`).

### Inferred (Diperkirakan dari Struktur)

- Hubungan Advance dan Settlement sepertinya berkesinambungan (Kasbon selesai -> menjadi Settlement). _(Perlu dibongkar di Feature Flow)_.
- Pembagian data antar-perusahaan tampaknya menggunakan _filter_ kolom `company_id` pada _database_ berdasarkan JWT token/Header.

### Unknown (Belum Diketahui)

- Batas wewenang spesifik `mitra_eks` (apakah UI-nya beda drastis dengan `staff`?).
- Mekanisme spesifik _Disbursement_ (Pencairan Dana) apakah otomatis memotong saldo _Expense/Bank_ di sistem.

---

_Laporan ini menggantikan versi sebelumnya dan dipetakan langsung dari source code (main.dart, app.py, models.py, auth_provider.dart)._
