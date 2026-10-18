import D1Bound5.CoherentFormBounds
import D1Bound5.HalfBinomialLowDegree

open Finset

namespace D1Bound5

private theorem coherent_halfCoeff_three : halfBinomialCoeff 3 = 1 / 16 := by
  have h1 : halfBinomialCoeff 1 = 1 / 2 := by
    norm_num [halfBinomialCoeff, Ring.choose_one_right]
  have h2 : halfBinomialCoeff 2 = -1 / 8 := by
    have h := halfBinomialCoeff_recurrence 1
    norm_num [h1] at h
    linarith
  have h := halfBinomialCoeff_recurrence 2
  norm_num [h2] at h
  linarith

/-- The sharper degree-two coefficient bound uses the manuscript's
terminal separation, rather than the generic convolution envelope. -/
theorem halfBinomialWeightedCoeff_two_norm_le
    (x y : ℂ) (P : ℝ) (hP : 0 < P)
    (hx : ‖x‖ ≤ 1 / P) (hy : ‖y‖ ≤ 1 / (4 * P)) :
    ‖halfBinomialWeightedCoeff x y 2‖ ≤ 25 / (128 * P ^ 2) := by
  have hxy : ‖x - y‖ ≤ 5 / (4 * P) := by
    calc
      ‖x - y‖ ≤ ‖x‖ + ‖y‖ := norm_sub_le _ _
      _ ≤ 1 / P + 1 / (4 * P) := add_le_add hx hy
      _ = 5 / (4 * P) := by field_simp; ring
  have hsquare : ‖x - y‖ ^ 2 ≤ (5 / (4 * P)) ^ 2 := by
    have h := mul_nonneg (sub_nonneg.mpr hxy)
      (add_nonneg (norm_nonneg (x-y)) (by positivity : 0 ≤ 5 / (4 * P)))
    nlinarith only [h]
  calc
    ‖halfBinomialWeightedCoeff x y 2‖ = ‖x - y‖ ^ 2 / 8 := by
      rw [halfBinomialWeightedCoeff_two, norm_div, norm_neg, norm_pow]
      norm_num
    _ ≤ (5 / (4 * P)) ^ 2 / 8 := div_le_div_of_nonneg_right hsquare (by norm_num)
    _ = 25 / (128 * P ^ 2) := by field_simp; ring

