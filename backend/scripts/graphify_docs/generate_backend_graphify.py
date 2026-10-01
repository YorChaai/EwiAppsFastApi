"""
generate_backend_graphify.py
============================
Script BARU (terpisah dari generate_backend_docs.py).
Membaca graphify-out/graph.json dan menghasilkan dokumentasi Markdown
backend FastAPI (Python) yang kaya entitas & relasi (Knowledge Graph-aware).

Output: docs/Panduan_Backend_Graphify.md

Cara menjalankan (dari root proyek):
    python backend/scripts/graphify_docs/generate_backend_graphify.py
"""

import json
import os
from collections import defaultdict

# ─── CONFIG ────────────────────────────────────────────────────────────────────
ROOT_DIR = r"D:\Aplikasi\EWIApps"
GRAPH_JSON = os.path.join(ROOT_DIR, "graphify-out", "graph.json")
OUT_PATH   = os.path.join(ROOT_DIR, "docs", "alldocument", "graphify", "Panduan_Backend_Graphify.md")

# Folder / path segments yang dikecualikan dari dokumentasi
EXCLUDE_PARTS = {
    'side', 'scripts', 'migrations', 'venv', 'scratch',
    '_backup_', 'backup', '__pycache__', '.pytest_cache',
    '.ruff_cache', '_archive', 'graphify_docs',
}

RISK_HIGH   = 900
RISK_MEDIUM = 500

# ─── UTILS ─────────────────────────────────────────────────────────────────────

def should_exclude(source_file: str) -> bool:
    """Kembalikan True jika file berada di dalam folder yang dikecualikan."""
    parts = (source_file or "").replace("\\", "/").split("/")
    return any(p in EXCLUDE_PARTS for p in parts)


def file_key(source_file: str) -> str:
    """Ubah path menjadi key yang bisa dipakai sebagai ID node graphify."""
    # contoh: backend/app.py → backend_app
    return source_file.replace("/", "_").replace("\\", "_").replace(".py", "").replace(".", "_")


def folder_role(folder: str) -> str:
    if "routes" in folder or "controllers" in folder:
        return "Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend."
    if "services" in folder:
        return "Menangani logika bisnis yang lebih kompleks, agar file routes tidak membengkak."
    if "models" in folder:
        return "Mendefinisikan skema database (ORM) dan validasi data dengan SQLAlchemy."
    if "utils" in folder or "helpers" in folder:
        return "Menyimpan fungsi utilitas umum (formatting, perhitungan, auth helpers)."
    return "File inti / konfigurasi utama aplikasi backend."


def file_role(path: str) -> str:
    p = path.lower()
    if "route" in p or "crud" in p or "approval" in p or "disbursement" in p:
        return "Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response."
    if "model" in p:
        return "Merepresentasikan tabel database (SQLAlchemy) dan menyediakan method konversi data."
    if "app.py" in p or "main.py" in p:
        return "Entry-point server backend. Inisialisasi aplikasi, database, middleware, dan blueprint."
    if "config" in p:
        return "Mengelola environment variables dan konfigurasi server (database URI, secret key, dll)."
    if "service" in p or "helper" in p:
        return "Menangani logika bisnis terisolasi yang dapat dipanggil oleh banyak route."
    if "util" in p:
        return "Fungsi pembantu umum (auth helper, formatting, kalkulasi) yang dipakai lintas file."
    return "Modul pendukung spesifik sesuai nama file."


def risk_badge(functions_count: int) -> str:
    if functions_count >= RISK_HIGH // 10:
        return f"🔴 **Kompleks** ({functions_count} fungsi/metode terdeteksi) — hati-hati saat modifikasi."
    if functions_count >= RISK_MEDIUM // 10:
        return f"🟡 **Sedang** ({functions_count} fungsi/metode terdeteksi)."
    return f"🟢 **Aman** ({functions_count} fungsi/metode terdeteksi)."


