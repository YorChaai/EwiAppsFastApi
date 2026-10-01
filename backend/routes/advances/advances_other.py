import json
from datetime import datetime, timezone

from fastapi import APIRouter, Body, Depends, Header, Request
from fastapi.responses import JSONResponse
from core.security import get_current_user
from models import (
    Advance,
    BankAccount,
    BankTransaction,
    User,
    db,
)
from sqlalchemy.orm import joinedload



advances_other_router = APIRouter(prefix="/api/advances", tags=["advances"])


def _query_int(request: Request, key: str):
    try:
        return int(request.query_params.get(key))
    except (TypeError, ValueError):
        return None


@advances_other_router.put("/{advance_id}/override")
def override_advance(advance_id: int, data: dict = Body(default={}), user: User = Depends(get_current_user)):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content=
            {"error": "Akses ditolak. Hanya manager yang bisa override data final"}
        , status_code=403)

    advance = Advance.query.get_or_404(advance_id)
    if "bank_id" in data:
        advance.bank_id = data["bank_id"]
    if "description" in data:
        advance.description = data["description"]
    if "status" in data:
        advance.status = data["status"]

    db.session.commit()
    return JSONResponse(content=
        {"message": "Data kasbon berhasil di-override", "advance": advance.to_dict()}
    , status_code=200)

