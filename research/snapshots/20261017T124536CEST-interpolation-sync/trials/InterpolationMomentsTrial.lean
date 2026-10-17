import Mathlib.LinearAlgebra.Lagrange

open Polynomial Finset

namespace D1Bound5

/-- Leading coefficient extraction from distinct interpolation anchors.
This identity uses the full set of nodes, over an arbitrary field. -/
theorem anchor_weighted_eval_coeff
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F)
    (ha : Set.InjOn a s) (P : F[X])
    (hdeg : P.degree < (s.card : WithBot ℕ)) :
    (∑ i ∈ s, P.eval (a i) / ∏ j ∈ s.erase i, (a i - a j)) =
      P.coeff (s.card - 1) := by
  exact (Lagrange.coeff_eq_sum (s := s) (v := a) ha hdeg).symm

/-- All interpolation weight moments strictly below the number of nodes. -/
theorem anchor_weighted_power_moment
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F)
    (ha : Set.InjOn a s) (n : ℕ) (hn : n < s.card) :
    (∑ i ∈ s, (a i)^n / ∏ j ∈ s.erase i, (a i - a j)) =
      if n = s.card - 1 then 1 else 0 := by
  have hdeg : ((X : F[X]) ^ n).degree < (s.card : WithBot ℕ) := by
    simpa using (WithBot.coe_lt_coe.mpr hn :
      (n : WithBot ℕ) < (s.card : WithBot ℕ))
  have h := anchor_weighted_eval_coeff s a ha ((X : F[X]) ^ n) hdeg
  simpa [Polynomial.eval_pow, Polynomial.coeff_X_pow, eq_comm] using h

/-- Every moment of degree at most `s.card - 2` vanishes. -/
theorem anchor_weighted_low_moment_zero
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) (ha : Set.InjOn a s)
    (n : ℕ) (hn : n + 1 < s.card) :
    (∑ i ∈ s, (a i)^n / ∏ j ∈ s.erase i, (a i - a j)) = 0 := by
  have hn' : n < s.card := lt_trans (Nat.lt_succ_self n) hn
  have hne : n ≠ s.card - 1 := by omega
  simpa [hne] using anchor_weighted_power_moment s a ha n hn'

/-- The first nonvanishing Lagrange moment is exactly one. -/
theorem anchor_weighted_top_moment_one
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) (ha : Set.InjOn a s)
    (hs : s.Nonempty) :
    (∑ i ∈ s, (a i)^(s.card - 1) /
      ∏ j ∈ s.erase i, (a i - a j)) = 1 := by
  have hn : s.card - 1 < s.card :=
    Nat.sub_lt hs.card_pos (by decide)
  simpa using anchor_weighted_power_moment s a ha (s.card - 1) hn

/-- The exact cancellation and normalization used for the first `m` terms
of the coherent square-root interpolation in the manuscript. -/
theorem anchor_coherent_initial_moments
    {F : Type*} [Field F] (m : ℕ) (a : Fin m → F)
    (ha : Function.Injective a) (n : ℕ) (hn : n < m) :
    (∑ i : Fin m, (a i)^(m - 1 - n) /
      ∏ j ∈ (Finset.univ : Finset (Fin m)).erase i, (a i - a j)) =
      if n = 0 then 1 else 0 := by
  have hm : 0 < m := lt_of_le_of_lt (Nat.zero_le n) hn
  by_cases hn0 : n = 0
  · subst n
    have hs : (Finset.univ : Finset (Fin m)).Nonempty :=
      ⟨⟨0, hm⟩, Finset.mem_univ _⟩
    simpa using (anchor_weighted_top_moment_one Finset.univ a ha.injOn hs)
  · have hlt : (m - 1 - n) + 1 < m := by omega
    have h := anchor_weighted_low_moment_zero Finset.univ a ha.injOn
      (m - 1 - n) (by simpa using hlt)
    simpa [hn0] using h

end D1Bound5

-- Isolated exact-type and transitive-axiom diagnostics; this is not a root import.
#check @D1Bound5.anchor_weighted_eval_coeff
#check @D1Bound5.anchor_weighted_power_moment
#check @D1Bound5.anchor_weighted_low_moment_zero
#check @D1Bound5.anchor_weighted_top_moment_one
#check @D1Bound5.anchor_coherent_initial_moments
#print axioms D1Bound5.anchor_weighted_eval_coeff
#print axioms D1Bound5.anchor_weighted_power_moment
#print axioms D1Bound5.anchor_weighted_low_moment_zero
#print axioms D1Bound5.anchor_weighted_top_moment_one
#print axioms D1Bound5.anchor_coherent_initial_moments
