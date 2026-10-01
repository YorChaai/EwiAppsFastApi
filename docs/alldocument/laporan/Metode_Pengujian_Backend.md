# Panduan Pengujian & Audit Backend (Deep Scan) 🛡️

Dokumen ini merangkum teknik, script, dan alat yang digunakan untuk melakukan audit menyeluruh (deep scan) pada kode backend (Flask & SQLAlchemy) agar terbebas dari bug tersembunyi, kerentanan keamanan, dan duplikasi kode. Anda dapat menyimpan dan menjalankan perintah-perintah ini di masa depan untuk memastikan kualitas kode tetap prima.

---

## 1. Uji Keamanan Kode (Cybersecurity Scan)
**Tujuan:** Mendeteksi kerentanan seperti *SQL Injection*, *Hardcoded Passwords*, eksekusi kode berbahaya, dan konfigurasi kriptografi yang lemah.
**Alat yang Digunakan:** `bandit` (Scanner keamanan standar Python)

**Cara Menjalankan:**
```bash
pip install bandit
python -m bandit -r backend/routes/ -ll
```
*Catatan: Parameter `-ll` digunakan untuk menyaring dan hanya menampilkan peringatan berlevel Medium dan High.*

---

## 2. Uji Integritas Database (Missing Rollbacks Scan)
**Tujuan:** Mencegah terjadinya bug `PendingRollbackError` pada SQLAlchemy. Saat kita menggunakan `db.session.commit()` di dalam blok `try`, kita **wajib** meletakkan `db.session.rollback()` di dalam blok `except`. Jika tidak, koneksi database akan hang dan menolak operasi berikutnya.

**Alat yang Digunakan:** *Abstract Syntax Tree (AST)* Python.

**Script Deteksi Otomatis:**
Jalankan perintah ini di terminal (dari root proyek) untuk mencari `try/except` yang lupa di-rollback:
```python
python -c "import ast, os; files=[os.path.join(dp, f) for dp, dn, fn in os.walk('backend') if 'venv' not in dp for f in fn if f.endswith('.py')]; res=[]; [(res.append((f, node.lineno))) for f in files for tree in [ast.parse(open(f, encoding='utf-8-sig').read())] for node in ast.walk(tree) if isinstance(node, ast.Try) and any(isinstance(n, ast.Call) and getattr(n.func, 'attr', '') == 'commit' for b in node.body for n in ast.walk(b)) and not any(isinstance(n, ast.Call) and getattr(n.func, 'attr', '') == 'rollback' for h in node.handlers for n in ast.walk(h))]; print('Missing rollbacks:', res)"
```
*Jika outputnya tidak kosong, segera tambahkan `db.session.rollback()` di file dan baris yang tertera.*

---

## 3. Uji "Silent Crash" (Swallowed Exceptions Scan)
**Tujuan:** Mencari kode yang menggunakan `except Exception: pass`. Pola ini sangat berbahaya karena jika terjadi error (misalnya API pihak ketiga mati atau database penuh), aplikasi akan diam saja tanpa memberikan log error apa pun.

**Alat yang Digunakan:** Pencarian Regex / AST.

**Script Deteksi Otomatis:**
```python
python -c "import ast, os; files=[os.path.join(dp, f) for dp, dn, fn in os.walk('backend') if 'venv' not in dp for f in fn if f.endswith('.py')]; res=[]; [res.append((f, n.lineno)) for f in files for n in ast.walk(ast.parse(open(f, encoding='utf-8-sig').read())) if isinstance(n, ast.ExceptHandler) and n.type is None]; print('Bare excepts:', res)"
```

---

## 4. Uji Keamanan Endpoint (Missing Authentication Scan)
**Tujuan:** Memastikan tidak ada endpoint sensitif yang lupa diberikan dekorator pengaman seperti `@jwt_required()`.

**Alat yang Digunakan:** Analisis Dekorator via AST Python.

**Script Deteksi Otomatis:**
Perintah ini mencari rute Flask (`@bp.route`) yang tidak memiliki `@jwt_required`:
```python
python -c "import ast, os; files=[os.path.join(dp, f) for dp, dn, fn in os.walk('backend/routes') for f in fn if f.endswith('.py')]; res=[]; [res.append(f + ':' + n.name) for f in files for n in ast.walk(ast.parse(open(f, encoding='utf-8-sig').read())) if isinstance(n, ast.FunctionDef) and any(getattr(d.func, 'attr', '') == 'route' for d in n.decorator_list if isinstance(d, ast.Call)) and not any(getattr(d.func, 'id', '') == 'jwt_required' for d in n.decorator_list if isinstance(d, ast.Call))]; print('Routes missing jwt_required:', res)"
```
*Catatan: Wajar jika rute seperti login, register, dan reset_password muncul dalam daftar ini.*

---

## 5. Uji Kerapian Variabel & Sintaks (Linting)
**Tujuan:** Mendeteksi variabel yang dipanggil tetapi tidak pernah dibuat (*Undefined Variables*) atau library yang di-import tapi tidak pernah dipakai (*Unused Imports*). Hal ini membantu membersihkan memori (RAM) dan mencegah aplikasi *crash* tiba-tiba saat logika dijalankan.

**Alat yang Digunakan:** `flake8`

**Cara Menjalankan:**
```bash
pip install flake8
flake8 backend/routes/ --select=E9,F63,F7,F82,F401,F841 --show-source
```
*Penjelasan Kode Error:*
- `F821`: Undefined name (Variabel tidak ditemukan - KRITIS)
- `F401`: Module imported but unused (Import tidak dipakai - SAMPAH MEMORI)
- `F841`: Local variable is assigned to but never used (Variabel dibuat tapi diabaikan)

---

## 6. Uji Duplikasi Logika (Local Scope Duplication Scan)
**Tujuan:** Memastikan fungsi-fungsi bantuan (*helpers*) tidak ditulis berulang kali di berbagai file (misalnya di-*copy-paste*). Jika sebuah fungsi dibuat lebih dari sekali, jika ada perbaikan bug di masa depan, developer mungkin lupa memperbaiki salinan lainnya.

**Script Deteksi Otomatis:**
Mencari definisi fungsi (`def ...`) yang muncul di lebih dari 1 file aktif:
```python
python -c "import os, re; files=[os.path.join(dp, f) for dp, dn, fn in os.walk('backend') if all(x not in dp.split(os.sep) for x in ('venv', 'scratch', 'backup', '_archive', 'tools', 'scripts')) for f in fn if f.endswith('.py') and f != 'common_utils.py']; defs={}; [defs.setdefault(d, []).append(f) for f in files for d in re.findall(r'^def ([a-zA-Z0-9_]+)\(', open(f, encoding='utf-8-sig').read(), re.M)]; print({k:v for k,v in defs.items() if len(set(v)) > 1 and not k.startswith('test_') and not k.startswith('__') and k not in ['allowed_file', 'normalize_source', 'create_app']})"
```

---

Dengan menjalankan 6 metode di atas, kita telah memastikan bahwa backend berjalan dengan standar rekayasa perangkat lunak (Software Engineering) kelas atas.
