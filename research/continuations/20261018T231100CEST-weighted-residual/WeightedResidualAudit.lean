import D1Bound5.BennettWeightedHeight
import D1Bound5.BennettResidualEvaluation
import D1Bound5.BennettResiduesAtInfinity
import D1Bound5.BennettChooseGamma
import D1Bound5.BennettRepeatedHsymm
import D1Bound5.BennettResidualBound
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let names : List Name := [
    `D1Bound5.bennett_weighted_even_power_le,
    `D1Bound5.bennettTwoClearedEntry_weighted_height,
    `D1Bound5.bennett_polynomial_series_hasSum,
    `D1Bound5.bennett_rescaled_binomial_hasSum,
    `D1Bound5.bennettPolynomialResidue_residual_hasSum,
    `D1Bound5.bennettPolynomialResidue_residual_coeff_eq_moment,
    `D1Bound5.bennettPolynomialResidue_residual_tail_hasSum,
    `D1Bound5.bennett_inverse_reverse_coeff,
    `D1Bound5.bennettLocalResidue_eq_zero_of_denominator_dvd,
    `D1Bound5.bennettLocalResidue_add,
    `D1Bound5.bennettLocalResidue_sum_eq_remainder_coeff,
    `D1Bound5.bennettReciprocalInfinity,
    `D1Bound5.bennettReciprocalInfinity_mul,
    `D1Bound5.bennettLocalResidue_sum_X_pow_eq_infinity_coeff,
    `D1Bound5.bennett_Gamma_half_add_nat,
    `D1Bound5.bennett_ascPochhammer_half_pos,
    `D1Bound5.bennett_factorial_mul_abs_choose,
    `D1Bound5.bennett_shifted_half_initial_abs,
    `D1Bound5.bennett_negative_half_abs,
    `D1Bound5.bennett_shifted_half_tail_abs_Gamma,
    `D1Bound5.bennett_two_residual_choose_abs_Gamma,
    `D1Bound5.bennettHomogeneousSeries,
    `D1Bound5.bennettHomogeneousSeries_finset_mul,
    `D1Bound5.bennettHomogeneousSeries_mul,
    `D1Bound5.BennettRepeatedNodes,
    `D1Bound5.bennettRepeatedNodes_card,
    `D1Bound5.bennettReciprocalInfinity_eq_homogeneous,
    `D1Bound5.bennettReciprocalInfinity_coeff_eq_hsymm,
    `D1Bound5.bennettLocalResidue_sum_X_pow_eq_hsymm,
    `D1Bound5.bennettPolynomialResidue_residual_norm_le,
    `D1Bound5.bennett_two_polynomial_residual_norm_le]
  for name in names do
    let axioms ← Lean.collectAxioms name
    let unexpected := axioms.filter fun x => !allowed.contains x
    unless unexpected.isEmpty do
      throwError "Unexpected axioms for {name}: {unexpected}"
    logInfo m!"WEIGHTED_RESIDUAL_AXIOMS_PASS {name}: {axioms}"

#check @D1Bound5.bennett_weighted_even_power_le
#check @D1Bound5.bennettTwoClearedEntry_weighted_height
#check @D1Bound5.bennett_polynomial_series_hasSum
#check @D1Bound5.bennett_rescaled_binomial_hasSum
#check @D1Bound5.bennettPolynomialResidue_residual_hasSum
#check @D1Bound5.bennettPolynomialResidue_residual_coeff_eq_moment
#check @D1Bound5.bennettPolynomialResidue_residual_tail_hasSum
#check @D1Bound5.bennett_inverse_reverse_coeff
#check @D1Bound5.bennettLocalResidue_eq_zero_of_denominator_dvd
#check @D1Bound5.bennettLocalResidue_add
#check @D1Bound5.bennettLocalResidue_sum_eq_remainder_coeff
#check @D1Bound5.bennettReciprocalInfinity
#check @D1Bound5.bennettReciprocalInfinity_mul
#check @D1Bound5.bennettLocalResidue_sum_X_pow_eq_infinity_coeff
#check @D1Bound5.bennett_Gamma_half_add_nat
#check @D1Bound5.bennett_ascPochhammer_half_pos
#check @D1Bound5.bennett_factorial_mul_abs_choose
#check @D1Bound5.bennett_shifted_half_initial_abs
#check @D1Bound5.bennett_negative_half_abs
#check @D1Bound5.bennett_shifted_half_tail_abs_Gamma
#check @D1Bound5.bennett_two_residual_choose_abs_Gamma
#check @D1Bound5.bennettHomogeneousSeries
#check @D1Bound5.bennettHomogeneousSeries_finset_mul
#check @D1Bound5.bennettHomogeneousSeries_mul
#check @D1Bound5.BennettRepeatedNodes
#check @D1Bound5.bennettRepeatedNodes_card
#check @D1Bound5.bennettReciprocalInfinity_eq_homogeneous
#check @D1Bound5.bennettReciprocalInfinity_coeff_eq_hsymm
#check @D1Bound5.bennettLocalResidue_sum_X_pow_eq_hsymm
#check @D1Bound5.bennettPolynomialResidue_residual_norm_le
#check @D1Bound5.bennett_two_polynomial_residual_norm_le
