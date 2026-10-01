Tentu, Dio. Berdasarkan semua dokumen rencana yang ada, saya sudah menyusun **Master Implementation Plan** agar pengerjaannya sistematis dan tidak bentrok (minim error).

Saran saya, kita ikuti prinsip: **Fondasi (Database) ➔ Logika (Backend) ➔ Input (Frontend) ➔ Output (Laporan)**.

Berikut adalah urutan langkah (Step-by-Step) yang perlu kita kerjakan:

### Phase 1: Fondasi Database (Sangat Penting!)
Kita siapkan "wadah" datanya dulu sebelum menyentuh tampilan.
1.  **Modifikasi `backend/models.py`**: Tambahkan tabel `BankAccount` (untuk BCA/BRI/Cash), `Asset` (untuk Mobil/Laptop), dan `BankTransaction` (untuk mutasi).
2.  **Update Model existing**: Tambahkan kolom `bank_id` di tabel `Settlement` dan `Advance`.

### Phase 2: Logika Backend & API
Setelah wadahnya ada, kita buatkan "otak" pengolahannya.
1.  **API Master Data**: Buat cara untuk menambah/mengedit daftar Bank dan Aset.
2.  **Auto-Post Transaksi**: Buat logika agar saat Manager klik "Approved Final" di Settlement, sistem **otomatis** mencatat uang keluar di tabel Bank.
3.  **Kalkulasi Depresiasi**: Buat rumus agar nilai aset berkurang otomatis tiap bulan.

### Phase 3: Perombakan UI Frontend (Sisi Input)
Kita perbaiki cara user memasukkan data.
1.  **Rebranding**: Ganti semua tulisan "Revenue" jadi "Pemasukan".
2.  **Unifikasi Kasbon & Settlement**: Samakan tampilan Kasbon dengan Settlement agar tidak membingungkan.
3.  **Tabel Verifikasi Dana**: Tambahkan pilihan "Sumber Dana" (Bank) di bagian bawah layar detail.

### Phase 4: Reorganisasi UI Laporan (Sisi Output)
Terakhir, kita tampilkan semua data tadi ke dalam laporan yang rapi.
1.  **Triple Cascading Header**: Buat menu atas yang bersih (Input, Sheet, Kolom).
2.  **Tabel 6 & 7**: Munculkan tabel Bank Status dan Asset Register di dalam laporan tahunan.

---

**Saran langkah pertama hari ini:**
Mari kita kerjakan **Phase 1: Modifikasi `backend/models.py`**. Ini adalah kunci agar semua fitur lainnya bisa jalan. 

Apakah Anda setuju kita mulai dari update database (`models.py`) sekarang?


-----
---------------------------------------------------

Fokus frontend untuk **Phase 3-4** saat ini bisa dipetakan seperti ini.

**Phase 3: Input UI**
1. **Rebranding “Revenue” jadi “Pemasukan”**
   Saat ini label lama masih banyak muncul di [annual_report_screen.dart](</D:/Aplikasi/EWIApps/frontend/lib/screens/reports/annual_report_screen.dart:1111>) dan tombol input masih pakai `Revenue` di [annual_report_screen.dart](</D:/Aplikasi/EWIApps/frontend/lib/screens/reports/annual_report_screen.dart:1418>). Nama file/screen `revenue_management_screen.dart` juga masih mempertahankan istilah lama.

2. **Settlement detail perlu diubah ke model verifikasi dana baru**
   Sekarang summary card settlement di [settlement_detail_screen.dart](</D:/Aplikasi/EWIApps/frontend/lib/screens/settlement/settlement_detail_screen.dart:767>) masih menampilkan `Total`, `Approved`, `Expense`, plus kartu kasbon/selisih bila ada. Belum ada format final 4 kartu yang diminta plan: `Total`, `Approved`, `Reimbursement`, `Expense`.
   Tabel item atas juga masih punya kolom **`Sumber`** di [settlement_detail_screen.dart](</D:/Aplikasi/EWIApps/frontend/lib/screens/settlement/settlement_detail_screen.dart:1004>), padahal plan minta kolom ini dihapus dari tabel atas.

3. **Belum ada tabel pengiriman dana dinamis di bawah settlement**
   Dari screen settlement yang ada, belum terlihat section khusus “Belum semua item di-approve” lalu berubah menjadi tabel “Pengiriman Dana”. Logika approve final juga masih hanya cek **semua item approved** di [settlement_detail_screen.dart](</D:/Aplikasi/EWIApps/frontend/lib/screens/settlement/settlement_detail_screen.dart:3063>), belum cek apakah **bank/sumber dana sudah dipilih**.

