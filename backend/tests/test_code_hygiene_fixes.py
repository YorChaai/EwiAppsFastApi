import os
import sys
import pytest

backend_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if backend_dir not in sys.path:
    sys.path.insert(0, backend_dir)

from services.reports.summary_service import excel_generator as summary_excel_generator
from services.dto.transaction_dto import TransactionDTO


from unittest.mock import MagicMock

def test_summary_excel_generator_logger():
    """Verify that logger is properly imported and configured in summary_service excel_generator."""
    assert hasattr(summary_excel_generator, "logger")
    assert summary_excel_generator.logger is not None
    assert summary_excel_generator.logger.name == "services.reports.summary_service.excel_generator"


def test_transaction_dto_keys_not_duplicated():
    """Verify that advance_to_dict and settlement_to_dict produce valid dicts with bank_id and bank_name."""
    mock_advance = MagicMock()
    mock_advance.id = 1
    mock_advance.items = []
    mock_advance.max_revision_no = 0
    mock_advance.active_revision_no = None
    mock_advance.document_date = None
    mock_advance.created_at = None
    mock_advance.updated_at = None
    mock_advance.approved_at = None
    mock_advance.expected_completion_at = None
    mock_advance.bank_id = 5
    mock_advance.bank = MagicMock()
    mock_advance.bank.name = "BCA Main"
    mock_advance.settlements = []
    mock_advance.status = "draft"

    res_adv = TransactionDTO.advance_to_dict(mock_advance, include_items=False)
    assert res_adv["bank_id"] == 5
    assert res_adv["bank_name"] == "BCA Main"
    assert "policy_warnings" in res_adv

    mock_settlement = MagicMock()
    mock_settlement.id = 10
    mock_settlement.expenses = []
    mock_settlement.creator = None
    mock_settlement.document_date = None
    mock_settlement.created_at = None
    mock_settlement.updated_at = None
    mock_settlement.submitted_at = None
    mock_settlement.completed_at = None
    mock_settlement.disbursement_date = None
    mock_settlement.expected_completion_at = None
    mock_settlement.bank_id = 7
    mock_settlement.bank = MagicMock()
    mock_settlement.bank.name = "Mandiri"
    mock_settlement.advance = None

    res_set = TransactionDTO.settlement_to_dict(mock_settlement, include_expenses=False)
    assert res_set["bank_id"] == 7
    assert res_set["bank_name"] == "Mandiri"
