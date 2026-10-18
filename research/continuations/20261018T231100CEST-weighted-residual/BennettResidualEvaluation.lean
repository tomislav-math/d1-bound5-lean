import D1Bound5.BennettResidualCancellation
import Mathlib.Analysis.Analytic.Binomial
import Mathlib.Analysis.Normed.Ring.InfiniteSum
import Mathlib.Tactic.Ring
import Lean.Elab.Tactic.Omega

open Finset

namespace D1Bound5

/-- Multiplication by a polynomial commutes with analytic summation of a
power series.  Absolute summability makes the Cauchy-product step explicit. -/
theorem bennett_polynomial_series_hasSum (P : Polynomial ℂ) (B : PowerSeries ℂ)
    (x b : ℂ)
    (hB : HasSum (fun r : ℕ => PowerSeries.coeff r B * x ^ r) b)
    (hBnorm : Summable (fun r : ℕ => ‖PowerSeries.coeff r B * x ^ r‖)) :
    HasSum (fun r : ℕ => PowerSeries.coeff r ((P : PowerSeries ℂ) * B) * x ^ r)
      (P.eval x * b) := by
  have hpzero (r : ℕ) (hr : r ∉ P.support) : P.coeff r * x ^ r = 0 := by
    rw [Polynomial.notMem_support_iff.mp hr, zero_mul]
  have hp : HasSum (fun r : ℕ => P.coeff r * x ^ r) (P.eval x) := by
    simpa only [Polynomial.eval_eq_sum, Polynomial.sum] using
      (hasSum_sum_of_ne_finset_zero (s := P.support) hpzero)
  have hpNorm : Summable (fun r : ℕ => ‖P.coeff r * x ^ r‖) := by
    apply summable_of_ne_finset_zero (s := P.support)
    intro r hr
    rw [hpzero r hr, norm_zero]
  have hc (r : ℕ) :
      PowerSeries.coeff r ((P : PowerSeries ℂ) * B) * x ^ r =
        ∑ uv ∈ antidiagonal r,
          (P.coeff uv.1 * x ^ uv.1) * (PowerSeries.coeff uv.2 B * x ^ uv.2) := by
    rw [PowerSeries.coeff_mul, Finset.sum_mul]
    apply Finset.sum_congr rfl
    intro uv huv
    rw [Polynomial.coeff_coe, ← Finset.mem_antidiagonal.mp huv, pow_add]
    ring
  have hconv :=
    summable_norm_sum_mul_antidiagonal_of_summable_norm hpNorm hBnorm
  have heq := tsum_mul_tsum_eq_tsum_sum_antidiagonal_of_summable_norm hpNorm hBnorm
  rw [hp.tsum_eq, hB.tsum_eq] at heq
  have hh := hconv.of_norm.hasSum
  rw [← heq] at hh
  simpa only [hc] using hh

/-- The rescaled formal binomial series evaluates to the principal complex
power in the unit disk, with absolute summability. -/
theorem bennett_rescaled_binomial_hasSum (a ν x : ℂ) (hx : ‖a * x‖ < 1) :
    HasSum (fun r : ℕ =>
      PowerSeries.coeff r (PowerSeries.rescale a (PowerSeries.binomialSeries ℂ ν)) *
        x ^ r) ((1 + a * x) ^ ν) ∧
    Summable (fun r : ℕ =>
      ‖PowerSeries.coeff r
        (PowerSeries.rescale a (PowerSeries.binomialSeries ℂ ν)) * x ^ r‖) := by
  have hxball : a * x ∈ Metric.eball (0 : ℂ) 1 := by
    rw [← ENNReal.ofReal_one, Metric.eball_ofReal]
    simpa only [Metric.mem_ball, dist_eq_norm, sub_zero] using hx
  have hseries := Complex.one_add_cpow_hasFPowerSeriesOnBall_zero (a := ν)
  have hs := hseries.hasSum_sub hxball
  have hxrad : a * x ∈ Metric.eball (0 : ℂ) (binomialSeries ℂ ν).radius :=
    lt_of_lt_of_le hxball hseries.r_le
  have hnorm := (binomialSeries ℂ ν).summable_norm_apply hxrad
  have hc (r : ℕ) :
      PowerSeries.coeff r (PowerSeries.rescale a (PowerSeries.binomialSeries ℂ ν)) *
        x ^ r = Ring.choose ν r * (a * x) ^ r := by
    simp only [PowerSeries.coeff_rescale, PowerSeries.binomialSeries_coeff,
      smul_eq_mul, mul_one, mul_pow]
    ring
  constructor
  · simpa only [hc, sub_zero, binomialSeries,
      FormalMultilinearSeries.ofScalars_apply_eq, smul_eq_mul, mul_comm] using hs
  · simpa only [hc, binomialSeries, FormalMultilinearSeries.ofScalars_apply_eq,
      smul_eq_mul, mul_comm] using hnorm

section Nodes

variable {I : Type*} [Fintype I] [DecidableEq I]

