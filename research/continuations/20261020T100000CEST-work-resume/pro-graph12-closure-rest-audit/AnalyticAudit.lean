import D1Bound5.SmallPairGraphClosure12Chunk01
import D1Bound5.SmallPairGraphClosure12Chunk02
import D1Bound5.SmallPairGraphClosure12Chunk03
import D1Bound5.SmallPairGraphClosure12Chunk04
import D1Bound5.SmallPairGraphClosure12Chunk05
import D1Bound5.SmallPairGraphClosure12
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairGraphPrepared12.indexed_chunk01_checked,
    `D1Bound5.PairGraphPrepared12.indexed_chunk02_checked,
    `D1Bound5.PairGraphPrepared12.indexed_chunk03_checked,
    `D1Bound5.PairGraphPrepared12.indexed_chunk04_checked,
    `D1Bound5.PairGraphPrepared12.indexed_chunk05_checked,
    `D1Bound5.PairGraphPrepared12.indexed_checked,
    `D1Bound5.smallPairClosure_12_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH12_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5.PairGraphPrepared12

example
:
    pairIndexedWitnessesPrefixBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 128
      (witnesses.drop 128) (destinations.drop 128) = true :=
  _root_.D1Bound5.PairGraphPrepared12.indexed_chunk01_checked
end D1Bound5.PairGraphPrepared12

namespace D1Bound5.PairGraphPrepared12

example
:
    pairIndexedWitnessesPrefixBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 128
      (witnesses.drop 256) (destinations.drop 256) = true :=
  _root_.D1Bound5.PairGraphPrepared12.indexed_chunk02_checked
end D1Bound5.PairGraphPrepared12

namespace D1Bound5.PairGraphPrepared12

example
:
    pairIndexedWitnessesPrefixBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 128
      (witnesses.drop 384) (destinations.drop 384) = true :=
  _root_.D1Bound5.PairGraphPrepared12.indexed_chunk03_checked
end D1Bound5.PairGraphPrepared12

namespace D1Bound5.PairGraphPrepared12

example
:
    pairIndexedWitnessesPrefixBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 128
      (witnesses.drop 512) (destinations.drop 512) = true :=
  _root_.D1Bound5.PairGraphPrepared12.indexed_chunk04_checked
end D1Bound5.PairGraphPrepared12

namespace D1Bound5.PairGraphPrepared12

example
:
    pairIndexedWitnessesPrefixBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 80
      (witnesses.drop 640) (destinations.drop 640) = true :=
  _root_.D1Bound5.PairGraphPrepared12.indexed_chunk05_checked
end D1Bound5.PairGraphPrepared12

namespace D1Bound5
open PairGraphPrepared12
example
:
    pairClosureIndexedWitnessBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 witnesses destinations = true :=
  _root_.D1Bound5.PairGraphPrepared12.indexed_checked
end D1Bound5

namespace D1Bound5
open PairGraphPrepared12
example
:
    pairClosureBool smallPairA_12 smallPairB_12
      (10^1100) smallPairClosure_12 = true :=
  _root_.D1Bound5.smallPairClosure_12_checked
end D1Bound5

#check @_root_.D1Bound5.PairGraphPrepared12.indexed_chunk01_checked
#check @_root_.D1Bound5.PairGraphPrepared12.indexed_chunk02_checked
#check @_root_.D1Bound5.PairGraphPrepared12.indexed_chunk03_checked
#check @_root_.D1Bound5.PairGraphPrepared12.indexed_chunk04_checked
#check @_root_.D1Bound5.PairGraphPrepared12.indexed_chunk05_checked
#check @_root_.D1Bound5.PairGraphPrepared12.indexed_checked
#check @_root_.D1Bound5.smallPairClosure_12_checked
