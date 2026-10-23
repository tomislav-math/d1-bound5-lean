import D1Bound5.SmallPairLightData39Sieve
import D1Bound5.SmallPairLightData39RightVertices
import D1Bound5.SmallPairLightData39RightCached
import D1Bound5.SmallPairLightData39RightRows
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared39
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Original heads 428 through 451, each checked against its complete tail. -/
theorem right_prefix_002_part08_checked :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared39.sieve 24
      (PairLightPrepared39.rightCached.drop 428)
      (PairLightPrepared39.rightRows.drop 428) = true := by
  decide +kernel

end D1Bound5.PairLightAdaptivePrepared39
