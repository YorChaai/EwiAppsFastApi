from typing import Any, Optional, List, Dict, Union
from datetime import date
from datetime import datetime
from sqlalchemy.orm import joinedload
from sqlalchemy import or_

from models import Settlement, Expense, Category, BankTransaction, db
import re

COMMON_SUBCATEGORY_ORDER = [
    "Rental Tool",
    "Sales",
    "Gaji",
    "Pembuatan Alat",
    "Allowance",
    "Data Processing",
    "Project Operation",
    "Sparepart",
    "Maintenance",
    "Software License",
    "Operation",
    "Sewa Ruangan",
    "Modal Kerja",
    "Team Building",
    "Biaya Bank & Admin",
]


def _validate_date(date_input: Any) -> Optional[datetime]:
    """Validate date format and return datetime object. Handles strings and date/datetime objects."""
    if not date_input:
        return None

    # If it's already a datetime object1
    if isinstance(date_input, datetime):
        return date_input

    # If it's a date object (but not datetime)
    if isinstance(date_input, date):
        return datetime.combine(date_input, datetime.min.time())

    try:
        # If it's a string
        return datetime.strptime(str(date_input), "%Y-%m-%d")
    except (ValueError, TypeError):
        return None

def _display_settlement_status(status: str) -> str:
    """Convert settlement status to display format."""
    return status

def _get_summary_approved_expenses(
    start_date: Optional[Union[str, date, datetime]] = None,
    end_date: Optional[Union[str, date, datetime]] = None,
    year: Optional[int] = None,
    mode: str = "report",
    company: str = "EWI Foundation",
) -> List[Expense]:
    """Get approved expenses (from Settlements). Cash Advance is excluded from expense reports as per revised master plan."""

    # 1. Fetch Expenses from Settlements — only completed settlements with valid items
    exp_query = (
        Expense.query.join(Settlement, Expense.settlement_id == Settlement.id)
        .filter(
            Expense.company == company,
            Expense.status.in_(["completed", "approved"]),
            Settlement.company == company,
            Settlement.status == "completed",
        )
    )

    # PRIORITAS: Filter berdasarkan mode report (report_year)
    if mode == "report" and year:
        exp_query = exp_query.filter(
            Settlement.report_year == year,
        )
    else:
        # Mode 'actual' atau 'range': Filter berdasarkan tanggal transaksi
        if start_date:
            validated = _validate_date(start_date)
            if validated:
                exp_query = exp_query.filter(Expense.date >= validated.date())

        if end_date:
            validated = _validate_date(end_date)
            if validated:
                exp_query = exp_query.filter(Expense.date <= validated.date())

    expenses = exp_query.all()
    return list(expenses)

def _expense_amount_for_summary(expense: Expense) -> float:
    """Get expense amount in IDR."""
    return expense.idr_amount or 0.0

def _get_display_subcategory(expense: Expense) -> str:
    """Get the consolidated subcategory label from the Expense model or description."""
    label = (expense.combined_subcategory_label or "").strip()
    if label:
        return label

    # Jika label kosong, coba ekstrak dari deskripsi format [Subkategori]
    if expense.description:
        match = re.match(r"^\[(.*?)\]", expense.description.strip())
        if match:
            return match.group(1).strip()

    return ""

def _summary_display_category(expense, category_by_id, children_by_parent_name):
    category = category_by_id.get(expense.category_id)
    if not category:
        return None, None

    # Cari root (kategori paling atas)
    root = category
    path = [category]
    while root.parent_id and category_by_id.get(root.parent_id):
        root = category_by_id[root.parent_id]
        path.append(root)

    root_name = root.name or "-"

    # 1. PRIORITAS: Jika expense.category_id itu sendiri adalah subkategori (punya parent)
    # dan parent-nya adalah root, maka itu adalah anak langsung.
    if category.parent_id == root.id:
        return root, category

    # 2. Jika category_id adalah level yang lebih dalam (cucu), cari anak langsung dari root.
    if len(path) > 2:  # [category, child, root] -> length 3
        direct_child = path[-2]
        if direct_child.parent_id == root.id:
            return root, direct_child

    # 3. FALLBACK: Coba cocokkan berdasarkan label teks (inferred_subcategory)
    inferred_subcategory_name = _get_display_subcategory(expense)
    if inferred_subcategory_name:
        children_map = children_by_parent_name.get(root_name, {})
        key_search = inferred_subcategory_name.lower().strip()

        # Hilangkan prefix kode jika ada di key_search (misal 'A11-Sales' -> 'sales')
        if "-" in key_search:
            key_search = key_search.split("-", 1)[1].strip()

        for child_name, child_obj in children_map.items():
            c_name_low = child_name.lower().strip()
            # Hilangkan prefix kode di nama kategori database juga untuk perbandingan
            pure_child_name = c_name_low
            if "-" in pure_child_name:
                pure_child_name = pure_child_name.split("-", 1)[1].strip()

            # Cocokkan jika nama murni sama, atau salah satu mengandung yang lain
            if (
                key_search == pure_child_name
                or key_search == c_name_low
                or key_search in pure_child_name
                or pure_child_name in key_search
            ):
                return root, child_obj
    # Jika expense dicatat langsung di kategori Induk (category_id == root_id)
    return root, None

