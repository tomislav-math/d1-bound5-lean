import D1Bound5.SmallPairLightLeft19
import D1Bound5.SmallPairLightRight19
import D1Bound5.PairLightArithmeticBridge
import D1Bound5.SmallPairRawSelectedData19

namespace D1Bound5.PairLightPrepared19
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem sieve_eq : sieve = smallPairSieve_1_1 := by
  rfl

theorem leftVertices_eq :
    leftVertices = (pairSplitByMask smallPairLarge_19 PairGraphPrepared19.colors).1.map pairLightCoordinates := by
  decide +kernel

theorem leftCached_eq :
    leftCached = PairSelectedPrepared19.leftCached.map pairLightCachedCoordinates := by
  rfl

theorem leftRows_eq : leftRows = PairSelectedPrepared19.leftRows := by
  rfl

theorem left_checked :
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_19 PairGraphPrepared19.colors).1 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_1_1
    (pairSplitByMask smallPairLarge_19 PairGraphPrepared19.colors).1 PairSelectedPrepared19.leftCached PairSelectedPrepared19.leftRows
  rw [← sieve_eq, ← leftVertices_eq, ← leftCached_eq, ← leftRows_eq]
  exact left_certificate_checked

theorem rightVertices_eq :
    rightVertices = (pairSplitByMask smallPairLarge_19 PairGraphPrepared19.colors).2.map pairLightCoordinates := by
  decide +kernel

theorem rightCached_eq :
    rightCached = PairSelectedPrepared19.rightCached.map pairLightCachedCoordinates := by
  rfl

theorem rightRows_eq : rightRows = PairSelectedPrepared19.rightRows := by
  rfl

theorem right_checked :
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_19 PairGraphPrepared19.colors).2 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_1_1
    (pairSplitByMask smallPairLarge_19 PairGraphPrepared19.colors).2 PairSelectedPrepared19.rightCached PairSelectedPrepared19.rightRows
  rw [← sieve_eq, ← rightVertices_eq, ← rightCached_eq, ← rightRows_eq]
  exact right_certificate_checked

end D1Bound5.PairLightPrepared19
