import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum

namespace D1Bound5

variable {R : Type*} [CommRing R]

/-- The three constant columns in the manuscript's N3 family, after the
row divisions and the common factor4 have been removed. -/
def finiteN3Constant (x y c : R) : Fin 3 → R :=
  ![(x-y)^5*((35) +
      (210 * x + 210 * y)*c +
      (336 * x ^ 2 + 504 * x * y + 336 * y ^ 2)*c^2 +
      (160 * x ^ 3 + 288 * x ^ 2 * y + 288 * x * y ^ 2 + 160 * y ^ 3)*c^3),
    (x-y)^6*((-70)*c +
      (-224 * x - 168 * y)*c^2 +
      (-160 * x ^ 2 - 192 * x * y - 96 * y ^ 2)*c^3),
    (x-y)^6*((-70)*c +
      (-168 * x - 224 * y)*c^2 +
      (-96 * x ^ 2 - 192 * x * y - 160 * y ^ 2)*c^3)]

def finiteN3Left (x y c : R) : Fin 3 → R :=
  ![(-6 * x ^ 4 + 36 * x ^ 3 * y - 126 * x ^ 2 * y ^ 2) +
      (-102 * x ^ 5 + 444 * x ^ 4 * y - 630 * x ^ 3 * y ^ 2)*c +
      (-256 * x ^ 6 + 920 * x ^ 5 * y - 952 * x ^ 4 * y ^ 2)*c^2 +
      (-160 * x ^ 7 + 512 * x ^ 6 * y - 448 * x ^ 5 * y ^ 2)*c^3,
    (-x ^ 4 + 9 * x ^ 3 * y - 63 * x ^ 2 * y ^ 2 - 105 * x * y ^ 3) +
      (18 * x ^ 5 - 120 * x ^ 4 * y + 378 * x ^ 3 * y ^ 2 - 756 * x ^ 2 * y ^ 3)*c +
      (144 * x ^ 6 - 792 * x ^ 5 * y + 1680 * x ^ 4 * y ^ 2 - 1512 * x ^ 3 * y ^ 3)*c^2 +
      (160 * x ^ 7 - 768 * x ^ 6 * y + 1344 * x ^ 5 * y ^ 2 - 896 * x ^ 4 * y ^ 3)*c^3,
    (-2 * x ^ 4 + 36 * x ^ 3 * y + 126 * x ^ 2 * y ^ 2) +
      (22 * x ^ 5 - 172 * x ^ 4 * y + 630 * x ^ 3 * y ^ 2)*c +
      (120 * x ^ 6 - 592 * x ^ 5 * y + 952 * x ^ 4 * y ^ 2)*c^2 +
      (96 * x ^ 7 - 384 * x ^ 6 * y + 448 * x ^ 5 * y ^ 2)*c^3]

def finiteN3Right (x y c : R) : Fin 3 → R :=
  ![(126 * x ^ 2 * y ^ 2 - 36 * x * y ^ 3 + 6 * y ^ 4) +
      (630 * x ^ 2 * y ^ 3 - 444 * x * y ^ 4 + 102 * y ^ 5)*c +
      (952 * x ^ 2 * y ^ 4 - 920 * x * y ^ 5 + 256 * y ^ 6)*c^2 +
      (448 * x ^ 2 * y ^ 5 - 512 * x * y ^ 6 + 160 * y ^ 7)*c^3,
    (126 * x ^ 2 * y ^ 2 + 36 * x * y ^ 3 - 2 * y ^ 4) +
      (630 * x ^ 2 * y ^ 3 - 172 * x * y ^ 4 + 22 * y ^ 5)*c +
      (952 * x ^ 2 * y ^ 4 - 592 * x * y ^ 5 + 120 * y ^ 6)*c^2 +
      (448 * x ^ 2 * y ^ 5 - 384 * x * y ^ 6 + 96 * y ^ 7)*c^3,
    (-105 * x ^ 3 * y - 63 * x ^ 2 * y ^ 2 + 9 * x * y ^ 3 - y ^ 4) +
      (-756 * x ^ 3 * y ^ 2 + 378 * x ^ 2 * y ^ 3 - 120 * x * y ^ 4 + 18 * y ^ 5)*c +
      (-1512 * x ^ 3 * y ^ 3 + 1680 * x ^ 2 * y ^ 4 - 792 * x * y ^ 5 + 144 * y ^ 6)*c^2 +
      (-896 * x ^ 3 * y ^ 4 + 1344 * x ^ 2 * y ^ 5 - 768 * x * y ^ 6 + 160 * y ^ 7)*c^3]

/-- The polynomial matrix with its exact anchor factors removed. This is
the matrix acting on the integral vector of signed root products. -/
def finiteN3DividedMatrix (x y c : R) : Matrix (Fin 3) (Fin 3) R :=
  Matrix.of (fun i j => ![finiteN3Constant x y c i,
    finiteN3Left x y c i, finiteN3Right x y c i] j)

/-- The original root coefficient matrix, with its exact anchor factors. -/
def finiteN3Matrix (x y c : R) : Matrix (Fin 3) (Fin 3) R :=
  finiteN3DividedMatrix x y c * Matrix.diagonal ![1,x,y]

def finiteN3RowFactor (x y : R) : Fin 3 → R := ![x-y,x,y]

@[simp] theorem finiteN3Matrix_zero (x y c : R) (i : Fin 3) :
    finiteN3Matrix x y c i 0 = finiteN3Constant x y c i := by
  simp [finiteN3Matrix, finiteN3DividedMatrix, Matrix.mul_diagonal]

@[simp] theorem finiteN3Matrix_one (x y c : R) (i : Fin 3) :
    finiteN3Matrix x y c i 1 = x * finiteN3Left x y c i := by
  simp [finiteN3Matrix, finiteN3DividedMatrix, Matrix.mul_diagonal, mul_comm]

@[simp] theorem finiteN3Matrix_two (x y c : R) (i : Fin 3) :
    finiteN3Matrix x y c i 2 = y * finiteN3Right x y c i := by
  simp [finiteN3Matrix, finiteN3DividedMatrix, Matrix.mul_diagonal, mul_comm]

set_option maxHeartbeats 4000000 in
/-- The determinant is verified from the actual integer polynomials.
The manuscript's constant235200 is divided by g^3=64. -/
theorem finiteN3DividedMatrix_det (x y c : R) :
    (finiteN3DividedMatrix x y c).det = 3675*x*y*(x-y)^11 := by
  simp [finiteN3DividedMatrix, finiteN3Constant, finiteN3Left, finiteN3Right,
    Matrix.det_succ_row_zero, Fin.sum_univ_succ, Matrix.submatrix]
  <;> ring

theorem finiteN3Matrix_det (x y c : R) :
    (finiteN3Matrix x y c).det = 3675*x^2*y^2*(x-y)^11 := by
  rw [finiteN3Matrix, Matrix.det_mul, finiteN3DividedMatrix_det, Matrix.det_diagonal]
  simp [Fin.prod_univ_succ]
  <;> ring

theorem finiteN3DividedMatrix_det_ne_zero
    {F : Type*} [Field F] [CharZero F] (x y c : F) (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) :
    (finiteN3DividedMatrix x y c).det ≠ 0 := by
  rw [finiteN3DividedMatrix_det]
  norm_num [mul_eq_zero, sub_eq_zero, hx, hy, hxy]

end D1Bound5
