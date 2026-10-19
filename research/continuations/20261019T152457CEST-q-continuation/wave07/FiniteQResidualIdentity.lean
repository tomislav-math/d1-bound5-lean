import D1Bound5.FiniteQMatrix
import D1Bound5.HalfBinomialAnalytic
import Mathlib.Tactic.FieldSimp

open Finset

namespace D1Bound5

theorem finiteQ_half_coefficients :
    halfBinomialCoeff 0 = 1 ∧ halfBinomialCoeff 1 = 1/2 ∧
    halfBinomialCoeff 2 = -1/8 ∧ halfBinomialCoeff 3 = 1/16 ∧
    halfBinomialCoeff 4 = -5/128 := by
  have h0 : halfBinomialCoeff 0 = 1 := by simp [halfBinomialCoeff]
  have h1 : halfBinomialCoeff 1 = 1/2 := by
    norm_num [halfBinomialCoeff, Ring.choose_one_right]
  have h2 : halfBinomialCoeff 2 = -1/8 := by
    have h := halfBinomialCoeff_recurrence 1
    norm_num [h1] at h
    linarith
  have h3 : halfBinomialCoeff 3 = 1/16 := by
    have h := halfBinomialCoeff_recurrence 2
    norm_num [h2] at h
    linarith
  have h4 : halfBinomialCoeff 4 = -5/128 := by
    have h := halfBinomialCoeff_recurrence 3
    norm_num [h3] at h
    linarith
  exact ⟨h0, h1, h2, h3, h4⟩

/-- The remainder of the actual principal half power after n terms. -/
noncomputable def finiteQHalfRemainder (n : ℕ) (z : ℂ) : ℂ :=
  (1+z)^(1/2 : ℂ) - ∑ m ∈ Finset.range n, (halfBinomialCoeff m : ℂ)*z^m

/-- A convergent geometric envelope for the actual half-power remainder,
valid from degree four onward with the sharp coefficient5/128. -/
theorem finiteQHalfRemainder_norm_le (n : ℕ) (z : ℂ)
    (hn : 4 ≤ n) (hz : ‖z‖ < 1) :
    ‖finiteQHalfRemainder n z‖ ≤ (5/128 : ℝ)*‖z‖^n/(1-‖z‖) := by
  have hs := halfBinomialCoeff_hasSum_cpow z hz
  have htail : HasSum (fun j : ℕ => (halfBinomialCoeff (j+n) : ℂ)*z^(j+n))
      (finiteQHalfRemainder n z) := (hasSum_nat_add_iff' n).2 hs
  have hr : ‖(‖z‖ : ℝ)‖ < 1 := by
    simpa only [Real.norm_eq_abs, abs_of_nonneg (norm_nonneg z)] using hz
  have hgeom := (hasSum_geometric_of_norm_lt_one hr).mul_left
    ((5/128 : ℝ)*‖z‖^n)
  have hterm (j : ℕ) :
      ‖(halfBinomialCoeff (j+n) : ℂ)*z^(j+n)‖ ≤
        ((5/128 : ℝ)*‖z‖^n)*‖z‖^j := by
    have hb : |halfBinomialCoeff (j+n)| ≤ (5/128 : ℝ) := by
      have h := halfBinomialCoeff_abs_antitone (j := 4) (k := j+n)
        (by decide) (by omega)
      rw [finiteQ_half_coefficients.2.2.2.2] at h
      norm_num at h ⊢
      exact h
    calc
      _ = |halfBinomialCoeff (j+n)| *‖z‖^(j+n) := by
        rw [norm_mul, norm_pow, Complex.norm_real, Real.norm_eq_abs]
      _ ≤ (5/128 : ℝ)*‖z‖^(j+n) :=
        mul_le_mul_of_nonneg_right hb (pow_nonneg (norm_nonneg z) _)
      _ = _ := by rw [pow_add]; ring
  have hnorm : Summable (fun j : ℕ => ‖(halfBinomialCoeff (j+n) : ℂ)*z^(j+n)‖) :=
    Summable.of_nonneg_of_le (fun _ => norm_nonneg _) hterm hgeom.summable
  calc
    _ = ‖∑' j : ℕ, (halfBinomialCoeff (j+n) : ℂ)*z^(j+n)‖ := by
      rw [htail.tsum_eq]
    _ ≤ ∑' j : ℕ, ‖(halfBinomialCoeff (j+n) : ℂ)*z^(j+n)‖ := norm_tsum_le_tsum_norm hnorm
    _ ≤ ∑' j : ℕ, ((5/128 : ℝ)*‖z‖^n)*‖z‖^j :=
      hnorm.tsum_le_tsum hterm hgeom.summable
    _ = (5/128 : ℝ)*‖z‖^n/(1-‖z‖) := by
      rw [hgeom.tsum_eq]
      rfl

/-- The residual of the actual finite pair row on its two principal
half-power branches. -/
noncomputable def finiteQResidual (u v c : ℂ) : ℂ :=
  finiteQConstant u v c + u*finiteQLeft u v c*((1+1/(u*c))^(1/2 : ℂ)) +
    v*finiteQRight u v c*((1+1/(v*c))^(1/2 : ℂ))

set_option maxHeartbeats 800000 in
/-- Every nonnegative power and each inverse power through c^-3 cancels.
The remaining four terms are genuine analytic remainders, not an assumed
formal residual estimate. -/
theorem finiteQResidual_eq_remainders
    (u v c : ℂ) (hu : u ≠ 0) (hv : v ≠ 0) (hc : c ≠ 0) :
    finiteQResidual u v c =
      u*(u^2-5*u*v)*finiteQHalfRemainder 4 (1/(u*c)) +
      u*(4*u^3-8*u^2*v)*c*finiteQHalfRemainder 5 (1/(u*c)) +
      v*(5*u*v-v^2)*finiteQHalfRemainder 4 (1/(v*c)) +
      v*(8*u*v^2-4*v^3)*c*finiteQHalfRemainder 5 (1/(v*c)) := by
  obtain ⟨h0, h1, h2, h3, h4⟩ := finiteQ_half_coefficients
  simp only [finiteQResidual, finiteQHalfRemainder, Finset.sum_range_succ,
    Finset.sum_range_zero, h0, h1, h2, h3, h4]
  norm_num only [Complex.ofReal_one, Complex.ofReal_div, Complex.ofReal_neg,
    Complex.ofReal_ofNat, pow_zero, pow_one, zero_add, one_mul]
  unfold finiteQConstant finiteQLeft finiteQRight
  field_simp [hu, hv, hc]
  <;> ring

end D1Bound5
