import D1Bound5.SmallPairGraphData13

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Complete large-extension triangle exclusion for pair-table row 13. -/
theorem smallPairGraph_13_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 2)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_13 smallPairB_13 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_13) (hneB : ∀ i, t i ≠ smallPairB_13) : False := by
  have hpos : 0 < discriminant 0 2 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_13*smallPairB_13+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_13 smallPairB_13
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_2 smallPairClosure_13 smallPairLarge_13
    smallPairSieve_0_2 smallPairSieve_0_2_valid ?_
    smallPairSeeds_13_checked smallPairClosure_13_checked smallPairFilter_13_checked
    smallPairNoTriangle_13_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_2_eq, List.mem_toFinset] at hq
  exact hq

end D1Bound5
