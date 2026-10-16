import D1Bound5.RootMatrixOperatorBound
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Verify the exact spectral norm bound, including the simultaneous
ring-valued signs theorem and the transitive dependencies. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.four_zero_diagonal_operator_norm_lt,
    `D1Bound5.halfOffDiagonal,
    `D1Bound5.signed_root_matrix_operator_bound,
    `D1Bound5.exists_signed_root_matrix_operator_bound]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axioms ← Lean.collectAxioms n
    let unexpected := axioms.filter (fun a => !allowed.contains a)
    unless unexpected.isEmpty do
      throwError "Unexpected axiom dependency in {n}: {unexpected}"
    logInfo m!"MATRIX_SPECTRAL_AUDIT {n}: {axioms}"
  logInfo "MATRIX_SPECTRAL_AXIOM_AUDIT_PASS: four declarations"

#print axioms D1Bound5.four_zero_diagonal_operator_norm_lt
#print axioms D1Bound5.signed_root_matrix_operator_bound
#print axioms D1Bound5.exists_signed_root_matrix_operator_bound
#check @D1Bound5.exists_signed_root_matrix_operator_bound
