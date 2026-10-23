import D1Bound5.SmallPairLightData36Sieve
import D1Bound5.SmallPairLightData36RightCached
import D1Bound5.SmallPairLightData36RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared36
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 395 through 406, with every original tail comparison. -/
theorem right_parallel_003_part09_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 12
      (PairLightPrepared36.rightCached.drop 395) (PairLightPrepared36.rightRows.drop 395) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared36
