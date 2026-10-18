import D1Bound5.CoherentFormBounds

open Finset

namespace D1Bound5

/-- The broader near-one estimates needed by the general three-anchor
lemma.  The analytic branch is fixed by the convergent binomial series. -/
theorem coherent_cpow_half_near_one_36
    (w : ℂ) (hw0 : w ≠ 0) (hw : ‖w‖ ≤ (1 / 36 : ℝ)) :
    (35 / 36 : ℝ) < ‖(1 + w) ^ (1 / 2 : ℂ)‖ ∧
    ‖(1 + w) ^ (1 / 2 : ℂ)‖ < (37 / 36 : ℝ) ∧
    ‖1 - (1 + w) ^ (1 / 2 : ℂ)‖ < (36 / 71 : ℝ) * ‖w‖ := by
  let u : ℂ := (1 + w) ^ (1 / 2 : ℂ)
  let d : ℝ := ‖u - 1‖
  have hw1 : ‖w‖ < 1 := by linarith
  have hd0 : 0 ≤ d := norm_nonneg _
  have hd : d < (1 / 36 : ℝ) := by
    have hb := coherent_cpow_half_sub_one_norm_le w hw1
    have hrat : (1 / 2 : ℝ) * ‖w‖ / (1 - ‖w‖) < (1 / 36 : ℝ) := by
      apply (div_lt_iff₀ (by linarith : 0 < 1 - ‖w‖)).2
      nlinarith only [hw]
    exact hb.trans_lt hrat
  have hdrev : ‖(1 : ℂ) - u‖ = d := norm_sub_rev _ _
  have huupper : ‖u‖ ≤ 1 + d := by
    have h := norm_add_le (1 : ℂ) (u - 1)
    have heq : (1 : ℂ) + (u - 1) = u := by ring
    rw [heq, norm_one] at h
    exact h
  have hulower : 1 ≤ ‖u‖ + d := by
    have h := norm_sub_le u (u - 1)
    have heq : u - (u - 1) = (1 : ℂ) := by ring
    rw [heq, norm_one] at h
    exact h
  have hBlower : (71 / 36 : ℝ) < ‖(1 : ℂ) + u‖ := by
    have h := norm_sub_le ((1 : ℂ) + u) (u - 1)
    have heq : (1 : ℂ) + u - (u - 1) = 2 := by ring
    rw [heq, Complex.norm_two] at h
    change 2 ≤ ‖(1 : ℂ) + u‖ + d at h
    linarith
  have hsq : u ^ 2 = 1 + w := coherent_cpow_half_sq (1 + w)
  have hprod : ((1 : ℂ) - u) * (1 + u) = -w := by linear_combination -hsq
  have hnorm : d * ‖(1 : ℂ) + u‖ = ‖w‖ := by
    simpa only [norm_mul, norm_neg, hdrev] using congrArg norm hprod
  have hdpos : 0 < d := by
    have hwpos : 0 < ‖w‖ := norm_pos_iff.mpr hw0
    by_contra h
    have hz : d = 0 := by linarith
    rw [hz, zero_mul] at hnorm
    linarith
  have hdist : d < (36 / 71 : ℝ) * ‖w‖ := by
    have h := mul_lt_mul_of_pos_left hBlower hdpos
    rw [hnorm] at h
    linarith
  change (35 / 36 : ℝ) < ‖u‖ ∧ ‖u‖ < (37 / 36 : ℝ) ∧
    ‖1-u‖ < (36 / 71 : ℝ) * ‖w‖
  rw [hdrev]
  exact ⟨by linarith, by linarith, hdist⟩

private theorem coherent_three_coefficients :
    halfBinomialCoeff 3 = 1 / 16 ∧ halfBinomialCoeff 4 = -5 / 128 := by
  have h1 : halfBinomialCoeff 1 = 1 / 2 := by
    norm_num [halfBinomialCoeff, Ring.choose_one_right]
  have h2 : halfBinomialCoeff 2 = -1 / 8 := by
    have h := halfBinomialCoeff_recurrence 1
    norm_num [h1] at h
    linarith
  have h3 : halfBinomialCoeff 3 = 1 / 16 := by
    have h := halfBinomialCoeff_recurrence 2
    norm_num [h2] at h
    linarith
  refine ⟨h3, ?_⟩
  have h := halfBinomialCoeff_recurrence 3
  norm_num [h3] at h
  linarith

