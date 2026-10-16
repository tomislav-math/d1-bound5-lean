import D1Bound5.ProductFourNumericalClosure
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Audit the rank-one determinant development and the numerical closure.
   The remaining perturbative bounds are explicit hypotheses. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.bilinear_mulVec_norm_le,
    `D1Bound5.rankOneDeterminant,
    `D1Bound5.adjugate_eq_det_smul_inverse,
    `D1Bound5.rankOneDeterminant_norm_le,
    `D1Bound5.rankOneDeterminant_adjugate_norm_le,
    `D1Bound5.scaledRootMatrix_det_adjugate_norm_le,
    `D1Bound5.productFour_numeric,
    `D1Bound5.productFour_rankOne_numeric,
    `D1Bound5.productFour_growth_from_bounds]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let bad := axs.filter fun a => !allowed.contains a
    unless bad.isEmpty do
      throwError "Forbidden axioms for {n}: {bad}"
    logInfo m!"PRODUCT_FOUR_AXIOM_AUDIT {n}: {axs}"
  logInfo m!"PRODUCT_FOUR_AXIOM_AUDIT_PASS: {names.length} theorems"

#check @D1Bound5.rankOneDeterminant_adjugate_norm_le
#check @D1Bound5.scaledRootMatrix_det_adjugate_norm_le
#check @D1Bound5.productFour_numeric
#check @D1Bound5.productFour_rankOne_numeric
#check @D1Bound5.productFour_growth_from_bounds
#print axioms D1Bound5.productFour_growth_from_bounds
