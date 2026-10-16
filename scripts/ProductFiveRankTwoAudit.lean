import D1Bound5.ProductFiveRankTwo
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Audit exact types and transitive axioms for all nine proofs of the
paper's (integrated-3) rank-two Schur-complement determinant identity. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.rankTwo_det_factor,
    `D1Bound5.rankTwo_det_entries,
    `D1Bound5.productFive_update_entry,
    `D1Bound5.productFive_compressed_entry,
    `D1Bound5.productFive_rankTwo_det_general,
    `D1Bound5.symmetric_inverse_bilinear_swap,
    `D1Bound5.productFive_rankTwo_det_symmetric,
    `D1Bound5.productFiveSchur_eq,
    `D1Bound5.productFiveSchur_det]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let forbidden := axs.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"PRODUCT_FIVE_RANK_TWO_AXIOMS {n}: {axs}"
  logInfo m!"PRODUCT_FIVE_RANK_TWO_AXIOMS_PASS: {names.length} theorems"

#print D1Bound5.productFive_rankTwo_det_general
#print D1Bound5.productFiveSchur_det
