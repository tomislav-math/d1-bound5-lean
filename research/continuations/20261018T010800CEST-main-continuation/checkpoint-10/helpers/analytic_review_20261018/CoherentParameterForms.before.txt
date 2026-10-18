import D1Bound5.CoherentThreeParameters

open Finset

namespace D1Bound5

/-- Exact-form norm control before inserting a numerical remainder
estimate.  This interface is shared by the parameter and four-anchor
lemmas. -/
theorem coherentQuotientForm_norm_le_remainder
    {m : ℕ} (a : Fin m → ℂ) (hm : 2 ≤ m)
    (ha : ∀ i, a i ≠ 0) (hinj : Function.Injective a)
    (Delta p q eta : ℂ) (hDelta : Delta ≠ 0) (heta : eta ≠ 0)
    (hp : ∀ i, ‖p⁻¹*(a i)⁻¹‖ < 1) (hq : ∀ i, ‖q⁻¹*(a i)⁻¹‖ < 1) :
    ‖coherentQuotientForm a Delta p q eta‖ ≤ ‖Delta‖*‖eta‖*
      (‖1-(1+p⁻¹*q⁻¹)^(1/2 : ℂ)‖ + ‖coherentRemainder a p q‖/(∏ i, ‖a i‖)) := by
  let c : ℂ := (-1)^ (m-1) * (∏ i, a i)⁻¹
  have hexact := coherentQuotientForm_normalized_eq a hm ha hinj Delta p q eta hDelta heta hp hq
  have hmul : coherentQuotientForm a Delta p q eta = (Delta*eta)*
      (1-(1+p⁻¹*q⁻¹)^(1/2 : ℂ)+c*coherentRemainder a p q) := by
    have h := (div_eq_iff (mul_ne_zero hDelta heta)).mp hexact
    simpa only [mul_comm] using h
  have hc : ‖c‖ = (∏ i, ‖a i‖)⁻¹ := by
    simp [c, norm_mul, norm_pow, norm_inv, norm_prod]
  rw [hmul, norm_mul, norm_mul]
  apply mul_le_mul_of_nonneg_left _ (by positivity : 0 ≤ ‖Delta‖*‖eta‖)
  calc
    _ ≤ ‖1-(1+p⁻¹*q⁻¹)^(1/2 : ℂ)‖ + ‖c*coherentRemainder a p q‖ := norm_add_le _ _
    _ = _ := by rw [norm_mul, hc]; ring

/-- A zero coherent form equates the exact remainder modulus to the
near-one defect modulus.  No asymptotic estimate is assumed. -/
theorem coherentQuotientForm_zero_norm_relation
    {m : ℕ} (a : Fin m → ℂ) (hm : 2 ≤ m)
    (ha : ∀ i, a i ≠ 0) (hinj : Function.Injective a)
    (Delta p q eta : ℂ) (hDelta : Delta ≠ 0) (heta : eta ≠ 0)
    (hp : ∀ i, ‖p⁻¹*(a i)⁻¹‖ < 1) (hq : ∀ i, ‖q⁻¹*(a i)⁻¹‖ < 1)
    (hL : coherentQuotientForm a Delta p q eta = 0) :
    ‖1-(1+p⁻¹*q⁻¹)^(1/2 : ℂ)‖ = ‖coherentRemainder a p q‖/(∏ i, ‖a i‖) := by
  let c : ℂ := (-1)^(m-1)*(∏ i, a i)⁻¹
  have h := coherentQuotientForm_normalized_eq a hm ha hinj Delta p q eta hDelta heta hp hq
  rw [hL, zero_div] at h
  have heq : 1-(1+p⁻¹*q⁻¹)^(1/2 : ℂ) = -c*coherentRemainder a p q := by
    linear_combination -h
  rw [heq, norm_mul, norm_neg]
  have hc : ‖c‖ = (∏ i, ‖a i‖)⁻¹ := by
    simp [c, norm_mul, norm_pow, norm_inv, norm_prod]
  rw [hc]
  ring

