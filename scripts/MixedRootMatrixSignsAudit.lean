import D1Bound5.MixedRootMatrixSigns
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Audit the eight mixed-row normalization theorems. No zero-root,
C>=4, or independent sign-choice hypothesis is introduced. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.signedEntryBounds_swap,
    `D1Bound5.signedEntryBounds_three_or_neg,
    `D1Bound5.signedEntryBounds_twelve_or_neg,
    `D1Bound5.signedEntryBounds_nine_or_neg,
    `D1Bound5.mixedSignedEntryGood_swap,
    `D1Bound5.mixedSignedEntryGood_or_neg,
    `D1Bound5.exists_mixed_symmetric_root_matrix,
    `D1Bound5.exists_mixed_symmetric_root_matrix_with_roots]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axioms ← Lean.collectAxioms n
    let bad := axioms.filter fun a => !allowed.contains a
    unless bad.isEmpty do
      throwError "Forbidden axioms for {n}: {bad}"
    logInfo m!"MIXED_ROOT_SIGNS_AXIOMS {n}: {axioms}"
  logInfo m!"MIXED_ROOT_SIGNS_AUDIT_PASS: {names.length} theorems"

#check @D1Bound5.exists_mixed_symmetric_root_matrix
#check @D1Bound5.exists_mixed_symmetric_root_matrix_with_roots
#print axioms D1Bound5.exists_mixed_symmetric_root_matrix_with_roots
