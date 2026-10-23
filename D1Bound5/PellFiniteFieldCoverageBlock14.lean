import D1Bound5.PellFiniteFieldCoverageLight

namespace D1Bound5
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

/-- Exact coverage of original indices 700 through 749. -/
theorem pellFieldCoverageBlock14_checked :
    ∀ k : Fin 50, PellFieldCoverageLightAt (700+k.val) := by
  decide +kernel

end D1Bound5
