import D1Bound5.ComplexHsymmNorm
import Mathlib.Analysis.SpecificLimits.Normed

open Finset

namespace D1Bound5

/-- The complete homogeneous generating series converges absolutely inside
its common radius disk, for a nonempty finite complex alphabet. The proof
uses the exact combinatorial norm majorant and the negative-binomial
summability theorem, without assuming that the nodes are distinct. -/
theorem hsymm_aeval_complex_summable
    {ι : Type*} [Fintype ι] [DecidableEq ι] [Nonempty ι]
    (a : ι → ℂ) (z : ℂ) (ρ : ℝ)
    (hρ0 : 0 ≤ ρ) (hρ : ∀ i, ‖a i‖ ≤ ρ)
    (hradius : ρ * ‖z‖ < 1) :
    Summable (fun k : ℕ => z ^ k *
      MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ k)) := by
  let q : ℕ := Fintype.card ι - 1
  let r : ℝ := ρ * ‖z‖
  have hq : q + 1 = Fintype.card ι := Nat.succ_pred_eq_of_pos Fintype.card_pos
  have hr0 : 0 ≤ r := mul_nonneg hρ0 (norm_nonneg z)
  have hr : ‖r‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_nonneg hr0]
    exact hradius
  have hmajor : Summable (fun k : ℕ =>
      (Nat.choose (k + q) q : ℝ) * r ^ k) :=
    summable_choose_mul_geometric_of_norm_lt_one q hr
  apply Summable.of_norm_bounded hmajor
  intro k
  have hchoose : Nat.choose (Fintype.card ι + k - 1) k =
      Nat.choose (k + q) q := by
    have heq : Fintype.card ι + k - 1 = k + q := by omega
    rw [heq]
    exact Nat.choose_symm_add
  calc
    ‖z ^ k * MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ k)‖ =
        ‖z‖ ^ k * ‖MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ k)‖ := by
          rw [norm_mul, norm_pow]
    _ ≤ ‖z‖ ^ k * ((Nat.choose (Fintype.card ι + k - 1) k : ℝ) * ρ ^ k) :=
      mul_le_mul_of_nonneg_left
        (hsymm_aeval_complex_norm_le_choose a k ρ hρ0 hρ)
        (pow_nonneg (norm_nonneg z) k)
    _ = (Nat.choose (k + q) q : ℝ) * r ^ k := by
      rw [hchoose]
      simp only [r, mul_pow]
      ring

end D1Bound5

#check @D1Bound5.hsymm_aeval_complex_summable
#print axioms D1Bound5.hsymm_aeval_complex_summable
