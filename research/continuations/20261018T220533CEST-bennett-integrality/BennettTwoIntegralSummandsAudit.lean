import D1Bound5.BennettTwoIntegralSummands
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let names : List Name := [`D1Bound5.bennett_two_integral_summand_zero,
    `D1Bound5.bennett_two_integral_summand_one,
    `D1Bound5.bennett_two_integral_summand_two]
  for name in names do
    let axioms ← Lean.collectAxioms name
    let other := axioms.filter fun x => !allowed.contains x
    unless other.isEmpty do
      throwError "Unexpected axioms in {name}: {other}"
    logInfo m!"INTEGRALITY_AXIOMS_PASS {name}: {axioms}"

#check @D1Bound5.bennett_two_integral_summand_zero
#check @D1Bound5.bennett_two_integral_summand_one
#check @D1Bound5.bennett_two_integral_summand_two
