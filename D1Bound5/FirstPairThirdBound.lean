import D1Bound5.FirstPairGeometryNormalization

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Actual S<15 for every nonrational first pair in the complete finite
classification. Exact row selection and every analytic bound are internal. -/
theorem IsD1Tuple.first_pair_third_lt_fifteen_of_table
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (tau nu : ℤ) (e : QuadInt tau nu ≃+* 𝓞 K)
    (hmodel : (tau,nu) ∈ smallPairModels)
    (hrow : firstPairCoordinates (e.symm (a 0)) (e.symm (a 1)) ∈ firstPairTable tau nu) :
    ‖phi (a 2 : K)‖ < 15 := by
  obtain ⟨g,hg,hgt,hgn,sgn,conj,hcoords⟩ :=
    firstPairTable_geometry_normalize hmodel (e.symm (a 0)) (e.symm (a 1)) hrow
  obtain ⟨r,hr,hmatch⟩ := firstPairGeometryRows_have_fixed_row g hg
  have hrt : r.triple.tau=tau := hmatch.1.symm.trans hgt
  have hrn : r.triple.nu=nu := hmatch.2.1.symm.trans hgn
  subst hrt
  subst hrn
  have hpair : firstPairCoordinates
      (smallExtensionSymmetry sgn conj (e.symm (a 0)))
      (smallExtensionSymmetry sgn conj (e.symm (a 1))) =
        firstPairCoordinates r.triple.anchorA r.triple.anchorB := by
    rw [hcoords]
    simp only [firstPairCoordinates,OneSmallTripleRow.anchorA,OneSmallTripleRow.anchorB]
    exact Prod.ext hmatch.2.2.1 hmatch.2.2.2.1
  obtain ⟨h0,h1⟩ := firstPairCoordinates_eq _ _ _ _ hpair
  exact IsD1Tuple.first_pair_third_lt_fifteen_of_fixed hK phi a ha hmon
    g hg r hr hmatch e sgn conj h0 h1

end D1Bound5
