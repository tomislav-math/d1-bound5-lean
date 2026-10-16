import D1Bound5.RootPerturbation
import D1Bound5.DeterminantNormalization
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.LinearCombination

namespace D1Bound5

/-- A sign of every complex square root of x(x+1), when |x| >= 9,
has correction strictly within 16/31 of zero and 128/8649 of 1/2.
This is the branch-selection part of (integrated-1)--(integrated-2);
the constants are uniform and do not require an analytic square root. -/
theorem exists_small_root_error (x t : ℂ)
    (hx : 9 ≤ ‖x‖) (ht : t^2 = x*(x+1)) :
    ∃ v : ℂ, (v = t ∨ v = -t) ∧
      ‖v-x‖ < (16/31 : ℝ) ∧
      ‖(v-x)-(1/2 : ℂ)‖ < (128/8649 : ℝ) := by
  have hxpos : 0 < ‖x‖ := by linarith
  have hxne : x ≠ 0 := norm_pos_iff.mp hxpos
  have hxSq : 9*‖x‖ ≤ ‖x‖^2 := by
    nlinarith [mul_nonneg (norm_nonneg x) (sub_nonneg.mpr hx)]
  have hgap : ‖x‖ < (1-(15/16 : ℝ)^2)*‖x‖^2 := by
    nlinarith only [hxSq, hx]
  have hdiff : t^2-x^2 = x := by
    rw [ht]
    ring
  have herr0 : ‖t^2-x^2‖ ≤ ‖x‖ := by rw [hdiff]
  obtain ⟨v,hv,hclose⟩ :=
    exists_sign_root_perturbation t x (15/16) ‖x‖ hxne
      (by norm_num) hxpos herr0 hgap
  have hsmall : ‖v-x‖ < (16/31 : ℝ) := by
    have hlarge : (31/16 : ℝ)*‖x‖*‖v-x‖ < ‖x‖ := by
      convert hclose using 1 <;> norm_num
    have hcancel : ‖x‖ * ((31/16 : ℝ)*‖v-x‖) < ‖x‖ * 1 := by
      nlinarith only [hlarge]
    have H : (31/16 : ℝ)*‖v-x‖ < 1 := by
      by_contra h
      have hh : 1 ≤ (31/16 : ℝ)*‖v-x‖ := le_of_not_gt h
      have hm := mul_nonneg hxpos.le (sub_nonneg.mpr hh)
      nlinarith only [hcancel, hm]
    nlinarith only [H]
  have hv2 : v^2 = x*(x+1) := by
    rcases hv with h | h
    · rw [h]
      exact ht
    · rw [h]
      simpa only [neg_sq] using ht
  let e : ℂ := v-x
  have heq : e^2+2*x*e = x := by
    dsimp only [e]
    calc
      (v-x)^2+2*x*(v-x) = v^2-x^2 := by ring
      _ = x := by rw [hv2]; ring
  have hden : (2:ℂ)*x ≠ 0 := mul_ne_zero (by norm_num) hxne
  have hhalf : e-(1/2 : ℂ) = -e^2/(2*x) := by
    apply (eq_div_iff hden).mpr
    linear_combination heq
  have hnorm : ‖e-(1/2 : ℂ)‖ = ‖e‖^2/(2*‖x‖) := by
    rw [hhalf,norm_div,norm_neg,norm_pow,norm_mul,Complex.norm_two]
  have hsmallE : ‖e‖ < (16/31 : ℝ) := hsmall
  have hEpos : 0 ≤ ‖e‖ := norm_nonneg _
  have hsquare : ‖e‖^2 < (16/31 : ℝ)^2 := by
    nlinarith only [hsmallE, hEpos]
  have hstrict : ‖e‖^2 < (128/8649 : ℝ)*(2*‖x‖) := by
    nlinarith only [hsquare, hx]
  have hbound : ‖e-(1/2 : ℂ)‖ < (128/8649 : ℝ) := by
    rw [hnorm]
    exact (div_lt_iff₀ (by positivity : 0 < 2*‖x‖)).mpr hstrict
  exact ⟨v,hv,hsmall,by simpa only [e] using hbound⟩

/-- The same choice for normalized off-diagonal entries of an integral
root matrix. Only complex algebra is used at this stage. -/
theorem exists_small_normalized_root_error (a b u v r : ℂ)
    (hu : u^2=a) (hv : v^2=b) (hr : r^2=a*b+1)
    (hab : 9 ≤ ‖a*b‖) :
    ∃ t : ℂ, (t=u*r*v ∨ t=-(u*r*v)) ∧
      ‖t-a*b‖ < (16/31 : ℝ) ∧
      ‖(t-a*b)-(1/2 : ℂ)‖ < (128/8649 : ℝ) := by
  have ht : (u*r*v)^2 = (a*b)*((a*b)+1) := by
    rw [mul_pow,mul_pow,hu,hv,hr]
    ring
  exact exists_small_root_error (a*b) (u*r*v) hab ht


