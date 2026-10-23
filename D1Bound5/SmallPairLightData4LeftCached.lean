import D1Bound5.SmallPairLightData4LeftCachedChunk00
import D1Bound5.SmallPairLightData4LeftCachedChunk01
import D1Bound5.SmallPairLightData4LeftCachedChunk02
import D1Bound5.SmallPairLightData4LeftCachedChunk03
import D1Bound5.SmallPairLightData4LeftCachedChunk04
import D1Bound5.SmallPairLightData4LeftCachedChunk05

namespace D1Bound5.PairLightPrepared4
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0


noncomputable def leftCached : List PairLightCachedVertex :=
  leftCachedChunk00 ++ leftCachedChunk01 ++ leftCachedChunk02 ++ leftCachedChunk03 ++ leftCachedChunk04 ++ leftCachedChunk05

end D1Bound5.PairLightPrepared4
