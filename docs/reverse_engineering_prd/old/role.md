Ya. File MD tambahan ini **jangan dijadikan prompt baru terpisah**. Masukkan ke proses `promptReverseEngineer` sebagai **reference/evidence tentang Role & Permission**.

Namun ada masalah pada isi MD tersebut: beberapa bagian sudah berubah dari **fakta code** menjadi **asumsi**, terutama `mitra_eks`, dan kalimat tentang Super Manager. Dari `auth_provider.dart`, yang benar-benar terverifikasi adalah role `super_manager`, `manager`, `staff`, `mitra_eks`, serta bahwa `isManager` bernilai true untuk `manager` dan `super_manager`. Untuk `accessibleCompanies`, `super_manager` memang mendapat `_systemCompanies` sebagai fallback, tetapi deskripsi seperti “level tertinggi”, “Direktur”, atau “kekuatan penuh” belum otomatis terbukti hanya dari file tersebut.

Jadi saya akan menambahkan aturan khusus ke prompt-mu seperti ini:

# MODULE: ROLE & PERMISSION RECONSTRUCTION

Selain melakukan reverse engineering terhadap flow aplikasi, kamu juga harus melakukan reverse engineering terhadap **Role, Permission, dan Access Control**.

Role adalah bagian penting dari business flow karena action yang tersedia pada user dapat berbeda berdasarkan role.

Jangan hanya mencatat nama role.

Harus dicari:

- siapa role tersebut;
- halaman yang dapat diakses;
- fitur yang dapat digunakan;
- action yang dapat dilakukan;
- action yang tidak dapat dilakukan;
- data yang dapat dilihat;
- data yang dapat dibuat;
- data yang dapat diedit;
- data yang dapat dihapus;
- data yang dapat di-approve;
- data yang dapat di-reject;
- apakah role memiliki akses ke satu atau beberapa perusahaan;
- apakah role memengaruhi flow;
- apakah role memengaruhi status transition;
- apakah role memiliki permission khusus.

---

# 1. IDENTIFIKASI ROLE

Cari seluruh role yang muncul dari:

- source code;
- provider;
- authentication;
- permission logic;
- UI conditional;
- API;
- database;
- file `.md`.

Catat role menggunakan nama asli aplikasi.

Contoh:

```text
staff
manager
super_manager
mitra_eks
```

Jangan mengubah nama role tanpa alasan.

---

# 2. JANGAN MENEBak FUNGSI ROLE

Jangan langsung menyimpulkan:

> `staff` = karyawan biasa

atau:

> `super_manager` = direktur

hanya berdasarkan nama.

Cari evidence dari behavior aplikasi.

Contoh:

Jika ditemukan:

```dart
bool get isManager =>
    _user?['role'] == 'manager' ||
    _user?['role'] == 'super_manager';
```

maka yang dapat dipastikan adalah:

> `manager` dan `super_manager` diperlakukan oleh aplikasi sebagai bagian dari kategori Manager pada logic tersebut.

Jangan langsung menulis bahwa Super Manager adalah Direktur kecuali ada evidence lain.

---

# 3. ROLE MATRIX

Buat matrix seperti:

| Role | Menu | View | Create | Edit | Delete | Submit | Approve | Reject |
| ---- | ---- | ---- | ------ | ---- | ------ | ------ | ------- | ------ |

Isi berdasarkan evidence yang ditemukan.

Jika belum diketahui:

**Unknown**

Jangan mengisi berdasarkan asumsi.

---

# 4. ROLE → FEATURE FLOW

Role tidak hanya dijelaskan sebagai daftar permission.

Hubungkan role dengan flow.

Contoh:

```text
STAFF
 ↓
Create Kasbon
 ↓
Fill Item
 ↓
Submit
 ↓
Wait for Verification
```

Sedangkan:

```text
MANAGER
 ↓
Open Kasbon
 ↓
Review Item
 ↓
Approve / Reject
```

Jika flow berbeda untuk role lain, dokumentasikan juga.

---

# 5. ROLE → STATUS TRANSITION

Cari apakah role menentukan siapa yang dapat mengubah status.

Contoh:

```text
Staff
Draft
  ↓ Submit
Pending

Manager
Pending
  ├── Approve → Approved
  └── Reject → Rejected / Draft
```

Jika ditemukan role lain yang dapat melakukan action tersebut, tambahkan.

---

# 6. COMPANY ACCESS

Cari apakah role memengaruhi perusahaan yang dapat diakses.

Periksa:

- `company_access`;
- `activeCompany`;
- `systemCompanies`;
- permission;
- API company context;
- filtering data berdasarkan company;
- UI company selection.

Jangan hanya menulis:

> Super Manager dapat melihat semua perusahaan.

Verifikasi dulu bagaimana logic tersebut bekerja.

Contoh evidence dari `AuthProvider`:

- `accessibleCompanies` menggunakan `company_access` jika tersedia.
- Ada fallback ke `_systemCompanies`.
- Jika user merupakan `super_manager`, fallback memberikan seluruh `_systemCompanies`.
- `setActiveCompany()` hanya menerima company yang terdapat dalam `accessibleCompanies`.
- Setelah dipilih, company disimpan sebagai `activeCompany` dan diteruskan ke API melalui `setCompany()`.

Jika behavior tersebut ditemukan, jelaskan sebagai **Confirmed Behavior**.

---

# 7. ROLE DESCRIPTIONS

Untuk setiap role, gunakan format:

## Role: Staff

**Identifier:**
`staff`

**Confirmed Behavior:**

Tuliskan hanya behavior yang dapat dibuktikan.

**Accessible Features:**

Daftar berdasarkan source code/UI.

**Allowed Actions:**

Daftar action yang benar-benar dapat dilakukan.

**Restricted Actions:**

Daftar action yang secara eksplisit tidak tersedia atau ditolak.

**Company Access:**

Jelaskan jika ditemukan.

**Flow Impact:**

Jelaskan bagaimana role ini masuk ke flow yang berbeda.

**Evidence:**

Sebutkan file dan bagian yang menjadi sumber.

**Confidence:**

Confirmed / Inferred / Unknown.

---

# 8. BEDAKAN FACT, INFERENCE, DAN ASSUMPTION

Contoh:

### Confirmed

> Source code mendefinisikan empat role: `staff`, `manager`, `super_manager`, dan `mitra_eks`.

### Confirmed

> `isManager` menganggap `manager` dan `super_manager` sebagai Manager-level pada logic tersebut.

### Inferred

> Role `super_manager` kemungkinan memiliki akses yang lebih luas terhadap company dibanding role lain.

### Unknown

> Belum diketahui apakah `mitra_eks` benar-benar memiliki akses khusus untuk vendor/proyek karena evidence dari file yang dianalisis belum cukup.

Jangan mengubah Inferred menjadi Confirmed.

---

# 9. ROLE TERHADAP UI

Cari conditional UI.

Contoh:

```dart
if (auth.isManager)
```

Artinya UI atau menu tertentu hanya ditampilkan untuk user yang memenuhi kondisi `isManager`.

Dokumentasikan sebagai:

> Menu X hanya ditampilkan ketika user memenuhi kondisi `isManager`.

Jangan langsung mengubahnya menjadi:

> Hanya Manager yang boleh menggunakan X.

Karena `isManager` bisa mencakup lebih dari satu role.

---

# 10. ROLE TERHADAP ACTION

Cari conditional action.

Contoh:

```text
if (auth.isManager)
```

atau:

```text
if (role == 'staff')
```

atau permission API.

Dokumentasikan siapa yang:

- melihat tombol;
- dapat menekan tombol;
- dapat menjalankan action;
- menerima error jika tidak memiliki permission.

---

# 11. ROLE TERHADAP DATA

Cari apakah role memengaruhi:

- data yang ditampilkan;
- data yang dapat dibuat;
- data yang dapat diedit;
- data yang dapat dihapus;
- data yang dapat diapprove;
- data yang dapat direject.

Jangan mengasumsikan role hanya memengaruhi UI.

Permission bisa berada di backend/API.

---

# 12. ROLE FLOW SUMMARY

Di akhir bagian role, buat ringkasan seperti:

```text
STAFF
Create → Edit → Submit → Wait

MANAGER
Review → Approve / Reject

SUPER MANAGER
[documented behavior berdasarkan evidence]

MITRA_EKS
[documented behavior berdasarkan evidence]
```

Jika behavior belum lengkap, jangan isi dengan tebakan.

Gunakan:

```text
[NEEDS FURTHER REVERSE ENGINEERING]
```

---

# 13. INTEGRATION WITH MAIN FLOW

Role analysis harus digabung dengan reverse-engineered flow utama.

Jangan membuat:

```text
Section A = Roles
Section B = Flow
```

tanpa hubungan.

Harus dapat dijelaskan seperti:

```text
LOGIN
 ↓
Load User
 ↓
Determine Role
 ↓
Determine Company Access
 ↓
Determine Available Menu
 ↓
User enters feature
 ↓
Role determines available action
 ↓
Action changes status
 ↓
Next role continues process
```

Dengan demikian role menjadi bagian dari flow aplikasi, bukan sekadar daftar user type.

---

# 14. PERINTAH PENTING UNTUK AI

Setiap kali menemukan role, tanyakan:

> "Role ini sebenarnya memengaruhi apa?"

Trace sampai menemukan:

**Role → Permission → UI → Action → Status → Data → Next Step**

Jangan berhenti setelah menemukan deklarasi role di `AuthProvider`.

Deklarasi role saja belum cukup untuk memahami permission sebenarnya.
