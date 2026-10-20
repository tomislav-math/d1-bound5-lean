import D1Bound5.FiniteA5Matrix
import D1Bound5.FiniteA5Coefficients
import D1Bound5.FiniteA5IntegralRows
import D1Bound5.FiniteA5Height
import D1Bound5.FiniteA5ResidueRow0
import D1Bound5.FiniteA5ResidueRow1
import D1Bound5.FiniteA5ResidueRow2
import D1Bound5.FiniteA5ResidueIdentity
import D1Bound5.FiniteA5Residual
import D1Bound5.FiniteA5Approximation
import D1Bound5.FiniteA5Interval
import Lean.Elab.Command
import Lean.Util.CollectAxioms
open Lean Elab Command
open scoped NumberField
open Module
set_option maxRecDepth 32768
run_cmd do
  let names : List Name := [
    `D1Bound5.finiteA5Constant,
    `D1Bound5.finiteA5Left,
    `D1Bound5.finiteA5Right,
    `D1Bound5.finiteA5DividedMatrix,
    `D1Bound5.finiteA5Matrix,
    `D1Bound5.finiteA5RowFactor,
    `D1Bound5.finiteA5Matrix_zero,
    `D1Bound5.finiteA5Matrix_one,
    `D1Bound5.finiteA5Matrix_two,
    `D1Bound5.finiteA5DividedMatrix_det,
    `D1Bound5.finiteA5Matrix_det,
    `D1Bound5.finiteA5DividedMatrix_det_ne_zero,
    `D1Bound5.finiteA5Coeff0,
    `D1Bound5.finiteA5Coeff1,
    `D1Bound5.finiteA5Coeff2,
    `D1Bound5.finiteA5Coeff3,
    `D1Bound5.finiteA5Coeff4,
    `D1Bound5.finiteA5Coeff5,
    `D1Bound5.finiteA5RootCoeff,
    `D1Bound5.finiteA5_root_coeff_decomposition,
    `D1Bound5.finiteA5CoefficientSums,
    `D1Bound5.finiteA5_coefficient_sums_0,
    `D1Bound5.finiteA5_coefficient_sums_1,
    `D1Bound5.finiteA5_coefficient_sums_2,
    `D1Bound5.finiteA5_coefficient_sums_3,
    `D1Bound5.finiteA5_coefficient_sums_4,
    `D1Bound5.finiteA5_coefficient_sums_5,
    `D1Bound5.map_finiteA5Constant,
    `D1Bound5.map_finiteA5Left,
    `D1Bound5.map_finiteA5Right,
    `D1Bound5.map_finiteA5DividedMatrix,
    `D1Bound5.finiteA5RowForm,
    `D1Bound5.map_finiteA5RowForm,
    `D1Bound5.finiteA5RowForm_exists_ne_zero,
    `D1Bound5.full_ring_finiteA5RowForm_exists_one_le_norm,
    `D1Bound5.finiteA5_root_coefficient_norm_le,
    `D1Bound5.finiteA5_coefficient_sums_nonneg,
    `D1Bound5.finiteA5_height_slack,
    `D1Bound5.finiteA5_root_columns_norm_le,
    `D1Bound5.finiteA5_height_scaled,
    `D1Bound5.finiteA5_residue_row0,
    `D1Bound5.finiteA5_residue_row1,
    `D1Bound5.finiteA5_residue_row2,
    `D1Bound5.finiteA5_residue_identity,
    `D1Bound5.finiteA5Residual,
    `D1Bound5.finiteA5_beta,
    `D1Bound5.finiteA5_residual_sum_identity,
    `D1Bound5.finiteA5RowFactor_ne_zero,
    `D1Bound5.finiteA5_residual_norm_lt_point,
    `D1Bound5.finiteA5_residual_norm_lt,
    `D1Bound5.finiteA5Residual_explicit,
    `D1Bound5.finiteA5RowForm_explicit,
    `D1Bound5.finiteA5RowForm_norm_lt,
    `D1Bound5.full_ring_finiteA5_integer,
    `D1Bound5.IsD1Tuple.finiteA5_inequality,
    `D1Bound5.IsD1Tuple.finiteA5_closed_interval_excluded]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.finiteA5Constant
