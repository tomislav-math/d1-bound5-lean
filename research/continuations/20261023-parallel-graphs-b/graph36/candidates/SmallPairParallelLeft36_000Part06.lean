import D1Bound5.SmallPairLightData36Sieve
import D1Bound5.SmallPairLightData36LeftCached
import D1Bound5.SmallPairLightData36LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared36
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 72 through 75, with every original tail comparison. -/
theorem left_parallel_000_part06_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 4
      (PairLightPrepared36.leftCached.drop 72) (PairLightPrepared36.leftRows.drop 72) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared36
