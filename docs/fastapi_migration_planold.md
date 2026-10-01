# Rencana & Inventaris Lengkap Migrasi: Flask ke FastAPI (Zero-Flask)

Dokumen ini adalah cetak biru teknis (*technical blueprint*) dan **daftar inventaris lengkap per file** untuk menghapus seluruh ketergantungan **Flask** dan menggantinya 100% dengan **FastAPI** pada project **MiniProjectKPI_EWI_Revisi2**.

---

## 1. Ringkasan Total File yang Terlibat

Berdasarkan audit pemindaian seluruh direktori `backend/`:

| Kategori | Jumlah File | Keterangan |
| :--- | :---: | :--- |
| **Routes (Controller)** | **33 file** | Blueprint, `request`, `jsonify`, `@jwt_required` |
| **Services (Business Logic)** | **12 file** | Pembersihan *web leak* (`request`, `jsonify`, `send_file`, `g`) |
| **Models & Database** | **6 file** | Pelepasan `flask_sqlalchemy` ke `SQLAlchemy 2.0` murni |
| **Utils & Helpers** | **4 file** | Pembersihan `current_app`, `get_jwt_identity`, dsb. |
| **Entry Point & Config** | **2 file** | Penggantian `app.py` ke `main.py` & penyesuaian `config.py` |
| **File Baru yang Akan Dibuat** | **4 file** | `main.py`, `core/security.py`, `core/database.py`, `schemas/` |
| **TOTAL FILE AKTIF** | **61 file** | Terdata lengkap di bawah |

---

## 2. Inventaris Lengkap Setiap File yang Harus Diubah

### A. Kelompok Database & Model (`backend/models/`) — 6 File

