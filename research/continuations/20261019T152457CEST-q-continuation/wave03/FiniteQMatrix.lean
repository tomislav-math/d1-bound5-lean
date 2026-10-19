import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum

namespace D1Bound5

variable {R : Type*} [CommRing R]

set_option maxRecDepth 4096 in
/-- Sparse determinant expansion before substituting the polynomial row entries. -/
private theorem finiteQSparseMatrix_det
    (c0 l0 r0 c1 l1 r1 c2 l2 r2 c3 l3 r3 c4 l4 r4 : R) :
    (!![c0,l0,r0,0,0; c1,l1,0,r1,0; c2,0,l2,r2,0;
        c3,l3,0,0,r3; c4,0,l4,0,r4] : Matrix (Fin 5) (Fin 5) R).det =
      (r4*c3-r3*c4)*(l0*r1*l2+r0*l1*r2) +
      r3*l4*(c0*l1*r2-l0*c1*r2+l0*r1*c2) -
      r4*l3*(c0*r1*l2+r0*c1*r2-r0*r1*c2) := by
  simp [Matrix.det_succ_row_zero, Fin.sum_univ_succ, Matrix.submatrix]
  <;> ring

/-- Left divided coefficient in the manuscript's finite Q pair row. -/
def finiteQLeft (u v c : R) : R :=
  u^2-5*u*v+(4*u^3-8*u^2*v)*c

/-- Right divided coefficient in the manuscript's finite Q pair row. -/
def finiteQRight (u v c : R) : R :=
  5*u*v-v^2+(8*u*v^2-4*v^3)*c

/-- Constant coefficient in the same actual pair row. -/
def finiteQConstant (u v c : R) : R :=
  -(u-v)^3*(3+4*(u+v)*c)

/-- The five rows ab,as,bs,at,bt, with the anchor factor divided out of
each nonconstant column. All coefficients are integer polynomials. -/
def finiteQDividedMatrix (a b s t c : R) : Matrix (Fin 5) (Fin 5) R :=
  !![finiteQConstant a b c, finiteQLeft a b c, finiteQRight a b c, 0, 0;
     finiteQConstant a s c, finiteQLeft a s c, 0, finiteQRight a s c, 0;
     finiteQConstant b s c, 0, finiteQLeft b s c, finiteQRight b s c, 0;
     finiteQConstant a t c, finiteQLeft a t c, 0, 0, finiteQRight a t c;
     finiteQConstant b t c, 0, finiteQLeft b t c, 0, finiteQRight b t c]

/-- The original finite Q coefficient matrix, including the exact anchor
factor in every root column. -/
def finiteQMatrix (a b s t c : R) : Matrix (Fin 5) (Fin 5) R :=
  finiteQDividedMatrix a b s t c * Matrix.diagonal ![1, a, b, s, t]

set_option maxHeartbeats 2000000 in
/-- Exact determinant of the divided finite family. In particular all
dependence on c cancels; this is checked by polynomial identities. -/
theorem finiteQDividedMatrix_det (a b s t c : R) :
    (finiteQDividedMatrix a b s t c).det =
      180*a*b*s*t*(a-b)^2*(a-s)*(a-t)*(b-s)*(b-t)*(s-t) := by
  rw [finiteQDividedMatrix, finiteQSparseMatrix_det]
  unfold finiteQConstant finiteQLeft finiteQRight
  ring

/-- The determinant stated for the full finite Q family follows by the
explicit column factors; no determinant certificate is an input. -/
theorem finiteQMatrix_det (a b s t c : R) :
    (finiteQMatrix a b s t c).det =
      180*a^2*b^2*s^2*t^2*(a-b)^2*(a-s)*(a-t)*(b-s)*(b-t)*(s-t) := by
  rw [finiteQMatrix, Matrix.det_mul, finiteQDividedMatrix_det, Matrix.det_diagonal]
  simp [Fin.prod_univ_succ]
  <;> ring

theorem finiteQDividedMatrix_det_ne_zero
    {F : Type*} [Field F] [CharZero F] (a b s t c : F)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0) (ht : t ≠ 0)
    (hab : a ≠ b) (has : a ≠ s) (hat : a ≠ t)
    (hbs : b ≠ s) (hbt : b ≠ t) (hst : s ≠ t) :
    (finiteQDividedMatrix a b s t c).det ≠ 0 := by
  rw [finiteQDividedMatrix_det]
  norm_num [mul_eq_zero, sub_eq_zero, ha, hb, hs, ht, hab, has, hat, hbs, hbt, hst]

end D1Bound5
