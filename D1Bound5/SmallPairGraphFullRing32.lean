import D1Bound5.SmallPairGraphData32

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Complete large-extension triangle exclusion for pair-table row 32. -/
theorem smallPairGraph_32_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 6 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 6)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_32 smallPairB_32 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_32) (hneB : ∀ i, t i ≠ smallPairB_32) : False := by
  have hpos : 0 < discriminant 0 6 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_32*smallPairB_32+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_32 smallPairB_32
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_6 smallPairClosure_32 smallPairLarge_32
    smallPairSieve_0_6 smallPairSieve_0_6_valid ?_
    smallPairSeeds_32_checked smallPairClosure_32_checked smallPairFilter_32_checked
    smallPairNoTriangle_32_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_6_eq, List.mem_toFinset] at hq
  exact hq

end D1Bound5
