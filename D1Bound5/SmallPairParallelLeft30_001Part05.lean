import D1Bound5.SmallPairLightData30Sieve
import D1Bound5.SmallPairLightData30LeftCached
import D1Bound5.SmallPairLightData30LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared30
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 151 through 162, with every original tail comparison. -/
theorem left_parallel_001_part05_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 12
      (PairLightPrepared30.leftCached.drop 151) (PairLightPrepared30.leftRows.drop 151) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared30
