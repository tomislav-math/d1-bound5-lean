import D1Bound5.CoherentRetainedMixedSizes
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let name := `D1Bound5.coherent_retained_mixed_size_parameters
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let axioms ← Lean.collectAxioms name
  let unexpected := axioms.filter fun a => !allowed.contains a
  unless unexpected.isEmpty do
    throwError "Unexpected axioms in {name}: {unexpected}"
  logInfo m!"MIXED_SIZE_AXIOMS_PASS {name}: {axioms}"

#check @D1Bound5.coherent_retained_mixed_size_parameters