/-- A convenient envelope for the exact three-anchor tail bound.
It uses the sharp first coefficient of the tail; the resulting `1/3`
constant is sufficient for the manuscript's general estimate. -/
theorem coherent_three_remainder_envelope
    (x y : ℂ) (A P : ℝ) (hA : 0 < A) (hP : 0 < P)
    (hx : ‖x‖ ≤ 1 / P) (hy : ‖y‖ ≤ 1 / P) (hAP : 9 ≤ A * P) :
    ‖halfBinomialWeightedCoeff x y 3‖ +
      (4 * |halfBinomialCoeff 4|) / P ^ 3 *
        (1 / (1 - 1 / (A * P)) ^ 3 - 1) ≤ 1 / (3 * P ^ 3) := by
  obtain ⟨hb3, hb4⟩ := coherent_three_coefficients
  have hc := halfBinomialWeightedCoeff_norm_le x y (1/P) (by positivity) hx hy 3 (by decide)
  rw [hb3] at hc
  norm_num at hc
  have hc' : ‖halfBinomialWeightedCoeff x y 3‖ ≤ 1 / (4 * P ^ 3) := by
    calc
      _ ≤ (1 / 4 : ℝ) * (1 / P) ^ 3 := hc
      _ = _ := by field_simp; ring
  have hinv : 1 / (A * P) ≤ (1 / 9 : ℝ) :=
    one_div_le_one_div_of_le (by norm_num) hAP
  have hbase : (8 / 9 : ℝ) ≤ 1 - 1 / (A * P) := by linarith
  have hbase3 : (512 / 729 : ℝ) ≤ (1 - 1 / (A * P)) ^ 3 := by
    have h : (8 / 9 : ℝ) ^ 3 ≤ (1 - 1 / (A * P)) ^ 3 := by gcongr
    norm_num at h
    exact h
  have hfactor : 1 / (1 - 1 / (A * P)) ^ 3 - 1 ≤ (217 / 512 : ℝ) := by
    have h := one_div_le_one_div_of_le (by norm_num : (0 : ℝ) < 512 / 729) hbase3
    norm_num at h
    linarith
  have ht : (4 * |halfBinomialCoeff 4|) / P ^ 3 *
      (1 / (1 - 1 / (A * P)) ^ 3 - 1) ≤ 1085 / (16384 * P ^ 3) := by
    rw [hb4]
    norm_num
    calc
      (5 / 32 : ℝ) / P ^ 3 * (1 / (1 - 1 / (A * P)) ^ 3 - 1) ≤
          (5 / 32 : ℝ) / P ^ 3 * (217 / 512) :=
        mul_le_mul_of_nonneg_left hfactor (by positivity)
      _ = _ := by ring
  calc
    _ ≤ 1 / (4 * P ^ 3) + 1085 / (16384 * P ^ 3) := add_le_add hc' ht
    _ ≤ 1 / (3 * P ^ 3) := by
      apply le_of_lt
      calc
        _ = ((1 / 4 : ℝ) + 1085 / 16384) / P ^ 3 := by field_simp; ring
        _ < (1 / 3 : ℝ) / P ^ 3 := div_lt_div_of_pos_right (by norm_num) (by positivity)
        _ = _ := by field_simp; ring

