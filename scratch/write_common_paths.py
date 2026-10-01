import sys
from pathlib import Path

content = '''import os
import sys
import json
from pathlib import Path

def resolve_project_root():
    """
    Mendeteksi path project secara dinamis:
    1. Argumen CLI (sys.argv)
    2. config.json di D:\\Aplikasi\\aitool
    3. CWD
    """
    for arg in sys.argv[1:]:
        if arg and not arg.startswith("-"):
            candidate = Path(arg.strip('"`')).resolve()
            if candidate.exists() and candidate.is_dir():
                return candidate

    tool_dir = Path(__file__).resolve().parent.parent
    cfg_file = tool_dir / "config.json"
    if cfg_file.exists():
        try:
            with open(cfg_file, "r", encoding="utf-8") as f:
                cfg = json.load(f)
                last_p = cfg.get("last_project_path")
                if last_p:
                    candidate = Path(last_p.strip('"`')).resolve()
                    if candidate.exists() and candidate.is_dir():
                        return candidate
        except Exception:
            pass

    return Path.cwd().resolve()

def get_doc_dirs(project_root=None):
    if project_root is None:
        project_root = resolve_project_root()
    else:
        project_root = Path(project_root).resolve()

    docs_root = project_root / "docs" / "alldocument"
    panduan_dir = docs_root / "panduan"
    laporan_dir = docs_root / "laporan"
    banding_dir = docs_root / "banding"
    graphify_dir = docs_root / "graphify"
    graphify_banding_dir = graphify_dir / "banding"

    for d in [docs_root, panduan_dir, laporan_dir, banding_dir, graphify_dir, graphify_banding_dir]:
        d.mkdir(parents=True, exist_ok=True)

    backend_dir = project_root / "backend"
    if not backend_dir.exists():
        backend_dir = project_root

    frontend_dir = project_root / "frontend"
    if not frontend_dir.exists():
        frontend_dir = project_root

    frontend_lib_dir = frontend_dir / "lib"
    if not frontend_lib_dir.exists():
        frontend_lib_dir = project_root / "lib"

    return {
        "project_root": project_root,
        "backend_dir": backend_dir,
        "frontend_dir": frontend_dir,
        "frontend_lib_dir": frontend_lib_dir,
        "docs_root": docs_root,
        "panduan_dir": panduan_dir,
        "laporan_dir": laporan_dir,
        "banding_dir": banding_dir,
        "graphify_dir": graphify_dir,
        "graphify_banding_dir": graphify_banding_dir,
        "index_path": docs_root / "INDEX.md",
    }
'''

target = Path(r"D:\Aplikasi\aitool\docs_generator\common_paths.py")
target.write_text(content, encoding="utf-8")
print("common_paths.py written successfully to", target)
