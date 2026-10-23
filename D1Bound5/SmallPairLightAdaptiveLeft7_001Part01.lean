import D1Bound5.SmallPairLightData7Sieve
import D1Bound5.SmallPairLightData7LeftVertices
import D1Bound5.SmallPairLightData7LeftCached
import D1Bound5.SmallPairLightData7LeftRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared7
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 129 through 152, each checked against its complete tail. -/
theorem left_prefix_001_part01_checked :
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared7.sieve 24
      (PairLightPrepared7.leftCached.drop 129)
      (PairLightPrepared7.leftRows.drop 129) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared7
