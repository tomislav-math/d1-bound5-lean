import D1Bound5.SmallPairLightRightData34

namespace D1Bound5.PairLightRightPilot34
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Only the isolated arithmetic computation. Connection to the original
class requires the separately checked data equalities and exact bridge. -/
theorem right_certificate_checked :
    pairLightSelectedFloorIndependentCertificateBool 1 2 sieve
      rightVertices rightCached rightRows = true := by
  decide +kernel

end D1Bound5.PairLightRightPilot34
