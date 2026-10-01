Sekarang untuk Table 3, saya lihat masih belum ada validasi yang ketat.

Saran saya:

- Jika form di Table 3 masih ada data yang belum diisi (selain komentar biasa), maka data tidak boleh bisa di-submit.
- dan ada kalanay juga kalo dari table 2 ke table 3 pasti kan dalam keadaan submit kan nah saya mau mirip kaya table 2 dimana tuh, kalo data form di table 3 blm ke isi semua(kecuali komentar biasa) maka centang dan silang di aksi verifikasi di bagina aksi ke hide atau tidak ada disitu harus form table 3 terisi semua baru muncul centang dan silang itu

- Submit hanya bisa dilakukan jika semua field wajib sudah terisi lengkap.
- Setelah berhasil submit, baru masuk ke proses verifikasi:
  - Jika dicentang → status menjadi approved.
  - Jika disilang → status menjadi revision dan wajib menambahkan komentar reject.

Untuk komentar reject di Table 3, behavior-nya harus sama persis seperti yang ada di Table 1 rincian item, yaitu:

- Bisa tambah komentar saat status draft/revision.
- Bisa delete komentar.
- Bisa edit teks komentar.
- Mendukung enter/multi-line dalam satu komentar.

Hak akses juga harus sama:

- Role staff tidak boleh tambah, edit, atau delete komentar reject.
- Hanya manager dan super manager yang boleh melakukan tindakan tersebut.

Selain itu, mohon hati-hati pada logic validasi Table 3 karena saya pernah menemukan bug yang cukup parah.

Contoh kasus:

- Awalnya rincian item = 10.000
- Pengiriman dana = 12.000
- Jadi muncul sisa dan Table 3 terisi.

Lalu saya ubah amount pengiriman dana dari 12.000 menjadi 10.000 sehingga sisa menjadi 0. Karena tidak ada sisa lagi, maka Table 3 otomatis hilang dan memang itu sudah benar.

Namun masalahnya, saat saya submit ulang, sistem malah menampilkan error:

> "Table 3 harus diisi datanya dengan lengkap"

Padahal Table 3 sudah tidak muncul karena memang tidak diperlukan lagi. Ini menyebabkan bug submit yang sangat lama dan pernah memakan waktu sampai seharian untuk dicari penyebabnya.

Jadi mohon logic validasi Table 3 benar-benar diperhatikan:

- Jika Table 3 memang tidak muncul / tidak diperlukan karena tidak ada sisa, maka validasi Table 3 harus otomatis dilewati.
- Jangan sampai sistem tetap menganggap Table 3 wajib diisi padahal tabelnya sudah tidak ada.
