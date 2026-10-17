import D1Bound5.CoherentAnalyticInterpolation

open Finset

namespace D1Bound5

/-- The complete homogeneous remainder estimate in the manuscript's
parameters.  There are exactly `s.card` reciprocal anchors.  The estimate
applies to the genuine complex half-binomial coefficients, and the full
series defining `F_m` is proved summable. -/
theorem coherent_half_binomial_manuscript_tail_norm_le
    {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (a : ι → ℂ) (hs : s.Nonempty)
    (x y : ℂ) (A P : ℝ)
    (hA : 0 < A) (hP : 0 < P)
    (ha : ∀ i ∈ s, A ≤ ‖a i‖)
    (hx : ‖x‖ ≤ 1 / P) (hy : ‖y‖ ≤ 1 / P)
    (hAP : 1 < A * P) :
    Summable (fun j : ℕ => halfBinomialWeightedCoeff x y (s.card + j) *
      MvPolynomial.aeval (fun i : s => (a i)⁻¹)
        (MvPolynomial.hsymm s ℂ j)) ∧
    ‖(∑' j : ℕ, halfBinomialWeightedCoeff x y (s.card + j) *
      MvPolynomial.aeval (fun i : s => (a i)⁻¹)
        (MvPolynomial.hsymm s ℂ j)) -
      halfBinomialWeightedCoeff x y s.card‖ ≤
      (4 * |halfBinomialCoeff (s.card + 1)|) / P ^ s.card *
        (1 / (1 - 1 / (A * P)) ^ s.card - 1) := by
  letI : Nonempty s := ⟨⟨hs.choose, hs.choose_spec⟩⟩
  have hrecip : ∀ i : s, ‖(a i)⁻¹‖ ≤ 1 / A := by
    intro i
    simpa only [one_div, norm_inv] using
      one_div_le_one_div_of_le hA (ha i i.2)
  have hprod : (1 / A) * (1 / P) = 1 / (A * P) := by
    simp only [one_div, mul_inv_rev]
    ring
  have hradius : (1 / A) * (1 / P) < 1 := by
    rw [hprod]
    exact (div_lt_one (mul_pos hA hP)).2 hAP
  obtain ⟨hfull, hbound⟩ := coherent_half_binomial_full_tail_norm_le
    (fun i : s => (a i)⁻¹) x y s.card (1 / A) (1 / P)
    (by have := hs.card_pos; omega) (by positivity) (by positivity)
    hrecip hx hy hradius
  refine ⟨hfull, ?_⟩
  rw [hprod, Fintype.card_coe] at hbound
  simpa only [one_div, inv_pow, div_eq_mul_inv] using hbound

/-- The manuscript's size assumptions place every anchor evaluation
strictly inside the disk of convergence of the half-binomial series. -/
theorem coherent_half_binomial_manuscript_anchor_radius
    {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (a : ι → ℂ) (x : ℂ) (A P : ℝ)
    (hA : 0 < A) (hP : 0 < P)
    (ha : ∀ i ∈ s, A ≤ ‖a i‖)
    (hx : ‖x‖ ≤ 1 / P) (hAP : 1 < A * P) :
    ∀ i ∈ s, ‖x * (a i)⁻¹‖ < 1 := by
  intro i hi
  have hai : ‖(a i)⁻¹‖ ≤ 1 / A := by
    simpa only [one_div, norm_inv] using
      one_div_le_one_div_of_le hA (ha i hi)
  have hprod : (1 / P) * (1 / A) = 1 / (A * P) := by
    simp only [one_div, mul_inv_rev]
  calc
    ‖x * (a i)⁻¹‖ = ‖x‖ * ‖(a i)⁻¹‖ := norm_mul _ _
    _ ≤ (1 / P) * (1 / A) :=
      mul_le_mul hx hai (norm_nonneg _) (by positivity)
    _ = 1 / (A * P) := hprod
    _ < 1 := (div_lt_one (mul_pos hA hP)).2 hAP

end D1Bound5

#print axioms D1Bound5.coherent_half_binomial_manuscript_tail_norm_le
#print axioms D1Bound5.coherent_half_binomial_manuscript_anchor_radius
