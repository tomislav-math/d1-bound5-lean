import D1Bound5.FiniteEtaBound
import D1Bound5.FiniteN2Residual
import D1Bound5.FiniteN2RowBound
import D1Bound5.FiniteN2FullRing
import D1Bound5.FiniteN2Interval
import Lean.Elab.Command
import Lean.Util.CollectAxioms
open Lean Elab Command
open scoped NumberField
open Module
set_option maxRecDepth 32768
run_cmd do
  let names : List Name := [
    `D1Bound5.finite_eta_power_lower,
    `D1Bound5.finite_eta_reciprocal_lt,
    `D1Bound5.finiteN2Residual,
    `D1Bound5.finiteN2_residual_identity,
    `D1Bound5.finiteN2_choose_abs,
    `D1Bound5.finiteN2_Gamma_beta,
    `D1Bound5.finiteN2_bennett_residual_norm_lt,
    `D1Bound5.finiteN2_residual_norm_lt_point,
    `D1Bound5.finiteN2_residual_norm_lt,
    `D1Bound5.finiteN2RowForm_eq_root_sum,
    `D1Bound5.finiteN2RowForm_norm_lt,
    `D1Bound5.finiteN2RowForm_norm_lt_point,
    `D1Bound5.full_ring_finiteN2_inequalities,
    `D1Bound5.full_ring_finiteN2_closed_interval_excluded]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.finite_eta_power_lower
#check @D1Bound5.finite_eta_reciprocal_lt
#check @D1Bound5.finiteN2Residual
#check @D1Bound5.finiteN2_residual_identity
#check @D1Bound5.finiteN2_choose_abs
#check @D1Bound5.finiteN2_Gamma_beta
#check @D1Bound5.finiteN2_bennett_residual_norm_lt
#check @D1Bound5.finiteN2_residual_norm_lt_point
#check @D1Bound5.finiteN2_residual_norm_lt
#check @D1Bound5.finiteN2RowForm_eq_root_sum
#check @D1Bound5.finiteN2RowForm_norm_lt
#check @D1Bound5.finiteN2RowForm_norm_lt_point
#check @D1Bound5.full_ring_finiteN2_inequalities
#check @D1Bound5.full_ring_finiteN2_closed_interval_excluded

open Finset Polynomial
namespace D1Bound5
section


example (T e : ℝ) (hT : 1000 ≤ T) (he : e ≤ 9) :
    (100/101 : ℝ) < (1-1/T)^e := by
  exact finite_eta_power_lower T e hT he

example (T e : ℝ) (hT : 1000 ≤ T) (he : e ≤ 9) :
    1/(1-1/T)^e < (101/100 : ℝ) := by
  exact finite_eta_reciprocal_lt T e hT he

end

section


example (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y) (i : Fin 3) :
    (∑ j, bennettTwoClearedEntry x y c 2 i j *
      (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ)) =
      2*finiteN2RowFactor x y i*finiteN2Residual x y c i := by
  exact finiteN2_residual_identity x y c hx hy hc hxy i

example : |Ring.choose (5/2 : ℝ) 6| = 5/1024 := by
  exact finiteN2_choose_abs

example :
    Real.Gamma (7/2)*Real.Gamma (7/2)/(Real.pi*Real.Gamma 7) = (5/1024 : ℝ) := by
  exact finiteN2_Gamma_beta

