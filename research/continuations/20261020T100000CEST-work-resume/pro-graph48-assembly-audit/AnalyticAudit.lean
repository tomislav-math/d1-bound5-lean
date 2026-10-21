import D1Bound5.SmallPairGraphArithmetic48
import D1Bound5.SmallPairRawSelectedData48
import D1Bound5.SmallPairLightAssembly48
import D1Bound5.SmallPairGraphTriangle48
import D1Bound5.SmallPairGraphData48
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.smallPairSeeds_48_checked,
    `D1Bound5.smallPairFilter_48_checked,
    `D1Bound5.smallPairLarge_48_count,
    `D1Bound5.PairSelectedPrepared48.leftCached,
    `D1Bound5.PairSelectedPrepared48.leftRows,
    `D1Bound5.PairSelectedPrepared48.rightCached,
    `D1Bound5.PairSelectedPrepared48.rightRows,
    `D1Bound5.PairLightPrepared48.sieve_eq,
    `D1Bound5.PairLightPrepared48.leftVertices_eq,
    `D1Bound5.PairLightPrepared48.leftCached_eq,
    `D1Bound5.PairLightPrepared48.leftRows_eq,
    `D1Bound5.PairLightPrepared48.left_checked,
    `D1Bound5.PairLightPrepared48.rightVertices_eq,
    `D1Bound5.PairLightPrepared48.rightCached_eq,
    `D1Bound5.PairLightPrepared48.rightRows_eq,
    `D1Bound5.PairLightPrepared48.right_checked,
    `D1Bound5.smallPairNoTriangle_48_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH48_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5

example
:
    pairSeedsCoveredBool smallPairA_48 smallPairB_48
      seedRootDisk_1_8 smallPairClosure_48 = true :=
  _root_.D1Bound5.smallPairSeeds_48_checked
end D1Bound5

namespace D1Bound5

example
:
    largePairVertices smallPairA_48 smallPairB_48 smallPairClosure_48 = smallPairLarge_48 :=
  _root_.D1Bound5.smallPairFilter_48_checked
end D1Bound5

namespace D1Bound5

example
: smallPairLarge_48.length = 718 :=
  _root_.D1Bound5.smallPairLarge_48_count
end D1Bound5

namespace D1Bound5.PairSelectedPrepared48

example
: List (PairResidueVertex 1 8) :=
  _root_.D1Bound5.PairSelectedPrepared48.leftCached
end D1Bound5.PairSelectedPrepared48

namespace D1Bound5.PairSelectedPrepared48

example
: List (ℕ × List ℕ) :=
  _root_.D1Bound5.PairSelectedPrepared48.leftRows
end D1Bound5.PairSelectedPrepared48

namespace D1Bound5.PairSelectedPrepared48

example
: List (PairResidueVertex 1 8) :=
  _root_.D1Bound5.PairSelectedPrepared48.rightCached
end D1Bound5.PairSelectedPrepared48

namespace D1Bound5.PairSelectedPrepared48

example
: List (ℕ × List ℕ) :=
  _root_.D1Bound5.PairSelectedPrepared48.rightRows
end D1Bound5.PairSelectedPrepared48

namespace D1Bound5.PairLightPrepared48

example
: sieve = smallPairSieve_1_8 :=
  _root_.D1Bound5.PairLightPrepared48.sieve_eq
end D1Bound5.PairLightPrepared48

namespace D1Bound5.PairLightPrepared48

example
:
    leftVertices = (pairSplitByMask smallPairLarge_48 PairGraphPrepared48.colors).1.map pairLightCoordinates :=
  _root_.D1Bound5.PairLightPrepared48.leftVertices_eq
end D1Bound5.PairLightPrepared48

namespace D1Bound5.PairLightPrepared48

example
:
    leftCached = PairSelectedPrepared48.leftCached.map pairLightCachedCoordinates :=
  _root_.D1Bound5.PairLightPrepared48.leftCached_eq
end D1Bound5.PairLightPrepared48

namespace D1Bound5.PairLightPrepared48

example
: leftRows = PairSelectedPrepared48.leftRows :=
  _root_.D1Bound5.PairLightPrepared48.leftRows_eq
end D1Bound5.PairLightPrepared48

namespace D1Bound5.PairLightPrepared48

example
:
    pairIndependentBool smallPairSieve_1_8 (pairSplitByMask smallPairLarge_48 PairGraphPrepared48.colors).1 = true :=
  _root_.D1Bound5.PairLightPrepared48.left_checked
end D1Bound5.PairLightPrepared48

namespace D1Bound5.PairLightPrepared48

example
:
    rightVertices = (pairSplitByMask smallPairLarge_48 PairGraphPrepared48.colors).2.map pairLightCoordinates :=
  _root_.D1Bound5.PairLightPrepared48.rightVertices_eq
end D1Bound5.PairLightPrepared48

namespace D1Bound5.PairLightPrepared48

example
:
    rightCached = PairSelectedPrepared48.rightCached.map pairLightCachedCoordinates :=
  _root_.D1Bound5.PairLightPrepared48.rightCached_eq
end D1Bound5.PairLightPrepared48

namespace D1Bound5.PairLightPrepared48

example
: rightRows = PairSelectedPrepared48.rightRows :=
  _root_.D1Bound5.PairLightPrepared48.rightRows_eq
end D1Bound5.PairLightPrepared48

namespace D1Bound5.PairLightPrepared48

example
:
    pairIndependentBool smallPairSieve_1_8 (pairSplitByMask smallPairLarge_48 PairGraphPrepared48.colors).2 = true :=
  _root_.D1Bound5.PairLightPrepared48.right_checked
end D1Bound5.PairLightPrepared48

namespace D1Bound5

example
:
    pairGraphTriangleFreeBool smallPairSieve_1_8 smallPairLarge_48 = true :=
  _root_.D1Bound5.smallPairNoTriangle_48_checked
end D1Bound5

#check @_root_.D1Bound5.smallPairSeeds_48_checked
#check @_root_.D1Bound5.smallPairFilter_48_checked
#check @_root_.D1Bound5.smallPairLarge_48_count
#check @_root_.D1Bound5.PairSelectedPrepared48.leftCached
#check @_root_.D1Bound5.PairSelectedPrepared48.leftRows
#check @_root_.D1Bound5.PairSelectedPrepared48.rightCached
#check @_root_.D1Bound5.PairSelectedPrepared48.rightRows
#check @_root_.D1Bound5.PairLightPrepared48.sieve_eq
#check @_root_.D1Bound5.PairLightPrepared48.leftVertices_eq
#check @_root_.D1Bound5.PairLightPrepared48.leftCached_eq
#check @_root_.D1Bound5.PairLightPrepared48.leftRows_eq
#check @_root_.D1Bound5.PairLightPrepared48.left_checked
#check @_root_.D1Bound5.PairLightPrepared48.rightVertices_eq
#check @_root_.D1Bound5.PairLightPrepared48.rightCached_eq
#check @_root_.D1Bound5.PairLightPrepared48.rightRows_eq
#check @_root_.D1Bound5.PairLightPrepared48.right_checked
#check @_root_.D1Bound5.smallPairNoTriangle_48_checked
