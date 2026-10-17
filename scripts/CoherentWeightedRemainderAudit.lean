import D1Bound5.CoherentWeightedRemainder
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Verify the exact elaborated statement and the complete axiom closure. -/
run_cmd do
  let name : Name := `D1Bound5.coherent_weighted_remainder_summable_and_norm_le
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let axioms ← Lean.collectAxioms name
  let forbidden := axioms.filter fun a => !allowed.contains a
  unless forbidden.isEmpty do
    throwError "Forbidden axioms for {name}: {forbidden}"
  logInfo m!"COHERENT_WEIGHTED_REMAINDER_AXIOMS_PASS {name}: {axioms}"

#check @D1Bound5.coherent_weighted_remainder_summable_and_norm_le
