import D1Bound5.SmallPairGraphData8

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Complete large-extension triangle exclusion for pair-table row 8. -/
theorem smallPairGraph_8_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 0 1)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_8 smallPairB_8 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_8) (hneB : ∀ i, t i ≠ smallPairB_8) : False := by
  have hpos : 0 < discriminant 0 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_8*smallPairB_8+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_8 smallPairB_8
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_0_1 smallPairClosure_8 smallPairLarge_8
    smallPairSieve_0_1 smallPairSieve_0_1_valid ?_
    smallPairSeeds_8_checked smallPairClosure_8_checked smallPairFilter_8_checked
    smallPairNoTriangle_8_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_0_1_eq, List.mem_toFinset] at hq
  exact hq

end D1Bound5
