import D1Bound5.BennettPositiveSeries
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let names : List Name := [`D1Bound5.bennettPoleMajorant,
    `D1Bound5.bennettPoleMajorant_coeff,
    `D1Bound5.bennettPoleMajorant_coeff_nonneg,
    `D1Bound5.bennettPoleSeries_coeff_norm_eq_majorant,
    `D1Bound5.bennettPoleMajorant_hasSum,
    `D1Bound5.bennett_positive_coeff_mul,
    `D1Bound5.bennett_positive_weighted_coeff_mul,
    `D1Bound5.bennett_positive_series_mul_hasSum,
    `D1Bound5.bennett_positive_series_coeff_le_sum,
    `D1Bound5.bennett_two_pole_majorant_coeff_le]
  for name in names do
    let axioms ← Lean.collectAxioms name
    let other := axioms.filter fun x => !allowed.contains x
    unless other.isEmpty do
      throwError "Unexpected axioms in {name}: {other}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {axioms}"

#check @D1Bound5.bennettPoleMajorant
#check @D1Bound5.bennettPoleMajorant_coeff
#check @D1Bound5.bennettPoleMajorant_coeff_nonneg
#check @D1Bound5.bennettPoleSeries_coeff_norm_eq_majorant
#check @D1Bound5.bennettPoleMajorant_hasSum
#check @D1Bound5.bennett_positive_coeff_mul
#check @D1Bound5.bennett_positive_weighted_coeff_mul
#check @D1Bound5.bennett_positive_series_mul_hasSum
#check @D1Bound5.bennett_positive_series_coeff_le_sum
#check @D1Bound5.bennett_two_pole_majorant_coeff_le
