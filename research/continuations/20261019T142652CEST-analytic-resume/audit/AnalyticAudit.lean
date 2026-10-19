import D1Bound5.BennettRateLower
import D1Bound5.CoherentThreeSeparated
import D1Bound5.FiniteEtaBound
import D1Bound5.FiniteMBennettIdentity
import D1Bound5.FiniteMFullRing
import D1Bound5.FiniteMHeight
import D1Bound5.FiniteMIntegralRows
import D1Bound5.FiniteMInterval
import D1Bound5.FiniteMMatrix
import D1Bound5.FiniteMResidual
import D1Bound5.FiniteMResidualPoint
import D1Bound5.FiniteMRowBound
import D1Bound5.FiniteRootApproximation
import D1Bound5.FiniteRowRootTransfer
import D1Bound5.FourAnchorVWindow
import D1Bound5.FrontierLargeTuple
import D1Bound5.FullRingDirectFour
import D1Bound5.FullRingThreeSelection
import D1Bound5.ThreeAnchorAlternative
import D1Bound5.ThreeGeneralWindow
import D1Bound5.TwoSmallFifthBound
import D1Bound5.TwoSmallHeightScalar
import D1Bound5.TwoSmallLargeCScalar
import D1Bound5.TwoSmallLargeS
import D1Bound5.TwoSmallLargeSBound
import D1Bound5.TwoSmallLargeTBound
import D1Bound5.TwoSmallLargeTScalar
import D1Bound5.TwoSmallMWindow
import D1Bound5.TwoSmallOrdinaryHeight
import D1Bound5.TwoSmallTupleInputs
import D1Bound5.UnitPairFiniteReduction
import D1Bound5.UnitPairImpossible
import Lean.Elab.Command
import Lean.Util.CollectAxioms

open Lean Elab Command

set_option maxRecDepth 32768

