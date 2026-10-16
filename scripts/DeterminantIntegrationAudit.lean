import D1Bound5.SignedRootMatrixBounds
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Audit the seven direct determinant results and the same-witness
determinant/adjugate sign-choice bridge. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.symmetricZeroFour_det,
    `D1Bound5.nearHalf_product_nearQuarter,
    `D1Bound5.threePairDetPolynomial_bound,
    `D1Bound5.symmetricZeroFour_det_norm_lt,
    `D1Bound5.symmetric_zero_four_det_upper,
    `D1Bound5.signed_root_matrix_det_upper,
    `D1Bound5.exists_signed_root_matrix_det_upper,
    `D1Bound5.exists_signed_root_matrix_det_and_adjugate_upper]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let bad := axs.filter fun a => !allowed.contains a
    unless bad.isEmpty do
      throwError "Forbidden axioms for {n}: {bad}"
    logInfo m!"DET_AND_ADJ_AXIOMS {n}: {axs}"
  logInfo m!"DET_AND_ADJ_AXIOMS_PASS: {names.length} theorems"

#check @D1Bound5.symmetric_zero_four_det_upper
#check @D1Bound5.signed_root_matrix_det_upper
#check @D1Bound5.exists_signed_root_matrix_det_and_adjugate_upper
#print axioms D1Bound5.exists_signed_root_matrix_det_and_adjugate_upper
