# Phase 2: Role & Permission Reconstruction

## Tujuan

Memetakan secara faktual:

- siapa yang dapat mengakses fitur;
- data apa yang dapat dilihat setiap role;
- action apa yang dapat dilakukan;
- siapa yang dapat mengubah status;
- bagaimana ownership/data scope bekerja;
- bagaimana UI permission berbeda dari backend authorization;
- bagaimana company access memengaruhi akses.

Semua temuan harus berdasarkan **source code aktual**, bukan asumsi dari nama role.

Phase ini fokus pada **Role, Permission, Ownership, Company Access, dan Authorization**.

Detail business flow per feature dibahas pada Phase 4.

---

# 1. Role Inventory

Aplikasi mengenal empat role:

1. `staff`
2. `mitra_eks`
3. `manager`
4. `super_manager`

### Evidence

- `backend/models.py`
- `frontend/lib/providers/auth_provider.dart`

---

# 2. Role Permission Matrix

## Feature / Data Scope

| Modul / Fitur | `staff` | `mitra_eks` | `manager` | `super_manager` | Evidence / Catatan |
|---|---|---|---|---|---|
| **Kasbon / Advance** | Data milik sendiri | Data milik sendiri* | Semua data | Semua data | Backend ownership check pada `advances_crud.py`; detail action dibahas di bawah |
| **Settlement** | Data milik sendiri | Data milik sendiri* | Semua data | Semua data | Backend ownership check pada `settlements_crud.py` |
| **Reports** | Tidak tersedia | Tidak tersedia | Akses tersedia | Akses tersedia | UI gating + backend authorization |
| **Category Management** | Tidak tersedia | Tidak tersedia | Akses tersedia | Akses tersedia | UI gating + backend authorization |
| **Bank Management** | Tidak tersedia | Tidak tersedia | Akses tersedia | Akses tersedia | UI gating + backend authorization |
| **Settings / Profile** | Profil sendiri | Profil sendiri | Profil sendiri + user yang berada dalam scope pengelolaan | Akses lebih luas | `auth.py` dan settings flow |

\* Tidak ditemukan perbedaan permission fungsional `mitra_eks` vs `staff` pada path yang telah dianalisis. Jangan menganggap keduanya identik di seluruh aplikasi sebelum semua feature diverifikasi.

---

# 3. Ownership & Data Scope

Permission tidak hanya ditentukan oleh role.

Untuk Advance dan Settlement, akses juga dipengaruhi oleh **ownership**.

Konsep dasarnya:

```text
User
 ↓
Document Ownership
 ↓
Is this document owned by current user?
 ├── YES → Owner-level action may be available
 └── NO
       ↓
     Is user Manager-level?
       ├── YES → Broader processing access
       └── NO → Access restricted
```

Pada backend terdapat pengecekan `user_id` untuk membatasi akses data milik user.

### Evidence

- `advances_crud.py`
- `settlements_crud.py`
- `advances_approval.py`

---

# 4. UI Permission vs Backend Authorization

Keduanya harus didokumentasikan secara terpisah.

## A. UI Permission

Frontend menentukan apakah:

- menu terlihat;
- halaman dapat dibuka;
- button/action ditampilkan;
- component tertentu diaktifkan.

Contoh:

```text
isManager
 ├── TRUE
 │    ├── Reports
 │    ├── Categories
 │    └── Bank Management
 │
 └── FALSE
      └── Menu manager-only disembunyikan
```

`isManager` mencakup:

- `manager`
- `super_manager`

### Evidence

- `frontend/lib/screens/main_layout.dart`
- `frontend/lib/providers/auth_provider.dart`

---

## B. Backend Authorization

Frontend hiding tidak boleh dianggap sebagai satu-satunya keamanan.

Backend harus diverifikasi untuk melihat apakah request unauthorized benar-benar ditolak.

Contoh behavior yang ditemukan:

```text
Request
 ↓
Backend checks role / ownership
 ↓
Authorized?
 ├── YES → Process
 └── NO → HTTP 403 / Access Denied
```

### Evidence

- `backend/routes/advances_approval.py`
- `backend/routes/reports/`
- `backend/routes/categories.py`
- `backend/routes/bank_management.py`
- route terkait disbursement dan approval

---

# 5. Action-Level Permission

Permission harus ditelusuri sampai level action, bukan hanya menu.

## Advance / Settlement