4. **Advance/Kasbon belum mirror ke settlement**
   Advance detail di [advance_detail_screen.dart](</D:/Aplikasi/EWIApps/frontend/lib/screens/advance/advance_detail_screen.dart:1937>) masih punya pola lama: 3 summary card (`Total Pengajuan`, `Approved Amount`, `Total Item`) dan tabel item sendiri di [advance_detail_screen.dart](</D:/Aplikasi/EWIApps/frontend/lib/screens/advance/advance_detail_screen.dart:2040>). Belum ada “tabel pengiriman dana”, belum ada validasi sumber dana, dan UI-nya belum benar-benar jadi kembaran settlement.

5. **Widget bersama sudah ada, tapi belum ada widget header cascading global**
   Shared widget yang sudah ada baru [settlement_detail_widgets.dart](</D:/Aplikasi/EWIApps/frontend/lib/screens/widgets/settlement_detail_widgets.dart:1>) untuk `SummaryCard` dan tombol aksi. Belum ada `CascadingMenuCustom` seperti yang diminta dokumen.

**Phase 4: Output UI Laporan**
1. **Annual report masih model lama, belum triple cascading header**
   Di [annual_report_screen.dart](</D:/Aplikasi/EWIApps/frontend/lib/screens/reports/annual_report_screen.dart:1224>) header atas sekarang masih berisi `CascadingYearFilter` + icon action biasa, bukan 3 menu utama `Input / Sheet / Kolom`.

2. **Belum ada state `activeSheet` dan filter tabel per sheet**
   Dokumen minta `_activeSheet` dan `_visibleTables`, tapi di [annual_report_screen.dart](</D:/Aplikasi/EWIApps/frontend/lib/screens/reports/annual_report_screen.dart:1>) state itu belum ada. Saat ini `_buildDisplayTables()` langsung render Tabel 1-5 sekaligus di [annual_report_screen.dart](</D:/Aplikasi/EWIApps/frontend/lib/screens/reports/annual_report_screen.dart:1111>).

3. **Tabel 6 dan 7 belum tampil**
   Annual report sekarang baru render:
   - Tabel 1 Revenue & Tax
   - Tabel 2 Pajak
   - Tabel 3 Dividen
   - Tabel 4 Pengeluaran
   - Tabel 5 Neraca  
   Itu ada di [annual_report_screen.dart](</D:/Aplikasi/EWIApps/frontend/lib/screens/reports/annual_report_screen.dart:1111>). Belum ada UI **Bank Status (T6)** dan **Asset Register (T7)**.

4. **Bagian input report masih tombol biasa**
   `_buildInputButtons()` di [annual_report_screen.dart](</D:/Aplikasi/EWIApps/frontend/lib/screens/reports/annual_report_screen.dart:1392>) masih berupa 4 tombol datar: Revenue, Pajak, Dividen, Neraca. Ini nanti harus dipindah ke menu cascading `Input`, lalu ditambah item baru seperti aset, transfer bank, dan neraca/modal sesuai plan.

**Kesimpulan praktis**
Frontend yang paling kena Phase 3-4 adalah:
- [settlement_detail_screen.dart](</D:/Aplikasi/EWIApps/frontend/lib/screens/settlement/settlement_detail_screen.dart:767>)
- [advance_detail_screen.dart](</D:/Aplikasi/EWIApps/frontend/lib/screens/advance/advance_detail_screen.dart:1937>)
- [annual_report_screen.dart](</D:/Aplikasi/EWIApps/frontend/lib/screens/reports/annual_report_screen.dart:1111>)
- [settlement_detail_widgets.dart](</D:/Aplikasi/EWIApps/frontend/lib/screens/widgets/settlement_detail_widgets.dart:1>)

Kalau Anda mau, langkah berikutnya saya bisa buatkan **checklist frontend yang lebih detail per file dan urutan implementasi** dulu, jadi nanti jelas mana yang dikerjakan lebih dulu tanpa langsung ngoding.



Belum sepenuhnya sesuai. Kondisinya sekarang lebih tepat disebut **database: sebagian sesuai**, **backend: setengah jadi**, **frontend: sudah maju tapi belum sepenuhnya tersambung ke backend final**.

**Temuan Utama**
1. **Flow “Approved Final” belum nyambung end-to-end.**  
   Backend punya endpoint final approval yang benar-benar menulis `BankTransaction` di [backend/routes/settlements.py](/D:/Aplikasi/EWIApps/backend/routes/settlements.py:537), yaitu `/final_approve`, dan di situ `bank_id` wajib diisi lalu dibuat mutasi bank.  
   Tapi frontend masih memakai flow approve lama lewat `approveSettlement()` di [frontend/lib/services/api_service.dart](/D:/Aplikasi/EWIApps/frontend/lib/services/api_service.dart:462) dan provider [frontend/lib/providers/settlement_provider.dart](/D:/Aplikasi/EWIApps/frontend/lib/providers/settlement_provider.dart:306), yang memanggil `/settlements/{id}/approve`, bukan `/final_approve`.  
   Artinya: UI sekarang bisa meminta sumber dana, tapi transaksi bank belum otomatis benar-benar terjadi dari flow frontend utama.

