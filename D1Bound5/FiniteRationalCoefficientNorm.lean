import D1Bound5.FiniteFixedCoefficientNorm
import D1Bound5.FullRingBridge

open scoped NumberField

namespace D1Bound5

/-- Integer-anchor evaluation has the same squared complex modulus as its
quadratic-algebra norm in every coordinate model. No identification of the
ambient number field with the Gaussian field is required. -/
theorem finiteFixedHomogeneous_intCast_norm_sq (tau nu : ℤ)
    (n : ℕ) (v : Fin (n+1) → ℤ) (X Y : ℤ) :
    ‖finiteHomogeneousTwo n v (X : ℂ) (Y : ℂ)‖^2 =
      ((finiteHomogeneousTwo n v (X : QuadInt tau nu) (Y : QuadInt tau nu)).norm : ℝ) := by
  let z : ℤ := finiteHomogeneousTwo n v X Y
  have hC : (z : ℂ) = finiteHomogeneousTwo n v (X : ℂ) (Y : ℂ) := by
    simpa [z] using
      finiteFixedHomogeneous_map (Int.castRingHom ℂ) n v X Y
  have hQ : (z : QuadInt tau nu) =
      finiteHomogeneousTwo n v (X : QuadInt tau nu) (Y : QuadInt tau nu) := by
    simpa [z] using
      finiteFixedHomogeneous_map (Int.castRingHom (QuadInt tau nu)) n v X Y
  rw [←hC,←hQ,QuadraticAlgebra.norm_intCast]
  have hn : ‖(z : ℂ)‖ = |(z : ℝ)| := by simp
  rw [hn,sq_abs]
  simp only [Int.cast_pow, Int.cast_id]

/-- Simultaneous signs preserve the rational coefficient certificate. -/
theorem finiteFixedHomogeneous_signed_intCast_norm_sq (tau nu : ℤ)
    (n : ℕ) (v : Fin (n+1) → ℤ) (X Y : ℤ) (sgn : Bool) :
    ‖finiteHomogeneousTwo n v (if sgn then -(X : ℂ) else (X : ℂ))
      (if sgn then -(Y : ℂ) else (Y : ℂ))‖^2 =
      ((finiteHomogeneousTwo n v (X : QuadInt tau nu) (Y : QuadInt tau nu)).norm : ℝ) := by
  cases sgn
  · simpa using
      finiteFixedHomogeneous_intCast_norm_sq tau nu n v X Y
  · simpa [finiteFixedHomogeneous_neg,norm_mul,norm_pow] using
      finiteFixedHomogeneous_intCast_norm_sq tau nu n v X Y

/-- Actual full-ring rational anchors transfer the same finite coefficient
certificate in arbitrary number fields, including the row (1,3,8). -/
theorem full_ring_finiteFixedHomogeneous_rational_norm_sq
    {K : Type*} [Field K] [NumberField K] (phi : K →+* ℂ)
    (tau nu : ℤ) (n : ℕ) (v : Fin (n+1) → ℤ) (X Y : ℤ)
    (sgn : Bool) (x y : 𝓞 K)
    (hx : x = if sgn then -(X : 𝓞 K) else (X : 𝓞 K))
    (hy : y = if sgn then -(Y : 𝓞 K) else (Y : 𝓞 K)) :
    ‖finiteHomogeneousTwo n v (phi (x : K)) (phi (y : K))‖^2 =
      ((finiteHomogeneousTwo n v (X : QuadInt tau nu) (Y : QuadInt tau nu)).norm : ℝ) := by
  have hxC : phi (x : K) = if sgn then -(X : ℂ) else (X : ℂ) := by
    rw [hx]
    cases sgn <;> simp
  have hyC : phi (y : K) = if sgn then -(Y : ℂ) else (Y : ℂ) := by
    rw [hy]
    cases sgn <;> simp
  rw [hxC,hyC]
  exact finiteFixedHomogeneous_signed_intCast_norm_sq tau nu n v X Y sgn

end D1Bound5
