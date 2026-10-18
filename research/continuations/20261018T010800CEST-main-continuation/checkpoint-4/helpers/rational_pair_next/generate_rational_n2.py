from pathlib import Path
src=Path('one_small_analytic_next/OneSmallN2FixedInterval.lean').read_text()
body=src[src.index('  obtain ⟨z,hz,_,hform⟩'):src.index('\nend D1Bound5')]
body=body.replace('r.M2','oneSmallCutoffRow_56.M2').replace('r.R2','oneSmallCutoffRow_56.R2')
head='''import D1Bound5.RationalCutoffHeights
import D1Bound5.FiniteN2HeightRefinement
import D1Bound5.FiniteClosedWindow

open scoped NumberField
open Module

namespace D1Bound5

/-- The N2 closed window for the signed rational pair in any imaginary
quadratic full ring; no Gaussian coordinate model is postulated. -/
theorem full_ring_finiteN2_rational_interval_excluded
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {S : Finset (𝓞 K)} (hS : IsD1 S) (x y c d : 𝓞 K)
    (hxS : x ∈ S) (hyS : y ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hxy : x ≠ y) (hxc : x ≠ c) (hyc : y ≠ c)
    (hxd : x ≠ d) (hyd : y ≠ d) (hcd : c ≠ d)
    (hC1000 : 1000 ≤ ‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖)
    (sgn : Bool) (hx : x = if sgn then -1 else 1)
    (hy : y = if sgn then -3 else 3)
    (hleft : 4*(oneSmallCutoffRow_56.M2 : ℝ)^2*‖phi (y : K)‖^8*‖phi (c : K)‖^5/
      (1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤ ‖phi (c : K)‖^7/
      (4*(oneSmallCutoffRow_56.R2 : ℝ)^2*‖phi (y : K)‖^4*(1+1/4000 : ℝ))) : False := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let A := ‖f x‖
  let B := ‖f y‖
  let C := ‖f c‖
  let D := ‖f d‖
  let delta := ‖f x-f y‖
  obtain ⟨hAn,hBn,hdn⟩ := rationalCutoff_pair_geometry phi sgn x y hx hy
  change A=1 at hAn
  change B=3 at hBn
  change delta=2 at hdn
  have hA1 : 1 ≤ A := by rw [hAn]
  have hA : 0 < A := by rw [hAn]; norm_num
  have hB : 0 < B := by rw [hBn]; norm_num
  have hC : 0 < C := by change 1000 ≤ C at hC1000; linarith only [hC1000]
  have hXY : A ≤ B := by rw [hAn,hBn]; norm_num
  change 200*B ≤ C at hCY
  change C ≤ D at hCD
  have hXC : 1000 ≤ A*C := by rw [hAn,one_mul]; exact hC1000
  have hmax : max (delta^4) (A*delta^3) = delta^4 := by rw [hdn,hAn]; norm_num
  have hR2 : (oneSmallCutoffRow_56.R2 : ℝ) = (101/2560 : ℝ)*delta^4/B^4 := by
    rw [hdn,hBn]
    exact_mod_cast (show oneSmallCutoffRow_56.R2 = (101/2560 : ℚ)*2^4/3^4 by decide +kernel)
  have hRpos : 0 < (oneSmallCutoffRow_56.R2 : ℝ) := by
    exact_mod_cast (show (0 : ℚ) < oneSmallCutoffRow_56.R2 by decide +kernel)
  have hMpos : 0 < (oneSmallCutoffRow_56.M2 : ℝ) := by
    exact_mod_cast (show (0 : ℚ) < oneSmallCutoffRow_56.M2 by decide +kernel)
  have hheight := finiteN2_rational_height phi sgn x y c hx hy hC1000 hCY
'''
Path('rational_pair_next/RationalN2Interval.lean').write_text(head+body+'\nend D1Bound5\n')
