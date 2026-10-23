import D1Bound5.SmallPairLightData6Sieve
import D1Bound5.SmallPairLightData6RightCached
import D1Bound5.SmallPairLightData6RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared6
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 638 through 656, retaining complete original tails. -/
theorem right_prefix_005_part03_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared6.sieve 19
      (PairLightPrepared6.rightCached.drop 638)
      (PairLightPrepared6.rightRows.drop 638) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared6
