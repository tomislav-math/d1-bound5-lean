import D1Bound5.SmallPairLightData30Sieve
import D1Bound5.SmallPairLightData30RightCached
import D1Bound5.SmallPairLightData30RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared30
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 92 through 103, with every original tail comparison. -/
theorem right_parallel_001_part00_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 12
      (PairLightPrepared30.rightCached.drop 92) (PairLightPrepared30.rightRows.drop 92) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared30
