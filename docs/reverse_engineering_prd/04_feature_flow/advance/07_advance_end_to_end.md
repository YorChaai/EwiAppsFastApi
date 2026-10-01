# ADVANCE: END-TO-END MASTER FLOW

## 1. Feature Purpose

Modul **Advance (Kasbon)** berfungsi sebagai mekanisme peminjaman uang di awal oleh Karyawan (Staff) kepada Perusahaan sebelum aktivitas/pengeluaran riil terjadi. Sistem menggunakan konsep **Virtual Plafon (Hutang Karyawan)** untuk membatasi dan melacak uang yang dibawa oleh Karyawan.

Dokumen ini merupakan peta induk yang merangkum siklus hidup penuh dari dokumen Advance, mulai dari pembuatan hingga penyelesaian, berdasarkan verifikasi source code aplikasi.

---

## 2. ACTUAL END-TO-END IMPLEMENTATION FLOW

Berikut adalah alur eksekusi nyata (*Actual Implementation*) dari pengajuan Advance di sistem:

```text
Advance List
   ↓
Create Advance
   ↓
Single / Batch
   ↓
Advance Detail
   ↓
Tabel 1 — Item (Estimasi)
   ↓
Submit
   ↓
Manager Review
   ├── Reject All
   │     ↓
   │   Comment / Checklist
   │     ↓
   │   Revision / Draft State (Parent status = draft)
   │     ↓
   │   Staff Edit Document
   │     ↓
   │   Resolve Checklist
   │     ↓
   │   Submit Again
   │     └──────────── LOOP
   │
   └── Approve Item (Satu per satu)
         ↓
      Semua Item Approved
         ↓
      Tabel 2 Terbuka (Pencairan)
         ↓
      Manager Mengisi Disbursed Amount & Bank
         ↓
      Approve Disbursement (Tabel 2)
         ↓
      Parent Status = APPROVED
         ↓
      Return Required? (diff = disbursed - approved > 0)
       ├── NO
       │    ↓
       │  Final Approve (Complete Button)
       │    ↓
       │  COMPLETED
       │
       └── YES
            ↓
          Tabel 3 Visible
            ↓
          CRITICAL DEADLOCK
            ↓
          Return cannot be completed
            ↓
          Final Approve blocked
```

### 2.1 Intended Flow vs Actual Implemented Flow

Diagram di atas merepresentasikan **Intended Flow** (alur yang diharapkan) untuk proses Tabel 1 dan Tabel 2, namun **Actual Implemented Flow** (alur yang benar-benar terjadi di sistem) pada Tabel 3 berujung pada kebuntuan (*Deadlock*). Sistem mengharapkan Tabel 3 diisi, namun implementasi *gating* di frontend dan backend secara bersamaan mengunci formulir tersebut.

---

## 3. STATE MACHINE & TRANSITION GATES

Perjalanan status induk (Parent `advance.status`) dan pemicu pastinya:

| Dari Status | Ke Status | Pemicu (Exact Trigger) | Aktor | Catatan |
| :--- | :--- | :--- | :--- | :--- |
| `draft` / `revision` | `submitted` | Tombol **Submit** | Staff | Memanggil `submit_advance`. Item harus ada, checklist revisi komplit. |
| `submitted` | `draft` / `revision`| Tombol **Reject All** | Manager | Memanggil `reject_advance`. Parent status `rejected` tidak eksis secara persisten. Dokumen dikembalikan ke `draft` (atau `revision`). |
| `submitted` | `draft` | Tombol **Move to Draft** | Manager / Staff | Membuka kunci dokumen. Dilarang jika sudah terikat Settlement. |
| `submitted` | `approved` | **Approve Tabel 2** (`approve-disbursement`) | Manager | Terjadi **HANYA** jika seluruh item di Tabel 1 `approved`. Ini mengubah `is_disbursement_approved = True` dan status ke `approved`. |
| `approved` | `completed` | Tombol **Complete** (`final_approve`) | Manager | Terminal State. Ini adalah gerbang pemotongan saldo riil di ledger virtual plafon. |

*(Siklus Tabel 3 (Return) berjalan secara independen menggunakan field `return_status` dan `workflow_stage`, serta tidak mengubah status induk Advance).*

---

## 4. COMPONENT LIFECYCLE SUMMARY

Advance dipecah menjadi 3 tabel utama yang harus diselesaikan secara berurutan:

### 4.1 Tabel 1: Estimasi Pengeluaran (Items)
*   **Tujuan**: Staf mengajukan rincian uang yang dibutuhkan.
*   **Cara Kerja**: 
    1. Staf menginput kategori dan nilai estimasi.
    2. Manager mengevaluasi, memverifikasi kecukupan *Virtual Plafon*, dan menyetujui tiap item secara individual.
*   **Gate**: Seluruh item harus di-approve agar proses bisa lanjut ke Tabel 2.

### 4.2 Tabel 2: Pencairan (Disbursement)
*   **Tujuan**: Manager memberikan dana riil, yang bisa saja dibulatkan ke atas.
*   **Cara Kerja**:
    1. Manager mengisi nominal pasti yang ditransfer (`disbursed_amount`), memilih Bank Pusat (Source), dan mengunggah bukti transfer.
    2. Manager men-klik Approve Tabel 2.
