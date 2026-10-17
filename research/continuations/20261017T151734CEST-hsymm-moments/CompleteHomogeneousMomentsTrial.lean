import Mathlib.LinearAlgebra.Lagrange
import Mathlib.RingTheory.Polynomial.Vieta
import exploration.ReciprocalAnchorTrial

open Polynomial Finset

namespace D1Bound5

/-- Every Lagrange power moment is the next-to-leading coefficient of
the polynomial remainder by the nodal polynomial, at every order. -/
theorem lagrange_power_moment_remainder
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F)
    (hinj : Set.InjOn a s) (n : ℕ) :
    (∑ i ∈ s, (a i) ^ n /
      ∏ j ∈ s.erase i, (a i - a j)) =
      (((X : F[X]) ^ n %ₘ (Lagrange.nodal s a)).coeff (s.card - 1)) := by
  have hdegree :
      (((X : F[X]) ^ n %ₘ (Lagrange.nodal s a)).degree <
        (s.card : WithBot ℕ)) := by
    have hnodal : (Lagrange.nodal s a).degree = (s.card : WithBot ℕ) :=
      Lagrange.degree_nodal
    exact (Polynomial.degree_modByMonic_lt _ (Lagrange.nodal_monic (s := s) (v := a))).trans_eq hnodal
  have heval : ∀ i ∈ s,
      (((X : F[X]) ^ n %ₘ (Lagrange.nodal s a)).eval (a i)) = (a i) ^ n := by
    intro i hi
    have h := congrArg (fun P : F[X] => P.eval (a i))
      (Polynomial.modByMonic_add_div ((X : F[X]) ^ n) (Lagrange.nodal s a))
    simpa [Polynomial.eval_add, Polynomial.eval_mul,
      Lagrange.eval_nodal_at_node hi] using h
  calc
    (∑ i ∈ s, (a i) ^ n / ∏ j ∈ s.erase i, (a i - a j)) =
      ∑ i ∈ s,
        (((X : F[X]) ^ n %ₘ (Lagrange.nodal s a)).eval (a i)) /
          ∏ j ∈ s.erase i, (a i - a j) := by
        apply Finset.sum_congr rfl
        intro i hi
        rw [heval i hi]
    _ = _ := (Lagrange.coeff_eq_sum hinj hdegree).symm

/-- Ordinary Lagrange moments of degree below the number of nodes
are zero except in the top degree, where the moment equals one. -/
theorem lagrange_power_moment_low
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) (hinj : Set.InjOn a s)
    (n : ℕ) (hn : n < s.card) :
    (∑ i ∈ s, (a i) ^ n /
      ∏ j ∈ s.erase i, (a i - a j)) =
        if n = s.card - 1 then 1 else 0 := by
  have hdegree : ((X : F[X]) ^ n).degree < (s.card : WithBot ℕ) := by
    rw [Polynomial.degree_X_pow]
    exact_mod_cast hn
  have hcoeff := Lagrange.coeff_eq_sum (s := s) (v := a)
    (P := (X : F[X]) ^ n) hinj hdegree
  simpa [Polynomial.eval_pow, Polynomial.coeff_X_pow, eq_comm] using hcoeff.symm

