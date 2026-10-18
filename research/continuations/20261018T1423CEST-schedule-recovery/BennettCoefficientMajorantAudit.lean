import D1Bound5.BennettCoefficientMajorant
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let names : List Name := [
    `D1Bound5.bennett_shifted_half_choose_abs_le,
    `D1Bound5.bennett_coeff_mul_norm_le,
    `D1Bound5.bennettNumeratorMajorant,
    `D1Bound5.bennettNumeratorMajorant_coeff,
    `D1Bound5.bennettNumeratorMajorant_coeff_nonneg,
    `D1Bound5.bennettNumeratorMajorant_hasSum,
    `D1Bound5.bennettClearedTaylor_eval_norm_le_coeff]
  for target in names do
    let axs ← Lean.collectAxioms target
    let forbidden := axs.filter fun n => !allowed.contains n
    unless forbidden.isEmpty do
      throwError "Unexpected axioms in {target}: {forbidden}"
    logInfo m!"BENNETT_MAJORANT_AXIOMS_PASS {target}: {axs}"

#check @D1Bound5.bennett_shifted_half_choose_abs_le
#check @D1Bound5.bennett_coeff_mul_norm_le
#check @D1Bound5.bennettNumeratorMajorant
#check @D1Bound5.bennettNumeratorMajorant_coeff
#check @D1Bound5.bennettNumeratorMajorant_coeff_nonneg
#check @D1Bound5.bennettNumeratorMajorant_hasSum
#check @D1Bound5.bennettClearedTaylor_eval_norm_le_coeff
