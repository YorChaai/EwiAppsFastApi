with open('backend/utils/parsing_helper.py', 'a', encoding='utf-8') as f:
    f.write('\n\nfrom datetime import datetime\ndef _default_report_year():\n    return datetime.now().year\n\ndef _year_date_bounds(year):\n    try:\n        y = int(year)\n    except:\n        y = _default_report_year()\n    return f"{y}-01-01", f"{y}-12-31"\n')
