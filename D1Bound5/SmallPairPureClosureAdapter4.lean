import D1Bound5.SmallPairPureClosure4
import D1Bound5.PairLightClosureBridge
import D1Bound5.SmallPairGraphClosure4Coverage

namespace D1Bound5.PairLightClosurePrepared4
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem a_eq : a = pairLightCoordinates smallPairA_4 := by rfl
theorem b_eq : b = pairLightCoordinates smallPairB_4 := by rfl
theorem anchorRoot_eq : anchorRoot = pairLightCoordinates PairGraphPrepared4.anchorRoot := by rfl
theorem vertices_eq : vertices = smallPairClosure_4.map pairLightCoordinates := by rfl
theorem witnesses_eq : witnesses = PairGraphPrepared4.witnesses.map pairLightRootWitnessCoordinates := by rfl
theorem destinations_eq : destinations = PairGraphPrepared4.destinations := by rfl

theorem original_witnesses_checked :
    pairIndexedWitnessesCheckedBool smallPairA_4 smallPairB_4 PairGraphPrepared4.anchorRoot
      (10^1100) smallPairClosure_4 PairGraphPrepared4.witnesses PairGraphPrepared4.destinations = true := by
  have hcheck : pairLightIndexedWitnessesCheckedBool 0 1
      (pairLightCoordinates smallPairA_4) (pairLightCoordinates smallPairB_4)
      (pairLightCoordinates PairGraphPrepared4.anchorRoot) (10^1100)
      (smallPairClosure_4.map pairLightCoordinates)
      (PairGraphPrepared4.witnesses.map pairLightRootWitnessCoordinates) PairGraphPrepared4.destinations = true := by
    rw [← a_eq, ← b_eq, ← anchorRoot_eq, ← vertices_eq, ← witnesses_eq, ← destinations_eq]
    exact all_checked
  exact (pairLightIndexedWitnessesCheckedBool_eq smallPairA_4 smallPairB_4
    PairGraphPrepared4.anchorRoot (10^1100) smallPairClosure_4
    PairGraphPrepared4.witnesses PairGraphPrepared4.destinations).symm.trans hcheck

theorem original_indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_4 smallPairB_4 PairGraphPrepared4.anchorRoot
      (10^1100) smallPairClosure_4 PairGraphPrepared4.witnesses PairGraphPrepared4.destinations = true :=
  pairClosureIndexedWitnessBool_of_checked_parts smallPairA_4 smallPairB_4
    PairGraphPrepared4.anchorRoot (10^1100) smallPairClosure_4
    PairGraphPrepared4.witnesses PairGraphPrepared4.destinations
    PairGraphPrepared4.indexed_coverage_checked original_witnesses_checked

end D1Bound5.PairLightClosurePrepared4
