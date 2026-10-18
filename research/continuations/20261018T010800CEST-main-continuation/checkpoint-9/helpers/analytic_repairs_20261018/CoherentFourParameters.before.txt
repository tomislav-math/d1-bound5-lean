import D1Bound5.CoherentParameterForms

open Finset

namespace D1Bound5

def coherentFourLeadingLower : ℝ :=
  (1-1/1000)^2*(5-6/1000-5/(1000:ℝ)^2)/128

def coherentFourLeadingUpper : ℝ :=
  (1+1/1000)^2*(5+6/1000+5/(1000:ℝ)^2)/128

def coherentFourTailConstant : ℝ := (7/64 : ℝ)*((1000/999 : ℝ)^4-1)

def coherentFourLowerConstant : ℝ := coherentFourLeadingLower-coherentFourTailConstant

def coherentFourUpperConstant : ℝ := coherentFourLeadingUpper+coherentFourTailConstant

private theorem coherent_parameter_coeff_five : halfBinomialCoeff 5 = 7/256 := by
  have h1 : halfBinomialCoeff 1 = 1/2 := by
    norm_num [halfBinomialCoeff, Ring.choose_one_right]
  have h2 : halfBinomialCoeff 2 = -1/8 := by
    have h := halfBinomialCoeff_recurrence 1
    norm_num [h1] at h
    linarith
  have h3 : halfBinomialCoeff 3 = 1/16 := by
    have h := halfBinomialCoeff_recurrence 2
    norm_num [h2] at h
    linarith
  have h4 : halfBinomialCoeff 4 = -5/128 := by
    have h := halfBinomialCoeff_recurrence 3
    norm_num [h3] at h
    linarith
  have h := halfBinomialCoeff_recurrence 4
  norm_num [h4] at h
  linarith

