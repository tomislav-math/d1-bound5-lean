import D1Bound5.SmallPairLightLeft40
import D1Bound5.SmallPairLightRight40
import D1Bound5.PairLightArithmeticBridge
import D1Bound5.SmallPairRawSelectedData40

namespace D1Bound5.PairLightPrepared40
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem sieve_eq : sieve = smallPairSieve_1_2 := by
  rfl

theorem leftVertices_eq :
    leftVertices = (pairSplitByMask smallPairLarge_40 PairGraphPrepared40.colors).1.map pairLightCoordinates := by
  decide +kernel

theorem leftCached_eq :
    leftCached = PairSelectedPrepared40.leftCached.map pairLightCachedCoordinates := by
  rfl

theorem leftRows_eq : leftRows = PairSelectedPrepared40.leftRows := by
  rfl

theorem left_checked :
    pairIndependentBool smallPairSieve_1_2 (pairSplitByMask smallPairLarge_40 PairGraphPrepared40.colors).1 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_1_2
    (pairSplitByMask smallPairLarge_40 PairGraphPrepared40.colors).1 PairSelectedPrepared40.leftCached PairSelectedPrepared40.leftRows
  rw [← sieve_eq, ← leftVertices_eq, ← leftCached_eq, ← leftRows_eq]
  exact left_certificate_checked

theorem rightVertices_eq :
    rightVertices = (pairSplitByMask smallPairLarge_40 PairGraphPrepared40.colors).2.map pairLightCoordinates := by
  decide +kernel

theorem rightCached_eq :
    rightCached = PairSelectedPrepared40.rightCached.map pairLightCachedCoordinates := by
  rfl

theorem rightRows_eq : rightRows = PairSelectedPrepared40.rightRows := by
  rfl

theorem right_checked :
    pairIndependentBool smallPairSieve_1_2 (pairSplitByMask smallPairLarge_40 PairGraphPrepared40.colors).2 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_1_2
    (pairSplitByMask smallPairLarge_40 PairGraphPrepared40.colors).2 PairSelectedPrepared40.rightCached PairSelectedPrepared40.rightRows
  rw [← sieve_eq, ← rightVertices_eq, ← rightCached_eq, ← rightRows_eq]
  exact right_certificate_checked

end D1Bound5.PairLightPrepared40
