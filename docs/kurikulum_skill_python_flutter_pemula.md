# Kurikulum Pemula: Belajar EWIApps dari Nol

Panduan ini ditujukan untuk orang yang belum tahu harus belajar apa sebelum memahami aplikasi. Ikuti urutannya. Jangan mulai dengan mengedit fitur besar: kuasai konsep, kerjakan latihan kecil, lalu telusuri satu alur codebase sampai paham. Backend EWIApps menggunakan Python + FastAPI + SQLAlchemy + Alembic; frontend menggunakan Flutter + Dart + Provider. Flask tidak dibutuhkan untuk pengembangan aplikasi ini.

## Cara belajar

- Satu sesi 1–2 jam, tetapi jangan pindah tahap hanya karena waktunya habis.
- Ketik contoh sendiri, jalankan, ubah satu hal, lalu jelaskan dengan kata-kata sendiri.
- Simpan latihan di `scratch/belajar/`, jangan gunakan database/upload aplikasi.
- Baca error lengkap dan cari baris sumbernya. Catat istilah yang belum dikenal.
- Sebelum mengedit: lihat `git status`, baca kode terkait, cari test, lalu tinjau `git diff`.
- Jangan pernah memasukkan `.env`, token, password, atau data keuangan ke Git/chat.

## Gambaran alur aplikasi

```text
Pengguna → Flutter screen/widget → Provider/controller → API service
         → HTTP request (JSON/token/file) → FastAPI route → validasi/auth
         → service/aturan bisnis → SQLAlchemy → PostgreSQL
         → response JSON/file → Flutter state → UI
```

Tujuan akhirnya: bisa mengikuti data melalui semua panah itu.

## Tahap 0 — Komputer, terminal, dan Git

**Belajar:** dasar folder/path Windows, terminal PowerShell (`cd`, `dir`, menjalankan perintah, `Ctrl+C`), path relatif dan absolut, editor, Git (`git status`, diff, branch, commit), bedakan source, konfigurasi, data, build, dan test.

**Latihan:** buka `D:\Aplikasi\EWIApps`, masuk ke `backend`, kembali ke root; jalankan `git status`; temukan folder `frontend/lib` dan `backend/routes`. Buat catatan singkat di folder latihan.

**Lanjut jika:** dapat menjelaskan direktori kerja dan perubahan Git yang terlihat tanpa menjalankan perintah hapus/reset yang belum dipahami.

## Tahap 1 — Logika pemrograman

Belajar input → proses → output, urutan instruksi, kondisi, pengulangan, dan memecah masalah menjadi fungsi kecil.

**Latihan:** dari tiga nominal pengeluaran, hitung jumlah dan sisa anggaran; tentukan apakah anggaran terlampaui. Tulis langkah dalam bahasa biasa sebelum mengetik kode.

## Tahap 2 — Python dari dasar

Belajar urut: menjalankan Python; variabel dan tipe (`str`, `int`, `float`, `bool`, `None`); operator; string/f-string; `if`; loop `for`/`while`; list, tuple, set, dict; indeks dan iterasi; fungsi, parameter, `return`; comprehension setelah loop biasa; exception dan traceback; baca/tulis file; JSON; modul/import; type hints; `datetime` dan UTC.

**Latihan:** program terminal pencatat pengeluaran. Setiap catatan punya tanggal, kategori, deskripsi, dan nominal. Bisa menambah, menyimpan ke JSON, memuat kembali, dan menghitung total per kategori. Tangani file JSON rusak dengan pesan jelas.

**Lanjut jika:** mampu menulis fungsi sederhana, memilih struktur data, serta menjelaskan error dasar dari traceback.

## Tahap 3 — Python untuk proyek

Pelajari class/object secukupnya, composition, virtual environment, package dan `requirements.txt`, environment variables, logging, pemisahan modul, linting, dan `pytest`. Jangan memakai class jika fungsi sederhana sudah jelas; jangan mencatat secret ke log.

**Latihan:** pecah pencatat pengeluaran menjadi beberapa modul; buat test total normal, daftar kosong, dan nominal tidak valid.

**Codebase:** aturan lint ada di `backend/ruff.toml`; test ada di `backend/tests/`.

**Lanjut jika:** dapat menjalankan satu test dan semua test backend, serta memahami assertion yang gagal.

## Tahap 4 — Web, HTTP, JSON, dan SQL sebelum FastAPI

