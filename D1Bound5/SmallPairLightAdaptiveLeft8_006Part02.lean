import D1Bound5.SmallPairLightData8Sieve
import D1Bound5.SmallPairLightData8LeftCached
import D1Bound5.SmallPairLightData8LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared8
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 610 through 675, retaining complete original tails. -/
theorem left_prefix_006_part02_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 66
      (PairLightPrepared8.leftCached.drop 610)
      (PairLightPrepared8.leftRows.drop 610) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared8
