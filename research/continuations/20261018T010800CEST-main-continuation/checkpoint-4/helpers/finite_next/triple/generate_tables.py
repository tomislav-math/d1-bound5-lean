from pathlib import Path
from itertools import combinations

def norm(t,n,z):
 x,y=z;return x*x+t*x*y+n*y*y

def mul(t,n,z,w):
 x,y=z;u,v=w;return x*u-n*y*v,x*v+y*u+t*y*v

def disk(t,n,M):
 return sorted((x,y) for x in range(-10,11) for y in range(-10,11) if norm(t,n,(x,y))<=M)

def triangles(t,n):
 xs=[z for z in disk(t,n,8) if z!=(0,0)]
 squares={mul(t,n,z,z) for z in disk(t,n,9)}
 def compat(a,b):
  x,y=mul(t,n,a,b);return (x+1,y) in squares
 return [zs for zs in combinations(xs,3) if all(compat(a,b) for a,b in combinations(zs,2))]

allrows={(t,n):triangles(t,n) for t in (0,1) for n in range(1,9)}
# The four maximal rings and ten exact manuscript representatives.
reps={
 (0,1):[ [(-2,-2),(-2,2),(2,0)], [(-2,-1),(0,-1),(2,-1)], [(-2,-1),(0,2),(2,-1)], [(-2,0),(-1,-2),(1,0)] ],
 (0,2):[ [(-2,0),(1,-1),(1,1)] ],
 (1,1):[ [(-1,-1),(-2,1),(1,0)], [(-1,-1),(2,-3),(1,0)], [(0,-1),(1,-2),(1,-1)] ],
 (1,2):[ [(-2,-1),(-3,1),(1,0)], [(-2,-1),(-1,2),(3,-1)] ]}
for (t,n),rr in reps.items():
 orbit=set()
 for r in rr:
  for sign in (-1,1):
   for conj in (False,True):
    orbit.add(tuple(sorted((sign*(x+t*y if conj else x),sign*(-y if conj else y)) for x,y in r)))
 assert orbit==set(allrows[t,n]), ((t,n),orbit^set(allrows[t,n]))

p=Path('finite_next/triple/D1Bound5/SmallTripleData.lean')
lines=['import D1Bound5.SmallTripleCheck','import D1Bound5.SmallQuadrupleData','','namespace D1Bound5','open QuadInt','set_option maxRecDepth 32768','set_option maxHeartbeats 6000000','']
for (t,n),rows in allrows.items():
 if not rows:continue
 text='[\n'+',\n'.join('  {'+', '.join(f'({x},{y})' for x,y in row)+'}' for row in rows)+'\n]'
 lines += [f'def smallTriples_{t}_{n} : List (Finset (ℤ × ℤ)) := {text}','']
lines += ['def smallTripleTable (tau nu : ℤ) : List (Finset (ℤ × ℤ)) :=',
 '  if tau = 0 then',
 '    if nu = 1 then smallTriples_0_1 else',
 '    if nu = 2 then smallTriples_0_2 else',
 '    if nu = 4 then smallTriples_0_4 else []',
 '  else if tau = 1 then',
 '    if nu = 1 then smallTriples_1_1 else',
 '    if nu = 2 then smallTriples_1_2 else []',
 '  else []','',
 '/-- Only five normalized coordinate models admit a small triple. The fifth',
 'is the nonmaximal Gaussian order, excluded at the full-ring endpoint. -/',
 'theorem smallTripleTable_models {tau nu : ℤ} {row : Finset (ℤ × ℤ)}',
 '    (h : row ∈ smallTripleTable tau nu) :',
 '    (tau = 0 ∧ nu = 1) ∨ (tau = 0 ∧ nu = 2) ∨ (tau = 0 ∧ nu = 4) ∨',
 '    (tau = 1 ∧ nu = 1) ∨ (tau = 1 ∧ nu = 2) := by',
 '  unfold smallTripleTable at h',
 '  split_ifs at h <;> simp_all','',
 '/-- The actual maximal-ring tables contain exactly 24 distinct triples. -/',
 'theorem smallTripleTable_counts :',
 '    smallTriples_0_1.length = 10 ∧ smallTriples_0_1.Nodup ∧',
 '    smallTriples_0_2.length = 2 ∧ smallTriples_0_2.Nodup ∧',
 '    smallTriples_1_1.length = 8 ∧ smallTriples_1_1.Nodup ∧',
 '    smallTriples_1_2.length = 4 ∧ smallTriples_1_2.Nodup := by',
 '  decide +kernel','']
for (t,n),rows in allrows.items():
 lines += [f'theorem smallTriples_{t}_{n}_checked :',
  f'    smallTripleClassifiedBool smallDisk_{t}_{n} (smallTripleTable {t} {n}) = true := by',
  '  decide +kernel','',
  f'theorem smallTriple_classified_{t}_{n}',
  f'    (t : Fin 3 → QuadInt {t} {n}) (ht : IsD1Tuple t)',
  '    (hnorm : ∀ i, (t i).norm ≤ 8) :',
  f'    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable {t} {n} := by',
  f'  apply smallTripleClassified_of_explicit_list (by decide) smallDisk_{t}_{n}',
  f'    (smallTripleTable {t} {n}) ?_ smallTriples_{t}_{n}_checked t ht hnorm',
  '  intro z hz',f'  rw [smallDisk_{t}_{n}_eq, List.mem_toFinset] at hz','  exact hz','']
lines += ['theorem smallTriple_classified_rectangular {tau nu : ℤ}',
 '    (htau : tau = 0 ∨ tau = 1) (hlo : 1 ≤ nu) (hhi : nu ≤ 8)',
 '    (t : Fin 3 → QuadInt tau nu) (ht : IsD1Tuple t)',
 '    (hnorm : ∀ i, (t i).norm ≤ 8) :',
 '    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable tau nu := by',
 '  rcases htau with rfl | rfl']
for t in (0,1):
 lines += ['  · interval_cases nu']
 for n in range(1,9):lines += [f'    · exact smallTriple_classified_{t}_{n} t ht hnorm']
lines += ['','end D1Bound5','']
p.write_text('\n'.join(lines))
print({str(k):len(v) for k,v in allrows.items()})
print('Confirmed exact orbit agreement with all ten manuscript representatives.')
