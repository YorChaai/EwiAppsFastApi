# 1 jenis case satu

"
bentar saya lihat ini masih blm bisa gini

Manager 1 ini sebenarnya sudah dibuatkan kasbonnya. Yang saya maksud, pada saat data masih berada di tabel Submit (Tabel 1) dan akan diverifikasi dan harus di approved gitu, jika di apporved pasti akan status akan diubah menjadi Approved, sistem seharusnya melakukan pengecekan terlebih dahulu saat teken approved centang itu mirip seperti pada proses kategori dan subkategori.

Jika saldo uang pada akun Advance Manager 1 tidak mencukupi untuk memenuhi nominal yang diminta, maka sistem harus menampilkan notifikasi bahwa saldo advance tidak mencukupi. Setelah itu, Manager atau Super Manager dapat masuk ke halaman Bank di popup nitifikasi itu dan untuk melakukan top-up atau alokasi dana ke akun Advance Manager 1 sesuai kebutuhan.

Setelah saldo advance mencukupi, barulah pengguna kembali ke halaman Detail Kasbon dan melakukan proses verifikasi hingga status menjadi Approved.

Namun pada tahap ini dana sebenarnya belum dikirimkan, karena masih harus melalui proses Pengiriman Dana Kasbon.

Ketika status sudah mencapai Approved pada Tabel 2 (Pengiriman Dana Kasbon), maka secara otomatis saldo akun advance akan berkurang dan hutang karyawan akan terbentuk.

Contohnya:

- Nominal kasbon yang diminta: Rp100.000
- Saldo akun Advance Manager 1: Rp500.000

Setelah proses Approved:

- Saldo akun Advance Manager 1 menjadi Rp400.000
- Hutang karyawan menjadi Rp100.000

Jadi saat kasbon disetujui dan dana dialokasikan, saldo advance berkurang sesuai nominal yang diberikan, sedangkan nominal tersebut tercatat sebagai hutang yang nantinya harus diselesaikan melalui proses settlement.

"

# 2 jenis case kedua

Kalau menurut saya alurnya seperti ini (termasuk Konsep Saldo Virtual):

**Konsep Dasar Saldo Virtual**
Sistem pembukuan kasbon dan pengeluaran menggunakan 3 komponen utama:
- **Saldo Virtual A (Bank Advance / Plafon):** Dana yang dialokasikan oleh perusahaan dan bisa digunakan oleh Manager.
- **Hutang (Floating/Pending Advance):** Uang kasbon yang sedang dipegang oleh karyawan dan belum diselesaikan (belum settlement/refund).
- **Saldo Virtual B (Realized/Consumed Budget):** Total dana yang sudah "sah" keluar dari Saldo Virtual A dan telah selesai prosesnya (baik berupa bukti struk pengeluaran valid, maupun uang sisa yang dikembalikan ke kas utama perusahaan).

Setiap uang yang diajukan akan memotong **Saldo Virtual A**. Jika proses telah selesai (settlement/pengembalian), maka nilai tersebut dipindahkan ke **Saldo Virtual B**.

**Alur Lengkap Kasbon, Settlement, dan Pengembalian (Refund):**

Misalnya saldo kas di Bank BRI masih 0 dan ditambah Rp5.000.000, maka data akan ter-update menjadi Rp5.000.000 dan **logbook juga akan ter-update mencatat pemasukan ini**.

Kemudian perusahaan melakukan alokasi dana ke akun Bank Advance Titis (Saldo Virtual A) sebesar Rp3.000.000. Setelah transaksi tersebut:
- Bank BRI: Rp2.000.000
- Bank Advance Titis (Saldo Virtual A): Rp3.000.000
- Saldo Virtual B: Rp0
*(Logbook bank akan mencatat perpindahan Rp3.000.000 dari BRI ke Advance Titis)*

Lalu Kak Titis mengajukan kasbon (permintaan uang muka) sebesar Rp1.000.000 dari detail item yang dia ajukan. Setelah disetujui dan dana diberikan:
- Bank BRI: Rp2.000.000
- Bank Advance Titis (Saldo Virtual A): Rp2.000.000 *(Plafon berkurang 1 Juta)*
- Hutang karyawan (Kak Titis): Rp1.000.000 *(Memegang 1 Juta)*
- Saldo Virtual B: Rp0

