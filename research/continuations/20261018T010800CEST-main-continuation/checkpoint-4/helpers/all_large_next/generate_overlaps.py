from pathlib import Path
p=Path(__file__).parent/'AllLargeWindowOverlaps.lean'
header='''import D1Bound5.AllLargeWindows
import D1Bound5.AllLargeOverlapConstants

namespace D1Bound5

/-- All actual endpoint overlaps in the all-large branch, including
both optional detours. The finite families are numerical expressions here;
the final theorem supplies their genuine full-ring exclusions. -/
theorem all_large_window_overlaps
    (A B S T C : ℝ) (hA : 3 ≤ A) (hAB : A ≤ B) (hBS : B ≤ S)
    (hT : 2*B*S < T) (hC : A^2*T^5/S^2 < C)
    (hgap : 400*(A^7*B^5*S^3) < C) :
    (allLargeWindowQ A T C).1 < A^2*C^7/(S^2*T^4) ∧
    (allLargeWindowN2 A B C).1 < (allLargeWindowQ A T C).2 ∧
    (allLargeWindowP A B S C).1 < (allLargeWindowN2 A B C).2 ∧
    (B^2 ≤ S → (allLargeWindowN3 A B C).1 < (allLargeWindowP A B S C).2) ∧
    (allLargeWindowA3 A B C).1 < (allLargeWindowP A B S C).2 ∧
    (S ≤ B^2 → (allLargeWindowM A B S C).1 < (allLargeWindowA3 A B C).2) ∧
    (allLargeWindowN3 A B C).1 < (allLargeWindowM A B S C).2 ∧
    (B^3 ≤ S → (allLargeWindowA4 A B C).1 < (allLargeWindowN3 A B C).2) ∧
    (S ≤ B^3 → (allLargeWindowN3 B S C).1 < (allLargeWindowN3 A B C).2) ∧
    (allLargeWindowA4 A B C).1 < (allLargeWindowN3 B S C).2 ∧
    ordinaryWindowLower B C 4 < (allLargeWindowA4 A B C).2 ∧
    (allLargeWindowA5 A B C).1 < ordinaryWindowUpper A B C 4 ∧
    ordinaryWindowLower B C 5 < (allLargeWindowA5 A B C).2 ∧
    ordinaryWindowLower B C 6 < ordinaryWindowUpper A B C 5 ∧
    42*B^3*C < 2*A*C^2/(5*B) := by
  have hB : 3 ≤ B := hA.trans hAB
  have hS : 3 ≤ S := hB.trans hBS
  have hA0 : 0 < A := by linarith only [hA]
  have hB0 : 0 < B := by linarith only [hB]
  have hS0 : 0 < S := by linarith only [hS]
  have hT0 : 0 < T := lt_trans (by positivity) hT
  have hbase0 : 0 < 400*(A^7*B^5*S^3) := by positivity
  have hC0 : 0 < C := hbase0.trans hgap
  have hCbase0 : 0 < A^2*T^5/S^2 := by positivity
  rcases all_large_overlap_constants A B S hA hB hS with
    ⟨hn0,hn1,hn2,hn3,hn4,hn5,hn6,hn7,hn8,hn9,hn10,hn11,hn12,hn13,hn14,hn15⟩
'''
# Each raw quotient follows from one exact certificate and elementary monotone monomial substitution.
H='(4001/3999 : ℝ)'
G='(400*(A^7*B^5*S^3))'
# q, raw, intermediate list, extra assumption if needed.
D0='12100'
items=[]
items.append(('0','(1024*(1-1/4000 : ℝ)/12100)*(A^10*B^10)', 'A^2*C^4*(1-1/4000 : ℝ)/(12100*S^2*T^10)', [
('(1-1/4000 : ℝ)*A^10*(2*B*S)^10/(12100*S^10)','='),
('(1-1/4000 : ℝ)*A^10*T^10/(12100*S^10)','≤'),
('A^2*(A^2*T^5/S^2)^4*(1-1/4000 : ℝ)/(12100*S^2*T^10)','='),
('A^2*C^4*(1-1/4000 : ℝ)/(12100*S^2*T^10)','≤')],None))
items.append(('1',f'(256/(36*243^2*{H}))*(A^8*S^4)', f'A^4*C^2/(36*243^2*B^8*T^2*{H})', [
(f'A^8*(2*B*S)^8/(36*243^2*B^8*S^4*{H})','='),
(f'A^8*T^8/(36*243^2*B^8*S^4*{H})','≤'),
(f'A^4*(A^2*T^5/S^2)^2/(36*243^2*B^8*T^2*{H})','='),
(f'A^4*C^2/(36*243^2*B^8*T^2*{H})','≤')],None))
# den constant, q exponent monomial, raw numerator coefficient monomial, raw denominator variable monomial, gap power, transformed comparison
specs=[
('2',f'16*(5/4 : ℝ)^2*2400^2*{H}','400^2','A^20*B^4','A^6','B^6*S^6',2,None,None),
('3',f'16*(5/4 : ℝ)^2*2400^2*{H}','400^2','A^20*S^2','A^6','B^10*S^4',2,None,None),
('4',f'16*(3 : ℝ)^2*4143^2*{H}','400^2','A^20','A^6','B^14*S^4',2,
 (f'400^2*A^20*(B^2)^2/((16*(3 : ℝ)^2*4143^2*{H})*B^4)',f'400^2*A^20*S^2/((16*(3 : ℝ)^2*4143^2*{H})*B^4)'), 'B^2 ≤ S'),
('5',f'16*(3 : ℝ)^2*2265^2*{H}','400^2','A^20','A^6','B^12*S^4',2,
 (f'400^2*A^20*B^2/((16*(3 : ℝ)^2*2265^2*{H})*B^2)',f'400^2*A^20*S^2/((16*(3 : ℝ)^2*2265^2*{H})*B^2)'),None),
('6',f'16*(35/16 : ℝ)^2*((8/9 : ℝ)*608^2)^2*{H}','400^4','A^36','A^8','B^12*S^16',4,
 (f'400^4*A^36*S^4/((16*(35/16 : ℝ)^2*((8/9 : ℝ)*608^2)^2*{H})*S^4)',f'400^4*A^36*(B^2)^4/((16*(35/16 : ℝ)^2*((8/9 : ℝ)*608^2)^2*{H})*S^4)'), 'S ≤ B^2'),
('7',f'16*(3920/81 : ℝ)^2*4143^2*{H}','400^4','A^34*B^2*S^2','A^6','B^18*S^10',4,None,None),
('8',f'16*(35/32 : ℝ)^2*165763^2*{H}','400^2','A^22*B^4','A^8','B^24',2,
 (f'400^2*A^22*(B^3)^6/((16*(35/32 : ℝ)^2*165763^2*{H})*B^14)',f'400^2*A^22*S^6/((16*(35/32 : ℝ)^2*165763^2*{H})*B^14)'), 'B^3 ≤ S'),
('9',f'16*(35/32 : ℝ)^2*4143^2*{H}','400^4','A^36*B^8','A^8','B^6*S^14',4,
 (f'400^4*A^36*B^8*S^2/((16*(35/32 : ℝ)^2*4143^2*{H})*S^2)',f'400^4*A^36*B^8*(B^3)^2/((16*(35/32 : ℝ)^2*4143^2*{H})*S^2)'), 'S ≤ B^3'),
('10',f'16*(35/32 : ℝ)^2*165763^2*{H}','400^2','A^14','1','B^10*S^6',2,None,None),
('11',f'144*(63/8 : ℝ)^2*42^8*{H}','400^4','A^38*B^2','A^10','B^30',4,
 (f'400^4*A^38*B^12/((144*(63/8 : ℝ)^2*42^8*{H})*B^10)',f'400^4*A^38*S^12/((144*(63/8 : ℝ)^2*42^8*{H})*B^10)'),None),
('12',f'4*3113013^2*(5/2 : ℝ)^8*{H}','400^4','A^36','A^8','B^32',4,
 (f'400^4*A^36*B^12/((4*3113013^2*(5/2 : ℝ)^8*{H})*B^12)',f'400^4*A^36*S^12/((4*3113013^2*(5/2 : ℝ)^8*{H})*B^12)'),None),
('13',f'144*(495/64 : ℝ)^2*42^10*{H}','400^6','A^54*B^10','A^12','B^38',6,
 (f'400^6*A^54*B^18/((144*(495/64 : ℝ)^2*42^10*{H})*B^8)',f'400^6*A^54*S^18/((144*(495/64 : ℝ)^2*42^10*{H})*B^8)'),None),
('14',f'36*42^12*(5/2 : ℝ)^10*{H}','400^6','A^52*B^4','A^10','B^44',6,
 (f'400^6*A^52*B^18/((36*42^12*(5/2 : ℝ)^10*{H})*B^14)',f'400^6*A^52*S^18/((36*42^12*(5/2 : ℝ)^10*{H})*B^14)'),None),
('15','105','400','A^8*B*S^3','A','B^4',1,None,None),
]
for idx,den,gcoef,qmono,numer,dmono,n,branch,hyp in specs:
 q=f'({gcoef}/({den}))*({qmono})'
 raw=f'{numer}*C^{n}/(({den})*{dmono})'
 chain=[]
 if branch: chain=[(branch[0],'='),(branch[1],'≤')]
 chain += [(f'{numer}*{G}^{n}/(({den})*{dmono})','='),(raw,'≤')]
 items.append((idx,q,raw,chain,hyp))
