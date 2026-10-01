# Prompt 4 — Kompresi Narasi Menjadi PRD Final

Sekarang review kembali narasi lengkap di `[NAMA_HALAMAN].md`.

Ubah narasi tersebut menjadi **Product Requirements Document (PRD) final** yang ringkas, profesional, dan mudah dipahami.

Tujuan tahap ini adalah:

**Narasi lengkap → PRD final**

Bukan:

**Narasi lengkap → ringkasan yang kehilangan detail**

PRD final harus mempertahankan seluruh aspek penting yang terdapat dalam narasi.

## Format Output

Gunakan format seperti berikut:

# Product Requirements Document (PRD)

## Modul: [NAMA HALAMAN]

[Paragraf pertama menjelaskan fungsi, tujuan, konteks halaman, dan karakteristik utama halaman.]

[Paragraf berikutnya menjelaskan fitur dan interaksi utama pengguna secara natural.]

[Paragraf berikutnya menjelaskan validasi, kondisi khusus, error, success, loading, navigation, dan behavior penting lainnya.]

[Paragraf berikutnya menjelaskan edge cases atau fitur khusus lainnya jika diperlukan.]

## Aturan Format

- Gunakan **paragraf sebagai format utama**.
- Jangan mengubah seluruh isi menjadi bullet list.
- Jangan membuat section "Fitur Utama & Interaksi" yang isinya hanya daftar bullet.
- Jangan memecah setiap fitur menjadi daftar terpisah jika informasi tersebut dapat dijelaskan secara natural dalam paragraf.
- Gunakan heading hanya jika memang membantu struktur dokumen.
- Format harus terasa seperti PRD yang menjelaskan requirement secara natural, bukan hasil dump dari source code.
- Boleh menggunakan istilah teknis yang terlihat oleh pengguna, seperti nama button, popup, snackbar, atau screen.
- Hindari detail implementasi seperti nama function, class, variable, API endpoint, query database, dan struktur kode.

## Prinsip Kompresi

Ringkas dengan cara:

- Menghapus pengulangan.
- Menggabungkan informasi yang saling berkaitan.
- Menggunakan kalimat yang lebih padat.
- Menghapus detail implementasi teknis.
- Mempertahankan behavior yang penting.

Jangan meringkas dengan cara:

- Menghapus fitur.
- Menghapus validasi.
- Menghapus edge case.
- Menghapus error state.
- Menghapus conditional behavior.
- Menghapus role-based behavior.
- Menghapus navigation.
- Menghapus informasi penting lainnya.

### Quality Check

Sebelum menyimpan hasil akhir, bandingkan kembali PRD dengan narasi sebelumnya.

Pastikan:

**Setiap aspek penting yang ada di narasi tetap terwakili di PRD final.**

Jika terdapat informasi yang terlalu panjang, kompres kalimatnya tanpa menghilangkan maknanya.

**Wajib:** update/timpa file:

`D:\Aplikasi\EWIApps\docs\mdcatatan\[NAMA_HALAMAN].md`
