import os
from fastapi import APIRouter, Body, Depends, Header
from fastapi.responses import JSONResponse
from core.security import get_current_user
from services.reports.annual_service.caching import clear_annual_report_cache

from models import Category, CategoryGroup, User, Expense, AdvanceItem, advance_item_subcategories, db
from services.core.notification_events import (
    notify_category_approved,
    notify_category_created,
    notify_category_rejected,
)

categories_router = APIRouter(prefix="/api/categories", tags=["categories"])




@categories_router.get("/groups")
def list_category_groups(
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    _user: User = Depends(get_current_user),
):
    company = company or "EWI Foundation"
    groups = (
        CategoryGroup.query.filter_by(company=company)
        .order_by(CategoryGroup.sort_order)
        .all()
    )

    # Seeding if empty for this company
    if not groups:
        defaults = [
            ("BEBAN LANGSUNG", 0),
            ("BEBAN TIDAK LANGSUNG", 1),
            ("BIAYA ADMINISTRASI DAN UMUM", 2),
        ]
        for name, order in defaults:
            g = CategoryGroup(name=name, sort_order=order, company=company)
            db.session.add(g)
        db.session.commit()
        groups = (
            CategoryGroup.query.filter_by(company=company)
            .order_by(CategoryGroup.sort_order)
            .all()
        )

    return {"groups": [g.to_dict() for g in groups]}


@categories_router.post("/groups")
def create_category_group(
    data: dict = Body(...),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    user: User = Depends(get_current_user),
):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)

    name = data.get("name", "").strip()
    company = company or "EWI Foundation"

    if not name:
        return JSONResponse({"error": "Nama grup wajib diisi"}, status_code=400)

    # Max sort order
    max_order = (
        db.session.query(db.func.max(CategoryGroup.sort_order))
        .filter_by(company=company)
        .scalar()
        or 0
    )

    group = CategoryGroup(name=name, sort_order=max_order + 1, company=company)
    db.session.add(group)
    db.session.commit()
    clear_annual_report_cache()
 
    return JSONResponse({"group": group.to_dict()}, status_code=201)


@categories_router.put("/groups/{group_id:int}")
def update_category_group(group_id: int, data: dict = Body(...), user: User = Depends(get_current_user)):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)

    group = CategoryGroup.query.get_or_404(group_id)
    old_name = group.name

    if "name" in data:
        new_name = data["name"].strip()
        if new_name and new_name != old_name:
            # Update all categories using this group name
            Category.query.filter_by(main_group=old_name, company=group.company).update(
                {Category.main_group: new_name}
            )
            group.name = new_name

    if "sort_order" in data:
        group.sort_order = data["sort_order"]

    db.session.commit()
    clear_annual_report_cache()
    return {"group": group.to_dict()}


@categories_router.put("/groups/reorder")
def reorder_category_groups(data: dict = Body(...), user: User = Depends(get_current_user)):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)

    if not data or "groups" not in data:
        return JSONResponse({"error": "Data grup tidak ditemukan"}, status_code=400)

    try:
        for g_data in data["groups"]:
            g_id = g_data.get("id")
            sort_order = g_data.get("sort_order")
            if g_id is not None and sort_order is not None:
                group = CategoryGroup.query.get(g_id)
                if group:
                    group.sort_order = sort_order
        db.session.commit()
        clear_annual_report_cache()
        return {"message": "Urutan grup berhasil disimpan"}
    except Exception as e:
        db.session.rollback()
        return JSONResponse({"error": str(e)}, status_code=500)


@categories_router.delete("/groups/{group_id}")
def delete_category_group(group_id: int, user: User = Depends(get_current_user)):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)

    group = CategoryGroup.query.get_or_404(group_id)

    # Check if any categories still use this group
    has_cats = Category.query.filter_by(
        main_group=group.name, company=group.company
    ).first()
    if has_cats:
        return JSONResponse(
            {
                "error": f'Grup "{group.name}" masih digunakan oleh beberapa kategori. Pindahkan kategori tersebut terlebih dahulu.'
            }, status_code=400
        )

    db.session.delete(group)
    db.session.commit()
    clear_annual_report_cache()
    return {"message": "Grup berhasil dihapus"}


