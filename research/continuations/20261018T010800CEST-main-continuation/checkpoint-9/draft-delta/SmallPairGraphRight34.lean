import D1Bound5.SmallPairGraphCachedData34
import D1Bound5.PairCachedFloorWitnesses
import D1Bound5.SmallPairFloorWitnessData34

namespace D1Bound5.PairGraphPrepared34
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_certificate_checked :
    pairCachedFloorIndependentCertificateBool smallPairSieve_1_2
      (pairSplitByMask smallPairLarge_34 colors).2
      (pairSplitByMask cachedVertices colors).2
      PairFloorWitness34.rightRows = true := by
  decide +kernel

theorem right_checked :
    pairIndependentBool smallPairSieve_1_2
      (pairSplitByMask smallPairLarge_34 colors).2 = true :=
  pairIndependentBool_of_cached_floor_certificate (by decide) smallPairSieve_1_2
    (pairSplitByMask smallPairLarge_34 colors).2
    (pairSplitByMask cachedVertices colors).2
    PairFloorWitness34.rightRows right_certificate_checked

end D1Bound5.PairGraphPrepared34
