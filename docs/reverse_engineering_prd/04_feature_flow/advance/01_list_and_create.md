# ADVANCE: LIST & CREATE

## 1. Feature Purpose

Fitur utama untuk menampilkan daftar Kasbon yang dapat diakses oleh user, melakukan pencarian/filter, dan membuat dokumen Kasbon baru.

## 2. Entry Point

Menu navigasi "Kasbon" pada `MainLayout` → `AdvancesScreen`.

## 3. Actors

*   `staff` / `mitra_eks`: Hanya melihat kasbon miliknya sendiri.
*   `manager` / `super_manager`: Melihat seluruh kasbon di company tersebut.

## 4. Normal Flow: View List

**Actor / Role:**
Semua role terotentikasi.

**Page / UI:**
`AdvancesScreen`

**System Behavior:**
1. Provider `AdvanceProvider` melakukan pengambilan data.
2. Memanggil `ApiService.getAdvances()`.

**API / Backend Behavior:**
`GET /api/advances` (`backend/routes/advances_crud.py`)

**Backend Logic & Database Effect:**
1. Mengambil *query* dari tabel `Advance`.
2. Melakukan filter wajib: `Advance.company == activeCompany`.
3. Menyembunyikan dummy advance yang di-generate sistem:
   * `NOT LIKE 'Penyelesaian Kasbon:%'`
   * `NOT LIKE 'Kompensasi Split Kasbon:%'`
   * `NOT LIKE 'Split Potongan Kasbon:%'`
4. **Role Check**: Jika user **bukan** `manager` atau `super_manager`, sistem menambahkan filter `user_id = user.id`.
5. Melakukan filtering tambahan berdasarkan parameter request:
   * `status`
   * `report_year` (mencocokkan tahun pada `document_date`, `created_at`, atau item `date`)
   * `type` (`single` atau `batch`)
   * `start_date` dan `end_date` (mencari berdasarkan `document_date` atau fallback ke `created_at`)
   * `search` (mencocokkan substring di `title`, `description`, `document_date`, `created_at`)
6. Mengembalikan daftar kasbon yang sudah diurutkan berdasarkan `created_at` (ascending) lalu `id` (ascending).

**UI Result & List Interaction:**
*   **Grouping**: Daftar kasbon dipisah secara visual ke dalam dua kelompok tab/section: `SINGLE` dan `BATCH`.
*   **Empty/Loading/Error State**: Di-*handle* oleh state Provider. Menampilkan *loading indicator* saat fetch data, pesan error jika request gagal, atau widget kosong (empty state) jika tidak ada data yang cocok dengan filter.
*   **Row/Card Actions**: Baris (card) dapat ditekan (OnTap) untuk membuka detail (masuk ke `AdvanceDetailScreen`).
*   **Edit/Delete Visibility**: Terdapat mode multiselect untuk *Delete*. Icon *Delete* hanya muncul atau dapat ditekan jika memenuhi syarat `_canDeleteAdvanceCard` (contoh: staff hanya bisa hapus draf; manager bisa hapus status selain yang terikat settlement). Edit dilakukan di layar Detail, bukan di List.

---

## 5. Negative / Blocked Flow: Outstanding Debt Check

Saat user menekan tombol "Buat Kasbon".

```text
Action: Click "Buat Kasbon"
↓
Condition Failed: User memiliki outstanding (saldo kasbon yang belum dipertanggungjawabkan) > 0.01.
(Dicek via `prov.checkUserOutstanding()`)
↓
System Response: Memblokir langsung pembuatan dokumen.
↓
UI Response: Menampilkan AlertDialog "Perhatian: Outstanding Kasbon" beserta nominal outstanding ("Anda masih memiliki saldo kasbon sebesar [Nominal] yang belum dipertanggungjawabkan...").
↓
Current State: Tetap di AdvancesScreen
↓
What User Must Do Next:
Terdapat 3 pilihan:
1. "Batal" (kembali ke list)
2. "Kembalikan Dana Sekarang" (membuka dialog `_showStandaloneReturnDialog` khusus tanpa membuat dokumen baru)
3. "Lanjut Buat Pengeluaran" (override / bypass peringatan dan lanjut membuat kasbon)

**Outstanding Debt Blocker Deep-Dive:**
*   **Siapa yang dapat bypass:** Karyawan/User yang membuat kasbon itu sendiri.
*   **Apakah bypass hanya UI atau backend juga:** Bypass **Hanya terjadi di UI**. Backend API `POST /api/advances` tidak memiliki validasi *outstanding debt check*. Backend akan menerima draf baru terlepas dari berapapun outstanding user.
*   **Side Effect:** Menekan tombol bypass menutup dialog peringatan dan langsung membuka dialog *Create Advance* standar.
*   **Apakah outstanding tetap tercatat:** Ya. Melakukan bypass **tidak** mereset atau menghapus outstanding. Uang yang belum di-*settle* tetap menjadi hutang user di buku besar sistem (Dompet Karyawan).
*   **Apa yang terjadi setelah override:** Dokumen draf baru berhasil dibuat. Namun, perlu dicatat bahwa Manager yang menyetujui pengajuan kasbon ini di tahap selanjutnya (Final Approve) akan melihat total hutang karyawan. Peringatan outstanding ini berfungsi sebagai "Early Warning" agar user sadar bahwa pengajuan baru ini memiliki kemungkinan besar ditolak oleh Manager jika hutang lama belum diselesaikan.
```

