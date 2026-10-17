import Mathlib.RingTheory.Binomial
import Mathlib.Algebra.BigOperators.NatAntidiagonal
import D1Bound5.CoherentWeightedRemainder

open Finset

namespace D1Bound5

/-- The real Taylor coefficient of `sqrt (1+z)` at degree `n`. -/
noncomputable def halfBinomialCoeff (n : ℕ) : ℝ :=
  Ring.choose (1 / 2 : ℝ) n

/-- The half-binomial coefficient recurrence in every degree. -/
theorem halfBinomialCoeff_recurrence (n : ℕ) :
    (n + 1 : ℝ) * halfBinomialCoeff (n + 1) =
      ((1 / 2 : ℝ) - n) * halfBinomialCoeff n := by
  have h := Ring.choose_smul_choose (r := (1 / 2 : ℝ))
    (n := n + 1) (k := n) (Nat.le_succ n)
  simpa [halfBinomialCoeff, Nat.choose_succ_self_right, nsmul_eq_mul,
    Ring.choose_one_right, mul_comm, mul_left_comm, mul_assoc] using h

/-- The coefficients have alternating signs from degree one onward. -/
theorem halfBinomialCoeff_signed_nonneg (n : ℕ) :
    0 ≤ (-1 : ℝ) ^ n * halfBinomialCoeff (n + 1) := by
  induction n with
  | zero =>
      norm_num [halfBinomialCoeff, Ring.choose_one_right]
  | succ n ih =>
      have hn : (0 : ℝ) < (n : ℝ) + 2 := by positivity
      have hrec :
          ((n : ℝ) + 2) * halfBinomialCoeff (n + 2) =
            ((1 / 2 : ℝ) - ((n : ℝ) + 1)) * halfBinomialCoeff (n + 1) := by
        convert halfBinomialCoeff_recurrence (n + 1) using 1 <;>
          simp only [Nat.cast_add, Nat.cast_one] <;> ring
      have hsolve :
          halfBinomialCoeff (n + 2) =
          (((1 / 2 : ℝ) - (n + 1)) * halfBinomialCoeff (n + 1)) / (n + 2) := by
        apply (eq_div_iff (ne_of_gt hn)).2
        rw [mul_comm]
        exact hrec
      have hfactor : 0 ≤ ((n + 1 : ℝ) - (1 / 2 : ℝ)) / (n + 2) := by
        apply div_nonneg
        · have hn1 : (1 : ℝ) ≤ (n + 1 : ℕ) := by
            exact_mod_cast Nat.succ_le_succ (Nat.zero_le n)
          linarith
        · exact le_of_lt hn
      rw [pow_succ, hsolve]
      have heq :
          (-1 : ℝ) ^ n * -1 *
              ((((1 / 2 : ℝ) - (n + 1)) * halfBinomialCoeff (n + 1)) / (n + 2)) =
          ((-1 : ℝ) ^ n * halfBinomialCoeff (n + 1)) *
              (((n + 1 : ℝ) - (1 / 2 : ℝ)) / (n + 2)) := by ring
      rw [heq]
      exact mul_nonneg ih hfactor

/-- Absolute coefficients weakly decrease from degree one onward. -/
theorem halfBinomialCoeff_abs_next_le (n : ℕ) (hn : 1 ≤ n) :
    |halfBinomialCoeff (n + 1)| ≤ |halfBinomialCoeff n| := by
  have hnreal : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  have hsign : (1 / 2 : ℝ) - n ≤ 0 := by linarith
  have hnum : |(1 / 2 : ℝ) - n| ≤ (n + 1 : ℝ) := by
    rw [abs_of_nonpos hsign]
    push_cast
    linarith
  have hre := congrArg abs (halfBinomialCoeff_recurrence n)
  rw [abs_mul, abs_mul, abs_of_nonneg (by positivity : (0 : ℝ) ≤ (n + 1 : ℝ))] at hre
  have hp : (0 : ℝ) < (n : ℝ) + 1 := by positivity
  have hmul :
      ((n : ℝ) + 1) * |halfBinomialCoeff (n + 1)| ≤
        ((n : ℝ) + 1) * |halfBinomialCoeff n| := by
    rw [hre]
    exact mul_le_mul_of_nonneg_right hnum (abs_nonneg _)
  exact (mul_le_mul_iff_of_pos_left hp).mp hmul

