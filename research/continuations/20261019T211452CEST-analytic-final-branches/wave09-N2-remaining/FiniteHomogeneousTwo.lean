import Mathlib.Analysis.Normed.Ring.Basic
import Mathlib.Analysis.Complex.Basic
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic.GCongr
import Mathlib.Tactic.Ring
import Lean.Elab.Tactic.Omega

namespace D1Bound5

/-- An explicit integer homogeneous polynomial in two anchors. -/
def finiteHomogeneousTwo {R : Type*} [CommRing R]
    (n : ℕ) (v : Fin (n+1) → ℤ) (x y : R) : R :=
  ∑ j, (v j : R)*x^(j : ℕ)*y^(n-(j : ℕ))

/-- The usual coefficient sum bounds the actual homogeneous polynomial.
No coefficient or polynomial-height certificate is assumed. -/
theorem finiteHomogeneousTwo_norm_le (n : ℕ) (v : Fin (n+1) → ℤ)
    (x y : ℂ) (hxy : ‖x‖ ≤ ‖y‖) :
    ‖finiteHomogeneousTwo n v x y‖ ≤
      (∑ j, |(v j : ℝ)|)*‖y‖^n := by
  unfold finiteHomogeneousTwo
  calc
    _ ≤ ∑ j, ‖(v j : ℂ)*x^(j : ℕ)*y^(n-(j : ℕ))‖ := norm_sum_le _ _
    _ ≤ ∑ j, |(v j : ℝ)| *‖y‖^n := by
      apply Finset.sum_le_sum
      intro j _
      have hj : (j : ℕ) ≤ n := by omega
      have hsum : (j : ℕ)+(n-(j : ℕ)) = n := by omega
      have hnorm : ‖(v j : ℂ)‖ = |(v j : ℝ)| := by simp
      rw [norm_mul, norm_mul, norm_pow, norm_pow, hnorm]
      calc
        _ ≤ |(v j : ℝ)| *‖y‖^(j : ℕ)*‖y‖^(n-(j : ℕ)) := by gcongr
        _ = _ := by rw [mul_assoc, ← pow_add, hsum]
    _ = _ := by rw [Finset.sum_mul]

theorem finite_norm_quadratic_le (u v w c : ℂ) :
    ‖u+v*c+w*c^2‖ ≤ ‖u‖+‖v‖*‖c‖+‖w‖*‖c‖^2 := by
  calc
    _ ≤ ‖u+v*c‖+‖w*c^2‖ := norm_add_le _ _
    _ ≤ (‖u‖+‖v*c‖)+‖w*c^2‖ := add_le_add (norm_add_le _ _) le_rfl
    _ = _ := by rw [norm_mul, norm_mul, norm_pow]

end D1Bound5