/-- Under `AP >= 32` and the quarter-size reciprocal terminal bound,
the actual complete homogeneous remainder satisfies a uniform rational
estimate with room to spare. -/
theorem coherentRemainder_two_norm_le
    (a : Fin 2 → ℂ) (p q : ℂ) (A P : ℝ)
    (hA : 0 < A) (hP : 0 < P) (ha : ∀ i, A ≤ ‖a i‖)
    (hp : ‖p⁻¹‖ ≤ 1 / P) (hq : ‖q⁻¹‖ ≤ 1 / (4 * P))
    (hAP : 32 ≤ A * P) :
    ‖coherentRemainder a p q‖ ≤ 7 / (32 * P ^ 2) := by
  have hAP0 : 0 < A * P := by positivity
  have hq' : ‖q⁻¹‖ ≤ 1 / P := by
    exact hq.trans (one_div_le_one_div_of_le hP (by nlinarith))
  have ht := coherentRemainder_norm_sub_le a (by decide) p q A P hA hP ha hp hq'
    (by linarith)
  norm_num [coherent_halfCoeff_three] at ht
  have ht' : ‖coherentRemainder a p q - halfBinomialWeightedCoeff p⁻¹ q⁻¹ 2‖ ≤
      (1/4 : ℝ)/P^2*(1/(1-1/(A*P))^2-1) := by
    simpa only [one_div, mul_inv_rev] using ht
  have hcoeff := halfBinomialWeightedCoeff_two_norm_le p⁻¹ q⁻¹ P hP hp hq
  have hinv : 1 / (A * P) ≤ (1 / 32 : ℝ) :=
    one_div_le_one_div_of_le (by norm_num) hAP
  have hbase : (31 / 32 : ℝ) ≤ 1 - 1 / (A * P) := by linarith
  have hbase0 : 0 ≤ 1 - 1 / (A * P) := by linarith
  have hbase2 : (961 / 1024 : ℝ) ≤ (1 - 1 / (A * P)) ^ 2 := by
    nlinarith only [hbase, hbase0, sq_nonneg (1 - 1 / (A * P) - 31 / 32)]
  have hfactor : 1 / (1 - 1 / (A * P)) ^ 2 - 1 ≤ (63 / 961 : ℝ) := by
    have h := one_div_le_one_div_of_le (by norm_num : (0 : ℝ) < 961 / 1024) hbase2
    norm_num at h
    have h' : 1/(1-1/(A*P))^2 ≤ (1024/961 : ℝ) := by
      simpa only [one_div, mul_inv_rev] using h
    linarith only [h']
  have htail : ‖coherentRemainder a p q - halfBinomialWeightedCoeff p⁻¹ q⁻¹ 2‖ ≤
      63 / (3844 * P ^ 2) := by
    calc
      _ ≤ (1 / 4 : ℝ) / P ^ 2 * (1 / (1 - 1 / (A * P)) ^ 2 - 1) := ht'
      _ ≤ (1 / 4 : ℝ) / P ^ 2 * (63 / 961) :=
        mul_le_mul_of_nonneg_left hfactor (by positivity)
      _ = 63 / (3844 * P ^ 2) := by ring
  have hF : ‖coherentRemainder a p q‖ ≤
      ‖halfBinomialWeightedCoeff p⁻¹ q⁻¹ 2‖ +
        ‖coherentRemainder a p q - halfBinomialWeightedCoeff p⁻¹ q⁻¹ 2‖ := by
    have h := norm_add_le (halfBinomialWeightedCoeff p⁻¹ q⁻¹ 2)
      (coherentRemainder a p q - halfBinomialWeightedCoeff p⁻¹ q⁻¹ 2)
    have heq : halfBinomialWeightedCoeff p⁻¹ q⁻¹ 2 +
        (coherentRemainder a p q - halfBinomialWeightedCoeff p⁻¹ q⁻¹ 2) =
        coherentRemainder a p q := by ring
    rw [heq] at h
    exact h
  calc
    ‖coherentRemainder a p q‖ ≤
      25 / (128 * P ^ 2) + 63 / (3844 * P ^ 2) :=
        hF.trans (add_le_add hcoeff htail)
    _ ≤ 7 / (32 * P ^ 2) := by
      apply le_of_lt
      calc
        _ = ((25 / 128 : ℝ) + 63 / 3844) / P ^ 2 := by field_simp <;> ring
        _ < (7 / 32 : ℝ) / P ^ 2 :=
          div_lt_div_of_pos_right (by norm_num) (by positivity)
        _ = _ := by field_simp <;> ring

/-- A scalar conversion of the exact coherent estimate to the two
explicit terms in the manuscript. -/
theorem coherent_two_upper_scalar
    (A B P Q E Z D d F L : ℝ)
    (hA : 0 < A) (hB : 0 < B) (hP : 0 < P) (hQ : 0 < Q)
    (hE : 0 < E) (hZ : 0 < Z) (hD0 : 0 ≤ D) (hd0 : 0 ≤ d) (hF0 : 0 ≤ F)
    (hD : D ≤ 2 * B) (hEsq : E ^ 2 = P * Q)
    (hZlo : (99 / 100 : ℝ) * E < Z) (hZhi : Z < (101 / 100 : ℝ) * E)
    (hd : d < 100 / (199 * P * Q)) (hF : F ≤ 7 / (32 * P ^ 2))
    (hL : L ≤ D * E * (d + F / (A * B))) :
    L < 21 * B / (20 * Z) + Z / (2 * A * P ^ 2) := by
  have hfirst : 2 * B * E * d < 21 * B / (20 * Z) := by
    have h1 : 2 * B * E * d < 2 * B * E * (100 / (199 * P * Q)) :=
      mul_lt_mul_of_pos_left hd (by positivity)
    have heq : 2 * B * E * (100 / (199 * P * Q)) = 200 * B / (199 * E) := by
      rw [mul_assoc 199 P Q, ← hEsq]
      field_simp <;> ring
    have h2 : 200 * B / (199 * E) < 21 * B / (20 * Z) := by
      apply (div_lt_div_iff₀ (by positivity) (by positivity)).2
      have h := mul_lt_mul_of_pos_left hZhi (by positivity : 0 < 4000 * B)
      nlinarith only [h, mul_pos hB hE]
    exact (h1.trans_eq heq).trans h2
  have hsecond : 2 * B * E * (F / (A * B)) < Z / (2 * A * P ^ 2) := by
    have h1 : 2 * B * E * (F / (A * B)) ≤
        2 * B * E * ((7 / (32 * P ^ 2)) / (A * B)) := by
      exact mul_le_mul_of_nonneg_left
        (div_le_div_of_nonneg_right hF (by positivity)) (by positivity)
    have heq : 2 * B * E * ((7 / (32 * P ^ 2)) / (A * B)) =
        7 * E / (16 * A * P ^ 2) := by field_simp; ring
    have h2 : 7 * E / (16 * A * P ^ 2) < Z / (2 * A * P ^ 2) := by
      apply (div_lt_div_iff₀ (by positivity) (by positivity)).2
      have hz : 7 * E < 8 * Z := by linarith
      have h := mul_lt_mul_of_pos_right hz (by positivity : 0 < 2 * A * P ^ 2)
      nlinarith only [h]
    exact (h1.trans_eq heq).trans_lt h2
  have hcoarse : L ≤ 2 * B * E * d + 2 * B * E * (F / (A * B)) := by
    calc
      L ≤ D * E * (d + F / (A * B)) := hL
      _ ≤ (2 * B) * E * (d + F / (A * B)) :=
        mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_right hD hE.le) (by positivity)
      _ = _ := by ring
  exact hcoarse.trans_lt (add_lt_add hfirst hsecond)

