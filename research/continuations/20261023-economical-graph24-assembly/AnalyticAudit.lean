import D1Bound5.SmallPairGraphArithmetic24
import D1Bound5.SmallPairRawSelectedData24LeftCached
import D1Bound5.SmallPairRawSelectedData24LeftRows
import D1Bound5.SmallPairRawSelectedData24RightCached
import D1Bound5.SmallPairRawSelectedData24RightRows
import D1Bound5.SmallPairRawSelectedData24
import D1Bound5.SmallPairLightAssembly24
import D1Bound5.SmallPairGraphTriangle24
import D1Bound5.SmallPairGraphData24
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5

example :
    pairSeedsCoveredBool smallPairA_24 smallPairB_24
      seedRootDisk_1_1 smallPairClosure_24 = true := smallPairSeeds_24_checked
end D1Bound5
namespace D1Bound5

example :
    largePairVertices smallPairA_24 smallPairB_24 smallPairClosure_24 = smallPairLarge_24 := smallPairFilter_24_checked
end D1Bound5
namespace D1Bound5

example : smallPairLarge_24.length = 892 := smallPairLarge_24_count
end D1Bound5
namespace D1Bound5.PairSelectedPrepared24

example : List (PairResidueVertex 1 1) := leftCached
end D1Bound5.PairSelectedPrepared24
namespace D1Bound5.PairSelectedPrepared24

example : List (ℕ × List ℕ) := leftRows
end D1Bound5.PairSelectedPrepared24
namespace D1Bound5.PairSelectedPrepared24

example : List (PairResidueVertex 1 1) := rightCached
end D1Bound5.PairSelectedPrepared24
namespace D1Bound5.PairSelectedPrepared24

example : List (ℕ × List ℕ) := rightRows
end D1Bound5.PairSelectedPrepared24
namespace D1Bound5.PairLightPrepared24

example : sieve = smallPairSieve_1_1 := sieve_eq
end D1Bound5.PairLightPrepared24
namespace D1Bound5.PairLightPrepared24

example :
    leftVertices = (pairSplitByMask smallPairLarge_24 PairGraphPrepared24.colors).1.map pairLightCoordinates := leftVertices_eq
end D1Bound5.PairLightPrepared24
namespace D1Bound5.PairLightPrepared24

example :
    leftCached = PairSelectedPrepared24.leftCached.map pairLightCachedCoordinates := leftCached_eq
end D1Bound5.PairLightPrepared24
namespace D1Bound5.PairLightPrepared24

example : leftRows = PairSelectedPrepared24.leftRows := leftRows_eq
end D1Bound5.PairLightPrepared24
namespace D1Bound5.PairLightPrepared24

example :
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_24 PairGraphPrepared24.colors).1 = true := left_checked
end D1Bound5.PairLightPrepared24
namespace D1Bound5.PairLightPrepared24

example :
    rightVertices = (pairSplitByMask smallPairLarge_24 PairGraphPrepared24.colors).2.map pairLightCoordinates := rightVertices_eq
end D1Bound5.PairLightPrepared24
namespace D1Bound5.PairLightPrepared24

example :
    rightCached = PairSelectedPrepared24.rightCached.map pairLightCachedCoordinates := rightCached_eq
end D1Bound5.PairLightPrepared24
namespace D1Bound5.PairLightPrepared24

example : rightRows = PairSelectedPrepared24.rightRows := rightRows_eq
end D1Bound5.PairLightPrepared24
namespace D1Bound5.PairLightPrepared24

example :
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_24 PairGraphPrepared24.colors).2 = true := right_checked
end D1Bound5.PairLightPrepared24
namespace D1Bound5

example :
    pairGraphTriangleFreeBool smallPairSieve_1_1 smallPairLarge_24 = true := smallPairNoTriangle_24_checked
end D1Bound5
run_cmd do
  for name in ([`D1Bound5.smallPairSeeds_24_checked, `D1Bound5.smallPairFilter_24_checked, `D1Bound5.smallPairLarge_24_count, `D1Bound5.PairSelectedPrepared24.leftCached, `D1Bound5.PairSelectedPrepared24.leftRows, `D1Bound5.PairSelectedPrepared24.rightCached, `D1Bound5.PairSelectedPrepared24.rightRows, `D1Bound5.PairLightPrepared24.sieve_eq, `D1Bound5.PairLightPrepared24.leftVertices_eq, `D1Bound5.PairLightPrepared24.leftCached_eq, `D1Bound5.PairLightPrepared24.leftRows_eq, `D1Bound5.PairLightPrepared24.left_checked, `D1Bound5.PairLightPrepared24.rightVertices_eq, `D1Bound5.PairLightPrepared24.rightCached_eq, `D1Bound5.PairLightPrepared24.rightRows_eq, `D1Bound5.PairLightPrepared24.right_checked, `D1Bound5.smallPairNoTriangle_24_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
