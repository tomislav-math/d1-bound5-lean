import D1Bound5.SymmetricFourDetBound
import D1Bound5.MixedRootMatrixSigns

open Matrix

namespace D1Bound5

/-- A product of a first-row and a later-row normalized root entry lies
within 7/192 of one quarter. The two error radii are different. -/
theorem mixedPairProduct_nearQuarter (x y : ℂ)
    (hx : ‖x - (1/2 : ℂ)‖ < (1/18 : ℝ))
    (hy : ‖y - (1/2 : ℂ)‖ < (1/64 : ℝ)) :
    ‖x*y - (1/4 : ℂ)‖ < (7/192 : ℝ) := by
  let a := x - (1/2 : ℂ)
  let b := y - (1/2 : ℂ)
  have ha : ‖a‖ < (1/18 : ℝ) := hx
  have hb : ‖b‖ < (1/64 : ℝ) := hy
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
  have hproduct : ‖a‖*‖b‖ < (1/18 : ℝ)*(1/64) := by
    calc
      _ ≤ (1/18 : ℝ)*‖b‖ :=
        mul_le_mul_of_nonneg_right ha.le (norm_nonneg _)
      _ < (1/18 : ℝ)*(1/64) :=
        mul_lt_mul_of_pos_left hb (by norm_num)
  have hlin : (1/2 : ℝ)*(‖a‖+‖b‖) <
      (1/2)*(1/18+1/64) := by
    linarith only [ha, hb]
  have hn : (1/18 : ℝ)*(1/64) + (1/2)*(1/18+1/64) = 7/192 := by
    norm_num
  linarith only [hbound, hproduct, hlin, hn]

