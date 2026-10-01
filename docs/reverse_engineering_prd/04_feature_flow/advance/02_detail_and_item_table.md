# ADVANCE: DETAIL & ADD ITEM (TABEL 1)

## 1. Feature Purpose

Melihat detail kasbon yang sudah dibuat dan menambahkan/mengedit rincian (items) kasbon (disebut sebagai Tabel 1 di UI).

## 2. Entry Point

Navigasi dari list Advance setelah klik baris dokumen, atau secara otomatis setelah dokumen kasbon baru dibuat (redirect ke `AdvanceDetailScreen`).

## 3. Screen Initialization (Detail Load)

**System Behavior:**
1. Memanggil `AdvanceProvider.loadAdvance(advanceId)`.
   API: `GET /api/advances/<id>`.
2. Memanggil `_fetchActiveAdvanceBalance(userId)`.
   API: Mengambil virtual balance (`AdvanceProvider.fetchUserVirtualBalances`) dan real bank balance (`GET /api/advances/active_balance/<user_id>`).
3. Memuat Master Data: `SettlementProvider.loadCategories()`, `SettlementProvider.loadBanks()`, `SettlementProvider.loadAdvanceBanks()`.

**API Response / Database Effect:**
`GET /api/advances/<id>` mengembalikan entity `Advance` beserta relasi `AdvanceItem` (`joinedload`).
Jika user bukan manager/super_manager dan advance ini bukan miliknya, maka akses ditolak (`403`).

---

## 4. Normal Flow: Add Item (Tabel 1)

**Condition Before:**
Kasbon masih berstatus `draft` atau sedang dalam `revision`.

**Actor / Role:**
Staff / Pembuat Dokumen.

**Page / UI:**
`AdvanceDetailScreen` → klik "Tambah Item Kasbon" → `_showAddItemDialog`.

**User Action:**
1. Memilih **Kategori Utama** dan **Sub Kategori**.
2. Mengisi **Deskripsi Item**.
3. Menentukan **Sumber Dana**.
4. Mengisi **Nilai (Amount)**.
5. Memilih **Mata Uang** (Currency) dan **Kurs** (Exchange Rate).
6. Memilih **Tanggal Pengeluaran**.
7. Mengunggah **Bukti** (Evidence).
8. Menekan tombol "Simpan".

**Validation (Frontend):**
1. Evidence (Bukti) wajib diisi.
2. Nominal tidak boleh 0 atau <= 0 jika tidak diset negatif.
3. Ekuivalen Rupiah (Amount * Exchange Rate) harus lebih dari Rp 100 atau kurang dari Rp -100.

**System Behavior:**
Memanggil `AdvanceProvider.saveFirstItemAndCommitAdvance` (jika ini item pertama dari dokumen unsaved) atau `addAdvanceItem`.
File bukti dikirim ke backend.

**API / Backend Behavior:**
`POST /api/advances/<advance_id>/items` (`backend/routes/advances_items.py`)

**Backend Validation:**
1. Cek mode edit: menggunakan `_editable_revision_no`. Jika advance tidak dapat diedit (bukan draft/revision), kembalikan error `400`.
2. Semua sub-kategori yang dipilih harus berada di bawah parent kategori utama yang sama.
3. Nominal ekuivalen IDR >= 100 atau <= -100.
4. **Cross-Feature Restriction**: Jika `advance_type == "single"`, dokumen hanya boleh memiliki 1 item. Jika sudah ada, kembalikan error `400`.

**Database / Data Effect:**
1. Menyimpan file ke `uploads/receipts/YYYY/MM/`.
2. Membuat entity `AdvanceItem` baru.
   * Disambungkan ke `Advance.id`.
   * Disambungkan ke `category_id` (kategori utama).
   * Disambungkan ke tabel pivot `advance_item_subcategories`.
   * `revision_no` = `editable_revision_no` (biasanya 0 untuk draft awal).
3. Set `Advance.modified_t1 = True`. (Flag penanda bahwa ada perubahan pada Tabel 1, di-trigger oleh backend setiap kali item ditambah/diedit).

**Parent-Child Synchronization (PENTING):**
Sistem melakukan auto-synchronization terhadap Parent (`Advance`) saat Child (`AdvanceItem`) berubah:
1. Jika `advance_type == "single"`, maka `advance.title` langsung ditimpa (disamakan) dengan `item.description`.
2. **Peran `modified_t2`**: Jika `advance.modified_t2 == False` (Tabel 2/Disbursement belum pernah diedit dan disimpan secara manual oleh Manager), maka:
   * `advance.disbursed_amount` secara otomatis disamakan dengan `advance.total_amount` (jumlah dari seluruh item Tabel 1).
   * *Auto-sync* berhenti jika Manager menyimpan form Tabel 2, yang akan merubah `modified_t2 = True`.

**Status Before:**
`draft`

**Status After:**
`draft` (tetap)

**UI Result:**
Dialog ditutup, Item Table memuat baris baru, total nominal kasbon di header ter-update secara reaktif karena Provider me-reload data dari backend.

---

## 5. Negative / Blocked Flow

```text
Action: "Simpan" pada Add Item
↓
Condition Failed: Jumlah ekuivalen Rupiah < Rp 100.
↓
System Response: Frontend menolak mengirim data ke API.
↓
UI Response: Menampilkan SnackBar error "Nominal ekuivalen Rupiah harus lebih dari Rp 100...".
↓
Current State: User tetap berada di Add Item Dialog.
↓
What User Must Do Next: User harus mengoreksi nilai nominal atau kurs.
```

