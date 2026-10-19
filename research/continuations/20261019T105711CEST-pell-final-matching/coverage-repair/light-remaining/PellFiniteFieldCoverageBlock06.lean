import D1Bound5.PellFiniteFieldCoverageLight

namespace D1Bound5
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

/-- Exact coverage of original indices 300 through 349. -/
theorem pellFieldCoverageBlock06_checked :
    ∀ k : Fin 50, PellFieldCoverageLightAt (300+k.val) := by
  decide +kernel

end D1Bound5
