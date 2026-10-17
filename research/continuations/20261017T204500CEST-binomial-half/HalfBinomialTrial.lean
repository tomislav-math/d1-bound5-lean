import Mathlib.RingTheory.Binomial
import Mathlib.Tactic

namespace D1Bound5

/-- Exact recurrence for the binomial coefficients in the Taylor series of
`sqrt (1 + z)`. The normalization is `Ring.choose (1/2) n`. -/
theorem half_binomial_recurrence (n : ℕ) :
    (n + 1 : ℝ) * Ring.choose (1 / 2 : ℝ) (n + 1) =
      ((1 / 2 : ℝ) - n) * Ring.choose (1 / 2 : ℝ) n := by
  have h := Ring.choose_smul_choose (r := (1 / 2 : ℝ))
    (n := n + 1) (k := n) (Nat.le_succ n)
  simpa [Nat.choose_succ_self, Ring.choose_one_right, nsmul_eq_mul,
    mul_comm, mul_left_comm, mul_assoc] using h

/-- From degree one onward, absolute half-binomial coefficients decrease. -/
theorem half_binomial_abs_next_le (n : ℕ) (hn : 1 ≤ n) :
    |Ring.choose (1 / 2 : ℝ) (n + 1)| ≤
      |Ring.choose (1 / 2 : ℝ) n| := by
  have hnreal : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  have hsign : (1 / 2 : ℝ) - n ≤ 0 := by linarith
  have hnum : |(1 / 2 : ℝ) - n| ≤ (n + 1 : ℝ) := by
    rw [abs_of_nonpos hsign]
    push_cast
    linarith
  have hre := congrArg abs (half_binomial_recurrence n)
  rw [abs_mul, abs_mul, abs_of_nonneg (by positivity : (0 : ℝ) ≤ (n + 1 : ℝ))] at hre
  have hp : (0 : ℝ) < (n + 1 : ℝ) := by positivity
  apply (mul_le_mul_left hp).mp
  rw [hre]
  exact mul_le_mul_of_nonneg_right hnum (abs_nonneg _)

/-- Uniform coefficient bound at all strictly positive degrees. -/
theorem half_binomial_abs_le_half (n : ℕ) (hn : 1 ≤ n) :
    |Ring.choose (1 / 2 : ℝ) n| ≤ 1 / 2 := by
  induction n with
  | zero => omega
  | succ n ih =>
      cases n with
      | zero =>
          simp [Ring.choose_one_right]
          norm_num
      | succ k =>
          exact (half_binomial_abs_next_le (k + 1) (by omega)).trans
            (ih (by omega))

end D1Bound5

#check @D1Bound5.half_binomial_recurrence
#check @D1Bound5.half_binomial_abs_next_le
#check @D1Bound5.half_binomial_abs_le_half
#print axioms D1Bound5.half_binomial_recurrence
#print axioms D1Bound5.half_binomial_abs_next_le
#print axioms D1Bound5.half_binomial_abs_le_half
