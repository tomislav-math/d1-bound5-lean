import D1Bound5.SmallPairLightData28Sieve
import D1Bound5.SmallPairLightData28RightCached
import D1Bound5.SmallPairLightData28RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared28
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 268 through 279, with every original tail comparison. -/
theorem right_parallel_002_part07_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 12
      (PairLightPrepared28.rightCached.drop 268) (PairLightPrepared28.rightRows.drop 268) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared28
