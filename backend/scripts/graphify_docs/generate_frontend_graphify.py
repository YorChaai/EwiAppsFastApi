"""
generate_frontend_graphify.py
==============================
Script BARU (terpisah dari generate_frontend_docs.py).
Membaca graphify-out/graph.json dan menghasilkan dokumentasi Markdown
frontend (Flutter / Dart) yang kaya entitas & relasi (Knowledge Graph-aware).

Output: docs/Panduan_Frontend_Graphify.md

Cara menjalankan (dari root proyek):
    python backend/scripts/graphify_docs/generate_frontend_graphify.py
"""

import json
import os
from collections import defaultdict

# ─── CONFIG ────────────────────────────────────────────────────────────────────
ROOT_DIR   = r"D:\Aplikasi\EWIApps"
GRAPH_JSON = os.path.join(ROOT_DIR, "graphify-out", "graph.json")
OUT_PATH   = os.path.join(ROOT_DIR, "docs", "alldocument", "graphify", "Panduan_Frontend_Graphify.md")

EXCLUDE_PARTS = {
    'side', '_backup_', 'backup', 'scratch', 'build',
    'android', 'ios', 'web', 'windows', 'linux', 'macos',
    '.dart_tool', '.idea', 'test',
}

# ─── UTILS ─────────────────────────────────────────────────────────────────────

def should_exclude(source_file: str) -> bool:
    parts = (source_file or "").replace("\\", "/").split("/")
    return any(p in EXCLUDE_PARTS for p in parts)


def folder_role(folder: str) -> str:
    if "screens" in folder:
        return "Halaman-halaman UI (Screen / View) dan interaksi pengguna."
    if "providers" in folder:
        return "State management (Provider) — menyimpan data sementara & logika bisnis UI."
    if "models" in folder:
        return "Struktur data (blueprint/model) dan fungsi fromJson/toJson."
    if "services" in folder:
        return "Komunikasi ke backend API (HTTP requests)."
    if "widgets" in folder:
        return "Komponen visual (Widget) yang dapat dipakai ulang di berbagai halaman."
    if "utils" in folder or "mixins" in folder:
        return "Fungsi utilitas, helper, dan mixin yang dipakai lintas file."
    if "theme" in folder:
        return "Konfigurasi tema global (warna, font, style)."
    if "controllers" in folder:
        return "Controller-layer (logika kontrol UI terpisah dari Screen)."
    return "Modul pendukung Flutter."


def file_role(path: str) -> str:
    p = path.lower()
    if "screen" in p:
        return "Menampilkan UI dan menangani interaksi pengguna untuk fitur terkait."
    if "provider" in p:
        return "Menyimpan state (data sementara) dan mengelola pembaruan UI saat data berubah."
    if "model" in p:
        return "Mendefinisikan entitas data agar dapat dikenali dan diproses secara type-safe oleh Dart."
    if "service" in p or "api_" in p:
        return "Menangani pemanggilan API ke backend (HTTP requests) untuk fitur terkait."
    if "widget" in p or "dialog" in p or "card" in p or "tile" in p or "header" in p:
        return "Komponen UI terpisah (reusable widget) agar kode lebih modular."
    if "main.dart" in p:
        return "Entry-point aplikasi Flutter. Inisialisasi providers global dan routing."
    if "controller" in p:
        return "Controller layer yang memisahkan logika UI dari tampilan Screen."
    return "Modul pendukung (helper, utilitas, atau konfigurasi) spesifik sesuai nama file."


# ─── MAIN ──────────────────────────────────────────────────────────────────────

