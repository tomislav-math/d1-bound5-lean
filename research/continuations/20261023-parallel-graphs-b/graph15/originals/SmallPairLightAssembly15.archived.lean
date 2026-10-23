import D1Bound5.SmallPairLightLeft15
import D1Bound5.SmallPairLightRight15
import D1Bound5.PairLightArithmeticBridge
import D1Bound5.SmallPairRawSelectedData15

namespace D1Bound5.PairLightPrepared15
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem sieve_eq : sieve = smallPairSieve_0_2 := by
  rfl

theorem leftVertices_eq :
    leftVertices = (pairSplitByMask smallPairLarge_15 PairGraphPrepared15.colors).1.map pairLightCoordinates := by
  decide +kernel

theorem leftCached_eq :
    leftCached = PairSelectedPrepared15.leftCached.map pairLightCachedCoordinates := by
  rfl

theorem leftRows_eq : leftRows = PairSelectedPrepared15.leftRows := by
  rfl

theorem left_checked :
    pairIndependentBool smallPairSieve_0_2 (pairSplitByMask smallPairLarge_15 PairGraphPrepared15.colors).1 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_0_2
    (pairSplitByMask smallPairLarge_15 PairGraphPrepared15.colors).1 PairSelectedPrepared15.leftCached PairSelectedPrepared15.leftRows
  rw [← sieve_eq, ← leftVertices_eq, ← leftCached_eq, ← leftRows_eq]
  exact left_certificate_checked

theorem rightVertices_eq :
    rightVertices = (pairSplitByMask smallPairLarge_15 PairGraphPrepared15.colors).2.map pairLightCoordinates := by
  decide +kernel

theorem rightCached_eq :
    rightCached = PairSelectedPrepared15.rightCached.map pairLightCachedCoordinates := by
  rfl

theorem rightRows_eq : rightRows = PairSelectedPrepared15.rightRows := by
  rfl

theorem right_checked :
    pairIndependentBool smallPairSieve_0_2 (pairSplitByMask smallPairLarge_15 PairGraphPrepared15.colors).2 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_0_2
    (pairSplitByMask smallPairLarge_15 PairGraphPrepared15.colors).2 PairSelectedPrepared15.rightCached PairSelectedPrepared15.rightRows
  rw [← sieve_eq, ← rightVertices_eq, ← rightCached_eq, ← rightRows_eq]
  exact right_certificate_checked

end D1Bound5.PairLightPrepared15
