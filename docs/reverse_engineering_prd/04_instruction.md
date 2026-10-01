# PHASE 4 — FEATURE FLOW REVERSE ENGINEERING

## Tujuan

Membongkar **behavior satu feature secara sangat detail dan mekanis** berdasarkan source code aktual.

Jangan hanya menjelaskan halaman.

Jangan hanya menjelaskan kode.

Jangan hanya membuat flow sederhana seperti:

```text
Create → Submit → Approve → Complete
```

Yang harus direkonstruksi adalah:

**User Flow + UI Flow + Role Flow + Validation + State Flow + Backend Flow + Database Effect + Loop + Gate + Side Effect + Dependency**

Tujuan akhirnya adalah membuat seseorang yang belum pernah melihat source code dapat memahami:

> "User mulai dari mana, melihat apa, menekan apa, mengisi apa, siapa yang memproses, status berubah bagaimana, kalau ditolak kembali ke mana, bagaimana memperbaikinya, kapan bisa submit lagi, kapan tahap berikutnya terbuka, dan bagaimana feature tersebut akhirnya selesai."

---

# 1. SCOPE

Mulai dari **Feature: Advance / Kasbon**.

Jangan berhenti di `AdvancesScreen`.

Telusuri seluruh feature sampai seluruh lifecycle dokumen dapat dipahami.

Minimal telusuri:

1. Advance List
2. Create Advance
3. Advance Type
4. Single vs Multiple
5. Advance Detail
6. Item Detail
7. Draft
8. Submit
9. Verification
10. Approve Item
11. Reject Item
12. Rejection Comment
13. Comment Checklist
14. Revision
15. Edit Item
16. Resolve Comment
17. Resubmit
18. Final Approval
19. Approval Gate
20. Disbursement
21. Return
22. Return Approval
23. Return Rejection
24. Return Checklist / Return Notes
25. Parent Advance Status
26. Advance Balance / Outstanding
27. Bank / Financial Side Effect
28. Notification
29. History / Timeline
30. Override jika tersedia
31. Settlement Dependency
32. Semua kondisi yang dapat menyebabkan flow kembali ke tahap sebelumnya

Jika terdapat Tabel 1, Tabel 2, Tabel 3, atau tabel tambahan:

**bedah masing-masing tabel secara terpisah.**

---

# 2. JANGAN HANYA TRACE SCREEN

Untuk setiap behavior penting, telusuri rantai:

```text
UI / Screen
    ↓
Widget / Dialog
    ↓
Provider
    ↓
Provider Extension / Helper
    ↓
API Service
    ↓
Backend Route
    ↓
Backend Service / Utility
    ↓
Database Operation
    ↓
Notification / Side Effect
    ↓
UI Refresh / Next State
```

Gunakan source code aktual untuk memastikan setiap langkah.

Dokumentasi `Panduan_Frontend_Lengkap.md` dan `Panduan_Backend_Lengkap.md` hanya digunakan sebagai:

**INDEX / NAVIGATION MAP**

Bukan sebagai bukti final behavior.

Jika panduan mengatakan function tertentu ada, buka source code aktual function tersebut sebelum menyimpulkan behavior.

---

# 3. FILE DISCOVERY SEBELUM ANALISIS

Sebelum membedah feature, buat daftar:

### Files Viewed

Contoh:

```text
Viewed:
- screens/advance/advances_screen.dart
- screens/advance/advance_detail_screen.dart
- screens/advance/advance_detail_tables.dart
- providers/advance_provider.dart
- providers/advance/advance_provider_workflow_ext.dart
- providers/advance/advance_provider_item_ext.dart
- providers/advance/advance_provider_finance_ext.dart
- services/api_service.dart
- backend/routes/advances_crud.py
- backend/routes/advances_items.py
- backend/routes/advances_approval.py
- backend/routes/advances_disbursement.py
- backend/routes/advances_other.py
- backend/routes/advances_utils.py
- backend routes / models / services terkait
```

Setiap kali membuka source code, tampilkan:

> `Viewed filename.dart:line-range`

atau:

> `Viewed filename.py:line-range`

Jangan hanya mengatakan:

> "Saya membaca Advance."

---

# 4. IDENTIFIKASI ENTRY POINT

Jelaskan dari mana user masuk ke feature.

Contoh:

```text
MainLayout
 ↓
Advance List
 ↓
Create Advance
```

