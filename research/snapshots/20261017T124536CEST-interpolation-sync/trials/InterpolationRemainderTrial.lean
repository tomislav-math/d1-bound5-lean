import Mathlib.LinearAlgebra.Lagrange

open Polynomial Finset

namespace D1Bound5

/-- The monic polynomial with the chosen interpolation nodes as roots. -/
noncomputable def anchorVanishingPolynomial
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) : F[X] :=
  ∏ i ∈ s, (X - C (a i))

theorem anchorVanishingPolynomial_monic
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) :
    (anchorVanishingPolynomial s a).Monic := by
  exact Polynomial.monic_prod_X_sub_C a s

theorem anchorVanishingPolynomial_degree
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) :
    (anchorVanishingPolynomial s a).degree = (s.card : WithBot ℕ) := by
  rw [degree_eq_natDegree (anchorVanishingPolynomial_monic s a).ne_zero]
  simp [anchorVanishingPolynomial]

theorem anchorVanishingPolynomial_eval_zero
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) (i : ι) (hi : i ∈ s) :
    (anchorVanishingPolynomial s a).eval (a i) = 0 := by
  simp only [anchorVanishingPolynomial, eval_prod]
  apply Finset.prod_eq_zero hi
  simp

/-- Every weighted interpolation evaluation is the coefficient of the
remainder modulo the nodal polynomial, without a degree restriction. -/
theorem anchor_weighted_eval_remainder_coeff
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F)
    (ha : Set.InjOn a s) (P : F[X]) :
    (∑ i ∈ s, P.eval (a i) /
      ∏ j ∈ s.erase i, (a i - a j)) =
      (P %ₘ anchorVanishingPolynomial s a).coeff (s.card - 1) := by
  let Q : F[X] := anchorVanishingPolynomial s a
  have hmonic : Q.Monic := anchorVanishingPolynomial_monic s a
  have hdeg : (P %ₘ Q).degree < (s.card : WithBot ℕ) := by
    rw [← anchorVanishingPolynomial_degree s a]
    exact degree_modByMonic_lt P hmonic
  have heval (i : ι) (hi : i ∈ s) :
      (P %ₘ Q).eval (a i) = P.eval (a i) := by
    have hroot : Q.eval (a i) = 0 :=
      anchorVanishingPolynomial_eval_zero s a i hi
    have h := Polynomial.eval₂_modByMonic_eq_self_of_root
      (p := P) (q := Q) (f := RingHom.id F) (x := a i)
      (by simpa only [Polynomial.eval₂_id] using hroot)
    simpa only [Polynomial.eval₂_id] using h
  calc
    (∑ i ∈ s, P.eval (a i) /
      ∏ j ∈ s.erase i, (a i - a j)) =
      (∑ i ∈ s, (P %ₘ Q).eval (a i) /
        ∏ j ∈ s.erase i, (a i - a j)) := by
          apply Finset.sum_congr rfl
          intro i hi
          rw [heval i hi]
    _ = (P %ₘ Q).coeff (s.card - 1) :=
      (Lagrange.coeff_eq_sum (s := s) (v := a) ha hdeg).symm

/-- The formula applies to every power, including those beyond the
initial cancellation range. -/
theorem anchor_weighted_power_remainder_coeff
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) (ha : Set.InjOn a s)
    (n : ℕ) :
    (∑ i ∈ s, (a i)^n /
      ∏ j ∈ s.erase i, (a i - a j)) =
      (((X : F[X]) ^ n %ₘ anchorVanishingPolynomial s a).coeff
        (s.card - 1)) := by
  simpa only [Polynomial.eval_pow, Polynomial.eval_X] using
    anchor_weighted_eval_remainder_coeff s a ha ((X : F[X]) ^ n)

end D1Bound5

-- Isolated exact elaborated types and transitive axiom inspection.
-- This is not an accepted root-imported module.
#check @D1Bound5.anchorVanishingPolynomial_monic
#check @D1Bound5.anchorVanishingPolynomial_degree
#check @D1Bound5.anchorVanishingPolynomial_eval_zero
#check @D1Bound5.anchor_weighted_eval_remainder_coeff
#check @D1Bound5.anchor_weighted_power_remainder_coeff
#print axioms D1Bound5.anchorVanishingPolynomial_monic
#print axioms D1Bound5.anchorVanishingPolynomial_degree
#print axioms D1Bound5.anchorVanishingPolynomial_eval_zero
#print axioms D1Bound5.anchor_weighted_eval_remainder_coeff
#print axioms D1Bound5.anchor_weighted_power_remainder_coeff
