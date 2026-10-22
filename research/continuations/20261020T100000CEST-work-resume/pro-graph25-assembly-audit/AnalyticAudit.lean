import D1Bound5.SmallPairGraphArithmetic25
import D1Bound5.SmallPairRawSelectedData25
import D1Bound5.SmallPairLightAssembly25
import D1Bound5.SmallPairGraphTriangle25
import D1Bound5.SmallPairGraphData25
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.smallPairSeeds_25_checked,
    `D1Bound5.smallPairFilter_25_checked,
    `D1Bound5.smallPairLarge_25_count,
    `D1Bound5.PairSelectedPrepared25.leftCached,
    `D1Bound5.PairSelectedPrepared25.leftRows,
    `D1Bound5.PairSelectedPrepared25.rightCached,
    `D1Bound5.PairSelectedPrepared25.rightRows,
    `D1Bound5.PairLightPrepared25.sieve_eq,
    `D1Bound5.PairLightPrepared25.leftVertices_eq,
    `D1Bound5.PairLightPrepared25.leftCached_eq,
    `D1Bound5.PairLightPrepared25.leftRows_eq,
    `D1Bound5.PairLightPrepared25.left_checked,
    `D1Bound5.PairLightPrepared25.rightVertices_eq,
    `D1Bound5.PairLightPrepared25.rightCached_eq,
    `D1Bound5.PairLightPrepared25.rightRows_eq,
    `D1Bound5.PairLightPrepared25.right_checked,
    `D1Bound5.smallPairNoTriangle_25_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH25_CLOSURE_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5

example
:
    pairSeedsCoveredBool smallPairA_25 smallPairB_25
      seedRootDisk_1_1 smallPairClosure_25 = true :=
  _root_.D1Bound5.smallPairSeeds_25_checked
end D1Bound5

namespace D1Bound5

example
:
    largePairVertices smallPairA_25 smallPairB_25 smallPairClosure_25 = smallPairLarge_25 :=
  _root_.D1Bound5.smallPairFilter_25_checked
end D1Bound5

namespace D1Bound5

example
: smallPairLarge_25.length = 761 :=
  _root_.D1Bound5.smallPairLarge_25_count
end D1Bound5

namespace D1Bound5.PairSelectedPrepared25

example
: List (PairResidueVertex 1 1) :=
  _root_.D1Bound5.PairSelectedPrepared25.leftCached
end D1Bound5.PairSelectedPrepared25

namespace D1Bound5.PairSelectedPrepared25

example
: List (ℕ × List ℕ) :=
  _root_.D1Bound5.PairSelectedPrepared25.leftRows
end D1Bound5.PairSelectedPrepared25

namespace D1Bound5.PairSelectedPrepared25

example
: List (PairResidueVertex 1 1) :=
  _root_.D1Bound5.PairSelectedPrepared25.rightCached
end D1Bound5.PairSelectedPrepared25

namespace D1Bound5.PairSelectedPrepared25

example
: List (ℕ × List ℕ) :=
  _root_.D1Bound5.PairSelectedPrepared25.rightRows
end D1Bound5.PairSelectedPrepared25

namespace D1Bound5.PairLightPrepared25

example
: sieve = smallPairSieve_1_1 :=
  _root_.D1Bound5.PairLightPrepared25.sieve_eq
end D1Bound5.PairLightPrepared25

namespace D1Bound5.PairLightPrepared25

example
:
    leftVertices = (pairSplitByMask smallPairLarge_25 PairGraphPrepared25.colors).1.map pairLightCoordinates :=
  _root_.D1Bound5.PairLightPrepared25.leftVertices_eq
end D1Bound5.PairLightPrepared25

namespace D1Bound5.PairLightPrepared25

example
:
    leftCached = PairSelectedPrepared25.leftCached.map pairLightCachedCoordinates :=
  _root_.D1Bound5.PairLightPrepared25.leftCached_eq
end D1Bound5.PairLightPrepared25

namespace D1Bound5.PairLightPrepared25

example
: leftRows = PairSelectedPrepared25.leftRows :=
  _root_.D1Bound5.PairLightPrepared25.leftRows_eq
end D1Bound5.PairLightPrepared25

namespace D1Bound5.PairLightPrepared25

example
:
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_25 PairGraphPrepared25.colors).1 = true :=
  _root_.D1Bound5.PairLightPrepared25.left_checked
end D1Bound5.PairLightPrepared25

namespace D1Bound5.PairLightPrepared25

example
:
    rightVertices = (pairSplitByMask smallPairLarge_25 PairGraphPrepared25.colors).2.map pairLightCoordinates :=
  _root_.D1Bound5.PairLightPrepared25.rightVertices_eq
end D1Bound5.PairLightPrepared25

namespace D1Bound5.PairLightPrepared25

example
:
    rightCached = PairSelectedPrepared25.rightCached.map pairLightCachedCoordinates :=
  _root_.D1Bound5.PairLightPrepared25.rightCached_eq
end D1Bound5.PairLightPrepared25

namespace D1Bound5.PairLightPrepared25

example
: rightRows = PairSelectedPrepared25.rightRows :=
  _root_.D1Bound5.PairLightPrepared25.rightRows_eq
end D1Bound5.PairLightPrepared25

namespace D1Bound5.PairLightPrepared25

example
:
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_25 PairGraphPrepared25.colors).2 = true :=
  _root_.D1Bound5.PairLightPrepared25.right_checked
end D1Bound5.PairLightPrepared25

namespace D1Bound5

example
:
    pairGraphTriangleFreeBool smallPairSieve_1_1 smallPairLarge_25 = true :=
  _root_.D1Bound5.smallPairNoTriangle_25_checked
end D1Bound5

#check @_root_.D1Bound5.smallPairSeeds_25_checked
#check @_root_.D1Bound5.smallPairFilter_25_checked
#check @_root_.D1Bound5.smallPairLarge_25_count
#check @_root_.D1Bound5.PairSelectedPrepared25.leftCached
#check @_root_.D1Bound5.PairSelectedPrepared25.leftRows
#check @_root_.D1Bound5.PairSelectedPrepared25.rightCached
#check @_root_.D1Bound5.PairSelectedPrepared25.rightRows
#check @_root_.D1Bound5.PairLightPrepared25.sieve_eq
#check @_root_.D1Bound5.PairLightPrepared25.leftVertices_eq
#check @_root_.D1Bound5.PairLightPrepared25.leftCached_eq
#check @_root_.D1Bound5.PairLightPrepared25.leftRows_eq
#check @_root_.D1Bound5.PairLightPrepared25.left_checked
#check @_root_.D1Bound5.PairLightPrepared25.rightVertices_eq
#check @_root_.D1Bound5.PairLightPrepared25.rightCached_eq
#check @_root_.D1Bound5.PairLightPrepared25.rightRows_eq
#check @_root_.D1Bound5.PairLightPrepared25.right_checked
#check @_root_.D1Bound5.smallPairNoTriangle_25_checked
