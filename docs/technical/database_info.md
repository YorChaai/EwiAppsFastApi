# Informasi Awal Database (Clean State)

Dokumen ini berisi informasi mengenai akun, role, perusahaan, dan kategori awal yang terdaftar di database setelah inisialisasi ulang menggunakan skrip pembersih data.

## 1. Akun & Role (Users)

Saat ini hanya terdapat **1 Akun Utama** yang terdaftar di sistem untuk memudahkan pengujian dan menghindari konflik login:

| Username | Password | Role | Email | Akses Perusahaan |
| :--- | :--- | :--- | :--- | :--- |
| **`anevril`** | `password123` | `manager` (Super Manager) | `anevril@example.com` | PT. EXSPAN WIRELINE INDONESIA, PT. ELNUSA TBK |

---

## 2. Akses Perusahaan (Companies)

Akun `anevril` memiliki hak akses penuh ke 2 entitas perusahaan berikut:
1. **`PT. EXSPAN WIRELINE INDONESIA`** (EWI)
2. **`PT. ELNUSA TBK`** (Elnusa)

---

## 3. Kategori Awal (Categories)

Kategori-kategori bawaan (*default seed*) yang telah terdaftar di database:

### A. BEBAN LANGSUNG

*   **Biaya Operasi** (Kode: `A`)
    *   `Transportation` (Kode: `A1`)
    *   `Accommodation` (Kode: `A2`)
    *   `Allowance` (Kode: `A3`)
    *   `Meal` (Kode: `A4`)
*   **Biaya Research (R&D)** (Kode: `B`)

### B. BIAYA ADMINISTRASI DAN UMUM

*   **Administrasi** (Kode: `C`)
    *   `Biaya Bank & Admin` (Kode: `C1`)

---

> [!NOTE]
> Seluruh kategori lain dari data multi-year/Excel akan ditambahkan secara dinamis oleh generator migrasi saat Anda mengimpor data keuangan Excel.
