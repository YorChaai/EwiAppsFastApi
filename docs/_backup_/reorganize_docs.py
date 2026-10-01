import os
import shutil
import re

DOCS_DIR = r"D:\Aplikasi\EWIApps\docs"

def ensure_dir(d):
    path = os.path.join(DOCS_DIR, d)
    if not os.path.exists(path):
        os.makedirs(path)
    return path

def organize_docs():
    bugs_dir = ensure_dir("bugs")
    reports_dir = ensure_dir("reports")
    plans_dir = ensure_dir("plans")
    technical_dir = ensure_dir("technical")
    templates_dir = ensure_dir("templates")
    manuals_dir = ensure_dir("manuals")
    backup_dir = ensure_dir("_backup_")

    files = [f for f in os.listdir(DOCS_DIR) if os.path.isfile(os.path.join(DOCS_DIR, f))]
    
    for f in files:
        if f.lower() == "readme.md":
            continue
            
        f_lower = f.lower()
        src = os.path.join(DOCS_DIR, f)
        
        # Categorize
        if "bug" in f_lower or "error" in f_lower:
            shutil.move(src, os.path.join(bugs_dir, f))
        elif "laporan" in f_lower or "meeting" in f_lower or "mettin" in f_lower or "progress" in f_lower or "history" in f_lower:
            shutil.move(src, os.path.join(reports_dir, f))
        elif "plan" in f_lower or "rencana" in f_lower or "strategi" in f_lower:
            shutil.move(src, os.path.join(plans_dir, f))
        elif "asset" in f_lower or "database" in f_lower or "struktur" in f_lower or "logika" in f_lower or "security" in f_lower or "health" in f_lower or "keyenv" in f_lower or "status" in f_lower or "alur" in f_lower:
            shutil.move(src, os.path.join(technical_dir, f))
        elif "prompt" in f_lower:
            shutil.move(src, os.path.join(templates_dir, f))
        elif "panduan" in f_lower or "guide" in f_lower or "skenario" in f_lower:
            shutil.move(src, os.path.join(manuals_dir, f))
        else:
            # Everything else to backup
            shutil.move(src, os.path.join(backup_dir, f))

if __name__ == "__main__":
    organize_docs()
    print("Docs reorganization complete.")
