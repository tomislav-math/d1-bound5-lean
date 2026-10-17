import D1Bound5.PairExtensionComplete
import D1Bound5.SmallTripleExtensionData1
import D1Bound5.SmallTripleExtensionData2
import D1Bound5.SmallTripleExtensionData3
import D1Bound5.SmallTripleExtensionData4
import D1Bound5.SmallTripleExtensionData5
import D1Bound5.SmallTripleExtensionData6
import D1Bound5.SmallTripleExtensionData7
import D1Bound5.SmallTripleExtensionData8
import D1Bound5.SmallTripleExtensionData9
import D1Bound5.SmallTripleExtensionData10

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Complete radius-10^40 extension list for manuscript row 1. -/
theorem smallTripleExtension_1_complete_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (z : QuadInt 0 1)
    (hpair : PairExtension smallTripleAnchorA_1 smallTripleAnchorB_1 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_1*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_1)
    (hb : z ≠ smallTripleAnchorB_1) (hc : z ≠ smallTripleAnchorC_1)
    (hNz : z.norm ≤ 10^80) :
    z ∈ smallTripleAllowed_1 := by
  have hpos : 0 < discriminant 0 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallTripleAnchorA_1*smallTripleAnchorB_1+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  have hmem : z ∈ smallTriplePairClosure_1 := by
    apply pairClosure_complete_full_ring hK phi hpos e smallTripleAnchorA_1 smallTripleAnchorB_1
      (by decide) (by decide) (by decide) hroot (by decide) (by decide)
      (10^80) smallTriplePairClosure_1 ?_ ?_ z hpair hNz
    · intro x hx hNx
      apply pairSeedsCovered_of_checked hpos smallTripleAnchorA_1 smallTripleAnchorB_1
        (by decide) (by decide) seedRootDisk_0_1 smallTriplePairClosure_1
        ?_ smallTripleSeeds_1_checked x hx hNx
      intro q hq
      rw [seedRootDisk_0_1_eq, List.mem_toFinset] at hq
      exact hq
    · intro x hx w hw hNw
      exact pairClosure_of_checked smallTripleAnchorA_1 smallTripleAnchorB_1 (10^80)
        smallTriplePairClosure_1 smallTripleClosure_1_checked hx hw hNw
  exact tripleExtensionFilter_of_checked hpos smallTripleAnchorA_1 smallTripleAnchorB_1 smallTripleAnchorC_1
    smallTriplePairClosure_1 smallTripleAllowed_1 smallTripleFilter_1_checked
    hmem hz ha hb hc hthird

/-- Complete radius-10^40 extension list for manuscript row 2. -/
theorem smallTripleExtension_2_complete_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (z : QuadInt 0 1)
    (hpair : PairExtension smallTripleAnchorA_2 smallTripleAnchorB_2 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_2*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_2)
    (hb : z ≠ smallTripleAnchorB_2) (hc : z ≠ smallTripleAnchorC_2)
    (hNz : z.norm ≤ 10^80) :
    z ∈ smallTripleAllowed_2 := by
  have hpos : 0 < discriminant 0 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallTripleAnchorA_2*smallTripleAnchorB_2+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  have hmem : z ∈ smallTriplePairClosure_2 := by
    apply pairClosure_complete_full_ring hK phi hpos e smallTripleAnchorA_2 smallTripleAnchorB_2
      (by decide) (by decide) (by decide) hroot (by decide) (by decide)
      (10^80) smallTriplePairClosure_2 ?_ ?_ z hpair hNz
    · intro x hx hNx
      apply pairSeedsCovered_of_checked hpos smallTripleAnchorA_2 smallTripleAnchorB_2
        (by decide) (by decide) seedRootDisk_0_1 smallTriplePairClosure_2
        ?_ smallTripleSeeds_2_checked x hx hNx
      intro q hq
      rw [seedRootDisk_0_1_eq, List.mem_toFinset] at hq
      exact hq
    · intro x hx w hw hNw
      exact pairClosure_of_checked smallTripleAnchorA_2 smallTripleAnchorB_2 (10^80)
        smallTriplePairClosure_2 smallTripleClosure_2_checked hx hw hNw
  exact tripleExtensionFilter_of_checked hpos smallTripleAnchorA_2 smallTripleAnchorB_2 smallTripleAnchorC_2
    smallTriplePairClosure_2 smallTripleAllowed_2 smallTripleFilter_2_checked
    hmem hz ha hb hc hthird

