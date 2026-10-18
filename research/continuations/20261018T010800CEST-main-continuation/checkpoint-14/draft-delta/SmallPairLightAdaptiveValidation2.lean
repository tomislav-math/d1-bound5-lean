import D1Bound5.SmallPairLightAdaptiveData2

namespace D1Bound5.PairLightAdaptivePrepared2
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared2.leftCached.map Prod.fst = PairLightPrepared2.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared2.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared2.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared2.rightCached.map Prod.fst = PairLightPrepared2.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared2.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared2.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared2
