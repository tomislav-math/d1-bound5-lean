import D1Bound5.CoupledPhaseGeometry
import Mathlib.Analysis.Calculus.Deriv.MeanValue

namespace D1Bound5

noncomputable def phaseHalfPolynomial (q x : ℝ) : ℝ := (4-x^2)^2*(1+(1/q)^2+x/q)
noncomputable def phaseCritical (q x : ℝ) : ℝ := 5*x^2/q+4*(1+(1/q)^2)*x-4/q

theorem phaseHalfPolynomial_deriv (q x : ℝ) :
    HasDerivAt (phaseHalfPolynomial q) (-(4-x^2)*phaseCritical q x) x := by
  have h₁ := ((hasDerivAt_const x (4 : ℝ)).sub ((hasDerivAt_id x).pow 2)).pow 2
  have h₂ := (hasDerivAt_const x (1+(1/q)^2)).add ((hasDerivAt_id x).div_const q)
  convert h₁.mul h₂ using 1 <;> dsimp [phaseHalfPolynomial,phaseCritical] <;> ring

theorem phaseCritical_mono (q x y : ℝ) (hq : 0 < q)
    (hx : 0 ≤ x) (hxy : x ≤ y) : phaseCritical q x ≤ phaseCritical q y := by
  unfold phaseCritical
  gcongr

