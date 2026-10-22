import D1Bound5.SmallPairGraphInputs1
import D1Bound5.SmallPairGraphWitnessData1
import D1Bound5.SmallPairGraphClosure1Chunk00
import D1Bound5.SmallPairGraphClosure1Coverage
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.smallPairA_1,
    `D1Bound5.smallPairB_1,
    `D1Bound5.smallPairClosure_1,
    `D1Bound5.smallPairLarge_1,
    `D1Bound5.PairGraphPrepared1.colors,
    `D1Bound5.PairGraphPrepared1.anchorRoot,
    `D1Bound5.PairGraphPrepared1.rootPairs,
    `D1Bound5.PairGraphPrepared1.witnesses,
    `D1Bound5.PairGraphPrepared1.destinations,
    `D1Bound5.PairGraphPrepared1.indexed_chunk00_checked,
    `D1Bound5.PairGraphPrepared1.indexed_coverage_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH1_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5
open QuadInt
example
: QuadInt 0 1 :=
  _root_.D1Bound5.smallPairA_1
end D1Bound5

namespace D1Bound5
open QuadInt
example
: QuadInt 0 1 :=
  _root_.D1Bound5.smallPairB_1
end D1Bound5

namespace D1Bound5
open QuadInt
example
: List (QuadInt 0 1) :=
  _root_.D1Bound5.smallPairClosure_1
end D1Bound5

namespace D1Bound5
open QuadInt
example
: List (QuadInt 0 1) :=
  _root_.D1Bound5.smallPairLarge_1
end D1Bound5

namespace D1Bound5.PairGraphPrepared1
open QuadInt
example
: ℕ :=
  _root_.D1Bound5.PairGraphPrepared1.colors
end D1Bound5.PairGraphPrepared1

namespace D1Bound5.PairGraphPrepared1

example
: QuadInt 0 1 :=
  _root_.D1Bound5.PairGraphPrepared1.anchorRoot
end D1Bound5.PairGraphPrepared1

namespace D1Bound5.PairGraphPrepared1

example
: List (QuadInt 0 1 × QuadInt 0 1) :=
  _root_.D1Bound5.PairGraphPrepared1.rootPairs
end D1Bound5.PairGraphPrepared1

namespace D1Bound5.PairGraphPrepared1

example
: List (PairRootWitness 0 1) :=
  _root_.D1Bound5.PairGraphPrepared1.witnesses
end D1Bound5.PairGraphPrepared1

namespace D1Bound5.PairGraphPrepared1

example
: List (Option ℕ × Option ℕ) :=
  _root_.D1Bound5.PairGraphPrepared1.destinations
end D1Bound5.PairGraphPrepared1

namespace D1Bound5.PairGraphPrepared1

example
:
    pairIndexedWitnessesPrefixBool smallPairA_1 smallPairB_1 anchorRoot
      (10^1100) smallPairClosure_1 64
      (witnesses.drop 0) (destinations.drop 0) = true :=
  _root_.D1Bound5.PairGraphPrepared1.indexed_chunk00_checked
end D1Bound5.PairGraphPrepared1

namespace D1Bound5.PairGraphPrepared1

example
:
    decide (anchorRoot * anchorRoot = smallPairA_1 * smallPairB_1 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_1) = true :=
  _root_.D1Bound5.PairGraphPrepared1.indexed_coverage_checked
end D1Bound5.PairGraphPrepared1

#check @_root_.D1Bound5.smallPairA_1
#check @_root_.D1Bound5.smallPairB_1
#check @_root_.D1Bound5.smallPairClosure_1
#check @_root_.D1Bound5.smallPairLarge_1
#check @_root_.D1Bound5.PairGraphPrepared1.colors
#check @_root_.D1Bound5.PairGraphPrepared1.anchorRoot
#check @_root_.D1Bound5.PairGraphPrepared1.rootPairs
#check @_root_.D1Bound5.PairGraphPrepared1.witnesses
#check @_root_.D1Bound5.PairGraphPrepared1.destinations
#check @_root_.D1Bound5.PairGraphPrepared1.indexed_chunk00_checked
#check @_root_.D1Bound5.PairGraphPrepared1.indexed_coverage_checked
