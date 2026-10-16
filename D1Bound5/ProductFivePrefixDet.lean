import D1Bound5.MixedFourDetBound

open Matrix

namespace D1Bound5

/-- The quadratic remainder in the three-pair four-by-four determinant
has the sharp coefficient nine when all three errors have size <= epsilon. -/
theorem threePair_quadratic_norm_le (a b c : ℂ) (epsilon : ℝ)
    (he : 0 ≤ epsilon)
    (ha : ‖a‖ ≤ epsilon) (hb : ‖b‖ ≤ epsilon) (hc : ‖c‖ ≤ epsilon) :
    ‖a^2 + b^2 + c^2 - 2*(a*b + a*c + b*c)‖ ≤
      9*epsilon^2 := by
  have hsq : ‖a^2 + b^2 + c^2‖ ≤
      ‖a‖^2 + ‖b‖^2 + ‖c‖^2 := by
    calc
      _ ≤ ‖a^2 + b^2‖ + ‖c^2‖ := norm_add_le _ _
      _ ≤ ‖a^2‖ + ‖b^2‖ + ‖c^2‖ := by
        have h := norm_add_le (a^2) (b^2)
        linarith only [h]
      _ = _ := by simp [norm_pow]
  have hprod : ‖a*b + a*c + b*c‖ ≤
      ‖a‖*‖b‖ + ‖a‖*‖c‖ + ‖b‖*‖c‖ := by
    calc
      _ ≤ ‖a*b + a*c‖ + ‖b*c‖ := norm_add_le _ _
      _ ≤ ‖a*b‖ + ‖a*c‖ + ‖b*c‖ := by
        have h := norm_add_le (a*b) (a*c)
        linarith only [h]
      _ = _ := by simp [norm_mul]
  have htri : ‖a^2 + b^2 + c^2 - 2*(a*b + a*c + b*c)‖ ≤
      ‖a‖^2 + ‖b‖^2 + ‖c‖^2 +
        2*(‖a‖*‖b‖ + ‖a‖*‖c‖ + ‖b‖*‖c‖) := by
    have h := norm_sub_le (a^2+b^2+c^2) ((2:ℂ)*(a*b+a*c+b*c))
    have ht : ‖(2:ℂ)*(a*b+a*c+b*c)‖ =
        2*‖a*b+a*c+b*c‖ := by
      simp [norm_mul]
    rw [ht] at h
    linarith only [h, hsq, hprod]
  have ha2 : ‖a‖^2 ≤ epsilon^2 :=
    (sq_le_sq₀ (norm_nonneg _) he).mpr ha
  have hb2 : ‖b‖^2 ≤ epsilon^2 :=
    (sq_le_sq₀ (norm_nonneg _) he).mpr hb
  have hc2 : ‖c‖^2 ≤ epsilon^2 :=
    (sq_le_sq₀ (norm_nonneg _) he).mpr hc
  have hab : ‖a‖*‖b‖ ≤ epsilon^2 := by
    calc
      _ ≤ epsilon*‖b‖ :=
        mul_le_mul_of_nonneg_right ha (norm_nonneg _)
      _ ≤ epsilon*epsilon := mul_le_mul_of_nonneg_left hb he
      _ = epsilon^2 := by ring
  have hac : ‖a‖*‖c‖ ≤ epsilon^2 := by
    calc
      _ ≤ epsilon*‖c‖ :=
        mul_le_mul_of_nonneg_right ha (norm_nonneg _)
      _ ≤ epsilon*epsilon := mul_le_mul_of_nonneg_left hc he
      _ = epsilon^2 := by ring
  have hbc : ‖b‖*‖c‖ ≤ epsilon^2 := by
    calc
      _ ≤ epsilon*‖c‖ :=
        mul_le_mul_of_nonneg_right hb (norm_nonneg _)
      _ ≤ epsilon*epsilon := mul_le_mul_of_nonneg_left hc he
      _ = epsilon^2 := by ring
  linarith only [htri, ha2, hb2, hc2, hab, hac, hbc]