#check @D1Bound5.finiteA5Left
#check @D1Bound5.finiteA5Right
#check @D1Bound5.finiteA5DividedMatrix
#check @D1Bound5.finiteA5Matrix
#check @D1Bound5.finiteA5RowFactor
#check @D1Bound5.finiteA5Matrix_zero
#check @D1Bound5.finiteA5Matrix_one
#check @D1Bound5.finiteA5Matrix_two
#check @D1Bound5.finiteA5DividedMatrix_det
#check @D1Bound5.finiteA5Matrix_det
#check @D1Bound5.finiteA5DividedMatrix_det_ne_zero
#check @D1Bound5.finiteA5Coeff0
#check @D1Bound5.finiteA5Coeff1
#check @D1Bound5.finiteA5Coeff2
#check @D1Bound5.finiteA5Coeff3
#check @D1Bound5.finiteA5Coeff4
#check @D1Bound5.finiteA5Coeff5
#check @D1Bound5.finiteA5RootCoeff
#check @D1Bound5.finiteA5_root_coeff_decomposition
#check @D1Bound5.finiteA5CoefficientSums
#check @D1Bound5.finiteA5_coefficient_sums_0
#check @D1Bound5.finiteA5_coefficient_sums_1
#check @D1Bound5.finiteA5_coefficient_sums_2
#check @D1Bound5.finiteA5_coefficient_sums_3
#check @D1Bound5.finiteA5_coefficient_sums_4
#check @D1Bound5.finiteA5_coefficient_sums_5
#check @D1Bound5.map_finiteA5Constant
#check @D1Bound5.map_finiteA5Left
#check @D1Bound5.map_finiteA5Right
#check @D1Bound5.map_finiteA5DividedMatrix
#check @D1Bound5.finiteA5RowForm
#check @D1Bound5.map_finiteA5RowForm
#check @D1Bound5.finiteA5RowForm_exists_ne_zero
#check @D1Bound5.full_ring_finiteA5RowForm_exists_one_le_norm
#check @D1Bound5.finiteA5_root_coefficient_norm_le
#check @D1Bound5.finiteA5_coefficient_sums_nonneg
#check @D1Bound5.finiteA5_height_slack
#check @D1Bound5.finiteA5_root_columns_norm_le
#check @D1Bound5.finiteA5_height_scaled
#check @D1Bound5.finiteA5_residue_row0
#check @D1Bound5.finiteA5_residue_row1
#check @D1Bound5.finiteA5_residue_row2
#check @D1Bound5.finiteA5_residue_identity
#check @D1Bound5.finiteA5Residual
#check @D1Bound5.finiteA5_beta
#check @D1Bound5.finiteA5_residual_sum_identity
#check @D1Bound5.finiteA5RowFactor_ne_zero
#check @D1Bound5.finiteA5_residual_norm_lt_point
#check @D1Bound5.finiteA5_residual_norm_lt
#check @D1Bound5.finiteA5Residual_explicit
#check @D1Bound5.finiteA5RowForm_explicit
#check @D1Bound5.finiteA5RowForm_norm_lt
#check @D1Bound5.full_ring_finiteA5_integer
#check @D1Bound5.IsD1Tuple.finiteA5_inequality
#check @D1Bound5.IsD1Tuple.finiteA5_closed_interval_excluded

open Finset Polynomial
namespace D1Bound5
section
variable {R : Type*} [CommRing R]

example (x y c : R) (i : Fin 3) :
    finiteA5Matrix x y c i 0 = finiteA5Constant x y c i := by
  exact finiteA5Matrix_zero x y c i

example (x y c : R) (i : Fin 3) :
    finiteA5Matrix x y c i 1 = x*finiteA5Left x y c i := by
  exact finiteA5Matrix_one x y c i

example (x y c : R) (i : Fin 3) :
    finiteA5Matrix x y c i 2 = y*finiteA5Right x y c i := by
  exact finiteA5Matrix_two x y c i

example (x y c : R) :
    (finiteA5DividedMatrix x y c).det = -62432370*(x*y)^2*c^1*(x-y)^19 := by
  exact finiteA5DividedMatrix_det x y c

example (x y c : R) :
    (finiteA5Matrix x y c).det = -62432370*(x*y)^3*c^1*(x-y)^19 := by
  exact finiteA5Matrix_det x y c