| No | Path File | Kode Flask yang Dihapus | Kode FastAPI / SQLAlchemy Pengganti | Aksi |
| :---: | :--- | :--- | :--- | :---: |
| 1 | [models/base.py](file:///D:/Aplikasi/EWIApps/backend/models/base.py) | `from flask_sqlalchemy import SQLAlchemy`<br>`db = SQLAlchemy()` | `from sqlalchemy.orm import DeclarativeBase`<br>`class Base(DeclarativeBase): pass`<br>Engine & `SessionLocal` | **UBAH TOTAL** |
| 2 | [models/core.py](file:///D:/Aplikasi/EWIApps/backend/models/core.py) | `class Company(db.Model)`<br>`id = db.Column(...)` | `class Company(Base)`<br>`id: Mapped[int] = mapped_column(...)` atau `Column(...)` | **UBAH** |
| 3 | [models/transaction.py](file:///D:/Aplikasi/EWIApps/backend/models/transaction.py) | `db.Model`, `db.relationship`, `db.ForeignKey` | `Base`, `relationship`, `ForeignKey` murni dari `sqlalchemy.orm` | **UBAH** |
| 4 | [models/banking.py](file:///D:/Aplikasi/EWIApps/backend/models/banking.py) | `db.Model`, `db.Column` | `Base`, `Column` murni SQLAlchemy | **UBAH** |
| 5 | [models/system.py](file:///D:/Aplikasi/EWIApps/backend/models/system.py) | `db.Model`, `db.Column` | `Base`, `Column` murni SQLAlchemy | **UBAH** |
| 6 | [models/__init__.py](file:///D:/Aplikasi/EWIApps/backend/models/__init__.py) | Export `db` dari `flask_sqlalchemy` | Export `Base`, `engine`, `SessionLocal`, dan semua model entitas | **UBAH** |

---

### B. Kelompok Routes / API Endpoints (`backend/routes/`) — 33 File

Setiap file di bawah mengubah:
* `from flask import Blueprint, jsonify, request` ➡️ `from fastapi import APIRouter, Depends, Query, HTTPException`
* `@jwt_required()` & `get_jwt_identity()` ➡️ `current_user: User = Depends(get_current_user)`
* `return jsonify(data), 200` ➡️ `return data`

#### 1. Core Routes (4 File)
| No | Path File | Import Flask Lama | Pengganti di FastAPI |
| :---: | :--- | :--- | :--- |
| 7 | [routes/core/auth.py](file:///D:/Aplikasi/EWIApps/backend/routes/core/auth.py) | `Blueprint`, `request`, `jsonify`, `create_access_token`, `flask_mail` | `APIRouter`, Pydantic LoginSchema, `core.security.create_access_token` |
| 8 | [routes/core/dashboard.py](file:///D:/Aplikasi/EWIApps/backend/routes/core/dashboard.py) | `Blueprint`, `jsonify`, `request`, `jwt_required`, `get_jwt_identity` | `APIRouter`, `Depends(get_current_user)`, `Depends(get_db)` |
| 9 | [routes/core/notifications.py](file:///D:/Aplikasi/EWIApps/backend/routes/core/notifications.py) | `Blueprint`, `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | `APIRouter`, `Depends(get_current_user)` |
| 10 | [routes/core/cleanup.py](file:///D:/Aplikasi/EWIApps/backend/routes/core/cleanup.py) | `Blueprint`, `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | `APIRouter`, `Depends(get_current_user)` |

#### 2. Advances Routes (6 File)
| No | Path File | Import Flask Lama | Pengganti di FastAPI |
| :---: | :--- | :--- | :--- |
| 11 | [routes/advances/advances.py](file:///D:/Aplikasi/EWIApps/backend/routes/advances/advances.py) | `Blueprint` | `router = APIRouter(prefix="/advances", tags=["Advances"])` |
| 12 | [routes/advances/advances_crud.py](file:///D:/Aplikasi/EWIApps/backend/routes/advances/advances_crud.py) | `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | Pydantic Schema, `Depends(get_current_user)`, `Depends(get_db)` |
| 13 | [routes/advances/advances_approval.py](file:///D:/Aplikasi/EWIApps/backend/routes/advances/advances_approval.py) | `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | Pydantic ApprovalSchema, `Depends(get_current_user)` |
| 14 | [routes/advances/advances_disbursement.py](file:///D:/Aplikasi/EWIApps/backend/routes/advances/advances_disbursement.py) | `current_app`, `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | Pydantic DisbursementSchema, `Depends(get_db)` |
| 15 | [routes/advances/advances_items.py](file:///D:/Aplikasi/EWIApps/backend/routes/advances/advances_items.py) | `current_app`, `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | `APIRouter` endpoint items, return dict |
| 16 | [routes/advances/advances_other.py](file:///D:/Aplikasi/EWIApps/backend/routes/advances/advances_other.py) | `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | Pydantic schemas, `Depends(get_current_user)` |

#### 3. Settlements Routes (6 File)
| No | Path File | Import Flask Lama | Pengganti di FastAPI |
| :---: | :--- | :--- | :--- |
| 17 | [routes/settlements/settlements.py](file:///D:/Aplikasi/EWIApps/backend/routes/settlements/settlements.py) | `Blueprint` | `router = APIRouter(prefix="/settlements", tags=["Settlements"])` |
| 18 | [routes/settlements/settlements_crud.py](file:///D:/Aplikasi/EWIApps/backend/routes/settlements/settlements_crud.py) | `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | Pydantic SettlementCreateSchema, `Depends(get_db)` |
| 19 | [routes/settlements/settlements_approval.py](file:///D:/Aplikasi/EWIApps/backend/routes/settlements/settlements_approval.py) | `jsonify`, `request`, `jwt_required` | `Depends(get_current_user)`, role check dependency |
| 20 | [routes/settlements/settlements_disbursement.py](file:///D:/Aplikasi/EWIApps/backend/routes/settlements/settlements_disbursement.py) | `current_app`, `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | Pydantic DisbursementSchema, `Depends(get_db)` |
| 21 | [routes/settlements/settlements_expenses.py](file:///D:/Aplikasi/EWIApps/backend/routes/settlements/settlements_expenses.py) | `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | `UploadFile = File(...)` untuk bukti kuitansi, Pydantic |
| 22 | [routes/settlements/settlements_other.py](file:///D:/Aplikasi/EWIApps/backend/routes/settlements/settlements_other.py) | `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | Pydantic schemas, `Depends(get_current_user)` |

#### 4. Transactions Routes (4 File)
| No | Path File | Import Flask Lama | Pengganti di FastAPI |
| :---: | :--- | :--- | :--- |
| 23 | [routes/transactions/revenues.py](file:///D:/Aplikasi/EWIApps/backend/routes/transactions/revenues.py) | `Blueprint`, `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | `APIRouter`, Pydantic RevenueSchema, `Depends(get_db)` |
| 24 | [routes/transactions/expenses.py](file:///D:/Aplikasi/EWIApps/backend/routes/transactions/expenses.py) | `Blueprint`, `current_app`, `jsonify`, `request`, `send_from_directory` | `APIRouter`, `FileResponse` untuk download bukti, Pydantic |
| 25 | [routes/transactions/assets.py](file:///D:/Aplikasi/EWIApps/backend/routes/transactions/assets.py) | `Blueprint`, `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | `APIRouter`, Pydantic AssetSchema, `Depends(get_db)` |
| 26 | [routes/transactions/dividends.py](file:///D:/Aplikasi/EWIApps/backend/routes/transactions/dividends.py) | `Blueprint`, `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | `APIRouter`, Pydantic DividendSchema, `Depends(get_db)` |

#### 5. Master Data Routes (5 File)
| No | Path File | Import Flask Lama | Pengganti di FastAPI |
| :---: | :--- | :--- | :--- |
| 27 | [routes/master_data/companies.py](file:///D:/Aplikasi/EWIApps/backend/routes/master_data/companies.py) | `Blueprint`, `request`, `jsonify`, `jwt_required`, `get_jwt_identity` | `APIRouter`, CompanySchema, `Depends(get_db)` |
| 28 | [routes/master_data/categories.py](file:///D:/Aplikasi/EWIApps/backend/routes/master_data/categories.py) | `Blueprint`, `jsonify`, `request`, `current_app`, `get_jwt_identity` | `APIRouter`, CategorySchema, `Depends(get_db)` |
| 29 | [routes/master_data/bank_management.py](file:///D:/Aplikasi/EWIApps/backend/routes/master_data/bank_management.py) | `Blueprint`, `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | `APIRouter`, BankAccountSchema, `Depends(get_db)` |
| 30 | [routes/master_data/bank_status.py](file:///D:/Aplikasi/EWIApps/backend/routes/master_data/bank_status.py) | `Blueprint`, `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | `APIRouter`, BankStatusSchema, `Depends(get_db)` |
| 31 | [routes/master_data/taxes.py](file:///D:/Aplikasi/EWIApps/backend/routes/master_data/taxes.py) | `Blueprint`, `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | `APIRouter`, TaxSchema, `Depends(get_db)` |

#### 6. Reports Routes (4 File)
| No | Path File | Import Flask Lama | Pengganti di FastAPI |
| :---: | :--- | :--- | :--- |
| 32 | [routes/reports/__init__.py](file:///D:/Aplikasi/EWIApps/backend/routes/reports/__init__.py) | `Blueprint` | `router = APIRouter(prefix="/reports", tags=["Reports"])` |
| 33 | [routes/reports/annual.py](file:///D:/Aplikasi/EWIApps/backend/routes/reports/annual.py) | `current_app`, `jsonify`, `request`, `send_file`, `get_jwt_identity` | `APIRouter`, Query parameters (`year: int`), `Depends(get_db)` |
| 34 | [routes/reports/annual_excel.py](file:///D:/Aplikasi/EWIApps/backend/routes/reports/annual_excel.py) | `current_app`, `request` | `FileResponse` (menghasilkan download Excel KPI murni) |
| 35 | [routes/reports/summary.py](file:///D:/Aplikasi/EWIApps/backend/routes/reports/summary.py) | `current_app`, `jsonify`, `request`, `send_file`, `jwt_required` | `APIRouter`, `FileResponse` untuk file summary/PDF |

#### 7. Settings Routes (4 File)
| No | Path File | Import Flask Lama | Pengganti di FastAPI |
| :---: | :--- | :--- | :--- |
| 36 | [routes/settings/__init__.py](file:///D:/Aplikasi/EWIApps/backend/routes/settings/__init__.py) | `Blueprint` | `router = APIRouter(prefix="/settings", tags=["Settings"])` |
| 37 | [routes/settings/profile.py](file:///D:/Aplikasi/EWIApps/backend/routes/settings/profile.py) | `current_app`, `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | `APIRouter`, ProfileUpdateSchema, `Depends(get_current_user)` |
| 38 | [routes/settings/deadline.py](file:///D:/Aplikasi/EWIApps/backend/routes/settings/deadline.py) | `current_app`, `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | `APIRouter`, DeadlineSchema, `Depends(get_db)` |
| 39 | [routes/settings/db_storage.py](file:///D:/Aplikasi/EWIApps/backend/routes/settings/db_storage.py) | `current_app`, `jsonify`, `request`, `get_jwt_identity`, `jwt_required` | `APIRouter`, StorageInfoSchema |

---

### C. Kelompok Services (Pembersihan Web Leak) — 12 File

File-file di bawah saat ini tercemar import web Flask. Harus diubah menjadi **murni fungsi Python** yang menerima argumen eksplisit dan mengembalikan dictionary/objek:

| No | Path File | Import Flask yang Dihapus | Perbaikan Bersih |
| :---: | :--- | :--- | :--- |
| 40 | [services/advances/advance_approval_service.py](file:///D:/Aplikasi/EWIApps/backend/services/advances/advance_approval_service.py) | `current_app`, `jsonify`, `request`, `get_jwt_identity` | Terima `user_id: int, db: Session` sebagai parameter; return dict biasa |
| 41 | [services/advances/advance_items_service.py](file:///D:/Aplikasi/EWIApps/backend/services/advances/advance_items_service.py) | `current_app`, `jsonify`, `request`, `get_jwt_identity` | Terima `item_data: dict, db: Session`; return dict biasa |
| 42 | [services/core/auth_service.py](file:///D:/Aplikasi/EWIApps/backend/services/core/auth_service.py) | `request`, `jsonify`, `create_access_token` (Flask-JWT) | Panggil `core.security.create_access_token` mandiri |
| 43 | [services/core/email_service.py](file:///D:/Aplikasi/EWIApps/backend/services/core/email_service.py) | `from flask_mail import Mail, Message`<br>`from flask import current_app` | Gunakan `smtplib` bawaan Python atau `fastapi-mail`; baca config via `config.py` |
| 44 | [services/core/storage_service.py](file:///D:/Aplikasi/EWIApps/backend/services/core/storage_service.py) | `from flask import current_app` | Gunakan parameter folder upload atau baca dari `config.py` |
| 45 | [services/dto/transaction_dto.py](file:///D:/Aplikasi/EWIApps/backend/services/dto/transaction_dto.py) | `from flask import g, has_request_context` | Hapus ketergantungan `flask.g`; lewatkan company_id/user eksplisit |
| 46 | [services/reports/annual_service/annual_excel.py](file:///D:/Aplikasi/EWIApps/backend/services/reports/annual_service/annual_excel.py) | `from flask import current_app, request` | Buat murni generator path file Excel |
| 47 | [services/reports/annual_service/caching.py](file:///D:/Aplikasi/EWIApps/backend/services/reports/annual_service/caching.py) | `current_app`, `jsonify`, `request`, `send_file`, `get_jwt_identity` | Modul cache berbasis file/memory Python murni |
| 48 | [services/reports/annual_service/excel_generator.py](file:///D:/Aplikasi/EWIApps/backend/services/reports/annual_service/excel_generator.py) | `current_app`, `jsonify`, `request`, `send_file`, `jwt_required` | Return `file_path: str` murni (tanpa `send_file`) |
| 49 | [services/reports/summary_service/excel_generator.py](file:///D:/Aplikasi/EWIApps/backend/services/reports/summary_service/excel_generator.py) | `send_file`, `request`, `jsonify`, `current_app`, `get_jwt_identity` | Return `file_path: str` atau BytesIO murni |
| 50 | [services/reports/summary_service/pdf_generator.py](file:///D:/Aplikasi/EWIApps/backend/services/reports/summary_service/pdf_generator.py) | `send_file`, `request`, `jsonify`, `get_jwt_identity` | Return `pdf_path: str` murni |
| 51 | [services/settlements/settlement_approval_service.py](file:///D:/Aplikasi/EWIApps/backend/services/settlements/settlement_approval_service.py) | `current_app`, `jsonify`, `request`, `get_jwt_identity` | Terima `settlement_id: int, user: User, db: Session`; return dict |

---

### D. Kelompok Utils & Helpers (`backend/utils/`) — 4 File

| No | Path File | Import Flask yang Dihapus | Perbaikan Bersih |
| :---: | :--- | :--- | :--- |
| 52 | [utils/auth_helper.py](file:///D:/Aplikasi/EWIApps/backend/utils/auth_helper.py) | `from flask import request, jsonify`<br>`from flask_jwt_extended import get_jwt_identity` | Diganti fungsi helper berbasis `User` instance dari FastAPI dependency |
| 53 | [utils/parsing_helper.py](file:///D:/Aplikasi/EWIApps/backend/utils/parsing_helper.py) | `from flask import current_app` | Gunakan logger standar `import logging` bawaan Python |
| 54 | [utils/report_helpers.py](file:///D:/Aplikasi/EWIApps/backend/utils/report_helpers.py) | `from flask import current_app` | Logger standar `logging.getLogger(__name__)` |
| 55 | [utils/storage.py](file:///D:/Aplikasi/EWIApps/backend/utils/storage.py) | `from flask import current_app` | Baca path direktori upload dari setting/env |

---

### E. Kelompok Entry Point & Konfigurasi — 2 File

| No | Path File | Keterangan | Aksi |
| :---: | :--- | :--- | :---: |
| 56 | [backend/app.py](file:///D:/Aplikasi/EWIApps/backend/app.py) | Dihapus / dihentikan setelah semua rute beralih ke `main.py` | **DEPRECATE / HAPUS** |
| 57 | [backend/config.py](file:///D:/Aplikasi/EWIApps/backend/config.py) | Disesuaikan agar mandiri tanpa `app.config` Flask | **UBAH** |

---

### F. File-File Baru yang Akan Dibuat — 4 File / Modul

| No | Path File Baru | Tanggung Jawab & Isi |
| :---: | :--- | :--- |
| 58 | **`backend/main.py`** | Server utama FastAPI, inisialisasi CORS, mount static files `/uploads`, include seluruh 33 APIRouter |
| 59 | **`backend/core/security.py`** | Helper hashing bcrypt (`pwd_context`), generate JWT (`jwt.encode`), decode JWT (`jwt.decode`), dan dependency `get_current_user` |
| 60 | **`backend/core/database.py`** | Inisialisasi engine SQLite, `sessionmaker(bind=engine)`, dan dependency injection `get_db()` |
| 61 | **`backend/schemas/`** *(Folder)* | Modul Pydantic untuk validasi skema request/response (Auth, Advance, Settlement, Transaction, Master Data) |

---

## 3. Contoh Detail Kode: Sebelum vs Sesudah

### Contoh 1: Database Model (`models/base.py`)
```python
# ==================== SEBELUM (FLASK) ====================
from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy()

class Company(db.Model):
    __tablename__ = 'companies'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)

# ==================== SESUDAH (FASTAPI) ====================
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column
from sqlalchemy import String

class Base(DeclarativeBase):
    pass

class Company(Base):
    __tablename__ = 'companies'
    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
```

### Contoh 2: Controller Rute (`routes/master_data/companies.py`)
```python
# ==================== SEBELUM (FLASK) ====================
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required
companies_bp = Blueprint('companies', __name__)

@companies_bp.route('/', methods=['POST'])
@jwt_required()
def create_company():
    data = request.json
    company = Company(name=data['name'])
    db.session.add(company)
    db.session.commit()
    return jsonify(company.to_dict()), 201

# ==================== SESUDAH (FASTAPI) ====================
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from core.database import get_db
from core.security import get_current_user
from schemas.company import CompanyCreateSchema, CompanyResponseSchema

router = APIRouter(prefix="/companies", tags=["Companies"])

@router.post("/", response_model=CompanyResponseSchema, status_code=status.HTTP_201_CREATED)
def create_company(payload: CompanyCreateSchema, db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    company = Company(name=payload.name)
    db.add(company)
    db.commit()
    db.refresh(company)
    return company
```

### Contoh 3: Download File Excel KPI (`routes/reports/annual_excel.py`)
```python
# ==================== SEBELUM (FLASK) ====================
from flask import send_file
@reports_bp.route('/annual-excel')
def download():
    path = generate_excel()
    return send_file(path, as_attachment=True)

# ==================== SESUDAH (FASTAPI) ====================
from fastapi.responses import FileResponse
@router.get('/annual-excel')
def download():
    path = generate_excel()
    return FileResponse(path, filename="KPI_Report.xlsx", media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
```

---

## 4. Urutan Eksekusi yang Direkomendasikan

1. **Langkah 1 (Fondasi Inti):**
   - Buat `backend/core/database.py` (engine & `get_db`).
   - Ubah `backend/models/base.py` menjadi SQLAlchemy 2.0 murni.
   - Buat `backend/core/security.py` (sistem auth JWT & password hash).
2. **Langkah 2 (Main App & Health Check):**
   - Buat `backend/main.py` dan jalankan via Uvicorn di port 8000 untuk memastikan server menyala.
3. **Langkah 3 (Migrasi Rute Bertahap per Modul):**
   - Urutan: **Auth** ➡️ **Master Data** ➡️ **Transactions** ➡️ **Advances** ➡️ **Settlements** ➡️ **Reports (Excel/KPI)** ➡️ **Settings**.
4. **Langkah 4 (Pembersihan Service):**
   - Bersihkan seluruh import Flask dari folder `services/` dan `utils/`.
5. **Langkah 5 (Verifikasi & Pengalihan):**
   - Cek semua endpoint di `http://127.0.0.1:8000/docs` (Swagger UI).
   - Ubah port di Flutter menjadi 8000.
   - Hapus `backend/app.py` lama.
