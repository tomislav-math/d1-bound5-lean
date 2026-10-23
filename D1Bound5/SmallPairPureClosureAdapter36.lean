import D1Bound5.SmallPairPureClosure36
import D1Bound5.PairLightClosureBridge
import D1Bound5.SmallPairGraphClosure36Coverage

namespace D1Bound5.PairLightClosurePrepared36
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem a_eq : a = pairLightCoordinates smallPairA_36 := by rfl
theorem b_eq : b = pairLightCoordinates smallPairB_36 := by rfl
theorem anchorRoot_eq : anchorRoot = pairLightCoordinates PairGraphPrepared36.anchorRoot := by rfl
theorem vertices_eq : vertices = smallPairClosure_36.map pairLightCoordinates := by rfl
theorem witnesses_eq : witnesses = PairGraphPrepared36.witnesses.map pairLightRootWitnessCoordinates := by rfl
theorem destinations_eq : destinations = PairGraphPrepared36.destinations := by rfl

theorem original_witnesses_checked :
    pairIndexedWitnessesCheckedBool smallPairA_36 smallPairB_36 PairGraphPrepared36.anchorRoot
      (10^1100) smallPairClosure_36 PairGraphPrepared36.witnesses PairGraphPrepared36.destinations = true := by
  have hcheck : pairLightIndexedWitnessesCheckedBool 1 2
      (pairLightCoordinates smallPairA_36) (pairLightCoordinates smallPairB_36)
      (pairLightCoordinates PairGraphPrepared36.anchorRoot) (10^1100)
      (smallPairClosure_36.map pairLightCoordinates)
      (PairGraphPrepared36.witnesses.map pairLightRootWitnessCoordinates) PairGraphPrepared36.destinations = true := by
    rw [← a_eq, ← b_eq, ← anchorRoot_eq, ← vertices_eq, ← witnesses_eq, ← destinations_eq]
    exact all_checked
  exact (pairLightIndexedWitnessesCheckedBool_eq smallPairA_36 smallPairB_36
    PairGraphPrepared36.anchorRoot (10^1100) smallPairClosure_36
    PairGraphPrepared36.witnesses PairGraphPrepared36.destinations).symm.trans hcheck

theorem original_indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_36 smallPairB_36 PairGraphPrepared36.anchorRoot
      (10^1100) smallPairClosure_36 PairGraphPrepared36.witnesses PairGraphPrepared36.destinations = true :=
  pairClosureIndexedWitnessBool_of_checked_parts smallPairA_36 smallPairB_36
    PairGraphPrepared36.anchorRoot (10^1100) smallPairClosure_36
    PairGraphPrepared36.witnesses PairGraphPrepared36.destinations
    PairGraphPrepared36.indexed_coverage_checked original_witnesses_checked

end D1Bound5.PairLightClosurePrepared36
