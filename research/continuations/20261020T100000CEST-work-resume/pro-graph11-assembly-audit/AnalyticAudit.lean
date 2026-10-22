import D1Bound5.SmallPairGraphArithmetic11
import D1Bound5.SmallPairRawSelectedData11LeftCached
import D1Bound5.SmallPairRawSelectedData11LeftRows
import D1Bound5.SmallPairRawSelectedData11RightCached
import D1Bound5.SmallPairRawSelectedData11RightRows
import D1Bound5.SmallPairRawSelectedData11
import D1Bound5.SmallPairLightAssembly11
import D1Bound5.SmallPairGraphTriangle11
import D1Bound5.SmallPairGraphData11
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.smallPairSeeds_11_checked,
    `D1Bound5.smallPairFilter_11_checked,
    `D1Bound5.smallPairLarge_11_count,
    `D1Bound5.PairSelectedPrepared11.leftCached,
    `D1Bound5.PairSelectedPrepared11.leftRows,
    `D1Bound5.PairSelectedPrepared11.rightCached,
    `D1Bound5.PairSelectedPrepared11.rightRows,
    `D1Bound5.PairLightPrepared11.sieve_eq,
    `D1Bound5.PairLightPrepared11.leftVertices_eq,
    `D1Bound5.PairLightPrepared11.leftCached_eq,
    `D1Bound5.PairLightPrepared11.leftRows_eq,
    `D1Bound5.PairLightPrepared11.left_checked,
    `D1Bound5.PairLightPrepared11.rightVertices_eq,
    `D1Bound5.PairLightPrepared11.rightCached_eq,
    `D1Bound5.PairLightPrepared11.rightRows_eq,
    `D1Bound5.PairLightPrepared11.right_checked,
    `D1Bound5.smallPairNoTriangle_11_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH11_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5

example
:
    pairSeedsCoveredBool smallPairA_11 smallPairB_11
      seedRootDisk_0_1 smallPairClosure_11 = true :=
  _root_.D1Bound5.smallPairSeeds_11_checked
end D1Bound5

namespace D1Bound5

example
:
    largePairVertices smallPairA_11 smallPairB_11 smallPairClosure_11 = smallPairLarge_11 :=
  _root_.D1Bound5.smallPairFilter_11_checked
end D1Bound5

namespace D1Bound5

example
: smallPairLarge_11.length = 718 :=
  _root_.D1Bound5.smallPairLarge_11_count
end D1Bound5

namespace D1Bound5.PairSelectedPrepared11

example
: List (PairResidueVertex 0 1) :=
  _root_.D1Bound5.PairSelectedPrepared11.leftCached
end D1Bound5.PairSelectedPrepared11

namespace D1Bound5.PairSelectedPrepared11

example
: List (ℕ × List ℕ) :=
  _root_.D1Bound5.PairSelectedPrepared11.leftRows
end D1Bound5.PairSelectedPrepared11

namespace D1Bound5.PairSelectedPrepared11

example
: List (PairResidueVertex 0 1) :=
  _root_.D1Bound5.PairSelectedPrepared11.rightCached
end D1Bound5.PairSelectedPrepared11

namespace D1Bound5.PairSelectedPrepared11

example
: List (ℕ × List ℕ) :=
  _root_.D1Bound5.PairSelectedPrepared11.rightRows
end D1Bound5.PairSelectedPrepared11

namespace D1Bound5.PairLightPrepared11

example
: sieve = smallPairSieve_0_1 :=
  _root_.D1Bound5.PairLightPrepared11.sieve_eq
end D1Bound5.PairLightPrepared11

namespace D1Bound5.PairLightPrepared11

example
:
    leftVertices = (pairSplitByMask smallPairLarge_11 PairGraphPrepared11.colors).1.map pairLightCoordinates :=
  _root_.D1Bound5.PairLightPrepared11.leftVertices_eq
end D1Bound5.PairLightPrepared11

namespace D1Bound5.PairLightPrepared11

example
:
    leftCached = PairSelectedPrepared11.leftCached.map pairLightCachedCoordinates :=
  _root_.D1Bound5.PairLightPrepared11.leftCached_eq
end D1Bound5.PairLightPrepared11

namespace D1Bound5.PairLightPrepared11

example
: leftRows = PairSelectedPrepared11.leftRows :=
  _root_.D1Bound5.PairLightPrepared11.leftRows_eq
end D1Bound5.PairLightPrepared11

namespace D1Bound5.PairLightPrepared11

example
:
    pairIndependentBool smallPairSieve_0_1 (pairSplitByMask smallPairLarge_11 PairGraphPrepared11.colors).1 = true :=
  _root_.D1Bound5.PairLightPrepared11.left_checked
end D1Bound5.PairLightPrepared11

namespace D1Bound5.PairLightPrepared11

example
:
    rightVertices = (pairSplitByMask smallPairLarge_11 PairGraphPrepared11.colors).2.map pairLightCoordinates :=
  _root_.D1Bound5.PairLightPrepared11.rightVertices_eq
end D1Bound5.PairLightPrepared11

namespace D1Bound5.PairLightPrepared11

example
:
    rightCached = PairSelectedPrepared11.rightCached.map pairLightCachedCoordinates :=
  _root_.D1Bound5.PairLightPrepared11.rightCached_eq
end D1Bound5.PairLightPrepared11

namespace D1Bound5.PairLightPrepared11

example
: rightRows = PairSelectedPrepared11.rightRows :=
  _root_.D1Bound5.PairLightPrepared11.rightRows_eq
end D1Bound5.PairLightPrepared11

namespace D1Bound5.PairLightPrepared11

example
:
    pairIndependentBool smallPairSieve_0_1 (pairSplitByMask smallPairLarge_11 PairGraphPrepared11.colors).2 = true :=
  _root_.D1Bound5.PairLightPrepared11.right_checked
end D1Bound5.PairLightPrepared11

namespace D1Bound5

example
:
    pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_11 = true :=
  _root_.D1Bound5.smallPairNoTriangle_11_checked
end D1Bound5

#check @_root_.D1Bound5.smallPairSeeds_11_checked
#check @_root_.D1Bound5.smallPairFilter_11_checked
#check @_root_.D1Bound5.smallPairLarge_11_count
#check @_root_.D1Bound5.PairSelectedPrepared11.leftCached
#check @_root_.D1Bound5.PairSelectedPrepared11.leftRows
#check @_root_.D1Bound5.PairSelectedPrepared11.rightCached
#check @_root_.D1Bound5.PairSelectedPrepared11.rightRows
#check @_root_.D1Bound5.PairLightPrepared11.sieve_eq
#check @_root_.D1Bound5.PairLightPrepared11.leftVertices_eq
#check @_root_.D1Bound5.PairLightPrepared11.leftCached_eq
#check @_root_.D1Bound5.PairLightPrepared11.leftRows_eq
#check @_root_.D1Bound5.PairLightPrepared11.left_checked
#check @_root_.D1Bound5.PairLightPrepared11.rightVertices_eq
#check @_root_.D1Bound5.PairLightPrepared11.rightCached_eq
#check @_root_.D1Bound5.PairLightPrepared11.rightRows_eq
#check @_root_.D1Bound5.PairLightPrepared11.right_checked
#check @_root_.D1Bound5.smallPairNoTriangle_11_checked
