import D1Bound5.SmallPairPureClosure28
import D1Bound5.PairLightClosureBridge
import D1Bound5.SmallPairGraphClosure28Coverage

namespace D1Bound5.PairLightClosurePrepared28
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem a_eq : a = pairLightCoordinates smallPairA_28 := by rfl
theorem b_eq : b = pairLightCoordinates smallPairB_28 := by rfl
theorem anchorRoot_eq : anchorRoot = pairLightCoordinates PairGraphPrepared28.anchorRoot := by rfl
theorem vertices_eq : vertices = smallPairClosure_28.map pairLightCoordinates := by rfl
theorem witnesses_eq : witnesses = PairGraphPrepared28.witnesses.map pairLightRootWitnessCoordinates := by rfl
theorem destinations_eq : destinations = PairGraphPrepared28.destinations := by rfl

theorem original_witnesses_checked :
    pairIndexedWitnessesCheckedBool smallPairA_28 smallPairB_28 PairGraphPrepared28.anchorRoot
      (10^1100) smallPairClosure_28 PairGraphPrepared28.witnesses PairGraphPrepared28.destinations = true := by
  have hcheck : pairLightIndexedWitnessesCheckedBool 1 1
      (pairLightCoordinates smallPairA_28) (pairLightCoordinates smallPairB_28)
      (pairLightCoordinates PairGraphPrepared28.anchorRoot) (10^1100)
      (smallPairClosure_28.map pairLightCoordinates)
      (PairGraphPrepared28.witnesses.map pairLightRootWitnessCoordinates) PairGraphPrepared28.destinations = true := by
    rw [← a_eq, ← b_eq, ← anchorRoot_eq, ← vertices_eq, ← witnesses_eq, ← destinations_eq]
    exact all_checked
  exact (pairLightIndexedWitnessesCheckedBool_eq smallPairA_28 smallPairB_28
    PairGraphPrepared28.anchorRoot (10^1100) smallPairClosure_28
    PairGraphPrepared28.witnesses PairGraphPrepared28.destinations).symm.trans hcheck

theorem original_indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_28 smallPairB_28 PairGraphPrepared28.anchorRoot
      (10^1100) smallPairClosure_28 PairGraphPrepared28.witnesses PairGraphPrepared28.destinations = true :=
  pairClosureIndexedWitnessBool_of_checked_parts smallPairA_28 smallPairB_28
    PairGraphPrepared28.anchorRoot (10^1100) smallPairClosure_28
    PairGraphPrepared28.witnesses PairGraphPrepared28.destinations
    PairGraphPrepared28.indexed_coverage_checked original_witnesses_checked

end D1Bound5.PairLightClosurePrepared28
