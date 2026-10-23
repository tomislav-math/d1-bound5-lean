import D1Bound5.SmallPairLightData15Sieve
import D1Bound5.SmallPairLightData15LeftCached
import D1Bound5.SmallPairLightData15LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared15
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 286 through 297, with every original tail comparison. -/
theorem left_parallel_002_part06_checked :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared15.sieve 12
      (PairLightPrepared15.leftCached.drop 286) (PairLightPrepared15.leftRows.drop 286) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared15
