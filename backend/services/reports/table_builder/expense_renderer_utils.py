from utils.report_helpers import _safe_text, _to_float, _idr_from_currency
from models import Category
import re
from typing import List, Dict
import logging

logger = logging.getLogger(__name__)

def _expense_column_mapping_name(expense, category_by_id_map=None):
    category_name = _safe_text(expense.get("category_name")).strip()
    if category_name:
        return category_name

    category_id = expense.get("category_id")
    if category_id is None:
        return ""

    # Use provided map if available, otherwise fallback to query
    if category_by_id_map:
        category = category_by_id_map.get(category_id)
    else:
        category = Category.query.get(category_id)

    if not category:
        return ""

    while category.parent_id:
        if category_by_id_map:
            parent = category_by_id_map.get(category.parent_id)
        else:
            parent = Category.query.get(category.parent_id)
        if not parent:
            break
        category = parent
    return _safe_text(category.name).strip()


def _expense_amount_for_display(expense):
    nominal_idr = _to_float(expense.get("idr_amount"))
    if nominal_idr != 0:
        return nominal_idr
    return _idr_from_currency(
        expense.get("amount"),
        expense.get("currency"),
        expense.get("currency_exchange"),
    )


def _expense_subcategory_label(expense):
    """
    Extract subcategory from expense.
    Priority:
    1. subcategory_name field from database (set in payload as combined_subcategory_label)
    2. [SubCategory] prefix in description
    3. 'Subcategory: X' in notes
    4. Keyword matching from description (fallback)
    """
    label = ""
    # ? PRIORITY 1: Database value (populated as combined_subcategory_label in payload)
    subcategory_name = _safe_text(expense.get("subcategory_name")).strip()
    if subcategory_name:
        label = subcategory_name
    else:
        raw_desc = _safe_text(expense.get("description")).strip()

        # ? PRIORITY 2: Check [SubCategory] prefix in description (same as Flutter)
        prefixed = re.match(r"^\[(.*?)\]\s*(.*)$", raw_desc)
        if prefixed:
            prefix = _safe_text(prefixed.group(1)).strip()
            if prefix:
                label = prefix

        if not label:
            # ? PRIORITY 3: Check notes for "Subcategory: X" pattern (same as Flutter)
            notes = _safe_text(expense.get("notes")).strip()
            note_match = re.search(
                r"\bSubcategory:\s*([^|]+)", notes, flags=re.IGNORECASE
            )
            if note_match:
                note_subcategory = _safe_text(note_match.group(1)).strip()
                if note_subcategory:
                    label = note_subcategory

        if not label:
            # ? PRIORITY 4: Keyword matching from description (EXACTLY LIKE FLUTTER)
            desc = raw_desc.lower()

            # Match Flutter's keyword order exactly
            if "rental tool" in desc:
                label = "Rental Tool"
            elif "sales" in desc:
                label = "Sales"
            elif "gaji" in desc or "bonus" in desc:
                label = "Gaji"
            elif "pembuatan alat" in desc or "mesin retort" in desc:
                label = "Pembuatan Alat"
            elif "thr" in desc or "allowance" in desc:
                label = "Allowance"
            elif "data processing" in desc:
                label = "Data Processing"
            elif "moving slickline" in desc or "project lampu" in desc:
                label = "Project Operation"
            elif (
                "sampling tool" in desc
                or "sparepart" in desc
                or "ups biaya import" in desc
            ):
                label = "Sparepart"
            elif "repair esor" in desc:
                label = "Maintenance"
            elif "licence" in desc or "license" in desc:
                label = "Software License"
            elif "handphone operational" in desc:
                label = "Operation"
            elif "sewa ruangan" in desc or "virtual office" in desc:
                label = "Sewa Ruangan"
            elif "modal kerja" in desc:
                label = "Modal Kerja"
            elif "team building" in desc:
                label = "Team Building"
            elif "biaya transaksi bank" in desc:
                label = "Biaya Bank & Admin"

    # ? STEP 5: Strip internal suffixes like (A), (Q), (J), etc. for clean output
    # This regex matches a space followed by a bracketed uppercase string at the end of the label
    if label:
        label = re.sub(r"\s*\([A-Z]+\)$", "", label.strip())

    return label or ""


def _group_expenses_by_subcategory(expenses):
    """
    Group expenses by subcategory, sorted by parent category sort_order first,
    then subcategory A-Z within the same parent.
    Returns dict with sorted subcategories and uncategorized list.
    """
    groups = {}
    group_sort_order = {}  # subcat_label -> (category_sort_order, subcat_label_lower)
    uncategorized = []

    for e in expenses:
        subcat = _expense_subcategory_label(e).strip()
        if not subcat:
            uncategorized.append(e)
        else:
            if subcat not in groups:
                groups[subcat] = []
                # Record parent category sort_order for this subcat
                cat_sort = int(e.get("category_sort_order") or 999)
                group_sort_order[subcat] = (cat_sort, subcat.lower())
            groups[subcat].append(e)

    # Sort: parent category sort_order first, then subcategory A-Z
    def _subcategory_sort_key(s):
        return group_sort_order.get(s, (999, s.lower()))

    sorted_subcats = sorted(groups.keys(), key=_subcategory_sort_key)

    return {
        "groups": {subcat: groups[subcat] for subcat in sorted_subcats},
        "uncategorized": uncategorized,
    }


