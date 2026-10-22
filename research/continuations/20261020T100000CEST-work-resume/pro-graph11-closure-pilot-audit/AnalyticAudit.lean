import D1Bound5.SmallPairGraphInputs11
import D1Bound5.SmallPairGraphWitnessData11
import D1Bound5.SmallPairGraphClosure11Chunk00
import D1Bound5.SmallPairGraphClosure11Coverage
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.smallPairA_11,
    `D1Bound5.smallPairB_11,
    `D1Bound5.smallPairClosure_11,
    `D1Bound5.smallPairLarge_11,
    `D1Bound5.PairGraphPrepared11.colors,
    `D1Bound5.PairGraphPrepared11.anchorRoot,
    `D1Bound5.PairGraphPrepared11.rootPairs,
    `D1Bound5.PairGraphPrepared11.witnesses,
    `D1Bound5.PairGraphPrepared11.destinations,
    `D1Bound5.PairGraphPrepared11.indexed_chunk00_checked,
    `D1Bound5.PairGraphPrepared11.indexed_coverage_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH11_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5
open QuadInt
example
: QuadInt 0 1 :=
  _root_.D1Bound5.smallPairA_11
end D1Bound5

namespace D1Bound5
open QuadInt
example
: QuadInt 0 1 :=
  _root_.D1Bound5.smallPairB_11
end D1Bound5

namespace D1Bound5
open QuadInt
example
: List (QuadInt 0 1) :=
  _root_.D1Bound5.smallPairClosure_11
end D1Bound5

namespace D1Bound5
open QuadInt
example
: List (QuadInt 0 1) :=
  _root_.D1Bound5.smallPairLarge_11
end D1Bound5

namespace D1Bound5.PairGraphPrepared11
open QuadInt
example
: ℕ :=
  _root_.D1Bound5.PairGraphPrepared11.colors
end D1Bound5.PairGraphPrepared11

namespace D1Bound5.PairGraphPrepared11

example
: QuadInt 0 1 :=
  _root_.D1Bound5.PairGraphPrepared11.anchorRoot
end D1Bound5.PairGraphPrepared11

namespace D1Bound5.PairGraphPrepared11

example
: List (QuadInt 0 1 × QuadInt 0 1) :=
  _root_.D1Bound5.PairGraphPrepared11.rootPairs
end D1Bound5.PairGraphPrepared11

namespace D1Bound5.PairGraphPrepared11

example
: List (PairRootWitness 0 1) :=
  _root_.D1Bound5.PairGraphPrepared11.witnesses
end D1Bound5.PairGraphPrepared11

namespace D1Bound5.PairGraphPrepared11

example
: List (Option ℕ × Option ℕ) :=
  _root_.D1Bound5.PairGraphPrepared11.destinations
end D1Bound5.PairGraphPrepared11

namespace D1Bound5.PairGraphPrepared11

example
:
    pairIndexedWitnessesPrefixBool smallPairA_11 smallPairB_11 anchorRoot
      (10^1100) smallPairClosure_11 64
      (witnesses.drop 0) (destinations.drop 0) = true :=
  _root_.D1Bound5.PairGraphPrepared11.indexed_chunk00_checked
end D1Bound5.PairGraphPrepared11

namespace D1Bound5.PairGraphPrepared11

example
:
    decide (anchorRoot * anchorRoot = smallPairA_11 * smallPairB_11 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_11) = true :=
  _root_.D1Bound5.PairGraphPrepared11.indexed_coverage_checked
end D1Bound5.PairGraphPrepared11

#check @_root_.D1Bound5.smallPairA_11
#check @_root_.D1Bound5.smallPairB_11
#check @_root_.D1Bound5.smallPairClosure_11
#check @_root_.D1Bound5.smallPairLarge_11
#check @_root_.D1Bound5.PairGraphPrepared11.colors
#check @_root_.D1Bound5.PairGraphPrepared11.anchorRoot
#check @_root_.D1Bound5.PairGraphPrepared11.rootPairs
#check @_root_.D1Bound5.PairGraphPrepared11.witnesses
#check @_root_.D1Bound5.PairGraphPrepared11.destinations
#check @_root_.D1Bound5.PairGraphPrepared11.indexed_chunk00_checked
#check @_root_.D1Bound5.PairGraphPrepared11.indexed_coverage_checked
