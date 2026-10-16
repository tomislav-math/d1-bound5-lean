import D1Bound5.ProductFourLargeBranch
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Audit the three new large-entry product-four branch theorems,
including all transitive dependencies and their exact elaborated types. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.productFour_ordered_square_sum,
    `D1Bound5.productFour_tail_large,
    `D1Bound5.full_ring_productFour_large_growth]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axioms ← Lean.collectAxioms n
    let forbidden := axioms.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"PRODUCT_FOUR_LARGE_BRANCH_AXIOMS {n}: {axioms}"
  logInfo m!"PRODUCT_FOUR_LARGE_BRANCH_AUDIT_PASS {names.length} theorems"

#check @D1Bound5.productFour_ordered_square_sum
#check @D1Bound5.productFour_tail_large
#check @D1Bound5.full_ring_productFour_large_growth
#print axioms D1Bound5.full_ring_productFour_large_growth
