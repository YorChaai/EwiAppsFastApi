from utils.parsing_helper import _parse_date, _parse_number_value, _parse_float_safe
import json
from datetime import datetime
from sqlalchemy import extract

from fastapi import APIRouter, Body, Depends, Header, Query
from fastapi.responses import JSONResponse
from core.security import get_current_user
from services.master_data.tax_service import _validate_manual_tax_group

from models import ManualCombineGroup, Tax, User, db

taxes_router = APIRouter(prefix="/api/taxes", tags=["taxes"])








@taxes_router.get("")
def get_taxes(
    start_date: str | None = Query(default=None),
    end_date: str | None = Query(default=None),
    year: int | None = Query(default=None),
    mode: str = Query(default="report"),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    _user: User = Depends(get_current_user),
):
    company = company or "EWI Foundation"

    query = Tax.query.filter(Tax.company == company)

    if year:
        if mode == "report":
            query = query.filter(
                db.or_(
                    Tax.report_year == year,
                    db.and_(
                        Tax.report_year.is_(None),
                        extract("year", Tax.date) == year,
                    ),
                )
            )
        else:
            query = query.filter(extract("year", Tax.date) == year)

    if start_date:
        parsed_start_date = _parse_date(start_date)
        if parsed_start_date:
            query = query.filter(Tax.date >= parsed_start_date)

    if end_date:
        parsed_end_date = _parse_date(end_date)
        if parsed_end_date:
            query = query.filter(Tax.date <= parsed_end_date)

    taxes = query.order_by(Tax.id.asc()).all()
    return [t.to_dict() for t in taxes]


@taxes_router.get("/{tax_id:int}")
def get_tax(tax_id: int, _user: User = Depends(get_current_user)):
    tax = Tax.query.get_or_404(tax_id)
    return tax.to_dict()


@taxes_router.post("")
def create_tax(
    data: dict = Body(default={}),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    user: User = Depends(get_current_user),
):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak."}, status_code=403)

    if not data:
        return JSONResponse({"error": "Must provide data"}, status_code=400)

    date = _parse_date(data.get("date"))
    description = data.get("description")
    transaction_value = data.get("transaction_value")

    if not date or not description or transaction_value is None:
        return JSONResponse(
            {"error": "date, description, and transaction_value are required"}, status_code=400
        )

    try:
        trans_val = _parse_float_safe(transaction_value, default=0.0)
        tax = Tax(
            date=date,
            description=description,
            transaction_value=trans_val if trans_val is not None else 0.0,
            invoice_value_usd=_parse_float_safe(data.get("invoice_value_usd")),
            transaction_value_idr=_parse_float_safe(data.get("transaction_value_idr")),
            currency=data.get("currency", "IDR") or "IDR",
            currency_exchange=_parse_float_safe(data.get("currency_exchange")),
            ppn=_parse_float_safe(data.get("ppn")),
            ppn_base=_parse_float_safe(data.get("ppn_base")),
            pph_21=_parse_float_safe(data.get("pph_21")),
            pph_21_base=_parse_float_safe(data.get("pph_21_base")),
            pph_23=_parse_float_safe(data.get("pph_23")),
            pph_23_base=_parse_float_safe(data.get("pph_23_base")),
            pph_26=_parse_float_safe(data.get("pph_26")),
            pph_26_base=_parse_float_safe(data.get("pph_26_base")),
            pemasukan_negara=_parse_float_safe(data.get("pemasukan_negara")),
            pemasukan_negara_base=_parse_float_safe(data.get("pemasukan_negara_base")),
            report_year=int(data.get("report_year") or date.year),
            company=company or "EWI Foundation",
        )
        db.session.add(tax)
        db.session.commit()
        return JSONResponse(tax.to_dict(), status_code=201)
    except Exception as e:
        db.session.rollback()
        return JSONResponse({"error": str(e)}, status_code=500)


