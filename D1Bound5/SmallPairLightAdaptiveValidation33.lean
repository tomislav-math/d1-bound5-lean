import D1Bound5.SmallPairLightAdaptiveData33

namespace D1Bound5.PairLightAdaptivePrepared33
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared33.leftCached.map Prod.fst = PairLightPrepared33.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared33.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared33.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared33.rightCached.map Prod.fst = PairLightPrepared33.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared33.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared33.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared33
