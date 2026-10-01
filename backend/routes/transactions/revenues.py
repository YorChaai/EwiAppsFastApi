from utils.parsing_helper import _parse_date, _parse_number_value, _parse_float_safe
import json
from datetime import datetime
from sqlalchemy import extract

from fastapi import APIRouter, Body, Depends, Header, Request
from fastapi.responses import JSONResponse
from core.security import get_current_user
from services.transactions.revenue_service import _validate_manual_revenue_group

from models import BankTransaction, ManualCombineGroup, Revenue, User, db

revenues_router = APIRouter(prefix="/api/revenues", tags=["Revenues"])


def sync_revenue_bank_transaction(revenue, user_id=None, is_delete=False):
    """
    Sinkronisasi transaksi income pada Bank Cash (BankTransaction) berdasarkan pilihan sumber dana (bank_id) pada Revenue.
    - Jika revenue dihapus atau bank_id None/kosong: hapus BankTransaction terkait.
    - Jika bank_id ada: buat baru atau perbarui BankTransaction (income) di rekening bank tersebut.
    """
    existing_bt = BankTransaction.query.filter_by(revenue_id=revenue.id).first()

    if is_delete or not revenue.bank_id:
        if existing_bt:
            db.session.delete(existing_bt)
        return

    # Ambil nominal uang masuk (prioritas amount_received_idr, jika kosong fallback ke amount_received atau invoice_value)
    amount_idr = revenue.idr_amount_received
    if amount_idr is None or amount_idr == 0:
        amount_idr = revenue.idr_invoice_value or 0.0

    amount_usd = revenue.amount_received_usd
    if amount_usd is None or amount_usd == 0:
        amount_usd = revenue.invoice_value_usd or 0.0

    tx_date = revenue.receive_date or revenue.invoice_date
    effective_user_id = user_id or getattr(revenue, "user_id", None)

    if existing_bt:
        existing_bt.bank_id = revenue.bank_id
        existing_bt.date = tx_date
        existing_bt.description = f"Penerimaan Revenue: {revenue.description}"
        existing_bt.amount_idr = float(amount_idr)
        existing_bt.amount_usd = float(amount_usd)
        existing_bt.transaction_type = "income"
        existing_bt.group_name = "Revenue"
        existing_bt.report_year = revenue.report_year
        existing_bt.company = revenue.company
        if effective_user_id:
            existing_bt.user_id = effective_user_id
    else:
        new_bt = BankTransaction(
            bank_id=revenue.bank_id,
            date=tx_date,
            description=f"Penerimaan Revenue: {revenue.description}",
            amount_idr=float(amount_idr),
            amount_usd=float(amount_usd),
            transaction_type="income",
            group_name="Revenue",
            report_year=revenue.report_year,
            company=revenue.company,
            revenue_id=revenue.id,
            user_id=effective_user_id,
        )
        db.session.add(new_bt)








@revenues_router.get("")
def get_revenues(request: Request, current_user: User = Depends(get_current_user), company: str = Header(default="EWI Foundation", alias="X-Company")):
    User.query.get(int(current_user.id))

    # filter opsional
    start_date_str = request.query_params.get("start_date")
    end_date_str = request.query_params.get("end_date")
    year = _query_int(request.query_params.get("year"))
    mode = request.query_params.get("mode", "report")  # 'report' or 'actual'

    query = Revenue.query.filter(Revenue.company == company)

    if year:
        if mode == "report":
            query = query.filter(
                db.or_(
                    Revenue.report_year == year,
                    db.and_(
                        Revenue.report_year.is_(None),
                        extract("year", Revenue.invoice_date) == year,
                    ),
                )
            )
        else:
            query = query.filter(extract("year", Revenue.invoice_date) == year)

    if start_date_str:
        start_date = _parse_date(start_date_str)
        if start_date:
            query = query.filter(Revenue.invoice_date >= start_date)

    if end_date_str:
        end_date = _parse_date(end_date_str)
        if end_date:
            query = query.filter(Revenue.invoice_date <= end_date)

    revenues = query.order_by(Revenue.id.asc()).all()
    return JSONResponse(content=[r.to_dict() for r in revenues], status_code=200)


@revenues_router.get("/{revenue_id:int}")
def get_revenue(revenue_id: int, current_user: User = Depends(get_current_user)):
    revenue = Revenue.query.get_or_404(revenue_id)
    return JSONResponse(content=revenue.to_dict(), status_code=200)


