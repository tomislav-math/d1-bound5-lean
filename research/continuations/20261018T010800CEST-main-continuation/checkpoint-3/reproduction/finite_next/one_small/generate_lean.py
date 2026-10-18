from pathlib import Path
import sys,json
sys.path.insert(0,'finite_next/two_small')
from generate_pair_closures import disk
base=Path('finite_next/one_small');out=base/'D1Bound5'
d=json.loads((base/'finite_data.json').read_text());pairs=d['pairs'];triples=d['triples']
models=sorted({(p['tau'],p['nu']) for p in pairs})
def z(z):return f'⟨{z[0]},{z[1]}⟩'
def coord(z):return f'({z[0]},{z[1]})'
def pair(r):return f'({coord(r[0])},{coord(r[1])})'
def zs(rows):return '['+', '.join(map(z,rows))+']'
head=['namespace D1Bound5','open QuadInt','set_option maxRecDepth 32768','set_option maxHeartbeats 12000000','']

# Integer disks are certified once per field and reused by all representative rows.
lines=['import D1Bound5.OneSmallFiniteCheck','']+head
for t,n in models:
 for L in (224,300):
  name=f'oneSmallDisk_{L}_{t}_{n}'
  lines += [f'def {name} : List (QuadInt {t} {n}) := {zs(sorted(disk(t,n,L)))}','',
    f'theorem {name}_eq : disk {t} {n} {L} = {name}.toFinset := by',
    '  decide +kernel','']
lines+=['end D1Bound5',''];(out/'OneSmallDisks.lean').write_text('\n'.join(lines))

lines=['import D1Bound5.OneSmallFiniteCheck','']+head+[
 'def firstPairOrbit (tau : ℤ) (row : (ℤ × ℤ) × (ℤ × ℤ)) :',
 '    Finset ((ℤ × ℤ) × (ℤ × ℤ)) :=',
 '  {row, ((-row.1.1,-row.1.2),(-row.2.1,-row.2.2)),',
 '   ((row.1.1+tau*row.1.2,-row.1.2),(row.2.1+tau*row.2.2,-row.2.2)),',
 '   ((-row.1.1-tau*row.1.2,row.1.2),(-row.2.1-tau*row.2.2,row.2.2))}','']
for table in d['pair_tables']:
 t,n,rs=table['tau'],table['nu'],table['rows']
 lines += [f'def firstPairs_{t}_{n} : List ((ℤ × ℤ) × (ℤ × ℤ)) :=',
   '  ['+', '.join(map(pair,rs))+']','']
lines += ['def firstPairTable (tau nu : ℤ) : List ((ℤ × ℤ) × (ℤ × ℤ)) :=']
for table in d['pair_tables']:
 t,n=table['tau'],table['nu'];lines += [f'  if tau = {t} ∧ nu = {n} then firstPairs_{t}_{n} else']
lines += ['  []','']
for t,n in models:
 rs=[(p['a'],p['b']) for p in pairs if (p['tau'],p['nu'])==(t,n)]
 lines += [f'def firstPairRepresentatives_{t}_{n} : Finset ((ℤ × ℤ) × (ℤ × ℤ)) :=',
   '  {'+', '.join(map(pair,rs))+'}','',
   f'theorem firstPairTable_{t}_{n}_orbits :',
   f'    firstPairs_{t}_{n}.toFinset = firstPairRepresentatives_{t}_{n}.biUnion (firstPairOrbit {t}) := by',
   '  decide +kernel','']
for table in d['pair_tables']:
 t,n=table['tau'],table['nu'];diskname=f'smallDisk_{t}_{n}'
 lines += [f'theorem firstPair_{t}_{n}_checked :',
  f'    firstPairClassifiedBool {diskname} {diskname} (firstPairTable {t} {n}) = true := by',
  '  decide +kernel','',f'theorem firstPair_classified_{t}_{n}',
  f'    (a b : QuadInt {t} {n}) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :',
  f'    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable {t} {n} := by',
  f'  apply firstPairClassified_of_checked (by decide) {diskname} {diskname}',
  f'    (firstPairTable {t} {n}) ?_ ?_ firstPair_{t}_{n}_checked a b hnorm hroot',
  f'  all_goals intro q hq; rw [{diskname}_eq, List.mem_toFinset] at hq; exact hq','']
