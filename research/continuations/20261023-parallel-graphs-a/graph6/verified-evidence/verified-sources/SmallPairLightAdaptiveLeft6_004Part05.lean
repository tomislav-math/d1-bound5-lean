import D1Bound5.SmallPairLightData6Sieve
import D1Bound5.SmallPairLightData6LeftCached
import D1Bound5.SmallPairLightData6LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared6
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 435 through 465, retaining complete original tails. -/
theorem left_prefix_004_part05_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 31
      (PairLightPrepared6.leftCached.drop 435)
      (PairLightPrepared6.leftRows.drop 435) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared6
