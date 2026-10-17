import D1Bound5.HsymmSummability
import Mathlib.Analysis.SpecificLimits.Normed

open Finset

namespace D1Bound5

/-- Exact positive-degree tail of a negative-binomial generating function. -/
theorem negative_binomial_positive_tail_tsum (q : ℕ) (r : ℝ)
    (hr0 : 0 ≤ r) (hr1 : r < 1) :
    (∑' j : ℕ, (Nat.choose (j + 1 + q) q : ℝ) * r ^ (j + 1)) =
      1 / (1 - r) ^ (q + 1) - 1 := by
  have hr : ‖r‖ < 1 := by
    simpa [Real.norm_eq_abs, abs_of_nonneg hr0] using hr1
  have hh := hasSum_choose_mul_geometric_of_norm_lt_one q hr
  have hsplit := hh.summable.tsum_eq_zero_add
  simp only [Nat.zero_add, Nat.choose_self, Nat.cast_one, pow_zero, mul_one] at hsplit
  rw [hh.tsum_eq] at hsplit
  linarith

/-- Sharp upper bound for the sum of norms of positive-degree complete
homogeneous coefficients in a common complex radius disk. -/
theorem hsymm_aeval_complex_positive_tail_norm_le
    {ι : Type*} [Fintype ι] [DecidableEq ι] [Nonempty ι]
    (a : ι → ℂ) (ρ t : ℝ)
    (hρ0 : 0 ≤ ρ) (ht0 : 0 ≤ t)
    (hρ : ∀ i, ‖a i‖ ≤ ρ)
    (hradius : ρ * t < 1) :
    (∑' j : ℕ,
       ‖MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ (j + 1))‖ * t ^ (j + 1)) ≤
      1 / (1 - ρ * t) ^ Fintype.card ι - 1 := by
  let q : ℕ := Fintype.card ι - 1
  let r : ℝ := ρ * t
  have hq : q + 1 = Fintype.card ι := Nat.succ_pred_eq_of_pos Fintype.card_pos
  have hr0 : 0 ≤ r := mul_nonneg hρ0 ht0
  have hr : ‖r‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_nonneg hr0]
    exact hradius
  have hmajor : Summable (fun k : ℕ => (Nat.choose (k + q) q : ℝ) * r ^ k) :=
    summable_choose_mul_geometric_of_norm_lt_one q hr
  have hmajorTail : Summable (fun j : ℕ =>
      (Nat.choose (j + 1 + q) q : ℝ) * r ^ (j + 1)) := by
    have hs := (summable_nat_add_iff
      (f := fun k : ℕ => (Nat.choose (k + q) q : ℝ) * r ^ k) 1).mpr hmajor
    exact hs
  have hterm (j : ℕ) :
      ‖MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ (j + 1))‖ * t ^ (j + 1) ≤
      (Nat.choose (j + 1 + q) q : ℝ) * r ^ (j + 1) := by
    have hchoose : Nat.choose (Fintype.card ι + (j + 1) - 1) (j + 1) =
        Nat.choose (j + 1 + q) q := by
      have heq : Fintype.card ι + (j + 1) - 1 = j + 1 + q := by omega
      rw [heq]
      exact Nat.choose_symm_add
    calc
      ‖MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ (j + 1))‖ * t ^ (j + 1) ≤
          ((Nat.choose (Fintype.card ι + (j + 1) - 1) (j + 1) : ℝ) *
            ρ ^ (j + 1)) * t ^ (j + 1) :=
        mul_le_mul_of_nonneg_right
          (hsymm_aeval_complex_norm_le_choose a (j + 1) ρ hρ0 hρ)
          (pow_nonneg ht0 _)
      _ = (Nat.choose (j + 1 + q) q : ℝ) * r ^ (j + 1) := by
        rw [hchoose]
        simp only [r, mul_pow]
        ring
  have hnorm : Summable (fun j : ℕ =>
      ‖MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ (j + 1))‖ * t ^ (j + 1)) := by
    apply Summable.of_nonneg_of_le _ hterm hmajorTail
    intro j
    exact mul_nonneg (norm_nonneg _) (pow_nonneg ht0 _)
  calc
    (∑' j : ℕ,
       ‖MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ (j + 1))‖ * t ^ (j + 1)) ≤
       (∑' j : ℕ, (Nat.choose (j + 1 + q) q : ℝ) * r ^ (j + 1)) :=
      hnorm.tsum_le_tsum hterm hmajorTail
    _ = 1 / (1 - r) ^ (q + 1) - 1 :=
      negative_binomial_positive_tail_tsum q r hr0 hradius
    _ = 1 / (1 - ρ * t) ^ Fintype.card ι - 1 := by
      rw [hq]

end D1Bound5
