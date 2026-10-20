import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic

namespace D1Bound5
variable {R : Type*} [CommRing R]

def finiteA4Constant (x y c : R) : Fin 3 → R :=
  ![(x-y)^7*c^1*(2560*x^3*c^3 + 5120*x^2*y*c^3 + 5760*x^2*c^2 + 5120*x*y^2*c^3 + 9216*x*y*c^2 + 4032*x*c + 2560*y^3*c^3 + 5760*y^2*c^2 + 4032*y*c + 840),(x-y)^8*c^2*(-1920*x^2*c^2 - 2560*x*y*c^2 - 2880*x*c - 1280*y^2*c^2 - 2304*y*c - 1008),(x-y)^8*c^2*(-1280*x^2*c^2 - 2560*x*y*c^2 - 2304*x*c - 1920*y^2*c^2 - 2880*y*c - 1008)]

def finiteA4Left (x y c : R) : Fin 3 → R :=
  ![-2560*x^9*c^4 + 12800*x^8*y*c^4 - 4480*x^8*c^3 - 23040*x^7*y^2*c^4 + 24704*x^7*y*c^3 - 2112*x^7*c^2 + 15360*x^6*y^3*c^4 - 50688*x^6*y^2*c^3 + 13440*x^6*y*c^2 - 184*x^6*c + 40704*x^5*y^3*c^3 - 33984*x^5*y^2*c^2 + 1448*x^5*y*c + 8*x^5 + 38016*x^4*y^3*c^2 - 5544*x^4*y^2*c - 88*x^4*y + 14520*x^3*y^3*c + 792*x^3*y^2 + 1848*x^2*y^3,1920*x^9*c^4 - 12800*x^8*y*c^4 + 1920*x^8*c^3 + 34560*x^7*y^2*c^4 - 14336*x^7*y*c^3 + 288*x^7*c^2 - 46080*x^6*y^3*c^4 + 44928*x^6*y^2*c^3 - 2496*x^6*y*c^2 - 24*x^6*c + 26880*x^5*y^4*c^4 - 73728*x^5*y^3*c^3 + 10080*x^5*y^2*c^2 + 256*x^5*y*c + 3*x^5 + 59136*x^4*y^4*c^3 - 25344*x^4*y^3*c^2 - 1584*x^4*y^2*c - 44*x^4*y + 44352*x^3*y^4*c^2 + 6336*x^3*y^3*c + 594*x^3*y^2 + 12936*x^2*y^4*c + 2772*x^2*y^3 + 1155*x*y^4,1280*x^9*c^4 - 7680*x^8*y*c^4 + 1664*x^8*c^3 + 17280*x^7*y^2*c^4 - 11712*x^7*y*c^3 + 336*x^7*c^2 - 15360*x^6*y^3*c^4 + 32832*x^6*y^2*c^3 - 3168*x^6*y*c^2 - 40*x^6*c - 40704*x^5*y^3*c^3 + 13968*x^5*y^2*c^2 + 600*x^5*y*c + 8*x^5 - 38016*x^4*y^3*c^2 - 3960*x^4*y^2*c - 264*x^4*y - 14520*x^3*y^3*c - 2376*x^3*y^2 - 1848*x^2*y^3]

