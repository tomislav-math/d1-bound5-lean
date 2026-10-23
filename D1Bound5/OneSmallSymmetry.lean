import D1Bound5.FirstPairClassification
import D1Bound5.OneSmallRows
import D1Bound5.SmallExtensionSymmetry

namespace D1Bound5
open QuadInt

def firstPairRowA (tau nu : ℤ) (row : (ℤ × ℤ) × (ℤ × ℤ)) : QuadInt tau nu :=
  ⟨row.1.1,row.1.2⟩

def firstPairRowB (tau nu : ℤ) (row : (ℤ × ℤ) × (ℤ × ℤ)) : QuadInt tau nu :=
  ⟨row.2.1,row.2.2⟩

theorem firstPairCoordinates_eq {tau nu : ℤ} (a b a' b' : QuadInt tau nu)
    (h : firstPairCoordinates a b = firstPairCoordinates a' b') : a = a' ∧ b = b' := by
  constructor
  · apply QuadraticAlgebra.ext
    · exact congrArg (fun p => p.1.1) h
    · exact congrArg (fun p => p.1.2) h
  · apply QuadraticAlgebra.ext
    · exact congrArg (fun p => p.2.1) h
    · exact congrArg (fun p => p.2.2) h

/-- The ordered coordinate orbit admits actual involutive normalization. -/
theorem firstPairOrbit_normalize {tau nu : ℤ}
    (a b : QuadInt tau nu) (row : (ℤ × ℤ) × (ℤ × ℤ))
    (horbit : firstPairCoordinates a b ∈ firstPairOrbit tau row) :
    ∃ sgn conj : Bool,
      smallExtensionSymmetry sgn conj a = firstPairRowA tau nu row ∧
      smallExtensionSymmetry sgn conj b = firstPairRowB tau nu row := by
  have hdecode (sgn conj : Bool)
      (h : firstPairCoordinates a b = firstPairCoordinates
        (smallExtensionSymmetry sgn conj (firstPairRowA tau nu row))
        (smallExtensionSymmetry sgn conj (firstPairRowB tau nu row))) :
      smallExtensionSymmetry sgn conj a = firstPairRowA tau nu row ∧
      smallExtensionSymmetry sgn conj b = firstPairRowB tau nu row := by
    obtain ⟨ha,hb⟩ := firstPairCoordinates_eq _ _ _ _ h
    constructor
    · rw [ha]
      exact smallExtensionSymmetry_involutive sgn conj _
    · rw [hb]
      exact smallExtensionSymmetry_involutive sgn conj _
  simp only [firstPairOrbit, Finset.mem_insert, Finset.mem_singleton] at horbit
  rcases horbit with h | h | h | h
  · refine ⟨false,false,hdecode false false ?_⟩
    simpa [firstPairCoordinates,firstPairRowA,firstPairRowB,smallExtensionSymmetry] using h
  · refine ⟨true,false,hdecode true false ?_⟩
    simpa [firstPairCoordinates,firstPairRowA,firstPairRowB,smallExtensionSymmetry] using h
  · refine ⟨false,true,hdecode false true ?_⟩
    simpa [firstPairCoordinates,firstPairRowA,firstPairRowB,smallExtensionSymmetry] using h
  · refine ⟨true,true,hdecode true true ?_⟩
    simpa [firstPairCoordinates,firstPairRowA,firstPairRowB,smallExtensionSymmetry,
      neg_add_rev, sub_eq_add_neg, add_comm] using h

theorem oneSmallSymmetry_square {tau nu : ℤ} (sgn conj : Bool)
    (a z : QuadInt tau nu) (h : ∃ r : QuadInt tau nu, r*r = a*z+1) :
    ∃ r : QuadInt tau nu, r*r =
      smallExtensionSymmetry sgn conj a*smallExtensionSymmetry sgn conj z+1 := by
  obtain ⟨r,hr⟩ := h
  have hs : star r*star r = star a*star z+1 := by
    simpa only [star_mul,star_add,star_one,mul_comm] using congrArg star hr
  cases sgn <;> cases conj
  · exact ⟨r,hr⟩
  · exact ⟨star r,hs⟩
  · exact ⟨r,by simpa [smallExtensionSymmetry] using hr⟩
  · exact ⟨star r,by simpa [smallExtensionSymmetry] using hs⟩

def OneSmallNormalizedThirdRows {tau nu : ℤ} (a b s : QuadInt tau nu) : Prop :=
  ∃ sgn conj : Bool,
    let F := smallExtensionSymmetry (tau := tau) (nu := nu) sgn conj
    (F a = 1 ∧ F b = -3 ∧ F s = 3) ∨
      ∃ cutoff, OneSmallRowMembership (F a) (F b) (F s) cutoff

/-- The fixed pair representatives classify third entries after one common
normalization, preserving all equal-modulus cases and all square conditions. -/
theorem oneSmallThirdRows_of_table_orbits {tau nu : ℤ}
    (table : List ((ℤ × ℤ) × (ℤ × ℤ)))
    (reps : Finset ((ℤ × ℤ) × (ℤ × ℤ)))
    (horbits : table.toFinset = reps.biUnion (firstPairOrbit tau))
    (hreps : ∀ row ∈ reps,
      OneSmallThirdRowProperty (firstPairRowA tau nu row) (firstPairRowB tau nu row))
    (a b s : QuadInt tau nu) (hrow : firstPairCoordinates a b ∈ table)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  have hmem : firstPairCoordinates a b ∈ reps.biUnion (firstPairOrbit tau) := by
    rw [← horbits]
    exact List.mem_toFinset.mpr hrow
  obtain ⟨rep,hrep,horbit⟩ := Finset.mem_biUnion.mp hmem
  obtain ⟨sgn,conj,heA,heB⟩ := firstPairOrbit_normalize a b rep horbit
  let F := smallExtensionSymmetry (tau := tau) (nu := nu) sgn conj
  have hF : Function.Involutive F := smallExtensionSymmetry_involutive sgn conj
  have hnorm (z : QuadInt tau nu) : (F z).norm = z.norm := smallExtensionSymmetry_norm sgn conj z
  have hsbound : (F s).norm ≤ 224 := by simpa only [hnorm] using hbound
  have hsorder : (firstPairRowB tau nu rep).norm ≤ (F s).norm := by
    rw [← heB]
    simpa only [F,smallExtensionSymmetry_norm] using horder
  have hsA : F s ≠ firstPairRowA tau nu rep := by
    rw [← heA]
    exact fun h => ha (hF.injective h)
  have hsB : F s ≠ firstPairRowB tau nu rep := by
    rw [← heB]
    exact fun h => hb (hF.injective h)
  have hsPair : PairExtension (firstPairRowA tau nu rep) (firstPairRowB tau nu rep) (F s) := by
    constructor
    · simpa only [heA] using oneSmallSymmetry_square sgn conj a s hpair.1
    · simpa only [heB] using oneSmallSymmetry_square sgn conj b s hpair.2
  have h := hreps rep hrep (F s) hsbound hsorder hsA hsB hsPair
  refine ⟨sgn,conj,?_⟩
  simpa only [heA,heB] using h

end D1Bound5
