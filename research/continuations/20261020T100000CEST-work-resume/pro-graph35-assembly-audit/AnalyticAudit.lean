import D1Bound5.SmallPairGraphArithmetic35
import D1Bound5.SmallPairRawSelectedData35
import D1Bound5.SmallPairLightAssembly35
import D1Bound5.SmallPairGraphTriangle35
import D1Bound5.SmallPairGraphData35
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.smallPairSeeds_35_checked,
    `D1Bound5.smallPairFilter_35_checked,
    `D1Bound5.smallPairLarge_35_count,
    `D1Bound5.PairSelectedPrepared35.leftCached,
    `D1Bound5.PairSelectedPrepared35.leftRows,
    `D1Bound5.PairSelectedPrepared35.rightCached,
    `D1Bound5.PairSelectedPrepared35.rightRows,
    `D1Bound5.PairLightPrepared35.sieve_eq,
    `D1Bound5.PairLightPrepared35.leftVertices_eq,
    `D1Bound5.PairLightPrepared35.leftCached_eq,
    `D1Bound5.PairLightPrepared35.leftRows_eq,
    `D1Bound5.PairLightPrepared35.left_checked,
    `D1Bound5.PairLightPrepared35.rightVertices_eq,
    `D1Bound5.PairLightPrepared35.rightCached_eq,
    `D1Bound5.PairLightPrepared35.rightRows_eq,
    `D1Bound5.PairLightPrepared35.right_checked,
    `D1Bound5.smallPairNoTriangle_35_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH35_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5

example
:
    pairSeedsCoveredBool smallPairA_35 smallPairB_35
      seedRootDisk_1_2 smallPairClosure_35 = true :=
  _root_.D1Bound5.smallPairSeeds_35_checked
end D1Bound5

namespace D1Bound5

example
:
    largePairVertices smallPairA_35 smallPairB_35 smallPairClosure_35 = smallPairLarge_35 :=
  _root_.D1Bound5.smallPairFilter_35_checked
end D1Bound5

namespace D1Bound5

example
: smallPairLarge_35.length = 737 :=
  _root_.D1Bound5.smallPairLarge_35_count
end D1Bound5

namespace D1Bound5.PairSelectedPrepared35

example
: List (PairResidueVertex 1 2) :=
  _root_.D1Bound5.PairSelectedPrepared35.leftCached
end D1Bound5.PairSelectedPrepared35

namespace D1Bound5.PairSelectedPrepared35

example
: List (ℕ × List ℕ) :=
  _root_.D1Bound5.PairSelectedPrepared35.leftRows
end D1Bound5.PairSelectedPrepared35

namespace D1Bound5.PairSelectedPrepared35

example
: List (PairResidueVertex 1 2) :=
  _root_.D1Bound5.PairSelectedPrepared35.rightCached
end D1Bound5.PairSelectedPrepared35

namespace D1Bound5.PairSelectedPrepared35

example
: List (ℕ × List ℕ) :=
  _root_.D1Bound5.PairSelectedPrepared35.rightRows
end D1Bound5.PairSelectedPrepared35

namespace D1Bound5.PairLightPrepared35

example
: sieve = smallPairSieve_1_2 :=
  _root_.D1Bound5.PairLightPrepared35.sieve_eq
end D1Bound5.PairLightPrepared35

namespace D1Bound5.PairLightPrepared35

example
:
    leftVertices = (pairSplitByMask smallPairLarge_35 PairGraphPrepared35.colors).1.map pairLightCoordinates :=
  _root_.D1Bound5.PairLightPrepared35.leftVertices_eq
end D1Bound5.PairLightPrepared35

namespace D1Bound5.PairLightPrepared35

example
:
    leftCached = PairSelectedPrepared35.leftCached.map pairLightCachedCoordinates :=
  _root_.D1Bound5.PairLightPrepared35.leftCached_eq
end D1Bound5.PairLightPrepared35

namespace D1Bound5.PairLightPrepared35

example
: leftRows = PairSelectedPrepared35.leftRows :=
  _root_.D1Bound5.PairLightPrepared35.leftRows_eq
end D1Bound5.PairLightPrepared35

namespace D1Bound5.PairLightPrepared35

example
:
    pairIndependentBool smallPairSieve_1_2 (pairSplitByMask smallPairLarge_35 PairGraphPrepared35.colors).1 = true :=
  _root_.D1Bound5.PairLightPrepared35.left_checked
end D1Bound5.PairLightPrepared35

namespace D1Bound5.PairLightPrepared35

example
:
    rightVertices = (pairSplitByMask smallPairLarge_35 PairGraphPrepared35.colors).2.map pairLightCoordinates :=
  _root_.D1Bound5.PairLightPrepared35.rightVertices_eq
end D1Bound5.PairLightPrepared35

namespace D1Bound5.PairLightPrepared35

example
:
    rightCached = PairSelectedPrepared35.rightCached.map pairLightCachedCoordinates :=
  _root_.D1Bound5.PairLightPrepared35.rightCached_eq
end D1Bound5.PairLightPrepared35

namespace D1Bound5.PairLightPrepared35

example
: rightRows = PairSelectedPrepared35.rightRows :=
  _root_.D1Bound5.PairLightPrepared35.rightRows_eq
end D1Bound5.PairLightPrepared35

namespace D1Bound5.PairLightPrepared35

example
:
    pairIndependentBool smallPairSieve_1_2 (pairSplitByMask smallPairLarge_35 PairGraphPrepared35.colors).2 = true :=
  _root_.D1Bound5.PairLightPrepared35.right_checked
end D1Bound5.PairLightPrepared35

namespace D1Bound5

example
:
    pairGraphTriangleFreeBool smallPairSieve_1_2 smallPairLarge_35 = true :=
  _root_.D1Bound5.smallPairNoTriangle_35_checked
end D1Bound5

#check @_root_.D1Bound5.smallPairSeeds_35_checked
#check @_root_.D1Bound5.smallPairFilter_35_checked
#check @_root_.D1Bound5.smallPairLarge_35_count
#check @_root_.D1Bound5.PairSelectedPrepared35.leftCached
#check @_root_.D1Bound5.PairSelectedPrepared35.leftRows
#check @_root_.D1Bound5.PairSelectedPrepared35.rightCached
#check @_root_.D1Bound5.PairSelectedPrepared35.rightRows
#check @_root_.D1Bound5.PairLightPrepared35.sieve_eq
#check @_root_.D1Bound5.PairLightPrepared35.leftVertices_eq
#check @_root_.D1Bound5.PairLightPrepared35.leftCached_eq
#check @_root_.D1Bound5.PairLightPrepared35.leftRows_eq
#check @_root_.D1Bound5.PairLightPrepared35.left_checked
#check @_root_.D1Bound5.PairLightPrepared35.rightVertices_eq
#check @_root_.D1Bound5.PairLightPrepared35.rightCached_eq
#check @_root_.D1Bound5.PairLightPrepared35.rightRows_eq
#check @_root_.D1Bound5.PairLightPrepared35.right_checked
#check @_root_.D1Bound5.smallPairNoTriangle_35_checked
