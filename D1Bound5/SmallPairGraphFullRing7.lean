import D1Bound5.SmallPairGraphData7

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Complete large-extension triangle exclusion for pair-table row 7. -/
theorem smallPairGraph_7_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_7 smallPairB_7 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_7) (hneB : ∀ i, t i ≠ smallPairB_7) : False := by
  have hpos : 0 < discriminant 0 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_7*smallPairB_7+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_7 smallPairB_7
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_1 smallPairClosure_7 smallPairLarge_7
    smallPairSieve_0_1 smallPairSieve_0_1_valid ?_
    smallPairSeeds_7_checked smallPairClosure_7_checked smallPairFilter_7_checked
    smallPairNoTriangle_7_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_1_eq, List.mem_toFinset] at hq
  exact hq

end D1Bound5
