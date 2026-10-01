from models import Advance, BankAccount, BankTransaction, Settlement, db
from sqlalchemy.orm import joinedload


def calculate_bank_real_balance(bank_id):
    """
    Menghitung saldo riil fisik di rekening bank berdasarkan transaksi yang ada.
    Real Balance = Initial Balance + Sum(Income) - Sum(Expense) - Sum(Transfer Out) + Sum(Transfer In)
    """
    bank = db.session.get(BankAccount, bank_id)
    if not bank:
        return 0.0

    incomes = (
        db.session.query(db.func.sum(BankTransaction.amount_idr))
        .filter(
            BankTransaction.bank_id == bank_id,
            BankTransaction.transaction_type == "income",
        )
        .scalar()
        or 0.0
    )

    expenses = (
        db.session.query(db.func.sum(BankTransaction.amount_idr))
        .filter(
            BankTransaction.bank_id == bank_id,
            BankTransaction.transaction_type == "expense",
        )
        .scalar()
        or 0.0
    )

    transfers_out = (
        db.session.query(db.func.sum(BankTransaction.amount_idr))
        .filter(
            BankTransaction.bank_id == bank_id,
            BankTransaction.transaction_type == "transfer",
        )
        .scalar()
        or 0.0
    )

    transfers_in = (
        db.session.query(db.func.sum(BankTransaction.amount_idr))
        .filter(
            BankTransaction.to_bank_id == bank_id,
            BankTransaction.transaction_type == "transfer",
        )
        .scalar()
        or 0.0
    )

    real_balance = (
        bank.initial_balance + incomes - expenses - transfers_out + transfers_in
    )
    return real_balance


def _get_user_advance_banks(user_id, company):
    from models import BankAccount, User
    user = db.session.get(User, user_id)
    if not user:
        return []

    all_advance_banks = BankAccount.query.filter(
        BankAccount.company == company,
        BankAccount.account_type == "advance"
    ).all()
    
    matched = []
    for b in all_advance_banks:
        if b.user_id == user.id:
            matched.append(b)
            
    return matched


def calculate_user_running_balance(user_id, company="EWI Foundation"):
    """
    Menghitung sisa saldo kasbon (running balance) virtual yang dipegang oleh karyawan.
    Menggunakan akumulasi dari dokumen asli (Advances dan Settlements) melalui
    calculate_user_running_balance_per_bank, agar konsisten dan tahan terhadap transaksi refund.
    """
    from models import User

    user = db.session.get(User, user_id)
    if not user:
        return 0.0

    advance_banks = _get_user_advance_banks(user_id, company)

    if not advance_banks:
        return 0.0

    total_hutang = 0.0
    for bank in advance_banks:
        total_hutang += calculate_user_running_balance_per_bank(
            user_id, bank.id, company
        )

    return total_hutang


def calculate_user_available_budget(user_id, company="EWI Foundation"):
    """
    Menghitung saldo uang cash (real balance) yang ada di akun Bank Advance milik user.
    Ini adalah saldo yang bisa digunakan untuk menyetujui Kasbon baru.
    Mencari bank berdasarkan account_type='advance' dan nama yang mengandung nama user.
    """
    from models import User

    user = db.session.get(User, user_id)
    if not user:
        return 0.0

    advance_banks = _get_user_advance_banks(user_id, company)

    return sum(calculate_bank_real_balance(ab.id) for ab in advance_banks)


def calculate_user_running_balance_per_bank(user_id, bank_id, company="EWI Foundation"):
    """
    Menghitung sisa saldo kasbon virtual karyawan per bank sumber dana.
    Fix 500 error: Properties cannot be used in db.func.sum.
    """
    from models import BankAccount, User, db

    user = db.session.get(User, user_id)
    if not user:
        return 0.0

    # ✅ FIX: Pastikan bank_id yang diminta benar-benar bank advance milik user ini (mencegah tabrakan nama)
    req_bank = db.session.get(BankAccount, bank_id)
    if not req_bank:
        return 0.0

    advance_banks = _get_user_advance_banks(user_id, company)
    matched_bank_ids = [b.id for b in advance_banks]

    if req_bank.id not in matched_bank_ids:
        # Jika bank yang diquery bukan plafon yang cocok untuk user ini, return 0
        return 0.0

    # 1. Advances
    advances = (
        Advance.query.options(joinedload(Advance.items))
        .filter(
            Advance.user_id == user_id,
            Advance.status.in_(["approved", "completed", "in_settlement"]),
            Advance.company == company,
            Advance.bank_id == bank_id,
            db.or_(
                Advance.is_disbursement_approved == True, Advance.status == "completed"
            ),
        )
        .all()
    )
    
    total_advance = sum(adv.approved_amount for adv in advances)
    total_returned_advance = sum(
        adv.returned_amount for adv in advances if adv.is_return_approved
    )

    # 2. Settlements
    # (Removed to prevent double-deduction. Settlements are now tracked via dummy Advances created in final_approve_settlement)

    return total_advance - total_returned_advance


