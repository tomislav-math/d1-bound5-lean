from pathlib import Path
import sys,json
from itertools import combinations
sys.path.insert(0,'finite_next/two_small')
from generate_pair_closures import norm,mul,add,root,disk
models=[(t,n) for t in (0,1) for n in range(1,9)]
allpairs={}
for t,n in models:
 xs=sorted(z for z in disk(t,n,8) if z!=(0,0))
 allpairs[t,n]=[list(p) for p in combinations(xs,2) if add(mul(t,n,*p),(1,0))!=(0,0) and root(t,n,add(mul(t,n,*p),(1,0))) is not None]
reps={}
for p in sorted(Path('finite_next/two_small/closures').glob('pair_*.json')):
 row=json.loads(p.read_text());reps.setdefault((row['tau'],row['nu']),[]).append(row['anchors'])
for (t,n),rs in reps.items():
 orbit=set()
 for r in rs:
  for sign in (-1,1):
   for conj in (False,True):
    orbit.add(tuple(sorted((sign*(x+t*y if conj else x),sign*(-y if conj else y)) for x,y in r)))
 assert orbit=={tuple(map(tuple,r)) for r in allpairs[t,n]},(t,n)

def rowtext(row):return '{'+', '.join(f'({x},{y})' for x,y in row)+'}'
def listtext(rows):return '[\n'+',\n'.join('  '+rowtext(row) for row in rows)+'\n]'
lines=['import D1Bound5.SmallPairClassificationCheck','import D1Bound5.SmallTripleData','','namespace D1Bound5','open QuadInt','set_option maxRecDepth 32768','set_option maxHeartbeats 6000000','']
for t,n in models:
 lines += [f'def smallPairs_{t}_{n} : List (Finset (ℤ × ℤ)) := {listtext(allpairs[t,n])}','']
lines += ['def smallPairTable (tau nu : ℤ) : List (Finset (ℤ × ℤ)) :=']
for t,n in models:lines += [f'  if tau = {t} ∧ nu = {n} then smallPairs_{t}_{n} else']
lines += ['  []','']
for (t,n),rs in reps.items():
 lines += [f'def smallPairRepresentatives_{t}_{n} : Finset (Finset (ℤ × ℤ)) :=',
 '  {'+', '.join(rowtext(r) for r in rs)+'}','',
 f'theorem smallPairTable_{t}_{n}_orbits :',
 f'    smallPairs_{t}_{n}.toFinset = smallPairRepresentatives_{t}_{n}.biUnion (smallTripleOrbit {t}) := by',
 '  decide +kernel','']
for t,n in models:
 lines += [f'theorem smallPairs_{t}_{n}_checked :',
 f'    smallPairClassifiedBool smallDisk_{t}_{n} (smallPairTable {t} {n}) = true := by',
 '  decide +kernel','',
 f'theorem smallPair_classified_{t}_{n}',
 f'    (a b : QuadInt {t} {n}) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)',
 '    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)',
 '    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :',
 f'    pairCoordinates a b ∈ smallPairTable {t} {n} := by',
 f'  apply smallPairClassified_of_explicit_list (by decide) smallDisk_{t}_{n}',
 f'    (smallPairTable {t} {n}) ?_ smallPairs_{t}_{n}_checked a b ha hb hab hroot hnondeg hNa hNb',
 '  intro z hz',f'  rw [smallDisk_{t}_{n}_eq, List.mem_toFinset] at hz','  exact hz','']
lines += ['theorem smallPair_classified_rectangular {tau nu : ℤ}',
 '    (htau : tau = 0 ∨ tau = 1) (hlo : 1 ≤ nu) (hhi : nu ≤ 8)',
 '    (a b : QuadInt tau nu) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)',
 '    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)',
 '    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :',
 '    pairCoordinates a b ∈ smallPairTable tau nu := by',
 '  rcases htau with rfl | rfl']
for t in (0,1):
 lines += ['  · interval_cases nu']
 for n in range(1,9):lines += [f'    · exact smallPair_classified_{t}_{n} a b ha hb hab hroot hnondeg hNa hNb']
lines += ['','end D1Bound5','']
Path('finite_next/two_small/classification/D1Bound5/SmallPairClassificationData.lean').write_text('\n'.join(lines))
print('All16pair tables generated; exact agreement with48manuscript orbits on11maximalmodels.')
print({str(k):len(v) for k,v in allpairs.items()})
