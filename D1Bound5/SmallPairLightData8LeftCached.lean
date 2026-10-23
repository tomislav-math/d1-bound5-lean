import D1Bound5.SmallPairLightData8LeftCachedChunk00
import D1Bound5.SmallPairLightData8LeftCachedChunk01
import D1Bound5.SmallPairLightData8LeftCachedChunk02
import D1Bound5.SmallPairLightData8LeftCachedChunk03
import D1Bound5.SmallPairLightData8LeftCachedChunk04
import D1Bound5.SmallPairLightData8LeftCachedChunk05
import D1Bound5.SmallPairLightData8LeftCachedChunk06
import D1Bound5.SmallPairLightData8LeftCachedChunk07

namespace D1Bound5.PairLightPrepared8
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

noncomputable def leftCached : List PairLightCachedVertex :=
  leftCachedChunk00 ++ leftCachedChunk01 ++ leftCachedChunk02 ++ leftCachedChunk03 ++ leftCachedChunk04 ++ leftCachedChunk05 ++ leftCachedChunk06 ++ leftCachedChunk07

end D1Bound5.PairLightPrepared8