/-- The manuscript's quantitative two-anchor upper estimate for the
actual coherent quotient form and its actual terminal square root.
The tail and branch estimates are proved internally. -/
theorem coherent_two_norm_lt
    (a : Fin 2 → ℂ) (p q eta : ℂ) (hinj : Function.Injective a)
    (hA : 0 < ‖a 0‖) (hP : 0 < ‖p‖) (hAB : ‖a 0‖ ≤ ‖a 1‖)
    (hAP : 32 ≤ ‖a 0‖ * ‖p‖) (hQ : 4 * ‖p‖ ≤ ‖q‖)
    (hPQ : 10000 < ‖p‖ * ‖q‖) (heta : eta ^ 2 = p * q) :
    ‖coherentQuotientForm a (a 0 - a 1) p q eta‖ <
      21 * ‖a 1‖ / (20 * ‖coherentTerminalRoot p q eta‖) +
        ‖coherentTerminalRoot p q eta‖ / (2 * ‖a 0‖ * ‖p‖ ^ 2) := by
  let A := ‖a 0‖
  let B := ‖a 1‖
  let P := ‖p‖
  let Q := ‖q‖
  let E := ‖eta‖
  let Z := ‖coherentTerminalRoot p q eta‖
  let f : ℂ := (1 + p⁻¹ * q⁻¹) ^ (1 / 2 : ℂ)
  let d := ‖1 - f‖
  let F := ‖coherentRemainder a p q‖
  have hB : 0 < B := hA.trans_le hAB
  have hQ0 : 0 < Q := by dsimp [Q]; nlinarith only [hP, hQ]
  have hp0 : p ≠ 0 := norm_pos_iff.mp hP
  have hq0 : q ≠ 0 := norm_pos_iff.mp hQ0
  have heta0 : eta ≠ 0 := by
    intro hz
    rw [hz, zero_pow (by decide : (2 : ℕ) ≠ 0)] at heta
    exact (mul_ne_zero hp0 hq0) heta.symm
  have hE : 0 < E := norm_pos_iff.mpr heta0
  have hEsq : E ^ 2 = P * Q := by
    simpa only [E, P, Q, norm_pow, norm_mul] using congrArg norm heta
  have hW : ‖p⁻¹ * q⁻¹‖ = 1 / (P * Q) := by
    simp [P, Q, norm_mul, norm_inv, one_div, mul_inv_rev, mul_comm]
  have hWsmall : ‖p⁻¹ * q⁻¹‖ < (1 / 10000 : ℝ) := by
    rw [hW]
    exact one_div_lt_one_div_of_lt (by norm_num) hPQ
  have hnear := coherent_cpow_half_near_one (p⁻¹ * q⁻¹)
    (mul_ne_zero (inv_ne_zero hp0) (inv_ne_zero hq0)) hWsmall
  have hZeq : Z = E * ‖f‖ := by simp only [Z, E, f, coherentTerminalRoot, norm_mul]
  have hZlo : (99 / 100 : ℝ) * E < Z := by
    rw [hZeq]
    simpa only [mul_comm] using mul_lt_mul_of_pos_left hnear.1 hE
  have hZhi : Z < (101 / 100 : ℝ) * E := by
    rw [hZeq]
    simpa only [mul_comm] using mul_lt_mul_of_pos_left hnear.2.1 hE
  have hZ : 0 < Z := by nlinarith only [hZlo, hE]
  have hd : d < 100 / (199 * P * Q) := by
    have h := hnear.2.2.2
    rw [hW] at h
    calc
      d < (100 / 199 : ℝ) * (1 / (P * Q)) := h
      _ = _ := by ring
  have ha : ∀ i, A ≤ ‖a i‖ := by
    intro i
    fin_cases i
    · exact le_rfl
    · exact hAB
  have han : ∀ i, a i ≠ 0 := fun i => norm_pos_iff.mp (hA.trans_le (ha i))
  have hp : ‖p⁻¹‖ ≤ 1 / P := by simp [P, norm_inv, one_div]
  have hq : ‖q⁻¹‖ ≤ 1 / (4 * P) := by
    simpa only [Q, norm_inv, one_div] using
      one_div_le_one_div_of_le (by positivity : 0 < 4 * P) hQ
  have hq' : ‖q⁻¹‖ ≤ 1 / P :=
    hq.trans (one_div_le_one_div_of_le hP (by dsimp [P]; nlinarith only [hP]))
  have hF : F ≤ 7 / (32 * P ^ 2) :=
    coherentRemainder_two_norm_le a p q A P hA hP ha hp hq hAP
  have hDelta : a 0 - a 1 ≠ 0 := sub_ne_zero.mpr (hinj.ne (by decide))
  have hxp : ∀ i, ‖p⁻¹ * (a i)⁻¹‖ < 1 := by
    intro i
    exact coherent_half_binomial_manuscript_anchor_radius Finset.univ a p⁻¹ A P
      hA hP (fun j _ => ha j) hp (by linarith) i (Finset.mem_univ i)
  have hxq : ∀ i, ‖q⁻¹ * (a i)⁻¹‖ < 1 := by
    intro i
    exact coherent_half_binomial_manuscript_anchor_radius Finset.univ a q⁻¹ A P
      hA hP (fun j _ => ha j) hq' (by linarith) i (Finset.mem_univ i)
  have hexact := coherentQuotientForm_normalized_eq a (by decide) han hinj
    (a 0 - a 1) p q eta hDelta heta0 hxp hxq
  have hmul : coherentQuotientForm a (a 0 - a 1) p q eta =
      ((a 0 - a 1) * eta) *
        (1 - f + (-1 * (a 0 * a 1)⁻¹) * coherentRemainder a p q) := by
    have h := (div_eq_iff (mul_ne_zero hDelta heta0)).mp hexact
    simpa [Fin.prod_univ_two, f, mul_comm] using h
  have hc : ‖(-1 : ℂ) * (a 0 * a 1)⁻¹‖ = 1 / (A * B) := by
    simp [A, B, norm_mul, norm_inv, one_div, mul_inv_rev, mul_comm]
  have hL : ‖coherentQuotientForm a (a 0 - a 1) p q eta‖ ≤
      ‖a 0 - a 1‖ * E * (d + F / (A * B)) := by
    rw [hmul, norm_mul, norm_mul]
    apply mul_le_mul_of_nonneg_left _ (by positivity : 0 ≤ ‖a 0 - a 1‖ * E)
    calc
      _ ≤ ‖1 - f‖ + ‖(-1 * (a 0 * a 1)⁻¹) * coherentRemainder a p q‖ :=
        norm_add_le _ _
      _ = d + F / (A * B) := by rw [norm_mul, hc]; dsimp [d, F]; ring
  have hD : ‖a 0 - a 1‖ ≤ 2 * B := by
    have h := norm_sub_le (a 0) (a 1)
    dsimp [B]
    linarith
  exact coherent_two_upper_scalar A B P Q E Z ‖a 0 - a 1‖ d F
    ‖coherentQuotientForm a (a 0 - a 1) p q eta‖
    hA hB hP hQ0 hE hZ (norm_nonneg _) (norm_nonneg _) (norm_nonneg _)
    hD hEsq hZlo hZhi hd hF hL

end D1Bound5

#print axioms D1Bound5.halfBinomialWeightedCoeff_two_norm_le
#print axioms D1Bound5.coherentRemainder_two_norm_le
#print axioms D1Bound5.coherent_two_upper_scalar
#print axioms D1Bound5.coherent_two_norm_lt
