import D1Bound5.FiveRegionResidualRates
import D1Bound5.CommonIntervalWindows
import D1Bound5.FiniteA5MaxInterval

open scoped NumberField
open Module

namespace D1Bound5

/-- Actual A5 window in each of the five first-pair regions. Its height
and residual inputs are proved here from the displayed matrix and the
actual anchor ratio. -/
theorem full_ring_finiteA5_five_region_interval_excluded
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
    (r : Fin 5) (hratio : ‖phi (x : K)‖ ≤ fiveRegionAnchorRatio r*‖phi (y : K)‖)
    (hleft : (commonWindowA5 ‖phi (x : K)‖ ‖phi (y : K)‖ ‖phi (c : K)‖
      (fiveRegionA5Height r) (fiveRegionA5Residual r)).1 ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤
      (commonWindowA5 ‖phi (x : K)‖ ‖phi (y : K)‖ ‖phi (c : K)‖
        (fiveRegionA5Height r) (fiveRegionA5Residual r)).2) : False := by
  have hY1 := one_le_norm_integer hK phi (hS.1 y hyS)
  have hY : 0 < ‖phi (y : K)‖ := by linarith only [hY1]
  have hYC : 1000 ≤ ‖phi (y : K)‖*‖phi (c : K)‖ := by
    nlinarith only [hY1,hC1000,norm_nonneg (phi (c : K))]
  have hheight (i : Fin 3) := finiteA5_height_five_regions r
    (phi (x : K)) (phi (y : K)) (phi (c : K)) (norm_pos_iff.mp hY) hratio hYC i
  have hR := (fiveRegion_distance_rates r (phi (x : K)) (phi (y : K)) hratio).2.2.2.2
  have hMpos : 0 < fiveRegionA5Height r := by fin_cases r <;> norm_num [fiveRegionA5Height]
  have hRpos : 0 < fiveRegionA5Residual r := by
    unfold fiveRegionA5Residual
    have hh := fiveRegionAnchorRatio_nonneg r
    positivity
  exact full_ring_finiteA5_max_interval_of_bounds hK phi hS x y c d
    hxS hyS hcS hdS hxy hxc hyc hxd hyd hcd hXY hC1000 hCY hCD
    (fiveRegionA5Height r) (fiveRegionA5Residual r) hMpos hRpos hheight hR hleft hright

end D1Bound5
