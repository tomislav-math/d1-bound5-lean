import D1Bound5.SmallPairLightData35

namespace D1Bound5.PairLightPrepared35
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem right_coverage_checked :
    decide (rightCached.map Prod.fst = rightVertices) = true := by
  decide +kernel

theorem right_signatures_checked :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true := by
  decide +kernel

theorem right_independent_checked :
    pairLightSelectedFloorIndependentBool 1 2 sieve rightCached rightRows = true := by
  decide +kernel

theorem right_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 2 sieve
      rightVertices rightCached rightRows = true := by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨right_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨right_signatures_checked, right_independent_checked⟩⟩

end D1Bound5.PairLightPrepared35
