import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum

namespace D1Bound5

variable {R : Type*} [CommRing R]

/-- The three constant columns in the manuscript's N2 family, after the
row divisions and the common factor2 have been removed. -/
def finiteN2Constant (x y c : R) : Fin 3 → R :=
  ![(x-y)^3*(15+40*(x+y)*c+8*(3*x^2+4*x*y+3*y^2)*c^2),
    -4*c*(x-y)^4*(5+(6*x+4*y)*c),
    -4*c*(x-y)^4*(5+(4*x+6*y)*c)]

/-- Divided x-column; every displayed coefficient is an integer. -/
def finiteN2Left (x y c : R) : Fin 3 → R :=
  ![-4*x^2+20*x*y+(-28*x^3+60*x^2*y)*c+(-24*x^4+40*x^3*y)*c^2,
    -x^2+10*x*y+15*y^2+(8*x^3-40*x^2*y+80*x*y^2)*c+
      (24*x^4-80*x^3*y+80*x^2*y^2)*c^2,
    -4*x^2-20*x*y+(12*x^3-60*x^2*y)*c+(16*x^4-40*x^3*y)*c^2]

/-- Divided y-column in the same row order. -/
def finiteN2Right (x y c : R) : Fin 3 → R :=
  ![-20*x*y+4*y^2+(-60*x*y^2+28*y^3)*c+(-40*x*y^3+24*y^4)*c^2,
    -20*x*y-4*y^2+(-60*x*y^2+12*y^3)*c+(-40*x*y^3+16*y^4)*c^2,
    15*x^2+10*x*y-y^2+(80*x^2*y-40*x*y^2+8*y^3)*c+
      (80*x^2*y^2-80*x*y^3+24*y^4)*c^2]

/-- The polynomial matrix with its exact anchor factors removed. This is
the matrix acting on the integral vector of signed root products. -/
def finiteN2DividedMatrix (x y c : R) : Matrix (Fin 3) (Fin 3) R :=
  Matrix.of (fun i j => ![finiteN2Constant x y c i,
    finiteN2Left x y c i, finiteN2Right x y c i] j)

/-- The original root coefficient matrix, with its exact anchor factors. -/
def finiteN2Matrix (x y c : R) : Matrix (Fin 3) (Fin 3) R :=
  finiteN2DividedMatrix x y c * Matrix.diagonal ![1,x,y]

def finiteN2RowFactor (x y : R) : Fin 3 → R := ![x-y,x,y]

@[simp] theorem finiteN2Matrix_zero (x y c : R) (i : Fin 3) :
    finiteN2Matrix x y c i 0 = finiteN2Constant x y c i := by
  simp [finiteN2Matrix, finiteN2DividedMatrix, Matrix.mul_diagonal]

@[simp] theorem finiteN2Matrix_one (x y c : R) (i : Fin 3) :
    finiteN2Matrix x y c i 1 = x * finiteN2Left x y c i := by
  simp [finiteN2Matrix, finiteN2DividedMatrix, Matrix.mul_diagonal, mul_comm]

@[simp] theorem finiteN2Matrix_two (x y c : R) (i : Fin 3) :
    finiteN2Matrix x y c i 2 = y * finiteN2Right x y c i := by
  simp [finiteN2Matrix, finiteN2DividedMatrix, Matrix.mul_diagonal, mul_comm]

set_option maxHeartbeats 1000000 in
/-- The determinant is verified from the actual integer polynomials.
The manuscript's constant -1800 is divided by g^3=8. -/
theorem finiteN2DividedMatrix_det (x y c : R) :
    (finiteN2DividedMatrix x y c).det = -225*(x-y)^7 := by
  simp [finiteN2DividedMatrix, finiteN2Constant, finiteN2Left, finiteN2Right,
    Matrix.det_succ_row_zero, Fin.sum_univ_succ, Matrix.submatrix]
  <;> ring

theorem finiteN2Matrix_det (x y c : R) :
    (finiteN2Matrix x y c).det = -225*x*y*(x-y)^7 := by
  rw [finiteN2Matrix, Matrix.det_mul, finiteN2DividedMatrix_det, Matrix.det_diagonal]
  simp [Fin.prod_univ_succ]
  <;> ring

theorem finiteN2DividedMatrix_det_ne_zero
    {F : Type*} [Field F] [CharZero F] (x y c : F) (hxy : x ≠ y) :
    (finiteN2DividedMatrix x y c).det ≠ 0 := by
  rw [finiteN2DividedMatrix_det]
  norm_num [mul_eq_zero, sub_eq_zero, hxy]

end D1Bound5
