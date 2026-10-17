# Arbitrary-anchor polynomial interpolation moments

Status: ISOLATED PROVED TRIAL, not an accepted root-imported dependency.
Source: `exploration/InterpolationMomentsTrial.lean` on the authorized Mac.
The isolation is deliberate: an attempted copy to the root module was
PRE_EXECUTION_DENIED before execution, with cause UNKNOWN.

## Mathematical statement

Let F be any field and let a_0,...,a_(m-1) be distinct elements of F.
For every n with 0 <= n < m,

    sum_{i=0}^{m-1} a_i^(m-1-n) / prod_{j != i} (a_i-a_j)
      = 1  if n = 0,
      = 0  if 1 <= n < m.

The proof is uniform in m, requires no nonzero-anchor assumption, and
works in arbitrary characteristic when the nodes are distinct. The more
general theorem identifies the same interpolation sum with the top
coefficient of any polynomial of degree less than m. It specializes
Mathlib's proved Lagrange coefficient identity and explicitly bridges
the indexing and normalization used in the manuscript's coherent
interpolation formula in the first part of Section 3.

This discharges the finite low-order cancellation in equation
`coherent-exact`; it does NOT prove the complete homogeneous symmetric
polynomial identity for all higher orders, the analytic binomial-series
tail, the integrality of the linear-form coefficients, Bennett's
arbitrary-order residue determinant, or any sextuple exclusion.

## Proof and trust record

- Initial pinned build of Mathlib.LinearAlgebra.Lagrange: EXIT 0,
  1748 jobs. No package installation, version or revision change.
- Trial01/02: unavailable prebuilt Mathlib imports; trial03: missing
  complex-field instances; trial04: `if` equality orientation; these were
  corrected without weakening the statement (generalized to any field).
- Trial05: EXIT 0 for the coefficient and power-moment statements.
- Trial06: EXIT 0 adding vanishing and top-moment normalization.
- Trial07: EXIT 0 adding the exact m-anchor reverse-indexed identity.
- Isolated exact elaborated types and printed transitive axioms: EXIT 0,
  all five statements; only `propext`, `Classical.choice`, `Quot.sound`.
- No `sorry`, `admit`, custom axioms, unsafe/native proof shortcuts.
- No root-module compilation, source/import audit, standalone OLean
  kernel replay, clean checkout or independent proof review for this unit.

## Next precise step

After a legitimate access resolution, root-integrate the saved proof,
compile the pinned root, perform a dedicated enforced axiom/type audit,
run targeted installed same-kernel replay, and update the two SHA manifests.
Then extend the interpolation identity to higher moments and the analytic
remainder before attempting the full Bennett determinant construction.
The main bound-five theorem remains UNPROVED.

## Recovery source (theorem bodies; not an accepted root import)

The following text reproduces the five mathematical theorem bodies from the
successfully elaborated isolated trial. The original with #check/#print axioms
remains at the local path and SHA-256 given above.

```lean
import Mathlib.LinearAlgebra.Lagrange

open Polynomial Finset
namespace D1Bound5

theorem anchor_weighted_eval_coeff
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F)
    (ha : Set.InjOn a s) (P : F[X])
    (hdeg : P.degree < (s.card : WithBot ℕ)) :
    (∑ i ∈ s, P.eval (a i) / ∏ j ∈ s.erase i, (a i - a j)) =
      P.coeff (s.card - 1) := by
  exact (Lagrange.coeff_eq_sum (s := s) (v := a) ha hdeg).symm

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

theorem anchor_weighted_low_moment_zero
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) (ha : Set.InjOn a s)
    (n : ℕ) (hn : n + 1 < s.card) :
    (∑ i ∈ s, (a i)^n / ∏ j ∈ s.erase i, (a i - a j)) = 0 := by
  have hn' : n < s.card := lt_trans (Nat.lt_succ_self n) hn
  have hne : n ≠ s.card - 1 := by omega
  simpa [hne] using anchor_weighted_power_moment s a ha n hn'

theorem anchor_weighted_top_moment_one
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) (ha : Set.InjOn a s)
    (hs : s.Nonempty) :
    (∑ i ∈ s, (a i)^(s.card - 1) /
      ∏ j ∈ s.erase i, (a i - a j)) = 1 := by
  have hn : s.card - 1 < s.card :=
    Nat.sub_lt hs.card_pos (by decide)
  simpa using anchor_weighted_power_moment s a ha (s.card - 1) hn

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
```
