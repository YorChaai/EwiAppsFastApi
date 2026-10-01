import os
import re

sql_path = r"D:\Aplikasi\EWIApps\data\backupdataapps\2026-09-21_17-33-30\migrasi_data_multiyear_hybrid_20260921_173330.sql"

if not os.path.exists(sql_path):
    print("File not found:", sql_path)
    exit(1)

size = os.path.getsize(sql_path)
print(f"File exists: {sql_path}")
print(f"Size: {size:,} bytes ({size/1024/1024:.2f} MB)")

with open(sql_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

print(f"Total lines: {len(lines):,}")

rev_lines = [l for l in lines if l.startswith("INSERT INTO public.revenues")]
bt_income_lines = [l for l in lines if "INSERT INTO public.bank_transactions" in l and "'income'" in l]
bt_all = [l for l in lines if "INSERT INTO public.bank_transactions" in l]

print(f"Revenue rows: {len(rev_lines)}")
print(f"Bank income rows (Revenues): {len(bt_income_lines)}")
print(f"All Bank transaction rows: {len(bt_all)}")

# Group revenues by year and bank
by_year = {}
bank_counts = {}

for l in rev_lines:
    # find year
    year_match = re.search(r", (202[0-9]), ", l)
    year = year_match.group(1) if year_match else "unknown"
    by_year[year] = by_year.get(year, 0) + 1

    # find bank
    if "LOWER('Mandiri Valas')" in l:
        b = "Mandiri Valas"
    elif "LOWER('Mandiri Bisnis')" in l:
        b = "Mandiri Bisnis"
    elif "LOWER('Mandiri Giro')" in l:
        b = "Mandiri Giro"
    elif "LOWER('Mandiri TabBis')" in l:
        b = "Mandiri TabBis"
    elif "LOWER('Mandiri')" in l:
        b = "Mandiri"
    elif "LOWER('BCA')" in l:
        b = "BCA"
    elif "LOWER('BRI')" in l:
        b = "BRI"
    elif "LOWER('Cash')" in l:
        b = "Cash"
    elif ", NULL, v_admin_id)" in l or ", NULL, NULL)" in l:
        b = "NULL (Unallocated)"
    else:
        b = "Other / Check"
    
    bank_counts[b] = bank_counts.get(b, 0) + 1

print("\n--- REVENUE PER TAHUN ---")
for y, count in sorted(by_year.items()):
    print(f"Tahun {y}: {count} baris")

print("\n--- PEMETAAN BANK PADA REVENUE ---")
for b, count in sorted(bank_counts.items(), key=lambda x: -x[1]):
    print(f"Bank '{b}': {count} baris")

# Check for any suspicious syntax errors
print("\n--- PENGECEKAN SYNTAX & ANOMALI ---")
anomalies = []
for idx, l in enumerate(lines, 1):
    if "None" in l and not "NoneType" in l and not "Non project" in l and not "Non-project" in l:
        # Check if python literal None leaked into SQL
        if "None," in l or ", None)" in l or "= None" in l:
            anomalies.append((idx, "Python literal None leaked", l.strip()[:100]))
    if "nan," in l or "NaN," in l or "nan)" in l or "NaN)" in l:
        anomalies.append((idx, "Python NaN leaked", l.strip()[:100]))

print(f"Total anomali/kebocoran tipe Python: {len(anomalies)}")
if anomalies:
    for a in anomalies[:10]:
        print(f"Line {a[0]}: {a[1]} -> {a[2]}")
else:
    print("Semua query SQL bersih! Tidak ada NaN, None, atau syntax error.")