```text
Action: "Simpan" pada Add Item
↓
Condition Failed: User mencoba menambah item kedua pada Kasbon tipe Single.
↓
System Response: Backend API menolak eksekusi (HTTP 400).
↓
UI Response: SnackBar error "Kasbon single hanya boleh memiliki 1 item".
↓
Current State: Add Item Dialog ditutup (karena request dilakukan), tapi item tidak ditambahkan.
↓
What User Must Do Next: User harus menghapus item lama jika ingin menggantinya, atau mengubah kasbon ke mode Batch.
```

**Negative / Blocked Flow Lainnya yang Ditangani Backend:**
*   **Missing Category / Invalid Relation**: Jika `category_id` tidak valid atau user mencoba memasukkan multi-subcategory dari parent yang berbeda, backend menolak dengan HTTP 400 ("Semua sub-kategori harus berada di bawah kategori utama yang sama").
*   **Unauthorized Action (HTTP 403)**: Staff mencoba mengubah item pada kasbon milik orang lain, atau mencoba merubah status checklist (`approved/rejected`).
*   **Invalid Status / Revision Lock (HTTP 400)**: Staff mencoba mengedit/menghapus item saat dokumen berstatus `submitted`. Backend mengembalikan "Item ini sudah terkunci".
*   **Delete Failure (HTTP 400)**: Penghapusan ditolak jika Kasbon sudah terikat pada Settlement, atau jika penghapusan item akan menyebabkan Plafon Karyawan menjadi minus akibat *Cross-Usage* di Dompet Gabungan.

---

## 6. Edit / Delete Item

**Edit Item:**
Mekanisme ini (`PUT /api/advances/items/<item_id>`) memiliki kontrol akses yang lebih ketat daripada saat menambah item.
*   **Allowed Fields & Behavior**: 
    * Jika dokumen *Draft*, user dapat mengedit semua field (kategori, deskripsi, nominal, dsb). 
    * Jika dokumen *Submitted* / *Rejected*, user/staff **TIDAK** dapat mengedit field utama. Manager hanya diizinkan mengirim *checklist fields* (`notes`, `status`, `checked`).
*   **Validation**: Sama dengan Add Item (ekuivalen IDR >= 100).
*   **Evidence Behavior**: Jika file baru diunggah, backend akan menghapus file fisik yang lama menggunakan utilitas `delete_evidence_file`, baru menyimpan yang baru.
*   **Status Effect**: Saat staff mengedit, status item akan ter-reset menjadi `pending`. Jika item memiliki catatan revisi (*unchecked checklist*), status otomatis menjadi `rejected`. Hanya Manager yang boleh merubah status ke `approved` secara manual, yang juga men-trigger validasi ketersediaan saldo plafon khusus untuk item ini.
*   **Database Effect**: Mengupdate baris `AdvanceItem`, men-set `Advance.modified_t1 = True`, dan mengulang Parent Sync (update title dan `disbursed_amount` jika `modified_t2 == False`).

**Delete Item:**
Mekanisme penghapusan (`DELETE /api/advances/items/<item_id>`).
*   **Owner / Role**: Staff hanya dapat menghapus item jika item tersebut *unlocked* (berada dalam mode draft). Manager dapat menghapus kapan saja (bypass lock).
*   **Status Requirement**: Tidak boleh dihapus jika Kasbon telah memiliki turunan `Settlement`. Jika dihapus pada status *Completed*, backend melakukan simulasi *Plafon underflow check* (bisa ditolak jika saldo sudah dipakai).
*   **Last-Item Behavior**: Jika item terakhir dari Kasbon dihapus, dokumen Kasbon tetap ada, hanya saja `total_amount` menjadi 0.
*   **Parent Effect**: T2 tersinkronisasi (menjadi 0 jika `modified_t2 == False`), dan T3 (*Return*) dihitung ulang (*diff*).
*   **Database & File Cleanup**: Memanggil `delete_evidence_file` secara fisik di server, lalu menjalankan `db.session.delete(item)`.

---

## 7. Role / Action Matrix (Tabel 1)

| Action | Staff / Pembuat | Manager / Super Manager |
| :--- | :--- | :--- |
| **View List** | Hanya miliknya | Semua dalam Company |
| **Add Item** | Ya (jika Draft/Revision) | Ya (jika Draft/Revision) |
| **Edit Data Item** | Ya (jika Draft/Revision) | Ya (jika Draft/Revision) |
| **Edit Checklist/Status**| Tidak | Ya (kapan saja) |
| **Delete Item** | Ya (jika Draft/Revision) | Ya (Bisa bypass lock) |

---

## Evidence

*   **Viewed File:** `frontend/lib/screens/advance/advance_detail_screen.dart` (`initState`).
*   **Viewed File:** `frontend/lib/screens/advance/dialogs/dialog_add_item.dart` (`_showAddItemDialog` UI and validation logic).
*   **Viewed File:** `backend/routes/advances_items.py` (`POST /<int:advance_id>/items`, validasi IDR, auto-sync Tabel 2, batasan single item).

## Confirmed

*   Detail load mengambil data virtual balance dan real bank balance.
*   Pembuatan item Single hanya dibatasi maksimal 1 item.
*   *Parent-Child Synchronization*: Penambahan item (T1) otomatis mengubah nilai Tabel 2 (Disbursement) jika T2 belum disentuh secara manual.
*   Upload file evidence hukumnya wajib.

## Inferred

*   Tombol Submit Document (Kirim ke Manager) sepertinya baru akan terbuka jika dokumen memiliki setidaknya 1 item dan tidak ada warning checklist yang belum terselesaikan. (Akan dibahas di file workflow berikutnya).
