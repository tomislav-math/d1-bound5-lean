import D1Bound5.FiniteQMatrix
import Mathlib.Analysis.Complex.Basic
import Mathlib.Tactic.GCongr
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.FinCases

namespace D1Bound5

/-- The actual two polynomial root weights have total height at most the
sum of their 36 absolute integer coefficients. -/
theorem finiteQ_pair_height
    (u v c : ℂ) (T C : ℝ) (hT : 0 ≤ T) (hC : 0 ≤ C)
    (hu : ‖u‖ ≤ T) (hv : ‖v‖ ≤ T) (hc : ‖c‖ ≤ C) (hTC : 1 ≤ T*C) :
    ‖finiteQLeft u v c‖ + ‖finiteQRight u v c‖ ≤ 36*T^3*C := by
  have hleft : ‖finiteQLeft u v c‖ ≤ 6*T^2+12*T^3*C := by
    calc
      _ ≤ ‖u^2-5*u*v‖ + ‖(4*u^3-8*u^2*v)*c‖ := norm_add_le _ _
      _ ≤ (‖u^2‖+‖5*u*v‖) + (‖4*u^3‖+‖8*u^2*v‖)*‖c‖ := by
        rw [norm_mul]
        exact add_le_add (norm_sub_le _ _)
          (mul_le_mul_of_nonneg_right (norm_sub_le _ _) (norm_nonneg _))
      _ = (‖u‖^2+5*‖u‖*‖v‖) + (4*‖u‖^3+8*‖u‖^2*‖v‖)*‖c‖ := by
        norm_num [norm_mul, norm_pow]
      _ ≤ (T^2+5*T*T)+(4*T^3+8*T^2*T)*C := by gcongr
      _ = _ := by ring
  have hright : ‖finiteQRight u v c‖ ≤ 6*T^2+12*T^3*C := by
    calc
      _ ≤ ‖5*u*v-v^2‖ + ‖(8*u*v^2-4*v^3)*c‖ := norm_add_le _ _
      _ ≤ (‖5*u*v‖+‖v^2‖) + (‖8*u*v^2‖+‖4*v^3‖)*‖c‖ := by
        rw [norm_mul]
        exact add_le_add (norm_sub_le _ _)
          (mul_le_mul_of_nonneg_right (norm_sub_le _ _) (norm_nonneg _))
      _ = (5*‖u‖*‖v‖+‖v‖^2) + (8*‖u‖*‖v‖^2+4*‖v‖^3)*‖c‖ := by
        norm_num [norm_mul, norm_pow]
      _ ≤ (5*T*T+T^2)+(8*T*T^2+4*T^3)*C := by gcongr
      _ = _ := by ring
  have hsmall := mul_le_mul_of_nonneg_left hTC (sq_nonneg T)
  nlinarith only [hleft, hright, hsmall]

/-- Every one of the five actual rows satisfies the same root-column
height bound. The selected nonzero integral row can therefore be used
without imposing a separate height certificate. -/
theorem finiteQDividedMatrix_root_height
    (a b s t c : ℂ) (T C : ℝ) (hT : 0 ≤ T) (hC : 0 ≤ C)
    (ha : ‖a‖ ≤ T) (hb : ‖b‖ ≤ T) (hs : ‖s‖ ≤ T) (ht : ‖t‖ ≤ T)
    (hc : ‖c‖ ≤ C) (hTC : 1 ≤ T*C) (i : Fin 5) :
    (∑ j : Fin 4, ‖finiteQDividedMatrix a b s t c i j.succ‖) ≤ 36*T^3*C := by
  have hab := finiteQ_pair_height a b c T C hT hC ha hb hc hTC
  have has := finiteQ_pair_height a s c T C hT hC ha hs hc hTC
  have hbs := finiteQ_pair_height b s c T C hT hC hb hs hc hTC
  have hat := finiteQ_pair_height a t c T C hT hC ha ht hc hTC
  have hbt := finiteQ_pair_height b t c T C hT hC hb ht hc hTC
  fin_cases i <;>
    simp_all [finiteQDividedMatrix, Fin.sum_univ_succ]

end D1Bound5
