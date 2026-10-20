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

/-- Expansion on the sparse last column leaves exactly two minors. -/
private theorem finiteP_sparse_column_det (M : Matrix (Fin 4) (Fin 4) R)
    (h0 : M 0 3 = 0) (h2 : M 2 3 = 0) :
    M.det =
      M 1 3 * (M.submatrix (1 : Fin 4).succAbove (3 : Fin 4).succAbove).det +
      M 3 3 * (M.submatrix (3 : Fin 4).succAbove (3 : Fin 4).succAbove).det := by
  rw [Matrix.det_succ_column M 3]
  norm_num [Fin.sum_univ_succ, h0, h2]
  rfl

set_option maxHeartbeats 4000000 in
/-- Exact determinant from the displayed integer polynomials. No rank
or leading-coefficient certificate is assumed. -/
theorem finitePDividedMatrix_det (a b s c : R) :
    (finitePDividedMatrix a b s c).det =
      -78750*a*b*s*(a-b)^5*(a-s)*(b-s)*finitePDetFactor a b s c := by
  have h1 : ((finitePDividedMatrix a b s c).submatrix
      (1 : Fin 4).succAbove (3 : Fin 4).succAbove).det = (-750*a*b*(a-b)^4*(3840*a^2*b^2*c^5*s^4 + 4608*a^2*b^2*c^4*s^3 + 864*a^2*b^2*c^3*s^2 - 96*a^2*b^2*c^2*s + 18*a^2*b^2*c + 4480*a^2*b*c^4*s^4 + 5376*a^2*b*c^3*s^3 + 1008*a^2*b*c^2*s^2 - 112*a^2*b*c*s + 21*a^2*b + 1120*a^2*c^3*s^4 + 1344*a^2*c^2*s^3 + 252*a^2*c*s^2 - 28*a^2*s + 4480*a*b^2*c^4*s^4 + 5376*a*b^2*c^3*s^3 + 1008*a*b^2*c^2*s^2 - 112*a*b^2*c*s + 21*a*b^2 + 4480*a*b*c^3*s^4 + 5376*a*b*c^2*s^3 + 1008*a*b*c*s^2 - 112*a*b*s + 840*a*c^2*s^4 + 1008*a*c*s^3 + 189*a*s^2 + 1120*b^2*c^3*s^4 + 1344*b^2*c^2*s^3 + 252*b^2*c*s^2 - 28*b^2*s + 840*b*c^2*s^4 + 1008*b*c*s^3 + 189*b*s^2 + 70*c*s^4 + 84*s^3)) := by
    rw [Matrix.det_fin_three]
    change (-(a-b)^3*(30+100*(a+b)*c+24*(3*a^2+4*a*b+3*b^2)*c^2))*((-15*a^3+56*a^2*b-105*a*b^2)+(-180*a^4+512*a^3*b-420*a^2*b^2)*c+(-240*a^5+576*a^4*b-360*a^3*b^2)*c^2)*(-((-15*b^3+56*b^2*s-105*b*s^2)+(-180*b^4+512*b^3*s-420*b^2*s^2)*c+(-240*b^5+576*b^4*s-360*b^3*s^2)*c^2)) - (-(a-b)^3*(30+100*(a+b)*c+24*(3*a^2+4*a*b+3*b^2)*c^2))*((70*a*b^2-6*b^3)+(100*a*b^3-12*b^4)*c+(24*b^5)*c^2)*((-15*a^3+56*a^2*s-105*a*s^2)+(-180*a^4+512*a^3*s-420*a^2*s^2)*c+(-240*a^5+576*a^4*s-360*a^3*s^2)*c^2) - ((7*a^2-35*a*b)+(64*a^3-140*a^2*b)*c+(72*a^4-120*a^3*b)*c^2)*((a-b)^3*(15*(5*a-b)+100*a*(3*a+b)*c+24*(10*a^3+6*a^2*b+3*a*b^2+b^3)*c^2))*(-((-15*b^3+56*b^2*s-105*b*s^2)+(-180*b^4+512*b^3*s-420*b^2*s^2)*c+(-240*b^5+576*b^4*s-360*b^3*s^2)*c^2)) + ((7*a^2-35*a*b)+(64*a^3-140*a^2*b)*c+(72*a^4-120*a^3*b)*c^2)*((70*a*b^2-6*b^3)+(100*a*b^3-12*b^4)*c+(24*b^5)*c^2)*(((a-s)^3*(15*(5*a-s)+100*a*(3*a+s)*c+24*(10*a^3+6*a^2*s+3*a*s^2+s^3)*c^2))-((b-s)^3*(15*(5*b-s)+100*b*(3*b+s)*c+24*(10*b^3+6*b^2*s+3*b*s^2+s^3)*c^2))) + ((35*a*b-7*b^2)+(140*a*b^2-64*b^3)*c+(120*a*b^3-72*b^4)*c^2)*((a-b)^3*(15*(5*a-b)+100*a*(3*a+b)*c+24*(10*a^3+6*a^2*b+3*a*b^2+b^3)*c^2))*((-15*a^3+56*a^2*s-105*a*s^2)+(-180*a^4+512*a^3*s-420*a^2*s^2)*c+(-240*a^5+576*a^4*s-360*a^3*s^2)*c^2) - ((35*a*b-7*b^2)+(140*a*b^2-64*b^3)*c+(120*a*b^3-72*b^4)*c^2)*((-15*a^3+56*a^2*b-105*a*b^2)+(-180*a^4+512*a^3*b-420*a^2*b^2)*c+(-240*a^5+576*a^4*b-360*a^3*b^2)*c^2)*(((a-s)^3*(15*(5*a-s)+100*a*(3*a+s)*c+24*(10*a^3+6*a^2*s+3*a*s^2+s^3)*c^2))-((b-s)^3*(15*(5*b-s)+100*b*(3*b+s)*c+24*(10*b^3+6*b^2*s+3*b*s^2+s^3)*c^2))) = _
    ring
  have h3 : ((finitePDividedMatrix a b s c).submatrix
      (3 : Fin 4).succAbove (3 : Fin 4).succAbove).det = (-375*a*b*(a-b)^4*(9216*a^2*b^2*c^6*s^4 + 15360*a^2*b^2*c^5*s^3 + 6912*a^2*b^2*c^4*s^2 + 576*a^2*b^2*c^3*s - 24*a^2*b^2*c^2 + 10752*a^2*b*c^5*s^4 + 17920*a^2*b*c^4*s^3 + 8064*a^2*b*c^3*s^2 + 672*a^2*b*c^2*s - 28*a^2*b*c + 2688*a^2*c^4*s^4 + 4480*a^2*c^3*s^3 + 2016*a^2*c^2*s^2 + 168*a^2*c*s - 7*a^2 + 10752*a*b^2*c^5*s^4 + 17920*a*b^2*c^4*s^3 + 8064*a*b^2*c^3*s^2 + 672*a*b^2*c^2*s - 28*a*b^2*c + 10752*a*b*c^4*s^4 + 17920*a*b*c^3*s^3 + 8064*a*b*c^2*s^2 + 672*a*b*c*s - 28*a*b + 2016*a*c^3*s^4 + 3360*a*c^2*s^3 + 1512*a*c*s^2 + 126*a*s + 2688*b^2*c^4*s^4 + 4480*b^2*c^3*s^3 + 2016*b^2*c^2*s^2 + 168*b^2*c*s - 7*b^2 + 2016*b*c^3*s^4 + 3360*b*c^2*s^3 + 1512*b*c*s^2 + 126*b*s + 168*c^2*s^4 + 280*c*s^3 + 126*s^2)) := by
    rw [Matrix.det_fin_three]
    change (-(a-b)^3*(30+100*(a+b)*c+24*(3*a^2+4*a*b+3*b^2)*c^2))*(((7*a^2-35*a*b)+(64*a^3-140*a^2*b)*c+(72*a^4-120*a^3*b)*c^2)-((7*a^2-35*a*s)+(64*a^3-140*a^2*s)*c+(72*a^4-120*a^3*s)*c^2))*((70*a*b^2-6*b^3)+(100*a*b^3-12*b^4)*c+(24*b^5)*c^2) - (-(a-b)^3*(30+100*(a+b)*c+24*(3*a^2+4*a*b+3*b^2)*c^2))*(((35*a*b-7*b^2)+(140*a*b^2-64*b^3)*c+(120*a*b^3-72*b^4)*c^2)+((7*b^2-35*b*s)+(64*b^3-140*b^2*s)*c+(72*b^4-120*b^3*s)*c^2))*((-15*a^3+56*a^2*b-105*a*b^2)+(-180*a^4+512*a^3*b-420*a^2*b^2)*c+(-240*a^5+576*a^4*b-360*a^3*b^2)*c^2) - ((7*a^2-35*a*b)+(64*a^3-140*a^2*b)*c+(72*a^4-120*a^3*b)*c^2)*((-(a-b)^3*(30+100*(a+b)*c+24*(3*a^2+4*a*b+3*b^2)*c^2))+(-(b-s)^3*(30+100*(b+s)*c+24*(3*b^2+4*b*s+3*s^2)*c^2))-(-(a-s)^3*(30+100*(a+s)*c+24*(3*a^2+4*a*s+3*s^2)*c^2)))*((70*a*b^2-6*b^3)+(100*a*b^3-12*b^4)*c+(24*b^5)*c^2) + ((7*a^2-35*a*b)+(64*a^3-140*a^2*b)*c+(72*a^4-120*a^3*b)*c^2)*(((35*a*b-7*b^2)+(140*a*b^2-64*b^3)*c+(120*a*b^3-72*b^4)*c^2)+((7*b^2-35*b*s)+(64*b^3-140*b^2*s)*c+(72*b^4-120*b^3*s)*c^2))*((a-b)^3*(15*(5*a-b)+100*a*(3*a+b)*c+24*(10*a^3+6*a^2*b+3*a*b^2+b^3)*c^2)) + ((35*a*b-7*b^2)+(140*a*b^2-64*b^3)*c+(120*a*b^3-72*b^4)*c^2)*((-(a-b)^3*(30+100*(a+b)*c+24*(3*a^2+4*a*b+3*b^2)*c^2))+(-(b-s)^3*(30+100*(b+s)*c+24*(3*b^2+4*b*s+3*s^2)*c^2))-(-(a-s)^3*(30+100*(a+s)*c+24*(3*a^2+4*a*s+3*s^2)*c^2)))*((-15*a^3+56*a^2*b-105*a*b^2)+(-180*a^4+512*a^3*b-420*a^2*b^2)*c+(-240*a^5+576*a^4*b-360*a^3*b^2)*c^2) - ((35*a*b-7*b^2)+(140*a*b^2-64*b^3)*c+(120*a*b^3-72*b^4)*c^2)*(((7*a^2-35*a*b)+(64*a^3-140*a^2*b)*c+(72*a^4-120*a^3*b)*c^2)-((7*a^2-35*a*s)+(64*a^3-140*a^2*s)*c+(72*a^4-120*a^3*s)*c^2))*((a-b)^3*(15*(5*a-b)+100*a*(3*a+b)*c+24*(10*a^3+6*a^2*b+3*a*b^2+b^3)*c^2)) = _
    ring
  rw [finiteP_sparse_column_det _ (by rfl) (by rfl), h1, h3]
  change (((35*b*s-7*s^2)+(140*b*s^2-64*s^3)*c+(120*b*s^3-72*s^4)*c^2)-((35*a*s-7*s^2)+(140*a*s^2-64*s^3)*c+(120*a*s^3-72*s^4)*c^2))*(-750*a*b*(a-b)^4*(3840*a^2*b^2*c^5*s^4 + 4608*a^2*b^2*c^4*s^3 + 864*a^2*b^2*c^3*s^2 - 96*a^2*b^2*c^2*s + 18*a^2*b^2*c + 4480*a^2*b*c^4*s^4 + 5376*a^2*b*c^3*s^3 + 1008*a^2*b*c^2*s^2 - 112*a^2*b*c*s + 21*a^2*b + 1120*a^2*c^3*s^4 + 1344*a^2*c^2*s^3 + 252*a^2*c*s^2 - 28*a^2*s + 4480*a*b^2*c^4*s^4 + 5376*a*b^2*c^3*s^3 + 1008*a*b^2*c^2*s^2 - 112*a*b^2*c*s + 21*a*b^2 + 4480*a*b*c^3*s^4 + 5376*a*b*c^2*s^3 + 1008*a*b*c*s^2 - 112*a*b*s + 840*a*c^2*s^4 + 1008*a*c*s^3 + 189*a*s^2 + 1120*b^2*c^3*s^4 + 1344*b^2*c^2*s^3 + 252*b^2*c*s^2 - 28*b^2*s + 840*b*c^2*s^4 + 1008*b*c*s^3 + 189*b*s^2 + 70*c*s^4 + 84*s^3))+(((70*a*s^2-6*s^3)+(100*a*s^3-12*s^4)*c+(24*s^5)*c^2)-((70*b*s^2-6*s^3)+(100*b*s^3-12*s^4)*c+(24*s^5)*c^2))*(-375*a*b*(a-b)^4*(9216*a^2*b^2*c^6*s^4 + 15360*a^2*b^2*c^5*s^3 + 6912*a^2*b^2*c^4*s^2 + 576*a^2*b^2*c^3*s - 24*a^2*b^2*c^2 + 10752*a^2*b*c^5*s^4 + 17920*a^2*b*c^4*s^3 + 8064*a^2*b*c^3*s^2 + 672*a^2*b*c^2*s - 28*a^2*b*c + 2688*a^2*c^4*s^4 + 4480*a^2*c^3*s^3 + 2016*a^2*c^2*s^2 + 168*a^2*c*s - 7*a^2 + 10752*a*b^2*c^5*s^4 + 17920*a*b^2*c^4*s^3 + 8064*a*b^2*c^3*s^2 + 672*a*b^2*c^2*s - 28*a*b^2*c + 10752*a*b*c^4*s^4 + 17920*a*b*c^3*s^3 + 8064*a*b*c^2*s^2 + 672*a*b*c*s - 28*a*b + 2016*a*c^3*s^4 + 3360*a*c^2*s^3 + 1512*a*c*s^2 + 126*a*s + 2688*b^2*c^4*s^4 + 4480*b^2*c^3*s^3 + 2016*b^2*c^2*s^2 + 168*b^2*c*s - 7*b^2 + 2016*b*c^3*s^4 + 3360*b*c^2*s^3 + 1512*b*c*s^2 + 126*b*s + 168*c^2*s^4 + 280*c*s^3 + 126*s^2)) =
    -78750*a*b*s*(a-b)^5*(a-s)*(b-s)*(7*(2*s-a-b)+6*c*(3*s^2-(a+b)*s-a*b))
  ring

theorem finitePMatrix_det (a b s c : R) :
    (finitePMatrix a b s c).det =
      -78750*a^2*b^2*s^2*(a-b)^5*(a-s)*(b-s)*finitePDetFactor a b s c := by
  rw [finitePMatrix, Matrix.det_mul, finitePDividedMatrix_det, Matrix.det_diagonal]
  simp [Fin.prod_univ_succ]
  <;> ring

end D1Bound5
