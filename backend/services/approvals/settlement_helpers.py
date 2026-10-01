import json
from datetime import datetime, timezone
from models import BankTransaction, Advance, db
from utils.workflow_helper import log_workflow

def _sync_advance_after_settlement(settlement):
    """
    Sync Advance status based on Settlement status in 1-to-1 strict mode.
    """
    if not settlement.advance_id:
        return
        
    from models import Advance, db
    advance = Advance.query.get(settlement.advance_id)
    if not advance:
        return

    # If settlement is completed, advance is completed
    if settlement.status == 'completed':
        advance.status = 'completed'
    # If settlement is rejected and has no active revisions, maybe back to approved?
    # But usually settlement stays rejected until revised. 
    # Let's mark it as 'in_settlement' if settlement is active
    elif settlement.status in ['draft', 'submitted', 'approved', 'revision']:
        advance.status = 'in_settlement'
    
    db.session.commit()


def rollback_settlement_transactions(settlement, user, reason_label):
    from models import Advance, OverrideLog
    from services.balance.balance_service import calculate_user_available_budget, calculate_user_running_balance

    current_plafon = calculate_user_available_budget(
        settlement.user_id, settlement.company
    )
    current_hutang = calculate_user_running_balance(
        settlement.user_id, settlement.company
    )

    # The amount restored to Plafon is the cash disbursed (reimbursement/lebih bayar) and returned amount
    disbursed_amount = getattr(settlement, "disbursed_amount", 0.0) or 0.0
    returned_amount = settlement.returned_amount or 0.0
    plafon_restored = disbursed_amount - returned_amount

    req_name = settlement.creator.full_name if settlement.creator else "Karyawan"

    # Cari transaksi bank yang akan di-rollback
    txns = BankTransaction.query.filter(
        db.or_(
            BankTransaction.description.like(f"%(Ref: #{settlement.id})%"),
            BankTransaction.description.like(f"Pencairan Settlement - {req_name}%"),
            BankTransaction.description.like(f"Pengembalian Dana - {req_name}%"),
        ),
        BankTransaction.company == settlement.company,
    ).all()

    # Cari kompensasi Advance yang akan di-rollback
    # PREFER precise matching via (Ref: #ID). Only fallback to exact title match if there's ONLY ONE exact title match.
    comp_advances = Advance.query.filter(
        Advance.company == settlement.company,
        Advance.user_id == settlement.user_id,
        Advance.title.endswith(f"(Ref: #{settlement.id})")
    ).all()

    # Fallback to legacy fuzzy matching ONLY if no precise match is found
    if not comp_advances:
        fuzzy_advances = Advance.query.filter(
            Advance.company == settlement.company,
            Advance.user_id == settlement.user_id,
            db.or_(
                Advance.title == f"Kompensasi Split Kasbon: {settlement.title}",
                Advance.title == f"Split Potongan Kasbon: {settlement.title}",
                Advance.title == f"Penyelesaian Kasbon: {settlement.title}",
            ),
        ).all()
        # To be safe, only rollback if there's exactly one fuzzy match OR if they were created recently.
        # But actually, if we just delete the most recent one that matches the amount? No, that's risky.
        # It's better to just delete all fuzzy matches ONLY if we are sure. But since it's a bug, let's just delete ONE matching advance.
        if fuzzy_advances:
            # Sort by ID descending (newest first) and just take ONE to prevent wiping out unrelated advances.
            fuzzy_advances.sort(key=lambda x: x.id, reverse=True)
            comp_advances = [fuzzy_advances[0]]

    hutang_restored = sum(
        abs(a.approved_amount_override or a.disbursed_amount or 0.0)
        for a in comp_advances
    )

    actually_deleted_items = len(txns) > 0 or len(comp_advances) > 0

    from services.balance.user_balance_service import get_all_users_balance_breakdown
    all_bk = get_all_users_balance_breakdown(settlement.company).get(str(settlement.user_id), {})
    bk_list = all_bk.get("breakdown", [])

    allocations = []
    source_bank_names = []
    for adv in comp_advances:
        b_name = (adv.disbursement_source or "").strip()
        amt = abs(adv.approved_amount_override or adv.disbursed_amount or 0.0)
        if b_name:
            source_bank_names.append(b_name)
            bank_item = next((b for b in bk_list if b["bank_name"].lower() == b_name.lower()), None)
            cur_b_amt = bank_item["balance"] if bank_item else 0.0
            allocations.append({
                "bank_name": b_name,
                "amount": amt,
                "starting_hutang": cur_b_amt,
                "remaining_hutang": cur_b_amt + amt,
            })

    # Lakukan rollback
    for txn in txns:
        db.session.delete(txn)

    for adv in comp_advances:
        db.session.delete(adv)

    # Catat pembatalan di OverrideLog HANYA JIKA ada transaksi yang dihapus
    # Atau jika ini adalah pembatalan settlement murni reimbursement (agar history tetap lengkap)
    if actually_deleted_items or (settlement.disbursed_amount or 0) > 0.01:
        doc_name = (
            settlement.title
            if settlement.settlement_type == "batch"
            else (
                settlement.expenses[0].description
                if settlement.expenses
                else settlement.title
            )
        )

        real_bank_name = ", ".join(list(dict.fromkeys(source_bank_names))) if source_bank_names else (settlement.disbursement_source or "Bank Cash")
        if real_bank_name in ("Plafon Virtual", "Lain-lainnya", "-"):
            real_bank_name = "Bank Cash"

        log_payload = {
            "type": "reversal",
            "source_bank": real_bank_name,
            "bank_name": real_bank_name,
            "recipient_name": req_name,
            "amount": plafon_restored + hutang_restored,
            "plafon_restored": plafon_restored,
            "hutang_restored": hutang_restored,
            "cash_restored": settlement.disbursed_amount or 0.0,
            "starting_balance": current_plafon,
            "revised_amount": current_plafon + plafon_restored,
            "starting_hutang": current_hutang,
            "remaining_hutang": current_hutang + hutang_restored,
            "hutang": current_hutang + hutang_restored,
            "reason": reason_label,
            "document_name": doc_name,
            "performer": user.full_name,
            "target_bank": real_bank_name,
            "allocations": allocations if allocations else [],
        }
        log_entry = OverrideLog(
            item_id=settlement.id,
            item_type="settlement",
            changed_by=user.id,
            original_amount=current_plafon,
            revised_amount=current_plafon + plafon_restored,
            notes="JSON:" + json.dumps(log_payload),
        )
        db.session.add(log_entry)


