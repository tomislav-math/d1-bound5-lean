import D1Bound5.SmallPairLightAdaptiveData4

namespace D1Bound5.PairLightAdaptivePrepared4
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared4.leftCached.map Prod.fst = PairLightPrepared4.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared4.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared4.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared4.rightCached.map Prod.fst = PairLightPrepared4.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared4.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared4.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared4
