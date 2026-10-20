import D1Bound5.FiniteA4Matrix
import D1Bound5.FiniteA4Coefficients
import D1Bound5.FiniteA4IntegralRows
import D1Bound5.FiniteA4Height
import D1Bound5.FiniteA4ResidueIdentity
import D1Bound5.FiniteA4Residual
import D1Bound5.FiniteA4Approximation
import D1Bound5.FiniteA4Interval
import Lean.Elab.Command
import Lean.Util.CollectAxioms
open Lean Elab Command
open scoped NumberField
open Module
set_option maxRecDepth 32768
run_cmd do
  let names : List Name := [
    `D1Bound5.finiteA4Constant,
    `D1Bound5.finiteA4Left,
    `D1Bound5.finiteA4Right,
    `D1Bound5.finiteA4DividedMatrix,
    `D1Bound5.finiteA4Matrix,
    `D1Bound5.finiteA4RowFactor,
    `D1Bound5.finiteA4Matrix_zero,
    `D1Bound5.finiteA4Matrix_one,
    `D1Bound5.finiteA4Matrix_two,
    `D1Bound5.finiteA4DividedMatrix_det,
    `D1Bound5.finiteA4Matrix_det,
    `D1Bound5.finiteA4DividedMatrix_det_ne_zero,
    `D1Bound5.finiteA4Coeff0,
    `D1Bound5.finiteA4Coeff1,
    `D1Bound5.finiteA4Coeff2,
    `D1Bound5.finiteA4Coeff3,
    `D1Bound5.finiteA4Coeff4,
    `D1Bound5.finiteA4RootCoeff,
    `D1Bound5.finiteA4_root_coeff_decomposition,
    `D1Bound5.finiteA4CoefficientSums,
    `D1Bound5.finiteA4_coefficient_sums_0,
    `D1Bound5.finiteA4_coefficient_sums_1,
    `D1Bound5.finiteA4_coefficient_sums_2,
    `D1Bound5.finiteA4_coefficient_sums_3,
    `D1Bound5.finiteA4_coefficient_sums_4,
    `D1Bound5.map_finiteA4Constant,
    `D1Bound5.map_finiteA4Left,
    `D1Bound5.map_finiteA4Right,
    `D1Bound5.map_finiteA4DividedMatrix,
    `D1Bound5.finiteA4RowForm,
    `D1Bound5.map_finiteA4RowForm,
    `D1Bound5.finiteA4RowForm_exists_ne_zero,
    `D1Bound5.full_ring_finiteA4RowForm_exists_one_le_norm,
    `D1Bound5.finiteA4_root_coefficient_norm_le,
    `D1Bound5.finiteA4_coefficient_sums_nonneg,
    `D1Bound5.finiteA4_height_slack,
    `D1Bound5.finiteA4_root_columns_norm_le,
    `D1Bound5.finiteA4_height_scaled,
    `D1Bound5.finiteA4_residue_identity,
    `D1Bound5.finiteA4Residual,
    `D1Bound5.finiteA4_beta,
    `D1Bound5.finiteA4_residual_sum_identity,
    `D1Bound5.finiteA4RowFactor_ne_zero,
    `D1Bound5.finiteA4_residual_norm_lt_point,
    `D1Bound5.finiteA4_residual_norm_lt,
    `D1Bound5.finiteA4Residual_explicit,
    `D1Bound5.finiteA4RowForm_explicit,
    `D1Bound5.finiteA4RowForm_norm_lt,
    `D1Bound5.full_ring_finiteA4_integer,
    `D1Bound5.IsD1Tuple.finiteA4_inequality,
    `D1Bound5.IsD1Tuple.finiteA4_closed_interval_excluded]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.finiteA4Constant
#check @D1Bound5.finiteA4Left
#check @D1Bound5.finiteA4Right
#check @D1Bound5.finiteA4DividedMatrix
#check @D1Bound5.finiteA4Matrix
#check @D1Bound5.finiteA4RowFactor
#check @D1Bound5.finiteA4Matrix_zero
#check @D1Bound5.finiteA4Matrix_one
#check @D1Bound5.finiteA4Matrix_two
#check @D1Bound5.finiteA4DividedMatrix_det
#check @D1Bound5.finiteA4Matrix_det
#check @D1Bound5.finiteA4DividedMatrix_det_ne_zero
#check @D1Bound5.finiteA4Coeff0
#check @D1Bound5.finiteA4Coeff1
#check @D1Bound5.finiteA4Coeff2
#check @D1Bound5.finiteA4Coeff3
#check @D1Bound5.finiteA4Coeff4
#check @D1Bound5.finiteA4RootCoeff
#check @D1Bound5.finiteA4_root_coeff_decomposition
#check @D1Bound5.finiteA4CoefficientSums
#check @D1Bound5.finiteA4_coefficient_sums_0
#check @D1Bound5.finiteA4_coefficient_sums_1
#check @D1Bound5.finiteA4_coefficient_sums_2
#check @D1Bound5.finiteA4_coefficient_sums_3
#check @D1Bound5.finiteA4_coefficient_sums_4
#check @D1Bound5.map_finiteA4Constant
#check @D1Bound5.map_finiteA4Left
#check @D1Bound5.map_finiteA4Right
#check @D1Bound5.map_finiteA4DividedMatrix
#check @D1Bound5.finiteA4RowForm
#check @D1Bound5.map_finiteA4RowForm
#check @D1Bound5.finiteA4RowForm_exists_ne_zero
#check @D1Bound5.full_ring_finiteA4RowForm_exists_one_le_norm
#check @D1Bound5.finiteA4_root_coefficient_norm_le
#check @D1Bound5.finiteA4_coefficient_sums_nonneg
#check @D1Bound5.finiteA4_height_slack
#check @D1Bound5.finiteA4_root_columns_norm_le
#check @D1Bound5.finiteA4_height_scaled
#check @D1Bound5.finiteA4_residue_identity
#check @D1Bound5.finiteA4Residual
#check @D1Bound5.finiteA4_beta
#check @D1Bound5.finiteA4_residual_sum_identity
#check @D1Bound5.finiteA4RowFactor_ne_zero
#check @D1Bound5.finiteA4_residual_norm_lt_point
#check @D1Bound5.finiteA4_residual_norm_lt
#check @D1Bound5.finiteA4Residual_explicit
#check @D1Bound5.finiteA4RowForm_explicit
#check @D1Bound5.finiteA4RowForm_norm_lt
#check @D1Bound5.full_ring_finiteA4_integer
#check @D1Bound5.IsD1Tuple.finiteA4_inequality
#check @D1Bound5.IsD1Tuple.finiteA4_closed_interval_excluded

open Finset Polynomial
namespace D1Bound5
section
variable {R : Type*} [CommRing R]

example (x y c : R) (i : Fin 3) :
    finiteA4Matrix x y c i 0 = finiteA4Constant x y c i := by
  exact finiteA4Matrix_zero x y c i

example (x y c : R) (i : Fin 3) :
    finiteA4Matrix x y c i 1 = x*finiteA4Left x y c i := by
  exact finiteA4Matrix_one x y c i

example (x y c : R) (i : Fin 3) :
    finiteA4Matrix x y c i 2 = y*finiteA4Right x y c i := by
  exact finiteA4Matrix_two x y c i

example (x y c : R) :
    (finiteA4DividedMatrix x y c).det = 2910600*(x*y)^1*c^1*(x-y)^15 := by
  exact finiteA4DividedMatrix_det x y c

example (x y c : R) :
    (finiteA4Matrix x y c).det = 2910600*(x*y)^2*c^1*(x-y)^15 := by
  exact finiteA4Matrix_det x y c

example
    {F : Type*} [Field F] [CharZero F] (x y c : F)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y) :
    (finiteA4DividedMatrix x y c).det ≠ 0 := by
  exact finiteA4DividedMatrix_det_ne_zero x y c hx hy hc hxy

end

section


example {R : Type*} [CommRing R]
    (x y c : R) (i : Fin 3) (j : Fin 2) :
    ![finiteA4Left x y c i,finiteA4Right x y c i] j =
      ∑ ell : Fin 5, finiteA4RootCoeff x y i j ell*c^(ell : ℕ) := by
  exact finiteA4_root_coeff_decomposition x y c i j

example (i : Fin 3) :
    (∑ r, |(finiteA4Coeff0 i 0 r : ℝ)|)+
      (∑ r, |(finiteA4Coeff0 i 1 r : ℝ)|) = finiteA4CoefficientSums i 0 := by
  exact finiteA4_coefficient_sums_0 i

example (i : Fin 3) :
    (∑ r, |(finiteA4Coeff1 i 0 r : ℝ)|)+
      (∑ r, |(finiteA4Coeff1 i 1 r : ℝ)|) = finiteA4CoefficientSums i 1 := by
  exact finiteA4_coefficient_sums_1 i

example (i : Fin 3) :
    (∑ r, |(finiteA4Coeff2 i 0 r : ℝ)|)+
      (∑ r, |(finiteA4Coeff2 i 1 r : ℝ)|) = finiteA4CoefficientSums i 2 := by
  exact finiteA4_coefficient_sums_2 i

example (i : Fin 3) :
    (∑ r, |(finiteA4Coeff3 i 0 r : ℝ)|)+
      (∑ r, |(finiteA4Coeff3 i 1 r : ℝ)|) = finiteA4CoefficientSums i 3 := by
  exact finiteA4_coefficient_sums_3 i

example (i : Fin 3) :
    (∑ r, |(finiteA4Coeff4 i 0 r : ℝ)|)+
      (∑ r, |(finiteA4Coeff4 i 1 r : ℝ)|) = finiteA4CoefficientSums i 4 := by
  exact finiteA4_coefficient_sums_4 i

end

section
variable {R S : Type*} [CommRing R] [CommRing S]

example (f : R →+* S) (x y c : R) (i : Fin 3) :
    f (finiteA4Constant x y c i) = finiteA4Constant (f x) (f y) (f c) i := by
  exact map_finiteA4Constant f x y c i

example (f : R →+* S) (x y c : R) (i : Fin 3) :
    f (finiteA4Left x y c i) = finiteA4Left (f x) (f y) (f c) i := by
  exact map_finiteA4Left f x y c i

example (f : R →+* S) (x y c : R) (i : Fin 3) :
    f (finiteA4Right x y c i) = finiteA4Right (f x) (f y) (f c) i := by
  exact map_finiteA4Right f x y c i

example (f : R →+* S)
    (x y c : R) (i j : Fin 3) :
    f (finiteA4DividedMatrix x y c i j) =
      finiteA4DividedMatrix (f x) (f y) (f c) i j := by
  exact map_finiteA4DividedMatrix f x y c i j

example (f : R →+* S)
    (x y c z sX sY : R) (i : Fin 3) :
    f (finiteA4RowForm x y c z sX sY i) =
      finiteA4RowForm (f x) (f y) (f c) (f z) (f sX) (f sY) i := by
  exact map_finiteA4RowForm f x y c z sX sY i

example
    {F : Type*} [Field F] [CharZero F]
    (x y c z sX sY : F) (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y) (hz : z ≠ 0) :
    ∃ i : Fin 3, finiteA4RowForm x y c z sX sY i ≠ 0 := by
  exact finiteA4RowForm_exists_ne_zero x y c z sX sY hx hy hc hxy hz

example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (x y c z sX sY : 𝓞 K) (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y) (hz : z ≠ 0) :
    ∃ i : Fin 3, 1 ≤ ‖finiteA4RowForm (phi (x : K)) (phi (y : K))
      (phi (c : K)) (phi (z : K)) (phi (sX : K)) (phi (sY : K)) i‖ := by
  exact full_ring_finiteA4RowForm_exists_one_le_norm hK phi x y c z sX sY hx hy hc hxy hz

end

section


example (x y : ℂ) (hxy : ‖x‖ ≤ ‖y‖)
    (i : Fin 3) (ell : Fin 5) :
    ‖finiteA4RootCoeff x y i 0 ell‖+‖finiteA4RootCoeff x y i 1 ell‖ ≤
      (finiteA4CoefficientSums i ell : ℝ)*‖y‖^(5+(ell : ℕ)) := by
  exact finiteA4_root_coefficient_norm_le x y hxy i ell

example (i : Fin 3) (ell : Fin 5) :
    0 ≤ (finiteA4CoefficientSums i ell : ℝ) := by
  exact finiteA4_coefficient_sums_nonneg i ell

example (i : Fin 3) :
    (101/100 : ℝ)*(∑ ell : Fin 5,
      (finiteA4CoefficientSums i ell : ℝ)/(1000 : ℝ)^(4-(ell : ℕ))) < 165763 := by
  exact finiteA4_height_slack i

example (x y c : ℂ) (hxy : ‖x‖ ≤ ‖y‖) (i : Fin 3) :
    ‖finiteA4Left x y c i‖+‖finiteA4Right x y c i‖ ≤
      ‖y‖^5*∑ ell : Fin 5, (finiteA4CoefficientSums i ell : ℝ)*(‖y‖*‖c‖)^(ell : ℕ) := by
  exact finiteA4_root_columns_norm_le x y c hxy i

example (x y c : ℂ) (hy : y ≠ 0)
    (hxy : ‖x‖ ≤ ‖y‖) (hYC : 1000 ≤ ‖y‖*‖c‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteA4Left x y c i‖+‖finiteA4Right x y c i‖) <
      165763*‖y‖^9*‖c‖^4 := by
  exact finiteA4_height_scaled x y c hy hxy hYC i

end

section
variable {F : Type*} [Field F] [CharZero F]

example (x y c : F)
    (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i j : Fin 3) :
    finiteUnequalClearedEntry x y c 4 3 i j =
      2*finiteA4RowFactor x y i*finiteA4Matrix x y c i j := by
  exact finiteA4_residue_identity x y c hx hy hxy i j

end

section


example : |Ring.choose (9/2 : ℝ) 11| = 63/524288 := by
  exact finiteA4_beta

example (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i : Fin 3) :
    2*finiteA4RowFactor x y i*finiteA4Residual x y c i =
      ∑ j, finiteUnequalClearedEntry x y c 4 3 i j*
        (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ) := by
  exact finiteA4_residual_sum_identity x y c hx hy hxy i

example (x y : ℂ) (hx : x ≠ 0) (hy : y ≠ 0)
    (hxy : x ≠ y) (i : Fin 3) : finiteA4RowFactor x y i ≠ 0 := by
  exact finiteA4RowFactor_ne_zero x y hx hy hxy i

example (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖finiteA4Residual x y c i‖ <
      (101/100 : ℝ)*(63/524288)*(4^4*‖x-y‖^8/(‖x‖^4*‖y‖^4*‖c‖^7)) /
        (2*‖finiteA4RowFactor x y i‖) := by
  exact finiteA4_residual_norm_lt_point x y c hx hy hc hxy hXY hXC i

example (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖finiteA4Residual x y c i‖ < (63/8 : ℝ)*‖y‖^4/(‖x‖^5*‖c‖^7) := by
  exact finiteA4_residual_norm_lt x y c hx hy hc hxy hXY hXC i

end

section


example (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (i : Fin 3) :
    finiteA4Residual x y c i = finiteA4Constant x y c i +
      x*finiteA4Left x y c i*(1+1/(x*c))^(1/2 : ℂ) +
      y*finiteA4Right x y c i*(1+1/(y*c))^(1/2 : ℂ) := by
  exact finiteA4Residual_explicit x y c hx hy hc i

example {R : Type*} [CommRing R]
    (x y c z sX sY : R) (i : Fin 3) :
    finiteA4RowForm x y c z sX sY i =
      finiteA4Constant x y c i*z+finiteA4Left x y c i*sX+
        finiteA4Right x y c i*sY := by
  exact finiteA4RowForm_explicit x y c z sX sY i

example (x y c z sX sY : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hz : z ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖)
    (herrorX : ‖(1+1/(x*c))^(1/2 : ℂ)-sX/(x*z)‖ <
      (101/100 : ℝ)*‖c‖/(‖x‖*‖z‖^2))
    (herrorY : ‖(1+1/(y*c))^(1/2 : ℂ)-sY/(y*z)‖ <
      (101/100 : ℝ)*‖c‖/(‖y‖*‖z‖^2)) (i : Fin 3) :
    ‖finiteA4RowForm x y c z sX sY i‖ <
      165763*‖y‖^9*‖c‖^5/‖z‖ + (63/8 : ℝ)*‖y‖^4*‖z‖/(‖x‖^5*‖c‖^7) := by
  exact finiteA4RowForm_norm_lt x y c z sX sY hx hy hc hz hxy hXY hXC herrorX herrorY i

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
    1 < 165763*‖phi (y : K)‖^9*‖phi (c : K)‖^5/‖phi (z : K)‖ +
      (63/8 : ℝ)*‖phi (y : K)‖^4*‖phi (z : K)‖/
        (‖phi (x : K)‖^5*‖phi (c : K)‖^7) := by
  exact full_ring_finiteA4_integer hK phi x y c d rX rY vX vY z hx hy hc hd hxy hrX hrY hvX hvY hzsq hXY hXC hC

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
      1 < 165763*‖phi (t 1 : K)‖^9*‖phi (t 2 : K)‖^5/‖phi (z : K)‖ +
        (63/8 : ℝ)*‖phi (t 1 : K)‖^4*‖phi (z : K)‖/
          (‖phi (t 0 : K)‖^5*‖phi (t 2 : K)‖^7) := by
  exact IsD1Tuple.finiteA4_inequality hK phi t ht hXY hXC hC

example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 4 → 𝓞 K) (ht : IsD1Tuple t)
    (hXY : ‖phi (t 0 : K)‖ ≤ ‖phi (t 1 : K)‖)
    (hXC : 1000 ≤ ‖phi (t 0 : K)‖*‖phi (t 2 : K)‖)
    (hC : 200*‖phi (t 1 : K)‖ ≤ ‖phi (t 2 : K)‖)
    (hCD : ‖phi (t 2 : K)‖ ≤ ‖phi (t 3 : K)‖)
    (hleft : 4*165763^2*‖phi (t 1 : K)‖^18*‖phi (t 2 : K)‖^9 /
      (1-1/4000 : ℝ) ≤ ‖phi (t 3 : K)‖)
    (hright : ‖phi (t 3 : K)‖ ≤
      16*‖phi (t 0 : K)‖^10*‖phi (t 2 : K)‖^13 /
        (3969*‖phi (t 1 : K)‖^8*(1+1/4000 : ℝ))) : False := by
  exact IsD1Tuple.finiteA4_closed_interval_excluded hK phi t ht hXY hXC hC hCD hleft hright

end

end D1Bound5
