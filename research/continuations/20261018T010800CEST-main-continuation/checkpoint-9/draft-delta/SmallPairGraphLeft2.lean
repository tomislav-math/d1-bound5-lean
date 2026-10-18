import D1Bound5.SmallPairGraphInputs2
import D1Bound5.PairCachedIntegerObstruction

namespace D1Bound5.PairGraphPrepared2
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_certificate_checked :
    pairCachedIntegerIndependentCertificateBool smallPairSieve_0_1
      (pairSplitByMask smallPairLarge_2 colors).1
      (pairSplitByMask cachedVertices colors).1 = true := by
  decide +kernel

theorem left_checked :
    pairIndependentBool smallPairSieve_0_1
      (pairSplitByMask smallPairLarge_2 colors).1 = true :=
  pairIndependentBool_of_cached_integer_certificate (by decide) smallPairSieve_0_1
    (pairSplitByMask smallPairLarge_2 colors).1
    (pairSplitByMask cachedVertices colors).1 left_certificate_checked

end D1Bound5.PairGraphPrepared2
