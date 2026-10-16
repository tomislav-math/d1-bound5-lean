import D1Bound5.RootDeterminantLower
import D1Bound5.SignedRootMatrixBounds
import D1Bound5.ProductFourNumericalClosure
import D1Bound5.ReferencePerturbation

open scoped NumberField Matrix.Norms.L2Operator BigOperators
open Matrix Module

namespace D1Bound5

/-- A quantitative square-sum estimate from the already established
irregular-growth inequality. The entries may have equal moduli. -/
theorem productFour_ordered_square_sum
    (A B C D : ℝ) (hA : 0 ≤ A) (hAB : A ≤ B)
    (hBC : B ≤ C) (hB : 3 ≤ B) (htail : 2*B*C < D) :
    A^2+B^2+C^2+D^2 ≤ (13/12 : ℝ)*D^2 := by
  have hC : 0 ≤ C := by linarith
  have hAC : A ≤ C := le_trans hAB hBC
  have hD6 : 6*C < D := by
    have hm := mul_le_mul_of_nonneg_right hB hC
    nlinarith only [hm, htail]
  have hDpos : 0 < D := by nlinarith only [hD6, hC]
  have hSq : 0 < (D-6*C)*(D+6*C) := by
    apply mul_pos
    · linarith
    · nlinarith only [hDpos, hC]
  have hA2 : A^2 ≤ C^2 := by
    nlinarith only [mul_nonneg (sub_nonneg.mpr hAC) (add_nonneg hC hA)]
  have hB2 : B^2 ≤ C^2 := by
    have hBnonneg : 0 ≤ B := by linarith
    nlinarith only [mul_nonneg (sub_nonneg.mpr hBC) (add_nonneg hC hBnonneg)]
  nlinarith only [hA2, hB2, hSq]

/-- The tail inequality forces the numerical D>18 threshold. -/
theorem productFour_tail_large
    (B C D : ℝ) (hBC : B ≤ C) (hB : 3 ≤ B)
    (htail : 2*B*C < D) : 18 < D := by
  have hC : 3 ≤ C := le_trans hB hBC
  have hmul : 9 ≤ B*C := by
    nlinarith [mul_nonneg (sub_nonneg.mpr hB) (sub_nonneg.mpr hC)]
  nlinarith only [htail, hmul]

end D1Bound5

namespace D1Bound5

/-- The A >= 3 part of the four-entry determinant growth lemma, for every
imaginary quadratic FULL integer ring. The tail-growth assumption is the
separately proved irregular-tail lemma, not a replacement for the result. -/
theorem full_ring_productFour_large_growth
    {K : Type*} [Field K] [NumberField K]
    [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 4 → 𝓞 K) (M : Matrix (Fin 4) (Fin 4) (𝓞 K))
    (hdiag : ∀ i, M i i = a i)
    (hsymm : ∀ i j, M i j = M j i)
    (hroot : ∀ i j, i ≠ j → (M i j)^2 = a i * a j + 1)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hA : 3 ≤ ‖phi (a 0 : K)‖)
    (htail : 2 * ‖phi (a 1 : K)‖ * ‖phi (a 2 : K)‖ < ‖phi (a 3 : K)‖) :
    2 * ‖phi (a 0 : K)‖ * ‖phi (a 1 : K)‖ * ‖phi (a 2 : K)‖ <
      ‖phi (a 3 : K)‖ := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let A : ℝ := ‖phi (a 0 : K)‖
  let B : ℝ := ‖phi (a 1 : K)‖
  let C : ℝ := ‖phi (a 2 : K)‖
  let D : ℝ := ‖phi (a 3 : K)‖
  have hAB : A ≤ B := hmon (by decide : (0 : Fin 4) ≤ 1)
  have hBC : B ≤ C := hmon (by decide : (1 : Fin 4) ≤ 2)
  have hAC : C ≤ D := hmon (by decide : (2 : Fin 4) ≤ 3)
  have hAl : 0 ≤ A := norm_nonneg _
  have hB3 : 3 ≤ B := le_trans hA hAB
  have hD18 : 18 < D := productFour_tail_large B C D hBC hB3 htail
  have hlarge (i j : Fin 4) (_ : i ≠ j) :
      9 ≤ ‖f (a i) * f (a j)‖ := by
    have hi : 3 ≤ ‖f (a i)‖ := by
      change 3 ≤ ‖phi (a i : K)‖
      exact hA.trans (hmon (Fin.zero_le i))
    have hj : 3 ≤ ‖f (a j)‖ := by
      change 3 ≤ ‖phi (a j : K)‖
      exact hA.trans (hmon (Fin.zero_le j))
    rw [norm_mul]
    nlinarith [mul_nonneg (sub_nonneg.mpr hi) (sub_nonneg.mpr hj)]
  obtain ⟨u, S, hu, hd, hs, _, hsq, hgood⟩ :=
    exists_good_symmetric_root_matrix_with_roots f a M
      hdiag hsymm hroot hlarge
  let w : Fin 4 → ℂ := fun i => f (a i)
  let F := normalizedRootError w u (S.map f)
  have hnear : ‖F - halfOffDiagonal‖ < 3 * (128/8649 : ℝ) :=
    signed_root_matrix_operator_bound f a u S hu hd hgood
  have hF : F.det ≠ 0 := reference_perturbed_det_ne_zero_of_near F hnear
  have hdet : ‖F.det‖ < productFourH * productFourS^3 :=
    signed_root_matrix_det_upper f a u S hu hd hs hgood
  have hadj : ‖F.adjugate‖ < productFourH * productFourS^2 :=
    signed_root_matrix_adjugate_upper f a u S hu hd hs hgood
  have hsum := productFour_ordered_square_sum A B C D hAl hAB hBC hB3 htail
  have hw : (∑ i, ‖w i‖^2) ≤ (13/12 : ℝ) * D^2 := by
    simpa [w, f, A, B, C, D, Fin.sum_univ_four] using hsum
  have hlower := full_ring_scaledRootMatrix_det_norm_lower hK phi
    (by decide : Even (Fintype.card (Fin 4))) a S hd hsq u hu
  have hmatrix : F + Matrix.vecMulVec w w = scaledRootMatrix u (S.map f) := by
    ext i j
    simp only [Matrix.add_apply, Matrix.vecMulVec_apply,
      F, w, normalizedRootError, scaledRootMatrix, Matrix.map_apply]
    ring
  have hlower' : A*B*C*D ≤ ‖(F + Matrix.vecMulVec w w).det‖ := by
    rw [hmatrix]
    convert hlower using 1
    simp [A, B, C, D, Fin.prod_univ_four]
  exact productFour_growth_from_bounds F w A B C D hD18 hF hdet hadj hw hlower'

end D1Bound5
