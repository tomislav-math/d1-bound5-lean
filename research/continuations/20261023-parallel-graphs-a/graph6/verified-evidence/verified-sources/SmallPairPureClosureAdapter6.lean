import D1Bound5.SmallPairPureClosure6
import D1Bound5.PairLightClosureBridge
import D1Bound5.SmallPairGraphClosure6Coverage

namespace D1Bound5.PairLightClosurePrepared6
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem a_eq : a = pairLightCoordinates smallPairA_6 := by rfl
theorem b_eq : b = pairLightCoordinates smallPairB_6 := by rfl
theorem anchorRoot_eq : anchorRoot = pairLightCoordinates PairGraphPrepared6.anchorRoot := by rfl
theorem vertices_eq : vertices = smallPairClosure_6.map pairLightCoordinates := by rfl
theorem witnesses_eq : witnesses = PairGraphPrepared6.witnesses.map pairLightRootWitnessCoordinates := by rfl
theorem destinations_eq : destinations = PairGraphPrepared6.destinations := by rfl

theorem original_witnesses_checked :
    pairIndexedWitnessesCheckedBool smallPairA_6 smallPairB_6 PairGraphPrepared6.anchorRoot
      (10^1100) smallPairClosure_6 PairGraphPrepared6.witnesses PairGraphPrepared6.destinations = true := by
  have hcheck : pairLightIndexedWitnessesCheckedBool 0 1
      (pairLightCoordinates smallPairA_6) (pairLightCoordinates smallPairB_6)
      (pairLightCoordinates PairGraphPrepared6.anchorRoot) (10^1100)
      (smallPairClosure_6.map pairLightCoordinates)
      (PairGraphPrepared6.witnesses.map pairLightRootWitnessCoordinates) PairGraphPrepared6.destinations = true := by
    rw [← a_eq, ← b_eq, ← anchorRoot_eq, ← vertices_eq, ← witnesses_eq, ← destinations_eq]
    exact all_checked
  exact (pairLightIndexedWitnessesCheckedBool_eq smallPairA_6 smallPairB_6
    PairGraphPrepared6.anchorRoot (10^1100) smallPairClosure_6
    PairGraphPrepared6.witnesses PairGraphPrepared6.destinations).symm.trans hcheck

theorem original_indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_6 smallPairB_6 PairGraphPrepared6.anchorRoot
      (10^1100) smallPairClosure_6 PairGraphPrepared6.witnesses PairGraphPrepared6.destinations = true :=
  pairClosureIndexedWitnessBool_of_checked_parts smallPairA_6 smallPairB_6
    PairGraphPrepared6.anchorRoot (10^1100) smallPairClosure_6
    PairGraphPrepared6.witnesses PairGraphPrepared6.destinations
    PairGraphPrepared6.indexed_coverage_checked original_witnesses_checked

end D1Bound5.PairLightClosurePrepared6
