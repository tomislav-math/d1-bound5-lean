import D1Bound5.SmallPairLightData28LeftCachedChunk00
import D1Bound5.SmallPairLightData28LeftCachedChunk01
import D1Bound5.SmallPairLightData28LeftCachedChunk02
import D1Bound5.SmallPairLightData28LeftCachedChunk03
import D1Bound5.SmallPairLightData28LeftCachedChunk04

namespace D1Bound5.PairLightPrepared28
set_option maxRecDepth 100000
set_option maxHeartbeats 0

noncomputable
def leftCached : List PairLightCachedVertex := leftCachedChunk00 ++ leftCachedChunk01 ++ leftCachedChunk02 ++ leftCachedChunk03 ++ leftCachedChunk04

end D1Bound5.PairLightPrepared28
