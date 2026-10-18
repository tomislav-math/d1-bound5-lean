import D1Bound5.SmallPairLightAdaptiveData9

namespace D1Bound5.PairLightAdaptivePrepared9
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared9.leftCached.map Prod.fst = PairLightPrepared9.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared9.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared9.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared9.rightCached.map Prod.fst = PairLightPrepared9.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared9.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared9.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared9
