import D1Bound5.SmallPairLightData23Sieve
import D1Bound5.SmallPairLightData23RightCached
import D1Bound5.SmallPairLightData23RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared23
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 84 through 91, with every original tail comparison. -/
theorem right_parallel_000_part07_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared23.sieve 8
      (PairLightPrepared23.rightCached.drop 84) (PairLightPrepared23.rightRows.drop 84) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared23
