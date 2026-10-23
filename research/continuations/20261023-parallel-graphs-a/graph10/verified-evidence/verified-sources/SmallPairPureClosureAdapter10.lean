import D1Bound5.SmallPairPureClosure10
import D1Bound5.PairLightClosureBridge
import D1Bound5.SmallPairGraphClosure10Coverage

namespace D1Bound5.PairLightClosurePrepared10
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem a_eq : a = pairLightCoordinates smallPairA_10 := by rfl
theorem b_eq : b = pairLightCoordinates smallPairB_10 := by rfl
theorem anchorRoot_eq : anchorRoot = pairLightCoordinates PairGraphPrepared10.anchorRoot := by rfl
theorem vertices_eq : vertices = smallPairClosure_10.map pairLightCoordinates := by rfl
theorem witnesses_eq : witnesses = PairGraphPrepared10.witnesses.map pairLightRootWitnessCoordinates := by rfl
theorem destinations_eq : destinations = PairGraphPrepared10.destinations := by rfl

theorem original_witnesses_checked :
    pairIndexedWitnessesCheckedBool smallPairA_10 smallPairB_10 PairGraphPrepared10.anchorRoot
      (10^1100) smallPairClosure_10 PairGraphPrepared10.witnesses PairGraphPrepared10.destinations = true := by
  have hcheck : pairLightIndexedWitnessesCheckedBool 0 1
      (pairLightCoordinates smallPairA_10) (pairLightCoordinates smallPairB_10)
      (pairLightCoordinates PairGraphPrepared10.anchorRoot) (10^1100)
      (smallPairClosure_10.map pairLightCoordinates)
      (PairGraphPrepared10.witnesses.map pairLightRootWitnessCoordinates) PairGraphPrepared10.destinations = true := by
    rw [← a_eq, ← b_eq, ← anchorRoot_eq, ← vertices_eq, ← witnesses_eq, ← destinations_eq]
    exact all_checked
  exact (pairLightIndexedWitnessesCheckedBool_eq smallPairA_10 smallPairB_10
    PairGraphPrepared10.anchorRoot (10^1100) smallPairClosure_10
    PairGraphPrepared10.witnesses PairGraphPrepared10.destinations).symm.trans hcheck

theorem original_indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_10 smallPairB_10 PairGraphPrepared10.anchorRoot
      (10^1100) smallPairClosure_10 PairGraphPrepared10.witnesses PairGraphPrepared10.destinations = true :=
  pairClosureIndexedWitnessBool_of_checked_parts smallPairA_10 smallPairB_10
    PairGraphPrepared10.anchorRoot (10^1100) smallPairClosure_10
    PairGraphPrepared10.witnesses PairGraphPrepared10.destinations
    PairGraphPrepared10.indexed_coverage_checked original_witnesses_checked

end D1Bound5.PairLightClosurePrepared10
