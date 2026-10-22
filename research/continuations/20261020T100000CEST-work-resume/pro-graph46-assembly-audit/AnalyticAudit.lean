import D1Bound5.SmallPairGraphArithmetic46
import D1Bound5.SmallPairRawSelectedData46LeftCached
import D1Bound5.SmallPairRawSelectedData46LeftRows
import D1Bound5.SmallPairRawSelectedData46RightCached
import D1Bound5.SmallPairRawSelectedData46RightRows
import D1Bound5.SmallPairRawSelectedData46
import D1Bound5.SmallPairLightAssembly46
import D1Bound5.SmallPairGraphTriangle46
import D1Bound5.SmallPairGraphData46
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.smallPairSeeds_46_checked,
    `D1Bound5.smallPairFilter_46_checked,
    `D1Bound5.smallPairLarge_46_count,
    `D1Bound5.PairSelectedPrepared46.leftCached,
    `D1Bound5.PairSelectedPrepared46.leftRows,
    `D1Bound5.PairSelectedPrepared46.rightCached,
    `D1Bound5.PairSelectedPrepared46.rightRows,
    `D1Bound5.PairLightPrepared46.sieve_eq,
    `D1Bound5.PairLightPrepared46.leftVertices_eq,
    `D1Bound5.PairLightPrepared46.leftCached_eq,
    `D1Bound5.PairLightPrepared46.leftRows_eq,
    `D1Bound5.PairLightPrepared46.left_checked,
    `D1Bound5.PairLightPrepared46.rightVertices_eq,
    `D1Bound5.PairLightPrepared46.rightCached_eq,
    `D1Bound5.PairLightPrepared46.rightRows_eq,
    `D1Bound5.PairLightPrepared46.right_checked,
    `D1Bound5.smallPairNoTriangle_46_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH46_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5

example
:
    pairSeedsCoveredBool smallPairA_46 smallPairB_46
      seedRootDisk_1_6 smallPairClosure_46 = true :=
  _root_.D1Bound5.smallPairSeeds_46_checked
end D1Bound5

namespace D1Bound5

example
:
    largePairVertices smallPairA_46 smallPairB_46 smallPairClosure_46 = smallPairLarge_46 :=
  _root_.D1Bound5.smallPairFilter_46_checked
end D1Bound5

namespace D1Bound5

example
: smallPairLarge_46.length = 718 :=
  _root_.D1Bound5.smallPairLarge_46_count
end D1Bound5

namespace D1Bound5.PairSelectedPrepared46

example
: List (PairResidueVertex 1 6) :=
  _root_.D1Bound5.PairSelectedPrepared46.leftCached
end D1Bound5.PairSelectedPrepared46

namespace D1Bound5.PairSelectedPrepared46

example
: List (ℕ × List ℕ) :=
  _root_.D1Bound5.PairSelectedPrepared46.leftRows
end D1Bound5.PairSelectedPrepared46

namespace D1Bound5.PairSelectedPrepared46

example
: List (PairResidueVertex 1 6) :=
  _root_.D1Bound5.PairSelectedPrepared46.rightCached
end D1Bound5.PairSelectedPrepared46

namespace D1Bound5.PairSelectedPrepared46

example
: List (ℕ × List ℕ) :=
  _root_.D1Bound5.PairSelectedPrepared46.rightRows
end D1Bound5.PairSelectedPrepared46

namespace D1Bound5.PairLightPrepared46

example
: sieve = smallPairSieve_1_6 :=
  _root_.D1Bound5.PairLightPrepared46.sieve_eq
end D1Bound5.PairLightPrepared46

namespace D1Bound5.PairLightPrepared46

example
:
    leftVertices = (pairSplitByMask smallPairLarge_46 PairGraphPrepared46.colors).1.map pairLightCoordinates :=
  _root_.D1Bound5.PairLightPrepared46.leftVertices_eq
end D1Bound5.PairLightPrepared46

namespace D1Bound5.PairLightPrepared46

example
:
    leftCached = PairSelectedPrepared46.leftCached.map pairLightCachedCoordinates :=
  _root_.D1Bound5.PairLightPrepared46.leftCached_eq
end D1Bound5.PairLightPrepared46

namespace D1Bound5.PairLightPrepared46

example
: leftRows = PairSelectedPrepared46.leftRows :=
  _root_.D1Bound5.PairLightPrepared46.leftRows_eq
end D1Bound5.PairLightPrepared46

namespace D1Bound5.PairLightPrepared46

example
:
    pairIndependentBool smallPairSieve_1_6 (pairSplitByMask smallPairLarge_46 PairGraphPrepared46.colors).1 = true :=
  _root_.D1Bound5.PairLightPrepared46.left_checked
end D1Bound5.PairLightPrepared46

namespace D1Bound5.PairLightPrepared46

example
:
    rightVertices = (pairSplitByMask smallPairLarge_46 PairGraphPrepared46.colors).2.map pairLightCoordinates :=
  _root_.D1Bound5.PairLightPrepared46.rightVertices_eq
end D1Bound5.PairLightPrepared46

namespace D1Bound5.PairLightPrepared46

example
:
    rightCached = PairSelectedPrepared46.rightCached.map pairLightCachedCoordinates :=
  _root_.D1Bound5.PairLightPrepared46.rightCached_eq
end D1Bound5.PairLightPrepared46

namespace D1Bound5.PairLightPrepared46

example
: rightRows = PairSelectedPrepared46.rightRows :=
  _root_.D1Bound5.PairLightPrepared46.rightRows_eq
end D1Bound5.PairLightPrepared46

namespace D1Bound5.PairLightPrepared46

example
:
    pairIndependentBool smallPairSieve_1_6 (pairSplitByMask smallPairLarge_46 PairGraphPrepared46.colors).2 = true :=
  _root_.D1Bound5.PairLightPrepared46.right_checked
end D1Bound5.PairLightPrepared46

namespace D1Bound5

example
:
    pairGraphTriangleFreeBool smallPairSieve_1_6 smallPairLarge_46 = true :=
  _root_.D1Bound5.smallPairNoTriangle_46_checked
end D1Bound5

#check @_root_.D1Bound5.smallPairSeeds_46_checked
#check @_root_.D1Bound5.smallPairFilter_46_checked
#check @_root_.D1Bound5.smallPairLarge_46_count
#check @_root_.D1Bound5.PairSelectedPrepared46.leftCached
#check @_root_.D1Bound5.PairSelectedPrepared46.leftRows
#check @_root_.D1Bound5.PairSelectedPrepared46.rightCached
#check @_root_.D1Bound5.PairSelectedPrepared46.rightRows
#check @_root_.D1Bound5.PairLightPrepared46.sieve_eq
#check @_root_.D1Bound5.PairLightPrepared46.leftVertices_eq
#check @_root_.D1Bound5.PairLightPrepared46.leftCached_eq
#check @_root_.D1Bound5.PairLightPrepared46.leftRows_eq
#check @_root_.D1Bound5.PairLightPrepared46.left_checked
#check @_root_.D1Bound5.PairLightPrepared46.rightVertices_eq
#check @_root_.D1Bound5.PairLightPrepared46.rightCached_eq
#check @_root_.D1Bound5.PairLightPrepared46.rightRows_eq
#check @_root_.D1Bound5.PairLightPrepared46.right_checked
#check @_root_.D1Bound5.smallPairNoTriangle_46_checked
