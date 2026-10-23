import D1Bound5.SmallPairPureClosure23
import D1Bound5.PairLightClosureBridge
import D1Bound5.SmallPairGraphClosure23Coverage

namespace D1Bound5.PairLightClosurePrepared23
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem a_eq : a = pairLightCoordinates smallPairA_23 := by rfl
theorem b_eq : b = pairLightCoordinates smallPairB_23 := by rfl
theorem anchorRoot_eq : anchorRoot = pairLightCoordinates PairGraphPrepared23.anchorRoot := by rfl
theorem vertices_eq : vertices = smallPairClosure_23.map pairLightCoordinates := by rfl
theorem witnesses_eq : witnesses = PairGraphPrepared23.witnesses.map pairLightRootWitnessCoordinates := by rfl
theorem destinations_eq : destinations = PairGraphPrepared23.destinations := by rfl

theorem original_witnesses_checked :
    pairIndexedWitnessesCheckedBool smallPairA_23 smallPairB_23 PairGraphPrepared23.anchorRoot
      (10^1100) smallPairClosure_23 PairGraphPrepared23.witnesses PairGraphPrepared23.destinations = true := by
  have hcheck : pairLightIndexedWitnessesCheckedBool 1 1
      (pairLightCoordinates smallPairA_23) (pairLightCoordinates smallPairB_23)
      (pairLightCoordinates PairGraphPrepared23.anchorRoot) (10^1100)
      (smallPairClosure_23.map pairLightCoordinates)
      (PairGraphPrepared23.witnesses.map pairLightRootWitnessCoordinates) PairGraphPrepared23.destinations = true := by
    rw [← a_eq, ← b_eq, ← anchorRoot_eq, ← vertices_eq, ← witnesses_eq, ← destinations_eq]
    exact all_checked
  exact (pairLightIndexedWitnessesCheckedBool_eq smallPairA_23 smallPairB_23
    PairGraphPrepared23.anchorRoot (10^1100) smallPairClosure_23
    PairGraphPrepared23.witnesses PairGraphPrepared23.destinations).symm.trans hcheck

theorem original_indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_23 smallPairB_23 PairGraphPrepared23.anchorRoot
      (10^1100) smallPairClosure_23 PairGraphPrepared23.witnesses PairGraphPrepared23.destinations = true :=
  pairClosureIndexedWitnessBool_of_checked_parts smallPairA_23 smallPairB_23
    PairGraphPrepared23.anchorRoot (10^1100) smallPairClosure_23
    PairGraphPrepared23.witnesses PairGraphPrepared23.destinations
    PairGraphPrepared23.indexed_coverage_checked original_witnesses_checked

end D1Bound5.PairLightClosurePrepared23
