# Log Progress: Sistem Tracking Approval & Deadline (Timeline)

Dokumen ini mencatat perubahan spesifik pada kode backend dan frontend untuk implementasi tracking proses yang detail.

## 1. Backend (Database & Model)
- **File**: `backend/models.py`
    - Menambahkan model `WorkflowLog` (tabel `workflow_logs`) untuk menyimpan histori setiap aksi approval.
    - Menambahkan kolom `current_stage` (String) dan `expected_completion_at` (DateTime) pada tabel `advances` dan `settlements`.
    - Memperbarui fungsi `to_dict()` pada Kasbon dan Settlement untuk mengirim data stage baru ke Frontend.
- **Migrasi**:
    - Membuat file migrasi baru `bb15b3243686_add_workflow_logs_and_stage_tracking.py`.
    - Berhasil sinkronisasi database dengan perintah `flask db upgrade`.
- **Integrasi**:
    - Modifikasi `backend/app.py`: Menonaktifkan `db.create_all()` agar tidak konflik dengan sistem migrasi Flask-Migrate.

## 2. Backend (Logika & Workflow)
- **File Baru**: `backend/utils/workflow_helper.py`
    - Fungsi `log_workflow`: Menghitung durasi antar tahap dan mencatat siapa yang melakukan aksi.
    - Fungsi `update_document_stage`: Memperbarui tahap aktif dokumen secara otomatis.
- **File Route Settlement**: `backend/routes/settlements.py`
    - Memasang tracker di: `submit`, `approve_t1` (Manager), `approve_t2` (Kirim Dana), `approve_t3` (Kembalian), `final_approve`, dan `reject`.
    - Menambahkan API Endpoint: `GET /api/settlements/<id>/history`.
- **File Route Advance**: `backend/routes/advances.py`
    - Memasang tracker di: `submit`, `approve_t1`, `approve_t2`, `approve_t3`, dan `final_approve`.
    - Menambahkan API Endpoint: `GET /api/advances/<id>/history`.
    - **Penting**: Menghapus blokade koding yang melarang Staff mengedit item saat statusnya `rejected` (Sekarang lebih fleksibel).
- **File Route Expense**: `backend/routes/expenses.py`
    - Menghapus pembatasan edit rincian biaya saat status Settlement `rejected`.

## 3. Backend (Notifikasi Deadline)
- **File**: `backend/utils/deadline_worker.py`
    - Refactoring total logika pengecekan deadline.
    - Sekarang sistem mengecek keterlambatan berdasarkan **Stage Aktif** (misal: "Terlambat di Table 1") bukan lagi hanya berdasarkan status global.

## 4. Frontend (Tahap Awal)
- **File**: `frontend/lib/services/api_service.dart`
    - Menambahkan fungsi `getSettlementHistory(id)` dan `getAdvanceHistory(id)` untuk mengambil data timeline dari server.
- **File**: `frontend/lib/providers/settlement_provider.dart`
    - Menambahkan state `_workflowHistory` untuk menampung data histori di aplikasi.
- **File**: `frontend/lib/providers/advance_provider.dart`
    - Menambahkan state dan loader `workflowHistory` untuk histori Kasbon.
- **File Baru**: `frontend/lib/widgets/workflow_timeline.dart`
    - Membuat widget reusable **WorkflowTimeline** untuk menampilkan stage aktif, target selesai, aktor, waktu aksi, transisi status, durasi antar tahap, dan komentar/reject reason.
- **File Detail Settlement & Kasbon**
    - Memasang widget timeline pada layar detail Settlement dan Kasbon.
    - Memastikan history ikut reload saat detail dokumen dimuat dan setelah aksi submit/approve/reject.
    - Mengubah timeline menjadi popup yang dibuka dari tombol **Timeline**, agar layar detail tetap ringkas.
- **File**: `frontend/analysis_options.yaml`
    - Mengecualikan folder `backup/**` dari analyzer agar `flutter analyze` tidak membaca arsip lama yang import path-nya sudah tidak valid.
- **File**: `backend/scratch/scanner_fokus/scripts/generate_hybrid_migration_v12.py`
    - Menyelaraskan output SQL dengan tabel `workflow_logs`, `current_stage`, dan `expected_completion_at`.
    - Memperbaiki matching evidence lama agar mencocokkan tanggal + activity/description + nominal, serta mengecek path file evidence di folder `data/receipts`.

---

## Rencana Selanjutnya (Next Steps)
1. Uji manual alur submit → approve → final approve pada satu Kasbon dan satu Settlement untuk memastikan timeline terisi sesuai data backend.
2. Rapikan warning/info lama Flutter secara bertahap jika ingin `flutter analyze` benar-benar bersih tanpa opsi `--no-fatal-infos --no-fatal-warnings`.
