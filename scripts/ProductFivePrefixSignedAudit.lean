import D1Bound5.ProductFivePrefixSigned
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Exact elaborated types and transitive axiom audit for the five-entry
prefix determinant transfer from one integral mixed signed-root matrix. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.mixed_signed_root_det_upper_33_128,
    `D1Bound5.five_prefix_det_upper_of_mixed_signed_entries]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let forbidden := axs.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"PRODUCT_FIVE_PREFIX_SIGNED_AXIOMS {n}: {axs}"
  logInfo m!"PRODUCT_FIVE_PREFIX_SIGNED_AXIOMS_PASS: {names.length} theorems"

#check D1Bound5.mixed_signed_root_det_upper_33_128
#check D1Bound5.five_prefix_det_upper_of_mixed_signed_entries