def get_all_bank_real_balances(company="EWI Foundation"):
    """
    Menghitung saldo riil semua bank sekaligus menggunakan GROUP BY untuk efisiensi.
    """
    banks = BankAccount.query.filter_by(company=company).all()
    balances = {b.id: b.initial_balance for b in banks}

    incomes = (
        db.session.query(
            BankTransaction.bank_id, db.func.sum(BankTransaction.amount_idr)
        )
        .filter(
            BankTransaction.company == company,
            BankTransaction.transaction_type == "income",
        )
        .group_by(BankTransaction.bank_id)
        .all()
    )
    for bank_id, total in incomes:
        if bank_id in balances:
            balances[bank_id] += total or 0.0

    expenses = (
        db.session.query(
            BankTransaction.bank_id, db.func.sum(BankTransaction.amount_idr)
        )
        .filter(
            BankTransaction.company == company,
            BankTransaction.transaction_type == "expense",
        )
        .group_by(BankTransaction.bank_id)
        .all()
    )
    for bank_id, total in expenses:
        if bank_id in balances:
            balances[bank_id] -= total or 0.0

    transfers_out = (
        db.session.query(
            BankTransaction.bank_id, db.func.sum(BankTransaction.amount_idr)
        )
        .filter(
            BankTransaction.company == company,
            BankTransaction.transaction_type == "transfer",
        )
        .group_by(BankTransaction.bank_id)
        .all()
    )
    for bank_id, total in transfers_out:
        if bank_id in balances:
            balances[bank_id] -= total or 0.0

    transfers_in = (
        db.session.query(
            BankTransaction.to_bank_id, db.func.sum(BankTransaction.amount_idr)
        )
        .filter(
            BankTransaction.company == company,
            BankTransaction.transaction_type == "transfer",
        )
        .group_by(BankTransaction.to_bank_id)
        .all()
    )
    for to_bank_id, total in transfers_in:
        if to_bank_id in balances:
            balances[to_bank_id] += total or 0.0

    return balances


