import D1Bound5.CoherentThreeSimultaneous

open Finset

namespace D1Bound5

/-- Elementary symmetric norm bounds for four ordered anchors. -/
theorem coherent_elementary_norm_bounds
    (a : Fin 4 → ℂ)
    (h01 : ‖a 0‖ ≤ ‖a 1‖) (h12 : ‖a 1‖ ≤ ‖a 2‖) (h23 : ‖a 2‖ ≤ ‖a 3‖) :
    ‖coherentElementary2 a‖ ≤ 6 * ‖a 2‖ * ‖a 3‖ ∧
    ‖coherentElementary3 a‖ ≤ 4 * ‖a 1‖ * ‖a 2‖ * ‖a 3‖ ∧
    ‖coherentElementary4 a‖ = ‖a 0‖ * ‖a 1‖ * ‖a 2‖ * ‖a 3‖ := by
  let v2 : Fin 6 → ℂ := ![a 0*a 1, a 0*a 2, a 0*a 3,
    a 1*a 2, a 1*a 3, a 2*a 3]
  let v3 : Fin 4 → ℂ := ![a 0*a 1*a 2, a 0*a 1*a 3,
    a 0*a 2*a 3, a 1*a 2*a 3]
  have he2 : coherentElementary2 a = ∑ i, v2 i := by
    simp [coherentElementary2, v2, Fin.sum_univ_succ]
    ring
  have he3 : coherentElementary3 a = ∑ i, v3 i := by
    simp [coherentElementary3, v3, Fin.sum_univ_succ]
    ring
  have hv2 (i : Fin 6) : ‖v2 i‖ ≤ ‖a 2‖ * ‖a 3‖ := by
    fin_cases i <;> simp only [v2, Matrix.cons_val_zero, Matrix.cons_val_succ, norm_mul]
    all_goals gcongr <;> linarith
  have hv3 (i : Fin 4) : ‖v3 i‖ ≤ ‖a 1‖ * ‖a 2‖ * ‖a 3‖ := by
    fin_cases i <;> simp only [v3, Matrix.cons_val_zero, Matrix.cons_val_succ, norm_mul]
    all_goals gcongr <;> linarith
  refine ⟨?_, ?_, ?_⟩
  · rw [he2]
    calc
      ‖∑ i, v2 i‖ ≤ ∑ i, ‖v2 i‖ := norm_sum_le _ _
      _ ≤ ∑ _i : Fin 6, ‖a 2‖ * ‖a 3‖ := Finset.sum_le_sum (fun i _ => hv2 i)
      _ = _ := by simp; ring
  · rw [he3]
    calc
      ‖∑ i, v3 i‖ ≤ ∑ i, ‖v3 i‖ := norm_sum_le _ _
      _ ≤ ∑ _i : Fin 4, ‖a 1‖ * ‖a 2‖ * ‖a 3‖ := Finset.sum_le_sum (fun i _ => hv3 i)
      _ = _ := by simp; ring
  · simp [coherentElementary4, norm_mul]

