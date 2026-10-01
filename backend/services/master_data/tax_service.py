from sqlalchemy import extract
from models import db, Tax, ManualCombineGroup

def _validate_manual_tax_group(year, row_ids, company):
    try:
        report_year = int(year)
    except Exception:
        return None, "Tahun laporan tidak valid."

    clean_ids = []
    for row_id in row_ids or []:
        try:
            clean_ids.append(int(row_id))
        except Exception:
            continue
    clean_ids = list(dict.fromkeys(clean_ids))
    if len(clean_ids) < 2:
        return None, "Pilih minimal 2 data pajak untuk combine."

    items = Tax.query.filter(Tax.company == company).filter(Tax.id.in_(clean_ids)).all()
    if len(items) != len(clean_ids):
        return None, "Sebagian data pajak tidak ditemukan."

    non_null_dates = [item.date for item in items if item.date]
    if not non_null_dates:
        return None, "Combine pajak perlu minimal satu tanggal yang terisi."
    # Gunakan tanggal pertama yang ditemukan sebagai group_date

    positions = {
        row_id: idx
        for idx, (row_id,) in enumerate(
            db.session.query(Tax.id)
            .filter(Tax.company == company)
            .filter(
                db.or_(
                    Tax.report_year == report_year,
                    db.and_(
                        Tax.report_year.is_(None),
                        extract("year", Tax.date) == report_year,
                    ),
                )
            )
            .order_by(Tax.id.asc())
            .all()
        )
    }
    selected_positions = sorted(positions.get(row_id, -1) for row_id in clean_ids)
    if -1 in selected_positions:
        return None, "Data pajak yang dipilih tidak sesuai tahun laporan."
    if selected_positions[-1] - selected_positions[0] + 1 != len(selected_positions):
        return None, "Combine pajak hanya bisa untuk baris yang berurutan."

    overlap = ManualCombineGroup.query.filter_by(
        table_name="taxes",
        report_year=report_year,
        company=company,
    ).all()
    for group in overlap:
        existing_ids = set(group.row_ids())
        if existing_ids.intersection(clean_ids):
            return (
                None,
                "Ada data pajak yang sudah masuk combine lain. Lepas combine lama dulu.",
            )

    return {
        "group_date": non_null_dates[0],
        "row_ids": clean_ids,
    }, None

