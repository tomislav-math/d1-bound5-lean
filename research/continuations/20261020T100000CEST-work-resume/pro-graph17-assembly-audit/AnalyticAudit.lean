import D1Bound5.SmallPairGraphArithmetic17
import D1Bound5.SmallPairRawSelectedData17
import D1Bound5.SmallPairLightAssembly17
import D1Bound5.SmallPairGraphTriangle17
import D1Bound5.SmallPairGraphData17
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.smallPairSeeds_17_checked,
    `D1Bound5.smallPairFilter_17_checked,
    `D1Bound5.smallPairLarge_17_count,
    `D1Bound5.PairSelectedPrepared17.leftCached,
    `D1Bound5.PairSelectedPrepared17.leftRows,
    `D1Bound5.PairSelectedPrepared17.rightCached,
    `D1Bound5.PairSelectedPrepared17.rightRows,
    `D1Bound5.PairLightPrepared17.sieve_eq,
    `D1Bound5.PairLightPrepared17.leftVertices_eq,
    `D1Bound5.PairLightPrepared17.leftCached_eq,
    `D1Bound5.PairLightPrepared17.leftRows_eq,
    `D1Bound5.PairLightPrepared17.left_checked,
    `D1Bound5.PairLightPrepared17.rightVertices_eq,
    `D1Bound5.PairLightPrepared17.rightCached_eq,
    `D1Bound5.PairLightPrepared17.rightRows_eq,
    `D1Bound5.PairLightPrepared17.right_checked,
    `D1Bound5.smallPairNoTriangle_17_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH17_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5

example
:
    pairSeedsCoveredBool smallPairA_17 smallPairB_17
      seedRootDisk_0_2 smallPairClosure_17 = true :=
  _root_.D1Bound5.smallPairSeeds_17_checked
end D1Bound5

namespace D1Bound5

example
:
    largePairVertices smallPairA_17 smallPairB_17 smallPairClosure_17 = smallPairLarge_17 :=
  _root_.D1Bound5.smallPairFilter_17_checked
end D1Bound5

namespace D1Bound5

example
: smallPairLarge_17.length = 718 :=
  _root_.D1Bound5.smallPairLarge_17_count
end D1Bound5

namespace D1Bound5.PairSelectedPrepared17

example
: List (PairResidueVertex 0 2) :=
  _root_.D1Bound5.PairSelectedPrepared17.leftCached
end D1Bound5.PairSelectedPrepared17

namespace D1Bound5.PairSelectedPrepared17

example
: List (ℕ × List ℕ) :=
  _root_.D1Bound5.PairSelectedPrepared17.leftRows
end D1Bound5.PairSelectedPrepared17

namespace D1Bound5.PairSelectedPrepared17

example
: List (PairResidueVertex 0 2) :=
  _root_.D1Bound5.PairSelectedPrepared17.rightCached
end D1Bound5.PairSelectedPrepared17

namespace D1Bound5.PairSelectedPrepared17

example
: List (ℕ × List ℕ) :=
  _root_.D1Bound5.PairSelectedPrepared17.rightRows
end D1Bound5.PairSelectedPrepared17

namespace D1Bound5.PairLightPrepared17

example
: sieve = smallPairSieve_0_2 :=
  _root_.D1Bound5.PairLightPrepared17.sieve_eq
end D1Bound5.PairLightPrepared17

namespace D1Bound5.PairLightPrepared17

example
:
    leftVertices = (pairSplitByMask smallPairLarge_17 PairGraphPrepared17.colors).1.map pairLightCoordinates :=
  _root_.D1Bound5.PairLightPrepared17.leftVertices_eq
end D1Bound5.PairLightPrepared17

namespace D1Bound5.PairLightPrepared17

example
:
    leftCached = PairSelectedPrepared17.leftCached.map pairLightCachedCoordinates :=
  _root_.D1Bound5.PairLightPrepared17.leftCached_eq
end D1Bound5.PairLightPrepared17

namespace D1Bound5.PairLightPrepared17

example
: leftRows = PairSelectedPrepared17.leftRows :=
  _root_.D1Bound5.PairLightPrepared17.leftRows_eq
end D1Bound5.PairLightPrepared17

namespace D1Bound5.PairLightPrepared17

example
:
    pairIndependentBool smallPairSieve_0_2 (pairSplitByMask smallPairLarge_17 PairGraphPrepared17.colors).1 = true :=
  _root_.D1Bound5.PairLightPrepared17.left_checked
end D1Bound5.PairLightPrepared17

namespace D1Bound5.PairLightPrepared17

example
:
    rightVertices = (pairSplitByMask smallPairLarge_17 PairGraphPrepared17.colors).2.map pairLightCoordinates :=
  _root_.D1Bound5.PairLightPrepared17.rightVertices_eq
end D1Bound5.PairLightPrepared17

namespace D1Bound5.PairLightPrepared17

example
:
    rightCached = PairSelectedPrepared17.rightCached.map pairLightCachedCoordinates :=
  _root_.D1Bound5.PairLightPrepared17.rightCached_eq
end D1Bound5.PairLightPrepared17

namespace D1Bound5.PairLightPrepared17

example
: rightRows = PairSelectedPrepared17.rightRows :=
  _root_.D1Bound5.PairLightPrepared17.rightRows_eq
end D1Bound5.PairLightPrepared17

namespace D1Bound5.PairLightPrepared17

example
:
    pairIndependentBool smallPairSieve_0_2 (pairSplitByMask smallPairLarge_17 PairGraphPrepared17.colors).2 = true :=
  _root_.D1Bound5.PairLightPrepared17.right_checked
end D1Bound5.PairLightPrepared17

namespace D1Bound5

example
:
    pairGraphTriangleFreeBool smallPairSieve_0_2 smallPairLarge_17 = true :=
  _root_.D1Bound5.smallPairNoTriangle_17_checked
end D1Bound5

#check @_root_.D1Bound5.smallPairSeeds_17_checked
#check @_root_.D1Bound5.smallPairFilter_17_checked
#check @_root_.D1Bound5.smallPairLarge_17_count
#check @_root_.D1Bound5.PairSelectedPrepared17.leftCached
#check @_root_.D1Bound5.PairSelectedPrepared17.leftRows
#check @_root_.D1Bound5.PairSelectedPrepared17.rightCached
#check @_root_.D1Bound5.PairSelectedPrepared17.rightRows
#check @_root_.D1Bound5.PairLightPrepared17.sieve_eq
#check @_root_.D1Bound5.PairLightPrepared17.leftVertices_eq
#check @_root_.D1Bound5.PairLightPrepared17.leftCached_eq
#check @_root_.D1Bound5.PairLightPrepared17.leftRows_eq
#check @_root_.D1Bound5.PairLightPrepared17.left_checked
#check @_root_.D1Bound5.PairLightPrepared17.rightVertices_eq
#check @_root_.D1Bound5.PairLightPrepared17.rightCached_eq
#check @_root_.D1Bound5.PairLightPrepared17.rightRows_eq
#check @_root_.D1Bound5.PairLightPrepared17.right_checked
#check @_root_.D1Bound5.smallPairNoTriangle_17_checked