/-- The three-pair determinant polynomial remains uniformly small with
the asymmetric first-row/later-row perturbations. -/
theorem mixedThreePairDet_norm_lt (P Q R : ℂ)
    (hP : ‖P - (1/4 : ℂ)‖ < (7/192 : ℝ))
    (hQ : ‖Q - (1/4 : ℂ)‖ < (7/192 : ℝ))
    (hR : ‖R - (1/4 : ℂ)‖ < (7/192 : ℝ)) :
    ‖P^2 + Q^2 + R^2 - 2*(P*Q + P*R + Q*R)‖ < (3/10 : ℝ) := by
  let a := P - (1/4 : ℂ)
  let b := Q - (1/4 : ℂ)
  let c := R - (1/4 : ℂ)
  have ha : ‖a‖ < (7/192 : ℝ) := hP
  have hb : ‖b‖ < (7/192 : ℝ) := hQ
  have hc : ‖c‖ < (7/192 : ℝ) := hR
  have hsum : ‖a+b+c‖ < (7/64 : ℝ) := by
    have h := norm_add_le (a+b) c
    have h' := norm_add_le a b
    linarith only [h, h', ha, hb, hc]
  have hdiff : ‖a-b-c‖ < (7/64 : ℝ) := by
    have h := norm_sub_le (a-b) c
    have h' := norm_sub_le a b
    linarith only [h, h', ha, hb, hc]
  have hsq : ‖a-b-c‖^2 < (7/64 : ℝ)^2 := by
    have hleft : 0 ≤ ‖a-b-c‖ := norm_nonneg _
    have hfirst :
        ‖a-b-c‖*‖a-b-c‖ ≤ (7/64 : ℝ)*‖a-b-c‖ :=
      mul_le_mul_of_nonneg_right hdiff.le hleft
    have hsecond :
        (7/64 : ℝ)*‖a-b-c‖ < (7/64 : ℝ)*(7/64 : ℝ) :=
      mul_lt_mul_of_pos_left hdiff (by norm_num)
    nlinarith only [hfirst, hsecond]
  have hprod : ‖b‖*‖c‖ < (7/192 : ℝ)^2 := by
    calc
      _ ≤ (7/192 : ℝ)*‖c‖ :=
        mul_le_mul_of_nonneg_right hb.le (norm_nonneg _)
      _ < (7/192 : ℝ)*(7/192 : ℝ) :=
        mul_lt_mul_of_pos_left hc (by norm_num)
      _ = (7/192 : ℝ)^2 := by ring
  have hquadratic : ‖(a-b-c)^2 - (4 : ℂ)*b*c‖ <
      (13 : ℝ)*(7/192)^2 := by
    have hbq :
        ‖(a-b-c)^2 - (4 : ℂ)*b*c‖ ≤
          ‖a-b-c‖^2 + 4*(‖b‖*‖c‖) := by
      calc
        _ ≤ ‖(a-b-c)^2‖ + ‖(4 : ℂ)*b*c‖ := norm_sub_le _ _
        _ = ‖a-b-c‖^2 + 4*(‖b‖*‖c‖) := by
          simp [norm_pow]
          ring
    nlinarith only [hbq, hsq, hprod]
  have hpoly :
      P^2 + Q^2 + R^2 - 2*(P*Q + P*R + Q*R) =
        -(3/16 : ℂ) - (a+b+c)/2 + ((a-b-c)^2 - 4*b*c) := by
    dsimp [a,b,c]
    ring
  rw [hpoly]
  have hnormLinear : ‖(a+b+c)/2‖ = ‖a+b+c‖/2 := by simp
  calc
    ‖-(3/16 : ℂ) - (a+b+c)/2 + ((a-b-c)^2 - 4*b*c)‖
        ≤ ‖-(3/16 : ℂ) - (a+b+c)/2‖ +
          ‖(a-b-c)^2 - 4*b*c‖ := norm_add_le _ _
    _ ≤ ‖-(3/16 : ℂ)‖ + ‖(a+b+c)/2‖ +
          ‖(a-b-c)^2 - 4*b*c‖ := by
        have h := norm_sub_le (-(3/16 : ℂ)) ((a+b+c)/2)
        linarith only [h]
    _ < (3/16 : ℝ) + (7/64)/2 + 13*(7/192)^2 := by
        rw [hnormLinear]
        have hn : ‖-(3/16 : ℂ)‖ = (3/16 : ℝ) := by norm_num
        rw [hn]
        linarith only [hsum, hquadratic]
    _ < 3/10 := by norm_num

/-- A symmetric mixed normalized matrix satisfies a uniform determinant
bound, with no singular-value or invertibility assumptions. -/
theorem mixedSymmetricFour_det_lt (x y z u v w : ℂ)
    (hx : ‖x-(1/2 : ℂ)‖ < (1/18 : ℝ))
    (hy : ‖y-(1/2 : ℂ)‖ < (1/18 : ℝ))
    (hz : ‖z-(1/2 : ℂ)‖ < (1/18 : ℝ))
    (hu : ‖u-(1/2 : ℂ)‖ < (1/64 : ℝ))
    (hv : ‖v-(1/2 : ℂ)‖ < (1/64 : ℝ))
    (hw : ‖w-(1/2 : ℂ)‖ < (1/64 : ℝ)) :
    ‖( !![0,x,y,z; x,0,u,v; y,u,0,w; z,v,w,0] :
      Matrix (Fin 4) (Fin 4) ℂ).det‖ < (3/10 : ℝ) := by
  rw [symmetricZeroFour_det]
  exact mixedThreePairDet_norm_lt (x*w) (y*v) (z*u)
    (mixedPairProduct_nearQuarter x w hx hw)
    (mixedPairProduct_nearQuarter y v hy hv)
    (mixedPairProduct_nearQuarter z u hz hu)

end D1Bound5

namespace D1Bound5

/-- The mixed determinant bound in a matrix-independent index interface. -/
theorem mixed_zero_four_det_norm_lt
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (hd : ∀ i, F i i = 0)
    (hsymm : ∀ i j, F i j = F j i)
    (hfirst : ∀ i j, i ≠ j → i = 0 ∨ j = 0 →
      ‖F i j - (1/2 : ℂ)‖ < (1/18 : ℝ))
    (hlater : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      ‖F i j - (1/2 : ℂ)‖ < (1/64 : ℝ)) :
    ‖F.det‖ < (3/10 : ℝ) := by
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
  exact mixedSymmetricFour_det_lt _ _ _ _ _ _
    (hfirst 0 1 (by decide) (Or.inl rfl))
    (hfirst 0 2 (by decide) (Or.inl rfl))
    (hfirst 0 3 (by decide) (Or.inl rfl))
    (hlater 1 2 (by decide) (by decide))
    (hlater 1 3 (by decide) (by decide))
    (hlater 2 3 (by decide) (by decide))

end D1Bound5

namespace D1Bound5

/-- Determinant bound for an integral symmetric signed-root matrix in the
mixed A >= 1, B >= 3 regime, with explicit signed-entry hypotheses. -/
theorem mixed_signed_root_det_upper
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a : Fin 4 → R) (u : Fin 4 → ℂ)
    (S : Matrix (Fin 4) (Fin 4) R)
    (hu : ∀ i, (u i)^2 = f (a i))
    (hdiag : ∀ i, S i i = a i)
    (hsymm : ∀ i j, S i j = S j i)
    (hgood : ∀ i j, i ≠ j →
      MixedSignedEntryGood f a u i j (S i j)) :
    ‖(normalizedRootError (fun i => f (a i)) u
      (fun i j => f (S i j))).det‖ < (3/10 : ℝ) := by
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
  exact mixed_zero_four_det_norm_lt F hFdiag hFsymm hFfirst hFlater

end D1Bound5
