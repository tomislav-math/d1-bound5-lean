import D1Bound5.SmallPairPureClosure8
import D1Bound5.PairLightClosureBridge
import D1Bound5.SmallPairGraphClosure8Coverage

namespace D1Bound5.PairLightClosurePrepared8
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem a_eq : a = pairLightCoordinates smallPairA_8 := by rfl
theorem b_eq : b = pairLightCoordinates smallPairB_8 := by rfl
theorem anchorRoot_eq : anchorRoot = pairLightCoordinates PairGraphPrepared8.anchorRoot := by rfl
theorem vertices_eq : vertices = smallPairClosure_8.map pairLightCoordinates := by rfl
theorem witnesses_eq : witnesses = PairGraphPrepared8.witnesses.map pairLightRootWitnessCoordinates := by rfl
theorem destinations_eq : destinations = PairGraphPrepared8.destinations := by rfl

theorem original_witnesses_checked :
    pairIndexedWitnessesCheckedBool smallPairA_8 smallPairB_8 PairGraphPrepared8.anchorRoot
      (10^1100) smallPairClosure_8 PairGraphPrepared8.witnesses PairGraphPrepared8.destinations = true := by
  have hcheck : pairLightIndexedWitnessesCheckedBool 0 1
      (pairLightCoordinates smallPairA_8) (pairLightCoordinates smallPairB_8)
      (pairLightCoordinates PairGraphPrepared8.anchorRoot) (10^1100)
      (smallPairClosure_8.map pairLightCoordinates)
      (PairGraphPrepared8.witnesses.map pairLightRootWitnessCoordinates) PairGraphPrepared8.destinations = true := by
    rw [← a_eq, ← b_eq, ← anchorRoot_eq, ← vertices_eq, ← witnesses_eq, ← destinations_eq]
    exact all_checked
  exact (pairLightIndexedWitnessesCheckedBool_eq smallPairA_8 smallPairB_8
    PairGraphPrepared8.anchorRoot (10^1100) smallPairClosure_8
    PairGraphPrepared8.witnesses PairGraphPrepared8.destinations).symm.trans hcheck

theorem original_indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_8 smallPairB_8 PairGraphPrepared8.anchorRoot
      (10^1100) smallPairClosure_8 PairGraphPrepared8.witnesses PairGraphPrepared8.destinations = true :=
  pairClosureIndexedWitnessBool_of_checked_parts smallPairA_8 smallPairB_8
    PairGraphPrepared8.anchorRoot (10^1100) smallPairClosure_8
    PairGraphPrepared8.witnesses PairGraphPrepared8.destinations
    PairGraphPrepared8.indexed_coverage_checked original_witnesses_checked

end D1Bound5.PairLightClosurePrepared8
