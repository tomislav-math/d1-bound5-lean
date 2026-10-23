import D1Bound5.SmallPairLightData15Sieve
import D1Bound5.SmallPairLightData15RightCached
import D1Bound5.SmallPairLightData15RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared15
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 84 through 91, with every original tail comparison. -/
theorem right_parallel_000_part07_checked :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared15.sieve 8
      (PairLightPrepared15.rightCached.drop 84) (PairLightPrepared15.rightRows.drop 84) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared15
