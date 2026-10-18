"""Emit isolated pilot41, preserving original large vertices byte-for-byte.
BFS is untrusted preparation: Lean checks both independent color classes;
the generic split theorem covers every original list element for ANY bit mask.
Do not modify the original graph/closure data or any disk certificate.
"""
from pathlib import Path
import json, hashlib, re
ROOT=Path(__file__).resolve().parents[2]
OUT=Path(__file__).resolve().parent
row=41
base=ROOT/'finite_next/two_small'
d=json.loads((base/f'closures/pair_{row:02}.json').read_text())
g=json.loads((base/f'graphs/pair_{row:02}.json').read_text())
vs=[tuple(v) for v in d['large']]
adj=[[] for _ in vs]
for i,j in g['exact_edges']:adj[i].append(j);adj[j].append(i)
colors=[None]*len(vs)
for i in range(len(vs)):
 if colors[i] is not None:continue
 colors[i]=0;queue=[i]
 for u in queue:
  for v in adj[u]:
   if colors[v] is None:colors[v]=1-colors[u];queue.append(v)
   else:assert colors[v]!=colors[u],(row,u,v)
mask=sum(int(c)<<i for i,c in enumerate(colors))
source=(base/f'D1Bound5/SmallPairGraphData{row:02}.lean').read_text()
m=re.search(r'def smallPairLarge_41 : List \(QuadInt 1 2\) := \[.*?\n\]',source,re.S)
assert m
literal=re.findall(r'⟨(-?\d+),(-?\d+)⟩',m.group())
assert [tuple(map(int,p)) for p in literal]==vs
body=m.group().replace('smallPairLarge_41','smallPairPilotLarge_41',1)
(OUT/'SmallPairBipartitePilotData41.lean').write_text('import D1Bound5.PairBipartiteCheck\n\nnamespace D1Bound5\nopen QuadInt\n'+body+f'\n\ndef smallPairPilotColors_41 : ℕ := {mask}\n\nend D1Bound5\n')
for c,name in [(0,'Left'),(1,'Right')]:
 proj=1+c
 (OUT/f'SmallPairBipartitePilot{name}41.lean').write_text(f'''import D1Bound5.SmallPairBipartitePilotData41
import D1Bound5.SmallPairSieve_1_2

namespace D1Bound5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem smallPairPilot{name}_41_checked :
    pairIndependentBool smallPairSieve_1_2
      (pairSplitByMask smallPairPilotLarge_41 smallPairPilotColors_41).{proj} = true := by
  decide +kernel

end D1Bound5
''')
(OUT/'SmallPairBipartitePilot41.lean').write_text('''import D1Bound5.SmallPairBipartitePilotLeft41
import D1Bound5.SmallPairBipartitePilotRight41

namespace D1Bound5

theorem smallPairPilotNoTriangle_41_checked :
    pairGraphTriangleFreeBool smallPairSieve_1_2 smallPairPilotLarge_41 = true :=
  pairGraphTriangleFreeBool_of_split smallPairSieve_1_2
    smallPairPilotLarge_41 smallPairPilotColors_41
    smallPairPilotLeft_41_checked smallPairPilotRight_41_checked

end D1Bound5
''')
counts=[colors.count(c) for c in (0,1)]
report={'row':41,'vertices':len(vs),'exact_edges_diagnostic':len(g['exact_edges']),
 'color_counts':counts,'same_color_unordered_checks':sum(n*(n-1)//2 for n in counts),
 'same_color_modular_survivors_diagnostic':sum(colors[i]==colors[j] for i,j in g['modular_edges']),
 'color_mask':str(mask),'original_large_literal_sha256':hashlib.sha256(m.group().encode()).hexdigest(),
 'original_source_sha256':hashlib.sha256(source.encode()).hexdigest(),
 'files':{p.name:{'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'bytes':p.stat().st_size} for p in sorted(OUT.glob('*.lean'))}}
(OUT/'pilot41_manifest.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps({k:v for k,v in report.items() if k not in ('files','color_mask')},indent=2))
