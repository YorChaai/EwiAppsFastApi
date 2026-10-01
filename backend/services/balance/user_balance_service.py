from models import BankAccount, User, Advance, Settlement, db
from services.balance.balance_service import (
    calculate_bank_real_balance,
    calculate_bank_composition,
    calculate_user_running_balance,
)
from sqlalchemy.orm import joinedload


def get_all_users_balance_breakdown(company: str = "EWI Foundation") -> dict:
    banks = BankAccount.query.filter(
        BankAccount.company == company, 
        BankAccount.account_type != "advance"
    ).all()
    main_bank_ids = [b.id for b in banks]
    users = User.query.all()

    result = {}
    for u in users:
        global_outstanding = calculate_user_running_balance(u.id, company)

        advance_banks = BankAccount.query.filter(
            BankAccount.company == company,
            BankAccount.account_type == "advance",
            BankAccount.user_id == u.id,
        ).all()

        user_budget = sum(calculate_bank_real_balance(ab.id) for ab in advance_banks)

        # 1. Calculate cash_composition (Komposisi uang Plafon / Virtual Bank per bank asal)
        cash_comp_list = []
        for adv_bank in advance_banks:
            real_bal = calculate_bank_real_balance(adv_bank.id)
            if real_bal <= 0.01:
                continue
            comp = calculate_bank_composition(adv_bank.id, main_bank_ids)
            has_comp = False
            for bank_id, amount in comp.items():
                if amount > 0.01:
                    b = next((b for b in banks if b.id == bank_id), None)
                    if b:
                        cash_comp_list.append({
                            "bank_id": b.id,
                            "bank_name": b.name,
                            "balance": amount
                        })
                        has_comp = True
            if not has_comp:
                cash_comp_list.append({
                    "bank_id": adv_bank.id,
                    "bank_name": adv_bank.name,
                    "balance": real_bal
                })

        # 2. Calculate breakdown (Kasbon / Hutang Berjalan aktif per bank)
        advances = Advance.query.options(joinedload(Advance.items)).filter(
            Advance.user_id == u.id,
            Advance.company == company,
            Advance.status.in_(['approved', 'completed', 'in_settlement']),
            Advance.bank_id.isnot(None),
            db.or_(Advance.is_disbursement_approved == True, Advance.status.in_(['completed', 'in_settlement']))
        ).order_by(Advance.id.asc()).all()

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
                    'bank_name': (adv.disbursement_source or '').strip() or 'Lainnya',
                    'amount': net_amount,
                    'rem': net_amount
                })
            elif net_amount < -0.01:
                neg_advances.append({
                    'id': adv.id,
                    'title': adv.title,
                    'description': adv.description or '',
                    'disbursement_source': (adv.disbursement_source or '').strip(),
                    'amount': abs(net_amount)
                })

        user_settlements = Settlement.query.filter(
            Settlement.user_id == u.id,
            Settlement.company == company,
            Settlement.status.in_(["approved", "completed"])
        ).options(joinedload(Settlement.expenses)).all()

        settlement_priority_maps = {}
        settlement_bank_maps = {}
        for s in user_settlements:
            p_map = {}
            b_list = []
            r_cnt = 0
            for exp in (getattr(s, 'expenses', []) or []):
                src = (getattr(exp, 'source', '') or '').strip()
                if src and src != '-':
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
                        else:
                            b_list.append(part.lower())
            if p_map:
                settlement_priority_maps[s.id] = p_map
            if b_list:
                settlement_bank_maps[s.id] = b_list

        for neg in neg_advances:
            ded_amount = neg['amount']
            ref_s_id = None
            if 'Ref: #' in neg['title']:
                try:
                    ref_s_id = int(neg['title'].split('Ref: #')[1].replace(')', '').strip())
                except Exception:
                    pass
            
            p_map = settlement_priority_maps.get(ref_s_id, {})
            b_list = settlement_bank_maps.get(ref_s_id, [])
            neg_src = neg.get('disbursement_source', '').lower()
            if neg_src and neg_src not in b_list and neg_src != 'lainnya':
                b_list = [neg_src] + b_list

            def match_score(x):
                if x['id'] in p_map:
                    return (0, p_map[x['id']], x['id'])
                x_bname = (x['bank_name'] or '').strip().lower()
                if b_list and any(b in x_bname or x_bname in b for b in b_list):
                    return (1, 0, x['id'])
                neg_desc = (neg.get('title', '') + ' ' + neg.get('description', '')).lower()
                if x_bname and x_bname in neg_desc:
                    return (1, 0, x['id'])
                return (2, 999, x['id'])

            matching_pos = [
                p for p in pos_advances 
                if p['rem'] > 0.01 and (
                    p['id'] in p_map or (
                        b_list and any(b in (p['bank_name'] or '').strip().lower() or (p['bank_name'] or '').strip().lower() in b for b in b_list)
                    )
                )
            ]
            
            target_pos = matching_pos if matching_pos else [p for p in pos_advances if p['rem'] > 0.01]
            sorted_pos = sorted(target_pos, key=match_score)
            
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

        breakdown = []
        for (b_id, s_name), adv_list in source_advances.items():
            bal = sum(a['amount'] for a in adv_list)
            if bal > 0.01:
                max_single = max([a['amount'] for a in adv_list], default=bal)
                breakdown.append({
                    "bank_id": b_id,
                    "bank_name": s_name,
                    "currency": "IDR", 
                    "balance": bal,
                    "max_single_advance": max_single,
                    "advances_count": len(adv_list),
                    "advances": adv_list,
                })
        
        completed_settlements = Settlement.query.filter(
            Settlement.user_id == u.id,
            Settlement.company == company,
            Settlement.status.in_(["approved", "completed"]),
        ).options(joinedload(Settlement.expenses)).all()
        total_settled = sum((s.approved_amount or 0.0) for s in completed_settlements)

        result[str(u.id)] = {
            "user_id": u.id,
            "user_full_name": u.full_name,
            "user_role": u.role,
            "company": company,
            "active_advance_balance": global_outstanding,
            "available_budget": user_budget,
            "cash_composition": cash_comp_list,
            "breakdown": breakdown,
            "total_settled": total_settled,
        }

    return result


def get_user_balance_breakdown(user_id: int, company: str = "EWI Foundation") -> dict:
    all_data = get_all_users_balance_breakdown(company)
    if str(user_id) in all_data:
        return all_data[str(user_id)]
        
    user = User.query.get(user_id)
    if not user:
        raise ValueError("User not found")
        
    global_outstanding = calculate_user_running_balance(user_id, company)
    return {
        "user_id": user_id,
        "user_full_name": user.full_name,
        "user_role": user.role,
        "company": company,
        "active_advance_balance": global_outstanding,
        "available_budget": 0.0,
        "cash_composition": [],
        "breakdown": [],
        "total_settled": 0.0,
    }