run_cmd do
  let names : List Name := [
    `D1Bound5.bennett_two_rate_scalar_lower,
    `D1Bound5.bennettTwoResidualRate_lower,
    `D1Bound5.bennettTwoResidualRate_norm_lower,
    `D1Bound5.coherent_three_parameter_1000,
    `D1Bound5.coherent_three_separated_bounds,
    `D1Bound5.finite_eta_power_lower,
    `D1Bound5.finite_eta_reciprocal_lt,
    `D1Bound5.finiteMNodes,
    `D1Bound5.finiteMBennettEntry,
    `D1Bound5.finiteM_bennett_identity,
    `D1Bound5.finiteMNodes_injective,
    `D1Bound5.finiteMDividedMatrix_det_ne_zero,
    `D1Bound5.full_ring_finiteM_inequality,
    `D1Bound5.finiteMTermEval_norm_le,
    `D1Bound5.finiteMDividedMatrix_root_height,
    `D1Bound5.finiteMRowForm,
    `D1Bound5.map_finiteMRowForm,
    `D1Bound5.finiteMRowForm_exists_ne_zero,
    `D1Bound5.full_ring_finiteMRowForm_exists_one_le_norm,
    `D1Bound5.full_ring_finiteM_closed_interval_excluded,
    `D1Bound5.FiniteMTerm,
    `D1Bound5.finiteMTermEval,
    `D1Bound5.finiteMTerms,
    `D1Bound5.finiteMRowFactor,
    `D1Bound5.finiteMDividedMatrix,
    `D1Bound5.finiteMMatrix,
    `D1Bound5.finiteMTermWeight,
    `D1Bound5.finiteMTermAdmissible,
    `D1Bound5.finiteMTerms_admissible,
    `D1Bound5.finiteMTerms_weight,
    `D1Bound5.map_finiteMTermEval,
    `D1Bound5.map_finiteMDividedMatrix,
    `D1Bound5.finiteM_rowfactor_scalar,
    `D1Bound5.finiteM_residual_norm_lt,
    `D1Bound5.finiteMResidual,
    `D1Bound5.finiteM_choose_abs,
    `D1Bound5.finiteMRowFactor_ne_zero,
    `D1Bound5.finiteM_residual_identity,
    `D1Bound5.finiteM_residual_norm_lt_point,
    `D1Bound5.finiteMAnchors,
    `D1Bound5.finiteMResidual_eq_root_sum,
    `D1Bound5.finiteMRowForm_eq_root_sum,
    `D1Bound5.finiteMRowForm_norm_lt,
    `D1Bound5.bennett_exists_integral_root_ratio_bound_finite,
    `D1Bound5.finite_row_root_transfer_norm_lt,
    `D1Bound5.four_anchor_V_window_scalar,
    `D1Bound5.IsD1Tuple.four_anchor_V_window,
    `D1Bound5.IsD1Tuple.frontier_large_growth,
    `D1Bound5.IsD1Tuple.direct_four_integer_inequality,
    `D1Bound5.full_ring_three_separated_norm_inequality,
    `D1Bound5.full_ring_four_anchor_three_separated_inequality,
    `D1Bound5.IsD1Tuple.three_anchor_general_alternative,
    `D1Bound5.three_general_window_scalar,
    `D1Bound5.full_ring_three_general_window,
    `D1Bound5.IsD1Tuple.two_small_bounded_fourth_fifth_lt,
    `D1Bound5.IsD1Tuple.two_small_fifth_lt,
    `D1Bound5.twoSmallHeightEnvelope,
    `D1Bound5.twoSmallHeightEnvelope_lt_389,
    `D1Bound5.twoSmallHeightEnvelope_lt_549,
    `D1Bound5.twoSmallHeightEnvelope_lt_eight_mul_sub_three,
    `D1Bound5.twoSmallHeightEnvelope_lt_eight_mul_sub_twenty_seven,
    `D1Bound5.twoSmallHeightEnvelope_lt_seven_mul_add_sixty,
    `D1Bound5.ordinaryLog10_two_small_parameters,
    `D1Bound5.two_small_large_C_V_parameters,
    `D1Bound5.two_small_large_C_direct_four_parameters,
    `D1Bound5.two_small_large_C_seventh_power,
    `D1Bound5.two_small_large_S_parameters,
    `D1Bound5.two_small_large_S_eighth_power,
    `D1Bound5.ordinaryLog10_div,
    `D1Bound5.ordinaryLog10_lt_nat_iff,
    `D1Bound5.twoSmallHeightEnvelope_lt_396,
    `D1Bound5.twoSmallHeightEnvelope_lt_eight_mul_sub_four,
    `D1Bound5.IsD1Tuple.two_small_large_third_bound,
    `D1Bound5.IsD1Tuple.two_small_fourth_bound,
    `D1Bound5.two_small_large_T_lower_window_impossible,
    `D1Bound5.two_small_large_T_quadratic_parameters,
    `D1Bound5.two_small_large_T_quadratic_eighth,
    `D1Bound5.two_small_large_T_quintic_eighth,
    `D1Bound5.two_small_M_window_contains,
    `D1Bound5.two_small_M_window_brackets,
    `D1Bound5.IsD1Tuple.two_small_ordinary_height,
    `D1Bound5.IsD1Tuple.comp_injective_map,
    `D1Bound5.IsD1Tuple.two_small_growth_inputs,
    `D1Bound5.IsD1Tuple.two_small_ordinary_at,
    `D1Bound5.IsD1Tuple.unit_pair_third_norm_ge_eight,
    `D1Bound5.IsD1Tuple.unit_pair_reduced_range,
    `D1Bound5.IsD1Tuple.unit_pair_impossible]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.bennett_two_rate_scalar_lower
#check @D1Bound5.bennettTwoResidualRate_lower
#check @D1Bound5.bennettTwoResidualRate_norm_lower
#check @D1Bound5.coherent_three_parameter_1000
#check @D1Bound5.coherent_three_separated_bounds
#check @D1Bound5.finite_eta_power_lower
#check @D1Bound5.finite_eta_reciprocal_lt
#check @D1Bound5.finiteMNodes
#check @D1Bound5.finiteMBennettEntry
#check @D1Bound5.finiteM_bennett_identity
#check @D1Bound5.finiteMNodes_injective
#check @D1Bound5.finiteMDividedMatrix_det_ne_zero
#check @D1Bound5.full_ring_finiteM_inequality
#check @D1Bound5.finiteMTermEval_norm_le
#check @D1Bound5.finiteMDividedMatrix_root_height
#check @D1Bound5.finiteMRowForm
#check @D1Bound5.map_finiteMRowForm
#check @D1Bound5.finiteMRowForm_exists_ne_zero
#check @D1Bound5.full_ring_finiteMRowForm_exists_one_le_norm
#check @D1Bound5.full_ring_finiteM_closed_interval_excluded
#check @D1Bound5.FiniteMTerm
#check @D1Bound5.finiteMTermEval
#check @D1Bound5.finiteMTerms
#check @D1Bound5.finiteMRowFactor
#check @D1Bound5.finiteMDividedMatrix
#check @D1Bound5.finiteMMatrix
#check @D1Bound5.finiteMTermWeight
#check @D1Bound5.finiteMTermAdmissible
#check @D1Bound5.finiteMTerms_admissible
#check @D1Bound5.finiteMTerms_weight
#check @D1Bound5.map_finiteMTermEval
#check @D1Bound5.map_finiteMDividedMatrix
#check @D1Bound5.finiteM_rowfactor_scalar
#check @D1Bound5.finiteM_residual_norm_lt
#check @D1Bound5.finiteMResidual
#check @D1Bound5.finiteM_choose_abs
#check @D1Bound5.finiteMRowFactor_ne_zero
#check @D1Bound5.finiteM_residual_identity
#check @D1Bound5.finiteM_residual_norm_lt_point
#check @D1Bound5.finiteMAnchors
#check @D1Bound5.finiteMResidual_eq_root_sum
#check @D1Bound5.finiteMRowForm_eq_root_sum
#check @D1Bound5.finiteMRowForm_norm_lt
#check @D1Bound5.bennett_exists_integral_root_ratio_bound_finite
#check @D1Bound5.finite_row_root_transfer_norm_lt
#check @D1Bound5.four_anchor_V_window_scalar
#check @D1Bound5.IsD1Tuple.four_anchor_V_window
#check @D1Bound5.IsD1Tuple.frontier_large_growth
#check @D1Bound5.IsD1Tuple.direct_four_integer_inequality
#check @D1Bound5.full_ring_three_separated_norm_inequality
#check @D1Bound5.full_ring_four_anchor_three_separated_inequality
#check @D1Bound5.IsD1Tuple.three_anchor_general_alternative
#check @D1Bound5.three_general_window_scalar
#check @D1Bound5.full_ring_three_general_window
#check @D1Bound5.IsD1Tuple.two_small_bounded_fourth_fifth_lt
#check @D1Bound5.IsD1Tuple.two_small_fifth_lt
#check @D1Bound5.twoSmallHeightEnvelope
#check @D1Bound5.twoSmallHeightEnvelope_lt_389
#check @D1Bound5.twoSmallHeightEnvelope_lt_549
#check @D1Bound5.twoSmallHeightEnvelope_lt_eight_mul_sub_three
#check @D1Bound5.twoSmallHeightEnvelope_lt_eight_mul_sub_twenty_seven
#check @D1Bound5.twoSmallHeightEnvelope_lt_seven_mul_add_sixty
#check @D1Bound5.ordinaryLog10_two_small_parameters
#check @D1Bound5.two_small_large_C_V_parameters
#check @D1Bound5.two_small_large_C_direct_four_parameters
#check @D1Bound5.two_small_large_C_seventh_power
#check @D1Bound5.two_small_large_S_parameters
#check @D1Bound5.two_small_large_S_eighth_power
#check @D1Bound5.ordinaryLog10_div
#check @D1Bound5.ordinaryLog10_lt_nat_iff
#check @D1Bound5.twoSmallHeightEnvelope_lt_396
#check @D1Bound5.twoSmallHeightEnvelope_lt_eight_mul_sub_four
#check @D1Bound5.IsD1Tuple.two_small_large_third_bound
#check @D1Bound5.IsD1Tuple.two_small_fourth_bound
#check @D1Bound5.two_small_large_T_lower_window_impossible
#check @D1Bound5.two_small_large_T_quadratic_parameters
#check @D1Bound5.two_small_large_T_quadratic_eighth
#check @D1Bound5.two_small_large_T_quintic_eighth
#check @D1Bound5.two_small_M_window_contains
#check @D1Bound5.two_small_M_window_brackets
#check @D1Bound5.IsD1Tuple.two_small_ordinary_height
#check @D1Bound5.IsD1Tuple.comp_injective_map
#check @D1Bound5.IsD1Tuple.two_small_growth_inputs
#check @D1Bound5.IsD1Tuple.two_small_ordinary_at
#check @D1Bound5.IsD1Tuple.unit_pair_third_norm_ge_eight
#check @D1Bound5.IsD1Tuple.unit_pair_reduced_range
#check @D1Bound5.IsD1Tuple.unit_pair_impossible
