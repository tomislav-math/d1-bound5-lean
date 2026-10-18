from pathlib import Path
D=Path(__file__).parent
# coefficient, half exponent of A, exponent B, exponent S
rows=[
('(1024*(1-1/4000 : ℝ)/12100)',5,10,0),
('(256/(36*(fiveRegionN2Height r)^2*(4001/3999 : ℝ)))',4,0,4),
('((fiveRegionGap r)^2/(16*(fiveRegionN2Residual r)^2*2400^2*(4001/3999 : ℝ)))',10,4,0),
('((fiveRegionGap r)^2/(16*(fiveRegionN2Residual r)^2*2400^2*(4001/3999 : ℝ)))',10,0,2),
('((fiveRegionGap r)^2/(16*(fiveRegionPResidual r)^2*(fiveRegionN3Height r)^2*(4001/3999 : ℝ)))',10,0,0),
('((fiveRegionGap r)^2/(16*(fiveRegionPResidual r)^2*(fiveRegionA3Height r)^2*(4001/3999 : ℝ)))',10,0,0),
('((fiveRegionGap r)^4/(16*(fiveRegionA3Residual r)^2*((8/9 : ℝ)*608^2)^2*(4001/3999 : ℝ)))',18,0,0),
('((fiveRegionGap r)^4/(16*(3920/81 : ℝ)^2*(fiveRegionN3Height r)^2*(4001/3999 : ℝ)))',17,2,2),
('((fiveRegionGap r)^2/(16*(fiveRegionN3Residual r)^2*(fiveRegionA4Height r)^2*(4001/3999 : ℝ)))',11,4,0),
('((fiveRegionGap r)^4/(16*(fiveRegionN3Residual r)^2*4143^2*(4001/3999 : ℝ)))',18,8,0),
('((fiveRegionCoupledGap r)^2/(16*(fiveRegionA4Height r)^2*(4001/3999 : ℝ)))',7,0,0),
('((fiveRegionGap r)^4/(144*(fiveRegionA4Residual r)^2*42^8*(4001/3999 : ℝ)))',19,2,0),
('((fiveRegionGap r)^4/(4*(fiveRegionA5Height r)^2*(5/2 : ℝ)^8*(4001/3999 : ℝ)))',18,0,0),
('((fiveRegionGap r)^6/(144*(fiveRegionA5Residual r)^2*42^10*(4001/3999 : ℝ)))',27,10,0),
('((fiveRegionGap r)^6/(36*42^12*(5/2 : ℝ)^10*(4001/3999 : ℝ)))',26,4,0),
('((fiveRegionGap r)/105)',4,1,3)]
defs='fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio'
s='''import D1Bound5.FiveRegionParameters
import D1Bound5.CommonIntervalWindows

namespace D1Bound5

private theorem fiveRegion_even_monomial_le (r : Fin 5) (A B S c : ℝ)
    (hc : 0 ≤ c) (hAn : fiveRegionMinNorm r ≤ A^2)
    (hBm : fiveRegionMinB r ≤ B) (hBS : B ≤ S) (p j l : ℕ) :
    c*((fiveRegionMinNorm r)^p*(fiveRegionMinB r)^j*(fiveRegionMinB r)^l) ≤
      c*(A^(2*p)*B^j*S^l) := by
  have hn : 0 ≤ fiveRegionMinNorm r := le_trans (by norm_num) (fiveRegion_parameters r).2.1
  have hm : 0 ≤ fiveRegionMinB r := le_trans (by norm_num) (fiveRegion_parameters r).1
  have hSm := hBm.trans hBS
  rw [pow_mul]
  gcongr

set_option maxHeartbeats 8000000 in
/-- The sixteen exact overlap comparisons are checked at the rational
lower corner A²=n, B=S=m, then transported monotonically. No numerical
certificate is assumed at the endpoint. -/
theorem fiveRegion_common_overlap_bounds (r : Fin 5) (A B S : ℝ)
    (hAn : fiveRegionMinNorm r ≤ A^2)
    (hBm : fiveRegionMinB r ≤ B) (hBS : B ≤ S) :
    CommonOverlapBounds A B S (fiveRegionGap r) (fiveRegionCoupledGap r) 1
      (fiveRegionN2Height r) (fiveRegionN3Height r) (fiveRegionA3Height r)
      (fiveRegionA4Height r) (fiveRegionA5Height r) 4143
      (fiveRegionN2Residual r) (fiveRegionN3Residual r) (fiveRegionA3Residual r)
      (fiveRegionA4Residual r) (fiveRegionA5Residual r) (fiveRegionPResidual r) := by
'''
for idx,(c,p,j,l) in enumerate(rows):
    s+=f'''  have h{idx} : 1 < {c}*(A^{2*p}*B^{j}*S^{l}) := by
    have hnum : 1 < {c}*((fiveRegionMinNorm r)^{p}*(fiveRegionMinB r)^{j}*(fiveRegionMinB r)^{l}) := by
      fin_cases r <;> norm_num [{defs}]
    have hc : 0 ≤ {c} := by fin_cases r <;> norm_num [{defs}]
    exact hnum.trans_le (fiveRegion_even_monomial_le r A B S {c} hc hAn hBm hBS {p} {j} {l})
'''
s+='''  unfold CommonOverlapBounds
  norm_num only [one_pow,one_mul,mul_one,pow_zero,pow_one] at *
  exact ⟨'''+','.join(f'h{i}' for i in range(16))+'''⟩

end D1Bound5
'''
(D/'FiveRegionOverlapBounds.lean').write_text(s)
