import D1Bound5.SmallPairLightData4Sieve
import D1Bound5.SmallPairLightData4LeftCached
import D1Bound5.SmallPairLightData4LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared4
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 46 through 57, retaining complete original tails. -/
theorem left_prefix_000_part04_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 12
      (PairLightPrepared4.leftCached.drop 46)
      (PairLightPrepared4.leftRows.drop 46) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared4