def finiteA4Right (x y c : R) : Fin 3 → R :=
  ![-15360*x^3*y^6*c^4 - 40704*x^3*y^5*c^3 - 38016*x^3*y^4*c^2 - 14520*x^3*y^3*c - 1848*x^3*y^2 + 23040*x^2*y^7*c^4 + 50688*x^2*y^6*c^3 + 33984*x^2*y^5*c^2 + 5544*x^2*y^4*c - 792*x^2*y^3 - 12800*x*y^8*c^4 - 24704*x*y^7*c^3 - 13440*x*y^6*c^2 - 1448*x*y^5*c + 88*x*y^4 + 2560*y^9*c^4 + 4480*y^8*c^3 + 2112*y^7*c^2 + 184*y^6*c - 8*y^5,-15360*x^3*y^6*c^4 - 40704*x^3*y^5*c^3 - 38016*x^3*y^4*c^2 - 14520*x^3*y^3*c - 1848*x^3*y^2 + 17280*x^2*y^7*c^4 + 32832*x^2*y^6*c^3 + 13968*x^2*y^5*c^2 - 3960*x^2*y^4*c - 2376*x^2*y^3 - 7680*x*y^8*c^4 - 11712*x*y^7*c^3 - 3168*x*y^6*c^2 + 600*x*y^5*c - 264*x*y^4 + 1280*y^9*c^4 + 1664*y^8*c^3 + 336*y^7*c^2 - 40*y^6*c + 8*y^5,26880*x^4*y^5*c^4 + 59136*x^4*y^4*c^3 + 44352*x^4*y^3*c^2 + 12936*x^4*y^2*c + 1155*x^4*y - 46080*x^3*y^6*c^4 - 73728*x^3*y^5*c^3 - 25344*x^3*y^4*c^2 + 6336*x^3*y^3*c + 2772*x^3*y^2 + 34560*x^2*y^7*c^4 + 44928*x^2*y^6*c^3 + 10080*x^2*y^5*c^2 - 1584*x^2*y^4*c + 594*x^2*y^3 - 12800*x*y^8*c^4 - 14336*x*y^7*c^3 - 2496*x*y^6*c^2 + 256*x*y^5*c - 44*x*y^4 + 1920*y^9*c^4 + 1920*y^8*c^3 + 288*y^7*c^2 - 24*y^6*c + 3*y^5]

def finiteA4DividedMatrix (x y c : R) : Matrix (Fin 3) (Fin 3) R :=
  Matrix.of fun i j => ![finiteA4Constant x y c i,finiteA4Left x y c i,finiteA4Right x y c i] j

def finiteA4Matrix (x y c : R) : Matrix (Fin 3) (Fin 3) R :=
  finiteA4DividedMatrix x y c * Matrix.diagonal ![1,x,y]

def finiteA4RowFactor (x y : R) : Fin 3 → R := ![x-y,x,y]

@[simp] theorem finiteA4Matrix_zero (x y c : R) (i : Fin 3) :
    finiteA4Matrix x y c i 0 = finiteA4Constant x y c i := by
  simp [finiteA4Matrix,finiteA4DividedMatrix,Matrix.mul_diagonal]
@[simp] theorem finiteA4Matrix_one (x y c : R) (i : Fin 3) :
    finiteA4Matrix x y c i 1 = x*finiteA4Left x y c i := by
  simp [finiteA4Matrix,finiteA4DividedMatrix,Matrix.mul_diagonal,mul_comm]
@[simp] theorem finiteA4Matrix_two (x y c : R) (i : Fin 3) :
    finiteA4Matrix x y c i 2 = y*finiteA4Right x y c i := by
  simp [finiteA4Matrix,finiteA4DividedMatrix,Matrix.mul_diagonal,mul_comm]

set_option maxHeartbeats 12000000 in
/-- Exact determinant of the actual integral polynomial matrix. -/
theorem finiteA4DividedMatrix_det (x y c : R) :
    (finiteA4DividedMatrix x y c).det = 2910600*(x*y)^1*c^1*(x-y)^15 := by
  simp [finiteA4DividedMatrix,finiteA4Constant,finiteA4Left,finiteA4Right,
    Matrix.det_succ_row_zero,Fin.sum_univ_succ,Matrix.submatrix]
  <;> ring

theorem finiteA4Matrix_det (x y c : R) :
    (finiteA4Matrix x y c).det = 2910600*(x*y)^2*c^1*(x-y)^15 := by
  rw [finiteA4Matrix,Matrix.det_mul,finiteA4DividedMatrix_det,Matrix.det_diagonal]
  simp [Fin.prod_univ_succ]
  <;> ring

theorem finiteA4DividedMatrix_det_ne_zero
    {F : Type*} [Field F] [CharZero F] (x y c : F)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y) :
    (finiteA4DividedMatrix x y c).det ≠ 0 := by
  rw [finiteA4DividedMatrix_det]
  norm_num [mul_eq_zero,sub_eq_zero,hx,hy,hc,hxy]

end D1Bound5
