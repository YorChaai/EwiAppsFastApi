Sekarang ada satu lagi. Saya lihat di Laporan Tahunan ada Revenue, sedangkan di Bank Management ada Bank Cash.

Di sini saya ingin melakukan semacam join atau integrasi data antara keduanya.

Jadi, misalnya saya mengisi Revenue, tetapi saat itu belum ada pilihan sumber dana, jadi nanti di tmabahin kolom sumber dana.

Kemudian, kalau saya memilih salah satu sumber dana dari Bank Cash, apakah data Revenue tersebut juga bisa otomatis masuk ke Bank Cash yang saya pilih conoth disini saya pilh bni maka ke bni gitu

Lalu ada kondisi lain. Misalnya pada bagian sumber dana saya memilih -, artinya Revenue tersebut belum memiliki sumber dana atau belum dialokasikan ke Bank Cash mana pun.

Kalau sumber dananya -, maka pada Laporan Tahunan → Revenue, line tersebut diberi warna kuning sebagai penanda bahwa Revenue tersebut belum masuk atau belum terhubung ke Laporan Tahunan, karena sumber dananya masih -.

Jadi intinya:

Revenue + pilih Bank Cash → Revenue terhubung dan masuk ke Bank Cash yang dipilih.

Revenue + sumber dana - → Revenue belum masuk ke Bank Cash mana pun.

Jika sumber dana -, line Revenue di Laporan Tahunan diberi warna kuning sebagai indikator bahwa datanya belum teralokasi/terhubung.

Jika kemudian sumber dana dipilih, status kuning tersebut hilang dan datanya otomatis terhubung ke Bank Cash yang dipilih.

Apakah konsep seperti ini bisa dibuat?

---

### Jawaban: Ya, Sangat Bisa Dibuat!

Konsep ini telah dianalisis dan dirancang ke dalam dokumen implementasi dan task list teknis lengkap.
Silakan merujuk ke dokumen berikut untuk detail task, arsitektur, dan status eksekusi:

👉 **[Dokumen Implementasi & Task List Rencana 1](file:///D:/Aplikasi/EWIApps/docs/plans/rencana1_task_dan_implementasi.md)**

#### Ringkasan Status Progres:
- [x] **Backend Model & DB**: Relasi `bank_id` pada `Revenue` dan `revenue_id` pada `BankTransaction` serta auto-migration kolom.
- [x] **Backend Sync Engine**: Sinkronisasi otomatis mutasi `income` ke `BankTransaction` saat Revenue ditambah/diedit/dihapus.
- [x] **Excel Export Highlight**: Highlight latar kuning muda pada baris Revenue yang bersumber dana `-`.
- [x] **Frontend Revenue Form**: Dropdown pilihan sumber dana Bank Cash dengan opsi `-` (default).
- [x] **Frontend Laporan Tahunan**: Baris berlatar kuning untuk Revenue dengan sumber dana `-`.
- [x] **Automated Testing & Analysis**: Suite test `test_revenue_bank_sync.py` dengan pytest (12/12 passed), `flutter analyze` (0 issues), dan `flutter test` (all passed).
