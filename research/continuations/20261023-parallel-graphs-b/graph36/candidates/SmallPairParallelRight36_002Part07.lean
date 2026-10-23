import D1Bound5.SmallPairLightData36Sieve
import D1Bound5.SmallPairLightData36RightCached
import D1Bound5.SmallPairLightData36RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared36
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 251 through 262, with every original tail comparison. -/
theorem right_parallel_002_part07_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 12
      (PairLightPrepared36.rightCached.drop 251) (PairLightPrepared36.rightRows.drop 251) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared36
