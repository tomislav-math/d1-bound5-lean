import D1Bound5.UnitPairCubicNumeric
import D1Bound5.FullRingBridge
import D1Bound5.TupleRootMatrixBridge
import Mathlib.Tactic.LinearCombination

open scoped NumberField
open Module

namespace D1Bound5

/-- The second-order unit-pair form can vanish only when the two
extensions are opposites. This calculation permits zero input roots. -/
theorem unit_pair_cancellation_ne_zero (u v z w : ℂ)
    (hu : u^2 = z^2+w) (hv : v^2 = z^2-w) (hw : w ≠ 0) :
    u+v-2*z ≠ 0 := by
  intro h
  have hsum : u+v = 2*z := sub_eq_zero.mp h
  have huv : u*v = z^2 := by
    linear_combination (u+v+2*z)/2 * hsum - (1/2 : ℂ)*hu - (1/2 : ℂ)*hv
  have hw2 : w^2 = 0 := by
    linear_combination (z^2-w)*hu + u^2*hv - (u*v+z^2)*huv
  exact (pow_ne_zero 2 hw) hw2

/-- The first-order errors cancel exactly in the sum of the two chosen
roots; the surviving expression is quadratic in those errors. -/
theorem unit_pair_cancellation_norm (u v z w : ℂ)
    (hu : u^2 = z^2+w) (hv : v^2 = z^2-w) :
    2*‖z‖*‖u+v-2*z‖ ≤ ‖u-z‖^2+‖v-z‖^2 := by
  have hid : 2*z*(u+v-2*z) = -((u-z)^2+(v-z)^2) := by
    linear_combination hu+hv
  have hn := congrArg norm hid
  simp only [norm_mul,norm_neg,Complex.norm_two] at hn
  rw [hn]
  calc
    _ ≤ ‖(u-z)^(2 : ℕ)‖+‖(v-z)^(2 : ℕ)‖ := norm_add_le _ _
    _ = _ := by rw [Complex.norm_pow, Complex.norm_pow]

private theorem exists_unit_pair_integral_sign
    {R : Type*} [CommRing R] (f : R →+* ℂ) (u z : R) (W : ℝ)
    (hz : f z ≠ 0) (hW : 0 < W)
    (herr : ‖(f u)^2-(f z)^2‖ ≤ W)
    (hgap : W < (1-(7/8 : ℝ)^2)*‖f z‖^2) :
    ∃ U : R, (U = u ∨ U = -u) ∧ (15/8 : ℝ)*‖f z‖*‖f U-f z‖ < W := by
  obtain ⟨v,hv,hnear⟩ := exists_sign_root_perturbation
    (f u) (f z) (7/8) W hz (by norm_num) hW herr hgap
  norm_num at hnear
  rcases hv with rfl | rfl
  · exact ⟨u,Or.inl rfl,hnear⟩
  · exact ⟨-u,Or.inr rfl,by simpa only [map_neg] using hnear⟩

/-- The unit cubic gap in any discrete complex ring image. Both signs
are selected among the original ring roots; the lower bound on the
nonzero second-order form is derived from discreteness. -/
theorem discrete_unit_pair_cubic_growth
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (hdiscrete : ∀ x : R, x ≠ 0 → 1 ≤ ‖f x‖)
    (c d z u v : R) (hC : 9 ≤ ‖f c‖) (hCD : ‖f c‖ ≤ ‖f d‖)
    (hneq : f c+f d ≠ 0)
    (hz : z^2 = c*d+1) (hu : u^2 = (c+1)*(d+1))
    (hv : v^2 = (1-c)*(1-d)) : ‖f c‖^3/2 < ‖f d‖ := by
  have hzC : (f z)^2 = f c*f d+1 := by
    simpa only [map_pow,map_mul,map_add,map_one] using congrArg f hz
  have huC : (f u)^2 = (f z)^2+(f c+f d) := by
    have h := congrArg f hu
    simp only [map_pow,map_mul,map_add,map_one] at h
    rw [h,hzC]
    ring
  have hvC : (f v)^2 = (f z)^2-(f c+f d) := by
    have h := congrArg f hv
    simp only [map_pow,map_mul,map_sub,map_one] at h
    rw [h,hzC]
    ring
  have hZ : ‖f c‖*‖f d‖ ≤ ‖f z‖^2+1 := by
    have hid : f c*f d = (f z)^2-1 := by rw [hzC]; ring
    have h := norm_sub_le ((f z)^2) (1 : ℂ)
    rw [← hid,norm_mul] at h
    simpa only [norm_pow,norm_one] using h
  have hD : 9 ≤ ‖f d‖ := hC.trans hCD
  have hCD81 : 81 ≤ ‖f c‖*‖f d‖ := by
    have hp := mul_nonneg (sub_nonneg.mpr hC) (sub_nonneg.mpr hD)
    nlinarith only [hp,hC,hD]
  have hZ0 : 0 < ‖f z‖ := by
    by_contra hbad
    have hn : ‖f z‖ = 0 := le_antisymm (le_of_not_gt hbad) (norm_nonneg _)
    nlinarith only [hZ,hCD81,hn]
  have hW0 : 0 < ‖f c+f d‖ := norm_pos_iff.mpr hneq
  have hW := norm_add_le (f c) (f d)
  have hgap := unit_pair_cubic_root_margin ‖f c‖ ‖f d‖ ‖f z‖ ‖f c+f d‖
    hC hCD hW hZ
  have huErr : ‖(f u)^2-(f z)^2‖ ≤ ‖f c+f d‖ := by rw [huC]; simp
  have hvErr : ‖(f v)^2-(f z)^2‖ ≤ ‖f c+f d‖ := by
    rw [hvC, show (f z)^2-(f c+f d)-(f z)^2 = -(f c+f d) by ring,
      norm_neg]
  obtain ⟨U,hU,hUnear⟩ := exists_unit_pair_integral_sign f u z ‖f c+f d‖
    (norm_pos_iff.mp hZ0) hW0 huErr hgap
  obtain ⟨V,hV,hVnear⟩ := exists_unit_pair_integral_sign f v z ‖f c+f d‖
    (norm_pos_iff.mp hZ0) hW0 hvErr hgap
  have hU2 : (f U)^2 = (f z)^2+(f c+f d) := by
    rcases hU with rfl | rfl
    · exact huC
    · simpa only [map_neg,neg_sq] using huC
  have hV2 : (f V)^2 = (f z)^2-(f c+f d) := by
    rcases hV with rfl | rfl
    · exact hvC
    · simpa only [map_neg,neg_sq] using hvC
  let L : R := U+V-2*z
  have hLimage : f L = f U+f V-2*f z := by
    simp only [L,map_sub,map_add,map_mul,map_ofNat]
  have hLn : L ≠ 0 := by
    intro h
    have hz0 : f U+f V-2*f z = 0 := by rw [← hLimage,h,map_zero]
    exact unit_pair_cancellation_ne_zero (f U) (f V) (f z) (f c+f d) hU2 hV2 hneq hz0
  have hL : 1 ≤ ‖f U+f V-2*f z‖ := by
    rw [← hLimage]
    exact hdiscrete L hLn
  exact unit_pair_cubic_numeric ‖f c‖ ‖f d‖ ‖f z‖ ‖f c+f d‖
    ‖f U-f z‖ ‖f V-f z‖ ‖f U+f V-2*f z‖
    hC hCD hZ0 hW0 (norm_nonneg _) (norm_nonneg _) hL hW hZ hUnear hVnear
    (unit_pair_cancellation_norm (f U) (f V) (f z) (f c+f d) hU2 hV2)

