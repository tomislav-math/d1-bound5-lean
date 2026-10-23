import D1Bound5.SmallPairLightLeft33
import D1Bound5.SmallPairLightRight33
import D1Bound5.PairLightArithmeticBridge
import D1Bound5.SmallPairRawSelectedData33

namespace D1Bound5.PairLightPrepared33
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem sieve_eq : sieve = smallPairSieve_1_2 := by
  rfl

theorem leftVertices_eq :
    leftVertices = (pairSplitByMask smallPairLarge_33 PairGraphPrepared33.colors).1.map pairLightCoordinates := by
  decide +kernel

theorem leftCached_eq :
    leftCached = PairSelectedPrepared33.leftCached.map pairLightCachedCoordinates := by
  rfl

theorem leftRows_eq : leftRows = PairSelectedPrepared33.leftRows := by
  rfl

theorem left_checked :
    pairIndependentBool smallPairSieve_1_2 (pairSplitByMask smallPairLarge_33 PairGraphPrepared33.colors).1 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_1_2
    (pairSplitByMask smallPairLarge_33 PairGraphPrepared33.colors).1 PairSelectedPrepared33.leftCached PairSelectedPrepared33.leftRows
  rw [← sieve_eq, ← leftVertices_eq, ← leftCached_eq, ← leftRows_eq]
  exact left_certificate_checked

theorem rightVertices_eq :
    rightVertices = (pairSplitByMask smallPairLarge_33 PairGraphPrepared33.colors).2.map pairLightCoordinates := by
  decide +kernel

theorem rightCached_eq :
    rightCached = PairSelectedPrepared33.rightCached.map pairLightCachedCoordinates := by
  rfl

theorem rightRows_eq : rightRows = PairSelectedPrepared33.rightRows := by
  rfl

theorem right_checked :
    pairIndependentBool smallPairSieve_1_2 (pairSplitByMask smallPairLarge_33 PairGraphPrepared33.colors).2 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_1_2
    (pairSplitByMask smallPairLarge_33 PairGraphPrepared33.colors).2 PairSelectedPrepared33.rightCached PairSelectedPrepared33.rightRows
  rw [← sieve_eq, ← rightVertices_eq, ← rightCached_eq, ← rightRows_eq]
  exact right_certificate_checked

end D1Bound5.PairLightPrepared33
