import D1Bound5.FinitePTailCoefficients

namespace D1Bound5

private theorem finitePPairTail_summand_norm_le (u v c : ℂ) (A S : ℝ)
    (hA1 : 1 ≤ A) (hAu : A ≤ ‖u‖) (hAv : A ≤ ‖v‖)
    (huS : ‖u‖ ≤ S) (hvS : ‖v‖ ≤ S) (hAC : 1000 ≤ A*‖c‖)
    (kind side : Fin 2) (l : Fin 3) :
    ‖![u,v] side*finitePPairCoeff u v kind side l*c^(l : ℕ)*
      finiteQHalfRemainder (6+(l : ℕ)) (1/(![u,v] side*c))‖ ≤
    (finitePTailCoeffWeight kind side l : ℝ)*
      ((21/1024 : ℝ)*(1000/999)*S^2/(A^4*‖c‖^6)) := by
  let U := ‖![u,v] side‖
  let C := ‖c‖
  have hAU : A ≤ U := by fin_cases side <;> assumption
  have hA : 0 < A := by linarith only [hA1]
  have hU : 0 < U := hA.trans_le hAU
  have hC : 0 < C := by
    have hn : 0 ≤ C := norm_nonneg c
    by_contra h
    have he : C=0 := le_antisymm (le_of_not_gt h) hn
    change 1000 ≤ A*C at hAC
    rw [he,mul_zero] at hAC
    norm_num at hAC
  have hUC : 1000 ≤ U*C := hAC.trans (mul_le_mul_of_nonneg_right hAU hC.le)
  have hn : ‖1/(![u,v] side*c)‖ = 1/(U*C) := by simp [U,C,norm_div,norm_mul]
  have hr : 1/(U*C) ≤ (1/1000 : ℝ) :=
    (div_le_div_iff₀ (mul_pos hU hC) (by norm_num)).mpr (by simpa using hUC)
  have hradius : ‖1/(![u,v] side*c)‖ < 1 := by rw [hn]; linarith only [hr]
  have hrem := finitePHalfRemainder_norm_le (6+(l : ℕ)) (1/(![u,v] side*c))
    (by omega) hradius
  rw [hn] at hrem
  have heta : 0 < 1-1/(U*C) := by linarith only [hr]
  have hinv : 1/(1-1/(U*C)) ≤ (1000/999 : ℝ) :=
    (div_le_iff₀ heta).mpr (by linarith only [hr])
  have hr0 : 0 ≤ 1/(U*C) := by positivity
  have hrem' : ‖finiteQHalfRemainder (6+(l : ℕ)) (1/(![u,v] side*c))‖ ≤
      (21/1024 : ℝ)*(1/(U*C))^(6+(l : ℕ))*(1000/999) := by
    apply hrem.trans
    have hm := mul_le_mul_of_nonneg_left hinv
      (show 0 ≤ (21/1024 : ℝ)*(1/(U*C))^(6+(l : ℕ)) by positivity)
    convert hm using 1 <;> ring
  have hcoeff := finitePPairCoeff_norm_le u v A S hA1 hAu hAv huS hvS kind side l
  calc
    _ = U*‖finitePPairCoeff u v kind side l‖*C^(l : ℕ)*
        ‖finiteQHalfRemainder (6+(l : ℕ)) (1/(![u,v] side*c))‖ := by
      simp only [norm_mul,norm_pow,U,C]
    _ ≤ U*((finitePTailCoeffWeight kind side l : ℝ)*(S^2/A^4)*U^(5+(l : ℕ)))*
        C^(l : ℕ)*((21/1024 : ℝ)*(1/(U*C))^(6+(l : ℕ))*(1000/999)) := by
      gcongr
    _ = _ := by
      simp only [pow_add,mul_pow,div_pow,one_pow]
      dsimp [C]
      field_simp [hA.ne',hU.ne',hC.ne']
      <;> ring

/-- Actual Taylor tails for the two pair-row types, with the exact finite
absolute-coefficient totals876 and2676. -/
theorem finitePPairTail_norm_le (u v c : ℂ) (A S : ℝ)
    (hA1 : 1 ≤ A) (hAu : A ≤ ‖u‖) (hAv : A ≤ ‖v‖)
    (huS : ‖u‖ ≤ S) (hvS : ‖v‖ ≤ S) (hAC : 1000 ≤ A*‖c‖) (kind : Fin 2) :
    ‖finitePPairTail u v c kind‖ ≤ (![876,2676] kind : ℕ)*
      ((21/1024 : ℝ)*(1000/999)*S^2/(A^4*‖c‖^6)) := by
  unfold finitePPairTail
  calc
    _ ≤ ∑ side : Fin 2, ∑ l : Fin 3,
        ‖![u,v] side*finitePPairCoeff u v kind side l*c^(l : ℕ)*
          finiteQHalfRemainder (6+(l : ℕ)) (1/(![u,v] side*c))‖ :=
      (norm_sum_le _ _).trans (Finset.sum_le_sum (fun side _ => norm_sum_le _ _))
    _ ≤ ∑ side : Fin 2, ∑ l : Fin 3, (finitePTailCoeffWeight kind side l : ℝ)*
        ((21/1024 : ℝ)*(1000/999)*S^2/(A^4*‖c‖^6)) := by
      apply Finset.sum_le_sum
      intro side _
      apply Finset.sum_le_sum
      intro l _
      exact finitePPairTail_summand_norm_le u v c A S hA1 hAu hAv huS hvS hAC kind side l
    _ = _ := by
      simp only [← Finset.sum_mul,← Nat.cast_sum]
      rw [finitePTailCoeffWeight_sum]

/-- Every actual P-row tail is strictly below one eighth of the common
residual scale. No coefficient or analytic bound is assumed in the statement. -/
theorem finitePTail_norm_lt (a b s c : ℂ)
    (hA : 1 ≤ ‖a‖) (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖)
    (hAC : 1000 ≤ ‖a‖*‖c‖) (i : Fin 4) :
    ‖finitePTail a b s c i‖ < (1/8 : ℝ)*‖s‖^2/(‖a‖^3*‖c‖^5) := by
  have hAS : ‖a‖ ≤ ‖s‖ := hAB.trans hBS
  have hA0 : 0 < ‖a‖ := by linarith only [hA]
  have hS0 : 0 < ‖s‖ := hA0.trans_le hAS
  have hC0 : 0 < ‖c‖ := by
    by_contra h
    have he : ‖c‖=0 := le_antisymm (le_of_not_gt h) (norm_nonneg c)
    rw [he,mul_zero] at hAC
    norm_num at hAC
  let K : ℝ := (21/1024 : ℝ)*(1000/999)*‖s‖^2/(‖a‖^4*‖c‖^6)
  have hK : 0 ≤ K := by dsimp [K]; positivity
  have habR : ‖finitePPairTail a b c 0‖ ≤ 876*K :=
    finitePPairTail_norm_le a b c ‖a‖ ‖s‖ hA le_rfl hAB hAS hBS hAC 0
  have hbsR : ‖finitePPairTail b s c 0‖ ≤ 876*K :=
    finitePPairTail_norm_le b s c ‖a‖ ‖s‖ hA hAB hAS hBS le_rfl hAC 0
  have hasR : ‖finitePPairTail a s c 0‖ ≤ 876*K :=
    finitePPairTail_norm_le a s c ‖a‖ ‖s‖ hA le_rfl hAS hAS le_rfl hAC 0
  have habT : ‖finitePPairTail a b c 1‖ ≤ 2676*K :=
    finitePPairTail_norm_le a b c ‖a‖ ‖s‖ hA le_rfl hAB hAS hBS hAC 1
  have hasT : ‖finitePPairTail a s c 1‖ ≤ 2676*K :=
    finitePPairTail_norm_le a s c ‖a‖ ‖s‖ hA le_rfl hAS hAS le_rfl hAC 1
  have hbsT : ‖finitePPairTail b s c 1‖ ≤ 2676*K :=
    finitePPairTail_norm_le b s c ‖a‖ ‖s‖ hA hAB hAS hBS le_rfl hAC 1
  have hrow : ‖finitePTail a b s c i‖ ≤ 5352*K := by
    fin_cases i
    · exact habR.trans (by nlinarith only [hK])
    · change ‖finitePPairTail a b c 0+finitePPairTail b s c 0-finitePPairTail a s c 0‖ ≤ _
      have hnorm := norm_sub_le (finitePPairTail a b c 0+finitePPairTail b s c 0)
        (finitePPairTail a s c 0)
      have hadd := norm_add_le (finitePPairTail a b c 0) (finitePPairTail b s c 0)
      linarith only [hnorm,hadd,habR,hbsR,hasR,hK]
    · exact habT.trans (by nlinarith only [hK])
    · change ‖finitePPairTail a s c 1-finitePPairTail b s c 1‖ ≤ _
      exact (norm_sub_le _ _).trans (by linarith only [hasT,hbsT])
  apply hrow.trans_lt
  have hratio : 1000/(‖a‖*‖c‖) ≤ 1 :=
    (div_le_one (mul_pos hA0 hC0)).mpr hAC
  have halg : 5352*K = (112392/1022976 : ℝ)*(1000/(‖a‖*‖c‖))*
      (‖s‖^2/(‖a‖^3*‖c‖^5)) := by
    dsimp [K]
    field_simp [hA0.ne',hC0.ne']
    <;> ring
  rw [halg]
  calc
    _ ≤ (112392/1022976 : ℝ)*1*(‖s‖^2/(‖a‖^3*‖c‖^5)) := by gcongr
    _ < (1/8 : ℝ)*(‖s‖^2/(‖a‖^3*‖c‖^5)) := by
      exact mul_lt_mul_of_pos_right (by norm_num) (by positivity)
    _ = _ := by ring

end D1Bound5
