# Solusi Aktivitas Git Push Tidak Muncul di GitHub Contribution Graph

Seringkali pengguna GitHub mendapati bahwa meskipun mereka telah berhasil melakukan `git push` dan kode sudah masuk ke repositori (bahkan tercatat di history commit repo tersebut), **kotak kontribusi (warna hijau) pada profil GitHub mereka tidak terisi atau tidak muncul**.

Berikut adalah penjelasan mengapa hal ini bisa terjadi beserta solusi lengkapnya.

---

## Penyebab dan Solusi

### 1. Email Lokal Belum Terdaftar atau Belum Diverifikasi di GitHub (Penyebab Terbanyak)

Agar GitHub mengetahui bahwa suatu commit adalah milik Anda (dan memberikan kredit pada profil), GitHub akan mencocokkan **email yang Anda gunakan di konfigurasi Git lokal** dengan **email yang terdaftar di akun GitHub Anda**.

Jika Anda melakukan push dengan email seperti `diofavianrch@gmail.com` dari terminal, tetapi email tersebut tidak terdaftar di akun GitHub Anda (atau berstatus *Unverified*), maka commit tidak akan tercatat di grafik kontribusi.

**Cara Mengecek Email di Terminal:**
Jalankan perintah ini di terminal Anda:
```bash
git config --local user.email
# atau
git config --global user.email
```

**Solusi:**
1. Buka browser dan login ke akun GitHub Anda.
2. Pergi ke **Settings** > **Emails** (atau klik [https://github.com/settings/emails](https://github.com/settings/emails)).
3. Pastikan email yang muncul dari terminal (misal: `diofavianrch@gmail.com`) sudah ditambahkan di sana.
4. Jika belum, tambahkan email tersebut.
5. Pastikan email tersebut memiliki status **Verified**. Jika masih *Unverified*, klik tombol verifikasi dan cek kotak masuk (inbox) email Anda untuk menyelesaikannya.
> **Note:** Setelah email ditambahkan dan diverifikasi, GitHub akan secara otomatis menelusuri riwayat commit lama Anda dan memunculkan warna hijau pada kotak kontribusi (biasanya memakan waktu beberapa menit).

### 2. Repositori Bersifat Privat (Private Repository)

Secara bawaan (default), GitHub sangat menjaga privasi Anda. Jika Anda berkontribusi pada proyek/repositori yang diatur sebagai *Private*, GitHub **menyembunyikan** seluruh kotak hijau dari repositori tersebut saat orang lain (maupun Anda sendiri) melihat profil publik Anda.

**Solusi:**
Jika Anda ingin aktivitas pada repositori privat Anda tetap menyumbang kotak hijau di profil:
1. Buka halaman profil publik GitHub Anda (contoh: `https://github.com/YorChaai`).
2. Tepat di bagian kanan atas pada kotak grafik *Contributions*, klik tulisan **"Contribution settings"**.
3. Centang opsi **"Private contributions"**.
> **Note:** Dengan mengaktifkan ini, pengunjung profil Anda hanya akan melihat kotak hijau tanpa bisa mengetahui ke repositori privat mana Anda berkontribusi.

### 3. Anda Melakukan Commit di Branch Selain "main" atau "master"

GitHub hanya menampilkan aktivitas kontribusi (kotak hijau) jika commit tersebut berada di **default branch** (umumnya `main` atau `master`), atau di branch `gh-pages`. Jika Anda mengerjakan sesuatu di branch lain (contoh: branch `fitur-a`) dan belum melakukan merge ke branch default, aktivitas tersebut tidak akan muncul.

**Solusi:**
1. Lanjutkan pekerjaan Anda.
2. Saat selesai, lakukan *Pull Request* atau *Merge* dari branch `fitur-a` ke branch `main`.
3. Segera setelah di-merge, grafik kontribusi dari hari saat Anda melakukan commit di branch tersebut akan otomatis menjadi hijau.

### 4. Cache GitHub atau Perbedaan Waktu (Timezone)

Terkadang, ada faktor penundaan (delay) dari server GitHub dalam merender kotak kontribusi. Selain itu, perbedaan *timezone* atau kesalahan pada jam sistem komputer lokal Anda saat melakukan commit dapat menyebabkan tanggal commit berbeda dengan tanggal aslinya (misalnya, jam komputer tersetting tahun 2026 padahal saat ini tahun 2024).

**Solusi:**
1. Pastikan jam, tanggal, dan tahun di sistem komputer Anda sudah benar.
2. Tunggu hingga 24 jam karena terkadang GitHub membutuhkan waktu untuk memproses kalkulasi grafik.

---

Dengan mengikuti pengecekan di atas, khususnya poin nomor 1 dan 2, hampir seluruh masalah riwayat kotak hijau yang hilang akan teratasi.
