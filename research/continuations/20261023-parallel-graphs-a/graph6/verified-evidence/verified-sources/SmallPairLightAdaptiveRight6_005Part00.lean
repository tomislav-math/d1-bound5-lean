import D1Bound5.SmallPairLightData6Sieve
import D1Bound5.SmallPairLightData6RightCached
import D1Bound5.SmallPairLightData6RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared6
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 476 through 513, retaining complete original tails. -/
theorem right_prefix_005_part00_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 38
      (PairLightPrepared6.rightCached.drop 476)
      (PairLightPrepared6.rightRows.drop 476) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared6
