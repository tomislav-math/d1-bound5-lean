from pathlib import Path
import json
b=Path('finite_next/one_small');ps=json.loads((b/'finite_data.json').read_text())['pairs'];models=sorted({(p['tau'],p['nu']) for p in ps})
lines=['import D1Bound5.OneSmallSymmetry','','namespace D1Bound5','open QuadInt','']
for t,n in models:
 rs=[p for p in ps if (p['tau'],p['nu'])==(t,n)]
 lines += [f'theorem firstPairTable_{t}_{n}_third_rows (a b s : QuadInt {t} {n})',
 f'    (hrow : firstPairCoordinates a b ∈ firstPairTable {t} {n})',
 '    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)',
 '    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :',
 '    OneSmallNormalizedThirdRows a b s := by',
 f'  apply oneSmallThirdRows_of_table_orbits firstPairs_{t}_{n}',
 f'    firstPairRepresentatives_{t}_{n} firstPairTable_{t}_{n}_orbits ?_ a b s',
 '    (by simpa [firstPairTable] using hrow) hbound horder ha hb hpair',
 '  intro rep hrep',
 f'  simp only [firstPairRepresentatives_{t}_{n}, Finset.mem_insert, Finset.mem_singleton] at hrep',
 '  rcases hrep with '+' | '.join('rfl' for _ in rs)]
 for r in rs:lines += [f'  · exact oneSmallThirdRows_{r["index"]}_complete']
 lines += ['']
lines += ['theorem firstPairTable_third_rows {tau nu : ℤ}',
 '    (hmodel : (tau,nu) ∈ smallPairModels) (a b s : QuadInt tau nu)',
 '    (hrow : firstPairCoordinates a b ∈ firstPairTable tau nu)',
 '    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)',
 '    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :',
 '    OneSmallNormalizedThirdRows a b s := by',
 '  simp only [smallPairModels, Finset.mem_insert, Finset.mem_singleton, Prod.mk.injEq] at hmodel',
 '  rcases hmodel with '+' | '.join('⟨rfl,rfl⟩' for _ in range(11))]
for t,n in sorted(models+[(1,8)]):
 if(t,n)==(1,8):lines+=['  · simp [firstPairTable,firstPairs_1_8] at hrow']
 else:lines += [f'  · exact firstPairTable_{t}_{n}_third_rows a b s hrow hbound horder ha hb hpair']
lines += ['','end D1Bound5',''];(b/'D1Bound5/OneSmallOrbitRows.lean').write_text('\n'.join(lines))
