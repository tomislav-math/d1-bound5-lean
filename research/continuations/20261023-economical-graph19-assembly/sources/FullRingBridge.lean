import D1Bound5.FullRingBasis
import D1Bound5.ComplexCoordinates
import D1Bound5.Specification
import D1Bound5.OneThree

open scoped NumberField ComplexConjugate
open Module

namespace D1Bound5

variable {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]

/-- A generator of the full number ring cannot have a real image in a
complex embedding of a totally complex field. Fraction representations
extend reality from the integer ring to the whole field. -/
theorem full_ring_generator_nonreal {tau nu : ℤ}
    (e : QuadInt tau nu ≃+* 𝓞 K) (φ : K →+* ℂ) :
    (((φ.comp (algebraMap (𝓞 K) K)).comp e.toRingHom) QuadraticAlgebra.omega).im ≠ 0 := by
  let f : QuadInt tau nu →+* ℂ := (φ.comp (algebraMap (𝓞 K) K)).comp e.toRingHom
  intro hi
  change (f QuadraticAlgebra.omega).im = 0 at hi
  have hreal (x : 𝓞 K) : conj (φ (x : K)) = φ (x : K) := by
    obtain ⟨z, rfl⟩ := e.surjective x
    apply Complex.conj_eq_iff_im.mpr
    change (f z).im = 0
    rw [QuadInt.complex_image f z]
    simp only [Complex.add_im, Complex.intCast_im, Complex.mul_im,
      hi, mul_zero, zero_mul, add_zero]
  apply NumberField.IsTotallyComplex.complexEmbedding_not_isReal φ
  apply NumberField.ComplexEmbedding.isReal_iff.mpr
  ext x
  change conj (φ x) = φ x
  obtain ⟨a, b, _, hx⟩ := IsFractionRing.div_surjective (𝓞 K) x
  rw [← hx]
  simp only [map_div₀, hreal]

/-- Every imaginary quadratic field has full integer-ring coordinates of
trace zero or one and positive discriminant. There is no suborder hypothesis. -/
theorem exists_imaginary_quadratic_ring_equiv (hK : finrank ℚ K = 2) :
    ∃ tau nu : ℤ, (tau = 0 ∨ tau = 1) ∧ 0 < QuadInt.discriminant tau nu ∧
      Nonempty (QuadInt tau nu ≃+* 𝓞 K) := by
  obtain ⟨tau, nu, ht, ⟨e⟩⟩ := exists_normalized_quadratic_ring_equiv hK
  let φ : K →+* ℂ := Classical.choice inferInstance
  refine ⟨tau, nu, ht, ?_, ⟨e⟩⟩
  exact QuadInt.discriminant_pos_of_complex_embedding _ (full_ring_generator_nonreal e φ)

/-- The actual complex modulus in the field agrees with the integral
coordinate norm under any full-ring equivalence and any complex embedding. -/
theorem norm_sq_full_ring_equiv {tau nu : ℤ}
    (e : QuadInt tau nu ≃+* 𝓞 K) (φ : K →+* ℂ) (z : QuadInt tau nu) :
    ‖φ (e z : K)‖^2 = (z.norm : ℝ) := by
  exact QuadInt.norm_sq_complex_image _ (full_ring_generator_nonreal e φ) z

/-- Every nonzero algebraic integer in an imaginary quadratic field has
complex modulus at least one. -/
theorem one_le_norm_integer (hK : finrank ℚ K = 2) (φ : K →+* ℂ)
    {x : 𝓞 K} (hx : x ≠ 0) : 1 ≤ ‖φ (x : K)‖ := by
  obtain ⟨tau, nu, _, hd, ⟨e⟩⟩ := exists_imaginary_quadratic_ring_equiv hK
  have hz : e.symm x ≠ 0 := by simpa using hx
  have hN : (1 : ℝ) ≤ ((e.symm x).norm : ℝ) := by
    exact_mod_cast QuadInt.one_le_norm hd hz
  have hn : ‖φ (x : K)‖^2 = ((e.symm x).norm : ℝ) := by
    simpa using norm_sq_full_ring_equiv e φ (e.symm x)
  nlinarith [norm_nonneg (φ (x : K))]

/-- The rationality assertion of lem:pr-one-three in the full integer ring
of every imaginary quadratic field, with no coordinate-model assumption. -/
theorem full_ring_one_three_common_extension_is_integer (hK : finrank ℚ K = 2)
    {z : 𝓞 K} (hr : ∃ r : 𝓞 K, r*r = z+1)
    (hs : ∃ s : 𝓞 K, s*s = 3*z+1) : ∃ n : ℤ, z = (n : 𝓞 K) := by
  obtain ⟨tau, nu, _, hd, ⟨e⟩⟩ := exists_imaginary_quadratic_ring_equiv hK
  have hr' : ∃ r : QuadInt tau nu, r*r = e.symm z+1 := by
    obtain ⟨r, hr⟩ := hr
    refine ⟨e.symm r, ?_⟩
    simpa only [map_mul, map_add, map_one] using congrArg e.symm hr
  have hs' : ∃ s : QuadInt tau nu, s*s = 3*e.symm z+1 := by
    obtain ⟨s, hs⟩ := hs
    refine ⟨e.symm s, ?_⟩
    simpa only [map_mul, map_add, map_one, map_ofNat] using congrArg e.symm hs
  obtain ⟨n, hn⟩ := one_three_common_extension_is_integer tau nu hd hr' hs'
  refine ⟨n, ?_⟩
  simpa only [RingEquiv.apply_symm_apply, map_intCast] using congrArg e hn

end D1Bound5
