import math
import json
from datetime import datetime
from services.balance.balance_service import calculate_user_running_balance

class TransactionDTO:
    @staticmethod
    def advance_to_dict(instance, include_items=False):
        revision_summaries = []
        for revision_no in range(0, instance.max_revision_no + 1):
            revision_items = [
                item for item in instance.items if (item.revision_no or 0) == revision_no
            ]
            if not revision_items:
                continue
            revision_summaries.append(
                {
                    "revision_no": revision_no,
                    "label": "Pengajuan Awal"
                    if revision_no == 0
                    else f"Revisi {revision_no}",
                    "item_count": len(revision_items),
                    "total_amount": sum(
                        (item.idr_amount or 0) for item in revision_items
                    ),
                    "is_approved": revision_no <= (instance.approved_revision_no or 0),
                    "is_active": revision_no == instance.active_revision_no,
                }
            )

        policy_warnings = []
        if instance.active_revision_no:
            policy_warnings.append(
                f"Sedang ada draft/approval revisi {instance.active_revision_no}."
            )

        sorted_items = sorted(instance.items, key=lambda x: x.id, reverse=True)
        first_item = sorted_items[0] if sorted_items else None
        data = {
            "id": instance.id,
            "title": instance.title,
            "description": instance.description,
            "first_item_description": first_item.description if first_item else None,
            "advance_type": instance.advance_type or "single",
            "document_date": instance.document_date.isoformat()
            if instance.document_date
            else None,
            "report_year": instance.report_year,
            "user_id": instance.user_id,
            "requester_name": instance.requester.full_name if instance.requester else None,
            "requester_role": instance.requester.role if instance.requester else None,
            "requester_id": instance.requester.id if instance.requester else None,
            "requester_profile_image": instance.requester.profile_image
            if instance.requester
            else None,
            "status": instance.status,
            "notes": instance.notes,
            "total_amount": instance.total_amount,
            "approved_amount": instance.approved_amount,
            "approved_amount_override": instance.approved_amount_override,
            "rejected_count": instance.rejected_count,
            "item_count": len(instance.items),
            "revision_amount": instance.revision_amount,
            "approved_revision_no": instance.approved_revision_no or 0,
            "active_revision_no": instance.active_revision_no,
            "max_revision_no": instance.max_revision_no,
            "created_at": instance.created_at.isoformat() if instance.created_at else None,
            "updated_at": instance.updated_at.isoformat() if instance.updated_at else None,
            "approved_at": instance.approved_at.isoformat() if instance.approved_at else None,
            "bank_id": instance.bank_id,
            "disbursement_source": instance.disbursement_source,
            "disbursement_source_id": instance.disbursement_source_id,
            "return_source": instance.return_source,
            "return_source_id": instance.return_source_id,
            "admin_fee": instance.admin_fee,
            "disbursed_amount": instance.disbursed_amount,
            "returned_amount": instance.returned_amount or 0.0,
            "disbursement_comment": instance.disbursement_comment,
            "return_description": instance.return_description,
            "disbursement_evidence_path": instance.disbursement_evidence_path,
            "disbursement_evidence_filename": instance.disbursement_evidence_filename,
            "return_evidence_path": instance.return_evidence_path,
            "return_evidence_filename": instance.return_evidence_filename,
            "is_disbursement_approved": instance.is_disbursement_approved or False,
            "is_return_approved": instance.is_return_approved or False,
            "return_status": instance.return_status or "pending",
            "return_notes": instance.return_notes,
            "modified_t1": instance.modified_t1 or False,
            "modified_t2": instance.modified_t2 or False,
            "modified_t3": instance.modified_t3 or False,
            "current_stage": instance.current_stage or "draft",
            "expected_completion_at": instance.expected_completion_at.isoformat()
            if instance.expected_completion_at
            else None,
            "bank_name": instance.bank.name if instance.bank else None,
            "policy_warnings": policy_warnings,
            "revision_summaries": revision_summaries,
            "settlement_id": instance.settlements[0].id if instance.settlements else None,
        }

        # Calculate is_settled
        is_settled = False
        if instance.settlements:
            is_settled = any(s.status in ["approved", "completed"] for s in instance.settlements)
        
        if not is_settled and instance.status == "completed":
            remaining_balance = calculate_user_running_balance(
                instance.user_id, instance.company
            )
            if remaining_balance <= 0.01:
                is_settled = True
                
        data["is_settled"] = is_settled

        # Handle case requester is None (user deleted)
        if not instance.requester:
            data["requester_name"] = "User dihapus"
            data["requester_role"] = "unknown"
        if include_items:
            data["items"] = [i.to_dict() for i in instance.items]
        return data


    @staticmethod
    def advanceitem_to_dict(instance):
        d_val = None
        if instance.date:
            try:
                d_val = (
                    instance.date.isoformat()
                    if hasattr(instance.date, "isoformat")
                    else str(instance.date)
                )
            except Exception:
                d_val = str(instance.date)

        return {
            "id": instance.id,
            "advance_id": instance.advance_id,
            "category_id": instance.category_id,
            "subcategory_ids": [c.id for c in instance.subcategories],
            "subcategory_name": instance.combined_subcategory_label,
            "category_name": instance.category.parent.name
            if instance.category and instance.category.parent
            else (instance.category.name if instance.category else None),
            "category_code": instance.category.parent.code
            if instance.category and instance.category.parent
            else (instance.category.code if instance.category else None),
            "description": instance.description,
            "estimated_amount": instance.estimated_amount,
            "revision_no": instance.revision_no or 0,
            "evidence_path": instance.evidence_path,
            "evidence_filename": instance.evidence_filename,
            "date": d_val,
            "source": instance.source,
            "currency": instance.currency or "IDR",
            "currency_exchange": instance.currency_exchange or 1.0,
            "idr_amount": instance.idr_amount,
            "status": instance.status or "pending",
            "notes": instance.notes,
            "created_at": instance.created_at.isoformat() if instance.created_at else None,
        }


    @staticmethod
    def settlement_to_dict(instance, include_expenses=False):
        policy_warnings = []
        first_exp = instance.expenses[0] if instance.expenses else None
        data = {
            "id": instance.id,
            "title": instance.title,
            "description": instance.description,
            "first_expense_description": first_exp.description if first_exp else None,
            "user_id": instance.user_id,
            "creator_name": instance.creator.full_name if instance.creator else None,
            "requester_name": instance.creator.full_name if instance.creator else None,
            "creator_role": instance.creator.role if instance.creator else None,
            "creator_id": instance.creator.id if instance.creator else None,
            "creator_profile_image": instance.creator.profile_image
            if instance.creator
            else None,
            "settlement_type": instance.settlement_type,
            "document_date": instance.document_date.isoformat()
            if instance.document_date
            else None,
            "report_year": instance.report_year,
            "status": instance.status,
            "total_amount": instance.total_amount,
            "approved_amount": instance.approved_amount,
            "approved_amount_override": instance.approved_amount_override,
            "rejected_count": instance.rejected_count,
            "expense_count": len(instance.expenses),
            "created_at": instance.created_at.isoformat() if instance.created_at else None,
            "updated_at": instance.updated_at.isoformat() if instance.updated_at else None,
            "submitted_at": instance.submitted_at.isoformat()
            if instance.submitted_at
            else None,
            "completed_at": instance.completed_at.isoformat()
            if instance.completed_at
            else None,
            "bank_id": instance.bank_id,
            "disbursement_source": instance.disbursement_source,
            "disbursement_source_id": instance.disbursement_source_id,
            "return_source": instance.return_source,
            "return_source_id": instance.return_source_id,
            "admin_fee": instance.admin_fee,
            "disbursed_amount": instance.disbursed_amount,
            "disbursement_date": instance.disbursement_date.isoformat() if instance.disbursement_date else None,
            "returned_amount": instance.returned_amount or 0.0,
            "disbursement_comment": instance.disbursement_comment,
            "return_description": instance.return_description,
            "disbursement_evidence_path": instance.disbursement_evidence_path,
            "disbursement_evidence_filename": instance.disbursement_evidence_filename,
            "return_evidence_path": instance.return_evidence_path,
            "return_evidence_filename": instance.return_evidence_filename,
            "is_disbursement_approved": instance.is_disbursement_approved or False,
            "is_return_approved": instance.is_return_approved or False,
            "return_status": instance.return_status or "pending",
            "return_notes": instance.return_notes,
            "modified_t1": instance.modified_t1 or False,
            "modified_t2": instance.modified_t2 or False,
            "modified_t3": instance.modified_t3 or False,
            "current_stage": instance.current_stage or "draft",
            "expected_completion_at": instance.expected_completion_at.isoformat()
            if instance.expected_completion_at
            else None,
            "bank_name": instance.bank.name if instance.bank else None,
            "advance_id": instance.advance_id,
            "advance_title": instance.advance.title if getattr(instance, 'advance', None) else None,
            "advance": instance.advance.to_dict() if getattr(instance, 'advance', None) else None,
            "policy_warnings": policy_warnings,
        }
        # Handle case creator is None (user deleted)
        if not instance.creator:
            data["creator_name"] = "User dihapus"
            data["creator_role"] = "unknown"
        if include_expenses:
            data["expenses"] = [e.to_dict() for e in instance.expenses]
        return data


    @staticmethod
    def expense_to_dict(instance):
        d_val = None
        if instance.date:
            try:
                d_val = (
                    instance.date.isoformat()
                    if hasattr(instance.date, "isoformat")
                    else str(instance.date)
                )
            except Exception:
                d_val = str(instance.date)

        return {
            "id": instance.id,
            "settlement_id": instance.settlement_id,
            "category_id": instance.category_id,
            "subcategory_ids": [c.id for c in instance.subcategories],
            "subcategory_name": instance.combined_subcategory_label,
            "category_name": instance.category.parent.name
            if instance.category and instance.category.parent
            else (instance.category.name if instance.category else None),
            "category_code": instance.category.parent.code
            if instance.category and instance.category.parent
            else (instance.category.code if instance.category else None),
            "description": instance.description,
            "amount": instance.amount,
            "date": d_val,
            "source": instance.source,
            "revision_no": instance.revision_no or 0,
            "currency": instance.currency,
            "currency_exchange": instance.currency_exchange,
            "idr_amount": instance.idr_amount,
            "evidence_path": instance.evidence_path,
            "evidence_filename": instance.evidence_filename,
            "status": instance.status,
            "notes": instance.notes,
            "created_at": instance.created_at.isoformat() if instance.created_at else None,
        }


    @staticmethod
    def revenue_to_dict(instance):
        # NOTE: 'Revenue' in UI labels is rebranded to 'Pemasukan'
        return {
            "id": instance.id,
            "invoice_date": instance.invoice_date.isoformat()
            if instance.invoice_date
            else None,
            "description": instance.description,
            "invoice_value": instance.invoice_value,
            "invoice_value_usd": instance.invoice_value_usd,
            "invoice_value_idr": instance.invoice_value_idr,
            "currency": instance.currency,
            "currency_exchange": instance.currency_exchange,
            "invoice_number": instance.invoice_number,
            "client": instance.client,
            "receive_date": instance.receive_date.isoformat()
            if instance.receive_date
            else None,
            "amount_received": instance.amount_received,
            "amount_received_idr": instance.amount_received_idr,
            "amount_received_usd": instance.amount_received_usd,
            "ppn": instance.ppn,
            "pph_23": instance.pph_23,
            "transfer_fee": instance.transfer_fee,
            "remark": instance.remark,
            "revenue_type": instance.revenue_type,
            "report_year": instance.report_year,
            "bank_id": instance.bank_id,
            "bank_name": instance.bank.name if instance.bank else None,
            "user_id": instance.user_id,
            "creator_name": (instance.creator.full_name or instance.creator.username) if getattr(instance, "creator", None) else None,
            "created_at": instance.created_at.isoformat() if instance.created_at else None,
        }


    @staticmethod
    def tax_to_dict(instance):
        return {
            "id": instance.id,
            "date": instance.date.isoformat() if instance.date else None,
            "description": instance.description,
            "transaction_value": instance.transaction_value,
            "invoice_value_usd": instance.invoice_value_usd,
            "transaction_value_idr": instance.transaction_value_idr,
            "transaction_value_idr_calc": instance.idr_transaction_value,
            "currency": instance.currency,
            "currency_exchange": instance.currency_exchange,
            "ppn": instance.ppn,
            "ppn_base": instance.ppn_base,
            "pph_21": instance.pph_21,
            "pph_21_base": instance.pph_21_base,
            "pph_23": instance.pph_23,
            "pph_23_base": instance.pph_23_base,
            "pph_26": instance.pph_26,
            "pph_26_base": instance.pph_26_base,
            "pemasukan_negara": instance.pemasukan_negara,
            "pemasukan_negara_base": instance.pemasukan_negara_base,
            "report_year": instance.report_year,
            "created_at": instance.created_at.isoformat() if instance.created_at else None,
        }


    @staticmethod
    def manualcombinegroup_to_dict(instance):
        return {
            "id": instance.id,
            "table_name": instance.table_name,
            "report_year": instance.report_year,
            "group_date": instance.group_date.isoformat() if instance.group_date else None,
            "row_ids": instance.row_ids(),
            "merged_columns": instance.merged_columns(),
            "created_at": instance.created_at.isoformat() if instance.created_at else None,
        }


    @staticmethod
    def dividend_to_dict(instance):
        return {
            "id": instance.id,
            "date": instance.date.isoformat() if instance.date else None,
            "name": instance.name,
            "amount": instance.amount,
            "percentage": instance.percentage,
            "recipient_count": instance.recipient_count or 1,
            "tax_percentage": instance.tax_percentage or 0.0,
            "report_year": instance.report_year,
            "created_at": instance.created_at.isoformat() if instance.created_at else None,
        }


    @staticmethod
    def dividendsetting_to_dict(instance):
        return {
            "id": instance.id,
            "year": instance.year,
            "profit_retained": instance.profit_retained,
            "opening_cash_balance": instance.opening_cash_balance,
            "accounts_receivable": instance.accounts_receivable,
            "prepaid_tax_pph23": instance.prepaid_tax_pph23,
            "prepaid_expenses": instance.prepaid_expenses,
            "other_receivables": instance.other_receivables,
            "office_inventory": instance.office_inventory,
            "other_assets": instance.other_assets,
            "accounts_payable": instance.accounts_payable,
            "salary_payable": instance.salary_payable,
            "shareholder_payable": instance.shareholder_payable,
            "accrued_expenses": instance.accrued_expenses,
            "share_capital": instance.share_capital,
            "retained_earnings_balance": instance.retained_earnings_balance,
            "corporate_tax_pph29": instance.corporate_tax_pph29,
            "corporate_tax_rate": instance.corporate_tax_rate,
            "other_income": instance.other_income,
            "created_at": instance.created_at.isoformat() if instance.created_at else None,
        }
