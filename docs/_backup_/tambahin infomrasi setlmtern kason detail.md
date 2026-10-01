Kalau menurut saya alurnya seperti ini:

Misalnya saldo kas di Bank BRI ada Rp5.000.000.

Kemudian perusahaan melakukan alokasi dana ke akun Bank Advance Titis sebesar Rp3.000.000. Setelah transaksi tersebut:

* Bank BRI: Rp2.000.000
* Bank Advance Titis: Rp3.000.000

Lalu Kak Titis mengajukan kasbon (permintaan uang muka) sebesar Rp1.000.000 dari detail item yang dia ajukan. Setelah disetujui dan dana diberikan:

* Bank BRI: Rp2.000.000
* Bank Advance Titis: Rp2.000.000
* Hutang karyawan (Kak Titis): Rp1.000.000

Kemudian Kak Titis melakukan settlement dan ternyata dana yang digunakan hanya Rp600.000. Berarti masih ada sisa Rp400.000 yang belum dipertanggungjawabkan. Jika settlement hanya di-approve tanpa pengembalian dana, maka:

* Hutang Kak Titis: Rp400.000

Artinya Rp400.000 tersebut masih menjadi hutang kepada perusahaan karena tidak digunakan dan belum dikembalikan.

Selanjutnya Kak Titis mengajukan advance lagi sebesar Rp1.000.000. Kondisinya menjadi:

* Bank BRI: Rp2.000.000
* Bank Advance Titis: Rp1.000.000
* Total hutang Kak Titis: Rp1.400.000 (Rp400.000 hutang sebelumnya + Rp1.000.000 advance baru)

Saat melakukan settlement untuk advance kedua, ternyata dana yang digunakan memang Rp1.000.000 sesuai pengajuan. Setelah settlement disetujui, masih tersisa hutang Rp400.000 dari transaksi sebelumnya.

Karena sistem mendeteksi masih ada hutang, maka saat membuat advance atau kasbon baru sebaiknya muncul notifikasi bahwa masih terdapat hutang yang belum diselesaikan. Pengguna dapat memilih salah satu opsi:

1. Melanjutkan pengajuan pengeluaran baru.
2. Mengembalikan seluruh hutang yang masih outstanding.

Jika Kak Titis memilih mengembalikan hutang, kemudian mengunggah bukti transfer (evidence) sebesar Rp400.000 dan pengembalian tersebut diterima perusahaan, maka kondisi akhirnya menjadi:

* Bank BRI: Rp2.000.000
* Bank Advance Titis: Rp1.000.000
* Hutang Kak Titis: Rp0

Dengan demikian seluruh hutang sebelumnya telah lunas dan tidak ada saldo hutang yang tersisa.



Masih ada beberapa hal yang belum sesuai.

1. **Final Approval belum mengikuti flow yang sudah kita sepakati.**

Saya sudah jelaskan sebelumnya:

* Jika nilai **Debt > 0** atau **Debt = 0**, maka tombol **Final Approval** harus langsung muncul.
* Tidak perlu menampilkan Table 2.
* Karena masih ada hutang kasbon yang sedang berjalan atau proses sudah selesai.

Contoh:

* Debt = Rp500.000 → Final Approval muncul.
* Debt = Rp0 → Final Approval muncul.

Sedangkan:

* Jika **Debt < 0** (misalnya -Rp1, -Rp100.000, atau -Rp500.000), maka **Final Approval belum boleh muncul**.
* Yang harus muncul terlebih dahulu adalah **Table 2 (Reimbursement/Payment)**.
* Setelah Table 2 selesai diproses dan di-approve, barulah tombol **Final Approval** muncul.

Jadi flow-nya:

**Debt >= 0**
→ Final Approval muncul.

**Debt < 0**
→ Table 2 muncul.
→ Approve Table 2.
→ Final Approval muncul.

---

2. **Debt Card yang baru dibuat juga masih belum benar.**

Debt Card harus menggunakan:

* Warna merah.
* Bahasa Inggris.

Contoh:

**Outstanding Debt**
Rp500.000

atau

**Outstanding Debt**
-Rp500.000

Nilai pada card harus selalu mengikuti hasil perhitungan settlement terbaru.

