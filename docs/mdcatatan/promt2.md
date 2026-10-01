# Prompt 2 — Audit Kelengkapan & Temukan Aspek yang Terlewat

Sekarang lakukan **audit menyeluruh** terhadap source code halaman **[NAMA HALAMAN]** dan isi file `[NAMA_HALAMAN].md` dari tahap sebelumnya.

Tujuan tahap ini bukan sekadar menambahkan validasi, tetapi **mencari apakah masih ada aspek yang belum terdokumentasikan**.

Bandingkan source code dengan isi file dan periksa kembali seluruh area berikut:

- Fitur yang belum tercatat
- Button atau action yang terlewat
- Input yang terlewat
- Validasi
- Error message
- Success message
- Loading state
- Empty state
- Disabled state
- Confirmation dialog
- Popup/modal
- Navigation
- Redirect
- Perubahan UI berdasarkan kondisi tertentu
- Perubahan UI berdasarkan role/permission
- Perubahan UI berdasarkan status/data
- Edge cases
- Kondisi gagal
- Kondisi berhasil
- Responsiveness
- Behavior khusus pada device tertentu
- Behavior ketika data kosong
- Behavior ketika data tidak valid
- Behavior ketika koneksi/API bermasalah
- Fitur tersembunyi atau conditional
- User flow yang belum tercatat
- Hasil/action setelah user melakukan suatu tindakan
- Informasi atau label yang penting bagi pengguna
- Fitur kecil yang mungkin terlewat pada tahap pertama

## Aturan Audit

Lakukan pemeriksaan dengan pola:

**Source Code → Apa yang dilakukan/ditampilkan → Apakah sudah ada di file?**

Jika sudah ada, **jangan membuat duplikat**.

Jika belum ada, tambahkan.

Jika informasi sebelumnya ternyata salah atau tidak sesuai dengan source code, **perbaiki**.

Jangan mengarang fitur.

Jangan menambahkan sesuatu hanya karena menurut Anda fitur tersebut seharusnya ada.

Semua informasi harus memiliki dasar dari source code atau behavior yang benar-benar dapat ditelusuri dari source code.

## Fokus Tahap Ini

Tahap 1 bertujuan untuk:

> "Apa saja yang ada?"

Tahap 2 bertujuan untuk:

> "Apakah masih ada yang kurang atau terlewat?"

Jadi lakukan pemeriksaan ulang secara kritis. Jangan hanya mengulang hasil tahap pertama.

**Wajib:** update/timpa file:

`D:\Aplikasi\EWIApps\docs\mdcatatan\[NAMA_HALAMAN].md`

dengan hasil audit yang sudah lengkap.
