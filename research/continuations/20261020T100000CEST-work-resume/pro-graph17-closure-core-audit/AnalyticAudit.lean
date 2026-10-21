import D1Bound5.SmallPairGraphInputs17
import D1Bound5.SmallPairGraphWitnessData17
import D1Bound5.SmallPairGraphClosure17Chunk00
import D1Bound5.SmallPairGraphClosure17Chunk01
import D1Bound5.SmallPairGraphClosure17Chunk02
import D1Bound5.SmallPairGraphClosure17Chunk03
import D1Bound5.SmallPairGraphClosure17Chunk04
import D1Bound5.SmallPairGraphClosure17Chunk05
import D1Bound5.SmallPairGraphClosure17Coverage
import D1Bound5.SmallPairGraphClosure17
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.smallPairA_17,
    `D1Bound5.smallPairB_17,
    `D1Bound5.smallPairClosure_17,
    `D1Bound5.smallPairLarge_17,
    `D1Bound5.PairGraphPrepared17.colors,
    `D1Bound5.PairGraphPrepared17.anchorRoot,
    `D1Bound5.PairGraphPrepared17.rootPairs,
    `D1Bound5.PairGraphPrepared17.witnesses,
    `D1Bound5.PairGraphPrepared17.destinations,
    `D1Bound5.PairGraphPrepared17.indexed_chunk00_checked,
    `D1Bound5.PairGraphPrepared17.indexed_chunk01_checked,
    `D1Bound5.PairGraphPrepared17.indexed_chunk02_checked,
    `D1Bound5.PairGraphPrepared17.indexed_chunk03_checked,
    `D1Bound5.PairGraphPrepared17.indexed_chunk04_checked,
    `D1Bound5.PairGraphPrepared17.indexed_chunk05_checked,
    `D1Bound5.PairGraphPrepared17.indexed_coverage_checked,
    `D1Bound5.PairGraphPrepared17.indexed_checked,
    `D1Bound5.smallPairClosure_17_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH17_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5
open QuadInt
example
: QuadInt 0 2 :=
  _root_.D1Bound5.smallPairA_17
end D1Bound5

namespace D1Bound5
open QuadInt
example
: QuadInt 0 2 :=
  _root_.D1Bound5.smallPairB_17
end D1Bound5

namespace D1Bound5
open QuadInt
example
: List (QuadInt 0 2) :=
  _root_.D1Bound5.smallPairClosure_17
end D1Bound5

namespace D1Bound5
open QuadInt
example
: List (QuadInt 0 2) :=
  _root_.D1Bound5.smallPairLarge_17
end D1Bound5

namespace D1Bound5.PairGraphPrepared17
open QuadInt
example
: ℕ :=
  _root_.D1Bound5.PairGraphPrepared17.colors
end D1Bound5.PairGraphPrepared17

namespace D1Bound5.PairGraphPrepared17

example
: QuadInt 0 2 :=
  _root_.D1Bound5.PairGraphPrepared17.anchorRoot
end D1Bound5.PairGraphPrepared17

namespace D1Bound5.PairGraphPrepared17

example
: List (QuadInt 0 2 × QuadInt 0 2) :=
  _root_.D1Bound5.PairGraphPrepared17.rootPairs
end D1Bound5.PairGraphPrepared17

namespace D1Bound5.PairGraphPrepared17

example
: List (PairRootWitness 0 2) :=
  _root_.D1Bound5.PairGraphPrepared17.witnesses
end D1Bound5.PairGraphPrepared17

namespace D1Bound5.PairGraphPrepared17

example
: List (Option ℕ × Option ℕ) :=
  _root_.D1Bound5.PairGraphPrepared17.destinations
end D1Bound5.PairGraphPrepared17

namespace D1Bound5.PairGraphPrepared17

example
:
    pairIndexedWitnessesPrefixBool smallPairA_17 smallPairB_17 anchorRoot
      (10^1100) smallPairClosure_17 128
      (witnesses.drop 0) (destinations.drop 0) = true :=
  _root_.D1Bound5.PairGraphPrepared17.indexed_chunk00_checked
end D1Bound5.PairGraphPrepared17

namespace D1Bound5.PairGraphPrepared17

example
:
    pairIndexedWitnessesPrefixBool smallPairA_17 smallPairB_17 anchorRoot
      (10^1100) smallPairClosure_17 128
      (witnesses.drop 128) (destinations.drop 128) = true :=
  _root_.D1Bound5.PairGraphPrepared17.indexed_chunk01_checked
end D1Bound5.PairGraphPrepared17

namespace D1Bound5.PairGraphPrepared17

example
:
    pairIndexedWitnessesPrefixBool smallPairA_17 smallPairB_17 anchorRoot
      (10^1100) smallPairClosure_17 128
      (witnesses.drop 256) (destinations.drop 256) = true :=
  _root_.D1Bound5.PairGraphPrepared17.indexed_chunk02_checked
end D1Bound5.PairGraphPrepared17

namespace D1Bound5.PairGraphPrepared17

example
:
    pairIndexedWitnessesPrefixBool smallPairA_17 smallPairB_17 anchorRoot
      (10^1100) smallPairClosure_17 128
      (witnesses.drop 384) (destinations.drop 384) = true :=
  _root_.D1Bound5.PairGraphPrepared17.indexed_chunk03_checked
end D1Bound5.PairGraphPrepared17

namespace D1Bound5.PairGraphPrepared17

example
:
    pairIndexedWitnessesPrefixBool smallPairA_17 smallPairB_17 anchorRoot
      (10^1100) smallPairClosure_17 128
      (witnesses.drop 512) (destinations.drop 512) = true :=
  _root_.D1Bound5.PairGraphPrepared17.indexed_chunk04_checked
end D1Bound5.PairGraphPrepared17

namespace D1Bound5.PairGraphPrepared17

example
:
    pairIndexedWitnessesPrefixBool smallPairA_17 smallPairB_17 anchorRoot
      (10^1100) smallPairClosure_17 79
      (witnesses.drop 640) (destinations.drop 640) = true :=
  _root_.D1Bound5.PairGraphPrepared17.indexed_chunk05_checked
end D1Bound5.PairGraphPrepared17

namespace D1Bound5.PairGraphPrepared17

example
:
    decide (anchorRoot * anchorRoot = smallPairA_17 * smallPairB_17 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_17) = true :=
  _root_.D1Bound5.PairGraphPrepared17.indexed_coverage_checked
end D1Bound5.PairGraphPrepared17

namespace D1Bound5
open PairGraphPrepared17
example
:
    pairClosureIndexedWitnessBool smallPairA_17 smallPairB_17 anchorRoot
      (10^1100) smallPairClosure_17 witnesses destinations = true :=
  _root_.D1Bound5.PairGraphPrepared17.indexed_checked
end D1Bound5

namespace D1Bound5
open PairGraphPrepared17
example
:
    pairClosureBool smallPairA_17 smallPairB_17
      (10^1100) smallPairClosure_17 = true :=
  _root_.D1Bound5.smallPairClosure_17_checked
end D1Bound5

#check @_root_.D1Bound5.smallPairA_17
#check @_root_.D1Bound5.smallPairB_17
#check @_root_.D1Bound5.smallPairClosure_17
#check @_root_.D1Bound5.smallPairLarge_17
#check @_root_.D1Bound5.PairGraphPrepared17.colors
#check @_root_.D1Bound5.PairGraphPrepared17.anchorRoot
#check @_root_.D1Bound5.PairGraphPrepared17.rootPairs
#check @_root_.D1Bound5.PairGraphPrepared17.witnesses
#check @_root_.D1Bound5.PairGraphPrepared17.destinations
#check @_root_.D1Bound5.PairGraphPrepared17.indexed_chunk00_checked
#check @_root_.D1Bound5.PairGraphPrepared17.indexed_chunk01_checked
#check @_root_.D1Bound5.PairGraphPrepared17.indexed_chunk02_checked
#check @_root_.D1Bound5.PairGraphPrepared17.indexed_chunk03_checked
#check @_root_.D1Bound5.PairGraphPrepared17.indexed_chunk04_checked
#check @_root_.D1Bound5.PairGraphPrepared17.indexed_chunk05_checked
#check @_root_.D1Bound5.PairGraphPrepared17.indexed_coverage_checked
#check @_root_.D1Bound5.PairGraphPrepared17.indexed_checked
#check @_root_.D1Bound5.smallPairClosure_17_checked
