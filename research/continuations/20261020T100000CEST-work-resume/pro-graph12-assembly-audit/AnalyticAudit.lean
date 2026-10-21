import D1Bound5.SmallPairGraphArithmetic12
import D1Bound5.SmallPairRawSelectedData12
import D1Bound5.SmallPairLightAssembly12
import D1Bound5.SmallPairGraphTriangle12
import D1Bound5.SmallPairGraphData12
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.smallPairSeeds_12_checked,
    `D1Bound5.smallPairFilter_12_checked,
    `D1Bound5.smallPairLarge_12_count,
    `D1Bound5.PairSelectedPrepared12.leftCached,
    `D1Bound5.PairSelectedPrepared12.leftRows,
    `D1Bound5.PairSelectedPrepared12.rightCached,
    `D1Bound5.PairSelectedPrepared12.rightRows,
    `D1Bound5.PairLightPrepared12.sieve_eq,
    `D1Bound5.PairLightPrepared12.leftVertices_eq,
    `D1Bound5.PairLightPrepared12.leftCached_eq,
    `D1Bound5.PairLightPrepared12.leftRows_eq,
    `D1Bound5.PairLightPrepared12.left_checked,
    `D1Bound5.PairLightPrepared12.rightVertices_eq,
    `D1Bound5.PairLightPrepared12.rightCached_eq,
    `D1Bound5.PairLightPrepared12.rightRows_eq,
    `D1Bound5.PairLightPrepared12.right_checked,
    `D1Bound5.smallPairNoTriangle_12_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH12_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5

example
:
    pairSeedsCoveredBool smallPairA_12 smallPairB_12
      seedRootDisk_0_1 smallPairClosure_12 = true :=
  _root_.D1Bound5.smallPairSeeds_12_checked
end D1Bound5

namespace D1Bound5

example
:
    largePairVertices smallPairA_12 smallPairB_12 smallPairClosure_12 = smallPairLarge_12 :=
  _root_.D1Bound5.smallPairFilter_12_checked
end D1Bound5

namespace D1Bound5

example
: smallPairLarge_12.length = 718 :=
  _root_.D1Bound5.smallPairLarge_12_count
end D1Bound5

namespace D1Bound5.PairSelectedPrepared12

example
: List (PairResidueVertex 0 1) :=
  _root_.D1Bound5.PairSelectedPrepared12.leftCached
end D1Bound5.PairSelectedPrepared12

namespace D1Bound5.PairSelectedPrepared12

example
: List (ℕ × List ℕ) :=
  _root_.D1Bound5.PairSelectedPrepared12.leftRows
end D1Bound5.PairSelectedPrepared12

namespace D1Bound5.PairSelectedPrepared12

example
: List (PairResidueVertex 0 1) :=
  _root_.D1Bound5.PairSelectedPrepared12.rightCached
end D1Bound5.PairSelectedPrepared12

namespace D1Bound5.PairSelectedPrepared12

example
: List (ℕ × List ℕ) :=
  _root_.D1Bound5.PairSelectedPrepared12.rightRows
end D1Bound5.PairSelectedPrepared12

namespace D1Bound5.PairLightPrepared12

example
: sieve = smallPairSieve_0_1 :=
  _root_.D1Bound5.PairLightPrepared12.sieve_eq
end D1Bound5.PairLightPrepared12

namespace D1Bound5.PairLightPrepared12

example
:
    leftVertices = (pairSplitByMask smallPairLarge_12 PairGraphPrepared12.colors).1.map pairLightCoordinates :=
  _root_.D1Bound5.PairLightPrepared12.leftVertices_eq
end D1Bound5.PairLightPrepared12

namespace D1Bound5.PairLightPrepared12

example
:
    leftCached = PairSelectedPrepared12.leftCached.map pairLightCachedCoordinates :=
  _root_.D1Bound5.PairLightPrepared12.leftCached_eq
end D1Bound5.PairLightPrepared12

namespace D1Bound5.PairLightPrepared12

example
: leftRows = PairSelectedPrepared12.leftRows :=
  _root_.D1Bound5.PairLightPrepared12.leftRows_eq
end D1Bound5.PairLightPrepared12

namespace D1Bound5.PairLightPrepared12

example
:
    pairIndependentBool smallPairSieve_0_1 (pairSplitByMask smallPairLarge_12 PairGraphPrepared12.colors).1 = true :=
  _root_.D1Bound5.PairLightPrepared12.left_checked
end D1Bound5.PairLightPrepared12

namespace D1Bound5.PairLightPrepared12

example
:
    rightVertices = (pairSplitByMask smallPairLarge_12 PairGraphPrepared12.colors).2.map pairLightCoordinates :=
  _root_.D1Bound5.PairLightPrepared12.rightVertices_eq
end D1Bound5.PairLightPrepared12

namespace D1Bound5.PairLightPrepared12

example
:
    rightCached = PairSelectedPrepared12.rightCached.map pairLightCachedCoordinates :=
  _root_.D1Bound5.PairLightPrepared12.rightCached_eq
end D1Bound5.PairLightPrepared12

namespace D1Bound5.PairLightPrepared12

example
: rightRows = PairSelectedPrepared12.rightRows :=
  _root_.D1Bound5.PairLightPrepared12.rightRows_eq
end D1Bound5.PairLightPrepared12

namespace D1Bound5.PairLightPrepared12

example
:
    pairIndependentBool smallPairSieve_0_1 (pairSplitByMask smallPairLarge_12 PairGraphPrepared12.colors).2 = true :=
  _root_.D1Bound5.PairLightPrepared12.right_checked
end D1Bound5.PairLightPrepared12

namespace D1Bound5

example
:
    pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_12 = true :=
  _root_.D1Bound5.smallPairNoTriangle_12_checked
end D1Bound5

#check @_root_.D1Bound5.smallPairSeeds_12_checked
#check @_root_.D1Bound5.smallPairFilter_12_checked
#check @_root_.D1Bound5.smallPairLarge_12_count
#check @_root_.D1Bound5.PairSelectedPrepared12.leftCached
#check @_root_.D1Bound5.PairSelectedPrepared12.leftRows
#check @_root_.D1Bound5.PairSelectedPrepared12.rightCached
#check @_root_.D1Bound5.PairSelectedPrepared12.rightRows
#check @_root_.D1Bound5.PairLightPrepared12.sieve_eq
#check @_root_.D1Bound5.PairLightPrepared12.leftVertices_eq
#check @_root_.D1Bound5.PairLightPrepared12.leftCached_eq
#check @_root_.D1Bound5.PairLightPrepared12.leftRows_eq
#check @_root_.D1Bound5.PairLightPrepared12.left_checked
#check @_root_.D1Bound5.PairLightPrepared12.rightVertices_eq
#check @_root_.D1Bound5.PairLightPrepared12.rightCached_eq
#check @_root_.D1Bound5.PairLightPrepared12.rightRows_eq
#check @_root_.D1Bound5.PairLightPrepared12.right_checked
#check @_root_.D1Bound5.smallPairNoTriangle_12_checked
