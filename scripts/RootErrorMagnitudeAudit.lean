import D1Bound5.RootErrorMagnitude
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Audit the five new exported theorems and all their transitive dependencies. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.exists_small_root_error,
    `D1Bound5.exists_small_normalized_root_error,
    `D1Bound5.exists_root_error_control,
    `D1Bound5.exists_root_error_three,
    `D1Bound5.exists_root_error_twelve]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axioms ← Lean.collectAxioms n
    let unexpected := axioms.filter (fun a => !allowed.contains a)
    unless unexpected.isEmpty do
      throwError "Unexpected axioms in {n}: {unexpected}"
    logInfo m!"ROOT_ERROR_AUDIT {n}: {axioms}"
  logInfo "ROOT_ERROR_AXIOM_AUDIT_PASS: five theorem dependencies"

#print axioms D1Bound5.exists_small_root_error
#print axioms D1Bound5.exists_root_error_control
#print axioms D1Bound5.exists_root_error_three
#print axioms D1Bound5.exists_root_error_twelve
