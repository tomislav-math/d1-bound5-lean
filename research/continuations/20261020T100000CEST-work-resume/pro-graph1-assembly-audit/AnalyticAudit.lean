import D1Bound5.SmallPairGraphArithmetic1
import D1Bound5.SmallPairRawSelectedData1LeftCached
import D1Bound5.SmallPairRawSelectedData1LeftRows
import D1Bound5.SmallPairRawSelectedData1RightCached
import D1Bound5.SmallPairRawSelectedData1RightRows
import D1Bound5.SmallPairRawSelectedData1
import D1Bound5.SmallPairLightAssembly1
import D1Bound5.SmallPairGraphTriangle1
import D1Bound5.SmallPairGraphData1
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.smallPairSeeds_1_checked,
    `D1Bound5.smallPairFilter_1_checked,
    `D1Bound5.smallPairLarge_1_count,
    `D1Bound5.PairSelectedPrepared1.leftCached,
    `D1Bound5.PairSelectedPrepared1.leftRows,
    `D1Bound5.PairSelectedPrepared1.rightCached,
    `D1Bound5.PairSelectedPrepared1.rightRows,
    `D1Bound5.PairLightPrepared1.sieve_eq,
    `D1Bound5.PairLightPrepared1.leftVertices_eq,
    `D1Bound5.PairLightPrepared1.leftCached_eq,
    `D1Bound5.PairLightPrepared1.leftRows_eq,
    `D1Bound5.PairLightPrepared1.left_checked,
    `D1Bound5.PairLightPrepared1.rightVertices_eq,
    `D1Bound5.PairLightPrepared1.rightCached_eq,
    `D1Bound5.PairLightPrepared1.rightRows_eq,
    `D1Bound5.PairLightPrepared1.right_checked,
    `D1Bound5.smallPairNoTriangle_1_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH1_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5

example
:
    pairSeedsCoveredBool smallPairA_1 smallPairB_1
      seedRootDisk_0_1 smallPairClosure_1 = true :=
  _root_.D1Bound5.smallPairSeeds_1_checked
end D1Bound5

namespace D1Bound5

example
:
    largePairVertices smallPairA_1 smallPairB_1 smallPairClosure_1 = smallPairLarge_1 :=
  _root_.D1Bound5.smallPairFilter_1_checked
end D1Bound5

namespace D1Bound5

example
: smallPairLarge_1.length = 718 :=
  _root_.D1Bound5.smallPairLarge_1_count
end D1Bound5

namespace D1Bound5.PairSelectedPrepared1

example
: List (PairResidueVertex 0 1) :=
  _root_.D1Bound5.PairSelectedPrepared1.leftCached
end D1Bound5.PairSelectedPrepared1

namespace D1Bound5.PairSelectedPrepared1

example
: List (ℕ × List ℕ) :=
  _root_.D1Bound5.PairSelectedPrepared1.leftRows
end D1Bound5.PairSelectedPrepared1

namespace D1Bound5.PairSelectedPrepared1

example
: List (PairResidueVertex 0 1) :=
  _root_.D1Bound5.PairSelectedPrepared1.rightCached
end D1Bound5.PairSelectedPrepared1

namespace D1Bound5.PairSelectedPrepared1

example
: List (ℕ × List ℕ) :=
  _root_.D1Bound5.PairSelectedPrepared1.rightRows
end D1Bound5.PairSelectedPrepared1

namespace D1Bound5.PairLightPrepared1

example
: sieve = smallPairSieve_0_1 :=
  _root_.D1Bound5.PairLightPrepared1.sieve_eq
end D1Bound5.PairLightPrepared1

namespace D1Bound5.PairLightPrepared1

example
:
    leftVertices = (pairSplitByMask smallPairLarge_1 PairGraphPrepared1.colors).1.map pairLightCoordinates :=
  _root_.D1Bound5.PairLightPrepared1.leftVertices_eq
end D1Bound5.PairLightPrepared1

namespace D1Bound5.PairLightPrepared1

example
:
    leftCached = PairSelectedPrepared1.leftCached.map pairLightCachedCoordinates :=
  _root_.D1Bound5.PairLightPrepared1.leftCached_eq
end D1Bound5.PairLightPrepared1

namespace D1Bound5.PairLightPrepared1

example
: leftRows = PairSelectedPrepared1.leftRows :=
  _root_.D1Bound5.PairLightPrepared1.leftRows_eq
end D1Bound5.PairLightPrepared1

namespace D1Bound5.PairLightPrepared1

example
:
    pairIndependentBool smallPairSieve_0_1 (pairSplitByMask smallPairLarge_1 PairGraphPrepared1.colors).1 = true :=
  _root_.D1Bound5.PairLightPrepared1.left_checked
end D1Bound5.PairLightPrepared1

namespace D1Bound5.PairLightPrepared1

example
:
    rightVertices = (pairSplitByMask smallPairLarge_1 PairGraphPrepared1.colors).2.map pairLightCoordinates :=
  _root_.D1Bound5.PairLightPrepared1.rightVertices_eq
end D1Bound5.PairLightPrepared1

namespace D1Bound5.PairLightPrepared1

example
:
    rightCached = PairSelectedPrepared1.rightCached.map pairLightCachedCoordinates :=
  _root_.D1Bound5.PairLightPrepared1.rightCached_eq
end D1Bound5.PairLightPrepared1

namespace D1Bound5.PairLightPrepared1

example
: rightRows = PairSelectedPrepared1.rightRows :=
  _root_.D1Bound5.PairLightPrepared1.rightRows_eq
end D1Bound5.PairLightPrepared1

namespace D1Bound5.PairLightPrepared1

example
:
    pairIndependentBool smallPairSieve_0_1 (pairSplitByMask smallPairLarge_1 PairGraphPrepared1.colors).2 = true :=
  _root_.D1Bound5.PairLightPrepared1.right_checked
end D1Bound5.PairLightPrepared1

namespace D1Bound5

example
:
    pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_1 = true :=
  _root_.D1Bound5.smallPairNoTriangle_1_checked
end D1Bound5

#check @_root_.D1Bound5.smallPairSeeds_1_checked
#check @_root_.D1Bound5.smallPairFilter_1_checked
#check @_root_.D1Bound5.smallPairLarge_1_count
#check @_root_.D1Bound5.PairSelectedPrepared1.leftCached
#check @_root_.D1Bound5.PairSelectedPrepared1.leftRows
#check @_root_.D1Bound5.PairSelectedPrepared1.rightCached
#check @_root_.D1Bound5.PairSelectedPrepared1.rightRows
#check @_root_.D1Bound5.PairLightPrepared1.sieve_eq
#check @_root_.D1Bound5.PairLightPrepared1.leftVertices_eq
#check @_root_.D1Bound5.PairLightPrepared1.leftCached_eq
#check @_root_.D1Bound5.PairLightPrepared1.leftRows_eq
#check @_root_.D1Bound5.PairLightPrepared1.left_checked
#check @_root_.D1Bound5.PairLightPrepared1.rightVertices_eq
#check @_root_.D1Bound5.PairLightPrepared1.rightCached_eq
#check @_root_.D1Bound5.PairLightPrepared1.rightRows_eq
#check @_root_.D1Bound5.PairLightPrepared1.right_checked
#check @_root_.D1Bound5.smallPairNoTriangle_1_checked
