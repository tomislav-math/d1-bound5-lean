import D1Bound5.SmallPairGraphClosure11Chunk01
import D1Bound5.SmallPairGraphClosure11Chunk02
import D1Bound5.SmallPairGraphClosure11Chunk03
import D1Bound5.SmallPairGraphClosure11Chunk04
import D1Bound5.SmallPairGraphClosure11Chunk05
import D1Bound5.SmallPairGraphClosure11Chunk06
import D1Bound5.SmallPairGraphClosure11Chunk07
import D1Bound5.SmallPairGraphClosure11Chunk08
import D1Bound5.SmallPairGraphClosure11Chunk09
import D1Bound5.SmallPairGraphClosure11Chunk10
import D1Bound5.SmallPairGraphClosure11Chunk11
import D1Bound5.SmallPairGraphClosure11
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairGraphPrepared11.indexed_chunk01_checked,
    `D1Bound5.PairGraphPrepared11.indexed_chunk02_checked,
    `D1Bound5.PairGraphPrepared11.indexed_chunk03_checked,
    `D1Bound5.PairGraphPrepared11.indexed_chunk04_checked,
    `D1Bound5.PairGraphPrepared11.indexed_chunk05_checked,
    `D1Bound5.PairGraphPrepared11.indexed_chunk06_checked,
    `D1Bound5.PairGraphPrepared11.indexed_chunk07_checked,
    `D1Bound5.PairGraphPrepared11.indexed_chunk08_checked,
    `D1Bound5.PairGraphPrepared11.indexed_chunk09_checked,
    `D1Bound5.PairGraphPrepared11.indexed_chunk10_checked,
    `D1Bound5.PairGraphPrepared11.indexed_chunk11_checked,
    `D1Bound5.PairGraphPrepared11.indexed_checked,
    `D1Bound5.smallPairClosure_11_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH11_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5.PairGraphPrepared11

example
:
    pairIndexedWitnessesPrefixBool smallPairA_11 smallPairB_11 anchorRoot
      (10^1100) smallPairClosure_11 64
      (witnesses.drop 64) (destinations.drop 64) = true :=
  _root_.D1Bound5.PairGraphPrepared11.indexed_chunk01_checked
end D1Bound5.PairGraphPrepared11

namespace D1Bound5.PairGraphPrepared11

example
:
    pairIndexedWitnessesPrefixBool smallPairA_11 smallPairB_11 anchorRoot
      (10^1100) smallPairClosure_11 64
      (witnesses.drop 128) (destinations.drop 128) = true :=
  _root_.D1Bound5.PairGraphPrepared11.indexed_chunk02_checked
end D1Bound5.PairGraphPrepared11

namespace D1Bound5.PairGraphPrepared11

example
:
    pairIndexedWitnessesPrefixBool smallPairA_11 smallPairB_11 anchorRoot
      (10^1100) smallPairClosure_11 64
      (witnesses.drop 192) (destinations.drop 192) = true :=
  _root_.D1Bound5.PairGraphPrepared11.indexed_chunk03_checked
end D1Bound5.PairGraphPrepared11

namespace D1Bound5.PairGraphPrepared11

example
:
    pairIndexedWitnessesPrefixBool smallPairA_11 smallPairB_11 anchorRoot
      (10^1100) smallPairClosure_11 64
      (witnesses.drop 256) (destinations.drop 256) = true :=
  _root_.D1Bound5.PairGraphPrepared11.indexed_chunk04_checked
end D1Bound5.PairGraphPrepared11

namespace D1Bound5.PairGraphPrepared11

example
:
    pairIndexedWitnessesPrefixBool smallPairA_11 smallPairB_11 anchorRoot
      (10^1100) smallPairClosure_11 64
      (witnesses.drop 320) (destinations.drop 320) = true :=
  _root_.D1Bound5.PairGraphPrepared11.indexed_chunk05_checked
end D1Bound5.PairGraphPrepared11

namespace D1Bound5.PairGraphPrepared11

