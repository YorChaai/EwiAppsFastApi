from models import BankAccount
import json
from models import Advance, AdvanceItem, db

def get_cash_composition_for_error(advance):
    from services.balance.balance_service import (
        calculate_bank_composition,
        calculate_bank_real_balance,
    )

    # Cari semua bank advance milik user ini
    advance_banks = BankAccount.query.filter(
        BankAccount.account_type == "advance",
        BankAccount.user_id == advance.user_id,
        BankAccount.company == advance.company,
    ).all()

    total_composition = {}
    main_banks_query = BankAccount.query.filter(
        BankAccount.company == advance.company, 
        BankAccount.account_type != "advance"
    ).all()
    main_bank_ids = [b.id for b in main_banks_query]

    for adv_bank in advance_banks:
        real_bal = calculate_bank_real_balance(adv_bank.id)
        if real_bal <= 0.01:
            continue

        # Coba hitung komposisi (asal usul uang dari bank utama)
        comp = calculate_bank_composition(adv_bank.id, main_bank_ids)

        has_comp = False
        for bank_id, amount in comp.items():
            b = next((b for b in main_banks_query if b.id == bank_id), None)
            if b and amount > 0.01:
                total_composition[b.name] = total_composition.get(b.name, 0.0) + amount
                has_comp = True

        # Jika komposisi tidak ketemu (miss), tampilkan nama akunnya sebagai fallback
        if not has_comp:
            total_composition[adv_bank.name] = (
                total_composition.get(adv_bank.name, 0.0) + real_bal
            )

    return total_composition


def normalize_source(value):
    if not value:
        return "-"
    val_str = str(value).strip()
    if val_str.lower() in ("null", "none", "", "-"):
        return "-"
    return val_str


def _advance_view_status_filter(query, status_filter):
    if not status_filter:
        return query
    if status_filter == "approved":
        # Finalized advances are now 'completed'.
        return query.filter(Advance.status.in_(["approved", "completed", "in_settlement"]))
    if status_filter in ("rejected", "revision"):
        # Include advances with status 'rejected' OR advances with rejected items
        has_rejected_items = db.exists().where(
            db.and_(
                AdvanceItem.advance_id == Advance.id, AdvanceItem.status == "rejected"
            )
        )
        return query.filter(
            db.or_(
                Advance.status.in_(
                    [
                        "rejected",
                        "revision",
                    ]
                ),
                has_rejected_items,
                Advance.return_status == "rejected",
            )
        )
    if status_filter == "completed":
        return query.filter_by(status="completed")
    return query.filter_by(status=status_filter)


def _editable_revision_no(advance):
    if advance.status in ("draft", "rejected", "revision"):
        return 0
    return None


def _items_for_revision(advance, revision_no):
    return [item for item in advance.items if (item.revision_no or 0) == revision_no]


def _next_revision_no(advance):
    return (advance.approved_revision_no or 0) + 1


def _status_after_approval(advance):
    return "approved"


