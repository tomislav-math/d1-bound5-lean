import D1Bound5.ProductFiveMatrixBridge
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Audit the exact five-entry realization of (integrated-3). -/
run_cmd do
  let names : List Name := [
    `D1Bound5.five_reindex_rankOne_plus_error,
    `D1Bound5.five_integrated_det_of_symmetric_error,
    `D1Bound5.five_normalized_root_det]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let forbidden := axs.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"PRODUCT_FIVE_MATRIX_AXIOMS {n}: {axs}"
  logInfo m!"PRODUCT_FIVE_MATRIX_AXIOMS_PASS: {names.length} theorems"

#check D1Bound5.five_reindex_rankOne_plus_error
#check D1Bound5.five_integrated_det_of_symmetric_error
#check D1Bound5.five_normalized_root_det
