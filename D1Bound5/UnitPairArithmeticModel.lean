import D1Bound5.UnitPairPellBounds
import D1Bound5.OneThreeNegative
import D1Bound5.UnitPairSymmetric

open scoped NumberField QuadraticAlgebra
open Module

namespace D1Bound5

/-- One fixed coordinate model carries all the arithmetic needed for the
unit-pair reduction. In particular the negative-square parameter is the
same parameter as the Pell equations. -/
structure UnitPairArithmeticModel (R : Type*) [CommRing R] where
  d : ℤ
  positive : 0 < d
  squarefree : Squarefree d
  w : R
  square : w * w = -(d : R)
  conjugate : R →+* R
  conjugate_w : conjugate w = -w
  negative_square : ∀ m : ℤ, m ≤ 0 → (∃ r : R, r*r = (m : R)) →
    ∃ y : ℤ, m = -d*y^2
  pell : ∀ z r s : R, z ≠ 0 → r*r = z+1 → s*s = 1-z →
    UnitPairPellDescription d w z

/-- Coordinate transport preserves all square witnesses, and the same
conjugation and field parameter are used for every element. -/
def UnitPairArithmeticModel.mapEquiv {R S : Type*} [CommRing R] [CommRing S]
    (M : UnitPairArithmeticModel R) (e : R ≃+* S) : UnitPairArithmeticModel S where
  d := M.d
  positive := M.positive
  squarefree := M.squarefree
  w := e M.w
  square := by simpa only [map_mul, map_neg, map_intCast] using congrArg e M.square
  conjugate := e.toRingHom.comp (M.conjugate.comp e.symm.toRingHom)
  conjugate_w := by simp [M.conjugate_w]
  negative_square := by
    intro m hm hs
    exact M.negative_square m hm (integer_square_under_ring_equiv e m hs)
  pell := by
    intro z r s hz hr hs
    have h := M.pell (e.symm z) (e.symm r) (e.symm s)
      (by simpa using hz)
      (by simpa only [map_mul, map_add, map_one] using congrArg e.symm hr)
      (by simpa only [map_mul, map_sub, map_one] using congrArg e.symm hs)
    have hmapped : UnitPairPellDescription M.d (e M.w) (e (e.symm z)) :=
      UnitPairPellDescription.map e.toRingHom M.d M.w (e.symm z) h
    simpa only [RingEquiv.apply_symm_apply] using hmapped

private def unitPairTraceZeroModel (d : ℤ) (hd : 0 < d) (hsq : Squarefree d) :
    UnitPairArithmeticModel (QuadInt 0 d) where
  d := d
  positive := hd
  squarefree := hsq
  w := QuadraticAlgebra.omega
  square := by ext <;> simp [QuadraticAlgebra.omega]
  conjugate := starRingEnd (QuadInt 0 d)
  conjugate_w := by ext <;> simp [starRingEnd_apply, QuadraticAlgebra.omega]
  negative_square := fun _ hm hs => nonpositive_integer_square_trace_zero hm hs
  pell := by
    intro z r s hz hr hs
    rcases QuadInt.unit_pair_integer_basis_pell hd z r s hz hr hs with h | h
    · exact Or.inl h
    · right
      obtain ⟨u,v,hv,hPell,hz⟩ := h
      refine ⟨u,v,hv,hPell,?_⟩
      rw [hz]
      ext <;> simp [QuadraticAlgebra.omega]

private def unitPairTraceOneModel (nu : ℤ)
    (hd : 0 < QuadInt.discriminant 1 nu) (hsq : Squarefree (4*nu-1)) :
    UnitPairArithmeticModel (QuadInt 1 nu) where
  d := 4*nu-1
  positive := by simpa [QuadInt.discriminant] using hd
  squarefree := hsq
  w := ⟨-1,2⟩
  square := by ext <;> simp <;> ring
  conjugate := starRingEnd (QuadInt 1 nu)
  conjugate_w := by ext <;> simp [starRingEnd_apply]
  negative_square := fun _ hm hs => nonpositive_integer_square_trace_one hm hs
  pell := by
    intro z r s hz hr hs
    rcases QuadInt.unit_pair_half_basis_pell hd z r s hz hr hs with h | h
    · exact Or.inl h
    · right
      obtain ⟨u,v,hv,hPell,hz⟩ := h
      refine ⟨u,v,hv,hPell,?_⟩
      rw [hz]
      ext <;> simp <;> ring

/-- Existence of the combined model for the full integer ring, including
the half-integral basis. All arithmetic properties are proved here. -/
theorem full_ring_unit_pair_arithmetic_model
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) : Nonempty (UnitPairArithmeticModel (𝓞 K)) := by
  obtain ⟨tau,nu,htau,hd,⟨e⟩⟩ := exists_imaginary_quadratic_ring_equiv hK
  rcases htau with rfl | rfl
  · have hnu : 0 < nu := by
      unfold QuadInt.discriminant at hd
      norm_num at hd
      omega
    exact ⟨(unitPairTraceZeroModel nu hnu
      (squarefree_trace_zero_parameter e hd)).mapEquiv e⟩
  · have hsq : Squarefree (4*nu-1) := by
      simpa [QuadInt.discriminant] using squarefree_trace_one_discriminant e hd
    exact ⟨(unitPairTraceOneModel nu hd hsq).mapEquiv e⟩

/-- Two purely imaginary extensions on the same half-axis cannot be
compatible: their negative square would make the field parameter divide 1. -/
theorem UnitPairArithmeticModel.imaginary_same_axis_impossible
    {R : Type*} [CommRing R] (M : UnitPairArithmeticModel R)
    (hd : 2 ≤ M.d) (m n : ℤ) (hmn : 0 < m*n)
    (hs : ∃ r : R, r*r = ((m : R)*M.w)*((n : R)*M.w)+1) : False := by
  have hmn1 : 1 ≤ m*n := by omega
  have hdmn : 2 ≤ M.d*(m*n) := by nlinarith [M.positive]
  have hnonpos : 1-M.d*(m*n) ≤ 0 := by omega
  have hs' : ∃ r : R, r*r = ((1-M.d*(m*n) : ℤ) : R) := by
    obtain ⟨r,hr⟩ := hs
    refine ⟨r, hr.trans ?_⟩
    calc
      _ = ((m*n : ℤ) : R)*(M.w*M.w)+1 := by push_cast; ring
      _ = _ := by rw [M.square]; push_cast; ring
  obtain ⟨y,hy⟩ := M.negative_square _ hnonpos hs'
  have hdiv : M.d ∣ 1 := ⟨m*n-y^2, by nlinarith only [hy]⟩
  have hle := Int.le_of_dvd (by norm_num : (0 : ℤ) < 1) hdiv
  omega

/-- Conjugation supplies the second product square for a real/imaginary
pair. This is an operation on the original integer ring. -/
theorem UnitPairArithmeticModel.mixed_product_square
    {R : Type*} [CommRing R] (M : UnitPairArithmeticModel R)
    (m n : ℤ) (hs : ∃ r : R, r^2 = 1+(m : R)*((n : R)*M.w)) :
    ∃ r : R, r^2 = 1-(m : R)*((n : R)*M.w) := by
  obtain ⟨r,hr⟩ := hs
  refine ⟨M.conjugate r, ?_⟩
  have h := congrArg M.conjugate hr
  simpa only [map_pow, map_add, map_one, map_mul, map_intCast,
    M.conjugate_w, mul_neg, sub_eq_add_neg] using h

end D1Bound5
