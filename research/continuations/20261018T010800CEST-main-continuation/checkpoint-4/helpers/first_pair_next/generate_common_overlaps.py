from pathlib import Path
import re
base=Path(__file__).resolve().parent.parent
ns={"__file__":str(base/"all_large_next/generate_overlaps.py")}
exec((base/'all_large_next/generate_overlaps.py').read_text().split('s=header')[0],ns)
items=ns['items']
# All transformations are exact symbolic substitutions in the independently
# reviewed all-large proof, with a separate pointwise rho bound at junction10.
def subst(s,idx):
 s=re.sub(r'(?<![0-9])400(?=\^)', 'G', s).replace('(400*','(G*').replace('(400/','(G/')
 for a,b in [('243','M2'),('2265','M3'),('165763','M4'),('3113013','M5')]:s=s.replace(a,b)
 s=s.replace('4143','Mbs' if idx=='9' else 'Mn')
 for a,b in [('(5/4 : ℝ)','R2'),('(3 : ℝ)','Rp'),('(35/16 : ℝ)','R3'),('(63/8 : ℝ)','R4'),('(495/64 : ℝ)','R5')]:s=s.replace(a,b)
 s=s.replace('(35/32 : ℝ)','Rbs' if idx=='10' else 'Rn')
 if idx=='0':
  s=s.replace('1024*','1024*K0^4*').replace('(1-1/4000 : ℝ)*A^10','(1-1/4000 : ℝ)*K0^4*A^10').replace('(A^2*T^5/S^2)','(K0*A^2*T^5/S^2)')
 if idx=='1':
  s=s.replace('(256/','(256*K0^2/').replace('A^8*','K0^2*A^8*').replace('(A^2*T^5/S^2)','(K0*A^2*T^5/S^2)')
 if idx=='10':
  s=s.replace('(G*(A^7*B^5*S^3))','((rho*Rbs)*(A^7*B^5*S^3))')
 return s
new=[]
for idx,q,raw,chain,hyp in items:
 q=subst(q,idx);raw=subst(raw,idx);chain=[(subst(a,idx),b) for a,b in chain]
 if idx=='1':q='(256*K0^2/(36*M2^2*(4001/3999 : ℝ)))*(A^8*S^4)'
 if idx=='10':q='(rho^2/(16*M4^2*(4001/3999 : ℝ)))*A^14'
 new.append((idx,q,raw,chain,hyp))