@categories_router.get("")
def list_categories(
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    user: User = Depends(get_current_user),
):
    # list semua kategori (staff hanya approved dan miliknya, manager semua)
    company = company or "EWI Foundation"

    if user.role in ["manager", "super_manager"]:
        cats = (
            Category.query.filter_by(parent_id=None, status="approved", company=company)
            .order_by(Category.sort_order)
            .all()
        )
    else:
        from sqlalchemy import or_

        cats = (
            Category.query.filter(
                Category.parent_id == None,
                Category.company == company,
                or_(Category.status == "approved", Category.created_by == user.id),
            )
            .order_by(Category.sort_order)
            .all()
        )

    return {"categories": [c.to_dict(include_children=True) for c in cats]}


@categories_router.put("/reorder")
def reorder_categories(
    data: dict = Body(...),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    user: User = Depends(get_current_user),
):
    """
    Reorder categories (manager only).
    Expects: {'categories': [{'id': 1, 'sort_order': 1, 'main_group': '...'}, ...]}
    """
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(
            {"error": "Akses ditolak. Hanya manager yang bisa mengubah urutan kategori"}
            , status_code=403
        )

    if not data or "categories" not in data:
        return JSONResponse({"error": "Data kategori tidak ditemukan"}, status_code=400)

    categories_data = data["categories"]

    try:
        for cat_data in categories_data:
            cat_id = cat_data.get("id")
            sort_order = cat_data.get("sort_order")
            main_group = cat_data.get("main_group")

            if cat_id is None:
                continue

            category = Category.query.get(cat_id)
            if category:
                if sort_order is not None:
                    category.sort_order = sort_order
                if main_group is not None:
                    category.main_group = main_group

        db.session.commit()
        clear_annual_report_cache()
 
        company = company or "EWI Foundation"
        updated_cats = (
            Category.query.filter_by(parent_id=None, company=company)
            .order_by(Category.sort_order)
            .all()
        )
        return {
            {
                "message": "Urutan dan grup kategori berhasil disimpan",
                "categories": [c.to_dict() for c in updated_cats],
            }
        }

    except Exception as e:
        db.session.rollback()
        return JSONResponse({"error": f"Gagal menyimpan urutan: {str(e)}"}, status_code=500)


@categories_router.get("/pending")
def list_pending(
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    user: User = Depends(get_current_user),
):
    # manager only: list pending kategori
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)

    company = company or "EWI Foundation"
    pending = Category.query.filter_by(status="pending", company=company).all()
    return {"categories": [c.to_dict() for c in pending]}


@categories_router.post("")
def create_category(
    data: dict = Body(...),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    user: User = Depends(get_current_user),
):
    # buat kategori baru: staff -> pending, manager -> approved
    company = company or "EWI Foundation"

    name = data.get("name", "").strip()
    parent_id = data.get("parent_id")

    if not name:
        return JSONResponse({"error": "Nama kategori wajib diisi"}, status_code=400)

    # buat kode unik
    existing_codes = [c.code for c in Category.query.filter_by(company=company).all()]
    if parent_id:
        parent = Category.query.get(parent_id)
        if not parent:
            return JSONResponse({"error": "Parent kategori tidak ditemukan"}, status_code=404)
        # kode subkategori: parent_code + angka
        base = parent.code
        idx = 1
        while f"{base}{idx}" in existing_codes:
            idx += 1
        code = f"{base}{idx}"
    else:
        # kode top-level: huruf berikutnya
        import string

        for letter in string.ascii_uppercase:
            if letter not in existing_codes:
                code = letter
                break
        else:
            code = f"X{len(existing_codes)}"

    # All new categories start as 'pending' to follow the strict approval flow
    status = "pending"

    # Set default main_group for top-level categories
    default_group = "BIAYA ADMINISTRASI DAN UMUM"
    if not parent_id:
        direct_keywords = [
            "operasi",
            "research",
            "r&d",
            "r & d",
            "sewa peralatan",
            "interpretasi",
            "log data",
            "project",
        ]
        if any(k in name.lower() for k in direct_keywords):
            default_group = "BEBAN LANGSUNG"

    cat = Category(
        name=name,
        code=code,
        parent_id=parent_id,
        status=status,
        created_by=user.id,
        main_group=default_group if not parent_id else None,
        company=company,
    )
    db.session.add(cat)
    db.session.flush()  # Get ID before commit

    # Auto-create "-" subcategory for top-level
    if not parent_id:
        sub_code = f"{code}0"
        sub_cat = Category(
            name="-",
            code=sub_code,
            parent_id=cat.id,
            status=status,
            created_by=user.id,
            company=company,
        )
        db.session.add(sub_cat)

    db.session.commit()
    clear_annual_report_cache()
 
    # Notify managers about new category creation
    notify_category_created(cat, user)

    return JSONResponse({"category": cat.to_dict()}, status_code=201)


