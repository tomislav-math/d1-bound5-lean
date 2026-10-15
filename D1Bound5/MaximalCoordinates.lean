import D1Bound5.FullRingBasis
import Mathlib.Algebra.Squarefree.Basic
import Mathlib.Algebra.Polynomial.Monic

open scoped NumberField
open Module Polynomial

namespace D1Bound5

variable {K : Type*} [Field K]

/-- A field element satisfying an integral monic quadratic is integral. -/
theorem integral_of_quadratic_relation (a b : ℤ) {x : K}
    (h : x*x = (a : K)+(b : K)*x) : IsIntegral ℤ x := by
  refine ⟨X^2-(C b*X+C a), ?_, ?_⟩
  · apply Polynomial.monic_X_pow_sub
    apply lt_of_le_of_lt (Polynomial.degree_add_le _ _)
    apply max_lt
    · exact lt_of_le_of_lt (Polynomial.degree_C_mul_X_le b) (by decide)
    · exact lt_of_le_of_lt Polynomial.degree_C_le (by decide)
  · simp only [Polynomial.eval₂_sub, Polynomial.eval₂_pow, Polynomial.eval₂_mul,
      Polynomial.eval₂_add, Polynomial.eval₂_X, Polynomial.eval₂_C]
    change x^2-((b : K)*x+(a : K)) = 0
    linear_combination h

variable [NumberField K]

/-- Square divisibility in a full integer ring forces divisibility of the
root. This uses integrality in K, not unique factorization in the ring. -/
theorem square_division_in_full_ring {tau nu : ℤ}
    (e : QuadInt tau nu ≃+* 𝓞 K) (a m : ℤ) (ha : a ≠ 0)
    {z : QuadInt tau nu} (hz : z*z = ((a*a*m : ℤ) : QuadInt tau nu)) :
    ∃ y : QuadInt tau nu, (a : QuadInt tau nu)*y = z := by
  let f : QuadInt tau nu →+* K := (algebraMap (𝓞 K) K).comp e.toRingHom
  let r : K := f z / (a : K)
  have haK : (a : K) ≠ 0 := by exact_mod_cast ha
  have hr : r^2 = (m : K) := by
    dsimp only [r]
    rw [div_pow]
    apply (div_eq_iff (pow_ne_zero 2 haK)).mpr
    have h := congrArg f hz
    simp only [map_mul, map_intCast] at h
    push_cast at h
    linear_combination h
  have hint : IsIntegral ℤ r := IsIntegral.of_pow (by decide : 0 < 2) (by
    rw [hr]
    exact isIntegral_intCast m)
  let y : 𝓞 K := ⟨r, hint⟩
  refine ⟨e.symm y, ?_⟩
  apply e.injective
  rw [map_mul, RingEquiv.apply_symm_apply, map_intCast]
  apply NumberField.RingOfIntegers.ext
  change (a : K)*r = f z
  dsimp only [r]
  field_simp [haK]

/-- A trace-zero coordinate model for a full imaginary quadratic integer
ring has squarefree nu. -/
theorem squarefree_trace_zero_parameter {nu : ℤ}
    (e : QuadInt 0 nu ≃+* 𝓞 K) (hd : 0 < QuadInt.discriminant 0 nu) : Squarefree nu := by
  have hnu : 0 < nu := by unfold QuadInt.discriminant at hd; norm_num at hd; omega
  intro a ha
  obtain ⟨m, hm⟩ := ha
  have ha0 : a ≠ 0 := by intro h; simp [h] at hm; omega
  have hz : (QuadraticAlgebra.omega : QuadInt 0 nu)*QuadraticAlgebra.omega =
      ((a*a*(-m) : ℤ) : QuadInt 0 nu) := by
    ext <;> simp [QuadraticAlgebra.omega, hm]
  obtain ⟨y, hy⟩ := square_division_in_full_ring e a (-m) ha0 hz
  have him : a*y.im = 1 := by
    have h := congrArg (fun z : QuadInt 0 nu => z.im) hy
    simpa [QuadraticAlgebra.omega] using h
  exact isUnit_of_dvd_one ⟨y.im, him.symm⟩

