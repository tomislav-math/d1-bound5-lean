import D1Bound5.MixedSignedRootAdjugate
import D1Bound5.TupleRootMatrixBridge
import D1Bound5.WeightedSchur

open scoped NumberField Matrix.Norms.L2Operator BigOperators
open Matrix Module

namespace D1Bound5

/-- Invertibility of a mixed normalized error matrix from its entrywise bounds. -/
theorem mixed_four_det_ne_zero_of_entry_bounds
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (hdiag : ∀ i, F i i = 0)
    (hfirst : ∀ i j, i ≠ j → i = 0 ∨ j = 0 →
      ‖F i j - (1/2 : ℂ)‖ < (1/18 : ℝ))
    (hlater : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      ‖F i j - (1/2 : ℂ)‖ < (1/64 : ℝ)) :
    F.det ≠ 0 := by
  have hd : ∀ i, (F - halfOffDiagonal) i i = 0 := by
    intro i
    simpa [Matrix.sub_apply, halfOffDiagonal, hdiag i]
  have hf : ∀ i j, i ≠ j → i = 0 ∨ j = 0 →
      ‖(F - halfOffDiagonal) i j‖ < (1/18 : ℝ) := by
    intro i j hij hz
    simpa [Matrix.sub_apply, halfOffDiagonal, hij] using hfirst i j hij hz
  have hl : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      ‖(F - halfOffDiagonal) i j‖ < (1/64 : ℝ) := by
    intro i j hij hz
    simpa [Matrix.sub_apply, halfOffDiagonal, hij] using hlater i j hij hz
  have hnear : ‖F - halfOffDiagonal‖ ≤ (11/96 : ℝ) :=
    mixedFour_operator_norm_le (F - halfOffDiagonal) hd hf hl
  have hsmall :
      ‖halfOffDiagonalInverse * (F - halfOffDiagonal)‖ < 1 := by
    calc
      ‖halfOffDiagonalInverse * (F - halfOffDiagonal)‖
          ≤ ‖halfOffDiagonalInverse‖ * ‖F - halfOffDiagonal‖ :=
            Matrix.l2_opNorm_mul _ _
      _ = 2 * ‖F - halfOffDiagonal‖ := by rw [halfOffDiagonalInverse_norm]
      _ ≤ 2 * (11/96 : ℝ) :=
        mul_le_mul_of_nonneg_left hnear (by norm_num)
      _ < 1 := by norm_num
  exact reference_perturbed_det_ne_zero F hsmall

/-- Exact parameters in the A >= 1, B >= 3 case of product-four. -/
noncomputable def productFourMixedS : ℝ := 59 / 96
noncomputable def productFourMixedH : ℝ := 155 / 96

/-- Rational margin of the mixed branch. -/
theorem productFour_mixed_numeric :
    productFourMixedH * productFourMixedS^2 *
      ((13/12 : ℝ) + productFourMixedS/324) < 2/3 := by
  unfold productFourMixedH productFourMixedS
  norm_num

/-- The mixed rank-one determinant inequality. -/
theorem productFour_mixed_rankOne_numeric
    (F : Matrix (Fin 4) (Fin 4) ℂ) (w : Fin 4 → ℂ)
    (D : ℝ) (hD : 18 < D) (hF : F.det ≠ 0)
    (hdet : ‖F.det‖ < productFourMixedH * productFourMixedS^3)
    (hadj : ‖F.adjugate‖ < productFourMixedH * productFourMixedS^2)
    (hw : (∑ i, ‖w i‖^2) ≤ (13/12 : ℝ) * D^2) :
    ‖(F + Matrix.vecMulVec w w).det‖ < (2/3 : ℝ)*D^2 := by
  have hsum : 0 ≤ (∑ i, ‖w i‖^2) :=
    Finset.sum_nonneg (fun i _ => sq_nonneg _)
  have hcoef : 0 ≤ productFourMixedH * productFourMixedS^2 := by
    unfold productFourMixedH productFourMixedS
    positivity
  have hterm :
      ‖F.adjugate‖ * (∑ i, ‖w i‖^2) ≤
        productFourMixedH * productFourMixedS^2 * ((13/12 : ℝ) * D^2) := by
    calc
      _ ≤ (productFourMixedH * productFourMixedS^2) * (∑ i, ‖w i‖^2) :=
        mul_le_mul_of_nonneg_right hadj.le hsum
      _ ≤ productFourMixedH * productFourMixedS^2 * ((13/12 : ℝ) * D^2) :=
        mul_le_mul_of_nonneg_left hw hcoef
  have hn :
      productFourMixedH * productFourMixedS^3 +
        productFourMixedH * productFourMixedS^2 * ((13/12 : ℝ) * D^2) <
        (2/3 : ℝ)*D^2 := by
    have hd2 : 324 < D^2 := by nlinarith
    unfold productFourMixedH productFourMixedS
    nlinarith only [hd2]
  have hbase := rankOneDeterminant_adjugate_norm_le F w hF
  linarith only [hbase, hdet, hterm, hn]