/-- The actual finite row of residue polynomials times the complex powers is
the sum of its actual formal coefficients. No residual identity is assumed. -/
theorem bennettPolynomialResidue_residual_hasSum
    (a : I → ℂ) (k : ℕ) (ν x : ℂ) (i : I)
    (hx : ∀ j, ‖a j * x‖ < 1) :
    HasSum (fun r : ℕ => PowerSeries.coeff r
      (∑ j, (bennettPolynomialResidue univ a k ν i j : PowerSeries ℂ) *
        PowerSeries.rescale (a j) (PowerSeries.binomialSeries ℂ ν)) * x ^ r)
      (∑ j, (bennettPolynomialResidue univ a k ν i j).eval x *
        (1 + a j * x) ^ ν) := by
  have hh (j : I) : HasSum (fun r : ℕ => PowerSeries.coeff r
      ((bennettPolynomialResidue univ a k ν i j : PowerSeries ℂ) *
        PowerSeries.rescale (a j) (PowerSeries.binomialSeries ℂ ν)) * x ^ r)
      ((bennettPolynomialResidue univ a k ν i j).eval x * (1 + a j * x) ^ ν) := by
    obtain ⟨hs, hn⟩ := bennett_rescaled_binomial_hasSum (a j) ν x (hx j)
    exact bennett_polynomial_series_hasSum _ _ _ _ hs hn
  simpa only [map_sum, Finset.sum_mul] using
    (hasSum_sum (s := (univ : Finset I)) (fun j _ => hh j))

/-- Arbitrary coefficients of the genuine residual are local residue moments.
This extends the low-degree cancellation identity to the high-degree tail. -/
theorem bennettPolynomialResidue_residual_coeff_eq_moment
    {F : Type*} [Field F] [CharZero F]
    (a : I → F) (k : ℕ) (hk : 1 ≤ k) (ν : F) (i : I) (r : ℕ) :
    PowerSeries.coeff r
      (∑ j, (bennettPolynomialResidue univ a k ν i j : PowerSeries F) *
        PowerSeries.rescale (a j) (PowerSeries.binomialSeries F ν)) =
      Ring.choose ((k : F) + ν) r *
        ∑ j, bennettLocalResidue a
          (fun l => k + (if i = l then 1 else 0) - 1) (Polynomial.X ^ r) j := by
  let e : I → ℕ := fun l => k + (if i = l then 1 else 0) - 1
  have he (l : I) : e l + 1 = k + (if i = l then 1 else 0) := by
    dsimp [e]
    split_ifs <;> omega
  have he_le (j : I) : e j ≤ k := by
    dsimp [e]
    split_ifs <;> omega
  have hB (j : I) : bennettOtherPoles univ a k i j =
      bennettLocalReciprocal a e j := by
    unfold bennettOtherPoles bennettLocalReciprocal
    simp_rw [he]
  have hshift (j : I) :
      bennettShiftToSeries (a j) (Polynomial.X ^ r) =
        (PowerSeries.C (a j) + PowerSeries.X) ^ r := by
    simp [bennettShiftToSeries]
  rw [map_sum, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j hj
  change PowerSeries.coeff r
    ((bennettResidueTaylor k (e j) ν (a j)
      (bennettOtherPoles univ a k i j) : PowerSeries F) *
        PowerSeries.rescale (a j) (PowerSeries.binomialSeries F ν)) = _
  rw [bennettResidueTaylor_coeff_mul_binomial k (e j) r (he_le j)]
  simp only [bennettLocalResidue, hshift, hB, e]

/-- After the proved cancellation, the actual analytic residual is exactly
the high-degree residue-moment tail. -/
theorem bennettPolynomialResidue_residual_tail_hasSum
    (a : I → ℂ) (ha : Function.Injective a) (k : ℕ) (hk : 1 ≤ k)
    (ν x : ℂ) (i : I) (hx : ∀ j, ‖a j * x‖ < 1) :
    HasSum (fun t : ℕ =>
      (Ring.choose ((k : ℂ) + ν) (Fintype.card I * k + t) *
        ∑ j, bennettLocalResidue a
          (fun l => k + (if i = l then 1 else 0) - 1)
          (Polynomial.X ^ (Fintype.card I * k + t)) j) *
            x ^ (Fintype.card I * k + t))
      (∑ j, (bennettPolynomialResidue univ a k ν i j).eval x *
        (1 + a j * x) ^ ν) := by
  let R : PowerSeries ℂ :=
    ∑ j, (bennettPolynomialResidue univ a k ν i j : PowerSeries ℂ) *
      PowerSeries.rescale (a j) (PowerSeries.binomialSeries ℂ ν)
  have hzero : (∑ r ∈ range (Fintype.card I * k),
      PowerSeries.coeff r R * x ^ r) = 0 := by
    apply Finset.sum_eq_zero
    intro r hr
    rw [show PowerSeries.coeff r R = 0 from
      bennettPolynomialResidue_residual_coeff_zero a ha k hk ν i r
        (Finset.mem_range.mp hr), zero_mul]
  have htail : HasSum (fun t : ℕ =>
      PowerSeries.coeff (t + Fintype.card I * k) R * x ^ (t + Fintype.card I * k))
      (∑ j, (bennettPolynomialResidue univ a k ν i j).eval x *
        (1 + a j * x) ^ ν) := by
    apply (hasSum_nat_add_iff
      (f := fun r : ℕ => PowerSeries.coeff r R * x ^ r) (Fintype.card I * k)).mpr
    rw [hzero, add_zero]
    exact bennettPolynomialResidue_residual_hasSum a k ν x i hx
  simpa only [R, Nat.add_comm,
    bennettPolynomialResidue_residual_coeff_eq_moment a k hk ν i] using htail

end Nodes

end D1Bound5
