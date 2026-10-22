import D1Bound5.SmallPairGraphInputs46
import D1Bound5.SmallPairGraphWitnessData46
import D1Bound5.SmallPairGraphClosure46Chunk00
import D1Bound5.SmallPairGraphClosure46Coverage
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.smallPairA_46,
    `D1Bound5.smallPairB_46,
    `D1Bound5.smallPairClosure_46,
    `D1Bound5.smallPairLarge_46,
    `D1Bound5.PairGraphPrepared46.colors,
    `D1Bound5.PairGraphPrepared46.anchorRoot,
    `D1Bound5.PairGraphPrepared46.rootPairs,
    `D1Bound5.PairGraphPrepared46.witnesses,
    `D1Bound5.PairGraphPrepared46.destinations,
    `D1Bound5.PairGraphPrepared46.indexed_chunk00_checked,
    `D1Bound5.PairGraphPrepared46.indexed_coverage_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH46_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5
open QuadInt
example
: QuadInt 1 6 :=
  _root_.D1Bound5.smallPairA_46
end D1Bound5

namespace D1Bound5
open QuadInt
example
: QuadInt 1 6 :=
  _root_.D1Bound5.smallPairB_46
end D1Bound5

namespace D1Bound5
open QuadInt
example
: List (QuadInt 1 6) :=
  _root_.D1Bound5.smallPairClosure_46
end D1Bound5

namespace D1Bound5
open QuadInt
example
: List (QuadInt 1 6) :=
  _root_.D1Bound5.smallPairLarge_46
end D1Bound5

namespace D1Bound5.PairGraphPrepared46
open QuadInt
example
: ℕ :=
  _root_.D1Bound5.PairGraphPrepared46.colors
end D1Bound5.PairGraphPrepared46

namespace D1Bound5.PairGraphPrepared46

example
: QuadInt 1 6 :=
  _root_.D1Bound5.PairGraphPrepared46.anchorRoot
end D1Bound5.PairGraphPrepared46

namespace D1Bound5.PairGraphPrepared46

example
: List (QuadInt 1 6 × QuadInt 1 6) :=
  _root_.D1Bound5.PairGraphPrepared46.rootPairs
end D1Bound5.PairGraphPrepared46

namespace D1Bound5.PairGraphPrepared46

example
: List (PairRootWitness 1 6) :=
  _root_.D1Bound5.PairGraphPrepared46.witnesses
end D1Bound5.PairGraphPrepared46

namespace D1Bound5.PairGraphPrepared46

example
: List (Option ℕ × Option ℕ) :=
  _root_.D1Bound5.PairGraphPrepared46.destinations
end D1Bound5.PairGraphPrepared46

namespace D1Bound5.PairGraphPrepared46

example
:
    pairIndexedWitnessesPrefixBool smallPairA_46 smallPairB_46 anchorRoot
      (10^1100) smallPairClosure_46 64
      (witnesses.drop 0) (destinations.drop 0) = true :=
  _root_.D1Bound5.PairGraphPrepared46.indexed_chunk00_checked
end D1Bound5.PairGraphPrepared46

namespace D1Bound5.PairGraphPrepared46

example
:
    decide (anchorRoot * anchorRoot = smallPairA_46 * smallPairB_46 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_46) = true :=
  _root_.D1Bound5.PairGraphPrepared46.indexed_coverage_checked
end D1Bound5.PairGraphPrepared46

#check @_root_.D1Bound5.smallPairA_46
#check @_root_.D1Bound5.smallPairB_46
#check @_root_.D1Bound5.smallPairClosure_46
#check @_root_.D1Bound5.smallPairLarge_46
#check @_root_.D1Bound5.PairGraphPrepared46.colors
#check @_root_.D1Bound5.PairGraphPrepared46.anchorRoot
#check @_root_.D1Bound5.PairGraphPrepared46.rootPairs
#check @_root_.D1Bound5.PairGraphPrepared46.witnesses
#check @_root_.D1Bound5.PairGraphPrepared46.destinations
#check @_root_.D1Bound5.PairGraphPrepared46.indexed_chunk00_checked
#check @_root_.D1Bound5.PairGraphPrepared46.indexed_coverage_checked
