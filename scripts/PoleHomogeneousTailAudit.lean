import D1Bound5.PoleHomogeneousTail
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Exact elaborated theorem type exposure and transitive axiom audit. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.reciprocal_pole_finite_tail,
    `D1Bound5.weighted_poles_finite_tail,
    `D1Bound5.reciprocal_pole_hsymm_finite_tail]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let forbidden := axs.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"POLE_TAIL_AXIOMS {n}: {axs}"
  logInfo m!"POLE_TAIL_AXIOMS_PASS: {names.length} theorems"

#check @D1Bound5.reciprocal_pole_finite_tail
#check @D1Bound5.weighted_poles_finite_tail
#check @D1Bound5.reciprocal_pole_hsymm_finite_tail
