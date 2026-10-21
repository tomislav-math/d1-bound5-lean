import D1Bound5.SmallPairGraphInputs29
import D1Bound5.SmallPairGraphWitnessData29
import D1Bound5.SmallPairGraphClosure29Chunk00
import D1Bound5.SmallPairGraphClosure29Coverage
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.smallPairA_29,
    `D1Bound5.smallPairB_29,
    `D1Bound5.smallPairClosure_29,
    `D1Bound5.smallPairLarge_29,
    `D1Bound5.PairGraphPrepared29.colors,
    `D1Bound5.PairGraphPrepared29.anchorRoot,
    `D1Bound5.PairGraphPrepared29.rootPairs,
    `D1Bound5.PairGraphPrepared29.witnesses,
    `D1Bound5.PairGraphPrepared29.destinations,
    `D1Bound5.PairGraphPrepared29.indexed_chunk00_checked,
    `D1Bound5.PairGraphPrepared29.indexed_coverage_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH29_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5
open QuadInt
example
: QuadInt 1 1 :=
  _root_.D1Bound5.smallPairA_29
end D1Bound5

namespace D1Bound5
open QuadInt
example
: QuadInt 1 1 :=
  _root_.D1Bound5.smallPairB_29
end D1Bound5

namespace D1Bound5
open QuadInt
example
: List (QuadInt 1 1) :=
  _root_.D1Bound5.smallPairClosure_29
end D1Bound5

namespace D1Bound5
open QuadInt
example
: List (QuadInt 1 1) :=
  _root_.D1Bound5.smallPairLarge_29
end D1Bound5

namespace D1Bound5.PairGraphPrepared29
open QuadInt
example
: ℕ :=
  _root_.D1Bound5.PairGraphPrepared29.colors
end D1Bound5.PairGraphPrepared29

namespace D1Bound5.PairGraphPrepared29

example
: QuadInt 1 1 :=
  _root_.D1Bound5.PairGraphPrepared29.anchorRoot
end D1Bound5.PairGraphPrepared29

namespace D1Bound5.PairGraphPrepared29

example
: List (QuadInt 1 1 × QuadInt 1 1) :=
  _root_.D1Bound5.PairGraphPrepared29.rootPairs
end D1Bound5.PairGraphPrepared29

namespace D1Bound5.PairGraphPrepared29

example
: List (PairRootWitness 1 1) :=
  _root_.D1Bound5.PairGraphPrepared29.witnesses
end D1Bound5.PairGraphPrepared29

namespace D1Bound5.PairGraphPrepared29

example
: List (Option ℕ × Option ℕ) :=
  _root_.D1Bound5.PairGraphPrepared29.destinations
end D1Bound5.PairGraphPrepared29

namespace D1Bound5.PairGraphPrepared29

example
:
    pairIndexedWitnessesPrefixBool smallPairA_29 smallPairB_29 anchorRoot
      (10^1100) smallPairClosure_29 64
      (witnesses.drop 0) (destinations.drop 0) = true :=
  _root_.D1Bound5.PairGraphPrepared29.indexed_chunk00_checked
end D1Bound5.PairGraphPrepared29

namespace D1Bound5.PairGraphPrepared29

example
:
    decide (anchorRoot * anchorRoot = smallPairA_29 * smallPairB_29 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_29) = true :=
  _root_.D1Bound5.PairGraphPrepared29.indexed_coverage_checked
end D1Bound5.PairGraphPrepared29

#check @_root_.D1Bound5.smallPairA_29
#check @_root_.D1Bound5.smallPairB_29
#check @_root_.D1Bound5.smallPairClosure_29
#check @_root_.D1Bound5.smallPairLarge_29
#check @_root_.D1Bound5.PairGraphPrepared29.colors
#check @_root_.D1Bound5.PairGraphPrepared29.anchorRoot
#check @_root_.D1Bound5.PairGraphPrepared29.rootPairs
#check @_root_.D1Bound5.PairGraphPrepared29.witnesses
#check @_root_.D1Bound5.PairGraphPrepared29.destinations
#check @_root_.D1Bound5.PairGraphPrepared29.indexed_chunk00_checked
#check @_root_.D1Bound5.PairGraphPrepared29.indexed_coverage_checked
