import D1Bound5.SmallPairLightData6LeftCachedChunk00
import D1Bound5.SmallPairLightData6LeftCachedChunk01
import D1Bound5.SmallPairLightData6LeftCachedChunk02
import D1Bound5.SmallPairLightData6LeftCachedChunk03
import D1Bound5.SmallPairLightData6LeftCachedChunk04
import D1Bound5.SmallPairLightData6LeftCachedChunk05
import D1Bound5.SmallPairLightData6LeftCachedChunk06

namespace D1Bound5.PairLightPrepared6
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

noncomputable def leftCached : List PairLightCachedVertex :=
  leftCachedChunk00 ++ leftCachedChunk01 ++ leftCachedChunk02 ++ leftCachedChunk03 ++ leftCachedChunk04 ++ leftCachedChunk05 ++ leftCachedChunk06

end D1Bound5.PairLightPrepared6