/-- The exact separated degree-four coefficient estimates. -/
theorem halfBinomialWeightedCoeff_four_norm_bounds
    (x y : ℂ) (P : ℝ) (hP : 0 < P)
    (hx : ‖x‖ = 1/P) (hy : ‖y‖ ≤ 1/(1000*P)) :
    coherentFourLeadingLower/P^4 ≤ ‖halfBinomialWeightedCoeff x y 4‖ ∧
    ‖halfBinomialWeightedCoeff x y 4‖ ≤ coherentFourLeadingUpper/P^4 := by
  have hy2 : ‖y‖^2 ≤ (1/(1000*P))^2 := by gcongr
  have hDupper : ‖x-y‖ ≤ 1001/(1000*P) := by
    calc
      _ ≤ ‖x‖+‖y‖ := norm_sub_le _ _
      _ ≤ 1/P+1/(1000*P) := by rw [hx]; exact add_le_add_left hy _
      _ = _ := by field_simp; ring
  have hDlower : 999/(1000*P) ≤ ‖x-y‖ := by
    have h := norm_add_le (x-y) y
    rw [sub_add_cancel,hx] at h
    have heq : 1/P-1/(1000*P) = 999/(1000*P) := by field_simp; ring
    linarith only [h,hy,heq]
  have hDupper2 : ‖x-y‖^2 ≤ (1001/(1000*P))^2 := by gcongr
  have hDlower2 : (999/(1000*P))^2 ≤ ‖x-y‖^2 := by gcongr
  have hX : ‖(5:ℂ)*x^2‖ = 5/P^2 := by
    calc
      _ = 5*(1/P)^2 := by simp [norm_mul,norm_pow,hx]
      _ = _ := by field_simp; ring
  have hXY : ‖(6:ℂ)*x*y‖ ≤ 6/(1000*P^2) := by
    calc
      _ = 6*(1/P)*‖y‖ := by simp [norm_mul,hx]
      _ ≤ 6*(1/P)*(1/(1000*P)) := mul_le_mul_of_nonneg_left hy (by positivity)
      _ = _ := by field_simp; ring
  have hY : ‖(5:ℂ)*y^2‖ ≤ 5/(1000000*P^2) := by
    calc
      _ = 5*‖y‖^2 := by simp [norm_mul,norm_pow]
      _ ≤ 5*(1/(1000*P))^2 := mul_le_mul_of_nonneg_left hy2 (by norm_num)
      _ = _ := by field_simp; ring
  let v : ℂ := 5*x^2+6*x*y+5*y^2
  have hVupper : ‖v‖ ≤ 5006005/(1000000*P^2) := by
    have h1 := norm_add_le ((5:ℂ)*x^2+6*x*y) ((5:ℂ)*y^2)
    have h2 := norm_add_le ((5:ℂ)*x^2) ((6:ℂ)*x*y)
    rw [hX] at h2
    have heq : 5/P^2+6/(1000*P^2)+5/(1000000*P^2) =
        5006005/(1000000*P^2) := by field_simp; ring
    change ‖v‖ ≤ _+_ at h1
    linarith only [h1,h2,hXY,hY,heq]
  have hVlower : 4993995/(1000000*P^2) ≤ ‖v‖ := by
    have h1 := norm_sub_le v ((6:ℂ)*x*y+(5:ℂ)*y^2)
    have heqV : v-((6:ℂ)*x*y+(5:ℂ)*y^2) = (5:ℂ)*x^2 := by dsimp [v]; ring
    rw [heqV,hX] at h1
    have h2 := norm_add_le ((6:ℂ)*x*y) ((5:ℂ)*y^2)
    have heq : 5/P^2-6/(1000*P^2)-5/(1000000*P^2) =
        4993995/(1000000*P^2) := by field_simp; ring
    linarith only [h1,h2,hXY,hY,heq]
  have hc : ‖halfBinomialWeightedCoeff x y 4‖ = ‖x-y‖^2*‖v‖/128 := by
    rw [halfBinomialWeightedCoeff_four,norm_div,norm_mul,norm_neg,norm_pow]
    change ‖x-y‖^2*‖v‖/‖(128:ℂ)‖ = ‖x-y‖^2*‖v‖/128
    norm_num
  rw [hc]
  constructor
  · calc
      _ = (999/(1000*P))^2*(4993995/(1000000*P^2))/128 := by
        dsimp [coherentFourLeadingLower]
        field_simp
        ring
      _ ≤ ‖x-y‖^2*‖v‖/128 := div_le_div_of_nonneg_right
        (mul_le_mul hDlower2 hVlower (by positivity) (by positivity)) (by norm_num)
  · calc
      _ ≤ (1001/(1000*P))^2*(5006005/(1000000*P^2))/128 := div_le_div_of_nonneg_right
        (mul_le_mul hDupper2 hVupper (norm_nonneg _) (by positivity)) (by norm_num)
      _ = _ := by
        dsimp [coherentFourLeadingUpper]
        field_simp
        ring

