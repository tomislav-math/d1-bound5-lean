import D1Bound5.SmallPairGraphData45

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Complete large-extension triangle exclusion for pair-table row 45. -/
theorem smallPairGraph_45_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 5 ≃+* 𝓞 K) (t : Fin 3 → QuadInt 1 5)
    (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension smallPairA_45 smallPairB_45 (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm) (hbound : ∀ i, (t i).norm ≤ 10^1100)
    (hneA : ∀ i, t i ≠ smallPairA_45) (hneB : ∀ i, t i ≠ smallPairB_45) : False := by
  have hpos : 0 < discriminant 1 5 := by decide
  have hroot : ∃ r0, r0*r0 = smallPairA_45*smallPairB_45+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  apply small_pair_graph_excludes_three_full_ring hK phi hpos e smallPairA_45 smallPairB_45
    (by decide) (by decide) (by decide) hroot (by decide) (by decide)
    (10^1100) seedRootDisk_1_5 smallPairClosure_45 smallPairLarge_45
    smallPairSieve_1_5 smallPairSieve_1_5_valid ?_
    smallPairSeeds_45_checked smallPairClosure_45_checked smallPairFilter_45_checked
    smallPairNoTriangle_45_checked t ht hpair hlarge hbound hneA hneB
  intro q hq
  rw [seedRootDisk_1_5_eq, List.mem_toFinset] at hq
  exact hq

end D1Bound5
