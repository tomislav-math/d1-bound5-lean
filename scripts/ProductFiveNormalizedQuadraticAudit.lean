import D1Bound5.ProductFiveNormalizedQuadratic
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Exact elaborated types and enforced transitive axiom policy for
normalized product-five quadratic bounds. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.productFive_quadratic_q_div_norm_lt,
    `D1Bound5.productFive_p_div_sq_norm_lt]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let forbidden := axs.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"PRODUCT_FIVE_QUADRATIC_AXIOMS {n}: {axs}"
  logInfo m!"PRODUCT_FIVE_QUADRATIC_AXIOMS_PASS: {names.length} theorems"

#check @D1Bound5.productFive_quadratic_q_div_norm_lt
#check @D1Bound5.productFive_p_div_sq_norm_lt
