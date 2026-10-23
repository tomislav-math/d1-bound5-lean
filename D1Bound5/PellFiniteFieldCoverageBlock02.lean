import D1Bound5.PellFiniteFieldCoverageLight

namespace D1Bound5
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

/-- Exact coverage of original indices 100 through 149. -/
theorem pellFieldCoverageBlock02_checked :
    ∀ k : Fin 50, PellFieldCoverageLightAt (100+k.val) := by
  decide +kernel

end D1Bound5
