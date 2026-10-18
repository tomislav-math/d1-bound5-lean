import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic

namespace D1Bound5
variable {R : Type*} [CommRing R]

def finiteA3Constant (x y c : R) : Fin 3 → R :=
  ![(x-y)^5*c^1*(96*x^2*c^2 + 144*x*y*c^2 + 168*x*c + 96*y^2*c^2 + 168*y*c + 70),(x-y)^6*c^2*(-64*x*c - 48*y*c - 56),(x-y)^6*c^2*(-48*x*c - 64*y*c - 56)]

def finiteA3Left (x y c : R) : Fin 3 → R :=
  ![-96*x^6*c^3 + 336*x^5*y*c^3 - 120*x^5*c^2 - 336*x^4*y^2*c^3 + 504*x^4*y*c^2 - 22*x^4*c - 672*x^3*y^2*c^2 + 140*x^3*y*c + 2*x^3 - 406*x^2*y^2*c - 28*x^2*y - 70*x*y^2,64*x^6*c^3 - 336*x^5*y*c^3 + 24*x^5*c^2 + 672*x^4*y^2*c^3 - 168*x^4*y*c^2 - 4*x^4*c - 560*x^3*y^3*c^3 + 504*x^3*y^2*c^2 + 42*x^3*y*c + x^3 - 840*x^2*y^3*c^2 - 168*x^2*y^2*c - 21*x^2*y - 350*x*y^3*c - 105*x*y^2 - 35*y^3,48*x^6*c^3 - 224*x^5*y*c^3 + 32*x^5*c^2 + 336*x^4*y^2*c^3 - 224*x^4*y*c^2 - 10*x^4*c + 672*x^3*y^2*c^2 + 84*x^3*y*c + 6*x^3 + 406*x^2*y^2*c + 84*x^2*y + 70*x*y^2]

def finiteA3Right (x y c : R) : Fin 3 → R :=
  ![336*x^2*y^4*c^3 + 672*x^2*y^3*c^2 + 406*x^2*y^2*c + 70*x^2*y - 336*x*y^5*c^3 - 504*x*y^4*c^2 - 140*x*y^3*c + 28*x*y^2 + 96*y^6*c^3 + 120*y^5*c^2 + 22*y^4*c - 2*y^3,336*x^2*y^4*c^3 + 672*x^2*y^3*c^2 + 406*x^2*y^2*c + 70*x^2*y - 224*x*y^5*c^3 - 224*x*y^4*c^2 + 84*x*y^3*c + 84*x*y^2 + 48*y^6*c^3 + 32*y^5*c^2 - 10*y^4*c + 6*y^3,-560*x^3*y^3*c^3 - 840*x^3*y^2*c^2 - 350*x^3*y*c - 35*x^3 + 672*x^2*y^4*c^3 + 504*x^2*y^3*c^2 - 168*x^2*y^2*c - 105*x^2*y - 336*x*y^5*c^3 - 168*x*y^4*c^2 + 42*x*y^3*c - 21*x*y^2 + 64*y^6*c^3 + 24*y^5*c^2 - 4*y^4*c + y^3]

def finiteA3DividedMatrix (x y c : R) : Matrix (Fin 3) (Fin 3) R :=
  Matrix.of fun i j => ![finiteA3Constant x y c i,finiteA3Left x y c i,finiteA3Right x y c i] j

def finiteA3Matrix (x y c : R) : Matrix (Fin 3) (Fin 3) R :=
  finiteA3DividedMatrix x y c * Matrix.diagonal ![1,x,y]

def finiteA3RowFactor (x y : R) : Fin 3 → R := ![x-y,x,y]

@[simp] theorem finiteA3Matrix_zero (x y c : R) (i : Fin 3) :
    finiteA3Matrix x y c i 0 = finiteA3Constant x y c i := by
  simp [finiteA3Matrix,finiteA3DividedMatrix,Matrix.mul_diagonal]
@[simp] theorem finiteA3Matrix_one (x y c : R) (i : Fin 3) :
    finiteA3Matrix x y c i 1 = x*finiteA3Left x y c i := by
  simp [finiteA3Matrix,finiteA3DividedMatrix,Matrix.mul_diagonal,mul_comm]
@[simp] theorem finiteA3Matrix_two (x y c : R) (i : Fin 3) :
    finiteA3Matrix x y c i 2 = y*finiteA3Right x y c i := by
  simp [finiteA3Matrix,finiteA3DividedMatrix,Matrix.mul_diagonal,mul_comm]

set_option maxHeartbeats 12000000 in
/-- Exact determinant of the actual integral polynomial matrix. -/
theorem finiteA3DividedMatrix_det (x y c : R) :
    (finiteA3DividedMatrix x y c).det = -2450*(x*y)^0*c^1*(x-y)^11 := by
  simp [finiteA3DividedMatrix,finiteA3Constant,finiteA3Left,finiteA3Right,
    Matrix.det_succ_row_zero,Fin.sum_univ_succ,Matrix.submatrix]
  <;> ring

theorem finiteA3Matrix_det (x y c : R) :
    (finiteA3Matrix x y c).det = -2450*(x*y)^1*c^1*(x-y)^11 := by
  rw [finiteA3Matrix,Matrix.det_mul,finiteA3DividedMatrix_det,Matrix.det_diagonal]
  simp [Fin.prod_univ_succ]
  <;> ring

theorem finiteA3DividedMatrix_det_ne_zero
    {F : Type*} [Field F] [CharZero F] (x y c : F)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y) :
    (finiteA3DividedMatrix x y c).det ≠ 0 := by
  rw [finiteA3DividedMatrix_det]
  norm_num [mul_eq_zero,sub_eq_zero,hx,hy,hc,hxy]

end D1Bound5
