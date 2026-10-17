import D1Bound5.ProductFiveSignedPrefixInverse
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Check the five actual elaborated theorem declarations and their
   transitive axioms. These are conditional analytic statements, not
   the final D(1) bound-five theorem. -/
run_cmd do
  let targets : List Name :=
    [`D1Bound5.five_compatible_prefix_operator_bound,
     `D1Bound5.five_compatible_inverse_vector_bound,
     `D1Bound5.productFive_bilinear_l2_le,
     `D1Bound5.productFive_selfBilinear_norm_lt_one,
     `D1Bound5.five_compatible_bilinear_p_bound]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in targets do
    let axs ← Lean.collectAxioms n
    let bad := axs.filter fun a => !allowed.contains a
    unless bad.isEmpty do
      throwError "Forbidden transitive axioms for {n}: {bad}"
    logInfo m!"FIVE_PREFIX_INVERSE_AXIOMS_PASS {n}: {axs}"

#check @D1Bound5.five_compatible_prefix_operator_bound
#check @D1Bound5.five_compatible_inverse_vector_bound
#check @D1Bound5.productFive_bilinear_l2_le
#check @D1Bound5.productFive_selfBilinear_norm_lt_one
#check @D1Bound5.five_compatible_bilinear_p_bound
