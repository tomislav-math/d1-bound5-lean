import D1Bound5.SmallPairGraphArithmetic7
import D1Bound5.SmallPairRawSelectedData7LeftCached
import D1Bound5.SmallPairRawSelectedData7LeftRows
import D1Bound5.SmallPairRawSelectedData7RightCached
import D1Bound5.SmallPairRawSelectedData7RightRows
import D1Bound5.SmallPairRawSelectedData7
import D1Bound5.SmallPairLightAssembly7
import D1Bound5.SmallPairGraphTriangle7
import D1Bound5.SmallPairGraphData7
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5

example :
    pairSeedsCoveredBool smallPairA_7 smallPairB_7
      seedRootDisk_0_1 smallPairClosure_7 = true := smallPairSeeds_7_checked
end D1Bound5
namespace D1Bound5

example :
    largePairVertices smallPairA_7 smallPairB_7 smallPairClosure_7 = smallPairLarge_7 := smallPairFilter_7_checked
end D1Bound5
namespace D1Bound5

example : smallPairLarge_7.length = 862 := smallPairLarge_7_count
end D1Bound5
namespace D1Bound5.PairSelectedPrepared7

example : List (PairResidueVertex 0 1) := leftCached
end D1Bound5.PairSelectedPrepared7
namespace D1Bound5.PairSelectedPrepared7

example : List (ℕ × List ℕ) := leftRows
end D1Bound5.PairSelectedPrepared7
namespace D1Bound5.PairSelectedPrepared7

example : List (PairResidueVertex 0 1) := rightCached
end D1Bound5.PairSelectedPrepared7
namespace D1Bound5.PairSelectedPrepared7

example : List (ℕ × List ℕ) := rightRows
end D1Bound5.PairSelectedPrepared7
namespace D1Bound5.PairLightPrepared7

example : sieve = smallPairSieve_0_1 := sieve_eq
end D1Bound5.PairLightPrepared7
namespace D1Bound5.PairLightPrepared7

example :
    leftVertices = (pairSplitByMask smallPairLarge_7 PairGraphPrepared7.colors).1.map pairLightCoordinates := leftVertices_eq
end D1Bound5.PairLightPrepared7
namespace D1Bound5.PairLightPrepared7

example :
    leftCached = PairSelectedPrepared7.leftCached.map pairLightCachedCoordinates := leftCached_eq
end D1Bound5.PairLightPrepared7
namespace D1Bound5.PairLightPrepared7

example : leftRows = PairSelectedPrepared7.leftRows := leftRows_eq
end D1Bound5.PairLightPrepared7
namespace D1Bound5.PairLightPrepared7

example :
    pairIndependentBool smallPairSieve_0_1 (pairSplitByMask smallPairLarge_7 PairGraphPrepared7.colors).1 = true := left_checked
end D1Bound5.PairLightPrepared7
namespace D1Bound5.PairLightPrepared7

example :
    rightVertices = (pairSplitByMask smallPairLarge_7 PairGraphPrepared7.colors).2.map pairLightCoordinates := rightVertices_eq
end D1Bound5.PairLightPrepared7
namespace D1Bound5.PairLightPrepared7

example :
    rightCached = PairSelectedPrepared7.rightCached.map pairLightCachedCoordinates := rightCached_eq
end D1Bound5.PairLightPrepared7
namespace D1Bound5.PairLightPrepared7

example : rightRows = PairSelectedPrepared7.rightRows := rightRows_eq
end D1Bound5.PairLightPrepared7
namespace D1Bound5.PairLightPrepared7

example :
    pairIndependentBool smallPairSieve_0_1 (pairSplitByMask smallPairLarge_7 PairGraphPrepared7.colors).2 = true := right_checked
end D1Bound5.PairLightPrepared7
namespace D1Bound5

example :
    pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_7 = true := smallPairNoTriangle_7_checked
end D1Bound5
run_cmd do
  for name in ([`D1Bound5.smallPairSeeds_7_checked, `D1Bound5.smallPairFilter_7_checked, `D1Bound5.smallPairLarge_7_count, `D1Bound5.PairSelectedPrepared7.leftCached, `D1Bound5.PairSelectedPrepared7.leftRows, `D1Bound5.PairSelectedPrepared7.rightCached, `D1Bound5.PairSelectedPrepared7.rightRows, `D1Bound5.PairLightPrepared7.sieve_eq, `D1Bound5.PairLightPrepared7.leftVertices_eq, `D1Bound5.PairLightPrepared7.leftCached_eq, `D1Bound5.PairLightPrepared7.leftRows_eq, `D1Bound5.PairLightPrepared7.left_checked, `D1Bound5.PairLightPrepared7.rightVertices_eq, `D1Bound5.PairLightPrepared7.rightCached_eq, `D1Bound5.PairLightPrepared7.rightRows_eq, `D1Bound5.PairLightPrepared7.right_checked, `D1Bound5.smallPairNoTriangle_7_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
