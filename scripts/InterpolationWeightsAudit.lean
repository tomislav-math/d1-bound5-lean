import D1Bound5.InterpolationWeights
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Check every declaration in the five newly integrated modules, including the definition. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.homogeneousMultisetSum,
    `D1Bound5.homogeneousMultisetSum_eq_hsymm,
    `D1Bound5.homogeneousMultisetSum_option_succ,
    `D1Bound5.homogeneousMultisetSum_zero,
    `D1Bound5.homogeneousMultisetSum_option_closed,
    `D1Bound5.hsymm_aeval_option_succ,
    `D1Bound5.hsymm_aeval_option_closed,
    `D1Bound5.barycentric_denominator_insert,
    `D1Bound5.barycentric_sum_insert_cancel,
    `D1Bound5.lagrange_power_moment_insert,
    `D1Bound5.homogeneousMultisetSum_equiv,
    `D1Bound5.homogeneousMultisetSum_insert,
    `D1Bound5.homogeneousMultisetSum_singleton,
    `D1Bound5.lagrange_power_moment_eq_homogeneousMultisetSum,
    `D1Bound5.lagrange_power_moment_eq_hsymm,
    `D1Bound5.reciprocal_vandermonde_product,
    `D1Bound5.reciprocal_anchor_weight_term,
    `D1Bound5.reciprocal_vandermonde_reverse,
    `D1Bound5.reciprocal_anchor_weight_standard,
    `D1Bound5.reciprocal_anchor_sum_transfer,
    `D1Bound5.reciprocal_anchor_first_nonzero,
    `D1Bound5.reciprocal_anchor_sum_eq_hsymm]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let forbidden := axs.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"INTERPOLATION_AXIOMS {n}: {axs}"
  logInfo m!"INTERPOLATION_AXIOMS_PASS: {names.length} declarations"

#check @D1Bound5.homogeneousMultisetSum
#check @D1Bound5.homogeneousMultisetSum_eq_hsymm
#check @D1Bound5.homogeneousMultisetSum_option_succ
#check @D1Bound5.homogeneousMultisetSum_zero
#check @D1Bound5.homogeneousMultisetSum_option_closed
#check @D1Bound5.hsymm_aeval_option_succ
#check @D1Bound5.hsymm_aeval_option_closed
#check @D1Bound5.barycentric_denominator_insert
#check @D1Bound5.barycentric_sum_insert_cancel
#check @D1Bound5.lagrange_power_moment_insert
#check @D1Bound5.homogeneousMultisetSum_equiv
#check @D1Bound5.homogeneousMultisetSum_insert
#check @D1Bound5.homogeneousMultisetSum_singleton
#check @D1Bound5.lagrange_power_moment_eq_homogeneousMultisetSum
#check @D1Bound5.lagrange_power_moment_eq_hsymm
#check @D1Bound5.reciprocal_vandermonde_product
#check @D1Bound5.reciprocal_anchor_weight_term
#check @D1Bound5.reciprocal_vandermonde_reverse
#check @D1Bound5.reciprocal_anchor_weight_standard
#check @D1Bound5.reciprocal_anchor_sum_transfer
#check @D1Bound5.reciprocal_anchor_first_nonzero
#check @D1Bound5.reciprocal_anchor_sum_eq_hsymm
