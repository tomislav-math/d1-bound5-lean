import Mathlib.RingTheory.MvPolynomial.Symmetric.Defs
import Mathlib.Data.Sym.Basic

open Finset Multiset Sym

namespace D1Bound5

/-- The value of the complete homogeneous symmetric polynomial as an explicit
sum over degree-n multisets. No distinctness assumptions are needed. -/
def homogeneousMultisetSum
    {ι R : Type*} [Fintype ι] [DecidableEq ι] [CommSemiring R]
    (a : ι → R) (n : ℕ) : R :=
  ∑ t : Sym ι n, (t.1.map a).prod

/-- The multiset sum agrees at every degree with mathlib's hsymm under evaluation. -/
theorem homogeneousMultisetSum_eq_hsymm
    {ι R : Type*} [Fintype ι] [DecidableEq ι] [CommSemiring R]
    (a : ι → R) (n : ℕ) :
    homogeneousMultisetSum a n =
      MvPolynomial.aeval a (MvPolynomial.hsymm ι R n) := by
  simp only [homogeneousMultisetSum, MvPolynomial.hsymm, map_sum]
  apply Finset.sum_congr rfl
  intro t _
  rw [map_multiset_prod]
  simp only [Multiset.map_map, Function.comp_apply, MvPolynomial.aeval_X]

/-- When a new variable is adjoined, the complete homogeneous polynomial
satisfies a one-step recursion at every positive degree. -/
theorem homogeneousMultisetSum_option_succ
    {ι R : Type*} [Fintype ι] [DecidableEq ι] [CommSemiring R]
    (a : Option ι → R) (n : ℕ) :
    homogeneousMultisetSum a (n + 1) =
      a none * homogeneousMultisetSum a n +
        homogeneousMultisetSum (fun i : ι => a (some i)) (n + 1) := by
  unfold homogeneousMultisetSum
  calc
    (∑ t : Sym (Option ι) (n + 1), (t.1.map a).prod) =
      ∑ t : Sum (Sym (Option ι) n) (Sym ι (n + 1)),
        (((symOptionSuccEquiv (α := ι)).symm t).1.map a).prod := by
          apply Fintype.sum_equiv (symOptionSuccEquiv (α := ι))
          intro t
          simp
    _ = _ := by
      simp only [Fintype.sum_sum_type]
      simp [symOptionSuccEquiv, SymOptionSuccEquiv.decode,
        Sym.coe_cons, Sym.coe_map, Multiset.map_cons, Multiset.map_map,
        Multiset.prod_cons, Finset.mul_sum]

/-- The empty-degree complete homogeneous symmetric polynomial evaluates to one. -/
@[simp] theorem homogeneousMultisetSum_zero
    {ι R : Type*} [Fintype ι] [DecidableEq ι] [CommSemiring R]
    (a : ι → R) : homogeneousMultisetSum a 0 = 1 := by
  rw [homogeneousMultisetSum_eq_hsymm]
  simp

/-- The all-degree variable-adjunction formula, obtained by iterating the
one-step recursion. It is valid even when the scalar values coincide. -/
theorem homogeneousMultisetSum_option_closed
    {ι R : Type*} [Fintype ι] [DecidableEq ι] [CommSemiring R]
    (a : Option ι → R) (n : ℕ) :
    homogeneousMultisetSum a n =
      ∑ j ∈ Finset.range (n + 1),
        (a none) ^ (n - j) * homogeneousMultisetSum (fun i : ι => a (some i)) j := by
  induction n with
  | zero =>
      simp
  | succ n ih =>
      rw [homogeneousMultisetSum_option_succ, ih]
      conv_rhs => rw [Finset.sum_range_succ]
      simp only [Nat.sub_self, pow_zero, one_mul]
      rw [Finset.mul_sum]
      congr 1
      apply Finset.sum_congr rfl
      intro j hj
      have hle : j ≤ n := Nat.le_of_lt_succ (Finset.mem_range.mp hj)
      have hs : n + 1 - j = (n - j) + 1 := by omega
      rw [hs, pow_succ]
      ring

/-- Evaluation of mathlib's hsymm satisfies the one-step variable-adjunction recursion. -/
theorem hsymm_aeval_option_succ
    {ι R : Type*} [Fintype ι] [DecidableEq ι] [CommSemiring R]
    (a : Option ι → R) (n : ℕ) :
    MvPolynomial.aeval a (MvPolynomial.hsymm (Option ι) R (n + 1)) =
      a none * MvPolynomial.aeval a (MvPolynomial.hsymm (Option ι) R n) +
        MvPolynomial.aeval (fun i : ι => a (some i))
          (MvPolynomial.hsymm ι R (n + 1)) := by
  simpa only [homogeneousMultisetSum_eq_hsymm] using
    (homogeneousMultisetSum_option_succ a n)

/-- Evaluation of mathlib's hsymm satisfies the full all-degree
variable-adjunction formula. -/
theorem hsymm_aeval_option_closed
    {ι R : Type*} [Fintype ι] [DecidableEq ι] [CommSemiring R]
    (a : Option ι → R) (n : ℕ) :
    MvPolynomial.aeval a (MvPolynomial.hsymm (Option ι) R n) =
      ∑ j ∈ Finset.range (n + 1),
        (a none) ^ (n - j) *
          MvPolynomial.aeval (fun i : ι => a (some i)) (MvPolynomial.hsymm ι R j) := by
  simpa only [homogeneousMultisetSum_eq_hsymm] using
    (homogeneousMultisetSum_option_closed a n)

end D1Bound5