Jika ada beberapa entry point, dokumentasikan semuanya.

Contoh:

```text
Advance List
├── Create New Advance
├── Open Existing Advance
├── Notification Deep Link
├── History
└── Standalone Return
```

---

# 5. STRUCTURE OF FEATURE

Sebelum flow detail, jelaskan struktur feature.

Contoh:

```text
ADVANCE
├── List
├── Create
├── Detail
│   ├── Table 1 — Items
│   ├── Table 2 — Disbursement
│   └── Table 3 — Return
├── Approval
├── Revision
├── Disbursement
├── Return
├── History
└── Override
```

Jangan membuat struktur berdasarkan dugaan.

Gunakan source code sebagai evidence.

---

# 6. STEP-BY-STEP FLOW

Untuk setiap proses gunakan format:

## Step N — [Nama Proses]

**Condition Before:**
Kondisi sistem sebelum action.

**Actor / Role:**
Siapa yang melakukan.

**Page / UI:**
Halaman atau dialog tempat action dilakukan.

**Visible Components:**
Button, form, table, checkbox, warning, modal, status label, dan component penting lainnya.

**User Action:**
Apa yang user lakukan.

**Validation:**
Apa yang harus terpenuhi sebelum action diterima.

**System Behavior:**
Apa yang dilakukan aplikasi.

**API / Backend Behavior:**
Endpoint yang dipanggil dan behavior backend jika dapat diverifikasi.

**Database / Data Effect:**
Data apa yang dibuat / diubah / dihapus.

**Status Before:**
Status sebelum action.

**Status After:**
Status setelah action.

**UI Result:**
Apa yang berubah di layar.

**Side Effects:**
Perubahan terhadap data/module lain.

**Next Step:**
Kemana proses berlanjut.

---

# 7. FORM FLOW

Jika ada form, jangan hanya mengatakan:

> "User mengisi form."

Bongkar field yang penting.

Contoh:

### Form Item

* Field
* Required / Optional
* Validation
* Default value
* Editable / Locked
* Dependency terhadap field lain
* Kondisi field muncul / hilang
* Effect terhadap calculated amount
* Evidence requirement

Jika terdapat Single / Multiple:

## Single

Jelaskan batasannya.

## Multiple

Jelaskan bagaimana item tambahan dibuat, diedit, dihapus, dan bagaimana semuanya dihitung dalam parent document.

---

# 8. SINGLE VS MULTIPLE

Jangan hanya menyebut bahwa keduanya berbeda.

Cari:

* Apa perbedaan UI?
* Berapa item yang diperbolehkan?
* Bagaimana item dibuat?
* Apakah item disimpan satu-satu atau sekaligus?
* Apakah approval dilakukan per item?
* Apakah rejection dapat terjadi hanya pada satu item?
* Apa yang terjadi pada parent jika salah satu item ditolak?
* Apakah Single dan Multiple mempunyai status flow berbeda?

---

# 9. STATUS STATE MACHINE

Buat status flow secara eksplisit.

Jangan menyederhanakan status yang berbeda.

Contoh:

```text
DRAFT
 ↓ Submit
SUBMITTED
 ↓ Review
 ├── APPROVED
 ├── REJECTED
 └── REVISION
```

Tetapi setelah itu harus dijelaskan **apa arti masing-masing status dalam implementation**.

Khususnya bedakan:

* Draft
* Submitted
* Rejected
* Revision
* Approved
* Disbursed
* Completed
* Returned
* Return Rejected
* Return Approved

Jangan mengasumsikan dua status adalah sinonim hanya karena UI terlihat mirip.

---

# 10. APPROVAL FLOW

Jika approval dilakukan per-item, dokumentasikan per-item.

Contoh:

```text
Item 1 → Approved
Item 2 → Rejected
Item 3 → Approved
```

Kemudian cari:

> Apa status parent document?

Jelaskan kapan parent dianggap fully approved.

Cari condition sebenarnya dari source code.

---

# 11. REJECTION FLOW

Jika ada Reject:

Jelaskan secara lengkap:

1. Siapa yang melakukan Reject.
2. Pada halaman apa.
3. Tombol apa.
4. Apakah dialog muncul.
5. Apakah komentar wajib.
6. Komentar disimpan di mana.
7. Siapa yang melihat komentar.
8. Status item berubah menjadi apa.
9. Status parent berubah atau tidak.
10. Apakah perlu Start Revision.
11. Kapan owner dapat mengedit.
12. Data apa yang boleh diedit.
13. Bagaimana komentar ditampilkan.
14. Bagaimana komentar dianggap selesai.
15. Apa yang terjadi jika masih ada komentar yang belum selesai.
16. Kapan Submit kembali tersedia.
17. Setelah Submit kembali, status menjadi apa.
18. Apakah approval dimulai dari awal atau hanya item tertentu.

---

# 12. REVISION FLOW

Jangan menyamakan:

**Rejected = Revision = Draft**

Telusuri apakah source code memang memperlakukan ketiganya berbeda.

Cari function seperti:

* `start_revision`
* `move_to_draft`
* `_editable_revision_no`
* `_items_for_revision`
* `_next_revision_no`
* status helper lainnya.

Jika revision mempunyai nomor atau history:

jelaskan:

```text
Revision 1
 ↓
Correction
 ↓
Revision 2
 ↓
Correction
```

Jika tidak ada revision number, jangan mengarang.

---

# 13. COMMENT / CHECKLIST FLOW

Jika terdapat rejection checklist, dokumentasikan:

```text
Reject
 ↓
Comment Created
 ↓
Owner Opens Comment
 ↓
Read Comment
 ↓
Edit Data
 ↓
Resolve / Check Comment
 ↓
Is Every Comment Resolved?
 ├── NO → Remain in Correction
 └── YES → Submit
```

Jelaskan apakah checklist:

* per item;
* per document;
* per rejection;
* atau gabungan beberapa komentar.

Cari logic seperti:

* `_parse_checklist_notes`
* `_has_unchecked_checklist`
* `_merge_rejection_notes`
* function checklist terkait.

---

# 14. GATING / LOCKING

Untuk setiap tahap yang dikunci, cari condition exact-nya.

Jangan menulis:

> "Tabel 2 terbuka setelah approval."

Cari kondisi sebenarnya.

Contoh:

```text
Table 1
 ↓
check approval condition
 ↓
ALL ITEMS APPROVED?
 ├── NO → Table 2 LOCKED
 └── YES → Table 2 UNLOCKED
```

Jelaskan juga:

* apa yang terlihat jika locked;
* apakah user dapat membuka / edit;
* pesan warning;
* kondisi yang menghilangkan warning.

---

# 15. DISBURSEMENT / FINANCE FLOW

Jika ada pencairan, jangan berhenti di:

> "Manager menekan Approve."

Telusuri:

```text
Disbursement Form
 ↓
Fund Source
 ↓
Date
 ↓
Amount
 ↓
Admin Fee
 ↓
Evidence
 ↓
Save
 ↓
Approve
 ↓
Financial Effect
```

Cari:

* bank/source account;
* amount;
* admin fee;
* evidence;
* transaction;
* bank balance;
* expense;
* cash;
* outstanding balance;
* notification;
* parent status.

Jika ada approval pencairan terpisah dari save pencairan, dokumentasikan kedua tahap.

---

# 16. RETURN FLOW

Jika ada Return / pengembalian dana, wajib dibongkar sebagai flow terpisah.

Minimal:

```text
Disbursed
 ↓
Return
 ↓
Save Return
 ↓
Submit Return
 ↓
Approve / Reject
 ↓
Return Checklist / Notes
 ↓
Final Return Approval
 ↓
Update Balance
 ↓
Update Parent Status
```

Jangan menganggap Return hanya bagian kecil dari Disbursement.

Backend menyediakan operasi khusus seperti:

* `save_return`
* `submit_return`
* `approve_return`
* `reject_return`
* `update_return_notes`

Jika fungsi tersebut ada, telusuri behavior masing-masing.

---

# 17. BALANCE / OUTSTANDING

Cari apakah feature berkaitan dengan:

* outstanding advance;
* active balance;
* returned amount;
* remaining debt;
* settlement amount.

Jelaskan:

```text
Before
 ↓
Transaction
 ↓
Balance Calculation
 ↓
After
```

Jangan hanya mengatakan:

> "Saldo berubah."

Jelaskan **saldo apa**, **kapan berubah**, dan **trigger-nya apa**.

---

# 18. BANK / FINANCIAL SIDE EFFECT

Cari semua side effect terhadap:

* bank;
* cash;
* expenses;
* advance balance;
* settlement;
* logbook;
* reports.

Jangan menyimpulkan bahwa disbursement selalu memengaruhi bank.

Buktikan dari backend/source code.

---

# 19. NOTIFICATION

Cari dua hal yang berbeda:

### Notification Consumption

User mengambil / membaca notification.

### Notification Creation

Action tertentu benar-benar membuat notification baru.

Jangan menyamakan:

> `NotificationProvider.startPolling()`

dengan:

> `Approve` membuat notification.

Jika belum menemukan creator/trigger, tulis Unknown / Needs Verification.

---

# 20. HISTORY / TIMELINE

Jika feature mempunyai:

* history;
* audit log;
* workflow timeline;
* revision history;

dokumentasikan perubahan status dan actor.

Contoh:

```text
Draft
 ↓
Submitted by Staff
 ↓
Rejected by Manager
 ↓
Revision 1
 ↓
Resubmitted by Staff
 ↓
Approved by Manager
```

---

# 21. OVERRIDE / EXCEPTION FLOW

Jika terdapat function seperti:

* `override_advance`
* `move_advance_to_draft`
* `override_settlement`
* `move_to_draft`

jangan mengabaikannya.

Dokumentasikan:

* siapa yang dapat menggunakannya;
* kapan;
* mengapa;
* status sebelum;
* status sesudah;
* apakah bypass workflow normal;
* audit log yang dibuat;
* risiko / impact.

---

# 22. HISTORY VS CURRENT STATE

Bedakan:

**Current State**

Apa kondisi dokumen sekarang.

**History**

Apa yang pernah terjadi pada dokumen.

Jangan menggunakan history sebagai bukti bahwa state tersebut masih aktif.

---

# 23. CROSS-FEATURE DEPENDENCY

Setelah feature selesai dibedah, cari hubungan ke feature lain.

Contoh:

```text
Advance
 ↓
Disbursement
 ↓
Outstanding Balance
 ↓
Settlement
```

Tetapi jangan langsung menyebut dependency sebagai wajib.

Gunakan:

* Confirmed Dependency
* Conditional Dependency
* Inferred Dependency
* Unknown Dependency

---

# 23A. PARENT ↔ CHILD STATE SYNCHRONIZATION

Jika feature memiliki hubungan **parent-child**, telusuri hubungan state antara parent dan child.

Contoh:

```text
Parent Document
├── Item 1
├── Item 2
└── Item 3
```

Cari:

* Bagaimana status child berubah.
* Bagaimana status parent dihitung.
* Apakah satu child `rejected` memengaruhi parent.
* Apakah satu child `approved` langsung mengubah parent.
* Kondisi apa yang membuat seluruh child dianggap `approved`.
* Apakah parent memiliki status sendiri yang berbeda dari child.
* Apakah perubahan parent mengubah child.
* Apakah perubahan child membuka atau menutup feature lain.

Dokumentasikan secara eksplisit:

```text
Child State
    ↓
Parent State
    ↓
Gate / Next Step
```

Jangan mengasumsikan hubungan parent-child hanya berdasarkan nama variable atau model. Verifikasi melalui source code.

---

# 23B. NEGATIVE / BLOCKED FLOW

Untuk setiap action penting, cari juga kondisi ketika action:

* gagal;
* ditolak;
* tidak tersedia;
* atau tidak dapat dilanjutkan.

Minimal cari:

* Validation failure
* Permission denied
* Invalid status
* Missing required data
* Missing evidence
* Unresolved comment
* Incomplete items
* Invalid company access
* Backend error
* Network/API failure

Gunakan format:

```text
Action
↓
Condition Failed
↓
System Response
↓
UI Response
↓
Current State
↓
What User Must Do Next
```

Jangan hanya mendokumentasikan happy path.

---

# 23C. RE-ENTRY POINTS

Identifikasi seluruh cara user dapat masuk kembali ke feature.

Minimal cari:

* Main navigation
* Existing document
* Notification
* Deep link / notification path
* History
* Related feature
* Edit
* Revision
* Return
* Override

Untuk setiap entry point, jelaskan:

1. Dari mana user masuk.
2. Halaman yang dibuka.
3. Dokumen/state yang dibawa.
4. Apakah user masuk ke state yang sama atau berbeda.
5. Action apa yang tersedia setelah masuk kembali.