---

## 6. Normal Flow: Create Advance

**Condition Before:**
User berhasil melewati pengecekan Outstanding Debt (atau melakukan bypass).

**Page / UI:**
Dialog "Buat Kasbon Baru" di `AdvancesScreen`.

**User Action:**
1. Memilih **Tahun Laporan** (Default: tahun laporan aktif saat ini).
2. Memilih **Tipe**: `Single` atau `Batch`.
3. Jika `Batch`, user diwajibkan mengisi:
   * Judul Kegiatan
   * Tanggal Batch
4. Menekan tombol "Buat".

**Validation:**
1. Jika tipe `batch` dan judul kosong → proses dihentikan.
2. Jika tipe `batch` dan tanggal kosong → menampilkan `AppSnackbar` error "Tanggal Batch wajib diisi".

**System Behavior:**
UI memanggil `AdvanceProvider.createUnsavedAdvance(...)`.

**API / Backend Behavior:**
`POST /api/advances` (`backend/routes/advances_crud.py`)

**Backend Logic & Database Effect:**
1. Validasi: `title` wajib diisi.
2. Membentuk entitas `Advance` baru.
3. Penetapan field:
   * `user_id` = User login saat ini.
   * `company` = `activeCompany` dari token/header.
   * `status` = `"draft"`
   * `approved_revision_no` = `0`
   * `active_revision_no` = `None`
4. Disimpan ke tabel `Advance` di database (`db.session.add(advance) -> commit()`).
5. Respons `201 Created` dengan data kasbon baru.

**Status Before:**
(Dokumen belum ada)

**Status After:**
`draft`

**Side Effects:**
Flag `_unsavedDraft = true` diset pada `AdvanceProvider`. (Digunakan oleh frontend untuk menandakan ini adalah dokumen baru yang belum ditambahkan rincian/item).

**Next Step:**
Dialog ditutup. UI melakukan navigasi (push) ke halaman `AdvanceDetailScreen` membawa `advanceId` baru.

---

## 7. Cross-Feature Dependency

*   **Company Context (Confirmed)**: List dan Create secara ketat disekat oleh `activeCompany`. Kasbon disimpan mengikat ke company aktif.
*   **Settlement / Outstanding (Confirmed)**: Pembuatan kasbon memiliki conditional block yang memeriksa total kasbon user saat ini yang belum di-*settle* / dikembalikan secara sistem.

---

## Evidence

*   **Viewed File:** `frontend/lib/screens/advance/advances_screen.dart` (List render, FAB Buat Kasbon, Pengecekan outstanding, bypass dialog).
*   **Viewed File:** `frontend/lib/providers/advance_provider.dart` (`createUnsavedAdvance`, filter state, pagination logic).
*   **Viewed File:** `backend/routes/advances_crud.py` (`GET /api/advances` date range and wildcard search logic, `POST /api/advances` validation).

## Confirmed

*   Role routing pada List Advance: Manager/Super Manager melihat seluruh kasbon di satu company, Staff/Mitra Eks hanya milik sendiri.
*   Pembuatan Advance menghasilkan dokumen di database dengan status `draft`.
*   Pengecekan outstanding debt sebagai blocker adalah fitur front-end (UI Gate) dengan kapabilitas override. Backend mengizinkan pembuatan kasbon secara teknikal terlepas dari outstanding.

## Unknown

*   Terminal state dari Advance (Akan dibahas pada dokumen *Approval Loop*).

## Potential Issues

*   **Backend Outstanding Bypass**: Karena outstanding check murni bersifat UI, API dapat ditembak langsung via tools seperti Postman untuk membuat draf secara masif walau user memiliki hutang. Ini bukan celah kritis karena draf tetap butuh *Manager Approval* sebelum uang dicairkan, tapi secara teknikal merupakan inkonsistensi pertahanan.
