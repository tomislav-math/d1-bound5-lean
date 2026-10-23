import D1Bound5.SmallPairPureClosure14
import D1Bound5.PairLightClosureBridge
import D1Bound5.SmallPairGraphClosure14Coverage

namespace D1Bound5.PairLightClosurePrepared14
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem a_eq : a = pairLightCoordinates smallPairA_14 := by rfl
theorem b_eq : b = pairLightCoordinates smallPairB_14 := by rfl
theorem anchorRoot_eq : anchorRoot = pairLightCoordinates PairGraphPrepared14.anchorRoot := by rfl
theorem vertices_eq : vertices = smallPairClosure_14.map pairLightCoordinates := by rfl
theorem witnesses_eq : witnesses = PairGraphPrepared14.witnesses.map pairLightRootWitnessCoordinates := by rfl
theorem destinations_eq : destinations = PairGraphPrepared14.destinations := by rfl

theorem original_witnesses_checked :
    pairIndexedWitnessesCheckedBool smallPairA_14 smallPairB_14 PairGraphPrepared14.anchorRoot
      (10^1100) smallPairClosure_14 PairGraphPrepared14.witnesses PairGraphPrepared14.destinations = true := by
  have hcheck : pairLightIndexedWitnessesCheckedBool 0 2
      (pairLightCoordinates smallPairA_14) (pairLightCoordinates smallPairB_14)
      (pairLightCoordinates PairGraphPrepared14.anchorRoot) (10^1100)
      (smallPairClosure_14.map pairLightCoordinates)
      (PairGraphPrepared14.witnesses.map pairLightRootWitnessCoordinates) PairGraphPrepared14.destinations = true := by
    rw [← a_eq, ← b_eq, ← anchorRoot_eq, ← vertices_eq, ← witnesses_eq, ← destinations_eq]
    exact all_checked
  exact (pairLightIndexedWitnessesCheckedBool_eq smallPairA_14 smallPairB_14
    PairGraphPrepared14.anchorRoot (10^1100) smallPairClosure_14
    PairGraphPrepared14.witnesses PairGraphPrepared14.destinations).symm.trans hcheck

theorem original_indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_14 smallPairB_14 PairGraphPrepared14.anchorRoot
      (10^1100) smallPairClosure_14 PairGraphPrepared14.witnesses PairGraphPrepared14.destinations = true :=
  pairClosureIndexedWitnessBool_of_checked_parts smallPairA_14 smallPairB_14
    PairGraphPrepared14.anchorRoot (10^1100) smallPairClosure_14
    PairGraphPrepared14.witnesses PairGraphPrepared14.destinations
    PairGraphPrepared14.indexed_coverage_checked original_witnesses_checked

end D1Bound5.PairLightClosurePrepared14
