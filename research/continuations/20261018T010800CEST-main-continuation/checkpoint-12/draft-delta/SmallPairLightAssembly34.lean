import D1Bound5.SmallPairLightLeft34
import D1Bound5.PairLightArithmeticBridge
import D1Bound5.SmallPairLiteralCachedData34
import D1Bound5.SmallPairSelectedData34

namespace D1Bound5.PairLightPilot34
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- All masks and their order are the original sieve. -/
theorem sieve_eq : sieve = smallPairSieve_1_2 := by
  rfl

/-- The independent literal coordinate list is the exact original left class,
including its ordering and full coverage. This linear check is separate from
the expensive all-pairs computation in the arithmetic-only module. -/
theorem leftVertices_eq :
    leftVertices =
      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).1.map
        pairLightCoordinates := by
  decide +kernel

/-- Every original cached coordinate and supplied signature is retained. -/
theorem leftCached_eq :
    leftCached = PairLiteralPilot34.leftCached.map pairLightCachedCoordinates := by
  rfl

/-- Packed words and sparse floor witnesses are unchanged. -/
theorem leftRows_eq : leftRows = PairSelectedPilot34.leftRows := by
  rfl

/-- Exactly the original left independent-class assertion, obtained only after
the four concrete data equalities and the unconditional checker bridge. -/
theorem left_checked :
    pairIndependentBool smallPairSieve_1_2
      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).1 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_1_2
    (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).1
    PairLiteralPilot34.leftCached PairSelectedPilot34.leftRows
  rw [← sieve_eq, ← leftVertices_eq, ← leftCached_eq, ← leftRows_eq]
  exact left_certificate_checked

end D1Bound5.PairLightPilot34
