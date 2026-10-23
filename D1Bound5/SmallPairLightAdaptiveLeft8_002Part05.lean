import D1Bound5.SmallPairLightData8Sieve
import D1Bound5.SmallPairLightData8LeftCached
import D1Bound5.SmallPairLightData8LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared8
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 180 through 191, retaining complete original tails. -/
theorem left_prefix_002_part05_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 12
      (PairLightPrepared8.leftCached.drop 180)
      (PairLightPrepared8.leftRows.drop 180) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared8
