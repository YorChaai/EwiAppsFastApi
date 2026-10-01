# Skenario Uji Coba: Bank Cash, Bank Advance, Kasbon & Settlement

Gunakan daftar ini untuk menguji secara sistematis (mencentang kotak) flow Kasbon, Settlement, dan Bank Management Anda. Pastikan untuk mengecek baik di **UI Aplikasi (Frontend)** maupun di **Database (TablePlus)**.

## 1. Persiapan Saldo (Alokasi Bank Cash ke Bank Advance)

- [ ] **UI:** Buka halaman Bank Management. Periksa saldo awal Bank Utama (misal: BRI) dan Bank Advance (misal: Bank Advance Manager 1).
- [ ] **UI:** Lakukan **Transfer/Pemindahbukuan** (alokasi dana) dari Bank BRI ke Bank Advance Manager 1 (misal: Rp3.000.000).
- [ ] **Database (`bank_transactions`):** Cek apakah mutasi transfer tercatat dengan deskripsi yang rapi dan logis (tidak ada teks aneh yang terlalu panjang).
- [ ] **UI:** Pastikan saldo Bank BRI berkurang Rp3.000.000 dan saldo Bank Advance Manager 1 bertambah Rp3.000.000.

---

## 2. Pengajuan Kasbon (Advance) Pertama

- [ ] **UI:** Login sebagai _Manager 1_ (atau user tester) dan ajukan **Kasbon** sebesar **Rp1.000.000**.
- [ ] **UI:** Lakukan proses persetujuan (Approval) hingga dana dicairkan (Disbursement) dari Bank Advance Manager 1.
- [ ] **UI:** Periksa halaman Dasbor/Profil Manager 1. **Outstanding Debt** harus menunjukkan angka **Rp1.000.000**.
- [ ] **Database (`advances`):** Status kasbon harus `completed` atau `in_settlement`, dan `disbursed_amount` terisi Rp1.000.000.
- [ ] **Database (`bank_transactions`):** Ada transaksi keluar dari Bank Advance Manager 1 sebesar Rp1.000.000.

---

## 3. Skenario Settlement 1: Pengeluaran Kurang dari Kasbon (Sisa Hutang > 0)

_Kondisi: Kasbon Rp1.000.000, tapi pengeluaran riil hanya Rp600.000._

- [ ] **UI:** Manager 1 melakukan Settlement sebesar **Rp600.000**.
- [ ] **UI:** Manager melakukan Approve pada Settlement tersebut.
- [ ] **UI (Validasi Flow):** Karena masih ada hutang sisa (Rp400.000), **Table 2 (Reimbursement/Payment) TIDAK BOLEH MUNCUL**.
- [ ] **UI (Validasi Flow):** Tombol **Final Approval** harus langsung muncul dan bisa diklik.
- [ ] **UI (Validasi Debt):** Setelah Final Approval, periksa Debt Card. Harus berwarna merah, menggunakan Bahasa Inggris ("Outstanding Debt"), dan nilainya update menjadi **Rp400.000**.
- [ ] **Database (`settlements` & `expenses`):** Pastikan settlement berstatus approved/completed dengan total amount Rp600.000.

---

## 4. Skenario Kasbon Baru Saat Masih Ada Hutang

_Kondisi: Manager 1 masih punya hutang Rp400.000, lalu mengajukan Kasbon baru Rp1.000.000._

- [ ] **UI:** Manager 1 membuat pengajuan Kasbon baru.
- [ ] **UI (Validasi Peringatan):** Sistem harus memunculkan notifikasi/peringatan bahwa "Masih terdapat hutang yang belum diselesaikan".
- [ ] **UI:** Manager 1 memilih opsi **Lanjutkan pengajuan baru** (mengabaikan pembayaran sisa hutang lama).
- [ ] **UI:** Setelah Kasbon baru disetujui (Rp1.000.000), cek Debt Card. Total hutang sekarang harus **Rp1.400.000** (400rb lama + 1jt baru).

---

## 5. Skenario Settlement 2: Pengeluaran Sesuai Kasbon (Sisa Hutang Berjalan)