def main():
    print("[INFO] Membaca graph.json ...")
    with open(GRAPH_JSON, encoding="utf-8") as f:
        graph = json.load(f)

    all_nodes = graph.get("nodes", [])
    all_edges = graph.get("links", [])

    # ── Filter: frontend/lib saja, bukan folder terlarang ──
    fe_prefix = "frontend/lib/"
    fe_file_nodes = [
        n for n in all_nodes
        if (n.get("source_file") or "").startswith(fe_prefix)
        and not n.get("_callable")
        and not should_exclude(n.get("source_file") or "")
    ]

    # ── Index: node id → node ──
    node_by_id = {n["id"]: n for n in all_nodes}

    # ── Index: source_file → symbol nodes (callable members) ──
    members_by_file: dict[str, list] = defaultdict(list)
    for n in all_nodes:
        sf = n.get("source_file") or ""
        if sf.startswith(fe_prefix) and n.get("_callable") and not should_exclude(sf):
            members_by_file[sf].append(n)

    # ── Index: source_file → Provider nodes referenced ──
    providers_by_file: dict[str, set] = defaultdict(set)
    # ── Index: source_file → internal imports ──
    imports_by_file: dict[str, set] = defaultdict(set)
    # ── Index: source_file → imported by (reverse deps) ──
    reverse_deps: dict[str, set] = defaultdict(set)

    for e in all_edges:
        sf = e.get("source_file") or ""
        if not sf.startswith(fe_prefix) or should_exclude(sf):
            continue

        relation = e.get("relation", "")
        target_id = e.get("target") or ""
        target_node = node_by_id.get(target_id)
        if not target_node:
            continue
        target_sf = target_node.get("source_file") or ""
        target_label = target_node.get("label", "")

        # Provider references (bloc_lookup / references ke provider)
        if relation == "references" and e.get("context") == "bloc_lookup":
            if "provider" in target_label.lower() or "provider" in target_sf.lower():
                providers_by_file[sf].add(target_label)

        # Internal imports
        if relation in ("imports", "imports_from"):
            if target_sf.startswith(fe_prefix) and target_sf != sf and not should_exclude(target_sf):
                imports_by_file[sf].add(target_label or target_sf.split("/")[-1])
                reverse_deps[target_sf].add(sf.split("/")[-1])

    # ── Sort & Group by folder ──
    fe_file_nodes.sort(key=lambda n: (n.get("source_file") or ""))
    by_folder: dict[str, list] = defaultdict(list)
    for n in fe_file_nodes:
        sf = n.get("source_file") or ""
        folder = "/".join(sf.split("/")[:-1])
        by_folder[folder].append(n)

    # ── Statistics ──
    total_files = len(fe_file_nodes)
    total_members = sum(len(v) for v in members_by_file.values())
    total_relations = len([e for e in all_edges if (e.get("source_file") or "").startswith(fe_prefix)])
    provider_files = len([k for k in fe_file_nodes if "provider" in (k.get("source_file") or "").lower()])
    screen_files = len([k for k in fe_file_nodes if "screen" in (k.get("source_file") or "").lower()])
    service_files = len([k for k in fe_file_nodes if "service" in (k.get("source_file") or "").lower() or "api_" in (k.get("source_file") or "").lower()])

    print(f"   [OK] {total_files} file | {total_members} member | {total_relations} relasi")

    # ── Write Markdown ──
    os.makedirs(os.path.dirname(OUT_PATH), exist_ok=True)
    with open(OUT_PATH, "w", encoding="utf-8") as f:

        f.write("# 📱 Panduan Frontend Flutter (Graphify Knowledge Graph)\n\n")
        f.write("Dokumen ini digenerate dari **graphify-out/graph.json** — bukan dari scan regex langsung.\n")
        f.write("Setiap entitas dan relasi di bawah ini dibangun dari Knowledge Graph proyek ini.\n\n")
        f.write(f"> **Script:** `backend/scripts/graphify_docs/generate_frontend_graphify.py`\n\n")
        f.write("---\n\n")

        # Ringkasan statistik
        f.write("## 📊 Ringkasan Statistik\n\n")
        f.write("| Metrik | Nilai |\n|---|---|\n")
        f.write(f"| Total File Frontend (aktif) | **{total_files}** |\n")
        f.write(f"| Total Member (fungsi/widget) | **{total_members}** |\n")
        f.write(f"| Total Relasi (edges) | **{total_relations}** |\n")
        f.write(f"| File Screen | **{screen_files}** |\n")
        f.write(f"| File Provider | **{provider_files}** |\n")
        f.write(f"| File Service / API | **{service_files}** |\n")
        f.write(f"| Total Folder | **{len(by_folder)}** |\n")
        f.write("\n---\n\n")

        for folder in sorted(by_folder.keys()):
            display = folder if folder else "frontend/lib (root)"
            f.write(f"## 📁 Folder: `{display}`\n\n")
            f.write(f"**Tujuan Folder:** {folder_role(folder)}\n\n")

            for node in by_folder[folder]:
                sf = node.get("source_file") or ""
                community = node.get("community", "-")

                members = members_by_file.get(sf, [])
                providers = providers_by_file.get(sf, set())
                imports = imports_by_file.get(sf, set())
                rev = reverse_deps.get(sf, set())

                f.write(f"### File: `{sf}`\n\n")
                f.write(f"**Tanggung Jawab:** {file_role(sf)}\n\n")
                f.write(f"**Community Group:** `{community}`\n\n")

                # Member symbols (dedupe label)
                if members:
                    seen = set()
                    unique = []
                    for m in members:
                        lbl = m.get("label", "")
                        if lbl and lbl not in seen:
                            seen.add(lbl)
                            unique.append(m)
                    f.write("**Members (Widget/Fungsi/State):**\n\n")
                    for m in unique[:20]:
                        f.write(f"- `{m['label']}`\n")
                    if len(unique) > 20:
                        f.write(f"- *(... dan {len(unique) - 20} member lainnya)*\n")
                    f.write("\n")

                # Provider dependencies
                if providers:
                    f.write("**Mengkonsumsi Provider:**\n\n")
                    for p in sorted(providers):
                        f.write(f"- `{p}`\n")
                    f.write("\n")

                # Internal imports
                if imports:
                    f.write("**Import Internal:**\n\n")
                    for imp in sorted(imports)[:10]:
                        f.write(f"- `{imp}`\n")
                    f.write("\n")

                # Reverse deps
                if rev:
                    f.write("**Dipakai Oleh:**\n\n")
                    for r in sorted(rev)[:8]:
                        f.write(f"- `{r}`\n")
                    f.write("\n")

                f.write("---\n\n")

    print(f"[OK] Selesai! Dokumentasi tersimpan di:\n   -> {OUT_PATH}")


if __name__ == "__main__":
    main()
