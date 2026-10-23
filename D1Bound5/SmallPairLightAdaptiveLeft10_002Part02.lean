import D1Bound5.SmallPairLightData10Sieve
import D1Bound5.SmallPairLightData10LeftCached
import D1Bound5.SmallPairLightData10LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared10
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 184 through 200, retaining complete original tails. -/
theorem left_prefix_002_part02_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared10.sieve 17
      (PairLightPrepared10.leftCached.drop 184)
      (PairLightPrepared10.leftRows.drop 184) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared10
