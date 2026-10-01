with open('backend/services/settings_service.py', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('import json', 'import json\n\nDEADLINE_RULE_ALIASES = {\n    "SETTLEMENT_APPROVAL": "SETTLEMENT_MANAGER_REVIEW",\n}')

with open('backend/services/settings_service.py', 'w', encoding='utf-8') as f:
    f.write(content)
