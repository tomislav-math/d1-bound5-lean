import D1Bound5.RootPerturbation
import D1Bound5.TailErrorBounds
import Mathlib.Analysis.Complex.Polynomial.Basic


namespace D1Bound5

/-- Sign selection preserves a square root in the original ring. The
complex perturbation lemma does not require division in that ring. -/
theorem exists_ring_sign_root_perturbation {R : Type*} [CommRing R]
    (f : R →+* ℂ) (u : R) (t : ℂ) (c E : ℝ)
    (ht : t ≠ 0) (hc : 0 ≤ c) (hE : 0 < E)
    (herr : ‖(f u)^2-t^2‖ ≤ E) (hgap : E < (1-c^2)*‖t‖^2) :
    ∃ v : R, v^2 = u^2 ∧ (1+c)*‖t‖*‖f v-t‖ < E := by
  obtain ⟨v,hv,H⟩ := exists_sign_root_perturbation (f u) t c E ht hc hE herr hgap
  rcases hv with rfl | rfl
  · exact ⟨u,rfl,H⟩
  · exact ⟨-u,by ring,by simpa only [map_neg] using H⟩

/-- Choose auxiliary square roots of b,c aligned with a fixed root of
bc+1. This is the first estimate in the C>=4 tail proof. -/
theorem exists_aligned_square_roots (b c r : ℂ)
    (hr : r^2 = b*c+1) (hB : 3 ≤ ‖b‖) (hC : 4 ≤ ‖c‖) :
    ∃ beta gamma : ℂ, beta^2 = b ∧ gamma^2 = c ∧
      (39/20 : ℝ)*‖beta‖*‖gamma‖*‖r-beta*gamma‖ < 1 := by
  obtain ⟨beta,hbeta⟩ := IsAlgClosed.exists_pow_nat_eq b (by decide : 0 < 2)
  obtain ⟨gamma,hgamma⟩ := IsAlgClosed.exists_pow_nat_eq c (by decide : 0 < 2)
  have hbetaN : ‖beta‖^2 = ‖b‖ := by rw [← norm_pow,hbeta]
  have hgammaN : ‖gamma‖^2 = ‖c‖ := by rw [← norm_pow,hgamma]
  have hmul : 12 ≤ ‖b‖*‖c‖ := by
    nlinarith [mul_nonneg (sub_nonneg.mpr hB) (sub_nonneg.mpr hC)]
  have htN : ‖beta*gamma‖^2 = ‖b‖*‖c‖ := by
    rw [norm_mul,mul_pow,hbetaN,hgammaN]
  have ht : beta*gamma ≠ 0 := by
    intro h
    rw [h,norm_zero,zero_pow (by decide : 2 ≠ 0)] at htN
    linarith
  have he : r^2-(beta*gamma)^2 = 1 := by
    rw [hr,mul_pow,hbeta,hgamma]
    ring
  have herr : ‖r^2-(beta*gamma)^2‖ ≤ 1 := by rw [he,norm_one]
  have hgap : 1 < (1-(19/20 : ℝ)^2)*‖beta*gamma‖^2 := by
    rw [htN]
    nlinarith only [hmul]
  obtain ⟨v,hv,H⟩ := exists_sign_root_perturbation r (beta*gamma) (19/20) 1 ht
    (by norm_num) (by norm_num) herr hgap
  norm_num only [norm_mul] at H
  rcases hv with rfl | rfl
  · exact ⟨beta,gamma,hbeta,hgamma,by nlinarith only [H]⟩
  · refine ⟨beta,-gamma,hbeta,by simpa only [neg_sq] using hgamma,?_⟩
    have hdist : ‖r-beta*(-gamma)‖ = ‖-r-beta*gamma‖ := by
      have hid : r-beta*(-gamma) = -(-r-beta*gamma) := by ring
      rw [hid,norm_neg]
    rw [norm_neg,hdist]
    nlinarith only [H]

end D1Bound5
