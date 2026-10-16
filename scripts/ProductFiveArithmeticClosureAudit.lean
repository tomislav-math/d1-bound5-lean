import D1Bound5.ProductFiveArithmeticClosure
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Check transitive axioms and elaborated types of the arithmetic product-five endpoint. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.five_root_det_ne_zero_of_schur,
    `D1Bound5.five_schur_det_ne_zero_of_near,
    `D1Bound5.full_ring_productFive_arithmetic_growth,
    `D1Bound5.full_ring_productFive_growth_of_schur_estimates]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let forbidden := axs.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"PRODUCT_FIVE_ARITHMETIC_AXIOMS {n}: {axs}"
  logInfo m!"PRODUCT_FIVE_ARITHMETIC_AXIOMS_PASS: {names.length} theorems"

#check D1Bound5.five_root_det_ne_zero_of_schur
#check D1Bound5.five_schur_det_ne_zero_of_near
#check D1Bound5.full_ring_productFive_arithmetic_growth
#check D1Bound5.full_ring_productFive_growth_of_schur_estimates