/-- Complete radius-10^40 extension list for manuscript row 3. -/
theorem smallTripleExtension_3_complete_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (z : QuadInt 0 1)
    (hpair : PairExtension smallTripleAnchorA_3 smallTripleAnchorB_3 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_3*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_3)
    (hb : z ≠ smallTripleAnchorB_3) (hc : z ≠ smallTripleAnchorC_3)
    (hNz : z.norm ≤ 10^80) :
    z ∈ smallTripleAllowed_3 := by
  have hpos : 0 < discriminant 0 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallTripleAnchorA_3*smallTripleAnchorB_3+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  have hmem : z ∈ smallTriplePairClosure_3 := by
    apply pairClosure_complete_full_ring hK phi hpos e smallTripleAnchorA_3 smallTripleAnchorB_3
      (by decide) (by decide) (by decide) hroot (by decide) (by decide)
      (10^80) smallTriplePairClosure_3 ?_ ?_ z hpair hNz
    · intro x hx hNx
      apply pairSeedsCovered_of_checked hpos smallTripleAnchorA_3 smallTripleAnchorB_3
        (by decide) (by decide) seedRootDisk_0_1 smallTriplePairClosure_3
        ?_ smallTripleSeeds_3_checked x hx hNx
      intro q hq
      rw [seedRootDisk_0_1_eq, List.mem_toFinset] at hq
      exact hq
    · intro x hx w hw hNw
      exact pairClosure_of_checked smallTripleAnchorA_3 smallTripleAnchorB_3 (10^80)
        smallTriplePairClosure_3 smallTripleClosure_3_checked hx hw hNw
  exact tripleExtensionFilter_of_checked hpos smallTripleAnchorA_3 smallTripleAnchorB_3 smallTripleAnchorC_3
    smallTriplePairClosure_3 smallTripleAllowed_3 smallTripleFilter_3_checked
    hmem hz ha hb hc hthird

/-- Complete radius-10^40 extension list for manuscript row 4. -/
theorem smallTripleExtension_4_complete_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (z : QuadInt 0 1)
    (hpair : PairExtension smallTripleAnchorA_4 smallTripleAnchorB_4 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_4*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_4)
    (hb : z ≠ smallTripleAnchorB_4) (hc : z ≠ smallTripleAnchorC_4)
    (hNz : z.norm ≤ 10^80) :
    z ∈ smallTripleAllowed_4 := by
  have hpos : 0 < discriminant 0 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallTripleAnchorA_4*smallTripleAnchorB_4+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  have hmem : z ∈ smallTriplePairClosure_4 := by
    apply pairClosure_complete_full_ring hK phi hpos e smallTripleAnchorA_4 smallTripleAnchorB_4
      (by decide) (by decide) (by decide) hroot (by decide) (by decide)
      (10^80) smallTriplePairClosure_4 ?_ ?_ z hpair hNz
    · intro x hx hNx
      apply pairSeedsCovered_of_checked hpos smallTripleAnchorA_4 smallTripleAnchorB_4
        (by decide) (by decide) seedRootDisk_0_1 smallTriplePairClosure_4
        ?_ smallTripleSeeds_4_checked x hx hNx
      intro q hq
      rw [seedRootDisk_0_1_eq, List.mem_toFinset] at hq
      exact hq
    · intro x hx w hw hNw
      exact pairClosure_of_checked smallTripleAnchorA_4 smallTripleAnchorB_4 (10^80)
        smallTriplePairClosure_4 smallTripleClosure_4_checked hx hw hNw
  exact tripleExtensionFilter_of_checked hpos smallTripleAnchorA_4 smallTripleAnchorB_4 smallTripleAnchorC_4
    smallTriplePairClosure_4 smallTripleAllowed_4 smallTripleFilter_4_checked
    hmem hz ha hb hc hthird

