import D1Bound5.SmallPairGraphArithmetic43
import D1Bound5.SmallPairRawSelectedData43LeftCached
import D1Bound5.SmallPairRawSelectedData43LeftRows
import D1Bound5.SmallPairRawSelectedData43RightCached
import D1Bound5.SmallPairRawSelectedData43RightRows
import D1Bound5.SmallPairRawSelectedData43
import D1Bound5.SmallPairLightAssembly43
import D1Bound5.SmallPairGraphTriangle43
import D1Bound5.SmallPairGraphData43
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5

example :
    pairSeedsCoveredBool smallPairA_43 smallPairB_43
      seedRootDisk_1_3 smallPairClosure_43 = true := smallPairSeeds_43_checked
end D1Bound5
namespace D1Bound5

example :
    largePairVertices smallPairA_43 smallPairB_43 smallPairClosure_43 = smallPairLarge_43 := smallPairFilter_43_checked
end D1Bound5
namespace D1Bound5

example : smallPairLarge_43.length = 962 := smallPairLarge_43_count
end D1Bound5
namespace D1Bound5.PairSelectedPrepared43

example : List (PairResidueVertex 1 3) := leftCached
end D1Bound5.PairSelectedPrepared43
namespace D1Bound5.PairSelectedPrepared43

example : List (ℕ × List ℕ) := leftRows
end D1Bound5.PairSelectedPrepared43
namespace D1Bound5.PairSelectedPrepared43

example : List (PairResidueVertex 1 3) := rightCached
end D1Bound5.PairSelectedPrepared43
namespace D1Bound5.PairSelectedPrepared43

example : List (ℕ × List ℕ) := rightRows
end D1Bound5.PairSelectedPrepared43
namespace D1Bound5.PairLightPrepared43

example : sieve = smallPairSieve_1_3 := sieve_eq
end D1Bound5.PairLightPrepared43
namespace D1Bound5.PairLightPrepared43

example :
    leftVertices = (pairSplitByMask smallPairLarge_43 PairGraphPrepared43.colors).1.map pairLightCoordinates := leftVertices_eq
end D1Bound5.PairLightPrepared43
namespace D1Bound5.PairLightPrepared43

example :
    leftCached = PairSelectedPrepared43.leftCached.map pairLightCachedCoordinates := leftCached_eq
end D1Bound5.PairLightPrepared43
namespace D1Bound5.PairLightPrepared43

example : leftRows = PairSelectedPrepared43.leftRows := leftRows_eq
end D1Bound5.PairLightPrepared43
namespace D1Bound5.PairLightPrepared43

example :
    pairIndependentBool smallPairSieve_1_3 (pairSplitByMask smallPairLarge_43 PairGraphPrepared43.colors).1 = true := left_checked
end D1Bound5.PairLightPrepared43
namespace D1Bound5.PairLightPrepared43

example :
    rightVertices = (pairSplitByMask smallPairLarge_43 PairGraphPrepared43.colors).2.map pairLightCoordinates := rightVertices_eq
end D1Bound5.PairLightPrepared43
namespace D1Bound5.PairLightPrepared43

example :
    rightCached = PairSelectedPrepared43.rightCached.map pairLightCachedCoordinates := rightCached_eq
end D1Bound5.PairLightPrepared43
namespace D1Bound5.PairLightPrepared43

example : rightRows = PairSelectedPrepared43.rightRows := rightRows_eq
end D1Bound5.PairLightPrepared43
namespace D1Bound5.PairLightPrepared43

example :
    pairIndependentBool smallPairSieve_1_3 (pairSplitByMask smallPairLarge_43 PairGraphPrepared43.colors).2 = true := right_checked
end D1Bound5.PairLightPrepared43
namespace D1Bound5

example :
    pairGraphTriangleFreeBool smallPairSieve_1_3 smallPairLarge_43 = true := smallPairNoTriangle_43_checked
end D1Bound5
run_cmd do
  for name in ([`D1Bound5.smallPairSeeds_43_checked, `D1Bound5.smallPairFilter_43_checked, `D1Bound5.smallPairLarge_43_count, `D1Bound5.PairSelectedPrepared43.leftCached, `D1Bound5.PairSelectedPrepared43.leftRows, `D1Bound5.PairSelectedPrepared43.rightCached, `D1Bound5.PairSelectedPrepared43.rightRows, `D1Bound5.PairLightPrepared43.sieve_eq, `D1Bound5.PairLightPrepared43.leftVertices_eq, `D1Bound5.PairLightPrepared43.leftCached_eq, `D1Bound5.PairLightPrepared43.leftRows_eq, `D1Bound5.PairLightPrepared43.left_checked, `D1Bound5.PairLightPrepared43.rightVertices_eq, `D1Bound5.PairLightPrepared43.rightCached_eq, `D1Bound5.PairLightPrepared43.rightRows_eq, `D1Bound5.PairLightPrepared43.right_checked, `D1Bound5.smallPairNoTriangle_43_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
