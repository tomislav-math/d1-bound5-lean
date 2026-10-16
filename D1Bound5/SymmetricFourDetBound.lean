import D1Bound5.ProductFourNumericalClosure
import Mathlib.Tactic.FinCases

open Matrix

namespace D1Bound5

/-- Exact determinant polynomial of a symmetric zero-diagonal four-by-four matrix. -/
theorem symmetricZeroFour_det (x y z u v w : ℂ) :
    ( !![0,x,y,z; x,0,u,v; y,u,0,w; z,v,w,0] :
      Matrix (Fin 4) (Fin 4) ℂ).det =
    (x*w)^2 + (y*v)^2 + (z*u)^2 -
      2 * ((x*w)*(y*v) + (x*w)*(z*u) + (y*v)*(z*u)) := by
  rw [Matrix.det_succ_row_zero]
  simp only [Fin.sum_univ_succ]
  simp (config := {decide := true}) [Matrix.det_fin_three, Matrix.submatrix_apply,
    Matrix.of_apply, Fin.succAbove]
  ring

end D1Bound5

namespace D1Bound5

/-- Products of two entries near one half are near one quarter. -/
theorem nearHalf_product_nearQuarter (x y : ℂ)
    (hx : ‖x - (1/2 : ℂ)‖ < (128/8649 : ℝ))
    (hy : ‖y - (1/2 : ℂ)‖ < (128/8649 : ℝ)) :
    ‖x*y - (1/4 : ℂ)‖ < (1/40 : ℝ) := by
  let a := x - (1/2 : ℂ)
  let b := y - (1/2 : ℂ)
  have ha : ‖a‖ < (128/8649 : ℝ) := hx
  have hb : ‖b‖ < (128/8649 : ℝ) := hy
  have hid : x*y - (1/4 : ℂ) =
      a*b + (1/2 : ℂ)*a + (1/2 : ℂ)*b := by
    dsimp [a,b]
    ring
  have hbound : ‖x*y - (1/4 : ℂ)‖ ≤
      ‖a‖*‖b‖ + (1/2 : ℝ)*(‖a‖+‖b‖) := by
    rw [hid]
    calc
      ‖a*b + (1/2 : ℂ)*a + (1/2 : ℂ)*b‖
          ≤ ‖a*b + (1/2 : ℂ)*a‖ + ‖(1/2 : ℂ)*b‖ := norm_add_le _ _
      _ ≤ (‖a*b‖ + ‖(1/2 : ℂ)*a‖) + ‖(1/2 : ℂ)*b‖ := by
          have h := norm_add_le (a*b) ((1/2 : ℂ)*a)
          linarith only [h]
      _ = ‖a‖*‖b‖ + (1/2 : ℝ)*(‖a‖+‖b‖) := by
          simp
          ring
  have hproduct : ‖a‖*‖b‖ < (128/8649 : ℝ)^2 := by
    calc
      _ ≤ (128/8649 : ℝ)*‖b‖ :=
        mul_le_mul_of_nonneg_right ha.le (norm_nonneg _)
      _ < (128/8649 : ℝ)*(128/8649 : ℝ) :=
        mul_lt_mul_of_pos_left hb (by norm_num)
      _ = (128/8649 : ℝ)^2 := by ring
  have hlin : (1/2 : ℝ)*(‖a‖+‖b‖) < (128/8649 : ℝ) := by
    linarith only [ha, hb]
  have hn : (128/8649 : ℝ)^2 + (128/8649 : ℝ) < 1/40 := by norm_num
  linarith only [hbound, hproduct, hlin, hn]