@advances_other_router.post("/{advance_id}/move_to_draft")
def move_advance_to_draft(advance_id: int, user: User = Depends(get_current_user)):
    user_id = user.id
    advance = Advance.query.get_or_404(advance_id)

    is_manager = user.role in ["manager", "super_manager"]

    if not is_manager and advance.user_id != user_id:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)

    if advance.status in ("approved", "completed") and not is_manager:
        return JSONResponse(content=
            {
                "error": "Karyawan tidak bisa menarik Kasbon yang sudah Approved atau Completed. Hubungi Manajer."
            }
        , status_code=403)

    if advance.settlements:
        return JSONResponse(content={"error": "Kasbon ini tidak bisa ditarik ke draft karena sudah dipakai oleh Settlement. Tarik atau hapus Settlement terkait ke draft terlebih dahulu."}, status_code=400)

    if advance.status in ("submitted", "rejected", "approved", "completed"):
        contributes_to_balance = advance.status in ("approved", "completed") and (
            advance.is_disbursement_approved or advance.status == "completed"
        )
        if contributes_to_balance:
            is_advance_bank = False
            if advance.bank_id:
                from models import BankAccount

                b = BankAccount.query.get(advance.bank_id)
                if b and b.account_type == "advance":
                    is_advance_bank = True

            if is_advance_bank:
                from services.balance.balance_service import calculate_user_running_balance

                current_hutang = calculate_user_running_balance(
                    advance.user_id, advance.company
                )

                contribution = advance.approved_amount
                if advance.is_return_approved:
                    contribution -= advance.returned_amount

                simulated_hutang = current_hutang - contribution
                if simulated_hutang < -0.01:  # Allow tiny float precision errors
                    return JSONResponse(content=
                        {
                            "error": "Gagal ditarik ke draft! Saldo Virtual (Plafon) tidak mencukupi karena sudah terpakai oleh Settlement. Anda harus menarik/menghapus Settlement terkait ke draft terlebih dahulu."
                        }
                    , status_code=400)

        advance.status = "draft"
        
        # Reset items status to pending if they were submitted
        for item in advance.items:
            if item.status == "submitted":
                item.status = "pending"
                
    elif advance.status in ("revision"):
        advance.status = "draft"
    else:
        return JSONResponse(content=
            {"error": f"Status {advance.status} tidak bisa ditarik ke draft"}
        , status_code=400)

    # Reset tracking flags when moving back to draft
    advance.modified_t1 = False
    advance.modified_t2 = False
    advance.modified_t3 = False

    # Also pull back Table 3 to pending if it was submitted
    if advance.return_status == "submitted":
        advance.return_status = "pending"

    # ✅ FIX: is_disbursement_approved TIDAK direset paksa di sini.
    # Approval T2 & T3 hanya reset di save_disbursement / save_return jika data diubah.
    # Dengan ini, jika user hanya edit T1, approval T2 & T3 tetap valid.

    # ✅ FIX: Hapus transaksi bank yang sudah dibuat di Tabel 2 (Pencairan)
    # agar saldo kembali (rollback) dan Hutang menjadi 0 saat ditarik ke draft.

    req_name = advance.requester.full_name if advance.requester else "Karyawan"

    exact_main = f"Pencairan Kasbon - {req_name}: {advance.disbursement_comment or advance.title}"
    exact_virtual = f"Pencairan Kasbon (Plafon Virtual) - {req_name}: {advance.disbursement_comment or advance.title}"
    exact_return = (
        f"Pengembalian Dana - {req_name}: {advance.return_description or advance.title}"
    )

    txns = BankTransaction.query.filter(
        db.or_(
            BankTransaction.description.endswith(f"(Ref: #{advance.id})"),
            BankTransaction.description == exact_main,
            BankTransaction.description == exact_virtual,
            BankTransaction.description == exact_return,
        ),
        BankTransaction.company == advance.company,
        BankTransaction.amount_idr
        == (advance.disbursed_amount or advance.approved_amount or 0.0),
    ).all()

    actually_deleted_txns = len(txns) > 0

    from models import OverrideLog
    from services.balance.balance_service import (
        calculate_user_available_budget,
        calculate_user_running_balance,
    )

    # ✅ Hitung saldo SEBELUM transaksi dihapus (sebelum db.session.delete dipanggil)
    current_plafon = calculate_user_available_budget(advance.user_id, advance.company)
    current_hutang = calculate_user_running_balance(advance.user_id, advance.company)

    for t in txns:
        db.session.delete(t)

    # Catat pembatalan di OverrideLog HANYA JIKA ada transaksi yang dihapus

    amount_reversed = advance.disbursed_amount or advance.approved_amount or 0.0

    if amount_reversed > 0.01 and actually_deleted_txns:
        doc_name = (
            advance.title
            if advance.advance_type == "batch"
            else (advance.items[0].description if advance.items else advance.title)
        )
        reason_label = f"Pembatalan (Move to Draft) Kasbon ({'Batch' if advance.advance_type == 'batch' else 'Single'})"

        log_payload = {
            "type": "reversal",
            "source_bank": "Plafon Virtual",
            "recipient_name": req_name,
            "amount": amount_reversed,
            "starting_balance": current_plafon,
            "revised_amount": current_plafon + amount_reversed,
            "hutang": max(0.0, current_hutang - amount_reversed),
            "reason": reason_label,
            "document_name": doc_name,
            "performer": user.full_name,
            "target_bank": "Plafon Virtual",
        }
        log_entry = OverrideLog(
            item_id=advance.id,
            item_type="advance",
            changed_by=user.id,
            original_amount=current_plafon,
            revised_amount=current_plafon + amount_reversed,
            notes="JSON:" + json.dumps(log_payload),
        )
        db.session.add(log_entry)

    # Reset juga flag approval Tabel 2 karena uang sudah "ditarik balik"
    advance.is_disbursement_approved = False

    # Sinkronkan kembali disbursed_amount dengan total item yang disetujui di Tabel 1
    # agar saat di draft, angkanya tidak menjadi 0 tapi mengikuti Tabel 1.
    advance.disbursed_amount = advance.approved_amount

    db.session.commit()
    return JSONResponse(content=
        {
            "message": "Kasbon ditarik ke draft, saldo telah dikembalikan.",
            "advance": advance.to_dict(include_items=True),
        }
    , status_code=200)