@taxes_router.put("/{tax_id:int}")
def update_tax(tax_id: int, data: dict = Body(...), user: User = Depends(get_current_user)):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak."}, status_code=403)

    tax = Tax.query.get_or_404(tax_id)

    if "date" in data:
        parsed_d = _parse_date(data["date"])
        if parsed_d:
            tax.date = parsed_d
    if "description" in data:
        tax.description = str(data["description"] or "")
    if "transaction_value" in data:
        trans_val = _parse_float_safe(data["transaction_value"])
        if trans_val is not None:
            tax.transaction_value = trans_val
    if "invoice_value_usd" in data:
        tax.invoice_value_usd = _parse_float_safe(data["invoice_value_usd"])
    if "transaction_value_idr" in data:
        tax.transaction_value_idr = _parse_float_safe(data["transaction_value_idr"])
    if "currency" in data:
        tax.currency = data["currency"] or "IDR"
    if "currency_exchange" in data:
        tax.currency_exchange = _parse_float_safe(data["currency_exchange"])
    if "ppn" in data:
        tax.ppn = _parse_float_safe(data["ppn"])
    if "ppn_base" in data:
        tax.ppn_base = _parse_float_safe(data["ppn_base"])
    if "pph_21" in data:
        tax.pph_21 = _parse_float_safe(data["pph_21"])
    if "pph_21_base" in data:
        tax.pph_21_base = _parse_float_safe(data["pph_21_base"])
    if "pph_23" in data:
        tax.pph_23 = _parse_float_safe(data["pph_23"])
    if "pph_23_base" in data:
        tax.pph_23_base = _parse_float_safe(data["pph_23_base"])
    if "pph_26" in data:
        tax.pph_26 = _parse_float_safe(data["pph_26"])
    if "pph_26_base" in data:
        tax.pph_26_base = _parse_float_safe(data["pph_26_base"])
    if "pemasukan_negara" in data:
        tax.pemasukan_negara = _parse_float_safe(data["pemasukan_negara"])
    if "pemasukan_negara_base" in data:
        tax.pemasukan_negara_base = _parse_float_safe(data["pemasukan_negara_base"])
    if "report_year" in data:
        try:
            tax.report_year = int(data["report_year"]) if data["report_year"] else tax.date.year
        except (ValueError, TypeError):
            pass

    try:
        db.session.commit()
        return tax.to_dict()
    except Exception as e:
        db.session.rollback()
        return JSONResponse({"error": str(e)}, status_code=500)


@taxes_router.delete("/{tax_id:int}")
def delete_tax(tax_id: int, user: User = Depends(get_current_user)):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak."}, status_code=403)

    tax = Tax.query.get_or_404(tax_id)
    try:
        # Hapus combine groups yang mengandung row ini
        groups_to_delete = []
        groups_to_update = []
        for group in ManualCombineGroup.query.filter_by(table_name="taxes").all():
            row_ids = group.row_ids()
            if tax_id in row_ids:
                if len(row_ids) <= 2:
                    # Hanya 2 row, hapus group saja
                    groups_to_delete.append(group)
                else:
                    # Lebih dari 2, hapus ID dari group
                    new_row_ids = [rid for rid in row_ids if rid != tax_id]
                    group.row_ids_json = json.dumps(new_row_ids)
                    groups_to_update.append(group)

        for group in groups_to_delete:
            db.session.delete(group)
        for group in groups_to_update:
            db.session.add(group)

        db.session.delete(tax)
        db.session.commit()
        return {"message": "Tax deleted"}
    except Exception as e:
        db.session.rollback()
        return JSONResponse({"error": str(e)}, status_code=500)


@taxes_router.get("/combine-groups")
def get_tax_combine_groups(year: int | None = Query(default=None), _user: User = Depends(get_current_user)):
    if not year:
        return JSONResponse({"error": "year is required"}, status_code=400)

    groups = (
        ManualCombineGroup.query.filter_by(
            table_name="taxes",
            report_year=year,
        )
        .order_by(ManualCombineGroup.group_date.asc(), ManualCombineGroup.id.asc())
        .all()
    )
    return [group.to_dict() for group in groups]


