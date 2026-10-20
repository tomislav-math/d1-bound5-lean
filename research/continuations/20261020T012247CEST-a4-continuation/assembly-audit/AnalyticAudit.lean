import D1Bound5.AllLargeForcedPWindow
import Lean.Elab.Command
import Lean.Util.CollectAxioms
open Lean Elab Command
open scoped NumberField
open Module
set_option maxRecDepth 32768
run_cmd do
  let names : List Name := [
    `D1Bound5.IsD1Tuple.all_large_forced_P_window]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.IsD1Tuple.all_large_forced_P_window

open Finset Polynomial
namespace D1Bound5
section


example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hA : 3 ≤ ‖phi (a 0 : K)‖) :
    let A := ‖phi (a 0 : K)‖
    let B := ‖phi (a 1 : K)‖
    let S := ‖phi (a 2 : K)‖
    let C := ‖phi (a 4 : K)‖
    let D := ‖phi (a 5 : K)‖
    (allLargeWindowP A B S C).1 ≤ D ∧ D ≤ (allLargeWindowP A B S C).2 := by
  exact IsD1Tuple.all_large_forced_P_window hK phi a ha hmon hA

end

end D1Bound5