@advances_other_router.post("/initialize_balance")
def initialize_balance(data: dict = Body(default={}), user: User = Depends(get_current_user), company: str = Header(default="EWI Foundation", alias="X-Company")):
    user_id = user.id
    current_user = user
    if current_user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)

    target_user_id = data.get("user_id")
    from utils.transaction_templates import TxTemplates
    notes = data.get("notes", TxTemplates.INIT_VIRTUAL)
    allocations = data.get("allocations", [])

    if not target_user_id or not allocations:
        return JSONResponse(content=
            {
                "error": "Data tidak lengkap. Pilih karyawan dan minimal satu sumber dana."
            }
        , status_code=400)

    target_user = User.query.get(target_user_id)
    if not target_user:
        return JSONResponse(content={"error": "Karyawan tidak ditemukan"}, status_code=404)

    from models import OverrideLog
    from services.balance.balance_service import (
        calculate_bank_real_balance,
        calculate_user_running_balance_per_bank,
    )

    company = company or "EWI Foundation"

    # Validation Phase
    for alloc in allocations:
        bank_id = alloc.get("bank_id")
        amount = alloc.get("amount")
        if not bank_id or amount is None:
            return JSONResponse(content={"error": "Data alokasi tidak valid."}, status_code=400)
        try:
            amount = float(amount)
        except (ValueError, TypeError):
            return JSONResponse(content={"error": "Nominal harus berupa angka"}, status_code=400)

        bank = BankAccount.query.get(bank_id)
        if not bank:
            return JSONResponse(content=
                {"error": f"Rekening bank asal dengan ID {bank_id} tidak ditemukan"}
            , status_code=404)

        # If adding funds, validate bank real balance
        if amount > 0.01:
            real_balance = calculate_bank_real_balance(bank_id)
            if amount > real_balance:
                import locale

                try:
                    locale.setlocale(locale.LC_ALL, "")
                except Exception:
                    pass
                return JSONResponse(content=
                    {
                        "error": f"Gagal mengalokasikan dana. Saldo {bank.name} saat ini ({bank.currency} {real_balance:,.2f}) tidak mencukupi untuk kebutuhan alokasi sebesar {bank.currency} {amount:,.2f}."
                    }
                , status_code=400)
        elif amount < -0.01:
            target_bank = BankAccount.query.filter(
                BankAccount.company == company,
                BankAccount.account_type == "advance",
                BankAccount.user_id == target_user.id,
            ).first()
            
            if not target_bank:
                return JSONResponse(content={"error": "Gagal menarik dana. Saldo virtual (plafon) tidak ditemukan."}, status_code=400)
            
            target_real_balance = calculate_bank_real_balance(target_bank.id)
            if abs(amount) > target_real_balance:
                import locale
                try:
                    locale.setlocale(locale.LC_ALL, "")
                except Exception:
                    pass
                return JSONResponse(content=
                    {
                        "error": f"Gagal menarik dana. Saldo virtual {target_user.full_name} saat ini ({bank.currency} {target_real_balance:,.2f}) tidak mencukupi untuk ditarik sebesar {bank.currency} {abs(amount):,.2f}."
                    }
                , status_code=400)
        else:
            return JSONResponse(content={"error": "Nominal alokasi tidak boleh bernilai 0."}, status_code=400)

    # Execution Phase
    total_added = 0.0
    import json

    for alloc in allocations:
        bank_id = alloc.get("bank_id")
        amount = float(alloc.get("amount"))
        bank = BankAccount.query.get(bank_id)

        # 1. Determine target bank account ("Advance [Recipient Name]")
        target_bank = BankAccount.query.filter(
            BankAccount.company == company,
            BankAccount.account_type == "advance",
            BankAccount.user_id == target_user.id,
        ).first()

        # 2. AUTO-CREATE target bank if missing
        if not target_bank:
            target_bank_name = "Plafon Virtual"
            target_bank = BankAccount(
                name=target_bank_name,
                account_type="advance",
                company=company,
                currency=bank.currency,
                initial_balance=0.0,
                user_id=target_user_id,
            )
            db.session.add(target_bank)

            db.session.flush()  # Get ID

        # Calculate Bank Real Balance for description progression
        from services.balance.balance_service import calculate_bank_real_balance

        bank_current_balance = calculate_bank_real_balance(bank_id)
        bank_new_balance = bank_current_balance - amount

        # 3. Create Bank Transactions (The core of "Top Up")

        is_addition = amount > 0
        direction_label = "Penambahan" if is_addition else "Penarikan"

        # Record single transfer transaction
        from_bank_id = bank_id if amount > 0 else target_bank.id
        to_bank_id = target_bank.id if amount > 0 else bank_id
        
        target_current = calculate_bank_real_balance(target_bank.id)
        target_new = target_current + amount
        
        direction_label = TxTemplates.RCV_ALLOCATION if amount > 0 else TxTemplates.PULL_ALLOCATION
        trx_desc = (
            f"{direction_label} dari {bank.name} ({current_user.full_name})|"
            f"{target_current}|{target_new}|{current_user.full_name.lower()}|"
            f"bank ({bank.name.lower()}) -> advance ({target_user.full_name.lower()})"
        )
        if notes and notes != TxTemplates.INIT_VIRTUAL:
            trx_desc += f"|{notes}"

        transfer_trx = BankTransaction(
            bank_id=from_bank_id,
            to_bank_id=to_bank_id,
            date=datetime.now(timezone.utc).date(),
            description=trx_desc,
            amount_idr=abs(amount),
            transaction_type="transfer",
            group_name="Alokasi Dana Advance",
            report_year=datetime.now().year,
            company=company,
        )
        db.session.add(transfer_trx)

        # 4. Write to OverrideLog for history
        starting_virtual = calculate_user_running_balance_per_bank(
            target_user_id, bank_id, company=company
        )

        # Construct a more descriptive reason for the logbook
        log_notes = TxTemplates.allocation_notes(
            direction_label, target_user.full_name, current_user.full_name, notes
        )

        log_payload = {
            "type": "rebalance",
            "source_bank": bank.name,
            "bank_name": bank.name,
            "target_user": target_user.full_name,
            "recipient_name": target_user.full_name,
            "amount": amount,
            "requested_amount": amount,
            "given_amount": amount,
            "starting_balance": target_current,
            "revised_amount": target_new,
            "notes": log_notes,
            "reason": log_notes,
            "performer": current_user.full_name,
            "manager_name": current_user.full_name,
            "target_bank": target_bank.name,
        }

        log_entry = OverrideLog(
            item_id=target_user_id,  # Link to User ID
            item_type="advance",  # Use 'advance' so it's picked up by filters
            changed_by=user_id,
            original_amount=target_current,
            revised_amount=target_new,
            notes="JSON:" + json.dumps(log_payload),
        )
        db.session.add(log_entry)

        total_added += amount

    db.session.commit()

    return JSONResponse(content=
        {"message": "Saldo virtual berhasil ditambahkan", "total_added": total_added}
    , status_code=200)

