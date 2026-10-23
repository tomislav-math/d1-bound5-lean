import D1Bound5.SmallPairLightData30Sieve
import D1Bound5.SmallPairLightData30RightCached
import D1Bound5.SmallPairLightData30RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared30
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 212 through 213, with every original tail comparison. -/
theorem right_parallel_001_part10_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 2
      (PairLightPrepared30.rightCached.drop 212) (PairLightPrepared30.rightRows.drop 212) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared30
