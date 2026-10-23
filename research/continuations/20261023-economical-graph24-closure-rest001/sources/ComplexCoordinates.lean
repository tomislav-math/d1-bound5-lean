import D1Bound5.Coordinates
import Mathlib.Analysis.Complex.Norm
import Mathlib.Tactic.LinearCombination

namespace D1Bound5.QuadInt

open scoped QuadraticAlgebra

variable {tau nu : ℤ}

/-- The image of an arbitrary coordinate element under a complex ring map. -/
theorem complex_image (f : QuadInt tau nu →+* ℂ) (z : QuadInt tau nu) :
    f z = (z.re : ℂ)+(z.im : ℂ)*f QuadraticAlgebra.omega := by
  have hz : z = (z.re : QuadInt tau nu) + (z.im : QuadInt tau nu)*QuadraticAlgebra.omega := by
    ext <;> simp [QuadraticAlgebra.omega]
  calc
    f z = f ((z.re : QuadInt tau nu) + (z.im : QuadInt tau nu)*QuadraticAlgebra.omega) := congrArg f hz
    _ = _ := by simp only [map_add, map_mul, map_intCast]

/-- A nonreal quadratic generator has real part tau/2 and norm nu. -/
theorem complex_generator_parameters (f : QuadInt tau nu →+* ℂ)
    (hi : (f QuadraticAlgebra.omega).im ≠ 0) :
    2*(f QuadraticAlgebra.omega).re = (tau : ℝ) ∧
    (f QuadraticAlgebra.omega).re^2 + (f QuadraticAlgebra.omega).im^2 = (nu : ℝ) ∧
    (discriminant tau nu : ℝ) = 4*(f QuadraticAlgebra.omega).im^2 := by
  let w := f QuadraticAlgebra.omega
  have hrel : (QuadraticAlgebra.omega : QuadInt tau nu)*QuadraticAlgebra.omega =
      -(nu : QuadInt tau nu)+(tau : QuadInt tau nu)*QuadraticAlgebra.omega := by
    ext <;> simp [QuadraticAlgebra.omega]
  have he := congrArg f hrel
  simp only [map_mul, map_add, map_neg, map_intCast] at he
  change w*w = -(nu : ℂ)+(tau : ℂ)*w at he
  have hr : w.re*w.re-w.im*w.im = -(nu : ℝ)+(tau : ℝ)*w.re := by
    simpa using congrArg Complex.re he
  have him : (2*w.re-(tau : ℝ))*w.im = 0 := by
    have h := congrArg Complex.im he
    simp only [Complex.mul_im, Complex.add_im, Complex.neg_im,
      Complex.intCast_im, Complex.intCast_re, neg_zero, zero_mul, zero_add, add_zero] at h
    nlinarith [h]
  have ht : 2*w.re = (tau : ℝ) := by
    have := (mul_eq_zero.mp him).resolve_right hi
    linarith
  have hn : w.re^2+w.im^2 = (nu : ℝ) := by
    linear_combination w.re*ht-hr
  refine ⟨ht, hn, ?_⟩
  change ((4*nu-tau^2 : ℤ) : ℝ) = 4*w.im^2
  push_cast
  linear_combination -4*hn+(2*w.re+(tau : ℝ))*ht

/-- Positivity of the coordinate discriminant follows from any nonreal
complex embedding, rather than being assumed as an extra field hypothesis. -/
theorem discriminant_pos_of_complex_embedding (f : QuadInt tau nu →+* ℂ)
    (hi : (f QuadraticAlgebra.omega).im ≠ 0) : 0 < discriminant tau nu := by
  have h := (complex_generator_parameters f hi).2.2
  have hs := sq_pos_of_ne_zero hi
  have hd : (0 : ℝ) < (discriminant tau nu : ℝ) := by linarith
  exact_mod_cast hd

/-- The coordinate norm equals the squared complex modulus. -/
theorem norm_sq_complex_image (f : QuadInt tau nu →+* ℂ)
    (hi : (f QuadraticAlgebra.omega).im ≠ 0) (z : QuadInt tau nu) :
    ‖f z‖^2 = (z.norm : ℝ) := by
  obtain ⟨ht, hn, _⟩ := complex_generator_parameters f hi
  rw [complex_image f z, Complex.sq_norm, Complex.normSq_apply, norm_formula]
  simp only [Complex.add_re, Complex.add_im, Complex.mul_re, Complex.mul_im,
    Complex.intCast_re, Complex.intCast_im, zero_mul, zero_add, sub_zero]
  push_cast
  linear_combination (z.im : ℝ)^2*hn + (z.re : ℝ)*(z.im : ℝ)*ht

/-- Real images are precisely the elements with zero second coordinate. -/
theorem complex_im_zero_iff (f : QuadInt tau nu →+* ℂ)
    (hi : (f QuadraticAlgebra.omega).im ≠ 0) (z : QuadInt tau nu) :
    (f z).im = 0 ↔ z.im = 0 := by
  rw [complex_image f z]
  simp [Complex.mul_im, hi]

end D1Bound5.QuadInt
