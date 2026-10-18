import D1Bound5.FirstPairGeometry
import D1Bound5.CommonIntervalWindows
import D1Bound5.FiniteN3ExactInterval
import D1Bound5.FiniteN3Height

open scoped NumberField
open Module

namespace D1Bound5

/-- The relabeled N3 window uses its actual separation-dependent
residual and the uniform coefficient4143; no fixed third-row premise. -/
theorem full_ring_finiteN3_phi_interval_excluded
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
    (hleft : (commonWindowN3 ‖phi (x : K)‖ ‖phi (y : K)‖ ‖phi (c : K)‖
      4143 ((3535/409600 : ℝ)*firstPairPhi (phi (x : K)) (phi (y : K)))).1 ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤
      (commonWindowN3 ‖phi (x : K)‖ ‖phi (y : K)‖ ‖phi (c : K)‖
        4143 ((3535/409600 : ℝ)*firstPairPhi (phi (x : K)) (phi (y : K)))).2) : False := by
  let X := phi (x : K)
  let Y := phi (y : K)
  let C := ‖phi (c : K)‖
  have hY1 : 1 ≤ ‖Y‖ := one_le_norm_integer hK phi (hS.1 y hyS)
  have hY : 0 < ‖Y‖ := by linarith only [hY1]
  have hy0 : Y ≠ 0 := norm_pos_iff.mp hY
  have hsep : X-Y ≠ 0 := sub_ne_zero.mpr (fun hh => hxy
    (Subtype.ext (phi.injective hh)))
  have hd : 0 < ‖X-Y‖ := norm_pos_iff.mpr hsep
  have hPhi : 0 < firstPairPhi X Y := by
    apply lt_of_lt_of_le (pow_pos (div_pos hd hY) 6)
    exact le_max_left _ _
  change 1000 ≤ C at hC1000
  have hYC : 1000 ≤ ‖Y‖*C := by
    have hC : 0 ≤ C := norm_nonneg _
    nlinarith only [hY1,hC1000,hC]
  have hheight (i : Fin 3) := finiteN3_height_scaled X Y (phi (c : K)) hy0 hXY hYC i
  have hR : (3535/409600 : ℝ)*max (‖X-Y‖^6) (‖X‖*‖X-Y‖^5) ≤
      ((3535/409600 : ℝ)*firstPairPhi X Y)*‖Y‖^6 := by
    rw [mul_assoc,firstPairPhi_scaled X Y hy0]
  exact full_ring_finiteN3_exact_interval_of_bounds hK phi hS x y c d
    hxS hyS hcS hdS hxy hxc hyc hxd hyd hcd hXY hC1000 hCY hCD
    4143 ((3535/409600 : ℝ)*firstPairPhi X Y) (by norm_num)
    (by positivity) hheight hR hleft hright

end D1Bound5