# ─── MAIN ──────────────────────────────────────────────────────────────────────

def main():
    print("[INFO] Membaca graph.json ...")
    with open(GRAPH_JSON, encoding="utf-8") as f:
        graph = json.load(f)

    all_nodes = graph.get("nodes", [])
    all_edges = graph.get("links", [])

    # ── Filter: hanya backend, bukan folder terlarang ──
    backend_file_nodes = [
        n for n in all_nodes
        if (n.get("source_file") or "").startswith("backend/")
        and not n.get("_callable")                          # hanya node file-level
        and not should_exclude(n.get("source_file") or "")
    ]

    # ── Index: node id → node ──
    node_by_id = {n["id"]: n for n in all_nodes}

    # ── Index: source_file → list of callable nodes (classes & functions) ──
    callables_by_file: dict[str, list] = defaultdict(list)
    for n in all_nodes:
        sf = n.get("source_file") or ""
        if sf.startswith("backend/") and n.get("_callable") and not should_exclude(sf):
            callables_by_file[sf].append(n)

    # ── Index: source_file → import targets ──
    imports_by_file: dict[str, list] = defaultdict(list)
    # ── Index: target_file → who imports it (reverse deps) ──
    reverse_deps: dict[str, list] = defaultdict(list)

    for e in all_edges:
        if e.get("relation") not in ("imports", "imports_from"):
            continue
        sf = e.get("source_file") or ""
        if not sf.startswith("backend/") or should_exclude(sf):
            continue
        # resolve target node
        target_node = node_by_id.get(e.get("target") or "")
        if not target_node:
            continue
        target_sf = target_node.get("source_file") or ""
        if target_sf.startswith("backend/") and not should_exclude(target_sf) and target_sf != sf:
            label = target_node.get("label", target_sf)
            if label not in imports_by_file[sf]:
                imports_by_file[sf].append(label)
            if sf not in reverse_deps[target_sf]:
                reverse_deps[target_sf].append(sf)

    # ── calls edges per file ──
    calls_by_file: dict[str, list] = defaultdict(list)
    for e in all_edges:
        if e.get("relation") != "calls":
            continue
        sf = e.get("source_file") or ""
        if not sf.startswith("backend/") or should_exclude(sf):
            continue
        target_node = node_by_id.get(e.get("target") or "")
        if not target_node:
            continue
        target_sf = target_node.get("source_file") or ""
        if target_sf.startswith("backend/") and target_sf != sf and not should_exclude(target_sf):
            label = target_node.get("label", "")
            if label and label not in calls_by_file[sf]:
                calls_by_file[sf].append(label)

    # ── Sort by folder then filename ──
    backend_file_nodes.sort(key=lambda n: (n.get("source_file") or ""))

    # ── Group by folder ──
    by_folder: dict[str, list] = defaultdict(list)
    for n in backend_file_nodes:
        sf = n.get("source_file") or ""
        folder = "/".join(sf.split("/")[:-1])  # semua segmen kecuali nama file
        by_folder[folder].append(n)

    # ── Statistics ──
    total_files = len(backend_file_nodes)
    total_classes = sum(1 for n in all_nodes if (n.get("source_file") or "").startswith("backend/") and n.get("_callable_class") and not should_exclude(n.get("source_file") or ""))
    total_funcs = sum(1 for n in all_nodes if (n.get("source_file") or "").startswith("backend/") and n.get("_callable") and not n.get("_callable_class") and not should_exclude(n.get("source_file") or ""))
    total_relations = len([e for e in all_edges if (e.get("source_file") or "").startswith("backend/")])

    print(f"   [OK] {total_files} file | {total_classes} class | {total_funcs} fungsi | {total_relations} relasi")

    # ── Write Markdown ──
    os.makedirs(os.path.dirname(OUT_PATH), exist_ok=True)
    with open(OUT_PATH, "w", encoding="utf-8") as f:

        f.write("# 📘 Panduan Backend (Graphify Knowledge Graph)\n\n")
        f.write("Dokumen ini digenerate dari **graphify-out/graph.json** — bukan dari scan regex/AST langsung.\n")
        f.write("Setiap entitas dan relasi di bawah ini dibangun dari Knowledge Graph proyek ini.\n\n")
        f.write(f"> **Script:** `backend/scripts/graphify_docs/generate_backend_graphify.py`\n\n")
        f.write("---\n\n")

        # Ringkasan statistik
        f.write("## 📊 Ringkasan Statistik\n\n")
        f.write(f"| Metrik | Nilai |\n|---|---|\n")
        f.write(f"| Total File Backend (aktif) | **{total_files}** |\n")
        f.write(f"| Total Class/Model | **{total_classes}** |\n")
        f.write(f"| Total Fungsi/Metode | **{total_funcs}** |\n")
        f.write(f"| Total Relasi (edges) | **{total_relations}** |\n")
        f.write(f"| Total Folder | **{len(by_folder)}** |\n")
        f.write("\n---\n\n")

        for folder in sorted(by_folder.keys()):
            display = folder if folder else "backend (root)"
            f.write(f"## 📁 Folder: `{display}`\n\n")
            f.write(f"**Tujuan Folder:** {folder_role(folder)}\n\n")

            for node in by_folder[folder]:
                sf = node.get("source_file") or ""
                filename = sf.split("/")[-1]
                label = node.get("label", filename)
                community = node.get("community", "-")
                loc = node.get("source_location", "L1")

                callables = callables_by_file.get(sf, [])
                classes = [c for c in callables if c.get("_callable_class")]
                funcs = [c for c in callables if not c.get("_callable_class")]

                f.write(f"### File: `{sf}`\n\n")
                f.write(f"**Tanggung Jawab:** {file_role(sf)}\n\n")
                f.write(f"**Community Group:** `{community}` | **Lokasi:** `{loc}`\n\n")
                f.write(f"**Risiko:** {risk_badge(len(funcs))}\n\n")

                # Classes
                if classes:
                    f.write("**Classes / Models:**\n\n")
                    for c in classes:
                        loc_c = c.get("source_location", "")
                        f.write(f"- `{c['label']}` ({loc_c})\n")
                    f.write("\n")

                # Functions (dedupe by label)
                if funcs:
                    seen = set()
                    unique_funcs = []
                    for fn in funcs:
                        if fn["label"] not in seen:
                            seen.add(fn["label"])
                            unique_funcs.append(fn)
                    f.write("**Fungsi / Metode:**\n\n")
                    for fn in unique_funcs[:20]:  # batasi 20 agar tidak terlalu panjang
                        f.write(f"- `{fn['label']}`\n")
                    if len(unique_funcs) > 20:
                        f.write(f"- *(... dan {len(unique_funcs) - 20} fungsi lainnya)*\n")
                    f.write("\n")

                # Internal imports
                imports = imports_by_file.get(sf, [])
                if imports:
                    f.write("**Bergantung Pada (Internal Imports):**\n\n")
                    for imp in sorted(set(imports))[:10]:
                        f.write(f"- `{imp}`\n")
                    f.write("\n")

                # Calls
                calls = calls_by_file.get(sf, [])
                if calls:
                    f.write("**Memanggil Fungsi/Modul:**\n\n")
                    for c in sorted(set(calls))[:10]:
                        f.write(f"- `{c}`\n")
                    f.write("\n")

                # Reverse deps
                rev = reverse_deps.get(sf, [])
                if rev:
                    f.write("**Dipakai Oleh:**\n\n")
                    for r in sorted(set(rev))[:8]:
                        f.write(f"- `{r}`\n")
                    f.write("\n")

                f.write("---\n\n")

    print(f"[OK] Selesai! Dokumentasi tersimpan di:\n   -> {OUT_PATH}")


if __name__ == "__main__":
    main()
