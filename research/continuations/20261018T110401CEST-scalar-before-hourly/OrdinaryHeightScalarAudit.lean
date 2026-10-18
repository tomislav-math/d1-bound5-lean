import D1Bound5.OrdinaryHeightScalar
import Lean.Util.CollectAxioms

open Lean Elab Command

-- Expose every theorem type and enforce the standard transitive axiom baseline.
run_cmd do
  let targets : List Name := [
    `D1Bound5.ordinary_integer_orders_log_bound,
    `D1Bound5.ordinary_height_scalar_envelope,
    `D1Bound5.unit_pair_height_cutoff_scalar]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for target in targets do
    let axs ← Lean.collectAxioms target
    let unexpected := axs.filter fun a => !allowed.contains a
    unless unexpected.isEmpty do
      throwError "Forbidden axioms in {target}: {unexpected}"
    logInfo m!"SCALAR_AXIOMS_PASS {target}: {axs}"

set_option pp.all true in
#check @D1Bound5.ordinary_integer_orders_log_bound
#check @D1Bound5.ordinary_height_scalar_envelope
#check @D1Bound5.unit_pair_height_cutoff_scalar
