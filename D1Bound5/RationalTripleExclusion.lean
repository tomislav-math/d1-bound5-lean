import D1Bound5.RationalCutoffBound
import D1Bound5.OneThreeEight

open scoped NumberField
open Module

namespace D1Bound5

/-- The universal rational triple cannot start a sorted full-ring
sextuple: its actual analytic cutoff contradicts actual tail growth. -/
theorem IsD1Tuple.not_rational_one_three_eight
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (sgn : Bool)
    (h0 : a 0 = if sgn then -1 else 1)
    (h1 : a 1 = if sgn then -3 else 3)
    (h2 : a 2 = if sgn then -8 else 8) : False := by
  have hcut := IsD1Tuple.rational_cutoff_fourth_norm_sq_lt
    hK phi a ha hmon sgn h0 h1 h2
  let b : Fin 4 → 𝓞 K := fun i => a (Fin.castAdd 2 i)
  have hi : Function.Injective (Fin.castAdd 2 : Fin 4 → Fin 6) := by
    intro i j h
    apply Fin.ext
    exact congrArg (fun k : Fin 6 => k.val) h
  have hb : IsD1Tuple b := by
    refine ⟨ha.1.comp hi,?_,?_⟩
    · intro i
      exact ha.2.1 (Fin.castAdd 2 i)
    · intro i j hij
      exact ha.2.2 (Fin.castAdd 2 i) (Fin.castAdd 2 j) (hi.ne hij)
  have hm : Monotone (fun i => ‖phi (b i : K)‖) := by
    intro i j hij
    exact hmon hij
  have hB : ‖phi (a 1 : K)‖ = 3 := by rw [h1]; cases sgn <;> norm_num [NumberField.RingOfIntegers.coe_eq_algebraMap,map_ofNat]
  have hS : ‖phi (a 2 : K)‖ = 8 := by rw [h2]; cases sgn <;> norm_num [NumberField.RingOfIntegers.coe_eq_algebraMap,map_ofNat]
  have hB3 : 3 ≤ ‖phi (b 1 : K)‖ := by change 3 ≤ ‖phi (a 1 : K)‖; rw [hB]
  have hg := (IsD1Tuple.tail_irregular_and_growth hK phi b hb hm hB3).2
  change 2*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖ < ‖phi (a 3 : K)‖ at hg
  rw [hB,hS] at hg
  exact one_three_eight_cutoff_contradiction ‖phi (a 3 : K)‖ hcut (by norm_num at hg ⊢; exact hg)

end D1Bound5

#print axioms D1Bound5.IsD1Tuple.not_rational_one_three_eight