@advances_other_router.get("/override_logs")
def get_override_logs_list(request: Request, user: User = Depends(get_current_user)):
    item_type = request.query_params.get("item_type")
    item_id = _query_int(request, "item_id")
    target_user_id = _query_int(request, "user_id")

    from models import Advance, OverrideLog

    query = OverrideLog.query

    if item_type:
        if item_type == "advance":
            query = query.filter(OverrideLog.item_type.in_(["advance", "settlement"]))
        else:
            query = query.filter(OverrideLog.item_type == item_type)

    if item_id:
        query = query.filter(OverrideLog.item_id == item_id)

    if target_user_id and item_type == "advance":
        from models import Settlement
        from sqlalchemy import or_

        # Support document-level logs (Advance/Settlement) and user-level rebalance logs
        query = query.outerjoin(
            Advance,
            db.and_(
                OverrideLog.item_id == Advance.id, OverrideLog.item_type == "advance"
            ),
        ).outerjoin(
            Settlement,
            db.and_(
                OverrideLog.item_id == Settlement.id,
                OverrideLog.item_type == "settlement",
            ),
        )

        target_user = User.query.get(target_user_id)
        target_user_name = target_user.full_name if target_user else ""

        query = query.filter(
            or_(
                Advance.user_id == target_user_id,
                Settlement.user_id == target_user_id,
                db.and_(
                    OverrideLog.item_type == "advance",
                    OverrideLog.item_id == target_user_id,
                ),
                OverrideLog.notes.like(f'%\"recipient_name\": \"{target_user_name}\"%')
            )
        )

    logs = query.order_by(OverrideLog.changed_at.desc()).all()
    return JSONResponse(content={"logs": [log.to_dict() for log in logs]}, status_code=200)


