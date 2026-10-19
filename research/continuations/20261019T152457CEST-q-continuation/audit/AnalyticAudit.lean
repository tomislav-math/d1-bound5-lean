import D1Bound5.FiniteQMatrix
import D1Bound5.FiniteQResidualIdentity
import D1Bound5.FiniteQHeight
import D1Bound5.FiniteQIntegralRows
import D1Bound5.FiniteQResidualBound
import D1Bound5.FiniteQRowBound
import D1Bound5.FiniteQFullRing
import D1Bound5.FiniteQInterval
import Lean.Elab.Command
import Lean.Util.CollectAxioms

open Lean Elab Command

set_option maxRecDepth 32768

run_cmd do
  let names : List Name := [
    `D1Bound5.finiteQLeft,
    `D1Bound5.finiteQRight,
    `D1Bound5.finiteQConstant,
    `D1Bound5.finiteQDividedMatrix,
    `D1Bound5.finiteQMatrix,
    `D1Bound5.finiteQDividedMatrix_det,
    `D1Bound5.finiteQMatrix_det,
    `D1Bound5.finiteQDividedMatrix_det_ne_zero,
    `D1Bound5.finiteQ_half_coefficients,
    `D1Bound5.finiteQHalfRemainder,
    `D1Bound5.finiteQHalfRemainder_norm_le,
    `D1Bound5.finiteQResidual,
    `D1Bound5.finiteQResidual_eq_remainders,
    `D1Bound5.finiteQ_pair_height,
    `D1Bound5.finiteQDividedMatrix_root_height,
    `D1Bound5.map_finiteQLeft,
    `D1Bound5.map_finiteQRight,
    `D1Bound5.map_finiteQConstant,
    `D1Bound5.map_finiteQDividedMatrix,
    `D1Bound5.finiteQRowForm,
    `D1Bound5.map_finiteQRowForm,
    `D1Bound5.finiteQRowForm_exists_ne_zero,
    `D1Bound5.full_ring_finiteQRowForm_exists_one_le_norm,
    `D1Bound5.finiteQHalfRemainder_small_norm_le,
    `D1Bound5.finiteQTailSide,
    `D1Bound5.finiteQTailSide_norm_le,
    `D1Bound5.finiteQResidual_norm_lt,
    `D1Bound5.finiteQAnchors,
    `D1Bound5.finiteQRowResidual,
    `D1Bound5.finiteQRowResidual_norm_lt,
    `D1Bound5.finiteQRowForm_eq_root_sum,
    `D1Bound5.finiteQRowForm_norm_lt,
    `D1Bound5.full_ring_finiteQ_inequality,
    `D1Bound5.full_ring_finiteQ_closed_interval_excluded]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.finiteQLeft
#check @D1Bound5.finiteQRight
#check @D1Bound5.finiteQConstant
#check @D1Bound5.finiteQDividedMatrix
#check @D1Bound5.finiteQMatrix
#check @D1Bound5.finiteQDividedMatrix_det
#check @D1Bound5.finiteQMatrix_det
#check @D1Bound5.finiteQDividedMatrix_det_ne_zero
#check @D1Bound5.finiteQ_half_coefficients
#check @D1Bound5.finiteQHalfRemainder
#check @D1Bound5.finiteQHalfRemainder_norm_le
#check @D1Bound5.finiteQResidual
#check @D1Bound5.finiteQResidual_eq_remainders
#check @D1Bound5.finiteQ_pair_height
#check @D1Bound5.finiteQDividedMatrix_root_height
#check @D1Bound5.map_finiteQLeft
#check @D1Bound5.map_finiteQRight
#check @D1Bound5.map_finiteQConstant
#check @D1Bound5.map_finiteQDividedMatrix
#check @D1Bound5.finiteQRowForm
#check @D1Bound5.map_finiteQRowForm
#check @D1Bound5.finiteQRowForm_exists_ne_zero
#check @D1Bound5.full_ring_finiteQRowForm_exists_one_le_norm
#check @D1Bound5.finiteQHalfRemainder_small_norm_le
#check @D1Bound5.finiteQTailSide
#check @D1Bound5.finiteQTailSide_norm_le
#check @D1Bound5.finiteQResidual_norm_lt
#check @D1Bound5.finiteQAnchors
#check @D1Bound5.finiteQRowResidual
#check @D1Bound5.finiteQRowResidual_norm_lt
#check @D1Bound5.finiteQRowForm_eq_root_sum
#check @D1Bound5.finiteQRowForm_norm_lt
#check @D1Bound5.full_ring_finiteQ_inequality
#check @D1Bound5.full_ring_finiteQ_closed_interval_excluded

open scoped NumberField
open Module
namespace D1Bound5

example {R : Type*} [CommRing R] (a b s t c : R) :
    (finiteQMatrix a b s t c).det =
      180*a^2*b^2*s^2*t^2*(a-b)^2*(a-s)*(a-t)*(b-s)*(b-t)*(s-t) :=
  finiteQMatrix_det a b s t c

example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {S : Finset (𝓞 K)} (hS : IsD1 S) (a : Fin 4 → 𝓞 K) (c d : 𝓞 K)
    (haS : ∀ j, a j ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hinj : Function.Injective a) (hac : ∀ j, a j ≠ c)
    (had : ∀ j, a j ≠ d) (hcd : c ≠ d)
    (A T : ℝ) (hA : 0 < A)
    (hlower : ∀ j, A ≤ ‖phi (a j : K)‖)
    (hupper : ∀ j, ‖phi (a j : K)‖ ≤ T)
    (hCT : 4*T ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖)
    (hAC : 1000 ≤ A*‖phi (c : K)‖) :
    ∃ z : 𝓞 K, z^2 = c*d+1 ∧
      1 < 55*T^3*‖phi (c : K)‖^2/‖phi (z : K)‖ +
        3*T*‖phi (z : K)‖/(2*A^2*‖phi (c : K)‖^4) := by
  exact full_ring_finiteQ_inequality hK phi hS a c d haS hcS hdS hinj hac had hcd A T hA hlower hupper hCT hCD hAC

example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {S : Finset (𝓞 K)} (hS : IsD1 S) (a : Fin 4 → 𝓞 K) (c d : 𝓞 K)
    (haS : ∀ j, a j ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hinj : Function.Injective a) (hac : ∀ j, a j ≠ c)
    (had : ∀ j, a j ≠ d) (hcd : c ≠ d)
    (A T : ℝ) (hA : 0 < A)
    (hlower : ∀ j, A ≤ ‖phi (a j : K)‖)
    (hupper : ∀ j, ‖phi (a j : K)‖ ≤ T)
    (hCT : 4*T ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖)
    (hAC : 1000 ≤ A*‖phi (c : K)‖)
    (hleft : 4*55^2*T^6*‖phi (c : K)‖^3/(1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤
      A^4*‖phi (c : K)‖^7/(9*T^2*(1+1/4000 : ℝ))) : False := by
  exact full_ring_finiteQ_closed_interval_excluded hK phi hS a c d haS hcS hdS hinj hac had hcd A T hA hlower hupper hCT hCD hAC hleft hright

end D1Bound5