/-- The rational identity forced by simultaneous vanishing gives the
manuscript's sharp enough upper bound for `|pq+1|`. -/
theorem coherent_four_vanishing_identity_norm_le
    (e2 e3 e4 p q : ℂ) (A B S T : ℝ)
    (hA : 1 ≤ A) (hAB : A ≤ B) (hBS : B ≤ S) (hST : S ≤ T)
    (he2 : ‖e2‖ ≤ 6*S*T) (he3 : ‖e3‖ ≤ 4*B*S*T)
    (he4 : ‖e4‖ = A*B*S*T)
    (hid : p*q+1 = (e2+1-e3^2/(4*e4))^2/(4*e4)) :
    ‖p*q+1‖ ≤ 121*B*S*T/(4*A^3) := by
  have hA0 : 0 < A := by linarith
  have hB0 : 0 < B := hA0.trans_le hAB
  have hS0 : 0 < S := hB0.trans_le hBS
  have hT0 : 0 < T := hS0.trans_le hST
  have hS1 : 1 ≤ S := hA.trans (hAB.trans hBS)
  have hT1 : 1 ≤ T := hS1.trans hST
  have hST1 : 1 ≤ S*T := by
    have h := mul_le_mul hS1 hT1 (by norm_num : (0 : ℝ) ≤ 1) hS0.le
    simpa using h
  have hABST : A ≤ B*S*T := by
    have h := mul_le_mul_of_nonneg_left hST1 hB0.le
    nlinarith only [h, hAB]
  have hAST : A*S*T ≤ B*S*T := by
    have h := mul_le_mul_of_nonneg_right hAB (by positivity : 0 ≤ S*T)
    nlinarith only [h]
  have hden : ‖(4 : ℂ)*e4‖ = 4*(A*B*S*T) := by
    rw [norm_mul, he4]
    norm_num
  have hE3sq : ‖e3‖^2 ≤ (4*B*S*T)^2 := by gcongr
  have hterm : ‖e3^2/((4 : ℂ)*e4)‖ ≤ 4*B*S*T/A := by
    rw [norm_div, norm_pow, hden]
    calc
      ‖e3‖^2 / (4*(A*B*S*T)) ≤ (4*B*S*T)^2 / (4*(A*B*S*T)) :=
        div_le_div_of_nonneg_right hE3sq (by positivity)
      _ = _ := by field_simp; ring
  have hinner : ‖e2+1-e3^2/(4*e4)‖ ≤ 6*S*T+1+4*B*S*T/A := by
    have h := norm_sub_le (e2+1) (e3^2/(4*e4))
    have h' := norm_add_le e2 (1 : ℂ)
    rw [norm_one] at h'
    linarith only [h, h', he2, hterm]
  have hcoarse : 6*S*T+1+4*B*S*T/A ≤ 11*B*S*T/A := by
    apply (mul_le_mul_iff_of_pos_right hA0).mp
    have heq1 : (6*S*T+1+4*B*S*T/A)*A = 6*A*S*T+A+4*B*S*T := by field_simp; ring
    have heq2 : (11*B*S*T/A)*A = 11*B*S*T := by field_simp; ring
    rw [heq1, heq2]
    nlinarith only [hABST, hAST]
  have hinner2 : ‖e2+1-e3^2/(4*e4)‖^2 ≤ (11*B*S*T/A)^2 := by
    have h := hinner.trans hcoarse
    gcongr
  rw [hid, norm_div, norm_pow, hden]
  calc
    _ ≤ (11*B*S*T/A)^2 / (4*(A*B*S*T)) :=
      div_le_div_of_nonneg_right hinner2 (by positivity)
    _ = _ := by field_simp; ring

/-- The ordered modulus hypothesis makes the upper bound from
simultaneous vanishing incompatible with the elementary reverse
triangle inequality. -/
theorem coherent_four_vanishing_size_contradiction
    (A B S T P Q Z : ℝ)
    (hA : 1 ≤ A) (hAB : A ≤ B) (hBS : B ≤ S) (hST : S ≤ T)
    (hTP : T ≤ P) (hPQ : P ≤ Q)
    (hsize : 32*B*S*T/A^3 ≤ P^2)
    (hupper : Z ≤ 121*B*S*T/(4*A^3)) (hlower : P*Q-1 ≤ Z) : False := by
  have hA0 : 0 < A := by linarith
  have hB0 : 0 < B := hA0.trans_le hAB
  have hS0 : 0 < S := hB0.trans_le hBS
  have hT0 : 0 < T := hS0.trans_le hST
  have hP0 : 0 < P := hT0.trans_le hTP
  have hr : 1 ≤ B*S*T/A^3 := by
    apply (le_div_iff₀ (by positivity : 0 < A^3)).2
    have h1 := mul_le_mul hAB (hAB.trans hBS) hA0.le hB0.le
    have h2 := mul_le_mul h1 (hAB.trans (hBS.trans hST)) hA0.le (by positivity : 0 ≤ B*S)
    nlinarith only [h2]
  have hp2 : P^2 ≤ P*Q := by
    have h := mul_le_mul_of_nonneg_left hPQ hP0.le
    nlinarith only [h]
  have hs : 32*(B*S*T/A^3) ≤ P^2 := by
    calc
      _ = 32*B*S*T/A^3 := by ring
      _ ≤ _ := hsize
  have hu : Z ≤ (121/4 : ℝ)*(B*S*T/A^3) := by
    calc
      Z ≤ 121*B*S*T/(4*A^3) := hupper
      _ = _ := by ring
  nlinarith only [hr, hp2, hs, hu, hlower]

/-- The two coherent polynomial-weight forms cannot both vanish under
the four-anchor size condition.  Arbitrary square-root signs are
allowed, provided the two forms use the same roots on their overlap. -/
theorem coherent_two_three_forms_not_both_zero
    (a R : Fin 4 → ℂ) (hinj : Function.Injective a) (p q z : ℂ)
    (hz : z^2 = p*q+1) (hR : ∀ i, (R i)^2 = (a i*p+1)*(a i*q+1))
    (hA : 1 ≤ ‖a 0‖) (hAB : ‖a 0‖ ≤ ‖a 1‖)
    (hBS : ‖a 1‖ ≤ ‖a 2‖) (hST : ‖a 2‖ ≤ ‖a 3‖)
    (hTP : ‖a 3‖ ≤ ‖p‖) (hPQ : ‖p‖ ≤ ‖q‖)
    (hsize : 32*‖a 1‖*‖a 2‖*‖a 3‖/‖a 0‖^3 ≤ ‖p‖^2) :
    (-(a 0-a 1)*(a 0-a 2)*(a 1-a 2)*z +
      a 0*(a 1-a 2)*R 0 - a 1*(a 0-a 2)*R 1 + a 2*(a 0-a 1)*R 2 ≠ 0) ∨
    (-(a 0-a 1)*(a 0-a 3)*(a 1-a 3)*z +
      a 0*(a 1-a 3)*R 0 - a 1*(a 0-a 3)*R 1 + a 3*(a 0-a 1)*R 3 ≠ 0) := by
  by_contra hzero
  push_neg at hzero
  have ha : ∀ i, a i ≠ 0 := by
    intro i
    apply norm_pos_iff.mp
    fin_cases i <;> linarith
  have hid := coherent_two_three_forms_vanishing_identity a R hinj ha p q z hz hR hzero.1 hzero.2
  obtain ⟨he2, he3, he4⟩ := coherent_elementary_norm_bounds a hAB hBS hST
  have hupper := coherent_four_vanishing_identity_norm_le
    (coherentElementary2 a) (coherentElementary3 a) (coherentElementary4 a) p q
    ‖a 0‖ ‖a 1‖ ‖a 2‖ ‖a 3‖ hA hAB hBS hST he2 he3 he4 hid
  have hlower : ‖p‖*‖q‖-1 ≤ ‖p*q+1‖ := by
    have h := norm_sub_le (p*q+1) (1 : ℂ)
    simp only [add_sub_cancel_right, norm_mul, norm_one] at h
    linarith
  exact coherent_four_vanishing_size_contradiction
    ‖a 0‖ ‖a 1‖ ‖a 2‖ ‖a 3‖ ‖p‖ ‖q‖ ‖p*q+1‖
    hA hAB hBS hST hTP hPQ hsize hupper hlower

def coherentTriple012 {F : Type*} (a : Fin 4 → F) : Fin 3 → F :=
  fun i => a (![0,1,2] i)

def coherentTriple013 {F : Type*} (a : Fin 4 → F) : Fin 3 → F :=
  fun i => a (![0,1,3] i)

/-- Simultaneous nonvanishing for the actual two coherent quotient
forms.  The chosen analytic roots supply all square identities; the
remaining hypotheses are precisely distinctness, ordering and size. -/
theorem coherent_three_quotient_forms_not_both_zero
    (a : Fin 4 → ℂ) (hinj : Function.Injective a) (p q eta : ℂ)
    (heta : eta^2 = p*q)
    (hA : 1 ≤ ‖a 0‖) (hAB : ‖a 0‖ ≤ ‖a 1‖)
    (hBS : ‖a 1‖ ≤ ‖a 2‖) (hST : ‖a 2‖ ≤ ‖a 3‖)
    (hTP : ‖a 3‖ ≤ ‖p‖) (hPQ : ‖p‖ ≤ ‖q‖)
    (hsize : 32*‖a 1‖*‖a 2‖*‖a 3‖/‖a 0‖^3 ≤ ‖p‖^2) :
    coherentQuotientForm (coherentTriple012 a)
      (coherentVandermonde3 (coherentTriple012 a)) p q eta ≠ 0 ∨
    coherentQuotientForm (coherentTriple013 a)
      (coherentVandermonde3 (coherentTriple013 a)) p q eta ≠ 0 := by
  have hinj2 : Function.Injective (coherentTriple012 a) :=
    hinj.comp (by decide : Function.Injective (![0,1,2] : Fin 3 → Fin 4))
  have hinj3 : Function.Injective (coherentTriple013 a) :=
    hinj.comp (by decide : Function.Injective (![0,1,3] : Fin 3 → Fin 4))
  have ha : ∀ i, a i ≠ 0 := by
    intro i
    apply norm_pos_iff.mp
    fin_cases i <;> linarith
  have hp : p ≠ 0 := norm_pos_iff.mp (by linarith : 0 < ‖p‖)
  have hq : q ≠ 0 := norm_pos_iff.mp (by linarith : 0 < ‖q‖)
  let z := coherentTerminalRoot p q eta
  let R : Fin 4 → ℂ := fun i => coherentAnchorRoot (a i) p q eta
  have hz : z^2 = p*q+1 := coherent_analytic_terminal_root_sq p q eta hp hq heta
  have hR : ∀ i, (R i)^2 = (a i*p+1)*(a i*q+1) := fun i =>
    coherent_analytic_anchor_root_sq (a i) p q eta (ha i) hp hq heta
  have h := coherent_two_three_forms_not_both_zero a R hinj p q z hz hR
    hA hAB hBS hST hTP hPQ hsize
  rw [coherentQuotientForm_three_eq _ hinj2, coherentQuotientForm_three_eq _ hinj3]
  simpa [coherentTriple012, coherentTriple013, R, z] using h

end D1Bound5