/-- Two-sided actual remainder bounds in the direct-four regime. -/
theorem coherentRemainder_four_parameter_norm_bounds
    (a : Fin 4 → ℂ) (p q : ℂ) (A P : ℝ)
    (hA : 0 < A) (hP : 0 < P) (ha : ∀ i, A ≤ ‖a i‖)
    (hp : ‖p⁻¹‖ = 1/P) (hq : ‖q⁻¹‖ ≤ 1/(1000*P))
    (hAP : 1000 ≤ A*P) :
    coherentFourLowerConstant/P^4 ≤ ‖coherentRemainder a p q‖ ∧
    ‖coherentRemainder a p q‖ ≤ coherentFourUpperConstant/P^4 := by
  have hq' : ‖q⁻¹‖ ≤ 1/P := hq.trans
    (one_div_le_one_div_of_le hP (by nlinarith))
  have ht := coherentRemainder_norm_sub_le a (by decide) p q A P hA hP ha hp.le hq' (by linarith)
  norm_num [coherent_parameter_coeff_five] at ht
  have hinv : 1/(A*P) ≤ (1/1000 : ℝ) := one_div_le_one_div_of_le (by norm_num) hAP
  have hbase : (999/1000 : ℝ) ≤ 1-1/(A*P) := by linarith
  have hbase4 : (999/1000 : ℝ)^4 ≤ (1-1/(A*P))^4 := by gcongr
  have hfactor : 1/(1-1/(A*P))^4-1 ≤ (1000/999 : ℝ)^4-1 := by
    have h := one_div_le_one_div_of_le (by norm_num : (0:ℝ)<(999/1000:ℝ)^4) hbase4
    norm_num at h ⊢
    linarith
  have htail : ‖coherentRemainder a p q-halfBinomialWeightedCoeff p⁻¹ q⁻¹ 4‖ ≤
      coherentFourTailConstant/P^4 := by
    calc
      _ ≤ (7/64 : ℝ)/P^4*(1/(1-1/(A*P))^4-1) := ht
      _ ≤ (7/64 : ℝ)/P^4*((1000/999 : ℝ)^4-1) :=
        mul_le_mul_of_nonneg_left hfactor (by positivity)
      _ = _ := by dsimp [coherentFourTailConstant]; ring
  obtain ⟨hcLow,hcUp⟩ := halfBinomialWeightedCoeff_four_norm_bounds p⁻¹ q⁻¹ P hP hp hq
  have hLowTriangle : ‖halfBinomialWeightedCoeff p⁻¹ q⁻¹ 4‖ ≤
      ‖coherentRemainder a p q‖ +
        ‖coherentRemainder a p q-halfBinomialWeightedCoeff p⁻¹ q⁻¹ 4‖ := by
    have h := norm_sub_le (coherentRemainder a p q)
      (coherentRemainder a p q-halfBinomialWeightedCoeff p⁻¹ q⁻¹ 4)
    simpa only [sub_sub_cancel] using h
  have hUpTriangle : ‖coherentRemainder a p q‖ ≤
      ‖halfBinomialWeightedCoeff p⁻¹ q⁻¹ 4‖ +
        ‖coherentRemainder a p q-halfBinomialWeightedCoeff p⁻¹ q⁻¹ 4‖ := by
    have h := norm_add_le (halfBinomialWeightedCoeff p⁻¹ q⁻¹ 4)
      (coherentRemainder a p q-halfBinomialWeightedCoeff p⁻¹ q⁻¹ 4)
    have heq : halfBinomialWeightedCoeff p⁻¹ q⁻¹ 4 +
        (coherentRemainder a p q-halfBinomialWeightedCoeff p⁻¹ q⁻¹ 4) =
        coherentRemainder a p q := by ring
    rw [heq] at h
    exact h
  constructor
  · have heq : coherentFourLowerConstant/P^4 =
        coherentFourLeadingLower/P^4-coherentFourTailConstant/P^4 := by
      dsimp [coherentFourLowerConstant]
      ring
    rw [heq]
    linarith only [hLowTriangle,hcLow,htail]
  · have heq : coherentFourUpperConstant/P^4 =
        coherentFourLeadingUpper/P^4+coherentFourTailConstant/P^4 := by
      dsimp [coherentFourUpperConstant]
      ring
    rw [heq]
    linarith only [hUpTriangle,hcUp,htail]

theorem coherent_four_parameter_comparisons :
    0 < coherentFourLowerConstant ∧ 0 < coherentFourUpperConstant ∧
    100*coherentFourUpperConstant/99 < (49/1200 : ℝ) ∧
    10 < 100/(201*coherentFourUpperConstant) ∧
    100/(199*coherentFourLowerConstant) < 17 := by
  norm_num [coherentFourLowerConstant,coherentFourUpperConstant,
    coherentFourLeadingLower,coherentFourLeadingUpper,coherentFourTailConstant]

end D1Bound5

