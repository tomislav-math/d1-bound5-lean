import D1Bound5.CoherentRetainedMixedForms
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for name in [`D1Bound5.CoherentRetainedRow,
      `D1Bound5.CoherentRetainedRow.parameters,
      `D1Bound5.full_ring_retained_three_mixed_lower_upper] do
    let axioms ← Lean.collectAxioms name
    let unexpected := axioms.filter fun a => !allowed.contains a
    unless unexpected.isEmpty do
      throwError "Unexpected axioms in {name}: {unexpected}"
    logInfo m!"MIXED_FORM_AXIOMS_PASS {name}: {axioms}"

#print D1Bound5.CoherentRetainedRow
#check @D1Bound5.CoherentRetainedRow.parameters
#check @D1Bound5.full_ring_retained_three_mixed_lower_upper
