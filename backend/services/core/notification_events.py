from models import db, Notification, User

DEFAULT_COMPANY = "EWI Foundation"

def create_notification(user_id, actor_id, action_type, target_type, target_id, message, link_path, company=None):
    """Create a notification in the database"""
    if company is None:
        company = DEFAULT_COMPANY
    try:
        notification = Notification(
            user_id=user_id,
            actor_id=actor_id,
            action_type=action_type,
            target_type=target_type,
            target_id=target_id,
            message=message,
            read_status=False,
            link_path=link_path,
            company=company,
        )
        db.session.add(notification)
        db.session.commit()
        return notification
    except Exception as e:
        db.session.rollback()
        print(f"Error creating notification: {str(e)}")
        return None

def notify_managers(action_type, target_type, target_id, message, staff_id, link_path, company=None):
    """Notify all managers about an action"""
    if company is None:
        company = DEFAULT_COMPANY
    managers = User.query.filter(User.role.in_(['manager', 'super_manager'])).all()
    for manager in managers:
        create_notification(
            user_id=manager.id,
            actor_id=staff_id,
            action_type=action_type,
            target_type=target_type,
            target_id=target_id,
            message=message,
            link_path=link_path,
            company=company,
        )

def notify_staff(user_id, action_type, target_type, target_id, message, actor_id, link_path, company=None):
    """Notify staff member about manager action"""
    if company is None:
        company = DEFAULT_COMPANY
    create_notification(
        user_id=user_id,
        actor_id=actor_id,
        action_type=action_type,
        target_type=target_type,
        target_id=target_id,
        message=message,
        link_path=link_path,
        company=company,
    )



# ==============================================================================
# NOTIFICATION EVENTS
# ==============================================================================
# Centralized logic for dispatching notifications with standardized messages.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. ADVANCES (KASBON)
# ------------------------------------------------------------------------------


def notify_advance_submitted(advance, user, parts_str):
    message = f"melakukan submit kasbon: {advance.title} (Pembaruan: {parts_str})"
    notify_managers(
        "submit", "advance", advance.id, message, user.id, f"/advances/{advance.id}", company=advance.company
    )


def notify_advance_revision_started(advance, user):
    message = (
        f"memulai revisi kasbon: {advance.title} (Revisi #{advance.active_revision_no})"
    )
    notify_managers(
        "revise", "advance", advance.id, message, user.id, f"/advances/{advance.id}", company=advance.company
    )


def notify_advance_approved_final(advance, manager):
    # Final approval confirmation
    final_message = f"Kasbon '{advance.title}' Anda telah disetujui final."
    notify_staff(
        advance.user_id,
        "complete",
        "advance",
        advance.id,
        final_message,
        manager.id,
        f"/advances/{advance.id}",
        company=advance.company,
    )


def notify_advance_rejected_final(advance, manager, notes):
    message = f"Kasbon Anda telah ditolak: {advance.title}. Alasan: {notes}"
    notify_staff(
        advance.user_id,
        "reject",
        "advance",
        advance.id,
        message,
        manager.id,
        f"/advances/{advance.id}",
        company=advance.company,
    )


def notify_advance_item_approved(advance, item, manager):
    pass  # Dimatikan untuk mencegah spam per-item


def notify_advance_item_rejected(advance, item, manager):
    pass  # Dimatikan untuk mencegah spam per-item


# ------------------------------------------------------------------------------
# 2. SETTLEMENTS
# ------------------------------------------------------------------------------


def notify_settlement_submitted(settlement, user, parts_str):
    message = (
        f"melakukan submit settlement: {settlement.title} (Pembaruan: {parts_str})"
    )
    notify_managers(
        "submit",
        "settlement",
        settlement.id,
        message,
        user.id,
        f"/settlements/{settlement.id}",
        company=settlement.company,
    )


def notify_settlement_approved_item(settlement, manager):
    pass  # Dimatikan untuk mencegah spam per-item


def notify_settlement_rejected(settlement, manager, notes):
    message = f"Settlement Anda telah ditolak: {settlement.title}. Alasan: {notes}"
    notify_staff(
        settlement.user_id,
        "reject",
        "settlement",
        settlement.id,
        message,
        manager.id,
        f"/settlements/{settlement.id}",
        company=settlement.company,
    )


def notify_settlement_approved_final(settlement, manager):
    message = f"Settlement Anda '{settlement.title}' telah disetujui final."
    notify_staff(
        settlement.user_id,
        "manager_approved_final",
        "settlement",
        settlement.id,
        message,
        manager.id,
        f"/settlements/{settlement.id}",
        company=settlement.company,
    )


# ------------------------------------------------------------------------------
# 3. EXPENSES
# ------------------------------------------------------------------------------


def _expense_owner_id(expense):
    settlement = getattr(expense, "settlement", None)
    return getattr(settlement, "user_id", None)


def notify_expense_approved(expense, manager):
    pass  # Dimatikan untuk mencegah spam per-item