/-- D > 3ABC/2 from the mixed determinant bounds and the arithmetic lower bound. -/
theorem productFour_mixed_growth_from_bounds
    (F : Matrix (Fin 4) (Fin 4) ℂ) (w : Fin 4 → ℂ)
    (A B C D : ℝ) (hD : 18 < D) (hF : F.det ≠ 0)
    (hdet : ‖F.det‖ < productFourMixedH * productFourMixedS^3)
    (hadj : ‖F.adjugate‖ < productFourMixedH * productFourMixedS^2)
    (hw : (∑ i, ‖w i‖^2) ≤ (13/12 : ℝ) * D^2)
    (hlower : A*B*C*D ≤ ‖(F + Matrix.vecMulVec w w).det‖) :
    (3/2 : ℝ)*A*B*C < D := by
  have ht := productFour_mixed_rankOne_numeric F w D hD hF hdet hadj hw
  have hDpos : 0 < D := by linarith
  have hprod : ((3/2 : ℝ)*A*B*C)*D < D*D := by
    nlinarith only [hlower, ht]
  by_contra hbad
  have hmul := mul_nonneg (sub_nonneg.mpr (le_of_not_gt hbad)) hDpos.le
  nlinarith only [hprod, hmul]


/-- The mixed A >= 1, B >= 3 growth estimate in every imaginary quadratic
full integer ring. The original-ring square roots and sign choices are
constructed without excluding zero squares or equal complex moduli. -/
theorem full_ring_productFour_mixed_growth
    {K : Type*} [Field K] [NumberField K]
    [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 4 → 𝓞 K) (M : Matrix (Fin 4) (Fin 4) (𝓞 K))
    (hdiag : ∀ i, M i i = a i)
    (hsymm : ∀ i j, M i j = M j i)
    (hroot : ∀ i j, i ≠ j → (M i j)^2 = a i * a j + 1)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hA : 1 ≤ ‖phi (a 0 : K)‖)
    (hB : 3 ≤ ‖phi (a 1 : K)‖)
    (htail : 2 * ‖phi (a 1 : K)‖ * ‖phi (a 2 : K)‖ <
      ‖phi (a 3 : K)‖) :
    (3/2 : ℝ)*‖phi (a 0 : K)‖*‖phi (a 1 : K)‖*
      ‖phi (a 2 : K)‖ < ‖phi (a 3 : K)‖ := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let A : ℝ := ‖phi (a 0 : K)‖
  let B : ℝ := ‖phi (a 1 : K)‖
  let C : ℝ := ‖phi (a 2 : K)‖
  let D : ℝ := ‖phi (a 3 : K)‖
  have hAB : A ≤ B := hmon (by decide : (0 : Fin 4) ≤ 1)
  have hBC : B ≤ C := hmon (by decide : (1 : Fin 4) ≤ 2)
  have hD18 : 18 < D := productFour_tail_large B C D hBC hB htail
  have hAl : 0 ≤ A := norm_nonneg _
  have hAall (i : Fin 4) : 1 ≤ ‖f (a i)‖ := by
    change 1 ≤ ‖phi (a i : K)‖
    exact hA.trans (hmon (Fin.zero_le i))
  have hBall (i : Fin 4) (hi : i ≠ 0) : 3 ≤ ‖f (a i)‖ := by
    change 3 ≤ ‖phi (a i : K)‖
    have hOne : (1 : Fin 4) ≤ i := by omega
    exact hB.trans (hmon hOne)
  have hfirst (i j : Fin 4) (hij : i ≠ j)
      (hz : i = 0 ∨ j = 0) : 3 ≤ ‖f (a i) * f (a j)‖ := by
    rw [norm_mul]
    rcases hz with hi | hj
    · subst i
      have hji : j ≠ 0 := hij.symm
      have h1 := hAall 0
      have h3 := hBall j hji
      nlinarith [mul_nonneg (sub_nonneg.mpr h1) (sub_nonneg.mpr h3)]
    · subst j
      have h1 := hAall 0
      have h3 := hBall i hij
      nlinarith [mul_nonneg (sub_nonneg.mpr h3) (sub_nonneg.mpr h1)]
  have hlater (i j : Fin 4) (_ : i ≠ j)
      (hz : ¬(i = 0 ∨ j = 0)) : 9 ≤ ‖f (a i) * f (a j)‖ := by
    have hi : i ≠ 0 := by tauto
    have hj : j ≠ 0 := by tauto
    have h1 := hBall i hi
    have h2 := hBall j hj
    rw [norm_mul]
    nlinarith [mul_nonneg (sub_nonneg.mpr h1) (sub_nonneg.mpr h2)]
  obtain ⟨u, S, hu, hd, hs, _, hsq, hgood⟩ :=
    exists_mixed_symmetric_root_matrix_with_roots f a M
      hdiag hsymm hroot hfirst hlater
  let w : Fin 4 → ℂ := fun i => f (a i)
  let F := normalizedRootError w u (S.map f)
  have hFdiag : ∀ i, F i i = 0 := by
    intro i
    exact normalizedRootError_diag w u (S.map f) (by simpa [w] using hu)
      (fun j => congrArg f (hd j)) i
  have hFfirst : ∀ i j, i ≠ j → i = 0 ∨ j = 0 →
      ‖F i j - (1/2 : ℂ)‖ < (1/18 : ℝ) := by
    intro i j hij hz
    have h : SignedEntryBounds f (a i) (a j) (u i) (u j)
        (S i j) (5/9) (25/486) := by
      simpa [MixedSignedEntryGood, hz] using hgood i j hij
    change ‖(u i * f (S i j) * u j - f (a i) * f (a j)) -
      (1/2 : ℂ)‖ < (1/18 : ℝ)
    exact lt_trans h.2 (by norm_num)
  have hFlater : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      ‖F i j - (1/2 : ℂ)‖ < (1/64 : ℝ) := by
    intro i j hij hz
    have h : SignedEntryBounds f (a i) (a j) (u i) (u j)
        (S i j) (7/13) (1/64) := by
      simpa [MixedSignedEntryGood, hz] using hgood i j hij
    change ‖(u i * f (S i j) * u j - f (a i) * f (a j)) -
      (1/2 : ℂ)‖ < (1/64 : ℝ)
    exact h.2
  have hF : F.det ≠ 0 :=
    mixed_four_det_ne_zero_of_entry_bounds F hFdiag hFfirst hFlater
  have hmap : S.map f = (fun i j => f (S i j)) := by
    ext i j
    rfl
  have hanalytic : ‖F.det‖ < (3/10 : ℝ) ∧
      ‖F.adjugate‖ < (155/96 : ℝ)*(59/96)^2 := by
    simpa only [F, w, hmap] using
      mixed_signed_root_det_and_adjugate_upper f a u S hu hd hs hgood
  have hdetNumeric : (3/10 : ℝ) <
      productFourMixedH * productFourMixedS^3 := by
    unfold productFourMixedH productFourMixedS
    norm_num
  have hdet : ‖F.det‖ < productFourMixedH * productFourMixedS^3 :=
    lt_trans hanalytic.1 hdetNumeric
  have hadj : ‖F.adjugate‖ < productFourMixedH * productFourMixedS^2 := by
    simpa [productFourMixedH, productFourMixedS] using hanalytic.2
  have hsum := productFour_ordered_square_sum A B C D hAl hAB hBC hB htail
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
  exact productFour_mixed_growth_from_bounds F w A B C D hD18
    hF hdet hadj hw hlower'

/-- The mixed growth bound for an actual ordered D(1) quadruple. -/
theorem IsD1Tuple.productFour_mixed_growth
    {K : Type*} [Field K] [NumberField K]
    [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 4 → 𝓞 K) (ht : IsD1Tuple t)
    (hmon : Monotone (fun i => ‖phi (t i : K)‖))
    (hA : 1 ≤ ‖phi (t 0 : K)‖)
    (hB : 3 ≤ ‖phi (t 1 : K)‖) :
    (3/2 : ℝ)*‖phi (t 0 : K)‖*‖phi (t 1 : K)‖*
      ‖phi (t 2 : K)‖ < ‖phi (t 3 : K)‖ := by
  obtain ⟨M, hdiag, hsymm, hroot⟩ := ht.exists_symmetric_root_matrix t
  have htail := (ht.tail_irregular_and_growth hK phi t hmon hB).2
  exact full_ring_productFour_mixed_growth hK phi t M hdiag hsymm
    hroot hmon hA hB htail

end D1Bound5
