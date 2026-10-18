import D1Bound5.CoherentFormBounds
import D1Bound5.HalfBinomialLowDegree

open Finset

noncomputable section

namespace D1Bound5

def coherentThreeTailConstant (H : ℝ) : ℝ :=
  (5/32 : ℝ) * ((H/(H-1))^3-1)

def coherentThreeLowerConstant (H : ℝ) : ℝ :=
  (45/1024 : ℝ) - coherentThreeTailConstant H

def coherentThreeUpperConstant (H : ℝ) : ℝ :=
  (85/1024 : ℝ) + coherentThreeTailConstant H

private theorem coherent_parameter_coeff_four : halfBinomialCoeff 4 = -5/128 := by
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
  have h := halfBinomialCoeff_recurrence 3
  norm_num [h3] at h
  linarith

/-- Both sharp elementary degree-three bounds under quarter-size
terminal separation.  The lower bound is a reverse triangle estimate
on each of the two factors, so no phase or square-root sign is assumed. -/
theorem halfBinomialWeightedCoeff_three_norm_bounds
    (x y : ℂ) (P : ℝ) (hP : 0 < P)
    (hx : ‖x‖ = 1/P) (hy : ‖y‖ ≤ 1/(4*P)) :
    45/(1024*P^3) ≤ ‖halfBinomialWeightedCoeff x y 3‖ ∧
    ‖halfBinomialWeightedCoeff x y 3‖ ≤ 85/(1024*P^3) := by
  have hy2 : ‖y‖^2 ≤ (1/(4*P))^2 := by gcongr
  have hUupper : ‖x-y‖ ≤ 5/(4*P) := by
    calc
      ‖x-y‖ ≤ ‖x‖+‖y‖ := norm_sub_le _ _
      _ ≤ 1/P+1/(4*P) := by rw [hx]; exact add_le_add_left hy _
      _ = _ := by field_simp; ring
  have hUlower : 3/(4*P) ≤ ‖x-y‖ := by
    have h := norm_add_le (x-y) y
    rw [sub_add_cancel, hx] at h
    have heq : 1/P-1/(4*P) = 3/(4*P) := by field_simp; ring
    linarith only [h, hy, heq]
  have hVupper : ‖x^2-y^2‖ ≤ 17/(16*P^2) := by
    calc
      ‖x^2-y^2‖ ≤ ‖x^2‖+‖y^2‖ := norm_sub_le _ _
      _ = (1/P)^2+‖y‖^2 := by rw [norm_pow, norm_pow, hx]
      _ ≤ (1/P)^2+(1/(4*P))^2 := add_le_add_left hy2 _
      _ = _ := by field_simp; ring
  have hVlower : 15/(16*P^2) ≤ ‖x^2-y^2‖ := by
    have h := norm_add_le (x^2-y^2) (y^2)
    rw [sub_add_cancel, norm_pow, norm_pow, hx] at h
    have heq : (1/P)^2-(1/(4*P))^2 = 15/(16*P^2) := by field_simp; ring
    linarith only [h, hy2, heq]
  have hcoeff : ‖halfBinomialWeightedCoeff x y 3‖ = ‖x^2-y^2‖*‖x-y‖/16 := by
    rw [halfBinomialWeightedCoeff_three, norm_div, norm_mul]
    norm_num
  rw [hcoeff]
  constructor
  · calc
      _ = (15/(16*P^2))*(3/(4*P))/16 := by field_simp; ring
      _ ≤ ‖x^2-y^2‖*‖x-y‖/16 :=
        div_le_div_of_nonneg_right
          (mul_le_mul hVlower hUlower (by positivity) (norm_nonneg _)) (by norm_num)
  · calc
      _ ≤ (17/(16*P^2))*(5/(4*P))/16 :=
        div_le_div_of_nonneg_right
          (mul_le_mul hVupper hUupper (norm_nonneg _) (by positivity)) (by norm_num)
      _ = _ := by field_simp; ring

/-- The exact manuscript error factor at any parameter `H>1`. -/
theorem coherent_three_tail_factor_le
    (A P H : ℝ) (hH : 1 < H) (hAP : H ≤ A*P) :
    1/(1-1/(A*P))^3-1 ≤ (H/(H-1))^3-1 := by
  have hH0 : 0 < H := by linarith
  have hHm : 0 < H-1 := by linarith
  have hinv : 1/(A*P) ≤ 1/H := one_div_le_one_div_of_le hH0 hAP
  have hbase : (H-1)/H ≤ 1-1/(A*P) := by
    have heq : (H-1)/H = 1-1/H := by field_simp; ring
    rw [heq]
    linarith
  have hbase3 : ((H-1)/H)^3 ≤ (1-1/(A*P))^3 := by gcongr
  have h := one_div_le_one_div_of_le (by positivity : 0 < ((H-1)/H)^3) hbase3
  have heq : 1/((H-1)/H)^3 = (H/(H-1))^3 := by field_simp; ring
  rw [heq] at h
  linarith

