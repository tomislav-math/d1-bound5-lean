import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Tactic.Ring
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum

open scoped BigOperators
open Matrix

namespace D1Bound5

/-- A matrix with its rows and columns multiplied by prescribed roots.
The construction also permits zero roots. -/
def scaledRootMatrix {R n : Type*} [CommRing R] (u : n → R)
    (M : Matrix n n R) : Matrix n n R :=
  fun i j => u i * M i j * u j

/-- Correction term after subtracting the rank-one matrix of the entries. -/
def normalizedRootError {R n : Type*} [CommRing R] (a u : n → R)
    (M : Matrix n n R) : Matrix n n R :=
  fun i j => scaledRootMatrix u M i j - a i * a j

/-- Exact determinant scaling in arbitrary finite dimension, with no
nonzero-root assumption. -/
theorem scaledRootMatrix_det {R n : Type*} [CommRing R]
    [Fintype n] [DecidableEq n] (u : n → R) (M : Matrix n n R) :
    (scaledRootMatrix u M).det = (∏ i, u i)^2 * M.det := by
  have h : scaledRootMatrix u M = Matrix.diagonal u * M * Matrix.diagonal u := by
    ext i j
    simp only [scaledRootMatrix, Matrix.mul_diagonal, Matrix.diagonal_mul]
  rw [h, Matrix.det_mul, Matrix.det_mul, Matrix.det_diagonal]
  ring

/-- The correction satisfies the quadratic relation behind
(integrated-2), in any commutative ring and without division. -/
theorem root_error_quadratic {R : Type*} [CommRing R]
    (a b u v r : R) (hu : u^2 = a) (hv : v^2 = b)
    (hr : r^2 = a*b+1) :
    (u*r*v-a*b)^2 + 2*a*b*(u*r*v-a*b) = a*b := by
  calc
    _ = (u*r*v)^2-(a*b)^2 := by ring
    _ = a*b := by
      rw [mul_pow, mul_pow, hu, hv, hr]
      ring

/-- Off-diagonal correction identity without denominators. -/
theorem normalizedRootError_relation {R n : Type*} [CommRing R]
    (a u : n → R) (M : Matrix n n R)
    (hu : ∀ i, (u i)^2 = a i)
    (hs : ∀ i j, i ≠ j → (M i j)^2 = a i*a j+1)
    (i j : n) (hij : i ≠ j) :
    (normalizedRootError a u M i j)^2 +
      2*a i*a j*(normalizedRootError a u M i j) = a i*a j := by
  simpa only [normalizedRootError, scaledRootMatrix] using
    root_error_quadratic (a i) (a j) (u i) (u j) (M i j) (hu i) (hu j) (hs i j hij)

/-- The correction is zero on the diagonal. -/
theorem normalizedRootError_diag {R n : Type*} [CommRing R]
    (a u : n → R) (M : Matrix n n R)
    (hu : ∀ i, (u i)^2 = a i) (hd : ∀ i, M i i = a i)
    (i : n) : normalizedRootError a u M i i = 0 := by
  simp only [normalizedRootError, scaledRootMatrix, hd i]
  have h := hu i
  calc
    u i * a i * u i - a i * a i =
        (u i)^2 * a i - a i^2 := by ring
    _ = 0 := by rw [h]; ring

/-- Normalization (integrated-1): a scaled root matrix is a rank-one
matrix plus the correction. -/
theorem scaledRootMatrix_eq_rankOne_add_error {R n : Type*} [CommRing R]
    (a u : n → R) (M : Matrix n n R) :
    scaledRootMatrix u M =
      (fun i j => a i*a j + normalizedRootError a u M i j) := by
  ext i j
  simp [normalizedRootError]

/-- Determinant equality in (integrated-1), in any finite dimension and
without dividing by entries or square roots. -/
theorem normalizedRootError_det {R n : Type*} [CommRing R]
    [Fintype n] [DecidableEq n] (a u : n → R) (M : Matrix n n R)
    (hu : ∀ i, (u i)^2 = a i) :
    Matrix.det (fun i j => a i*a j + normalizedRootError a u M i j) =
      (∏ i, a i) * M.det := by
  rw [← scaledRootMatrix_eq_rankOne_add_error a u M, scaledRootMatrix_det]
  have hp : (∏ i, u i)^2 = ∏ i, a i := by
    rw [← Finset.prod_pow]
    exact Finset.prod_congr rfl (fun i _ => hu i)
  rw [hp]

/-- Division version of (integrated-2) over the complex numbers. -/
theorem root_error_sub_half (a b u v r : ℂ)
    (hab : a*b ≠ 0) (hu : u^2 = a) (hv : v^2 = b)
    (hr : r^2 = a*b+1) :
    (u*r*v-a*b)-(1/2 : ℂ) = -(u*r*v-a*b)^2/(2*a*b) := by
  have hd : (2:ℂ)*a*b ≠ 0 := by
    have ha : a ≠ 0 := (mul_ne_zero_iff.mp hab).1
    have hb : b ≠ 0 := (mul_ne_zero_iff.mp hab).2
    exact mul_ne_zero (mul_ne_zero (by norm_num) ha) hb
  apply (eq_div_iff hd).2
  have h := root_error_quadratic a b u v r hu hv hr
  calc
    ((u*r*v-a*b)-(1/2 : ℂ))*(2*a*b) =
      2*a*b*(u*r*v-a*b)-a*b := by ring
    _ = -(u*r*v-a*b)^2 := by linear_combination h

end D1Bound5
