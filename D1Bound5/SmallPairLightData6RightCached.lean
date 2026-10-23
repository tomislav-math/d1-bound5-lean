import D1Bound5.SmallPairLightData6RightCachedChunk00
import D1Bound5.SmallPairLightData6RightCachedChunk01
import D1Bound5.SmallPairLightData6RightCachedChunk02
import D1Bound5.SmallPairLightData6RightCachedChunk03
import D1Bound5.SmallPairLightData6RightCachedChunk04
import D1Bound5.SmallPairLightData6RightCachedChunk05
import D1Bound5.SmallPairLightData6RightCachedChunk06

namespace D1Bound5.PairLightPrepared6
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

noncomputable def rightCached : List PairLightCachedVertex :=
  rightCachedChunk00 ++ rightCachedChunk01 ++ rightCachedChunk02 ++ rightCachedChunk03 ++ rightCachedChunk04 ++ rightCachedChunk05 ++ rightCachedChunk06

end D1Bound5.PairLightPrepared6
