import D1Bound5.SmallPairGraphInputs48
import D1Bound5.SmallPairGraphWitnessData48
import D1Bound5.SmallPairGraphClosure48Chunk00
import D1Bound5.SmallPairGraphClosure48Chunk01
import D1Bound5.SmallPairGraphClosure48Chunk02
import D1Bound5.SmallPairGraphClosure48Chunk03
import D1Bound5.SmallPairGraphClosure48Chunk04
import D1Bound5.SmallPairGraphClosure48Chunk05
import D1Bound5.SmallPairGraphClosure48Coverage
import D1Bound5.SmallPairGraphClosure48
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.smallPairA_48,
    `D1Bound5.smallPairB_48,
    `D1Bound5.smallPairClosure_48,
    `D1Bound5.smallPairLarge_48,
    `D1Bound5.PairGraphPrepared48.colors,
    `D1Bound5.PairGraphPrepared48.anchorRoot,
    `D1Bound5.PairGraphPrepared48.rootPairs,
    `D1Bound5.PairGraphPrepared48.witnesses,
    `D1Bound5.PairGraphPrepared48.destinations,
    `D1Bound5.PairGraphPrepared48.indexed_chunk00_checked,
    `D1Bound5.PairGraphPrepared48.indexed_chunk01_checked,
    `D1Bound5.PairGraphPrepared48.indexed_chunk02_checked,
    `D1Bound5.PairGraphPrepared48.indexed_chunk03_checked,
    `D1Bound5.PairGraphPrepared48.indexed_chunk04_checked,
    `D1Bound5.PairGraphPrepared48.indexed_chunk05_checked,
    `D1Bound5.PairGraphPrepared48.indexed_coverage_checked,
    `D1Bound5.PairGraphPrepared48.indexed_checked,
    `D1Bound5.smallPairClosure_48_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH48_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5
open QuadInt
example
: QuadInt 1 8 :=
  _root_.D1Bound5.smallPairA_48
end D1Bound5

namespace D1Bound5
open QuadInt
example
: QuadInt 1 8 :=
  _root_.D1Bound5.smallPairB_48
end D1Bound5

namespace D1Bound5
open QuadInt
example
: List (QuadInt 1 8) :=
  _root_.D1Bound5.smallPairClosure_48
end D1Bound5

namespace D1Bound5
open QuadInt
example
: List (QuadInt 1 8) :=
  _root_.D1Bound5.smallPairLarge_48
end D1Bound5

namespace D1Bound5.PairGraphPrepared48
open QuadInt
example
: ℕ :=
  _root_.D1Bound5.PairGraphPrepared48.colors
end D1Bound5.PairGraphPrepared48

namespace D1Bound5.PairGraphPrepared48

example
: QuadInt 1 8 :=
  _root_.D1Bound5.PairGraphPrepared48.anchorRoot
end D1Bound5.PairGraphPrepared48

namespace D1Bound5.PairGraphPrepared48

example
: List (QuadInt 1 8 × QuadInt 1 8) :=
  _root_.D1Bound5.PairGraphPrepared48.rootPairs
end D1Bound5.PairGraphPrepared48

namespace D1Bound5.PairGraphPrepared48

example
: List (PairRootWitness 1 8) :=
  _root_.D1Bound5.PairGraphPrepared48.witnesses
end D1Bound5.PairGraphPrepared48

namespace D1Bound5.PairGraphPrepared48

example
: List (Option ℕ × Option ℕ) :=
  _root_.D1Bound5.PairGraphPrepared48.destinations
end D1Bound5.PairGraphPrepared48

namespace D1Bound5.PairGraphPrepared48

example
:
    pairIndexedWitnessesPrefixBool smallPairA_48 smallPairB_48 anchorRoot
      (10^1100) smallPairClosure_48 128
      (witnesses.drop 0) (destinations.drop 0) = true :=
  _root_.D1Bound5.PairGraphPrepared48.indexed_chunk00_checked
end D1Bound5.PairGraphPrepared48

namespace D1Bound5.PairGraphPrepared48

example
:
    pairIndexedWitnessesPrefixBool smallPairA_48 smallPairB_48 anchorRoot
      (10^1100) smallPairClosure_48 128
      (witnesses.drop 128) (destinations.drop 128) = true :=
  _root_.D1Bound5.PairGraphPrepared48.indexed_chunk01_checked
end D1Bound5.PairGraphPrepared48

namespace D1Bound5.PairGraphPrepared48

example
:
    pairIndexedWitnessesPrefixBool smallPairA_48 smallPairB_48 anchorRoot
      (10^1100) smallPairClosure_48 128
      (witnesses.drop 256) (destinations.drop 256) = true :=
  _root_.D1Bound5.PairGraphPrepared48.indexed_chunk02_checked
end D1Bound5.PairGraphPrepared48

namespace D1Bound5.PairGraphPrepared48

example
:
    pairIndexedWitnessesPrefixBool smallPairA_48 smallPairB_48 anchorRoot
      (10^1100) smallPairClosure_48 128
      (witnesses.drop 384) (destinations.drop 384) = true :=
  _root_.D1Bound5.PairGraphPrepared48.indexed_chunk03_checked
end D1Bound5.PairGraphPrepared48

namespace D1Bound5.PairGraphPrepared48

example
:
    pairIndexedWitnessesPrefixBool smallPairA_48 smallPairB_48 anchorRoot
      (10^1100) smallPairClosure_48 128
      (witnesses.drop 512) (destinations.drop 512) = true :=
  _root_.D1Bound5.PairGraphPrepared48.indexed_chunk04_checked
end D1Bound5.PairGraphPrepared48

namespace D1Bound5.PairGraphPrepared48

example
:
    pairIndexedWitnessesPrefixBool smallPairA_48 smallPairB_48 anchorRoot
      (10^1100) smallPairClosure_48 79
      (witnesses.drop 640) (destinations.drop 640) = true :=
  _root_.D1Bound5.PairGraphPrepared48.indexed_chunk05_checked
end D1Bound5.PairGraphPrepared48

namespace D1Bound5.PairGraphPrepared48

example
:
    decide (anchorRoot * anchorRoot = smallPairA_48 * smallPairB_48 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_48) = true :=
  _root_.D1Bound5.PairGraphPrepared48.indexed_coverage_checked
end D1Bound5.PairGraphPrepared48

namespace D1Bound5
open PairGraphPrepared48
example
:
    pairClosureIndexedWitnessBool smallPairA_48 smallPairB_48 anchorRoot
      (10^1100) smallPairClosure_48 witnesses destinations = true :=
  _root_.D1Bound5.PairGraphPrepared48.indexed_checked
end D1Bound5

namespace D1Bound5
open PairGraphPrepared48
example
:
    pairClosureBool smallPairA_48 smallPairB_48
      (10^1100) smallPairClosure_48 = true :=
  _root_.D1Bound5.smallPairClosure_48_checked
end D1Bound5

#check @_root_.D1Bound5.smallPairA_48
#check @_root_.D1Bound5.smallPairB_48
#check @_root_.D1Bound5.smallPairClosure_48
#check @_root_.D1Bound5.smallPairLarge_48
#check @_root_.D1Bound5.PairGraphPrepared48.colors
#check @_root_.D1Bound5.PairGraphPrepared48.anchorRoot
#check @_root_.D1Bound5.PairGraphPrepared48.rootPairs
#check @_root_.D1Bound5.PairGraphPrepared48.witnesses
#check @_root_.D1Bound5.PairGraphPrepared48.destinations
#check @_root_.D1Bound5.PairGraphPrepared48.indexed_chunk00_checked
#check @_root_.D1Bound5.PairGraphPrepared48.indexed_chunk01_checked
#check @_root_.D1Bound5.PairGraphPrepared48.indexed_chunk02_checked
#check @_root_.D1Bound5.PairGraphPrepared48.indexed_chunk03_checked
#check @_root_.D1Bound5.PairGraphPrepared48.indexed_chunk04_checked
#check @_root_.D1Bound5.PairGraphPrepared48.indexed_chunk05_checked
#check @_root_.D1Bound5.PairGraphPrepared48.indexed_coverage_checked
#check @_root_.D1Bound5.PairGraphPrepared48.indexed_checked
#check @_root_.D1Bound5.smallPairClosure_48_checked
