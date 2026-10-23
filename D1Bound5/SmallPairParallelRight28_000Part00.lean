import D1Bound5.SmallPairLightData28Sieve
import D1Bound5.SmallPairLightData28RightCached
import D1Bound5.SmallPairLightData28RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared28
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 0 through 11, with every original tail comparison. -/
theorem right_parallel_000_part00_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 12
      (PairLightPrepared28.rightCached.drop 0) (PairLightPrepared28.rightRows.drop 0) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared28
