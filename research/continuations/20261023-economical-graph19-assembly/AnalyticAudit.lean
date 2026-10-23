import D1Bound5.SmallPairGraphArithmetic19
import D1Bound5.SmallPairRawSelectedData19LeftCached
import D1Bound5.SmallPairRawSelectedData19LeftRows
import D1Bound5.SmallPairRawSelectedData19RightCached
import D1Bound5.SmallPairRawSelectedData19RightRows
import D1Bound5.SmallPairRawSelectedData19
import D1Bound5.SmallPairLightAssembly19
import D1Bound5.SmallPairGraphTriangle19
import D1Bound5.SmallPairGraphData19
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5

example :
    pairSeedsCoveredBool smallPairA_19 smallPairB_19
      seedRootDisk_1_1 smallPairClosure_19 = true := smallPairSeeds_19_checked
end D1Bound5
namespace D1Bound5

example :
    largePairVertices smallPairA_19 smallPairB_19 smallPairClosure_19 = smallPairLarge_19 := smallPairFilter_19_checked
end D1Bound5
namespace D1Bound5

example : smallPairLarge_19.length = 892 := smallPairLarge_19_count
end D1Bound5
namespace D1Bound5.PairSelectedPrepared19

example : List (PairResidueVertex 1 1) := leftCached
end D1Bound5.PairSelectedPrepared19
namespace D1Bound5.PairSelectedPrepared19

example : List (ℕ × List ℕ) := leftRows
end D1Bound5.PairSelectedPrepared19
namespace D1Bound5.PairSelectedPrepared19

example : List (PairResidueVertex 1 1) := rightCached
end D1Bound5.PairSelectedPrepared19
namespace D1Bound5.PairSelectedPrepared19

example : List (ℕ × List ℕ) := rightRows
end D1Bound5.PairSelectedPrepared19
namespace D1Bound5.PairLightPrepared19

example : sieve = smallPairSieve_1_1 := sieve_eq
end D1Bound5.PairLightPrepared19
namespace D1Bound5.PairLightPrepared19

example :
    leftVertices = (pairSplitByMask smallPairLarge_19 PairGraphPrepared19.colors).1.map pairLightCoordinates := leftVertices_eq
end D1Bound5.PairLightPrepared19
namespace D1Bound5.PairLightPrepared19

example :
    leftCached = PairSelectedPrepared19.leftCached.map pairLightCachedCoordinates := leftCached_eq
end D1Bound5.PairLightPrepared19
namespace D1Bound5.PairLightPrepared19

example : leftRows = PairSelectedPrepared19.leftRows := leftRows_eq
end D1Bound5.PairLightPrepared19
namespace D1Bound5.PairLightPrepared19

example :
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_19 PairGraphPrepared19.colors).1 = true := left_checked
end D1Bound5.PairLightPrepared19
namespace D1Bound5.PairLightPrepared19

example :
    rightVertices = (pairSplitByMask smallPairLarge_19 PairGraphPrepared19.colors).2.map pairLightCoordinates := rightVertices_eq
end D1Bound5.PairLightPrepared19
namespace D1Bound5.PairLightPrepared19

example :
    rightCached = PairSelectedPrepared19.rightCached.map pairLightCachedCoordinates := rightCached_eq
end D1Bound5.PairLightPrepared19
namespace D1Bound5.PairLightPrepared19

example : rightRows = PairSelectedPrepared19.rightRows := rightRows_eq
end D1Bound5.PairLightPrepared19
namespace D1Bound5.PairLightPrepared19

example :
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_19 PairGraphPrepared19.colors).2 = true := right_checked
end D1Bound5.PairLightPrepared19
namespace D1Bound5

example :
    pairGraphTriangleFreeBool smallPairSieve_1_1 smallPairLarge_19 = true := smallPairNoTriangle_19_checked
end D1Bound5
run_cmd do
  for name in ([`D1Bound5.smallPairSeeds_19_checked, `D1Bound5.smallPairFilter_19_checked, `D1Bound5.smallPairLarge_19_count, `D1Bound5.PairSelectedPrepared19.leftCached, `D1Bound5.PairSelectedPrepared19.leftRows, `D1Bound5.PairSelectedPrepared19.rightCached, `D1Bound5.PairSelectedPrepared19.rightRows, `D1Bound5.PairLightPrepared19.sieve_eq, `D1Bound5.PairLightPrepared19.leftVertices_eq, `D1Bound5.PairLightPrepared19.leftCached_eq, `D1Bound5.PairLightPrepared19.leftRows_eq, `D1Bound5.PairLightPrepared19.left_checked, `D1Bound5.PairLightPrepared19.rightVertices_eq, `D1Bound5.PairLightPrepared19.rightCached_eq, `D1Bound5.PairLightPrepared19.rightRows_eq, `D1Bound5.PairLightPrepared19.right_checked, `D1Bound5.smallPairNoTriangle_19_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
