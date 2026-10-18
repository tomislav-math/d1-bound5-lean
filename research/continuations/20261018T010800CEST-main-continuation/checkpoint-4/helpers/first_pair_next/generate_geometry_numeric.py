from pathlib import Path
p=Path('/workspace/scratch/40edb97fa4c0/first_pair_next')
qs=[
'9604*(1-1/4000)*r.b0^5/12100',
'784*225^2/(36*r.M2^2*(4001/3999))',
'r.G^2*r.b0^2/(16*r.R2^2*2400^2*(4001/3999))',
'r.G^2*225/(16*r.R2^2*2400^2*(4001/3999))',
'r.G^2/(16*r.Rp^2*r.Mn^2*(4001/3999))',
'r.G^2/(16*r.Rp^2*r.M3^2*(4001/3999))',
'r.G^4/(16*r.R3^2*((8/9)*608^2)^2*(4001/3999))',
'r.G^4*r.b0*225/(16*(3920/81)^2*r.Mn^2*(4001/3999))',
'r.G^2*r.b0^2/(16*r.Rn^2*r.M4^2*(4001/3999))',
'r.G^4*r.b0^4/(16*r.Rn^2*4143^2*(4001/3999))',
'r.rho^2/(16*r.M4^2*(4001/3999))',
'r.G^4*r.b0/(144*r.R4^2*42^8*(4001/3999))',
'r.G^4/(4*r.M5^2*(5/2)^8*(4001/3999))',
'r.G^6*r.b0^5/(144*r.R5^2*42^10*(4001/3999))',
'r.G^6*r.b0^2/(36*42^12*(5/2)^10*(4001/3999))']
import re
text=(p/'CommonIntervalWindows.lean').read_text()
raw=text.split(' : Prop :=\n')[1].split('\n\nend')[0]
realqs=[x.strip()[4:] for x in raw.split(' ∧\n')]
repl={'A':'1','G':'(r.G : ℝ)','rho':'(r.rho : ℝ)','K0':'(7/4 : ℝ)','M2':'(r.M2 : ℝ)','Mn':'(r.Mn : ℝ)','M3':'(r.M3 : ℝ)','M4':'(r.M4 : ℝ)','M5':'(r.M5 : ℝ)','Mbs':'4143','R2':'(r.R2 : ℝ)','Rn':'(r.Rn : ℝ)','R3':'(r.R3 : ℝ)','R4':'(r.R4 : ℝ)','R5':'(r.R5 : ℝ)','Rp':'(r.Rp : ℝ)'}
realqs=[re.sub(r'\b[A-Za-z][A-Za-z0-9]*\b',lambda m:repl.get(m[0],m[0]),q) for q in realqs]
s='''import D1Bound5.FirstPairGeometryData
import D1Bound5.CommonIntervalWindows

namespace D1Bound5

/-- The exact rational certificates give all shared real overlap
comparisons for every S≥15. Actual family estimates are separate. -/
theorem firstPairGeometry_common_overlap_bounds (r : FirstPairGeometryRow)
    (hr : r.Valid) (B S : ℝ) (hB : 0 < B)
    (hBn : B^2 = (r.b0 : ℝ)) (hS : 15 ≤ S) :
    CommonOverlapBounds 1 B S r.G r.rho (7/4)
      r.M2 r.Mn r.M3 r.M4 r.M5 4143 r.R2 r.Rn r.R3 r.R4 r.R5 r.Rp := by
  rcases hr with
    ⟨ha,hb,hd,hA1,hA1sq,hB0,hB0sq,hB1,hB1sq,hd1,hd1sq,hq,hQ,hm,hK,
      hG,hH,hF,hrho,hR2,hRn,hR3,hR4,hR5,hRp,hM2,hMn,hM3,hM4,hM5,hqs,htail⟩
  have hS0 : 0 < S := by linarith
'''
for v in ['G','rho','R2','Rn','R3','R4','R5','Rp','M2','Mn','M3','M4','M5','B0']:
    s+=f'  have hp{v} : (0 : ℝ) < (r.{v} : ℝ) := by exact_mod_cast h{v}\n'
for i,q in enumerate(qs):
    rq=realqs[i].replace('S^','(15 : ℝ)^')
    s+=f'''  have hr{i} : (1 : ℚ) < {q} := by
    exact lt_trans (by norm_num) (hqs _ (by simp [FirstPairGeometryRow.overlaps]))
  have hq{i} : (1 : ℝ) < {rq} := by
    convert (show (1 : ℝ) < (({q} : ℚ) : ℝ) by exact_mod_cast hr{i}) using 1 <;>
      push_cast <;> rw [← hBn] <;> ring
'''
s+='''  have hB0B : (r.B0 : ℝ) ≤ B := by
    have hs : (r.B0 : ℝ)^2 ≤ B^2 := by
      rw [hBn]
      exact_mod_cast hB0sq
    nlinarith
  have hqt : (1 : ℝ) < (r.G : ℝ)*(r.B0 : ℝ)*15^3/105 := by
    exact_mod_cast htail
  unfold CommonOverlapBounds
  refine ⟨hq0,?_,hq2,?_,hq4,hq5,hq6,?_,hq8,hq9,hq10,hq11,hq12,hq13,hq14,?_⟩
'''
for i in [1,3,7]:
    s+=f'  · refine lt_of_lt_of_le hq{i} ?_\n    gcongr <;> first | exact hS | positivity\n'
s+='''  · have hmono : (r.G : ℝ)*(r.B0 : ℝ)*15^3/105 ≤
        (r.G : ℝ)*B*S^3/105 := by
      gcongr
    convert lt_of_lt_of_le hqt hmono using 1 <;> ring

end D1Bound5
'''
# rw need not fail when q omits b0.
s=s.replace('push_cast <;> rw [← hBn] <;> ring','push_cast <;> try rw [← hBn]\n    all_goals ring')
(p/'FirstPairGeometryNumeric.lean').write_text(s)
