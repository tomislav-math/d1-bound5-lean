import D1Bound5.SmallPairLightLeft14
import D1Bound5.SmallPairLightRight14
import D1Bound5.PairLightArithmeticBridge
import D1Bound5.SmallPairRawSelectedData14

namespace D1Bound5.PairLightPrepared14
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem sieve_eq : sieve = smallPairSieve_0_2 := by
  rfl

theorem leftVertices_eq :
    leftVertices = (pairSplitByMask smallPairLarge_14 PairGraphPrepared14.colors).1.map pairLightCoordinates := by
  decide +kernel

theorem leftCached_eq :
    leftCached = PairSelectedPrepared14.leftCached.map pairLightCachedCoordinates := by
  rfl

theorem leftRows_eq : leftRows = PairSelectedPrepared14.leftRows := by
  rfl

theorem left_checked :
    pairIndependentBool smallPairSieve_0_2 (pairSplitByMask smallPairLarge_14 PairGraphPrepared14.colors).1 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_0_2
    (pairSplitByMask smallPairLarge_14 PairGraphPrepared14.colors).1 PairSelectedPrepared14.leftCached PairSelectedPrepared14.leftRows
  rw [← sieve_eq, ← leftVertices_eq, ← leftCached_eq, ← leftRows_eq]
  exact left_certificate_checked

theorem rightVertices_eq :
    rightVertices = (pairSplitByMask smallPairLarge_14 PairGraphPrepared14.colors).2.map pairLightCoordinates := by
  decide +kernel

theorem rightCached_eq :
    rightCached = PairSelectedPrepared14.rightCached.map pairLightCachedCoordinates := by
  rfl

theorem rightRows_eq : rightRows = PairSelectedPrepared14.rightRows := by
  rfl

theorem right_checked :
    pairIndependentBool smallPairSieve_0_2 (pairSplitByMask smallPairLarge_14 PairGraphPrepared14.colors).2 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_0_2
    (pairSplitByMask smallPairLarge_14 PairGraphPrepared14.colors).2 PairSelectedPrepared14.rightCached PairSelectedPrepared14.rightRows
  rw [← sieve_eq, ← rightVertices_eq, ← rightCached_eq, ← rightRows_eq]
  exact right_certificate_checked

end D1Bound5.PairLightPrepared14
