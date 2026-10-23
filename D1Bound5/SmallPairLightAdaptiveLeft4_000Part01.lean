import D1Bound5.SmallPairLightData4Sieve
import D1Bound5.SmallPairLightData4LeftCached
import D1Bound5.SmallPairLightData4LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared4
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 11 through 21, retaining complete original tails. -/
theorem left_prefix_000_part01_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared4.sieve 11
      (PairLightPrepared4.leftCached.drop 11)
      (PairLightPrepared4.leftRows.drop 11) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared4
