import D1Bound5.SmallPairLightData23Sieve
import D1Bound5.SmallPairLightData23RightCached
import D1Bound5.SmallPairLightData23RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared23
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 370 through 381, with every original tail comparison. -/
theorem right_parallel_002_part13_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared23.sieve 12
      (PairLightPrepared23.rightCached.drop 370) (PairLightPrepared23.rightRows.drop 370) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared23