example
    {F : Type*} [Field F] [CharZero F] (x y c : F)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y) :
    (finiteA5DividedMatrix x y c).det ≠ 0 := by
  exact finiteA5DividedMatrix_det_ne_zero x y c hx hy hc hxy

end

section


example {R : Type*} [CommRing R]
    (x y c : R) (i : Fin 3) (j : Fin 2) :
    ![finiteA5Left x y c i,finiteA5Right x y c i] j =
      ∑ ell : Fin 6, finiteA5RootCoeff x y i j ell*c^(ell : ℕ) := by
  exact finiteA5_root_coeff_decomposition x y c i j

example (i : Fin 3) :
    (∑ r, |(finiteA5Coeff0 i 0 r : ℝ)|)+
      (∑ r, |(finiteA5Coeff0 i 1 r : ℝ)|) = finiteA5CoefficientSums i 0 := by
  exact finiteA5_coefficient_sums_0 i

example (i : Fin 3) :
    (∑ r, |(finiteA5Coeff1 i 0 r : ℝ)|)+
      (∑ r, |(finiteA5Coeff1 i 1 r : ℝ)|) = finiteA5CoefficientSums i 1 := by
  exact finiteA5_coefficient_sums_1 i

example (i : Fin 3) :
    (∑ r, |(finiteA5Coeff2 i 0 r : ℝ)|)+
      (∑ r, |(finiteA5Coeff2 i 1 r : ℝ)|) = finiteA5CoefficientSums i 2 := by
  exact finiteA5_coefficient_sums_2 i

example (i : Fin 3) :
    (∑ r, |(finiteA5Coeff3 i 0 r : ℝ)|)+
      (∑ r, |(finiteA5Coeff3 i 1 r : ℝ)|) = finiteA5CoefficientSums i 3 := by
  exact finiteA5_coefficient_sums_3 i

example (i : Fin 3) :
    (∑ r, |(finiteA5Coeff4 i 0 r : ℝ)|)+
      (∑ r, |(finiteA5Coeff4 i 1 r : ℝ)|) = finiteA5CoefficientSums i 4 := by
  exact finiteA5_coefficient_sums_4 i

example (i : Fin 3) :
    (∑ r, |(finiteA5Coeff5 i 0 r : ℝ)|)+
      (∑ r, |(finiteA5Coeff5 i 1 r : ℝ)|) = finiteA5CoefficientSums i 5 := by
  exact finiteA5_coefficient_sums_5 i

end

section
variable {R S : Type*} [CommRing R] [CommRing S]

example (f : R →+* S) (x y c : R) (i : Fin 3) :
    f (finiteA5Constant x y c i) = finiteA5Constant (f x) (f y) (f c) i := by
  exact map_finiteA5Constant f x y c i

example (f : R →+* S) (x y c : R) (i : Fin 3) :
    f (finiteA5Left x y c i) = finiteA5Left (f x) (f y) (f c) i := by
  exact map_finiteA5Left f x y c i

example (f : R →+* S) (x y c : R) (i : Fin 3) :
    f (finiteA5Right x y c i) = finiteA5Right (f x) (f y) (f c) i := by
  exact map_finiteA5Right f x y c i

example (f : R →+* S)
    (x y c : R) (i j : Fin 3) :
    f (finiteA5DividedMatrix x y c i j) =
      finiteA5DividedMatrix (f x) (f y) (f c) i j := by
  exact map_finiteA5DividedMatrix f x y c i j

example (f : R →+* S)
    (x y c z sX sY : R) (i : Fin 3) :
    f (finiteA5RowForm x y c z sX sY i) =
      finiteA5RowForm (f x) (f y) (f c) (f z) (f sX) (f sY) i := by
  exact map_finiteA5RowForm f x y c z sX sY i

example
    {F : Type*} [Field F] [CharZero F]
    (x y c z sX sY : F) (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y) (hz : z ≠ 0) :
    ∃ i : Fin 3, finiteA5RowForm x y c z sX sY i ≠ 0 := by
  exact finiteA5RowForm_exists_ne_zero x y c z sX sY hx hy hc hxy hz

