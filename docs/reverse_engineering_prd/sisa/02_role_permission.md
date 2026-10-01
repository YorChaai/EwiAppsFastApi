# Phase 2: Role & Permission Reconstruction

**Tujuan:** Memetakan secara faktual siapa yang dapat melihat dan melakukan apa di dalam aplikasi berdasarkan *source code*, bukan asumsi nama *role*.

---

## 1. Role Inventory

Berdasarkan `models.py` baris 67-69 dan `auth_provider.dart`, aplikasi ini mengenal 4 *role*:
1. `staff`
2. `mitra_eks`
3. `manager`
4. `super_manager`

---

## 2. Role Permission Matrix (Feature Access)

| Modul / Fitur | `staff` / `mitra_eks` | `manager` | `super_manager` | Evidence / Catatan |
| :--- | :--- | :--- | :--- | :--- |
| **Kasbon (Advance)** | Akses Data Sendiri | Akses Semua Data | Akses Semua Data | `advances_crud.py:212` (Cek `user_id`) |
| **Settlement** | Akses Data Sendiri | Akses Semua Data | Akses Semua Data | `settlements_crud.py:293` (Cek `user_id`) |
| **Reports** | Tidak Ada Akses | Penuh | Penuh | `main_layout.dart` & `reports/summary.py` |
| **Manajemen Kategori** | Tidak Ada Akses | Penuh | Penuh | `main_layout.dart` & `categories.py` |
| **Manajemen Bank** | Tidak Ada Akses | Penuh | Penuh | `main_layout.dart` & `bank_management.py` |
| **Pengaturan & Profil** | Akses Profil Sendiri | Akses Profil & User Bawah | Akses Semua User | `auth.py:475,484` |

---

## 3. Action-Level Permission (Kasbon & Settlement)

| Aksi | Kondisi / Syarat | Role yang Diizinkan |
| :--- | :--- | :--- |
| **Create (Draft)** | - | Semua *Role* |
| **Edit/Delete** | Status = `draft` atau `revision` | Pembuat (*Owner*) atau `manager`/`super_manager` |
| **Submit** | Status = `draft` atau `revision` | Pembuat (*Owner*) atau `manager`/`super_manager` |
| **Approve Item** | Status = `submitted` | Hanya `manager` / `super_manager` |
| **Reject Item** | Status = `submitted` | Hanya `manager` / `super_manager` |
| **Approve Final** | Semua item berstatus `approved` | Hanya `manager` / `super_manager` |
| **Disburse (Pencairan)**| Status = `approved` (Final) | Hanya `manager` / `super_manager` |

---

## 4. Status Transition by Role

Berikut adalah wewenang perubahan status berdasarkan peran (berlaku untuk Kasbon dan Settlement):

1. `draft` ➔ `submitted` : **Owner** (Semua Role) menekan tombol Submit.
2. `submitted` ➔ `approved` : **Manager / Super Manager** menyetujui seluruh item.
3. `submitted` ➔ `rejected` : **Manager / Super Manager** menolak item dan memberikan komentar.
4. `rejected` ➔ `revision` : **Manager / Super Manager** (di Advance) menekan Start Revision (kembali ke owner).
5. `approved` ➔ `completed` / `disbursed` : **Manager / Super Manager** mencairkan dana.

---

## 5. Company Access & Role Gating

**A. UI Menu Gating**
Di `frontend/lib/screens/main_layout.dart:274-277`, menu Reports, Kategori, dan Bank secara eksplisit disembunyikan jika `!auth.isManager`. Getter `isManager` di `auth_provider.dart:30` memeriksa apakah `role == 'manager' || role == 'super_manager'`.

**B. Backend Permission Enforcement**
Penyembunyian UI dikawal ketat oleh *backend*. Setiap *route* untuk Reports, Kategori, Bank, Pencairan (Disbursement), dan Persetujuan (Approval) diawali dengan validasi:
`if user.role not in ["manager", "super_manager"]:`
Jika peran tidak sesuai, backend me-return HTTP 403 Forbidden.

**C. Company Access**
Di `auth_provider.dart:63-75`:
- Hak akses *Company* utamanya diatur oleh field JSON `company_access` dari database.
- Jika data kosong/NULL:
  - `super_manager` otomatis mendapatkan akses ke semua `_systemCompanies` secara bawaan (*fallback*).
  - Role lainnya (`manager`, `staff`, `mitra_eks`) hanya mendapat akses ke 1 company pertama (*default* "EWI Foundation").

---

## 6. Confirmed, Inferred, Unknown & Contradictions

### Confirmed (Fakta dari Kode)
1. **Tidak Ada Beda `staff` dan `mitra_eks`:** Pada level UI maupun Backend *Logic* (CRUD & Persetujuan), `staff` dan `mitra_eks` diperlakukan sama persis. Bedanya hanya pada nama *Role* di database.
2. **Perbedaan `manager` dan `super_manager`:** Keduanya identik dalam hak akses operasional keuangan. Perbedaannya hanya pada manajemen akun (`auth.py`). `manager` tidak bisa mengedit profil/akun `super_manager` atau mengangkat akun baru menjadi `super_manager`.
3. **Validasi Lapis Ganda:** Pembatasan akses dilakukan baik di Frontend (Menyembunyikan UI/Tombol) maupun di Backend (Mengecek `user.role` sebelum mengeksekusi query database).

### Inferred (Asumsi Berdasarkan Struktur)
- Alasan adanya `mitra_eks` kemungkinan besar hanya untuk pelabelan/kategorisasi pengguna eksternal di laporan, bukan untuk pembedaan fungsi sistem yang mendasar.

### Unknown
- Tidak ada hak otorisasi yang tidak diketahui (*Unknown*). Logika perizinan sudah dipetakan dengan jelas dan konsisten di seluruh *controllers* (Backend).

### Potential Contradictions
- **Documentation vs Implementation Mismatch:** Dokumentasi spesifikasi lama (jika ada) mungkin membedakan fungsi operasional `staff` dan `mitra_eks`, namun secara implementasi kode *frontend* dan *backend*, sama sekali tidak ada perbedaan wewenang fungsional di antara keduanya.

---

## 7. Evidence Index
| Penemuan | File Lokasi | Detail Bukti |
| :--- | :--- | :--- |
| **Definisi isManager** | `frontend/lib/providers/auth_provider.dart:30` | `bool get isManager => _user?['role'] == 'manager' \|\| _user?['role'] == 'super_manager';` |
| **Backend Enforcement (Contoh)** | `backend/routes/advances_approval.py:49` | `if not is_manager and advance.user_id != user_id: return jsonify({"error": "Akses ditolak"}), 403` |
| **Super Manager Company Access** | `frontend/lib/providers/auth_provider.dart:69` | `if (isSuperManager) { return _systemCompanies; }` |
| **Account Mgmt Escalation** | `backend/routes/auth.py:475` | `manager` ditolak mengedit `super_manager`. |
