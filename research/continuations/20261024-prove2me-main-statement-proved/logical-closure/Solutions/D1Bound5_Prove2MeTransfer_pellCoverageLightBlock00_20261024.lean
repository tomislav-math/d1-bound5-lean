import Mathlib.Tactic
import Definitions.Def_D1Bound5_PellFiniteFieldCoverageLight_Definitions

section
namespace D1Bound5
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

theorem _root_.solution : ∀ k : Fin 50, PellFieldCoverageLightAt (0+k.val) := by
  decide +kernel

end D1Bound5
end