*   **Gate**: Dokumen menjadi `approved`. Sistem menghitung apakah nominal yang dicairkan lebih besar dari estimasi Tabel 1. Jika ya, Tabel 3 wajib diisi.

### 4.3 Tabel 3: Pengembalian (Return)
*   **Tujuan**: Staf mengembalikan uang "kembalian" jika nominal cair > nominal disetujui.
*   **Cara Kerja**:
    1. Staf men-transfer balik uang sisa ke Main Bank, mengisi form Tabel 3, dan men-klik *Submit Return*.
    2. Manager memverifikasi bukti dan men-klik *Approve Return*.

---

## 5. FINANCIAL & LEDGER IMPACT (THE DIVIDE)

Kasbon berdampak ganda pada pembukuan:

1.  **Hutang Karyawan (Advance-based Calculation)**:
    Dihitung *on-the-fly* dari record database Advance (`Total Approved - Total Returned`). Berjalan dengan sangat akurat dan langsung ter-update otomatis ketika dokumen disetujui/direvisi/dihapus.
2.  **Ledger Mutasi (BankTransaction)**:
    Dihitung dari record mutasi bank riil. 
    *   `final_approve` membuat mutasi *Expense* di **Plafon Virtual**.
    *   `approve_return` membuat mutasi *Income* di **Main Bank**.

---

## 6. EDGE CASES, BUGS & ABNORMALITIES

Meskipun alur pengajuan dan pencairan berjalan cukup baik, eksekusi fungsionalitas memiliki kecacatan kritis pada siklus Return. Berikut adalah daftar jebakan (*trap*) dan inkonsistensi yang wajib diperhatikan:

### 6.1 [Dashboard approve_all trap] The "Setujui" Trap
*   **Masalah**: Tombol "Setujui" di Dashboard menggunakan endpoint *alternate* `approve_all`.
*   **Dampak**: Mengubah status induk menjadi `approved` secara sepihak, namun memaksa Tabel 2 menjadi *Belum Approved*. Karena statusnya sudah `approved`, UI Detail menyembunyikan tombol persetujuan Tabel 2. Manager akan **stuck** tidak bisa melakukan Final Approve dokumen ini.

### 6.2 [Ledger divergence] Plafon Debt Mismatch
*   **Masalah**: Pengembalian uang (Tabel 3) masuk ke mutasi Main Bank, tetapi tidak pernah memulihkan mutasi (Plafon) karyawan.
*   **Dampak**: Laporan saldo *Available Budget* karyawan (berdasarkan mutasi fisik) akan terkuras habis karena efek dari Tabel 2, meskipun karyawan sudah mengembalikan uangnya di Tabel 3.

### 6.3 [Orphaned BankTransaction] Deletion Bug
*   **Masalah**: Manager diizinkan melakukan Hard Delete dokumen Kasbon yang sudah berstatus `completed`.
*   **Dampak**: Hutang karyawan pulih seketika, namun baris transaksi bank (`BankTransaction`) yang tercipta saat `completed` tertinggal selamanya tanpa referensi (Orphaned). Merusak kesesuaian antara pembukuan log dengan kondisi hutang berjalan.

---

## 7. CONSISTENCY VALIDATION & CRITICAL DEADLOCK

Dari proses *Cross-Document Consistency Check*, ditemukan kontradiksi parah antara ekspektasi alur bisnis dengan pembatasan (*gating*) di level implementasi UI dan Backend untuk **Tabel 3 (Return)**.

### 7.1 [Tabel 3 Return deadlock] Fitur Return Lumpuh
*   **Contradiction Found**: Alur ideal mengisyaratkan Tabel 3 dikerjakan oleh Staff *setelah* Tabel 2 dicairkan.
*   **Backend Truth**:
    *   Tabel 2 (`approve-disbursement`) mengubah parent status menjadi `approved`.
    *   Fungsi penyimpanan Tabel 3 (`save_return`) memiliki hard-check: `if advance.status not in ("draft", "revision", "rejected"): return 400`.
*   **Frontend Truth**:
    *   Tabel 3 baru akan dirender (`visible`) jika parent status = `approved` ATAU `is_disbursement_approved = True`.
    *   Namun, *tombol Edit/Upload* Tabel 3 diikat pada flag `canEditReturn`, yang mensyaratkan status dokumen harus `isInDraft` (`draft`/`revision`).
*   **Impact (Verified Bug)**: **DEADLOCK MUTLAK**. Saat Tabel 2 selesai, Tabel 3 muncul tapi dalam keadaan terkunci (Read-Only). Staff tidak akan pernah bisa menekan tombol edit untuk mengunggah bukti Return, dan Backend akan menolak jika dipaksa. Karena form Return kosong, Manager tidak bisa melakukan *Final Approve* (Complete Button). Dokumen akan terjebak selamanya di status `approved` dengan stage `t3_pending`.

**Status Final**: ADVANCE END-TO-END VERIFIED (With Critical Flaws)

---

**END OF DOCUMENT**
