import D1Bound5.CrossBlockDeterminant
import D1Bound5.CoherentAnalyticInterpolation
import D1Bound5.BennettResidualDeterminant
import D1Bound5.BennettResidueCoefficient
import D1Bound5.BennettFirstOrder
import D1Bound5.BennettFirstOrderResidues
import D1Bound5.BennettPoleSeries
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let names : List Name := [
    `D1Bound5.crossBlock_rootMatrix_det_ne_zero,
    `D1Bound5.full_ring_crossBlock_rootMatrix_one_le_norm,
    `D1Bound5.coherent_anchor_power_moment_low,
    `D1Bound5.coherent_anchor_power_moment_high,
    `D1Bound5.coherent_interpolation_series_exact,
    `D1Bound5.coherent_half_binomial_exact,
    `D1Bound5.coherent_half_binomial_exact_split,
    `D1Bound5.coherent_half_binomial_full_tail_norm_le,
    `D1Bound5.coherent_interpolation_normalization,
    `D1Bound5.coherent_half_binomial_manuscript_tail_norm_le,
    `D1Bound5.coherent_half_binomial_manuscript_anchor_radius,
    `D1Bound5.coherent_cpow_half_sq,
    `D1Bound5.coherent_analytic_terminal_root_sq,
    `D1Bound5.coherent_analytic_anchor_root_sq,
    `D1Bound5.coherent_analytic_anchor_root_eq_or_eq_neg,
    `D1Bound5.dvd_det_of_dvd_column_combination,
    `D1Bound5.polynomial_det_natDegree_le_sum,
    `D1Bound5.polynomial_eq_top_monomial_of_X_pow_dvd,
    `D1Bound5.polynomial_det_eq_monomial_of_residual,
    `D1Bound5.polynomial_det_eq_monomial_of_uniform_residual,
    `D1Bound5.clearedPoleNumerator,
    `D1Bound5.clearedPoleNumerator_monic,
    `D1Bound5.clearedPoleNumerator_natDegree,
    `D1Bound5.clearedPoleNumerator_top_coeff,
    `D1Bound5.coeff_eq_sum_simple_residues,
    `D1Bound5.sum_simple_residues_eq_zero_of_degree_gap,
    `D1Bound5.lagrangeDifferentiation,
    `D1Bound5.lagrangeDifferentiation_moment,
    `D1Bound5.bennettFirstOrderMonomial,
    `D1Bound5.bennettFirstOrderMonomial_natDegree_le,
    `D1Bound5.bennettFirstOrderMonomial_eval,
    `D1Bound5.bennettFirstOrderCoefficients,
    `D1Bound5.bennettFirstOrderCoefficients_det,
    `D1Bound5.vandermonde_mul_bennettFirstOrderCoefficients,
    `D1Bound5.bennettFirstOrderOperator,
    `D1Bound5.bennettFirstOrderOperator_mul_vandermonde,
    `D1Bound5.bennettFirstOrderOperator_det,
    `D1Bound5.bennettFirstOrderReverse_det,
    `D1Bound5.bennettFirstOrderResidue,
    `D1Bound5.bennettFirstOrderResidue_det,
    `D1Bound5.eval_derivative_basisDivisor,
    `D1Bound5.lagrangeDifferentiation_diagonal,
    `D1Bound5.lagrange_basis_eq_weight_mul_nodal_erase,
    `D1Bound5.nodalWeight_mul_lagrangeDifferentiation_offDiagonal,
    `D1Bound5.bennettFirstOrderExplicit,
    `D1Bound5.bennettFirstOrderResidue_eq_explicit,
    `D1Bound5.bennettFirstOrderExplicit_det,
    `D1Bound5.three_halves_sub_natCast_ne_zero,
    `D1Bound5.bennettFirstOrderExplicit_det_ne_zero,
    `D1Bound5.bennettPoleSeries,
    `D1Bound5.bennettPoleSeries_coeff,
    `D1Bound5.bennettNegativeBinomial_mul,
    `D1Bound5.bennettPoleSeries_mul]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axioms ← Lean.collectAxioms n
    let extra := axioms.filter fun a => !allowed.contains a
    unless extra.isEmpty do
      throwError "Forbidden axioms in {n}: {extra}"
    logInfo m!"CONTINUATION_AXIOMS {n}: {axioms}"
  logInfo m!"CONTINUATION_AXIOMS_PASS: {names.length} declarations"

#check @D1Bound5.crossBlock_rootMatrix_det_ne_zero
#check @D1Bound5.full_ring_crossBlock_rootMatrix_one_le_norm
#check @D1Bound5.coherent_anchor_power_moment_low
#check @D1Bound5.coherent_anchor_power_moment_high
#check @D1Bound5.coherent_interpolation_series_exact
#check @D1Bound5.coherent_half_binomial_exact
#check @D1Bound5.coherent_half_binomial_exact_split
#check @D1Bound5.coherent_half_binomial_full_tail_norm_le
#check @D1Bound5.coherent_interpolation_normalization
#check @D1Bound5.coherent_half_binomial_manuscript_tail_norm_le
#check @D1Bound5.coherent_half_binomial_manuscript_anchor_radius
#check @D1Bound5.coherent_cpow_half_sq
#check @D1Bound5.coherent_analytic_terminal_root_sq
#check @D1Bound5.coherent_analytic_anchor_root_sq
#check @D1Bound5.coherent_analytic_anchor_root_eq_or_eq_neg
#check @D1Bound5.dvd_det_of_dvd_column_combination
#check @D1Bound5.polynomial_det_natDegree_le_sum
#check @D1Bound5.polynomial_eq_top_monomial_of_X_pow_dvd
#check @D1Bound5.polynomial_det_eq_monomial_of_residual
#check @D1Bound5.polynomial_det_eq_monomial_of_uniform_residual
#check @D1Bound5.clearedPoleNumerator
#check @D1Bound5.clearedPoleNumerator_monic
#check @D1Bound5.clearedPoleNumerator_natDegree
#check @D1Bound5.clearedPoleNumerator_top_coeff
#check @D1Bound5.coeff_eq_sum_simple_residues
#check @D1Bound5.sum_simple_residues_eq_zero_of_degree_gap
#check @D1Bound5.lagrangeDifferentiation
#check @D1Bound5.lagrangeDifferentiation_moment
#check @D1Bound5.bennettFirstOrderMonomial
#check @D1Bound5.bennettFirstOrderMonomial_natDegree_le
#check @D1Bound5.bennettFirstOrderMonomial_eval
#check @D1Bound5.bennettFirstOrderCoefficients
#check @D1Bound5.bennettFirstOrderCoefficients_det
#check @D1Bound5.vandermonde_mul_bennettFirstOrderCoefficients
#check @D1Bound5.bennettFirstOrderOperator
#check @D1Bound5.bennettFirstOrderOperator_mul_vandermonde
#check @D1Bound5.bennettFirstOrderOperator_det
#check @D1Bound5.bennettFirstOrderReverse_det
#check @D1Bound5.bennettFirstOrderResidue
#check @D1Bound5.bennettFirstOrderResidue_det
#check @D1Bound5.eval_derivative_basisDivisor
#check @D1Bound5.lagrangeDifferentiation_diagonal
#check @D1Bound5.lagrange_basis_eq_weight_mul_nodal_erase
#check @D1Bound5.nodalWeight_mul_lagrangeDifferentiation_offDiagonal
#check @D1Bound5.bennettFirstOrderExplicit
#check @D1Bound5.bennettFirstOrderResidue_eq_explicit
#check @D1Bound5.bennettFirstOrderExplicit_det
#check @D1Bound5.three_halves_sub_natCast_ne_zero
#check @D1Bound5.bennettFirstOrderExplicit_det_ne_zero
#check @D1Bound5.bennettPoleSeries
#check @D1Bound5.bennettPoleSeries_coeff
#check @D1Bound5.bennettNegativeBinomial_mul
#check @D1Bound5.bennettPoleSeries_mul
