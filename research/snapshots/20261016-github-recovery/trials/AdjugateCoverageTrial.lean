import exploration.AdjugateFourTrial
import exploration.AdjugateOffdiagTrial

open scoped Matrix.Norms.L2Operator
open Matrix

namespace D1Bound5

private def symmetricFour (x y z u v w : ℂ) : Matrix (Fin 4) (Fin 4) ℂ :=
  !![0,x,y,z; x,0,u,v; y,u,0,w; z,v,w,0]

private def symmetricFourAdj (x y z u v w : ℂ) : Matrix (Fin 4) (Fin 4) ℂ :=
  !![2*u*v*w, w^2*x-w*z*u-w*y*v, v^2*y-v*z*u-v*x*w, u^2*z-u*y*v-u*x*w;
     w^2*x-w*z*u-w*y*v, 2*y*z*w, z^2*u-z*y*v-z*x*w, y^2*v-y*x*w-y*z*u;
     v^2*y-v*z*u-v*x*w, z^2*u-z*y*v-z*x*w, 2*x*z*v, x^2*w-x*y*v-x*z*u;
     u^2*z-u*y*v-u*x*w, y^2*v-y*x*w-y*z*u, x^2*w-x*y*v-x*z*u, 2*x*y*u]

/-- All sixteen cofactors of the symmetric zero-diagonal four-by-four matrix. -/
theorem symmetricFour_adjugate_formula (x y z u v w : ℂ) :
    (symmetricFour x y z u v w).adjugate = symmetricFourAdj x y z u v w := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    (rw [Matrix.adjugate_apply, Matrix.det_succ_row_zero]
     simp (config := {decide := true})
       [symmetricFour, symmetricFourAdj, Matrix.updateRow_apply,
        Pi.single_apply, Fin.sum_univ_succ, Matrix.det_fin_three,
        Matrix.submatrix_apply, Matrix.of_apply, Fin.succAbove] <;> ring)

/-- Unconditional adjugate operator-norm estimate for all six
independently chosen entries satisfying the previously proved near-half bounds. -/
theorem symmetricFour_adjugate_norm_lt (x y z u v w : ℂ)
    (hx : ‖x-(1/2 : ℂ)‖ < (128/8649 : ℝ))
    (hy : ‖y-(1/2 : ℂ)‖ < (128/8649 : ℝ))
    (hz : ‖z-(1/2 : ℂ)‖ < (128/8649 : ℝ))
    (hu : ‖u-(1/2 : ℂ)‖ < (128/8649 : ℝ))
    (hv : ‖v-(1/2 : ℂ)‖ < (128/8649 : ℝ))
    (hw : ‖w-(1/2 : ℂ)‖ < (128/8649 : ℝ)) :
    ‖(symmetricFour x y z u v w).adjugate‖ <
      productFourH * productFourS^2 := by
  let F := symmetricFour x y z u v w
  have hAdj : F.adjugate = symmetricFourAdj x y z u v w :=
    symmetricFour_adjugate_formula x y z u v w
  have h00 := nearHalf_triple_cofactor_bound u v w hu hv hw
  have h11 := nearHalf_triple_cofactor_bound y z w hy hz hw
  have h22 := nearHalf_triple_cofactor_bound x z v hx hz hv
  have h33 := nearHalf_triple_cofactor_bound x y u hx hy hu
  have h01 := nearHalf_offDiagonal_cofactor_bound x y z u v w hx hy hz hu hv hw
  have h02 := nearHalf_offDiagonal_cofactor_bound y x z u w v hy hx hz hu hw hv
  have h03 := nearHalf_offDiagonal_cofactor_bound z x y v w u hz hx hy hv hw hu
  have h12 := nearHalf_offDiagonal_cofactor_bound u x y v w z hu hx hy hv hw hz
  have h13 := nearHalf_offDiagonal_cofactor_bound v z x w u y hv hz hx hw hu hy
  have h23 := nearHalf_offDiagonal_cofactor_bound w z y v u x hw hz hy hv hu hx
  apply four_adjugate_bound_of_entry_bounds F
  · intro i
    fin_cases i
    · simpa [Matrix.sub_apply, hAdj, symmetricFourAdj,
             halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h00
    · simpa [Matrix.sub_apply, hAdj, symmetricFourAdj,
             halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h11
    · simpa [Matrix.sub_apply, hAdj, symmetricFourAdj,
             halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h22
    · simpa [Matrix.sub_apply, hAdj, symmetricFourAdj,
             halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h33
  · intro i j hij
    fin_cases i <;> fin_cases j <;> try simp at hij
    all_goals first
      | simpa [Matrix.sub_apply, hAdj, symmetricFourAdj,
               halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h01
      | simpa [Matrix.sub_apply, hAdj, symmetricFourAdj,
               halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h02
      | simpa [Matrix.sub_apply, hAdj, symmetricFourAdj,
               halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h03
      | simpa [Matrix.sub_apply, hAdj, symmetricFourAdj,
               halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h12
      | simpa [Matrix.sub_apply, hAdj, symmetricFourAdj,
               halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h13
      | simpa [Matrix.sub_apply, hAdj, symmetricFourAdj,
               halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h23

/-- The cofactor estimate holds for any symmetric zero-diagonal complex
matrix, expressed without choosing or labelling its six entries. -/
theorem symmetric_zero_four_adjugate_norm_lt
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (hzero : ∀ i, F i i = 0)
    (hsym : ∀ i j, F i j = F j i)
    (hnear : ∀ i j, i ≠ j →
      ‖F i j - (1/2 : ℂ)‖ < (128/8649 : ℝ)) :
    ‖F.adjugate‖ < productFourH * productFourS^2 := by
  have hrepr : F = symmetricFour (F 0 1) (F 0 2) (F 0 3)
      (F 1 2) (F 1 3) (F 2 3) := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      (simp (config := {decide := true}) [symmetricFour, hzero] <;>
        (first | exact hsym _ _ | exact (hsym _ _).symm))
  rw [hrepr]
  exact symmetricFour_adjugate_norm_lt
    (F 0 1) (F 0 2) (F 0 3) (F 1 2) (F 1 3) (F 2 3)
    (hnear 0 1 (by decide)) (hnear 0 2 (by decide))
    (hnear 0 3 (by decide)) (hnear 1 2 (by decide))
    (hnear 1 3 (by decide)) (hnear 2 3 (by decide))

end D1Bound5

open Lean Elab Command
run_cmd do
  let names : List Name := [
    `D1Bound5.symmetricFour_adjugate_formula,
    `D1Bound5.symmetricFour_adjugate_norm_lt,
    `D1Bound5.symmetric_zero_four_adjugate_norm_lt]
  for n in names do
    let axs ← Lean.collectAxioms n
    let bad := axs.filter fun a =>
      !([`propext, `Classical.choice, `Quot.sound] : List Name).contains a
    unless bad.isEmpty do
      throwError "Forbidden axioms for {n}: {bad}"
    logInfo m!"COVERAGE_AXIO​​MS {n}: {axs}"