example (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖∑ j, bennettTwoClearedEntry x y c 2 i j *
      (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ)‖ <
      (101/1280 : ℝ)*‖x-y‖^4/(‖x‖^2*‖y‖^2*‖c‖^4) := by
  exact finiteN2_bennett_residual_norm_lt x y c hx hy hc hxy hXY hXC i

example (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖finiteN2Residual x y c i‖ <
      (101/2560 : ℝ)*max (‖x-y‖^4) (‖x‖*‖x-y‖^3) /
        (‖x‖^3*‖y‖^2*‖c‖^4) := by
  exact finiteN2_residual_norm_lt_point x y c hx hy hc hxy hXY hXC i

example (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖finiteN2Residual x y c i‖ < (5/4 : ℝ)*‖y‖^2/(‖x‖^3*‖c‖^4) := by
  exact finiteN2_residual_norm_lt x y c hx hy hc hxy hXY hXC i

end

section


example (x y c z sX sY : ℂ) (i : Fin 3) :
    finiteN2RowForm x y c z sX sY i =
      finiteN2Constant x y c i*z +
        ∑ j : Fin 2, ![finiteN2Left x y c i,finiteN2Right x y c i] j * ![sX,sY] j := by
  exact finiteN2RowForm_eq_root_sum x y c z sX sY i

example
    (x y c z sX sY : ℂ) (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0)
    (hxy : x ≠ y) (hz : z ≠ 0) (hXY : ‖x‖ ≤ ‖y‖)
    (hXC : 1000 ≤ ‖x‖*‖c‖)
    (herr : ∀ j : Fin 2,
      ‖(1+1/(![x,y] j*c))^(1/2 : ℂ)-![sX,sY] j/(![x,y] j*z)‖ ≤
        (101/100 : ℝ)*‖c‖/(‖![x,y] j‖*‖z‖^2)) (i : Fin 3) :
    ‖finiteN2RowForm x y c z sX sY i‖ <
      243*‖y‖^4*‖c‖^3/‖z‖ + (5/4 : ℝ)*‖y‖^2*‖z‖/(‖x‖^3*‖c‖^4) := by
  exact finiteN2RowForm_norm_lt x y c z sX sY hx hy hc hxy hz hXY hXC herr i

example
    (x y c z sX sY : ℂ) (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0)
    (hxy : x ≠ y) (hz : z ≠ 0) (hXY : ‖x‖ ≤ ‖y‖)
    (hXC : 1000 ≤ ‖x‖*‖c‖)
    (herr : ∀ j : Fin 2,
      ‖(1+1/(![x,y] j*c))^(1/2 : ℂ)-![sX,sY] j/(![x,y] j*z)‖ ≤
        (101/100 : ℝ)*‖c‖/(‖![x,y] j‖*‖z‖^2)) (i : Fin 3) :
    ‖finiteN2RowForm x y c z sX sY i‖ <
      243*‖y‖^4*‖c‖^3/‖z‖ +
        (101/2560 : ℝ)*max (‖x-y‖^4) (‖x‖*‖x-y‖^3)*‖z‖/
          (‖x‖^3*‖y‖^2*‖c‖^4) := by
  exact finiteN2RowForm_norm_lt_point x y c z sX sY hx hy hc hxy hz hXY hXC herr i

end

section


example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {S : Finset (𝓞 K)} (hS : IsD1 S) (x y c d : 𝓞 K)
    (hxS : x ∈ S) (hyS : y ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hxy : x ≠ y) (hxc : x ≠ c) (hyc : y ≠ c)
    (hxd : x ≠ d) (hyd : y ≠ d) (hcd : c ≠ d)
    (hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖)
    (hXC : 1000 ≤ ‖phi (x : K)‖*‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖) :
    ∃ z : 𝓞 K, z^2 = c*d+1 ∧
      (1 < 243*‖phi (y : K)‖^4*‖phi (c : K)‖^3/‖phi (z : K)‖ +
        (5/4 : ℝ)*‖phi (y : K)‖^2*‖phi (z : K)‖ /
          (‖phi (x : K)‖^3*‖phi (c : K)‖^4)) ∧
      (1 < 243*‖phi (y : K)‖^4*‖phi (c : K)‖^3/‖phi (z : K)‖ +
        (101/2560 : ℝ)*max (‖phi (x : K)-phi (y : K)‖^4)
          (‖phi (x : K)‖*‖phi (x : K)-phi (y : K)‖^3)*‖phi (z : K)‖ /
            (‖phi (x : K)‖^3*‖phi (y : K)‖^2*‖phi (c : K)‖^4)) := by
  exact full_ring_finiteN2_inequalities hK phi hS x y c d hxS hyS hcS hdS hxy hxc hyc hxd hyd hcd hXY hXC hCY hCD

end

section


example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {S : Finset (𝓞 K)} (hS : IsD1 S) (x y c d : 𝓞 K)
    (hxS : x ∈ S) (hyS : y ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hxy : x ≠ y) (hxc : x ≠ c) (hyc : y ≠ c)
    (hxd : x ≠ d) (hyd : y ≠ d) (hcd : c ≠ d)
    (hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖)
    (hXC : 1000 ≤ ‖phi (x : K)‖*‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖)
    (hleft : 4*243^2*‖phi (y : K)‖^8*‖phi (c : K)‖^5 /
      (1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤
      4*‖phi (x : K)‖^6*‖phi (c : K)‖^7 /
        (25*‖phi (y : K)‖^4*(1+1/4000 : ℝ))) : False := by
  exact full_ring_finiteN2_closed_interval_excluded hK phi hS x y c d hxS hyS hcS hdS hxy hxc hyc hxd hyd hcd hXY hXC hCY hCD hleft hright

end

end D1Bound5
