import D1Bound5.HomogeneousSymmetric
import D1Bound5.LagrangeAdjunction
import Mathlib.Data.Finset.Insert

open Polynomial Finset

namespace D1Bound5

/-- Reindexing variables preserves the explicit homogeneous multiset sum. -/
theorem homogeneousMultisetSum_equiv
    {ι κ R : Type*} [Fintype ι] [DecidableEq ι]
    [Fintype κ] [DecidableEq κ] [CommSemiring R]
    (e : ι ≃ κ) (a : κ → R) (n : ℕ) :
    homogeneousMultisetSum (fun i => a (e i)) n = homogeneousMultisetSum a n := by
  unfold homogeneousMultisetSum
  apply Fintype.sum_equiv (Sym.equivCongr e)
  intro t
  simp [Sym.equivCongr, Sym.coe_map, Multiset.map_map]

/-- Finite-set variable adjunction, compatible with barycentric interpolation. -/
theorem homogeneousMultisetSum_insert
    {ι R : Type*} [DecidableEq ι] [CommSemiring R]
    (s : Finset ι) (a : ι → R) (t : ι) (ht : t ∉ s) (n : ℕ) :
    homogeneousMultisetSum (fun i : (insert t s : Finset ι) => a i) (n + 1) =
      a t * homogeneousMultisetSum (fun i : (insert t s : Finset ι) => a i) n +
        homogeneousMultisetSum (fun i : s => a i) (n + 1) := by
  let e := Finset.subtypeInsertEquivOption ht
  let b : Option s → R := fun o => a (e.symm o)
  have hre (k : ℕ) : homogeneousMultisetSum b k =
      homogeneousMultisetSum (fun i : (insert t s : Finset ι) => a i) k :=
    homogeneousMultisetSum_equiv e.symm (fun i => a i) k
  have h := homogeneousMultisetSum_option_succ b n
  rw [hre (n + 1), hre n] at h
  exact h

/-- A single variable has exactly one monomial in each degree. -/
theorem homogeneousMultisetSum_singleton
    {ι R : Type*} [DecidableEq ι] [CommSemiring R]
    (a : ι → R) (t : ι) (n : ℕ) :
    homogeneousMultisetSum (fun i : ({t} : Finset ι) => a i) n = (a t)^n := by
  let t' : ({t} : Finset ι) := ⟨t, Finset.mem_singleton_self t⟩
  let : Unique ({t} : Finset ι) :=
    { default := t', uniq := fun i => Subtype.ext (Finset.mem_singleton.mp i.2) }
  have hp (v : Sym ({t} : Finset ι) n) :
      (v.1.map (fun i : ({t} : Finset ι) => a i)).prod = (a t)^n := by
    rw [Sym.eq_replicate_of_subsingleton t' v]
    simp [Sym.replicate, t']
  simp only [homogeneousMultisetSum, Fintype.sum_unique]
  exact hp default

/-- Every higher Lagrange power moment is the complete homogeneous
multiset sum, for every nonempty finite set of distinct nodes. -/
theorem lagrange_power_moment_eq_homogeneousMultisetSum
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) (hs : s.Nonempty)
    (hinj : Set.InjOn a s) (k : ℕ) :
    (∑ i ∈ s, (a i) ^ (s.card - 1 + k) /
      (∏ j ∈ s.erase i, (a i - a j))) =
      homogeneousMultisetSum (fun i : s => a i) k := by
  revert hs hinj
  induction s using Finset.induction_on generalizing k with
  | empty =>
      intro hs
      simp at hs
  | @insert t s ht ih =>
      intro hs hinj
      obtain rfl | hs' := s.eq_empty_or_nonempty
      · simp only [Finset.insert_empty, Finset.card_singleton, Nat.sub_self,
          zero_add, Finset.sum_singleton, Finset.erase_singleton, Finset.prod_empty, div_one]
        exact (homogeneousMultisetSum_singleton a t k).symm
      have hsinj : Set.InjOn a s := hinj.mono (by intro i hi; exact Finset.mem_insert_of_mem hi)
      have hsep : ∀ i ∈ s, a i ≠ a t := by
        intro i hi heq
        have hit := hinj (Finset.mem_insert_of_mem hi) (Finset.mem_insert_self t s) heq
        exact ht (hit ▸ hi)
      have hp : 0 < s.card := hs'.card_pos
      induction k with
      | zero =>
          have hn : (insert t s).card - 1 < (insert t s).card := by
            rw [Finset.card_insert_of_notMem ht]
            omega
          have hdegree : ((X : F[X]) ^ ((insert t s).card - 1)).degree <
              ((insert t s).card : WithBot ℕ) := by
            rw [Polynomial.degree_X_pow]
            exact_mod_cast hn
          have h := Lagrange.coeff_eq_sum (s := insert t s) (v := a)
            (P := (X : F[X]) ^ ((insert t s).card - 1)) hinj hdegree
          simpa [Polynomial.eval_pow, Polynomial.coeff_X_pow] using h.symm
      | succ k hk =>
          have hold := ih (k + 1) hs' hsinj
          have hold' : (∑ i ∈ s, (a i) ^ (s.card + k) /
              (∏ j ∈ s.erase i, (a i - a j))) =
              homogeneousMultisetSum (fun i : s => a i) (k + 1) := by
            simpa only [show s.card - 1 + (k + 1) = s.card + k by omega] using hold
          have hnew' : (∑ i ∈ insert t s, (a i) ^ (s.card + k) /
              (∏ j ∈ (insert t s).erase i, (a i - a j))) =
              homogeneousMultisetSum (fun i : (insert t s : Finset ι) => a i) k := by
            simpa [Finset.card_insert_of_notMem ht] using hk
          have h := lagrange_power_moment_insert s a t ht hsep (s.card + k)
          rw [hnew', hold', ← homogeneousMultisetSum_insert s a t ht k] at h
          simpa [Finset.card_insert_of_notMem ht, Nat.add_assoc] using h

/-- All-order Lagrange moments equal mathlib's complete homogeneous
symmetric polynomials, with no nonzero-node restriction. -/
theorem lagrange_power_moment_eq_hsymm
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) (hs : s.Nonempty)
    (hinj : Set.InjOn a s) (k : ℕ) :
    (∑ i ∈ s, (a i) ^ (s.card - 1 + k) /
      (∏ j ∈ s.erase i, (a i - a j))) =
      MvPolynomial.aeval (fun i : s => a i) (MvPolynomial.hsymm s F k) := by
  rw [← homogeneousMultisetSum_eq_hsymm]
  exact lagrange_power_moment_eq_homogeneousMultisetSum s a hs hinj k

end D1Bound5
