import D1Bound5.FinitePolynomialHeight

namespace D1Bound5

def finiteHomogeneousRatioWeight (n : ℕ) (v : Fin (n+1) → ℤ) (r : ℝ) : ℝ :=
  ∑ j, |(v j : ℝ)|*r^(j : ℕ)

theorem finiteHomogeneousRatioWeight_nonneg (n : ℕ) (v : Fin (n+1) → ℤ)
    (r : ℝ) (hr : 0 ≤ r) : 0 ≤ finiteHomogeneousRatioWeight n v r := by
  exact Finset.sum_nonneg (fun j _ => mul_nonneg (abs_nonneg _) (pow_nonneg hr _))

/-- Retain the exact first-anchor ratio in each actual homogeneous
coefficient polynomial, instead of replacing both anchor moduli by B. -/
theorem finiteHomogeneousTwo_norm_le_ratio (n : ℕ) (v : Fin (n+1) → ℤ)
    (x y : ℂ) (r : ℝ) (hr : 0 ≤ r) (hxy : ‖x‖ ≤ r*‖y‖) :
    ‖finiteHomogeneousTwo n v x y‖ ≤ finiteHomogeneousRatioWeight n v r*‖y‖^n := by
  unfold finiteHomogeneousTwo
  calc
    _ ≤ ∑ j, ‖(v j : ℂ)*x^(j : ℕ)*y^(n-(j : ℕ))‖ := norm_sum_le _ _
    _ ≤ ∑ j, |(v j : ℝ)|*r^(j : ℕ)*‖y‖^n := by
      apply Finset.sum_le_sum
      intro j _
      have hj : (j : ℕ) ≤ n := by omega
      have hsum : (j : ℕ)+(n-(j : ℕ)) = n := by omega
      have hnorm : ‖(v j : ℂ)‖ = |(v j : ℝ)| := by simp
      rw [norm_mul,norm_mul,norm_pow,norm_pow,hnorm]
      calc
        _ ≤ |(v j : ℝ)|*(r*‖y‖)^(j : ℕ)*‖y‖^(n-(j : ℕ)) := by gcongr
        _ = _ := by rw [mul_pow]; rw [mul_assoc,mul_assoc,← pow_add,hsum]; ring
    _ = _ := by rw [Finset.sum_mul]; rfl

/-- Exact reciprocal q for the five unbounded first-pair regions. -/
def fiveRegionAnchorRatio : Fin 5 → ℝ := ![1/8,3/8,7/12,2/3,17/18]

theorem fiveRegionAnchorRatio_nonneg (r : Fin 5) : 0 ≤ fiveRegionAnchorRatio r := by
  fin_cases r <;> norm_num [fiveRegionAnchorRatio]

theorem fiveRegionAnchorRatio_le_one (r : Fin 5) : fiveRegionAnchorRatio r ≤ 1 := by
  fin_cases r <;> norm_num [fiveRegionAnchorRatio]

end D1Bound5
