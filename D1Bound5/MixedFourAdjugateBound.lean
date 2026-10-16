import D1Bound5.MixedAdjugateScalarBound
import D1Bound5.MixedAdjugateEnvelope
import D1Bound5.MixedFourDetBound

open scoped Matrix.Norms.L2Operator
open Matrix

namespace D1Bound5

/-- An unconditional L2-adjugate bound for mixed first/later cofactor radii. -/
theorem mixedSymmetricFour_adjugate_norm_lt (x y z u v w : ℂ)
    (hx : ‖x-(1/2 : ℂ)‖ < (1/18 : ℝ))
    (hy : ‖y-(1/2 : ℂ)‖ < (1/18 : ℝ))
    (hz : ‖z-(1/2 : ℂ)‖ < (1/18 : ℝ))
    (hu : ‖u-(1/2 : ℂ)‖ < (1/64 : ℝ))
    (hv : ‖v-(1/2 : ℂ)‖ < (1/64 : ℝ))
    (hw : ‖w-(1/2 : ℂ)‖ < (1/64 : ℝ)) :
    ‖( !![0,x,y,z; x,0,u,v; y,u,0,w; z,v,w,0] :
       Matrix (Fin 4) (Fin 4) ℂ).adjugate‖ <
      (155/96 : ℝ) * (59/96)^2 := by
  let F : Matrix (Fin 4) (Fin 4) ℂ :=
    !![0,x,y,z; x,0,u,v; y,u,0,w; z,v,w,0]
  have hAdj : F.adjugate =
    !![2*u*v*w, w^2*x-w*z*u-w*y*v, v^2*y-v*z*u-v*x*w, u^2*z-u*y*v-u*x*w;
       w^2*x-w*z*u-w*y*v, 2*y*z*w, z^2*u-z*y*v-z*x*w, y^2*v-y*x*w-y*z*u;
       v^2*y-v*z*u-v*x*w, z^2*u-z*y*v-z*x*w, 2*x*z*v, x^2*w-x*y*v-x*z*u;
       u^2*z-u*y*v-u*x*w, y^2*v-y*x*w-y*z*u, x^2*w-x*y*v-x*z*u, 2*x*y*u] := by
    exact symmetricFour_adjugate_formula x y z u v w
  have h00 := mixed_triple_later u v w hu hv hw
  have h11 := mixed_triple_first_first_later y z w hy hz hw
  have h22 := mixed_triple_first_first_later x z v hx hz hv
  have h33 := mixed_triple_first_first_later x y u hx hy hu
  have h01 := mixed_offDiagonal_first x y z u v w hx hy hz hu hv hw
  have h02 := mixed_offDiagonal_first y x z u w v hy hx hz hu hw hv
  have h03 := mixed_offDiagonal_first z x y v w u hz hx hy hv hw hu
  have h12 := mixed_offDiagonal_later x y z u v w hx hy hz hu hv hw
  have h13 := mixed_offDiagonal_later z x y v w u hz hx hy hv hw hu
  have h23 := mixed_offDiagonal_later z y x w v u hz hy hx hw hv hu
  change ‖F.adjugate‖ < _
  apply mixedFour_adjugate_norm_of_entries F
  · intro i
    fin_cases i
    · simpa [Matrix.sub_apply, hAdj, Matrix.of_apply,
             halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h00
    · simpa [Matrix.sub_apply, hAdj, Matrix.of_apply,
             halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h11
    · simpa [Matrix.sub_apply, hAdj, Matrix.of_apply,
             halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h22
    · simpa [Matrix.sub_apply, hAdj, Matrix.of_apply,
             halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h33
  · intro i j hij hz
    fin_cases i <;> fin_cases j <;> try simp at hij <;> try simp at hz
    all_goals first
      | simpa [Matrix.sub_apply, hAdj, Matrix.of_apply,
               halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h01
      | simpa [Matrix.sub_apply, hAdj, Matrix.of_apply,
               halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h02
      | simpa [Matrix.sub_apply, hAdj, Matrix.of_apply,
               halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h03
  · intro i j hij hz
    fin_cases i <;> fin_cases j <;> try simp at hij <;> try simp at hz
    all_goals first
      | simpa [Matrix.sub_apply, hAdj, Matrix.of_apply,
               halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h12
      | simpa [Matrix.sub_apply, hAdj, Matrix.of_apply,
               halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h13
      | simpa [Matrix.sub_apply, hAdj, Matrix.of_apply,
               halfOffDiagonal_adjugate_apply, sub_neg_eq_add, neg_div] using h23

/-- Entrywise mixed perturbations for arbitrary symmetric zero-diagonal F. -/
theorem mixed_zero_four_adjugate_norm_lt
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (hd : ∀ i, F i i = 0)
    (hsymm : ∀ i j, F i j = F j i)
    (hfirst : ∀ i j, i ≠ j → i = 0 ∨ j = 0 →
      ‖F i j - (1/2 : ℂ)‖ < (1/18 : ℝ))
    (hlater : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      ‖F i j - (1/2 : ℂ)‖ < (1/64 : ℝ)) :
    ‖F.adjugate‖ < (155/96 : ℝ) * (59/96)^2 := by
  have hmatrix : F =
      !![0,F 0 1,F 0 2,F 0 3;
         F 0 1,0,F 1 2,F 1 3;
         F 0 2,F 1 2,0,F 2 3;
         F 0 3,F 1 3,F 2 3,0] := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp (config := {decide := true}) [Matrix.of_apply, hd, hsymm]
    all_goals exact hsymm 1 0
  rw [hmatrix]
  exact mixedSymmetricFour_adjugate_norm_lt _ _ _ _ _ _
    (hfirst 0 1 (by decide) (Or.inl rfl))
    (hfirst 0 2 (by decide) (Or.inl rfl))
    (hfirst 0 3 (by decide) (Or.inl rfl))
    (hlater 1 2 (by decide) (by decide))
    (hlater 1 3 (by decide) (by decide))
    (hlater 2 3 (by decide) (by decide))

end D1Bound5