/-- A three-pair polynomial estimate, avoiding singular-value theory. -/
theorem threePairDetPolynomial_bound (P Q R : ℂ)
    (hP : ‖P - (1/4 : ℂ)‖ < (1/40 : ℝ))
    (hQ : ‖Q - (1/4 : ℂ)‖ < (1/40 : ℝ))
    (hR : ‖R - (1/4 : ℂ)‖ < (1/40 : ℝ)) :
    ‖P^2 + Q^2 + R^2 - 2*(P*Q + P*R + Q*R)‖ < (6/25 : ℝ) := by
  let a := P - (1/4 : ℂ)
  let b := Q - (1/4 : ℂ)
  let c := R - (1/4 : ℂ)
  have ha : ‖a‖ < (1/40 : ℝ) := hP
  have hb : ‖b‖ < (1/40 : ℝ) := hQ
  have hc : ‖c‖ < (1/40 : ℝ) := hR
  have hsum : ‖a+b+c‖ < (3/40 : ℝ) := by
    have h := norm_add_le (a+b) c
    have h' := norm_add_le a b
    linarith only [h, h', ha, hb, hc]
  have hdiff : ‖a-b-c‖ < (3/40 : ℝ) := by
    have h := norm_sub_le (a-b) c
    have h' := norm_sub_le a b
    linarith only [h, h', ha, hb, hc]
  have hsq : ‖a-b-c‖^2 < (3/40 : ℝ)^2 := by
    have hleft : 0 ≤ ‖a-b-c‖ := norm_nonneg _
    have hfirst :
        ‖a-b-c‖*‖a-b-c‖ ≤ (3/40 : ℝ)*‖a-b-c‖ :=
      mul_le_mul_of_nonneg_right hdiff.le hleft
    have hsecond :
        (3/40 : ℝ)*‖a-b-c‖ < (3/40 : ℝ)*(3/40 : ℝ) :=
      mul_lt_mul_of_pos_left hdiff (by norm_num)
    nlinarith only [hfirst, hsecond]
  have hprod : ‖b‖*‖c‖ < (1/1600 : ℝ) := by
    calc
      _ ≤ (1/40 : ℝ)*‖c‖ :=
        mul_le_mul_of_nonneg_right hb.le (norm_nonneg _)
      _ < (1/40 : ℝ)*(1/40 : ℝ) :=
        mul_lt_mul_of_pos_left hc (by norm_num)
      _ = 1/1600 := by norm_num
  have hquadratic : ‖(a-b-c)^2 - (4 : ℂ)*b*c‖ < (13/1600 : ℝ) := by
    have hbq :
        ‖(a-b-c)^2 - (4 : ℂ)*b*c‖ ≤
        ‖a-b-c‖^2 + 4*(‖b‖*‖c‖) := by
      calc
        _ ≤ ‖(a-b-c)^2‖ + ‖(4 : ℂ)*b*c‖ := norm_sub_le _ _
        _ = ‖a-b-c‖^2 + 4*(‖b‖*‖c‖) := by
          simp [norm_pow]
          ring
    linarith only [hbq, hsq, hprod]
  have hpoly :
      P^2 + Q^2 + R^2 - 2*(P*Q + P*R + Q*R) =
      -(3/16 : ℂ) - (a+b+c)/2 + ((a-b-c)^2 - 4*b*c) := by
    dsimp [a, b, c]
    ring
  rw [hpoly]
  have hnormLinear : ‖(a+b+c)/2‖ = ‖a+b+c‖ / 2 := by
    simp
  calc
    ‖-(3/16 : ℂ) - (a+b+c)/2 + ((a-b-c)^2 - 4*b*c)‖
        ≤ ‖-(3/16 : ℂ) - (a+b+c)/2‖ +
          ‖(a-b-c)^2 - 4*b*c‖ := norm_add_le _ _
    _ ≤ ‖-(3/16 : ℂ)‖ + ‖(a+b+c)/2‖ +
          ‖(a-b-c)^2 - 4*b*c‖ := by
        have h := norm_sub_le (-(3/16 : ℂ)) ((a+b+c)/2)
        linarith only [h]
    _ < (3/16 : ℝ) + (3/40)/2 + 13/1600 := by
        rw [hnormLinear]
        have hn : ‖-(3/16 : ℂ)‖ = (3/16 : ℝ) := by norm_num
        rw [hn]
        linarith only [hsum, hquadratic]
    _ < 6/25 := by norm_num

end D1Bound5

namespace D1Bound5

/-- A direct four-by-four determinant bound, without singular values. -/
theorem symmetricZeroFour_det_norm_lt
    (x y z u v w : ℂ)
    (hx : ‖x - (1/2 : ℂ)‖ < (128/8649 : ℝ))
    (hy : ‖y - (1/2 : ℂ)‖ < (128/8649 : ℝ))
    (hz : ‖z - (1/2 : ℂ)‖ < (128/8649 : ℝ))
    (hu : ‖u - (1/2 : ℂ)‖ < (128/8649 : ℝ))
    (hv : ‖v - (1/2 : ℂ)‖ < (128/8649 : ℝ))
    (hw : ‖w - (1/2 : ℂ)‖ < (128/8649 : ℝ)) :
    ‖( !![0,x,y,z; x,0,u,v; y,u,0,w; z,v,w,0] :
      Matrix (Fin 4) (Fin 4) ℂ).det‖ <
    productFourH * productFourS^3 := by
  rw [symmetricZeroFour_det]
  exact lt_trans
    (threePairDetPolynomial_bound (x*w) (y*v) (z*u)
      (nearHalf_product_nearQuarter x w hx hw)
      (nearHalf_product_nearQuarter y v hy hv)
      (nearHalf_product_nearQuarter z u hz hu))
    (by unfold productFourH productFourS; norm_num)

/-- The large-entry determinant bound for any symmetric zero-diagonal
matrix with the six entrywise deviations established in RootMatrixSigns. -/
theorem symmetric_zero_four_det_upper
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (hd : ∀ i, F i i = 0)
    (hsymm : ∀ i j, F i j = F j i)
    (hsmall : ∀ i j, i ≠ j →
      ‖F i j - (1/2 : ℂ)‖ < (128/8649 : ℝ)) :
    ‖F.det‖ < productFourH * productFourS^3 := by
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
  exact symmetricZeroFour_det_norm_lt _ _ _ _ _ _
    (hsmall 0 1 (by decide)) (hsmall 0 2 (by decide))
    (hsmall 0 3 (by decide)) (hsmall 1 2 (by decide))
    (hsmall 1 3 (by decide)) (hsmall 2 3 (by decide))

end D1Bound5

namespace D1Bound5

/-- A signed, symmetric integral root matrix has the required determinant
bound as soon as all six normalized entries satisfy the scalar estimates. -/
theorem signed_root_matrix_det_upper
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a : Fin 4 → R) (u : Fin 4 → ℂ)
    (S : Matrix (Fin 4) (Fin 4) R)
    (hu : ∀ i, (u i)^2 = f (a i))
    (hdiag : ∀ i, S i i = a i)
    (hsymm : ∀ i j, S i j = S j i)
    (hgood : ∀ i j, i ≠ j →
      SignedEntryGood f (a i) (a j) (u i) (u j) (S i j)) :
    ‖(normalizedRootError (fun i => f (a i)) u
      (fun i j => f (S i j))).det‖ < productFourH * productFourS^3 := by
  let fa : Fin 4 → ℂ := fun i => f (a i)
  let fS : Matrix (Fin 4) (Fin 4) ℂ := fun i j => f (S i j)
  let F := normalizedRootError fa u fS
  have hFdiag : ∀ i, F i i = 0 := by
    intro i
    exact normalizedRootError_diag fa u fS hu
      (fun j => congrArg f (hdiag j)) i
  have hFsymm : ∀ i j, F i j = F j i := by
    intro i j
    change u i * f (S i j) * u j - f (a i) * f (a j) =
      u j * f (S j i) * u i - f (a j) * f (a i)
    rw [hsymm i j]
    ring
  have hFsmall : ∀ i j, i ≠ j →
      ‖F i j - (1/2 : ℂ)‖ < (128/8649 : ℝ) := by
    intro i j hij
    change ‖(u i * f (S i j) * u j - f (a i) * f (a j)) -
      (1/2 : ℂ)‖ < (128/8649 : ℝ)
    exact (hgood i j hij).2
  exact symmetric_zero_four_det_upper F hFdiag hFsymm hFsmall

/-- The full simultaneous integral sign choice produces a matrix whose
determinant satisfies the first required product-four upper bound. -/
theorem exists_signed_root_matrix_det_upper
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a : Fin 4 → R) (M : Matrix (Fin 4) (Fin 4) R)
    (hdiag : ∀ i, M i i = a i)
    (hsymm : ∀ i j, M i j = M j i)
    (hroot : ∀ i j, i ≠ j → (M i j)^2 = a i * a j + 1)
    (hlarge : ∀ i j, i ≠ j → 9 ≤ ‖f (a i) * f (a j)‖) :
    ∃ (u : Fin 4 → ℂ) (S : Matrix (Fin 4) (Fin 4) R),
      (∀ i, (u i)^2 = f (a i)) ∧
      (∀ i, S i i = a i) ∧
      (∀ i j, S i j = S j i) ∧
      (∀ i j, i ≠ j → (S i j)^2 = a i * a j + 1) ∧
      ‖(normalizedRootError (fun i => f (a i)) u
        (fun i j => f (S i j))).det‖ < productFourH * productFourS^3 := by
  obtain ⟨u,S,hu,hd,hs,_,hsq,hgood⟩ :=
    exists_good_symmetric_root_matrix_with_roots f a M hdiag hsymm hroot hlarge
  exact ⟨u,S,hu,hd,hs,hsq,
    signed_root_matrix_det_upper f a u S hu hd hs hgood⟩

end D1Bound5

