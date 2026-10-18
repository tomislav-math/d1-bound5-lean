import D1Bound5.SmallExtensionSymmetry
import D1Bound5.SmallPairClassification

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- No compatible triple of distinct proper common extensions lies in the
closed annulus with radii 3 and 10^550. -/
def SmallPairGraphProperty {tau nu : ℤ}
    (A : Finset (QuadInt tau nu)) : Prop :=
  ∀ t : Fin 3 → QuadInt tau nu, IsD1Tuple t →
    (∀ i, ProperCommonExtension A (t i)) →
    (∀ i, 9 ≤ (t i).norm) → (∀ i, (t i).norm ≤ 10^1100) → False

private theorem smallPairSymmetry_square {tau nu : ℤ} (sgn conj : Bool)
    (a z : QuadInt tau nu) (h : ∃ r : QuadInt tau nu, r*r = a*z+1) :
    ∃ r : QuadInt tau nu, r*r =
      smallExtensionSymmetry sgn conj a*smallExtensionSymmetry sgn conj z+1 := by
  obtain ⟨r, hr⟩ := h
  have hstar : star r*star r = star a*star z+1 := by
    simpa only [star_mul, star_add, star_one, mul_comm] using congrArg star hr
  cases sgn <;> cases conj
  · exact ⟨r, hr⟩
  · exact ⟨star r, hstar⟩
  · exact ⟨r, by simpa [smallExtensionSymmetry] using hr⟩
  · exact ⟨star r, by simpa [smallExtensionSymmetry] using hstar⟩

/-- The entire triangle exclusion, including all three compatibility edges,
transports through each simultaneous sign/conjugation symmetry. -/
theorem SmallPairGraphProperty.symmetry {tau nu : ℤ}
    (A : Finset (QuadInt tau nu)) (hA : SmallPairGraphProperty A)
    (sgn conj : Bool) :
    SmallPairGraphProperty (A.image (smallExtensionSymmetry sgn conj)) := by
  let F := smallExtensionSymmetry (tau := tau) (nu := nu) sgn conj
  have hF : Function.Involutive F := smallExtensionSymmetry_involutive sgn conj
  have hzero : F 0 = 0 := smallExtensionSymmetry_zero sgn conj
  intro t ht hproper hlarge hbound
  have hFt : IsD1Tuple (fun i => F (t i)) := by
    refine ⟨hF.injective.comp ht.1, ?_, ?_⟩
    · intro i hi
      apply ht.2.1 i
      apply hF.injective
      simpa only [hzero] using hi
    · intro i j hij
      exact smallPairSymmetry_square sgn conj _ _ (ht.2.2 i j hij)
  have hback (i : Fin 3) : ProperCommonExtension A (F (t i)) := by
    refine ⟨hFt.2.1 i, ?_, ?_⟩
    · intro hmem
      apply (hproper i).2.1
      exact Finset.mem_image.mpr ⟨F (t i), hmem, hF (t i)⟩
    · intro a ha
      have hs := (hproper i).2.2 (F a) (Finset.mem_image.mpr ⟨a, ha, rfl⟩)
      have h := smallPairSymmetry_square sgn conj (F a) (t i) hs
      simpa only [show smallExtensionSymmetry sgn conj (F a) = a from hF a] using h
  apply hA (fun i => F (t i)) hFt hback
  · intro i
    simpa only [F, smallExtensionSymmetry_norm] using hlarge i
  · intro i
    simpa only [F, smallExtensionSymmetry_norm] using hbound i

theorem smallCoordinateSet_pair {tau nu : ℤ} (a b : QuadInt tau nu) :
    smallCoordinateSet tau nu (pairCoordinates a b) = {a,b} := by
  simp [smallCoordinateSet, pairCoordinates]

theorem smallPairGraphProperty_of_orbit {tau nu : ℤ}
    (row row' : Finset (ℤ × ℤ))
    (hrow : SmallPairGraphProperty (smallCoordinateSet tau nu row))
    (horbit : row' ∈ smallTripleOrbit tau row) :
    SmallPairGraphProperty (smallCoordinateSet tau nu row') := by
  have himage (sgn conj : Bool) (g : ℤ × ℤ → ℤ × ℤ)
      (hg : ∀ p, (⟨(g p).1, (g p).2⟩ : QuadInt tau nu) =
        smallExtensionSymmetry sgn conj ⟨p.1,p.2⟩) :
      smallCoordinateSet tau nu (row.image g) =
        (smallCoordinateSet tau nu row).image (smallExtensionSymmetry sgn conj) := by
    unfold smallCoordinateSet
    rw [Finset.image_image, Finset.image_image]
    apply Finset.image_congr
    intro p _
    exact hg p
  simp only [smallTripleOrbit, Finset.mem_insert, Finset.mem_singleton] at horbit
  rcases horbit with rfl | rfl | rfl | rfl
  · exact hrow
  · rw [himage true false (fun p => (-p.1,-p.2)) (by
      intro p; apply QuadraticAlgebra.ext <;> simp [smallExtensionSymmetry])]
    exact SmallPairGraphProperty.symmetry _ hrow true false
  · rw [himage false true (fun p => (p.1+tau*p.2,-p.2)) (by
      intro p; apply QuadraticAlgebra.ext <;> simp [smallExtensionSymmetry])]
    exact SmallPairGraphProperty.symmetry _ hrow false true
  · rw [himage true true (fun p => (-p.1-tau*p.2,p.2)) (by
      intro p; apply QuadraticAlgebra.ext <;> simp [smallExtensionSymmetry] <;> ring)]
    exact SmallPairGraphProperty.symmetry _ hrow true true

end D1Bound5