@revenues_router.post("")
def create_revenue(data: dict | None = Body(default=None), current_user: User = Depends(get_current_user), company: str = Header(default="EWI Foundation", alias="X-Company")):
    user = User.query.get(int(current_user.id))
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={'error': 'Akses ditolak. Hanya manager yang dapat membuat record Revenue.'}, status_code=403)

    if not data:
        return JSONResponse(content={'error': 'Must provide data'}, status_code=400)

    invoice_date = _parse_date(data.get("invoice_date"))
    description = data.get("description")
    invoice_value = data.get("invoice_value")

    if not invoice_date or not description or invoice_value is None:
        return JSONResponse(content={'error': 'invoice_date, description, and invoice_value are required'}, status_code=400)

    # Normalize and validate revenue_type
    revenue_type = Revenue.normalize_revenue_type(data.get("revenue_type"))
    if revenue_type not in (Revenue.REVENUE_DIRECT, Revenue.REVENUE_OTHER):
        return JSONResponse(content={'error': 'Invalid revenue_type. Must be "pendapatan_langsung" or "pendapatan_lain_lain"'}, status_code=400)

    try:
        inv_val = _parse_float_safe(invoice_value, default=0.0)

        # Parse bank_id
        raw_bank_id = data.get("bank_id")
        bank_id = None
        if raw_bank_id is not None:
            try:
                b_int = int(raw_bank_id)
                if b_int > 0:
                    bank_id = b_int
            except (ValueError, TypeError):
                bank_id = None

        revenue = Revenue(
            invoice_date=invoice_date,
            description=description,
            invoice_value=inv_val if inv_val is not None else 0.0,
            invoice_value_usd=_parse_float_safe(data.get("invoice_value_usd")),
            invoice_value_idr=_parse_float_safe(data.get("invoice_value_idr")),
            currency=data.get("currency", "IDR") or "IDR",
            currency_exchange=_parse_float_safe(data.get("currency_exchange")),
            invoice_number=data.get("invoice_number"),
            client=data.get("client"),
            receive_date=_parse_date(data.get("receive_date")),
            amount_received=_parse_float_safe(data.get("amount_received")),
            amount_received_idr=_parse_float_safe(data.get("amount_received_idr")),
            amount_received_usd=_parse_float_safe(data.get("amount_received_usd")),
            ppn=_parse_float_safe(data.get("ppn")),
            pph_23=_parse_float_safe(data.get("pph_23")),
            transfer_fee=_parse_float_safe(data.get("transfer_fee")),
            remark=data.get("remark"),
            revenue_type=revenue_type,
            report_year=int(data.get("report_year") or invoice_date.year),
            bank_id=bank_id,
            user_id=user.id,
            company=company,
        )
        db.session.add(revenue)
        db.session.flush()
        sync_revenue_bank_transaction(revenue, user_id=user.id)
        db.session.commit()
        return JSONResponse(content=revenue.to_dict(), status_code=201)
    except Exception as e:
        db.session.rollback()
        return JSONResponse(content={'error': str(e)}, status_code=500)


@revenues_router.put("/{revenue_id}")
def update_revenue(revenue_id: int, data: dict = Body(default={}), current_user: User = Depends(get_current_user), company: str = Header(default="EWI Foundation", alias="X-Company")):
    user = User.query.get(int(current_user.id))
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={'error': 'Akses ditolak.'}, status_code=403)

    revenue = Revenue.query.get_or_404(revenue_id)
    if "invoice_date" in data:
        parsed_d = _parse_date(data["invoice_date"])
        if parsed_d:
            revenue.invoice_date = parsed_d
    if "description" in data:
        revenue.description = str(data["description"] or "")
    if "invoice_value" in data:
        inv_val = _parse_float_safe(data["invoice_value"])
        if inv_val is not None:
            revenue.invoice_value = inv_val
    if "invoice_value_usd" in data:
        revenue.invoice_value_usd = _parse_float_safe(data["invoice_value_usd"])
    if "invoice_value_idr" in data:
        revenue.invoice_value_idr = _parse_float_safe(data["invoice_value_idr"])
    if "currency" in data:
        revenue.currency = data["currency"] or "IDR"
    if "currency_exchange" in data:
        revenue.currency_exchange = _parse_float_safe(data["currency_exchange"])
    if "invoice_number" in data:
        revenue.invoice_number = data["invoice_number"]
    if "client" in data:
        revenue.client = data["client"]
    if "receive_date" in data:
        revenue.receive_date = _parse_date(data["receive_date"])
    if "amount_received" in data:
        revenue.amount_received = _parse_float_safe(data["amount_received"])
    if "amount_received_idr" in data:
        revenue.amount_received_idr = _parse_float_safe(data["amount_received_idr"])
    if "amount_received_usd" in data:
        revenue.amount_received_usd = _parse_float_safe(data["amount_received_usd"])
    if "ppn" in data:
        revenue.ppn = _parse_float_safe(data["ppn"])
    if "pph_23" in data:
        revenue.pph_23 = _parse_float_safe(data["pph_23"])
    if "transfer_fee" in data:
        revenue.transfer_fee = _parse_float_safe(data["transfer_fee"])
    if "remark" in data:
        revenue.remark = data["remark"]
    if "revenue_type" in data:
        revenue_type = Revenue.normalize_revenue_type(data["revenue_type"])
        if revenue_type not in (Revenue.REVENUE_DIRECT, Revenue.REVENUE_OTHER):
            return JSONResponse(content={'error': 'Invalid revenue_type. Must be "pendapatan_langsung" or "pendapatan_lain_lain"'}, status_code=400)
        revenue.revenue_type = revenue_type
    if "report_year" in data:
        try:
            revenue.report_year = int(data["report_year"]) if data["report_year"] else revenue.invoice_date.year
        except (ValueError, TypeError):
            pass
    if "is_selected_for_tax_offset" in data:
        revenue.is_selected_for_tax_offset = bool(data["is_selected_for_tax_offset"])

    if "bank_id" in data:
        raw_b_id = data["bank_id"]
        if raw_b_id is not None:
            try:
                b_int = int(raw_b_id)
                revenue.bank_id = b_int if b_int > 0 else None
            except (ValueError, TypeError):
                revenue.bank_id = None
        else:
            revenue.bank_id = None

    revenue.user_id = user.id

    try:
        sync_revenue_bank_transaction(revenue, user_id=user.id)
        db.session.commit()
        return JSONResponse(content=revenue.to_dict(), status_code=200)
    except Exception as e:
        db.session.rollback()
        return JSONResponse(content={'error': str(e)}, status_code=500)


