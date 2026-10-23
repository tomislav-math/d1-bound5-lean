import D1Bound5.SmallPairLightAdaptiveData36

namespace D1Bound5.PairLightAdaptivePrepared36
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared36.leftCached.map Prod.fst = PairLightPrepared36.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared36.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared36.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared36.rightCached.map Prod.fst = PairLightPrepared36.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared36.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared36.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared36
