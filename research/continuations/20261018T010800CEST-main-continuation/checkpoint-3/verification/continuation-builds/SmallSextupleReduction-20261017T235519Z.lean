import D1Bound5.SmallQuadruple

open scoped NumberField
open Module

namespace D1Bound5

/-- The fourth entry of an actual ordered sextuple already has modulus at
least three. This follows from the unconditional no-four-small theorem,
and permits equal moduli and zero pair square roots. -/
theorem IsD1Tuple.fourth_norm_ge_three
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 6 → 𝓞 K) (ht : IsD1Tuple t)
    (hmon : Monotone (fun i => ‖phi (t i : K)‖)) :
    3 ≤ ‖phi (t 3 : K)‖ := by
  by_contra h
  have hsmall : ‖phi (t 3 : K)‖ < 3 := lt_of_not_ge h
  let j : Fin 4 → Fin 6 := fun i => ⟨i.val, Nat.lt_trans i.isLt (by decide)⟩
  have hj : Function.Injective j := by
    intro i k hik
    apply Fin.ext
    exact congrArg (fun l : Fin 6 => l.val) hik
  let s : Fin 4 → 𝓞 K := fun i => t (j i)
  have hs : IsD1Tuple s := by
    refine ⟨ht.1.comp hj, fun i => ht.2.1 (j i), ?_⟩
    intro i k hik
    exact ht.2.2 (j i) (j k) (fun h => hik (hj h))
  apply IsD1Tuple.not_four_small hK phi s hs
  intro i
  have hi : j i ≤ (3 : Fin 6) := by
    change i.val ≤ 3
    omega
  exact lt_of_le_of_lt (hmon hi) hsmall

/-- In the remaining small-entry sextuple branch there are exactly two
or exactly three small entries. This is a genuine restriction deduced
from the no-four-small result, not an assumed branch exclusion. -/
theorem IsD1Tuple.two_or_three_small
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 6 → 𝓞 K) (ht : IsD1Tuple t)
    (hmon : Monotone (fun i => ‖phi (t i : K)‖))
    (htwo : ‖phi (t 1 : K)‖ < 3) :
    (‖phi (t 1 : K)‖ < 3 ∧ 3 ≤ ‖phi (t 2 : K)‖) ∨
      (‖phi (t 2 : K)‖ < 3 ∧ 3 ≤ ‖phi (t 3 : K)‖) := by
  by_cases hthird : 3 ≤ ‖phi (t 2 : K)‖
  · exact Or.inl ⟨htwo, hthird⟩
  · exact Or.inr ⟨lt_of_not_ge hthird,
      IsD1Tuple.fourth_norm_ge_three hK phi t ht hmon⟩

end D1Bound5
