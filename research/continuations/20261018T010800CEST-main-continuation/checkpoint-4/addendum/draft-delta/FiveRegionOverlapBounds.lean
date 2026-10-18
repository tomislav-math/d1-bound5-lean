import D1Bound5.FiveRegionParameters
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
  have h0 : 1 < (1024*(1-1/4000 : ℝ)/12100)*(A^10*B^10*S^0) := by
    have hnum : 1 < (1024*(1-1/4000 : ℝ)/12100)*((fiveRegionMinNorm r)^5*(fiveRegionMinB r)^10*(fiveRegionMinB r)^0) := by
      fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    have hc : 0 ≤ (1024*(1-1/4000 : ℝ)/12100) := by fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    exact hnum.trans_le (fiveRegion_even_monomial_le r A B S (1024*(1-1/4000 : ℝ)/12100) hc hAn hBm hBS 5 10 0)
  have h1 : 1 < (256/(36*(fiveRegionN2Height r)^2*(4001/3999 : ℝ)))*(A^8*B^0*S^4) := by
    have hnum : 1 < (256/(36*(fiveRegionN2Height r)^2*(4001/3999 : ℝ)))*((fiveRegionMinNorm r)^4*(fiveRegionMinB r)^0*(fiveRegionMinB r)^4) := by
      fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    have hc : 0 ≤ (256/(36*(fiveRegionN2Height r)^2*(4001/3999 : ℝ))) := by fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    exact hnum.trans_le (fiveRegion_even_monomial_le r A B S (256/(36*(fiveRegionN2Height r)^2*(4001/3999 : ℝ))) hc hAn hBm hBS 4 0 4)
  have h2 : 1 < ((fiveRegionGap r)^2/(16*(fiveRegionN2Residual r)^2*2400^2*(4001/3999 : ℝ)))*(A^20*B^4*S^0) := by
    have hnum : 1 < ((fiveRegionGap r)^2/(16*(fiveRegionN2Residual r)^2*2400^2*(4001/3999 : ℝ)))*((fiveRegionMinNorm r)^10*(fiveRegionMinB r)^4*(fiveRegionMinB r)^0) := by
      fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    have hc : 0 ≤ ((fiveRegionGap r)^2/(16*(fiveRegionN2Residual r)^2*2400^2*(4001/3999 : ℝ))) := by fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    exact hnum.trans_le (fiveRegion_even_monomial_le r A B S ((fiveRegionGap r)^2/(16*(fiveRegionN2Residual r)^2*2400^2*(4001/3999 : ℝ))) hc hAn hBm hBS 10 4 0)
  have h3 : 1 < ((fiveRegionGap r)^2/(16*(fiveRegionN2Residual r)^2*2400^2*(4001/3999 : ℝ)))*(A^20*B^0*S^2) := by
    have hnum : 1 < ((fiveRegionGap r)^2/(16*(fiveRegionN2Residual r)^2*2400^2*(4001/3999 : ℝ)))*((fiveRegionMinNorm r)^10*(fiveRegionMinB r)^0*(fiveRegionMinB r)^2) := by
      fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    have hc : 0 ≤ ((fiveRegionGap r)^2/(16*(fiveRegionN2Residual r)^2*2400^2*(4001/3999 : ℝ))) := by fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    exact hnum.trans_le (fiveRegion_even_monomial_le r A B S ((fiveRegionGap r)^2/(16*(fiveRegionN2Residual r)^2*2400^2*(4001/3999 : ℝ))) hc hAn hBm hBS 10 0 2)
  have h4 : 1 < ((fiveRegionGap r)^2/(16*(fiveRegionPResidual r)^2*(fiveRegionN3Height r)^2*(4001/3999 : ℝ)))*(A^20*B^0*S^0) := by
    have hnum : 1 < ((fiveRegionGap r)^2/(16*(fiveRegionPResidual r)^2*(fiveRegionN3Height r)^2*(4001/3999 : ℝ)))*((fiveRegionMinNorm r)^10*(fiveRegionMinB r)^0*(fiveRegionMinB r)^0) := by
      fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    have hc : 0 ≤ ((fiveRegionGap r)^2/(16*(fiveRegionPResidual r)^2*(fiveRegionN3Height r)^2*(4001/3999 : ℝ))) := by fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    exact hnum.trans_le (fiveRegion_even_monomial_le r A B S ((fiveRegionGap r)^2/(16*(fiveRegionPResidual r)^2*(fiveRegionN3Height r)^2*(4001/3999 : ℝ))) hc hAn hBm hBS 10 0 0)
  have h5 : 1 < ((fiveRegionGap r)^2/(16*(fiveRegionPResidual r)^2*(fiveRegionA3Height r)^2*(4001/3999 : ℝ)))*(A^20*B^0*S^0) := by
    have hnum : 1 < ((fiveRegionGap r)^2/(16*(fiveRegionPResidual r)^2*(fiveRegionA3Height r)^2*(4001/3999 : ℝ)))*((fiveRegionMinNorm r)^10*(fiveRegionMinB r)^0*(fiveRegionMinB r)^0) := by
      fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    have hc : 0 ≤ ((fiveRegionGap r)^2/(16*(fiveRegionPResidual r)^2*(fiveRegionA3Height r)^2*(4001/3999 : ℝ))) := by fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    exact hnum.trans_le (fiveRegion_even_monomial_le r A B S ((fiveRegionGap r)^2/(16*(fiveRegionPResidual r)^2*(fiveRegionA3Height r)^2*(4001/3999 : ℝ))) hc hAn hBm hBS 10 0 0)
  have h6 : 1 < ((fiveRegionGap r)^4/(16*(fiveRegionA3Residual r)^2*((8/9 : ℝ)*608^2)^2*(4001/3999 : ℝ)))*(A^36*B^0*S^0) := by
    have hnum : 1 < ((fiveRegionGap r)^4/(16*(fiveRegionA3Residual r)^2*((8/9 : ℝ)*608^2)^2*(4001/3999 : ℝ)))*((fiveRegionMinNorm r)^18*(fiveRegionMinB r)^0*(fiveRegionMinB r)^0) := by
      fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    have hc : 0 ≤ ((fiveRegionGap r)^4/(16*(fiveRegionA3Residual r)^2*((8/9 : ℝ)*608^2)^2*(4001/3999 : ℝ))) := by fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    exact hnum.trans_le (fiveRegion_even_monomial_le r A B S ((fiveRegionGap r)^4/(16*(fiveRegionA3Residual r)^2*((8/9 : ℝ)*608^2)^2*(4001/3999 : ℝ))) hc hAn hBm hBS 18 0 0)
  have h7 : 1 < ((fiveRegionGap r)^4/(16*(3920/81 : ℝ)^2*(fiveRegionN3Height r)^2*(4001/3999 : ℝ)))*(A^34*B^2*S^2) := by
    have hnum : 1 < ((fiveRegionGap r)^4/(16*(3920/81 : ℝ)^2*(fiveRegionN3Height r)^2*(4001/3999 : ℝ)))*((fiveRegionMinNorm r)^17*(fiveRegionMinB r)^2*(fiveRegionMinB r)^2) := by
      fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    have hc : 0 ≤ ((fiveRegionGap r)^4/(16*(3920/81 : ℝ)^2*(fiveRegionN3Height r)^2*(4001/3999 : ℝ))) := by fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    exact hnum.trans_le (fiveRegion_even_monomial_le r A B S ((fiveRegionGap r)^4/(16*(3920/81 : ℝ)^2*(fiveRegionN3Height r)^2*(4001/3999 : ℝ))) hc hAn hBm hBS 17 2 2)
  have h8 : 1 < ((fiveRegionGap r)^2/(16*(fiveRegionN3Residual r)^2*(fiveRegionA4Height r)^2*(4001/3999 : ℝ)))*(A^22*B^4*S^0) := by
    have hnum : 1 < ((fiveRegionGap r)^2/(16*(fiveRegionN3Residual r)^2*(fiveRegionA4Height r)^2*(4001/3999 : ℝ)))*((fiveRegionMinNorm r)^11*(fiveRegionMinB r)^4*(fiveRegionMinB r)^0) := by
      fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    have hc : 0 ≤ ((fiveRegionGap r)^2/(16*(fiveRegionN3Residual r)^2*(fiveRegionA4Height r)^2*(4001/3999 : ℝ))) := by fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    exact hnum.trans_le (fiveRegion_even_monomial_le r A B S ((fiveRegionGap r)^2/(16*(fiveRegionN3Residual r)^2*(fiveRegionA4Height r)^2*(4001/3999 : ℝ))) hc hAn hBm hBS 11 4 0)
  have h9 : 1 < ((fiveRegionGap r)^4/(16*(fiveRegionN3Residual r)^2*4143^2*(4001/3999 : ℝ)))*(A^36*B^8*S^0) := by
    have hnum : 1 < ((fiveRegionGap r)^4/(16*(fiveRegionN3Residual r)^2*4143^2*(4001/3999 : ℝ)))*((fiveRegionMinNorm r)^18*(fiveRegionMinB r)^8*(fiveRegionMinB r)^0) := by
      fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    have hc : 0 ≤ ((fiveRegionGap r)^4/(16*(fiveRegionN3Residual r)^2*4143^2*(4001/3999 : ℝ))) := by fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    exact hnum.trans_le (fiveRegion_even_monomial_le r A B S ((fiveRegionGap r)^4/(16*(fiveRegionN3Residual r)^2*4143^2*(4001/3999 : ℝ))) hc hAn hBm hBS 18 8 0)
  have h10 : 1 < ((fiveRegionCoupledGap r)^2/(16*(fiveRegionA4Height r)^2*(4001/3999 : ℝ)))*(A^14*B^0*S^0) := by
    have hnum : 1 < ((fiveRegionCoupledGap r)^2/(16*(fiveRegionA4Height r)^2*(4001/3999 : ℝ)))*((fiveRegionMinNorm r)^7*(fiveRegionMinB r)^0*(fiveRegionMinB r)^0) := by
      fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    have hc : 0 ≤ ((fiveRegionCoupledGap r)^2/(16*(fiveRegionA4Height r)^2*(4001/3999 : ℝ))) := by fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    exact hnum.trans_le (fiveRegion_even_monomial_le r A B S ((fiveRegionCoupledGap r)^2/(16*(fiveRegionA4Height r)^2*(4001/3999 : ℝ))) hc hAn hBm hBS 7 0 0)
  have h11 : 1 < ((fiveRegionGap r)^4/(144*(fiveRegionA4Residual r)^2*42^8*(4001/3999 : ℝ)))*(A^38*B^2*S^0) := by
    have hnum : 1 < ((fiveRegionGap r)^4/(144*(fiveRegionA4Residual r)^2*42^8*(4001/3999 : ℝ)))*((fiveRegionMinNorm r)^19*(fiveRegionMinB r)^2*(fiveRegionMinB r)^0) := by
      fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    have hc : 0 ≤ ((fiveRegionGap r)^4/(144*(fiveRegionA4Residual r)^2*42^8*(4001/3999 : ℝ))) := by fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    exact hnum.trans_le (fiveRegion_even_monomial_le r A B S ((fiveRegionGap r)^4/(144*(fiveRegionA4Residual r)^2*42^8*(4001/3999 : ℝ))) hc hAn hBm hBS 19 2 0)
  have h12 : 1 < ((fiveRegionGap r)^4/(4*(fiveRegionA5Height r)^2*(5/2 : ℝ)^8*(4001/3999 : ℝ)))*(A^36*B^0*S^0) := by
    have hnum : 1 < ((fiveRegionGap r)^4/(4*(fiveRegionA5Height r)^2*(5/2 : ℝ)^8*(4001/3999 : ℝ)))*((fiveRegionMinNorm r)^18*(fiveRegionMinB r)^0*(fiveRegionMinB r)^0) := by
      fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    have hc : 0 ≤ ((fiveRegionGap r)^4/(4*(fiveRegionA5Height r)^2*(5/2 : ℝ)^8*(4001/3999 : ℝ))) := by fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    exact hnum.trans_le (fiveRegion_even_monomial_le r A B S ((fiveRegionGap r)^4/(4*(fiveRegionA5Height r)^2*(5/2 : ℝ)^8*(4001/3999 : ℝ))) hc hAn hBm hBS 18 0 0)
  have h13 : 1 < ((fiveRegionGap r)^6/(144*(fiveRegionA5Residual r)^2*42^10*(4001/3999 : ℝ)))*(A^54*B^10*S^0) := by
    have hnum : 1 < ((fiveRegionGap r)^6/(144*(fiveRegionA5Residual r)^2*42^10*(4001/3999 : ℝ)))*((fiveRegionMinNorm r)^27*(fiveRegionMinB r)^10*(fiveRegionMinB r)^0) := by
      fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    have hc : 0 ≤ ((fiveRegionGap r)^6/(144*(fiveRegionA5Residual r)^2*42^10*(4001/3999 : ℝ))) := by fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    exact hnum.trans_le (fiveRegion_even_monomial_le r A B S ((fiveRegionGap r)^6/(144*(fiveRegionA5Residual r)^2*42^10*(4001/3999 : ℝ))) hc hAn hBm hBS 27 10 0)
  have h14 : 1 < ((fiveRegionGap r)^6/(36*42^12*(5/2 : ℝ)^10*(4001/3999 : ℝ)))*(A^52*B^4*S^0) := by
    have hnum : 1 < ((fiveRegionGap r)^6/(36*42^12*(5/2 : ℝ)^10*(4001/3999 : ℝ)))*((fiveRegionMinNorm r)^26*(fiveRegionMinB r)^4*(fiveRegionMinB r)^0) := by
      fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    have hc : 0 ≤ ((fiveRegionGap r)^6/(36*42^12*(5/2 : ℝ)^10*(4001/3999 : ℝ))) := by fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    exact hnum.trans_le (fiveRegion_even_monomial_le r A B S ((fiveRegionGap r)^6/(36*42^12*(5/2 : ℝ)^10*(4001/3999 : ℝ))) hc hAn hBm hBS 26 4 0)
  have h15 : 1 < ((fiveRegionGap r)/105)*(A^8*B^1*S^3) := by
    have hnum : 1 < ((fiveRegionGap r)/105)*((fiveRegionMinNorm r)^4*(fiveRegionMinB r)^1*(fiveRegionMinB r)^3) := by
      fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    have hc : 0 ≤ ((fiveRegionGap r)/105) := by fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionGap,fiveRegionCoupledGap,fiveRegionN2Height,fiveRegionN3Height,fiveRegionA3Height,fiveRegionA4Height,fiveRegionA5Height,fiveRegionN2Residual,fiveRegionN3Residual,fiveRegionA3Residual,fiveRegionA4Residual,fiveRegionA5Residual,fiveRegionPResidual,fiveRegionAnchorRatio]
    exact hnum.trans_le (fiveRegion_even_monomial_le r A B S ((fiveRegionGap r)/105) hc hAn hBm hBS 4 1 3)
  unfold CommonOverlapBounds
  norm_num only [one_pow,one_mul,mul_one,pow_zero,pow_one] at *
  exact ⟨h0,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13,h14,h15⟩

end D1Bound5
