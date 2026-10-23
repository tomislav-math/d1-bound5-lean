import D1Bound5.SmallPairPureClosure21
import D1Bound5.PairLightClosureBridge
import D1Bound5.SmallPairGraphClosure21Coverage

namespace D1Bound5.PairLightClosurePrepared21
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem a_eq : a = pairLightCoordinates smallPairA_21 := by rfl
theorem b_eq : b = pairLightCoordinates smallPairB_21 := by rfl
theorem anchorRoot_eq : anchorRoot = pairLightCoordinates PairGraphPrepared21.anchorRoot := by rfl
theorem vertices_eq : vertices = smallPairClosure_21.map pairLightCoordinates := by rfl
theorem witnesses_eq : witnesses = PairGraphPrepared21.witnesses.map pairLightRootWitnessCoordinates := by rfl
theorem destinations_eq : destinations = PairGraphPrepared21.destinations := by rfl

theorem original_witnesses_checked :
    pairIndexedWitnessesCheckedBool smallPairA_21 smallPairB_21 PairGraphPrepared21.anchorRoot
      (10^1100) smallPairClosure_21 PairGraphPrepared21.witnesses PairGraphPrepared21.destinations = true := by
  have hcheck : pairLightIndexedWitnessesCheckedBool 1 1
      (pairLightCoordinates smallPairA_21) (pairLightCoordinates smallPairB_21)
      (pairLightCoordinates PairGraphPrepared21.anchorRoot) (10^1100)
      (smallPairClosure_21.map pairLightCoordinates)
      (PairGraphPrepared21.witnesses.map pairLightRootWitnessCoordinates) PairGraphPrepared21.destinations = true := by
    rw [← a_eq, ← b_eq, ← anchorRoot_eq, ← vertices_eq, ← witnesses_eq, ← destinations_eq]
    exact all_checked
  exact (pairLightIndexedWitnessesCheckedBool_eq smallPairA_21 smallPairB_21
    PairGraphPrepared21.anchorRoot (10^1100) smallPairClosure_21
    PairGraphPrepared21.witnesses PairGraphPrepared21.destinations).symm.trans hcheck

theorem original_indexed_checked :
    pairClosureIndexedWitnessBool smallPairA_21 smallPairB_21 PairGraphPrepared21.anchorRoot
      (10^1100) smallPairClosure_21 PairGraphPrepared21.witnesses PairGraphPrepared21.destinations = true :=
  pairClosureIndexedWitnessBool_of_checked_parts smallPairA_21 smallPairB_21
    PairGraphPrepared21.anchorRoot (10^1100) smallPairClosure_21
    PairGraphPrepared21.witnesses PairGraphPrepared21.destinations
    PairGraphPrepared21.indexed_coverage_checked original_witnesses_checked

end D1Bound5.PairLightClosurePrepared21