/-- The sharper determinant threshold used in Lemma product-five.
It improves the previously established 3/10 bound using the exact
nine-term quadratic estimate rather than a 13-term majorant. -/
theorem mixedThreePairDet_norm_lt_33_128 (P Q R : ℂ)
    (hP : ‖P - (1/4 : ℂ)‖ < (7/192 : ℝ))
    (hQ : ‖Q - (1/4 : ℂ)‖ < (7/192 : ℝ))
    (hR : ‖R - (1/4 : ℂ)‖ < (7/192 : ℝ)) :
    ‖P^2 + Q^2 + R^2 - 2*(P*Q + P*R + Q*R)‖ <
      (33/128 : ℝ) := by
  let a := P - (1/4 : ℂ)
  let b := Q - (1/4 : ℂ)
  let c := R - (1/4 : ℂ)
  have ha : ‖a‖ ≤ (7/192 : ℝ) := hP.le
  have hb : ‖b‖ ≤ (7/192 : ℝ) := hQ.le
  have hc : ‖c‖ ≤ (7/192 : ℝ) := hR.le
  have hsum : ‖a+b+c‖ ≤ (7/64 : ℝ) := by
    have h := norm_add_le (a+b) c
    have h' := norm_add_le a b
    linarith only [h, h', ha, hb, hc]
  have hquad := threePair_quadratic_norm_le a b c (7/192)
    (by norm_num) ha hb hc
  have hpoly :
      P^2 + Q^2 + R^2 - 2*(P*Q + P*R + Q*R) =
        -(3/16 : ℂ) - (a+b+c)/2 +
          (a^2+b^2+c^2 - 2*(a*b+a*c+b*c)) := by
    dsimp [a,b,c]
    ring
  rw [hpoly]
  have hhalf : ‖(a+b+c)/2‖ = ‖a+b+c‖/2 := by simp
  have h1 := norm_add_le (-(3/16 : ℂ) - (a+b+c)/2)
    (a^2+b^2+c^2-2*(a*b+a*c+b*c))
  have h2 := norm_sub_le (-(3/16 : ℂ)) ((a+b+c)/2)
  have hconstant : ‖-(3/16 : ℂ)‖ = (3/16 : ℝ) := by norm_num
  have hmain : ‖-(3/16 : ℂ) - (a+b+c)/2 +
      (a^2+b^2+c^2-2*(a*b+a*c+b*c))‖ ≤
      (3/16 : ℝ) + (7/64)/2 + 9*(7/192)^2 := by
    rw [hhalf] at h2
    rw [hconstant] at h2
    linarith only [h1, h2, hsum, hquad]
  exact lt_of_le_of_lt hmain (by norm_num)

/-- Sharpened mixed determinant bound for the exact symmetric matrix. -/
theorem mixedSymmetricFour_det_lt_33_128 (x y z u v w : ℂ)
    (hx : ‖x-(1/2 : ℂ)‖ < (1/18 : ℝ))
    (hy : ‖y-(1/2 : ℂ)‖ < (1/18 : ℝ))
    (hz : ‖z-(1/2 : ℂ)‖ < (1/18 : ℝ))
    (hu : ‖u-(1/2 : ℂ)‖ < (1/64 : ℝ))
    (hv : ‖v-(1/2 : ℂ)‖ < (1/64 : ℝ))
    (hw : ‖w-(1/2 : ℂ)‖ < (1/64 : ℝ)) :
    ‖( !![0,x,y,z; x,0,u,v; y,u,0,w; z,v,w,0] :
      Matrix (Fin 4) (Fin 4) ℂ).det‖ < (33/128 : ℝ) := by
  rw [symmetricZeroFour_det]
  exact mixedThreePairDet_norm_lt_33_128 (x*w) (y*v) (z*u)
    (mixedPairProduct_nearQuarter x w hx hw)
    (mixedPairProduct_nearQuarter y v hy hv)
    (mixedPairProduct_nearQuarter z u hz hu)

/-- Matrix-index version, with no invertibility or root-nonzero hypothesis. -/
theorem mixed_zero_four_det_norm_lt_33_128
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (hd : ∀ i, F i i = 0)
    (hsymm : ∀ i j, F i j = F j i)
    (hfirst : ∀ i j, i ≠ j → i = 0 ∨ j = 0 →
      ‖F i j - (1/2 : ℂ)‖ < (1/18 : ℝ))
    (hlater : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      ‖F i j - (1/2 : ℂ)‖ < (1/64 : ℝ)) :
    ‖F.det‖ < (33/128 : ℝ) := by
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
  exact mixedSymmetricFour_det_lt_33_128 _ _ _ _ _ _
    (hfirst 0 1 (by decide) (Or.inl rfl))
    (hfirst 0 2 (by decide) (Or.inl rfl))
    (hfirst 0 3 (by decide) (Or.inl rfl))
    (hlater 1 2 (by decide) (by decide))
    (hlater 1 3 (by decide) (by decide))
    (hlater 2 3 (by decide) (by decide))

end D1Bound5