/-- Exact scalar vanishing window in terms of two proved remainder
constants.  The manuscript's rows are obtained by rational comparison. -/
theorem coherent_three_window_scalar
    (V P Q d F ell u : ℝ) (hV : 0 < V) (hP : 0 < P) (hQ : 0 < Q)
    (hell : 0 < ell) (hu : 0 < u)
    (hdlo : 100/(201*P*Q) < d) (hdhi : d < 100/(199*P*Q))
    (hFlo : ell/P^3 ≤ F) (hFhi : F ≤ u/P^3) (hrel : d = F/V) :
    100*V*P^2/(201*u) < Q ∧ Q < 100*V*P^2/(199*ell) := by
  have hlo : 100/(201*P*Q) < u/(V*P^3) := by
    calc
      _ < d := hdlo
      _ = F/V := hrel
      _ ≤ (u/P^3)/V := div_le_div_of_nonneg_right hFhi hV.le
      _ = _ := by field_simp; ring
  have hhi : ell/(V*P^3) < 100/(199*P*Q) := by
    calc
      _ = (ell/P^3)/V := by field_simp; ring
      _ ≤ F/V := div_le_div_of_nonneg_right hFlo hV.le
      _ = d := hrel.symm
      _ < _ := hdhi
  constructor
  · apply (div_lt_iff₀ (by positivity : 0 < 201*u)).2
    have h := (div_lt_div_iff₀ (by positivity) (by positivity)).mp hlo
    apply (mul_lt_mul_iff_of_pos_right hP).mp
    nlinarith only [h]
  · apply (lt_div_iff₀ (by positivity : 0 < 199*ell)).2
    have h := (div_lt_div_iff₀ (by positivity) (by positivity)).mp hhi
    apply (mul_lt_mul_iff_of_pos_right hP).mp
    nlinarith only [h]

/-- Direct parameter estimate from the exact coherent norm identity. -/
theorem coherent_three_parameter_upper_scalar
    (V P Q E Z D d F L u lam : ℝ)
    (hV : 0 < V) (hP : 0 < P) (hQ : 0 < Q) (hE : 0 < E)
    (hZ : 0 < Z) (hD : 0 < D) (hu : 0 < u)
    (hEsq : E^2 = P*Q)
    (hZlo : (99/100 : ℝ)*E < Z) (hZhi : Z < (101/100 : ℝ)*E)
    (hd : d < 100/(199*P*Q)) (hF : F ≤ u/P^3)
    (hlam : 100*u/99 < lam) (hL : L ≤ D*E*(d+F/V)) :
    L < 51*D/(100*Z) + lam*D*Z/(V*P^3) := by
  have hfirst : D*E*d < 51*D/(100*Z) := by
    have h1 := mul_lt_mul_of_pos_left hd (mul_pos hD hE)
    have heq : D*E*(100/(199*P*Q)) = 100*D/(199*E) := by
      rw [← hEsq]
      field_simp
      ring
    have h2 : 100*D/(199*E) < 51*D/(100*Z) := by
      apply (div_lt_div_iff₀ (by positivity) (by positivity)).2
      have h := mul_lt_mul_of_pos_left hZhi (by positivity : 0 < 10000*D)
      nlinarith only [h, mul_pos hD hE]
    exact (h1.trans_eq heq).trans h2
  have hsecond : D*E*(F/V) < lam*D*Z/(V*P^3) := by
    have h1 : D*E*(F/V) ≤ D*u*E/(V*P^3) := by
      calc
        _ ≤ D*E*((u/P^3)/V) := mul_le_mul_of_nonneg_left
          (div_le_div_of_nonneg_right hF hV.le) (by positivity)
        _ = _ := by field_simp; ring
    have huE : u*E < lam*Z := by
      have he : E < (100/99 : ℝ)*Z := by linarith only [hZlo]
      have h2 := mul_lt_mul_of_pos_left he hu
      have h3 := mul_lt_mul_of_pos_right hlam hZ
      nlinarith only [h2, h3]
    have h2 : D*u*E/(V*P^3) < lam*D*Z/(V*P^3) := by
      apply div_lt_div_of_pos_right _ (by positivity)
      have h := mul_lt_mul_of_pos_left huE hD
      nlinarith only [h]
    exact h1.trans_lt h2
  have hcoarse : L ≤ D*E*d+D*E*(F/V) := by nlinarith only [hL]
  exact hcoarse.trans_lt (add_lt_add hfirst hsecond)

