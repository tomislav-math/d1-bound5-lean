import D1Bound5.HalfBinomialConvolutionAbs
import Mathlib.Analysis.Complex.Basic

open Finset

namespace D1Bound5

/-- The degree-n coefficient in the product of the two formal half-binomial
series with complex variables x and y. -/
noncomputable def halfBinomialWeightedCoeff (x y : ℂ) (n : ℕ) : ℂ :=
  ∑ ij ∈ Finset.antidiagonal n,
    ((halfBinomialCoeff ij.1 * halfBinomialCoeff ij.2 : ℝ) : ℂ) *
      x ^ ij.1 * y ^ ij.2

/-- The sharp real absolute convolution implies a uniform complex coefficient
bound, without assuming x=y or positivity of either complex variable. -/
theorem halfBinomialWeightedCoeff_norm_le
    (x y : ℂ) (t : ℝ) (ht : 0 ≤ t)
    (hx : ‖x‖ ≤ t) (hy : ‖y‖ ≤ t)
    (n : ℕ) (hn : 2 ≤ n) :
    ‖halfBinomialWeightedCoeff x y n‖ ≤
      4 * |halfBinomialCoeff n| * t ^ n := by
  unfold halfBinomialWeightedCoeff
  have hterm (ij : ℕ × ℕ) (hij : ij ∈ Finset.antidiagonal n) :
      ‖((halfBinomialCoeff ij.1 * halfBinomialCoeff ij.2 : ℝ) : ℂ) *
        x ^ ij.1 * y ^ ij.2‖ ≤
      |halfBinomialCoeff ij.1 * halfBinomialCoeff ij.2| * t ^ n := by
    have hsum : ij.1 + ij.2 = n := Finset.mem_antidiagonal.mp hij
    calc
      ‖((halfBinomialCoeff ij.1 * halfBinomialCoeff ij.2 : ℝ) : ℂ) *
          x ^ ij.1 * y ^ ij.2‖ =
        |halfBinomialCoeff ij.1 * halfBinomialCoeff ij.2| *
          ‖x‖ ^ ij.1 * ‖y‖ ^ ij.2 := by
            simp [Real.norm_eq_abs]
      _ ≤ |halfBinomialCoeff ij.1 * halfBinomialCoeff ij.2| *
          t ^ ij.1 * t ^ ij.2 := by
            gcongr
      _ = |halfBinomialCoeff ij.1 * halfBinomialCoeff ij.2| * t ^ n := by
            rw [mul_assoc, ← pow_add, hsum]
  calc
    ‖∑ ij ∈ Finset.antidiagonal n,
        ((halfBinomialCoeff ij.1 * halfBinomialCoeff ij.2 : ℝ) : ℂ) *
          x ^ ij.1 * y ^ ij.2‖ ≤
      ∑ ij ∈ Finset.antidiagonal n,
        ‖((halfBinomialCoeff ij.1 * halfBinomialCoeff ij.2 : ℝ) : ℂ) *
          x ^ ij.1 * y ^ ij.2‖ := norm_sum_le _ _
    _ ≤ ∑ ij ∈ Finset.antidiagonal n,
        |halfBinomialCoeff ij.1 * halfBinomialCoeff ij.2| * t ^ n := by
          exact Finset.sum_le_sum (fun ij hij => hterm ij hij)
    _ = (∑ ij ∈ Finset.antidiagonal n,
        |halfBinomialCoeff ij.1 * halfBinomialCoeff ij.2|) * t ^ n := by
          rw [Finset.sum_mul]
    _ = 4 * |halfBinomialCoeff n| * t ^ n := by
          rw [halfBinomialCoeff_abs_convolution n hn]

/-- The monotonicity of the half-binomial coefficients gives one fixed
envelope for every degree at least m+1, when m is positive. -/
theorem halfBinomialWeightedCoeff_tail_norm_le
    (x y : ℂ) (t : ℝ) (ht : 0 ≤ t)
    (hx : ‖x‖ ≤ t) (hy : ‖y‖ ≤ t)
    (m n : ℕ) (hm : 1 ≤ m) (hn : m + 1 ≤ n) :
    ‖halfBinomialWeightedCoeff x y n‖ ≤
      4 * |halfBinomialCoeff (m + 1)| * t ^ n := by
  have hn2 : 2 ≤ n := by omega
  have hb : |halfBinomialCoeff n| ≤ |halfBinomialCoeff (m + 1)| :=
    halfBinomialCoeff_abs_antitone (by omega) hn
  calc
    ‖halfBinomialWeightedCoeff x y n‖ ≤
      4 * |halfBinomialCoeff n| * t ^ n :=
        halfBinomialWeightedCoeff_norm_le x y t ht hx hy n hn2
    _ ≤ 4 * |halfBinomialCoeff (m + 1)| * t ^ n := by
        exact mul_le_mul_of_nonneg_right
          (mul_le_mul_of_nonneg_left hb (by norm_num))
          (pow_nonneg ht _)

/-- The actual complex half-binomial convolution satisfies the complete
weighted-homogeneous tail bound. The coefficient envelope is proved here,
rather than inserted as an independent hypothesis. -/
theorem coherent_half_binomial_tail_summable_and_norm_le
    {ι : Type*} [Fintype ι] [DecidableEq ι] [Nonempty ι]
    (a : ι → ℂ) (x y : ℂ) (m : ℕ) (ρ t : ℝ)
    (hm : 1 ≤ m) (hρ0 : 0 ≤ ρ) (ht : 0 ≤ t)
    (ha : ∀ i, ‖a i‖ ≤ ρ)
    (hx : ‖x‖ ≤ t) (hy : ‖y‖ ≤ t)
    (hradius : ρ * t < 1) :
    Summable (fun j : ℕ => halfBinomialWeightedCoeff x y (m + (j + 1)) *
      MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ (j + 1))) ∧
    ‖∑' j : ℕ, halfBinomialWeightedCoeff x y (m + (j + 1)) *
      MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ (j + 1))‖ ≤
      (4 * |halfBinomialCoeff (m + 1)|) * t ^ m *
        (1 / (1 - ρ * t) ^ Fintype.card ι - 1) := by
  have hcoeff (j : ℕ) :
      ‖halfBinomialWeightedCoeff x y (m + (j + 1))‖ ≤
        (4 * |halfBinomialCoeff (m + 1)|) * t ^ (m + (j + 1)) := by
    exact halfBinomialWeightedCoeff_tail_norm_le
      x y t ht hx hy m (m + (j + 1)) hm (by omega)
  exact coherent_weighted_remainder_summable_and_norm_le
    a (halfBinomialWeightedCoeff x y) m
      (4 * |halfBinomialCoeff (m + 1)|) ρ t
      (mul_nonneg (by norm_num) (abs_nonneg _)) hρ0 ht ha hradius hcoeff

end D1Bound5

#check @D1Bound5.halfBinomialWeightedCoeff_norm_le
#check @D1Bound5.halfBinomialWeightedCoeff_tail_norm_le
#print axioms D1Bound5.halfBinomialWeightedCoeff_norm_le
#print axioms D1Bound5.halfBinomialWeightedCoeff_tail_norm_le
#check @D1Bound5.coherent_half_binomial_tail_summable_and_norm_le
#print axioms D1Bound5.coherent_half_binomial_tail_summable_and_norm_le