Pelajari client-server; URL, host, path, path parameter dan query; method `GET`, `POST`, `PUT`, `PATCH`, `DELETE`; header dan body; JSON; status `200`, `201`, `204`, `400`, `401`, `403`, `404`, `422`, `500`; REST; CORS; SQL tabel/baris/kolom, primary/foreign key, `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `JOIN`.

**Latihan:** tulis contoh request dan response untuk membaca kasbon, membuat kasbon, dan mengirim nominal yang tidak valid. Tandai URL, method, header/body, dan status.

**Lanjut jika:** dapat menjelaskan request-response tanpa menyebut framework.

## Tahap 5 — FastAPI dasar

Belajar satu demi satu:

1. Buat aplikasi latihan dan jalankan dengan Uvicorn.
2. Buka `/docs`; pahami dokumentasi OpenAPI.
3. Buat endpoint GET yang mengembalikan JSON.
4. Pahami `APIRouter`, prefix, tag, dan pemasangan router.
5. Path/query parameter serta validasi tipe.
6. Pydantic request schema: field wajib/opsional dan batas nilai.
7. Response model dan status code.
8. `HTTPException`, error yang diketahui, dan error server.
9. Dependency Injection dengan `Depends`.
10. Session database sebagai dependency.
11. Middleware/CORS setelah alur normal paham.
12. Upload `UploadFile`, download, validasi konten dan keamanan path.
13. Sync vs async; jangan mengganti fungsi menjadi `async` tanpa alasan.
14. Test endpoint.

**Latihan:** API pengeluaran in-memory dengan list, detail, tambah; buat test sukses, data tak ada, payload invalid.

**Codebase:** aplikasi `backend/main.py`; route `backend/routes/`; schema `backend/schemas/`; aturan bisnis `backend/services/`; utility `backend/utils/`.

**Lanjut jika:** dapat mengikuti request route → validasi → hasil response dan menjelaskan statusnya.

## Tahap 6 — Database dan migrasi

Urutannya: SQL dasar; ORM/model/kolom/relasi; engine dan session; query ORM; transaksi, `commit`/`rollback`; constraint dan indeks; PostgreSQL; konfigurasi koneksi via environment; Alembic revision, review migrasi, upgrade/downgrade. ORM tetap menghasilkan SQL. Migrasi jangan dijadikan latihan di database penting; pastikan target benar dan prosedur backup dipahami.

**Rujukan:** `backend/core/database.py`, `backend/models/`, `backend/migrations/`. Adapter internal pada `backend/models/base.py` dan `backend/core/database.py` adalah kompatibilitas proyek, bukan Flask-SQLAlchemy.

**Latihan:** gunakan database lokal latihan untuk membuat tabel catatan, simpan/baca satu data, dan uji rollback.

**Lanjut jika:** paham perbedaan perubahan di session dengan transaksi yang telah di-commit.

## Tahap 7 — Auth dan keamanan

Pelajari setelah HTTP, FastAPI, dan database: authentication vs authorization; hashing password; bearer token; JWT claims, signature, expiry (payload JWT bukan rahasia); role; dependency auth; `401` vs `403`; secret environment; validasi upload; jangan log password/token. JWT memang digunakan aplikasi dan tidak berarti Flask masih digunakan. Jangan ubah format atau secret token aplikasi sebagai latihan.

**Codebase:** `backend/utils/auth_helper.py`, route auth, serta dependency di `backend/routes/`.

**Latihan:** gambar alur login → token → header `Authorization` → pemeriksaan user/role → response terproteksi.

## Tahap 8 — Test dan Git saat mengubah backend

Sebelum mengedit, baca pemanggil dan test terkait. Buat perubahan kecil, tambah test regresi, jalankan test relevan lalu `backend/tests`, baca traceback, tinjau diff, periksa file rahasia/data ikut berubah atau tidak. Untuk API, pastikan Flutter cocok dengan response.

**Lanjut jika:** dapat menjelaskan perilaku lama, bug, perubahan, dan test yang membuktikan perbaikan.

## Tahap 9 — Dart dari nol

Belajar variabel, tipe, `final`/`const`; operator dan string; kondisi/loop; `List<T>` dan `Map<K,V>`; fungsi/parameter bernama; class/constructor/enum; null safety (`?`, `!`, `??`, `late`); import; JSON model; `Future`, `async`/`await`; `Stream` belakangan.

**Latihan:** ubah daftar JSON transaksi contoh menjadi object Dart dan hitung total per kategori.

**Lanjut jika:** bisa membaca signature fungsi dan menjelaskan mengapa jaringan mengembalikan `Future`.

## Tahap 10 — Flutter UI dan state

Urut: `main()`/`runApp`; widget tree; `StatelessWidget`/`StatefulWidget`; `BuildContext` dan layout constraints; `Scaffold`, `Row`, `Column`, `Expanded`, `ListView`; input/form/validasi; loading, empty, error; tombol/dialog/navigasi; tema dan responsive UI; Provider (`ChangeNotifier`, `notifyListeners`, `context.watch/read`, `Consumer`); state ownership dan `dispose`; widget test.

**Codebase:** `frontend/lib/main.dart`, `frontend/lib/screens/`, `frontend/lib/widgets/`, `frontend/lib/providers/`.

**Latihan:** halaman daftar transaksi statis dengan kondisi loading, daftar, kosong, dan error sebelum memakai API.

## Tahap 11 — Flutter ke FastAPI

Belajar HTTP client; base URL; method/header/timeout; encode/decode JSON; status/error; Future dan loading state; bearer token/logout; pemisahan UI → provider/controller → API service; query/filter; multipart upload/download; konfigurasi URL untuk web/emulator/desktop; cocokkan nama field dengan schema backend. CORS adalah aturan browser, bukan autentikasi.

**Codebase:** `frontend/lib/services/` (contoh `api_advances.dart`), provider `frontend/lib/providers/`, screen `frontend/lib/screens/`, model `frontend/lib/models/`; pasangkan dengan route backend terkait.

**Latihan:** telusuri satu GET read-only dari widget sampai route dan balik ke UI. Gambar URL, header, response JSON, perubahan provider, dan tampilan.

## Tahap 12 — Telusuri codebase, jangan baca semuanya sekaligus

Pilih satu fitur kecil, misalnya melihat daftar kasbon:

1. Baca `backend/main.py` untuk app, middleware, dan router.
2. Cari route fitur di `backend/routes/`.
3. Ikuti schema, dependency/auth, service, model, dan response.
4. Temukan test relevan di `backend/tests/`.
5. Cari screen/provider/service/model Flutter yang memanggil API itu.
6. Cocokkan field JSON frontend dan backend.
7. Tulis alur dengan nama fungsi/file aktual.
8. Setelah paham alur baca, pelajari form/tambah; settlement dan upload bukti belakangan.

**Siap mengubah fitur jika:** tahu sumber data, validasi, aturan bisnis, penyimpanan, izin, response, Flutter pemakai, dan test yang harus dijalankan.

## Tahap 13 — Materi khusus setelah dasar

Pelajari saat dibutuhkan: storage/upload (`backend/utils/storage.py`), Excel/PDF dan binary response, worker (`backend/utils/deadline_worker.py`), logging/debugging, izin file per platform, query performance, index, pagination, aksesibilitas, deployment. Pandas/NumPy dan optimasi bukan prasyarat memahami alur aplikasi.

## Urutan wajib singkat

1. Terminal dan Git → 2. Logika → 3. Python dasar/JSON → 4. Modul/type hints/pytest → 5. HTTP/JSON/SQL → 6. FastAPI/Pydantic/test → 7. SQLAlchemy/PostgreSQL/Alembic → 8. Auth/keamanan → 9. Dart/asynchronous → 10. Flutter UI → 11. Provider/test Flutter → 12. Integrasi API/upload → 13. Satu fitur ujung-ke-ujung → 14. Perubahan kecil dengan test.

## Checklist sebelum perubahan nyata

- [ ] Bisa menjalankan app/test tanpa menyentuh database penting.
- [ ] Tahu route dan request/response yang terlibat.
- [ ] Tahu screen, provider/controller, dan service Flutter terkait.
- [ ] Paham schema, model, aturan bisnis, serta permission.
- [ ] Tahu test yang perlu ditambah/dijalankan.
- [ ] Bisa menjelaskan seluruh diff.
- [ ] Tidak ada secret, database lokal, upload, atau perubahan tak terkait pada diff.

## Prompt belajar

```text
Bimbing saya mengikuti docs/kurikulum_skill_python_flutter.md dari tahap yang sedang saya pelajari. Anggap saya pemula. Jelaskan satu konsep dengan bahasa sederhana, beri contoh kecil untuk saya ketik, lalu beri latihan tanpa langsung memberi jawaban. Periksa jawaban saya dan jangan melompat ke tahap berikutnya sebelum saya paham. Hubungkan ke codebase EWIApps setelah dasar konsep dikuasai. Jangan gunakan Flask atau database penting untuk latihan.
```
