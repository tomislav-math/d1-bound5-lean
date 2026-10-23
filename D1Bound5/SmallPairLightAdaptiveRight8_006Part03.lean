import D1Bound5.SmallPairLightData8Sieve
import D1Bound5.SmallPairLightData8RightCached
import D1Bound5.SmallPairLightData8RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared8
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 665 through 717, retaining complete original tails. -/
theorem right_prefix_006_part03_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 53
      (PairLightPrepared8.rightCached.drop 665)
      (PairLightPrepared8.rightRows.drop 665) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared8