s=header
for idx,q,raw,chain,hyp in items:
 # Keep explicit numeric source certificates, using ring normalization when q differs by cancellation of 35/32.
 s+=f'  have hq{idx} : 1 < {q} := by\n'
 bound='(7/5 : ℝ)' if idx=='10' else '(13/10 : ℝ)'
 s+=f'    have hh : {bound} < {q} := by\n      convert hn{idx} using 1 <;> norm_num <;> ring\n    exact lt_trans (by norm_num) hh\n'
 s+=f'  have hr{idx} '+(f'(hextra : {hyp}) ' if hyp else '')+f': 1 < {raw} := by\n    calc\n      (1 : ℝ) < {q} := hq{idx}\n'
 for expr,rel in chain:
  proof='by field_simp [hA0.ne\',hB0.ne\',hS0.ne\',hT0.ne\']; <;> ring' if rel=='=' else ('by\n        gcongr <;> first | exact hC.le | exact hgap.le | exact hT.le | exact hBS' + (' | exact hextra' if hyp else '') + ' | positivity')
  # Lean's ; <;> is invalid; use a newline-delimited field_simp then ring.
  if rel=='=': proof="by\n        field_simp [hA0.ne',hB0.ne',hS0.ne',hT0.ne']\n        <;> ring"
  s+=f'      _ {rel} {expr} := {proof}\n'
