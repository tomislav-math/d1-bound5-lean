import D1Bound5.FullRingOrdinaryHeight
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let names : List Name := [
    `D1Bound5.bennettTwoResidualRate,
    `D1Bound5.bennettTwoResidualGammaBound,
    `D1Bound5.bennettTwoResidualRate_pos,
    `D1Bound5.bennettTwoResidualGammaBound_mul_rate,
    `D1Bound5.bennettTwoResidualGammaBound_lt_half_rate,
    `D1Bound5.bennettTwoClearedEntry_residual_norm_lt_half_rate,
    `D1Bound5.bennettTwoRowForm_norm_le,
    `D1Bound5.bennettTwoRowForm_norm_lt,
    `D1Bound5.full_ring_bennett_two_integer_k,
    `D1Bound5.complex_terminal_root_height,
    `D1Bound5.IsD1Tuple.ordinary_height_envelope]
  for name in names do
    let axioms ← Lean.collectAxioms name
    let other := axioms.filter fun n => !allowed.contains n
    unless other.isEmpty do
      throwError "Unexpected axioms in {name}: {other}"
    logInfo m!"RESIDUAL_RATE_AXIOMS_PASS {name}: {axioms}"

#check @D1Bound5.bennettTwoResidualRate
#check @D1Bound5.bennettTwoResidualGammaBound
#check @D1Bound5.bennettTwoResidualRate_pos
#check @D1Bound5.bennettTwoResidualGammaBound_mul_rate
#check @D1Bound5.bennettTwoResidualGammaBound_lt_half_rate
#check @D1Bound5.bennettTwoClearedEntry_residual_norm_lt_half_rate
#check @D1Bound5.bennettTwoRowForm_norm_le
#check @D1Bound5.bennettTwoRowForm_norm_lt
#check @D1Bound5.full_ring_bennett_two_integer_k
#check @D1Bound5.complex_terminal_root_height
#check @D1Bound5.IsD1Tuple.ordinary_height_envelope
