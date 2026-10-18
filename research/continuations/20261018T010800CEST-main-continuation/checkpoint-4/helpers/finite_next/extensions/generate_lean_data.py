from pathlib import Path
import json,math
rows=json.loads(Path('finite_next/triple/extensions.json').read_text())
# Imported generator is not executed; this copies only the exact disk rule.
def disk(t,n,M):
 D=4*n-t*t;r=math.isqrt(4*M)
 return sorted(((e-t*y)//2,y) for y in range(-math.isqrt(4*M//D),math.isqrt(4*M//D)+1) for e in range(-r,r+1) if (e-t*y)%2==0 and e*e+D*y*y<=4*M)
def lean_list(zs):return '[\n'+',\n'.join(f'  ⟨{x},{y}⟩' for x,y in zs)+'\n]'
def point(p):return f'⟨{p[0]},{p[1]}⟩'
lines=['import D1Bound5.PairExtensionCore','','namespace D1Bound5','open QuadInt','set_option maxRecDepth 32768','set_option maxHeartbeats 8000000','']
for t,n in [(0,1),(0,2),(1,1),(1,2)]:
 lines += [f'def seedRootDisk_{t}_{n} : List (QuadInt {t} {n}) := {lean_list(disk(t,n,132))}',
  f'theorem seedRootDisk_{t}_{n}_eq : disk {t} {n} 132 = seedRootDisk_{t}_{n}.toFinset := by',
  '  decide +kernel','']
Path('finite_next/extensions/D1Bound5/PairSeedDisks.lean').write_text('\n'.join(lines)+'\nend D1Bound5\n')
for row in rows:
 k,t,n=row['row'],row['tau'],row['nu'];a,b=row['anchors'];c=next(p for p in row['triple'] if p!=a and p!=b)
 lines=['import D1Bound5.PairSeedDisks','','namespace D1Bound5','open QuadInt','set_option maxRecDepth 32768','set_option maxHeartbeats 8000000','',
 f'def smallTripleAnchorA_{k} : QuadInt {t} {n} := {point(a)}',
 f'def smallTripleAnchorB_{k} : QuadInt {t} {n} := {point(b)}',
 f'def smallTripleAnchorC_{k} : QuadInt {t} {n} := {point(c)}','',
 f'def smallTriplePairClosure_{k} : List (QuadInt {t} {n}) := {lean_list(row["vertices"])}','',
 f'def smallTripleAllowed_{k} : List (QuadInt {t} {n}) := {lean_list(row["extension"])}','',
 f'theorem smallTripleSeeds_{k}_checked :',
 f'    pairSeedsCoveredBool smallTripleAnchorA_{k} smallTripleAnchorB_{k}',
 f'      seedRootDisk_{t}_{n} smallTriplePairClosure_{k} = true := by',
 '  decide +kernel','',
 f'theorem smallTripleClosure_{k}_checked :',
 f'    pairClosureBool smallTripleAnchorA_{k} smallTripleAnchorB_{k}',
 f'      (10^80) smallTriplePairClosure_{k} = true := by','  decide +kernel','',
 f'theorem smallTripleFilter_{k}_checked :',
 f'    tripleExtensionFilterBool smallTripleAnchorA_{k} smallTripleAnchorB_{k}',
 f'      smallTripleAnchorC_{k} smallTriplePairClosure_{k} smallTripleAllowed_{k} = true := by',
 '  decide +kernel','',
 f'theorem smallTripleClosure_{k}_count : smallTriplePairClosure_{k}.length = {len(row["vertices"])} := by',
 '  decide +kernel','', 'end D1Bound5','']
 Path(f'finite_next/extensions/D1Bound5/SmallTripleExtensionData{k}.lean').write_text('\n'.join(lines))
print('Wrote4root disks and10individual closure certificate modules.')
