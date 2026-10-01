import sys
import json
from pathlib import Path
from graphify.extract import collect_files, extract

code_files = []
detect = json.loads(Path('graphify-out/.graphify_detect.json').read_text(encoding='utf-8'))
for f in detect.get('files', {}).get('code', []):
    p = Path(f)
    if p.is_dir():
        code_files.extend(collect_files(p))
    elif p.exists():
        code_files.append(p)

print(f'Collected {len(code_files)} code files for AST extraction.')
result = extract(code_files, cache_root=Path('.'))
Path('graphify-out/.graphify_ast.json').write_text(json.dumps(result, indent=2, ensure_ascii=False), encoding='utf-8')
n_nodes = len(result.get('nodes', []))
n_edges = len(result.get('edges', []))
print(f'AST Extraction Complete: {n_nodes} nodes, {n_edges} edges.')

Path('graphify-out/.graphify_semantic.json').write_text(
    json.dumps({'nodes': [], 'edges': [], 'hyperedges': [], 'input_tokens': 0, 'output_tokens': 0}),
    encoding='utf-8'
)
print('Semantic placeholder written.')
