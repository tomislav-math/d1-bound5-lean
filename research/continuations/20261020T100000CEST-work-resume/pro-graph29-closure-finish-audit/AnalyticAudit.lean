import D1Bound5.SmallPairGraphClosure29Chunk05
import D1Bound5.SmallPairGraphClosure29Chunk06
import D1Bound5.SmallPairGraphClosure29Chunk07
import D1Bound5.SmallPairGraphClosure29Chunk08
import D1Bound5.SmallPairGraphClosure29Chunk09
import D1Bound5.SmallPairGraphClosure29Chunk10
import D1Bound5.SmallPairGraphClosure29Chunk11
import D1Bound5.SmallPairGraphClosure29
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairGraphPrepared29.indexed_chunk05_checked,
    `D1Bound5.PairGraphPrepared29.indexed_chunk06_checked,
    `D1Bound5.PairGraphPrepared29.indexed_chunk07_checked,
    `D1Bound5.PairGraphPrepared29.indexed_chunk08_checked,
    `D1Bound5.PairGraphPrepared29.indexed_chunk09_checked,
    `D1Bound5.PairGraphPrepared29.indexed_chunk10_checked,
    `D1Bound5.PairGraphPrepared29.indexed_chunk11_checked,
    `D1Bound5.PairGraphPrepared29.indexed_checked,
    `D1Bound5.smallPairClosure_29_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH29_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5.PairGraphPrepared29

example
:
    pairIndexedWitnessesPrefixBool smallPairA_29 smallPairB_29 anchorRoot
      (10^1100) smallPairClosure_29 64
      (witnesses.drop 320) (destinations.drop 320) = true :=
  _root_.D1Bound5.PairGraphPrepared29.indexed_chunk05_checked
end D1Bound5.PairGraphPrepared29

namespace D1Bound5.PairGraphPrepared29

example
:
    pairIndexedWitnessesPrefixBool smallPairA_29 smallPairB_29 anchorRoot
      (10^1100) smallPairClosure_29 64
      (witnesses.drop 384) (destinations.drop 384) = true :=
  _root_.D1Bound5.PairGraphPrepared29.indexed_chunk06_checked
end D1Bound5.PairGraphPrepared29

namespace D1Bound5.PairGraphPrepared29

example
:
    pairIndexedWitnessesPrefixBool smallPairA_29 smallPairB_29 anchorRoot
      (10^1100) smallPairClosure_29 64
      (witnesses.drop 448) (destinations.drop 448) = true :=
  _root_.D1Bound5.PairGraphPrepared29.indexed_chunk07_checked
end D1Bound5.PairGraphPrepared29

namespace D1Bound5.PairGraphPrepared29

example
:
    pairIndexedWitnessesPrefixBool smallPairA_29 smallPairB_29 anchorRoot
      (10^1100) smallPairClosure_29 64
      (witnesses.drop 512) (destinations.drop 512) = true :=
  _root_.D1Bound5.PairGraphPrepared29.indexed_chunk08_checked
end D1Bound5.PairGraphPrepared29

namespace D1Bound5.PairGraphPrepared29

example
:
    pairIndexedWitnessesPrefixBool smallPairA_29 smallPairB_29 anchorRoot
      (10^1100) smallPairClosure_29 64
      (witnesses.drop 576) (destinations.drop 576) = true :=
  _root_.D1Bound5.PairGraphPrepared29.indexed_chunk09_checked
end D1Bound5.PairGraphPrepared29

namespace D1Bound5.PairGraphPrepared29

example
:
    pairIndexedWitnessesPrefixBool smallPairA_29 smallPairB_29 anchorRoot
      (10^1100) smallPairClosure_29 64
      (witnesses.drop 640) (destinations.drop 640) = true :=
  _root_.D1Bound5.PairGraphPrepared29.indexed_chunk10_checked
end D1Bound5.PairGraphPrepared29

namespace D1Bound5.PairGraphPrepared29

example
:
    pairIndexedWitnessesPrefixBool smallPairA_29 smallPairB_29 anchorRoot
      (10^1100) smallPairClosure_29 59
      (witnesses.drop 704) (destinations.drop 704) = true :=
  _root_.D1Bound5.PairGraphPrepared29.indexed_chunk11_checked
end D1Bound5.PairGraphPrepared29

namespace D1Bound5
open PairGraphPrepared29
example
:
    pairClosureIndexedWitnessBool smallPairA_29 smallPairB_29 anchorRoot
      (10^1100) smallPairClosure_29 witnesses destinations = true :=
  _root_.D1Bound5.PairGraphPrepared29.indexed_checked
end D1Bound5

namespace D1Bound5
open PairGraphPrepared29
example
:
    pairClosureBool smallPairA_29 smallPairB_29
      (10^1100) smallPairClosure_29 = true :=
  _root_.D1Bound5.smallPairClosure_29_checked
end D1Bound5

#check @_root_.D1Bound5.PairGraphPrepared29.indexed_chunk05_checked
#check @_root_.D1Bound5.PairGraphPrepared29.indexed_chunk06_checked
#check @_root_.D1Bound5.PairGraphPrepared29.indexed_chunk07_checked
#check @_root_.D1Bound5.PairGraphPrepared29.indexed_chunk08_checked
#check @_root_.D1Bound5.PairGraphPrepared29.indexed_chunk09_checked
#check @_root_.D1Bound5.PairGraphPrepared29.indexed_chunk10_checked
#check @_root_.D1Bound5.PairGraphPrepared29.indexed_chunk11_checked
#check @_root_.D1Bound5.PairGraphPrepared29.indexed_checked
#check @_root_.D1Bound5.smallPairClosure_29_checked
