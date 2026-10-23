import D1Bound5.SmallPairLightData10Sieve
import D1Bound5.SmallPairLightData10RightCached
import D1Bound5.SmallPairLightData10RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared10
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 371 through 401, retaining complete original tails. -/
theorem right_prefix_003_part05_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared10.sieve 31
      (PairLightPrepared10.rightCached.drop 371)
      (PairLightPrepared10.rightRows.drop 371) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared10
