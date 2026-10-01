# Dokumen Implementasi & Task List: Integrasi Revenue dengan Bank Cash

**ID Rencana:** `RENCANA-1-REV-BANK-SYNC`  
**Referensi:** [rencana1.md](file:///D:/Aplikasi/EWIApps/docs/plans/rencana1.md)  
**Status:** Completed (100% Implemented & Verified)  
**Tanggal:** 2026-09-09  

---

## 1. Latar Belakang & Kebutuhan Bisnis

Di dalam aplikasi, data pemasukan dicatat pada modul **Revenue (Laporan Tahunan)**, sedangkan pengelolaan kas bank berada pada modul **Bank Management (Bank Cash)**. Sebelumnya, pencatatan Revenue berdiri sendiri tanpa relasi ke rekening kas bank tertentu.

Kebutuhan integrasi ini meliputi:
1. **Dropdown Sumber Dana**: Saat menambah atau mengedit data Revenue, user dapat menentukan rekening sumber dana (Bank Cash).
2. **Kondisi Sumber Dana `-` (Belum Teralokasi)**:
   - Jika sumber dana dipilih `-` (default), Revenue belum masuk ke Bank Cash mana pun.
   - Pada **Laporan Tahunan → Tabel 1: Pemasukan**, baris data Revenue tersebut **diberi highlight warna KUNING** sebagai penanda bahwa dana belum terhubung/teralokasi ke rekening kas bank.
   - Pada **Export Excel**, baris tersebut juga diwarnai **kuning muda** (`#FFF9C4`) secara konsisten.
3. **Kondisi Sumber Dana Dipilih (misal: BNI, BRI, Mandiri, BCA)**:
   - Data Revenue otomatis terhubung ke rekening Bank Cash yang dipilih (`bank_id`).
   - Sistem **secara otomatis membuat/memperbarui transaksi masuk (`income`) di `bank_transactions`**, sehingga **Saldo Riil Bank Cash tersebut otomatis bertambah** tanpa perlu input manual di Bank Management.
   - Pada **Laporan Tahunan**, penanda warna kuning **otomatis hilang (kembali normal)**.
4. **Kondisi Penghapusan / Perubahan Bank**:
   - Jika sumber dana diubah dari Bank A ke Bank B, mutasi di Bank A dipindahkan ke Bank B.
   - Jika sumber dana diubah ke `-` atau Revenue dihapus, mutasi penerimaan di bank otomatis dihapus dan saldo bank kembali ke kondisi semula.

---

## 2. Matriks Kondisi Sistem

| No | Pilihan Sumber Dana | Status Relasi (`bank_id`) | Efek pada Bank Cash (`bank_transactions`) | Tampilan di Laporan Tahunan (Tabel 1) | Tampilan di Excel Export |
|---|---|---|---|---|---|
| 1 | `-` (Belum Ada Bank) | `NULL` | Tidak ada mutasi bank / transaksi dihapus jika sebelumnya ada | **Highlight KUNING** | **Fill Kuning Muda (`#FFF9C4`)** |
| 2 | Rekening Bank (misal BNI) | ID Bank (`int`) | Dibuat transaksi tipe `income` otomatis; Saldo Riil Bank bertambah | **Normal** (warna standar tema) | **Normal** (tanpa fill) |
| 3 | Berubah dari BNI ke BRI | Berubah dari ID BNI ke ID BRI | Transaksi diupdate ke ID BRI; Saldo BNI berkurang, Saldo BRI bertambah | **Normal** | **Normal** |
| 4 | Berubah dari BNI ke `-` | Menjadi `NULL` | Transaksi di BNI dihapus; Saldo BNI kembali berkurang | **Highlight KUNING** | **Fill Kuning Muda (`#FFF9C4`)** |

---

## 3. Checklist Task & Progress Status

### Phase 1: Database & Model Architecture
- [x] **Task 1.1**: Tambah relasi `bank_id` (FK `bank_accounts.id`) dan relasi `bank` pada model `Revenue` di `backend/models/transaction.py`.
- [x] **Task 1.2**: Tambah relasi `revenue_id` (FK `revenues.id`, ON DELETE SET NULL) dan relasi `revenue` pada model `BankTransaction` di `backend/models/banking.py`.
- [x] **Task 1.3**: Tambah auto-migration / safety column check di `run_database_integrity_maintenance()` pada `backend/app.py` agar kolom `bank_id` dan `revenue_id` otomatis dibuat tanpa migrasi manual.
- [x] **Task 1.4**: Update DTO `revenue_to_dict()` di `backend/services/dto/transaction_dto.py` untuk mengembalikan `bank_id` dan `bank_name`.

### Phase 2: Backend Synchronization Engine
- [x] **Task 2.1**: Buat engine sinkronisasi `sync_revenue_bank_transaction(revenue, is_delete=False)` di `backend/routes/transactions/revenues.py`.
- [x] **Task 2.2**: Integrasikan sinkronisasi ke `create_revenue()` (POST `/api/revenues`).
- [x] **Task 2.3**: Integrasikan sinkronisasi ke `update_revenue(id)` (PUT `/api/revenues/<id>`).
- [x] **Task 2.4**: Integrasikan sinkronisasi ke `delete_revenue(id)` (DELETE `/api/revenues/<id>`).
- [x] **Task 2.5**: Pastikan payload API laporan tahunan (`_build_annual_payload_from_db`) meneruskan data `bank_id` dan `bank_name` ke frontend.

### Phase 3: Excel Report Generator
- [x] **Task 3.1**: Tambahkan styling `PatternFill(start_color="FFF9C4", end_color="FFF9C4", fill_type="solid")` pada baris Tabel 1 di `backend/services/reports/annual_service/excel_generator.py`.
- [x] **Task 3.2**: Terapkan fill kuning pada kolom A sampai Q jika `item.get("bank_id") is None`.

### Phase 4: Frontend Revenue Form (Input/Edit Sumber Dana)
- [x] **Task 4.1**: Inisialisasi provider `BankManagementProvider` dan siapkan state `selectedBankId` pada `revenue_management_screen_dialogs.dart`.
- [x] **Task 4.2**: Tambahkan widget dropdown "Sumber Dana (Bank Cash)" pada form Revenue dengan item default `-` (nilai `null`) dan daftar rekening bank aktif.
- [x] **Task 4.3**: Sertakan `'bank_id': selectedBankId` pada payload yang dikirim saat tombol Simpan ditekan.
- [x] **Task 4.4**: Panggil `context.read<BankManagementProvider>().loadBanks()` setelah simpan agar saldo bank di UI ter-update secara reaktif.

### Phase 5: Frontend UI Laporan Tahunan (Highlight Baris Kuning)
- [x] **Task 5.1**: Tambahkan properti `final Map<int, Color>? rowColors;` pada kelas `ReportTableData` di `annual_report_state.dart`.
- [x] **Task 5.2**: Update pemrosesan Tabel 1 (Pemasukan) di `widget_all_tables.dart` untuk mendeteksi `bank_id == null` dan mengisi `t1RowColors[rowIndex] = const Color(0xFFFFF9C4)` (atau kuning adaptif tema).
- [x] **Task 5.3**: Teruskan parameter `rowColors: t1.rowColors` melalui `widget_display_tables.dart` ke `buildTableCard()`.
- [x] **Task 5.4**: Modifikasi `widget_table_card.dart` untuk menggunakan `rowColors?[rIdx]` sebagai warna latar belakang baris jika tersedia.

### Phase 6: Automated Testing & Verifikasi
- [x] **Task 6.1**: Buat test otomatis `backend/tests/test_revenue_bank_sync.py`.
- [x] **Task 6.2**: Uji skenario create revenue dengan bank -> pastikan transaksi bank terbuat dan saldo bertambah.
- [x] **Task 6.3**: Uji skenario update revenue ubah bank ke `-` -> pastikan transaksi bank terhapus dan saldo bank berkurang.
- [x] **Task 6.4**: Uji skenario delete revenue -> pastikan transaksi bank terhapus.
- [x] **Task 6.5**: Jalankan `pytest` untuk seluruh modul dan pastikan semua test lulus 100% (12/12 passed).
- [x] **Task 6.6**: Jalankan `flutter analyze` (0 issues / no issues found) dan `flutter test` (all tests passed).%.

---

## 4. Rincian Teknis Implementasi File

### 4.1. Backend Database Model
- **File:** `backend/models/transaction.py`
  - Menambahkan relasi `bank_id` ke `bank_accounts.id`.
- **File:** `backend/models/banking.py`
  - Menambahkan relasi `revenue_id` ke `revenues.id`.
- **File:** `backend/app.py`
  - Melakukan `PRAGMA table_info` / `inspector.get_columns()` untuk menambahkan kolom `bank_id` dan `revenue_id` secara aman saat startup backend.

### 4.2. Backend Logic: Sinkronisasi Otomatis
- **File:** `backend/routes/transactions/revenues.py`
  ```python
  def sync_revenue_bank_transaction(revenue, is_delete=False):
      existing_bt = BankTransaction.query.filter_by(revenue_id=revenue.id).first()
      if is_delete or not revenue.bank_id:
          if existing_bt:
              db.session.delete(existing_bt)
          return

      amount_idr = revenue.idr_amount_received or revenue.idr_invoice_value or 0.0
      amount_usd = revenue.amount_received_usd or revenue.invoice_value_usd or 0.0
      tx_date = revenue.receive_date or revenue.invoice_date

      if existing_bt:
          existing_bt.bank_id = revenue.bank_id
          existing_bt.date = tx_date
          existing_bt.amount_idr = float(amount_idr)
          existing_bt.amount_usd = float(amount_usd)
      else:
          new_bt = BankTransaction(
              bank_id=revenue.bank_id,
              date=tx_date,
              description=f"Penerimaan Revenue: {revenue.description}",
              amount_idr=float(amount_idr),
              amount_usd=float(amount_usd),
              transaction_type="income",
              group_name="Revenue",
              report_year=revenue.report_year,
              company=revenue.company,
              revenue_id=revenue.id,
          )
          db.session.add(new_bt)
  ```

### 4.3. Excel Export Highlight
- **File:** `backend/services/reports/annual_service/excel_generator.py`
  - Pada baris data Revenue:
  ```python
  if r.get("bank_id") is None:
      yellow_fill = PatternFill(start_color="FFF9C4", end_color="FFF9C4", fill_type="solid")
      for c in range(2, 18):
          ws.cell(row=row_cursor, column=c).fill = yellow_fill
  ```

### 4.4. Frontend UI Components
- **File:** `frontend/lib/screens/management/revenue_management_screen_dialogs.dart`
  - Tambahkan dropdown pilihan bank pada dialog form Revenue.
- **File:** `frontend/lib/screens/reports/annual_report/annual_report_state.dart`
  - Tambahkan field `rowColors` pada `ReportTableData`.
- **File:** `frontend/lib/screens/reports/annual_report/widget_all_tables.dart`
  - Tentukan warna baris kuning untuk baris dengan `bank_id == null`.
- **File:** `frontend/lib/screens/reports/annual_report/widget_table_card.dart`
  - Terapkan warna baris pada container setiap baris data tabel.

---

## 5. Rencana Verifikasi & Pengujian

### A. Pengujian Otomatis (Automated Tests)
1. Jalankan `pytest tests/test_revenue_bank_sync.py -v`
2. Jalankan `pytest` untuk seluruh suite pengujian backend untuk memastikan tidak ada regresi pada tax offset, combine group, invoice grouping, atau modul lainnya.

### B. Pengujian Manual
1. **Skenario Input Baru Tanpa Bank**:
   - Buka menu **Management → Revenue**, klik Tambah.
   - Biarkan Sumber Dana bernilai `-`.
   - Simpan.
   - Buka **Laporan Tahunan → Tabel 1: Pemasukan**: Baris data tersebut harus berwarna **KUNING**.
   - Buka **Bank Management**: Pastikan tidak ada transaksi baru dan saldo bank tidak berubah.
2. **Skenario Update Alokasi Bank (BNI)**:
   - Edit data Revenue tadi, pilih Sumber Dana **BNI**.
   - Simpan.
   - Buka **Bank Management → Rekening BNI**: Saldo riil bertambah sesuai nominal dan terdapat transaksi bertipe `income`.
   - Buka **Laporan Tahunan → Tabel 1: Pemasukan**: Warna kuning pada baris data tersebut **hilang (normal)**.
3. **Skenario Pengosongan Bank Kembali ke `-`**:
   - Edit Revenue tadi, kembalikan Sumber Dana ke `-`.
   - Simpan.
   - Saldo BNI berkurang kembali ke semula.
   - Baris di Laporan Tahunan kembali berlatar kuning.
4. **Skenario Export Excel**:
   - Download file Excel Laporan Tahunan.
   - Pastikan baris data dengan sumber dana `-` berlatar kuning muda di sheet Excel.
