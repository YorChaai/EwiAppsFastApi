import json
from config import Config

def allowed_file(filename):
    allowed = Config.ALLOWED_EXTENSIONS
    return "." in filename and filename.rsplit(".", 1)[1].lower() in allowed

def _parse_checklist_notes(notes_value):
    if not notes_value:
        return []
    raw = str(notes_value).strip()
    if not raw.startswith("["):
        return []
    try:
        parsed = json.loads(raw)
    except (ValueError, TypeError):
        return []
    if not isinstance(parsed, list):
        return []
    normalized = []
    for item in parsed:
        if isinstance(item, dict) and "text" in item:
            normalized.append(
                {
                    "text": str(item.get("text", "")).strip(),
                    "checked": bool(item.get("checked", False)),
                }
            )
        elif isinstance(item, str):
            normalized.append({"text": item.strip(), "checked": False})
    return [item for item in normalized if item["text"]]

def _has_unchecked_checklist(item):
    checklist = _parse_checklist_notes(item.notes)
    return bool(checklist) and any(not note["checked"] for note in checklist)

def _has_unchecked_return_checklist(doc):
    checklist = _parse_checklist_notes(doc.return_notes)
    return bool(checklist) and any(not note["checked"] for note in checklist)

def _merge_rejection_notes(old_notes_str, new_notes_str):
    """Gabungkan komentar reject baru ke checklist lama (append)."""
    import json as json_mod

    old_list = []

    # 1. Parse old notes
    if old_notes_str and str(old_notes_str).strip().startswith("["):
        try:
            parsed_old = json_mod.loads(str(old_notes_str))
            if isinstance(parsed_old, list):
                for item in parsed_old:
                    if isinstance(item, dict) and "text" in item:
                        old_list.append(
                            {
                                "text": str(item["text"]),
                                "checked": bool(item.get("checked", False)),
                            }
                        )
                    elif isinstance(item, str):
                        old_list.append({"text": str(item), "checked": False})
            else:
                old_list = [{"text": str(old_notes_str), "checked": False}]
        except (ValueError, TypeError):
            old_list = [{"text": str(old_notes_str), "checked": False}]
    elif old_notes_str:
        old_list = [{"text": str(old_notes_str).strip(), "checked": False}]

    # 2. Parse new notes - check if it's already JSON
    if new_notes_str and str(new_notes_str).strip().startswith("["):
        try:
            new_list = json_mod.loads(str(new_notes_str))
            if isinstance(new_list, list):
                for item in new_list:
                    if isinstance(item, dict) and "text" in item:
                        old_list.append(
                            {
                                "text": str(item["text"]),
                                "checked": bool(item.get("checked", False)),
                            }
                        )
                    elif isinstance(item, str):
                        old_list.append({"text": str(item), "checked": False})
                return json_mod.dumps(old_list)
        except Exception:
            pass

    # 3. Fallback: treat as plain text
    new_reasons = [
        line.strip() for line in str(new_notes_str).strip().split("\n") if line.strip()
    ]
    for r in new_reasons:
        old_list.append({"text": str(r), "checked": False})
    return json_mod.dumps(old_list)

def _parse_date(date_str):
    if not date_str:
        return None
    from datetime import datetime
    try:
        return datetime.fromisoformat(date_str.replace("Z", "+00:00")).date()
    except ValueError:
        return None

def _parse_float_safe(value, default=None):
    if value is None:
        return default
    if isinstance(value, (int, float)):
        return float(value)
    s = str(value).strip().replace(" ", "")
    if not s:
        return default
    if "." in s and "," in s:
        if s.rfind(",") > s.rfind("."):
            s = s.replace(".", "").replace(",", ".")
        else:
            s = s.replace(",", "")
    elif "," in s:
        parts = s.split(",")
        if len(parts) == 2 and len(parts[1]) <= 2:
            s = s.replace(".", "").replace(",", ".")
        else:
            s = s.replace(",", "")
    elif s.count(".") > 1:
        s = s.replace(".", "")
    try:
        return float(s)
    except (ValueError, TypeError):
        return default

def _parse_number_value(value):
    return _parse_float_safe(value, default=0.0)

import re

def _parse_category_ids(cat_input):
    if not cat_input:
        return []
    if isinstance(cat_input, str):
        return [int(x) for x in re.findall(r"\d+", cat_input)]
    if isinstance(cat_input, (int, float)):
        return [int(cat_input)]
    if isinstance(cat_input, (list, tuple)):
        res = []
        for item in cat_input:
            res.extend(_parse_category_ids(item))
        return list(dict.fromkeys(res))
    if hasattr(cat_input, "getlist"):
        raw_list = cat_input.getlist("category_ids") or cat_input.getlist("category_id")
        if not raw_list:
            single = cat_input.get("category_ids") or cat_input.get("category_id")
            if single:
                raw_list = [single]
        res = []
        for item in raw_list:
            if item:
                res.extend(_parse_category_ids(item))
        return list(dict.fromkeys(res))
    if isinstance(cat_input, dict):
        raw = cat_input.get("category_ids") or cat_input.get("category_id")
        return _parse_category_ids(raw)
    return []




from datetime import datetime
def _default_report_year():
    return datetime.now().year

def _year_date_bounds(year):
    try:
        y = int(year)
    except:
        y = _default_report_year()
    return f"{y}-01-01", f"{y}-12-31"

def _parse_iso_date(date_str):
    if not date_str:
        return None
    try:
        if hasattr(date_str, "strftime"):
            return date_str
        return datetime.strptime(str(date_str)[:10], "%Y-%m-%d").date()
    except ValueError:
        return None
