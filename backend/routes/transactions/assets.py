from datetime import datetime

from fastapi import APIRouter, Body, Depends, Header, Query
from fastapi.responses import JSONResponse
from core.security import get_current_user
from models import Asset, User, db

assets_router = APIRouter(prefix="/api/assets", tags=["assets"])


@assets_router.get("")
def list_assets(
    as_of_date: str | None = Query(default=None),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    _user: User = Depends(get_current_user),
):
    # Remove year filtering for the Management list so all registered assets are visible
    # regardless of purchase date vs selected report year.
    company = company or "EWI Foundation"

    query = Asset.query.filter(Asset.company == company)
    assets = query.order_by(Asset.purchase_date.desc(), Asset.id.desc()).all()

    # Use our helper to calculate dynamic valuation
    from services.reports.data_fetcher.depreciation import _calculate_asset_depreciation

    asset_data = _calculate_asset_depreciation(assets, target_date=as_of_date)

    return {"assets": asset_data}


@assets_router.post("")
def create_asset(
    data: dict = Body(...),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    user: User = Depends(get_current_user),
):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)

    name = data.get("name")
    price = data.get("purchase_price")
    date_str = data.get("purchase_date")
    life = data.get("useful_life_months")
    company = company or "EWI Foundation"

    if not name or price is None or not date_str or not life:
        return JSONResponse({"error": "Data aset tidak lengkap"}, status_code=400)

    date = datetime.strptime(date_str, "%Y-%m-%d").date()

    # Asset Code uniqueness check
    asset_code = data.get("asset_code")
    if asset_code:
        existing = Asset.query.filter_by(asset_code=asset_code, company=company).first()
        if existing:
            return JSONResponse(
                {"error": f"Kode Aset '{asset_code}' sudah digunakan di perusahaan ini"},
                status_code=400,
            )

    asset = Asset(
        asset_code=asset_code,
        name=name,
        purchase_date=date,
        purchase_price=price,
        useful_life_months=life,
        residual_value=data.get("residual_value", 0.0),
        asset_type=data.get("asset_type"),
        status=data.get("status", "Active"),
        description=data.get("description"),
        company=company,
    )
    db.session.add(asset)
    db.session.commit()
    return JSONResponse(asset.to_dict(), status_code=201)


@assets_router.put("/{asset_id}")
def update_asset(
    asset_id: int,
    data: dict = Body(...),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    user: User = Depends(get_current_user),
):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)

    company = company or "EWI Foundation"
    asset = Asset.query.filter_by(id=asset_id, company=company).first_or_404()

    if "asset_code" in data:
        new_code = data["asset_code"]
        if new_code and new_code != asset.asset_code:
            existing = Asset.query.filter_by(
                asset_code=new_code, company=company
            ).first()
            if existing:
                return JSONResponse(
                    {
                        "error": f"Kode Aset '{new_code}' sudah digunakan di perusahaan ini"
                    },
                    status_code=400,
                )
        asset.asset_code = new_code

    asset.name = data.get("name", asset.name)
    if "purchase_date" in data:
        asset.purchase_date = datetime.strptime(
            data["purchase_date"], "%Y-%m-%d"
        ).date()
    asset.purchase_price = data.get("purchase_price", asset.purchase_price)
    asset.useful_life_months = data.get("useful_life_months", asset.useful_life_months)
    asset.residual_value = data.get("residual_value", asset.residual_value)
    asset.asset_type = data.get("asset_type", asset.asset_type)
    asset.status = data.get("status", asset.status)
    asset.description = data.get("description", asset.description)

    db.session.commit()
    return asset.to_dict()


@assets_router.delete("/{asset_id}")
def delete_asset(
    asset_id: int,
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    user: User = Depends(get_current_user),
):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)

    company = company or "EWI Foundation"
    asset = Asset.query.filter_by(id=asset_id, company=company).first_or_404()
    db.session.delete(asset)
    db.session.commit()
    return {"message": "Aset berhasil dihapus"}