/-- A trace-one coordinate model for a full imaginary quadratic integer
ring has squarefree absolute discriminant. -/
theorem squarefree_trace_one_discriminant {nu : ℤ}
    (e : QuadInt 1 nu ≃+* 𝓞 K) (hd : 0 < QuadInt.discriminant 1 nu) :
    Squarefree (QuadInt.discriminant 1 nu) := by
  intro a ha
  obtain ⟨m, hm⟩ := ha
  have ha0 : a ≠ 0 := by intro h; simp [h] at hm; omega
  let z : QuadInt 1 nu := 2*QuadraticAlgebra.omega-1
  have hz : z*z = ((a*a*(-m) : ℤ) : QuadInt 1 nu) := by
    have h : 4*nu-1 = a*a*m := by simpa [QuadInt.discriminant] using hm
    apply QuadraticAlgebra.ext
    · simp [z, QuadraticAlgebra.omega, QuadraticAlgebra.re_one, QuadraticAlgebra.im_one,
      QuadraticAlgebra.re_ofNat, QuadraticAlgebra.im_ofNat]
      linear_combination -h
    · simp [z, QuadraticAlgebra.omega, QuadraticAlgebra.re_one, QuadraticAlgebra.im_one,
      QuadraticAlgebra.re_ofNat, QuadraticAlgebra.im_ofNat]
  obtain ⟨y, hy⟩ := square_division_in_full_ring e a (-m) ha0 hz
  have him : a*y.im = 2 := by
    have h := congrArg (fun w : QuadInt 1 nu => w.im) hy
    simpa [z, QuadraticAlgebra.omega, QuadraticAlgebra.re_one, QuadraticAlgebra.im_one,
      QuadraticAlgebra.re_ofNat, QuadraticAlgebra.im_ofNat] using h
  have h : 4*nu-1 = a*a*m := by simpa [QuadInt.discriminant] using hm
  apply isUnit_of_dvd_one
  refine ⟨2*nu*y.im-a*m, ?_⟩
  linear_combination -h-2*nu*him

/-- If nu is 3 modulo 4 then (1+omega)/2 is an extra integral element.
Thus a trace-zero model with that parameter cannot be the full integer ring. -/
theorem trace_zero_parameter_not_three_mod_four {nu : ℤ}
    (e : QuadInt 0 nu ≃+* 𝓞 K) : nu % 4 ≠ 3 := by
  intro hmod
  let m := (nu+1)/4
  have hm : nu+1 = 4*m := by dsimp [m]; omega
  let f : QuadInt 0 nu →+* K := (algebraMap (𝓞 K) K).comp e.toRingHom
  let w : K := f QuadraticAlgebra.omega
  have hw : w*w = -(nu : K) := by
    have hrel : (QuadraticAlgebra.omega : QuadInt 0 nu)*QuadraticAlgebra.omega = -(nu : QuadInt 0 nu) := by
      ext <;> simp [QuadraticAlgebra.omega]
    simpa only [map_mul, map_neg, map_intCast] using congrArg f hrel
  let r : K := (1+w)/2
  have hmK : (nu : K)+1 = 4*(m : K) := by exact_mod_cast hm
  have hr : r*r = ((-m : ℤ) : K)+(1 : K)*r := by
    dsimp only [r]
    push_cast
    linear_combination (1/4 : K)*hw-(1/4 : K)*hmK
  have hint : IsIntegral ℤ r := integral_of_quadratic_relation (-m) 1 (by simpa only [Int.cast_one] using hr)
  let rO : 𝓞 K := ⟨r, hint⟩
  let y := e.symm rO
  have hy : (2 : QuadInt 0 nu)*y = 1+QuadraticAlgebra.omega := by
    apply e.injective
    simp only [y, map_mul, RingEquiv.apply_symm_apply, map_ofNat, map_add, map_one]
    apply NumberField.RingOfIntegers.ext
    change (2 : K)*r = 1+w
    dsimp only [r]
    ring
  have him : 2*y.im = 1 := by
    have h := congrArg (fun z : QuadInt 0 nu => z.im) hy
    simpa [QuadraticAlgebra.omega, QuadraticAlgebra.re_one, QuadraticAlgebra.im_one,
      QuadraticAlgebra.re_ofNat, QuadraticAlgebra.im_ofNat] using h
  omega

end D1Bound5