/-- Exact rational brackets around the positive critical point suffice
for a global bound. The two outer intervals use the proved derivative
sign; the middle interval uses monotonicity of its two positive factors. -/
theorem coupled_phase_polynomial_bound (q l r F : ℝ)
    (hq : 1 ≤ q) (hl : 0 ≤ l) (hlr : l ≤ r) (hr : r ≤ 2)
    (hleft : phaseCritical q l ≤ 0) (hright : 0 ≤ phaseCritical q r)
    (henvelope : (4-l^2)^4*(1+(1/q)^2+r/q)^2 < F)
    (x : ℝ) (hx : 0 ≤ x) (hx2 : x ≤ 2) : coupledPhasePolynomial q x < F := by
  have hq0 : 0 < q := by linarith only [hq]
  have hl2 : l ≤ 2 := hlr.trans hr
  have hr0 : 0 ≤ r := hl.trans hlr
  have hbase (t : ℝ) (ht : 0 ≤ t) (ht2 : t ≤ 2) : 0 ≤ 4-t^2 := by
    nlinarith only [ht,ht2]
  have hpos (t : ℝ) (ht : 0 ≤ t) : 0 ≤ 1+(1/q)^2+t/q := by positivity
  have hmono : MonotoneOn (phaseHalfPolynomial q) (Set.Icc 0 l) := by
    apply monotoneOn_of_deriv_nonneg (convex_Icc 0 l)
    · unfold phaseHalfPolynomial
      fun_prop
    · intro t _
      exact (phaseHalfPolynomial_deriv q t).differentiableAt.differentiableWithinAt
    · intro t ht
      have ht' : t ∈ Set.Icc 0 l := interior_subset ht
      rw [(phaseHalfPolynomial_deriv q t).deriv]
      have hcrit : phaseCritical q t ≤ 0 :=
        (phaseCritical_mono q t l hq0 ht'.1 ht'.2).trans hleft
      exact mul_nonneg_of_nonpos_of_nonpos (neg_nonpos.mpr (hbase t ht'.1 (ht'.2.trans hl2))) hcrit
  have hanti : AntitoneOn (phaseHalfPolynomial q) (Set.Icc r 2) := by
    apply antitoneOn_of_deriv_nonpos (convex_Icc r 2)
    · unfold phaseHalfPolynomial
      fun_prop
    · intro t _
      exact (phaseHalfPolynomial_deriv q t).differentiableAt.differentiableWithinAt
    · intro t ht
      have ht' : t ∈ Set.Icc r 2 := interior_subset ht
      rw [(phaseHalfPolynomial_deriv q t).deriv]
      have hcrit : 0 ≤ phaseCritical q t :=
        hright.trans (phaseCritical_mono q r t hq0 hr0 ht'.1)
      exact mul_nonpos_of_nonpos_of_nonneg
        (neg_nonpos.mpr (hbase t (hr0.trans ht'.1) ht'.2)) hcrit
  let G := (4-l^2)^2*(1+(1/q)^2+r/q)
  have hG0 : 0 ≤ G := mul_nonneg (sq_nonneg _) (hpos r hr0)
  have hg0 : 0 ≤ phaseHalfPolynomial q x := mul_nonneg (sq_nonneg _) (hpos x hx)
  have hg : phaseHalfPolynomial q x ≤ G := by
    by_cases hxl : x ≤ l
    · calc
        _ ≤ phaseHalfPolynomial q l := hmono ⟨hx,hxl⟩ ⟨hl,le_rfl⟩ hxl
        _ ≤ G := by unfold phaseHalfPolynomial; dsimp [G]; gcongr
    · by_cases hrx : r ≤ x
      · calc
          _ ≤ phaseHalfPolynomial q r := hanti ⟨le_rfl,hr⟩ ⟨hrx,hx2⟩ hrx
          _ ≤ G := by
            unfold phaseHalfPolynomial
            dsimp [G]
            gcongr
      · have hlx : l ≤ x := (lt_of_not_ge hxl).le
        have hxr : x ≤ r := (lt_of_not_ge hrx).le
        unfold phaseHalfPolynomial
        dsimp [G]
        gcongr
  have hsquare : (phaseHalfPolynomial q x)^2 ≤ G^2 := by
    nlinarith only [hg,hg0,hG0]
  have hf : coupledPhasePolynomial q x = (phaseHalfPolynomial q x)^2 := by
    unfold coupledPhasePolynomial phaseHalfPolynomial
    ring
  rw [hf]
  apply lt_of_le_of_lt hsquare
  have hGeq : G^2 = (4-l^2)^4*(1+(1/q)^2+r/q)^2 := by dsimp [G]; ring
  rwa [hGeq]

noncomputable def CoupledPhaseRow (q F : ℝ) : Prop :=
  (q=8 ∧ F=269) ∨ (q=8/3 ∧ F=368) ∨ (q=12/7 ∧ F=540) ∨
  (q=3/2 ∧ F=637) ∨ (q=18/17 ∧ F=1121)

/-- All five printed phase constants follow from exact rational critical
brackets. Decimal approximations are not used in the proof. -/
theorem coupled_phase_row_polynomial_bound (q F : ℝ) (hrow : CoupledPhaseRow q F)
    (x : ℝ) (hx : 0 ≤ x) (hx2 : x ≤ 2) : coupledPhasePolynomial q x < F := by
  rcases hrow with ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩
  · exact coupled_phase_polynomial_bound 8 (64870519/536870912) (8108815/67108864) 269
      (by norm_num) (by norm_num) (by norm_num) (by norm_num)
      (by norm_num [phaseCritical]) (by norm_num [phaseCritical]) (by norm_num) x hx hx2
  · exact coupled_phase_polynomial_bound (8/3) (157513737/536870912) (78756869/268435456) 368
      (by norm_num) (by norm_num) (by norm_num) (by norm_num)
      (by norm_num [phaseCritical]) (by norm_num [phaseCritical]) (by norm_num) x hx hx2
  · exact coupled_phase_polynomial_bound (12/7) (195093997/536870912) (97546999/268435456) 540
      (by norm_num) (by norm_num) (by norm_num) (by norm_num)
      (by norm_num [phaseCritical]) (by norm_num [phaseCritical]) (by norm_num) x hx hx2
  · exact coupled_phase_polynomial_bound (3/2) (203350297/536870912) (101675149/268435456) 637
      (by norm_num) (by norm_num) (by norm_num) (by norm_num)
      (by norm_num [phaseCritical]) (by norm_num [phaseCritical]) (by norm_num) x hx hx2
  · exact coupled_phase_polynomial_bound (18/17) (107257323/268435456) (214514647/536870912) 1121
      (by norm_num) (by norm_num) (by norm_num) (by norm_num)
      (by norm_num [phaseCritical]) (by norm_num [phaseCritical]) (by norm_num) x hx hx2

theorem coupled_phase_row_bound (a b s : ℂ) (q F : ℝ)
    (hrow : CoupledPhaseRow q F) (hB : 0 < ‖b‖) (hBS : ‖b‖ ≤ ‖s‖)
    (hsep : q*‖a‖ ≤ ‖b‖) :
    (phaseVandermondeRatio a b s)^2*phasePhi b s < F := by
  have hq : 1 ≤ q := by rcases hrow with h|h|h|h|h <;> rcases h with ⟨rfl,_⟩ <;> norm_num
  obtain ⟨x,hx,hx2,hbound⟩ := coupled_phase_geometry a b s q hq hB hBS hsep
  exact hbound.trans_lt (coupled_phase_row_polynomial_bound q F hrow x hx hx2)

end D1Bound5
