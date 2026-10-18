import D1Bound5.CoherentFourParameters
import D1Bound5.CoherentVandermondeFourNorm

open Finset

namespace D1Bound5

/-- The actual four-anchor form with its separated-parameter constants
and its exact zero-form window. -/
theorem coherent_four_parameter_form_bounds
    (a : Fin 4 → ℂ) (hinj : Function.Injective a) (p q eta : ℂ)
    (A : ℝ) (hA : 0 < A) (ha : ∀ i, A ≤ ‖a i‖)
    (hP : 0 < ‖p‖) (hQ : 1000*‖p‖ ≤ ‖q‖) (hPQ : 10000 < ‖p‖*‖q‖)
    (hAP : 1000 ≤ A*‖p‖) (heta : eta^2 = p*q) :
    ‖coherentQuotientForm a (coherentVandermonde4 a) p q eta‖ <
        51*‖coherentVandermonde4 a‖/(100*‖coherentTerminalRoot p q eta‖) +
          (49/1200 : ℝ)*‖coherentVandermonde4 a‖*‖coherentTerminalRoot p q eta‖ /
            ((∏ i, ‖a i‖)*‖p‖^4) ∧
      (coherentQuotientForm a (coherentVandermonde4 a) p q eta = 0 →
        10*(∏ i, ‖a i‖)*‖p‖^3 < ‖q‖ ∧
          ‖q‖ < 17*(∏ i, ‖a i‖)*‖p‖^3) := by
  let P := ‖p‖
  let Q := ‖q‖
  let V := ∏ i, ‖a i‖
  let E := ‖eta‖
  let Z := ‖coherentTerminalRoot p q eta‖
  let D := ‖coherentVandermonde4 a‖
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
  have hDelta : coherentVandermonde4 a ≠ 0 := by
    unfold coherentVandermonde4
    repeat' apply mul_ne_zero
    all_goals exact sub_ne_zero.mpr (hinj.ne (by decide))
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
  have hq : ‖q⁻¹‖ ≤ 1/(1000*P) := by
    simpa only [Q,norm_inv,one_div] using
      one_div_le_one_div_of_le (by positivity : 0 < 1000*P) hQ
  have hq' : ‖q⁻¹‖ ≤ 1/P := hq.trans
    (one_div_le_one_div_of_le hP (by change ‖p‖ ≤ 1000*‖p‖; nlinarith only [hP]))
  have hxp : ∀ i, ‖p⁻¹*(a i)⁻¹‖ < 1 := by
    intro i
    exact coherent_half_binomial_manuscript_anchor_radius Finset.univ a p⁻¹ A P
      hA hP (fun j _ => ha j) hp.le (by linarith) i (Finset.mem_univ i)
  have hxq : ∀ i, ‖q⁻¹*(a i)⁻¹‖ < 1 := by
    intro i
    exact coherent_half_binomial_manuscript_anchor_radius Finset.univ a q⁻¹ A P
      hA hP (fun j _ => ha j) hq' (by linarith) i (Finset.mem_univ i)
  obtain ⟨hFlo,hFhi⟩ := coherentRemainder_four_parameter_norm_bounds
    a p q A P hA hP ha hp hq hAP
  obtain ⟨hell,hu,hlam,hwindowLow,hwindowHigh⟩ := coherent_four_parameter_comparisons
  have hFlo' : coherentFourLowerConstant/P^3 ≤ P*F := by
    have h := mul_le_mul_of_nonneg_left hFlo hP.le
    have heq : P*(coherentFourLowerConstant/P^4) = coherentFourLowerConstant/P^3 := by
      field_simp
      ring
    rwa [heq] at h
  have hFhi' : P*F ≤ coherentFourUpperConstant/P^3 := by
    have h := mul_le_mul_of_nonneg_left hFhi hP.le
    have heq : P*(coherentFourUpperConstant/P^4) = coherentFourUpperConstant/P^3 := by
      field_simp
      ring
    rwa [heq] at h
  have hscale : (P*F)/(V*P) = F/V := by field_simp; ring
  have hL := coherentQuotientForm_norm_le_remainder a (by decide) han hinj
    (coherentVandermonde4 a) p q eta hDelta heta0 hxp hxq
  have hL' : ‖coherentQuotientForm a (coherentVandermonde4 a) p q eta‖ ≤
      D*E*(d+(P*F)/(V*P)) := by rw [hscale]; exact hL
  constructor
  · have h := coherent_three_parameter_upper_scalar (V*P) P Q E Z D d (P*F)
      ‖coherentQuotientForm a (coherentVandermonde4 a) p q eta‖
      coherentFourUpperConstant (49/1200) (mul_pos hV hP) hP hQ0 hE hZ hD hu
      hEsq hZlo hZhi hdhi hFhi' hlam hL'
    calc
      _ < 51*D/(100*Z)+(49/1200 : ℝ)*D*Z/((V*P)*P^3) := h
      _ = _ := by dsimp only [D,Z,V,P]; congr 1 <;> ring
  · intro hzero
    have hrel := coherentQuotientForm_zero_norm_relation a (by decide) han hinj
      (coherentVandermonde4 a) p q eta hDelta heta0 hxp hxq hzero
    have hrel' : d = (P*F)/(V*P) := by rw [hscale]; exact hrel
    have hw := coherent_three_window_scalar (V*P) P Q d (P*F)
      coherentFourLowerConstant coherentFourUpperConstant (mul_pos hV hP) hP hQ0
      hell hu hdlo hdhi hFlo' hFhi' hrel'
    constructor
    · calc
        10*V*P^3 < (100/(201*coherentFourUpperConstant))*V*P^3 := by
          have h := mul_lt_mul_of_pos_right hwindowLow (by positivity : 0 < V*P^3)
          nlinarith only [h]
        _ = 100*(V*P)*P^2/(201*coherentFourUpperConstant) := by ring
        _ < Q := hw.1
    · calc
        Q < 100*(V*P)*P^2/(199*coherentFourLowerConstant) := hw.2
        _ = (100/(199*coherentFourLowerConstant))*V*P^3 := by ring
        _ < 17*V*P^3 := by
          have h := mul_lt_mul_of_pos_right hwindowHigh (by positivity : 0 < V*P^3)
          nlinarith only [h]