_Kondisi: Settlement persis Rp1.000.000 sesuai kasbon kedua. Tapi masih ada hutang lama Rp400.000._

- [ ] **UI:** Manager 1 melakukan Settlement untuk Kasbon kedua sebesar **Rp1.000.000**.
- [ ] **UI (Validasi Flow):** Sama seperti Skenario 3, Table 2 tidak boleh muncul. Tombol Final Approval langsung muncul.
- [ ] **UI (Validasi Debt):** Setelah Final Approval, nilai Debt Card harus kembali ke **Rp400.000**.

---

## 6. Skenario Pengembalian Sisa Hutang (Debt = 0)

- [ ] **UI:** Manager 1 memutuskan untuk mengembalikan sisa hutang Rp400.000. Dia melakukan proses transfer (Return) dan mengunggah bukti transfer.
- [ ] **UI:** Manager/Finance menyetujui (Approve) pengembalian tersebut ke Bank Advance Manager 1.
- [ ] **UI (Validasi Debt):** Debt Card harus menjadi **Rp0** (lunas).
- [ ] **Database (`bank_transactions`):** Harus ada transaksi _Income_ masuk ke Bank Advance Manager 1 sebesar Rp400.000.
- [ ] **UI:** Saldo Bank Advance Manager 1 kembali normal sesuai perhitungan awal.

---

## 7. Skenario Settlement 3: Pengeluaran Lebih Besar dari Kasbon (Hutang < 0)

_Kondisi: Ajukan Kasbon baru Rp1.000.000. Tapi ternyata Settlement-nya Rp1.500.000._

- [ ] **UI:** Manager 1 ajukan Kasbon Rp1.000.000 dan di-approve.
- [ ] **UI:** Manager 1 ajukan Settlement dengan total **Rp1.500.000**. Manager menyetujui.
- [ ] **UI (Validasi Flow):** Nilai Debt sekarang adalah `1.000.000 - 1.500.000 = -500.000`. **Table 2 HARUS MUNCUL**.
- [ ] **UI (Validasi Flow):** Tombol **Final Approval BELUM BOLEH MUNCUL** sebelum Table 2 diselesaikan.
- [ ] **UI (Table 2):** Pastikan nilai di Table 2 (Reimbursement) adalah **Rp500.000** (bukan 1,5 juta).
- [ ] **UI (Validasi Debt):** Debt Card menunjukkan angka **-Rp500.000** (minus lima ratus ribu).
- [ ] **UI:** Lakukan proses Reimbursement (transfer dari perusahaan ke karyawan) melalui Table 2.
- [ ] **UI (Validasi Flow):** Setelah Reimbursement selesai, baru tombol **Final Approval** muncul dan bisa diklik.

---

## 8. Verifikasi Visual & Validasi Data (General)

- [ ] **Format Angka Nol:** Pastikan nilai Rp0 tampil benar sebagai **Rp0**, BUKAN sebagai angka nol yang diformat dengan pemisah ribuan seperti `00.000.000`, `Rp 0.0`, atau format aneh lainnya. _(Ini sangat penting untuk dicek karena pemformat uang seringkali gagal ketika angkanya 0)_.
- [ ] **Tanda Plus/Minus:** Pada histori / logbook, pastikan tanda `+` (pemasukan/pengembalian) dan `-` (pengeluaran/hutang) tampil secara akurat dan tidak membingungkan. Apabila format minus, pastikan bentuknya rapi misal `-Rp500.000`.
- [ ] **Bahasa & Warna UI:** Pastikan "Outstanding Debt" / "Debt Card" menggunakan Bahasa Inggris, berwarna merah (jika ada hutang positif), sesuai dengan instruksi desain.
- [ ] **Logbook di Database:** Buka TablePlus > `bank_transactions`. Pastikan isi kolom `description` bersih (contoh: "Kasbon Manager 1", "Pengembalian Sisa Hutang"), dan _tidak lagi_ menampilkan format panjang bermuatan _pipes_ (`|0|...|system migration`).
