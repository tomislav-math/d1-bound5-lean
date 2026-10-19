import D1Bound5.FiniteN3BennettIdentity
import D1Bound5.FiniteN3Residual
import D1Bound5.FiniteN3Approximation
import D1Bound5.FiniteN3Interval
import Lean.Elab.Command
import Lean.Util.CollectAxioms
open Lean Elab Command
open scoped NumberField
open Module
set_option maxRecDepth 32768
run_cmd do
  let names : List Name := [
    `D1Bound5.finiteN3_choose_two,
    `D1Bound5.finiteN3_choose_three,
    `D1Bound5.finiteN3_bennett_identity,
    `D1Bound5.finiteN3Residual,
    `D1Bound5.finiteN3_beta,
    `D1Bound5.finiteN3_residual_identity,
    `D1Bound5.finiteN3RowFactor_ne_zero,
    `D1Bound5.finiteN3_residual_norm_lt_point,
    `D1Bound5.finiteN3_residual_norm_lt,
    `D1Bound5.finiteN3Residual_explicit,
    `D1Bound5.finiteN3RowForm_explicit,
    `D1Bound5.finiteN3RowForm_norm_lt,
    `D1Bound5.full_ring_finiteN3_integer,
    `D1Bound5.IsD1Tuple.finiteN3_inequality,
    `D1Bound5.IsD1Tuple.finiteN3_closed_interval_excluded]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.finiteN3_choose_two
#check @D1Bound5.finiteN3_choose_three
#check @D1Bound5.finiteN3_bennett_identity
#check @D1Bound5.finiteN3Residual
#check @D1Bound5.finiteN3_beta
#check @D1Bound5.finiteN3_residual_identity
#check @D1Bound5.finiteN3RowFactor_ne_zero
#check @D1Bound5.finiteN3_residual_norm_lt_point
#check @D1Bound5.finiteN3_residual_norm_lt
#check @D1Bound5.finiteN3Residual_explicit
#check @D1Bound5.finiteN3RowForm_explicit
#check @D1Bound5.finiteN3RowForm_norm_lt
#check @D1Bound5.full_ring_finiteN3_integer
#check @D1Bound5.IsD1Tuple.finiteN3_inequality
#check @D1Bound5.IsD1Tuple.finiteN3_closed_interval_excluded

open Finset Polynomial
namespace D1Bound5
section
variable {F : Type*} [Field F] [CharZero F]

example (r : F) : Ring.choose r 2 = r*(r-1)/2 := by
  exact finiteN3_choose_two r

example (r : F) : Ring.choose r 3 = r*(r-1)*(r-2)/6 := by
  exact finiteN3_choose_three r

example (x y c : F)
    (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i j : Fin 3) :
    bennettTwoClearedEntry x y c 3 i j =
      4 * finiteN3RowFactor x y i * finiteN3Matrix x y c i j := by
  exact finiteN3_bennett_identity x y c hx hy hxy i j

end

section


example :
    Real.Gamma (9/2 : ℝ)*Real.Gamma (11/2 : ℝ)/
      (Real.pi*Real.Gamma (10 : ℝ)) = 35/65536 := by
  exact finiteN3_beta

example (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i : Fin 3) :
    4*finiteN3RowFactor x y i*finiteN3Residual x y c i =
      ∑ j, bennettTwoClearedEntry x y c 3 i j *
        (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ) := by
  exact finiteN3_residual_identity x y c hx hy hxy i

example (x y : ℂ) (hx : x ≠ 0) (hy : y ≠ 0)
    (hxy : x ≠ y) (i : Fin 3) : finiteN3RowFactor x y i ≠ 0 := by
  exact finiteN3RowFactor_ne_zero x y hx hy hxy i

example (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖finiteN3Residual x y c i‖ <
      (101/100 : ℝ)*(35/65536)*(4*‖x-y‖^2/(‖x‖*‖y‖*‖c‖^2))^3 /
        (4*‖finiteN3RowFactor x y i‖) := by
  exact finiteN3_residual_norm_lt_point x y c hx hy hc hxy hXY hXC i

example (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖finiteN3Residual x y c i‖ <
      (35/32 : ℝ)*‖y‖^3/(‖x‖^4*‖c‖^6) := by
  exact finiteN3_residual_norm_lt x y c hx hy hc hxy hXY hXC i

end

section


example (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (i : Fin 3) :
    finiteN3Residual x y c i = finiteN3Constant x y c i +
      x*finiteN3Left x y c i*(1+1/(x*c))^(1/2 : ℂ) +
      y*finiteN3Right x y c i*(1+1/(y*c))^(1/2 : ℂ) := by
  exact finiteN3Residual_explicit x y c hx hy hc i

example {R : Type*} [CommRing R]
    (x y c z sX sY : R) (i : Fin 3) :
    finiteN3RowForm x y c z sX sY i =
      finiteN3Constant x y c i*z+finiteN3Left x y c i*sX+
        finiteN3Right x y c i*sY := by
  exact finiteN3RowForm_explicit x y c z sX sY i

example (x y c z sX sY : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hz : z ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖)
    (herrorX : ‖(1+1/(x*c))^(1/2 : ℂ)-sX/(x*z)‖ <
      (101/100 : ℝ)*‖c‖/(‖x‖*‖z‖^2))
    (herrorY : ‖(1+1/(y*c))^(1/2 : ℂ)-sY/(y*z)‖ <
      (101/100 : ℝ)*‖c‖/(‖y‖*‖z‖^2)) (i : Fin 3) :
    ‖finiteN3RowForm x y c z sX sY i‖ <
      4143*‖y‖^7*‖c‖^4/‖z‖ + (35/32 : ℝ)*‖y‖^3*‖z‖/(‖x‖^4*‖c‖^6) := by
  exact finiteN3RowForm_norm_lt x y c z sX sY hx hy hc hz hxy hXY hXC herrorX herrorY i

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
    1 < 4143*‖phi (y : K)‖^7*‖phi (c : K)‖^4/‖phi (z : K)‖ +
      (35/32 : ℝ)*‖phi (y : K)‖^3*‖phi (z : K)‖/
        (‖phi (x : K)‖^4*‖phi (c : K)‖^6) := by
  exact full_ring_finiteN3_integer hK phi x y c d rX rY vX vY z hx hy hc hd hxy hrX hrY hvX hvY hzsq hXY hXC hC

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
      1 < 4143*‖phi (t 1 : K)‖^7*‖phi (t 2 : K)‖^4/‖phi (z : K)‖ +
        (35/32 : ℝ)*‖phi (t 1 : K)‖^3*‖phi (z : K)‖/
          (‖phi (t 0 : K)‖^4*‖phi (t 2 : K)‖^6) := by
  exact IsD1Tuple.finiteN3_inequality hK phi t ht hXY hXC hC

example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 4 → 𝓞 K) (ht : IsD1Tuple t)
    (hXY : ‖phi (t 0 : K)‖ ≤ ‖phi (t 1 : K)‖)
    (hXC : 1000 ≤ ‖phi (t 0 : K)‖*‖phi (t 2 : K)‖)
    (hC : 200*‖phi (t 1 : K)‖ ≤ ‖phi (t 2 : K)‖)
    (hCD : ‖phi (t 2 : K)‖ ≤ ‖phi (t 3 : K)‖)
    (hleft : 4*4143^2*‖phi (t 1 : K)‖^14*‖phi (t 2 : K)‖^7 /
      (1-1/4000 : ℝ) ≤ ‖phi (t 3 : K)‖)
    (hright : ‖phi (t 3 : K)‖ ≤
      256*‖phi (t 0 : K)‖^8*‖phi (t 2 : K)‖^11 /
        (1225*‖phi (t 1 : K)‖^6*(1+1/4000 : ℝ))) : False := by
  exact IsD1Tuple.finiteN3_closed_interval_excluded hK phi t ht hXY hXC hC hCD hleft hright

end

end D1Bound5