/-- Actual common extensions of {-1,1} satisfy the manuscript cubic gap.
All five square witnesses are in the full integer ring; no analytic
branch, root nonvanishing, or auxiliary form estimate is a premise. -/
theorem full_ring_unit_pair_cubic_growth
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (c d : 𝓞 K) (hC : 9 ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖) (hneq : d ≠ -c)
    (hcp : ∃ r : 𝓞 K, r^2 = c+1) (hcm : ∃ r : 𝓞 K, r^2 = 1-c)
    (hdp : ∃ r : 𝓞 K, r^2 = d+1) (hdm : ∃ r : 𝓞 K, r^2 = 1-d)
    (hcd : ∃ r : 𝓞 K, r^2 = c*d+1) :
    ‖phi (c : K)‖^3/2 < ‖phi (d : K)‖ := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hdiscrete (x : 𝓞 K) (hx : x ≠ 0) : 1 ≤ ‖f x‖ :=
    one_le_norm_integer hK phi hx
  have hsum : c+d ≠ 0 := by
    intro h
    apply hneq
    linear_combination h
  have hneqC : f c+f d ≠ 0 := by
    intro h
    have hn := hdiscrete (c+d) hsum
    rw [map_add,h,norm_zero] at hn
    norm_num at hn
  obtain ⟨cp,hcp⟩ := hcp
  obtain ⟨cm,hcm⟩ := hcm
  obtain ⟨dp,hdp⟩ := hdp
  obtain ⟨dm,hdm⟩ := hdm
  obtain ⟨z,hz⟩ := hcd
  apply discrete_unit_pair_cubic_growth f hdiscrete c d z (cp*dp) (cm*dm)
    hC hCD hneqC hz
  · rw [mul_pow,hcp,hdp]
  · rw [mul_pow,hcm,hdm]

/-- The cubic unit-pair gap for an actual indexed D(1)-quadruple. -/
theorem IsD1Tuple.unit_pair_cubic_growth
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 4 → 𝓞 K) (ha : IsD1Tuple a)
    (hminus : a 0 = -1) (hplus : a 1 = 1)
    (hC : 9 ≤ ‖phi (a 2 : K)‖)
    (hCD : ‖phi (a 2 : K)‖ ≤ ‖phi (a 3 : K)‖)
    (hneq : a 3 ≠ -a 2) :
    ‖phi (a 2 : K)‖^3/2 < ‖phi (a 3 : K)‖ := by
  apply full_ring_unit_pair_cubic_growth hK phi (a 2) (a 3) hC hCD hneq
  · obtain ⟨r,hr⟩ := ha.2.2 1 2 (by decide)
    exact ⟨r,by simpa only [pow_two,hplus,one_mul] using hr⟩
  · obtain ⟨r,hr⟩ := ha.2.2 0 2 (by decide)
    refine ⟨r,?_⟩
    rw [pow_two,hr,hminus]
    ring
  · obtain ⟨r,hr⟩ := ha.2.2 1 3 (by decide)
    exact ⟨r,by simpa only [pow_two,hplus,one_mul] using hr⟩
  · obtain ⟨r,hr⟩ := ha.2.2 0 3 (by decide)
    refine ⟨r,?_⟩
    rw [pow_two,hr,hminus]
    ring
  · obtain ⟨r,hr⟩ := ha.2.2 2 3 (by decide)
    exact ⟨r,by simpa only [pow_two] using hr⟩

end D1Bound5
