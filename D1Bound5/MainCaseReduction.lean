import D1Bound5.Specification
import D1Bound5.Sextuple
import Mathlib.Analysis.Complex.Basic
import Lean.Elab.Tactic.Omega

open scoped NumberField

universe u

namespace D1Bound5

/-- For a monotonically ordered sextuple, no weight is below the cutoff
exactly when its first weight is at least the cutoff. Ties are permitted. -/
theorem ordered_sextuple_no_small_iff
    {R W : Type*} [LinearOrder W] (weight : R → W) (cutoff : W)
    (t : Fin 6 → R) (hmon : Monotone (weight ∘ t)) :
    (∀ i, cutoff ≤ weight (t i)) ↔ cutoff ≤ weight (t 0) := by
  constructor
  · intro h
    exact h 0
  · intro h i
    exact h.trans (hmon (Fin.zero_le i))

/-- Exactly the first entry has weight below the cutoff if and only if
the first weight is below it and the second is at least it. -/
theorem ordered_sextuple_one_small_iff
    {R W : Type*} [LinearOrder W] (weight : R → W) (cutoff : W)
    (t : Fin 6 → R) (hmon : Monotone (weight ∘ t)) :
    (∀ i, weight (t i) < cutoff ↔ i = 0) ↔
      weight (t 0) < cutoff ∧ cutoff ≤ weight (t 1) := by
  constructor
  · intro h
    refine ⟨(h 0).mpr rfl, ?_⟩
    apply le_of_not_gt
    intro hs
    have hi : (1 : Fin 6) = 0 := (h 1).mp hs
    exact (by decide : (1 : Fin 6) ≠ 0) hi
  · rintro ⟨hfirst, hsecond⟩ i
    constructor
    · intro hs
      by_contra hi
      have hindex : (1 : Fin 6) ≤ i := by omega
      exact (not_lt_of_ge (hsecond.trans (hmon hindex))) hs
    · intro hi
      subst i
      exact hfirst

/-- At least two entries have weight below the cutoff exactly when the
second weight is below it. Equal weights cause no exception. -/
theorem ordered_sextuple_two_small_iff
    {R W : Type*} [LinearOrder W] (weight : R → W) (cutoff : W)
    (t : Fin 6 → R) (hmon : Monotone (weight ∘ t)) :
    (∃ i j : Fin 6, i ≠ j ∧
      weight (t i) < cutoff ∧ weight (t j) < cutoff) ↔
      weight (t 1) < cutoff := by
  constructor
  · rintro ⟨i, j, hij, hi, hj⟩
    by_cases hindex : (1 : Fin 6) ≤ i
    · exact lt_of_le_of_lt (hmon hindex) hi
    · have hizero : i = 0 := by omega
      have hjindex : (1 : Fin 6) ≤ j := by omega
      exact lt_of_le_of_lt (hmon hjindex) hj
  · intro h
    exact ⟨0, 1, by decide,
      lt_of_le_of_lt (hmon (by decide : (0 : Fin 6) ≤ 1)) h, h⟩

/-- The cardinality bound is equivalent to the three ordered exclusions.
This is an exact reduction, not a proof of any of the three exclusions. -/
theorem card_bound_iff_three_ordered_cases
    {R W : Type*} [CommRing R] [LinearOrder W]
    (weight : R → W) (cutoff : W) :
    (∀ A : Finset R, IsD1 A → A.card ≤ 5) ↔
      (∀ t : Fin 6 → R, IsD1Tuple t → Monotone (weight ∘ t) →
        cutoff ≤ weight (t 0) → False) ∧
      (∀ t : Fin 6 → R, IsD1Tuple t → Monotone (weight ∘ t) →
        weight (t 0) < cutoff → cutoff ≤ weight (t 1) → False) ∧
      (∀ t : Fin 6 → R, IsD1Tuple t → Monotone (weight ∘ t) →
        weight (t 1) < cutoff → False) := by
  rw [card_bound_iff_no_ordered_sextuple weight]
  constructor
  · intro h
    exact ⟨fun t ht hm _ => h t ht hm,
      fun t ht hm _ _ => h t ht hm,
      fun t ht hm _ => h t ht hm⟩
  · rintro ⟨hlarge, hone, htwo⟩ t ht hm
    by_cases hfirst : cutoff ≤ weight (t 0)
    · exact hlarge t ht hm hfirst
    · by_cases hsecond : cutoff ≤ weight (t 1)
      · exact hone t ht hm (lt_of_not_ge hfirst) hsecond
      · exact htwo t ht hm (lt_of_not_ge hsecond)

/-- The exact full-ring target is equivalent to the manuscript's three
ordered sextuple cases for every complex embedding. The three exclusions
are displayed explicitly. This theorem proves their equivalence with the
target, and does not supply any missing branch proof. -/
theorem mainStatement_iff_three_ordered_cases :
    MainStatement.{u} ↔
      ∀ (K : Type u) [Field K] [NumberField K]
        [NumberField.IsTotallyComplex K], Module.finrank ℚ K = 2 →
        ∀ phi : K →+* ℂ,
          (∀ t : Fin 6 → 𝓞 K, IsD1Tuple t →
            Monotone (fun i => ‖phi (t i : K)‖) →
            3 ≤ ‖phi (t 0 : K)‖ → False) ∧
          (∀ t : Fin 6 → 𝓞 K, IsD1Tuple t →
            Monotone (fun i => ‖phi (t i : K)‖) →
            ‖phi (t 0 : K)‖ < 3 → 3 ≤ ‖phi (t 1 : K)‖ → False) ∧
          (∀ t : Fin 6 → 𝓞 K, IsD1Tuple t →
            Monotone (fun i => ‖phi (t i : K)‖) →
            ‖phi (t 1 : K)‖ < 3 → False) := by
  constructor
  · intro h K _ _ _ hK phi
    exact (card_bound_iff_three_ordered_cases
      (fun z : 𝓞 K => ‖phi (z : K)‖) (3 : ℝ)).mp (h K hK)
  · intro h
    intro K _ _ _ hK
    let phi : K →+* ℂ := Classical.choice inferInstance
    exact (card_bound_iff_three_ordered_cases
      (fun z : 𝓞 K => ‖phi (z : K)‖) (3 : ℝ)).mpr (h K hK phi)

end D1Bound5

#check @D1Bound5.mainStatement_iff_three_ordered_cases
#print axioms D1Bound5.mainStatement_iff_three_ordered_cases
