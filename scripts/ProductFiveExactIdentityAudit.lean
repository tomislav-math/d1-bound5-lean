import D1Bound5.ProductFiveExactIdentity
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Audit the actual normalized five-entry rank-two identity. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.five_prefix_symmetric,
    `D1Bound5.five_normalized_error_symmetric,
    `D1Bound5.five_normalized_root_det_rankTwo]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let forbidden := axs.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"PRODUCT_FIVE_EXACT_AXIOMS {n}: {axs}"
  logInfo m!"PRODUCT_FIVE_EXACT_AXIOMS_PASS: {names.length} theorems"

#check D1Bound5.five_prefix_symmetric
#check D1Bound5.five_normalized_error_symmetric
#check D1Bound5.five_normalized_root_det_rankTwo
