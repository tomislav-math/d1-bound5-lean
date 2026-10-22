import D1Bound5.SmallPairGraphInputs25
import D1Bound5.SmallPairGraphWitnessData25
import D1Bound5.SmallPairGraphClosure25Chunk00
import D1Bound5.SmallPairGraphClosure25Coverage
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.smallPairA_25,
    `D1Bound5.smallPairB_25,
    `D1Bound5.smallPairClosure_25,
    `D1Bound5.smallPairLarge_25,
    `D1Bound5.PairGraphPrepared25.colors,
    `D1Bound5.PairGraphPrepared25.anchorRoot,
    `D1Bound5.PairGraphPrepared25.rootPairs,
    `D1Bound5.PairGraphPrepared25.witnesses,
    `D1Bound5.PairGraphPrepared25.destinations,
    `D1Bound5.PairGraphPrepared25.indexed_chunk00_checked,
    `D1Bound5.PairGraphPrepared25.indexed_coverage_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH25_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5
open QuadInt
example
: QuadInt 1 1 :=
  _root_.D1Bound5.smallPairA_25
end D1Bound5

namespace D1Bound5
open QuadInt
example
: QuadInt 1 1 :=
  _root_.D1Bound5.smallPairB_25
end D1Bound5

namespace D1Bound5
open QuadInt
example
: List (QuadInt 1 1) :=
  _root_.D1Bound5.smallPairClosure_25
end D1Bound5

namespace D1Bound5
open QuadInt
example
: List (QuadInt 1 1) :=
  _root_.D1Bound5.smallPairLarge_25
end D1Bound5

namespace D1Bound5.PairGraphPrepared25
open QuadInt
example
: ℕ :=
  _root_.D1Bound5.PairGraphPrepared25.colors
end D1Bound5.PairGraphPrepared25

namespace D1Bound5.PairGraphPrepared25

example
: QuadInt 1 1 :=
  _root_.D1Bound5.PairGraphPrepared25.anchorRoot
end D1Bound5.PairGraphPrepared25

namespace D1Bound5.PairGraphPrepared25

example
: List (QuadInt 1 1 × QuadInt 1 1) :=
  _root_.D1Bound5.PairGraphPrepared25.rootPairs
end D1Bound5.PairGraphPrepared25

namespace D1Bound5.PairGraphPrepared25

example
: List (PairRootWitness 1 1) :=
  _root_.D1Bound5.PairGraphPrepared25.witnesses
end D1Bound5.PairGraphPrepared25

namespace D1Bound5.PairGraphPrepared25

example
: List (Option ℕ × Option ℕ) :=
  _root_.D1Bound5.PairGraphPrepared25.destinations
end D1Bound5.PairGraphPrepared25

namespace D1Bound5.PairGraphPrepared25

example
:
    pairIndexedWitnessesPrefixBool smallPairA_25 smallPairB_25 anchorRoot
      (10^1100) smallPairClosure_25 64
      (witnesses.drop 0) (destinations.drop 0) = true :=
  _root_.D1Bound5.PairGraphPrepared25.indexed_chunk00_checked
end D1Bound5.PairGraphPrepared25

namespace D1Bound5.PairGraphPrepared25

example
:
    decide (anchorRoot * anchorRoot = smallPairA_25 * smallPairB_25 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_25) = true :=
  _root_.D1Bound5.PairGraphPrepared25.indexed_coverage_checked
end D1Bound5.PairGraphPrepared25

#check @_root_.D1Bound5.smallPairA_25
#check @_root_.D1Bound5.smallPairB_25
#check @_root_.D1Bound5.smallPairClosure_25
#check @_root_.D1Bound5.smallPairLarge_25
#check @_root_.D1Bound5.PairGraphPrepared25.colors
#check @_root_.D1Bound5.PairGraphPrepared25.anchorRoot
#check @_root_.D1Bound5.PairGraphPrepared25.rootPairs
#check @_root_.D1Bound5.PairGraphPrepared25.witnesses
#check @_root_.D1Bound5.PairGraphPrepared25.destinations
#check @_root_.D1Bound5.PairGraphPrepared25.indexed_chunk00_checked
#check @_root_.D1Bound5.PairGraphPrepared25.indexed_coverage_checked
