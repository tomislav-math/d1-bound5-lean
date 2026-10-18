import D1Bound5.CoherentRetainedMixedGap
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for name in [`D1Bound5.coherent_retained_mixed_size_parameters,
      `D1Bound5.CoherentRetainedRow,
      `D1Bound5.CoherentRetainedRow.parameters,
      `D1Bound5.full_ring_retained_three_mixed_lower_upper,
      `D1Bound5.coherent_retained_mixed_coefficient_gt_one,
      `D1Bound5.full_ring_retained_three_mixed_gap] do
    let axioms ← Lean.collectAxioms name
    let unexpected := axioms.filter fun a => !allowed.contains a
    unless unexpected.isEmpty do
      throwError "Unexpected axioms in {name}: {unexpected}"
    logInfo m!"MIXED_BRIDGE_AXIOMS_PASS {name}: {axioms}"

#check @D1Bound5.coherent_retained_mixed_size_parameters
#print D1Bound5.CoherentRetainedRow
#check @D1Bound5.CoherentRetainedRow.parameters
#check @D1Bound5.full_ring_retained_three_mixed_lower_upper
#check @D1Bound5.coherent_retained_mixed_coefficient_gt_one
#check @D1Bound5.full_ring_retained_three_mixed_gap
