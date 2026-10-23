import D1Bound5.SmallPairLightData8Sieve
import D1Bound5.SmallPairLightData8RightCached
import D1Bound5.SmallPairLightData8RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared8
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 604 through 664, retaining complete original tails. -/
theorem right_prefix_006_part02_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 61
      (PairLightPrepared8.rightCached.drop 604)
      (PairLightPrepared8.rightRows.drop 604) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared8
