import D1Bound5.SmallTripleExtensions
import D1Bound5.SmallTripleClassification

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- A proper further common extension. Only the final extension is required
to be nonzero and outside the anchors; mutation intermediates are not. -/
def ProperCommonExtension {R : Type*} [CommRing R] [DecidableEq R]
    (A : Finset R) (z : R) : Prop :=
  z ≠ 0 ∧ z ∉ A ∧ ∀ a ∈ A, ∃ r : R, r*r = a*z+1

/-- The two facts extracted from the finite radius-10^40 certificates. -/
def SmallTripleExtensionProperty {tau nu : ℤ}
    (A : Finset (QuadInt tau nu)) : Prop :=
  (∀ z, ProperCommonExtension A z → z.norm ≤ 10^80 → z.norm < 85^2) ∧
  (∀ z w, ProperCommonExtension A z → ProperCommonExtension A w →
    z.norm ≤ 10^80 → w.norm ≤ 10^80 → z = w)

private theorem properCommonExtension_map
    {R : Type*} [CommRing R] [DecidableEq R]
    (F : R → R) (hF : Function.Injective F) (hzero : F 0 = 0)
    (hsquare : ∀ a z, (∃ r : R, r*r = a*z+1) →
      ∃ r : R, r*r = F a*F z+1)
    (A : Finset R) (z : R) (hz : ProperCommonExtension A z) :
    ProperCommonExtension (A.image F) (F z) := by
  refine ⟨?_, ?_, ?_⟩
  · intro h
    apply hz.1
    apply hF
    simpa only [hzero] using h
  · intro h
    obtain ⟨a, ha, he⟩ := Finset.mem_image.mp h
    have he' : a = z := hF he
    exact hz.2.1 (he' ▸ ha)
  · intro a ha
    obtain ⟨a', ha', rfl⟩ := Finset.mem_image.mp ha
    exact hsquare a' z (hz.2.2 a' ha')

/-- Proper common extensions transport through an actual ring equivalence. -/
theorem ProperCommonExtension.map_equiv
    {R S : Type*} [CommRing R] [CommRing S] [DecidableEq R] [DecidableEq S]
    (e : R ≃+* S) (A : Finset R) (z : R) (hz : ProperCommonExtension A z) :
    ProperCommonExtension (A.image e) (e z) := by
  refine ⟨?_, ?_, ?_⟩
  · intro h
    apply hz.1
    apply e.injective
    simpa only [map_zero] using h
  · intro h
    obtain ⟨a, ha, he⟩ := Finset.mem_image.mp h
    exact hz.2.1 ((e.injective he) ▸ ha)
  · intro a ha
    obtain ⟨a', ha', rfl⟩ := Finset.mem_image.mp ha
    obtain ⟨r, hr⟩ := hz.2.2 a' ha'
    exact ⟨e r, by simpa only [map_mul, map_add, map_one] using congrArg e hr⟩

/-- Simultaneous sign and coordinate conjugation, encoded independently. -/
def smallExtensionSymmetry {tau nu : ℤ} (sgn conj : Bool)
    (z : QuadInt tau nu) : QuadInt tau nu :=
  if sgn then -(if conj then star z else z) else (if conj then star z else z)

theorem smallExtensionSymmetry_involutive {tau nu : ℤ} (sgn conj : Bool) :
    Function.Involutive (smallExtensionSymmetry (tau := tau) (nu := nu) sgn conj) := by
  intro z
  cases sgn <;> cases conj <;> simp [smallExtensionSymmetry]

theorem smallExtensionSymmetry_zero {tau nu : ℤ} (sgn conj : Bool) :
    smallExtensionSymmetry (tau := tau) (nu := nu) sgn conj 0 = 0 := by
  cases sgn <;> cases conj <;> simp [smallExtensionSymmetry]

theorem smallExtensionSymmetry_norm {tau nu : ℤ} (sgn conj : Bool)
    (z : QuadInt tau nu) : (smallExtensionSymmetry sgn conj z).norm = z.norm := by
  cases sgn <;> cases conj <;>
    simp [smallExtensionSymmetry, QuadraticAlgebra.norm_neg, QuadraticAlgebra.norm_star]

private theorem smallExtensionSymmetry_square {tau nu : ℤ} (sgn conj : Bool)
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

/-- Proper extension uniqueness and the norm bound survive each of the four
simultaneous sign/conjugation symmetries. -/
theorem SmallTripleExtensionProperty.symmetry {tau nu : ℤ}
    (A : Finset (QuadInt tau nu)) (hA : SmallTripleExtensionProperty A)
    (sgn conj : Bool) :
    SmallTripleExtensionProperty (A.image (smallExtensionSymmetry sgn conj)) := by
  let F := smallExtensionSymmetry (tau := tau) (nu := nu) sgn conj
  have hF : Function.Involutive F := smallExtensionSymmetry_involutive sgn conj
  have hback (z : QuadInt tau nu) (hz : ProperCommonExtension (A.image F) z) :
      ProperCommonExtension A (F z) := by
    have h := properCommonExtension_map F hF.injective
      (smallExtensionSymmetry_zero sgn conj) (smallExtensionSymmetry_square sgn conj)
      (A.image F) z hz
    have himage : (A.image F).image F = A := by
      simp only [Finset.image_image, Function.comp_def, hF, Finset.image_id]
    rwa [himage] at h
  constructor
  · intro z hz hNz
    have hN : (F z).norm ≤ 10^80 := by
      simpa only [F, smallExtensionSymmetry_norm] using hNz
    have h := hA.1 (F z) (hback z hz) hN
    simpa only [F, smallExtensionSymmetry_norm] using h
  · intro z w hz hw hNz hNw
    apply hF.injective
    apply hA.2 (F z) (F w) (hback z hz) (hback w hw)
    · simpa only [F, smallExtensionSymmetry_norm] using hNz
    · simpa only [F, smallExtensionSymmetry_norm] using hNw

/-- Decode an unordered set of integer coordinate pairs into the ring. -/
def smallCoordinateSet (tau nu : ℤ) (row : Finset (ℤ × ℤ)) :
    Finset (QuadInt tau nu) := row.image (fun p => ⟨p.1, p.2⟩)

theorem smallCoordinateSet_triple {tau nu : ℤ} (a b c : QuadInt tau nu) :
    smallCoordinateSet tau nu (tripleCoordinates a b c) = {a,b,c} := by
  simp [smallCoordinateSet, tripleCoordinates]

/-- The explicit coordinate orbit in the finite classification is exactly
covered by the four proved norm-preserving extension symmetries. -/
theorem smallTripleExtensionProperty_of_orbit {tau nu : ℤ}
    (row row' : Finset (ℤ × ℤ))
    (hrow : SmallTripleExtensionProperty (smallCoordinateSet tau nu row))
    (horbit : row' ∈ smallTripleOrbit tau row) :
    SmallTripleExtensionProperty (smallCoordinateSet tau nu row') := by
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
    exact SmallTripleExtensionProperty.symmetry _ hrow true false
  · rw [himage false true (fun p => (p.1+tau*p.2,-p.2)) (by
      intro p; apply QuadraticAlgebra.ext <;> simp [smallExtensionSymmetry])]
    exact SmallTripleExtensionProperty.symmetry _ hrow false true
  · rw [himage true true (fun p => (-p.1-tau*p.2,p.2)) (by
      intro p; apply QuadraticAlgebra.ext <;> simp [smallExtensionSymmetry] <;> ring)]
    exact SmallTripleExtensionProperty.symmetry _ hrow true true

end D1Bound5
