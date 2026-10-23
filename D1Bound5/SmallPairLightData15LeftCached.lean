import D1Bound5.SmallPairLightData15LeftCachedChunk00
import D1Bound5.SmallPairLightData15LeftCachedChunk01
import D1Bound5.SmallPairLightData15LeftCachedChunk02
import D1Bound5.SmallPairLightData15LeftCachedChunk03
import D1Bound5.SmallPairLightData15LeftCachedChunk04

namespace D1Bound5.PairLightPrepared15
set_option maxRecDepth 100000
set_option maxHeartbeats 0

noncomputable
def leftCached : List PairLightCachedVertex := leftCachedChunk00 ++ leftCachedChunk01 ++ leftCachedChunk02 ++ leftCachedChunk03 ++ leftCachedChunk04

end D1Bound5.PairLightPrepared15
