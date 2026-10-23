import D1Bound5.SmallPairLightData39RightCachedChunk00
import D1Bound5.SmallPairLightData39RightCachedChunk01
import D1Bound5.SmallPairLightData39RightCachedChunk02
import D1Bound5.SmallPairLightData39RightCachedChunk03

namespace D1Bound5.PairLightPrepared39
set_option autoImplicit false

noncomputable
def rightCached : List PairLightCachedVertex :=
  rightCachedChunk00 ++ rightCachedChunk01 ++ rightCachedChunk02 ++ rightCachedChunk03

end D1Bound5.PairLightPrepared39
