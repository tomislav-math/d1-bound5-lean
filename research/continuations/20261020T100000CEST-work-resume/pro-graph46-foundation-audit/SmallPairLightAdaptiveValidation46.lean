import D1Bound5.SmallPairLightAdaptiveData46

namespace D1Bound5.PairLightAdaptivePrepared46
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared46.leftCached.map Prod.fst = PairLightPrepared46.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared46.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared46.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared46.rightCached.map Prod.fst = PairLightPrepared46.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared46.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared46.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared46
