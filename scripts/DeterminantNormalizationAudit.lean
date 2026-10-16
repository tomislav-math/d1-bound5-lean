import D1Bound5.DeterminantNormalization
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Audit all declarations introduced by the normalization module, not only
selected named theorems. No custom axioms or unsafe proof shortcuts. -/
run_cmd do
  let env ← getEnv
  let names := env.constants.toList.filterMap fun (n, _) =>
    if (`D1Bound5).isPrefixOf n then some n else none
  if names.isEmpty then
    throwError "No D1Bound5 declarations found"
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axioms ← Lean.collectAxioms n
    let forbidden := axioms.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"AUDITED {n}: {axioms}"
  logInfo m!"DET_NORMALIZATION_AXIOMS_PASS: {names.length} declarations"

#check D1Bound5.scaledRootMatrix_det
#check D1Bound5.root_error_quadratic
#check D1Bound5.normalizedRootError_relation
#check D1Bound5.normalizedRootError_diag
#check D1Bound5.normalizedRootError_det
#check D1Bound5.root_error_sub_half
#print axioms D1Bound5.normalizedRootError_det
#print axioms D1Bound5.root_error_sub_half
