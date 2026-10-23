import D1Bound5.SmallPairLightData6Sieve
import D1Bound5.SmallPairLightData6RightCached
import D1Bound5.SmallPairLightData6RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared6
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 249 through 265, retaining complete original tails. -/
theorem right_prefix_003_part02_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 17
      (PairLightPrepared6.rightCached.drop 249)
      (PairLightPrepared6.rightRows.drop 249) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared6
