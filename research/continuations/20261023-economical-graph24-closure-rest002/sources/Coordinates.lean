import Mathlib.Algebra.QuadraticAlgebra.Basic
import Mathlib.Tactic.Linarith

namespace D1Bound5

/-- Coordinates x+y*omega with omega^2=tau*omega-nu.
Both tau=0 and tau=1 are included. Identification with the full ring of
integers is a separate obligation, not part of this definition. -/
abbrev QuadInt (tau nu : ℤ) := QuadraticAlgebra ℤ (-nu) tau

namespace QuadInt

variable {tau nu : ℤ}

def discriminant (tau nu : ℤ) : ℤ := 4*nu-tau^2

/-- Equation (integrated-disk), first identity. -/
theorem norm_formula (z : QuadInt tau nu) :
    z.norm = z.re^2 + tau*z.re*z.im + nu*z.im^2 := by
  rw [QuadraticAlgebra.norm_def]
  ring

/-- Equation (integrated-disk), completed-square identity. -/
theorem four_norm (z : QuadInt tau nu) :
    4*z.norm = (2*z.re+tau*z.im)^2 + discriminant tau nu*z.im^2 := by
  rw [norm_formula]
  unfold discriminant
  ring

theorem norm_nonneg (hd : 0 < discriminant tau nu) (z : QuadInt tau nu) :
    0 ≤ z.norm := by
  have h := four_norm z
  have hprod := mul_nonneg hd.le (sq_nonneg z.im)
  nlinarith [sq_nonneg (2*z.re+tau*z.im)]

theorem norm_eq_zero_iff (hd : 0 < discriminant tau nu) (z : QuadInt tau nu) :
    z.norm = 0 ↔ z = 0 := by
  constructor
  · intro hz
    have h := four_norm z
    have hy : z.im = 0 := by
      by_contra hy
      have hp := mul_pos hd (sq_pos_of_ne_zero hy)
      nlinarith [sq_nonneg (2*z.re+tau*z.im)]
    have hx : z.re = 0 := by
      rw [hz, hy] at h
      nlinarith
    exact QuadraticAlgebra.ext hx hy
  · intro hz
    simp [hz]

theorem norm_pos (hd : 0 < discriminant tau nu) {z : QuadInt tau nu}
    (hz : z ≠ 0) : 0 < z.norm := by
  have hn := norm_nonneg hd z
  have hne : z.norm ≠ 0 := fun h => hz ((norm_eq_zero_iff hd z).mp h)
  omega

/-- The integer norm of a nonzero element is at least one. -/
theorem one_le_norm (hd : 0 < discriminant tau nu) {z : QuadInt tau nu}
    (hz : z ≠ 0) : 1 ≤ z.norm := by
  have := norm_pos hd hz
  omega

/-- A nonreal element in a bounded disk bounds the field discriminant.
Used for the Delta<=60 reduction in lem:tail-irregular. -/
theorem discriminant_le_four_bound (hd : 0 < discriminant tau nu)
    {z : QuadInt tau nu} {M : ℤ} (hM : z.norm ≤ M) (hy : z.im ≠ 0) :
    discriminant tau nu ≤ 4*M := by
  have hypos := sq_pos_of_ne_zero hy
  have hyone : 1 ≤ z.im^2 := by omega
  have hp := mul_le_mul_of_nonneg_left hyone hd.le
  have h := four_norm z
  nlinarith [sq_nonneg (2*z.re+tau*z.im)]

end QuadInt
end D1Bound5