def calculate_bank_composition(target_bank_id, main_bank_ids):
    """
    Menghitung komposisi sumber dana dari bank-bank utama ke bank target (Virtual Bank).
    Alokasi masuk dan keluar dari tiap bank utama dihitung secara eksak.
    Pengeluaran Kasbon/Settlement di-trace balik ke dokumen aslinya untuk memotong dari
    sumber dana (disbursement_source) yang spesifik. Sisa pengeluaran (jika ada) didistribusikan proporsional.
    """
    from models import BankTransaction, BankAccount, db
    import re

    # 1. Dapatkan saldo riil saat ini (sebagai target verifikasi akhir)
    current_balance = calculate_bank_real_balance(target_bank_id)
    if current_balance <= 0.01:
        return {b_id: 0.0 for b_id in main_bank_ids}

    # Ambil data main banks
    main_banks = BankAccount.query.filter(BankAccount.id.in_(main_bank_ids)).all()
    bank_names = {b.id: b.name for b in main_banks}

    composition = {b_id: 0.0 for b_id in main_bank_ids}

    # 2. Hitung Alokasi Masuk (Transfer Masuk dari Main Bank ke Target Bank Virtual) per sumber
    for b_id, b_name in bank_names.items():
        t_in = (
            db.session.query(db.func.sum(BankTransaction.amount_idr))
            .filter(
                BankTransaction.to_bank_id == target_bank_id,
                BankTransaction.bank_id == b_id,
                BankTransaction.transaction_type == "transfer",
            )
            .scalar()
            or 0.0
        )
        # Note: Transfer out from Virtual Bank to Main Bank (if any) could be calculated similarly if needed.
        # But typically we only allocate IN to virtual bank. If there's an out, it's also a transfer.
        t_out = (
            db.session.query(db.func.sum(BankTransaction.amount_idr))
            .filter(
                BankTransaction.bank_id == target_bank_id,
                BankTransaction.to_bank_id == b_id,
                BankTransaction.transaction_type == "transfer",
            )
            .scalar()
            or 0.0
        )
        composition[b_id] = t_in - t_out

    # 3. Cari pengeluaran Kasbon / Settlement
    # (Alokasi dana sudah berupa transfer, jadi tidak akan terbaca sebagai expense)
    expenses = BankTransaction.query.filter(
        BankTransaction.bank_id == target_bank_id,
        BankTransaction.transaction_type == "expense",
    ).all()

    # Pre-fetch untuk referensi agar cepat
    advances = Advance.query.all()
    adv_dict = {adv.id: adv for adv in advances}
    
    # Pre-fetch Settlements if any
    settlements = Settlement.query.all()
    set_dict = {s.id: s for s in settlements}

    unmatched_expense = 0.0

    for txn in expenses:
        source_name = None
        source_id = None
        
        # Coba identifikasi ID Advance (Kasbon)
        if "Kasbon" in txn.description:
            match = re.search(r"Ref: #(\d+)", txn.description)
            if match:
                adv = adv_dict.get(int(match.group(1)))
                if adv:
                    source_name = adv.disbursement_source
                    source_id = getattr(adv, "disbursement_source_id", None)

        # Coba identifikasi ID Settlement
        elif "Settlement" in txn.description:
            match = re.search(r"Ref: #(\d+)", txn.description)
            if match:
                s = set_dict.get(int(match.group(1)))
                if s:
                    source_name = s.disbursement_source
                    source_id = getattr(s, "disbursement_source_id", None)

        # Kurangi saldo spesifik berdasarkan ID langsung
        matched_b_id = None
        
        if source_id and source_id in bank_names:
            matched_b_id = source_id
        elif source_name:
            # Fallback to source_name if source_id is missing
            for b_id, b_name in bank_names.items():
                if b_name.strip().lower() == source_name.strip().lower():
                    matched_b_id = b_id
                    break
                elif source_name.lower() in b_name.strip().lower():
                    matched_b_id = b_id
                    break
        
        if matched_b_id:
            composition[matched_b_id] -= txn.amount_idr
        else:
            unmatched_expense += txn.amount_idr

    # 3b. Cari pemasukan Pengembalian Dana / Return ke Bank Advance
    incomes = BankTransaction.query.filter(
        BankTransaction.bank_id == target_bank_id,
        BankTransaction.transaction_type == "income",
    ).all()

    for txn in incomes:
        source_name = None
        source_id = None

        match = re.search(r"Ref: #(\d+)", txn.description)
        if match:
            s = set_dict.get(int(match.group(1)))
            if s:
                source_name = getattr(s, "return_source", None) or getattr(s, "disbursement_source", None)
                source_id = getattr(s, "return_source_id", None) or getattr(s, "disbursement_source_id", None)
            else:
                # Also check advances
                adv = adv_dict.get(int(match.group(1)))
                if adv:
                    source_name = getattr(adv, "return_source", None) or getattr(adv, "disbursement_source", None)
                    source_id = getattr(adv, "return_source_id", None) or getattr(adv, "disbursement_source_id", None)

        if not source_name and not source_id:
            # Try to match bank name in txn.description
            for b_id, b_name in bank_names.items():
                clean_name = b_name.strip().lower()
                if clean_name and clean_name != '-' and len(clean_name) > 1 and clean_name in txn.description.lower():
                    source_id = b_id
                    break

        matched_b_id = None
        if source_id and source_id in bank_names:
            matched_b_id = source_id
        elif source_name:
            for b_id, b_name in bank_names.items():
                if b_name.strip().lower() == source_name.strip().lower() or source_name.lower() in b_name.strip().lower():
                    matched_b_id = b_id
                    break

        if matched_b_id:
            composition[matched_b_id] += txn.amount_idr

    # 4. Jika ada expense yang tidak ter-mapping ke spesifik bank, ini menandakan data tidak lengkap
    if unmatched_expense > 0.01:
        # Peringatan: Ada expense lama yang tidak memiliki referensi source bank.
        # Kita abaikan exception ini agar tidak terjadi Server Error 500.
        # Proses scaling proporsional di step 5 akan otomatis menyesuaikan kekurangannya.
        pass

    # 5. Normalisasi Akhir
    # Pastikan tidak ada yang negatif (karena float precision)
    for b_id in composition:
        if composition[b_id] < 0:
            composition[b_id] = 0.0

    # Skala proporsional agar total pas dengan current_balance yang riil
    # (Untuk menangani selisih pembulatan atau data inkonsisten)
    total_comp_final = sum(composition.values())
    if total_comp_final > 0:
        scale = current_balance / total_comp_final
        for b_id in composition:
            composition[b_id] = composition[b_id] * scale

    return composition
