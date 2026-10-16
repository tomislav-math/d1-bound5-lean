import D1Bound5.ProductFivePrefixDet
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Exact elaborated types and transitive axiom audit for the sharper
product-five prefix determinant certificate. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.threePair_quadratic_norm_le,
    `D1Bound5.mixedThreePairDet_norm_lt_33_128,
    `D1Bound5.mixedSymmetricFour_det_lt_33_128,
    `D1Bound5.mixed_zero_four_det_norm_lt_33_128]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let forbidden := axs.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"PRODUCT_FIVE_PREFIX_AXIOMS {n}: {axs}"
  logInfo m!"PRODUCT_FIVE_PREFIX_AXIOMS_PASS: {names.length} theorems"

#check D1Bound5.threePair_quadratic_norm_le
#check D1Bound5.mixedThreePairDet_norm_lt_33_128
#check D1Bound5.mixedSymmetricFour_det_lt_33_128
#check D1Bound5.mixed_zero_four_det_norm_lt_33_128