/-- The complete three-anchor interpolation-parameter lemma for the
actual coherent form.  Exact numerical row checks are separate from
the analytic proof; all remainder and branch hypotheses are discharged. -/
theorem coherent_three_parameter_form_bounds
    (a : Fin 3 → ℂ) (hinj : Function.Injective a) (p q eta : ℂ)
    (A H lam U : ℝ) (hA : 0 < A) (ha : ∀ i, A ≤ ‖a i‖)
    (hP : 0 < ‖p‖) (hQ : 4*‖p‖ ≤ ‖q‖) (hPQ : 10000 < ‖p‖*‖q‖)
    (hH : 1 < H) (hAP : H ≤ A*‖p‖) (heta : eta^2 = p*q)
    (hell : 0 < coherentThreeLowerConstant H) (hu : 0 < coherentThreeUpperConstant H)
    (hlam : 100*coherentThreeUpperConstant H/99 < lam)
    (hwindowLow : 5 < 100/(201*coherentThreeUpperConstant H))
    (hwindowHigh : 100/(199*coherentThreeLowerConstant H) < U) :
    ‖coherentQuotientForm a (coherentVandermonde3 a) p q eta‖ <
        51*‖coherentVandermonde3 a‖/(100*‖coherentTerminalRoot p q eta‖) +
          lam*‖coherentVandermonde3 a‖*‖coherentTerminalRoot p q eta‖ /
            ((∏ i, ‖a i‖)*‖p‖^3) ∧
      (coherentQuotientForm a (coherentVandermonde3 a) p q eta = 0 →
        5*(∏ i, ‖a i‖)*‖p‖^2 < ‖q‖ ∧
          ‖q‖ < U*(∏ i, ‖a i‖)*‖p‖^2) := by
  let P := ‖p‖
  let Q := ‖q‖
  let V := ∏ i, ‖a i‖
  let E := ‖eta‖
  let Z := ‖coherentTerminalRoot p q eta‖
  let D := ‖coherentVandermonde3 a‖
  let d := ‖1-(1+p⁻¹*q⁻¹)^(1/2 : ℂ)‖
  let F := ‖coherentRemainder a p q‖
  have han : ∀ i, a i ≠ 0 := fun i => norm_pos_iff.mp (hA.trans_le (ha i))
  have hV : 0 < V := Finset.prod_pos (fun i _ => hA.trans_le (ha i))
  have hQ0 : 0 < Q := by change 0 < ‖q‖; nlinarith only [hP,hQ]
  have hp0 : p ≠ 0 := norm_pos_iff.mp hP
  have hq0 : q ≠ 0 := norm_pos_iff.mp hQ0
  have heta0 : eta ≠ 0 := by
    intro hz
    rw [hz, zero_pow (by decide : (2 : ℕ) ≠ 0)] at heta
    exact (mul_ne_zero hp0 hq0) heta.symm
  have hE : 0 < E := norm_pos_iff.mpr heta0
  have hEsq : E^2 = P*Q := by
    simpa only [E,P,Q,norm_pow,norm_mul] using congrArg norm heta
  have hDelta : coherentVandermonde3 a ≠ 0 := by
    exact mul_ne_zero
      (mul_ne_zero (sub_ne_zero.mpr (hinj.ne (by decide)))
        (sub_ne_zero.mpr (hinj.ne (by decide))))
      (sub_ne_zero.mpr (hinj.ne (by decide)))
  have hD : 0 < D := norm_pos_iff.mpr hDelta
  have hW : ‖p⁻¹*q⁻¹‖ = 1/(P*Q) := by
    simp [P,Q,norm_mul,norm_inv,one_div,mul_inv_rev,mul_comm]
  have hWsmall : ‖p⁻¹*q⁻¹‖ < (1/10000 : ℝ) := by
    rw [hW]
    exact one_div_lt_one_div_of_lt (by norm_num) hPQ
  have hnear := coherent_cpow_half_near_one (p⁻¹*q⁻¹)
    (mul_ne_zero (inv_ne_zero hp0) (inv_ne_zero hq0)) hWsmall
  have hZeq : Z = E*‖(1+p⁻¹*q⁻¹)^(1/2 : ℂ)‖ := by
    simp only [Z,E,coherentTerminalRoot,norm_mul]
  have hZlo : (99/100 : ℝ)*E < Z := by
    rw [hZeq]
    simpa only [mul_comm] using mul_lt_mul_of_pos_left hnear.1 hE
  have hZhi : Z < (101/100 : ℝ)*E := by
    rw [hZeq]
    simpa only [mul_comm] using mul_lt_mul_of_pos_left hnear.2.1 hE
  have hZ : 0 < Z := by nlinarith only [hZlo,hE]
  have hdlo : 100/(201*P*Q) < d := by
    have h := hnear.2.2.1
    rw [hW] at h
    calc
      _ = (100/201 : ℝ)*(1/(P*Q)) := by ring
      _ < _ := h
  have hdhi : d < 100/(199*P*Q) := by
    have h := hnear.2.2.2
    rw [hW] at h
    calc
      _ < (100/199 : ℝ)*(1/(P*Q)) := h
      _ = _ := by ring
  have hp : ‖p⁻¹‖ = 1/P := by simp [P,norm_inv,one_div]
  have hq : ‖q⁻¹‖ ≤ 1/(4*P) := by
    simpa only [Q,norm_inv,one_div] using
      one_div_le_one_div_of_le (by positivity : 0 < 4*P) hQ
  have hq' : ‖q⁻¹‖ ≤ 1/P := hq.trans
    (one_div_le_one_div_of_le hP (by change ‖p‖ ≤ 4*‖p‖; nlinarith only [hP]))
  have hxp : ∀ i, ‖p⁻¹*(a i)⁻¹‖ < 1 := by
    intro i
    exact coherent_half_binomial_manuscript_anchor_radius Finset.univ a p⁻¹ A P
      hA hP (fun j _ => ha j) hp.le (hH.trans_le hAP) i (Finset.mem_univ i)
  have hxq : ∀ i, ‖q⁻¹*(a i)⁻¹‖ < 1 := by
    intro i
    exact coherent_half_binomial_manuscript_anchor_radius Finset.univ a q⁻¹ A P
      hA hP (fun j _ => ha j) hq' (hH.trans_le hAP) i (Finset.mem_univ i)
  obtain ⟨hFlo,hFhi⟩ := coherentRemainder_three_parameter_norm_bounds
    a p q A P H hA hP ha hp hq hH hAP
  have hL := coherentQuotientForm_norm_le_remainder a (by decide) han hinj
    (coherentVandermonde3 a) p q eta hDelta heta0 hxp hxq
  constructor
  · exact coherent_three_parameter_upper_scalar V P Q E Z D d F
      ‖coherentQuotientForm a (coherentVandermonde3 a) p q eta‖
      (coherentThreeUpperConstant H) lam hV hP hQ0 hE hZ hD hu
      hEsq hZlo hZhi hdhi hFhi hlam hL
  · intro hzero
    have hrel := coherentQuotientForm_zero_norm_relation a (by decide) han hinj
      (coherentVandermonde3 a) p q eta hDelta heta0 hxp hxq hzero
    have hw := coherent_three_window_scalar V P Q d F
      (coherentThreeLowerConstant H) (coherentThreeUpperConstant H)
      hV hP hQ0 hell hu hdlo hdhi hFlo hFhi hrel
    constructor
    · calc
        5*V*P^2 < (100/(201*coherentThreeUpperConstant H))*V*P^2 := by
          have h := mul_lt_mul_of_pos_right hwindowLow (by positivity : 0 < V*P^2)
          nlinarith only [h]
        _ = 100*V*P^2/(201*coherentThreeUpperConstant H) := by ring
        _ < Q := hw.1
    · calc
        Q < 100*V*P^2/(199*coherentThreeLowerConstant H) := hw.2
        _ = (100/(199*coherentThreeLowerConstant H))*V*P^2 := by ring
        _ < U*V*P^2 := by
          have h := mul_lt_mul_of_pos_right hwindowHigh (by positivity : 0 < V*P^2)
          nlinarith only [h]

end D1Bound5