# use raw quotient identities to produce actual overlaps. direct list first2 and specialized rawP lower terms.
links=[
('0','(allLargeWindowQ A T C).1','A^2*C^7/(S^2*T^4)',None),
('1','(allLargeWindowN2 A B C).1','(allLargeWindowQ A T C).2',None),
('2','4*2400^2*(B*S^3)^2*C^5/(1-1/4000 : ℝ)','(allLargeWindowN2 A B C).2',None),
('3','4*2400^2*(B^3*S^2)^2*C^5/(1-1/4000 : ℝ)','(allLargeWindowN2 A B C).2',None),
('4','(allLargeWindowN3 A B C).1','(allLargeWindowP A B S C).2','B^2 ≤ S'),
('5','(allLargeWindowA3 A B C).1','(allLargeWindowP A B S C).2',None),
('6','(allLargeWindowM A B S C).1','(allLargeWindowA3 A B C).2','S ≤ B^2'),
('7','(allLargeWindowN3 A B C).1','(allLargeWindowM A B S C).2',None),
('8','(allLargeWindowA4 A B C).1','(allLargeWindowN3 A B C).2','B^3 ≤ S'),
('9','(allLargeWindowN3 B S C).1','(allLargeWindowN3 A B C).2','S ≤ B^3'),
('10','(allLargeWindowA4 A B C).1','(allLargeWindowN3 B S C).2',None),
('11','ordinaryWindowLower B C 4','(allLargeWindowA4 A B C).2',None),
('12','(allLargeWindowA5 A B C).1','ordinaryWindowUpper A B C 4',None),
('13','ordinaryWindowLower B C 5','(allLargeWindowA5 A B C).2',None),
('14','ordinaryWindowLower B C 6','ordinaryWindowUpper A B C 5',None),
('15','42*B^3*C','2*A*C^2/(5*B)',None)]
defs='allLargeWindowQ,allLargeWindowN2,allLargeWindowP,allLargeWindowA3,allLargeWindowM,allLargeWindowN3,allLargeWindowA4,allLargeWindowA5,ordinaryWindowLower,ordinaryWindowUpper'
for idx,l,u,hyp in links:
 raw=next(t[2] for t in items if t[0]==idx)
 s+=f'  have ho{idx} '+(f'(hextra : {hyp}) ' if hyp else '')+f': {l} < {u} := by\n'
 s+=f'    apply window_overlap_of_ratio ({l}) ({u}) ({raw})\n'
 s+=f'    · dsimp [{defs}]\n      positivity\n'
 s+=f"    · dsimp [{defs}]\n      field_simp [hA0.ne',hB0.ne',hS0.ne',hT0.ne',hC0.ne']\n      <;> ring\n"
 s+=f'    · exact hr{idx}'+(' hextra' if hyp else '')+'\n'
s+='''  have hoP : (allLargeWindowP A B S C).1 < (allLargeWindowN2 A B C).2 := by
    rcases le_total (B*S^3) (B^3*S^2) with h | h
    · simpa only [allLargeWindowP,max_eq_right h] using ho3
    · simpa only [allLargeWindowP,max_eq_left h] using ho2
  exact ⟨ho0,ho1,hoP,ho4,ho5,ho6,ho7,ho8,ho9,ho10,ho11,ho12,ho13,ho14,ho15⟩

end D1Bound5
'''
p.write_text(s)
