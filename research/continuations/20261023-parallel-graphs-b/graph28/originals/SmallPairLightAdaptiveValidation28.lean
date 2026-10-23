import D1Bound5.SmallPairLightAdaptiveData28

namespace D1Bound5.PairLightAdaptivePrepared28
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared28.leftCached.map Prod.fst = PairLightPrepared28.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared28.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared28.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared28.rightCached.map Prod.fst = PairLightPrepared28.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared28.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared28.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared28
