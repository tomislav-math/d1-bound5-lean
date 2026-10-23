import D1Bound5.SmallPairLightData10RightCachedChunk00
import D1Bound5.SmallPairLightData10RightCachedChunk01
import D1Bound5.SmallPairLightData10RightCachedChunk02
import D1Bound5.SmallPairLightData10RightCachedChunk03
import D1Bound5.SmallPairLightData10RightCachedChunk04
import D1Bound5.SmallPairLightData10RightCachedChunk05

namespace D1Bound5.PairLightPrepared10
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

noncomputable def rightCached : List PairLightCachedVertex :=
  rightCachedChunk00 ++ rightCachedChunk01 ++ rightCachedChunk02 ++ rightCachedChunk03 ++ rightCachedChunk04 ++ rightCachedChunk05

end D1Bound5.PairLightPrepared10
