import D1Bound5.SmallPairLightData23Sieve
import D1Bound5.SmallPairLightData23LeftCached
import D1Bound5.SmallPairLightData23LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared23
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 332 through 343, with every original tail comparison. -/
theorem left_parallel_002_part10_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared23.sieve 12
      (PairLightPrepared23.leftCached.drop 332) (PairLightPrepared23.leftRows.drop 332) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared23
