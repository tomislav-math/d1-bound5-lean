import D1Bound5.FinitePAdaptiveTailData
import D1Bound5.FinitePRatioMonomial

namespace D1Bound5

noncomputable def finitePAdaptiveTailCoeffWeight (i : Fin 4) (l j : Fin 3) (x : ℝ) : ℝ :=
  ∑ t : Fin 3, |((finitePRootTerms i l j t).1 : ℝ)| *
    x^(finitePAdaptiveTailExponent i l j t)

theorem finitePRootCoeff_adaptive_norm_le (a b s : ℂ)
    (hA : 1 ≤ ‖a‖) (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖)
    (i : Fin 4) (l j : Fin 3) :
    ‖finitePRootCoeff a b s i l j‖ ≤
      finitePAdaptiveTailCoeffWeight i l j (‖a‖/‖b‖)*
        (‖s‖^2/‖a‖^4)*‖![a,b,s] j‖^(5+(l : ℕ)) := by
  let A := ‖a‖
  let B := ‖b‖
  let S := ‖s‖
  let U := ‖![a,b,s] j‖
  have hA0 : 0 < A := by linarith only [hA]
  have hB0 : 0 < B := hA0.trans_le hAB
  have hS0 : 0 < S := hB0.trans_le hBS
  have hAU : A ≤ U := by
    fin_cases j
    · exact le_rfl
    · exact hAB
    · exact hAB.trans hBS
  have hU : 0 < U := hA0.trans_le hAU
  have hroot : ![A,B,S] j = U := by fin_cases j <;> rfl
  have ht (t : Fin 3) : ‖finitePTermValue (finitePRootTerms i l j t) a b s‖ ≤
      |((finitePRootTerms i l j t).1 : ℝ)| *(A/B)^(finitePAdaptiveTailExponent i l j t)*
        (S^2/A^4)*U^(5+(l : ℕ)) := by
    let u := finitePRootTerms i l j t
    let e := finitePAdaptiveTailExponent i l j t
    obtain ⟨hdeg,h0,h1,h2⟩ := finitePAdaptiveTailExponent_certificate i l j t
    have he : e+u.2.2.1+u.2.2.2 = if j=0 then 2 else (4+(l : ℕ))+2 := by
      fin_cases j
      · exact h0 rfl
      · exact (h1 rfl).1
      · exact h2 rfl
    have hl : j ≠ 2 → u.2.2.2 ≤ 2 := by
      intro hj
      fin_cases j
      · have hh := h0 rfl
        dsimp [u] at *
        omega
      · exact (h1 rfl).2
      · exact False.elim (hj rfl)
    have hr := finiteP_ratio_monomial_bound A B S hA hAB hBS j
      u.2.1 u.2.2.1 u.2.2.2 (4+(l : ℕ)) 3 e hdeg he hl
    rw [hroot] at hr
    have hm := (div_le_iff₀ (pow_pos hU _)).mp hr
    have hextra : (S^2/A^3)*(A/B)^e*U^(4+(l : ℕ)) ≤
        (A/B)^e*(S^2/A^4)*U^(5+(l : ℕ)) := by
      have hh := mul_le_mul_of_nonneg_left hAU
        (show 0 ≤ S^2*(A/B)^e*U^(4+(l : ℕ))/A^4 by positivity)
      calc
        _ = (S^2*(A/B)^e*U^(4+(l : ℕ))/A^4)*A := by
          field_simp [hA0.ne'] <;> ring
        _ ≤ (S^2*(A/B)^e*U^(4+(l : ℕ))/A^4)*U := hh
        _ = _ := by
          simp only [show 5+(l : ℕ)=(4+(l : ℕ))+1 by omega,pow_add,pow_one]
          ring
    have hscalar := hm.trans hextra
    have hnorm : ‖(u.1 : ℂ)‖ = |(u.1 : ℝ)| := by simp
    have hh := mul_le_mul_of_nonneg_left hscalar (abs_nonneg (u.1 : ℝ))
    simpa [finitePTermValue,norm_mul,norm_pow,hnorm,A,B,S,U,u,e,mul_assoc] using hh
  calc
    _ ≤ ∑ t, ‖finitePTermValue (finitePRootTerms i l j t) a b s‖ := norm_sum_le _ _
    _ ≤ ∑ t, |((finitePRootTerms i l j t).1 : ℝ)| *
        (A/B)^(finitePAdaptiveTailExponent i l j t)*(S^2/A^4)*U^(5+(l : ℕ)) :=
      Finset.sum_le_sum (fun t _ => ht t)
    _ = _ := by simp [finitePAdaptiveTailCoeffWeight,Finset.sum_mul,A,B,S,U]

private theorem finiteP_remainder_scaled (u c : ℂ) (A : ℝ) (n : ℕ)
    (hA1 : 1 ≤ A) (hAu : A ≤ ‖u‖) (hAC : 1000 ≤ A*‖c‖) (hn : 6 ≤ n) :
    ‖finiteQHalfRemainder n (1/(u*c))‖ ≤
      (21/1024 : ℝ)*(1/(‖u‖*‖c‖))^n*(1000/999) := by
  have hA : 0 < A := by linarith only [hA1]
  have hU : 0 < ‖u‖ := hA.trans_le hAu
  have hC : 0 < ‖c‖ := by
    by_contra h
    have he : ‖c‖=0 := le_antisymm (le_of_not_gt h) (norm_nonneg c)
    rw [he,mul_zero] at hAC
    norm_num at hAC
  have hUC : 1000 ≤ ‖u‖*‖c‖ := hAC.trans (mul_le_mul_of_nonneg_right hAu hC.le)
  have hr : 1/(‖u‖*‖c‖) ≤ (1/1000 : ℝ) :=
    (div_le_div_iff₀ (mul_pos hU hC) (by norm_num)).mpr (by simpa using hUC)
  have hnorm : ‖1/(u*c)‖ = 1/(‖u‖*‖c‖) := by simp [norm_div,norm_mul]
  have hrem := finitePHalfRemainder_norm_le n (1/(u*c)) hn (by rw [hnorm]; linarith only [hr])
  rw [hnorm] at hrem
  have heta : 0 < 1-1/(‖u‖*‖c‖) := by linarith only [hr]
  have hinv : 1/(1-1/(‖u‖*‖c‖)) ≤ (1000/999 : ℝ) :=
    (div_le_iff₀ heta).mpr (by linarith only [hr])
  apply hrem.trans
  have hm := mul_le_mul_of_nonneg_left hinv
    (show 0 ≤ (21/1024 : ℝ)*(1/(‖u‖*‖c‖))^n by positivity)
  convert hm using 1 <;> ring

/-- Actual adaptive tail estimate. Its coefficient is the positive
polynomial obtained from the already-combined integer root columns. -/
theorem finitePTail_adaptive_norm_le (a b s c : ℂ)
    (hA : 1 ≤ ‖a‖) (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖)
    (hAC : 1000 ≤ ‖a‖*‖c‖) (i : Fin 4) :
    ‖finitePTail a b s c i‖ ≤
      (21/(1024*999) : ℝ)*finitePAdaptiveTailWeight i (‖a‖/‖b‖)*
        ‖s‖^2/(‖a‖^3*‖c‖^5) := by
  have hA0 : 0 < ‖a‖ := by linarith only [hA]
  have hB0 : 0 < ‖b‖ := hA0.trans_le hAB
  have hS0 : 0 < ‖s‖ := hB0.trans_le hBS
  have hC0 : 0 < ‖c‖ := by
    by_contra h
    have he : ‖c‖=0 := le_antisymm (le_of_not_gt h) (norm_nonneg c)
    rw [he,mul_zero] at hAC
    norm_num at hAC
  let x := ‖a‖/‖b‖
  let K := (21/1024 : ℝ)*(1000/999)*‖s‖^2/(‖a‖^4*‖c‖^6)
  have hK : 0 ≤ K := by dsimp [K]; positivity
  have hx : 0 ≤ x := by dsimp [x]; positivity
  have hAU (j : Fin 3) : ‖a‖ ≤ ‖![a,b,s] j‖ := by
    fin_cases j
    · exact le_rfl
    · exact hAB
    · exact hAB.trans hBS
  have hU (j : Fin 3) : 0 < ‖![a,b,s] j‖ := hA0.trans_le (hAU j)
  have hterm (j l : Fin 3) :
      ‖![a,b,s] j*finitePRootCoeff a b s i l j*c^(l : ℕ)*
        finiteQHalfRemainder (6+(l : ℕ)) (1/(![a,b,s] j*c))‖ ≤
      finitePAdaptiveTailCoeffWeight i l j x*K := by
    have hc := finitePRootCoeff_adaptive_norm_le a b s hA hAB hBS i l j
    have hr := finiteP_remainder_scaled (![a,b,s] j) c ‖a‖ (6+(l : ℕ))
      hA (hAU j) hAC (by omega)
    have hw : 0 ≤ finitePAdaptiveTailCoeffWeight i l j x := by
      unfold finitePAdaptiveTailCoeffWeight
      exact Finset.sum_nonneg (fun _ _ => mul_nonneg (abs_nonneg _) (pow_nonneg hx _))
    calc
      _ = ‖![a,b,s] j‖*‖finitePRootCoeff a b s i l j‖*‖c‖^(l : ℕ)*
          ‖finiteQHalfRemainder (6+(l : ℕ)) (1/(![a,b,s] j*c))‖ := by
        simp only [norm_mul,norm_pow]
      _ ≤ ‖![a,b,s] j‖*(finitePAdaptiveTailCoeffWeight i l j x*(‖s‖^2/‖a‖^4)*
          ‖![a,b,s] j‖^(5+(l : ℕ)))*‖c‖^(l : ℕ)*
          ((21/1024 : ℝ)*(1/(‖![a,b,s] j‖*‖c‖))^(6+(l : ℕ))*(1000/999)) := by
        gcongr
      _ = _ := by
        dsimp [K]
        simp only [pow_add,mul_pow,div_pow,one_pow]
        field_simp [hA0.ne',(hU j).ne',hC0.ne']
        <;> ring
  have hsum : ‖finitePTail a b s c i‖ ≤ finitePAdaptiveTailWeight i x*K := by
    rw [finitePTail_eq_combined]
    calc
      _ ≤ ∑ j : Fin 3, ∑ l : Fin 3,
          ‖![a,b,s] j*finitePRootCoeff a b s i l j*c^(l : ℕ)*
            finiteQHalfRemainder (6+(l : ℕ)) (1/(![a,b,s] j*c))‖ :=
        (norm_sum_le _ _).trans (Finset.sum_le_sum (fun _ _ => norm_sum_le _ _))
      _ ≤ ∑ j : Fin 3, ∑ l : Fin 3, finitePAdaptiveTailCoeffWeight i l j x*K :=
        Finset.sum_le_sum (fun j _ => Finset.sum_le_sum (fun l _ => hterm j l))
      _ = _ := by simp [finitePAdaptiveTailWeight,finitePAdaptiveTailCoeffWeight,Finset.sum_mul]
  apply hsum.trans
  have hratio : 1000/(‖a‖*‖c‖) ≤ 1 := (div_le_one (mul_pos hA0 hC0)).mpr hAC
  have hw : 0 ≤ finitePAdaptiveTailWeight i x := by
    unfold finitePAdaptiveTailWeight
    exact Finset.sum_nonneg (fun _ _ => Finset.sum_nonneg (fun _ _ =>
      Finset.sum_nonneg (fun _ _ => mul_nonneg (abs_nonneg _) (pow_nonneg hx _))))
  have halg : finitePAdaptiveTailWeight i x*K =
      (21/(1024*999) : ℝ)*finitePAdaptiveTailWeight i x*(1000/(‖a‖*‖c‖))*
        (‖s‖^2/(‖a‖^3*‖c‖^5)) := by
    dsimp [K]
    field_simp [hA0.ne',hC0.ne']
    <;> ring
  rw [halg]
  calc
    _ ≤ (21/(1024*999) : ℝ)*finitePAdaptiveTailWeight i x*1*
        (‖s‖^2/(‖a‖^3*‖c‖^5)) := by gcongr
    _ = _ := by dsimp [x]; ring

end D1Bound5
