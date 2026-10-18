import D1Bound5.UnitPairHeightCutoff
import Lean.Util.CollectAxioms
open Lean Elab Command
run_cmd do
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let names : List Name := [`D1Bound5.ordinaryLog10,
    `D1Bound5.ordinaryLog10_base_pos,
    `D1Bound5.ordinaryLog10_mul,
    `D1Bound5.ordinaryLog10_pow,
    `D1Bound5.ordinaryLog10_ten,
    `D1Bound5.ordinaryLog10_strictMono,
    `D1Bound5.ordinaryLog10_mono,
    `D1Bound5.ordinaryLog10_nonneg,
    `D1Bound5.ordinaryLog10_lt_of_pow_lt,
    `D1Bound5.ordinaryLog10_two_lt,
    `D1Bound5.ordinaryLog10_unit_parameters,
    `D1Bound5.ordinary_height_envelope_from_orders,
    `D1Bound5.unit_pair_residual_rate_lower,
    `D1Bound5.ordinaryLog10_ge_four,
    `D1Bound5.unit_pair_height_upper_from_orders,
    `D1Bound5.unit_pair_height_cutoff_from_orders]
  for name in names do
    let axioms ← Lean.collectAxioms name
    let other := axioms.filter fun x => !allowed.contains x
    unless other.isEmpty do
      throwError "Unexpected axioms in {name}: {other}"
    logInfo m!"HEIGHT_AXIOMS_PASS {name}: {axioms}"

#check @D1Bound5.ordinaryLog10
#check @D1Bound5.ordinaryLog10_base_pos
#check @D1Bound5.ordinaryLog10_mul
#check @D1Bound5.ordinaryLog10_pow
#check @D1Bound5.ordinaryLog10_ten
#check @D1Bound5.ordinaryLog10_strictMono
#check @D1Bound5.ordinaryLog10_mono
#check @D1Bound5.ordinaryLog10_nonneg
#check @D1Bound5.ordinaryLog10_lt_of_pow_lt
#check @D1Bound5.ordinaryLog10_two_lt
#check @D1Bound5.ordinaryLog10_unit_parameters
#check @D1Bound5.ordinary_height_envelope_from_orders
#check @D1Bound5.unit_pair_residual_rate_lower
#check @D1Bound5.ordinaryLog10_ge_four
#check @D1Bound5.unit_pair_height_upper_from_orders
#check @D1Bound5.unit_pair_height_cutoff_from_orders
