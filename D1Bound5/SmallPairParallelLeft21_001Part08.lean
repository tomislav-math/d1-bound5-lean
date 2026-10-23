import D1Bound5.SmallPairLightData21Sieve
import D1Bound5.SmallPairLightData21LeftCached
import D1Bound5.SmallPairLightData21LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared21
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 178 through 183, with every original tail comparison. -/
theorem left_parallel_001_part08_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared21.sieve 6
      (PairLightPrepared21.leftCached.drop 178) (PairLightPrepared21.leftRows.drop 178) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared21
