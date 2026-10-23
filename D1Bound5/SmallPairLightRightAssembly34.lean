import D1Bound5.SmallPairLightRight34
import D1Bound5.PairLightArithmeticBridge
import D1Bound5.SmallPairLiteralCachedData34
import D1Bound5.SmallPairSelectedData34

namespace D1Bound5.PairLightRightPilot34
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- All masks and their order are the original sieve. -/
theorem sieve_eq : sieve = smallPairSieve_1_2 := by
  rfl

/-- The independent literal coordinate list is the exact original right class,
including its ordering and full coverage. This linear check is separate from
the expensive all-pairs computation in the arithmetic-only module. -/
theorem rightVertices_eq :
    rightVertices =
      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).2.map
        pairLightCoordinates := by
  decide +kernel

/-- Every original cached coordinate and supplied signature is retained. -/
theorem rightCached_eq :
    rightCached = PairLiteralPilot34.rightCached.map pairLightCachedCoordinates := by
  rfl

/-- Packed words and sparse floor witnesses are unchanged. -/
theorem rightRows_eq : rightRows = PairSelectedPilot34.rightRows := by
  rfl

/-- Exactly the original right independent-class assertion, obtained only after
the four concrete data equalities and the unconditional checker bridge. -/
theorem right_checked :
    pairIndependentBool smallPairSieve_1_2
      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).2 = true := by
  apply pairIndependentBool_of_light_selected_floor_certificate (by decide) smallPairSieve_1_2
    (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).2
    PairLiteralPilot34.rightCached PairSelectedPilot34.rightRows
  rw [← sieve_eq, ← rightVertices_eq, ← rightCached_eq, ← rightRows_eq]
  exact right_certificate_checked

end D1Bound5.PairLightRightPilot34
