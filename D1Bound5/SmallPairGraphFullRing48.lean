import D1Bound5.SmallPairGraphData48

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Complete large-extension triangle exclusion for pair-table row 48. -/
theorem smallPairGraph_48_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 8 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 8)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_48 smallPairB_48 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_48) (hneB : ∀ i, t i ≠ smallPairB_48) : False := by
  have hpos : 0 < discriminant 1 8 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_48*smallPairB_48+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_48 smallPairB_48
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_8 smallPairClosure_48 smallPairLarge_48
    smallPairSieve_1_8 smallPairSieve_1_8_valid ?_
    smallPairSeeds_48_checked smallPairClosure_48_checked smallPairFilter_48_checked
    smallPairNoTriangle_48_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_8_eq, List.mem_toFinset] at hq
  exact hq

end D1Bound5
