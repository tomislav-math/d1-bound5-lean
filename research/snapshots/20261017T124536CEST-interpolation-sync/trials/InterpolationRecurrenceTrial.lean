import Mathlib.LinearAlgebra.Lagrange

open Polynomial Finset

namespace D1Bound5

/-- Every polynomial vanishing at the selected nodes annihilates each
weighted power-moment sequence. The weights are completely arbitrary. -/
theorem weighted_power_moments_annihilated
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a b : ι → F) (P : F[X])
    (hroot : ∀ i ∈ s, P.eval (a i) = 0) (n : ℕ) :
    (∑ k ∈ Finset.range (P.natDegree + 1),
      P.coeff k * (∑ i ∈ s, b i * (a i) ^ (n + k))) = 0 := by
  calc
    (∑ k ∈ Finset.range (P.natDegree + 1),
      P.coeff k * (∑ i ∈ s, b i * (a i) ^ (n + k))) =
        ∑ i ∈ s, (b i * (a i) ^ n) * P.eval (a i) := by
      simp_rw [Finset.mul_sum]
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro i hi
      rw [Polynomial.eval_eq_sum_range, Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro k hk
      rw [pow_add]
      ring
    _ = 0 := by
      apply Finset.sum_eq_zero
      intro i hi
      rw [hroot i hi, mul_zero]

/-- The nodal polynomial gives an exact recurrence for every weighted
moment, at all orders and without a nonzero-node hypothesis. -/
theorem nodal_polynomial_moment_recurrence
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a b : ι → F) (n : ℕ) :
    (∑ k ∈ Finset.range (s.card + 1),
      (∏ i ∈ s, (X - C (a i))).coeff k *
        (∑ i ∈ s, b i * (a i) ^ (n + k))) = 0 := by
  let Q : F[X] := ∏ i ∈ s, (X - C (a i))
  have hroot : ∀ i ∈ s, Q.eval (a i) = 0 := by
    intro i hi
    simp [Q, eval_prod, Finset.prod_eq_zero hi]
  have hdeg : Q.natDegree = s.card := by
    simp [Q]
  have h := weighted_power_moments_annihilated s a b Q hroot n
  simpa only [hdeg] using h

/-- The top coefficient is one, so the next weighted moment is exactly
determined by the preceding moments and lower nodal coefficients. -/
theorem nodal_polynomial_moment_step
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a b : ι → F) (n : ℕ) :
    (∑ k ∈ Finset.range s.card,
      (∏ i ∈ s, (X - C (a i))).coeff k *
        (∑ i ∈ s, b i * (a i) ^ (n + k))) +
      (∑ i ∈ s, b i * (a i) ^ (n + s.card)) = 0 := by
  let Q : F[X] := ∏ i ∈ s, (X - C (a i))
  have hmonic : Q.Monic := Polynomial.monic_prod_X_sub_C a s
  have hdeg : Q.natDegree = s.card := by simp [Q]
  have htop : Q.coeff s.card = 1 := by
    rw [← hdeg]
    exact hmonic.coeff_natDegree
  have hrec := nodal_polynomial_moment_recurrence s a b n
  rw [Finset.sum_range_succ] at hrec
  simpa only [htop, one_mul] using hrec

end D1Bound5
