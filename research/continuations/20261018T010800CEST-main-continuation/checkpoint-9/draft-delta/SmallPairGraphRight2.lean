import D1Bound5.SmallPairGraphInputs2
import D1Bound5.PairCachedIntegerObstruction

namespace D1Bound5.PairGraphPrepared2
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_certificate_checked :
    pairCachedIntegerIndependentCertificateBool smallPairSieve_0_1
      (pairSplitByMask smallPairLarge_2 colors).2
      (pairSplitByMask cachedVertices colors).2 = true := by
  decide +kernel

theorem right_checked :
    pairIndependentBool smallPairSieve_0_1
      (pairSplitByMask smallPairLarge_2 colors).2 = true :=
  pairIndependentBool_of_cached_integer_certificate (by decide) smallPairSieve_0_1
    (pairSplitByMask smallPairLarge_2 colors).2
    (pairSplitByMask cachedVertices colors).2 right_certificate_checked

end D1Bound5.PairGraphPrepared2
