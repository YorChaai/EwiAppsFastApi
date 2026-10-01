# Checklist Implementasi: Integrasi "Sumber Dana" Revenue ke Bank Cash

Dokumen ini berisi checklist task operasional implementasi pemetaan kolom **Sumber Dana** pada Revenue ke **Bank Cash**. Checklist ini telah dieksekusi, diuji, dan diverifikasi secara menyeluruh.

---

## Tahap 1: Refactoring Script Migrasi Excel (`generate_hybrid_migration_v14.py`)
- [x] **1.1 Buat fungsi helper / logika resolusi Sumber Dana**
  - Normalisasi string input (strip whitespace, abaikan string kosong, `"-"`, `"none"`, `"nan"`, `"null"`).
  - Prioritaskan compound bank spesifik terlebih dahulu:
    - `"Mandiri Valas"`
    - `"Mandiri Bisnis"`
    - `"Mandiri Giro"`
    - `"Mandiri TabBis"`
    - `"BCA Valas"`, `"BCA Bisnis"`, `"BCA Giro"`
    - `"BRI Valas"`, `"BRI Bisnis"`, `"BRI Giro"`
    - `"BNI Valas"`, `"BNI Bisnis"`, `"BNI Giro"`
  - Sediakan fallback generic jika tidak ada suffix: `"Mandiri"`, `"BCA"`, `"BRI"`, `"BNI"`, `"Cash"`.
  - Jika tidak cocok dengan bank manapun atau kosong, return `None`.
- [x] **1.2 Hapus fallback text-guessing**
  - Hapus logika lama di baris ~2707–2720 yang menebak bank dari teks `desc` dan `remark` saat kolom Sumber Dana kosong.
  - Pastikan jika kolom Sumber Dana kosong/`-`, nilai `bank_name` murni menjadi `None`.
- [x] **1.3 Perbaiki Subquery SQL Pencocokan Bank (`bank_sql_val`)**
  - Ganti query lama `(name ILIKE '%{b_name}%' OR name ILIKE '%{b_name[:3]}%')` yang tidak presisi.
  - Gunakan exact case-insensitive match:
    ```sql
    (SELECT id FROM public.bank_accounts 
     WHERE LOWER(TRIM(name)) = LOWER('{b_name}') 
       AND (company = {to_sql_val(target_company)} OR company IS NULL OR company = 'EWI Foundation') 
     ORDER BY (company = {to_sql_val(target_company)}) DESC, id ASC 
     LIMIT 1)
    ```
- [x] **1.4 Validasi Pembuatan Mutasi Kas (`bank_transactions`)**
  - Pastikan `INSERT INTO bank_transactions` HANYA dieksekusi jika `b_name` ada (valid).
  - Jika `b_name` adalah `None`: `bank_sql_val` diset `"NULL"` dan tidak ada `bank_transactions` yang di-insert (saldo semua bank tetap 0 perubahan).

---

## Tahap 2: Verifikasi Backend REST API & Sinkronisasi
- [x] **2.1 Verifikasi Serialisasi Model Revenue & DTO**
  - [`backend/services/dto/transaction_dto.py`](file:///D:/Aplikasi/EWIApps/backend/services/dto/transaction_dto.py) mengirimkan field `bank_id` dan `bank_name` pada endpoint `/api/revenues`.
- [x] **2.2 Verifikasi `sync_revenue_bank_transaction()`**
  - [`backend/routes/transactions/revenues.py`](file:///D:/Aplikasi/EWIApps/backend/routes/transactions/revenues.py) sinkronisasi `BankTransaction` tipe `income` berjalan reaktif saat create/update/delete. Jika bank diganti, saldo bank lama berkurang dan saldo bank baru bertambah. Jika `bank_id` di-set `None` (unallocated), mutasi dihapus.

---

## Tahap 3: Verifikasi Frontend UI (Flutter)
- [x] **3.1 Verifikasi Kolom Sumber Dana di Tabel Laporan Tahunan**
  - [`frontend/lib/screens/reports/annual_report/widget_all_tables.dart`](file:///D:/Aplikasi/EWIApps/frontend/lib/screens/reports/annual_report/widget_all_tables.dart) kolom Sumber Dana menampilkan nama bank yang sesuai, atau `"-"` dengan highlight jika unallocated (`bank_id == null`).
- [x] **3.2 Verifikasi Dropdown Sumber Dana di Dialog Tambah/Edit Revenue**
  - [`frontend/lib/screens/management/revenue_management_screen_dialogs.dart`](file:///D:/Aplikasi/EWIApps/frontend/lib/screens/management/revenue_management_screen_dialogs.dart) opsi `null` (label `"- (Belum Ada Sumber Dana / Teralokasi)"`) dan daftar seluruh bank fisik tersedia secara dinamis.

---

## Tahap 4: Eksekusi Generator Migrasi & Validasi Output SQL
- [x] **4.1 Eksekusi script migrasi v14 terhadap Excel versi 2**
  - Script sukses dijalankan dengan parameter Excel:
    `data/excel/20250427_EWI Financial-Repport_2024-2026 (version 2).xlsx`.
- [x] **4.2 Analisis dan verifikasi file `.sql` yang dihasilkan**
  - File SQL terverifikasi di: `data/backupdataapps/2026-09-21_17-26-24/migrasi_data_multiyear_hybrid_20260921_172624.sql`.
  - Item `INV 045` (Mandiri Valas) ➡️ tepat mengarah ke `Mandiri Valas` + `bank_transactions` income.
  - Item `INV 047` (BRI) ➡️ tepat mengarah ke `BRI` + `bank_transactions` income.
  - Item `INV 048` (BCA) ➡️ tepat mengarah ke `BCA` + `bank_transactions` income.
  - Item `INV 049` (kosong / `-`) ➡️ `bank_id = NULL` dan 0 insert ke `bank_transactions`.

---

## Tahap 5: Pengujian Otomatis & Regresi
- [x] **5.1 Jalankan Pytest Backend Unit Tests**
  - `backend/tests/test_revenue_bank_sync.py`: 5 passed (100%).
  - Seluruh test suite `backend/tests`: 17 passed (100%).
- [x] **5.2 Jalankan Playwright E2E Test Suite**
  - `tests/authenticated_e2e_suite.spec.js`: 25 passed (4.3s).
- [x] **5.3 Jalankan Flutter Analyze**
  - `flutter analyze` pada modul revenue & report table: No issues found!
- [x] **5.4 Verifikasi Akhir Saldo Bank Cash**
  - Saldo bank terisolasi per rekening (hanya bank yang dipilih yang bertambah, bank lain tidak terdampak sama sekali).
