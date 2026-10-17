import D1Bound5.ProductFiveTupleGrowth
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Exact theorem type exposure and enforced transitive axiom policy. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.productFive_prefix_sq_lt_last_div_nine,
    `D1Bound5.productFive_prefix_l2_lt_last_div_nine,
    `D1Bound5.productFive_cross_div_norm_lt_11_108,
    `D1Bound5.IsD1Tuple.five_compatible_schur_near,
    `D1Bound5.IsD1Tuple.exists_five_signed_schur_witness,
    `D1Bound5.IsD1Tuple.five_compatible_schur_det_small,
    `D1Bound5.IsD1Tuple.productFive_growth]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let forbidden := axs.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"PRODUCT_FIVE_TUPLE_AXIOMS {n}: {axs}"
  logInfo m!"PRODUCT_FIVE_TUPLE_AXIOMS_PASS: {names.length} theorems"

#check @D1Bound5.productFive_prefix_sq_lt_last_div_nine
#check @D1Bound5.productFive_prefix_l2_lt_last_div_nine
#check @D1Bound5.productFive_cross_div_norm_lt_11_108
#check @D1Bound5.IsD1Tuple.five_compatible_schur_near
#check @D1Bound5.IsD1Tuple.exists_five_signed_schur_witness
#check @D1Bound5.IsD1Tuple.five_compatible_schur_det_small
#check @D1Bound5.IsD1Tuple.productFive_growth
