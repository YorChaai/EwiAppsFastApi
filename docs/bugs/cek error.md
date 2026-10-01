# Panduan Cek Error Project EWI

> **Start dari:** `PS C:\Windows\System32\WindowsPowerShell\v1.0>`

---

## STEP 0 — Pindah ke Folder Backend (WAJIB PERTAMA)

```powershell
cd "D:\Aplikasi\EWIApps\backend"
```

---

## STEP 1 — Py Compile (Cek Syntax Python)

Cek semua file `.py` di folder `routes/`:

```powershell
Get-ChildItem -Path "routes" -Recurse -Filter "*.py" | Where-Object { $_.FullName -notmatch "\\__pycache__\\" } | ForEach-Object { $r = python -m py_compile $_.FullName 2>&1; if ($r) { Write-Host "ERROR: $($_.Name)" -ForegroundColor Red; Write-Host $r } else { Write-Host "OK: $($_.Name)" -ForegroundColor Green } }
```

> ✅ Hasil OK = tidak ada syntax error  
> ❌ Hasil ERROR = ada typo / syntax yang salah di file tersebut

Cek file tertentu saja:

```powershell
python -m py_compile routes\assets.py
python -m py_compile scratch\scanner_fokus\scripts\generate_hybrid_migration_v3.py
```

> Kalau tidak ada output = **AMAN**

---

## STEP 2 — Ruff Check (Cek Gaya Penulisan Python)

Cek semua file di `routes/`:

```powershell
ruff check routes/
```

Auto-fix yang bisa diperbaiki otomatis:

```powershell
ruff check routes/ --fix
```

Cek file tertentu:

```powershell
ruff check routes\assets.py
ruff check scratch\scanner_fokus\scripts\generate_hybrid_migration_v3.py
```

> Kode error umum:
> - `E701/E702` = banyak statement dalam 1 baris (tidak berbahaya)
> - `F841` = variable dibuat tapi tidak dipakai
> - `F401` = import tidak dipakai

---

## STEP 3 — Pytest (Jalankan Unit Test)

```powershell
pytest -v
```

> `collected 0 items` = belum ada file test, tidak apa-apa  
> `PASSED` = test berhasil  
> `FAILED` = ada yang perlu diperbaiki

---

## BONUS — Flutter Analyze (Cek Dart/Flutter)

```powershell
cd "D:\Aplikasi\EWIApps\frontend"
flutter analyze
```

> `No issues found!` = semua OK  
> Ada warning `info` = tidak kritis  
> Ada `error` = harus diperbaiki sebelum build

---

## Urutan Lengkap (Satu-Satu)

```powershell
# 1. Masuk backend
cd "D:\Aplikasi\EWIApps\backend"

# 2. Py Compile
Get-ChildItem -Path "routes" -Recurse -Filter "*.py" | Where-Object { $_.FullName -notmatch "\\__pycache__\\" } | ForEach-Object { $r = python -m py_compile $_.FullName 2>&1; if ($r) { Write-Host "ERROR: $($_.Name)" -ForegroundColor Red; Write-Host $r } else { Write-Host "OK: $($_.Name)" -ForegroundColor Green } }

# 3. Ruff Check
ruff check routes/

# 4. Pytest
pytest -v

# 5. Flutter Analyze (pindah dulu)
cd "..\frontend"
flutter analyze
```
