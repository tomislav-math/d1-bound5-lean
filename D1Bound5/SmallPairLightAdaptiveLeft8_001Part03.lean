import D1Bound5.SmallPairLightData8Sieve
import D1Bound5.SmallPairLightData8LeftCached
import D1Bound5.SmallPairLightData8LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared8
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 88 through 98, retaining complete original tails. -/
theorem left_prefix_001_part03_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 11
      (PairLightPrepared8.leftCached.drop 88)
      (PairLightPrepared8.leftRows.drop 88) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared8