---

3. **Semua label pada Gambar 3 juga sebaiknya menggunakan Bahasa Inggris agar konsisten dengan tampilan lainnya.**

---

4. **Perhitungan pada Table 2 masih salah.**

Contoh kasus:

* Kasbon = Rp1.000.000
* Pengeluaran yang di-settlement = Rp1.500.000

Maka:

Debt = Rp1.000.000 - Rp1.500.000

Debt = **-Rp500.000**

Artinya perusahaan masih harus mengganti uang user sebesar Rp500.000.

Karena itu:

* Debt Card harus menampilkan **-Rp500.000**.
* Amount pada Table 2 harus **Rp500.000**.

Saat ini yang muncul justru Rp1.500.000, sehingga perhitungannya tidak sesuai.

Selain itu, saya juga melihat Debt Card masih menampilkan nilai 0, padahal seharusnya nilai debt setelah settlement adalah **-Rp500.000**.

Jadi sumber masalahnya kemungkinan besar ada pada perhitungan atau update nilai debt setelah settlement, karena nilai yang ditampilkan di card tidak sesuai dengan hasil perhitungan transaksi.


Sudah lebih benar, tetapi masih ada yang kurang.

Yang paling penting, card summary hutangnya belum terlihat berubah. Misalnya:

* Kasbon: Rp1.000.000
* Approved di settlement: Rp500.000

Maka card summary hutang seharusnya berubah dari:

**Hutang: Rp1.000.000 → Rp500.000**

Karena Rp500.000 sudah dipertanggungjawabkan melalui settlement. Saat ini saya belum melihat perubahan nilai hutang tersebut di UI.

Selain itu, saya juga masih bingung apakah ini bug atau memang flow yang dirancang seperti itu. Soalnya setelah tahap ini sepertinya tidak ada aksi lain yang bisa dilakukan.

Menurut saya flow-nya bisa disederhanakan seperti ini:

### Kondisi Hutang > 0

Jika nilai hutang masih di atas 0 (misalnya Rp100, Rp10.000, atau Rp500.000), maka tombol **Final Approve** tetap bisa muncul.

Karena pada kondisi ini user masih memiliki sisa hutang kasbon yang belum selesai. Jadi tidak perlu masuk ke Table 2 terlebih dahulu.

Contoh:

* Kasbon: Rp1.000.000
* Settlement approved: Rp500.000
* Sisa hutang: Rp500.000

Maka:

* Card hutang berubah menjadi Rp500.000.
* Final Approve tetap bisa dilakukan.
* Table 2 tidak perlu muncul karena tidak ada uang yang harus dibayarkan ke user.

### Kondisi Hutang = 0

Jika setelah settlement nilai hutang menjadi 0, maka proses dianggap selesai.

Contoh:

* Kasbon: Rp1.000.000
* Settlement approved: Rp1.000.000
* Hutang: Rp0

Maka:

* Final Approve bisa dilakukan.
* Tidak perlu Table 2.
* Proses selesai.

### Kondisi Hutang < 0

Jika hutang bernilai negatif, berarti user mengeluarkan uang lebih besar daripada kasbon yang diterima.

Contoh:

* Kasbon: Rp100.000
* Pengeluaran yang di-settlement: Rp200.000

Perhitungannya:

* Hutang = Rp100.000 - Rp200.000
* Hutang = -Rp100.000

Artinya perusahaan masih berhutang kepada user sebesar Rp100.000.

Pada kondisi inilah Table 2 perlu ditampilkan.

Contoh isi Table 2:

* Amount Penggantian Dana: Rp100.000

Karena perusahaan harus mengirim tambahan dana kepada user sebesar Rp100.000 untuk menutup selisih pengeluaran yang melebihi kasbon.

Jadi menurut saya aturan sederhananya:

* Hutang > 0 → Tidak perlu Table 2.
* Hutang = 0 → Selesai, tidak perlu Table 2.
* Hutang < 0 → Tampilkan Table 2 untuk proses penggantian dana sesuai nilai absolut hutang.

Flow ini lebih mudah dipahami karena kemunculan Table 2 benar-benar bergantung pada nilai hutang akhir setelah settlement.
