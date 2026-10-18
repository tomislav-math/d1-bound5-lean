import D1Bound5.SmallPairCachedData41

namespace D1Bound5.PairCachedPilot41
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_certificate_checked :
    pairCachedIndependentCertificateBool smallPairSieve_1_2
      (pairSplitByMask smallPairPilotLarge_41 smallPairPilotColors_41).1
      (pairSplitByMask cachedVertices smallPairPilotColors_41).1 = true := by
  decide +kernel

/-- The existing independent-class predicate, derived from the cached certificate. -/
theorem left_checked :
    pairIndependentBool smallPairSieve_1_2
      (pairSplitByMask smallPairPilotLarge_41 smallPairPilotColors_41).1 = true :=
  pairIndependentBool_of_cached_certificate smallPairSieve_1_2
    (pairSplitByMask smallPairPilotLarge_41 smallPairPilotColors_41).1
    (pairSplitByMask cachedVertices smallPairPilotColors_41).1
    left_certificate_checked

end D1Bound5.PairCachedPilot41
