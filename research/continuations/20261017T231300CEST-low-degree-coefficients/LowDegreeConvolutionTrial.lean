import D1Bound5.HalfBinomialCoefficients
import Mathlib.Algebra.BigOperators.NatAntidiagonal

open Finset

namespace D1Bound5

/-- The finite complex coefficient of degree n in the product of two
formal half-binomial power series. -/
private noncomputable def lowDegreeHalfCoefficient (x y : ℂ) (n : ℕ) : ℂ :=
  ∑ ij ∈ Finset.antidiagonal n,
    ((halfBinomialCoeff ij.1 * halfBinomialCoeff ij.2 : ℝ) : ℂ) *
      x ^ ij.1 * y ^ ij.2

private theorem halfCoeff_zero : halfBinomialCoeff 0 = 1 := by
  norm_num [halfBinomialCoeff]

private theorem halfCoeff_one : halfBinomialCoeff 1 = 1 / 2 := by
  norm_num [halfBinomialCoeff, Ring.choose_one_right]

private theorem halfCoeff_two : halfBinomialCoeff 2 = -1 / 8 := by
  have h := halfBinomialCoeff_recurrence 1
  norm_num [halfCoeff_one] at h
  linarith

private theorem halfCoeff_three : halfBinomialCoeff 3 = 1 / 16 := by
  have h := halfBinomialCoeff_recurrence 2
  norm_num [halfCoeff_two] at h
  linarith

private theorem halfCoeff_four : halfBinomialCoeff 4 = -5 / 128 := by
  have h := halfBinomialCoeff_recurrence 3
  norm_num [halfCoeff_three] at h
  linarith

/-- Frozen v4 equation (integrated-5), degree two. -/
theorem lowDegreeHalfCoefficient_two (x y : ℂ) :
    lowDegreeHalfCoefficient x y 2 = -(x - y)^2 / 8 := by
  norm_num [lowDegreeHalfCoefficient, Finset.antidiagonal,
    halfCoeff_zero, halfCoeff_one, halfCoeff_two]
  ring

/-- Frozen v4 equation (integrated-5), degree three. -/
theorem lowDegreeHalfCoefficient_three (x y : ℂ) :
    lowDegreeHalfCoefficient x y 3 = (x^2 - y^2) * (x-y) / 16 := by
  norm_num [lowDegreeHalfCoefficient, Finset.antidiagonal,
    halfCoeff_zero, halfCoeff_one, halfCoeff_two, halfCoeff_three]
  ring

/-- Frozen v4 equation (integrated-5), degree four. -/
theorem lowDegreeHalfCoefficient_four (x y : ℂ) :
    lowDegreeHalfCoefficient x y 4 =
      -(x-y)^2 * (5*x^2 + 6*x*y + 5*y^2) / 128 := by
  norm_num [lowDegreeHalfCoefficient, Finset.antidiagonal,
    halfCoeff_zero, halfCoeff_one, halfCoeff_two, halfCoeff_three, halfCoeff_four]
  ring

end D1Bound5

#check @D1Bound5.lowDegreeHalfCoefficient_two
#check @D1Bound5.lowDegreeHalfCoefficient_three
#check @D1Bound5.lowDegreeHalfCoefficient_four
#print axioms D1Bound5.lowDegreeHalfCoefficient_two
#print axioms D1Bound5.lowDegreeHalfCoefficient_three
#print axioms D1Bound5.lowDegreeHalfCoefficient_four
