import Mathlib.Analysis.Complex.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

namespace D1Bound5

/-- An elementary root estimate. No analytic branch or power series is
needed: the sign is specified by the nonnegative real part. -/
theorem normalized_root_perturbation (q : ℂ) (c rho : ℝ)
    (hc : 0 ≤ c) (hrho : 0 < rho) (hgap : rho < 1-c^2)
    (hRe : 0 ≤ q.re) (hq : ‖q^2-1‖ ≤ rho) :
    (1+c)*‖q-1‖ < rho := by
  have hreal : 1-(q.re*q.re-q.im*q.im) ≤ rho := by
    have h := Complex.re_le_norm (1-q*q)
    simp only [Complex.sub_re, Complex.one_re, Complex.mul_re] at h
    have hn : ‖1-q*q‖ = ‖q^2-1‖ := by rw [pow_two, norm_sub_rev]
    rw [hn] at h
    exact h.trans hq
  have hqc : c < q.re := by
    nlinarith [sq_nonneg q.im]
  have hplus : 1+c < ‖q+1‖ := by
    have h := Complex.re_le_norm (q+1)
    simp only [Complex.add_re, Complex.one_re] at h
    linarith
  have hp : ‖q-1‖*‖q+1‖ ≤ rho := by
    rw [← norm_mul]
    have hid : (q-1)*(q+1) = q^2-1 := by ring
    rwa [hid]
  by_cases hzero : ‖q-1‖ = 0
  · simpa only [hzero, mul_zero] using hrho
  · have hpos : 0 < ‖q-1‖ := lt_of_le_of_ne (norm_nonneg _) (Ne.symm hzero)
    nlinarith

/-- Choose the sign of a square root close to a prescribed nonzero target.
The error estimate is multiplicative, with no division by the root. -/
theorem exists_sign_root_perturbation (u t : ℂ) (c E : ℝ)
    (ht : t ≠ 0) (hc : 0 ≤ c) (hE : 0 < E)
    (herr : ‖u^2-t^2‖ ≤ E) (hgap : E < (1-c^2)*‖t‖^2) :
    ∃ v : ℂ, (v = u ∨ v = -u) ∧ (1+c)*‖t‖*‖v-t‖ < E := by
  have htN : 0 < ‖t‖ := norm_pos_iff.mpr ht
  have htN2 : 0 < ‖t‖^2 := sq_pos_of_pos htN
  let q := u/t
  have hq2 : q^2-1 = (u^2-t^2)/(t^2) := by
    dsimp only [q]
    field_simp
  have hqN : ‖q^2-1‖ ≤ E/(‖t‖^2) := by
    rw [hq2, norm_div, norm_pow]
    exact div_le_div_of_nonneg_right herr htN2.le
  have hgap' : E/(‖t‖^2) < 1-c^2 := (div_lt_iff₀ htN2).mpr hgap
  have hE' : 0 < E/(‖t‖^2) := div_pos hE htN2
  have transfer (v : ℂ) (H : (1+c)*‖v/t-1‖ < E/(‖t‖^2)) :
      (1+c)*‖t‖*‖v-t‖ < E := by
    have hid : v/t-1 = (v-t)/t := by field_simp
    rw [hid, norm_div] at H
    have H' := (lt_div_iff₀ htN2).mp H
    have hidR : (1+c)*(‖v-t‖/‖t‖)*‖t‖^2 = (1+c)*‖t‖*‖v-t‖ := by
      field_simp
    rwa [hidR] at H'
  by_cases hRe : 0 ≤ q.re
  · exact ⟨u, Or.inl rfl, transfer u (normalized_root_perturbation q c _ hc hE' hgap' hRe hqN)⟩
  · refine ⟨-u, Or.inr rfl, transfer (-u) ?_⟩
    have hneg : 0 ≤ (-q).re := by simp only [Complex.neg_re]; linarith
    have hsq : ‖(-q)^2-1‖ ≤ E/(‖t‖^2) := by simpa only [neg_sq] using hqN
    have H := normalized_root_perturbation (-q) c _ hc hE' hgap' hneg hsq
    simpa only [q, neg_div] using H

end D1Bound5
