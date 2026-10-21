import D1Bound5.SmallPairGraphInputs12
import D1Bound5.SmallPairGraphWitnessData12
import D1Bound5.SmallPairGraphClosure12Chunk00Part00
import D1Bound5.SmallPairGraphClosure12Chunk00Part01
import D1Bound5.SmallPairGraphClosure12Chunk00
import D1Bound5.SmallPairGraphClosure12Coverage
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.smallPairA_12,
    `D1Bound5.smallPairB_12,
    `D1Bound5.smallPairClosure_12,
    `D1Bound5.smallPairLarge_12,
    `D1Bound5.PairGraphPrepared12.colors,
    `D1Bound5.PairGraphPrepared12.anchorRoot,
    `D1Bound5.PairGraphPrepared12.rootPairs,
    `D1Bound5.PairGraphPrepared12.witnesses,
    `D1Bound5.PairGraphPrepared12.destinations,
    `D1Bound5.PairGraphPrepared12.indexed_chunk00_part00_checked,
    `D1Bound5.PairGraphPrepared12.indexed_chunk00_part01_checked,
    `D1Bound5.PairGraphPrepared12.indexed_chunk00_checked,
    `D1Bound5.PairGraphPrepared12.indexed_coverage_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH12_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5
open QuadInt
example
: QuadInt 0 1 :=
  _root_.D1Bound5.smallPairA_12
end D1Bound5

namespace D1Bound5
open QuadInt
example
: QuadInt 0 1 :=
  _root_.D1Bound5.smallPairB_12
end D1Bound5

namespace D1Bound5
open QuadInt
example
: List (QuadInt 0 1) :=
  _root_.D1Bound5.smallPairClosure_12
end D1Bound5

namespace D1Bound5
open QuadInt
example
: List (QuadInt 0 1) :=
  _root_.D1Bound5.smallPairLarge_12
end D1Bound5

namespace D1Bound5.PairGraphPrepared12
open QuadInt
example
: ℕ :=
  _root_.D1Bound5.PairGraphPrepared12.colors
end D1Bound5.PairGraphPrepared12

namespace D1Bound5.PairGraphPrepared12

example
: QuadInt 0 1 :=
  _root_.D1Bound5.PairGraphPrepared12.anchorRoot
end D1Bound5.PairGraphPrepared12

namespace D1Bound5.PairGraphPrepared12

example
: List (QuadInt 0 1 × QuadInt 0 1) :=
  _root_.D1Bound5.PairGraphPrepared12.rootPairs
end D1Bound5.PairGraphPrepared12

namespace D1Bound5.PairGraphPrepared12

example
: List (PairRootWitness 0 1) :=
  _root_.D1Bound5.PairGraphPrepared12.witnesses
end D1Bound5.PairGraphPrepared12

namespace D1Bound5.PairGraphPrepared12

example
: List (Option ℕ × Option ℕ) :=
  _root_.D1Bound5.PairGraphPrepared12.destinations
end D1Bound5.PairGraphPrepared12

namespace D1Bound5.PairGraphPrepared12

example
:
    pairIndexedWitnessesPrefixBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 64
      (witnesses.drop 0) (destinations.drop 0) = true :=
  _root_.D1Bound5.PairGraphPrepared12.indexed_chunk00_part00_checked
end D1Bound5.PairGraphPrepared12

namespace D1Bound5.PairGraphPrepared12

example
:
    pairIndexedWitnessesPrefixBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 64
      (witnesses.drop 64) (destinations.drop 64) = true :=
  _root_.D1Bound5.PairGraphPrepared12.indexed_chunk00_part01_checked
end D1Bound5.PairGraphPrepared12

namespace D1Bound5.PairGraphPrepared12

example
:
    pairIndexedWitnessesPrefixBool smallPairA_12 smallPairB_12 anchorRoot
      (10^1100) smallPairClosure_12 128
      (witnesses.drop 0) (destinations.drop 0) = true :=
  _root_.D1Bound5.PairGraphPrepared12.indexed_chunk00_checked
end D1Bound5.PairGraphPrepared12

namespace D1Bound5.PairGraphPrepared12

example
:
    decide (anchorRoot * anchorRoot = smallPairA_12 * smallPairB_12 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_12) = true :=
  _root_.D1Bound5.PairGraphPrepared12.indexed_coverage_checked
end D1Bound5.PairGraphPrepared12

#check @_root_.D1Bound5.smallPairA_12
#check @_root_.D1Bound5.smallPairB_12
#check @_root_.D1Bound5.smallPairClosure_12
#check @_root_.D1Bound5.smallPairLarge_12
#check @_root_.D1Bound5.PairGraphPrepared12.colors
#check @_root_.D1Bound5.PairGraphPrepared12.anchorRoot
#check @_root_.D1Bound5.PairGraphPrepared12.rootPairs
#check @_root_.D1Bound5.PairGraphPrepared12.witnesses
#check @_root_.D1Bound5.PairGraphPrepared12.destinations
#check @_root_.D1Bound5.PairGraphPrepared12.indexed_chunk00_part00_checked
#check @_root_.D1Bound5.PairGraphPrepared12.indexed_chunk00_part01_checked
#check @_root_.D1Bound5.PairGraphPrepared12.indexed_chunk00_checked
#check @_root_.D1Bound5.PairGraphPrepared12.indexed_coverage_checked
