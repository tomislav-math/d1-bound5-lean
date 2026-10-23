import D1Bound5.SmallPairGraphData42

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Complete large-extension triangle exclusion for pair-table row 42. -/
theorem smallPairGraph_42_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 3 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 3)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_42 smallPairB_42 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_42) (hneB : ∀ i, t i ≠ smallPairB_42) : False := by
  have hpos : 0 < discriminant 1 3 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_42*smallPairB_42+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_42 smallPairB_42
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_3 smallPairClosure_42 smallPairLarge_42
    smallPairSieve_1_3 smallPairSieve_1_3_valid ?_
    smallPairSeeds_42_checked smallPairClosure_42_checked smallPairFilter_42_checked
    smallPairNoTriangle_42_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_3_eq, List.mem_toFinset] at hq
  exact hq

end D1Bound5
