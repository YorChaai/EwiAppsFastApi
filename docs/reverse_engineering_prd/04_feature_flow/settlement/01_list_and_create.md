# SETTLEMENT: LIST & CREATE FLOW

## 1. Maksud dan Tujuan

Modul **Settlement (LPJ / Reimbursement)** adalah pintu masuk untuk pelaporan pengeluaran riil karyawan. Berbeda dengan Advance (Kasbon) yang murni untuk perencanaan dan pencairan dana di muka, Settlement mencatat bukti transaksi aktual (*nota, struk, kuitansi*).

Modul ini mendukung dua jenis transaksi fundamental:
1. **Direct Settlement (Reimbursement)**: Karyawan menggunakan uang pribadi terlebih dahulu, lalu meminta penggantian dana (Reimburse). Dokumen ini berdiri sendiri (`advance_id = null`).
2. **Kasbon Settlement (LPJ Kasbon)**: Karyawan mempertanggungjawabkan uang Kasbon yang telah dicairkan sebelumnya. Dokumen ini terikat dengan dokumen Kasbon induk (`advance_id` terisi).

---

## 2. List & Filtering (`GET /api/settlements`)

Sama halnya dengan modul Advance, layar List Settlement menampilkan seluruh LPJ yang diajukan oleh pengguna (jika Staff) atau seluruh LPJ di perusahaan (jika Manager).

### 2.1 Filtering & Grouping Mechanics

| Parameter / Filter | Mekanisme di Backend (`settlements_crud.py`) |
| :--- | :--- |
| **Status Filter** | - `approved` & `completed` digabung dalam satu query (`status IN ('approved', 'completed')`).<br>- `rejected` / `revision` mencari parent status `rejected`, ATAU memiliki item expense berstatus `rejected`, ATAU `return_status == 'rejected'`. |
| **Year Filter** (`report_year`) | Memiliki dua mode:<br>- `mode=report`: Difilter mutlak berdasarkan kolom `Settlement.report_year`.<br>- `mode=actual`: Difilter berdasarkan tahun ekstrak dari `Expense.date`. Jika kosong, fallback ke `Settlement.created_at`. |
| **Type Filter** | `single` vs `batch`. |
| **Date Range** | `start_date` & `end_date` memfilter kolom `created_at` (bukan document date). |
| **Search Query** | Melakukan `ILIKE` ke `title`, `description`, dan `document_date`. |

### 2.2 List Action (Visibility)
*   **Draft/Revision/Rejected**: Dapat diedit, dihapus, atau disubmit.
*   **Submitted/Pending**: *Read-only* bagi Staff, menunggu *Approve* Manager.
*   **Approved/Completed**: Terminal state (Selesai).

---

## 3. Creation Flows (`POST /api/settlements`)

Terdapat dua jalur masuk (*entry points*) utama untuk membuat Settlement baru:

### 3.1 Flow A: Direct Settlement (Reimbursement)
*   **Trigger**: Karyawan menekan tombol "Buat Baru" secara manual dari halaman List Settlement.
*   **Kondisi**: Form kosong. Karyawan harus mengetik judul dan deskripsi dari nol.
*   **API Payload**: `advance_id` tidak dikirim (null).
*   **Hasil**: Dokumen Settlement baru berstatus `draft` tercipta.

### 3.2 Flow B: Kasbon Settlement (LPJ dari Advance)
*   **Trigger**: Karyawan menekan tombol **"Buat Settlement"** yang berada di dalam halaman Detail Advance.
*   **Syarat Gating (Frontend)**:
    Tombol ini **HANYA** muncul jika kondisi berikut terpenuhi secara simultan:
    1. Parent Advance status adalah `completed` atau `in_settlement`.
    2. `is_disbursement_approved` bernilai `true`.
    3. `settlement_id` pada Advance tersebut masih `null` (Satu Kasbon hanya boleh memiliki satu LPJ).
*   **API Payload**: Backend menerima `copy_from_advance_id = [id_kasbon]`.
*   **Hasil**:
    1. Dokumen Settlement baru berstatus `draft` tercipta.
    2. Backend **menyalin seluruh baris item secara otomatis** dari `AdvanceItem` menjadi baris `Expense` di dalam Settlement baru.
    3. Nilai `Expense.amount` diambil dari `AdvanceItem.estimated_amount`.
    4. Kategori disalin (*1-to-1 match*).
    5. Fungsi `_sync_advance_after_settlement()` dipanggil untuk mengikat LPJ ini ke Kasbon (mengisi `advance_id` bolak-balik).

---

## 4. Gating Impact dari Advance Deadlock (Critical Flow Break)

Pada modul Advance, telah terverifikasi bahwa dokumen yang memiliki sisa kembalian (Tabel 3 Required) akan terkena **Tabel 3 Deadlock** yang menyebabkan dokumen *stuck* di status `approved` selamanya.

**Efek domino pada Settlement**:
Karena form "Buat Settlement" mensyaratkan dokumen Kasbon harus berstatus `completed` untuk bisa diklik, maka setiap dokumen Kasbon yang terkena *deadlock* Tabel 3 **TIDAK AKAN PERNAH** bisa dibuatkan LPJ (Settlement)-nya. Tombol "Buat Settlement" tidak akan pernah muncul.

---

**Next**: Melanjutkan ke `02_detail_and_expense_table.md` untuk menganalisis isi Tabel 1 (Expenses) dan pembatasan nilai LPJ terhadap Kasbon.
