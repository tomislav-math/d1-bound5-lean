import D1Bound5.SmallPairLightAdaptiveData43

namespace D1Bound5.PairLightAdaptivePrepared43
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared43.leftCached.map Prod.fst = PairLightPrepared43.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared43.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared43.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared43.rightCached.map Prod.fst = PairLightPrepared43.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared43.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared43.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared43
