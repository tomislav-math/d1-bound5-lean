import D1Bound5.SmallPairLightData4Sieve
import D1Bound5.SmallPairLightData4LeftCached
import D1Bound5.SmallPairLightData4LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared4
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 236 through 254, retaining complete original tails. -/
theorem left_prefix_002_part05_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 19
      (PairLightPrepared4.leftCached.drop 236)
      (PairLightPrepared4.leftRows.drop 236) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared4