@revenues_router.post("/{revenue_id}/toggle-tax-offset")
def toggle_tax_offset(revenue_id: int, current_user: User = Depends(get_current_user), company: str = Header(default="EWI Foundation", alias="X-Company")):
    user = User.query.get(int(current_user.id))
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={'error': 'Akses ditolak.'}, status_code=403)

    revenue = Revenue.query.get_or_404(revenue_id)
    revenue.is_selected_for_tax_offset = not getattr(
        revenue, "is_selected_for_tax_offset", True
    )
    db.session.commit()
    return JSONResponse(content=revenue.to_dict(), status_code=200)


@revenues_router.delete("/{revenue_id}")
def delete_revenue(revenue_id: int, current_user: User = Depends(get_current_user), company: str = Header(default="EWI Foundation", alias="X-Company")):
    user = User.query.get(int(current_user.id))
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={'error': 'Akses ditolak.'}, status_code=403)

    revenue = Revenue.query.get_or_404(revenue_id)
    try:
        # Hapus combine groups yang mengandung row ini
        ManualCombineGroup.query.filter(
            ManualCombineGroup.table_name == "revenues",
        ).all()
        # Filter manual untuk hapus yang mengandung ID ini
        groups_to_delete = []
        groups_to_update = []
        for group in ManualCombineGroup.query.filter_by(table_name="revenues").all():
            row_ids = group.row_ids()
            if revenue_id in row_ids:
                if len(row_ids) <= 2:
                    # Hanya 2 row, hapus group saja
                    groups_to_delete.append(group)
                else:
                    # Lebih dari 2, hapus ID dari group
                    new_row_ids = [rid for rid in row_ids if rid != revenue_id]
                    group.row_ids_json = json.dumps(new_row_ids)
                    groups_to_update.append(group)

        for group in groups_to_delete:
            db.session.delete(group)
        for group in groups_to_update:
            db.session.add(group)

        sync_revenue_bank_transaction(revenue, is_delete=True)
        db.session.delete(revenue)
        db.session.commit()
        return JSONResponse(content={'message': 'Revenue deleted'}, status_code=200)
    except Exception as e:
        db.session.rollback()
        return JSONResponse(content={'error': str(e)}, status_code=500)


@revenues_router.get("/combine-groups")
def get_revenue_combine_groups(request: Request, current_user: User = Depends(get_current_user), company: str = Header(default="EWI Foundation", alias="X-Company")):
    year = _query_int(request.query_params.get("year"))
    if not year:
        return JSONResponse(content={'error': 'year is required'}, status_code=400)

    groups = (
        ManualCombineGroup.query.filter_by(
            table_name="revenues",
            report_year=year,
        )
        .order_by(ManualCombineGroup.group_date.asc(), ManualCombineGroup.id.asc())
        .all()
    )
    return JSONResponse(content=[group.to_dict() for group in groups], status_code=200)


