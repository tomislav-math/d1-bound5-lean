import D1Bound5.BennettRootBranch
import D1Bound5.BennettTwoIntegralEntries
import Mathlib.Tactic.LinearCombination

namespace D1Bound5

/-- One fixed sign gives the elementary root error bound relative to any
nonzero complex target. The chosen sign is retained in the conclusion. -/
theorem bennett_exists_sign_root_error (t θ : ℂ) (hθ : θ ≠ 0) :
    ∃ v : ℂ, (v = t ∨ v = -t) ∧
      0 ≤ (v / θ).re ∧ ‖θ - v‖ ≤ ‖t ^ 2 - θ ^ 2‖ / ‖θ‖ := by
  have existsSign : ∃ v : ℂ, (v = t ∨ v = -t) ∧ 0 ≤ (v / θ).re := by
    by_cases h : 0 ≤ (t / θ).re
    · exact ⟨t, Or.inl rfl, h⟩
    · refine ⟨-t, Or.inr rfl, ?_⟩
      simp only [neg_div, Complex.neg_re]
      linarith
  obtain ⟨v, hv, hRe⟩ := existsSign
  have hv2 : v ^ 2 = t ^ 2 := by rcases hv with h | h <;> rw [h] <;> simp
  have hunit : 1 ≤ ‖v / θ + 1‖ := by
    have hh := Complex.re_le_norm (v / θ + 1)
    simp only [Complex.add_re, Complex.one_re] at hh
    linarith
  have hscale : v + θ = θ * (v / θ + 1) := by field_simp [hθ]; ring
  have hplus : ‖θ‖ ≤ ‖v + θ‖ := by
    rw [hscale, norm_mul]
    simpa only [mul_one] using mul_le_mul_of_nonneg_left hunit (norm_nonneg θ)
  have hprod : ‖θ - v‖ * ‖v + θ‖ = ‖t ^ 2 - θ ^ 2‖ := by
    rw [← norm_mul]
    have hid : (θ - v) * (v + θ) = -(t ^ 2 - θ ^ 2) := by
      calc
        _ = -(v ^ 2 - θ ^ 2) := by ring
        _ = _ := by rw [hv2]
    rw [hid, norm_neg]
  refine ⟨v, hv, hRe, (le_div_iff₀ (norm_pos_iff.mpr hθ)).mpr ?_⟩
  exact (mul_le_mul_of_nonneg_left hplus (norm_nonneg _)).trans_eq hprod

/-- Exact algebraic error for the two products of tuple roots. -/
theorem bennett_root_ratio_square_error
    (a c d z r v θ : ℂ) (ha : a ≠ 0) (hc : c ≠ 0) (hz : z ≠ 0)
    (hr : r ^ 2 = a * c + 1) (hv : v ^ 2 = a * d + 1)
    (hzsq : z ^ 2 = c * d + 1) (hθ : θ ^ 2 = 1 + 1 / (a * c)) :
    (r * v / (a * z)) ^ 2 - θ ^ 2 =
      θ ^ 2 * (c - a) / (a * z ^ 2) := by
  have hcd : c * d + 1 ≠ 0 := by rw [← hzsq]; exact pow_ne_zero _ hz
  simp only [div_pow, mul_pow, hr, hv, hθ, hzsq]
  field_simp [ha, hc, hcd]
  <;> ring

/-- The source-ring witness is a sign of the existing product of integral
roots. It is chosen once, independently of the later matrix row. -/
theorem bennett_exists_integral_root_ratio
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a c d z r v : R) (θ : ℂ)
    (ha : f a ≠ 0) (hc : f c ≠ 0) (hz : f z ≠ 0) (hθ0 : θ ≠ 0)
    (hr : r ^ 2 = a * c + 1) (hv : v ^ 2 = a * d + 1)
    (hzsq : z ^ 2 = c * d + 1) (hθ : θ ^ 2 = 1 + 1 / (f a * f c)) :
    ∃ s : R, (s = r * v ∨ s = -(r * v)) ∧
      0 ≤ ((f s / (f a * f z)) / θ).re ∧
      ‖θ - f s / (f a * f z)‖ ≤
        ‖θ‖ * ‖f c - f a‖ / (‖f a‖ * ‖f z‖ ^ 2) := by
  have hrC : (f r) ^ 2 = f a * f c + 1 := by
    simpa only [map_pow, map_mul, map_add, map_one] using congrArg f hr
  have hvC : (f v) ^ 2 = f a * f d + 1 := by
    simpa only [map_pow, map_mul, map_add, map_one] using congrArg f hv
  have hzC : (f z) ^ 2 = f c * f d + 1 := by
    simpa only [map_pow, map_mul, map_add, map_one] using congrArg f hzsq
  have hsquare := bennett_root_ratio_square_error (f a) (f c) (f d) (f z)
    (f r) (f v) θ ha hc hz hrC hvC hzC hθ
  obtain ⟨w, hw, hRe, herr⟩ := bennett_exists_sign_root_error
    (f r * f v / (f a * f z)) θ hθ0
  have hnorm : ‖(f r * f v / (f a * f z)) ^ 2 - θ ^ 2‖ / ‖θ‖ =
      ‖θ‖ * ‖f c - f a‖ / (‖f a‖ * ‖f z‖ ^ 2) := by
    rw [hsquare, norm_div, norm_mul, norm_pow, norm_mul, norm_pow]
    field_simp [norm_ne_zero_iff.mpr hθ0, norm_ne_zero_iff.mpr ha, norm_ne_zero_iff.mpr hz]
    <;> ring
  rw [hnorm] at herr
  rcases hw with hw | hw
  · refine ⟨r * v, Or.inl rfl, ?_, ?_⟩
    · simpa only [hw, map_mul] using hRe
    · simpa only [hw, map_mul] using herr
  · refine ⟨-(r * v), Or.inr rfl, ?_, ?_⟩
    · simpa only [hw, map_neg, map_mul, neg_div] using hRe
    · simpa only [hw, map_neg, map_mul, neg_div] using herr