params='M2 Mn M3 M4 M5 Mbs R2 Rn R3 R4 R5 Rbs Rp'
qparams='M2 Mn M3 M4 M5 Mbs R2 Rn R3 R4 R5 Rp'
qargs=qparams
out='''import D1Bound5.AllLargeWindows

namespace D1Bound5

noncomputable def commonWindowN2 (A B C M R : ℝ) : ℝ × ℝ :=
  (4*M^2*B^8*C^5/(1-1/4000 : ℝ),A^6*C^7/(4*R^2*B^4*(1+1/4000 : ℝ)))
noncomputable def commonWindowN3 (A B C M R : ℝ) : ℝ × ℝ :=
  (4*M^2*B^14*C^7/(1-1/4000 : ℝ),A^8*C^11/(4*R^2*B^6*(1+1/4000 : ℝ)))
noncomputable def commonWindowA3 (A B C M R : ℝ) : ℝ × ℝ :=
  (4*M^2*B^12*C^7/(1-1/4000 : ℝ),A^8*C^9/(4*R^2*B^6*(1+1/4000 : ℝ)))
noncomputable def commonWindowA4 (A B C M R : ℝ) : ℝ × ℝ :=
  (4*M^2*B^18*C^9/(1-1/4000 : ℝ),A^10*C^13/(4*R^2*B^8*(1+1/4000 : ℝ)))
noncomputable def commonWindowA5 (A B C M R : ℝ) : ℝ × ℝ :=
  (4*M^2*B^24*C^11/(1-1/4000 : ℝ),A^12*C^17/(4*R^2*B^10*(1+1/4000 : ℝ)))
noncomputable def commonWindowP (A B S C R : ℝ) : ℝ × ℝ :=
  (4*2400^2*(max (B*S^3) (B^3*S^2))^2*C^5/(1-1/4000 : ℝ),
    A^6*C^9/(4*R^2*S^4*(1+1/4000 : ℝ)))

/-- The exact sixteen numerical comparisons. They are supplied by
independently checked rational records for each application, not assumed
as analytic bounds for the approximation families. -/
def CommonOverlapBounds (A B S G rho K0 '''+qparams+''' : ℝ) : Prop :=
'''
out+=' ∧\n'.join('  1 < '+q for _,q,_,_,_ in new)+'\n\n'
(base/'first_pair_next/CommonIntervalWindows.lean').write_text(out+'end D1Bound5\n')
# Build generalized theorem body using the same list of quotient proofs.
header='''import D1Bound5.CommonIntervalWindows

namespace D1Bound5

/-- Parameterized endpoint calculation for both the five unbounded
regions and the forty-one S≥15 first-pair regions. The relabeled N3
junction uses its pointwise coupled rho bound; K0 controls the stronger
retained starting coefficient. -/
theorem common_interval_window_overlaps
    (A B S T C G rho K0 '''+params+''' : ℝ)
    (hA0 : 0 < A) (hB0 : 0 < B) (hS0 : 0 < S) (hBS : B ≤ S)
    (hG : 0 < G) (hrho : 0 < rho) (hK0 : 0 < K0)
'''
for n in params.split():header+=f'    (h{n} : 0 < {n})\n'
header+='''    (hT : 2*B*S < T) (hC : K0*A^2*T^5/S^2 < C)
    (hgap : G*(A^7*B^5*S^3) < C)
    (hgapbs : (rho*Rbs)*(A^7*B^5*S^3) < C)
    (hnum : CommonOverlapBounds A B S G rho K0 '''+qargs+''') :
    (allLargeWindowQ A T C).1 < A^2*C^7/(S^2*T^4) ∧
    (commonWindowN2 A B C M2 R2).1 < (allLargeWindowQ A T C).2 ∧
    (commonWindowP A B S C Rp).1 < (commonWindowN2 A B C M2 R2).2 ∧
    (B^2 ≤ S → (commonWindowN3 A B C Mn Rn).1 < (commonWindowP A B S C Rp).2) ∧
    (commonWindowA3 A B C M3 R3).1 < (commonWindowP A B S C Rp).2 ∧
    (S ≤ B^2 → (allLargeWindowM A B S C).1 < (commonWindowA3 A B C M3 R3).2) ∧
    (commonWindowN3 A B C Mn Rn).1 < (allLargeWindowM A B S C).2 ∧
    (B^3 ≤ S → (commonWindowA4 A B C M4 R4).1 < (commonWindowN3 A B C Mn Rn).2) ∧
    (S ≤ B^3 → (commonWindowN3 B S C Mbs Rbs).1 < (commonWindowN3 A B C Mn Rn).2) ∧
    (commonWindowA4 A B C M4 R4).1 < (commonWindowN3 B S C Mbs Rbs).2 ∧
    ordinaryWindowLower B C 4 < (commonWindowA4 A B C M4 R4).2 ∧
    (commonWindowA5 A B C M5 R5).1 < ordinaryWindowUpper A B C 4 ∧
    ordinaryWindowLower B C 5 < (commonWindowA5 A B C M5 R5).2 ∧
    ordinaryWindowLower B C 6 < ordinaryWindowUpper A B C 5 ∧
    42*B^3*C < 2*A*C^2/(5*B) := by
  have hT0 : 0 < T := lt_trans (by positivity) hT
  have hbase0 : 0 < G*(A^7*B^5*S^3) := by positivity
  have hC0 : 0 < C := hbase0.trans hgap
  have hCbase0 : 0 < K0*A^2*T^5/S^2 := by positivity
  have hbsbase0 : 0 < (rho*Rbs)*(A^7*B^5*S^3) := by positivity
  rcases hnum with
    ⟨hq0,hq1,hq2,hq3,hq4,hq5,hq6,hq7,hq8,hq9,hq10,hq11,hq12,hq13,hq14,hq15⟩
'''
nonzeros="hA0.ne',hB0.ne',hS0.ne',hT0.ne',hC0.ne',hG.ne',hrho.ne',hK0.ne',"+','.join('h'+n+".ne'" for n in params.split())
s=header
for idx,q,raw,chain,hyp in new:
 s+=f'  have hr{idx} '+(f'(hextra : {hyp}) ' if hyp else '')+f': 1 < {raw} := by\n    calc\n      (1 : ℝ) < {q} := hq{idx}\n'
 for expr,rel in chain:
  if rel=='=':proof=f'by\n        field_simp [{nonzeros}]\n        <;> ring'
  else:proof='by\n        gcongr <;> first | exact hC.le | exact hgap.le | exact hgapbs.le | exact hT.le | exact hBS'+(' | exact hextra' if hyp else '')+' | positivity'
  s+=f'      _ {rel} {expr} := {proof}\n'