@categories_router.put("/{cat_id}")
def update_category(cat_id: int, data: dict = Body(...), user: User = Depends(get_current_user)):
    # update kategori (manager only)
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)

    cat = Category.query.get_or_404(cat_id)

    if "name" in data:
        cat.name = data["name"].strip()
    if "parent_id" in data:
        cat.parent_id = data["parent_id"]
    if "main_group" in data:
        cat.main_group = data["main_group"]

    db.session.commit()
    clear_annual_report_cache()
    return {"category": cat.to_dict()}


@categories_router.delete("/{cat_id}")
def delete_category(cat_id: int, user: User = Depends(get_current_user)):
    # hapus kategori (manager only, jika tidak ada relasi expense)
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)

    cat = Category.query.get_or_404(cat_id)

    # cek apakah kategori atau children punya expense
    if cat.expenses:
        return JSONResponse({"error": "Kategori memiliki expense, tidak bisa dihapus"}, status_code=400)
    for child in cat.children:
        if child.expenses:
            return JSONResponse(
                {"error": f'Sub-kategori "{child.name}" memiliki expense'}, status_code=400
            )

    # hapus children dulu
    for child in cat.children:
        db.session.delete(child)

    db.session.delete(cat)
    db.session.commit()
    clear_annual_report_cache()
    return {"message": "Kategori dihapus"}


@categories_router.post("/{cat_id}/approve")
def approve_category(
    cat_id: int,
    data: dict = Body(default={}),
    user: User = Depends(get_current_user),
):
    # manager approve kategori pending
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)

    cat = Category.query.get_or_404(cat_id)
    if cat.status != "pending":
        return JSONResponse({"error": "Kategori sudah diapprove"}, status_code=400)

    action = data.get("action", "approve")

    try:
        if action == "approve":
            cat.status = "approved"
            # Auto-approve "-" subcategory if it exists
            for child in cat.children:
                if child.name == "-" and child.status == "pending":
                    child.status = "approved"
        elif action == "reject":
            # Check if category is used
            expenses_count = Expense.query.filter_by(category_id=cat.id).count()
            advance_items_count = AdvanceItem.query.filter_by(category_id=cat.id).count()
            subcats_count = db.session.query(advance_item_subcategories).filter_by(category_id=cat.id).count()
            
            if expenses_count > 0 or advance_items_count > 0 or subcats_count > 0:
                return JSONResponse({"error": "Tidak dapat menolak kategori ini karena masih digunakan pada rincian item Kasbon atau Settlement."}, status_code=400)
                
            # Check children usage
            for child in cat.children:
                c_expenses = Expense.query.filter_by(category_id=child.id).count()
                c_advances = AdvanceItem.query.filter_by(category_id=child.id).count()
                c_subcats = db.session.query(advance_item_subcategories).filter_by(category_id=child.id).count()
                if c_expenses > 0 or c_advances > 0 or c_subcats > 0:
                    return JSONResponse({"error": f"Tidak dapat menolak kategori ini karena sub-kategori '{child.name}' masih digunakan pada rincian item Kasbon atau Settlement."}, status_code=400)

            # Cascade delete children
            for child in cat.children:
                db.session.delete(child)
            db.session.delete(cat)
        else:
            return JSONResponse({"error": "Action harus approve atau reject"}, status_code=400)

        db.session.commit()
        clear_annual_report_cache()
 
        # Notify staff who created the category
        created_by_user = User.query.get(cat.created_by) if cat.created_by else None
        if created_by_user and action == "approve":
            notify_category_approved(cat, user, created_by_user.id)
        elif created_by_user and action == "reject":
            notify_category_rejected(cat, user, created_by_user.id)

        return {"message": f"Kategori {action}d", "status": "success"}
    except Exception as e:
        db.session.rollback()
        return JSONResponse({"error": f"Gagal memproses kategori: {str(e)}"}, status_code=500)
