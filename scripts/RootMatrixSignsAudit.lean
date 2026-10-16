import D1Bound5.RootMatrixSigns
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Audit the exact simultaneous sign-selection proof and its definition. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.SignedEntryGood,
    `D1Bound5.signed_entry_good_or_neg,
    `D1Bound5.signed_entry_good_swap,
    `D1Bound5.exists_good_symmetric_root_matrix,
    `D1Bound5.exists_good_symmetric_root_matrix_with_roots]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axioms ← Lean.collectAxioms n
    let unexpected := axioms.filter (fun a => !allowed.contains a)
    unless unexpected.isEmpty do
      throwError "Unexpected axioms in {n}: {unexpected}"
    logInfo m!"ROOT_MATRIX_SIGNS_AUDIT {n}: {axioms}"
  logInfo "ROOT_MATRIX_SIGNS_AXIOM_AUDIT_PASS: five declarations"

#print axioms D1Bound5.exists_good_symmetric_root_matrix
#print axioms D1Bound5.exists_good_symmetric_root_matrix_with_roots
#check @D1Bound5.exists_good_symmetric_root_matrix_with_roots
