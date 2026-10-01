import os
import re
from pathlib import Path

def update_backend_graphify():
    p = Path(r"D:\Aplikasi\aitool\docs_generator\graphify_docs\generate_backend_graphify.py")
    content = p.read_text(encoding="utf-8")
    
    old_config = '''# ─── CONFIG ────────────────────────────────────────────────────────────────────
ROOT_DIR = r"D:\\Aplikasi\\EWIApps"
GRAPH_JSON = os.path.join(ROOT_DIR, "graphify-out", "graph.json")
OUT_PATH   = os.path.join(ROOT_DIR, "docs", "alldocument", "graphify", "Panduan_Backend_Graphify.md")'''

    new_config = '''# ─── CONFIG ────────────────────────────────────────────────────────────────────
import sys
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from common_paths import resolve_project_root, get_doc_dirs

dirs = get_doc_dirs()
ROOT_DIR = str(dirs["project_root"])
GRAPH_JSON = os.path.join(ROOT_DIR, "graphify-out", "graph.json")
OUT_PATH   = str(dirs["graphify_dir"] / "Panduan_Backend_Graphify.md")'''

    if old_config in content:
        content = content.replace(old_config, new_config)
        p.write_text(content, encoding="utf-8")
        print("generate_backend_graphify.py updated.")
    else:
        print("generate_backend_graphify.py config block not matched directly, checking...")

def update_frontend_graphify():
    p = Path(r"D:\Aplikasi\aitool\docs_generator\graphify_docs\generate_frontend_graphify.py")
    content = p.read_text(encoding="utf-8")

    old_config = '''# ─── CONFIG ────────────────────────────────────────────────────────────────────
ROOT_DIR   = r"D:\\Aplikasi\\EWIApps"
GRAPH_JSON = os.path.join(ROOT_DIR, "graphify-out", "graph.json")
OUT_PATH   = os.path.join(ROOT_DIR, "docs", "alldocument", "graphify", "Panduan_Frontend_Graphify.md")'''

    new_config = '''# ─── CONFIG ────────────────────────────────────────────────────────────────────
import sys
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from common_paths import resolve_project_root, get_doc_dirs

dirs = get_doc_dirs()
ROOT_DIR   = str(dirs["project_root"])
GRAPH_JSON = os.path.join(ROOT_DIR, "graphify-out", "graph.json")
OUT_PATH   = str(dirs["graphify_dir"] / "Panduan_Frontend_Graphify.md")'''

    if old_config in content:
        content = content.replace(old_config, new_config)
        p.write_text(content, encoding="utf-8")
        print("generate_frontend_graphify.py updated.")
    else:
        print("generate_frontend_graphify.py config block not matched directly, checking...")

def update_auto_graphify():
    p = Path(r"D:\Aplikasi\aitool\docs_generator\graphify_docs\auto_graphify_docs.py")
    content = p.read_text(encoding="utf-8")

    old_config = '''# ─── CONFIG ────────────────────────────────────────────────────────────────────
ROOT_DIR      = r"D:\\Aplikasi\\EWIApps"
SCRIPTS_DIR   = os.path.dirname(os.path.abspath(__file__))
GRAPHIFY_DIR  = os.path.join(ROOT_DIR, "docs", "alldocument", "graphify")
BANDING_DIR   = os.path.join(GRAPHIFY_DIR, "banding")'''

    new_config = '''# ─── CONFIG ────────────────────────────────────────────────────────────────────
import sys
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from common_paths import resolve_project_root, get_doc_dirs

dirs = get_doc_dirs()
ROOT_DIR      = str(dirs["project_root"])
SCRIPTS_DIR   = os.path.dirname(os.path.abspath(__file__))
GRAPHIFY_DIR  = str(dirs["graphify_dir"])
BANDING_DIR   = str(dirs["graphify_banding_dir"])'''

    # Juga pastikan subprocess memanggil dengan parameter ROOT_DIR
    old_run = 'result = subprocess.run(\n            ["python", script_path],'
    new_run = 'result = subprocess.run(\n            [sys.executable, script_path, ROOT_DIR],'

    if old_config in content:
        content = content.replace(old_config, new_config)
        content = content.replace(old_run, new_run)
        p.write_text(content, encoding="utf-8")
        print("auto_graphify_docs.py updated.")
    else:
        print("auto_graphify_docs.py config block not matched directly, checking...")

if __name__ == "__main__":
    update_backend_graphify()
    update_frontend_graphify()
    update_auto_graphify()
