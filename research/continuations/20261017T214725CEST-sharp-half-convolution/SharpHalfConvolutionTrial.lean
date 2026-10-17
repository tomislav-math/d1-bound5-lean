import D1Bound5.HalfBinomialCoefficients

open Finset

namespace D1Bound5

/-- The interior coefficients of the half-binomial convolution sum to twice
the negative endpoint coefficient. -/
theorem halfBinomialCoeff_interior_convolution (k : ℕ) :
    (∑ ij ∈ Finset.antidiagonal k,
      halfBinomialCoeff (ij.1 + 1) * halfBinomialCoeff (ij.2 + 1)) =
      -2 * halfBinomialCoeff (k + 2) := by
  have h := halfBinomialCoeff_convolution_zero (k + 2) (by omega)
  rw [show k + 2 = (k + 1) + 1 by omega,
      Finset.Nat.sum_antidiagonal_succ] at h
  rw [Finset.Nat.sum_antidiagonal_succ'] at h
  have hb0 : halfBinomialCoeff 0 = 1 := by
    simp [halfBinomialCoeff]
  simp only [hb0, one_mul, mul_one] at h
  linarith

/-- The sign of a positive-degree coefficient describes its absolute value. -/
theorem halfBinomialCoeff_abs_signed (k : ℕ) :
    |halfBinomialCoeff (k + 1)| =
      (-1 : ℝ) ^ k * halfBinomialCoeff (k + 1) := by
  calc
    |halfBinomialCoeff (k + 1)| =
        |(-1 : ℝ) ^ k * halfBinomialCoeff (k + 1)| := by
          simp [abs_mul]
    _ = _ := abs_of_nonneg (halfBinomialCoeff_signed_nonneg k)

/-- All products of positive-degree coefficients have the prescribed sign. -/
theorem halfBinomialCoeff_pair_abs_signed (i j : ℕ) :
    |halfBinomialCoeff (i + 1) * halfBinomialCoeff (j + 1)| =
       (-1 : ℝ) ^ (i + j + 2) *
         (halfBinomialCoeff (i + 1) * halfBinomialCoeff (j + 1)) := by
  calc
    |halfBinomialCoeff (i + 1) * halfBinomialCoeff (j + 1)| =
      |(-1 : ℝ) ^ (i + j + 2) *
          (halfBinomialCoeff (i + 1) * halfBinomialCoeff (j + 1))| := by
            simp [abs_mul]
    _ = _ := abs_of_nonneg (halfBinomialCoeff_signed_pair_nonneg i j)

/-- The interior absolute convolution is exactly twice the endpoint modulus. -/
theorem halfBinomialCoeff_interior_abs_sum (k : ℕ) :
    (∑ ij ∈ Finset.antidiagonal k,
      |halfBinomialCoeff (ij.1 + 1) * halfBinomialCoeff (ij.2 + 1)|) =
        2 * |halfBinomialCoeff (k + 2)| := by
  calc
    (∑ ij ∈ Finset.antidiagonal k,
      |halfBinomialCoeff (ij.1 + 1) * halfBinomialCoeff (ij.2 + 1)|) =
        (∑ ij ∈ Finset.antidiagonal k,
          (-1 : ℝ) ^ (k + 2) *
            (halfBinomialCoeff (ij.1 + 1) * halfBinomialCoeff (ij.2 + 1))) := by
          apply Finset.sum_congr rfl
          intro ij hij
          rw [halfBinomialCoeff_pair_abs_signed]
          have hsum : ij.1 + ij.2 = k := Finset.mem_antidiagonal.mp hij
          rw [hsum]
    _ = (-1 : ℝ) ^ (k + 2) *
          (∑ ij ∈ Finset.antidiagonal k,
            halfBinomialCoeff (ij.1 + 1) * halfBinomialCoeff (ij.2 + 1)) := by
          rw [Finset.mul_sum]
    _ = 2 * |halfBinomialCoeff (k + 2)| := by
          rw [halfBinomialCoeff_interior_convolution,
              halfBinomialCoeff_abs_signed (k + 1)]
          rw [show k + 2 = (k + 1) + 1 by omega, pow_succ]
          ring

/-- Sharp absolute half-binomial convolution, valid at every degree >= 2. -/
theorem halfBinomialCoeff_abs_convolution (n : ℕ) (hn : 2 ≤ n) :
    (∑ ij ∈ Finset.antidiagonal n,
      |halfBinomialCoeff ij.1 * halfBinomialCoeff ij.2|) =
        4 * |halfBinomialCoeff n| := by
  obtain ⟨k, rfl⟩ : ∃ k : ℕ, n = k + 2 := ⟨n - 2, by omega⟩
  rw [show k + 2 = (k + 1) + 1 by omega,
    Finset.Nat.sum_antidiagonal_succ,
    Finset.Nat.sum_antidiagonal_succ']
  have hb0 : halfBinomialCoeff 0 = 1 := by
    simp [halfBinomialCoeff]
  simp only [hb0, one_mul, mul_one]
  rw [halfBinomialCoeff_interior_abs_sum]
  ring

end D1Bound5

#check @D1Bound5.halfBinomialCoeff_abs_convolution
#print axioms D1Bound5.halfBinomialCoeff_abs_convolution