/-- The complete direct-four lemma for actual coherent roots. -/
theorem coherent_direct_four
    (a : Fin 4 → ℂ) (hinj : Function.Injective a) (p q eta : ℂ)
    (hA : 1 ≤ ‖a 0‖) (hAB : ‖a 0‖ ≤ ‖a 1‖)
    (hBS : ‖a 1‖ ≤ ‖a 2‖) (hST : ‖a 2‖ ≤ ‖a 3‖)
    (hTP : ‖a 3‖ ≤ ‖p‖) (hP : 1000 ≤ ‖p‖) (hQ : 1000*‖p‖ ≤ ‖q‖)
    (heta : eta^2 = p*q) :
    ‖coherentQuotientForm a (coherentVandermonde4 a) p q eta‖ <
        13*‖a 1‖*‖a 2‖^2*‖a 3‖^3/‖coherentTerminalRoot p q eta‖ +
          49*‖a 2‖*‖a 3‖^2*‖coherentTerminalRoot p q eta‖/(50*‖a 0‖*‖p‖^4) ∧
      (coherentQuotientForm a (coherentVandermonde4 a) p q eta = 0 →
        10*‖a 0‖*‖a 1‖*‖a 2‖*‖a 3‖*‖p‖^3 < ‖q‖ ∧
          ‖q‖ < 17*‖a 0‖*‖a 1‖*‖a 2‖*‖a 3‖*‖p‖^3) := by
  let A := ‖a 0‖
  let B := ‖a 1‖
  let S := ‖a 2‖
  let T := ‖a 3‖
  let P := ‖p‖
  let Z := ‖coherentTerminalRoot p q eta‖
  let D := ‖coherentVandermonde4 a‖
  have hA0 : 0 < A := by dsimp [A]; linarith only [hA]
  have hB0 : 0 < B := hA0.trans_le hAB
  have hS0 : 0 < S := hB0.trans_le hBS
  have hT0 : 0 < T := hS0.trans_le hST
  have hP0 : 0 < P := by dsimp [P]; linarith only [hP]
  have hQ0 : 0 < ‖q‖ := by nlinarith only [hP,hQ]
  have hAP : 1000 ≤ A*P := by
    have h := mul_le_mul hA hP (by norm_num : (0:ℝ)≤1000) hA0.le
    nlinarith only [h]
  have hPQ : 10000 < P*‖q‖ := by
    have hq : 1000 ≤ ‖q‖ := by nlinarith only [hP,hQ]
    have h := mul_le_mul hP hq (by norm_num : (0:ℝ)≤1000) hP0.le
    nlinarith only [h]
  have ha : ∀ i, A ≤ ‖a i‖ := by intro i; fin_cases i <;> dsimp [A] <;> linarith
  have h := coherent_four_parameter_form_bounds a hinj p q eta A hA0 ha hP0 hQ hPQ hAP heta
  have hprod : (∏ i, ‖a i‖) = A*B*S*T := by
    simp [Fin.prod_univ_succ,A,B,S,T,mul_assoc]
  rw [hprod] at h
  have hD : D ≤ 24*B*S^2*T^3 := coherentVandermonde4_norm_le a hAB hBS hST
  have hZ : 0 < Z := by
    apply norm_pos_iff.mpr
    intro hz
    have hs := coherent_analytic_terminal_root_sq p q eta (norm_pos_iff.mp hP0) (norm_pos_iff.mp hQ0) heta
    change (coherentTerminalRoot p q eta)^2 = p*q+1 at hs
    rw [hz,zero_pow (by decide : (2:ℕ)≠0)] at hs
    have hn : ‖p‖*‖q‖ = 1 := by
      have heq : p*q = -1 := by linear_combination -hs
      simpa only [norm_mul,norm_neg,norm_one] using congrArg norm heq
    nlinarith only [hn,hPQ]
  have hfirst : 51*D/(100*Z) ≤ 13*B*S^2*T^3/Z := by
    calc
      _ ≤ 51*(24*B*S^2*T^3)/(100*Z) :=
        div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left hD (by norm_num)) (by positivity)
      _ ≤ _ := by
        apply (div_le_div_iff₀ (by positivity) hZ).2
        nlinarith only [mul_nonneg (mul_nonneg (mul_nonneg hB0.le (sq_nonneg S))
          (pow_nonneg hT0.le 3)) hZ.le]
  have hsecond : (49/1200 : ℝ)*D*Z/((A*B*S*T)*P^4) ≤
      49*S*T^2*Z/(50*A*P^4) := by
    calc
      _ ≤ (49/1200 : ℝ)*(24*B*S^2*T^3)*Z/((A*B*S*T)*P^4) := by
        apply div_le_div_of_nonneg_right _ (by positivity)
        exact mul_le_mul_of_nonneg_right
          (mul_le_mul_of_nonneg_left hD (by norm_num)) hZ.le
      _ = _ := by field_simp; ring
  refine ⟨h.1.trans_le (add_le_add hfirst hsecond), ?_⟩
  intro hzero
  have hw := h.2 hzero
  constructor <;> nlinarith only [hw.1,hw.2]

end D1Bound5

