import D1Bound5.SmallPairGraphClosure33
import Lean.Elab.Command
import Lean.Util.CollectAxioms

set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairGraphPrepared33.indexed_chunk04_checked,
    `D1Bound5.PairGraphPrepared33.indexed_chunk05_checked,
    `D1Bound5.PairGraphPrepared33.indexed_coverage_checked,
    `D1Bound5.PairGraphPrepared33.indexed_checked,
    `D1Bound5.smallPairClosure_33_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n =>
      !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH33_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5
open PairGraphPrepared33

example :
    pairIndexedWitnessesPrefixBool smallPairA_33 smallPairB_33 anchorRoot
      (10^1100) smallPairClosure_33 128
      (witnesses.drop 512) (destinations.drop 512) = true :=
  PairGraphPrepared33.indexed_chunk04_checked

example :
    pairIndexedWitnessesPrefixBool smallPairA_33 smallPairB_33 anchorRoot
      (10^1100) smallPairClosure_33 80
      (witnesses.drop 640) (destinations.drop 640) = true :=
  PairGraphPrepared33.indexed_chunk05_checked

example :
    decide (anchorRoot * anchorRoot = smallPairA_33 * smallPairB_33 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_33) = true :=
  PairGraphPrepared33.indexed_coverage_checked

example :
    pairClosureIndexedWitnessBool smallPairA_33 smallPairB_33 anchorRoot
      (10^1100) smallPairClosure_33 witnesses destinations = true :=
  PairGraphPrepared33.indexed_checked

example :
    pairClosureBool smallPairA_33 smallPairB_33
      (10^1100) smallPairClosure_33 = true :=
  smallPairClosure_33_checked

end D1Bound5

#check @_root_.D1Bound5.PairGraphPrepared33.indexed_chunk04_checked
#check @_root_.D1Bound5.PairGraphPrepared33.indexed_chunk05_checked
#check @_root_.D1Bound5.PairGraphPrepared33.indexed_coverage_checked
#check @_root_.D1Bound5.PairGraphPrepared33.indexed_checked
#check @_root_.D1Bound5.smallPairClosure_33_checked
