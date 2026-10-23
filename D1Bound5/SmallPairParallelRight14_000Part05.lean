import D1Bound5.SmallPairLightData14Sieve
import D1Bound5.SmallPairLightData14RightCached
import D1Bound5.SmallPairLightData14RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared14
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 60 through 71, with every original tail comparison. -/
theorem right_parallel_000_part05_checked :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 12
      (PairLightPrepared14.rightCached.drop 60) (PairLightPrepared14.rightRows.drop 60) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared14
