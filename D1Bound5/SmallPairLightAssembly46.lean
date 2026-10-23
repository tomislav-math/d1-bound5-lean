import D1Bound5.SmallPairLightLeft46
import D1Bound5.SmallPairLightRight46
import D1Bound5.PairLightArithmeticBridge
import D1Bound5.SmallPairRawSelectedData46

namespace D1Bound5.PairLightPrepared46
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem sieve_eq : sieve = smallPairSieve_1_6 := by
  rfl

theorem leftVertices_eq :
    leftVertices = (pairSplitByMask smallPairLarge_46 PairGraphPrepared46.colors).1.map pairLightCoordinates := by
  decide +kernel

theorem leftCached_eq :
    leftCached = PairSelectedPrepared46.leftCached.map pairLightCachedCoordinates := by
  rfl

theorem leftRows_eq : leftRows = PairSelectedPrepared46.leftRows := by
  rfl

theorem left_checked :
    pairIndependentBool smallPairSieve_1_6 (pairSplitByMask smallPairLarge_46 PairGraphPrepared46.colors).1 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_1_6
    (pairSplitByMask smallPairLarge_46 PairGraphPrepared46.colors).1 PairSelectedPrepared46.leftCached PairSelectedPrepared46.leftRows
  rw [← sieve_eq, ← leftVertices_eq, ← leftCached_eq, ← leftRows_eq]
  exact left_certificate_checked

theorem rightVertices_eq :
    rightVertices = (pairSplitByMask smallPairLarge_46 PairGraphPrepared46.colors).2.map pairLightCoordinates := by
  decide +kernel

theorem rightCached_eq :
    rightCached = PairSelectedPrepared46.rightCached.map pairLightCachedCoordinates := by
  rfl

theorem rightRows_eq : rightRows = PairSelectedPrepared46.rightRows := by
  rfl

theorem right_checked :
    pairIndependentBool smallPairSieve_1_6 (pairSplitByMask smallPairLarge_46 PairGraphPrepared46.colors).2 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_1_6
    (pairSplitByMask smallPairLarge_46 PairGraphPrepared46.colors).2 PairSelectedPrepared46.rightCached PairSelectedPrepared46.rightRows
  rw [← sieve_eq, ← rightVertices_eq, ← rightCached_eq, ← rightRows_eq]
  exact right_certificate_checked

end D1Bound5.PairLightPrepared46
