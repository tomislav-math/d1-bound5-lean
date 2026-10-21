import D1Bound5.SmallPairGraphInputs35
import D1Bound5.SmallPairGraphWitnessData35
import D1Bound5.SmallPairGraphClosure35Chunk00
import D1Bound5.SmallPairGraphClosure35Chunk01
import D1Bound5.SmallPairGraphClosure35Chunk02
import D1Bound5.SmallPairGraphClosure35Chunk03
import D1Bound5.SmallPairGraphClosure35Chunk04
import D1Bound5.SmallPairGraphClosure35Chunk05
import D1Bound5.SmallPairGraphClosure35Coverage
import D1Bound5.SmallPairGraphClosure35
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.smallPairA_35,
    `D1Bound5.smallPairB_35,
    `D1Bound5.smallPairClosure_35,
    `D1Bound5.smallPairLarge_35,
    `D1Bound5.PairGraphPrepared35.colors,
    `D1Bound5.PairGraphPrepared35.anchorRoot,
    `D1Bound5.PairGraphPrepared35.rootPairs,
    `D1Bound5.PairGraphPrepared35.witnesses,
    `D1Bound5.PairGraphPrepared35.destinations,
    `D1Bound5.PairGraphPrepared35.indexed_chunk00_checked,
    `D1Bound5.PairGraphPrepared35.indexed_chunk01_checked,
    `D1Bound5.PairGraphPrepared35.indexed_chunk02_checked,
    `D1Bound5.PairGraphPrepared35.indexed_chunk03_checked,
    `D1Bound5.PairGraphPrepared35.indexed_chunk04_checked,
    `D1Bound5.PairGraphPrepared35.indexed_chunk05_checked,
    `D1Bound5.PairGraphPrepared35.indexed_coverage_checked,
    `D1Bound5.PairGraphPrepared35.indexed_checked,
    `D1Bound5.smallPairClosure_35_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH35_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5
open QuadInt
example
: QuadInt 1 2 :=
  _root_.D1Bound5.smallPairA_35
end D1Bound5

namespace D1Bound5
open QuadInt
example
: QuadInt 1 2 :=
  _root_.D1Bound5.smallPairB_35
end D1Bound5

namespace D1Bound5
open QuadInt
example
: List (QuadInt 1 2) :=
  _root_.D1Bound5.smallPairClosure_35
end D1Bound5

namespace D1Bound5
open QuadInt
example
: List (QuadInt 1 2) :=
  _root_.D1Bound5.smallPairLarge_35
end D1Bound5

namespace D1Bound5.PairGraphPrepared35
open QuadInt
example
: ℕ :=
  _root_.D1Bound5.PairGraphPrepared35.colors
end D1Bound5.PairGraphPrepared35

namespace D1Bound5.PairGraphPrepared35

example
: QuadInt 1 2 :=
  _root_.D1Bound5.PairGraphPrepared35.anchorRoot
end D1Bound5.PairGraphPrepared35

namespace D1Bound5.PairGraphPrepared35

example
: List (QuadInt 1 2 × QuadInt 1 2) :=
  _root_.D1Bound5.PairGraphPrepared35.rootPairs
end D1Bound5.PairGraphPrepared35

namespace D1Bound5.PairGraphPrepared35

example
: List (PairRootWitness 1 2) :=
  _root_.D1Bound5.PairGraphPrepared35.witnesses
end D1Bound5.PairGraphPrepared35

namespace D1Bound5.PairGraphPrepared35

example
: List (Option ℕ × Option ℕ) :=
  _root_.D1Bound5.PairGraphPrepared35.destinations
end D1Bound5.PairGraphPrepared35

namespace D1Bound5.PairGraphPrepared35

example
:
    pairIndexedWitnessesPrefixBool smallPairA_35 smallPairB_35 anchorRoot
      (10^1100) smallPairClosure_35 128
      (witnesses.drop 0) (destinations.drop 0) = true :=
  _root_.D1Bound5.PairGraphPrepared35.indexed_chunk00_checked
end D1Bound5.PairGraphPrepared35

namespace D1Bound5.PairGraphPrepared35

example
:
    pairIndexedWitnessesPrefixBool smallPairA_35 smallPairB_35 anchorRoot
      (10^1100) smallPairClosure_35 128
      (witnesses.drop 128) (destinations.drop 128) = true :=
  _root_.D1Bound5.PairGraphPrepared35.indexed_chunk01_checked
end D1Bound5.PairGraphPrepared35

namespace D1Bound5.PairGraphPrepared35

example
:
    pairIndexedWitnessesPrefixBool smallPairA_35 smallPairB_35 anchorRoot
      (10^1100) smallPairClosure_35 128
      (witnesses.drop 256) (destinations.drop 256) = true :=
  _root_.D1Bound5.PairGraphPrepared35.indexed_chunk02_checked
end D1Bound5.PairGraphPrepared35

namespace D1Bound5.PairGraphPrepared35

example
:
    pairIndexedWitnessesPrefixBool smallPairA_35 smallPairB_35 anchorRoot
      (10^1100) smallPairClosure_35 128
      (witnesses.drop 384) (destinations.drop 384) = true :=
  _root_.D1Bound5.PairGraphPrepared35.indexed_chunk03_checked
end D1Bound5.PairGraphPrepared35

namespace D1Bound5.PairGraphPrepared35

example
:
    pairIndexedWitnessesPrefixBool smallPairA_35 smallPairB_35 anchorRoot
      (10^1100) smallPairClosure_35 128
      (witnesses.drop 512) (destinations.drop 512) = true :=
  _root_.D1Bound5.PairGraphPrepared35.indexed_chunk04_checked
end D1Bound5.PairGraphPrepared35

namespace D1Bound5.PairGraphPrepared35

example
:
    pairIndexedWitnessesPrefixBool smallPairA_35 smallPairB_35 anchorRoot
      (10^1100) smallPairClosure_35 99
      (witnesses.drop 640) (destinations.drop 640) = true :=
  _root_.D1Bound5.PairGraphPrepared35.indexed_chunk05_checked
end D1Bound5.PairGraphPrepared35

namespace D1Bound5.PairGraphPrepared35

example
:
    decide (anchorRoot * anchorRoot = smallPairA_35 * smallPairB_35 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_35) = true :=
  _root_.D1Bound5.PairGraphPrepared35.indexed_coverage_checked
end D1Bound5.PairGraphPrepared35

namespace D1Bound5
open PairGraphPrepared35
example
:
    pairClosureIndexedWitnessBool smallPairA_35 smallPairB_35 anchorRoot
      (10^1100) smallPairClosure_35 witnesses destinations = true :=
  _root_.D1Bound5.PairGraphPrepared35.indexed_checked
end D1Bound5

namespace D1Bound5
open PairGraphPrepared35
example
:
    pairClosureBool smallPairA_35 smallPairB_35
      (10^1100) smallPairClosure_35 = true :=
  _root_.D1Bound5.smallPairClosure_35_checked
end D1Bound5

#check @_root_.D1Bound5.smallPairA_35
#check @_root_.D1Bound5.smallPairB_35
#check @_root_.D1Bound5.smallPairClosure_35
#check @_root_.D1Bound5.smallPairLarge_35
#check @_root_.D1Bound5.PairGraphPrepared35.colors
#check @_root_.D1Bound5.PairGraphPrepared35.anchorRoot
#check @_root_.D1Bound5.PairGraphPrepared35.rootPairs
#check @_root_.D1Bound5.PairGraphPrepared35.witnesses
#check @_root_.D1Bound5.PairGraphPrepared35.destinations
#check @_root_.D1Bound5.PairGraphPrepared35.indexed_chunk00_checked
#check @_root_.D1Bound5.PairGraphPrepared35.indexed_chunk01_checked
#check @_root_.D1Bound5.PairGraphPrepared35.indexed_chunk02_checked
#check @_root_.D1Bound5.PairGraphPrepared35.indexed_chunk03_checked
#check @_root_.D1Bound5.PairGraphPrepared35.indexed_chunk04_checked
#check @_root_.D1Bound5.PairGraphPrepared35.indexed_chunk05_checked
#check @_root_.D1Bound5.PairGraphPrepared35.indexed_coverage_checked
#check @_root_.D1Bound5.PairGraphPrepared35.indexed_checked
#check @_root_.D1Bound5.smallPairClosure_35_checked
