import D1Bound5.FinitePResidualIdentity
import D1Bound5.FinitePMonomial

open Finset

namespace D1Bound5

attribute [local simp] Matrix.cons_val_two Matrix.cons_val_three

/-- Coefficient, denominator anchor, numerator anchor, numerator exponent,
and denominator exponent; a common denominator256 is outside the sum. -/
abbrev FinitePLeadingTerm := ℤ × Fin 3 × Fin 3 × ℕ × ℕ

def finitePLeadingTerms : Fin 4 → Fin 12 → FinitePLeadingTerm :=
  ![![(10,0,0,0,2),(-10,1,1,0,2),(5,1,0,1,3),(-5,0,1,1,3),
      (0,0,0,0,1),(0,0,0,0,1),(0,0,0,0,1),(0,0,0,0,1),
      (0,0,0,0,1),(0,0,0,0,1),(0,0,0,0,1),(0,0,0,0,1)],
    ![(10,0,0,0,2),(-10,1,1,0,2),(5,1,0,1,3),(-5,0,1,1,3),
      (10,1,1,0,2),(-10,2,2,0,2),(5,2,1,1,3),(-5,1,2,1,3),
      (-10,0,0,0,2),(10,2,2,0,2),(-5,2,0,1,3),(5,0,2,1,3)],
    ![(-150,0,0,0,1),(80,0,1,1,2),(-15,0,1,2,3),(-35,1,0,1,2),
      (120,1,1,0,1),(0,0,0,0,1),(0,0,0,0,1),(0,0,0,0,1),
      (0,0,0,0,1),(0,0,0,0,1),(0,0,0,0,1),(0,0,0,0,1)],
    ![(-150,0,0,0,1),(80,0,2,1,2),(-15,0,2,2,3),(-35,2,0,1,2),
      (150,1,1,0,1),(-80,1,2,1,2),(15,1,2,2,3),(35,2,1,1,2),
      (0,0,0,0,1),(0,0,0,0,1),(0,0,0,0,1),(0,0,0,0,1)]]

noncomputable def finitePLeadingTermValue (x : Fin 3 → ℂ)
    (t : FinitePLeadingTerm) : ℂ :=
  (t.1 : ℂ)*(x t.2.2.1)^t.2.2.2.1/(x t.2.1)^t.2.2.2.2

theorem finitePLeading_eq_terms (a b s : ℂ) (ha : a ≠ 0) (hb : b ≠ 0)
    (hs : s ≠ 0) (i : Fin 4) :
    finitePLeading a b s i =
      (∑ t, finitePLeadingTermValue ![a,b,s] (finitePLeadingTerms i t))/256 := by
  fin_cases i <;> norm_num [finitePLeading,finitePLeadingR,finitePLeadingT,
    finitePLeadingV,finitePLeadingTerms,finitePLeadingTermValue,Fin.sum_univ_succ]
  all_goals field_simp [ha,hb,hs] <;> ring

theorem finitePLeadingTerms_exponents (i : Fin 4) (t : Fin 12) :
    let u := finitePLeadingTerms i t
    u.2.2.2.1 ≤ 2 ∧ u.2.2.2.1+3 ≤ u.2.2.2.2+2 := by
  fin_cases i <;> fin_cases t <;> norm_num [finitePLeadingTerms]

theorem finitePLeadingTerms_sum (i : Fin 4) :
    (∑ t, |((finitePLeadingTerms i t).1 : ℝ)|) ≤ 560 := by
  fin_cases i <;> norm_num [finitePLeadingTerms,Fin.sum_univ_succ]

theorem finitePLeading_norm_le (a b s : ℂ)
    (hA : 1 ≤ ‖a‖) (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖) (i : Fin 4) :
    ‖finitePLeading a b s i‖ ≤ (35/16 : ℝ)*‖s‖^2/‖a‖^3 := by
  have hapos : 0 < ‖a‖ := by linarith
  have hbpos : 0 < ‖b‖ := hapos.trans_le hAB
  have hspos : 0 < ‖s‖ := hbpos.trans_le hBS
  have hlow (j : Fin 3) : ‖a‖ ≤ ‖![a,b,s] j‖ := by
    fin_cases j
    · exact le_rfl
    · exact hAB
    · exact hAB.trans hBS
  have hupp (j : Fin 3) : ‖![a,b,s] j‖ ≤ ‖s‖ := by
    fin_cases j
    · exact hAB.trans hBS
    · exact hBS
    · exact le_rfl
  have hterm (t : Fin 12) :
      ‖finitePLeadingTermValue ![a,b,s] (finitePLeadingTerms i t)‖ ≤
        |((finitePLeadingTerms i t).1 : ℝ)| *(‖s‖^2/‖a‖^3) := by
    let u := finitePLeadingTerms i t
    obtain ⟨he,hn⟩ := finitePLeadingTerms_exponents i t
    have hm := finiteP_monomial_bound ‖a‖ ‖s‖ ‖![a,b,s] u.2.1‖ ‖![a,b,s] u.2.2.1‖
      3 u.2.2.2.2 0 u.2.2.2.1 hA (hlow _) (hlow _) (hupp _) (hupp _) he (by simpa using hn)
    have hnorm : ‖(u.1 : ℂ)‖ = |(u.1 : ℝ)| := by simp
    simpa [finitePLeadingTermValue, norm_div, norm_mul, norm_pow, hnorm,
      pow_zero, one_mul, mul_div_assoc, u] using
        mul_le_mul_of_nonneg_left hm (abs_nonneg (u.1 : ℝ))
  rw [finitePLeading_eq_terms a b s (norm_pos_iff.mp hapos)
    (norm_pos_iff.mp hbpos) (norm_pos_iff.mp hspos) i, norm_div]
  norm_num only [Complex.norm_ofNat]
  calc
    _ ≤ (∑ t, |((finitePLeadingTerms i t).1 : ℝ)| *(‖s‖^2/‖a‖^3))/256 := by
      gcongr
      exact (norm_sum_le _ _).trans (Finset.sum_le_sum fun t _ => hterm t)
    _ = (∑ t, |((finitePLeadingTerms i t).1 : ℝ)|)*(‖s‖^2/‖a‖^3)/256 := by
      rw [Finset.sum_mul]
    _ ≤ 560*(‖s‖^2/‖a‖^3)/256 := by
      gcongr
      exact finitePLeadingTerms_sum i
    _ = _ := by ring

end D1Bound5
