# Bugfix: Status Verifikasi Item Setelah Edit Data

**Tanggal:** 27 Mei 2026  
**Modul terdampak:** Settlement (`backend/routes/settlements.py`) & Kasbon (`backend/routes/advances.py`)

---

## Latar Belakang Masalah

Setelah item settlement / kasbon sebelumnya sudah pernah diverifikasi (status `APPROVED`),
kemudian data diubah melalui tombol **Edit**, lalu di-**Submit** ulang — sistem langsung
menganggap item tersebut masih `APPROVED` **tanpa melalui proses verifikasi ulang** oleh manager
(centang / silang). Ini berarti manager bisa meng-approve settlement tanpa memeriksa kembali
item yang sudah diubah.

---

## Root Cause: 2 Bug Ditemukan

### Bug 1 — `update_expense` / `update_item`: Status override yang salah

**File:**
- `backend/routes/settlements.py` → fungsi `update_expense()` (sekitar baris 422–430)
- `backend/routes/advances.py` → fungsi `update_item()` (sekitar baris 649–655)

**Masalah:**

Kode sudah ada logika yang benar: saat item di-edit (bukan update checklist), status direset ke `"pending"`:

```python
if not is_updating_checklist:
    expense.status = "pending"   # ✅ reset ke pending
```

Namun **tepat di bawahnya** ada kode yang bisa menimpa kembali:

```python
if "status" in data:
    expense.status = data["status"]  # ❌ bisa override balik ke "approved"!
```

Baris ini seharusnya **hanya** boleh berjalan saat update dilakukan oleh manager melalui
centang/silang (checklist), bukan saat edit item biasa.

**Fix:**

```python
# Status hanya boleh diubah via checklist update (centang/silang manager),
# bukan dari edit item biasa agar tidak bypass reset ke "pending".
if is_updating_checklist and "status" in data:
    expense.status = data["status"]
```

---

### Bug 2 — `move_to_draft` / `move_advance_to_draft`: `is_disbursement_approved` tidak direset

**File:**
- `backend/routes/settlements.py` → fungsi `move_to_draft()` (sekitar baris 1222+)
- `backend/routes/advances.py` → fungsi `move_advance_to_draft()` (sekitar baris 1670+)

**Masalah:**

Saat settlement / kasbon dikembalikan ke Draft (`move_to_draft`), flag `is_disbursement_approved`
(status approval Tabel 2 / Pengiriman Dana) **tidak direset ke `False`**.  
Akibatnya, Tabel 2 masih dianggap sudah di-approve padahal data bisa saja berubah.

**Fix:**

```python
# Reset T2 approval flag — jika T2 pernah diubah, harus di-approve ulang.
settlement.is_disbursement_approved = False
```

---

## Perilaku Akhir (Hasil Setelah Fix)

### Alur yang benar sekarang:

Misalkan ada 3 item: **A**, **B**, **C** — semuanya sudah `APPROVED` sebelumnya.

| Langkah | Item A | Item B | Item C (diedit) |
|---|---|---|---|
| Sebelum Move to Draft | `APPROVED` | `APPROVED` | `APPROVED` |
| Setelah Move to Draft | `APPROVED` | `APPROVED` | `APPROVED` |
| Setelah Edit Item C | `APPROVED` | `APPROVED` | → `PENDING` (otomatis) |
| Setelah Submit Ulang | `APPROVED` | `APPROVED` | `PENDING` |
| Manager buka | ✅ skip | ✅ skip | ⬜ wajib centang/silang |
| Setelah Manager centang | `APPROVED` | `APPROVED` | → `APPROVED` |

**Intinya: hanya item yang di-edit yang perlu diverifikasi ulang. Item lain yang tidak
disentuh tetap `APPROVED` dan tidak perlu centang ulang.**

---

## Catatan Penting: Skenario yang Tidak Berubah

| Kondisi | Perilaku |
|---|---|
| Edit item → submit → manager belum centang | Status tetap `PENDING`, approve settlement di-block |
| Tidak ada yang diedit → move to draft → submit ulang | Item tetap `APPROVED`, manager boleh langsung approve |
| Manager silang item (reject) + komentar | Status jadi `REJECTED`, komentar masuk ke checklist item |
| Edit item yang di-reject → submit ulang | Item kembali ke `PENDING`, wajib verifikasi ulang |
| Tabel 2 (Pengiriman Dana) setelah move_to_draft | Selalu direset `is_disbursement_approved = False`, harus di-approve ulang |

---

## File yang Diubah

### `backend/routes/settlements.py`

| Baris | Perubahan |
|---|---|
| ~430 | `if "status" in data` → `if is_updating_checklist and "status" in data` |
| ~1258 | Tambah `settlement.is_disbursement_approved = False` di dalam `move_to_draft()` |

### `backend/routes/advances.py`

| Baris | Perubahan |
|---|---|
| ~655 | `if "status" in data` → `if is_updating_checklist and "status" in data` |
| ~1706 | Tambah `advance.is_disbursement_approved = False` di dalam `move_advance_to_draft()` |

---

## Tidak Ada Perubahan di Frontend

Semua fix dilakukan **hanya di backend**. Frontend tidak perlu diubah karena:
- Edit item biasa (`updateExpense` / `updateItem`) **tidak pernah mengirim field `status`** dalam payload — sudah benar dari awal.
- Update checklist (`updateExpenseData` dengan `status: newStatus`) tetap berjalan normal karena guard `is_updating_checklist` sudah mengenali request ini.