Contoh:

```text
Notification
↓
Open Advance Detail
↓
Existing Submitted Document
↓
Manager Review
```

Jangan menganggap semua entry point memiliki behavior yang sama.

---

# 23D. TERMINAL STATE / DEFINITION OF DONE

Cari kondisi yang benar-benar membuat lifecycle feature selesai.

Jangan mengasumsikan:

```text
Disbursed = Completed
```

Telusuri source code untuk menentukan:

* Final status
* Final approval
* Remaining balance
* Return requirement
* Settlement requirement
* Pending child item
* Outstanding debt
* Required financial reconciliation
* Final history / audit state

Dokumentasikan:

```text
START
 ↓
...
 ↓
TERMINAL STATE
```

Jelaskan secara eksplisit **condition apa yang membuat sistem menganggap lifecycle feature benar-benar selesai**.

Jika belum dapat ditentukan:

> `Unknown — terminal state belum dapat diverifikasi dari source code yang dianalisis.`

---

# 24. END-TO-END LOOP

Setelah seluruh mekanisme dibedah, buat satu diagram penuh.

Contoh:

```text
Advance List
 ↓
Create
 ↓
Single / Multiple
 ↓
Item Detail
 ↓
Draft
 ↓
Submit
 ↓
Manager Review
 ├── Approve Item
 │
 └── Reject Item
       ↓
    Comment
       ↓
    Revision
       ↓
    Edit
       ↓
    Resolve Comment
       ↓
    Submit Again
       ↓
    Manager Review
          ↑
          └──── LOOP
 ↓
All Items Approved
 ↓
Disbursement Gate
 ↓
Save Disbursement
 ↓
Approve Disbursement
 ↓
Disbursed
 ↓
Return / Settlement Dependency
```

Diagram harus mengikuti behavior yang benar-benar ditemukan.

---

# 25. OUTPUT FORMAT

Gunakan gaya:

> `Viewed filename.dart:line-range`

Kemudian:

# [FEATURE NAME]

## 1. Feature Purpose

## 2. Entry Point

## 3. Components / Tables

## 4. Step-by-Step Flow

### Step 1 — ...

**Condition Before:**
...

**Actor / Role:**
...

**Page / UI:**
...

**User Action:**
...

**Validation:**
...

**System Behavior:**
...

**API / Backend Behavior:**
...

**Database / Data Effect:**
...

**Status Before:**
...

**Status After:**
...

**UI Result:**
...

**Side Effects:**
...

**Next Step:**
...

Lanjutkan hingga seluruh flow selesai.

---

# 26. FINAL SUMMARY

Di akhir setiap feature document wajib ada:

## End-to-End Flow

## Status Flow

## Role Flow

## Rejection / Correction Loop

## Revision Flow

## Gates / Locks

## Disbursement Flow

## Return Flow

## Balance / Financial Effect

## Notification Flow

## History / Timeline

## Cross-Feature Dependency

## Evidence

Daftar file dan line range utama yang digunakan.

## Confirmed

Behavior yang dibuktikan langsung.

## Inferred

Kesimpulan yang masih berdasarkan evidence tidak langsung.

## Unknown

Informasi yang belum dapat dipastikan.

## Potential Issue

Behavior yang terlihat mencurigakan, tidak konsisten, atau kemungkinan bug.

---

# 27. ATURAN EVIDENCE

Jangan menyimpulkan business meaning hanya dari nama function, variable, atau file.

Contoh:

`saveDisbursement()` tidak otomatis berarti uang benar-benar keluar.

Telusuri apa yang terjadi setelah function tersebut dipanggil.

Gunakan:

**UI → Provider → API → Backend → Database → Side Effect**

Jika hanya sampai UI yang diketahui:

> UI Behavior Confirmed; Backend Effect Unknown.

Jika backend sudah ditemukan tetapi database effect belum:

> Backend Behavior Confirmed; Database Effect Not Yet Verified.

---

# 28. ATURAN DETAIL

Jangan terlalu singkat.

Jangan merangkum beberapa action berbeda menjadi satu langkah jika behavior-nya berbeda.

Contoh jangan menulis:

> "Manager melakukan approval."

Jika sebenarnya:

```text
Manager membuka detail
 ↓
Approve Item
 ↓
Item status berubah
 ↓
Periksa apakah semua item approved
 ↓
Final Approve
 ↓
Disbursement dibuka
```