example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (x y c z sX sY : 𝓞 K) (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y) (hz : z ≠ 0) :
    ∃ i : Fin 3, 1 ≤ ‖finiteA5RowForm (phi (x : K)) (phi (y : K))
      (phi (c : K)) (phi (z : K)) (phi (sX : K)) (phi (sY : K)) i‖ := by
  exact full_ring_finiteA5RowForm_exists_one_le_norm hK phi x y c z sX sY hx hy hc hxy hz

end

section


example (x y : ℂ) (hxy : ‖x‖ ≤ ‖y‖)
    (i : Fin 3) (ell : Fin 6) :
    ‖finiteA5RootCoeff x y i 0 ell‖+‖finiteA5RootCoeff x y i 1 ell‖ ≤
      (finiteA5CoefficientSums i ell : ℝ)*‖y‖^(7+(ell : ℕ)) := by
  exact finiteA5_root_coefficient_norm_le x y hxy i ell

example (i : Fin 3) (ell : Fin 6) :
    0 ≤ (finiteA5CoefficientSums i ell : ℝ) := by
  exact finiteA5_coefficient_sums_nonneg i ell

example (i : Fin 3) :
    (101/100 : ℝ)*(∑ ell : Fin 6,
      (finiteA5CoefficientSums i ell : ℝ)/(1000 : ℝ)^(5-(ell : ℕ))) < 3113013 := by
  exact finiteA5_height_slack i

example (x y c : ℂ) (hxy : ‖x‖ ≤ ‖y‖) (i : Fin 3) :
    ‖finiteA5Left x y c i‖+‖finiteA5Right x y c i‖ ≤
      ‖y‖^7*∑ ell : Fin 6, (finiteA5CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ) := by
  exact finiteA5_root_columns_norm_le x y c hxy i

example (x y c : ℂ) (hy : y ≠ 0)
    (hxy : ‖x‖ ≤ ‖y‖) (hYC : 1000 ≤ ‖y‖*‖c‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteA5Left x y c i‖+‖finiteA5Right x y c i‖) <
      3113013*‖y‖^12*‖c‖^5 := by
  exact finiteA5_height_scaled x y c hy hxy hYC i

end

section
variable {F : Type*} [Field F] [CharZero F]

