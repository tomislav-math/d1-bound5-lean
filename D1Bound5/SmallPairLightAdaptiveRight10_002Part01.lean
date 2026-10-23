import D1Bound5.SmallPairLightData10Sieve
import D1Bound5.SmallPairLightData10RightCached
import D1Bound5.SmallPairLightData10RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared10
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 168 through 183, retaining complete original tails. -/
theorem right_prefix_002_part01_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared10.sieve 16
      (PairLightPrepared10.rightCached.drop 168)
      (PairLightPrepared10.rightRows.drop 168) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared10
