import D1Bound5.SmallPairLightData23Sieve
import D1Bound5.SmallPairLightData23RightCached
import D1Bound5.SmallPairLightData23RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared23
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 164 through 175, with every original tail comparison. -/
theorem right_parallel_001_part06_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared23.sieve 12
      (PairLightPrepared23.rightCached.drop 164) (PairLightPrepared23.rightRows.drop 164) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared23
