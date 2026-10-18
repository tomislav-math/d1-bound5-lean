import D1Bound5.SmallPairLiteralCachedData34
import D1Bound5.PairCachedFloorWitnesses
import D1Bound5.SmallPairFloorWitnessData34

namespace D1Bound5.PairLiteralPilot34
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_certificate_checked :
    pairCachedFloorIndependentCertificateBool smallPairSieve_1_2
      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).1
      leftCached PairFloorWitness34.leftRows = true := by
  decide +kernel

/-- Same original split-class target; the accepted generic checker is unchanged. -/
theorem left_checked :
    pairIndependentBool smallPairSieve_1_2
      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).1 = true :=
  pairIndependentBool_of_cached_floor_certificate (by decide) smallPairSieve_1_2
    (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).1
    leftCached PairFloorWitness34.leftRows left_certificate_checked

end D1Bound5.PairLiteralPilot34
