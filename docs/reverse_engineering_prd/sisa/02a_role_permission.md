# Phase 2: Role & Permission Reconstruction

**Tujuan:** Memetakan secara faktual siapa yang dapat melihat dan melakukan apa di dalam aplikasi berdasarkan *source code*.

---

## 1. Role Inventory

Aplikasi ini mengenal 4 *role* utama (Sumber: `backend/models.py:67-69` dan `frontend/lib/providers/auth_provider.dart`):
1. `staff`
2. `mitra_eks`
3. `manager`
4. `super_manager`

---

## 2. Role Permission Matrix (Feature Access)

Setiap baris di bawah ini membedakan antara batasan **UI Permission** (Frontend) dan **Backend Authorization**.

| Modul / Fitur | Hak Akses (*Ownership / Data Scope*) | Evidence |
| :--- | :--- | :--- |
| **Kasbon (Advance)** | **Semua Role:** Dapat membuat & melihat kasbon miliknya sendiri (`advance.user_id == user_id`).<br>**Manager/Super Manager:** Dapat melihat & memproses semua kasbon. | Frontend: `advances_screen.dart`<br>Backend: `advances_crud.py:212` |
| **Settlement** | **Semua Role:** Dapat membuat & melihat settlement miliknya sendiri.<br>**Manager/Super Manager:** Dapat melihat & memproses semua settlement. | Frontend: `main_layout_settlement_list.dart`<br>Backend: `settlements_crud.py:293` |
| **Reports** | **Staff/Mitra Eks:** Tidak memiliki UI Menu, Backend menolak (HTTP 403).<br>**Manager/Super Manager:** Akses UI & Backend Penuh. | Frontend: `main_layout.dart:274-277`<br>Backend: `reports/summary.py:340` |
| **Manajemen Kategori**| **Staff/Mitra Eks:** Tidak memiliki UI Menu, Backend menolak (HTTP 403).<br>**Manager/Super Manager:** Akses UI & Backend Penuh. | Frontend: `main_layout.dart:274-277`<br>Backend: `categories.py` |
| **Manajemen Bank** | **Staff/Mitra Eks:** Tidak memiliki UI Menu, Backend menolak (HTTP 403).<br>**Manager/Super Manager:** Akses UI & Backend Penuh. | Frontend: `main_layout.dart:274-277`<br>Backend: `bank_management.py` |
| **Pengaturan / Profil**| **Semua Role:** Dapat mengedit profil sendiri.<br>**Manager:** Dapat mengedit data user bawahan, *kecuali* profil `super_manager`.<br>**Super Manager:** Dapat mengedit semua user. | Frontend: `settings_screen.dart`<br>Backend: `auth.py:475,484` |

---

## 3. Action-Level Permission

| Modul | Aksi Khusus | Role yang Diizinkan (Backend Auth) | Evidence |
| :--- | :--- | :--- | :--- |
| **Advance** | Approve / Reject Item | `manager`, `super_manager` | `advances_approval.py:49` |
| **Advance** | Start Revision | `manager`, `super_manager` | `advances_approval.py:42-51` |
| **Advance** | Disburse (Pencairan) | `manager`, `super_manager` | `advances_disbursement.py:38` |
| **Settlement** | Approve / Reject Item | `manager`, `super_manager` | `settlements_approval.py:33` |
| **Settlement** | Disburse (Pencairan) | `manager`, `super_manager` | `settlements_disbursement.py:29` |

---

## 4. Status Transition Flow

*Transisi status diawasi secara ketat oleh Backend berdasarkan peran dan kepemilikan dokumen.*

### A. Advance (Kasbon) Status Flow
1. `draft` ➔ `submitted` : **Owner** (Semua Role) via tombol Submit.
2. `submitted` ➔ `approved` : **Manager / Super Manager** menyetujui.
3. `submitted` ➔ `rejected` : **Manager / Super Manager** menolak.
4. `approved` ➔ `revision` : **Manager / Super Manager** via tombol Start Revision.
5. `approved` ➔ `disbursed` : **Manager / Super Manager** mencairkan dana.

### B. Settlement Status Flow
1. `draft` ➔ `submitted` : **Owner** (Semua Role) via tombol Submit.
2. `submitted` ➔ `approved` : **Manager / Super Manager** menyetujui.
3. `submitted` ➔ `rejected` : **Manager / Super Manager** menolak.
4. `approved` ➔ `disbursed` : **Manager / Super Manager** mencairkan dana.

---

## 5. Company Access

Hak akses *Company* menentukan batasan data mana yang boleh ditarik dari *backend*.
- **Data Scope:** Diatur oleh field JSON `company_access` dari database per user.
- **Backend Authorization (Fallback):** 
  - Jika tabel kosong, `super_manager` secara default diberi izin ke semua `_systemCompanies`.
  - `manager`, `staff`, `mitra_eks` secara default dibatasi ke *company* pertama.
- **Evidence:** `frontend/lib/providers/auth_provider.dart:63-75`.

---

## 6. Confirmed, Inferred, Unknown & Contradictions

### Confirmed (Fakta dari Kode)
1. **Pemisahan Lapis Ganda:** Pembatasan *role* dilakukan secara ganda: **UI Permission** (hiding tabs di `main_layout.dart`) dan **Backend Authorization** (pengecekan statemen `if user.role not in...` di sisi Python).
2. **Perbedaan Manager vs Super Manager:** Identik secara hak operasional/keuangan, hanya berbeda pada hierarki modifikasi *Profile* di *Account Management*.

### Inferred
- **Peran Mitra Eksternal:** No functional permission difference was identified in the analyzed paths antara `staff` dan `mitra_eks`. Keduanya terhubung ke alur otorisasi non-manajerial yang persis sama.

### Unknown
- No additional unknown permission was identified within the analyzed scope. Logika gating terstruktur konsisten menggunakan `is_manager`.

### Potential Contradictions
- Tidak ada kontradiksi otorisasi. Aturan `isManager` di frontend selaras sempurna dengan filter `["manager", "super_manager"]` di backend.
