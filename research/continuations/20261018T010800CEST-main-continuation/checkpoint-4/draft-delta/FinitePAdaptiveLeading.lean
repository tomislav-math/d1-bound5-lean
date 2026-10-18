import D1Bound5.FinitePLeadingBound
import D1Bound5.FinitePRatioMonomial

namespace D1Bound5

/-- The six remaining terms of H after its pure reciprocal squares cancel. -/
def finitePAdaptiveLeadingTerms (i : Fin 4) : Fin 12 → FinitePLeadingTerm :=
  if i=1 then
    ![(5,1,0,1,3),(-5,0,1,1,3),(5,2,1,1,3),(-5,1,2,1,3),
      (-5,2,0,1,3),(5,0,2,1,3),(0,0,0,0,1),(0,0,0,0,1),
      (0,0,0,0,1),(0,0,0,0,1),(0,0,0,0,1),(0,0,0,0,1)]
  else finitePLeadingTerms i

def finitePLeadingNumeratorExponent (u : FinitePLeadingTerm) (j : Fin 3) : ℕ :=
  if j=u.2.2.1 then u.2.2.2.1 else 0

def finitePLeadingRatioExponent (u : FinitePLeadingTerm) : ℕ :=
  (if u.2.1=0 then 2 else u.2.2.2.2+2)-
    (finitePLeadingNumeratorExponent u 1+finitePLeadingNumeratorExponent u 2)

noncomputable def finitePAdaptiveLeadingTermValue (a b s : ℂ) (u : FinitePLeadingTerm) : ℂ :=
  (u.1 : ℂ)*a^(finitePLeadingNumeratorExponent u 0)*
    b^(finitePLeadingNumeratorExponent u 1)*s^(finitePLeadingNumeratorExponent u 2)/
      (![a,b,s] u.2.1)^u.2.2.2.2

/-- Exact positive leading polynomials in x=A/B from the manuscript. -/
def finitePLeadingWeight (x : ℝ) : Fin 4 → ℝ :=
  ![(5*x+10*x^2+10*x^4+5*x^5)/256,
    (10*x+10*x^4+10*x^5)/256,
    (15+80*x+150*x^2+120*x^3+35*x^4)/256,
    (15+80*x+150*x^2+280*x^3+35*x^4)/256]

theorem finitePAdaptiveLeading_eq_terms (a b s : ℂ)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0) (i : Fin 4) :
    finitePLeading a b s i =
      (∑ t, finitePAdaptiveLeadingTermValue a b s (finitePAdaptiveLeadingTerms i t))/256 := by
  fin_cases i <;> norm_num [finitePLeading,finitePLeadingR,finitePLeadingT,
    finitePLeadingV,finitePAdaptiveLeadingTerms,finitePLeadingTerms,
    finitePAdaptiveLeadingTermValue,finitePLeadingNumeratorExponent,Fin.sum_univ_succ]
  all_goals field_simp [ha,hb,hs] <;> ring

theorem finitePAdaptiveLeading_exponents (i : Fin 4) (t : Fin 12) :
    let u := finitePAdaptiveLeadingTerms i t
    let p := finitePLeadingNumeratorExponent u
    p 0+p 1+p 2+3 ≤ u.2.2.2.2+2 ∧
      finitePLeadingRatioExponent u+p 1+p 2 = (if u.2.1=0 then 2 else u.2.2.2.2+2) ∧
      (u.2.1 ≠ 2 → p 2 ≤ 2) := by
  fin_cases i <;> fin_cases t <;>
    norm_num [finitePAdaptiveLeadingTerms,finitePLeadingTerms,
      finitePLeadingNumeratorExponent,finitePLeadingRatioExponent]

theorem finitePLeadingWeight_eq_sum (x : ℝ) (i : Fin 4) :
    finitePLeadingWeight x i =
      (∑ t, |((finitePAdaptiveLeadingTerms i t).1 : ℝ)|*
        x^(finitePLeadingRatioExponent (finitePAdaptiveLeadingTerms i t)))/256 := by
  fin_cases i <;> norm_num [finitePLeadingWeight,finitePAdaptiveLeadingTerms,
    finitePLeadingTerms,finitePLeadingRatioExponent,finitePLeadingNumeratorExponent,
    Fin.sum_univ_succ] <;> ring

/-- Actual leading residual coefficient with the exact ratio-sensitive
positive polynomial, rather than the coarser uniform constant35/16. -/
theorem finitePLeading_norm_le_adaptive (a b s : ℂ)
    (hA : 1 ≤ ‖a‖) (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖) (i : Fin 4) :
    ‖finitePLeading a b s i‖ ≤
      finitePLeadingWeight (‖a‖/‖b‖) i*(‖s‖^2/‖a‖^3) := by
  have hA0 : 0 < ‖a‖ := by linarith only [hA]
  have hB0 : 0 < ‖b‖ := hA0.trans_le hAB
  have hS0 : 0 < ‖s‖ := hB0.trans_le hBS
  have ht (t : Fin 12) :
      ‖finitePAdaptiveLeadingTermValue a b s (finitePAdaptiveLeadingTerms i t)‖ ≤
        |((finitePAdaptiveLeadingTerms i t).1 : ℝ)|*
          (‖a‖/‖b‖)^(finitePLeadingRatioExponent (finitePAdaptiveLeadingTerms i t))*
            (‖s‖^2/‖a‖^3) := by
    let u := finitePAdaptiveLeadingTerms i t
    let p := finitePLeadingNumeratorExponent u
    obtain ⟨hdeg,he,hl⟩ := finitePAdaptiveLeading_exponents i t
    have hmono := finiteP_ratio_monomial_bound ‖a‖ ‖b‖ ‖s‖ hA hAB hBS
      u.2.1 (p 0) (p 1) (p 2) u.2.2.2.2 3 (finitePLeadingRatioExponent u)
      hdeg he hl
    have hn : ‖(u.1 : ℂ)‖ = |(u.1 : ℝ)| := by simp
    have hanchor : ‖![a,b,s] u.2.1‖ = ![‖a‖,‖b‖,‖s‖] u.2.1 := by
      generalize u.2.1 = r
      fin_cases r <;> rfl
    have hh := mul_le_mul_of_nonneg_left hmono (abs_nonneg (u.1 : ℝ))
    change ‖(u.1 : ℂ)*a^(p 0)*b^(p 1)*s^(p 2)/(![a,b,s] u.2.1)^u.2.2.2.2‖ ≤ _
    simp only [norm_div,norm_mul,norm_pow,hn,hanchor]
    convert hh using 1 <;> dsimp [p,u] <;> ring
  rw [finitePAdaptiveLeading_eq_terms a b s (norm_pos_iff.mp hA0)
    (norm_pos_iff.mp hB0) (norm_pos_iff.mp hS0) i,norm_div]
  norm_num only [norm_ofNat]
  calc
    _ ≤ (∑ t, |((finitePAdaptiveLeadingTerms i t).1 : ℝ)|*
          (‖a‖/‖b‖)^(finitePLeadingRatioExponent (finitePAdaptiveLeadingTerms i t))*
            (‖s‖^2/‖a‖^3))/256 := by
      gcongr
      exact (norm_sum_le _ _).trans (Finset.sum_le_sum fun t _ => ht t)
    _ = finitePLeadingWeight (‖a‖/‖b‖) i*(‖s‖^2/‖a‖^3) := by
      rw [Finset.sum_mul,finitePLeadingWeight_eq_sum]
      ring

end D1Bound5
