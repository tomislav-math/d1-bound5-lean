import D1Bound5.RationalCutoffHeights
import D1Bound5.FiniteA3FixedInterval
import D1Bound5.FiniteA4FixedInterval
import D1Bound5.FiniteA5FixedInterval
import D1Bound5.FiniteN3FixedInterval
import D1Bound5.FiniteN3ExactInterval

open scoped NumberField
open Module

namespace D1Bound5

/-- The actual A3 window for signed rational anchors. It requires no
coordinate-ring equivalence for the ambient quadratic field. -/
theorem full_ring_finiteA3_rational_interval_excluded
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
    (hleft : 4*(oneSmallCutoffRow_56.M3 : ℝ)^2*‖phi (y : K)‖^12*‖phi (c : K)‖^7/
      (1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤ ‖phi (c : K)‖^9/
      (4*(oneSmallCutoffRow_56.R3 : ℝ)^2*‖phi (y : K)‖^6*(1+1/4000 : ℝ))) : False := by
  obtain ⟨hX,hY,hdist⟩ := rationalCutoff_pair_geometry phi sgn x y hx hy
  have hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖ := by rw [hX,hY]; norm_num
  have hM : 0 < (oneSmallCutoffRow_56.M3 : ℝ) := by
    exact_mod_cast (show (0 : ℚ) < oneSmallCutoffRow_56.M3 by decide +kernel)
  have hRpos : 0 < (oneSmallCutoffRow_56.R3 : ℝ) := by
    exact_mod_cast (show (0 : ℚ) < oneSmallCutoffRow_56.R3 by decide +kernel)
  have hheight := finiteA3_rational_height phi sgn x y c hx hy hC1000 hCY
  have hdelta : ‖phi (x : K)‖ ≤ ‖phi (x : K)-phi (y : K)‖ := by
    rw [hX,hdist]
    norm_num
  have hR : (707/40960 : ℝ)*‖phi (x : K)-phi (y : K)‖^6 ≤
      (oneSmallCutoffRow_56.R3 : ℝ)*‖phi (y : K)‖^6 := by
    rw [hdist,hY]
    exact_mod_cast (show (707/40960 : ℚ)*2^6 ≤ oneSmallCutoffRow_56.R3*3^6 by decide +kernel)
  exact full_ring_finiteA3_fixed_interval_of_bounds hK phi hS x y c d
    hxS hyS hcS hdS hxy hxc hyc hxd hyd hcd hXY hC1000 hCY hCD
    (oneSmallCutoffRow_56.M3 : ℝ) (oneSmallCutoffRow_56.R3 : ℝ)
    hM hRpos hheight hdelta hR hleft hright

/-- The actual A4 window for signed rational anchors. It requires no
coordinate-ring equivalence for the ambient quadratic field. -/
theorem full_ring_finiteA4_rational_interval_excluded
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
    (hleft : 4*(oneSmallCutoffRow_56.M4 : ℝ)^2*‖phi (y : K)‖^18*‖phi (c : K)‖^9/
      (1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤ ‖phi (c : K)‖^13/
      (4*(oneSmallCutoffRow_56.R4 : ℝ)^2*‖phi (y : K)‖^8*(1+1/4000 : ℝ))) : False := by
  obtain ⟨hX,hY,hdist⟩ := rationalCutoff_pair_geometry phi sgn x y hx hy
  have hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖ := by rw [hX,hY]; norm_num
  have hM : 0 < (oneSmallCutoffRow_56.M4 : ℝ) := by
    exact_mod_cast (show (0 : ℚ) < oneSmallCutoffRow_56.M4 by decide +kernel)
  have hRpos : 0 < (oneSmallCutoffRow_56.R4 : ℝ) := by
    exact_mod_cast (show (0 : ℚ) < oneSmallCutoffRow_56.R4 by decide +kernel)
  have hheight := finiteA4_rational_height phi sgn x y c hx hy hC1000 hCY
  have hdelta : ‖phi (x : K)‖ ≤ ‖phi (x : K)-phi (y : K)‖ := by
    rw [hX,hdist]
    norm_num
  have hR : (6363/409600 : ℝ)*‖phi (x : K)-phi (y : K)‖^8 ≤
      (oneSmallCutoffRow_56.R4 : ℝ)*‖phi (y : K)‖^8 := by
    rw [hdist,hY]
    exact_mod_cast (show (6363/409600 : ℚ)*2^8 ≤ oneSmallCutoffRow_56.R4*3^8 by decide +kernel)
  exact full_ring_finiteA4_fixed_interval_of_bounds hK phi hS x y c d
    hxS hyS hcS hdS hxy hxc hyc hxd hyd hcd hXY hC1000 hCY hCD
    (oneSmallCutoffRow_56.M4 : ℝ) (oneSmallCutoffRow_56.R4 : ℝ)
    hM hRpos hheight hdelta hR hleft hright

/-- The actual A5 window for signed rational anchors. It requires no
coordinate-ring equivalence for the ambient quadratic field. -/
theorem full_ring_finiteA5_rational_interval_excluded
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
    (hleft : 4*(oneSmallCutoffRow_56.M5 : ℝ)^2*‖phi (y : K)‖^24*‖phi (c : K)‖^11/
      (1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤ ‖phi (c : K)‖^17/
      (4*(oneSmallCutoffRow_56.R5 : ℝ)^2*‖phi (y : K)‖^10*(1+1/4000 : ℝ))) : False := by
  obtain ⟨hX,hY,hdist⟩ := rationalCutoff_pair_geometry phi sgn x y hx hy
  have hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖ := by rw [hX,hY]; norm_num
  have hM : 0 < (oneSmallCutoffRow_56.M5 : ℝ) := by
    exact_mod_cast (show (0 : ℚ) < oneSmallCutoffRow_56.M5 by decide +kernel)
  have hRpos : 0 < (oneSmallCutoffRow_56.R5 : ℝ) := by
    exact_mod_cast (show (0 : ℚ) < oneSmallCutoffRow_56.R5 by decide +kernel)
  have hheight := finiteA5_rational_height phi sgn x y c hx hy hC1000 hCY
  have hdelta : ‖phi (x : K)‖ ≤ ‖phi (x : K)-phi (y : K)‖ := by
    rw [hX,hdist]
    norm_num
  have hR : (9999/2621440 : ℝ)*‖phi (x : K)-phi (y : K)‖^10 ≤
      (oneSmallCutoffRow_56.R5 : ℝ)*‖phi (y : K)‖^10 := by
    rw [hdist,hY]
    exact_mod_cast (show (9999/2621440 : ℚ)*2^10 ≤ oneSmallCutoffRow_56.R5*3^10 by decide +kernel)
  exact full_ring_finiteA5_fixed_interval_of_bounds hK phi hS x y c d
    hxS hyS hcS hdS hxy hxc hyc hxd hyd hcd hXY hC1000 hCY hCD
    (oneSmallCutoffRow_56.M5 : ℝ) (oneSmallCutoffRow_56.R5 : ℝ)
    hM hRpos hheight hdelta hR hleft hright

/-- The actual N3Ab window for signed rational anchors. It requires no
coordinate-ring equivalence for the ambient quadratic field. -/
theorem full_ring_finiteN3Ab_rational_interval_excluded
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
    (hleft : 4*(oneSmallCutoffRow_56.Mn : ℝ)^2*‖phi (y : K)‖^14*‖phi (c : K)‖^7/
      (1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤ ‖phi (c : K)‖^11/
      (4*(oneSmallCutoffRow_56.Rn : ℝ)^2*‖phi (y : K)‖^6*(1+1/4000 : ℝ))) : False := by
  obtain ⟨hX,hY,hdist⟩ := rationalCutoff_pair_geometry phi sgn x y hx hy
  have hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖ := by rw [hX,hY]; norm_num
  have hM : 0 < (oneSmallCutoffRow_56.Mn : ℝ) := by
    exact_mod_cast (show (0 : ℚ) < oneSmallCutoffRow_56.Mn by decide +kernel)
  have hRpos : 0 < (oneSmallCutoffRow_56.Rn : ℝ) := by
    exact_mod_cast (show (0 : ℚ) < oneSmallCutoffRow_56.Rn by decide +kernel)
  have hheight := finiteN3Ab_rational_height phi sgn x y c hx hy hC1000 hCY
  have hR : (3535/409600 : ℝ)*max (‖phi (x : K)-phi (y : K)‖^6)
      (‖phi (x : K)‖*‖phi (x : K)-phi (y : K)‖^5) ≤
        (oneSmallCutoffRow_56.Rn : ℝ)*‖phi (y : K)‖^6 := by
    rw [hdist,hX,hY]
    exact_mod_cast (show (3535/409600 : ℚ)*max (2^6) (1*2^5) ≤
      oneSmallCutoffRow_56.Rn*3^6 by decide +kernel)
  exact full_ring_finiteN3_fixed_interval_of_bounds hK phi hS x y c d
    hxS hyS hcS hdS hxy hxc hyc hxd hyd hcd hXY hC1000 hCY hCD
    (oneSmallCutoffRow_56.Mn : ℝ) (oneSmallCutoffRow_56.Rn : ℝ)
    hM hRpos hheight hR hleft hright

/-- The actual N3Bs window for signed rational anchors. It requires no
coordinate-ring equivalence for the ambient quadratic field. -/
theorem full_ring_finiteN3Bs_rational_interval_excluded
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {S : Finset (𝓞 K)} (hS : IsD1 S) (x y c d : 𝓞 K)
    (hxS : x ∈ S) (hyS : y ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hxy : x ≠ y) (hxc : x ≠ c) (hyc : y ≠ c)
    (hxd : x ≠ d) (hyd : y ≠ d) (hcd : c ≠ d)
    (hC1000 : 1000 ≤ ‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖)
    (sgn : Bool) (hx : x = if sgn then -3 else 3)
    (hy : y = if sgn then -8 else 8)
    (hleft : 4*(oneSmallCutoffRow_56.Mbs : ℝ)^2*‖phi (y : K)‖^14*‖phi (c : K)‖^7/
      (1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤ ‖phi (x : K)‖^8*‖phi (c : K)‖^11/
      (4*(oneSmallCutoffRow_56.Rbs : ℝ)^2*‖phi (y : K)‖^6*(1+1/4000 : ℝ))) : False := by
  obtain ⟨hX,hY,hdist⟩ := rationalCutoff_bs_geometry phi sgn x y hx hy
  have hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖ := by rw [hX,hY]; norm_num
  have hM : 0 < (oneSmallCutoffRow_56.Mbs : ℝ) := by
    exact_mod_cast (show (0 : ℚ) < oneSmallCutoffRow_56.Mbs by decide +kernel)
  have hRpos : 0 < (oneSmallCutoffRow_56.Rbs : ℝ) := by
    exact_mod_cast (show (0 : ℚ) < oneSmallCutoffRow_56.Rbs by decide +kernel)
  have hheight := finiteN3Bs_rational_height phi sgn x y c hx hy hC1000 hCY
  have hR : (3535/409600 : ℝ)*max (‖phi (x : K)-phi (y : K)‖^6)
      (‖phi (x : K)‖*‖phi (x : K)-phi (y : K)‖^5) ≤
        (oneSmallCutoffRow_56.Rbs : ℝ)*‖phi (y : K)‖^6 := by
    rw [hdist,hX,hY]
    exact_mod_cast (show (3535/409600 : ℚ)*max (5^6) (3*5^5) ≤
      oneSmallCutoffRow_56.Rbs*8^6 by decide +kernel)
  exact full_ring_finiteN3_exact_interval_of_bounds hK phi hS x y c d
    hxS hyS hcS hdS hxy hxc hyc hxd hyd hcd hXY hC1000 hCY hCD
    (oneSmallCutoffRow_56.Mbs : ℝ) (oneSmallCutoffRow_56.Rbs : ℝ)
    hM hRpos hheight hR hleft hright

end D1Bound5
