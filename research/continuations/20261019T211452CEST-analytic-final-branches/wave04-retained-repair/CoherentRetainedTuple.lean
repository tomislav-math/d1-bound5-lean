import D1Bound5.CoherentRetainedGap
import D1Bound5.FrontierLargeTuple
import D1Bound5.ProductFiveTupleGrowth

open Finset
open scoped NumberField
open Module

namespace D1Bound5

/-- The retained coefficient-400 growth estimate for an actual ordered
D(1) quintuple in the full ring of integers of an imaginary quadratic
field.  The two determinant growth inputs and the analytic form
hypotheses are all consequences of the tuple and its order. -/
theorem IsD1Tuple.all_large_retained_growth
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 5 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hA : 3 ≤ ‖phi (a 0 : K)‖) :
    400*(‖phi (a 0 : K)‖^7*‖phi (a 1 : K)‖^5*‖phi (a 2 : K)‖^3) <
      ‖phi (a 4 : K)‖ := by
  classical
  let b : Fin 4 → 𝓞 K := fun i => a (Fin.castAdd 1 i)
  have hcast : Function.Injective (Fin.castAdd 1 : Fin 4 → Fin 5) := by
    intro i j hij
    apply Fin.ext
    exact congrArg (fun k : Fin 5 => k.val) hij
  have hb : IsD1Tuple b := by
    refine ⟨ha.1.comp hcast, ?_, ?_⟩
    · intro i
      exact ha.2.1 (Fin.castAdd 1 i)
    · intro i j hij
      exact ha.2.2 (Fin.castAdd 1 i) (Fin.castAdd 1 j) (hcast.ne hij)
  have hbmon : Monotone (fun i => ‖phi (b i : K)‖) := by
    intro i j hij
    exact hmon hij
  have hfrontier := IsD1Tuple.frontier_large_growth hK phi b hb hbmon hA
  have hB : 3 ≤ ‖phi (a 1 : K)‖ :=
    hA.trans (hmon (by decide : (0 : Fin 5) ≤ 1))
  have hproduct :
      3*‖phi (a 0 : K)‖*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖*‖phi (a 3 : K)‖ <
        ‖phi (a 4 : K)‖ := by
    have hc0 : Fin.castAdd 1 (0 : Fin 4) = (0 : Fin 5) := by decide
    have hc1 : Fin.castAdd 1 (1 : Fin 4) = (1 : Fin 5) := by decide
    have hc2 : Fin.castAdd 1 (2 : Fin 4) = (2 : Fin 5) := by decide
    have hc3 : Fin.castAdd 1 (3 : Fin 4) = (3 : Fin 5) := by decide
    simpa only [Fin.prod_univ_four, hc0, hc1, hc2, hc3, mul_assoc] using
      (IsD1Tuple.productFive_growth hK phi a ha hmon hB)
  let Tup : Finset (𝓞 K) := Finset.univ.image a
  have hmem (i : Fin 5) : a i ∈ Tup :=
    Finset.mem_image.mpr ⟨i, Finset.mem_univ i, rfl⟩
  have hTup : IsD1 Tup := by
    constructor
    · intro x hx
      obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp hx
      exact ha.2.1 i
    · intro x hx y hy hxy
      obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp hx
      obtain ⟨j, _, rfl⟩ := Finset.mem_image.mp hy
      exact ha.2.2 i j (fun hij => hxy (congrArg a hij))
  exact full_ring_all_large_retained_monomial hK phi hTup a ha.1 hmem hA
    (hmon (by decide : (0 : Fin 5) ≤ 1))
    (hmon (by decide : (1 : Fin 5) ≤ 2)) hfrontier hproduct

end D1Bound5

#print axioms D1Bound5.IsD1Tuple.all_large_retained_growth
