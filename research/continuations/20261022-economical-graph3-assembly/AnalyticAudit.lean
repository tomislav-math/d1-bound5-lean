import D1Bound5.SmallPairGraphArithmetic3
import D1Bound5.SmallPairRawSelectedData3LeftCached
import D1Bound5.SmallPairRawSelectedData3LeftRows
import D1Bound5.SmallPairRawSelectedData3RightCached
import D1Bound5.SmallPairRawSelectedData3RightRows
import D1Bound5.SmallPairRawSelectedData3
import D1Bound5.SmallPairLightAssembly3
import D1Bound5.SmallPairGraphTriangle3
import D1Bound5.SmallPairGraphData3
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5

example :
    pairSeedsCoveredBool smallPairA_3 smallPairB_3
      seedRootDisk_0_1 smallPairClosure_3 = true := smallPairSeeds_3_checked
end D1Bound5
namespace D1Bound5

example :
    largePairVertices smallPairA_3 smallPairB_3 smallPairClosure_3 = smallPairLarge_3 := smallPairFilter_3_checked
end D1Bound5
namespace D1Bound5

example : smallPairLarge_3.length = 827 := smallPairLarge_3_count
end D1Bound5
namespace D1Bound5.PairSelectedPrepared3

example : List (PairResidueVertex 0 1) := leftCached
end D1Bound5.PairSelectedPrepared3
namespace D1Bound5.PairSelectedPrepared3

example : List (ℕ × List ℕ) := leftRows
end D1Bound5.PairSelectedPrepared3
namespace D1Bound5.PairSelectedPrepared3

example : List (PairResidueVertex 0 1) := rightCached
end D1Bound5.PairSelectedPrepared3
namespace D1Bound5.PairSelectedPrepared3

example : List (ℕ × List ℕ) := rightRows
end D1Bound5.PairSelectedPrepared3
namespace D1Bound5.PairLightPrepared3

example : sieve = smallPairSieve_0_1 := sieve_eq
end D1Bound5.PairLightPrepared3
namespace D1Bound5.PairLightPrepared3

example :
    leftVertices = (pairSplitByMask smallPairLarge_3 PairGraphPrepared3.colors).1.map pairLightCoordinates := leftVertices_eq
end D1Bound5.PairLightPrepared3
namespace D1Bound5.PairLightPrepared3

example :
    leftCached = PairSelectedPrepared3.leftCached.map pairLightCachedCoordinates := leftCached_eq
end D1Bound5.PairLightPrepared3
namespace D1Bound5.PairLightPrepared3

example : leftRows = PairSelectedPrepared3.leftRows := leftRows_eq
end D1Bound5.PairLightPrepared3
namespace D1Bound5.PairLightPrepared3

example :
    pairIndependentBool smallPairSieve_0_1 (pairSplitByMask smallPairLarge_3 PairGraphPrepared3.colors).1 = true := left_checked
end D1Bound5.PairLightPrepared3
namespace D1Bound5.PairLightPrepared3

example :
    rightVertices = (pairSplitByMask smallPairLarge_3 PairGraphPrepared3.colors).2.map pairLightCoordinates := rightVertices_eq
end D1Bound5.PairLightPrepared3
namespace D1Bound5.PairLightPrepared3

example :
    rightCached = PairSelectedPrepared3.rightCached.map pairLightCachedCoordinates := rightCached_eq
end D1Bound5.PairLightPrepared3
namespace D1Bound5.PairLightPrepared3

example : rightRows = PairSelectedPrepared3.rightRows := rightRows_eq
end D1Bound5.PairLightPrepared3
namespace D1Bound5.PairLightPrepared3

example :
    pairIndependentBool smallPairSieve_0_1 (pairSplitByMask smallPairLarge_3 PairGraphPrepared3.colors).2 = true := right_checked
end D1Bound5.PairLightPrepared3
namespace D1Bound5

example :
    pairGraphTriangleFreeBool smallPairSieve_0_1 smallPairLarge_3 = true := smallPairNoTriangle_3_checked
end D1Bound5
run_cmd do
  for name in ([`D1Bound5.smallPairSeeds_3_checked, `D1Bound5.smallPairFilter_3_checked, `D1Bound5.smallPairLarge_3_count, `D1Bound5.PairSelectedPrepared3.leftCached, `D1Bound5.PairSelectedPrepared3.leftRows, `D1Bound5.PairSelectedPrepared3.rightCached, `D1Bound5.PairSelectedPrepared3.rightRows, `D1Bound5.PairLightPrepared3.sieve_eq, `D1Bound5.PairLightPrepared3.leftVertices_eq, `D1Bound5.PairLightPrepared3.leftCached_eq, `D1Bound5.PairLightPrepared3.leftRows_eq, `D1Bound5.PairLightPrepared3.left_checked, `D1Bound5.PairLightPrepared3.rightVertices_eq, `D1Bound5.PairLightPrepared3.rightCached_eq, `D1Bound5.PairLightPrepared3.rightRows_eq, `D1Bound5.PairLightPrepared3.right_checked, `D1Bound5.smallPairNoTriangle_3_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
