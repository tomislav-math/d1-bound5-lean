import D1Bound5.FiniteA5FixedInterval
import D1Bound5.OneSmallA5FixedArithmetic
import D1Bound5.OneSmallFixedPairGeometry

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- The fixed-table A5 interval from actual evaluated root coefficients. -/
theorem full_ring_finiteA5_fixed_interval_excluded
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {S : Finset (𝓞 K)} (hS : IsD1 S) (x y c d : 𝓞 K)
    (hxS : x ∈ S) (hyS : y ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hxy : x ≠ y) (hxc : x ≠ c) (hyc : y ≠ c)
    (hxd : x ≠ d) (hyd : y ≠ d) (hcd : c ≠ d)
    (hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖)
    (hC1000 : 1000 ≤ ‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖)
    (r : OneSmallCutoffRow) (hr : r ∈ oneSmallCutoffRows)
    (e : QuadInt r.triple.tau r.triple.nu ≃+* 𝓞 K)
    (sgn conj : Bool)
    (hx : smallExtensionSymmetry sgn conj (e.symm x) = r.triple.anchorA)
    (hy : smallExtensionSymmetry sgn conj (e.symm y) = r.triple.anchorB)
    (hleft : 4*(r.M5 : ℝ)^2*‖phi (y : K)‖^24*‖phi (c : K)‖^11/
      (1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤ ‖phi (c : K)‖^17/
      (4*(r.R5 : ℝ)^2*‖phi (y : K)‖^10*(1+1/4000 : ℝ))) : False := by
  let X := phi (x : K)
  let Y := phi (y : K)
  let A := ‖X‖
  let B := ‖Y‖
  let delta := ‖X-Y‖
  obtain ⟨hAsq,hBsq,hdsq,hdelta⟩ := oneSmall_fixed_pair_geometry phi r hr e sgn conj x y hx hy
  change A^2 = (r.a0 : ℝ) at hAsq
  change B^2 = (r.b0 : ℝ) at hBsq
  change delta^2 = (r.dab : ℝ) at hdsq
  change A < delta at hdelta
  have hA1 : 1 ≤ A := one_le_norm_integer hK phi (hS.1 x hxS)
  have hA : 0 < A := by linarith only [hA1]
  have hB : 0 < B := hA.trans_le hXY
  have hd : 0 < delta := hA.trans hdelta
  have hReq : (r.R5 : ℝ) = (9999/2621440 : ℝ)*delta^10/B^10 := by
    simp only [OneSmallCutoffRow.R5]
    push_cast
    rw [←hdsq,←hBsq]
    field_simp [hB.ne']
    <;> ring
  have hRpos : 0 < (r.R5 : ℝ) := by rw [hReq]; positivity
  have hR : (9999/2621440 : ℝ)*delta^10 ≤ (r.R5 : ℝ)*B^10 := by
    rw [hReq]
    field_simp [hB.ne']
    <;> norm_num
  obtain ⟨_,_,_,_,_,_,_,_,_,_,_,_,_,hM2,hMn,hM3,hM4,hM5,_⟩ :=
    oneSmallCutoffRows_valid r hr
  have hM : 0 < (r.M5 : ℝ) := by exact_mod_cast hM5
  obtain ⟨w,hw⟩ := oneSmallCutoffRows_finiteA5FixedBound r hr
  have hheight (i : Fin 3) := finiteA5_fixed_height phi r.triple.anchorA r.triple.anchorB
    r.M5 w hw e sgn conj x y c hx hy (norm_pos_iff.mp hB) hC1000 hCY i
  exact full_ring_finiteA5_fixed_interval_of_bounds hK phi hS x y c d
    hxS hyS hcS hdS hxy hxc hyc hxd hyd hcd hXY hC1000 hCY hCD
    (r.M5 : ℝ) (r.R5 : ℝ) hM hRpos hheight hdelta.le hR hleft hright

end D1Bound5
