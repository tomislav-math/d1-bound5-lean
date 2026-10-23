import D1Bound5.SmallPairLightData8Sieve
import D1Bound5.SmallPairLightData8RightCached
import D1Bound5.SmallPairLightData8RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared8
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 464 through 490, retaining complete original tails. -/
theorem right_prefix_005_part04_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared8.sieve 27
      (PairLightPrepared8.rightCached.drop 464)
      (PairLightPrepared8.rightRows.drop 464) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared8
