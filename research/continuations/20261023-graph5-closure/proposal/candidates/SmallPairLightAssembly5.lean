import D1Bound5.SmallPairLightLeft5
import D1Bound5.SmallPairLightRight5
import D1Bound5.PairLightArithmeticBridge
import D1Bound5.SmallPairRawSelectedData5

namespace D1Bound5.PairLightPrepared5
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem sieve_eq : sieve = smallPairSieve_0_1 := by
  rfl

theorem leftVertices_eq :
    leftVertices = (pairSplitByMask smallPairLarge_5 PairGraphPrepared5.colors).1.map pairLightCoordinates := by
  decide +kernel

theorem leftCached_eq :
    leftCached = PairSelectedPrepared5.leftCached.map pairLightCachedCoordinates := by
  rfl

theorem leftRows_eq : leftRows = PairSelectedPrepared5.leftRows := by
  rfl

theorem left_checked :
    pairIndependentBool smallPairSieve_0_1 (pairSplitByMask smallPairLarge_5 PairGraphPrepared5.colors).1 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_0_1
    (pairSplitByMask smallPairLarge_5 PairGraphPrepared5.colors).1 PairSelectedPrepared5.leftCached PairSelectedPrepared5.leftRows
  rw [← sieve_eq, ← leftVertices_eq, ← leftCached_eq, ← leftRows_eq]
  exact left_certificate_checked

theorem rightVertices_eq :
    rightVertices = (pairSplitByMask smallPairLarge_5 PairGraphPrepared5.colors).2.map pairLightCoordinates := by
  decide +kernel

theorem rightCached_eq :
    rightCached = PairSelectedPrepared5.rightCached.map pairLightCachedCoordinates := by
  rfl

theorem rightRows_eq : rightRows = PairSelectedPrepared5.rightRows := by
  rfl

theorem right_checked :
    pairIndependentBool smallPairSieve_0_1 (pairSplitByMask smallPairLarge_5 PairGraphPrepared5.colors).2 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_0_1
    (pairSplitByMask smallPairLarge_5 PairGraphPrepared5.colors).2 PairSelectedPrepared5.rightCached PairSelectedPrepared5.rightRows
  rw [← sieve_eq, ← rightVertices_eq, ← rightCached_eq, ← rightRows_eq]
  exact right_certificate_checked

end D1Bound5.PairLightPrepared5
