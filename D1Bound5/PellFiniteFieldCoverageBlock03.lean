import D1Bound5.PellFiniteFieldCoverageLight

namespace D1Bound5
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

/-- Exact coverage of original indices 150 through 199. -/
theorem pellFieldCoverageBlock03_checked :
    ∀ k : Fin 50, PellFieldCoverageLightAt (150+k.val) := by
  decide +kernel

end D1Bound5
