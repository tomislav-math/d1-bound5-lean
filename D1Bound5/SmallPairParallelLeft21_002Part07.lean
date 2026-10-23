import D1Bound5.SmallPairLightData21Sieve
import D1Bound5.SmallPairLightData21LeftCached
import D1Bound5.SmallPairLightData21LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared21
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 268 through 279, with every original tail comparison. -/
theorem left_parallel_002_part07_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared21.sieve 12
      (PairLightPrepared21.leftCached.drop 268) (PairLightPrepared21.leftRows.drop 268) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared21
