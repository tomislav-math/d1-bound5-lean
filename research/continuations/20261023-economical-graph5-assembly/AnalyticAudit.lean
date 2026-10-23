import D1Bound5.SmallPairGraphArithmetic5
import D1Bound5.SmallPairRawSelectedData5LeftCached
import D1Bound5.SmallPairRawSelectedData5LeftRows
import D1Bound5.SmallPairRawSelectedData5RightCached
import D1Bound5.SmallPairRawSelectedData5RightRows
import D1Bound5.SmallPairRawSelectedData5
import D1Bound5.SmallPairLightAssembly5
import D1Bound5.SmallPairGraphTriangle5
import D1Bound5.SmallPairGraphData5
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5

example :
    pairSeedsCoveredBool smallPairA_5 smallPairB_5
      seedRootDisk_0_1 smallPairClosure_5 = true := smallPairSeeds_5_checked
end D1Bound5
namespace D1Bound5

example :
    largePairVertices smallPairA_5 smallPairB_5 smallPairClosure_5 = smallPairLarge_5 := smallPairFilter_5_checked
end D1Bound5
namespace D1Bound5

example : smallPairLarge_5.length = 861 := smallPairLarge_5_count
end D1Bound5
namespace D1Bound5.PairSelectedPrepared5

example : List (PairResidueVertex 0 1) := leftCached
end D1Bound5.PairSelectedPrepared5
namespace D1Bound5.PairSelectedPrepared5

example : List (ℕ × List ℕ) := leftRows
end D1Bound5.PairSelectedPrepared5
namespace D1Bound5.PairSelectedPrepared5

example : List (PairResidueVertex 0 1) := rightCached
end D1Bound5.PairSelectedPrepared5
namespace D1Bound5.PairSelectedPrepared5

example : List (ℕ × List ℕ) := rightRows
end D1Bound5.PairSelectedPrepared5
namespace D1Bound5.PairLightPrepared5

example : sieve = smallPairSieve_0_1 := sieve_eq
end D1Bound5.PairLightPrepared5
namespace D1Bound5.PairLightPrepared5

example :
    leftVertices = (pairSplitByMask smallPairLarge_5 PairGraphPrepared5.colors).1.map pairLightCoordinates := leftVertices_eq
end D1Bound5.PairLightPrepared5
namespace D1Bound5.PairLightPrepared5

example :
    leftCached = PairSelectedPrepared5.leftCached.map pairLightCachedCoordinates := leftCached_eq
end D1Bound5.PairLightPrepared5
namespace D1Bound5.PairLightPrepared5

example : leftRows = PairSelectedPrepared5.leftRows := leftRows_eq
end D1Bound5.PairLightPrepared5
namespace D1Bound5.PairLightPrepared5

example :
    pairIndependentBool smallPairSieve_0_1 (pairSplitByMask smallPairLarge_5 PairGraphPrepared5.colors).1 = true := left_checked
end D1Bound5.PairLightPrepared5
namespace D1Bound5.PairLightPrepared5

example :
    rightVertices = (pairSplitByMask smallPairLarge_5 PairGraphPrepared5.colors).2.map pairLightCoordinates := rightVertices_eq
end D1Bound5.PairLightPrepared5
namespace D1Bound5.PairLightPrepared5

example :
    rightCached = PairSelectedPrepared5.rightCached.map pairLightCachedCoordinates := rightCached_eq
end D1Bound5.PairLightPrepared5
namespace D1Bound5.PairLightPrepared5

example : rightRows = PairSelectedPrepared5.rightRows := rightRows_eq
end D1Bound5.PairLightPrepared5
namespace D1Bound5.PairLightPrepared5

example :
    pairIndependentBool smallPairSieve_0_1 (pairSplitByMask smallPairLarge_5 PairGraphPrepared5.colors).2 = true := right_checked
end D1Bound5.PairLightPrepared5
namespace D1Bound5

example :
    pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_5 = true := smallPairNoTriangle_5_checked
end D1Bound5
run_cmd do
  for name in ([`D1Bound5.smallPairSeeds_5_checked, `D1Bound5.smallPairFilter_5_checked, `D1Bound5.smallPairLarge_5_count, `D1Bound5.PairSelectedPrepared5.leftCached, `D1Bound5.PairSelectedPrepared5.leftRows, `D1Bound5.PairSelectedPrepared5.rightCached, `D1Bound5.PairSelectedPrepared5.rightRows, `D1Bound5.PairLightPrepared5.sieve_eq, `D1Bound5.PairLightPrepared5.leftVertices_eq, `D1Bound5.PairLightPrepared5.leftCached_eq, `D1Bound5.PairLightPrepared5.leftRows_eq, `D1Bound5.PairLightPrepared5.left_checked, `D1Bound5.PairLightPrepared5.rightVertices_eq, `D1Bound5.PairLightPrepared5.rightCached_eq, `D1Bound5.PairLightPrepared5.rightRows_eq, `D1Bound5.PairLightPrepared5.right_checked, `D1Bound5.smallPairNoTriangle_5_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
