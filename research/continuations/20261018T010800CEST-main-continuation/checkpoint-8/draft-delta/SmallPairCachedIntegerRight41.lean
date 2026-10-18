import D1Bound5.PairCachedIntegerObstruction
import D1Bound5.SmallPairCachedData41

namespace D1Bound5.PairCachedIntegerPilot41
open PairCachedPilot41
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_certificate_checked :
    pairCachedIntegerIndependentCertificateBool smallPairSieve_1_2
      (pairSplitByMask smallPairPilotLarge_41 smallPairPilotColors_41).2
      (pairSplitByMask cachedVertices smallPairPilotColors_41).2 = true := by
  decide +kernel

/-- The unchanged original independent-class predicate. -/
theorem right_checked :
    pairIndependentBool smallPairSieve_1_2
      (pairSplitByMask smallPairPilotLarge_41 smallPairPilotColors_41).2 = true :=
  pairIndependentBool_of_cached_integer_certificate (by decide) smallPairSieve_1_2
    (pairSplitByMask smallPairPilotLarge_41 smallPairPilotColors_41).2
    (pairSplitByMask cachedVertices smallPairPilotColors_41).2
    right_certificate_checked

end D1Bound5.PairCachedIntegerPilot41
