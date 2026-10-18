from pathlib import Path
import json
from generate_pair_closures import disk
base=Path('finite_next/two_small/D1Bound5')
rows=[json.loads(p.read_text()) for p in sorted(Path('finite_next/two_small/closures').glob('pair_*.json'))]
def point(z):return f'⟨{z[0]},{z[1]}⟩'
def leanlist(zs):return '[\n'+',\n'.join('  '+point(z) for z in zs)+'\n]'
models=sorted({(r['tau'],r['nu']) for r in rows})
existing={(0,1),(0,2),(1,1),(1,2)}
lines=['import D1Bound5.PairSeedDisks','','namespace D1Bound5','open QuadInt','set_option maxRecDepth 32768','set_option maxHeartbeats 8000000','']
for t,n in models:
 if (t,n) in existing:continue
 lines += [f'def seedRootDisk_{t}_{n} : List (QuadInt {t} {n}) := {leanlist(sorted(disk(t,n,132)))}',
 f'theorem seedRootDisk_{t}_{n}_eq : disk {t} {n} 132 = seedRootDisk_{t}_{n}.toFinset := by',
 '  decide +kernel','']
(base/'TwoSmallSeedDisks.lean').write_text('\n'.join(lines)+'\nend D1Bound5\n')
for row in rows:
 k,t,n=row['row'],row['tau'],row['nu'];a,b=row['anchors']
 lines=['import D1Bound5.TwoSmallSeedDisks','import D1Bound5.SmallPairGraphCheck','import D1Bound5.SmallPairSieves','','namespace D1Bound5','open QuadInt','set_option maxRecDepth 100000','set_option maxHeartbeats 100000000','',
 f'def smallPairA_{k} : QuadInt {t} {n} := {point(a)}',
 f'def smallPairB_{k} : QuadInt {t} {n} := {point(b)}','',
 f'def smallPairClosure_{k} : List (QuadInt {t} {n}) := {leanlist(row["closure"])}','',
 f'def smallPairLarge_{k} : List (QuadInt {t} {n}) := {leanlist(row["large"])}','',
 f'theorem smallPairSeeds_{k}_checked :',
 f'    pairSeedsCoveredBool smallPairA_{k} smallPairB_{k}',
 f'      seedRootDisk_{t}_{n} smallPairClosure_{k} = true := by',
 '  decide +kernel','',
 f'theorem smallPairClosure_{k}_checked :',
 f'    pairClosureBool smallPairA_{k} smallPairB_{k}',
 f'      (10^1100) smallPairClosure_{k} = true := by','  decide +kernel','',
 f'theorem smallPairFilter_{k}_checked :',
 f'    largePairVertices smallPairA_{k} smallPairB_{k} smallPairClosure_{k} = smallPairLarge_{k} := by',
 '  decide +kernel','',
 f'theorem smallPairNoTriangle_{k}_checked :',
 f'    pairGraphTriangleFreeBool smallPairSieve_{t}_{n} smallPairLarge_{k} = true := by','  decide +kernel','',
 f'theorem smallPairLarge_{k}_count : smallPairLarge_{k}.length = {len(row["large"])} := by',
 '  decide +kernel','', 'end D1Bound5','']
 (base/f'SmallPairGraphData{k}.lean').write_text('\n'.join(lines))
lines=[f'import D1Bound5.SmallPairGraphData{k}' for k in range(1,49)]+['','open scoped NumberField','open Module','','namespace D1Bound5','open QuadInt','']
for row in rows:
 k,t,n=row['row'],row['tau'],row['nu'];a=f'smallPairA_{k}';b=f'smallPairB_{k}';vs=f'smallPairClosure_{k}';ls=f'smallPairLarge_{k}'
 lines += [f'/-- Complete large-extension triangle exclusion for pair-table row {k}. -/',
 f'theorem smallPairGraph_{k}_excludes_three_full_ring',
 '    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]',
 '    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)',
 f'    (e : QuadInt {t} {n} ≃+* 𝓞 K) (t : Fin 3 → QuadInt {t} {n})',
 '    (ht : IsD1Tuple t)',
 f'    (hpair : ∀ i, PairExtension {a} {b} (t i))',
 '    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)',
 f'    (hneA : ∀ i, t i ≠ {a}) (hneB : ∀ i, t i ≠ {b}) : False := by',
 f'  have hpos : 0 < discriminant {t} {n} := by decide',
 f'  have hroot : ∃ r0, r0*r0 = {a}*{b}+1 :=',
 '    (hasSquareRoot_iff hpos _).1 (by decide +kernel)',
 f'  apply small_pair_graph_excludes_three_full_ring hK phi hpos e {a} {b}',
 '    (by decide) (by decide) (by decide) hroot (by decide) (by decide)',
 f'    (10^1100) seedRootDisk_{t}_{n} {vs} {ls}',
 f'    smallPairSieve_{t}_{n} smallPairSieve_{t}_{n}_valid ?_',
 f'    smallPairSeeds_{k}_checked smallPairClosure_{k}_checked smallPairFilter_{k}_checked',
 f'    smallPairNoTriangle_{k}_checked t ht hpair hlarge hbound hneA hneB',
 '  intro q hq',f'  rw [seedRootDisk_{t}_{n}_eq, List.mem_toFinset] at hq','  exact hq','']
lines += ['end D1Bound5','']
(base/'SmallPairGraphs.lean').write_text('\n'.join(lines))
print('Wrote48complete Lean certificate modules, seven extra seed disks, and48actual full-ring exclusion endpoints.')
print('Lean source total bytes',sum(p.stat().st_size for p in base.glob('*.lean')))
