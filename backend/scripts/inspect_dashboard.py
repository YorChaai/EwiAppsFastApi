import re
import json

dashboard_path = r"d:\2. Organize\1. Projects\MiniProjectKPI_EWI_Revisi2\docs\interactive_test_dashboard.html"

with open(dashboard_path, "r", encoding="utf-8") as f:
    content = f.read()

# Let's inspect testMatrixData in interactive_test_dashboard.html
print("File length:", len(content))
