# Implementation Plan - Fixing Advance Evidence Persistence

The goal is to resolve the issue where Disbursement (Table 2) and Return (Table 3) data, including evidence, fails to persist in the database. The primary cause identified is a failing regex-based bank ID extraction in the frontend and a mismatch in how bank selection is handled.

## User Review Required

> [!IMPORTANT]
> The "Cairkan" button in Table 2 will now open the "Edit Rincian Pengiriman" dialog if no bank has been selected yet, rather than just showing a cryptic error message. This ensures the manager provides necessary details (Bank, Amount, Evidence) before final approval.

## Proposed Changes

### Frontend: `AdvanceDetailScreen`

#### [MODIFY] [advance_detail_screen.dart](file:///D:/Aplikasi/EWIApps/frontend/lib/screens/advance/advance_detail_screen.dart)
- Replace the regex-based `bankId` extraction in `_showEditDisbursementDialog` with a proper `DropdownButtonFormField<int>` using the bank list from `SettlementProvider`.
- Update `_approveAdvance` to first check if a `bank_id` exists in the `advance` record. If not, prompt the user to use the "Edit" dialog or open it automatically.
- Ensure that `disbursedAmount`, `adminFee`, and `returnedAmount` are correctly synchronized between the UI controllers and the API call.
- Improve error handling to show backend validation errors in a SnackBar.

### Backend: `routes/advances.py`

#### [MODIFY] [advances.py](file:///D:/Aplikasi/EWIApps/backend/routes/advances.py)
- Add logging to `final_approve_advance` to verify exactly what data and files are being received from the frontend.
- Ensure that `disbursement_evidence_path` and `return_evidence_path` are correctly updated even if only one of them is provided in a single call.
- Validate that `bank_id` is always present for final approval.

## Verification Plan

### Automated Tests
- I will use the browser tool (if applicable) or manual inspection of network logs to verify that the `MultipartRequest` contains:
    - `bank_id` as a stringified integer.
    - `disbursed_amount`, `returned_amount`, and `admin_fee`.
    - `evidence` and `return_evidence` files.
- Verify that the backend response contains the updated `advance` object with correct paths.

### Manual Verification
- **Table 2 Save**: Open "Edit Rincian Pengiriman", select a bank, add a file, and click "Simpan". Verify it appears in the table and persists after refresh.
- **Table 3 Save**: Open "Edit Rincian Pengembalian", add a file, and click "Simpan". Verify it appears and persists.
- **Cairkan Button**: Click "Cairkan" and verify it correctly calls the API if a bank is already set, or guides the user if not.


and

I have analyzed the persistence issues in the Advance module. The primary findings are:

Bank ID Extraction Failure: The frontend was trying to extract the Bank ID from a string using a regular expression that expected a specific format (e.g., BCA (ID: 1)), but the available options were only plain names (e.g., BCA). This caused the "Save" operation to fail silently, updating the UI locally but never reaching the database.
State Sync Mismatch: The "Cairkan" button and "Edit" dialogs were not robustly handling the required data for the backend API, leading to cases where valid data wasn't being sent.
I have created a detailed 
implementation plan
 and a 
task list
 to address these issues.

Key highlights of the proposed fix:

Replace unreliable text parsing with direct ID selection for banks in all dialogs.
Guide the user to provide necessary details if they attempt to "Cairkan" without setting a bank.
Add backend logging to ensure the data is correctly received and committed.
Please review the implementation plan and let me know if I should proceed with the execution.