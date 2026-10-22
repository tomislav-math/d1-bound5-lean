import D1Bound5.SmallPairGraphClosure1Chunk01
import D1Bound5.SmallPairGraphClosure1Chunk02
import D1Bound5.SmallPairGraphClosure1Chunk03
import D1Bound5.SmallPairGraphClosure1Chunk04
import D1Bound5.SmallPairGraphClosure1Chunk05
import D1Bound5.SmallPairGraphClosure1Chunk06
import D1Bound5.SmallPairGraphClosure1Chunk07
import D1Bound5.SmallPairGraphClosure1Chunk08
import D1Bound5.SmallPairGraphClosure1Chunk09
import D1Bound5.SmallPairGraphClosure1Chunk10
import D1Bound5.SmallPairGraphClosure1Chunk11
import D1Bound5.SmallPairGraphClosure1
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairGraphPrepared1.indexed_chunk01_checked,
    `D1Bound5.PairGraphPrepared1.indexed_chunk02_checked,
    `D1Bound5.PairGraphPrepared1.indexed_chunk03_checked,
    `D1Bound5.PairGraphPrepared1.indexed_chunk04_checked,
    `D1Bound5.PairGraphPrepared1.indexed_chunk05_checked,
    `D1Bound5.PairGraphPrepared1.indexed_chunk06_checked,
    `D1Bound5.PairGraphPrepared1.indexed_chunk07_checked,
    `D1Bound5.PairGraphPrepared1.indexed_chunk08_checked,
    `D1Bound5.PairGraphPrepared1.indexed_chunk09_checked,
    `D1Bound5.PairGraphPrepared1.indexed_chunk10_checked,
    `D1Bound5.PairGraphPrepared1.indexed_chunk11_checked,
    `D1Bound5.PairGraphPrepared1.indexed_checked,
    `D1Bound5.smallPairClosure_1_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH1_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5.PairGraphPrepared1

example
:
    pairIndexedWitnessesPrefixBool smallPairA_1 smallPairB_1 anchorRoot
      (10^1100) smallPairClosure_1 64
      (witnesses.drop 64) (destinations.drop 64) = true :=
  _root_.D1Bound5.PairGraphPrepared1.indexed_chunk01_checked
end D1Bound5.PairGraphPrepared1

namespace D1Bound5.PairGraphPrepared1

example
:
    pairIndexedWitnessesPrefixBool smallPairA_1 smallPairB_1 anchorRoot
      (10^1100) smallPairClosure_1 64
      (witnesses.drop 128) (destinations.drop 128) = true :=
  _root_.D1Bound5.PairGraphPrepared1.indexed_chunk02_checked
end D1Bound5.PairGraphPrepared1

namespace D1Bound5.PairGraphPrepared1

example
:
    pairIndexedWitnessesPrefixBool smallPairA_1 smallPairB_1 anchorRoot
      (10^1100) smallPairClosure_1 64
      (witnesses.drop 192) (destinations.drop 192) = true :=
  _root_.D1Bound5.PairGraphPrepared1.indexed_chunk03_checked
end D1Bound5.PairGraphPrepared1

namespace D1Bound5.PairGraphPrepared1

example
:
    pairIndexedWitnessesPrefixBool smallPairA_1 smallPairB_1 anchorRoot
      (10^1100) smallPairClosure_1 64
      (witnesses.drop 256) (destinations.drop 256) = true :=
  _root_.D1Bound5.PairGraphPrepared1.indexed_chunk04_checked
end D1Bound5.PairGraphPrepared1

namespace D1Bound5.PairGraphPrepared1

example
:
    pairIndexedWitnessesPrefixBool smallPairA_1 smallPairB_1 anchorRoot
      (10^1100) smallPairClosure_1 64
      (witnesses.drop 320) (destinations.drop 320) = true :=
  _root_.D1Bound5.PairGraphPrepared1.indexed_chunk05_checked
end D1Bound5.PairGraphPrepared1

namespace D1Bound5.PairGraphPrepared1

