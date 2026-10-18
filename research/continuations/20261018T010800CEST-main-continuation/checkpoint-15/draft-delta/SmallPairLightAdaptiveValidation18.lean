import D1Bound5.SmallPairLightAdaptiveData18

namespace D1Bound5.PairLightAdaptivePrepared18
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem left_coverage_checked :
    decide (PairLightPrepared18.leftCached.map Prod.fst = PairLightPrepared18.leftVertices) = true := by
  decide +kernel

theorem left_signatures_checked :
    (PairLightPrepared18.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared18.sieve x.1)) = true := by
  decide +kernel

theorem right_coverage_checked :
    decide (PairLightPrepared18.rightCached.map Prod.fst = PairLightPrepared18.rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (PairLightPrepared18.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared18.sieve x.1)) = true := by
  decide +kernel


end D1Bound5.PairLightAdaptivePrepared18
