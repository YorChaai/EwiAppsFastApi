# Rencana Implementasi: Integrasi Data Revenue dengan Bank Cash (Bank Management)

Dokumen ini merupakan tindak lanjut dari ide dan konsep pada [rencana1.md](file:///D:/Aplikasi/EWIApps/docs/plans/rencana1.md).

---

## 1. Ringkasan Kebutuhan Bisnis

1. **Pilihan Sumber Dana pada Revenue**:
   - Menambahkan pilihan Sumber Dana (Bank Cash) pada form tambah/edit Revenue.
   - Opsi default adalah `-` (artinya Revenue belum dialokasikan / belum masuk ke bank mana pun).
   - Opsi lainnya adalah daftar rekening Bank Cash aktif (BRI, BNI, Mandiri, BCA, dll.).

2. **Sinkronisasi Otomatis ke Bank Cash**:
   - Jika user memilih salah satu Bank Cash (misal BNI):
     - Data Revenue otomatis terhubung ke Bank BNI.
     - Dibuatkan transaksi penerimaan (`income`) otomatis pada `bank_transactions` untuk rekening BNI tersebut sehingga **Saldo Riil Bank BNI otomatis bertambah**.
   - Jika user mengubah sumber dana ke bank lain:
     - Transaksi di bank sebelumnya dipindahkan/diperbarui ke bank baru.
   - Jika user memilih `-` atau menghapus Revenue:
     - Transaksi penerimaan di bank terkait otomatis dihapus, dan saldo bank kembali ke kondisi semula.

3. **Penanda Visual (Warna Kuning) di Laporan Tahunan**:
   - Pada Laporan Tahunan → **Tabel 1: Pemasukan**:
     - Jika sumber dana bernilai `-` (belum teralokasi / `bank_id == null`), **seluruh baris Revenue tersebut diberi highlight warna KUNING**.
     - Jika sumber dana telah dipilih (terhubung ke Bank Cash), warna kuning **hilang** (kembali normal).
   - Indikator ini juga diterapkan pada **hasil export Excel** (cell fill background kuning muda) agar konsisten antara aplikasi dan cetakan laporan.

---

## 2. Analisis Arsitektur Sistem Saat Ini

1. **Model `Revenue` (`backend/models/transaction.py`)**:
   - Menyimpan transaksi pendapatan (`invoice_date`, `description`, `amount_received_idr`, dll.), namun belum memiliki field `bank_id`.
2. **Model `BankAccount` & `BankTransaction` (`backend/models/banking.py`)**:
   - Rekening Bank Cash (`account_type != 'advance'`) menghitung saldo riil melalui query `sum(amount_idr)` dari `BankTransaction` bertipe `income`, `expense`, dan `transfer`.
3. **Penyusunan Payload Laporan Tahunan (`backend/services/reports/data_fetcher/payload_builder.py`)**:
   - Mengambil data Revenue dan memanggil `to_dict()` untuk dikirimkan ke frontend.
4. **Rendering Tabel Laporan Tahunan (`frontend/lib/screens/reports/annual_report/`)**:
   - `widget_all_tables.dart` memformat baris untuk Tabel 1 (Pemasukan).
   - `widget_table_card.dart` menggambar baris tabel dan mendukung penataan warna latar baris (`groupColor` / `rowColors`).
5. **Ekspor Excel Laporan Tahunan (`backend/services/reports/annual_service/excel_generator.py`)**:
   - Menulis setiap baris Tabel 1 Pemasukan ke workbook openpyxl.

---

## 3. Rencana Perubahan (Proposed Changes)

### A. Backend: Database & Models

#### [MODIFY] [backend/models/transaction.py](file:///D:/Aplikasi/EWIApps/backend/models/transaction.py)
- Tambahkan kolom pada class `Revenue`:
  ```python
  bank_id = db.Column(db.Integer, db.ForeignKey("bank_accounts.id"), nullable=True)
  bank = db.relationship("BankAccount", foreign_keys=[bank_id], backref="revenues")
  ```

#### [MODIFY] [backend/models/banking.py](file:///D:/Aplikasi/EWIApps/backend/models/banking.py)
- Tambahkan kolom referensi balik pada class `BankTransaction`:
  ```python
  revenue_id = db.Column(db.Integer, db.ForeignKey("revenues.id", ondelete="SET NULL"), nullable=True, index=True)
  revenue = db.relationship("Revenue", foreign_keys=[revenue_id])
  ```

#### [MODIFY] [backend/app.py](file:///D:/Aplikasi/EWIApps/backend/app.py)
- Di fungsi `run_database_integrity_maintenance(app)`:
  - Tambahkan migrasi otomatis (safe column check) menggunakan SQLAlchemy inspector:
    - Tambahkan kolom `bank_id` ke tabel `revenues` jika belum ada.
    - Tambahkan kolom `revenue_id` ke tabel `bank_transactions` jika belum ada.

#### [MODIFY] [backend/services/dto/transaction_dto.py](file:///D:/Aplikasi/EWIApps/backend/services/dto/transaction_dto.py)
- Di `revenue_to_dict(instance)`:
  - Sertakan `bank_id`: `instance.bank_id`
  - Sertakan `bank_name`: `instance.bank.name if instance.bank else None`

---

### B. Backend: Logika Sinkronisasi Bank Cash

#### [MODIFY] [backend/routes/transactions/revenues.py](file:///D:/Aplikasi/EWIApps/backend/routes/transactions/revenues.py)
- Buat fungsi helper sinkronisasi: `sync_revenue_bank_transaction(revenue)`:
  - **Kasus 1: `revenue.bank_id` terisi (misal BNI)**:
    - Cari `BankTransaction` dengan `revenue_id == revenue.id`.
    - Jika belum ada, buat baru:
      - `bank_id = revenue.bank_id`
      - `date = revenue.receive_date or revenue.invoice_date`
      - `description = f"Penerimaan Revenue: {revenue.description}"`
      - `amount_idr = revenue.idr_amount_received or revenue.idr_invoice_value`
      - `amount_usd = revenue.amount_received_usd or revenue.invoice_value_usd or 0.0`
      - `transaction_type = "income"`
      - `group_name = "Revenue"`
      - `report_year = revenue.report_year`
      - `company = revenue.company`
      - `revenue_id = revenue.id`
    - Jika sudah ada, perbarui `bank_id`, `amount_idr`, `amount_usd`, `date`, `description`, `report_year`.
  - **Kasus 2: `revenue.bank_id` adalah `None` atau `-`**:
    - Cari `BankTransaction` dengan `revenue_id == revenue.id`, jika ada maka hapus (`db.session.delete`).
- Panggil helper sinkronisasi ini pada:
  - `create_revenue()`: saat create baru.
  - `update_revenue(id)`: saat edit Revenue.
  - `delete_revenue(id)`: sebelum Revenue dihapus, hapus juga `BankTransaction` terkait.

---

### C. Backend: Excel Generator Highlight Kuning

#### [MODIFY] [backend/services/reports/annual_service/excel_generator.py](file:///D:/Aplikasi/EWIApps/backend/services/reports/annual_service/excel_generator.py)
- Pada bagian loop penulisan baris Revenue Tabel 1 (Pemasukan):
  - Cek jika `item.get("bank_id") is None`:
    - Berikan cell styling `fill = PatternFill(start_color="FFF9C4", end_color="FFF9C4", fill_type="solid")` (kuning muda) pada kolom A–Q baris tersebut sebagai indikator bahwa dana belum masuk ke bank mana pun.

---

### D. Frontend: Form Input/Edit Revenue

#### [MODIFY] [frontend/lib/screens/management/revenue_management_screen_dialogs.dart](file:///D:/Aplikasi/EWIApps/frontend/lib/screens/management/revenue_management_screen_dialogs.dart)
- Di dalam dialog `openRevenueForm`:
  - Ambil daftar Bank Cash dari `context.read<BankManagementProvider>().banks`.
  - Tambahkan state variabel `int? selectedBankId = data?['bank_id']`.
  - Tambahkan komponen dropdown **"Sumber Dana (Bank Cash)"**:
    - Opsi 1: `'-' (Belum Ada Sumber Dana)` dengan nilai `null`.
    - Opsi 2..N: Daftar Bank Cash (BCA, BNI, BRI, Mandiri, dll.).
  - Masukkan `'bank_id': selectedBankId` ke dalam payload saat simpan.

---

### E. Frontend: Laporan Tahunan (Tabel 1: Highlight Kuning)

#### [MODIFY] [frontend/lib/screens/reports/annual_report/annual_report_state.dart](file:///D:/Aplikasi/EWIApps/frontend/lib/screens/reports/annual_report/annual_report_state.dart)
- Tambahkan field `rowColors` pada `ReportTableData`:
  ```dart
  final Map<int, Color>? rowColors;
  ```

#### [MODIFY] [frontend/lib/screens/reports/annual_report/widget_all_tables.dart](file:///D:/Aplikasi/EWIApps/frontend/lib/screens/reports/annual_report/widget_all_tables.dart)
- Pada pemrosesan `t1` (Revenue):
  - Siapkan `final Map<int, Color> t1RowColors = {};`
  - Loop setiap item Revenue:
    - Jika `e.value['bank_id'] == null`:
      - Berikan warna kuning: `const Color(0xFFFFF59D)` (light mode) atau `const Color(0xFF4A4100)` (dark mode).
  - Masukkan `rowColors: t1RowColors` ke dalam `ReportTableData`.

#### [MODIFY] [frontend/lib/screens/reports/annual_report/widget_table_card.dart](file:///D:/Aplikasi/EWIApps/frontend/lib/screens/reports/annual_report/widget_table_card.dart)
- Teruskan `rowColors` dari `ReportTableData` ke `buildTableCard()`.
- Di setiap baris item cell container:
  - Jika ada `rowColors[rIdx]`, gunakan warna tersebut sebagai background baris.

---

## 4. Verification Plan

### Automated Tests
1. **Pytest Backend Tests**:
   - `tests/test_revenue_bank_sync.py`:
     - Test buat Revenue dengan `bank_id` -> pastikan `BankTransaction` bertipe `income` terbuat otomatis di bank terkait.
     - Test hitung saldo riil bank (`calculate_bank_real_balance`) -> pastikan saldo bertambah sesuai nominal.
     - Test update Revenue ubah `bank_id` ke `None` (`-`) -> pastikan `BankTransaction` terhapus dan saldo bank berkurang kembali.
     - Test payload `_build_annual_payload_from_db` -> pastikan `bank_id` dan `bank_name` disertakan di setiap record Revenue.
   - Jalankan `pytest -v` untuk memastikan semua test lulus.

### Manual Verification
1. **Buka menu Management → Revenue**:
   - Tambah Revenue baru dengan Sumber Dana `-`.
   - Buka **Laporan Tahunan → Tabel 1: Pemasukan**: Pastikan baris tersebut berlatar **kuning**.
   - Buka **Bank Management**: Pastikan saldo Bank Cash tidak berubah.
2. **Edit Revenue tersebut dan pilih Bank Cash BNI**:
   - Simpan.
   - Buka **Bank Management**: Pastikan Saldo Bank BNI bertambah dan muncul transaksi income terkait.
   - Buka **Laporan Tahunan → Tabel 1: Pemasukan**: Pastikan warna kuning pada baris tersebut **hilang (normal)**.
3. **Export Laporan Tahunan ke Excel**:
   - Pastikan baris dengan sumber dana `-` berlatar kuning muda di file Excel.
