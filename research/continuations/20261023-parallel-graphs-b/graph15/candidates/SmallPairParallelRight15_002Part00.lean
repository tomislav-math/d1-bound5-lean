import D1Bound5.SmallPairLightData15Sieve
import D1Bound5.SmallPairLightData15RightCached
import D1Bound5.SmallPairLightData15RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared15
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 214 through 225, with every original tail comparison. -/
theorem right_parallel_002_part00_checked :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared15.sieve 12
      (PairLightPrepared15.rightCached.drop 214) (PairLightPrepared15.rightRows.drop 214) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared15
