import sys
import json
from pathlib import Path
from graphify.build import build_merge, build_from_json
from graphify.cluster import cluster, score_all
from graphify.analyze import god_nodes, surprising_connections, suggest_questions
from graphify.report import generate
from graphify.export import to_json

ast = json.loads(Path('graphify-out/.graphify_ast.json').read_text(encoding='utf-8'))
sem = json.loads(Path('graphify-out/.graphify_semantic.json').read_text(encoding='utf-8'))

seen = {n['id'] for n in ast.get('nodes', [])}
merged_nodes = list(ast.get('nodes', []))
for n in sem.get('nodes', []):
    if n['id'] not in seen:
        merged_nodes.append(n)
        seen.add(n['id'])

merged_edges = ast.get('edges', []) + sem.get('edges', [])
merged_hyperedges = sem.get('hyperedges', [])
merged = {
    'nodes': merged_nodes,
    'edges': merged_edges,
    'hyperedges': merged_hyperedges,
    'input_tokens': sem.get('input_tokens', 0),
    'output_tokens': sem.get('output_tokens', 0),
}
Path('graphify-out/.graphify_extract.json').write_text(json.dumps(merged, indent=2, ensure_ascii=False), encoding='utf-8')
print(f'Merged extraction: {len(merged_nodes)} nodes, {len(merged_edges)} edges.')

# Incremental merge with existing graph
incremental = json.loads(Path('graphify-out/.graphify_incremental.json').read_text(encoding='utf-8'))
deleted = list(incremental.get('deleted_files', []))
prune = list(deleted) or None

print('Merging with graph.json...')
G = build_merge(
    [merged],
    graph_path='graphify-out/graph.json',
    prune_sources=prune,
    root='.',
    directed=False,
)
print(f'Merge complete: {G.number_of_nodes()} nodes, {G.number_of_edges()} edges.')

# Run cluster and analysis
communities = cluster(G)
cohesion = score_all(G, communities)
labels = {cid: f'Community {cid}' for cid in communities}
gods = god_nodes(G)
surprises = surprising_connections(G, communities)
questions = suggest_questions(G, communities, labels)

# Write to graph.json directly
import networkx as nx
from networkx.readwrite import json_graph
data = json_graph.node_link_data(G, edges='links')
# attach communities
for node in data.get('nodes', []):
    nid = node.get('id')
    for cid, members in communities.items():
        if nid in members:
            node['community'] = cid
            break

Path('graphify-out/graph.json').write_text(json.dumps(data, ensure_ascii=False), encoding='utf-8')
print('graphify-out/graph.json updated successfully!')


