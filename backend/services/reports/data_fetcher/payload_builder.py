import logging
from datetime import date, datetime
from typing import Any, Dict, Optional
from dateutil.relativedelta import relativedelta

logger = logging.getLogger(__name__)
from models import (
    Advance,
    AdvanceItem,
    Category,
    CategoryGroup,
    Dividend,
    DividendSetting,
    Expense,
    Revenue,
    Settlement,
    Tax,
    db,
)
from sqlalchemy import text as sql_text
from sqlalchemy.orm import joinedload
from services.reports.annual_service.annual_helpers import (
    _compute_dividend_distribution_v2,
)
from utils.report_helpers import (
    _clean_currency,
    _clean_settlement_title,
    _group_annual_expenses,
    _year_date_bounds,
)

from .db_fetchers import _tagged_ids_for_year, _has_any_report_tags, _fetch_revenue_data, _fetch_expense_data, _fetch_asset_data, _fetch_bank_transaction_data, _fetch_tax_data, _fetch_advance_items_data, _fetch_dividend_data
from .depreciation import _calculate_asset_depreciation

def _compute_dividend_distribution(
    revenues, expenses, profit_retained, recipient_count
):
    revenue_total = sum((r.idr_invoice_value or 0) for r in revenues)
    pph23_total = sum((r.pph_23 or 0) for r in revenues)
    total_cost = sum((e.idr_amount or 0) for e in expenses)
    profit_before_tax = revenue_total - total_cost
    tax_corporate = profit_before_tax * 0.22 * 0.5 if profit_before_tax > 0 else 0.0
    profit_after_tax = profit_before_tax - (tax_corporate - pph23_total)
    dividend_distributed = max(profit_after_tax - profit_retained, 0.0)
    dividend_per_person = (
        dividend_distributed / recipient_count if recipient_count > 0 else 0.0
    )
    return {
        "revenue_total": revenue_total,
        "pph23_total": pph23_total,
        "total_cost": total_cost,
        "profit_before_tax": profit_before_tax,
        "tax_corporate": tax_corporate,
        "profit_after_tax": profit_after_tax,
        "profit_retained": profit_retained,
        "dividend_distributed": dividend_distributed,
        "dividend_per_person": dividend_per_person,
    }

