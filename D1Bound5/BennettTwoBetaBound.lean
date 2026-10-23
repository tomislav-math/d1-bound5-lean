import Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring
import Lean.Elab.Tactic.Omega

namespace D1Bound5

/-- The exact normalized beta factor in the two-anchor residual estimate. -/
noncomputable def bennettTwoBetaFactor (k : ℕ) : ℝ :=
  (27 / 4 : ℝ) ^ k * Real.Gamma ((k : ℝ) + 3 / 2) *
    Real.Gamma (2 * (k : ℝ) - 1 / 2) /
      (Real.pi * Real.Gamma (3 * (k : ℝ) + 1))

theorem bennett_Gamma_add_two (x : ℝ) (hx : 0 < x) :
    Real.Gamma (x + 2) = (x + 1) * x * Real.Gamma x := by
  rw [show x + 2 = (x + 1) + 1 by ring,
    Real.Gamma_add_one (show x + 1 ≠ 0 by linarith), Real.Gamma_add_one hx.ne']
  ring

theorem bennett_Gamma_add_three (x : ℝ) (hx : 0 < x) :
    Real.Gamma (x + 3) = (x + 2) * (x + 1) * x * Real.Gamma x := by
  rw [show x + 3 = (x + 2) + 1 by ring,
    Real.Gamma_add_one (show x + 2 ≠ 0 by linarith), bennett_Gamma_add_two x hx]
  ring

theorem bennettTwoBetaFactor_pos (k : ℕ) (hk : 1 ≤ k) :
    0 < bennettTwoBetaFactor k := by
  have hkR : (1 : ℝ) ≤ k := by exact_mod_cast hk
  unfold bennettTwoBetaFactor
  exact div_pos
    (mul_pos (mul_pos (pow_pos (by norm_num) _)
      (Real.Gamma_pos_of_pos (by linarith))) (Real.Gamma_pos_of_pos (by linarith)))
    (mul_pos Real.pi_pos (Real.Gamma_pos_of_pos (by positivity)))

/-- Exact first value; both half-integer Gamma factors are evaluated. -/
theorem bennettTwoBetaFactor_one : bennettTwoBetaFactor 1 = 27 / 64 := by
  have h3 : Real.Gamma (3 / 2 : ℝ) = (1 / 2 : ℝ) * Real.sqrt Real.pi := by
    convert Real.Gamma_add_one (by norm_num : (1 / 2 : ℝ) ≠ 0) using 1 <;>
      norm_num [Real.Gamma_one_half_eq]
  have h5 : Real.Gamma (5 / 2 : ℝ) = (3 / 2 : ℝ) * Real.Gamma (3 / 2 : ℝ) := by
    convert Real.Gamma_add_one (by norm_num : (3 / 2 : ℝ) ≠ 0) using 1 <;> norm_num
  norm_num [bennettTwoBetaFactor, h3, h5] <;>
    field_simp [Real.pi_ne_zero] <;> nlinarith [Real.sq_sqrt Real.pi_pos.le]

/-- The actual Gamma sequence obeys the rational recurrence used in the paper. -/
theorem bennettTwoBetaFactor_succ (k : ℕ) (hk : 1 ≤ k) :
    bennettTwoBetaFactor (k + 1) = bennettTwoBetaFactor k *
      (((27 / 4 : ℝ) * ((k : ℝ) + 3 / 2) * (2 * (k : ℝ) - 1 / 2) *
        (2 * (k : ℝ) + 1 / 2)) /
          ((3 * (k : ℝ) + 1) * (3 * (k : ℝ) + 2) * (3 * (k : ℝ) + 3))) := by
  have hkR : (1 : ℝ) ≤ k := by exact_mod_cast hk
  have hg1 : Real.Gamma (((k + 1 : ℕ) : ℝ) + 3 / 2) =
      ((k : ℝ) + 3 / 2) * Real.Gamma ((k : ℝ) + 3 / 2) := by
    rw [show ((k + 1 : ℕ) : ℝ) + 3 / 2 = ((k : ℝ) + 3 / 2) + 1 by
      push_cast; ring]
    exact Real.Gamma_add_one (by linarith)
  have hg2 : Real.Gamma (2 * ((k + 1 : ℕ) : ℝ) - 1 / 2) =
      (2 * (k : ℝ) + 1 / 2) * (2 * (k : ℝ) - 1 / 2) *
        Real.Gamma (2 * (k : ℝ) - 1 / 2) := by
    rw [show 2 * ((k + 1 : ℕ) : ℝ) - 1 / 2 = (2 * (k : ℝ) - 1 / 2) + 2 by
      push_cast; ring, bennett_Gamma_add_two _ (by linarith)]
    ring
  have hg3 : Real.Gamma (3 * ((k + 1 : ℕ) : ℝ) + 1) =
      (3 * (k : ℝ) + 1) * (3 * (k : ℝ) + 2) * (3 * (k : ℝ) + 3) *
        Real.Gamma (3 * (k : ℝ) + 1) := by
    rw [show 3 * ((k + 1 : ℕ) : ℝ) + 1 = (3 * (k : ℝ) + 1) + 3 by
      push_cast; ring, bennett_Gamma_add_three _ (by positivity)]
    ring
  have hG : Real.Gamma (3 * (k : ℝ) + 1) ≠ 0 :=
    (Real.Gamma_pos_of_pos (by positivity)).ne'
  have h1 : 3 * (k : ℝ) + 1 ≠ 0 := by positivity
  have h2 : 3 * (k : ℝ) + 2 ≠ 0 := by positivity
  have h3 : 3 * (k : ℝ) + 3 ≠ 0 := by positivity
  unfold bennettTwoBetaFactor
  rw [hg1, hg2, hg3, pow_succ]
  field_simp [Real.pi_ne_zero, hG, h1, h2, h3]
  <;> ring

/-- The rational recurrence factor is strictly below one at every positive order. -/
theorem bennettTwoBeta_ratio_lt_one (k : ℕ) (hk : 1 ≤ k) :
    (((27 / 4 : ℝ) * ((k : ℝ) + 3 / 2) * (2 * (k : ℝ) - 1 / 2) *
      (2 * (k : ℝ) + 1 / 2)) /
        ((3 * (k : ℝ) + 1) * (3 * (k : ℝ) + 2) * (3 * (k : ℝ) + 3))) < 1 := by
  have hden : 0 < (3 * (k : ℝ) + 1) * (3 * (k : ℝ) + 2) * (3 * (k : ℝ) + 3) := by
    positivity
  apply (div_lt_one hden).mpr
  have hdiff :
      (3 * (k : ℝ) + 1) * (3 * (k : ℝ) + 2) * (3 * (k : ℝ) + 3) -
        (27 / 4 : ℝ) * ((k : ℝ) + 3 / 2) * (2 * (k : ℝ) - 1 / 2) *
          (2 * (k : ℝ) + 1 / 2) =
      (432 * (k : ℝ) ^ 2 + 1110 * (k : ℝ) + 273) / 32 := by ring
  have hp : 0 < (432 * (k : ℝ) ^ 2 + 1110 * (k : ℝ) + 273) / 32 := by positivity
  linarith

theorem bennettTwoBetaFactor_succ_lt (k : ℕ) (hk : 1 ≤ k) :
    bennettTwoBetaFactor (k + 1) < bennettTwoBetaFactor k := by
  rw [bennettTwoBetaFactor_succ k hk]
  simpa only [mul_one] using
    mul_lt_mul_of_pos_left (bennettTwoBeta_ratio_lt_one k hk) (bennettTwoBetaFactor_pos k hk)

/-- Uniform quantitative bound on the exact normalized beta factor, for all orders. -/
theorem bennettTwoBetaFactor_le (k : ℕ) (hk : 1 ≤ k) :
    bennettTwoBetaFactor k ≤ 27 / 64 := by
  have h : ∀ n : ℕ, bennettTwoBetaFactor (n + 1) ≤ 27 / 64 := by
    intro n
    induction n with
    | zero => exact bennettTwoBetaFactor_one.le
    | succ n ih =>
        exact (bennettTwoBetaFactor_succ_lt (n + 1) (by omega)).le.trans ih
  obtain ⟨n, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (by omega : k ≠ 0)
  exact h n

/-- The normalized residual bound is strictly below one half once the exact
beta expression has been derived; no estimate of a recurrence is assumed. -/
theorem bennettTwoBetaFactor_sqrt_mul_lt_half
    (η : ℝ) (hη0 : 0 ≤ η) (hη1 : η ≤ 1) (k : ℕ) (hk : 1 ≤ k) :
    Real.sqrt η * bennettTwoBetaFactor k < 1 / 2 := by
  have hs : Real.sqrt η ≤ 1 := by
    nlinarith [Real.sq_sqrt hη0, Real.sqrt_nonneg η]
  calc
    _ ≤ 1 * bennettTwoBetaFactor k :=
      mul_le_mul_of_nonneg_right hs (bennettTwoBetaFactor_pos k hk).le
    _ = bennettTwoBetaFactor k := one_mul _
    _ ≤ 27 / 64 := bennettTwoBetaFactor_le k hk
    _ < 1 / 2 := by norm_num

end D1Bound5
