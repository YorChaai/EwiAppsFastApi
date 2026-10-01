# -*- coding: utf-8 -*-
import os
from update_test_matrix_steps import all_modules

md_path = r"d:\2. Organize\1. Projects\MiniProjectKPI_EWI_Revisi2\docs\master_test_matrix_checklist.md"

md_lines = [
    "# Master Test Matrix & QA Checklist (19 Modul Lengkap)",
    "",
    "> **Panduan QA:** Gunakan daftar uji ini untuk memvalidasi seluruh fungsionalitas sistem secara bertahap. Setiap skenario mencantumkan menu persis, tombol yang ditekan, data yang dimasukkan, dan hasil verifikasi di layar.",
    ""
]

for mod in all_modules:
    md_lines.append(f"## MODUL {mod['num']}: {mod['title'].upper()}")
    md_lines.append(f"_{mod['desc']}_")
    md_lines.append("")
    for case in mod["cases"]:
        clean_desc = (
            case["desc"]
            .replace("<strong>", "**")
            .replace("</strong>", "**")
            .replace("<em>", "*")
            .replace("</em>", "*")
        )
        md_lines.append(f"- [ ] **{case['code']}** | {clean_desc}")
    md_lines.append("")
    md_lines.append("---")
    md_lines.append("")

with open(md_path, "w", encoding="utf-8") as f:
    f.write("\n".join(md_lines))

print("Successfully synced master_test_matrix_checklist.md from update_test_matrix_steps.py!")
