class TxTemplates:
    ADD_REAL_CASH = "Penambahan Saldo Kas Riil"
    SUB_REAL_CASH = "Pengurangan Saldo Kas Riil"
    INIT_VIRTUAL = "Penyesuaian Saldo Virtual" # Based on the frontend default text
    RCV_ALLOCATION = "Terima Alokasi"
    PULL_ALLOCATION = "Tarik Alokasi"

    @staticmethod
    def allocation_notes(direction_label, target_user_name, current_user_name, notes=None):
        # Hindari nama dobel jika target dan pelaksana adalah orang yang sama
        if target_user_name == current_user_name:
            base = f"{direction_label} - {target_user_name}"
        else:
            base = f"{direction_label} - {target_user_name} (oleh {current_user_name})"
            
        clean_notes = (notes or "").strip()
        default_skip_labels = [
            TxTemplates.INIT_VIRTUAL.lower(),
            "terima alokasi",
            "tarik alokasi",
            direction_label.lower(),
        ]
        
        if clean_notes and clean_notes.lower() not in default_skip_labels:
            return f"{base}: {clean_notes}"
        return base

    @staticmethod
    def advance_approved_final():
        return "Advance Approved (Final)"

    @staticmethod
    def advance_rejected_final():
        return "Advance Rejected (Final)"

    @staticmethod
    def settlement_approved_final():
        return "Settlement Approved (Final)"

    @staticmethod
    def settlement_rejected_final():
        return "Settlement Rejected (Final)"

    @staticmethod
    def advance_revision_requested():
        return "Revision Requested"

    @staticmethod
    def advance_move_to_draft():
        return "Dipindahkan ke Draft"

    @staticmethod
    def disbursement(target_user_name, current_user_name):
        return f"Disbursement Saldo Advance {target_user_name} ({current_user_name})"

    @staticmethod
    def refund_notes(req_name, desc, ref_id):
        return f"Pengembalian Dana - {req_name}: {desc} (Ref: #{ref_id})"

