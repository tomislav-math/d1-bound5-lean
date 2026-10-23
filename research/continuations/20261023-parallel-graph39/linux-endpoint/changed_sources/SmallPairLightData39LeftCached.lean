import D1Bound5.SmallPairLightData39LeftCachedChunk00
import D1Bound5.SmallPairLightData39LeftCachedChunk01
import D1Bound5.SmallPairLightData39LeftCachedChunk02
import D1Bound5.SmallPairLightData39LeftCachedChunk03

namespace D1Bound5.PairLightPrepared39
set_option autoImplicit false

noncomputable
def leftCached : List PairLightCachedVertex :=
  leftCachedChunk00 ++ leftCachedChunk01 ++ leftCachedChunk02 ++ leftCachedChunk03

end D1Bound5.PairLightPrepared39