/-- Complete radius-10^40 extension list for manuscript row 5. -/
theorem smallTripleExtension_5_complete_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K) (z : QuadInt 0 2)
    (hpair : PairExtension smallTripleAnchorA_5 smallTripleAnchorB_5 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_5*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_5)
    (hb : z ≠ smallTripleAnchorB_5) (hc : z ≠ smallTripleAnchorC_5)
    (hNz : z.norm ≤ 10^80) :
    z ∈ smallTripleAllowed_5 := by
  have hpos : 0 < discriminant 0 2 := by decide
  have hroot : ∃ r0, r0*r0 = smallTripleAnchorA_5*smallTripleAnchorB_5+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  have hmem : z ∈ smallTriplePairClosure_5 := by
    apply pairClosure_complete_full_ring hK phi hpos e smallTripleAnchorA_5 smallTripleAnchorB_5
      (by decide) (by decide) (by decide) hroot (by decide) (by decide)
      (10^80) smallTriplePairClosure_5 ?_ ?_ z hpair hNz
    · intro x hx hNx
      apply pairSeedsCovered_of_checked hpos smallTripleAnchorA_5 smallTripleAnchorB_5
        (by decide) (by decide) seedRootDisk_0_2 smallTriplePairClosure_5
        ?_ smallTripleSeeds_5_checked x hx hNx
      intro q hq
      rw [seedRootDisk_0_2_eq, List.mem_toFinset] at hq
      exact hq
    · intro x hx w hw hNw
      exact pairClosure_of_checked smallTripleAnchorA_5 smallTripleAnchorB_5 (10^80)
        smallTriplePairClosure_5 smallTripleClosure_5_checked hx hw hNw
  exact tripleExtensionFilter_of_checked hpos smallTripleAnchorA_5 smallTripleAnchorB_5 smallTripleAnchorC_5
    smallTriplePairClosure_5 smallTripleAllowed_5 smallTripleFilter_5_checked
    hmem hz ha hb hc hthird

/-- Complete radius-10^40 extension list for manuscript row 6. -/
theorem smallTripleExtension_6_complete_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (z : QuadInt 1 1)
    (hpair : PairExtension smallTripleAnchorA_6 smallTripleAnchorB_6 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_6*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_6)
    (hb : z ≠ smallTripleAnchorB_6) (hc : z ≠ smallTripleAnchorC_6)
    (hNz : z.norm ≤ 10^80) :
    z ∈ smallTripleAllowed_6 := by
  have hpos : 0 < discriminant 1 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallTripleAnchorA_6*smallTripleAnchorB_6+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  have hmem : z ∈ smallTriplePairClosure_6 := by
    apply pairClosure_complete_full_ring hK phi hpos e smallTripleAnchorA_6 smallTripleAnchorB_6
      (by decide) (by decide) (by decide) hroot (by decide) (by decide)
      (10^80) smallTriplePairClosure_6 ?_ ?_ z hpair hNz
    · intro x hx hNx
      apply pairSeedsCovered_of_checked hpos smallTripleAnchorA_6 smallTripleAnchorB_6
        (by decide) (by decide) seedRootDisk_1_1 smallTriplePairClosure_6
        ?_ smallTripleSeeds_6_checked x hx hNx
      intro q hq
      rw [seedRootDisk_1_1_eq, List.mem_toFinset] at hq
      exact hq
    · intro x hx w hw hNw
      exact pairClosure_of_checked smallTripleAnchorA_6 smallTripleAnchorB_6 (10^80)
        smallTriplePairClosure_6 smallTripleClosure_6_checked hx hw hNw
  exact tripleExtensionFilter_of_checked hpos smallTripleAnchorA_6 smallTripleAnchorB_6 smallTripleAnchorC_6
    smallTriplePairClosure_6 smallTripleAllowed_6 smallTripleFilter_6_checked
    hmem hz ha hb hc hthird

