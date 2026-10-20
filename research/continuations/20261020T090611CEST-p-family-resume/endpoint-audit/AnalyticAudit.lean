import D1Bound5.FinitePResidualBound
import D1Bound5.FinitePRowBound
import D1Bound5.FinitePFullRing
import D1Bound5.FinitePInterval
import Lean.Elab.Command
import Lean.Util.CollectAxioms
open Lean Elab Command
open scoped NumberField
open Module
set_option maxRecDepth 32768
run_cmd do
  let names : List Name := [
    `D1Bound5.finiteP_residual_norm_lt,
    `D1Bound5.finitePRowForm_eq_root_sum,
    `D1Bound5.finitePRowForm_norm_lt,
    `D1Bound5.full_ring_finiteP_inequality,
    `D1Bound5.full_ring_finiteP_closed_interval_excluded]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.finiteP_residual_norm_lt
#check @D1Bound5.finitePRowForm_eq_root_sum
#check @D1Bound5.finitePRowForm_norm_lt
#check @D1Bound5.full_ring_finiteP_inequality
#check @D1Bound5.full_ring_finiteP_closed_interval_excluded

open Finset Polynomial
namespace D1Bound5
section


example (a b s c : ℂ)
    (hA : 1 ≤ ‖a‖) (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖)
    (hAC : 1000 ≤ ‖a‖*‖c‖) (i : Fin 4) :
    ‖finitePResidual a b s c i‖ < 3*‖s‖^2/(‖a‖^3*‖c‖^5) := by
  exact finiteP_residual_norm_lt a b s c hA hAB hBS hAC i

end

section


example (a b s c z rA rB rS : ℂ) (i : Fin 4) :
    finitePRowForm a b s c z rA rB rS i =
      finitePDividedMatrix a b s c i 0*z+
        ∑ j : Fin 3, finitePRootColumn a b s c i j*![rA,rB,rS] j := by
  exact finitePRowForm_eq_root_sum a b s c z rA rB rS i

example (a b s c z rA rB rS : ℂ)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0) (hz : z ≠ 0)
    (hA : 1 ≤ ‖a‖) (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖)
    (hC : 200 ≤ ‖c‖) (hAC : 1000 ≤ ‖a‖*‖c‖)
    (herr : ∀ j : Fin 3,
      ‖(1+1/(![a,b,s] j*c))^(1/2 : ℂ)-![rA,rB,rS] j/(![a,b,s] j*z)‖ ≤
        (101/100 : ℝ)*‖c‖/(‖![a,b,s] j‖*‖z‖^2)) (i : Fin 4) :
    ‖finitePRowForm a b s c z rA rB rS i‖ <
      2400*max (‖b‖*‖s‖^3) (‖b‖^3*‖s‖^2)*‖c‖^3/‖z‖+
        3*‖s‖^2*‖z‖/(‖a‖^3*‖c‖^5) := by
  exact finitePRowForm_norm_lt a b s c z rA rB rS ha hb hs hz hA hAB hBS hC hAC herr i

end

section


example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {S : Finset (𝓞 K)} (hS : IsD1 S) (a : Fin 3 → 𝓞 K) (c d : 𝓞 K)
    (haS : ∀ j, a j ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hinj : Function.Injective a) (hac : ∀ j, a j ≠ c)
    (had : ∀ j, a j ≠ d) (hcd : c ≠ d)
    (hmon : Monotone (fun j => ‖phi (a j : K)‖))
    (hCT : 200*‖phi (a 2 : K)‖ ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖)
    (hAC : 1000 ≤ ‖phi (a 0 : K)‖*‖phi (c : K)‖) :
    ∃ z : 𝓞 K, z^2 = c*d+1 ∧
      1 < 2400*max (‖phi (a 1 : K)‖*‖phi (a 2 : K)‖^3)
          (‖phi (a 1 : K)‖^3*‖phi (a 2 : K)‖^2)*‖phi (c : K)‖^3/‖phi (z : K)‖+
        3*‖phi (a 2 : K)‖^2*‖phi (z : K)‖/
          (‖phi (a 0 : K)‖^3*‖phi (c : K)‖^5) := by
  exact full_ring_finiteP_inequality hK phi hS a c d haS hcS hdS hinj hac had hcd hmon hCT hCD hAC

end

section


example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {S : Finset (𝓞 K)} (hS : IsD1 S) (a : Fin 3 → 𝓞 K) (c d : 𝓞 K)
    (haS : ∀ j, a j ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hinj : Function.Injective a) (hac : ∀ j, a j ≠ c)
    (had : ∀ j, a j ≠ d) (hcd : c ≠ d)
    (hmon : Monotone (fun j => ‖phi (a j : K)‖))
    (hCT : 200*‖phi (a 2 : K)‖ ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖)
    (hAC : 1000 ≤ ‖phi (a 0 : K)‖*‖phi (c : K)‖)
    (hleft : 4*(2400 : ℝ)^2*
      (max (‖phi (a 1 : K)‖*‖phi (a 2 : K)‖^3)
        (‖phi (a 1 : K)‖^3*‖phi (a 2 : K)‖^2))^2*
      ‖phi (c : K)‖^5/(1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤ ‖phi (a 0 : K)‖^6*‖phi (c : K)‖^9/
      (36*‖phi (a 2 : K)‖^4*(1+1/4000 : ℝ))) : False := by
  exact full_ring_finiteP_closed_interval_excluded hK phi hS a c d haS hcS hdS hinj hac had hcd hmon hCT hCD hAC hleft hright

end

end D1Bound5
