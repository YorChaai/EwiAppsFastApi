# Penjelasan Masalah Aplikasi Kasbon

Dokumen ini berisi rangkuman dua masalah yang ditemukan pada fitur Kasbon, lengkap dengan letak kode yang bermasalah. Anda dapat menggunakan dokumen ini sebagai *prompt* atau konteks untuk model AI lain (seperti ChatGPT atau Claude) jika Anda ingin mereka membantu menuliskan kodenya.

---

## Masalah 1: Bulk Delete Tidak Berfungsi Sempurna
**Deskripsi Masalah:** 
Saat pengguna mencoba menghapus 3 dokumen (Kasbon) sekaligus, muncul notifikasi hijau "Berhasil menghapus 3 item". Namun, setelah halamannya di-refresh, hanya kasbon berstatus "Draft" yang benar-benar terhapus. Kasbon dengan status "Submitted", "Revision", dan "Approved" ternyata masih ada dan tidak terhapus dari database, meskipun notifikasinya sukses.

**Penyebab Masalah:**
Model AI sebelumnya membuat endpoint API untuk menghapus Kasbon, namun lupa memasukkan perintah penghapusan dari database (`db.session.delete`) dan commit (`db.session.commit()`). API tersebut hanya memvalidasi hak akses dan langsung merespons sukses `200 OK` tanpa melakukan aksi apa pun pada database. 

Oleh karena API memberikan respons `200 OK`, aplikasi frontend (Flutter) menganggap penghapusan berhasil dan menampilkan notifikasi sukses, padahal datanya tidak pernah dihapus di database.

**Lokasi Kode yang Bermasalah (Backend):**
File: `backend/routes/advances.py`
Fungsi: `delete_advance(advance_id)`

**Prompt untuk AI Lain:**
> "Bantu saya memperbaiki endpoint `delete_advance` di Flask (`backend/routes/advances.py`). Saat ini endpoint tersebut mereturn response sukses (200), tetapi tidak ada eksekusi `db.session.delete(advance)` dan `db.session.commit()`. Tolong tambahkan logika penghapusan ke database pada fungsi tersebut."

---

## Masalah 2: Item Kasbon Bisa Disetujui Padahal Saldo Virtual Kosong
**Deskripsi Masalah:**
Saat Manager melakukan verifikasi Kasbon, Manager dapat menekan tombol "Centang" pada baris rincian item kasbon (Tabel 1). Ketika tombol centang ditekan, item tersebut langsung berubah statusnya menjadi `APPROVED` beserta notifikasi "Item kasbon disetujui". Sistem tidak melakukan pengecekan sama sekali apakah saldo Virtual Advance Manager 1 mencukupi untuk item tersebut. 

**Penyebab Masalah:**
Pada sistem sebelumnya, pengecekan saldo virtual Advance (untuk memblokir persetujuan jika saldo kurang) hanya dilakukan di satu tempat, yaitu pada saat Manager menekan tombol **"Approve All"** secara keseluruhan. Namun, pengecekan saldo ini *tidak diterapkan* pada endpoint yang mengurus persetujuan per-item tunggal (saat menekan tombol centang). 

**Lokasi Kode yang Bermasalah (Sudah Saya Perbaiki Sebagian):**
- **Backend:** `backend/routes/advances.py` pada fungsi `update_advance_item(item_id)`. Pengecekan saldo (`calculate_user_running_balance`) harus ditambahkan ketika `data["status"] == "approved"`.
- **Frontend:** `frontend/lib/providers/advance_provider.dart` (Fungsi `approveAdvanceItem`) dan `frontend/lib/screens/advance/advance_detail_widgets.dart` (Fungsi `_approveItem`). Frontend harus menangkap error HTTP 422 (Insufficient Balance) dan memunculkan *Pop-up Dialog* persis seperti saat tombol "Approve All" ditekan.

**Status Saat Ini:** 
Masalah ke-2 ini **sudah saya tangani dan perbaiki kodenya** pada chat sebelumnya. Namun, jika Anda ingin AI lain memeriksa atau merapikan strukturnya, Anda bisa memberikan prompt berikut.

**Prompt untuk AI Lain:**
> "Bantu saya memastikan logika pengecekan saldo kasbon. Saya ingin setiap kali manager menyetujui sebuah item individual melalui fungsi `update_advance_item` (method PUT) di `backend/routes/advances.py`, sistem menghitung akumulasi total semua item yang sudah disetujui di dalam kasbon tersebut ditambah item yang sedang disetujui, lalu membandingkannya dengan saldo virtual advance. Jika kurang, kembalikan HTTP 422 agar frontend bisa menampilkan pop-up top-up saldo."
