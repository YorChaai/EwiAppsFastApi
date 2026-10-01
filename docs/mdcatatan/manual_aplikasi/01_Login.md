# Product Requirements Document (PRD)
## Modul: Halaman Login

Halaman Login adalah antarmuka responsif pertama aplikasi yang beradaptasi menjadi satu kolom di layar kecil (HP) dan dua kolom di layar lebar (Tablet/Landscape), serta dilengkapi dengan elemen visual identitas "EWIAPPS". 

Untuk login manual, pengguna mengisi kolom "Username/Email" (dilengkapi teks *hint*) dan "Password" (karakter disembunyikan `***` namun bisa dilihat lewat ikon mata). Tersedia opsi centang "Remember Me" untuk menyimpan sesi, dilanjutkan dengan menekan tombol "Login". Sistem akan otomatis memvalidasi input; memunculkan peringatan jika kolom kosong atau password kurang dari 6 karakter, serta menampilkan error spesifik jika kredensial salah atau koneksi bermasalah (pesan jaringan disertai tombol aksi "CEK IP").

Sebagai alternatif instan, pengguna bisa mengklik tombol login Google (ikon 'G'). Jika perangkat tidak mendukung, sistem akan meminta pengguna memakai login manual. Menariknya, jika email Google tersebut belum terdaftar, aplikasi tidak menolak masuk, melainkan memunculkan *pop-up* konfirmasi pembuatan akun baru. Jika disetujui, pengguna akan diarahkan ke halaman Register dengan nama dan email yang sudah terisi otomatis dan dikunci.

Bagi pengguna baru, tersedia tautan langsung untuk beralih ke halaman Register. Sementara bagi yang lupa kata sandi, tautan "Lupa Password" akan memunculkan *pop-up* pemulihan bertahap: mulai dari input email untuk meminta kode OTP, input validasi OTP, hingga pembuatan kata sandi baru. Terakhir, di bagian paling bawah layar terdapat label teks URL server yang jika diklik memungkinkan teknisi/pengguna untuk mengubah alamat IP API secara manual.
