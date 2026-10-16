import D1Bound5.MixedFourDetBound
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Check exact types and the full transitive axiom closure of all five
new mixed determinant declarations. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.mixedPairProduct_nearQuarter,
    `D1Bound5.mixedThreePairDet_norm_lt,
    `D1Bound5.mixedSymmetricFour_det_lt,
    `D1Bound5.mixed_zero_four_det_norm_lt,
    `D1Bound5.mixed_signed_root_det_upper]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let forbidden := axs.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"MIXED_DET_AXIOMS {n}: {axs}"
  logInfo m!"MIXED_DET_AXIOMS_PASS: {names.length} theorems"

#check @D1Bound5.mixedPairProduct_nearQuarter
#check @D1Bound5.mixedThreePairDet_norm_lt
#check @D1Bound5.mixedSymmetricFour_det_lt
#check @D1Bound5.mixed_zero_four_det_norm_lt
#check @D1Bound5.mixed_signed_root_det_upper
