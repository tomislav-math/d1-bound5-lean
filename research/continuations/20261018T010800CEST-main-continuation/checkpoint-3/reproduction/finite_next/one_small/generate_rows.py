from pathlib import Path
import json
b=Path('finite_next/one_small');out=b/'D1Bound5';d=json.loads((b/'finite_data.json').read_text());ps=d['pairs'];rs=d['triples']
def xy(z):return f'({z[0]},{z[1]})'
def row(r):
 p=ps[r['pair']]
 return f'⟨{p["tau"]},{p["nu"]},{xy(p["a"])},{xy(p["b"])},{xy(r["s"])},{r["n0"]}⟩'
lines=[f'import D1Bound5.OneSmallFourthData{i}' for i in range(1,8)]+['','namespace D1Bound5','open QuadInt','',
 '/-- The complete fixed-triple certificate record from the manuscript. -/',
 'structure OneSmallTripleRow where',
 '  tau : ℤ','  nu : ℤ','  a : ℤ × ℤ','  b : ℤ × ℤ','  s : ℤ × ℤ','  cutoff : ℤ',
 '  deriving DecidableEq, Repr','',
 'def oneSmallFixedRows : Finset OneSmallTripleRow :=',
 '  {'+',\n   '.join(row(r) for r in rs)+'}','',
 'def OneSmallTripleRow.anchorA (r : OneSmallTripleRow) : QuadInt r.tau r.nu := ⟨r.a.1,r.a.2⟩',
 'def OneSmallTripleRow.anchorB (r : OneSmallTripleRow) : QuadInt r.tau r.nu := ⟨r.b.1,r.b.2⟩',
 'def OneSmallTripleRow.anchorS (r : OneSmallTripleRow) : QuadInt r.tau r.nu := ⟨r.s.1,r.s.2⟩','',
 '/-- All 56 bounded complements are checked with exact integral roots.',
 'Zero and anchor coincidences are allowed throughout this theorem. -/',
 'theorem oneSmallFixedRows_bounded_growth (r : OneSmallTripleRow)',
 '    (hr : r ∈ oneSmallFixedRows) (z : QuadInt r.tau r.nu) (hz : z.norm < r.cutoff)',
 '    (ha : ∃ q, q*q = r.anchorA*z+1) (hb : ∃ q, q*q = r.anchorB*z+1)',
 '    (hs : ∃ q, q*q = r.anchorS*z+1) : z.norm ≤ 4*r.anchorB.norm*r.anchorS.norm := by',
 '  simp only [oneSmallFixedRows, Finset.mem_insert, Finset.mem_singleton] at hr',
 '  rcases hr with '+' | '.join('rfl' for r in rs)]
for r in rs:lines += [f'  · exact oneSmallFourth_{r["index"]}_growth z hz ha hb hs']
lines += ['', '/-- The ordered finite row relation keeps the cutoff attached to its exact triple. -/',
 'def OneSmallRowMembership {tau nu : ℤ} (a b s : QuadInt tau nu) (cutoff : ℤ) : Prop :=',
 '  (⟨tau,nu,(a.re,a.im),(b.re,b.im),(s.re,s.im),cutoff⟩ : OneSmallTripleRow) ∈ oneSmallFixedRows','',
 'def OneSmallThirdRowProperty {tau nu : ℤ} (a b : QuadInt tau nu) : Prop :=',
 '  ∀ s : QuadInt tau nu, s.norm ≤ 224 → b.norm ≤ s.norm → s ≠ a → s ≠ b →',
 '    PairExtension a b s →',
 '    (a = 1 ∧ b = -3 ∧ s = 3) ∨ ∃ cutoff, OneSmallRowMembership a b s cutoff','']
for p in ps:
 i,t,n=p['index'],p['tau'],p['nu']
 allowed=d['third_entries'][str(i)]
 lines += [f'theorem oneSmallThirdRows_{i}_complete :',
 f'    OneSmallThirdRowProperty oneSmallPairA_{i} oneSmallPairB_{i} := by',
 '  intro s hbound horder ha hb hpair',
 f'  have hm := oneSmallThirds_{i}_complete s hbound horder ha hb hpair',
 f'  simp only [oneSmallThirds_{i}, List.mem_cons, List.not_mem_nil, or_false] at hm',
 '  rcases hm with '+' | '.join('rfl' for _ in allowed)]
 for s in allowed:
  if i==7 and s==[3,0]:
   lines += ['  · left',f'    norm_num [oneSmallPairA_{i},oneSmallPairB_{i}]']
  else:
   r=next(r for r in rs if r['pair']==i and r['s']==s)
   lines += [f'  · exact Or.inr ⟨{r["n0"]}, by decide +kernel⟩']
 lines += ['']
lines += ['end D1Bound5',''];(out/'OneSmallRows.lean').write_text('\n'.join(lines))
print('Generated 56-row bounded growth theorem and all40 normalized third-entry endpoints.')
