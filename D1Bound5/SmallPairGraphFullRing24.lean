import D1Bound5.SmallPairGraphData24

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Complete large-extension triangle exclusion for pair-table row 24. -/
theorem smallPairGraph_24_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_24 smallPairB_24 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_24) (hneB : ∀ i, t i ≠ smallPairB_24) : False := by
  have hpos : 0 < discriminant 1 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_24*smallPairB_24+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_24 smallPairB_24
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_1 smallPairClosure_24 smallPairLarge_24
    smallPairSieve_1_1 smallPairSieve_1_1_valid ?_
    smallPairSeeds_24_checked smallPairClosure_24_checked smallPairFilter_24_checked
    smallPairNoTriangle_24_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_1_eq, List.mem_toFinset] at hq
  exact hq

end D1Bound5