2. **Frontend pakai “source per item”, backend final pakai `bank_id` di level settlement.**  
   Di frontend, tabel verifikasi dana yang saya pasang menyimpan pilihan bank ke field `source` expense/item di [frontend/lib/screens/settlement/settlement_detail_screen.dart](/D:/Aplikasi/EWIApps/frontend/lib/screens/settlement/settlement_detail_screen.dart:299) dan [frontend/lib/screens/advance/advance_detail_screen.dart](/D:/Aplikasi/EWIApps/frontend/lib/screens/advance/advance_detail_screen.dart:293).  
   Sementara backend final approval membaca `bank_id` di `Settlement` pada model [backend/models.py](/D:/Aplikasi/EWIApps/backend/models.py:421) dan endpoint [backend/routes/settlements.py](/D:/Aplikasi/EWIApps/backend/routes/settlements.py:537).  
   Jadi model datanya belum konsisten: satu sisi berbasis `source` string per item, sisi lain berbasis `bank_id` settlement-level.

3. **API master data Bank dan Asset belum terlihat tersedia.**  
   Model `BankAccount`, `BankTransaction`, dan `Asset` memang sudah ada di [backend/models.py](/D:/Aplikasi/EWIApps/backend/models.py:138), [backend/models.py](/D:/Aplikasi/EWIApps/backend/models.py:157), dan [backend/models.py](/D:/Aplikasi/EWIApps/backend/models.py:187).  
   Tapi dari pencarian route, saya tidak menemukan endpoint CRUD master bank/aset yang jelas. Yang terlihat hanya query `Asset` dan `BankTransaction` dipakai di laporan tahunan [backend/routes/reports/annual.py](/D:/Aplikasi/EWIApps/backend/routes/reports/annual.py:680).  
   Jadi Phase 1 model sudah ada, tapi Phase 2 “API Master Data” belum tampak selesai.

4. **Report frontend sudah menampilkan Tabel 6-7, tapi bergantung pada payload backend yang belum kaya.**  
   Frontend annual report sekarang sudah siap render `bank_status` dan `asset register` di [frontend/lib/screens/reports/annual_report_screen.dart](/D:/Aplikasi/EWIApps/frontend/lib/screens/reports/annual_report_screen.dart:1062).  
   Backend annual report memang sudah mengirim `assets` dan `bank_status` di [backend/routes/reports/annual.py](/D:/Aplikasi/EWIApps/backend/routes/reports/annual.py:703), tapi data bank yang dikirim masih murni dari `BankTransaction`. Kalau transaksi itu belum diisi konsisten dari approve flow, Tabel 6 akan tampil tapi datanya tidak terpercaya.

**Status per layer**
- **Database:** cukup dekat dengan plan. `BankAccount`, `BankTransaction`, `Asset`, `Settlement.bank_id`, `Advance.bank_id` sudah ada.
- **Backend:** belum konsisten dengan workflow plan. Ada `/approve`, `/complete`, `/final_approve`, `/override`, tapi frontend belum diarahkan ke jalur final yang benar. Master data bank/aset juga belum terlihat lengkap.
- **Frontend:** secara UI Phase 3-4 sudah mendekati plan. Rebranding, unifikasi settlement/kasbon, tabel verifikasi dana, triple cascading header, Tabel 6-7 sudah ada. Tapi wiring ke backend final masih belum rapi.

**Kesimpulan**
Kalau ditanya “sudah sesuai kah dari database-backend-frontend?” jawabannya: **belum 100%**.  
Yang paling bermasalah sekarang bukan tampilan, tapi **kontrak data dan alur approval final**. Frontend sudah bicara dalam bahasa “pilih sumber dana”, tapi backend final masih menunggu `bank_id` settlement-level dan hanya menulis bank transaction di endpoint khusus yang belum dipakai flow frontend utama.

Langkah berikut yang paling tepat:
1. Satukan keputusan model data: mau `bank_id` per settlement, per advance, atau per item approved.
2. Ubah frontend agar `Approved Final` memanggil endpoint final backend, bukan approve biasa.
3. Tambahkan endpoint master `BankAccount` dan `Asset`.
4. Baru setelah itu validasi ulang Tabel 6 dan 7.

Kalau Anda mau, saya bisa lanjut bikin **audit gap yang lebih teknis per file**: mana yang sudah sesuai, mana yang harus diubah di `models.py`, route Flask, `api_service.dart`, provider, dan screen supaya benar-benar sinkron end-to-end.