def notify_expense_rejected(expense, manager):
    pass  # Dimatikan untuk mencegah spam per-item


# ------------------------------------------------------------------------------
# 4. CATEGORIES
# ------------------------------------------------------------------------------


def notify_category_created(category, user):
    message = f"membuat kategori baru: {category.name}"
    notify_managers("create", "category", category.id, message, user.id, "/categories", company=category.company)


def notify_category_approved(category, manager, created_by_user_id):
    message = f"Kategori '{category.name}' Anda telah disetujui"
    notify_staff(
        created_by_user_id,
        "approve",
        "category",
        category.id,
        message,
        manager.id,
        "/categories",
        company=category.company,
    )


def notify_category_rejected(category, manager, created_by_user_id):
    message = f"Kategori '{category.name}' Anda telah ditolak"
    notify_staff(
        created_by_user_id,
        "reject",
        "category",
        category.id,
        message,
        manager.id,
        "/categories",
        company=category.company,
    )


# ------------------------------------------------------------------------------
# 5. AUTH / USER
# ------------------------------------------------------------------------------


def notify_user_registered(new_user, full_name, username, role):
    message = f"terdaftar sebagai user baru (@{username}) - Role: {role}"
    notify_managers("register", "user", new_user.id, message, new_user.id, "/settings", company=DEFAULT_COMPANY)


def notify_user_returned(user, days_since_last_login):
    message = f"login setelah {days_since_last_login} hari tidak aktif"
    managers = __import__("models").User.query.filter_by(role="manager").all()
    for manager in managers:
        create_notification(
            user_id=manager.id,
            actor_id=user.id,
            action_type="return_login",
            target_type="user",
            target_id=user.id,
            message=message,
            link_path="/settings",
            company=DEFAULT_COMPANY,
        )


# ------------------------------------------------------------------------------
# 6. REVENUES
# ------------------------------------------------------------------------------


def notify_revenue_created(revenue, user):
    message = f"mendaftarkan Revenue baru: {revenue.source_name} sebesar Rp {revenue.idr_amount:,.0f}"
    notify_managers(
        "create", "revenue", revenue.id, message, user.id, "/reports/revenue", company=revenue.company
    )


def notify_revenue_updated(revenue, user):
    pass  # Dimatikan untuk mencegah spam edit/typo


def notify_revenue_deleted(revenue, user):
    message = f"menghapus data Revenue: {revenue.source_name}"
    notify_managers(
        "delete", "revenue", revenue.id, message, user.id, "/reports/revenue", company=revenue.company
    )


# ------------------------------------------------------------------------------
# 7. TAXES
# ------------------------------------------------------------------------------


def notify_tax_created(tax, user):
    message = (
        f"menambahkan data Pajak baru: {tax.tax_name} sebesar Rp {tax.idr_amount:,.0f}"
    )
    notify_managers("create", "tax", tax.id, message, user.id, "/reports/tax", company=tax.company)


def notify_tax_updated(tax, user):
    pass  # Dimatikan untuk mencegah spam edit/typo


def notify_tax_deleted(tax, user):
    message = f"menghapus data Pajak: {tax.tax_name}"
    notify_managers("delete", "tax", tax.id, message, user.id, "/reports/tax", company=tax.company)


# ------------------------------------------------------------------------------
# 8. BANKS
# ------------------------------------------------------------------------------


def notify_bank_created(bank, user, company=None):
    message = f"menambahkan Rekening Bank baru: {bank.name} - {bank.account_number}"
    notify_managers("create", "bank", bank.id, message, user.id, "/reports/bank", company=company or bank.company)


def notify_bank_transaction_created(transaction, bank, user, company=None):
    # Ambil hanya bagian utama deskripsi (sebelum tanda '|' jika masih ada format lama)
    clean_desc = (transaction.description or "").split("|")[0].strip()
    message = f"menambahkan transaksi manual pada {bank.name}: {clean_desc}"
    notify_managers(
        "create", "bank_transaction", transaction.id, message, user.id, "/reports/bank", company=company or transaction.company
    )


# ------------------------------------------------------------------------------
# 9. ASSETS
# ------------------------------------------------------------------------------


def notify_asset_created(asset, user):
    message = f"mendaftarkan Aset baru: {asset.name}"
    notify_managers("create", "asset", asset.id, message, user.id, "/reports/asset", company=asset.company)


def notify_asset_updated(asset, user):
    pass  # Dimatikan untuk mencegah spam edit/typo


def notify_asset_deleted(asset, user):
    message = f"menghapus data Aset: {asset.name}"
    notify_managers("delete", "asset", asset.id, message, user.id, "/reports/asset", company=asset.company)


def _can_access_notification(user, notification):
    """Manager: akses penuh ke semua notifikasi. Staff/Mitra: hanya milik sendiri."""
    if notification.user_id == user.id:
        return True
    if user.role in ['manager', 'super_manager']:
        return True
    return False
