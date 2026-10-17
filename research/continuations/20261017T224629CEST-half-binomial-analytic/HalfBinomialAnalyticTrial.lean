import D1Bound5.HalfBinomialCoefficients
import Mathlib.Analysis.Analytic.Binomial

namespace D1Bound5

/-- The half-binomial coefficients sum to the complex principal power
of exponent one half throughout the open unit disk. -/
theorem halfBinomialCoeff_hasSum_cpow (z : ℂ) (hz : ‖z‖ < 1) :
    HasSum (fun n : ℕ => (halfBinomialCoeff n : ℂ) * z ^ n)
      ((1 + z) ^ (1 / 2 : ℂ)) := by
  have hzball : z ∈ Metric.eball (0 : ℂ) 1 := by
    rw [← ENNReal.ofReal_one, Metric.eball_ofReal]
    simpa [Metric.mem_ball, dist_eq_norm] using hz
  have hs := (Complex.one_add_cpow_hasFPowerSeriesOnBall_zero
    (a := (1 / 2 : ℂ))).hasSum_sub hzball
  simpa [binomialSeries, FormalMultilinearSeries.ofScalars_apply_eq,
    halfBinomialCoeff, Complex.ofReal_choose, smul_eq_mul, mul_comm] using hs

/-- The full Cauchy product of the two half-binomial series converges
absolutely to the product of their principal complex powers. -/
theorem halfBinomialCoeff_cauchy_hasSum (x y z : ℂ)
    (hx : ‖x * z‖ < 1) (hy : ‖y * z‖ < 1) :
    HasSum (fun n : ℕ => ∑ ij ∈ Finset.antidiagonal n,
      ((halfBinomialCoeff ij.1 : ℂ) * (x * z) ^ ij.1) *
      ((halfBinomialCoeff ij.2 : ℂ) * (y * z) ^ ij.2))
      (((1 + x * z) ^ (1 / 2 : ℂ)) * ((1 + y * z) ^ (1 / 2 : ℂ))) := by
  have hsx := halfBinomialCoeff_hasSum_cpow (x * z) hx
  have hsy := halfBinomialCoeff_hasSum_cpow (y * z) hy
  have hnx := hsx.summable.norm
  have hny := hsy.summable.norm
  have hs := summable_norm_sum_mul_antidiagonal_of_summable_norm hnx hny
  have hprod := tsum_mul_tsum_eq_tsum_sum_antidiagonal_of_summable_norm hnx hny
  rw [hsx.tsum_eq, hsy.tsum_eq] at hprod
  rw [hprod]
  exact hs.of_norm.hasSum

/-- Reassociation of the Cauchy coefficients into genuine homogeneous
polynomial coefficients, using only the antidiagonal degree equation. -/
theorem halfBinomialCoeff_cauchy_rearrange (x y z : ℂ) (n : ℕ) :
    (∑ ij ∈ Finset.antidiagonal n,
      ((halfBinomialCoeff ij.1 : ℂ) * (x * z) ^ ij.1) *
        ((halfBinomialCoeff ij.2 : ℂ) * (y * z) ^ ij.2)) =
    (∑ ij ∈ Finset.antidiagonal n,
      ((halfBinomialCoeff ij.1 * halfBinomialCoeff ij.2 : ℝ) : ℂ) *
        x ^ ij.1 * y ^ ij.2) * z ^ n := by
  rw [Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro ij hij
  have hdegree : ij.1 + ij.2 = n := Finset.mem_antidiagonal.mp hij
  calc
    ((halfBinomialCoeff ij.1 : ℂ) * (x * z) ^ ij.1) *
        ((halfBinomialCoeff ij.2 : ℂ) * (y * z) ^ ij.2) =
      ((halfBinomialCoeff ij.1 * halfBinomialCoeff ij.2 : ℝ) : ℂ) *
        x ^ ij.1 * y ^ ij.2 * z ^ (ij.1 + ij.2) := by
          simp only [mul_pow, pow_add, Complex.ofReal_mul]
          ring
    _ = _ := by rw [hdegree]

/-- Exact convergence of the weighted two-variable half-binomial series
to the corresponding product of complex square-root powers. -/
theorem halfBinomialCoeff_weighted_hasSum (x y z : ℂ)
    (hx : ‖x * z‖ < 1) (hy : ‖y * z‖ < 1) :
    HasSum (fun n : ℕ =>
      (∑ ij ∈ Finset.antidiagonal n,
        ((halfBinomialCoeff ij.1 * halfBinomialCoeff ij.2 : ℝ) : ℂ) *
          x ^ ij.1 * y ^ ij.2) * z ^ n)
      (((1 + x * z) ^ (1 / 2 : ℂ)) * ((1 + y * z) ^ (1 / 2 : ℂ))) := by
  convert halfBinomialCoeff_cauchy_hasSum x y z hx hy using 1
  ext n
  exact (halfBinomialCoeff_cauchy_rearrange x y z n).symm

end D1Bound5

#check @D1Bound5.halfBinomialCoeff_hasSum_cpow
#print axioms D1Bound5.halfBinomialCoeff_hasSum_cpow
