import D1Bound5.ReferencePerturbation
import Mathlib.Analysis.InnerProductSpace.PiL2

open scoped Matrix.Norms.L2Operator
open scoped InnerProductSpace
open Matrix

namespace D1Bound5

/-- The quadratic form bound works for a complex, not necessarily Hermitian,
operator and for a bilinear (without conjugation) product. -/
theorem bilinear_mulVec_norm_le (F : Matrix (Fin 4) (Fin 4) ℂ)
    (w : Fin 4 → ℂ) :
    ‖w ⬝ᵥ (F *ᵥ w)‖ ≤ ‖F‖ * (∑ i, ‖w i‖ ^ 2) := by
  let x : EuclideanSpace ℂ (Fin 4) := WithLp.toLp 2 w
  let y : EuclideanSpace ℂ (Fin 4) := WithLp.toLp 2 (star w)
  have hy : ‖y‖ = ‖x‖ := by
    have hsq : ‖y‖ ^ 2 = ‖x‖ ^ 2 := by
      rw [EuclideanSpace.norm_sq_eq y, EuclideanSpace.norm_sq_eq x]
      simp [x, y, norm_star]
    nlinarith only [hsq, norm_nonneg x, norm_nonneg y]
  have hinner : w ⬝ᵥ (F *ᵥ w) =
      inner ℂ y ((EuclideanSpace.equiv (Fin 4) ℂ).symm (F *ᵥ w)) := by
    change w ⬝ᵥ (F *ᵥ w) = inner ℂ (WithLp.toLp 2 (star w))
      (WithLp.toLp 2 (F *ᵥ w))
    rw [EuclideanSpace.inner_toLp_toLp]
    simp [dotProduct_comm]
  have hv : ‖(EuclideanSpace.equiv (Fin 4) ℂ).symm (F *ᵥ w)‖ ≤ ‖F‖ * ‖x‖ := by
    simpa only [x] using Matrix.l2_opNorm_mulVec F x
  calc
    ‖w ⬝ᵥ (F *ᵥ w)‖ =
        ‖inner ℂ y ((EuclideanSpace.equiv (Fin 4) ℂ).symm (F *ᵥ w))‖ :=
          congrArg norm hinner
    _ ≤ ‖y‖ * ‖(EuclideanSpace.equiv (Fin 4) ℂ).symm (F *ᵥ w)‖ :=
      norm_inner_le_norm _ _
    _ ≤ ‖x‖ * (‖F‖ * ‖x‖) := by
      rw [hy]
      exact mul_le_mul_of_nonneg_left hv (norm_nonneg x)
    _ = ‖F‖ * (∑ i, ‖w i‖ ^ 2) := by
      rw [← EuclideanSpace.norm_sq_eq x]
      ring

end D1Bound5
