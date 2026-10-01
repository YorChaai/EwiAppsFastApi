from models import db, DeadlineSetting
import json

DEADLINE_RULE_ALIASES = {
    "SETTLEMENT_APPROVAL": "SETTLEMENT_MANAGER_REVIEW",
}

def _normalize_deadline_rule_key(rule_key):
    return DEADLINE_RULE_ALIASES.get(rule_key, rule_key)

def _find_deadline_setting(rule_key, company="EWI Foundation"):
    normalized_key = _normalize_deadline_rule_key(rule_key)
    legacy_keys = [
        legacy
        for legacy, canonical in DEADLINE_RULE_ALIASES.items()
        if canonical == normalized_key
    ]
    for candidate in [normalized_key, *legacy_keys]:
        setting = DeadlineSetting.query.filter_by(
            rule_key=candidate, company=company
        ).first()
        if setting:
            return setting, normalized_key
    return None, normalized_key

def _sanitize_deadline_days(days):
    if not isinstance(days, list) or len(days) == 0:
        return None
    cleaned = []
    for day in days:
        try:
            parsed = int(day)
        except (TypeError, ValueError):
            return None
        if parsed <= 0:
            return None
        cleaned.append(parsed)
    return sorted(set(cleaned))