/-- Uniform sign selection with a free margin c. The two inequalities
are polynomial inequalities in real norms, without division by a
possibly zero chosen square root. -/
theorem exists_root_error_control (x t : ℂ) (c : ℝ)
    (hc : 0 ≤ c) (hx : 0 < ‖x‖)
    (hgap : 1 < (1-c^2)*‖x‖) (ht : t^2 = x*(x+1)) :
    ∃ v : ℂ, (v = t ∨ v = -t) ∧
      (1+c)*‖v-x‖ < 1 ∧
      (2*‖x‖*(1+c)^2)*‖(v-x)-(1/2 : ℂ)‖ < 1 := by
  have hxne : x ≠ 0 := norm_pos_iff.mp hx
  have hmarg : 0 < ((1-c^2)*‖x‖-1)*‖x‖ :=
    mul_pos (sub_pos.mpr hgap) hx
  have hgap' : ‖x‖ < (1-c^2)*‖x‖^2 := by
    nlinarith only [hmarg]
  have hdiff : t^2-x^2 = x := by rw [ht]; ring
  have herr : ‖t^2-x^2‖ ≤ ‖x‖ := by rw [hdiff]
  obtain ⟨v,hv,hnear⟩ := exists_sign_root_perturbation
    t x c ‖x‖ hxne hc hx herr hgap'
  have hsmall : (1+c)*‖v-x‖ < 1 := by
    by_contra h
    have hh : 1 ≤ (1+c)*‖v-x‖ := le_of_not_gt h
    have hm := mul_nonneg hx.le (sub_nonneg.mpr hh)
    nlinarith only [hnear,hm]
  have hv2 : v^2 = x*(x+1) := by
    rcases hv with h | h
    · rw [h]; exact ht
    · rw [h]; simpa only [neg_sq] using ht
  let e : ℂ := v-x
  have heq : e^2+2*x*e = x := by
    dsimp only [e]
    calc
      (v-x)^2+2*x*(v-x) = v^2-x^2 := by ring
      _ = x := by rw [hv2]; ring
  have hden : (2:ℂ)*x ≠ 0 := mul_ne_zero (by norm_num) hxne
  have hhalf : e-(1/2 : ℂ) = -e^2/(2*x) := by
    apply (eq_div_iff hden).mpr
    linear_combination heq
  have hnorm : ‖e-(1/2 : ℂ)‖ = ‖e‖^2/(2*‖x‖) := by
    rw [hhalf,norm_div,norm_neg,norm_pow,norm_mul,Complex.norm_two]
  have hep : 0 ≤ ‖e‖ := norm_nonneg _
  have hcp : 0 < 1+c := by linarith
  have hpp : 0 ≤ (1+c)*‖e‖ := mul_nonneg hcp.le hep
  have hsquare : ((1+c)*‖e‖)^2 < 1 := by
    nlinarith only [hsmall,hpp]
  have hsquare' : (1+c)^2*‖e‖^2 < 1 := by
    nlinarith only [hsquare]
  have hnormfactor : (2*‖x‖*(1+c)^2)*(‖e‖^2/(2*‖x‖)) =
      (1+c)^2*‖e‖^2 := by
    field_simp [show (2:ℝ)*‖x‖ ≠ 0 by positivity]
    <;> ring
  have hbound : (2*‖x‖*(1+c)^2)*‖e-(1/2 : ℂ)‖ < 1 := by
    rw [hnorm,hnormfactor]
    exact hsquare'
  exact ⟨v,hv,by simpa only [e] using hsmall,by simpa only [e] using hbound⟩

/-- First-row entries in the A >= 1, B >= 3 determinant argument. -/
theorem exists_root_error_three (x t : ℂ)
    (hx : 3 ≤ ‖x‖) (ht : t^2 = x*(x+1)) :
    ∃ v : ℂ, (v=t ∨ v=-t) ∧
      ‖v-x‖ < (5/9 : ℝ) ∧
      ‖(v-x)-(1/2 : ℂ)‖ < (25/486 : ℝ) := by
  have hxpos : 0 < ‖x‖ := by linarith
  have hgap : 1 < (1-(4/5 : ℝ)^2)*‖x‖ := by nlinarith only [hx]
  obtain ⟨v,hv,hnear,hhalf⟩ :=
    exists_root_error_control x t (4/5) (by norm_num) hxpos hgap ht
  have hnear' : ‖v-x‖ < (5/9 : ℝ) := by nlinarith only [hnear]
  have hprod := mul_nonneg (sub_nonneg.mpr hx)
    (norm_nonneg ((v-x)-(1/2 : ℂ)))
  have hhalf' : ‖(v-x)-(1/2 : ℂ)‖ < (25/486 : ℝ) := by
    nlinarith only [hhalf,hprod]
  exact ⟨v,hv,hnear',hhalf'⟩

/-- Later-row entries in the A >= 1, B >= 3 determinant argument. -/
theorem exists_root_error_twelve (x t : ℂ)
    (hx : 12 ≤ ‖x‖) (ht : t^2 = x*(x+1)) :
    ∃ v : ℂ, (v=t ∨ v=-t) ∧
      ‖v-x‖ < (7/13 : ℝ) ∧
      ‖(v-x)-(1/2 : ℂ)‖ < (1/64 : ℝ) := by
  have hxpos : 0 < ‖x‖ := by linarith
  have hgap : 1 < (1-(6/7 : ℝ)^2)*‖x‖ := by nlinarith only [hx]
  obtain ⟨v,hv,hnear,hhalf⟩ :=
    exists_root_error_control x t (6/7) (by norm_num) hxpos hgap ht
  have hnear' : ‖v-x‖ < (7/13 : ℝ) := by nlinarith only [hnear]
  have hprod := mul_nonneg (sub_nonneg.mpr hx)
    (norm_nonneg ((v-x)-(1/2 : ℂ)))
  have hhalf' : ‖(v-x)-(1/2 : ℂ)‖ < (1/64 : ℝ) := by
    nlinarith only [hhalf,hprod]
  exact ⟨v,hv,hnear',hhalf'⟩

end D1Bound5

