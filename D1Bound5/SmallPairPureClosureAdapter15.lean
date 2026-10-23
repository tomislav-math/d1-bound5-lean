import D1Bound5.SmallPairPureClosure15
import D1Bound5.PairLightClosureBridge
import D1Bound5.SmallPairGraphClosure15Coverage

namespace D1Bound5.PairLightClosurePrepared15
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem a_eq : a = pairLightCoordinates smallPairA_15 := by rfl
theorem b_eq : b = pairLightCoordinates smallPairB_15 := by rfl
theorem anchorRoot_eq : anchorRoot = pairLightCoordinates PairGraphPrepared15.anchorRoot := by rfl
theorem vertices_eq : vertices = smallPairClosure_15.map pairLightCoordinates := by rfl
theorem witnesses_eq : witnesses = PairGraphPrepared15.witnesses.map pairLightRootWitnessCoordinates := by rfl
theorem destinations_eq : destinations = PairGraphPrepared15.destinations := by rfl

theorem original_witnesses_checked :
    pairIndexedWitnessesCheckedBool smallPairA_15 smallPairB_15 PairGraphPrepared15.anchorRoot
      (10^1100) smallPairClosure_15 PairGraphPrepared15.witnesses PairGraphPrepared15.destinations = true := by
  have hcheck : pairLightIndexedWitnessesCheckedBool 0 2
      (pairLightCoordinates smallPairA_15) (pairLightCoordinates smallPairB_15)
      (pairLightCoordinates PairGraphPrepared15.anchorRoot) (10^1100)
      (smallPairClosure_15.map pairLightCoordinates)
      (PairGraphPrepared15.witnesses.map pairLightRootWitnessCoordinates) PairGraphPrepared15.destinations = true := by
    rw [← a_eq, ← b_eq, ← anchorRoot_eq, ← vertices_eq, ← witnesses_eq, ← destinations_eq]
    exact all_checked
  exact (pairLightIndexedWitnessesCheckedBool_eq smallPairA_15 smallPairB_15
    PairGraphPrepared15.anchorRoot (10^1100) smallPairClosure_15
    PairGraphPrepared15.witnesses PairGraphPrepared15.destinations).symm.trans hcheck

theorem original_indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_15 smallPairB_15 PairGraphPrepared15.anchorRoot
      (10^1100) smallPairClosure_15 PairGraphPrepared15.witnesses PairGraphPrepared15.destinations = true :=
  pairClosureIndexedWitnessBool_of_checked_parts smallPairA_15 smallPairB_15
    PairGraphPrepared15.anchorRoot (10^1100) smallPairClosure_15
    PairGraphPrepared15.witnesses PairGraphPrepared15.destinations
    PairGraphPrepared15.indexed_coverage_checked original_witnesses_checked

end D1Bound5.PairLightClosurePrepared15
