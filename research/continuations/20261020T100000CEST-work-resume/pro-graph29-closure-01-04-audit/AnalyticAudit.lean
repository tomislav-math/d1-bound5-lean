import D1Bound5.SmallPairGraphClosure29Chunk01
import D1Bound5.SmallPairGraphClosure29Chunk02
import D1Bound5.SmallPairGraphClosure29Chunk03
import D1Bound5.SmallPairGraphClosure29Chunk04
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairGraphPrepared29.indexed_chunk01_checked,
    `D1Bound5.PairGraphPrepared29.indexed_chunk02_checked,
    `D1Bound5.PairGraphPrepared29.indexed_chunk03_checked,
    `D1Bound5.PairGraphPrepared29.indexed_chunk04_checked]
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
      (witnesses.drop 64) (destinations.drop 64) = true :=
  _root_.D1Bound5.PairGraphPrepared29.indexed_chunk01_checked
end D1Bound5.PairGraphPrepared29

namespace D1Bound5.PairGraphPrepared29

example
:
    pairIndexedWitnessesPrefixBool smallPairA_29 smallPairB_29 anchorRoot
      (10^1100) smallPairClosure_29 64
      (witnesses.drop 128) (destinations.drop 128) = true :=
  _root_.D1Bound5.PairGraphPrepared29.indexed_chunk02_checked
end D1Bound5.PairGraphPrepared29

namespace D1Bound5.PairGraphPrepared29

example
:
    pairIndexedWitnessesPrefixBool smallPairA_29 smallPairB_29 anchorRoot
      (10^1100) smallPairClosure_29 64
      (witnesses.drop 192) (destinations.drop 192) = true :=
  _root_.D1Bound5.PairGraphPrepared29.indexed_chunk03_checked
end D1Bound5.PairGraphPrepared29

namespace D1Bound5.PairGraphPrepared29

example
:
    pairIndexedWitnessesPrefixBool smallPairA_29 smallPairB_29 anchorRoot
      (10^1100) smallPairClosure_29 64
      (witnesses.drop 256) (destinations.drop 256) = true :=
  _root_.D1Bound5.PairGraphPrepared29.indexed_chunk04_checked
end D1Bound5.PairGraphPrepared29

#check @_root_.D1Bound5.PairGraphPrepared29.indexed_chunk01_checked
#check @_root_.D1Bound5.PairGraphPrepared29.indexed_chunk02_checked
#check @_root_.D1Bound5.PairGraphPrepared29.indexed_chunk03_checked
#check @_root_.D1Bound5.PairGraphPrepared29.indexed_chunk04_checked