/-- Exact two-sided bounds for the actual complete homogeneous
three-anchor remainder in the manuscript parameter regime. -/
theorem coherentRemainder_three_parameter_norm_bounds
    (a : Fin 3 → ℂ) (p q : ℂ) (A P H : ℝ)
    (hA : 0 < A) (hP : 0 < P) (ha : ∀ i, A ≤ ‖a i‖)
    (hp : ‖p⁻¹‖ = 1/P) (hq : ‖q⁻¹‖ ≤ 1/(4*P))
    (hH : 1 < H) (hAP : H ≤ A*P) :
    coherentThreeLowerConstant H / P^3 ≤ ‖coherentRemainder a p q‖ ∧
    ‖coherentRemainder a p q‖ ≤ coherentThreeUpperConstant H / P^3 := by
  have hq' : ‖q⁻¹‖ ≤ 1/P :=
    hq.trans (one_div_le_one_div_of_le hP (by nlinarith))
  have ht := coherentRemainder_norm_sub_le a (by decide) p q A P hA hP ha hp.le hq'
    (hH.trans_le hAP)
  norm_num [coherent_parameter_coeff_four] at ht
  have hfactor := coherent_three_tail_factor_le A P H hH hAP
  have htail : ‖coherentRemainder a p q-halfBinomialWeightedCoeff p⁻¹ q⁻¹ 3‖ ≤
      coherentThreeTailConstant H/P^3 := by
    calc
      _ ≤ (5/32 : ℝ)/P^3*(1/(1-1/(A*P))^3-1) := ht
      _ ≤ (5/32 : ℝ)/P^3*((H/(H-1))^3-1) :=
        mul_le_mul_of_nonneg_left hfactor (by positivity)
      _ = _ := by dsimp [coherentThreeTailConstant]; ring
  obtain ⟨hcLow,hcUp⟩ := halfBinomialWeightedCoeff_three_norm_bounds p⁻¹ q⁻¹ P hP hp hq
  have hLowTriangle : ‖halfBinomialWeightedCoeff p⁻¹ q⁻¹ 3‖ ≤
      ‖coherentRemainder a p q‖ +
        ‖coherentRemainder a p q-halfBinomialWeightedCoeff p⁻¹ q⁻¹ 3‖ := by
    have h := norm_sub_le (coherentRemainder a p q)
      (coherentRemainder a p q-halfBinomialWeightedCoeff p⁻¹ q⁻¹ 3)
    simpa only [sub_sub_cancel] using h
  have hUpTriangle : ‖coherentRemainder a p q‖ ≤
      ‖halfBinomialWeightedCoeff p⁻¹ q⁻¹ 3‖ +
        ‖coherentRemainder a p q-halfBinomialWeightedCoeff p⁻¹ q⁻¹ 3‖ := by
    have h := norm_add_le (halfBinomialWeightedCoeff p⁻¹ q⁻¹ 3)
      (coherentRemainder a p q-halfBinomialWeightedCoeff p⁻¹ q⁻¹ 3)
    have heq : halfBinomialWeightedCoeff p⁻¹ q⁻¹ 3 +
        (coherentRemainder a p q-halfBinomialWeightedCoeff p⁻¹ q⁻¹ 3) =
        coherentRemainder a p q := by ring
    rw [heq] at h
    exact h
  constructor
  · have heq : coherentThreeLowerConstant H/P^3 =
        45/(1024*P^3)-coherentThreeTailConstant H/P^3 := by
      dsimp [coherentThreeLowerConstant]
      field_simp
      ring
    rw [heq]
    linarith only [hLowTriangle,hcLow,htail]
  · have heq : coherentThreeUpperConstant H/P^3 =
        85/(1024*P^3)+coherentThreeTailConstant H/P^3 := by
      dsimp [coherentThreeUpperConstant]
      field_simp
      ring
    rw [heq]
    linarith only [hUpTriangle,hcUp,htail]

/-- All exact rational comparisons for the manuscript's two rows. -/
theorem coherent_three_parameter_rows :
    (0 < coherentThreeLowerConstant 32 ∧
      100*coherentThreeUpperConstant 32/99 < (1/10 : ℝ) ∧
      5 < 100/(201*coherentThreeUpperConstant 32) ∧
      100/(199*coherentThreeLowerConstant 32) < 179/10) ∧
    (0 < coherentThreeLowerConstant 48 ∧
      100*coherentThreeUpperConstant 48/99 < (19/200 : ℝ) ∧
      5 < 100/(201*coherentThreeUpperConstant 48) ∧
      100/(199*coherentThreeLowerConstant 48) < 15) := by
  norm_num [coherentThreeLowerConstant, coherentThreeUpperConstant, coherentThreeTailConstant]

end D1Bound5

