import D1Bound5.SmallPairLightData36Sieve
import D1Bound5.SmallPairLightData36RightCached
import D1Bound5.SmallPairLightData36RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared36
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 167 through 178, with every original tail comparison. -/
theorem right_parallel_002_part00_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 12
      (PairLightPrepared36.rightCached.drop 167) (PairLightPrepared36.rightRows.drop 167) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared36