example
:
    pairIndexedWitnessesPrefixBool smallPairA_1 smallPairB_1 anchorRoot
      (10^1100) smallPairClosure_1 64
      (witnesses.drop 384) (destinations.drop 384) = true :=
  _root_.D1Bound5.PairGraphPrepared1.indexed_chunk06_checked
end D1Bound5.PairGraphPrepared1

namespace D1Bound5.PairGraphPrepared1

example
:
    pairIndexedWitnessesPrefixBool smallPairA_1 smallPairB_1 anchorRoot
      (10^1100) smallPairClosure_1 64
      (witnesses.drop 448) (destinations.drop 448) = true :=
  _root_.D1Bound5.PairGraphPrepared1.indexed_chunk07_checked
end D1Bound5.PairGraphPrepared1

namespace D1Bound5.PairGraphPrepared1

example
:
    pairIndexedWitnessesPrefixBool smallPairA_1 smallPairB_1 anchorRoot
      (10^1100) smallPairClosure_1 64
      (witnesses.drop 512) (destinations.drop 512) = true :=
  _root_.D1Bound5.PairGraphPrepared1.indexed_chunk08_checked
end D1Bound5.PairGraphPrepared1

namespace D1Bound5.PairGraphPrepared1

example
:
    pairIndexedWitnessesPrefixBool smallPairA_1 smallPairB_1 anchorRoot
      (10^1100) smallPairClosure_1 64
      (witnesses.drop 576) (destinations.drop 576) = true :=
  _root_.D1Bound5.PairGraphPrepared1.indexed_chunk09_checked
end D1Bound5.PairGraphPrepared1

namespace D1Bound5.PairGraphPrepared1

example
:
    pairIndexedWitnessesPrefixBool smallPairA_1 smallPairB_1 anchorRoot
      (10^1100) smallPairClosure_1 64
      (witnesses.drop 640) (destinations.drop 640) = true :=
  _root_.D1Bound5.PairGraphPrepared1.indexed_chunk10_checked
end D1Bound5.PairGraphPrepared1

namespace D1Bound5.PairGraphPrepared1

example
:
    pairIndexedWitnessesPrefixBool smallPairA_1 smallPairB_1 anchorRoot
      (10^1100) smallPairClosure_1 16
      (witnesses.drop 704) (destinations.drop 704) = true :=
  _root_.D1Bound5.PairGraphPrepared1.indexed_chunk11_checked
end D1Bound5.PairGraphPrepared1

namespace D1Bound5
open PairGraphPrepared1
example
:
    pairClosureIndexedWitnessBool smallPairA_1 smallPairB_1 anchorRoot
      (10^1100) smallPairClosure_1 witnesses destinations = true :=
  _root_.D1Bound5.PairGraphPrepared1.indexed_checked
end D1Bound5

namespace D1Bound5
open PairGraphPrepared1
example
:
    pairClosureBool smallPairA_1 smallPairB_1
      (10^1100) smallPairClosure_1 = true :=
  _root_.D1Bound5.smallPairClosure_1_checked
end D1Bound5

#check @_root_.D1Bound5.PairGraphPrepared1.indexed_chunk01_checked
#check @_root_.D1Bound5.PairGraphPrepared1.indexed_chunk02_checked
#check @_root_.D1Bound5.PairGraphPrepared1.indexed_chunk03_checked
#check @_root_.D1Bound5.PairGraphPrepared1.indexed_chunk04_checked
#check @_root_.D1Bound5.PairGraphPrepared1.indexed_chunk05_checked
#check @_root_.D1Bound5.PairGraphPrepared1.indexed_chunk06_checked
#check @_root_.D1Bound5.PairGraphPrepared1.indexed_chunk07_checked
#check @_root_.D1Bound5.PairGraphPrepared1.indexed_chunk08_checked
#check @_root_.D1Bound5.PairGraphPrepared1.indexed_chunk09_checked
#check @_root_.D1Bound5.PairGraphPrepared1.indexed_chunk10_checked
#check @_root_.D1Bound5.PairGraphPrepared1.indexed_chunk11_checked
#check @_root_.D1Bound5.PairGraphPrepared1.indexed_checked
#check @_root_.D1Bound5.smallPairClosure_1_checked
