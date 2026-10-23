import D1Bound5.SmallPairLightData6Sieve
import D1Bound5.SmallPairLightData6LeftCached
import D1Bound5.SmallPairLightData6LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared6
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 74 through 85, retaining complete original tails. -/
theorem left_prefix_001_part01_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 12
      (PairLightPrepared6.leftCached.drop 74)
      (PairLightPrepared6.leftRows.drop 74) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared6