/-- Monotonicity of the absolute coefficients at all positive degrees. -/
theorem halfBinomialCoeff_abs_antitone
    {j k : ℕ} (hj : 1 ≤ j) (hjk : j ≤ k) :
    |halfBinomialCoeff k| ≤ |halfBinomialCoeff j| := by
  induction k, hjk using Nat.le_induction with
  | base => exact le_refl _
  | succ k hk ih =>
      exact (halfBinomialCoeff_abs_next_le k (hj.trans hk)).trans ih

/-- Uniform upper bound on each nonconstant half-binomial coefficient. -/
theorem halfBinomialCoeff_abs_le_half (n : ℕ) (hn : 1 ≤ n) :
    |halfBinomialCoeff n| ≤ (1 / 2 : ℝ) := by
  have h := halfBinomialCoeff_abs_antitone (j := 1) (k := n) (by decide) hn
  simpa [halfBinomialCoeff, Ring.choose_one_right] using h

/-- Every interior product has the sign needed for the sharp convolution bound. -/
theorem halfBinomialCoeff_signed_pair_nonneg (i j : ℕ) :
    0 ≤ (-1 : ℝ) ^ (i + j + 2) *
      (halfBinomialCoeff (i + 1) * halfBinomialCoeff (j + 1)) := by
  have hi := halfBinomialCoeff_signed_nonneg i
  have hj := halfBinomialCoeff_signed_nonneg j
  have hpow : (-1 : ℝ) ^ (i + j + 2) =
      (-1 : ℝ) ^ i * (-1 : ℝ) ^ j := by
    simp [pow_add]
  rw [hpow]
  simpa only [mul_assoc, mul_comm, mul_left_comm] using (mul_nonneg hi hj)

/-- The half-binomial convolution vanishes at each degree at least two. -/
theorem halfBinomialCoeff_convolution_zero (n : ℕ) (hn : 2 ≤ n) :
    (∑ ij ∈ Finset.antidiagonal n,
        halfBinomialCoeff ij.1 * halfBinomialCoeff ij.2) = 0 := by
  have h := Ring.add_choose_eq
    (r := (1 / 2 : ℝ)) (s := (1 / 2 : ℝ)) n (Commute.all _ _)
  have hs : (1 / 2 : ℝ) + 1 / 2 = 1 := by ring
  rw [hs] at h
  have hz : Nat.choose 1 n = 0 := Nat.choose_eq_zero_of_lt (by omega)
  have hb0 : Ring.choose (1 : ℝ) n = 0 := by
    simpa [hz] using (Ring.choose_natCast (R := ℝ) 1 n)
  simpa [halfBinomialCoeff, hb0] using h.symm

end D1Bound5

#check @D1Bound5.halfBinomialCoeff_abs_antitone
#check @D1Bound5.halfBinomialCoeff_abs_le_half
#check @D1Bound5.halfBinomialCoeff_signed_pair_nonneg
#check @D1Bound5.halfBinomialCoeff_convolution_zero
#print axioms D1Bound5.halfBinomialCoeff_abs_antitone
#print axioms D1Bound5.halfBinomialCoeff_abs_le_half
#print axioms D1Bound5.halfBinomialCoeff_signed_pair_nonneg
#print axioms D1Bound5.halfBinomialCoeff_convolution_zero
#check @D1Bound5.halfBinomialCoeff_recurrence
#check @D1Bound5.halfBinomialCoeff_signed_nonneg
#check @D1Bound5.halfBinomialCoeff_abs_next_le
#print axioms D1Bound5.halfBinomialCoeff_recurrence
#print axioms D1Bound5.halfBinomialCoeff_signed_nonneg
#print axioms D1Bound5.halfBinomialCoeff_abs_next_le
