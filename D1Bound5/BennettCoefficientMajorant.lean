import D1Bound5.BennettClearedResidues
import D1Bound5.BennettBinomialTransfer
import Mathlib.Analysis.Complex.Basic
import Mathlib.Analysis.Normed.Ring.InfiniteSum
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

open Finset

namespace D1Bound5

private theorem bennett_real_factorial_mul_choose (s : ℝ) (h : ℕ) :
    (h.factorial : ℝ) * Ring.choose s h = (descPochhammer ℝ h).eval s := by
  have heq : (descPochhammer ℤ h).smeval s =
      (descPochhammer ℝ h).eval s := by
    rw [Polynomial.descPochhammer_smeval_eq_ascPochhammer,
      Polynomial.ascPochhammer_smeval_eq_eval,
      descPochhammer_eval_eq_ascPochhammer]
  have hh := Ring.descPochhammer_eq_factorial_smul_choose s h
  rw [heq, nsmul_eq_mul] at hh
  exact hh.symm

/-- All coefficients used by the local Taylor residue lie before the first
sign change. An ordinary degree-(k+1) binomial dominates them coefficientwise.
The small extra factor will be absorbed by the manuscript's rounding to H2. -/
theorem bennett_shifted_half_choose_abs_le (k h : ℕ) (hh : h ≤ k) :
    |Ring.choose ((k : ℝ) + 1 / 2) h| ≤ (Nat.choose (k + 1) h : ℝ) := by
  have hh' : (h : ℝ) ≤ k := by exact_mod_cast hh
  have hlow : (h : ℝ) - 1 ≤ (k : ℝ) + 1 / 2 := by linarith
  have hhigh : (h : ℝ) - 1 ≤ ((k + 1 : ℕ) : ℝ) := by push_cast; linarith
  have hupper : (k : ℝ) + 1 / 2 ≤ ((k + 1 : ℕ) : ℝ) := by push_cast; linarith
  have hf : 0 < (h.factorial : ℝ) := by positivity
  have hnonneg := descPochhammer_nonneg hlow
  rw [← bennett_real_factorial_mul_choose] at hnonneg
  have hc : 0 ≤ Ring.choose ((k : ℝ) + 1 / 2) h := by nlinarith
  have hmono := (monotoneOn_descPochhammer_eval h) hlow hhigh hupper
  dsimp only at hmono
  rw [← bennett_real_factorial_mul_choose, ← bennett_real_factorial_mul_choose,
    Ring.choose_natCast] at hmono
  rw [abs_of_nonneg hc]
  exact (mul_le_mul_iff_of_pos_left hf).mp hmono

/-- Norm coefficient majorants multiply by the actual Cauchy product. -/
theorem bennett_coeff_mul_norm_le
    (B C : PowerSeries ℂ) (D E : PowerSeries ℝ)
    (hB : ∀ h, ‖PowerSeries.coeff h B‖ ≤ PowerSeries.coeff h D)
    (hC : ∀ h, ‖PowerSeries.coeff h C‖ ≤ PowerSeries.coeff h E) (t : ℕ) :
    ‖PowerSeries.coeff t (B * C)‖ ≤ PowerSeries.coeff t (D * E) := by
  rw [PowerSeries.coeff_mul, PowerSeries.coeff_mul]
  calc
    _ ≤ ∑ hu ∈ antidiagonal t,
      ‖PowerSeries.coeff hu.1 B * PowerSeries.coeff hu.2 C‖ := norm_sum_le _ _
    _ ≤ _ := by
      apply Finset.sum_le_sum
      intro hu hhu
      rw [norm_mul]
      exact mul_le_mul (hB hu.1) (hC hu.2) (norm_nonneg _)
        ((norm_nonneg _).trans (hB hu.1))

/-- Positive numerator majorant for every local coefficient of order at most k. -/
noncomputable def bennettNumeratorMajorant (U : ℝ) (k : ℕ) : PowerSeries ℝ :=
  PowerSeries.C U⁻¹ * (PowerSeries.C U + PowerSeries.X) ^ (k + 1)

theorem bennettNumeratorMajorant_coeff (U : ℝ) (hU : U ≠ 0)
    (k h : ℕ) (hh : h ≤ k) :
    PowerSeries.coeff h (bennettNumeratorMajorant U k) =
      (Nat.choose (k + 1) h : ℝ) * U ^ (k - h) := by
  rw [bennettNumeratorMajorant, PowerSeries.coeff_C_mul,
    bennettSeries_coeff_C_add_X_pow]
  have hexp : k + 1 - h = k - h + 1 := by omega
  rw [hexp, pow_succ]
  field_simp [hU]
  <;> ring

