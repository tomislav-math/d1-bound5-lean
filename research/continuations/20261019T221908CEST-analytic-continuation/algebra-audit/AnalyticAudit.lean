import D1Bound5.FiniteHomogeneousTwo
import D1Bound5.FiniteN2Matrix
import D1Bound5.FiniteN2Height
import D1Bound5.FiniteN2IntegralRows
import D1Bound5.FiniteN2BennettIdentity
import D1Bound5.FiniteN3Matrix
import D1Bound5.FiniteN3Height
import D1Bound5.FiniteN3IntegralRows
import Lean.Elab.Command
import Lean.Util.CollectAxioms
open Lean Elab Command
open scoped NumberField
open Module
set_option maxRecDepth 32768
run_cmd do
  let names : List Name := [
    `D1Bound5.finiteHomogeneousTwo,
    `D1Bound5.finiteHomogeneousTwo_norm_le,
    `D1Bound5.finite_norm_quadratic_le,
    `D1Bound5.finiteN2Constant,
    `D1Bound5.finiteN2Left,
    `D1Bound5.finiteN2Right,
    `D1Bound5.finiteN2DividedMatrix,
    `D1Bound5.finiteN2Matrix,
    `D1Bound5.finiteN2RowFactor,
    `D1Bound5.finiteN2Matrix_zero,
    `D1Bound5.finiteN2Matrix_one,
    `D1Bound5.finiteN2Matrix_two,
    `D1Bound5.finiteN2DividedMatrix_det,
    `D1Bound5.finiteN2Matrix_det,
    `D1Bound5.finiteN2DividedMatrix_det_ne_zero,
    `D1Bound5.finiteN2Coeff0,
    `D1Bound5.finiteN2Coeff1,
    `D1Bound5.finiteN2Coeff2,
    `D1Bound5.finiteN2_root_coeff_decomposition,
    `D1Bound5.finiteN2_coefficient_sums,
    `D1Bound5.finiteN2_root_columns_norm_le,
    `D1Bound5.finiteN2_height_scalar,
    `D1Bound5.finiteN2_height_scaled,
    `D1Bound5.map_finiteN2Constant,
    `D1Bound5.map_finiteN2Left,
    `D1Bound5.map_finiteN2Right,
    `D1Bound5.map_finiteN2DividedMatrix,
    `D1Bound5.finiteN2RowForm,
    `D1Bound5.map_finiteN2RowForm,
    `D1Bound5.finiteN2RowForm_exists_ne_zero,
    `D1Bound5.full_ring_finiteN2RowForm_exists_one_le_norm,
    `D1Bound5.finite_choose_two,
    `D1Bound5.finiteN2_bennett_identity,
    `D1Bound5.finiteN3Constant,
    `D1Bound5.finiteN3Left,
    `D1Bound5.finiteN3Right,
    `D1Bound5.finiteN3DividedMatrix,
    `D1Bound5.finiteN3Matrix,
    `D1Bound5.finiteN3RowFactor,
    `D1Bound5.finiteN3Matrix_zero,
    `D1Bound5.finiteN3Matrix_one,
    `D1Bound5.finiteN3Matrix_two,
    `D1Bound5.finiteN3DividedMatrix_det,
    `D1Bound5.finiteN3Matrix_det,
    `D1Bound5.finiteN3DividedMatrix_det_ne_zero,
    `D1Bound5.finiteN3Coeff0,
    `D1Bound5.finiteN3Coeff1,
    `D1Bound5.finiteN3Coeff2,
    `D1Bound5.finiteN3Coeff3,
    `D1Bound5.finite_norm_cubic_le,
    `D1Bound5.finiteN3_root_coeff_decomposition,
    `D1Bound5.finiteN3_coefficient_sums,
    `D1Bound5.finiteN3_root_columns_norm_le,
    `D1Bound5.finiteN3_height_scalar,
    `D1Bound5.finiteN3_height_scaled,
    `D1Bound5.map_finiteN3Constant,
    `D1Bound5.map_finiteN3Left,
    `D1Bound5.map_finiteN3Right,
    `D1Bound5.map_finiteN3DividedMatrix,
    `D1Bound5.finiteN3RowForm,
    `D1Bound5.map_finiteN3RowForm,
    `D1Bound5.finiteN3RowForm_exists_ne_zero,
    `D1Bound5.full_ring_finiteN3RowForm_exists_one_le_norm]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.finiteHomogeneousTwo
#check @D1Bound5.finiteHomogeneousTwo_norm_le
#check @D1Bound5.finite_norm_quadratic_le
#check @D1Bound5.finiteN2Constant
#check @D1Bound5.finiteN2Left
#check @D1Bound5.finiteN2Right
#check @D1Bound5.finiteN2DividedMatrix
#check @D1Bound5.finiteN2Matrix
#check @D1Bound5.finiteN2RowFactor
#check @D1Bound5.finiteN2Matrix_zero
#check @D1Bound5.finiteN2Matrix_one
#check @D1Bound5.finiteN2Matrix_two
#check @D1Bound5.finiteN2DividedMatrix_det
#check @D1Bound5.finiteN2Matrix_det
#check @D1Bound5.finiteN2DividedMatrix_det_ne_zero
#check @D1Bound5.finiteN2Coeff0
#check @D1Bound5.finiteN2Coeff1
#check @D1Bound5.finiteN2Coeff2
#check @D1Bound5.finiteN2_root_coeff_decomposition
#check @D1Bound5.finiteN2_coefficient_sums
#check @D1Bound5.finiteN2_root_columns_norm_le
#check @D1Bound5.finiteN2_height_scalar
#check @D1Bound5.finiteN2_height_scaled
#check @D1Bound5.map_finiteN2Constant
#check @D1Bound5.map_finiteN2Left
#check @D1Bound5.map_finiteN2Right
#check @D1Bound5.map_finiteN2DividedMatrix
#check @D1Bound5.finiteN2RowForm
#check @D1Bound5.map_finiteN2RowForm
#check @D1Bound5.finiteN2RowForm_exists_ne_zero
#check @D1Bound5.full_ring_finiteN2RowForm_exists_one_le_norm
#check @D1Bound5.finite_choose_two
#check @D1Bound5.finiteN2_bennett_identity
#check @D1Bound5.finiteN3Constant
#check @D1Bound5.finiteN3Left
#check @D1Bound5.finiteN3Right
#check @D1Bound5.finiteN3DividedMatrix
#check @D1Bound5.finiteN3Matrix
#check @D1Bound5.finiteN3RowFactor
#check @D1Bound5.finiteN3Matrix_zero
#check @D1Bound5.finiteN3Matrix_one
#check @D1Bound5.finiteN3Matrix_two
#check @D1Bound5.finiteN3DividedMatrix_det
#check @D1Bound5.finiteN3Matrix_det
#check @D1Bound5.finiteN3DividedMatrix_det_ne_zero
#check @D1Bound5.finiteN3Coeff0
#check @D1Bound5.finiteN3Coeff1
#check @D1Bound5.finiteN3Coeff2
#check @D1Bound5.finiteN3Coeff3
#check @D1Bound5.finite_norm_cubic_le
#check @D1Bound5.finiteN3_root_coeff_decomposition
#check @D1Bound5.finiteN3_coefficient_sums
#check @D1Bound5.finiteN3_root_columns_norm_le
#check @D1Bound5.finiteN3_height_scalar
#check @D1Bound5.finiteN3_height_scaled
#check @D1Bound5.map_finiteN3Constant
#check @D1Bound5.map_finiteN3Left
#check @D1Bound5.map_finiteN3Right
#check @D1Bound5.map_finiteN3DividedMatrix
#check @D1Bound5.finiteN3RowForm
#check @D1Bound5.map_finiteN3RowForm
#check @D1Bound5.finiteN3RowForm_exists_ne_zero
#check @D1Bound5.full_ring_finiteN3RowForm_exists_one_le_norm

open Finset Polynomial
namespace D1Bound5
section


example (n : ℕ) (v : Fin (n+1) → ℤ)
    (x y : ℂ) (hxy : ‖x‖ ≤ ‖y‖) :
    ‖finiteHomogeneousTwo n v x y‖ ≤
      (∑ j, |(v j : ℝ)|)*‖y‖^n := by
  exact finiteHomogeneousTwo_norm_le n v x y hxy

example (u v w c : ℂ) :
    ‖u+v*c+w*c^2‖ ≤ ‖u‖+‖v‖*‖c‖+‖w‖*‖c‖^2 := by
  exact finite_norm_quadratic_le u v w c

end

section
variable {R : Type*} [CommRing R]

example (x y c : R) (i : Fin 3) :
    finiteN2Matrix x y c i 0 = finiteN2Constant x y c i := by
  exact finiteN2Matrix_zero x y c i

example (x y c : R) (i : Fin 3) :
    finiteN2Matrix x y c i 1 = x * finiteN2Left x y c i := by
  exact finiteN2Matrix_one x y c i

example (x y c : R) (i : Fin 3) :
    finiteN2Matrix x y c i 2 = y * finiteN2Right x y c i := by
  exact finiteN2Matrix_two x y c i

example (x y c : R) :
    (finiteN2DividedMatrix x y c).det = -225*(x-y)^7 := by
  exact finiteN2DividedMatrix_det x y c

example (x y c : R) :
    (finiteN2Matrix x y c).det = -225*x*y*(x-y)^7 := by
  exact finiteN2Matrix_det x y c

example
    {F : Type*} [Field F] [CharZero F] (x y c : F) (hxy : x ≠ y) :
    (finiteN2DividedMatrix x y c).det ≠ 0 := by
  exact finiteN2DividedMatrix_det_ne_zero x y c hxy

end

section


example {R : Type*} [CommRing R]
    (x y c : R) (i : Fin 3) (j : Fin 2) :
    ![finiteN2Left x y c i, finiteN2Right x y c i] j =
      finiteHomogeneousTwo 2 (finiteN2Coeff0 i j) x y +
      finiteHomogeneousTwo 3 (finiteN2Coeff1 i j) x y*c +
      finiteHomogeneousTwo 4 (finiteN2Coeff2 i j) x y*c^2 := by
  exact finiteN2_root_coeff_decomposition x y c i j

example (i : Fin 3) :
    ((∑ j, |(finiteN2Coeff0 i 0 j : ℝ)|) +
      (∑ j, |(finiteN2Coeff0 i 1 j : ℝ)|) ≤ 50) ∧
    ((∑ j, |(finiteN2Coeff1 i 0 j : ℝ)|) +
      (∑ j, |(finiteN2Coeff1 i 1 j : ℝ)|) ≤ 200) ∧
    ((∑ j, |(finiteN2Coeff2 i 0 j : ℝ)|) +
      (∑ j, |(finiteN2Coeff2 i 1 j : ℝ)|) ≤ 240) := by
  exact finiteN2_coefficient_sums i

example (x y c : ℂ) (hxy : ‖x‖ ≤ ‖y‖) (i : Fin 3) :
    ‖finiteN2Left x y c i‖+‖finiteN2Right x y c i‖ ≤
      50*‖y‖^2+200*‖y‖^3*‖c‖+240*‖y‖^4*‖c‖^2 := by
  exact finiteN2_root_columns_norm_le x y c hxy i

example (T : ℝ) (hT : 1000 ≤ T) :
    (101/100 : ℝ)*(50+200*T+240*T^2) < 243*T^2 := by
  exact finiteN2_height_scalar T hT

example (x y c : ℂ) (hy : y ≠ 0)
    (hxy : ‖x‖ ≤ ‖y‖) (hYC : 1000 ≤ ‖y‖*‖c‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteN2Left x y c i‖+‖finiteN2Right x y c i‖) <
      243*‖y‖^4*‖c‖^2 := by
  exact finiteN2_height_scaled x y c hy hxy hYC i

end

section
variable {R S : Type*} [CommRing R] [CommRing S]

example (f : R →+* S) (x y c : R) (i : Fin 3) :
    f (finiteN2Constant x y c i) = finiteN2Constant (f x) (f y) (f c) i := by
  exact map_finiteN2Constant f x y c i

example (f : R →+* S) (x y c : R) (i : Fin 3) :
    f (finiteN2Left x y c i) = finiteN2Left (f x) (f y) (f c) i := by
  exact map_finiteN2Left f x y c i

example (f : R →+* S) (x y c : R) (i : Fin 3) :
    f (finiteN2Right x y c i) = finiteN2Right (f x) (f y) (f c) i := by
  exact map_finiteN2Right f x y c i

example (f : R →+* S)
    (x y c : R) (i j : Fin 3) :
    f (finiteN2DividedMatrix x y c i j) =
      finiteN2DividedMatrix (f x) (f y) (f c) i j := by
  exact map_finiteN2DividedMatrix f x y c i j

example (f : R →+* S)
    (x y c z sX sY : R) (i : Fin 3) :
    f (finiteN2RowForm x y c z sX sY i) =
      finiteN2RowForm (f x) (f y) (f c) (f z) (f sX) (f sY) i := by
  exact map_finiteN2RowForm f x y c z sX sY i

example
    {F : Type*} [Field F] [CharZero F]
    (x y c z sX sY : F) (hxy : x ≠ y) (hz : z ≠ 0) :
    ∃ i : Fin 3, finiteN2RowForm x y c z sX sY i ≠ 0 := by
  exact finiteN2RowForm_exists_ne_zero x y c z sX sY hxy hz

example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (x y c z sX sY : 𝓞 K) (hxy : x ≠ y) (hz : z ≠ 0) :
    ∃ i : Fin 3, 1 ≤ ‖finiteN2RowForm (phi (x : K)) (phi (y : K))
      (phi (c : K)) (phi (z : K)) (phi (sX : K)) (phi (sY : K)) i‖ := by
  exact full_ring_finiteN2RowForm_exists_one_le_norm hK phi x y c z sX sY hxy hz

end

section
variable {F : Type*} [Field F] [CharZero F]

example (r : F) : Ring.choose r 2 = r*(r-1)/2 := by
  exact finite_choose_two r

example (x y c : F)
    (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i j : Fin 3) :
    bennettTwoClearedEntry x y c 2 i j =
      2 * finiteN2RowFactor x y i * finiteN2Matrix x y c i j := by
  exact finiteN2_bennett_identity x y c hx hy hxy i j

end

section
variable {R : Type*} [CommRing R]

example (x y c : R) (i : Fin 3) :
    finiteN3Matrix x y c i 0 = finiteN3Constant x y c i := by
  exact finiteN3Matrix_zero x y c i

example (x y c : R) (i : Fin 3) :
    finiteN3Matrix x y c i 1 = x * finiteN3Left x y c i := by
  exact finiteN3Matrix_one x y c i

example (x y c : R) (i : Fin 3) :
    finiteN3Matrix x y c i 2 = y * finiteN3Right x y c i := by
  exact finiteN3Matrix_two x y c i

example (x y c : R) :
    (finiteN3DividedMatrix x y c).det = 3675*x*y*(x-y)^11 := by
  exact finiteN3DividedMatrix_det x y c

example (x y c : R) :
    (finiteN3Matrix x y c).det = 3675*x^2*y^2*(x-y)^11 := by
  exact finiteN3Matrix_det x y c

example
    {F : Type*} [Field F] [CharZero F] (x y c : F) (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) :
    (finiteN3DividedMatrix x y c).det ≠ 0 := by
  exact finiteN3DividedMatrix_det_ne_zero x y c hx hy hxy

end

section


example (u v w t c : ℂ) :
    ‖u+v*c+w*c^2+t*c^3‖ ≤
      ‖u‖+‖v‖*‖c‖+‖w‖*‖c‖^2+‖t‖*‖c‖^3 := by
  exact finite_norm_cubic_le u v w t c

example {R : Type*} [CommRing R]
    (x y c : R) (i : Fin 3) (j : Fin 2) :
    ![finiteN3Left x y c i,finiteN3Right x y c i] j =
      finiteHomogeneousTwo 4 (finiteN3Coeff0 i j) x y +
      finiteHomogeneousTwo 5 (finiteN3Coeff1 i j) x y*c +
      finiteHomogeneousTwo 6 (finiteN3Coeff2 i j) x y*c^2 +
      finiteHomogeneousTwo 7 (finiteN3Coeff3 i j) x y*c^3 := by
  exact finiteN3_root_coeff_decomposition x y c i j

example (i : Fin 3) :
    ((∑ j, |(finiteN3Coeff0 i 0 j : ℝ)|)+
      (∑ j, |(finiteN3Coeff0 i 1 j : ℝ)|) ≤ 342) ∧
    ((∑ j, |(finiteN3Coeff1 i 0 j : ℝ)|)+
      (∑ j, |(finiteN3Coeff1 i 1 j : ℝ)|) ≤ 2352) ∧
    ((∑ j, |(finiteN3Coeff2 i 0 j : ℝ)|)+
      (∑ j, |(finiteN3Coeff2 i 1 j : ℝ)|) ≤ 5792) ∧
    ((∑ j, |(finiteN3Coeff3 i 0 j : ℝ)|)+
      (∑ j, |(finiteN3Coeff3 i 1 j : ℝ)|) ≤ 4096) := by
  exact finiteN3_coefficient_sums i

example (x y c : ℂ) (hxy : ‖x‖ ≤ ‖y‖) (i : Fin 3) :
    ‖finiteN3Left x y c i‖+‖finiteN3Right x y c i‖ ≤
      342*‖y‖^4+2352*‖y‖^5*‖c‖+5792*‖y‖^6*‖c‖^2+4096*‖y‖^7*‖c‖^3 := by
  exact finiteN3_root_columns_norm_le x y c hxy i

example (T : ℝ) (hT : 1000 ≤ T) :
    (101/100 : ℝ)*(342+2352*T+5792*T^2+4096*T^3) < 4143*T^3 := by
  exact finiteN3_height_scalar T hT

example (x y c : ℂ) (hy : y ≠ 0)
    (hxy : ‖x‖ ≤ ‖y‖) (hYC : 1000 ≤ ‖y‖*‖c‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteN3Left x y c i‖+‖finiteN3Right x y c i‖) <
      4143*‖y‖^7*‖c‖^3 := by
  exact finiteN3_height_scaled x y c hy hxy hYC i

end

section
variable {R S : Type*} [CommRing R] [CommRing S]

example (f : R →+* S) (x y c : R) (i : Fin 3) :
    f (finiteN3Constant x y c i) = finiteN3Constant (f x) (f y) (f c) i := by
  exact map_finiteN3Constant f x y c i

example (f : R →+* S) (x y c : R) (i : Fin 3) :
    f (finiteN3Left x y c i) = finiteN3Left (f x) (f y) (f c) i := by
  exact map_finiteN3Left f x y c i

example (f : R →+* S) (x y c : R) (i : Fin 3) :
    f (finiteN3Right x y c i) = finiteN3Right (f x) (f y) (f c) i := by
  exact map_finiteN3Right f x y c i

example (f : R →+* S)
    (x y c : R) (i j : Fin 3) :
    f (finiteN3DividedMatrix x y c i j) =
      finiteN3DividedMatrix (f x) (f y) (f c) i j := by
  exact map_finiteN3DividedMatrix f x y c i j

example (f : R →+* S)
    (x y c z sX sY : R) (i : Fin 3) :
    f (finiteN3RowForm x y c z sX sY i) =
      finiteN3RowForm (f x) (f y) (f c) (f z) (f sX) (f sY) i := by
  exact map_finiteN3RowForm f x y c z sX sY i

example
    {F : Type*} [Field F] [CharZero F]
    (x y c z sX sY : F) (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (hz : z ≠ 0) :
    ∃ i : Fin 3, finiteN3RowForm x y c z sX sY i ≠ 0 := by
  exact finiteN3RowForm_exists_ne_zero x y c z sX sY hx hy hxy hz

example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (x y c z sX sY : 𝓞 K) (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (hz : z ≠ 0) :
    ∃ i : Fin 3, 1 ≤ ‖finiteN3RowForm (phi (x : K)) (phi (y : K))
      (phi (c : K)) (phi (z : K)) (phi (sX : K)) (phi (sY : K)) i‖ := by
  exact full_ring_finiteN3RowForm_exists_one_le_norm hK phi x y c z sX sY hx hy hxy hz

end

end D1Bound5