/-- Scalar conversion with comfortable rational margins; the stronger
tail envelope above yields `96/35 < 3` for the second contribution. -/
theorem coherent_three_general_scalar
    (A B S P Q E Z D d L : ℝ)
    (hA : 0 < A) (hB : 0 < B) (hS : 0 < S) (hP : 0 < P) (hQ : 0 < Q)
    (hE : 0 < E) (hZ : 0 < Z) (hd0 : 0 ≤ d)
    (hD : D ≤ 8 * B * S ^ 2) (hEsq : E ^ 2 = P * Q)
    (hZlo : (35 / 36 : ℝ) * E < Z) (hZhi : Z < (37 / 36 : ℝ) * E)
    (hd : d < 36 / (71 * P * Q))
    (hL : L ≤ D * E * (d + (1 / (3 * P ^ 3)) / (A * B * S))) :
    L < 5 * B * S ^ 2 / Z + 3 * S * Z / (A * P ^ 3) := by
  have hfirst : 8 * B * S ^ 2 * E * d < 5 * B * S ^ 2 / Z := by
    have h1 := mul_lt_mul_of_pos_left hd (by positivity : 0 < 8 * B * S ^ 2 * E)
    have heq : 8 * B * S ^ 2 * E * (36 / (71 * P * Q)) =
        288 * B * S ^ 2 / (71 * E) := by
      rw [← hEsq]
      field_simp
      ring
    have h2 : 288 * B * S ^ 2 / (71 * E) < 5 * B * S ^ 2 / Z := by
      apply (div_lt_div_iff₀ (by positivity) hZ).2
      have h := mul_lt_mul_of_pos_left hZhi (by positivity : 0 < 288 * B * S ^ 2)
      nlinarith only [h, mul_pos (mul_pos hB (sq_pos_of_pos hS)) hE]
    exact (h1.trans_eq heq).trans h2
  have hsecond : 8 * B * S ^ 2 * E * ((1 / (3 * P ^ 3)) / (A * B * S)) <
      3 * S * Z / (A * P ^ 3) := by
    have heq : 8 * B * S ^ 2 * E * ((1 / (3 * P ^ 3)) / (A * B * S)) =
        8 * S * E / (3 * A * P ^ 3) := by field_simp; ring
    rw [heq]
    apply (div_lt_div_iff₀ (by positivity) (by positivity)).2
    have hz : 8 * E < 9 * Z := by linarith
    have h := mul_lt_mul_of_pos_right hz (by positivity : 0 < S * A * P ^ 3)
    nlinarith only [h]
  have hcoarse : L ≤ 8 * B * S ^ 2 * E * d +
      8 * B * S ^ 2 * E * ((1 / (3 * P ^ 3)) / (A * B * S)) := by
    calc
      L ≤ D * E * (d + (1 / (3 * P ^ 3)) / (A * B * S)) := hL
      _ ≤ (8 * B * S ^ 2) * E * (d + (1 / (3 * P ^ 3)) / (A * B * S)) :=
        mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_right hD hE.le) (by positivity)
      _ = _ := by ring
  exact hcoarse.trans_lt (add_lt_add hfirst hsecond)