/-- Complete radius-10^40 extension list for manuscript row 7. -/
theorem smallTripleExtension_7_complete_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (z : QuadInt 1 1)
    (hpair : PairExtension smallTripleAnchorA_7 smallTripleAnchorB_7 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_7*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_7)
    (hb : z ≠ smallTripleAnchorB_7) (hc : z ≠ smallTripleAnchorC_7)
    (hNz : z.norm ≤ 10^80) :
    z ∈ smallTripleAllowed_7 := by
  have hpos : 0 < discriminant 1 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallTripleAnchorA_7*smallTripleAnchorB_7+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  have hmem : z ∈ smallTriplePairClosure_7 := by
    apply pairClosure_complete_full_ring hK phi hpos e smallTripleAnchorA_7 smallTripleAnchorB_7
      (by decide) (by decide) (by decide) hroot (by decide) (by decide)
      (10^80) smallTriplePairClosure_7 ?_ ?_ z hpair hNz
    · intro x hx hNx
      apply pairSeedsCovered_of_checked hpos smallTripleAnchorA_7 smallTripleAnchorB_7
        (by decide) (by decide) seedRootDisk_1_1 smallTriplePairClosure_7
        ?_ smallTripleSeeds_7_checked x hx hNx
      intro q hq
      rw [seedRootDisk_1_1_eq, List.mem_toFinset] at hq
      exact hq
    · intro x hx w hw hNw
      exact pairClosure_of_checked smallTripleAnchorA_7 smallTripleAnchorB_7 (10^80)
        smallTriplePairClosure_7 smallTripleClosure_7_checked hx hw hNw
  exact tripleExtensionFilter_of_checked hpos smallTripleAnchorA_7 smallTripleAnchorB_7 smallTripleAnchorC_7
    smallTriplePairClosure_7 smallTripleAllowed_7 smallTripleFilter_7_checked
    hmem hz ha hb hc hthird

/-- Complete radius-10^40 extension list for manuscript row 8. -/
theorem smallTripleExtension_8_complete_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (z : QuadInt 1 1)
    (hpair : PairExtension smallTripleAnchorA_8 smallTripleAnchorB_8 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_8*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_8)
    (hb : z ≠ smallTripleAnchorB_8) (hc : z ≠ smallTripleAnchorC_8)
    (hNz : z.norm ≤ 10^80) :
    z ∈ smallTripleAllowed_8 := by
  have hpos : 0 < discriminant 1 1 := by decide
  have hroot : ∃ r0, r0*r0 = smallTripleAnchorA_8*smallTripleAnchorB_8+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  have hmem : z ∈ smallTriplePairClosure_8 := by
    apply pairClosure_complete_full_ring hK phi hpos e smallTripleAnchorA_8 smallTripleAnchorB_8
      (by decide) (by decide) (by decide) hroot (by decide) (by decide)
      (10^80) smallTriplePairClosure_8 ?_ ?_ z hpair hNz
    · intro x hx hNx
      apply pairSeedsCovered_of_checked hpos smallTripleAnchorA_8 smallTripleAnchorB_8
        (by decide) (by decide) seedRootDisk_1_1 smallTriplePairClosure_8
        ?_ smallTripleSeeds_8_checked x hx hNx
      intro q hq
      rw [seedRootDisk_1_1_eq, List.mem_toFinset] at hq
      exact hq
    · intro x hx w hw hNw
      exact pairClosure_of_checked smallTripleAnchorA_8 smallTripleAnchorB_8 (10^80)
        smallTriplePairClosure_8 smallTripleClosure_8_checked hx hw hNw
  exact tripleExtensionFilter_of_checked hpos smallTripleAnchorA_8 smallTripleAnchorB_8 smallTripleAnchorC_8
    smallTriplePairClosure_8 smallTripleAllowed_8 smallTripleFilter_8_checked
    hmem hz ha hb hc hthird