@taxes_router.post("/combine-groups")
def create_tax_combine_group(
    data: dict = Body(default={}),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    user: User = Depends(get_current_user),
):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak."}, status_code=403)

    year = data.get("year")
    row_ids = data.get("row_ids") or []
    merged_columns = data.get("merged_columns") or []
    overrides = data.get("overrides") or {}

    company = company or "EWI Foundation"
    validated, error = _validate_manual_tax_group(year, row_ids, company)
    if error:
        return JSONResponse({"error": error}, status_code=400)

    # Backup data asli
    original_data = {}
    taxes = []
    for rid in row_ids:
        tx = Tax.query.get(rid)
        if tx:
            taxes.append(tx)
            original_data[str(rid)] = {
                "date": tx.date.isoformat() if tx.date else None,
                "description": tx.description,
                "transaction_value": tx.transaction_value,
                "invoice_value_usd": tx.invoice_value_usd,
                "transaction_value_idr": tx.transaction_value_idr,
                "currency": tx.currency,
                "currency_exchange": tx.currency_exchange,
                "ppn": tx.ppn,
                "ppn_base": tx.ppn_base,
                "pph_21": tx.pph_21,
                "pph_21_base": tx.pph_21_base,
                "pph_23": tx.pph_23,
                "pph_23_base": tx.pph_23_base,
                "pph_26": tx.pph_26,
                "pph_26_base": tx.pph_26_base,
                "pemasukan_negara": tx.pemasukan_negara,
                "pemasukan_negara_base": tx.pemasukan_negara_base,
            }

    # Terapkan override & nol-kan
    if taxes:
        primary_tx = taxes[0]
        for col in merged_columns:
            val = overrides.get(col)
            if val is not None:
                if col == "date":
                    try:
                        primary_tx.date = datetime.strptime(val, "%Y-%m-%d").date()
                    except:
                        pass
                elif col in ["currency", "description"]:
                    setattr(primary_tx, col, val)
                else:
                    parsed_num = _parse_number_value(val)
                    if parsed_num is not None:
                        setattr(primary_tx, col, parsed_num)

            for other_tx in taxes[1:]:
                if col == "date":
                    # date is NOT NULL, we can't set to None. Keep it.
                    pass
                elif col in ["currency", "description"]:
                    setattr(other_tx, col, "")
                else:
                    setattr(other_tx, col, 0.0)

    group = ManualCombineGroup(
        table_name="taxes",
        report_year=int(year),
        group_date=validated["group_date"],
        row_ids_json=json.dumps(row_ids),
        merged_columns_json=json.dumps(merged_columns),
        original_data_json=json.dumps(original_data),
    )
    try:
        db.session.add(group)
        db.session.commit()
        return JSONResponse(group.to_dict(), status_code=201)
    except Exception as e:
        db.session.rollback()
        return JSONResponse({"error": str(e)}, status_code=500)


@taxes_router.delete("/combine-groups/{group_id}")
def delete_tax_combine_group(group_id: int, user: User = Depends(get_current_user)):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak."}, status_code=403)

    group = ManualCombineGroup.query.filter_by(
        id=group_id,
        table_name="taxes",
    ).first_or_404()

    try:
        # Restore data asli
        original_data = json.loads(group.original_data_json or "{}")
        for rid_str, fields in original_data.items():
            tx = Tax.query.get(int(rid_str))
            if tx:
                for col, val in fields.items():
                    if col == "date" and val:
                        try:
                            tx.date = datetime.strptime(val[:10], "%Y-%m-%d").date()
                        except:
                            pass
                    else:
                        setattr(tx, col, val)

        db.session.delete(group)
        db.session.commit()
        return {"message": "Tax combine group deleted"}
    except Exception as e:
        db.session.rollback()
        return JSONResponse({"error": str(e)}, status_code=500)
