import D1Bound5.SmallPairLightData36Sieve
import D1Bound5.SmallPairLightData36LeftCached
import D1Bound5.SmallPairLightData36LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared36
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 167 through 178, with every original tail comparison. -/
theorem left_parallel_002_part00_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 12
      (PairLightPrepared36.leftCached.drop 167) (PairLightPrepared36.leftRows.drop 167) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared36
