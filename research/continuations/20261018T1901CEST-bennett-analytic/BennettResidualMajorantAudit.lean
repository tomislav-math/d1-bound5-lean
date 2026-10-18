import D1Bound5.BennettResidualMajorant
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let names : List Name := [`D1Bound5.bennett_multichoose_pos,
    `D1Bound5.bennett_choose_negative_abs,
    `D1Bound5.bennett_choose_tail_identity,
    `D1Bound5.bennett_negative_binomial_abs_hasSum,
    `D1Bound5.bennett_homogeneous_tail_summable_and_norm_le,
    `D1Bound5.bennett_two_homogeneous_tail_summable_and_norm_le]
  for name in names do
    let axioms ← Lean.collectAxioms name
    let other := axioms.filter fun x => !allowed.contains x
    unless other.isEmpty do
      throwError "Unexpected axioms in {name}: {other}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {axioms}"

#check @D1Bound5.bennett_multichoose_pos
#check @D1Bound5.bennett_choose_negative_abs
#check @D1Bound5.bennett_choose_tail_identity
#check @D1Bound5.bennett_negative_binomial_abs_hasSum
#check @D1Bound5.bennett_homogeneous_tail_summable_and_norm_le
#check @D1Bound5.bennett_two_homogeneous_tail_summable_and_norm_le
