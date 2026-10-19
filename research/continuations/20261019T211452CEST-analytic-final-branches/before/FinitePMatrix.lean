import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum

namespace D1Bound5

variable {R : Type*} [CommRing R]

def finitePRLeftCoeff (u v : R) : Fin 3 → R :=
  ![7*u^2-35*u*v,64*u^3-140*u^2*v,72*u^4-120*u^3*v]

def finitePRRightCoeff (u v : R) : Fin 3 → R :=
  ![35*u*v-7*v^2,140*u*v^2-64*v^3,120*u*v^3-72*v^4]

def finitePTLeftCoeff (u v : R) : Fin 3 → R :=
  ![-15*u^3+56*u^2*v-105*u*v^2,
    -180*u^4+512*u^3*v-420*u^2*v^2,
    -240*u^5+576*u^4*v-360*u^3*v^2]

def finitePTRightCoeff (u v : R) : Fin 3 → R :=
  ![70*u*v^2-6*v^3,100*u*v^3-12*v^4,24*v^5]

def finitePairQuadratic (p : Fin 3 → R) (c : R) : R := p 0+p 1*c+p 2*c^2

def finitePRLeft (u v c : R) : R := finitePairQuadratic (finitePRLeftCoeff u v) c
def finitePRRight (u v c : R) : R := finitePairQuadratic (finitePRRightCoeff u v) c
def finitePTLeft (u v c : R) : R := finitePairQuadratic (finitePTLeftCoeff u v) c
def finitePTRight (u v c : R) : R := finitePairQuadratic (finitePTRightCoeff u v) c

/-- The polynomial parts of the two actual pair rows, expanded before
evaluation so integrality does not depend on anchor division. -/
def finitePRConstant (u v c : R) : R :=
  -(u-v)^3*(30+100*(u+v)*c+24*(3*u^2+4*u*v+3*v^2)*c^2)

def finitePTConstant (u v c : R) : R :=
  (u-v)^3*(15*(5*u-v)+100*u*(3*u+v)*c+
    24*(10*u^3+6*u^2*v+3*u*v^2+v^3)*c^2)

/-- Rows R_ab, H=R_ab+R_bs-R_as, T_ab, V=T_as-T_bs with the
three anchor factors removed from their root columns. -/
def finitePDividedMatrix (a b s c : R) : Matrix (Fin 4) (Fin 4) R :=
  !![finitePRConstant a b c, finitePRLeft a b c, finitePRRight a b c, 0;
    finitePRConstant a b c+finitePRConstant b s c-finitePRConstant a s c,
      finitePRLeft a b c-finitePRLeft a s c,
      finitePRRight a b c+finitePRLeft b s c,
      finitePRRight b s c-finitePRRight a s c;
    finitePTConstant a b c, finitePTLeft a b c, finitePTRight a b c, 0;
    finitePTConstant a s c-finitePTConstant b s c,
      finitePTLeft a s c, -finitePTLeft b s c,
      finitePTRight a s c-finitePTRight b s c]

def finitePMatrix (a b s c : R) : Matrix (Fin 4) (Fin 4) R :=
  finitePDividedMatrix a b s c * Matrix.diagonal ![1,a,b,s]

def finitePDetFactor (a b s c : R) : R :=
  7*(2*s-a-b)+6*c*(3*s^2-(a+b)*s-a*b)

set_option maxHeartbeats 4000000 in
/-- Exact determinant from the displayed integer polynomials. No rank
or leading-coefficient certificate is assumed. -/
theorem finitePDividedMatrix_det (a b s c : R) :
    (finitePDividedMatrix a b s c).det =
      -78750*a*b*s*(a-b)^5*(a-s)*(b-s)*finitePDetFactor a b s c := by
  simp [finitePDividedMatrix, finitePRConstant, finitePTConstant,
    finitePRLeft, finitePRRight, finitePTLeft, finitePTRight, finitePairQuadratic,
    finitePRLeftCoeff, finitePRRightCoeff, finitePTLeftCoeff, finitePTRightCoeff,
    finitePDetFactor, Matrix.det_succ_row_zero, Fin.sum_univ_succ, Matrix.submatrix]
  <;> ring

theorem finitePMatrix_det (a b s c : R) :
    (finitePMatrix a b s c).det =
      -78750*a^2*b^2*s^2*(a-b)^5*(a-s)*(b-s)*finitePDetFactor a b s c := by
  rw [finitePMatrix, Matrix.det_mul, finitePDividedMatrix_det, Matrix.det_diagonal]
  simp [Fin.prod_univ_succ]
  <;> ring

end D1Bound5