def _build_summary_payload(expenses, company: str = "EWI Foundation"):
    all_categories = (
        Category.query.filter(Category.company == company)
        .order_by(db.func.length(Category.code).asc(), Category.code.asc())
        .all()
    )
    # Ambil kategori akar (parent_id is None) - Urutkan alami (A, B, C...)
    root_categories = [cat for cat in all_categories if cat.parent_id is None]
    category_by_id = {cat.id: cat for cat in all_categories}
    children_by_parent_id = {}
    for cat in all_categories:
        if cat.parent_id is not None:
            children_by_parent_id.setdefault(cat.parent_id, []).append(cat)

    children_by_parent_name = {}
    for root in root_categories:
        children = children_by_parent_id.get(root.id, [])
        ordered_children = []
        used_ids = set()
        for child_name in COMMON_SUBCATEGORY_ORDER:
            match = next(
                (child for child in children if child.name == child_name), None
            )
            if match:
                ordered_children.append(match)
                used_ids.add(match.id)
        for child in children:
            if child.id not in used_ids:
                ordered_children.append(child)
        children_by_parent_name[root.name] = {
            child.name: child for child in ordered_children
        }

    summary_data = []
    grand_total = 0
    expense_map_by_root = {
        root.id: {"root_expenses": [], "child_expense_map": {}}
        for root in root_categories
    }

    for expense in expenses:
        mapped_root, mapped_child = _summary_display_category(
            expense,
            category_by_id,
            children_by_parent_name,
        )
        if not mapped_root:
            continue
        root_bucket = expense_map_by_root.setdefault(
            mapped_root.id,
            {"root_expenses": [], "child_expense_map": {}},
        )
        if mapped_child:
            root_bucket["child_expense_map"].setdefault(mapped_child.id, []).append(
                expense
            )
        else:
            root_bucket["root_expenses"].append(expense)

    for root in root_categories:
        root_bucket = expense_map_by_root.get(root.id, {})
        root_expenses = root_bucket.get("root_expenses", [])
        child_expense_map = root_bucket.get("child_expense_map", {})

        children = list(children_by_parent_name.get(root.name, {}).values())
        children_list = []

        # 1. Proses Subkategori Resmi
        for child in children:
            child_expenses = child_expense_map.get(child.id, [])
            monthly = {str(i): 0 for i in range(1, 13)}
            yearly_total = 0
            for e in child_expenses:
                month_str = str(e.date.month)
                amount = _expense_amount_for_summary(e)
                monthly[month_str] += amount
                yearly_total += amount

            # Tambahkan ke grand_total hanya di level ini
            grand_total += yearly_total

            children_list.append(
                {
                    "category": f"{child.code} - {child.name}",
                    "monthly": monthly,
                    "yearly_total": yearly_total,
                    "is_parent": False,
                    "level": 1,
                }
            )

        # 2. Proses Baris Sisa (Yang masuk langsung ke Root)
        if root_expenses:
            combine_monthly = {str(i): 0 for i in range(1, 13)}
            combine_yearly_total = 0
            labels = set()
            for e in root_expenses:
                month_str = str(e.date.month)
                amount = _expense_amount_for_summary(e)
                combine_monthly[month_str] += amount
                combine_yearly_total += amount

                lbl = _get_display_subcategory(e)
                if lbl:
                    labels.add(lbl)

            grand_total += combine_yearly_total

            label_str = " - ".join(sorted(list(labels))) if labels else "Uncategorized"
            # Jangan gunakan kode dummy '0', gunakan kode Root saja agar tidak membingungkan
            children_list.insert(
                0,
                {
                    "category": f"{root.code} (Other) - {label_str}",
                    "monthly": combine_monthly,
                    "yearly_total": combine_yearly_total,
                    "is_parent": False,
                    "level": 1,
                },
            )
        # 3. Hitung Total Kategori Induk (dari semua baris di children_list)
        parent_monthly = {str(i): 0 for i in range(1, 13)}
        parent_yearly_total = 0.0

        for child_row in children_list:
            for i in range(1, 13):
                month_key = str(i)
                parent_monthly[month_key] += child_row["monthly"].get(month_key, 0) or 0
            parent_yearly_total += child_row.get("yearly_total", 0) or 0

        # Masukkan baris INDUK
        summary_data.append(
            {
                "category": f"{root.code} - {root.name}",
                "monthly": parent_monthly,
                "yearly_total": parent_yearly_total,
                "is_parent": True,
                "level": 0,
            }
        )

        # Masukkan semua anak (termasuk baris combine tadi)
        summary_data.extend(children_list)

    return summary_data, grand_total

