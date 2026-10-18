import D1Bound5.BennettTwoIntegralSummands
import D1Bound5.BennettTwoIntegralEntries
import D1Bound5.BennettTwoIntegralMatrix
import D1Bound5.BennettIntegralRowSelection
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let names : List Name := [`D1Bound5.bennett_two_integral_summand_zero,
    `D1Bound5.bennett_two_integral_summand_one,
    `D1Bound5.bennett_two_integral_summand_two,
    `D1Bound5.bennettTwoNodes,
    `D1Bound5.bennettTwoNodes_zero,
    `D1Bound5.bennettTwoNodes_one,
    `D1Bound5.bennettTwoNodes_two,
    `D1Bound5.bennett_delta_sum_three,
    `D1Bound5.bennettTwoOtherPoles_zero,
    `D1Bound5.bennettTwoOtherPoles_one,
    `D1Bound5.bennettTwoOtherPoles_two,
    `D1Bound5.bennettClearedTaylor_two_poles_scaled_eval,
    `D1Bound5.bennettTwoClearedEntry,
    `D1Bound5.bennettTwoClearedEntry_zero_integral,
    `D1Bound5.bennettTwoClearedEntry_one_integral_divisible,
    `D1Bound5.bennettTwoClearedEntry_two_integral_divisible,
    `D1Bound5.bennettTwoClearedEntry_eq_scaled_residue,
    `D1Bound5.bennettTwoClearedEntry_row_lift,
    `D1Bound5.bennettTwoNodes_injective,
    `D1Bound5.bennettTwoClearedMatrix,
    `D1Bound5.bennettTwoClearedMatrix_det_ne_zero,
    `D1Bound5.bennettTwoRowForm,
    `D1Bound5.bennettTwoRowForm_exists_ne_zero,
    `D1Bound5.bennettTwoRowForm_lift,
    `D1Bound5.full_ring_bennettTwoRowForm_exists_one_le_norm]
  for name in names do
    let axioms ← Lean.collectAxioms name
    let other := axioms.filter fun x => !allowed.contains x
    unless other.isEmpty do
      throwError "Unexpected axioms in {name}: {other}"
    logInfo m!"INTEGRALITY_AXIOMS_PASS {name}: {axioms}"

#check @D1Bound5.bennett_two_integral_summand_zero
#check @D1Bound5.bennett_two_integral_summand_one
#check @D1Bound5.bennett_two_integral_summand_two
#check @D1Bound5.bennettTwoNodes
#check @D1Bound5.bennettTwoNodes_zero
#check @D1Bound5.bennettTwoNodes_one
#check @D1Bound5.bennettTwoNodes_two
#check @D1Bound5.bennett_delta_sum_three
#check @D1Bound5.bennettTwoOtherPoles_zero
#check @D1Bound5.bennettTwoOtherPoles_one
#check @D1Bound5.bennettTwoOtherPoles_two
#check @D1Bound5.bennettClearedTaylor_two_poles_scaled_eval
#check @D1Bound5.bennettTwoClearedEntry
#check @D1Bound5.bennettTwoClearedEntry_zero_integral
#check @D1Bound5.bennettTwoClearedEntry_one_integral_divisible
#check @D1Bound5.bennettTwoClearedEntry_two_integral_divisible
#check @D1Bound5.bennettTwoClearedEntry_eq_scaled_residue
#check @D1Bound5.bennettTwoClearedEntry_row_lift
#check @D1Bound5.bennettTwoNodes_injective
#check @D1Bound5.bennettTwoClearedMatrix
#check @D1Bound5.bennettTwoClearedMatrix_det_ne_zero
#check @D1Bound5.bennettTwoRowForm
#check @D1Bound5.bennettTwoRowForm_exists_ne_zero
#check @D1Bound5.bennettTwoRowForm_lift
#check @D1Bound5.full_ring_bennettTwoRowForm_exists_one_le_norm
