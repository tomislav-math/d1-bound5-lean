import D1Bound5.SmallPairLightData15Sieve
import D1Bound5.SmallPairLightData15RightCached
import D1Bound5.SmallPairLightData15RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared15
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 128 through 139, with every original tail comparison. -/
theorem right_parallel_001_part03_checked :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared15.sieve 12
      (PairLightPrepared15.rightCached.drop 128) (PairLightPrepared15.rightRows.drop 128) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared15
