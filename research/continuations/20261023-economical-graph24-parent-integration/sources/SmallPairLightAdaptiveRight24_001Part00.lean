import D1Bound5.SmallPairLightData24Sieve
import D1Bound5.SmallPairLightData24RightVertices
import D1Bound5.SmallPairLightData24RightCached
import D1Bound5.SmallPairLightData24RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared24
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 101 through 124, each checked against its complete tail. -/
theorem right_prefix_001_part00_checked :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared24.sieve 24
      (PairLightPrepared24.rightCached.drop 101)
      (PairLightPrepared24.rightRows.drop 101) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared24
