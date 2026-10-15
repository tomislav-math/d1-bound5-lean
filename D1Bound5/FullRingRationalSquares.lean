import D1Bound5.RationalSquares
import D1Bound5.FullRingClassification

open scoped NumberField
open Module

namespace D1Bound5

/-- Square-root existence is transported through any ring equivalence,
including roots equal to zero. -/
theorem integer_square_under_ring_equiv {R S : Type*} [CommRing R] [CommRing S]
    (e : R ≃+* S) (m : ℤ)
    (h : ∃ r : S, r*r = (m : S)) :
    ∃ r : R, r*r = (m : R) := by
  obtain ⟨r,hr⟩ := h
  refine ⟨e.symm r, ?_⟩
  simpa only [map_mul, map_intCast] using congrArg e.symm hr

/-- A positive rational integer square in the full number ring is an
ordinary integer square, uniformly over all imaginary quadratic fields. -/
theorem full_ring_positive_integer_square {K : Type*} [Field K]
    [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) {m : ℤ} (hm : 0 < m)
    (hs : ∃ r : 𝓞 K, r*r = (m : 𝓞 K)) :
    ∃ n : ℤ, m = n^2 := by
  obtain ⟨tau,nu,_,hd,⟨e⟩⟩ := exists_imaginary_quadratic_ring_equiv hK
  exact positive_integer_square_is_integer hd hm (integer_square_under_ring_equiv e m hs)

/-- Every negative rational integer that is an integral square in an
imaginary quadratic field is -d times an integer square, with d the
positive squarefree parameter of that very field. Both integral-basis
branches are included. -/
theorem full_ring_negative_integer_square {K : Type*} [Field K]
    [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) {m : ℤ} (hm : m < 0)
    (hs : ∃ r : 𝓞 K, r*r = (m : 𝓞 K)) :
    ∃ d : ℤ, 0 < d ∧ Squarefree d ∧ ∃ n : ℤ, m = -d*n^2 := by
  obtain ⟨d,hdpos,hsf,hcase⟩ := exists_full_integer_coordinates hK
  refine ⟨d,hdpos,hsf,?_⟩
  rcases hcase with ⟨hmod,⟨e⟩⟩ | ⟨_,⟨e⟩⟩
  · obtain ⟨n,hn⟩ := negative_integer_square_trace_one hm
      (integer_square_under_ring_equiv e m hs)
    have hdiv : 4*((d+1)/4)-1=d := by omega
    refine ⟨n, ?_⟩
    rw [hdiv] at hn
    exact hn
  · exact negative_integer_square_trace_zero hm
      (integer_square_under_ring_equiv e m hs)

end D1Bound5
