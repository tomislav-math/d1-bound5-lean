import D1Bound5.BennettTwoDenominatorClearing
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let names : List Name := [
    `D1Bound5.bennett_cancel_power_denominator,
    `D1Bound5.bennett_two_clear_column_zero,
    `D1Bound5.bennett_two_clear_column_one,
    `D1Bound5.bennett_two_clear_column_two,
    `D1Bound5.bennett_two_clear_column_zero_signed,
    `D1Bound5.bennett_two_clear_column_one_signed]
  for name in names do
    let axioms ← Lean.collectAxioms name
    let other := axioms.filter fun x => !allowed.contains x
    unless other.isEmpty do
      throwError "Unexpected axioms in {name}: {other}"
    logInfo m!"BENNETT_TWO_CLEAR_AXIOMS_PASS {name}: {axioms}"

#check @D1Bound5.bennett_cancel_power_denominator
#check @D1Bound5.bennett_two_clear_column_zero
#check @D1Bound5.bennett_two_clear_column_one
#check @D1Bound5.bennett_two_clear_column_two
#check @D1Bound5.bennett_two_clear_column_zero_signed
#check @D1Bound5.bennett_two_clear_column_one_signed
