import D1Bound5.ProductFiveBlockDet
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Audit the generic scalar Schur complement and the five-entry block determinant. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.scalar_last_block_det,
    `D1Bound5.productFiveIntegratedBlock_det]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let forbidden := axs.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"PRODUCT_FIVE_BLOCK_AXIOMS {n}: {axs}"
  logInfo m!"PRODUCT_FIVE_BLOCK_AXIOMS_PASS: {names.length} theorems"

#check D1Bound5.scalar_last_block_det
#check D1Bound5.productFiveIntegratedBlock_det
