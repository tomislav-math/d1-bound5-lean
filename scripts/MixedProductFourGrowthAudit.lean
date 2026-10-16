import D1Bound5.MixedProductFourGrowth
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Audit exact types and transitive axioms of the mixed product-four closure. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.mixed_four_det_ne_zero_of_entry_bounds,
    `D1Bound5.productFour_mixed_numeric,
    `D1Bound5.productFour_mixed_rankOne_numeric,
    `D1Bound5.productFour_mixed_growth_from_bounds,
    `D1Bound5.full_ring_productFour_mixed_growth,
    `D1Bound5.IsD1Tuple.productFour_mixed_growth]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let forbidden := axs.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"MIXED_PRODUCT_FOUR_AXIOMS {n}: {axs}"
  logInfo m!"MIXED_PRODUCT_FOUR_AXIOMS_PASS: {names.length} theorems"

#print D1Bound5.full_ring_productFour_mixed_growth
#print D1Bound5.IsD1Tuple.productFour_mixed_growth