/-- The first higher Lagrange moment is the first complete homogeneous
symmetric polynomial, namely the sum of the interpolation nodes. -/
theorem lagrange_power_moment_first_hsymm
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F)
    (hinj : Set.InjOn a s) (hs : 0 < s.card) :
    (∑ i ∈ s, (a i) ^ s.card /
      ∏ j ∈ s.erase i, (a i - a j)) = ∑ i ∈ s, a i := by
  let Q : F[X] := Lagrange.nodal s a
  have hdegX : ((X : F[X]) ^ s.card).degree = (s.card : WithBot ℕ) := by
    simp
  have hdegQ : Q.degree = (s.card : WithBot ℕ) := Lagrange.degree_nodal
  have hlc : ((X : F[X]) ^ s.card).leadingCoeff = Q.leadingCoeff := by
    rw [(monic_X_pow s.card).leadingCoeff, (Lagrange.nodal_monic (s := s) (v := a)).leadingCoeff]
  have hxne : ((X : F[X]) ^ s.card) ≠ 0 := (monic_X_pow s.card).ne_zero
  have hlt : (((X : F[X]) ^ s.card - Q).degree) < (s.card : WithBot ℕ) := by
    exact (Polynomial.degree_sub_lt_left (hdegX.trans hdegQ.symm) hxne hlc).trans_eq hdegX
  have hcoeffQ : Q.coeff (s.card - 1) = -(∑ i ∈ s, a i) := by
    simpa [Q, Lagrange.nodal_eq] using
      (Polynomial.prod_X_sub_C_coeff_card_pred s a hs)
  have hneq : s.card - 1 ≠ s.card := by omega
  have hcoeffP :
      (((X : F[X]) ^ s.card - Q).coeff (s.card - 1)) = ∑ i ∈ s, a i := by
    simp [Polynomial.coeff_sub, hneq, hcoeffQ]
  have heval : ∀ i ∈ s,
      (((X : F[X]) ^ s.card - Q).eval (a i)) = (a i) ^ s.card := by
    intro i hi
    simp [Q, Polynomial.eval_sub, Lagrange.eval_nodal_at_node hi]
  have hcoeff := Lagrange.coeff_eq_sum (s := s) (v := a)
    (P := (X : F[X]) ^ s.card - Q) hinj hlt
  calc
    (∑ i ∈ s, (a i) ^ s.card / ∏ j ∈ s.erase i, (a i - a j)) =
        (((X : F[X]) ^ s.card - Q).coeff (s.card - 1)) := by
          rw [hcoeff]
          apply Finset.sum_congr rfl
          intro i hi
          rw [heval i hi]
    _ = _ := hcoeffP

/-- The full negative-power interpolation expression is an exact signed
reciprocal product times a coefficient of an ordinary polynomial remainder.
This identity has no restriction on the exponent. -/
theorem reciprocal_anchor_sum_remainder
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F)
    (ha : ∀ j ∈ s, a j ≠ 0) (hinj : Set.InjOn a s)
    (k : ℕ) :
    (∑ i ∈ s, ((a i)⁻¹) ^ (k + 1) /
      (∏ j ∈ s.erase i, (a i - a j))) =
    ((-1 : F) ^ (s.card - 1) * (∏ j ∈ s, a j)⁻¹) *
      (((X : F[X]) ^ (k + s.card - 1) %ₘ
        (Lagrange.nodal s (fun i => (a i)⁻¹))).coeff (s.card - 1)) := by
  have hinv : Set.InjOn (fun i => (a i)⁻¹) s := by
    intro i hi j hj hij
    apply hinj hi hj
    simpa only [inv_inv] using congrArg Inv.inv hij
  calc
    _ = ((-1 : F) ^ (s.card - 1) * (∏ j ∈ s, a j)⁻¹) *
      (∑ i ∈ s, ((a i)⁻¹) ^ (k + s.card - 1) /
        (∏ j ∈ s.erase i, ((a i)⁻¹ - (a j)⁻¹))) :=
          reciprocal_anchor_sum_transfer s a ha k
    _ = _ := by
      rw [lagrange_power_moment_remainder s (fun i => (a i)⁻¹) hinv
        (k + s.card - 1)]

end D1Bound5

#check @D1Bound5.lagrange_power_moment_remainder
#check @D1Bound5.lagrange_power_moment_low
#check @D1Bound5.lagrange_power_moment_first_hsymm
#check @D1Bound5.reciprocal_anchor_sum_remainder
#print axioms D1Bound5.lagrange_power_moment_remainder
#print axioms D1Bound5.lagrange_power_moment_low
#print axioms D1Bound5.lagrange_power_moment_first_hsymm
#print axioms D1Bound5.reciprocal_anchor_sum_remainder