| Action | Condition | Allowed Role / Actor | Evidence Status |
|---|---|---|---|
| **Create Draft** | Feature dapat dibuat | Owner / permitted role | Confirmed in analyzed paths |
| **Edit** | Status dan ownership mengizinkan | Owner; manager-level sesuai backend rule | Confirmed in analyzed paths |
| **Delete** | Status dan ownership mengizinkan | Owner; manager-level sesuai backend rule | Confirmed in analyzed paths |
| **Submit** | Status memungkinkan submit | Owner / permitted role | Confirmed in analyzed paths |
| **Approve Item** | Item berada pada state yang dapat di-approve | `manager`, `super_manager` | Confirmed |
| **Reject Item** | Item berada pada state yang dapat di-reject | `manager`, `super_manager` | Confirmed |
| **Start Revision** | Revision condition terpenuhi | `manager`, `super_manager` pada Advance path | Confirmed for analyzed Advance path |
| **Final Approval** | Semua item memenuhi approval condition | `manager`, `super_manager` | Confirmed in analyzed paths |
| **Disburse** | Document berada pada state yang memungkinkan pencairan | `manager`, `super_manager` | Confirmed |

### Important

Jangan menganggap action pada Kasbon dan Settlement selalu identik.

Status, endpoint, dan condition harus diverifikasi per feature.

---

# 6. Status Transition by Role

Status transition harus dibedakan antara **Advance** dan **Settlement**.

## A. Advance

Status transition yang telah ditemukan pada analyzed paths:

```text
DRAFT
  ↓ Submit
SUBMITTED
  ├── Approve
  │     ↓
  │   APPROVED
  │
  └── Reject
        ↓
     REJECTED / REVISION FLOW
```

Pada Advance terdapat mekanisme Revision yang harus ditelusuri lebih lanjut pada Phase 4.

Disbursement berada setelah kondisi approval yang sesuai.

---

## B. Settlement

Status transition yang telah ditemukan pada analyzed paths:

```text
DRAFT
  ↓ Submit
SUBMITTED
  ├── Approve
  │     ↓
  │   APPROVED
  │
  └── Reject
        ↓
     Rejection / Correction Flow
```

Disbursement merupakan tahap lanjutan dan condition-nya harus dibuktikan pada Settlement feature flow.

### Important

Jangan menyamakan state machine Advance dan Settlement hanya karena keduanya memiliki nama status yang sama.

---

# 7. Company Access

Company access merupakan bagian dari authorization context.

Sumber utama:

`company_access` pada data user.

Konsep:

```text
Authenticated User
        ↓
company_access
        ↓
accessibleCompanies
        ↓
activeCompany
        ↓
API Company Context
```

Pada fallback yang telah ditemukan:

- `super_manager` dapat memperoleh seluruh `_systemCompanies`;
- role lainnya menggunakan fallback company yang tersedia sesuai implementation.

### Important Boundary

Fakta yang sudah diketahui adalah logic accessible company dan active company.

Apakah **setiap backend query** benar-benar menerapkan company filtering harus diverifikasi per endpoint.

Jangan menganggap company context otomatis berarti semua query pasti aman dari cross-company access.

---

# 8. Role-Specific Company Access

| Role | Company Access | Confidence |
|---|---|---|
| `super_manager` | Fallback dapat mencakup semua `_systemCompanies` | Confirmed from analyzed AuthProvider path |
| `manager` | Bergantung pada `company_access`; fallback mengikuti implementation | Confirmed / scope-dependent |
| `staff` | Bergantung pada `company_access`; fallback mengikuti implementation | Confirmed / scope-dependent |
| `mitra_eks` | Bergantung pada `company_access`; fallback mengikuti implementation | Confirmed / scope-dependent |

---

# 9. Manager vs Super Manager

Pada operational finance flow, kedua role masuk ke kategori manager-level pada logic yang dianalisis.

Namun terdapat perbedaan pada **account management / hierarchy**.

Temuan yang telah didokumentasikan:

- `manager` tidak dapat melakukan perubahan tertentu terhadap `super_manager`;
- `super_manager` memiliki scope account-management yang lebih tinggi.

### Important

Jangan menyimpulkan:

> "manager dan super_manager sama persis."

Yang benar:

> **Tidak ditemukan perbedaan pada permission operasional yang telah dianalisis, tetapi terdapat perbedaan pada account-management hierarchy.**

---

# 10. Staff vs Mitra Eks

Dalam path yang telah dianalisis:

> Tidak ditemukan perbedaan functional permission yang signifikan antara `staff` dan `mitra_eks`.

Namun ini harus diperlakukan sebagai:

**Analyzed-Scope Finding**

bukan:

**Global Application Fact**

Karena feature lain dapat memiliki conditional logic khusus yang belum dianalisis.

Jangan mengarang alasan bisnis tentang mengapa `mitra_eks` dibuat.

