import D1Bound5.OneThreeNegative
import D1Bound5.FullRingBridge

open scoped NumberField Classical
open Module

namespace D1Bound5

/-- The only integer strictly between 3 and 15 whose successor is a
square is 8. The additional 3s+1 square condition is unnecessary here. -/
theorem integer_one_three_third_eq_eight (s r : ℤ)
    (hlo : 3 < s) (hhi : s < 15) (hr : r*r = s+1) : s = 8 := by
  have hrlo : -3 ≤ r := by nlinarith [sq_nonneg (r+3)]
  have hrhi : r ≤ 3 := by nlinarith [sq_nonneg (r-3)]
  interval_cases r <;> nlinarith

/-- In any actual full ring, a D(1)-set of cardinality at least five
containing 1 and 3 has exactly the third candidate 8 below modulus 15.
The accepted negative-extension theorem supplies positivity and rationality. -/
theorem IsD1.one_three_small_third_eq_eight
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {A : Finset (𝓞 K)} (hA : IsD1 A)
    (h1 : (1 : 𝓞 K) ∈ A) (h3 : (3 : 𝓞 K) ∈ A) (hcard : 4 < A.card)
    (z : 𝓞 K) (hz : z ∈ A) (hz1 : z ≠ 1) (hz3 : z ≠ 3)
    (hlo : 9 ≤ ‖phi (z : K)‖^2) (hhi : ‖phi (z : K)‖^2 < 225) : z = 8 := by
  classical
  obtain ⟨s,hs,rfl⟩ := hA.one_three_all_positive_integers hK h1 h3 hcard z hz
  obtain ⟨tau,nu,_,_,⟨e⟩⟩ := exists_imaginary_quadratic_ring_equiv hK
  have hnorm : ‖phi ((s : 𝓞 K) : K)‖^2 = (s : ℝ)^2 := by
    have h := norm_sq_full_ring_equiv e phi (s : QuadInt tau nu)
    simpa [QuadInt.norm_formula] using h
  rw [hnorm] at hlo hhi
  have hslo : (9 : ℤ) ≤ s^2 := by exact_mod_cast hlo
  have hshi : s^2 < 225 := by exact_mod_cast hhi
  have hs3 : s ≠ 3 := by intro h; apply hz3; simp [h]
  have hsge3 : 3 ≤ s := by nlinarith
  have hslo' : 3 < s := by omega
  have hshi' : s < 15 := by nlinarith
  obtain ⟨r,hr⟩ := full_ring_positive_integer_square hK (m := s+1) (by omega)
    (by simpa using hA.2 1 h1 (s : 𝓞 K) hz (Ne.symm hz1))
  have heq := integer_one_three_third_eq_eight s r hslo' hshi' (by nlinarith [hr])
  simp [heq]

/-- For the remaining rational triple (1,3,8), the analytic cutoff N(t)<1024
already contradicts the strict tail-growth inequality T>48. -/
theorem one_three_eight_cutoff_contradiction (T : ℝ)
    (hcutoff : T^2 < 1024) (hgrowth : 48 < T) : False := by
  nlinarith

end D1Bound5
