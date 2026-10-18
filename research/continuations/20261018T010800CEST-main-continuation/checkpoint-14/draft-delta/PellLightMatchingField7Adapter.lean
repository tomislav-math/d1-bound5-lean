import D1Bound5.PellLightMatchingBridge
import D1Bound5.PellLightMatchingField7

namespace D1Bound5.PellMatchingLightPilot7
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

def pellMagnitudes_7 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7

def pellMasks_7 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7.map pellLightMasksToOriginal

def pellWitnesses_7 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7

theorem pellMasks_7_valid : ∀ m ∈ pellMasks_7, m.Valid 7 := by
  exact pellLightMasks_valid 7 PellMatchingLightProduction.pellMasks_7 PellMatchingLightProduction.pellMasks_7_valid

theorem pellMatching_7_checked :
    pellMatchingCheck pellMasks_7 pellMagnitudes_7 pellWitnesses_7 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7
    PellMatchingLightProduction.pellMagnitudes_7 PellMatchingLightProduction.pellWitnesses_7).symm.trans
      PellMatchingLightProduction.pellMatching_7_checked

theorem pellMagnitudes_7_large : ∀ x ∈ pellMagnitudes_7, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7 PellMatchingLightProduction.pellMagnitudes_7_large

def pellGraphCertificate_7 : PellMatchingCertificate 7 where
  magnitudes := pellMagnitudes_7
  masks := pellMasks_7
  witnesses := pellWitnesses_7
  masks_valid := pellMasks_7_valid
  checked := pellMatching_7_checked
  large := pellMagnitudes_7_large

end D1Bound5.PellMatchingLightPilot7