/-- Complete radius-10^40 extension list for manuscript row 9. -/
theorem smallTripleExtension_9_complete_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (z : QuadInt 1 2)
    (hpair : PairExtension smallTripleAnchorA_9 smallTripleAnchorB_9 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_9*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_9)
    (hb : z ≠ smallTripleAnchorB_9) (hc : z ≠ smallTripleAnchorC_9)
    (hNz : z.norm ≤ 10^80) :
    z ∈ smallTripleAllowed_9 := by
  have hpos : 0 < discriminant 1 2 := by decide
  have hroot : ∃ r0, r0*r0 = smallTripleAnchorA_9*smallTripleAnchorB_9+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  have hmem : z ∈ smallTriplePairClosure_9 := by
    apply pairClosure_complete_full_ring hK phi hpos e smallTripleAnchorA_9 smallTripleAnchorB_9
      (by decide) (by decide) (by decide) hroot (by decide) (by decide)
      (10^80) smallTriplePairClosure_9 ?_ ?_ z hpair hNz
    · intro x hx hNx
      apply pairSeedsCovered_of_checked hpos smallTripleAnchorA_9 smallTripleAnchorB_9
        (by decide) (by decide) seedRootDisk_1_2 smallTriplePairClosure_9
        ?_ smallTripleSeeds_9_checked x hx hNx
      intro q hq
      rw [seedRootDisk_1_2_eq, List.mem_toFinset] at hq
      exact hq
    · intro x hx w hw hNw
      exact pairClosure_of_checked smallTripleAnchorA_9 smallTripleAnchorB_9 (10^80)
        smallTriplePairClosure_9 smallTripleClosure_9_checked hx hw hNw
  exact tripleExtensionFilter_of_checked hpos smallTripleAnchorA_9 smallTripleAnchorB_9 smallTripleAnchorC_9
    smallTriplePairClosure_9 smallTripleAllowed_9 smallTripleFilter_9_checked
    hmem hz ha hb hc hthird

/-- Complete radius-10^40 extension list for manuscript row 10. -/
theorem smallTripleExtension_10_complete_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (z : QuadInt 1 2)
    (hpair : PairExtension smallTripleAnchorA_10 smallTripleAnchorB_10 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_10*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_10)
    (hb : z ≠ smallTripleAnchorB_10) (hc : z ≠ smallTripleAnchorC_10)
    (hNz : z.norm ≤ 10^80) :
    z ∈ smallTripleAllowed_10 := by
  have hpos : 0 < discriminant 1 2 := by decide
  have hroot : ∃ r0, r0*r0 = smallTripleAnchorA_10*smallTripleAnchorB_10+1 :=
    (hasSquareRoot_iff hpos _).1 (by decide +kernel)
  have hmem : z ∈ smallTriplePairClosure_10 := by
    apply pairClosure_complete_full_ring hK phi hpos e smallTripleAnchorA_10 smallTripleAnchorB_10
      (by decide) (by decide) (by decide) hroot (by decide) (by decide)
      (10^80) smallTriplePairClosure_10 ?_ ?_ z hpair hNz
    · intro x hx hNx
      apply pairSeedsCovered_of_checked hpos smallTripleAnchorA_10 smallTripleAnchorB_10
        (by decide) (by decide) seedRootDisk_1_2 smallTriplePairClosure_10
        ?_ smallTripleSeeds_10_checked x hx hNx
      intro q hq
      rw [seedRootDisk_1_2_eq, List.mem_toFinset] at hq
      exact hq
    · intro x hx w hw hNw
      exact pairClosure_of_checked smallTripleAnchorA_10 smallTripleAnchorB_10 (10^80)
        smallTriplePairClosure_10 smallTripleClosure_10_checked hx hw hNw
  exact tripleExtensionFilter_of_checked hpos smallTripleAnchorA_10 smallTripleAnchorB_10 smallTripleAnchorC_10
    smallTriplePairClosure_10 smallTripleAllowed_10 smallTripleFilter_10_checked
    hmem hz ha hb hc hthird

end D1Bound5
