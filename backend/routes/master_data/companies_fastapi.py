"""Company management endpoints implemented with FastAPI and SQLAlchemy."""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from core.database import get_db
from core.security import get_current_user
from models import Company, User
from schemas.companies import CompanyOrderPayload, CompanyPayload

router = APIRouter(prefix="/api/companies", tags=["Companies"])


@router.get("")
def get_companies(
    _user: User = Depends(get_current_user), db: Session = Depends(get_db)
):
    items = db.query(Company).order_by(Company.sort_order.asc(), Company.created_at.asc()).all()
    return {"success": True, "data": [item.to_dict() for item in items]}


@router.post("", status_code=status.HTTP_201_CREATED)
def create_company(
    payload: CompanyPayload,
    _user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    name = payload.name.strip()
    if not name:
        raise HTTPException(status_code=400, detail="Nama perusahaan tidak boleh kosong")
    if db.query(Company).filter_by(name=name).first():
        raise HTTPException(status_code=409, detail="Perusahaan sudah ada")
    company = Company(name=name)
    db.add(company)
    try:
        db.commit()
        db.refresh(company)
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(status_code=409, detail="Perusahaan sudah ada") from exc
    return {"success": True, "company": company.to_dict()}


@router.put("/{company_id:int}")
def update_company(
    company_id: int,
    payload: CompanyPayload,
    _user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    name = payload.name.strip()
    if not name:
        raise HTTPException(status_code=400, detail="Nama perusahaan tidak boleh kosong")
    company = db.get(Company, company_id)
    if not company:
        raise HTTPException(status_code=404, detail="Perusahaan tidak ditemukan")
    duplicate = db.query(Company).filter(Company.name == name, Company.id != company_id).first()
    if duplicate:
        raise HTTPException(status_code=409, detail="Perusahaan dengan nama tersebut sudah ada")

    old_name = company.name
    company.name = name
    for user in db.query(User).all():
        if user.company_access and old_name in user.company_access:
            user.company_access = [name if item == old_name else item for item in user.company_access]
    try:
        db.commit()
        db.refresh(company)
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(status_code=409, detail="Perusahaan dengan nama tersebut sudah ada") from exc
    return {"success": True, "company": company.to_dict()}


@router.delete("/{company_id:int}")
def delete_company(
    company_id: int,
    _user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    company = db.get(Company, company_id)
    if not company:
        raise HTTPException(status_code=404, detail="Perusahaan tidak ditemukan")
    old_name = company.name
    for user in db.query(User).all():
        if user.company_access and old_name in user.company_access:
            user.company_access = [name for name in user.company_access if name != old_name]
    db.delete(company)
    db.commit()
    return {"success": True, "message": "Perusahaan berhasil dihapus"}


@router.put("/reorder")
def reorder_companies(
    payload: CompanyOrderPayload,
    _user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    for index, item in enumerate(payload.companies):
        company = db.get(Company, item.id)
        if company:
            company.sort_order = index
    db.commit()
    return {"success": True, "message": "Urutan berhasil disimpan"}
