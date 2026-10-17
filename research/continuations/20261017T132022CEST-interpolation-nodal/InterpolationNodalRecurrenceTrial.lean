import Mathlib.LinearAlgebra.Lagrange

open Polynomial Finset

namespace D1Bound5

/-- A polynomial that vanishes on the nodes annihilates every weighted
power-moment sequence, for arbitrary weights and all shifts. -/
theorem polynomial_weighted_moment_annihilation
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

/-- The canonical nodal polynomial yields an exact recurrence of order
equal to the number of nodes. Repeated and zero nodes are permitted. -/
theorem nodal_weighted_moment_recurrence
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a b : ι → F) (n : ℕ) :
    (∑ k ∈ Finset.range (s.card + 1),
      (Lagrange.nodal s a).coeff k *
        (∑ i ∈ s, b i * (a i) ^ (n + k))) = 0 := by
  have hroot : ∀ i ∈ s, (Lagrange.nodal s a).eval (a i) = 0 := by
    intro i hi
    exact Lagrange.eval_nodal_at_node hi
  simpa only [Lagrange.natDegree_nodal] using
    polynomial_weighted_moment_annihilation s a b (Lagrange.nodal s a) hroot n

/-- Monicity makes the next moment the negative of the recurrence's
lower-order part. This is valid at every shift, including zero nodes. -/
theorem nodal_weighted_moment_step
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a b : ι → F) (n : ℕ) :
    (∑ k ∈ Finset.range s.card,
      (Lagrange.nodal s a).coeff k *
        (∑ i ∈ s, b i * (a i) ^ (n + k))) +
      (∑ i ∈ s, b i * (a i) ^ (n + s.card)) = 0 := by
  have htop : (Lagrange.nodal s a).coeff s.card = 1 := by
    have hmonic : (Lagrange.nodal s a).Monic := Lagrange.nodal_monic
    have hcard : (Lagrange.nodal s a).natDegree = s.card := Lagrange.natDegree_nodal
    rw [← hcard]
    exact hmonic.coeff_natDegree
  have hrec := nodal_weighted_moment_recurrence s a b n
  rw [Finset.sum_range_succ] at hrec
  simpa only [htop, one_mul] using hrec

/-- For fixed nodes, the first `s.card` moments determine all moments.
No nonzero or distinctness assumptions on the nodes are needed. -/
theorem weighted_moments_eq_of_initial
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a b c : ι → F)
    (hinit : ∀ n < s.card,
      (∑ i ∈ s, b i * (a i)^n) =
        (∑ i ∈ s, c i * (a i)^n)) :
    ∀ n : ℕ,
      (∑ i ∈ s, b i * (a i)^n) =
        (∑ i ∈ s, c i * (a i)^n) := by
  intro n
  induction n using Nat.strong_induction_on with
  | h n ih =>
    by_cases hn : n < s.card
    · exact hinit n hn
    · have hnm : n - s.card + s.card = n := by omega
      have hb := nodal_weighted_moment_step s a b (n - s.card)
      have hc := nodal_weighted_moment_step s a c (n - s.card)
      rw [hnm] at hb hc
      have heq :
          (∑ k ∈ Finset.range s.card,
            (Lagrange.nodal s a).coeff k *
              (∑ i ∈ s, b i * (a i) ^ (n - s.card + k))) =
          (∑ k ∈ Finset.range s.card,
            (Lagrange.nodal s a).coeff k *
              (∑ i ∈ s, c i * (a i) ^ (n - s.card + k))) := by
        apply Finset.sum_congr rfl
        intro k hk
        congr 1
        exact ih _ (by have hk' := Finset.mem_range.mp hk; omega)
      rw [heq] at hb
      exact add_left_cancel (hb.trans hc.symm)

/-- The ordinary Lagrange power moments obey the same all-order
recurrence, even before assuming the interpolation nodes are distinct. -/
theorem lagrange_power_moment_step
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) (n : ℕ) :
    (∑ k ∈ Finset.range s.card,
      (Lagrange.nodal s a).coeff k *
        (∑ i ∈ s, (a i) ^ (n + k) /
          ∏ j ∈ s.erase i, (a i - a j))) +
      (∑ i ∈ s, (a i) ^ (n + s.card) /
        ∏ j ∈ s.erase i, (a i - a j)) = 0 := by
  simpa only [div_eq_mul_inv, mul_comm] using
    nodal_weighted_moment_step s a
      (fun i => (∏ j ∈ s.erase i, (a i - a j))⁻¹) n

end D1Bound5


-- Standalone exact elaborated types and transitive axioms.
-- This trial is not imported by the accepted project root.
#check @D1Bound5.polynomial_weighted_moment_annihilation
#check @D1Bound5.nodal_weighted_moment_recurrence
#check @D1Bound5.nodal_weighted_moment_step
#check @D1Bound5.weighted_moments_eq_of_initial
#check @D1Bound5.lagrange_power_moment_step
#print axioms D1Bound5.polynomial_weighted_moment_annihilation
#print axioms D1Bound5.nodal_weighted_moment_recurrence
#print axioms D1Bound5.nodal_weighted_moment_step
#print axioms D1Bound5.weighted_moments_eq_of_initial
#print axioms D1Bound5.lagrange_power_moment_step