@revenues_router.post("/combine-groups")
def create_revenue_combine_group(data: dict = Body(default={}), current_user: User = Depends(get_current_user), company: str = Header(default="EWI Foundation", alias="X-Company")):
    user = User.query.get(int(current_user.id))
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={'error': 'Akses ditolak.'}, status_code=403)

    year = data.get("year")
    row_ids = data.get("row_ids") or []
    merged_columns = (
        data.get("merged_columns") or []
    )  # List of fields like ['invoice_value', 'rate']
    overrides = data.get("overrides") or {}  # Dict like {'invoice_value': 1000}

    validated, error = _validate_manual_revenue_group(year, row_ids, company)
    if error:
        return JSONResponse(content={'error': error}, status_code=400)

    # Simpan backup data asli sebelum diubah
    original_data = {}
    revenues = []
    for rid in row_ids:
        rev = Revenue.query.get(rid)
        if rev:
            revenues.append(rev)
            # Simpan semua field yang mungkin di-merge
            original_data[str(rid)] = {
                "invoice_date": rev.invoice_date.isoformat()
                if rev.invoice_date
                else None,
                "description": rev.description,
                "invoice_value": rev.invoice_value,
                "invoice_value_usd": rev.invoice_value_usd,
                "invoice_value_idr": rev.invoice_value_idr,
                "currency": rev.currency,
                "currency_exchange": rev.currency_exchange,
                "invoice_number": rev.invoice_number,
                "client": rev.client,
                "amount_received": rev.amount_received,
                "amount_received_idr": rev.amount_received_idr,
                "amount_received_usd": rev.amount_received_usd,
                "ppn": rev.ppn,
                "pph_23": rev.pph_23,
                "transfer_fee": rev.transfer_fee,
                "receive_date": rev.receive_date.isoformat()
                if rev.receive_date
                else None,
                "remark": rev.remark,
            }

    # Terapkan override dan nol-kan baris sisanya
    if revenues:
        primary_rev = revenues[0]
        for col in merged_columns:
            val = overrides.get(col)
            # Jika user memberikan input manual, gunakan itu. Jika tidak, tetap gunakan nilai baris utama.
            if val is not None:
                # Handle conversion for numbers vs strings vs dates
                if col in ["receive_date", "invoice_date"]:
                    try:
                        dt_val = datetime.strptime(val, "%Y-%m-%d").date()
                        setattr(primary_rev, col, dt_val)
                    except:
                        pass
                elif col in [
                    "currency",
                    "remark",
                    "description",
                    "client",
                    "invoice_number",
                ]:
                    setattr(primary_rev, col, val)
                else:
                    parsed_num = _parse_number_value(val)
                    if parsed_num is not None:
                        setattr(primary_rev, col, parsed_num)

            # Nol-kan atau kosongkan baris kedua dan seterusnya untuk kolom ini
            for other_rev in revenues[1:]:
                if col == "receive_date":
                    other_rev.receive_date = None
                elif col == "invoice_date":
                    # invoice_date is NOT NULL, so we keep it same as primary or just don't clear it
                    # other_rev.invoice_date = primary_rev.invoice_date
                    pass
                elif col in [
                    "currency",
                    "remark",
                    "description",
                    "client",
                    "invoice_number",
                ]:
                    setattr(other_rev, col, "")
                else:
                    setattr(other_rev, col, 0.0)

    group = ManualCombineGroup(
        table_name="revenues",
        report_year=int(year),
        group_date=validated["group_date"],
        row_ids_json=json.dumps(row_ids),
        merged_columns_json=json.dumps(merged_columns),
        original_data_json=json.dumps(original_data),
    )
    try:
        db.session.add(group)
        db.session.commit()
        return JSONResponse(content=group.to_dict(), status_code=201)
    except Exception as e:
        db.session.rollback()
        return JSONResponse(content={'error': str(e)}, status_code=500)


@revenues_router.delete("/combine-groups/{group_id}")
def delete_revenue_combine_group(group_id: int, current_user: User = Depends(get_current_user), company: str = Header(default="EWI Foundation", alias="X-Company")):
    user = User.query.get(int(current_user.id))
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={'error': 'Akses ditolak.'}, status_code=403)

    group = ManualCombineGroup.query.filter_by(
        id=group_id,
        table_name="revenues",
    ).first_or_404()

    try:
        # Kembalikan data asli
        original_data = json.loads(group.original_data_json or "{}")
        for rid_str, fields in original_data.items():
            rev = Revenue.query.get(int(rid_str))
            if rev:
                for col, val in fields.items():
                    if col in ["receive_date", "invoice_date"] and val:
                        try:
                            dt_val = datetime.strptime(val[:10], "%Y-%m-%d").date()
                            setattr(rev, col, dt_val)
                        except:
                            pass
                    else:
                        setattr(rev, col, val)

        db.session.delete(group)
        db.session.commit()
        return JSONResponse(content={'message': 'Revenue combine group deleted'}, status_code=200)
    except Exception as e:
        db.session.rollback()
        return JSONResponse(content={'error': str(e)}, status_code=500)


def _query_int(value):
    try:
        return int(value) if value is not None else None
    except (TypeError, ValueError):
        return None
