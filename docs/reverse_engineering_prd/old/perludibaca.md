Kalau maksudmu **prompt `promptReverseEngineer` + tambahan Role tadi nanti kamu kasih ke AI lain**, maka AI itu bukan langsung disuruh bikin PRD.

Kamu suruh dia melakukan **fase reverse engineering terlebih dahulu**.

Urutannya sebaiknya begini:

```text
SOURCE CODE / MD / FILE APLIKASI
            ↓
     REVERSE ENGINEERING
            ↓
   OUTPUT DOKUMENTASI FLOW
            ↓
       VALIDASI FLOW
            ↓
      BARU BUAT PRD
```

### Jadi prompt itu dipakai untuk apa?

Untuk membuat AI memahami:

> **"Bongkar dulu aplikasi ini sampai saya tahu aplikasi ini sebenarnya bekerja bagaimana."**

Bukan:

> "Tolong buat PRD."

Karena kalau langsung minta PRD, AI cenderung **mengarang atau menyederhanakan flow**.

---

# Output yang seharusnya keluar dari AI

Misalnya AI membaca file:

```text
advance_detail_screen.dart
advance_detail_tables.dart
advance_provider.dart
auth_provider.dart
```

Output yang kamu harapkan kira-kira:

```text
Viewed advance_detail_screen.dart:1-800
Viewed advance_detail_tables.dart:600-1000
Viewed advance_provider.dart:200-700
Viewed auth_provider.dart:1-200

## KASBON DETAIL

### Tabel 1 — Rincian Item

Purpose:
Tabel 1 digunakan untuk...

Role:
Staff → input/edit/submit
Manager → approve/reject

### Flow

DRAFT
 ↓
Tambah Item
 ↓
Isi Form
 ↓
Submit
 ↓
Pending Verification
 ↓
Manager Review
 ├── Approve
 │      ↓
 │   Item Approved
 │
 └── Reject
        ↓
     Comment
        ↓
      Draft
        ↓
     Edit Item
        ↓
   Resolve Comment
        ↓
      Submit
        ↓
   Verification Again

### Gate

Jika seluruh item belum Approved:
→ Tabel 2 masih terkunci.

Jika seluruh item Approved:
→ Tabel 2 dibuka.

### Tabel 2 — Pencairan Dana

...

### Role Impact

Staff:
...

Manager:
...

Super Manager:
...

### Unknown

- Belum diketahui apakah...
- Belum ditemukan...
```

Jadi outputnya adalah **"peta pemahaman aplikasi"**.

---

# Lalu setelah reverse engineering selesai

Baru kamu kasih hasil itu ke AI dan bilang:

> **"Sekarang berdasarkan hasil reverse engineering ini, buatkan Reconstructed PRD."**

Itu jauh lebih aman.

Jadi sebenarnya kamu punya **2 pekerjaan berbeda**.

### Tahap 1 — Reverse Engineer

Tujuannya:

**Memahami aplikasi.**

Output:

- module;
- halaman;
- user flow;
- button/action;
- role;
- permission;
- status;
- validation;
- rejection;
- correction;
- loop;
- gating;
- side effect;
- hubungan antarfeature;
- unknown;
- potential issue.

### Tahap 2 — Reconstructed PRD

Tujuannya:

**Mengubah hasil pemahaman tersebut menjadi dokumen requirement yang rapi.**

---

## Saya justru menyarankan jangan membuat AI langsung menghasilkan satu file PRD

Untuk aplikasi yang flow-nya rumit seperti yang kamu jelaskan, lebih bagus hasil reverse engineering disimpan seperti:

```text
01_application_map.md
02_role_permission.md
03_user_flow.md
04_feature_flow.md
05_business_rules.md
06_status_transition.md
07_open_questions.md
08_reconstructed_prd.md
```

Dan **`08_reconstructed_prd.md` baru dibuat setelah 1–7 selesai**.

Kalau nanti kamu memberikan prompt itu ke AI, instruksi utamanya harus berbunyi:

> **"Jangan membuat PRD dulu. Lakukan reverse engineering dan hasilkan dokumentasi behavior aplikasi secara detail. PRD dibuat pada tahap berikutnya."**

Itu yang membedakan AI yang benar-benar **memahami aplikasi** dengan AI yang sekadar **merangkum source code**.