/-- A uniform root-transfer estimate with the same final constant3 as the
manuscript. The stronger entry bounds permit the simple factor3/2 here,
avoiding a monotonicity argument for the auxiliary function e(X). -/
theorem bennett_exists_integral_root_ratio_bound
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a c d z r v : R)
    (ha : f a ≠ 0) (hc : f c ≠ 0) (hz : f z ≠ 0)
    (hr : r ^ 2 = a * c + 1) (hv : v ^ 2 = a * d + 1)
    (hzsq : z ^ 2 = c * d + 1)
    (hAC : 1000 ≤ ‖f a‖ * ‖f c‖) (hC : 4 * ‖f a‖ ≤ ‖f c‖) :
    ∃ s : R, (s = r * v ∨ s = -(r * v)) ∧
      ‖(1 + 1 / (f a * f c)) ^ (1 / 2 : ℂ) - f s / (f a * f z)‖ <
        (3 / 2 : ℝ) * ‖f c‖ / (‖f a‖ * ‖f z‖ ^ 2) := by
  let θ : ℂ := (1 + 1 / (f a * f c)) ^ (1 / 2 : ℂ)
  obtain ⟨hθsq, hθ0⟩ := bennett_two_root_branch_sq_ne_zero (f a) (f c) (by linarith)
  obtain ⟨s, hs, _, herr⟩ := bennett_exists_integral_root_ratio f a c d z r v θ
    ha hc hz hθ0 hr hv hzsq hθsq
  have hθnorm : ‖θ‖ < 6 / 5 := bennett_two_root_branch_norm_lt (f a) (f c) hAC
  have hdiff : ‖f c - f a‖ ≤ (5 / 4 : ℝ) * ‖f c‖ := by
    have ht := norm_sub_le (f c) (f a)
    linarith
  have hnum : ‖θ‖ * ‖f c - f a‖ < (3 / 2 : ℝ) * ‖f c‖ := by
    calc
      _ ≤ ‖θ‖ * ((5 / 4 : ℝ) * ‖f c‖) :=
        mul_le_mul_of_nonneg_left hdiff (norm_nonneg _)
      _ < (6 / 5 : ℝ) * ((5 / 4) * ‖f c‖) :=
        mul_lt_mul_of_pos_right hθnorm
          (mul_pos (by norm_num) (norm_pos_iff.mpr hc))
      _ = _ := by ring
  refine ⟨s, hs, herr.trans_lt ?_⟩
  exact div_lt_div_of_pos_right hnum
    (mul_pos (norm_pos_iff.mpr ha) (sq_pos_of_pos (norm_pos_iff.mpr hz)))

/-- The two nonzero interpolation columns have exactly the root branches
used in the tuple-root comparison. -/
theorem bennettTwoNodes_branch_one_two (a b c : ℂ)
    (ha : a ≠ 0) (hb : b ≠ 0) (hc : c ≠ 0) :
    (1 + bennettTwoNodes a b 1 * (a * b * c)⁻¹) ^ (1 / 2 : ℂ) =
        (1 + 1 / (a * c)) ^ (1 / 2 : ℂ) ∧
    (1 + bennettTwoNodes a b 2 * (a * b * c)⁻¹) ^ (1 / 2 : ℂ) =
        (1 + 1 / (b * c)) ^ (1 / 2 : ℂ) := by
  constructor
  · congr 1
    rw [bennettTwoNodes_one]
    field_simp [ha, hb, hc]
    <;> ring
  · congr 1
    rw [bennettTwoNodes_two]
    field_simp [ha, hb, hc]
    <;> ring

end D1Bound5
