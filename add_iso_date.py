with open('backend/utils/parsing_helper.py', 'a', encoding='utf-8') as f:
    f.write('''
def _parse_iso_date(date_str):
    if not date_str:
        return None
    try:
        if hasattr(date_str, "strftime"):
            return date_str
        return datetime.strptime(str(date_str)[:10], "%Y-%m-%d").date()
    except ValueError:
        return None
''')
