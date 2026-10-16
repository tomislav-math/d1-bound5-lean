import D1Bound5.TupleRootMatrixBridge
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let names : List Name := [
    `D1Bound5.IsD1Tuple.exists_symmetric_root_matrix,
    `D1Bound5.IsD1Tuple.productFour_large_growth]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axioms ← Lean.collectAxioms n
    let forbidden := axioms.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"TUPLE_ROOT_MATRIX_BRIDGE_AXIOMS {n}: {axioms}"
  logInfo m!"TUPLE_ROOT_MATRIX_BRIDGE_AUDIT_PASS: {names.length} theorems"

#check @D1Bound5.IsD1Tuple.exists_symmetric_root_matrix
#check @D1Bound5.IsD1Tuple.productFour_large_growth
#print axioms D1Bound5.IsD1Tuple.productFour_large_growth
