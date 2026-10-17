import D1Bound5.ProductFiveSchurNear
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Exact elaborated types and enforced transitive axiom policy. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.four_all_entries_operator_norm_lt,
    `D1Bound5.productFive_schur_near_of_entrywise,
    `D1Bound5.productFive_schur_scalar_correction_lt,
    `D1Bound5.productFive_schur_near_of_coordinate_bounds,
    `D1Bound5.productFive_prefix_coordinate_div_lt_eighteenth]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let forbidden := axs.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"PRODUCT_FIVE_SCHUR_AXIOMS {n}: {axs}"
  logInfo m!"PRODUCT_FIVE_SCHUR_AXIOMS_PASS: {names.length} theorems"

#check @D1Bound5.four_all_entries_operator_norm_lt
#check @D1Bound5.productFive_schur_near_of_entrywise
#check @D1Bound5.productFive_schur_scalar_correction_lt
#check @D1Bound5.productFive_schur_near_of_coordinate_bounds
#check @D1Bound5.productFive_prefix_coordinate_div_lt_eighteenth
