import D1Bound5.FiniteN3FixedInterval
import D1Bound5.OneSmallN3AbFixedArithmetic
import D1Bound5.OneSmallFixedPairGeometry

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- The fixed-table N3Ab interval from actual evaluated root coefficients. -/
theorem full_ring_finiteN3Ab_fixed_interval_excluded
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
    (hleft : 4*(r.Mn : ℝ)^2*‖phi (y : K)‖^14*‖phi (c : K)‖^7/
      (1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤ ‖phi (c : K)‖^11/
      (4*(r.Rn : ℝ)^2*‖phi (y : K)‖^6*(1+1/4000 : ℝ))) : False := by
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
  have hReq : (r.Rn : ℝ) = (3535/409600 : ℝ)*delta^6/B^6 := by
    simp only [OneSmallCutoffRow.Rn]
    push_cast
    rw [←hdsq,←hBsq]
    field_simp [hB.ne']
    <;> ring
  have hRpos : 0 < (r.Rn : ℝ) := by rw [hReq]; positivity
  have hR : (3535/409600 : ℝ)*delta^6 ≤ (r.Rn : ℝ)*B^6 := by
    rw [hReq]
    field_simp [hB.ne']
    <;> norm_num
  obtain ⟨_,_,_,_,_,_,_,_,_,_,_,_,_,hM2,hMn,hM3,hM4,hM5,_⟩ :=
    oneSmallCutoffRows_valid r hr
  have hM : 0 < (r.Mn : ℝ) := by exact_mod_cast hMn
  obtain ⟨w,hw⟩ := oneSmallCutoffRows_finiteN3AbFixedBound r hr
  have hheight (i : Fin 3) := finiteN3_fixed_height phi r.triple.anchorA r.triple.anchorB
    r.Mn w hw e sgn conj x y c hx hy (norm_pos_iff.mp hB) hC1000 hCY i
  have hmax : max (delta^6) (A*delta^5) = delta^6 := by
    apply max_eq_left
    have hh := mul_le_mul_of_nonneg_right hdelta.le (pow_nonneg hd.le 5)
    nlinarith only [hh]
  have hdist : (3535/409600 : ℝ)*max (delta^6) (A*delta^5) ≤ (r.Rn : ℝ)*B^6 := by
    rw [hmax]
    exact hR
  exact full_ring_finiteN3_fixed_interval_of_bounds hK phi hS x y c d
    hxS hyS hcS hdS hxy hxc hyc hxd hyd hcd hXY hC1000 hCY hCD
    (r.Mn : ℝ) (r.Rn : ℝ) hM hRpos hheight hdist hleft hright

end D1Bound5
