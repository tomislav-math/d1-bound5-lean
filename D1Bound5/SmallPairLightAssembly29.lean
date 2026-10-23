import D1Bound5.SmallPairLightLeft29
import D1Bound5.SmallPairLightRight29
import D1Bound5.PairLightArithmeticBridge
import D1Bound5.SmallPairRawSelectedData29

namespace D1Bound5.PairLightPrepared29
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem sieve_eq : sieve = smallPairSieve_1_1 := by
  rfl

theorem leftVertices_eq :
    leftVertices = (pairSplitByMask smallPairLarge_29 PairGraphPrepared29.colors).1.map pairLightCoordinates := by
  decide +kernel

theorem leftCached_eq :
    leftCached = PairSelectedPrepared29.leftCached.map pairLightCachedCoordinates := by
  rfl

theorem leftRows_eq : leftRows = PairSelectedPrepared29.leftRows := by
  rfl

theorem left_checked :
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_29 PairGraphPrepared29.colors).1 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_1_1
    (pairSplitByMask smallPairLarge_29 PairGraphPrepared29.colors).1 PairSelectedPrepared29.leftCached PairSelectedPrepared29.leftRows
  rw [← sieve_eq, ← leftVertices_eq, ← leftCached_eq, ← leftRows_eq]
  exact left_certificate_checked

theorem rightVertices_eq :
    rightVertices = (pairSplitByMask smallPairLarge_29 PairGraphPrepared29.colors).2.map pairLightCoordinates := by
  decide +kernel

theorem rightCached_eq :
    rightCached = PairSelectedPrepared29.rightCached.map pairLightCachedCoordinates := by
  rfl

theorem rightRows_eq : rightRows = PairSelectedPrepared29.rightRows := by
  rfl

theorem right_checked :
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_29 PairGraphPrepared29.colors).2 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_1_1
    (pairSplitByMask smallPairLarge_29 PairGraphPrepared29.colors).2 PairSelectedPrepared29.rightCached PairSelectedPrepared29.rightRows
  rw [← sieve_eq, ← rightVertices_eq, ← rightCached_eq, ← rightRows_eq]
  exact right_certificate_checked

end D1Bound5.PairLightPrepared29
