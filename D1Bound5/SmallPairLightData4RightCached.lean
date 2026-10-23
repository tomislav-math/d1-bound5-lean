import D1Bound5.SmallPairLightData4RightCachedChunk00
import D1Bound5.SmallPairLightData4RightCachedChunk01
import D1Bound5.SmallPairLightData4RightCachedChunk02
import D1Bound5.SmallPairLightData4RightCachedChunk03
import D1Bound5.SmallPairLightData4RightCachedChunk04
import D1Bound5.SmallPairLightData4RightCachedChunk05

namespace D1Bound5.PairLightPrepared4
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0


noncomputable def rightCached : List PairLightCachedVertex :=
  rightCachedChunk00 ++ rightCachedChunk01 ++ rightCachedChunk02 ++ rightCachedChunk03 ++ rightCachedChunk04 ++ rightCachedChunk05

end D1Bound5.PairLightPrepared4