@advances_other_router.get("/user_balances/{user_id}")
def get_user_balances(user_id: int, current_user: User = Depends(get_current_user), company: str = Header(default="EWI Foundation", alias="X-Company")):
    company = company or "EWI Foundation"
    user = User.query.get_or_404(user_id)

    # Cari advance (kasbon) yang approved/completed milik user ini
    from models import Advance
    advances = Advance.query.options(joinedload(Advance.items)).filter(
        Advance.user_id == user_id,
        Advance.company == company,
        Advance.status.in_(['approved', 'completed', 'in_settlement']),
        Advance.bank_id.isnot(None),
        db.or_(Advance.is_disbursement_approved == True, Advance.status.in_(['completed', 'in_settlement']))
    ).order_by(Advance.id.asc()).all()

    # Kumpulkan positive advances dan negative advances (deductions) secara kronologis (order by ID asc)
    pos_advances = []
    neg_advances = []

    for adv in advances:
        net_amount = (adv.approved_amount or 0.0)
        if adv.is_return_approved or (adv.returned_amount or 0.0) > 0:
            net_amount -= (adv.returned_amount or 0.0)
            
        if net_amount > 0.01:
            pos_advances.append({
                'id': adv.id,
                'title': adv.title,
                'bank_id': adv.bank_id,
                'bank_name': adv.disbursement_source or 'Lainnya',
                'amount': net_amount,
                'rem': net_amount
            })
        elif net_amount < -0.01:
            neg_advances.append({
                'id': adv.id,
                'title': adv.title,
                'amount': abs(net_amount)
            })

    # Map priority rank per settlement ID
    from models import Settlement
    user_settlements = Settlement.query.filter(
        Settlement.user_id == user_id,
        Settlement.company == company,
        Settlement.status.in_(['approved', 'completed'])
    ).all()

    settlement_priority_maps = {}
    for s in user_settlements:
        p_map = {}
        r_cnt = 0
        for exp in (getattr(s, 'expenses', []) or []):
            src = getattr(exp, 'source', '') or ''
            if src:
                for part in src.split(','):
                    part = part.strip()
                    if part.startswith('adv_'):
                        try:
                            adv_id_val = int(part.split('_')[1])
                            if adv_id_val not in p_map:
                                p_map[adv_id_val] = r_cnt
                                r_cnt += 1
                        except (IndexError, ValueError):
                            pass
        if p_map:
            settlement_priority_maps[s.id] = p_map

    # Terapkan pemotongan secara kronologis per transaksi negatif
    for neg in neg_advances:
        ded_amount = neg['amount']
        ref_s_id = None
        if 'Ref: #' in neg['title']:
            try:
                ref_s_id = int(neg['title'].split('Ref: #')[1].replace(')', '').strip())
            except Exception:
                pass
        
        p_map = settlement_priority_maps.get(ref_s_id, {})
        sorted_pos = sorted(
            [p for p in pos_advances if p['rem'] > 0.01],
            key=lambda x: (p_map.get(x['id'], 999), x['id'])
        )
        for item in sorted_pos:
            if ded_amount <= 0.01:
                break
            ded = min(item['rem'], ded_amount)
            item['rem'] -= ded
            ded_amount -= ded

    source_advances = {}
    for p in pos_advances:
        if p['rem'] > 0.01:
            key = (p['bank_id'], p['bank_name'])
            if key not in source_advances:
                source_advances[key] = []
            source_advances[key].append({
                'id': p['id'],
                'title': p['title'],
                'amount': p['rem']
            })

    balances = []
    for (b_id, s_name), adv_list in source_advances.items():
        valid_advs = [a for a in adv_list if a['amount'] > 0.01]
        bal = sum(a['amount'] for a in valid_advs)
        if bal > 0.01:
            max_single = max([a['amount'] for a in valid_advs], default=bal)
            balances.append({
                'bank_id': b_id,
                'bank_name': s_name,
                'balance': bal,
                'max_single_advance': max_single,
                'advances_count': len(valid_advs),
                'advances': valid_advs,
            })

    return JSONResponse(content={'balances': balances}, status_code=200)

