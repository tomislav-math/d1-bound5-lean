import D1Bound5.SmallPairGraphArithmetic29
import D1Bound5.SmallPairRawSelectedData29
import D1Bound5.SmallPairLightAssembly29
import D1Bound5.SmallPairGraphTriangle29
import D1Bound5.SmallPairGraphData29
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.smallPairSeeds_29_checked,
    `D1Bound5.smallPairFilter_29_checked,
    `D1Bound5.smallPairLarge_29_count,
    `D1Bound5.PairSelectedPrepared29.leftCached,
    `D1Bound5.PairSelectedPrepared29.leftRows,
    `D1Bound5.PairSelectedPrepared29.rightCached,
    `D1Bound5.PairSelectedPrepared29.rightRows,
    `D1Bound5.PairLightPrepared29.sieve_eq,
    `D1Bound5.PairLightPrepared29.leftVertices_eq,
    `D1Bound5.PairLightPrepared29.leftCached_eq,
    `D1Bound5.PairLightPrepared29.leftRows_eq,
    `D1Bound5.PairLightPrepared29.left_checked,
    `D1Bound5.PairLightPrepared29.rightVertices_eq,
    `D1Bound5.PairLightPrepared29.rightCached_eq,
    `D1Bound5.PairLightPrepared29.rightRows_eq,
    `D1Bound5.PairLightPrepared29.right_checked,
    `D1Bound5.smallPairNoTriangle_29_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH29_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5

example
:
    pairSeedsCoveredBool smallPairA_29 smallPairB_29
      seedRootDisk_1_1 smallPairClosure_29 = true :=
  _root_.D1Bound5.smallPairSeeds_29_checked
end D1Bound5

namespace D1Bound5

example
:
    largePairVertices smallPairA_29 smallPairB_29 smallPairClosure_29 = smallPairLarge_29 :=
  _root_.D1Bound5.smallPairFilter_29_checked
end D1Bound5

namespace D1Bound5

example
: smallPairLarge_29.length = 761 :=
  _root_.D1Bound5.smallPairLarge_29_count
end D1Bound5

namespace D1Bound5.PairSelectedPrepared29

example
: List (PairResidueVertex 1 1) :=
  _root_.D1Bound5.PairSelectedPrepared29.leftCached
end D1Bound5.PairSelectedPrepared29

namespace D1Bound5.PairSelectedPrepared29

example
: List (ℕ × List ℕ) :=
  _root_.D1Bound5.PairSelectedPrepared29.leftRows
end D1Bound5.PairSelectedPrepared29

namespace D1Bound5.PairSelectedPrepared29

example
: List (PairResidueVertex 1 1) :=
  _root_.D1Bound5.PairSelectedPrepared29.rightCached
end D1Bound5.PairSelectedPrepared29

namespace D1Bound5.PairSelectedPrepared29

example
: List (ℕ × List ℕ) :=
  _root_.D1Bound5.PairSelectedPrepared29.rightRows
end D1Bound5.PairSelectedPrepared29

namespace D1Bound5.PairLightPrepared29

example
: sieve = smallPairSieve_1_1 :=
  _root_.D1Bound5.PairLightPrepared29.sieve_eq
end D1Bound5.PairLightPrepared29

namespace D1Bound5.PairLightPrepared29

example
:
    leftVertices = (pairSplitByMask smallPairLarge_29 PairGraphPrepared29.colors).1.map pairLightCoordinates :=
  _root_.D1Bound5.PairLightPrepared29.leftVertices_eq
end D1Bound5.PairLightPrepared29

namespace D1Bound5.PairLightPrepared29

example
:
    leftCached = PairSelectedPrepared29.leftCached.map pairLightCachedCoordinates :=
  _root_.D1Bound5.PairLightPrepared29.leftCached_eq
end D1Bound5.PairLightPrepared29

namespace D1Bound5.PairLightPrepared29

example
: leftRows = PairSelectedPrepared29.leftRows :=
  _root_.D1Bound5.PairLightPrepared29.leftRows_eq
end D1Bound5.PairLightPrepared29

namespace D1Bound5.PairLightPrepared29

example
:
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_29 PairGraphPrepared29.colors).1 = true :=
  _root_.D1Bound5.PairLightPrepared29.left_checked
end D1Bound5.PairLightPrepared29

namespace D1Bound5.PairLightPrepared29

example
:
    rightVertices = (pairSplitByMask smallPairLarge_29 PairGraphPrepared29.colors).2.map pairLightCoordinates :=
  _root_.D1Bound5.PairLightPrepared29.rightVertices_eq
end D1Bound5.PairLightPrepared29

namespace D1Bound5.PairLightPrepared29

example
:
    rightCached = PairSelectedPrepared29.rightCached.map pairLightCachedCoordinates :=
  _root_.D1Bound5.PairLightPrepared29.rightCached_eq
end D1Bound5.PairLightPrepared29

namespace D1Bound5.PairLightPrepared29

example
: rightRows = PairSelectedPrepared29.rightRows :=
  _root_.D1Bound5.PairLightPrepared29.rightRows_eq
end D1Bound5.PairLightPrepared29

namespace D1Bound5.PairLightPrepared29

example
:
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_29 PairGraphPrepared29.colors).2 = true :=
  _root_.D1Bound5.PairLightPrepared29.right_checked
end D1Bound5.PairLightPrepared29

namespace D1Bound5

example
:
    pairGraphTriangleFreeBool smallPairSieve_1_1 smallPairLarge_29 = true :=
  _root_.D1Bound5.smallPairNoTriangle_29_checked
end D1Bound5

#check @_root_.D1Bound5.smallPairSeeds_29_checked
#check @_root_.D1Bound5.smallPairFilter_29_checked
#check @_root_.D1Bound5.smallPairLarge_29_count
#check @_root_.D1Bound5.PairSelectedPrepared29.leftCached
#check @_root_.D1Bound5.PairSelectedPrepared29.leftRows
#check @_root_.D1Bound5.PairSelectedPrepared29.rightCached
#check @_root_.D1Bound5.PairSelectedPrepared29.rightRows
#check @_root_.D1Bound5.PairLightPrepared29.sieve_eq
#check @_root_.D1Bound5.PairLightPrepared29.leftVertices_eq
#check @_root_.D1Bound5.PairLightPrepared29.leftCached_eq
#check @_root_.D1Bound5.PairLightPrepared29.leftRows_eq
#check @_root_.D1Bound5.PairLightPrepared29.left_checked
#check @_root_.D1Bound5.PairLightPrepared29.rightVertices_eq
#check @_root_.D1Bound5.PairLightPrepared29.rightCached_eq
#check @_root_.D1Bound5.PairLightPrepared29.rightRows_eq
#check @_root_.D1Bound5.PairLightPrepared29.right_checked
#check @_root_.D1Bound5.smallPairNoTriangle_29_checked