Contoh klaim yang **tidak boleh** dibuat tanpa evidence:

> "`mitra_eks` hanya untuk pelabelan vendor di laporan."

Itu merupakan business inference yang belum terbukti.

---

# 11. Permission Flow

Secara umum:

```text
LOGIN
 ↓
LOAD USER
 ↓
READ ROLE
 ↓
READ COMPANY ACCESS
 ↓
SET AUTH CONTEXT
 ↓
OPEN FEATURE
 ↓
CHECK UI ACCESS
 ↓
USER ACTION
 ↓
BACKEND AUTHORIZATION
 ↓
 ├── ALLOWED
 │      ↓
 │   Execute Action
 │
 └── DENIED
        ↓
      HTTP 403 / Error
```

Permission tidak dianggap lengkap hanya karena button terlihat di frontend.

---

# 12. Evidence Index

| Temuan | Evidence |
|---|---|
| Role definitions | `backend/models.py`, `frontend/lib/providers/auth_provider.dart` |
| `isManager` | `frontend/lib/providers/auth_provider.dart` |
| Manager-only menu gating | `frontend/lib/screens/main_layout.dart` |
| Advance ownership | `backend/routes/advances_crud.py` |
| Settlement ownership | `backend/routes/settlements_crud.py` |
| Advance approval authorization | `backend/routes/advances_approval.py` |
| Advance revision authorization | `backend/routes/advances_approval.py` |
| Advance disbursement authorization | `backend/routes/advances_disbursement.py` |
| Settlement approval authorization | `backend/routes/settlements_approval.py` |
| Settlement disbursement authorization | `backend/routes/settlements_disbursement.py` |
| Company access | `frontend/lib/providers/auth_provider.dart` |
| Account hierarchy | `backend/routes/auth.py` |

---

# 13. Confirmed

- Aplikasi memiliki 4 role:
  - `staff`
  - `mitra_eks`
  - `manager`
  - `super_manager`
- `manager` dan `super_manager` termasuk dalam manager-level gating pada frontend.
- Advance memiliki ownership/data-scope check.
- Settlement memiliki ownership/data-scope check.
- Manager/Super Manager memiliki action approval pada analyzed paths.
- Manager/Super Manager memiliki disbursement authorization pada analyzed paths.
- UI permission dan backend authorization sama-sama digunakan.
- Company access menggunakan `company_access` pada user context.
- Terdapat perbedaan hierarchy antara `manager` dan `super_manager` pada account management.

---

# 14. Inferred / Scope-Limited Findings

- `staff` dan `mitra_eks` belum menunjukkan perbedaan permission fungsional pada analyzed paths.
- Company context kemungkinan menjadi salah satu scope data utama feature.
- Beberapa status transition tampak memiliki pattern serupa antara Advance dan Settlement.

Semua poin di atas harus tetap diverifikasi pada feature flow jika diperlukan.

---

# 15. Unknown / Needs Verification

- Apakah terdapat permission khusus `mitra_eks` pada feature yang belum dianalisis.
- Apakah semua backend endpoint menerapkan company filtering secara konsisten.
- Apakah setiap action memiliki frontend dan backend authorization yang identik.
- Apakah terdapat permission khusus pada feature selain Advance/Settlement.
- Apakah semua status transition yang tampak serupa benar-benar memiliki implementation yang sama.
- Apakah terdapat exception/override permission yang belum ditemukan.
- Apakah terdapat role-based restriction pada level field, bukan hanya page/action.

---

# 16. Potential Contradiction / Documentation Mismatch

Jika dokumentasi lama menyatakan role tertentu memiliki permission yang berbeda dari implementation aktual:

> **Documentation vs Implementation Mismatch**

Jelaskan:

1. Apa yang dikatakan dokumentasi.
2. Apa yang dilakukan implementation.
3. File/evidence masing-masing.
4. Apakah requirement asli masih perlu dikonfirmasi.

Jangan diam-diam memilih salah satunya sebagai business requirement.

---

# 17. Scope Boundary

Phase 2 tidak membedah:

- detail UI workflow;
- detail form;
- detail rejection comment;
- detail revision mechanics;
- detail disbursement mechanics;
- detail return;
- detail balance;
- detail terminal state.

Phase 2 hanya menetapkan:

**WHO CAN DO WHAT, ON WHICH DATA, UNDER WHICH AUTHORIZATION CONDITION.**

Detail behavior akan dibongkar pada:

`Phase 4 — Feature Flow Reverse Engineering`

---

## Status

**PHASE 2 COMPLETE — READY FOR PHASE 3 / PHASE 4 VALIDATION**
