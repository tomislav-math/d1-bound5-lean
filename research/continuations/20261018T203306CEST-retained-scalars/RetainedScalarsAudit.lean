import D1Bound5.RetainedMixedFourScalar
import D1Bound5.RetainedMixedScalar
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let names : List Name := [
    `D1Bound5.retained_mixed_four_first_term_lt,
    `D1Bound5.retained_mixed_four_start_scalar_gap,
    `D1Bound5.retained_three_mixed_scalar_gap]
  for name in names do
    let axioms ← Lean.collectAxioms name
    let other := axioms.filter fun x => !allowed.contains x
    unless other.isEmpty do
      throwError "Unexpected axioms in {name}: {other}"
    logInfo m!"RETAINED_SCALAR_AXIOMS_PASS {name}: {axioms}"

#check @D1Bound5.retained_mixed_four_first_term_lt
#check @D1Bound5.retained_mixed_four_start_scalar_gap
#check @D1Bound5.retained_three_mixed_scalar_gap