example
:
    pairIndexedWitnessesPrefixBool smallPairA_11 smallPairB_11 anchorRoot
      (10^1100) smallPairClosure_11 64
      (witnesses.drop 384) (destinations.drop 384) = true :=
  _root_.D1Bound5.PairGraphPrepared11.indexed_chunk06_checked
end D1Bound5.PairGraphPrepared11

namespace D1Bound5.PairGraphPrepared11

example
:
    pairIndexedWitnessesPrefixBool smallPairA_11 smallPairB_11 anchorRoot
      (10^1100) smallPairClosure_11 64
      (witnesses.drop 448) (destinations.drop 448) = true :=
  _root_.D1Bound5.PairGraphPrepared11.indexed_chunk07_checked
end D1Bound5.PairGraphPrepared11

namespace D1Bound5.PairGraphPrepared11

example
:
    pairIndexedWitnessesPrefixBool smallPairA_11 smallPairB_11 anchorRoot
      (10^1100) smallPairClosure_11 64
      (witnesses.drop 512) (destinations.drop 512) = true :=
  _root_.D1Bound5.PairGraphPrepared11.indexed_chunk08_checked
end D1Bound5.PairGraphPrepared11

namespace D1Bound5.PairGraphPrepared11

example
:
    pairIndexedWitnessesPrefixBool smallPairA_11 smallPairB_11 anchorRoot
      (10^1100) smallPairClosure_11 64
      (witnesses.drop 576) (destinations.drop 576) = true :=
  _root_.D1Bound5.PairGraphPrepared11.indexed_chunk09_checked
end D1Bound5.PairGraphPrepared11

namespace D1Bound5.PairGraphPrepared11

example
:
    pairIndexedWitnessesPrefixBool smallPairA_11 smallPairB_11 anchorRoot
      (10^1100) smallPairClosure_11 64
      (witnesses.drop 640) (destinations.drop 640) = true :=
  _root_.D1Bound5.PairGraphPrepared11.indexed_chunk10_checked
end D1Bound5.PairGraphPrepared11

namespace D1Bound5.PairGraphPrepared11

example
:
    pairIndexedWitnessesPrefixBool smallPairA_11 smallPairB_11 anchorRoot
      (10^1100) smallPairClosure_11 15
      (witnesses.drop 704) (destinations.drop 704) = true :=
  _root_.D1Bound5.PairGraphPrepared11.indexed_chunk11_checked
end D1Bound5.PairGraphPrepared11

namespace D1Bound5
open PairGraphPrepared11
example
:
    pairClosureIndexedWitnessBool smallPairA_11 smallPairB_11 anchorRoot
      (10^1100) smallPairClosure_11 witnesses destinations = true :=
  _root_.D1Bound5.PairGraphPrepared11.indexed_checked
end D1Bound5

namespace D1Bound5
open PairGraphPrepared11
example
:
    pairClosureBool smallPairA_11 smallPairB_11
      (10^1100) smallPairClosure_11 = true :=
  _root_.D1Bound5.smallPairClosure_11_checked
end D1Bound5

#check @_root_.D1Bound5.PairGraphPrepared11.indexed_chunk01_checked
#check @_root_.D1Bound5.PairGraphPrepared11.indexed_chunk02_checked
#check @_root_.D1Bound5.PairGraphPrepared11.indexed_chunk03_checked
#check @_root_.D1Bound5.PairGraphPrepared11.indexed_chunk04_checked
#check @_root_.D1Bound5.PairGraphPrepared11.indexed_chunk05_checked
#check @_root_.D1Bound5.PairGraphPrepared11.indexed_chunk06_checked
#check @_root_.D1Bound5.PairGraphPrepared11.indexed_chunk07_checked
#check @_root_.D1Bound5.PairGraphPrepared11.indexed_chunk08_checked
#check @_root_.D1Bound5.PairGraphPrepared11.indexed_chunk09_checked
#check @_root_.D1Bound5.PairGraphPrepared11.indexed_chunk10_checked
#check @_root_.D1Bound5.PairGraphPrepared11.indexed_chunk11_checked
#check @_root_.D1Bound5.PairGraphPrepared11.indexed_checked
#check @_root_.D1Bound5.smallPairClosure_11_checked
