import D1Bound5.SmallPairPureClosure30
import D1Bound5.PairLightClosureBridge
import D1Bound5.SmallPairGraphClosure30Coverage

namespace D1Bound5.PairLightClosurePrepared30
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem a_eq : a = pairLightCoordinates smallPairA_30 := by rfl
theorem b_eq : b = pairLightCoordinates smallPairB_30 := by rfl
theorem anchorRoot_eq : anchorRoot = pairLightCoordinates PairGraphPrepared30.anchorRoot := by rfl
theorem vertices_eq : vertices = smallPairClosure_30.map pairLightCoordinates := by rfl
theorem witnesses_eq : witnesses = PairGraphPrepared30.witnesses.map pairLightRootWitnessCoordinates := by rfl
theorem destinations_eq : destinations = PairGraphPrepared30.destinations := by rfl

theorem original_witnesses_checked :
    pairIndexedWitnessesCheckedBool smallPairA_30 smallPairB_30 PairGraphPrepared30.anchorRoot
      (10^1100) smallPairClosure_30 PairGraphPrepared30.witnesses PairGraphPrepared30.destinations = true := by
  have hcheck : pairLightIndexedWitnessesCheckedBool 1 1
      (pairLightCoordinates smallPairA_30) (pairLightCoordinates smallPairB_30)
      (pairLightCoordinates PairGraphPrepared30.anchorRoot) (10^1100)
      (smallPairClosure_30.map pairLightCoordinates)
      (PairGraphPrepared30.witnesses.map pairLightRootWitnessCoordinates) PairGraphPrepared30.destinations = true := by
    rw [← a_eq, ← b_eq, ← anchorRoot_eq, ← vertices_eq, ← witnesses_eq, ← destinations_eq]
    exact all_checked
  exact (pairLightIndexedWitnessesCheckedBool_eq smallPairA_30 smallPairB_30
    PairGraphPrepared30.anchorRoot (10^1100) smallPairClosure_30
    PairGraphPrepared30.witnesses PairGraphPrepared30.destinations).symm.trans hcheck

theorem original_indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_30 smallPairB_30 PairGraphPrepared30.anchorRoot
      (10^1100) smallPairClosure_30 PairGraphPrepared30.witnesses PairGraphPrepared30.destinations = true :=
  pairClosureIndexedWitnessBool_of_checked_parts smallPairA_30 smallPairB_30
    PairGraphPrepared30.anchorRoot (10^1100) smallPairClosure_30
    PairGraphPrepared30.witnesses PairGraphPrepared30.destinations
    PairGraphPrepared30.indexed_coverage_checked original_witnesses_checked

end D1Bound5.PairLightClosurePrepared30