maka semua tahap tersebut harus didokumentasikan.

---

# 29. ATURAN LOOP

Setiap loop harus menjawab:

1. Loop dimulai dari mana?
2. Apa condition yang menyebabkan kembali?
3. Kembali ke status apa?
4. Kembali ke halaman apa?
5. Apa yang harus diperbaiki?
6. Siapa yang memperbaiki?
7. Apa syarat untuk keluar dari loop?
8. Setelah keluar, lanjut ke mana?

---

# 30. ATURAN KETIDAKPASTIAN

Jika behavior tidak ditemukan:

**Jangan mengarang.**

Gunakan:

> **Unknown — belum ditemukan evidence yang cukup.**

Jika dokumentasi mengatakan A tetapi source code menunjukkan B:

> **Documentation vs Implementation Mismatch**

Jika implementation terlihat salah:

> **Potential Issue**

Jangan memperbaiki atau menyimpulkan bug hanya dari asumsi.

---

# 31. URUTAN ANALISIS

Untuk setiap feature gunakan urutan:

```text
1. Identify Entry Point
2. Identify Screens / Tables
3. Identify Actors
4. Identify Available Actions
5. Identify Normal Flow
6. Identify Negative / Blocked Flow
7. Trace UI Action
8. Trace Provider
9. Trace Provider Extensions / Helpers
10. Trace API
11. Trace Backend Route
12. Trace Backend Service / Utility
13. Trace Database Effect
14. Trace Parent-Child Synchronization
15. Trace Side Effects
16. Trace Status Transition
17. Trace Rejection
18. Trace Revision
19. Trace Return
20. Trace Override
21. Trace Loops
22. Trace Gates
23. Trace Re-entry Points
24. Trace Cross-Feature Dependency
25. Identify Terminal State
26. Validate Against Other Modules
27. Validate Documentation vs Implementation
28. Write Final Flow
```

### Aturan tambahan untuk urutan analisis

Jangan membuat kesimpulan final mengenai suatu behavior sebelum tracing pada langkah-langkah yang relevan selesai.

Jika suatu langkah tidak berlaku untuk feature tertentu, tandai:

> `Not Applicable`

Jangan dilewati tanpa alasan.

Jika evidence berhenti di layer tertentu, jelaskan batasnya.

Contoh:

> UI behavior confirmed, backend effect not yet verified.

atau:

> Backend behavior confirmed, database effect not yet verified.

Jangan mengisi layer yang belum ditemukan dengan asumsi.

---

# 32. PRIORITAS

Jika harus memilih antara membuat dokumentasi lebih pendek atau lebih akurat:

**Accuracy > Completeness > Brevity**

Namun detail harus tetap relevan.

Jangan memasukkan implementasi teknis yang tidak memiliki dampak terhadap behavior user/business.

---

# 33. HASIL YANG DIHARAPKAN

Output akhir harus terasa seperti seseorang sedang menjelaskan aplikasi kepada client dan developer secara bersamaan:

> **"Begini cara feature ini bekerja dari awal sampai selesai."**

Pembaca harus dapat memahami:

* apa yang ada;
* siapa yang menggunakan;
* mulai dari mana;
* apa yang harus diisi;
* tombol apa yang digunakan;
* apa yang terjadi setelah tombol ditekan;
* siapa yang memproses berikutnya;
* bagaimana approval bekerja;
* bagaimana rejection bekerja;
* bagaimana correction bekerja;
* bagaimana revision bekerja;
* kapan loop berhenti;
* kapan gate terbuka;
* bagaimana disbursement bekerja;
* bagaimana return bekerja;
* bagaimana saldo berubah;
* bagaimana feature terhubung ke feature lain;
* dan kapan proses benar-benar selesai.

---

# 34. OUTPUT REQUIREMENT

Setelah update ini diterapkan, gunakan aturan tersebut pada seluruh reverse engineering Phase 4.

Tujuan akhirnya tetap:

> **Memahami seluruh lifecycle feature secara nyata dari entry point sampai terminal state, termasuk normal flow, blocked flow, rejection, revision, loop, gate, parent-child synchronization, side effect, re-entry point, dan cross-feature dependency.**

Jangan membuat PRD pada Phase 4.

Phase 4 hanya menghasilkan **detailed feature behavior documentation**.
