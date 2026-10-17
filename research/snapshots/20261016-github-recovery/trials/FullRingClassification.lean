import D1Bound5.FullRingBridge
import D1Bound5.MaximalCoordinates

open scoped NumberField
open Module

namespace D1Bound5

/-- The two full integer-ring models used in all finite computations.
Every imaginary quadratic field is covered, with positive squarefree d
and the half-integral model exactly when d is 3 modulo 4. -/
theorem exists_full_integer_coordinates {K : Type*} [Field K] [NumberField K]
    [NumberField.IsTotallyComplex K] (hK : finrank ℚ K = 2) :
    ∃ d : ℤ, 0 < d ∧ Squarefree d ∧
      ((d % 4 = 3 ∧ Nonempty (QuadInt 1 ((d+1)/4) ≃+* 𝓞 K)) ∨
       (d % 4 ≠ 3 ∧ Nonempty (QuadInt 0 d ≃+* 𝓞 K))) := by
  obtain ⟨tau, nu, ht, hd, ⟨e⟩⟩ := exists_imaginary_quadratic_ring_equiv hK
  rcases ht with rfl | rfl
  · refine ⟨nu, ?_, squarefree_trace_zero_parameter e hd,
      Or.inr ⟨trace_zero_parameter_not_three_mod_four e, ⟨e⟩⟩⟩
    unfold QuadInt.discriminant at hd
    norm_num at hd
    omega
  · refine ⟨4*nu-1, ?_, ?_, Or.inl ⟨by omega, ?_⟩⟩
    · simpa [QuadInt.discriminant] using hd
    · simpa [QuadInt.discriminant] using squarefree_trace_one_discriminant e hd
    · have hn : (4*nu-1+1)/4 = nu := by omega
      rw [hn]
      exact ⟨e⟩

end D1Bound5
