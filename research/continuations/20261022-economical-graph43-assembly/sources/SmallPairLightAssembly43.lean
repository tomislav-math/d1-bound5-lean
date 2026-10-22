import D1Bound5.SmallPairLightLeft43
import D1Bound5.SmallPairLightRight43
import D1Bound5.PairLightArithmeticBridge
import D1Bound5.SmallPairRawSelectedData43

namespace D1Bound5.PairLightPrepared43
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem sieve_eq : sieve = smallPairSieve_1_3 := by
  rfl

theorem leftVertices_eq :
    leftVertices = (pairSplitByMask smallPairLarge_43 PairGraphPrepared43.colors).1.map pairLightCoordinates := by
  decide +kernel

theorem leftCached_eq :
    leftCached = PairSelectedPrepared43.leftCached.map pairLightCachedCoordinates := by
  rfl

theorem leftRows_eq : leftRows = PairSelectedPrepared43.leftRows := by
  rfl

theorem left_checked :
    pairIndependentBool smallPairSieve_1_3 (pairSplitByMask smallPairLarge_43 PairGraphPrepared43.colors).1 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_1_3
    (pairSplitByMask smallPairLarge_43 PairGraphPrepared43.colors).1 PairSelectedPrepared43.leftCached PairSelectedPrepared43.leftRows
  rw [← sieve_eq, ← leftVertices_eq, ← leftCached_eq, ← leftRows_eq]
  exact left_certificate_checked

theorem rightVertices_eq :
    rightVertices = (pairSplitByMask smallPairLarge_43 PairGraphPrepared43.colors).2.map pairLightCoordinates := by
  decide +kernel

theorem rightCached_eq :
    rightCached = PairSelectedPrepared43.rightCached.map pairLightCachedCoordinates := by
  rfl

theorem rightRows_eq : rightRows = PairSelectedPrepared43.rightRows := by
  rfl

theorem right_checked :
    pairIndependentBool smallPairSieve_1_3 (pairSplitByMask smallPairLarge_43 PairGraphPrepared43.colors).2 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_1_3
    (pairSplitByMask smallPairLarge_43 PairGraphPrepared43.colors).2 PairSelectedPrepared43.rightCached PairSelectedPrepared43.rightRows
  rw [← sieve_eq, ← rightVertices_eq, ← rightCached_eq, ← rightRows_eq]
  exact right_certificate_checked

end D1Bound5.PairLightPrepared43