links=[
('0','(allLargeWindowQ A T C).1','A^2*C^7/(S^2*T^4)',None),
('1','(commonWindowN2 A B C M2 R2).1','(allLargeWindowQ A T C).2',None),
('2','4*2400^2*(B*S^3)^2*C^5/(1-1/4000 : ℝ)','(commonWindowN2 A B C M2 R2).2',None),
('3','4*2400^2*(B^3*S^2)^2*C^5/(1-1/4000 : ℝ)','(commonWindowN2 A B C M2 R2).2',None),
('4','(commonWindowN3 A B C Mn Rn).1','(commonWindowP A B S C Rp).2','B^2 ≤ S'),
('5','(commonWindowA3 A B C M3 R3).1','(commonWindowP A B S C Rp).2',None),
('6','(allLargeWindowM A B S C).1','(commonWindowA3 A B C M3 R3).2','S ≤ B^2'),
('7','(commonWindowN3 A B C Mn Rn).1','(allLargeWindowM A B S C).2',None),
('8','(commonWindowA4 A B C M4 R4).1','(commonWindowN3 A B C Mn Rn).2','B^3 ≤ S'),
('9','(commonWindowN3 B S C Mbs Rbs).1','(commonWindowN3 A B C Mn Rn).2','S ≤ B^3'),
('10','(commonWindowA4 A B C M4 R4).1','(commonWindowN3 B S C Mbs Rbs).2',None),
('11','ordinaryWindowLower B C 4','(commonWindowA4 A B C M4 R4).2',None),
('12','(commonWindowA5 A B C M5 R5).1','ordinaryWindowUpper A B C 4',None),
('13','ordinaryWindowLower B C 5','(commonWindowA5 A B C M5 R5).2',None),
('14','ordinaryWindowLower B C 6','ordinaryWindowUpper A B C 5',None),
('15','42*B^3*C','2*A*C^2/(5*B)',None)]
defs='allLargeWindowQ,allLargeWindowM,commonWindowN2,commonWindowN3,commonWindowP,commonWindowA3,commonWindowA4,commonWindowA5,ordinaryWindowLower,ordinaryWindowUpper'
for idx,l,u,hyp in links:
 raw=next(t[2] for t in new if t[0]==idx)
 s+=f'  have ho{idx} '+(f'(hextra : {hyp}) ' if hyp else '')+f': {l} < {u} := by\n'
 s+=f'    apply window_overlap_of_ratio ({l}) ({u}) ({raw})\n'
 s+=f'    · dsimp [{defs}]\n      positivity\n'
 s+=f'    · dsimp [{defs}]\n      field_simp [{nonzeros}]\n      <;> ring\n'
 s+=f'    · exact hr{idx}'+(' hextra' if hyp else '')+'\n'
s+='''  have hoP : (commonWindowP A B S C Rp).1 < (commonWindowN2 A B C M2 R2).2 := by
    rcases le_total (B*S^3) (B^3*S^2) with h | h
    · simpa only [commonWindowP,max_eq_right h] using ho3
    · simpa only [commonWindowP,max_eq_left h] using ho2
  exact ⟨ho0,ho1,hoP,ho4,ho5,ho6,ho7,ho8,ho9,ho10,ho11,ho12,ho13,ho14,ho15⟩

end D1Bound5
'''
(base/'first_pair_next/CommonIntervalOverlaps.lean').write_text(s)
