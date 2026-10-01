# Dokumentasi Pengembalian Dana (Refund System)

Dokumen ini menjelaskan logika dan alur pengembalian dana dalam aplikasi EwiApps.

## Konsep Dasar
Pengembalian dana terjadi ketika total dana yang dikeluarkan (`approved_amount`) lebih kecil daripada dana yang dicairkan oleh perusahaan (`disbursed_amount`), atau sebaliknya ketika ada sisa dana dari Kasbon (Advance) yang harus dikembalikan ke perusahaan.

## Tinjauan Pengguna Diperlukan

> [!IMPORTANT]
> Kolom "Amount" pada tabel Pengiriman Dana sekarang akan menjadi bidang input (TextFormField) untuk Manager dan Finance. Ini memungkinkan penyesuaian nominal aktual yang ditransfer, yang mungkin berbeda dari total expense yang disetujui.

> [!NOTE]
> Saya akan menambahkan kolom "Kembalian" (Return Amount) ke layar Detail Settlement agar sesuai dengan fungsionalitas yang ada di layar Detail Kasbon.

## Perubahan yang Diusulkan

### Layar Detail Settlement (Settlement Detail)

#### [MODIFY] [settlement_detail_screen.dart](file:///D:/Aplikasi/EWIApps/frontend/lib/screens/settlement/settlement_detail_screen.dart)
- Inisialisasi `_disbursedAmountController` dengan total amount yang disetujui jika belum diatur.
- Perbarui `_buildFundTransferSection`:
    - Tambahkan kolom "Kembalian" ke `DataTable`.
    - Ubah cell "Amount" menggunakan `TextFormField` dengan `_disbursedAmountController`.
    - Tambahkan cell "Kembalian" dengan `TextFormField` menggunakan `_returnedAmountController`.
- Pastikan fungsi `_approveSettlement` menggunakan nilai dari controller ini.

### Layar Detail Kasbon (Advance Detail)

#### [MODIFY] [advance_detail_screen.dart](file:///D:/Aplikasi/EWIApps/frontend/lib/screens/advance/advance_detail_screen.dart)
- Verifikasi bahwa `_disbursedAmountController` dan `_returnedAmountController` sudah digunakan dengan benar (berdasarkan analisis saya, ini sudah sesuai).
- Melakukan sedikit perbaikan UI jika diperlukan untuk memastikan konsistensi dengan layar Settlement.

## Rencana Verifikasi

### Tes Otomatis
- Jalankan `flutter analyze` untuk memastikan tidak ada kesalahan linting atau sintaksis.

### Verifikasi Manual
1. Buka layar Detail Settlement.
2. Pastikan kolom "Amount" di "Tabel Pengiriman Dana" sekarang berupa bidang input.
3. Pastikan kolom "Kembalian" sekarang terlihat dan dapat diedit.
4. Ubah nominal Amount dan Kembalian.
5. Klik "Approved Final" dan pastikan dialog mencerminkan nilai yang dimasukkan di tabel.
6. Selesaikan persetujuan dan pastikan data tersimpan dengan benar.

## Alur Input
1. **Layar Detail (Settlement/Advance)**:
   - Manager atau Finance dapat memasukkan nominal aktual yang ditransfer.
   - Jika ada selisih, nominal tersebut dimasukkan ke kolom **Kembalian**.
   - User dapat memberikan deskripsi tambahan di kolom penjelasan untuk merinci kenapa terjadi selisih atau pengembalian tersebut.

2. **Validasi**:
   - Nominal kecil (di bawah Rp 100.000) tetap diperbolehkan selama mendapatkan persetujuan dari Manager.
   - Deskripsi wajib diisi jika ada pengembalian dana untuk transparansi audit.

## Pelaporan (Annual Report) taruh di table 3c
- Terdapat tabel khusus yang merangkum semua dana kembalian.
- Tabel ini menampilkan:
    - Nama Item / Settlement.
    - Total Biaya.
    - Total Dana Diterima.
    - **Dana Dikembalikan**.
- Disediakan tombol **Detail** untuk melihat rincian transaksi di layar aslinya.

## Penyimpanan Data
Data ini disimpan secara persisten di database pada tabel:
- `settlements.returned_amount`
- `advances.returned_amount`
- Serta catatan tambahan pada log aktivitas atau kolom notes terkait.
