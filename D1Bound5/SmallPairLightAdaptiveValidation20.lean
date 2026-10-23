import D1Bound5.SmallPairLightAdaptiveData20

namespace D1Bound5.PairLightAdaptivePrepared20
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared20.leftCached.map Prod.fst = PairLightPrepared20.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared20.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared20.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared20.rightCached.map Prod.fst = PairLightPrepared20.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared20.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared20.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared20
