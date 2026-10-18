import D1Bound5.SmallPairLightAdaptiveData25

namespace D1Bound5.PairLightAdaptivePrepared25
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared25.leftCached.map Prod.fst = PairLightPrepared25.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared25.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared25.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared25.rightCached.map Prod.fst = PairLightPrepared25.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared25.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared25.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared25