theorem bennettNumeratorMajorant_coeff_nonneg (U : ℝ) (hU : 0 < U) (k h : ℕ) :
    0 ≤ PowerSeries.coeff h (bennettNumeratorMajorant U k) := by
  rw [bennettNumeratorMajorant, PowerSeries.coeff_C_mul,
    bennettSeries_coeff_C_add_X_pow]
  positivity

/-- The finite numerator majorant has its ordinary polynomial value as sum. -/
theorem bennettNumeratorMajorant_hasSum (U r : ℝ) (k : ℕ) :
    HasSum (fun h : ℕ => PowerSeries.coeff h (bennettNumeratorMajorant U k) * r ^ h)
      ((U + r) ^ (k + 1) / U) := by
  let P : Polynomial ℝ := Polynomial.C U⁻¹ * (Polynomial.C U + Polynomial.X) ^ (k + 1)
  have hP : (P : PowerSeries ℝ) = bennettNumeratorMajorant U k := by
    simp [P, bennettNumeratorMajorant]
  have hpzero (h : ℕ) (hh : h ∉ P.support) : P.coeff h * r ^ h = 0 := by
    have hcoeff : P.coeff h = 0 := by
      simpa only [Polynomial.mem_support_iff, not_not] using hh
    rw [hcoeff, zero_mul]
  have hp : HasSum (fun h : ℕ => P.coeff h * r ^ h) (P.eval r) := by
    simpa only [Polynomial.eval_eq_sum, Polynomial.sum] using
      (hasSum_sum_of_ne_finset_zero (s := P.support) hpzero)
  have heval : P.eval r = (U + r) ^ (k + 1) / U := by simp [P, div_eq_mul_inv, mul_comm]
  simpa only [← hP, Polynomial.coeff_coe, heval] using hp

/-- The actual complex local residue Taylor expression is bounded by the
coefficient of the explicit positive numerator/pole majorant. -/
theorem bennettClearedTaylor_eval_norm_le_coeff
    (k t : ℕ) (ht : t ≤ k) (a N : ℂ)
    (B : PowerSeries ℂ) (D : PowerSeries ℝ)
    (hU : 0 < ‖N + a‖)
    (hB : ∀ h, ‖PowerSeries.coeff h B‖ ≤ PowerSeries.coeff h D) :
    ‖(bennettClearedTaylor k t (1 / 2 : ℂ) a B).eval N‖ ≤
      PowerSeries.coeff t (bennettNumeratorMajorant ‖N + a‖ k * D) := by
  unfold bennettClearedTaylor
  simp only [Polynomial.eval_finsetSum, Polynomial.eval_mul, Polynomial.eval_C,
    Polynomial.eval_pow, Polynomial.eval_add, Polynomial.eval_X]
  rw [PowerSeries.coeff_mul]
  calc
    _ ≤ ∑ hu ∈ antidiagonal t,
      ‖(Ring.choose ((k : ℂ) + 1 / 2) hu.1 * PowerSeries.coeff hu.2 B) *
        (N + a) ^ (k - hu.1)‖ := norm_sum_le _ _
    _ ≤ _ := by
      apply Finset.sum_le_sum
      intro hu hhu
      have hh : hu.1 ≤ k := by
        have hsum := Finset.mem_antidiagonal.mp hhu
        omega
      have hchoose : ‖Ring.choose ((k : ℂ) + 1 / 2) hu.1‖ ≤
          (Nat.choose (k + 1) hu.1 : ℝ) := by
        have hcast : Ring.choose ((k : ℂ) + 1 / 2) hu.1 =
            Complex.ofReal (Ring.choose ((k : ℝ) + 1 / 2) hu.1) := by
          simpa using
            (Ring.map_choose (algebraMap ℝ ℂ) ((k : ℝ) + 1 / 2) hu.1).symm
        rw [hcast, Complex.norm_real, Real.norm_eq_abs]
        exact bennett_shifted_half_choose_abs_le k hu.1 hh
      rw [norm_mul, norm_mul, norm_pow,
        bennettNumeratorMajorant_coeff _ hU.ne' k hu.1 hh]
      calc
        _ ≤ ((Nat.choose (k + 1) hu.1 : ℝ) * PowerSeries.coeff hu.2 D) *
            ‖N + a‖ ^ (k - hu.1) :=
          mul_le_mul_of_nonneg_right
            (mul_le_mul hchoose (hB hu.2) (norm_nonneg _) (Nat.cast_nonneg _))
            (pow_nonneg (norm_nonneg _) _)
        _ = _ := by ring

end D1Bound5