example (x y c : F)
    (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (j : Fin 3) :
    finiteUnequalClearedEntry x y c 5 4 0 j =
      4*finiteA5RowFactor x y 0*finiteA5Matrix x y c 0 j := by
  exact finiteA5_residue_row0 x y c hx hy hxy j

end

section
variable {F : Type*} [Field F] [CharZero F]

example (x y c : F)
    (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (j : Fin 3) :
    finiteUnequalClearedEntry x y c 5 4 1 j =
      4*finiteA5RowFactor x y 1*finiteA5Matrix x y c 1 j := by
  exact finiteA5_residue_row1 x y c hx hy hxy j

end

section
variable {F : Type*} [Field F] [CharZero F]

example (x y c : F)
    (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (j : Fin 3) :
    finiteUnequalClearedEntry x y c 5 4 2 j =
      4*finiteA5RowFactor x y 2*finiteA5Matrix x y c 2 j := by
  exact finiteA5_residue_row2 x y c hx hy hxy j

end

section
variable {F : Type*} [Field F] [CharZero F]

example (x y c : F)
    (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i j : Fin 3) :
    finiteUnequalClearedEntry x y c 5 4 i j =
      4*finiteA5RowFactor x y i*finiteA5Matrix x y c i j := by
  exact finiteA5_residue_identity x y c hx hy hxy i j

end

section


example : |Ring.choose (11/2 : ℝ) 14| = 495/33554432 := by
  exact finiteA5_beta

example (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i : Fin 3) :
    4*finiteA5RowFactor x y i*finiteA5Residual x y c i =
      ∑ j, finiteUnequalClearedEntry x y c 5 4 i j*
        (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ) := by
  exact finiteA5_residual_sum_identity x y c hx hy hxy i

example (x y : ℂ) (hx : x ≠ 0) (hy : y ≠ 0)
    (hxy : x ≠ y) (i : Fin 3) : finiteA5RowFactor x y i ≠ 0 := by
  exact finiteA5RowFactor_ne_zero x y hx hy hxy i

example (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖finiteA5Residual x y c i‖ <
      (101/100 : ℝ)*(495/33554432)*(4^5*‖x-y‖^10/(‖x‖^5*‖y‖^5*‖c‖^9)) /
        (4*‖finiteA5RowFactor x y i‖) := by
  exact finiteA5_residual_norm_lt_point x y c hx hy hc hxy hXY hXC i

example (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖finiteA5Residual x y c i‖ < (495/64 : ℝ)*‖y‖^5/(‖x‖^6*‖c‖^9) := by
  exact finiteA5_residual_norm_lt x y c hx hy hc hxy hXY hXC i

end

section


example (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (i : Fin 3) :
    finiteA5Residual x y c i = finiteA5Constant x y c i +
      x*finiteA5Left x y c i*(1+1/(x*c))^(1/2 : ℂ) +
      y*finiteA5Right x y c i*(1+1/(y*c))^(1/2 : ℂ) := by
  exact finiteA5Residual_explicit x y c hx hy hc i

example {R : Type*} [CommRing R]
    (x y c z sX sY : R) (i : Fin 3) :
    finiteA5RowForm x y c z sX sY i =
      finiteA5Constant x y c i*z+finiteA5Left x y c i*sX+
        finiteA5Right x y c i*sY := by
  exact finiteA5RowForm_explicit x y c z sX sY i

example (x y c z sX sY : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hz : z ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖)
    (herrorX : ‖(1+1/(x*c))^(1/2 : ℂ)-sX/(x*z)‖ <
      (101/100 : ℝ)*‖c‖/(‖x‖*‖z‖^2))
    (herrorY : ‖(1+1/(y*c))^(1/2 : ℂ)-sY/(y*z)‖ <
      (101/100 : ℝ)*‖c‖/(‖y‖*‖z‖^2)) (i : Fin 3) :
    ‖finiteA5RowForm x y c z sX sY i‖ <
      3113013*‖y‖^12*‖c‖^6/‖z‖ + (495/64 : ℝ)*‖y‖^5*‖z‖/(‖x‖^6*‖c‖^9) := by
  exact finiteA5RowForm_norm_lt x y c z sX sY hx hy hc hz hxy hXY hXC herrorX herrorY i

example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (x y c d rX rY vX vY z : 𝓞 K)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hd : d ≠ 0) (hxy : x ≠ y)
    (hrX : rX^2=x*c+1) (hrY : rY^2=y*c+1)
    (hvX : vX^2=x*d+1) (hvY : vY^2=y*d+1) (hzsq : z^2=c*d+1)
    (hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖)
    (hXC : 1000 ≤ ‖phi (x : K)‖*‖phi (c : K)‖)
    (hC : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖) :
    1 < 3113013*‖phi (y : K)‖^12*‖phi (c : K)‖^6/‖phi (z : K)‖ +
      (495/64 : ℝ)*‖phi (y : K)‖^5*‖phi (z : K)‖/
        (‖phi (x : K)‖^6*‖phi (c : K)‖^9) := by
  exact full_ring_finiteA5_integer hK phi x y c d rX rY vX vY z hx hy hc hd hxy hrX hrY hvX hvY hzsq hXY hXC hC

end

section


example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 4 → 𝓞 K) (ht : IsD1Tuple t)
    (hXY : ‖phi (t 0 : K)‖ ≤ ‖phi (t 1 : K)‖)
    (hXC : 1000 ≤ ‖phi (t 0 : K)‖*‖phi (t 2 : K)‖)
    (hC : 200*‖phi (t 1 : K)‖ ≤ ‖phi (t 2 : K)‖) :
    ∃ z : 𝓞 K, z^2=t 2*t 3+1 ∧
      1 < 3113013*‖phi (t 1 : K)‖^12*‖phi (t 2 : K)‖^6/‖phi (z : K)‖ +
        (495/64 : ℝ)*‖phi (t 1 : K)‖^5*‖phi (z : K)‖/
          (‖phi (t 0 : K)‖^6*‖phi (t 2 : K)‖^9) := by
  exact IsD1Tuple.finiteA5_inequality hK phi t ht hXY hXC hC

example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 4 → 𝓞 K) (ht : IsD1Tuple t)
    (hXY : ‖phi (t 0 : K)‖ ≤ ‖phi (t 1 : K)‖)
    (hXC : 1000 ≤ ‖phi (t 0 : K)‖*‖phi (t 2 : K)‖)
    (hC : 200*‖phi (t 1 : K)‖ ≤ ‖phi (t 2 : K)‖)
    (hCD : ‖phi (t 2 : K)‖ ≤ ‖phi (t 3 : K)‖)
    (hleft : 4*3113013^2*‖phi (t 1 : K)‖^24*‖phi (t 2 : K)‖^11 /
      (1-1/4000 : ℝ) ≤ ‖phi (t 3 : K)‖)
    (hright : ‖phi (t 3 : K)‖ ≤
      1024*‖phi (t 0 : K)‖^12*‖phi (t 2 : K)‖^17 /
        (245025*‖phi (t 1 : K)‖^10*(1+1/4000 : ℝ))) : False := by
  exact IsD1Tuple.finiteA5_closed_interval_excluded hK phi t ht hXY hXC hC hCD hleft hright

end

end D1Bound5

namespace D1Bound5

example {R : Type*} [CommRing R] (x y c : R) :
    finiteA5Left x y c 0 =
      -17920*x^12*c^5 + 116480*x^11*y*c^5 - 40320*x^11*c^4 - 299520*x^10*y^2*c^5 + 279680*x^10*y*c^4 - 29600*x^10*c^3 + 366080*x^9*y^3*c^5 - 779520*x^9*y^2*c^4 + 223200*x^9*y*c^3 - 7600*x^9*c^2 - 183040*x^8*y^4*c^5 + 1056000*x^8*y^3*c^4 - 693120*x^8*y^2*c^3 + 63920*x^8*y*c^2 - 390*x^8*c - 605440*x^7*y^4*c^4 + 1085920*x^7*y^3*c^3 - 231120*x^7*y^2*c^2 + 3800*x^7*y*c + 10*x^7 - 765600*x^6*y^4*c^3 + 453200*x^6*y^3*c^2 - 17220*x^6*y^2*c - 120*x^6*y - 457600*x^5*y^4*c^2 + 51480*x^5*y^3*c + 780*x^5*y^2 - 127270*x^4*y^4*c - 5720*x^4*y^3 - 12870*x^3*y^4 := rfl

example {R : Type*} [CommRing R] (x y c : R) :
    finiteA5Left x y c 1 =
      14336*x^12*c^5 - 116480*x^11*y*c^5 + 22400*x^11*c^4 + 399360*x^10*y^2*c^5 - 195200*x^10*y*c^4 + 9600*x^10*c^3 - 732160*x^9*y^3*c^5 + 729600*x^9*y^2*c^4 - 91200*x^9*y*c^3 + 800*x^9*c^2 + 732160*x^8*y^4*c^5 - 1492480*x^8*y^3*c^4 + 382080*x^8*y^2*c^3 - 8480*x^8*y*c^2 - 40*x^8*c - 329472*x^7*y^5*c^5 + 1724800*x^7*y^4*c^4 - 913440*x^7*y^3*c^3 + 41520*x^7*y^2*c^2 + 490*x^7*y*c + 3*x^7 - 950400*x^6*y^5*c^4 + 1320000*x^6*y^4*c^3 - 127600*x^6*y^3*c^2 - 3000*x^6*y^2*c - 45*x^6*y - 1029600*x^5*y^5*c^3 + 286000*x^5*y^4*c^2 + 14300*x^5*y^3*c + 390*x^5*y^2 - 514800*x^4*y^5*c^2 - 57200*x^4*y^4*c - 4290*x^4*y^3 - 115830*x^3*y^5*c - 19305*x^3*y^4 - 9009*x^2*y^5 := rfl

example {R : Type*} [CommRing R] (x y c : R) :
    finiteA5Left x y c 2 =
      8960*x^12*c^5 - 66560*x^11*y*c^5 + 16640*x^11*c^4 + 199680*x^10*y^2*c^5 - 135680*x^10*y*c^4 + 8640*x^10*c^3 - 292864*x^9*y^3*c^5 + 457728*x^9*y^2*c^4 - 79872*x^9*y*c^3 + 896*x^9*c^2 + 183040*x^8*y^4*c^5 - 782848*x^8*y^3*c^4 + 318816*x^8*y^2*c^3 - 9824*x^8*y*c^2 - 58*x^8*c + 605440*x^7*y^4*c^4 - 690624*x^7*y^3*c^3 + 51648*x^7*y^2*c^2 + 808*x^7*y*c + 6*x^7 + 765600*x^6*y^4*c^3 - 177760*x^6*y^3*c^2 - 6780*x^6*y^2*c - 120*x^6*y + 457600*x^5*y^4*c^2 + 40040*x^5*y^3*c + 2340*x^5*y^2 + 127270*x^4*y^4*c + 17160*x^4*y^3 + 12870*x^3*y^4 := rfl

example {R : Type*} [CommRing R] (x y c : R) :
    finiteA5Right x y c 0 =
      183040*x^4*y^8*c^5 + 605440*x^4*y^7*c^4 + 765600*x^4*y^6*c^3 + 457600*x^4*y^5*c^2 + 127270*x^4*y^4*c + 12870*x^4*y^3 - 366080*x^3*y^9*c^5 - 1056000*x^3*y^8*c^4 - 1085920*x^3*y^7*c^3 - 453200*x^3*y^6*c^2 - 51480*x^3*y^5*c + 5720*x^3*y^4 + 299520*x^2*y^10*c^5 + 779520*x^2*y^9*c^4 + 693120*x^2*y^8*c^3 + 231120*x^2*y^7*c^2 + 17220*x^2*y^6*c - 780*x^2*y^5 - 116480*x*y^11*c^5 - 279680*x*y^10*c^4 - 223200*x*y^9*c^3 - 63920*x*y^8*c^2 - 3800*x*y^7*c + 120*x*y^6 + 17920*y^12*c^5 + 40320*y^11*c^4 + 29600*y^10*c^3 + 7600*y^9*c^2 + 390*y^8*c - 10*y^7 := rfl

example {R : Type*} [CommRing R] (x y c : R) :
    finiteA5Right x y c 1 =
      183040*x^4*y^8*c^5 + 605440*x^4*y^7*c^4 + 765600*x^4*y^6*c^3 + 457600*x^4*y^5*c^2 + 127270*x^4*y^4*c + 12870*x^4*y^3 - 292864*x^3*y^9*c^5 - 782848*x^3*y^8*c^4 - 690624*x^3*y^7*c^3 - 177760*x^3*y^6*c^2 + 40040*x^3*y^5*c + 17160*x^3*y^4 + 199680*x^2*y^10*c^5 + 457728*x^2*y^9*c^4 + 318816*x^2*y^8*c^3 + 51648*x^2*y^7*c^2 - 6780*x^2*y^6*c + 2340*x^2*y^5 - 66560*x*y^11*c^5 - 135680*x*y^10*c^4 - 79872*x*y^9*c^3 - 9824*x*y^8*c^2 + 808*x*y^7*c - 120*x*y^6 + 8960*y^12*c^5 + 16640*y^11*c^4 + 8640*y^10*c^3 + 896*y^9*c^2 - 58*y^8*c + 6*y^7 := rfl

example {R : Type*} [CommRing R] (x y c : R) :
    finiteA5Right x y c 2 =
      -329472*x^5*y^7*c^5 - 950400*x^5*y^6*c^4 - 1029600*x^5*y^5*c^3 - 514800*x^5*y^4*c^2 - 115830*x^5*y^3*c - 9009*x^5*y^2 + 732160*x^4*y^8*c^5 + 1724800*x^4*y^7*c^4 + 1320000*x^4*y^6*c^3 + 286000*x^4*y^5*c^2 - 57200*x^4*y^4*c - 19305*x^4*y^3 - 732160*x^3*y^9*c^5 - 1492480*x^3*y^8*c^4 - 913440*x^3*y^7*c^3 - 127600*x^3*y^6*c^2 + 14300*x^3*y^5*c - 4290*x^3*y^4 + 399360*x^2*y^10*c^5 + 729600*x^2*y^9*c^4 + 382080*x^2*y^8*c^3 + 41520*x^2*y^7*c^2 - 3000*x^2*y^6*c + 390*x^2*y^5 - 116480*x*y^11*c^5 - 195200*x*y^10*c^4 - 91200*x*y^9*c^3 - 8480*x*y^8*c^2 + 490*x*y^7*c - 45*x*y^6 + 14336*y^12*c^5 + 22400*y^11*c^4 + 9600*y^10*c^3 + 800*y^9*c^2 - 40*y^8*c + 3*y^7 := rfl

end D1Bound5