def _build_annual_payload_from_db(
    year: Optional[int] = None,
    mode: str = "report",
    start_date: Optional[str] = None,
    end_date: Optional[str] = None,
    company: str = "EWI Foundation",
    sort_mode: str = "kategori",
) -> Dict[str, Any]:
    from services.reports.annual_service.annual_tables import _manual_combine_groups_by_rows, _validate_revenue_data

    """
    Build annual report payload from database.
    - mode='report': Filters by report_year (Accrual)
    - mode='actual': Filters by transaction date (Cash Basis)
    - mode='range': Filters by specific date range
    """

    print(
        f"\n[ANNUAL_REPORT_DEBUG] Building payload for year={year} mode={mode} company={company}"
    )
    year_start, next_year_start = _year_date_bounds(year)

    # Debug: Check raw counts for the year
    raw_rev_count = (
        Revenue.query.filter(Revenue.company == company)
        .filter(Revenue.report_year == year)
        .count()
    )
    raw_set_count = (
        Settlement.query.filter(Settlement.company == company)
        .filter(Settlement.report_year == year)
        .count()
    )
    raw_adv_count = (
        Advance.query.filter(Advance.company == company)
        .filter(Advance.report_year == year)
        .count()
    )
    completed_set_count = Settlement.query.filter(
        Settlement.company == company,
        Settlement.report_year == year,
        Settlement.status == "completed",
    ).count()

    print(
        f"[ANNUAL_REPORT_DEBUG] {year} ({company}): Raw Revenues={raw_rev_count}, Raw Settlements={raw_set_count} (Completed={completed_set_count}), Raw Advances={raw_adv_count}"
    )

    has_report_tags = _has_any_report_tags()
    tagged_revenue_ids = _tagged_ids_for_year("revenues", year)
    tagged_tax_ids = _tagged_ids_for_year("taxes", year)

    # ? ASSETS FILTER (Tabel 7)
    assets = _fetch_asset_data(year, mode, end_date, next_year_start, company=company)

    # ? BANK TRANSACTIONS FILTER (Tabel 6)
    bank_transactions = _fetch_bank_transaction_data(
        year, mode, start_date, end_date, year_start, next_year_start, company=company
    )

    logger.debug(
        f"Report tags: has={has_report_tags}, revenue_ids={len(tagged_revenue_ids)}, tax_ids={len(tagged_tax_ids)}"
    )

    # ? REVENUE FILTER
    revenues = _fetch_revenue_data(
        year,
        mode,
        start_date,
        end_date,
        has_report_tags,
        tagged_revenue_ids,
        year_start,
        next_year_start,
        company=company,
    )
    logger.debug(f"Loaded {len(revenues)} revenues")

    # ? TAX FILTER
    taxes = _fetch_tax_data(
        year,
        mode,
        start_date,
        end_date,
        has_report_tags,
        tagged_tax_ids,
        year_start,
        next_year_start,
        company=company,
    )
    logger.debug(f"Loaded {len(taxes)} taxes")

    # ? EXPENSES FILTER
    expenses = _fetch_expense_data(
        year, mode, start_date, end_date, year_start, next_year_start, company=company
    )

    # ? ADVANCE ITEMS FILTER (Kasbon yang sudah Final)
    advance_items = _fetch_advance_items_data(
        year, mode, start_date, end_date, year_start, next_year_start, company=company
    )
    logger.debug(
        f"Loaded {len(expenses)} expenses and {len(advance_items)} advance items"
    )

    # ? RETURNED FUNDS FILTER (Tabel 3C)
    returned_funds_data = []

    def _preferred_source_label(*values):
        for value in values:
            label = (value or "").strip() if isinstance(value, str) else value
            if isinstance(label, str) and label and label != "-":
                return label
        return "-"

    # Settlements with returns
    settlements_query = Settlement.query.filter(
        Settlement.company == company,
        Settlement.returned_amount > 0,
        Settlement.status == "completed",
        Settlement.return_status == "approved",
    )
    if mode == "report":
        if year:
            settlements_query = settlements_query.filter(Settlement.report_year == year)
    elif mode == "range" and start_date and end_date:
        settlements_query = settlements_query.filter(
            Settlement.completed_at >= start_date, Settlement.completed_at <= end_date
        )
    else:
        if year_start and next_year_start:
            settlements_query = settlements_query.filter(
                Settlement.created_at >= year_start,
                Settlement.created_at < next_year_start,
            )

    for s in settlements_query.all():
        # ? Update Title logic for Table 3C: Single type uses first item description
        display_title = s.title
        if getattr(s, "settlement_type", "single") == "single" and s.expenses:
            first_item = s.expenses[0]
            if first_item.description:
                display_title = first_item.description

        returned_funds_data.append(
            {
                "date": s.completed_at.date().isoformat()
                if s.completed_at
                else s.created_at.date().isoformat(),
                "title": display_title,
                "type": (getattr(s, "settlement_type", "single") or "single").upper(),
                "class_type": "Settlement",
                "approved_amount": s.approved_amount,
                "disbursed_amount": s.disbursed_amount or s.approved_amount,
                "returned_amount": s.returned_amount,
                "disbursement_source": s.disbursement_source,
                "return_source": s.return_source,
                "bank_name": _preferred_source_label(
                    s.return_source,
                    s.disbursement_source,
                    s.bank.name if s.bank else None,
                ),
                "id": s.id,
            }
        )

    # Advances with returns
    advances_query = Advance.query.filter(
        Advance.company == company,
        Advance.returned_amount > 0,
        Advance.status == "completed",
        Advance.return_status == "approved",
    )
    if mode == "report":
        if year:
            advances_query = advances_query.filter(Advance.report_year == year)
    elif mode == "range" and start_date and end_date:
        advances_query = advances_query.filter(
            Advance.approved_at >= start_date, Advance.approved_at <= end_date
        )
    else:
        if year_start and next_year_start:
            advances_query = advances_query.filter(
                Advance.created_at >= year_start,
                Advance.created_at < next_year_start,
            )

    for a in advances_query.all():
        # ? Update Title logic for Table 3C: Single type uses first item description
        display_title = a.title
        if getattr(a, "advance_type", "single") == "single" and a.items:
            first_item = a.items[0]
            if first_item.description:
                display_title = first_item.description

        returned_funds_data.append(
            {
                "date": a.approved_at.date().isoformat()
                if a.approved_at
                else a.created_at.date().isoformat(),
                "title": display_title,
                "type": (getattr(a, "advance_type", "single") or "single").upper(),
                "class_type": "Advance",
                "approved_amount": a.approved_amount,
                "disbursed_amount": a.disbursed_amount or a.approved_amount,
                "returned_amount": a.returned_amount,
                "disbursement_source": a.disbursement_source,
                "return_source": a.return_source,
                "bank_name": _preferred_source_label(
                    a.return_source,
                    a.disbursement_source,
                    a.bank.name if a.bank else None,
                ),
                "id": f"ADV-{a.id}",
            }
        )

    returned_funds_data.sort(key=lambda x: x["date"])

    # ? DIVIDENDS FILTER
    dividends = _fetch_dividend_data(
        year, mode, start_date, end_date, year_start, next_year_start, company=company
    )
    dividend_setting = DividendSetting.query.filter_by(
        year=year, company=company
    ).first()

    advance_data = []
    for adv in advance_items:
        d = adv.to_dict()
        d["currency"] = _clean_currency(d.get("currency"))
        d["evidence"] = adv.evidence_path or ""
        d["evidence_filename"] = adv.evidence_filename or ""
        advance_data.append(d)

    revenue_data = []
    for r in revenues:
        d = r.to_dict()
        d["currency"] = _clean_currency(d.get("currency"))
        revenue_data.append(d)

    tax_data = []
    for t in taxes:
        d = t.to_dict()
        d["currency"] = _clean_currency(d.get("currency"))
        tax_data.append(d)

    # ? VALIDATE DATA EARLY
    _validate_revenue_data(revenue_data)

    dividend_calc = _compute_dividend_distribution_v2(
        revenues, expenses, dividend_setting, len(dividends)
    )
    dividend_data = []
    total_percentage = 0.0
    for d in dividends:
        row = d.to_dict()
        row["recipient_name"] = d.name
        row["amount"] = dividend_calc["dividend_distributed"] * (d.percentage / 100.0)
        row["amount_display"] = row["amount"]
        total_percentage += d.percentage
        dividend_data.append(row)

    # Add remainder row if total percentage is less than 100%
    if total_percentage < 100.0 and dividend_calc["dividend_distributed"] > 0:
        remaining = 100.0 - total_percentage
        amount = dividend_calc["dividend_distributed"] * (remaining / 100.0)
        dividend_data.append(
            {
                "id": 99999,
                "name": f"Sisa Persen ({remaining:.1f}%)",
                "recipient_name": f"Sisa Persen ({remaining:.1f}%)",
                "percentage": remaining,
                "amount": amount,
                "amount_display": amount,
                "date": f"{dividend_setting.year}-12-31"
                if dividend_setting and dividend_setting.year
                else "",
            }
        )

    # ? Asset Data with Depreciation
    asset_data = _calculate_asset_depreciation(assets, year)

    # ? BANK TRANSACTIONS GROUPING
    bank_status_groups = {}
    for t in bank_transactions:
        gn = t.group_name or "Lain-lain"
        if gn not in bank_status_groups:
            # Store first item's type to help with sorting
            bank_status_groups[gn] = {"items": [], "type": t.transaction_type}

        d = t.to_dict()

        # ✅ FIX: Clean pipe-delimited metadata from description (e.g. "Desc|0|100|performer")
        raw_desc = (d.get("description") or "").strip()
        if "|" in raw_desc:
            d["description"] = raw_desc.split("|")[0].strip()

        d["currency"] = _clean_currency(d.get("currency"))
        bank_status_groups[gn]["items"].append(d)

    # Format for JSON response and sort by group type
    def _bank_group_rank(gn, g_type):
        gn_up = gn.upper()

        # 1. Tentukan Ranking berdasarkan Tipe: Income > Expense > Transfer
        # Priority: Income=10, Expense=20, Transfer=30, Others=40
        type_rank = 40

        # Check by explicit transaction_type first
        if g_type == "income":
            type_rank = 10
        elif g_type == "expense":
            type_rank = 20
        elif g_type == "transfer":
            type_rank = 30
        else:
            # Fallback to group name analysis
            if "INTEREST" in gn_up or "PENGEMBALIAN" in gn_up:
                type_rank = 10
            elif (
                "DIRECT TRANSFER" in gn_up
                or "BIAYA ADMIN" in gn_up
                or "PENGIRIMAN" in gn_up
                or "TRANSFER FROM" in gn_up
            ):
                type_rank = 20
            elif "PEMINDAHBUKUAN" in gn_up:
                type_rank = 30

        # 2. Tentukan Ranking berdasarkan Bank (BRI > BNI > Mandiri > BCA > EWI)
        # Priority matching order: BRI=1 -> BNI=2 -> Mandiri=3 -> BCA=4 -> EWI=5
        # Sub-priority: GIRO=1, BISNIS=2, TABBIS=3, VALAS=4, Others=5
        bank_main_rank = 6
        bank_sub_rank = 9

        if "BRI" in gn_up:
            bank_main_rank = 1
            if "GIRO" in gn_up:
                bank_sub_rank = 1
            elif "BISNIS" in gn_up:
                bank_sub_rank = 2
            elif "TABBIS" in gn_up:
                bank_sub_rank = 3
            elif "VALAS" in gn_up:
                bank_sub_rank = 4
            else:
                bank_sub_rank = 5
        elif "BNI" in gn_up:
            bank_main_rank = 2
            if "GIRO" in gn_up:
                bank_sub_rank = 1
            elif "BISNIS" in gn_up:
                bank_sub_rank = 2
            elif "TABBIS" in gn_up:
                bank_sub_rank = 3
            elif "VALAS" in gn_up:
                bank_sub_rank = 4
            else:
                bank_sub_rank = 5
        elif "MANDIRI" in gn_up:
            bank_main_rank = 3
            if "GIRO" in gn_up:
                bank_sub_rank = 1
            elif "BISNIS" in gn_up:
                bank_sub_rank = 2
            elif "TABBIS" in gn_up:
                bank_sub_rank = 3
            elif "VALAS" in gn_up:
                bank_sub_rank = 4
            else:
                bank_sub_rank = 5
        elif "BCA" in gn_up:
            bank_main_rank = 4
            if "GIRO" in gn_up:
                bank_sub_rank = 1
            elif "BISNIS" in gn_up:
                bank_sub_rank = 2
            elif "TABBIS" in gn_up:
                bank_sub_rank = 3
            elif "VALAS" in gn_up:
                bank_sub_rank = 4
            else:
                bank_sub_rank = 5
        elif "EWI" in gn_up:
            bank_main_rank = 5
            bank_sub_rank = 1

        # Kombinasikan: Tipe dulu -> Bank Utama -> Sub Bank -> Nama
        return (type_rank, bank_main_rank, bank_sub_rank, gn_up)

    grouped_bank_status = []
    for gn, data in bank_status_groups.items():
        grouped_bank_status.append(
            {"group_name": gn, "items": data["items"], "type": data.get("type")}
        )

    # Sort groups: Type Rank -> Bank Rank -> Sub Rank -> Name
    grouped_bank_status.sort(
        key=lambda x: _bank_group_rank(x["group_name"], x.get("type"))
    )

    # ? Optimization: use joinedload for categories to avoid nested database hits
    all_categories = (
        Category.query.filter(Category.company == company)
        .options(joinedload(Category.parent))
        .all()
    )
    category_by_id = {c.id: c for c in all_categories}
    expense_data = []
    advance_expense_data = []

    # Track processed admin fees to avoid duplicates
    processed_settlement_ids = set()
    processed_advance_ids = set()
    admin_fee_items = []

    def _create_virtual_admin_fee_item(parent_obj, obj_type="settlement"):
        # Category ID 25 is 'Biaya Bank' under 'Administrasi' (ID 23)
        # Note: We should ideally find the category by code/name for the specific company
        # but for now we'll use the ID if it exists in the company's category list
        cat_id = 25
        root_cat_id = 23
        cat = category_by_id.get(cat_id)
        root_cat = category_by_id.get(root_cat_id)

        # Fallback if specific IDs don't match (e.g. different company category setup)
        if not root_cat:
            root_cat = next(
                (
                    c
                    for c in all_categories
                    if c.name == "Administrasi" and c.parent_id is None
                ),
                None,
            )
        if not cat and root_cat:
            cat = next(
                (
                    c
                    for c in all_categories
                    if c.name == "Biaya Bank & Admin" and c.parent_id == root_cat.id
                ),
                None,
            )

        item_id = f"FEE-{obj_type.upper()}-{parent_obj.id}"

        # Determine main transaction amount (Jumlah)
        main_amount = 0.0
        doc_type = (
            getattr(
                parent_obj,
                "settlement_type" if obj_type == "settlement" else "advance_type",
                "single",
            )
            or "single"
        ).lower()

        # Priority: For Single, use item description. For Batch, use Title.
        activity = parent_obj.title or "-"

        if obj_type == "settlement":
            main_amount = sum(((ex.idr_amount or 0.0) for ex in parent_obj.expenses))
            if doc_type == "single" and parent_obj.expenses:
                first_exp = parent_obj.expenses[0]
                if first_exp and first_exp.description:
                    activity = first_exp.description
        else:
            main_amount = sum(((ai.idr_amount or 0.0) for ai in parent_obj.items))
            if doc_type == "single" and parent_obj.items:
                first_item = parent_obj.items[0]
                if first_item and first_item.description:
                    activity = first_item.description

        d = {
            "id": item_id,
            "date": parent_obj.created_at.date().isoformat()
            if parent_obj.created_at
            else None,
            "description": activity,
            "amount": parent_obj.admin_fee or 0.0,
            "idr_amount": parent_obj.admin_fee or 0.0,
            "main_amount": main_amount,
            "currency": "IDR",
            "exchange_rate": 1.0,
            "category_id": cat.id if cat else (cat_id if root_cat else None),
            "category_name": root_cat.name if root_cat else "Administrasi",
            "category_code": root_cat.code if root_cat else "E",
            "main_group": root_cat.main_group if root_cat else "NON-PROJECT",
            "subcategory_name": cat.name if cat else "Biaya Bank & Admin",
            "settlement_id": parent_obj.id
            if obj_type == "settlement"
            else f"ADV-{parent_obj.id}",
            "settlement_title": _clean_settlement_title(parent_obj.title),
            "settlement_type": doc_type,
            "settlement_description": parent_obj.description or "",
            "bank_name": _preferred_source_label(
                getattr(parent_obj, "disbursement_source", None),
                parent_obj.bank.name if parent_obj.bank else None,
            ),
            "is_admin_fee_extra": True,
        }
        return d

    # Pre-collect admin fees from all relevant Settlements and Advances
    # This ensures admin fees show up even if the settlement/advance itself is not fully processed yet
    fee_s_query = Settlement.query.filter(
        Settlement.company == company,
        Settlement.admin_fee > 0,
        Settlement.status == "completed",
    )
    if year:
        fee_s_query = fee_s_query.filter(Settlement.report_year == year)

    settlements_with_fee = fee_s_query.all()

    for s in settlements_with_fee:
        if s.id not in processed_settlement_ids:
            fee_item = _create_virtual_admin_fee_item(s, "settlement")
            expense_data.append(fee_item)  # Add to main expense list for profit/loss
            admin_fee_items.append(fee_item)
            processed_settlement_ids.add(s.id)

    fee_a_query = Advance.query.filter(
        Advance.company == company,
        Advance.admin_fee > 0,
        Advance.status == "completed",
    )
    if year:
        fee_a_query = fee_a_query.filter(Advance.report_year == year)

    advances_with_fee = fee_a_query.all()

    for a in advances_with_fee:
        if a.id not in processed_advance_ids:
            fee_item = _create_virtual_admin_fee_item(a, "advance")
            advance_expense_data.append(fee_item)  # Add to advance expense list
            admin_fee_items.append(fee_item)
            processed_advance_ids.add(a.id)

    for e in expenses:
        d = e.to_dict()

        # FIX: Gunakan tanggal dokumen settlement sebagai tanggal tampilan di laporan
        # agar urutannya konsisten dengan list di aplikasi.
        if e.settlement and e.settlement.document_date:
            d["date"] = e.settlement.document_date.isoformat()

        # ? SAFETY: Filter out trash descriptions from UI display
        clean_desc = str(d.get("description") or "").strip().upper()
        if clean_desc in ["TOTAL", "SUBTOTAL", "-", ""]:
            continue

        curr_cat = category_by_id.get(e.category_id)
        if curr_cat:
            # Cari nama & kode kategori akar untuk header tabel (tetap perlu root_name)
            temp_cat = curr_cat
            while temp_cat.parent_id and category_by_id.get(temp_cat.parent_id):
                temp_cat = category_by_id[temp_cat.parent_id]
            root_name = temp_cat.name or "-"
            root_code = temp_cat.code or "-"

            # ? FIX: Determine main_group by checking curr_cat first, then traversing up
            target_mg = None
            search_cat = curr_cat
            while search_cat:
                if search_cat.main_group and search_cat.main_group != "-":
                    target_mg = search_cat.main_group
                    break
                if not search_cat.parent_id:
                    break
                search_cat = category_by_id.get(search_cat.parent_id)

            m_group = target_mg or temp_cat.main_group or "-"
        else:
            root_name = "-"
            root_code = "-"
            m_group = "-"

        d["category_name"] = root_name
        d["category_code"] = root_code
        d["main_group"] = m_group or "-"
        d["subcategory_name"] = e.combined_subcategory_label
        d["settlement_id"] = e.settlement_id
        d["settlement_title"] = _clean_settlement_title(
            e.settlement.title if e.settlement else "-"
        )
        d["settlement_type"] = (
            e.settlement.settlement_type if e.settlement else "single"
        )
        d["settlement_description"] = e.settlement.description if e.settlement else ""
        bank_n = _preferred_source_label(
            e.source,
            e.settlement.disbursement_source if e.settlement else None,
            e.settlement.bank.name if e.settlement and e.settlement.bank else None,
        )
        d["bank_name"] = bank_n
        d["currency"] = _clean_currency(d.get("currency"))

        # Combine evidence from expense and its settlement
        evs = []
        evs_fn = []
        if e.evidence_path:
            evs.append(e.evidence_path)
            evs_fn.append(e.evidence_filename or "")
        if e.settlement and e.settlement.disbursement_evidence_path:
            dis_paths = e.settlement.disbursement_evidence_path.split("|")
            dis_names = (e.settlement.disbursement_evidence_filename or "").split("|")
            evs.extend(dis_paths)
            # Pad filenames if count doesn't match
            for i, p in enumerate(dis_paths):
                evs_fn.append(dis_names[i] if i < len(dis_names) else "")
        d["evidence"] = "|".join(evs) if evs else ""
        d["evidence_filename"] = "|".join(evs_fn) if evs_fn else ""

        expense_data.append(d)

        # Collect regular "Biaya Bank" items into admin_fee_items for Table 7
        is_regular_admin = any(
            k in (d.get("subcategory_name") or "").lower()
            for k in ["biaya bank", "biaya admin", "tax"]
        ) or any(
            k in (d.get("description") or "").lower()
            for k in [
                "biaya admin",
                "biayan admin",
                "biaay admin",
                "biaya dmin",
                "admin bank",
                "biaya transfer",
                "tax giro",
                "tax valas",
                "taxtab",
                "monthly fee",
                "monthly card charge",
                "fee atm",
            ]
        )
        if is_regular_admin:
            admin_fee_items.append(d)

    # ? PROSES ADVANCE ITEMS (KASBON)
    for ai in advance_items:
        d = ai.to_dict()

        # ? SAFETY: Filter out trash descriptions from UI display
        clean_desc = str(d.get("description") or "").strip().upper()
        if clean_desc in ["TOTAL", "SUBTOTAL", "-", ""]:
            continue

        # Check for admin_fee in Advance
        if ai.advance and ai.advance.admin_fee and ai.advance.admin_fee > 0:
            if ai.advance_id not in processed_advance_ids:
                fee_item = _create_virtual_admin_fee_item(ai.advance, "advance")
                advance_expense_data.append(fee_item)
                admin_fee_items.append(fee_item)
                processed_advance_ids.add(ai.advance_id)

        # Mapping fields agar kompatibel dengan layout Expense di laporan
        # ✅ FIX: Use original amount (estimated_amount) for the Amount column, NOT idr_amount
        d["amount"] = ai.estimated_amount

        curr_cat = category_by_id.get(ai.category_id)
        if curr_cat:
            temp_cat = curr_cat
            while temp_cat.parent_id and category_by_id.get(temp_cat.parent_id):
                temp_cat = category_by_id[temp_cat.parent_id]
            root_name = temp_cat.name or "-"
            root_code = temp_cat.code or "-"

            # ? FIX: Determine main_group by checking curr_cat first, then traversing up
            target_mg = None
            search_cat = curr_cat
            while search_cat:
                if search_cat.main_group and search_cat.main_group != "-":
                    target_mg = search_cat.main_group
                    break
                if not search_cat.parent_id:
                    break
                search_cat = category_by_id.get(search_cat.parent_id)

            m_group = target_mg or temp_cat.main_group or "-"
        else:
            root_name = "-"
            root_code = "-"
            m_group = "-"

        d["category_name"] = root_name
        d["category_code"] = root_code
        d["main_group"] = m_group or "-"
        d["subcategory_name"] = ai.combined_subcategory_label
        d["settlement_id"] = f"ADV-{ai.advance_id}"  # Penanda Kasbon
        d["settlement_title"] = _clean_settlement_title(
            ai.advance.title if ai.advance else "-"
        )
        d["settlement_type"] = ai.advance.advance_type if ai.advance else "single"
        d["settlement_description"] = ai.advance.description if ai.advance else ""
        bank_n = _preferred_source_label(
            ai.source,
            ai.advance.disbursement_source if ai.advance else None,
            ai.advance.bank.name if ai.advance and ai.advance.bank else None,
        )
        d["bank_name"] = bank_n
        d["currency"] = _clean_currency(d.get("currency"))

        # Combine evidence from advance item and its advance
        evs = []
        evs_fn = []
        if ai.evidence_path:
            evs.append(ai.evidence_path)
            evs_fn.append(ai.evidence_filename or "")
        if ai.advance and ai.advance.disbursement_evidence_path:
            dis_paths = ai.advance.disbursement_evidence_path.split("|")
            dis_names = (ai.advance.disbursement_evidence_filename or "").split("|")
            evs.extend(dis_paths)
            for i, p in enumerate(dis_paths):
                evs_fn.append(dis_names[i] if i < len(dis_names) else "")
        d["evidence"] = "|".join(evs) if evs else ""
        d["evidence_filename"] = "|".join(evs_fn) if evs_fn else ""

        advance_expense_data.append(d)

        # Collect regular "Biaya Bank" items from advances
        is_regular_admin = any(
            k in (d.get("subcategory_name") or "").lower()
            for k in ["biaya bank", "biaya admin", "tax"]
        ) or any(
            k in (d.get("description") or "").lower()
            for k in [
                "biaya admin",
                "biayan admin",
                "biaay admin",
                "biaya dmin",
                "admin bank",
                "biaya transfer",
                "tax giro",
                "tax valas",
                "taxtab",
                "monthly fee",
                "monthly card charge",
                "fee atm",
            ]
        )
        if is_regular_admin:
            admin_fee_items.append(d)

    # Build sort_order map for root categories (used by _group_annual_expenses)
    root_cats_sort_map = {
        c.name: (c.sort_order or 999) for c in all_categories if c.parent_id is None
    }
    # Stamp category_sort_order onto each expense so _group_sort_key can sort by it
    for d in expense_data:
        d["category_sort_order"] = root_cats_sort_map.get(
            d.get("category_name", ""), 999
        )

    ordered_expense_data = []
    for group in _group_annual_expenses(expense_data, year, sort_mode=sort_mode):
        ordered_expense_data.extend(group)

    for d in advance_expense_data:
        d["category_sort_order"] = root_cats_sort_map.get(
            d.get("category_name", ""), 999
        )
    ordered_advance_expense_data = []
    for group in _group_annual_expenses(
        advance_expense_data, year, sort_mode=sort_mode
    ):
        ordered_advance_expense_data.extend(group)
    # ? Calculate sorted expense groups for Laba Rugi
    # 1. Fetch all category groups for this company
    all_groups = (
        CategoryGroup.query.filter_by(company=company)
        .order_by(CategoryGroup.sort_order)
        .all()
    )
    group_names = [g.name.upper() for g in all_groups]

    mg_totals = {name: {} for name in group_names}
    # For any existing categories that might have a group not in current all_groups (e.g. legacy or deleted)
    # we put them in a fallback group or the last one.

    for e in ordered_expense_data:
        mg = (e.get("main_group") or "-").upper()
        if mg not in mg_totals:
            # If group not found in CategoryGroup table, add it temporarily at the end or use fallback
            mg_totals[mg] = {}
            if mg not in group_names:
                group_names.append(mg)

        cat = e.get("category_name") or "-"
        amount = e.get("amount") or 0
        mg_totals[mg][cat] = mg_totals[mg].get(cat, 0) + amount

    # Sort categories by their sort_order from DB
    root_cats_map = {
        c.name: c.sort_order for c in all_categories if c.parent_id is None
    }

    sorted_expenses = {}
    # Iterate using group_names to maintain CategoryGroup.sort_order
    for mg in group_names:
        if mg not in mg_totals:
            sorted_expenses[mg] = []
            continue

        cats = mg_totals[mg]
        sorted_list = []
        for cat_name, total in cats.items():
            sorted_list.append(
                {
                    "name": cat_name,
                    "amount": total,
                    "sort_order": root_cats_map.get(cat_name, 999),
                }
            )
        sorted_list.sort(key=lambda x: x["sort_order"])
        sorted_expenses[mg] = sorted_list

    # Also include any groups found in data but NOT in CategoryGroup table (fallback)
    for mg, cats in mg_totals.items():
        if mg not in group_names:
            sorted_list = []
            for cat_name, total in cats.items():
                sorted_list.append(
                    {
                        "name": cat_name,
                        "amount": total,
                        "sort_order": root_cats_map.get(cat_name, 999),
                    }
                )
            sorted_list.sort(key=lambda x: x["sort_order"])
            sorted_expenses[mg] = sorted_list

    # --- SORT FOR ADVANCES ---
    mg_totals_adv = {name: {} for name in group_names}
    for e in ordered_advance_expense_data:
        mg = (e.get("main_group") or "-").upper()
        if mg not in mg_totals_adv:
            mg_totals_adv[mg] = {}
            if mg not in group_names:
                group_names.append(mg)
        cat = e.get("category_name") or "-"
        amount = e.get("amount") or 0
        mg_totals_adv[mg][cat] = mg_totals_adv[mg].get(cat, 0) + amount

    sorted_advance_expenses = {}
    for mg in group_names:
        if mg not in mg_totals_adv:
            sorted_advance_expenses[mg] = []
            continue
        cats = mg_totals_adv[mg]
        sorted_list = []
        for cat_name, total in cats.items():
            sorted_list.append(
                {
                    "name": cat_name,
                    "amount": total,
                    "sort_order": root_cats_map.get(cat_name, 999),
                }
            )
        sorted_list.sort(key=lambda x: x["sort_order"])
        sorted_advance_expenses[mg] = sorted_list

    for mg, cats in mg_totals_adv.items():
        if mg not in group_names:
            sorted_list = []
            for cat_name, total in cats.items():
                sorted_list.append(
                    {
                        "name": cat_name,
                        "amount": total,
                        "sort_order": root_cats_map.get(cat_name, 999),
                    }
                )
            sorted_list.sort(key=lambda x: x["sort_order"])
            sorted_advance_expenses[mg] = sorted_list
    # --- END SORT FOR ADVANCES ---

    # Calculate revenue totals taking manual combine groups into account
    revenue_row_ids = [r.id for r in revenues]
    revenue_combine_groups = _manual_combine_groups_by_rows(
        "revenues", revenue_row_ids, company=company
    )
    rev_id_to_group_idx = {}
    for idx, group in enumerate(revenue_combine_groups):
        for r_id in group.get("row_ids", []):
            rev_id_to_group_idx[int(r_id)] = idx

    total_invoice_value = 0.0
    total_invoice_value_usd = 0.0
    total_amount_received = 0.0
    total_amount_received_usd = 0.0
    total_rev_ppn = 0.0
    total_rev_pph23 = 0.0

    for r in revenues:
        r_id = int(r.id)

        is_inv_val_dup = False
        is_amt_rec_dup = False
        is_ppn_dup = False
        is_pph_dup = False

        if r_id in rev_id_to_group_idx:
            g_idx = rev_id_to_group_idx[r_id]
            group_meta = revenue_combine_groups[g_idx]
            merged_cols = group_meta.get("merged_columns", [])
            group_row_ids = [int(rid) for rid in group_meta.get("row_ids", [])]
            if r_id != group_row_ids[0]:
                if "invoice_value" in merged_cols:
                    is_inv_val_dup = True
                if "amount_received" in merged_cols:
                    is_amt_rec_dup = True
                if "ppn" in merged_cols:
                    is_ppn_dup = True
                if "pph_23" in merged_cols:
                    is_pph_dup = True

        if not is_inv_val_dup:
            total_invoice_value += r.idr_invoice_value or 0
            total_invoice_value_usd += r.invoice_value_usd or 0
        if not is_amt_rec_dup:
            total_amount_received += r.idr_amount_received or 0
            total_amount_received_usd += r.amount_received_usd or 0
        if not is_ppn_dup:
            total_rev_ppn += r.ppn or 0
        if not is_pph_dup:
            total_rev_pph23 += r.pph_23 or 0

    # Calculate tax totals taking manual combine groups into account
    tax_row_ids = [t.id for t in taxes]
    tax_combine_groups = _manual_combine_groups_by_rows("taxes", tax_row_ids)
    tax_id_to_group_idx = {}
    for idx, group in enumerate(tax_combine_groups):
        for r_id in group.get("row_ids", []):
            tax_id_to_group_idx[int(r_id)] = idx

    total_trans_val_idr = 0.0
    total_tax_ppn = 0.0
    total_tax_ppn_base = 0.0
    total_tax_pph21 = 0.0
    total_tax_pph21_base = 0.0
    total_tax_pph23 = 0.0
    total_tax_pph23_base = 0.0
    total_tax_pph26 = 0.0
    total_tax_pph26_base = 0.0
    total_tax_pemasukan_negara = 0.0
    total_tax_pemasukan_negara_base = 0.0

    for t in taxes:
        t_id = int(t.id)

        is_trans_val_dup = False
        is_ppn_dup = False
        is_pph21_dup = False
        is_pph23_dup = False
        is_pph26_dup = False

        if t_id in tax_id_to_group_idx:
            g_idx = tax_id_to_group_idx[t_id]
            group_meta = tax_combine_groups[g_idx]
            merged_cols = group_meta.get("merged_columns", [])
            group_row_ids = [int(rid) for rid in group_meta.get("row_ids", [])]
            if t_id != group_row_ids[0]:
                if "transaction_value" in merged_cols:
                    is_trans_val_dup = True
                if "ppn" in merged_cols:
                    is_ppn_dup = True
                if "pph_21" in merged_cols:
                    is_pph21_dup = True
                if "pph_23" in merged_cols:
                    is_pph23_dup = True
                if "pph_26" in merged_cols:
                    is_pph26_dup = True

        if not is_trans_val_dup:
            # ? FIX: Prioritize the column directly to avoid fallback to legacy values if col is 0
            val_idr = t.transaction_value_idr
            if val_idr is None:
                val_idr = t.idr_transaction_value or 0
            total_trans_val_idr += val_idr
        if not is_ppn_dup:
            total_tax_ppn += t.ppn or 0
            total_tax_ppn_base += t.ppn_base or 0
        if not is_pph21_dup:
            total_tax_pph21 += t.pph_21 or 0
            total_tax_pph21_base += t.pph_21_base or 0
        if not is_pph23_dup:
            total_tax_pph23 += t.pph_23 or 0
            total_tax_pph23_base += t.pph_23_base or 0
        if not is_pph26_dup:
            total_tax_pph26 += t.pph_26 or 0
            total_tax_pph26_base += t.pph_26_base or 0

        # Pemasukan Negara deduplication
        is_pemasukan_dup = False
        if t_id in tax_id_to_group_idx:
            if t_id != group_row_ids[0] and "pemasukan_negara" in merged_cols:
                is_pemasukan_dup = True

        if not is_pemasukan_dup:
            total_tax_pemasukan_negara += t.pemasukan_negara or 0
            total_tax_pemasukan_negara_base += t.pemasukan_negara_base or 0

    # Calculate combined actual tax payment (matching Excel's Penerimaan Negara)
    total_tax_paid = (
        total_tax_ppn
        + total_tax_pph21
        + total_tax_pph23
        + total_tax_pph26
        + total_tax_pemasukan_negara
    )

    return {
        "year": year,
        "is_all_years": year == 0,
        "revenue": {
            "data": revenue_data,
            "combine_groups": revenue_combine_groups,
            "total_invoice_value": total_invoice_value,
            "total_invoice_value_usd": total_invoice_value_usd,
            "total_invoice_value_idr": total_invoice_value,
            "total_amount_received": total_amount_received,
            "total_amount_received_idr": total_amount_received,
            "total_amount_received_usd": total_amount_received_usd,
            "total_ppn": total_rev_ppn,
            "total_pph23": total_rev_pph23,
        },
        "tax": {
            "data": tax_data,
            "combine_groups": tax_combine_groups,
            "total_trans_val_idr": total_trans_val_idr,
            "total_tax_paid": total_tax_paid,
            "total_ppn": total_tax_ppn,
            "total_ppn_base": total_tax_ppn_base,
            "total_pph21": total_tax_pph21,
            "total_pph21_base": total_tax_pph21_base,
            "total_pph23": total_tax_pph23,
            "total_pph23_base": total_tax_pph23_base,
            "total_pph26": total_tax_pph26,
            "total_pph26_base": total_tax_pph26_base,
            "total_pemasukan_negara": total_tax_pemasukan_negara,
            "total_pemasukan_negara_base": total_tax_pemasukan_negara_base,
        },
        "dividend": {
            "data": dividend_data,
            "revenue_total": dividend_calc["revenue_total"],
            "revenue_direct": dividend_calc["revenue_direct"],
            "revenue_other_db": dividend_calc["revenue_other_db"],
            "other_income_setting": dividend_calc["other_income_setting"],
            "pph23_total": dividend_calc["pph23_total"],
            "total_cost": dividend_calc["total_cost"],
            "profit_before_tax": dividend_calc["profit_before_tax"],
            "tax_corporate_auto": dividend_calc["tax_corporate_auto"],
            "tax_shortfall": dividend_calc["tax_shortfall"],
            "tax_pph29_input": dividend_calc["tax_pph29_input"],
            "profit_after_tax_accounting": dividend_calc["profit_after_tax_accounting"],
            "profit_after_tax_cash": dividend_calc["profit_after_tax_cash"],
            "profit_retained": dividend_calc["profit_retained_setting"],
            "total_amount": dividend_calc[
                "dividend_distributed"
            ],  # Match Excel PAT - Retained
            "total_recipient_count": len(dividends),
            "dividend_per_person": dividend_calc["dividend_per_person"],
            "settings": dividend_setting.to_dict()
            if dividend_setting
            else {
                "year": year,
                "profit_retained": 0.0,
                "opening_cash_balance": 0.0,
                "accounts_receivable": 0.0,
                "prepaid_tax_pph23": 0.0,
                "prepaid_expenses": 0.0,
                "other_receivables": 0.0,
                "office_inventory": 0.0,
                "other_assets": 0.0,
                "accounts_payable": 0.0,
                "salary_payable": 0.0,
                "shareholder_payable": 0.0,
                "accrued_expenses": 0.0,
                "share_capital": 0.0,
                "retained_earnings_balance": 0.0,
            },
        },
        "operation_cost": {
            "data": [
                e for e in ordered_expense_data if not e.get("is_admin_fee_extra")
            ],
            "total_expenses": sum((e.get("amount") or 0) for e in ordered_expense_data),
        },
        "advance_operation_cost": {
            "data": [
                e
                for e in ordered_advance_expense_data
                if not e.get("is_admin_fee_extra")
            ],
            "total_expenses": sum(
                (e.get("amount") or 0) for e in ordered_advance_expense_data
            ),
        },
        "assets": {
            "data": asset_data,
            "total_purchase_price": sum(a["purchase_price"] for a in asset_data),
        },
        "bank_status": {"data": grouped_bank_status},
        "admin_fees": {
            "data": admin_fee_items,
            "total_admin_fee": sum((e.get("amount") or 0) for e in admin_fee_items),
        },
        "returned_funds": {
            "data": returned_funds_data,
            "total_returned": sum(x["returned_amount"] for x in returned_funds_data),
        },
        "debug_info": {
            "raw_counts": {
                "revenues": raw_rev_count,
                "settlements": raw_set_count,
                "completed_settlements": completed_set_count,
                "advances": raw_adv_count,
            },
            "explanation": f"Year {year}: Found {raw_rev_count} revenues and {raw_set_count} settlements. Note: only COMPLETED settlements are shown in report ({completed_set_count} found).",
        },
        "profit_loss_expenses": sorted_expenses,
        "advance_profit_loss_expenses": sorted_advance_expenses,
        "expense_group_order": group_names,
        "generated_at": datetime.now().isoformat(),
    }

