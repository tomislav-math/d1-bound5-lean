import D1Bound5.SmallPairLightAdaptiveData19

namespace D1Bound5.PairLightAdaptivePrepared19
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared19.leftCached.map Prod.fst = PairLightPrepared19.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared19.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared19.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared19.rightCached.map Prod.fst = PairLightPrepared19.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared19.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared19.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared19