lines += ['theorem firstPair_classified_rectangular {tau nu : ℤ}',
 '    (htau : tau = 0 ∨ tau = 1) (hlo : 1 ≤ nu) (hhi : nu ≤ 8)',
 '    (a b : QuadInt tau nu) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :',
 '    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable tau nu := by',
 '  rcases htau with rfl | rfl']
for t in (0,1):
 lines+=['  · interval_cases nu']
 for n in range(1,9):lines += [f'    · exact firstPair_classified_{t}_{n} a b hnorm hroot']
lines+=['','end D1Bound5',''];(out/'FirstPairData.lean').write_text('\n'.join(lines))

lines=['import D1Bound5.OneSmallDisks','']+head
for p in pairs:
 i,t,n=p['index'],p['tau'],p['nu'];allowed=d['third_entries'][str(i)];diskname=f'oneSmallDisk_224_{t}_{n}'
 lines += [f'def oneSmallPairA_{i} : QuadInt {t} {n} := {z(p["a"])}',
  f'def oneSmallPairB_{i} : QuadInt {t} {n} := {z(p["b"])}',
  f'def oneSmallThirds_{i} : List (QuadInt {t} {n}) := {zs(allowed)}','',
  f'theorem oneSmallThirds_{i}_checked :',
  f'    oneSmallThirdCoveredBool oneSmallPairA_{i} oneSmallPairB_{i}',
  f'      {diskname} oneSmallThirds_{i} = true := by','  decide +kernel','',
  f'theorem oneSmallThirds_{i}_complete (s : QuadInt {t} {n}) (hbound : s.norm ≤ 224)',
  f'    (horder : oneSmallPairB_{i}.norm ≤ s.norm)',
  f'    (ha : s ≠ oneSmallPairA_{i}) (hb : s ≠ oneSmallPairB_{i})',
  f'    (hpair : PairExtension oneSmallPairA_{i} oneSmallPairB_{i} s) : s ∈ oneSmallThirds_{i} := by',
  f'  apply oneSmallThirdCovered_of_checked (by decide) oneSmallPairA_{i} oneSmallPairB_{i}',
  f'    {diskname} oneSmallThirds_{i} ?_ oneSmallThirds_{i}_checked s hbound horder ha hb hpair',
  f'  intro q hq; rw [{diskname}_eq, List.mem_toFinset] at hq; exact hq','']
lines+=['end D1Bound5',''];(out/'OneSmallThirdData.lean').write_text('\n'.join(lines))

for group in range(7):
 lines=['import D1Bound5.OneSmallThirdData','']+head
 for r in triples[group*8:(group+1)*8]:
  j,i=r['index'],r['pair'];p=pairs[i];t,n=p['tau'],p['nu'];name=f'oneSmallDisk_300_{t}_{n}'
  lines += [f'def oneSmallTripleS_{j} : QuadInt {t} {n} := {z(r["s"])}',
    f'def oneSmallTripleCutoff_{j} : ℤ := {r["n0"]}','',
    f'theorem oneSmallFourth_{j}_checked :',
    f'    oneSmallFourthGrowthBool oneSmallPairA_{i} oneSmallPairB_{i} oneSmallTripleS_{j}',
    f'      oneSmallTripleCutoff_{j} {name} = true := by','  decide +kernel','',
    f'theorem oneSmallFourth_{j}_growth (z : QuadInt {t} {n})',
    f'    (hz : z.norm < oneSmallTripleCutoff_{j})',
    f'    (ha : ∃ q, q*q = oneSmallPairA_{i}*z+1)',
    f'    (hb : ∃ q, q*q = oneSmallPairB_{i}*z+1)',
    f'    (hs : ∃ q, q*q = oneSmallTripleS_{j}*z+1) :',
    f'    z.norm ≤ 4*oneSmallPairB_{i}.norm*oneSmallTripleS_{j}.norm := by',
    f'  apply oneSmallFourthGrowth_of_checked (by decide)',
    f'    oneSmallPairA_{i} oneSmallPairB_{i} oneSmallTripleS_{j}',
    f'    (by decide) (by decide) oneSmallTripleCutoff_{j} (by decide)',
    f'    {name} ?_ oneSmallFourth_{j}_checked z hz ha hb hs',
    f'  intro q hq; rw [{name}_eq, List.mem_toFinset] at hq; exact hq','']
 lines+=['end D1Bound5',''];(out/f'OneSmallFourthData{group+1}.lean').write_text('\n'.join(lines))
print('Generated generic finite checker data: 16 first-pair disks, 40 third lists, 56 bounded fourth certificates.')
