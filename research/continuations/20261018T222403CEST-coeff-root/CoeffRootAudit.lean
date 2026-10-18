import D1Bound5.BennettTwoCoefficientConstants
import D1Bound5.BennettRootApproximation
import D1Bound5.BennettLocalCoefficientBound
import D1Bound5.BennettTwoEntryBounds
import D1Bound5.BennettHeightNormalization
import D1Bound5.BennettTwoHeightBounds
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let names : List Name := [`D1Bound5.bennett_two_local_radius_product,
    `D1Bound5.bennett_two_row_radius_power_le,
    `D1Bound5.bennett_two_distance_ratio_le,
    `D1Bound5.bennett_two_coefficient_rounding,
    `D1Bound5.bennett_prefactor_absorb,
    `D1Bound5.bennett_exists_sign_root_error,
    `D1Bound5.bennett_root_ratio_square_error,
    `D1Bound5.bennett_exists_integral_root_ratio,
    `D1Bound5.bennett_exists_integral_root_ratio_bound,
    `D1Bound5.bennettTwoNodes_branch_one_two,
    `D1Bound5.bennettClearedTaylor_two_poles_weighted_norm_le,
    `D1Bound5.bennettClearedTaylor_two_poles_norm_le,
    `D1Bound5.bennettTwoClearedEntry_one_norm_le_local,
    `D1Bound5.bennettTwoClearedEntry_two_norm_le_local,
    `D1Bound5.bennett_two_scaled_radius_ratio_le,
    `D1Bound5.bennett_two_height_normalization,
    `D1Bound5.bennettTwoClearedEntry_height_bounds]
  for name in names do
    let axioms ← Lean.collectAxioms name
    let other := axioms.filter fun x => !allowed.contains x
    unless other.isEmpty do
      throwError "Unexpected axioms in {name}: {other}"
    logInfo m!"COEFF_ROOT_AXIOMS_PASS {name}: {axioms}"

#check @D1Bound5.bennett_two_local_radius_product
#check @D1Bound5.bennett_two_row_radius_power_le
#check @D1Bound5.bennett_two_distance_ratio_le
#check @D1Bound5.bennett_two_coefficient_rounding
#check @D1Bound5.bennett_prefactor_absorb
#check @D1Bound5.bennett_exists_sign_root_error
#check @D1Bound5.bennett_root_ratio_square_error
#check @D1Bound5.bennett_exists_integral_root_ratio
#check @D1Bound5.bennett_exists_integral_root_ratio_bound
#check @D1Bound5.bennettTwoNodes_branch_one_two
#check @D1Bound5.bennettClearedTaylor_two_poles_weighted_norm_le
#check @D1Bound5.bennettClearedTaylor_two_poles_norm_le
#check @D1Bound5.bennettTwoClearedEntry_one_norm_le_local
#check @D1Bound5.bennettTwoClearedEntry_two_norm_le_local
#check @D1Bound5.bennett_two_scaled_radius_ratio_le
#check @D1Bound5.bennett_two_height_normalization
#check @D1Bound5.bennettTwoClearedEntry_height_bounds
