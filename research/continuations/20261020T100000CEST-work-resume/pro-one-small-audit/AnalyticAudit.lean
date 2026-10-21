import D1Bound5.OneSmallReducedImpossible
import D1Bound5.OneSmallImpossible
import Lean.Elab.Command
import Lean.Util.CollectAxioms
open scoped NumberField
open Module
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
run_cmd do
  let names : List Lean.Name := [`D1Bound5.IsD1Tuple.one_small_reduced_impossible,
    `D1Bound5.IsD1Tuple.not_one_small]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"ONE_SMALL_AXIOMS_PASS {name}: {ax}"
namespace D1Bound5

example
{K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hsize :
      (‖phi (a 0 : K)‖^2=1 ∧ 9≤‖phi (a 1 : K)‖^2 ∧ ‖phi (a 1 : K)‖^2<64) ∨
      (‖phi (a 0 : K)‖^2=2 ∧ 9≤‖phi (a 1 : K)‖^2 ∧ ‖phi (a 1 : K)‖^2<16)) : False :=
  IsD1Tuple.one_small_reduced_impossible hK phi a ha hmon hsize

example
{K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hA : ‖phi (a 0 : K)‖ < 3) (hB : 3 ≤ ‖phi (a 1 : K)‖) : False :=
  IsD1Tuple.not_one_small hK phi a ha hmon hA hB

end D1Bound5
#check @_root_.D1Bound5.IsD1Tuple.one_small_reduced_impossible
#check @_root_.D1Bound5.IsD1Tuple.not_one_small
