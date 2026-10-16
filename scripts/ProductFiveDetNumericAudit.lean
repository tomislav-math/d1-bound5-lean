import D1Bound5.ProductFiveDetNumeric
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Exact-type and transitive axiom audit of the quantitative
rank-two determinant margin; no trust shortcuts permitted. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.productFive_scalar_det_upper,
    `D1Bound5.productFive_schur_det_upper_of_bilinear_bounds]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let forbidden := axs.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"PRODUCT_FIVE_NUMERIC_AXIOMS {n}: {axs}"
  logInfo m!"PRODUCT_FIVE_NUMERIC_AXIOMS_PASS: {names.length} theorems"

#check D1Bound5.productFive_scalar_det_upper
#check D1Bound5.productFive_schur_det_upper_of_bilinear_bounds
