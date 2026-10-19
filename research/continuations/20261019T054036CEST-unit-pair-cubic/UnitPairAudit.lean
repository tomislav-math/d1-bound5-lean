import D1Bound5.UnitPairCubicNumeric
import D1Bound5.UnitPairCubic
import D1Bound5.UnitPairCubicIteration
import D1Bound5.UnitPairFirstExtensionBound
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let names : List Name := [
    `D1Bound5.unit_pair_cubic_root_margin,
    `D1Bound5.unit_pair_cubic_numeric,
    `D1Bound5.unit_pair_cancellation_ne_zero,
    `D1Bound5.unit_pair_cancellation_norm,
    `D1Bound5.discrete_unit_pair_cubic_growth,
    `D1Bound5.full_ring_unit_pair_cubic_growth,
    `D1Bound5.IsD1Tuple.unit_pair_cubic_growth,
    `D1Bound5.unit_pair_three_cubic_gaps,
    `D1Bound5.IsD1Tuple.unit_pair_cubic_iteration,
    `D1Bound5.IsD1Tuple.unit_pair_first_extension_lt]
  for name in names do
    let axioms ← Lean.collectAxioms name
    unless (axioms.filter fun n => !allowed.contains n).isEmpty do
      throwError "Unexpected axioms in {name}: {axioms}"
    logInfo m!"UNIT_PAIR_AXIOMS_PASS {name}: {axioms}"

#check @D1Bound5.unit_pair_cubic_root_margin
#check @D1Bound5.unit_pair_cubic_numeric
#check @D1Bound5.unit_pair_cancellation_ne_zero
#check @D1Bound5.unit_pair_cancellation_norm
#check @D1Bound5.discrete_unit_pair_cubic_growth
#check @D1Bound5.full_ring_unit_pair_cubic_growth
#check @D1Bound5.IsD1Tuple.unit_pair_cubic_growth
#check @D1Bound5.unit_pair_three_cubic_gaps
#check @D1Bound5.IsD1Tuple.unit_pair_cubic_iteration
#check @D1Bound5.IsD1Tuple.unit_pair_first_extension_lt