Kemudian Kak Titis melakukan settlement dan ternyata dana yang digunakan hanya Rp600.000. Berarti masih ada sisa Rp400.000 yang belum dipertanggungjawabkan. Jika settlement hanya di-approve tanpa pengembalian dana, maka:
- Bank BRI: Rp2.000.000
- Bank Advance Titis (Saldo Virtual A): Rp2.000.000 *(Plafon tidak kembali)*
- Hutang Kak Titis: Rp400.000 *(Sisa uang yang belum dipertanggungjawabkan/dikembalikan)*
- Saldo Virtual B: Rp600.000 *(Nilai Rp600.000 yang sudah ada struknya kini sah menjadi realisasi pengeluaran)*
Artinya Rp400.000 tersebut masih menjadi hutang kepada perusahaan karena tidak digunakan dan belum dikembalikan.

Selanjutnya Kak Titis mengajukan advance lagi sebesar Rp1.000.000. Kondisinya menjadi:
- Bank BRI: Rp2.000.000
- Bank Advance Titis (Saldo Virtual A): Rp1.000.000 *(Plafon berkurang 1 Juta lagi)*
- Total Hutang Kak Titis: Rp1.400.000 *(Rp400.000 hutang sebelumnya + Rp1.000.000 advance baru)*
- Saldo Virtual B: Rp600.000

Saat melakukan settlement untuk advance kedua, ternyata dana yang digunakan memang Rp1.000.000 sesuai pengajuan. Setelah settlement disetujui, masih tersisa hutang Rp400.000 dari transaksi sebelumnya.
- Saldo Virtual B: Rp1.600.000 *(Rp600.000 awal + Rp1.000.000 baru)*
- Total Hutang Kak Titis: Rp400.000

Karena sistem mendeteksi masih ada hutang, maka saat membuat advance atau kasbon baru sebaiknya muncul notifikasi bahwa masih terdapat hutang yang belum diselesaikan. Pengguna dapat memilih salah satu opsi:
1. Melanjutkan pengajuan pengeluaran baru.
2. Mengembalikan seluruh hutang yang masih outstanding.

Jika Kak Titis memilih mengembalikan hutang, kemudian mengunggah bukti transfer (evidence) sebesar Rp400.000 dan pengembalian tersebut diterima perusahaan (dikembalikan ke rekening utama), maka kondisi akhirnya menjadi:
- Bank BRI: Rp2.400.000 *(BRI bertambah Rp400.000 dari uang refund. Logbook mencatat pemasukan refund)*
- Bank Advance Titis (Saldo Virtual A): Rp1.000.000
- Hutang Kak Titis: Rp0 *(Hutang Lunas)*
- Saldo Virtual B: Rp2.000.000 *(Sisa Rp400.000 yang direfund ikut masuk ke Virtual B sebagai penutup siklus pengeluaran plafon)*
Dengan demikian seluruh hutang sebelumnya telah lunas dan tidak ada saldo hutang yang tersisa.

# 3 jenis case ketiga: Alur Pengeluaran Langsung (Tanpa Kasbon / Reimbursement)

Ada kondisi di mana karyawan tidak melakukan kasbon di awal, melainkan langsung menggunakan uang pribadinya untuk membeli barang perusahaan, lalu mengajukan Reimbursement (Penggantian Dana) melalui menu settlement.

Kondisi Awal (Melanjutkan sisa dari Case 2):
- Bank BRI: Rp2.400.000
- Bank Advance Titis (Saldo Virtual A): Rp1.000.000
- Hutang: Rp0
- Saldo Virtual B: Rp2.000.000

Karyawan melakukan pembelian barang menggunakan uang pribadi sebesar Rp1.000.000. Ia membuat pengajuan penyelesaian (settlement/pengeluaran) beserta struknya. Manager menyetujui dan perusahaan mentransfer uang penggantian tersebut ke karyawan (diambil dari plafon Advance Titis, tapi uang fisiknya ditransfer ke karyawan).
*(Logbook bank akan mencatat pengeluaran reimbursement)*

Kondisi Setelah Reimbursement Disetujui:
- Bank BRI: Rp2.400.000
- Bank Advance Titis (Saldo Virtual A): Rp0 *(Plafon habis terpakai)*
- Hutang: Rp0 *(Tidak ada hutang karena ini uang pribadi yang diganti)*
- Saldo Virtual B: Rp3.000.000 *(Total realisasi pengeluaran bertambah 1 Juta)*

Pada skenario ini, tidak ada satupun proses yang mampir ke status "Hutang" karena perusahaan hanya mengganti dana yang sudah valid dikeluarkan oleh karyawan.