/-- The general three-anchor estimate for the actual coherent form.
Only ordered anchor moduli and the manuscript's size conditions remain;
no auxiliary analytic approximation or remainder bound is assumed. -/
theorem coherent_three_general_norm_lt
    (a : Fin 3 → ℂ) (p q eta : ℂ) (hinj : Function.Injective a)
    (hA : 0 < ‖a 0‖) (hAB : ‖a 0‖ ≤ ‖a 1‖) (hBS : ‖a 1‖ ≤ ‖a 2‖)
    (hP : 4 * ‖a 2‖ ≤ ‖p‖) (hAP : 9 ≤ ‖a 0‖ * ‖p‖)
    (hQ : ‖p‖ ≤ ‖q‖) (heta : eta ^ 2 = p * q) :
    ‖coherentQuotientForm a (coherentVandermonde3 a) p q eta‖ <
      5 * ‖a 1‖ * ‖a 2‖ ^ 2 / ‖coherentTerminalRoot p q eta‖ +
        3 * ‖a 2‖ * ‖coherentTerminalRoot p q eta‖ / (‖a 0‖ * ‖p‖ ^ 3) := by
  let A := ‖a 0‖
  let B := ‖a 1‖
  let S := ‖a 2‖
  let P := ‖p‖
  let Q := ‖q‖
  let E := ‖eta‖
  let Z := ‖coherentTerminalRoot p q eta‖
  let D := ‖coherentVandermonde3 a‖
  let f : ℂ := (1 + p⁻¹ * q⁻¹) ^ (1 / 2 : ℂ)
  let d := ‖1 - f‖
  have hB : 0 < B := hA.trans_le hAB
  have hS : 0 < S := hB.trans_le hBS
  have hP0 : 0 < P := by
    change 0 < ‖p‖
    have hs : 0 < ‖a 2‖ := hS
    nlinarith only [hP, hs]
  have hQ0 : 0 < Q := hP0.trans_le hQ
  have hp0 : p ≠ 0 := norm_pos_iff.mp hP0
  have hq0 : q ≠ 0 := norm_pos_iff.mp hQ0
  have heta0 : eta ≠ 0 := by
    intro hz
    rw [hz, zero_pow (by decide : (2 : ℕ) ≠ 0)] at heta
    exact (mul_ne_zero hp0 hq0) heta.symm
  have hE : 0 < E := norm_pos_iff.mpr heta0
  have hEsq : E ^ 2 = P * Q := by
    simpa only [E, P, Q, norm_pow, norm_mul] using congrArg norm heta
  have hPQ36 : (36 : ℝ) ≤ P * Q := by
    have hPA : 4 * A ≤ P := by dsimp [A, P]; linarith only [hAB, hBS, hP]
    have h1 := mul_le_mul_of_nonneg_right hPA hP0.le
    have h2 := mul_le_mul_of_nonneg_left hQ hP0.le
    nlinarith only [h1, h2, hAP]
  have hW : ‖p⁻¹ * q⁻¹‖ = 1 / (P * Q) := by
    simp [P, Q, norm_mul, norm_inv, one_div, mul_inv_rev, mul_comm]
  have hWsmall : ‖p⁻¹ * q⁻¹‖ ≤ (1 / 36 : ℝ) := by
    rw [hW]
    exact one_div_le_one_div_of_le (by norm_num) hPQ36
  have hnear := coherent_cpow_half_near_one_36 (p⁻¹ * q⁻¹)
    (mul_ne_zero (inv_ne_zero hp0) (inv_ne_zero hq0)) hWsmall
  have hZeq : Z = E * ‖f‖ := by simp only [Z, E, f, coherentTerminalRoot, norm_mul]
  have hZlo : (35 / 36 : ℝ) * E < Z := by
    rw [hZeq]
    simpa only [mul_comm] using mul_lt_mul_of_pos_left hnear.1 hE
  have hZhi : Z < (37 / 36 : ℝ) * E := by
    rw [hZeq]
    simpa only [mul_comm] using mul_lt_mul_of_pos_left hnear.2.1 hE
  have hZ : 0 < Z := by nlinarith only [hZlo, hE]
  have hd : d < 36 / (71 * P * Q) := by
    have h := hnear.2.2
    rw [hW] at h
    calc
      d < (36 / 71 : ℝ) * (1 / (P * Q)) := h
      _ = _ := by ring
  have ha : ∀ i, A ≤ ‖a i‖ := by
    intro i
    fin_cases i
    · exact le_rfl
    · exact hAB
    · exact hAB.trans hBS
  have hp : ‖p⁻¹‖ ≤ 1 / P := by simp [P, norm_inv, one_div]
  have hq : ‖q⁻¹‖ ≤ 1 / P := by
    simpa only [Q, norm_inv, one_div] using one_div_le_one_div_of_le hP0 hQ
  have hDelta : coherentVandermonde3 a ≠ 0 := by
    exact mul_ne_zero
      (mul_ne_zero (sub_ne_zero.mpr (hinj.ne (by decide)))
        (sub_ne_zero.mpr (hinj.ne (by decide))))
      (sub_ne_zero.mpr (hinj.ne (by decide)))
  have hprod : (∏ i, ‖a i‖) = A * B * S := by
    simp [Fin.prod_univ_succ, A, B, S, mul_assoc]
  have hD : D ≤ 8 * B * S ^ 2 := by
    have h01 : ‖a 0 - a 1‖ ≤ 2 * B := by
      have h := norm_sub_le (a 0) (a 1)
      dsimp [B]
      linarith only [h, hAB]
    have h02 : ‖a 0 - a 2‖ ≤ 2 * S := by
      have h := norm_sub_le (a 0) (a 2)
      dsimp [S]
      linarith only [h, hAB, hBS]
    have h12 : ‖a 1 - a 2‖ ≤ 2 * S := by
      have h := norm_sub_le (a 1) (a 2)
      dsimp [S]
      linarith only [h, hBS]
    calc
      D = ‖a 0 - a 1‖ * ‖a 0 - a 2‖ * ‖a 1 - a 2‖ := by
        simp only [D, coherentVandermonde3, norm_mul]
      _ ≤ (2 * B) * (2 * S) * (2 * S) :=
        mul_le_mul (mul_le_mul h01 h02 (norm_nonneg _) (by positivity)) h12
          (norm_nonneg _) (by positivity)
      _ = _ := by ring
  have henv := coherent_three_remainder_envelope p⁻¹ q⁻¹ A P hA hP0 hp hq hAP
  have hbound := coherentQuotientForm_norm_le a (by decide) hinj
    (coherentVandermonde3 a) p q eta hDelta heta0 A P hA hP0 ha hp hq (by linarith)
  have hL : ‖coherentQuotientForm a (coherentVandermonde3 a) p q eta‖ ≤
      D * E * (d + (1 / (3 * P ^ 3)) / (A * B * S)) := by
    rw [hprod] at hbound
    exact hbound.trans (mul_le_mul_of_nonneg_left
      (add_le_add_left (div_le_div_of_nonneg_right henv (by positivity)) _)
      (by positivity : 0 ≤ D * E))
  exact coherent_three_general_scalar A B S P Q E Z D d
    ‖coherentQuotientForm a (coherentVandermonde3 a) p q eta‖
    hA hB hS hP0 hQ0 hE hZ (norm_nonneg _) hD hEsq hZlo hZhi hd hL

end D1Bound5

