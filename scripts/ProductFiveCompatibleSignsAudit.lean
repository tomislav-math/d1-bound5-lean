import D1Bound5.ProductFiveCompatibleSigns
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Audit every public declaration introduced by this module, including
   the sign-quality definition. Types retain all original ring/tuple inputs. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.signedEntryBounds_fiftyfour_or_neg,
    `D1Bound5.FiveSignedEntryGood,
    `D1Bound5.fiveSignedEntryGood_swap,
    `D1Bound5.fiveSignedEntryGood_or_neg,
    `D1Bound5.exists_five_signed_root_matrix,
    `D1Bound5.fiveSignedEntryGood_prefix,
    `D1Bound5.fiveSignedEntryGood_last_column,
    `D1Bound5.exists_five_signed_root_matrix_with_bounds,
    `D1Bound5.IsD1Tuple.five_last_modulus_gt_fiftyfour,
    `D1Bound5.IsD1Tuple.exists_five_compatible_signed_matrix,
    `D1Bound5.fiveLastColumn_l2_bounds]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let bad := axs.filter fun a => !allowed.contains a
    unless bad.isEmpty do
      throwError "Forbidden axioms for {n}: {bad}"
    logInfo m!"FIVE_SIGNS_AXIOMS {n}: {axs}"
  logInfo m!"FIVE_SIGNS_AXIOMS_PASS: {names.length} declarations"

#check @D1Bound5.signedEntryBounds_fiftyfour_or_neg
#check @D1Bound5.FiveSignedEntryGood
#check @D1Bound5.fiveSignedEntryGood_swap
#check @D1Bound5.fiveSignedEntryGood_or_neg
#check @D1Bound5.exists_five_signed_root_matrix
#check @D1Bound5.fiveSignedEntryGood_prefix
#check @D1Bound5.fiveSignedEntryGood_last_column
#check @D1Bound5.exists_five_signed_root_matrix_with_bounds
#check @D1Bound5.IsD1Tuple.five_last_modulus_gt_fiftyfour
#check @D1Bound5.IsD1Tuple.exists_five_compatible_signed_matrix
#check @D1Bound5.fiveLastColumn_l2_bounds
