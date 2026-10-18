import D1Bound5.FirstPairData
import D1Bound5.SmallPairClassification

open scoped NumberField Classical
open Module

namespace D1Bound5
open QuadInt

private theorem integer_norm_le_two (x : ℤ) (hpos : 1 ≤ x^2) (hbound : x^2 ≤ 2) :
    x = 1 ∨ x = -1 := by
  have hlo : -1 ≤ x := by nlinarith [sq_nonneg (x+1)]
  have hhi : x ≤ 1 := by nlinarith [sq_nonneg (x-1)]
  interval_cases x <;> norm_num at *

private theorem integer_small_square (x : ℤ) (hx : x^2 ≤ 8)
    (hbig : 9 ≤ (x^2-1)^2) : x^2 = 4 := by
  have hlo : -2 ≤ x := by nlinarith [sq_nonneg (x+2)]
  have hhi : x ≤ 2 := by nlinarith [sq_nonneg (x-2)]
  interval_cases x <;> norm_num at *

/-- The only first pair in any coordinate order of discriminant above 32
is the rational pair (1,3), up to simultaneous sign. -/
theorem first_pair_of_large_discriminant {tau nu : ℤ}
    (hlarge : 32 < discriminant tau nu) (a b : QuadInt tau nu)
    (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) := by
  have hd : 0 < discriminant tau nu := by omega
  have hNa : 1 ≤ a.norm ∧ a.norm ≤ 2 := by
    rcases hnorm with h | h <;> omega
  have hNb : 9 ≤ b.norm := by rcases hnorm with h | h <;> omega
  have hprod : a.norm*b.norm ≤ 63 := by
    rcases hnorm with h | h
    · rw [h.1]; simpa using h.2.2
    · rw [h.1]; omega
  obtain ⟨q,hq⟩ := hroot
  have hNq := first_pair_root_norm_le_eight hd a b q hprod hq
  have him (z : QuadInt tau nu) (hz : z.norm ≤ 8) : z.im = 0 := by
    by_contra h
    have := discriminant_le_four_bound hd hz h
    omega
  have hcast (z : QuadInt tau nu) (hz : z.norm ≤ 8) : z = (z.re : QuadInt tau nu) := by
    apply QuadraticAlgebra.ext
    · simp
    · simpa only [QuadraticAlgebra.im_intCast] using him z hz
  have hnormInt (z : QuadInt tau nu) (hz : z.norm ≤ 8) : z.norm = z.re^2 := by
    simp [norm_formula, him z hz]
  have ha8 : a.norm ≤ 8 := by omega
  have hare : a.re = 1 ∨ a.re = -1 := by
    apply integer_norm_le_two
    · simpa only [hnormInt a ha8] using hNa.1
    · simpa only [hnormInt a ha8] using hNa.2
  have ha : a = 1 ∨ a = -1 := by
    rcases hare with h | h
    · left; rw [hcast a ha8, h]; norm_num
    · right; rw [hcast a ha8, h]; norm_num
  have hNa1 : a.norm = 1 := by rcases ha with rfl | rfl <;> norm_num [norm_formula]
  have hNm : (q*q-1).norm = b.norm := by
    have hf : q*q-1 = a*b := by rw [hq]; ring
    rw [hf, map_mul, hNa1, one_mul]
  have hNmi : (q*q-1).norm = (q.re^2-1)^2 := by
    have hc : q*q-1 = ((q.re^2-1 : ℤ) : QuadInt tau nu) := by
      rw [hcast q hNq]
      push_cast
      ring
    rw [hc]
    simp [norm_formula]
  have hqfour : q.re^2 = 4 := integer_small_square q.re
    (by simpa only [hnormInt q hNq] using hNq) (by omega)
  have hqfour' : q*q = (4 : QuadInt tau nu) := by
    rw [hcast q hNq, ← Int.cast_mul]
    have h : q.re*q.re = 4 := by nlinarith only [hqfour]
    rw [h]
    norm_num
  rw [hqfour'] at hq
  rcases ha with rfl | rfl
  · exact Or.inl ⟨rfl, by linear_combination -hq⟩
  · exact Or.inr ⟨rfl, by linear_combination hq⟩

/-- Every first pair in a full ring is rational (1,3) up to sign, or lies
in the complete finite first-pair table of one of the eleven maximal models.
The unused discriminant-31 table is empty, so it contributes no pairs. -/
theorem full_first_pair_classification
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ) (a b : 𝓞 K)
    (hsize :
      (‖phi (a : K)‖^2 = 1 ∧ 9 ≤ ‖phi (b : K)‖^2 ∧ ‖phi (b : K)‖^2 < 64) ∨
      (‖phi (a : K)‖^2 = 2 ∧ 9 ≤ ‖phi (b : K)‖^2 ∧ ‖phi (b : K)‖^2 < 16))
    (hroot : ∃ q : 𝓞 K, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨
      ∃ (tau nu : ℤ) (e : QuadInt tau nu ≃+* 𝓞 K),
        (tau,nu) ∈ smallPairModels ∧
        firstPairCoordinates (e.symm a) (e.symm b) ∈ firstPairTable tau nu := by
  classical
  obtain ⟨tau,nu,htau,hd,⟨e⟩⟩ := exists_imaginary_quadratic_ring_equiv hK
  have hnorm (z : 𝓞 K) : ‖phi (z : K)‖^2 = ((e.symm z).norm : ℝ) := by
    simpa only [RingEquiv.apply_symm_apply] using norm_sq_full_ring_equiv e phi (e.symm z)
  have hN : FirstPairNorms (e.symm a) (e.symm b) := by
    rw [hnorm a, hnorm b] at hsize
    rcases hsize with h | h
    · left
      have ha : (e.symm a).norm = 1 := by exact_mod_cast h.1
      have hb : 9 ≤ (e.symm b).norm := by exact_mod_cast h.2.1
      have hc : (e.symm b).norm < 64 := by exact_mod_cast h.2.2
      exact ⟨ha,hb,by omega⟩
    · right
      have ha : (e.symm a).norm = 2 := by exact_mod_cast h.1
      have hb : 9 ≤ (e.symm b).norm := by exact_mod_cast h.2.1
      have hc : (e.symm b).norm < 16 := by exact_mod_cast h.2.2
      exact ⟨ha,hb,by omega⟩
  have hroot' : ∃ q : QuadInt tau nu, q*q = e.symm a*e.symm b+1 := by
    obtain ⟨q,hq⟩ := hroot
    exact ⟨e.symm q, by simpa only [map_mul,map_add,map_one] using congrArg e.symm hq⟩
  have hrational (h : (e.symm a = 1 ∧ e.symm b = 3) ∨
      (e.symm a = -1 ∧ e.symm b = -3)) : (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) := by
    rcases h with h | h
    · left
      constructor <;> apply e.symm.injective
      · simpa using h.1
      · simpa using h.2
    · right
      constructor <;> apply e.symm.injective
      · simpa using h.1
      · simpa using h.2
  by_cases hcut : discriminant tau nu ≤ 32
  · have hnu : 1 ≤ nu ∧ nu ≤ 8 := by
      rcases htau with rfl | rfl <;> simp only [discriminant] at hd hcut <;> omega
    have hc := firstPair_classified_rectangular htau hnu.1 hnu.2 _ _ hN hroot'
    rcases hc with h | h | h
    · exact (hrational (Or.inl h)).elim Or.inl (fun h => Or.inr (Or.inl h))
    · exact (hrational (Or.inr h)).elim Or.inl (fun h => Or.inr (Or.inl h))
    · exact Or.inr (Or.inr ⟨tau,nu,e,full_small_pair_model_allowed e htau hd hnu.1 hnu.2,h⟩)
  · have h := hrational (first_pair_of_large_discriminant (lt_of_not_ge hcut) _ _ hN hroot')
    exact h.elim Or.inl (fun h => Or.inr (Or.inl h))

end D1Bound5
