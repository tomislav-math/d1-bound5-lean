import D1Bound5.PellLightMatchingBridge
import D1Bound5.PellLightMatchingPilot
import D1Bound5.PellLightMatchingField7
import D1Bound5.PellLightMatchingField23
import D1Bound5.PellLightMatchingField31
import D1Bound5.PellLightMatchingField47
import D1Bound5.PellLightMatchingField71
import D1Bound5.PellLightMatchingField79
import D1Bound5.PellLightMatchingField103
import D1Bound5.PellLightMatchingField119
import D1Bound5.PellLightMatchingField127
import D1Bound5.PellLightMatchingField151
import D1Bound5.PellLightMatchingField167
import D1Bound5.PellLightMatchingField191
import D1Bound5.PellLightMatchingField199
import D1Bound5.PellLightMatchingField223
import D1Bound5.PellLightMatchingField239
import D1Bound5.PellLightMatchingField263
import D1Bound5.PellLightMatchingField271
import D1Bound5.PellLightMatchingField287
import D1Bound5.PellLightMatchingField311
import D1Bound5.PellLightMatchingField359
import D1Bound5.PellLightMatchingField367
import D1Bound5.PellLightMatchingField383
import D1Bound5.PellLightMatchingField391
import D1Bound5.PellLightMatchingField431
import D1Bound5.PellLightMatchingField439
import D1Bound5.PellLightMatchingField463
import D1Bound5.PellLightMatchingField479
import D1Bound5.PellLightMatchingField487
import D1Bound5.PellLightMatchingField503
import D1Bound5.PellLightMatchingField511
import D1Bound5.PellLightMatchingField527
import D1Bound5.PellLightMatchingField599
import D1Bound5.PellLightMatchingField607
import D1Bound5.PellLightMatchingField623
import D1Bound5.PellLightMatchingField631
import D1Bound5.PellLightMatchingField647
import D1Bound5.PellLightMatchingField679
import D1Bound5.PellLightMatchingField719
import D1Bound5.PellLightMatchingField727
import D1Bound5.PellLightMatchingField743
import D1Bound5.PellLightMatchingField751
import D1Bound5.PellLightMatchingField823
import D1Bound5.PellLightMatchingField839
import D1Bound5.PellLightMatchingField863
import D1Bound5.PellLightMatchingField887
import D1Bound5.PellLightMatchingField911
import D1Bound5.PellLightMatchingField919
import D1Bound5.PellLightMatchingField959
import D1Bound5.PellLightMatchingData4
import D1Bound5.PellLightMatchingData5
import D1Bound5.PellLightMatchingData6
import D1Bound5.PellLightMatchingData7
import D1Bound5.PellLightMatchingData8
import D1Bound5.PellLightMatchingData9
import D1Bound5.PellLightMatchingData10
import D1Bound5.PellLightMatchingData11
import D1Bound5.PellLightMatchingData12
import D1Bound5.PellLightMatchingData13
import D1Bound5.PellLightMatchingData14
import D1Bound5.PellLightMatchingData15
import D1Bound5.PellLightMatchingData16
import D1Bound5.PellLightMatchingData17
import D1Bound5.PellLightMatchingData18
import D1Bound5.PellLightMatchingData19
import D1Bound5.PellLightMatchingData20
import D1Bound5.PellLightMatchingData21
import D1Bound5.PellLightMatchingData22
import D1Bound5.PellLightMatchingData23
import D1Bound5.PellLightMatchingData24
import D1Bound5.PellLightMatchingData25
import D1Bound5.PellLightMatchingData26

namespace D1Bound5
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

def pellMagnitudes_4519 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4519

def pellMasks_4519 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4519.map pellLightMasksToOriginal

def pellWitnesses_4519 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4519

theorem pellMasks_4519_valid : ∀ m ∈ pellMasks_4519, m.Valid 4519 := by
  exact pellLightMasks_valid 4519 PellMatchingLightProduction.pellMasks_4519 PellMatchingLightProduction.pellMasks_4519_valid

theorem pellMatching_4519_checked :
    pellMatchingCheck pellMasks_4519 pellMagnitudes_4519 pellWitnesses_4519 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4519
    PellMatchingLightProduction.pellMagnitudes_4519 PellMatchingLightProduction.pellWitnesses_4519).symm.trans
      PellMatchingLightProduction.pellMatching_4519_checked

theorem pellMagnitudes_4519_large : ∀ x ∈ pellMagnitudes_4519, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4519 PellMatchingLightProduction.pellMagnitudes_4519_large

def pellGraphCertificate_4519 : PellMatchingCertificate 4519 where
  magnitudes := pellMagnitudes_4519
  masks := pellMasks_4519
  witnesses := pellWitnesses_4519
  masks_valid := pellMasks_4519_valid
  checked := pellMatching_4519_checked
  large := pellMagnitudes_4519_large

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

def pellMagnitudes_23 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_23

def pellMasks_23 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_23.map pellLightMasksToOriginal

def pellWitnesses_23 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_23

theorem pellMasks_23_valid : ∀ m ∈ pellMasks_23, m.Valid 23 := by
  exact pellLightMasks_valid 23 PellMatchingLightProduction.pellMasks_23 PellMatchingLightProduction.pellMasks_23_valid

theorem pellMatching_23_checked :
    pellMatchingCheck pellMasks_23 pellMagnitudes_23 pellWitnesses_23 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_23
    PellMatchingLightProduction.pellMagnitudes_23 PellMatchingLightProduction.pellWitnesses_23).symm.trans
      PellMatchingLightProduction.pellMatching_23_checked

theorem pellMagnitudes_23_large : ∀ x ∈ pellMagnitudes_23, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_23 PellMatchingLightProduction.pellMagnitudes_23_large

def pellGraphCertificate_23 : PellMatchingCertificate 23 where
  magnitudes := pellMagnitudes_23
  masks := pellMasks_23
  witnesses := pellWitnesses_23
  masks_valid := pellMasks_23_valid
  checked := pellMatching_23_checked
  large := pellMagnitudes_23_large

def pellMagnitudes_31 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_31

def pellMasks_31 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_31.map pellLightMasksToOriginal

def pellWitnesses_31 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_31

theorem pellMasks_31_valid : ∀ m ∈ pellMasks_31, m.Valid 31 := by
  exact pellLightMasks_valid 31 PellMatchingLightProduction.pellMasks_31 PellMatchingLightProduction.pellMasks_31_valid

theorem pellMatching_31_checked :
    pellMatchingCheck pellMasks_31 pellMagnitudes_31 pellWitnesses_31 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_31
    PellMatchingLightProduction.pellMagnitudes_31 PellMatchingLightProduction.pellWitnesses_31).symm.trans
      PellMatchingLightProduction.pellMatching_31_checked

theorem pellMagnitudes_31_large : ∀ x ∈ pellMagnitudes_31, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_31 PellMatchingLightProduction.pellMagnitudes_31_large

def pellGraphCertificate_31 : PellMatchingCertificate 31 where
  magnitudes := pellMagnitudes_31
  masks := pellMasks_31
  witnesses := pellWitnesses_31
  masks_valid := pellMasks_31_valid
  checked := pellMatching_31_checked
  large := pellMagnitudes_31_large

def pellMagnitudes_47 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_47

def pellMasks_47 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_47.map pellLightMasksToOriginal

def pellWitnesses_47 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_47

theorem pellMasks_47_valid : ∀ m ∈ pellMasks_47, m.Valid 47 := by
  exact pellLightMasks_valid 47 PellMatchingLightProduction.pellMasks_47 PellMatchingLightProduction.pellMasks_47_valid

theorem pellMatching_47_checked :
    pellMatchingCheck pellMasks_47 pellMagnitudes_47 pellWitnesses_47 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_47
    PellMatchingLightProduction.pellMagnitudes_47 PellMatchingLightProduction.pellWitnesses_47).symm.trans
      PellMatchingLightProduction.pellMatching_47_checked

theorem pellMagnitudes_47_large : ∀ x ∈ pellMagnitudes_47, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_47 PellMatchingLightProduction.pellMagnitudes_47_large

def pellGraphCertificate_47 : PellMatchingCertificate 47 where
  magnitudes := pellMagnitudes_47
  masks := pellMasks_47
  witnesses := pellWitnesses_47
  masks_valid := pellMasks_47_valid
  checked := pellMatching_47_checked
  large := pellMagnitudes_47_large

def pellMagnitudes_71 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_71

def pellMasks_71 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_71.map pellLightMasksToOriginal

def pellWitnesses_71 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_71

theorem pellMasks_71_valid : ∀ m ∈ pellMasks_71, m.Valid 71 := by
  exact pellLightMasks_valid 71 PellMatchingLightProduction.pellMasks_71 PellMatchingLightProduction.pellMasks_71_valid

theorem pellMatching_71_checked :
    pellMatchingCheck pellMasks_71 pellMagnitudes_71 pellWitnesses_71 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_71
    PellMatchingLightProduction.pellMagnitudes_71 PellMatchingLightProduction.pellWitnesses_71).symm.trans
      PellMatchingLightProduction.pellMatching_71_checked

theorem pellMagnitudes_71_large : ∀ x ∈ pellMagnitudes_71, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_71 PellMatchingLightProduction.pellMagnitudes_71_large

def pellGraphCertificate_71 : PellMatchingCertificate 71 where
  magnitudes := pellMagnitudes_71
  masks := pellMasks_71
  witnesses := pellWitnesses_71
  masks_valid := pellMasks_71_valid
  checked := pellMatching_71_checked
  large := pellMagnitudes_71_large

def pellMagnitudes_79 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_79

def pellMasks_79 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_79.map pellLightMasksToOriginal

def pellWitnesses_79 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_79

theorem pellMasks_79_valid : ∀ m ∈ pellMasks_79, m.Valid 79 := by
  exact pellLightMasks_valid 79 PellMatchingLightProduction.pellMasks_79 PellMatchingLightProduction.pellMasks_79_valid

theorem pellMatching_79_checked :
    pellMatchingCheck pellMasks_79 pellMagnitudes_79 pellWitnesses_79 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_79
    PellMatchingLightProduction.pellMagnitudes_79 PellMatchingLightProduction.pellWitnesses_79).symm.trans
      PellMatchingLightProduction.pellMatching_79_checked

theorem pellMagnitudes_79_large : ∀ x ∈ pellMagnitudes_79, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_79 PellMatchingLightProduction.pellMagnitudes_79_large

def pellGraphCertificate_79 : PellMatchingCertificate 79 where
  magnitudes := pellMagnitudes_79
  masks := pellMasks_79
  witnesses := pellWitnesses_79
  masks_valid := pellMasks_79_valid
  checked := pellMatching_79_checked
  large := pellMagnitudes_79_large

def pellMagnitudes_103 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_103

def pellMasks_103 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_103.map pellLightMasksToOriginal

def pellWitnesses_103 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_103

theorem pellMasks_103_valid : ∀ m ∈ pellMasks_103, m.Valid 103 := by
  exact pellLightMasks_valid 103 PellMatchingLightProduction.pellMasks_103 PellMatchingLightProduction.pellMasks_103_valid

theorem pellMatching_103_checked :
    pellMatchingCheck pellMasks_103 pellMagnitudes_103 pellWitnesses_103 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_103
    PellMatchingLightProduction.pellMagnitudes_103 PellMatchingLightProduction.pellWitnesses_103).symm.trans
      PellMatchingLightProduction.pellMatching_103_checked

theorem pellMagnitudes_103_large : ∀ x ∈ pellMagnitudes_103, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_103 PellMatchingLightProduction.pellMagnitudes_103_large

def pellGraphCertificate_103 : PellMatchingCertificate 103 where
  magnitudes := pellMagnitudes_103
  masks := pellMasks_103
  witnesses := pellWitnesses_103
  masks_valid := pellMasks_103_valid
  checked := pellMatching_103_checked
  large := pellMagnitudes_103_large

def pellMagnitudes_119 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_119

def pellMasks_119 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_119.map pellLightMasksToOriginal

def pellWitnesses_119 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_119

theorem pellMasks_119_valid : ∀ m ∈ pellMasks_119, m.Valid 119 := by
  exact pellLightMasks_valid 119 PellMatchingLightProduction.pellMasks_119 PellMatchingLightProduction.pellMasks_119_valid

theorem pellMatching_119_checked :
    pellMatchingCheck pellMasks_119 pellMagnitudes_119 pellWitnesses_119 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_119
    PellMatchingLightProduction.pellMagnitudes_119 PellMatchingLightProduction.pellWitnesses_119).symm.trans
      PellMatchingLightProduction.pellMatching_119_checked

theorem pellMagnitudes_119_large : ∀ x ∈ pellMagnitudes_119, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_119 PellMatchingLightProduction.pellMagnitudes_119_large

def pellGraphCertificate_119 : PellMatchingCertificate 119 where
  magnitudes := pellMagnitudes_119
  masks := pellMasks_119
  witnesses := pellWitnesses_119
  masks_valid := pellMasks_119_valid
  checked := pellMatching_119_checked
  large := pellMagnitudes_119_large

def pellMagnitudes_127 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_127

def pellMasks_127 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_127.map pellLightMasksToOriginal

def pellWitnesses_127 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_127

theorem pellMasks_127_valid : ∀ m ∈ pellMasks_127, m.Valid 127 := by
  exact pellLightMasks_valid 127 PellMatchingLightProduction.pellMasks_127 PellMatchingLightProduction.pellMasks_127_valid

theorem pellMatching_127_checked :
    pellMatchingCheck pellMasks_127 pellMagnitudes_127 pellWitnesses_127 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_127
    PellMatchingLightProduction.pellMagnitudes_127 PellMatchingLightProduction.pellWitnesses_127).symm.trans
      PellMatchingLightProduction.pellMatching_127_checked

theorem pellMagnitudes_127_large : ∀ x ∈ pellMagnitudes_127, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_127 PellMatchingLightProduction.pellMagnitudes_127_large

def pellGraphCertificate_127 : PellMatchingCertificate 127 where
  magnitudes := pellMagnitudes_127
  masks := pellMasks_127
  witnesses := pellWitnesses_127
  masks_valid := pellMasks_127_valid
  checked := pellMatching_127_checked
  large := pellMagnitudes_127_large

def pellMagnitudes_151 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_151

def pellMasks_151 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_151.map pellLightMasksToOriginal

def pellWitnesses_151 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_151

theorem pellMasks_151_valid : ∀ m ∈ pellMasks_151, m.Valid 151 := by
  exact pellLightMasks_valid 151 PellMatchingLightProduction.pellMasks_151 PellMatchingLightProduction.pellMasks_151_valid

theorem pellMatching_151_checked :
    pellMatchingCheck pellMasks_151 pellMagnitudes_151 pellWitnesses_151 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_151
    PellMatchingLightProduction.pellMagnitudes_151 PellMatchingLightProduction.pellWitnesses_151).symm.trans
      PellMatchingLightProduction.pellMatching_151_checked

theorem pellMagnitudes_151_large : ∀ x ∈ pellMagnitudes_151, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_151 PellMatchingLightProduction.pellMagnitudes_151_large

def pellGraphCertificate_151 : PellMatchingCertificate 151 where
  magnitudes := pellMagnitudes_151
  masks := pellMasks_151
  witnesses := pellWitnesses_151
  masks_valid := pellMasks_151_valid
  checked := pellMatching_151_checked
  large := pellMagnitudes_151_large

def pellMagnitudes_167 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_167

def pellMasks_167 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_167.map pellLightMasksToOriginal

def pellWitnesses_167 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_167

theorem pellMasks_167_valid : ∀ m ∈ pellMasks_167, m.Valid 167 := by
  exact pellLightMasks_valid 167 PellMatchingLightProduction.pellMasks_167 PellMatchingLightProduction.pellMasks_167_valid

theorem pellMatching_167_checked :
    pellMatchingCheck pellMasks_167 pellMagnitudes_167 pellWitnesses_167 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_167
    PellMatchingLightProduction.pellMagnitudes_167 PellMatchingLightProduction.pellWitnesses_167).symm.trans
      PellMatchingLightProduction.pellMatching_167_checked

theorem pellMagnitudes_167_large : ∀ x ∈ pellMagnitudes_167, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_167 PellMatchingLightProduction.pellMagnitudes_167_large

def pellGraphCertificate_167 : PellMatchingCertificate 167 where
  magnitudes := pellMagnitudes_167
  masks := pellMasks_167
  witnesses := pellWitnesses_167
  masks_valid := pellMasks_167_valid
  checked := pellMatching_167_checked
  large := pellMagnitudes_167_large

def pellMagnitudes_191 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_191

def pellMasks_191 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_191.map pellLightMasksToOriginal

def pellWitnesses_191 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_191

theorem pellMasks_191_valid : ∀ m ∈ pellMasks_191, m.Valid 191 := by
  exact pellLightMasks_valid 191 PellMatchingLightProduction.pellMasks_191 PellMatchingLightProduction.pellMasks_191_valid

theorem pellMatching_191_checked :
    pellMatchingCheck pellMasks_191 pellMagnitudes_191 pellWitnesses_191 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_191
    PellMatchingLightProduction.pellMagnitudes_191 PellMatchingLightProduction.pellWitnesses_191).symm.trans
      PellMatchingLightProduction.pellMatching_191_checked

theorem pellMagnitudes_191_large : ∀ x ∈ pellMagnitudes_191, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_191 PellMatchingLightProduction.pellMagnitudes_191_large

def pellGraphCertificate_191 : PellMatchingCertificate 191 where
  magnitudes := pellMagnitudes_191
  masks := pellMasks_191
  witnesses := pellWitnesses_191
  masks_valid := pellMasks_191_valid
  checked := pellMatching_191_checked
  large := pellMagnitudes_191_large

def pellMagnitudes_199 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_199

def pellMasks_199 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_199.map pellLightMasksToOriginal

def pellWitnesses_199 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_199

theorem pellMasks_199_valid : ∀ m ∈ pellMasks_199, m.Valid 199 := by
  exact pellLightMasks_valid 199 PellMatchingLightProduction.pellMasks_199 PellMatchingLightProduction.pellMasks_199_valid

theorem pellMatching_199_checked :
    pellMatchingCheck pellMasks_199 pellMagnitudes_199 pellWitnesses_199 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_199
    PellMatchingLightProduction.pellMagnitudes_199 PellMatchingLightProduction.pellWitnesses_199).symm.trans
      PellMatchingLightProduction.pellMatching_199_checked

theorem pellMagnitudes_199_large : ∀ x ∈ pellMagnitudes_199, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_199 PellMatchingLightProduction.pellMagnitudes_199_large

def pellGraphCertificate_199 : PellMatchingCertificate 199 where
  magnitudes := pellMagnitudes_199
  masks := pellMasks_199
  witnesses := pellWitnesses_199
  masks_valid := pellMasks_199_valid
  checked := pellMatching_199_checked
  large := pellMagnitudes_199_large

def pellMagnitudes_223 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_223

def pellMasks_223 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_223.map pellLightMasksToOriginal

def pellWitnesses_223 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_223

theorem pellMasks_223_valid : ∀ m ∈ pellMasks_223, m.Valid 223 := by
  exact pellLightMasks_valid 223 PellMatchingLightProduction.pellMasks_223 PellMatchingLightProduction.pellMasks_223_valid

theorem pellMatching_223_checked :
    pellMatchingCheck pellMasks_223 pellMagnitudes_223 pellWitnesses_223 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_223
    PellMatchingLightProduction.pellMagnitudes_223 PellMatchingLightProduction.pellWitnesses_223).symm.trans
      PellMatchingLightProduction.pellMatching_223_checked

theorem pellMagnitudes_223_large : ∀ x ∈ pellMagnitudes_223, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_223 PellMatchingLightProduction.pellMagnitudes_223_large

def pellGraphCertificate_223 : PellMatchingCertificate 223 where
  magnitudes := pellMagnitudes_223
  masks := pellMasks_223
  witnesses := pellWitnesses_223
  masks_valid := pellMasks_223_valid
  checked := pellMatching_223_checked
  large := pellMagnitudes_223_large

def pellMagnitudes_239 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_239

def pellMasks_239 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_239.map pellLightMasksToOriginal

def pellWitnesses_239 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_239

theorem pellMasks_239_valid : ∀ m ∈ pellMasks_239, m.Valid 239 := by
  exact pellLightMasks_valid 239 PellMatchingLightProduction.pellMasks_239 PellMatchingLightProduction.pellMasks_239_valid

theorem pellMatching_239_checked :
    pellMatchingCheck pellMasks_239 pellMagnitudes_239 pellWitnesses_239 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_239
    PellMatchingLightProduction.pellMagnitudes_239 PellMatchingLightProduction.pellWitnesses_239).symm.trans
      PellMatchingLightProduction.pellMatching_239_checked

theorem pellMagnitudes_239_large : ∀ x ∈ pellMagnitudes_239, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_239 PellMatchingLightProduction.pellMagnitudes_239_large

def pellGraphCertificate_239 : PellMatchingCertificate 239 where
  magnitudes := pellMagnitudes_239
  masks := pellMasks_239
  witnesses := pellWitnesses_239
  masks_valid := pellMasks_239_valid
  checked := pellMatching_239_checked
  large := pellMagnitudes_239_large

def pellMagnitudes_263 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_263

def pellMasks_263 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_263.map pellLightMasksToOriginal

def pellWitnesses_263 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_263

theorem pellMasks_263_valid : ∀ m ∈ pellMasks_263, m.Valid 263 := by
  exact pellLightMasks_valid 263 PellMatchingLightProduction.pellMasks_263 PellMatchingLightProduction.pellMasks_263_valid

theorem pellMatching_263_checked :
    pellMatchingCheck pellMasks_263 pellMagnitudes_263 pellWitnesses_263 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_263
    PellMatchingLightProduction.pellMagnitudes_263 PellMatchingLightProduction.pellWitnesses_263).symm.trans
      PellMatchingLightProduction.pellMatching_263_checked

theorem pellMagnitudes_263_large : ∀ x ∈ pellMagnitudes_263, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_263 PellMatchingLightProduction.pellMagnitudes_263_large

def pellGraphCertificate_263 : PellMatchingCertificate 263 where
  magnitudes := pellMagnitudes_263
  masks := pellMasks_263
  witnesses := pellWitnesses_263
  masks_valid := pellMasks_263_valid
  checked := pellMatching_263_checked
  large := pellMagnitudes_263_large

def pellMagnitudes_271 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_271

def pellMasks_271 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_271.map pellLightMasksToOriginal

def pellWitnesses_271 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_271

theorem pellMasks_271_valid : ∀ m ∈ pellMasks_271, m.Valid 271 := by
  exact pellLightMasks_valid 271 PellMatchingLightProduction.pellMasks_271 PellMatchingLightProduction.pellMasks_271_valid

theorem pellMatching_271_checked :
    pellMatchingCheck pellMasks_271 pellMagnitudes_271 pellWitnesses_271 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_271
    PellMatchingLightProduction.pellMagnitudes_271 PellMatchingLightProduction.pellWitnesses_271).symm.trans
      PellMatchingLightProduction.pellMatching_271_checked

theorem pellMagnitudes_271_large : ∀ x ∈ pellMagnitudes_271, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_271 PellMatchingLightProduction.pellMagnitudes_271_large

def pellGraphCertificate_271 : PellMatchingCertificate 271 where
  magnitudes := pellMagnitudes_271
  masks := pellMasks_271
  witnesses := pellWitnesses_271
  masks_valid := pellMasks_271_valid
  checked := pellMatching_271_checked
  large := pellMagnitudes_271_large

def pellMagnitudes_287 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_287

def pellMasks_287 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_287.map pellLightMasksToOriginal

def pellWitnesses_287 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_287

theorem pellMasks_287_valid : ∀ m ∈ pellMasks_287, m.Valid 287 := by
  exact pellLightMasks_valid 287 PellMatchingLightProduction.pellMasks_287 PellMatchingLightProduction.pellMasks_287_valid

theorem pellMatching_287_checked :
    pellMatchingCheck pellMasks_287 pellMagnitudes_287 pellWitnesses_287 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_287
    PellMatchingLightProduction.pellMagnitudes_287 PellMatchingLightProduction.pellWitnesses_287).symm.trans
      PellMatchingLightProduction.pellMatching_287_checked

theorem pellMagnitudes_287_large : ∀ x ∈ pellMagnitudes_287, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_287 PellMatchingLightProduction.pellMagnitudes_287_large

def pellGraphCertificate_287 : PellMatchingCertificate 287 where
  magnitudes := pellMagnitudes_287
  masks := pellMasks_287
  witnesses := pellWitnesses_287
  masks_valid := pellMasks_287_valid
  checked := pellMatching_287_checked
  large := pellMagnitudes_287_large

def pellMagnitudes_311 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_311

def pellMasks_311 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_311.map pellLightMasksToOriginal

def pellWitnesses_311 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_311

theorem pellMasks_311_valid : ∀ m ∈ pellMasks_311, m.Valid 311 := by
  exact pellLightMasks_valid 311 PellMatchingLightProduction.pellMasks_311 PellMatchingLightProduction.pellMasks_311_valid

theorem pellMatching_311_checked :
    pellMatchingCheck pellMasks_311 pellMagnitudes_311 pellWitnesses_311 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_311
    PellMatchingLightProduction.pellMagnitudes_311 PellMatchingLightProduction.pellWitnesses_311).symm.trans
      PellMatchingLightProduction.pellMatching_311_checked

theorem pellMagnitudes_311_large : ∀ x ∈ pellMagnitudes_311, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_311 PellMatchingLightProduction.pellMagnitudes_311_large

def pellGraphCertificate_311 : PellMatchingCertificate 311 where
  magnitudes := pellMagnitudes_311
  masks := pellMasks_311
  witnesses := pellWitnesses_311
  masks_valid := pellMasks_311_valid
  checked := pellMatching_311_checked
  large := pellMagnitudes_311_large

def pellMagnitudes_359 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_359

def pellMasks_359 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_359.map pellLightMasksToOriginal

def pellWitnesses_359 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_359

theorem pellMasks_359_valid : ∀ m ∈ pellMasks_359, m.Valid 359 := by
  exact pellLightMasks_valid 359 PellMatchingLightProduction.pellMasks_359 PellMatchingLightProduction.pellMasks_359_valid

theorem pellMatching_359_checked :
    pellMatchingCheck pellMasks_359 pellMagnitudes_359 pellWitnesses_359 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_359
    PellMatchingLightProduction.pellMagnitudes_359 PellMatchingLightProduction.pellWitnesses_359).symm.trans
      PellMatchingLightProduction.pellMatching_359_checked

theorem pellMagnitudes_359_large : ∀ x ∈ pellMagnitudes_359, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_359 PellMatchingLightProduction.pellMagnitudes_359_large

def pellGraphCertificate_359 : PellMatchingCertificate 359 where
  magnitudes := pellMagnitudes_359
  masks := pellMasks_359
  witnesses := pellWitnesses_359
  masks_valid := pellMasks_359_valid
  checked := pellMatching_359_checked
  large := pellMagnitudes_359_large

def pellMagnitudes_367 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_367

def pellMasks_367 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_367.map pellLightMasksToOriginal

def pellWitnesses_367 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_367

theorem pellMasks_367_valid : ∀ m ∈ pellMasks_367, m.Valid 367 := by
  exact pellLightMasks_valid 367 PellMatchingLightProduction.pellMasks_367 PellMatchingLightProduction.pellMasks_367_valid

theorem pellMatching_367_checked :
    pellMatchingCheck pellMasks_367 pellMagnitudes_367 pellWitnesses_367 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_367
    PellMatchingLightProduction.pellMagnitudes_367 PellMatchingLightProduction.pellWitnesses_367).symm.trans
      PellMatchingLightProduction.pellMatching_367_checked

theorem pellMagnitudes_367_large : ∀ x ∈ pellMagnitudes_367, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_367 PellMatchingLightProduction.pellMagnitudes_367_large

def pellGraphCertificate_367 : PellMatchingCertificate 367 where
  magnitudes := pellMagnitudes_367
  masks := pellMasks_367
  witnesses := pellWitnesses_367
  masks_valid := pellMasks_367_valid
  checked := pellMatching_367_checked
  large := pellMagnitudes_367_large

def pellMagnitudes_383 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_383

def pellMasks_383 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_383.map pellLightMasksToOriginal

def pellWitnesses_383 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_383

theorem pellMasks_383_valid : ∀ m ∈ pellMasks_383, m.Valid 383 := by
  exact pellLightMasks_valid 383 PellMatchingLightProduction.pellMasks_383 PellMatchingLightProduction.pellMasks_383_valid

theorem pellMatching_383_checked :
    pellMatchingCheck pellMasks_383 pellMagnitudes_383 pellWitnesses_383 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_383
    PellMatchingLightProduction.pellMagnitudes_383 PellMatchingLightProduction.pellWitnesses_383).symm.trans
      PellMatchingLightProduction.pellMatching_383_checked

theorem pellMagnitudes_383_large : ∀ x ∈ pellMagnitudes_383, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_383 PellMatchingLightProduction.pellMagnitudes_383_large

def pellGraphCertificate_383 : PellMatchingCertificate 383 where
  magnitudes := pellMagnitudes_383
  masks := pellMasks_383
  witnesses := pellWitnesses_383
  masks_valid := pellMasks_383_valid
  checked := pellMatching_383_checked
  large := pellMagnitudes_383_large

def pellMagnitudes_391 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_391

def pellMasks_391 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_391.map pellLightMasksToOriginal

def pellWitnesses_391 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_391

theorem pellMasks_391_valid : ∀ m ∈ pellMasks_391, m.Valid 391 := by
  exact pellLightMasks_valid 391 PellMatchingLightProduction.pellMasks_391 PellMatchingLightProduction.pellMasks_391_valid

theorem pellMatching_391_checked :
    pellMatchingCheck pellMasks_391 pellMagnitudes_391 pellWitnesses_391 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_391
    PellMatchingLightProduction.pellMagnitudes_391 PellMatchingLightProduction.pellWitnesses_391).symm.trans
      PellMatchingLightProduction.pellMatching_391_checked

theorem pellMagnitudes_391_large : ∀ x ∈ pellMagnitudes_391, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_391 PellMatchingLightProduction.pellMagnitudes_391_large

def pellGraphCertificate_391 : PellMatchingCertificate 391 where
  magnitudes := pellMagnitudes_391
  masks := pellMasks_391
  witnesses := pellWitnesses_391
  masks_valid := pellMasks_391_valid
  checked := pellMatching_391_checked
  large := pellMagnitudes_391_large

def pellMagnitudes_431 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_431

def pellMasks_431 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_431.map pellLightMasksToOriginal

def pellWitnesses_431 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_431

theorem pellMasks_431_valid : ∀ m ∈ pellMasks_431, m.Valid 431 := by
  exact pellLightMasks_valid 431 PellMatchingLightProduction.pellMasks_431 PellMatchingLightProduction.pellMasks_431_valid

theorem pellMatching_431_checked :
    pellMatchingCheck pellMasks_431 pellMagnitudes_431 pellWitnesses_431 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_431
    PellMatchingLightProduction.pellMagnitudes_431 PellMatchingLightProduction.pellWitnesses_431).symm.trans
      PellMatchingLightProduction.pellMatching_431_checked

theorem pellMagnitudes_431_large : ∀ x ∈ pellMagnitudes_431, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_431 PellMatchingLightProduction.pellMagnitudes_431_large

def pellGraphCertificate_431 : PellMatchingCertificate 431 where
  magnitudes := pellMagnitudes_431
  masks := pellMasks_431
  witnesses := pellWitnesses_431
  masks_valid := pellMasks_431_valid
  checked := pellMatching_431_checked
  large := pellMagnitudes_431_large

def pellMagnitudes_439 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_439

def pellMasks_439 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_439.map pellLightMasksToOriginal

def pellWitnesses_439 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_439

theorem pellMasks_439_valid : ∀ m ∈ pellMasks_439, m.Valid 439 := by
  exact pellLightMasks_valid 439 PellMatchingLightProduction.pellMasks_439 PellMatchingLightProduction.pellMasks_439_valid

theorem pellMatching_439_checked :
    pellMatchingCheck pellMasks_439 pellMagnitudes_439 pellWitnesses_439 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_439
    PellMatchingLightProduction.pellMagnitudes_439 PellMatchingLightProduction.pellWitnesses_439).symm.trans
      PellMatchingLightProduction.pellMatching_439_checked

theorem pellMagnitudes_439_large : ∀ x ∈ pellMagnitudes_439, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_439 PellMatchingLightProduction.pellMagnitudes_439_large

def pellGraphCertificate_439 : PellMatchingCertificate 439 where
  magnitudes := pellMagnitudes_439
  masks := pellMasks_439
  witnesses := pellWitnesses_439
  masks_valid := pellMasks_439_valid
  checked := pellMatching_439_checked
  large := pellMagnitudes_439_large

def pellMagnitudes_463 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_463

def pellMasks_463 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_463.map pellLightMasksToOriginal

def pellWitnesses_463 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_463

theorem pellMasks_463_valid : ∀ m ∈ pellMasks_463, m.Valid 463 := by
  exact pellLightMasks_valid 463 PellMatchingLightProduction.pellMasks_463 PellMatchingLightProduction.pellMasks_463_valid

theorem pellMatching_463_checked :
    pellMatchingCheck pellMasks_463 pellMagnitudes_463 pellWitnesses_463 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_463
    PellMatchingLightProduction.pellMagnitudes_463 PellMatchingLightProduction.pellWitnesses_463).symm.trans
      PellMatchingLightProduction.pellMatching_463_checked

theorem pellMagnitudes_463_large : ∀ x ∈ pellMagnitudes_463, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_463 PellMatchingLightProduction.pellMagnitudes_463_large

def pellGraphCertificate_463 : PellMatchingCertificate 463 where
  magnitudes := pellMagnitudes_463
  masks := pellMasks_463
  witnesses := pellWitnesses_463
  masks_valid := pellMasks_463_valid
  checked := pellMatching_463_checked
  large := pellMagnitudes_463_large

def pellMagnitudes_479 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_479

def pellMasks_479 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_479.map pellLightMasksToOriginal

def pellWitnesses_479 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_479

theorem pellMasks_479_valid : ∀ m ∈ pellMasks_479, m.Valid 479 := by
  exact pellLightMasks_valid 479 PellMatchingLightProduction.pellMasks_479 PellMatchingLightProduction.pellMasks_479_valid

theorem pellMatching_479_checked :
    pellMatchingCheck pellMasks_479 pellMagnitudes_479 pellWitnesses_479 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_479
    PellMatchingLightProduction.pellMagnitudes_479 PellMatchingLightProduction.pellWitnesses_479).symm.trans
      PellMatchingLightProduction.pellMatching_479_checked

theorem pellMagnitudes_479_large : ∀ x ∈ pellMagnitudes_479, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_479 PellMatchingLightProduction.pellMagnitudes_479_large

def pellGraphCertificate_479 : PellMatchingCertificate 479 where
  magnitudes := pellMagnitudes_479
  masks := pellMasks_479
  witnesses := pellWitnesses_479
  masks_valid := pellMasks_479_valid
  checked := pellMatching_479_checked
  large := pellMagnitudes_479_large

def pellMagnitudes_487 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_487

def pellMasks_487 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_487.map pellLightMasksToOriginal

def pellWitnesses_487 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_487

theorem pellMasks_487_valid : ∀ m ∈ pellMasks_487, m.Valid 487 := by
  exact pellLightMasks_valid 487 PellMatchingLightProduction.pellMasks_487 PellMatchingLightProduction.pellMasks_487_valid

theorem pellMatching_487_checked :
    pellMatchingCheck pellMasks_487 pellMagnitudes_487 pellWitnesses_487 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_487
    PellMatchingLightProduction.pellMagnitudes_487 PellMatchingLightProduction.pellWitnesses_487).symm.trans
      PellMatchingLightProduction.pellMatching_487_checked

theorem pellMagnitudes_487_large : ∀ x ∈ pellMagnitudes_487, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_487 PellMatchingLightProduction.pellMagnitudes_487_large

def pellGraphCertificate_487 : PellMatchingCertificate 487 where
  magnitudes := pellMagnitudes_487
  masks := pellMasks_487
  witnesses := pellWitnesses_487
  masks_valid := pellMasks_487_valid
  checked := pellMatching_487_checked
  large := pellMagnitudes_487_large

def pellMagnitudes_503 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_503

def pellMasks_503 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_503.map pellLightMasksToOriginal

def pellWitnesses_503 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_503

theorem pellMasks_503_valid : ∀ m ∈ pellMasks_503, m.Valid 503 := by
  exact pellLightMasks_valid 503 PellMatchingLightProduction.pellMasks_503 PellMatchingLightProduction.pellMasks_503_valid

theorem pellMatching_503_checked :
    pellMatchingCheck pellMasks_503 pellMagnitudes_503 pellWitnesses_503 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_503
    PellMatchingLightProduction.pellMagnitudes_503 PellMatchingLightProduction.pellWitnesses_503).symm.trans
      PellMatchingLightProduction.pellMatching_503_checked

theorem pellMagnitudes_503_large : ∀ x ∈ pellMagnitudes_503, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_503 PellMatchingLightProduction.pellMagnitudes_503_large

def pellGraphCertificate_503 : PellMatchingCertificate 503 where
  magnitudes := pellMagnitudes_503
  masks := pellMasks_503
  witnesses := pellWitnesses_503
  masks_valid := pellMasks_503_valid
  checked := pellMatching_503_checked
  large := pellMagnitudes_503_large

def pellMagnitudes_511 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_511

def pellMasks_511 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_511.map pellLightMasksToOriginal

def pellWitnesses_511 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_511

theorem pellMasks_511_valid : ∀ m ∈ pellMasks_511, m.Valid 511 := by
  exact pellLightMasks_valid 511 PellMatchingLightProduction.pellMasks_511 PellMatchingLightProduction.pellMasks_511_valid

theorem pellMatching_511_checked :
    pellMatchingCheck pellMasks_511 pellMagnitudes_511 pellWitnesses_511 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_511
    PellMatchingLightProduction.pellMagnitudes_511 PellMatchingLightProduction.pellWitnesses_511).symm.trans
      PellMatchingLightProduction.pellMatching_511_checked

theorem pellMagnitudes_511_large : ∀ x ∈ pellMagnitudes_511, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_511 PellMatchingLightProduction.pellMagnitudes_511_large

def pellGraphCertificate_511 : PellMatchingCertificate 511 where
  magnitudes := pellMagnitudes_511
  masks := pellMasks_511
  witnesses := pellWitnesses_511
  masks_valid := pellMasks_511_valid
  checked := pellMatching_511_checked
  large := pellMagnitudes_511_large

def pellMagnitudes_527 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_527

def pellMasks_527 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_527.map pellLightMasksToOriginal

def pellWitnesses_527 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_527

theorem pellMasks_527_valid : ∀ m ∈ pellMasks_527, m.Valid 527 := by
  exact pellLightMasks_valid 527 PellMatchingLightProduction.pellMasks_527 PellMatchingLightProduction.pellMasks_527_valid

theorem pellMatching_527_checked :
    pellMatchingCheck pellMasks_527 pellMagnitudes_527 pellWitnesses_527 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_527
    PellMatchingLightProduction.pellMagnitudes_527 PellMatchingLightProduction.pellWitnesses_527).symm.trans
      PellMatchingLightProduction.pellMatching_527_checked

theorem pellMagnitudes_527_large : ∀ x ∈ pellMagnitudes_527, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_527 PellMatchingLightProduction.pellMagnitudes_527_large

def pellGraphCertificate_527 : PellMatchingCertificate 527 where
  magnitudes := pellMagnitudes_527
  masks := pellMasks_527
  witnesses := pellWitnesses_527
  masks_valid := pellMasks_527_valid
  checked := pellMatching_527_checked
  large := pellMagnitudes_527_large

def pellMagnitudes_599 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_599

def pellMasks_599 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_599.map pellLightMasksToOriginal

def pellWitnesses_599 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_599

theorem pellMasks_599_valid : ∀ m ∈ pellMasks_599, m.Valid 599 := by
  exact pellLightMasks_valid 599 PellMatchingLightProduction.pellMasks_599 PellMatchingLightProduction.pellMasks_599_valid

theorem pellMatching_599_checked :
    pellMatchingCheck pellMasks_599 pellMagnitudes_599 pellWitnesses_599 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_599
    PellMatchingLightProduction.pellMagnitudes_599 PellMatchingLightProduction.pellWitnesses_599).symm.trans
      PellMatchingLightProduction.pellMatching_599_checked

theorem pellMagnitudes_599_large : ∀ x ∈ pellMagnitudes_599, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_599 PellMatchingLightProduction.pellMagnitudes_599_large

def pellGraphCertificate_599 : PellMatchingCertificate 599 where
  magnitudes := pellMagnitudes_599
  masks := pellMasks_599
  witnesses := pellWitnesses_599
  masks_valid := pellMasks_599_valid
  checked := pellMatching_599_checked
  large := pellMagnitudes_599_large

def pellMagnitudes_607 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_607

def pellMasks_607 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_607.map pellLightMasksToOriginal

def pellWitnesses_607 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_607

theorem pellMasks_607_valid : ∀ m ∈ pellMasks_607, m.Valid 607 := by
  exact pellLightMasks_valid 607 PellMatchingLightProduction.pellMasks_607 PellMatchingLightProduction.pellMasks_607_valid

theorem pellMatching_607_checked :
    pellMatchingCheck pellMasks_607 pellMagnitudes_607 pellWitnesses_607 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_607
    PellMatchingLightProduction.pellMagnitudes_607 PellMatchingLightProduction.pellWitnesses_607).symm.trans
      PellMatchingLightProduction.pellMatching_607_checked

theorem pellMagnitudes_607_large : ∀ x ∈ pellMagnitudes_607, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_607 PellMatchingLightProduction.pellMagnitudes_607_large

def pellGraphCertificate_607 : PellMatchingCertificate 607 where
  magnitudes := pellMagnitudes_607
  masks := pellMasks_607
  witnesses := pellWitnesses_607
  masks_valid := pellMasks_607_valid
  checked := pellMatching_607_checked
  large := pellMagnitudes_607_large

def pellMagnitudes_623 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_623

def pellMasks_623 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_623.map pellLightMasksToOriginal

def pellWitnesses_623 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_623

theorem pellMasks_623_valid : ∀ m ∈ pellMasks_623, m.Valid 623 := by
  exact pellLightMasks_valid 623 PellMatchingLightProduction.pellMasks_623 PellMatchingLightProduction.pellMasks_623_valid

theorem pellMatching_623_checked :
    pellMatchingCheck pellMasks_623 pellMagnitudes_623 pellWitnesses_623 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_623
    PellMatchingLightProduction.pellMagnitudes_623 PellMatchingLightProduction.pellWitnesses_623).symm.trans
      PellMatchingLightProduction.pellMatching_623_checked

theorem pellMagnitudes_623_large : ∀ x ∈ pellMagnitudes_623, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_623 PellMatchingLightProduction.pellMagnitudes_623_large

def pellGraphCertificate_623 : PellMatchingCertificate 623 where
  magnitudes := pellMagnitudes_623
  masks := pellMasks_623
  witnesses := pellWitnesses_623
  masks_valid := pellMasks_623_valid
  checked := pellMatching_623_checked
  large := pellMagnitudes_623_large

def pellMagnitudes_631 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_631

def pellMasks_631 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_631.map pellLightMasksToOriginal

def pellWitnesses_631 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_631

theorem pellMasks_631_valid : ∀ m ∈ pellMasks_631, m.Valid 631 := by
  exact pellLightMasks_valid 631 PellMatchingLightProduction.pellMasks_631 PellMatchingLightProduction.pellMasks_631_valid

theorem pellMatching_631_checked :
    pellMatchingCheck pellMasks_631 pellMagnitudes_631 pellWitnesses_631 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_631
    PellMatchingLightProduction.pellMagnitudes_631 PellMatchingLightProduction.pellWitnesses_631).symm.trans
      PellMatchingLightProduction.pellMatching_631_checked

theorem pellMagnitudes_631_large : ∀ x ∈ pellMagnitudes_631, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_631 PellMatchingLightProduction.pellMagnitudes_631_large

def pellGraphCertificate_631 : PellMatchingCertificate 631 where
  magnitudes := pellMagnitudes_631
  masks := pellMasks_631
  witnesses := pellWitnesses_631
  masks_valid := pellMasks_631_valid
  checked := pellMatching_631_checked
  large := pellMagnitudes_631_large

def pellMagnitudes_647 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_647

def pellMasks_647 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_647.map pellLightMasksToOriginal

def pellWitnesses_647 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_647

theorem pellMasks_647_valid : ∀ m ∈ pellMasks_647, m.Valid 647 := by
  exact pellLightMasks_valid 647 PellMatchingLightProduction.pellMasks_647 PellMatchingLightProduction.pellMasks_647_valid

theorem pellMatching_647_checked :
    pellMatchingCheck pellMasks_647 pellMagnitudes_647 pellWitnesses_647 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_647
    PellMatchingLightProduction.pellMagnitudes_647 PellMatchingLightProduction.pellWitnesses_647).symm.trans
      PellMatchingLightProduction.pellMatching_647_checked

theorem pellMagnitudes_647_large : ∀ x ∈ pellMagnitudes_647, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_647 PellMatchingLightProduction.pellMagnitudes_647_large

def pellGraphCertificate_647 : PellMatchingCertificate 647 where
  magnitudes := pellMagnitudes_647
  masks := pellMasks_647
  witnesses := pellWitnesses_647
  masks_valid := pellMasks_647_valid
  checked := pellMatching_647_checked
  large := pellMagnitudes_647_large

def pellMagnitudes_679 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_679

def pellMasks_679 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_679.map pellLightMasksToOriginal

def pellWitnesses_679 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_679

theorem pellMasks_679_valid : ∀ m ∈ pellMasks_679, m.Valid 679 := by
  exact pellLightMasks_valid 679 PellMatchingLightProduction.pellMasks_679 PellMatchingLightProduction.pellMasks_679_valid

theorem pellMatching_679_checked :
    pellMatchingCheck pellMasks_679 pellMagnitudes_679 pellWitnesses_679 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_679
    PellMatchingLightProduction.pellMagnitudes_679 PellMatchingLightProduction.pellWitnesses_679).symm.trans
      PellMatchingLightProduction.pellMatching_679_checked

theorem pellMagnitudes_679_large : ∀ x ∈ pellMagnitudes_679, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_679 PellMatchingLightProduction.pellMagnitudes_679_large

def pellGraphCertificate_679 : PellMatchingCertificate 679 where
  magnitudes := pellMagnitudes_679
  masks := pellMasks_679
  witnesses := pellWitnesses_679
  masks_valid := pellMasks_679_valid
  checked := pellMatching_679_checked
  large := pellMagnitudes_679_large

def pellMagnitudes_719 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_719

def pellMasks_719 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_719.map pellLightMasksToOriginal

def pellWitnesses_719 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_719

theorem pellMasks_719_valid : ∀ m ∈ pellMasks_719, m.Valid 719 := by
  exact pellLightMasks_valid 719 PellMatchingLightProduction.pellMasks_719 PellMatchingLightProduction.pellMasks_719_valid

theorem pellMatching_719_checked :
    pellMatchingCheck pellMasks_719 pellMagnitudes_719 pellWitnesses_719 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_719
    PellMatchingLightProduction.pellMagnitudes_719 PellMatchingLightProduction.pellWitnesses_719).symm.trans
      PellMatchingLightProduction.pellMatching_719_checked

theorem pellMagnitudes_719_large : ∀ x ∈ pellMagnitudes_719, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_719 PellMatchingLightProduction.pellMagnitudes_719_large

def pellGraphCertificate_719 : PellMatchingCertificate 719 where
  magnitudes := pellMagnitudes_719
  masks := pellMasks_719
  witnesses := pellWitnesses_719
  masks_valid := pellMasks_719_valid
  checked := pellMatching_719_checked
  large := pellMagnitudes_719_large

def pellMagnitudes_727 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_727

def pellMasks_727 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_727.map pellLightMasksToOriginal

def pellWitnesses_727 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_727

theorem pellMasks_727_valid : ∀ m ∈ pellMasks_727, m.Valid 727 := by
  exact pellLightMasks_valid 727 PellMatchingLightProduction.pellMasks_727 PellMatchingLightProduction.pellMasks_727_valid

theorem pellMatching_727_checked :
    pellMatchingCheck pellMasks_727 pellMagnitudes_727 pellWitnesses_727 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_727
    PellMatchingLightProduction.pellMagnitudes_727 PellMatchingLightProduction.pellWitnesses_727).symm.trans
      PellMatchingLightProduction.pellMatching_727_checked

theorem pellMagnitudes_727_large : ∀ x ∈ pellMagnitudes_727, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_727 PellMatchingLightProduction.pellMagnitudes_727_large

def pellGraphCertificate_727 : PellMatchingCertificate 727 where
  magnitudes := pellMagnitudes_727
  masks := pellMasks_727
  witnesses := pellWitnesses_727
  masks_valid := pellMasks_727_valid
  checked := pellMatching_727_checked
  large := pellMagnitudes_727_large

def pellMagnitudes_743 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_743

def pellMasks_743 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_743.map pellLightMasksToOriginal

def pellWitnesses_743 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_743

theorem pellMasks_743_valid : ∀ m ∈ pellMasks_743, m.Valid 743 := by
  exact pellLightMasks_valid 743 PellMatchingLightProduction.pellMasks_743 PellMatchingLightProduction.pellMasks_743_valid

theorem pellMatching_743_checked :
    pellMatchingCheck pellMasks_743 pellMagnitudes_743 pellWitnesses_743 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_743
    PellMatchingLightProduction.pellMagnitudes_743 PellMatchingLightProduction.pellWitnesses_743).symm.trans
      PellMatchingLightProduction.pellMatching_743_checked

theorem pellMagnitudes_743_large : ∀ x ∈ pellMagnitudes_743, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_743 PellMatchingLightProduction.pellMagnitudes_743_large

def pellGraphCertificate_743 : PellMatchingCertificate 743 where
  magnitudes := pellMagnitudes_743
  masks := pellMasks_743
  witnesses := pellWitnesses_743
  masks_valid := pellMasks_743_valid
  checked := pellMatching_743_checked
  large := pellMagnitudes_743_large

def pellMagnitudes_751 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_751

def pellMasks_751 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_751.map pellLightMasksToOriginal

def pellWitnesses_751 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_751

theorem pellMasks_751_valid : ∀ m ∈ pellMasks_751, m.Valid 751 := by
  exact pellLightMasks_valid 751 PellMatchingLightProduction.pellMasks_751 PellMatchingLightProduction.pellMasks_751_valid

theorem pellMatching_751_checked :
    pellMatchingCheck pellMasks_751 pellMagnitudes_751 pellWitnesses_751 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_751
    PellMatchingLightProduction.pellMagnitudes_751 PellMatchingLightProduction.pellWitnesses_751).symm.trans
      PellMatchingLightProduction.pellMatching_751_checked

theorem pellMagnitudes_751_large : ∀ x ∈ pellMagnitudes_751, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_751 PellMatchingLightProduction.pellMagnitudes_751_large

def pellGraphCertificate_751 : PellMatchingCertificate 751 where
  magnitudes := pellMagnitudes_751
  masks := pellMasks_751
  witnesses := pellWitnesses_751
  masks_valid := pellMasks_751_valid
  checked := pellMatching_751_checked
  large := pellMagnitudes_751_large

def pellMagnitudes_823 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_823

def pellMasks_823 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_823.map pellLightMasksToOriginal

def pellWitnesses_823 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_823

theorem pellMasks_823_valid : ∀ m ∈ pellMasks_823, m.Valid 823 := by
  exact pellLightMasks_valid 823 PellMatchingLightProduction.pellMasks_823 PellMatchingLightProduction.pellMasks_823_valid

theorem pellMatching_823_checked :
    pellMatchingCheck pellMasks_823 pellMagnitudes_823 pellWitnesses_823 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_823
    PellMatchingLightProduction.pellMagnitudes_823 PellMatchingLightProduction.pellWitnesses_823).symm.trans
      PellMatchingLightProduction.pellMatching_823_checked

theorem pellMagnitudes_823_large : ∀ x ∈ pellMagnitudes_823, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_823 PellMatchingLightProduction.pellMagnitudes_823_large

def pellGraphCertificate_823 : PellMatchingCertificate 823 where
  magnitudes := pellMagnitudes_823
  masks := pellMasks_823
  witnesses := pellWitnesses_823
  masks_valid := pellMasks_823_valid
  checked := pellMatching_823_checked
  large := pellMagnitudes_823_large

def pellMagnitudes_839 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_839

def pellMasks_839 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_839.map pellLightMasksToOriginal

def pellWitnesses_839 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_839

theorem pellMasks_839_valid : ∀ m ∈ pellMasks_839, m.Valid 839 := by
  exact pellLightMasks_valid 839 PellMatchingLightProduction.pellMasks_839 PellMatchingLightProduction.pellMasks_839_valid

theorem pellMatching_839_checked :
    pellMatchingCheck pellMasks_839 pellMagnitudes_839 pellWitnesses_839 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_839
    PellMatchingLightProduction.pellMagnitudes_839 PellMatchingLightProduction.pellWitnesses_839).symm.trans
      PellMatchingLightProduction.pellMatching_839_checked

theorem pellMagnitudes_839_large : ∀ x ∈ pellMagnitudes_839, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_839 PellMatchingLightProduction.pellMagnitudes_839_large

def pellGraphCertificate_839 : PellMatchingCertificate 839 where
  magnitudes := pellMagnitudes_839
  masks := pellMasks_839
  witnesses := pellWitnesses_839
  masks_valid := pellMasks_839_valid
  checked := pellMatching_839_checked
  large := pellMagnitudes_839_large

def pellMagnitudes_863 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_863

def pellMasks_863 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_863.map pellLightMasksToOriginal

def pellWitnesses_863 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_863

theorem pellMasks_863_valid : ∀ m ∈ pellMasks_863, m.Valid 863 := by
  exact pellLightMasks_valid 863 PellMatchingLightProduction.pellMasks_863 PellMatchingLightProduction.pellMasks_863_valid

theorem pellMatching_863_checked :
    pellMatchingCheck pellMasks_863 pellMagnitudes_863 pellWitnesses_863 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_863
    PellMatchingLightProduction.pellMagnitudes_863 PellMatchingLightProduction.pellWitnesses_863).symm.trans
      PellMatchingLightProduction.pellMatching_863_checked

theorem pellMagnitudes_863_large : ∀ x ∈ pellMagnitudes_863, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_863 PellMatchingLightProduction.pellMagnitudes_863_large

def pellGraphCertificate_863 : PellMatchingCertificate 863 where
  magnitudes := pellMagnitudes_863
  masks := pellMasks_863
  witnesses := pellWitnesses_863
  masks_valid := pellMasks_863_valid
  checked := pellMatching_863_checked
  large := pellMagnitudes_863_large

def pellMagnitudes_887 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_887

def pellMasks_887 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_887.map pellLightMasksToOriginal

def pellWitnesses_887 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_887

theorem pellMasks_887_valid : ∀ m ∈ pellMasks_887, m.Valid 887 := by
  exact pellLightMasks_valid 887 PellMatchingLightProduction.pellMasks_887 PellMatchingLightProduction.pellMasks_887_valid

theorem pellMatching_887_checked :
    pellMatchingCheck pellMasks_887 pellMagnitudes_887 pellWitnesses_887 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_887
    PellMatchingLightProduction.pellMagnitudes_887 PellMatchingLightProduction.pellWitnesses_887).symm.trans
      PellMatchingLightProduction.pellMatching_887_checked

theorem pellMagnitudes_887_large : ∀ x ∈ pellMagnitudes_887, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_887 PellMatchingLightProduction.pellMagnitudes_887_large

def pellGraphCertificate_887 : PellMatchingCertificate 887 where
  magnitudes := pellMagnitudes_887
  masks := pellMasks_887
  witnesses := pellWitnesses_887
  masks_valid := pellMasks_887_valid
  checked := pellMatching_887_checked
  large := pellMagnitudes_887_large

def pellMagnitudes_911 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_911

def pellMasks_911 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_911.map pellLightMasksToOriginal

def pellWitnesses_911 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_911

theorem pellMasks_911_valid : ∀ m ∈ pellMasks_911, m.Valid 911 := by
  exact pellLightMasks_valid 911 PellMatchingLightProduction.pellMasks_911 PellMatchingLightProduction.pellMasks_911_valid

theorem pellMatching_911_checked :
    pellMatchingCheck pellMasks_911 pellMagnitudes_911 pellWitnesses_911 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_911
    PellMatchingLightProduction.pellMagnitudes_911 PellMatchingLightProduction.pellWitnesses_911).symm.trans
      PellMatchingLightProduction.pellMatching_911_checked

theorem pellMagnitudes_911_large : ∀ x ∈ pellMagnitudes_911, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_911 PellMatchingLightProduction.pellMagnitudes_911_large

def pellGraphCertificate_911 : PellMatchingCertificate 911 where
  magnitudes := pellMagnitudes_911
  masks := pellMasks_911
  witnesses := pellWitnesses_911
  masks_valid := pellMasks_911_valid
  checked := pellMatching_911_checked
  large := pellMagnitudes_911_large

def pellMagnitudes_919 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_919

def pellMasks_919 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_919.map pellLightMasksToOriginal

def pellWitnesses_919 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_919

theorem pellMasks_919_valid : ∀ m ∈ pellMasks_919, m.Valid 919 := by
  exact pellLightMasks_valid 919 PellMatchingLightProduction.pellMasks_919 PellMatchingLightProduction.pellMasks_919_valid

theorem pellMatching_919_checked :
    pellMatchingCheck pellMasks_919 pellMagnitudes_919 pellWitnesses_919 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_919
    PellMatchingLightProduction.pellMagnitudes_919 PellMatchingLightProduction.pellWitnesses_919).symm.trans
      PellMatchingLightProduction.pellMatching_919_checked

theorem pellMagnitudes_919_large : ∀ x ∈ pellMagnitudes_919, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_919 PellMatchingLightProduction.pellMagnitudes_919_large

def pellGraphCertificate_919 : PellMatchingCertificate 919 where
  magnitudes := pellMagnitudes_919
  masks := pellMasks_919
  witnesses := pellWitnesses_919
  masks_valid := pellMasks_919_valid
  checked := pellMatching_919_checked
  large := pellMagnitudes_919_large

def pellMagnitudes_959 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_959

def pellMasks_959 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_959.map pellLightMasksToOriginal

def pellWitnesses_959 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_959

theorem pellMasks_959_valid : ∀ m ∈ pellMasks_959, m.Valid 959 := by
  exact pellLightMasks_valid 959 PellMatchingLightProduction.pellMasks_959 PellMatchingLightProduction.pellMasks_959_valid

theorem pellMatching_959_checked :
    pellMatchingCheck pellMasks_959 pellMagnitudes_959 pellWitnesses_959 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_959
    PellMatchingLightProduction.pellMagnitudes_959 PellMatchingLightProduction.pellWitnesses_959).symm.trans
      PellMatchingLightProduction.pellMatching_959_checked

theorem pellMagnitudes_959_large : ∀ x ∈ pellMagnitudes_959, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_959 PellMatchingLightProduction.pellMagnitudes_959_large

def pellGraphCertificate_959 : PellMatchingCertificate 959 where
  magnitudes := pellMagnitudes_959
  masks := pellMasks_959
  witnesses := pellWitnesses_959
  masks_valid := pellMasks_959_valid
  checked := pellMatching_959_checked
  large := pellMagnitudes_959_large

def pellMagnitudes_967 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_967

def pellMasks_967 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_967.map pellLightMasksToOriginal

def pellWitnesses_967 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_967

theorem pellMasks_967_valid : ∀ m ∈ pellMasks_967, m.Valid 967 := by
  exact pellLightMasks_valid 967 PellMatchingLightProduction.pellMasks_967 PellMatchingLightProduction.pellMasks_967_valid

theorem pellMatching_967_checked :
    pellMatchingCheck pellMasks_967 pellMagnitudes_967 pellWitnesses_967 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_967
    PellMatchingLightProduction.pellMagnitudes_967 PellMatchingLightProduction.pellWitnesses_967).symm.trans
      PellMatchingLightProduction.pellMatching_967_checked

theorem pellMagnitudes_967_large : ∀ x ∈ pellMagnitudes_967, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_967 PellMatchingLightProduction.pellMagnitudes_967_large

def pellGraphCertificate_967 : PellMatchingCertificate 967 where
  magnitudes := pellMagnitudes_967
  masks := pellMasks_967
  witnesses := pellWitnesses_967
  masks_valid := pellMasks_967_valid
  checked := pellMatching_967_checked
  large := pellMagnitudes_967_large

def pellMagnitudes_983 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_983

def pellMasks_983 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_983.map pellLightMasksToOriginal

def pellWitnesses_983 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_983

theorem pellMasks_983_valid : ∀ m ∈ pellMasks_983, m.Valid 983 := by
  exact pellLightMasks_valid 983 PellMatchingLightProduction.pellMasks_983 PellMatchingLightProduction.pellMasks_983_valid

theorem pellMatching_983_checked :
    pellMatchingCheck pellMasks_983 pellMagnitudes_983 pellWitnesses_983 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_983
    PellMatchingLightProduction.pellMagnitudes_983 PellMatchingLightProduction.pellWitnesses_983).symm.trans
      PellMatchingLightProduction.pellMatching_983_checked

theorem pellMagnitudes_983_large : ∀ x ∈ pellMagnitudes_983, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_983 PellMatchingLightProduction.pellMagnitudes_983_large

def pellGraphCertificate_983 : PellMatchingCertificate 983 where
  magnitudes := pellMagnitudes_983
  masks := pellMasks_983
  witnesses := pellWitnesses_983
  masks_valid := pellMasks_983_valid
  checked := pellMatching_983_checked
  large := pellMagnitudes_983_large

def pellMagnitudes_991 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_991

def pellMasks_991 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_991.map pellLightMasksToOriginal

def pellWitnesses_991 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_991

theorem pellMasks_991_valid : ∀ m ∈ pellMasks_991, m.Valid 991 := by
  exact pellLightMasks_valid 991 PellMatchingLightProduction.pellMasks_991 PellMatchingLightProduction.pellMasks_991_valid

theorem pellMatching_991_checked :
    pellMatchingCheck pellMasks_991 pellMagnitudes_991 pellWitnesses_991 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_991
    PellMatchingLightProduction.pellMagnitudes_991 PellMatchingLightProduction.pellWitnesses_991).symm.trans
      PellMatchingLightProduction.pellMatching_991_checked

theorem pellMagnitudes_991_large : ∀ x ∈ pellMagnitudes_991, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_991 PellMatchingLightProduction.pellMagnitudes_991_large

def pellGraphCertificate_991 : PellMatchingCertificate 991 where
  magnitudes := pellMagnitudes_991
  masks := pellMasks_991
  witnesses := pellWitnesses_991
  masks_valid := pellMasks_991_valid
  checked := pellMatching_991_checked
  large := pellMagnitudes_991_large

def pellMagnitudes_1031 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1031

def pellMasks_1031 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1031.map pellLightMasksToOriginal

def pellWitnesses_1031 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1031

theorem pellMasks_1031_valid : ∀ m ∈ pellMasks_1031, m.Valid 1031 := by
  exact pellLightMasks_valid 1031 PellMatchingLightProduction.pellMasks_1031 PellMatchingLightProduction.pellMasks_1031_valid

theorem pellMatching_1031_checked :
    pellMatchingCheck pellMasks_1031 pellMagnitudes_1031 pellWitnesses_1031 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1031
    PellMatchingLightProduction.pellMagnitudes_1031 PellMatchingLightProduction.pellWitnesses_1031).symm.trans
      PellMatchingLightProduction.pellMatching_1031_checked

theorem pellMagnitudes_1031_large : ∀ x ∈ pellMagnitudes_1031, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1031 PellMatchingLightProduction.pellMagnitudes_1031_large

def pellGraphCertificate_1031 : PellMatchingCertificate 1031 where
  magnitudes := pellMagnitudes_1031
  masks := pellMasks_1031
  witnesses := pellWitnesses_1031
  masks_valid := pellMasks_1031_valid
  checked := pellMatching_1031_checked
  large := pellMagnitudes_1031_large

def pellMagnitudes_1039 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1039

def pellMasks_1039 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1039.map pellLightMasksToOriginal

def pellWitnesses_1039 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1039

theorem pellMasks_1039_valid : ∀ m ∈ pellMasks_1039, m.Valid 1039 := by
  exact pellLightMasks_valid 1039 PellMatchingLightProduction.pellMasks_1039 PellMatchingLightProduction.pellMasks_1039_valid

theorem pellMatching_1039_checked :
    pellMatchingCheck pellMasks_1039 pellMagnitudes_1039 pellWitnesses_1039 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1039
    PellMatchingLightProduction.pellMagnitudes_1039 PellMatchingLightProduction.pellWitnesses_1039).symm.trans
      PellMatchingLightProduction.pellMatching_1039_checked

theorem pellMagnitudes_1039_large : ∀ x ∈ pellMagnitudes_1039, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1039 PellMatchingLightProduction.pellMagnitudes_1039_large

def pellGraphCertificate_1039 : PellMatchingCertificate 1039 where
  magnitudes := pellMagnitudes_1039
  masks := pellMasks_1039
  witnesses := pellWitnesses_1039
  masks_valid := pellMasks_1039_valid
  checked := pellMatching_1039_checked
  large := pellMagnitudes_1039_large

def pellMagnitudes_1063 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1063

def pellMasks_1063 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1063.map pellLightMasksToOriginal

def pellWitnesses_1063 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1063

theorem pellMasks_1063_valid : ∀ m ∈ pellMasks_1063, m.Valid 1063 := by
  exact pellLightMasks_valid 1063 PellMatchingLightProduction.pellMasks_1063 PellMatchingLightProduction.pellMasks_1063_valid

theorem pellMatching_1063_checked :
    pellMatchingCheck pellMasks_1063 pellMagnitudes_1063 pellWitnesses_1063 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1063
    PellMatchingLightProduction.pellMagnitudes_1063 PellMatchingLightProduction.pellWitnesses_1063).symm.trans
      PellMatchingLightProduction.pellMatching_1063_checked

theorem pellMagnitudes_1063_large : ∀ x ∈ pellMagnitudes_1063, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1063 PellMatchingLightProduction.pellMagnitudes_1063_large

def pellGraphCertificate_1063 : PellMatchingCertificate 1063 where
  magnitudes := pellMagnitudes_1063
  masks := pellMasks_1063
  witnesses := pellWitnesses_1063
  masks_valid := pellMasks_1063_valid
  checked := pellMatching_1063_checked
  large := pellMagnitudes_1063_large

def pellMagnitudes_1087 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1087

def pellMasks_1087 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1087.map pellLightMasksToOriginal

def pellWitnesses_1087 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1087

theorem pellMasks_1087_valid : ∀ m ∈ pellMasks_1087, m.Valid 1087 := by
  exact pellLightMasks_valid 1087 PellMatchingLightProduction.pellMasks_1087 PellMatchingLightProduction.pellMasks_1087_valid

theorem pellMatching_1087_checked :
    pellMatchingCheck pellMasks_1087 pellMagnitudes_1087 pellWitnesses_1087 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1087
    PellMatchingLightProduction.pellMagnitudes_1087 PellMatchingLightProduction.pellWitnesses_1087).symm.trans
      PellMatchingLightProduction.pellMatching_1087_checked

theorem pellMagnitudes_1087_large : ∀ x ∈ pellMagnitudes_1087, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1087 PellMatchingLightProduction.pellMagnitudes_1087_large

def pellGraphCertificate_1087 : PellMatchingCertificate 1087 where
  magnitudes := pellMagnitudes_1087
  masks := pellMasks_1087
  witnesses := pellWitnesses_1087
  masks_valid := pellMasks_1087_valid
  checked := pellMatching_1087_checked
  large := pellMagnitudes_1087_large

def pellMagnitudes_1103 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1103

def pellMasks_1103 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1103.map pellLightMasksToOriginal

def pellWitnesses_1103 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1103

theorem pellMasks_1103_valid : ∀ m ∈ pellMasks_1103, m.Valid 1103 := by
  exact pellLightMasks_valid 1103 PellMatchingLightProduction.pellMasks_1103 PellMatchingLightProduction.pellMasks_1103_valid

theorem pellMatching_1103_checked :
    pellMatchingCheck pellMasks_1103 pellMagnitudes_1103 pellWitnesses_1103 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1103
    PellMatchingLightProduction.pellMagnitudes_1103 PellMatchingLightProduction.pellWitnesses_1103).symm.trans
      PellMatchingLightProduction.pellMatching_1103_checked

theorem pellMagnitudes_1103_large : ∀ x ∈ pellMagnitudes_1103, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1103 PellMatchingLightProduction.pellMagnitudes_1103_large

def pellGraphCertificate_1103 : PellMatchingCertificate 1103 where
  magnitudes := pellMagnitudes_1103
  masks := pellMasks_1103
  witnesses := pellWitnesses_1103
  masks_valid := pellMasks_1103_valid
  checked := pellMatching_1103_checked
  large := pellMagnitudes_1103_large

def pellMagnitudes_1151 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1151

def pellMasks_1151 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1151.map pellLightMasksToOriginal

def pellWitnesses_1151 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1151

theorem pellMasks_1151_valid : ∀ m ∈ pellMasks_1151, m.Valid 1151 := by
  exact pellLightMasks_valid 1151 PellMatchingLightProduction.pellMasks_1151 PellMatchingLightProduction.pellMasks_1151_valid

theorem pellMatching_1151_checked :
    pellMatchingCheck pellMasks_1151 pellMagnitudes_1151 pellWitnesses_1151 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1151
    PellMatchingLightProduction.pellMagnitudes_1151 PellMatchingLightProduction.pellWitnesses_1151).symm.trans
      PellMatchingLightProduction.pellMatching_1151_checked

theorem pellMagnitudes_1151_large : ∀ x ∈ pellMagnitudes_1151, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1151 PellMatchingLightProduction.pellMagnitudes_1151_large

def pellGraphCertificate_1151 : PellMatchingCertificate 1151 where
  magnitudes := pellMagnitudes_1151
  masks := pellMasks_1151
  witnesses := pellWitnesses_1151
  masks_valid := pellMasks_1151_valid
  checked := pellMatching_1151_checked
  large := pellMagnitudes_1151_large

def pellMagnitudes_1207 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1207

def pellMasks_1207 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1207.map pellLightMasksToOriginal

def pellWitnesses_1207 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1207

theorem pellMasks_1207_valid : ∀ m ∈ pellMasks_1207, m.Valid 1207 := by
  exact pellLightMasks_valid 1207 PellMatchingLightProduction.pellMasks_1207 PellMatchingLightProduction.pellMasks_1207_valid

theorem pellMatching_1207_checked :
    pellMatchingCheck pellMasks_1207 pellMagnitudes_1207 pellWitnesses_1207 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1207
    PellMatchingLightProduction.pellMagnitudes_1207 PellMatchingLightProduction.pellWitnesses_1207).symm.trans
      PellMatchingLightProduction.pellMatching_1207_checked

theorem pellMagnitudes_1207_large : ∀ x ∈ pellMagnitudes_1207, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1207 PellMatchingLightProduction.pellMagnitudes_1207_large

def pellGraphCertificate_1207 : PellMatchingCertificate 1207 where
  magnitudes := pellMagnitudes_1207
  masks := pellMasks_1207
  witnesses := pellWitnesses_1207
  masks_valid := pellMasks_1207_valid
  checked := pellMatching_1207_checked
  large := pellMagnitudes_1207_large

def pellMagnitudes_1223 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1223

def pellMasks_1223 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1223.map pellLightMasksToOriginal

def pellWitnesses_1223 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1223

theorem pellMasks_1223_valid : ∀ m ∈ pellMasks_1223, m.Valid 1223 := by
  exact pellLightMasks_valid 1223 PellMatchingLightProduction.pellMasks_1223 PellMatchingLightProduction.pellMasks_1223_valid

theorem pellMatching_1223_checked :
    pellMatchingCheck pellMasks_1223 pellMagnitudes_1223 pellWitnesses_1223 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1223
    PellMatchingLightProduction.pellMagnitudes_1223 PellMatchingLightProduction.pellWitnesses_1223).symm.trans
      PellMatchingLightProduction.pellMatching_1223_checked

theorem pellMagnitudes_1223_large : ∀ x ∈ pellMagnitudes_1223, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1223 PellMatchingLightProduction.pellMagnitudes_1223_large

def pellGraphCertificate_1223 : PellMatchingCertificate 1223 where
  magnitudes := pellMagnitudes_1223
  masks := pellMasks_1223
  witnesses := pellWitnesses_1223
  masks_valid := pellMasks_1223_valid
  checked := pellMatching_1223_checked
  large := pellMagnitudes_1223_large

def pellMagnitudes_1231 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1231

def pellMasks_1231 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1231.map pellLightMasksToOriginal

def pellWitnesses_1231 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1231

theorem pellMasks_1231_valid : ∀ m ∈ pellMasks_1231, m.Valid 1231 := by
  exact pellLightMasks_valid 1231 PellMatchingLightProduction.pellMasks_1231 PellMatchingLightProduction.pellMasks_1231_valid

theorem pellMatching_1231_checked :
    pellMatchingCheck pellMasks_1231 pellMagnitudes_1231 pellWitnesses_1231 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1231
    PellMatchingLightProduction.pellMagnitudes_1231 PellMatchingLightProduction.pellWitnesses_1231).symm.trans
      PellMatchingLightProduction.pellMatching_1231_checked

theorem pellMagnitudes_1231_large : ∀ x ∈ pellMagnitudes_1231, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1231 PellMatchingLightProduction.pellMagnitudes_1231_large

def pellGraphCertificate_1231 : PellMatchingCertificate 1231 where
  magnitudes := pellMagnitudes_1231
  masks := pellMasks_1231
  witnesses := pellWitnesses_1231
  masks_valid := pellMasks_1231_valid
  checked := pellMatching_1231_checked
  large := pellMagnitudes_1231_large

def pellMagnitudes_1279 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1279

def pellMasks_1279 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1279.map pellLightMasksToOriginal

def pellWitnesses_1279 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1279

theorem pellMasks_1279_valid : ∀ m ∈ pellMasks_1279, m.Valid 1279 := by
  exact pellLightMasks_valid 1279 PellMatchingLightProduction.pellMasks_1279 PellMatchingLightProduction.pellMasks_1279_valid

theorem pellMatching_1279_checked :
    pellMatchingCheck pellMasks_1279 pellMagnitudes_1279 pellWitnesses_1279 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1279
    PellMatchingLightProduction.pellMagnitudes_1279 PellMatchingLightProduction.pellWitnesses_1279).symm.trans
      PellMatchingLightProduction.pellMatching_1279_checked

theorem pellMagnitudes_1279_large : ∀ x ∈ pellMagnitudes_1279, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1279 PellMatchingLightProduction.pellMagnitudes_1279_large

def pellGraphCertificate_1279 : PellMatchingCertificate 1279 where
  magnitudes := pellMagnitudes_1279
  masks := pellMasks_1279
  witnesses := pellWitnesses_1279
  masks_valid := pellMasks_1279_valid
  checked := pellMatching_1279_checked
  large := pellMagnitudes_1279_large

def pellMagnitudes_1303 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1303

def pellMasks_1303 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1303.map pellLightMasksToOriginal

def pellWitnesses_1303 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1303

theorem pellMasks_1303_valid : ∀ m ∈ pellMasks_1303, m.Valid 1303 := by
  exact pellLightMasks_valid 1303 PellMatchingLightProduction.pellMasks_1303 PellMatchingLightProduction.pellMasks_1303_valid

theorem pellMatching_1303_checked :
    pellMatchingCheck pellMasks_1303 pellMagnitudes_1303 pellWitnesses_1303 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1303
    PellMatchingLightProduction.pellMagnitudes_1303 PellMatchingLightProduction.pellWitnesses_1303).symm.trans
      PellMatchingLightProduction.pellMatching_1303_checked

theorem pellMagnitudes_1303_large : ∀ x ∈ pellMagnitudes_1303, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1303 PellMatchingLightProduction.pellMagnitudes_1303_large

def pellGraphCertificate_1303 : PellMatchingCertificate 1303 where
  magnitudes := pellMagnitudes_1303
  masks := pellMasks_1303
  witnesses := pellWitnesses_1303
  masks_valid := pellMasks_1303_valid
  checked := pellMatching_1303_checked
  large := pellMagnitudes_1303_large

def pellMagnitudes_1319 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1319

def pellMasks_1319 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1319.map pellLightMasksToOriginal

def pellWitnesses_1319 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1319

theorem pellMasks_1319_valid : ∀ m ∈ pellMasks_1319, m.Valid 1319 := by
  exact pellLightMasks_valid 1319 PellMatchingLightProduction.pellMasks_1319 PellMatchingLightProduction.pellMasks_1319_valid

theorem pellMatching_1319_checked :
    pellMatchingCheck pellMasks_1319 pellMagnitudes_1319 pellWitnesses_1319 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1319
    PellMatchingLightProduction.pellMagnitudes_1319 PellMatchingLightProduction.pellWitnesses_1319).symm.trans
      PellMatchingLightProduction.pellMatching_1319_checked

theorem pellMagnitudes_1319_large : ∀ x ∈ pellMagnitudes_1319, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1319 PellMatchingLightProduction.pellMagnitudes_1319_large

def pellGraphCertificate_1319 : PellMatchingCertificate 1319 where
  magnitudes := pellMagnitudes_1319
  masks := pellMasks_1319
  witnesses := pellWitnesses_1319
  masks_valid := pellMasks_1319_valid
  checked := pellMatching_1319_checked
  large := pellMagnitudes_1319_large

def pellMagnitudes_1327 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1327

def pellMasks_1327 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1327.map pellLightMasksToOriginal

def pellWitnesses_1327 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1327

theorem pellMasks_1327_valid : ∀ m ∈ pellMasks_1327, m.Valid 1327 := by
  exact pellLightMasks_valid 1327 PellMatchingLightProduction.pellMasks_1327 PellMatchingLightProduction.pellMasks_1327_valid

theorem pellMatching_1327_checked :
    pellMatchingCheck pellMasks_1327 pellMagnitudes_1327 pellWitnesses_1327 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1327
    PellMatchingLightProduction.pellMagnitudes_1327 PellMatchingLightProduction.pellWitnesses_1327).symm.trans
      PellMatchingLightProduction.pellMatching_1327_checked

theorem pellMagnitudes_1327_large : ∀ x ∈ pellMagnitudes_1327, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1327 PellMatchingLightProduction.pellMagnitudes_1327_large

def pellGraphCertificate_1327 : PellMatchingCertificate 1327 where
  magnitudes := pellMagnitudes_1327
  masks := pellMasks_1327
  witnesses := pellWitnesses_1327
  masks_valid := pellMasks_1327_valid
  checked := pellMatching_1327_checked
  large := pellMagnitudes_1327_large

def pellMagnitudes_1343 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1343

def pellMasks_1343 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1343.map pellLightMasksToOriginal

def pellWitnesses_1343 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1343

theorem pellMasks_1343_valid : ∀ m ∈ pellMasks_1343, m.Valid 1343 := by
  exact pellLightMasks_valid 1343 PellMatchingLightProduction.pellMasks_1343 PellMatchingLightProduction.pellMasks_1343_valid

theorem pellMatching_1343_checked :
    pellMatchingCheck pellMasks_1343 pellMagnitudes_1343 pellWitnesses_1343 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1343
    PellMatchingLightProduction.pellMagnitudes_1343 PellMatchingLightProduction.pellWitnesses_1343).symm.trans
      PellMatchingLightProduction.pellMatching_1343_checked

theorem pellMagnitudes_1343_large : ∀ x ∈ pellMagnitudes_1343, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1343 PellMatchingLightProduction.pellMagnitudes_1343_large

def pellGraphCertificate_1343 : PellMatchingCertificate 1343 where
  magnitudes := pellMagnitudes_1343
  masks := pellMasks_1343
  witnesses := pellWitnesses_1343
  masks_valid := pellMasks_1343_valid
  checked := pellMatching_1343_checked
  large := pellMagnitudes_1343_large

def pellMagnitudes_1367 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1367

def pellMasks_1367 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1367.map pellLightMasksToOriginal

def pellWitnesses_1367 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1367

theorem pellMasks_1367_valid : ∀ m ∈ pellMasks_1367, m.Valid 1367 := by
  exact pellLightMasks_valid 1367 PellMatchingLightProduction.pellMasks_1367 PellMatchingLightProduction.pellMasks_1367_valid

theorem pellMatching_1367_checked :
    pellMatchingCheck pellMasks_1367 pellMagnitudes_1367 pellWitnesses_1367 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1367
    PellMatchingLightProduction.pellMagnitudes_1367 PellMatchingLightProduction.pellWitnesses_1367).symm.trans
      PellMatchingLightProduction.pellMatching_1367_checked

theorem pellMagnitudes_1367_large : ∀ x ∈ pellMagnitudes_1367, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1367 PellMatchingLightProduction.pellMagnitudes_1367_large

def pellGraphCertificate_1367 : PellMatchingCertificate 1367 where
  magnitudes := pellMagnitudes_1367
  masks := pellMasks_1367
  witnesses := pellWitnesses_1367
  masks_valid := pellMasks_1367_valid
  checked := pellMatching_1367_checked
  large := pellMagnitudes_1367_large

def pellMagnitudes_1399 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1399

def pellMasks_1399 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1399.map pellLightMasksToOriginal

def pellWitnesses_1399 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1399

theorem pellMasks_1399_valid : ∀ m ∈ pellMasks_1399, m.Valid 1399 := by
  exact pellLightMasks_valid 1399 PellMatchingLightProduction.pellMasks_1399 PellMatchingLightProduction.pellMasks_1399_valid

theorem pellMatching_1399_checked :
    pellMatchingCheck pellMasks_1399 pellMagnitudes_1399 pellWitnesses_1399 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1399
    PellMatchingLightProduction.pellMagnitudes_1399 PellMatchingLightProduction.pellWitnesses_1399).symm.trans
      PellMatchingLightProduction.pellMatching_1399_checked

theorem pellMagnitudes_1399_large : ∀ x ∈ pellMagnitudes_1399, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1399 PellMatchingLightProduction.pellMagnitudes_1399_large

def pellGraphCertificate_1399 : PellMatchingCertificate 1399 where
  magnitudes := pellMagnitudes_1399
  masks := pellMasks_1399
  witnesses := pellWitnesses_1399
  masks_valid := pellMasks_1399_valid
  checked := pellMatching_1399_checked
  large := pellMagnitudes_1399_large

def pellMagnitudes_1423 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1423

def pellMasks_1423 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1423.map pellLightMasksToOriginal

def pellWitnesses_1423 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1423

theorem pellMasks_1423_valid : ∀ m ∈ pellMasks_1423, m.Valid 1423 := by
  exact pellLightMasks_valid 1423 PellMatchingLightProduction.pellMasks_1423 PellMatchingLightProduction.pellMasks_1423_valid

theorem pellMatching_1423_checked :
    pellMatchingCheck pellMasks_1423 pellMagnitudes_1423 pellWitnesses_1423 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1423
    PellMatchingLightProduction.pellMagnitudes_1423 PellMatchingLightProduction.pellWitnesses_1423).symm.trans
      PellMatchingLightProduction.pellMatching_1423_checked

theorem pellMagnitudes_1423_large : ∀ x ∈ pellMagnitudes_1423, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1423 PellMatchingLightProduction.pellMagnitudes_1423_large

def pellGraphCertificate_1423 : PellMatchingCertificate 1423 where
  magnitudes := pellMagnitudes_1423
  masks := pellMasks_1423
  witnesses := pellWitnesses_1423
  masks_valid := pellMasks_1423_valid
  checked := pellMatching_1423_checked
  large := pellMagnitudes_1423_large

def pellMagnitudes_1439 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1439

def pellMasks_1439 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1439.map pellLightMasksToOriginal

def pellWitnesses_1439 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1439

theorem pellMasks_1439_valid : ∀ m ∈ pellMasks_1439, m.Valid 1439 := by
  exact pellLightMasks_valid 1439 PellMatchingLightProduction.pellMasks_1439 PellMatchingLightProduction.pellMasks_1439_valid

theorem pellMatching_1439_checked :
    pellMatchingCheck pellMasks_1439 pellMagnitudes_1439 pellWitnesses_1439 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1439
    PellMatchingLightProduction.pellMagnitudes_1439 PellMatchingLightProduction.pellWitnesses_1439).symm.trans
      PellMatchingLightProduction.pellMatching_1439_checked

theorem pellMagnitudes_1439_large : ∀ x ∈ pellMagnitudes_1439, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1439 PellMatchingLightProduction.pellMagnitudes_1439_large

def pellGraphCertificate_1439 : PellMatchingCertificate 1439 where
  magnitudes := pellMagnitudes_1439
  masks := pellMasks_1439
  witnesses := pellWitnesses_1439
  masks_valid := pellMasks_1439_valid
  checked := pellMatching_1439_checked
  large := pellMagnitudes_1439_large

def pellMagnitudes_1447 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1447

def pellMasks_1447 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1447.map pellLightMasksToOriginal

def pellWitnesses_1447 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1447

theorem pellMasks_1447_valid : ∀ m ∈ pellMasks_1447, m.Valid 1447 := by
  exact pellLightMasks_valid 1447 PellMatchingLightProduction.pellMasks_1447 PellMatchingLightProduction.pellMasks_1447_valid

theorem pellMatching_1447_checked :
    pellMatchingCheck pellMasks_1447 pellMagnitudes_1447 pellWitnesses_1447 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1447
    PellMatchingLightProduction.pellMagnitudes_1447 PellMatchingLightProduction.pellWitnesses_1447).symm.trans
      PellMatchingLightProduction.pellMatching_1447_checked

theorem pellMagnitudes_1447_large : ∀ x ∈ pellMagnitudes_1447, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1447 PellMatchingLightProduction.pellMagnitudes_1447_large

def pellGraphCertificate_1447 : PellMatchingCertificate 1447 where
  magnitudes := pellMagnitudes_1447
  masks := pellMasks_1447
  witnesses := pellWitnesses_1447
  masks_valid := pellMasks_1447_valid
  checked := pellMatching_1447_checked
  large := pellMagnitudes_1447_large

def pellMagnitudes_1471 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1471

def pellMasks_1471 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1471.map pellLightMasksToOriginal

def pellWitnesses_1471 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1471

theorem pellMasks_1471_valid : ∀ m ∈ pellMasks_1471, m.Valid 1471 := by
  exact pellLightMasks_valid 1471 PellMatchingLightProduction.pellMasks_1471 PellMatchingLightProduction.pellMasks_1471_valid

theorem pellMatching_1471_checked :
    pellMatchingCheck pellMasks_1471 pellMagnitudes_1471 pellWitnesses_1471 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1471
    PellMatchingLightProduction.pellMagnitudes_1471 PellMatchingLightProduction.pellWitnesses_1471).symm.trans
      PellMatchingLightProduction.pellMatching_1471_checked

theorem pellMagnitudes_1471_large : ∀ x ∈ pellMagnitudes_1471, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1471 PellMatchingLightProduction.pellMagnitudes_1471_large

def pellGraphCertificate_1471 : PellMatchingCertificate 1471 where
  magnitudes := pellMagnitudes_1471
  masks := pellMasks_1471
  witnesses := pellWitnesses_1471
  masks_valid := pellMasks_1471_valid
  checked := pellMatching_1471_checked
  large := pellMagnitudes_1471_large

def pellMagnitudes_1487 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1487

def pellMasks_1487 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1487.map pellLightMasksToOriginal

def pellWitnesses_1487 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1487

theorem pellMasks_1487_valid : ∀ m ∈ pellMasks_1487, m.Valid 1487 := by
  exact pellLightMasks_valid 1487 PellMatchingLightProduction.pellMasks_1487 PellMatchingLightProduction.pellMasks_1487_valid

theorem pellMatching_1487_checked :
    pellMatchingCheck pellMasks_1487 pellMagnitudes_1487 pellWitnesses_1487 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1487
    PellMatchingLightProduction.pellMagnitudes_1487 PellMatchingLightProduction.pellWitnesses_1487).symm.trans
      PellMatchingLightProduction.pellMatching_1487_checked

theorem pellMagnitudes_1487_large : ∀ x ∈ pellMagnitudes_1487, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1487 PellMatchingLightProduction.pellMagnitudes_1487_large

def pellGraphCertificate_1487 : PellMatchingCertificate 1487 where
  magnitudes := pellMagnitudes_1487
  masks := pellMasks_1487
  witnesses := pellWitnesses_1487
  masks_valid := pellMasks_1487_valid
  checked := pellMatching_1487_checked
  large := pellMagnitudes_1487_large

def pellMagnitudes_1511 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1511

def pellMasks_1511 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1511.map pellLightMasksToOriginal

def pellWitnesses_1511 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1511

theorem pellMasks_1511_valid : ∀ m ∈ pellMasks_1511, m.Valid 1511 := by
  exact pellLightMasks_valid 1511 PellMatchingLightProduction.pellMasks_1511 PellMatchingLightProduction.pellMasks_1511_valid

theorem pellMatching_1511_checked :
    pellMatchingCheck pellMasks_1511 pellMagnitudes_1511 pellWitnesses_1511 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1511
    PellMatchingLightProduction.pellMagnitudes_1511 PellMatchingLightProduction.pellWitnesses_1511).symm.trans
      PellMatchingLightProduction.pellMatching_1511_checked

theorem pellMagnitudes_1511_large : ∀ x ∈ pellMagnitudes_1511, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1511 PellMatchingLightProduction.pellMagnitudes_1511_large

def pellGraphCertificate_1511 : PellMatchingCertificate 1511 where
  magnitudes := pellMagnitudes_1511
  masks := pellMasks_1511
  witnesses := pellWitnesses_1511
  masks_valid := pellMasks_1511_valid
  checked := pellMatching_1511_checked
  large := pellMagnitudes_1511_large

def pellMagnitudes_1543 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1543

def pellMasks_1543 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1543.map pellLightMasksToOriginal

def pellWitnesses_1543 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1543

theorem pellMasks_1543_valid : ∀ m ∈ pellMasks_1543, m.Valid 1543 := by
  exact pellLightMasks_valid 1543 PellMatchingLightProduction.pellMasks_1543 PellMatchingLightProduction.pellMasks_1543_valid

theorem pellMatching_1543_checked :
    pellMatchingCheck pellMasks_1543 pellMagnitudes_1543 pellWitnesses_1543 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1543
    PellMatchingLightProduction.pellMagnitudes_1543 PellMatchingLightProduction.pellWitnesses_1543).symm.trans
      PellMatchingLightProduction.pellMatching_1543_checked

theorem pellMagnitudes_1543_large : ∀ x ∈ pellMagnitudes_1543, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1543 PellMatchingLightProduction.pellMagnitudes_1543_large

def pellGraphCertificate_1543 : PellMatchingCertificate 1543 where
  magnitudes := pellMagnitudes_1543
  masks := pellMasks_1543
  witnesses := pellWitnesses_1543
  masks_valid := pellMasks_1543_valid
  checked := pellMatching_1543_checked
  large := pellMagnitudes_1543_large

def pellMagnitudes_1559 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1559

def pellMasks_1559 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1559.map pellLightMasksToOriginal

def pellWitnesses_1559 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1559

theorem pellMasks_1559_valid : ∀ m ∈ pellMasks_1559, m.Valid 1559 := by
  exact pellLightMasks_valid 1559 PellMatchingLightProduction.pellMasks_1559 PellMatchingLightProduction.pellMasks_1559_valid

theorem pellMatching_1559_checked :
    pellMatchingCheck pellMasks_1559 pellMagnitudes_1559 pellWitnesses_1559 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1559
    PellMatchingLightProduction.pellMagnitudes_1559 PellMatchingLightProduction.pellWitnesses_1559).symm.trans
      PellMatchingLightProduction.pellMatching_1559_checked

theorem pellMagnitudes_1559_large : ∀ x ∈ pellMagnitudes_1559, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1559 PellMatchingLightProduction.pellMagnitudes_1559_large

def pellGraphCertificate_1559 : PellMatchingCertificate 1559 where
  magnitudes := pellMagnitudes_1559
  masks := pellMasks_1559
  witnesses := pellWitnesses_1559
  masks_valid := pellMasks_1559_valid
  checked := pellMatching_1559_checked
  large := pellMagnitudes_1559_large

def pellMagnitudes_1567 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1567

def pellMasks_1567 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1567.map pellLightMasksToOriginal

def pellWitnesses_1567 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1567

theorem pellMasks_1567_valid : ∀ m ∈ pellMasks_1567, m.Valid 1567 := by
  exact pellLightMasks_valid 1567 PellMatchingLightProduction.pellMasks_1567 PellMatchingLightProduction.pellMasks_1567_valid

theorem pellMatching_1567_checked :
    pellMatchingCheck pellMasks_1567 pellMagnitudes_1567 pellWitnesses_1567 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1567
    PellMatchingLightProduction.pellMagnitudes_1567 PellMatchingLightProduction.pellWitnesses_1567).symm.trans
      PellMatchingLightProduction.pellMatching_1567_checked

theorem pellMagnitudes_1567_large : ∀ x ∈ pellMagnitudes_1567, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1567 PellMatchingLightProduction.pellMagnitudes_1567_large

def pellGraphCertificate_1567 : PellMatchingCertificate 1567 where
  magnitudes := pellMagnitudes_1567
  masks := pellMasks_1567
  witnesses := pellWitnesses_1567
  masks_valid := pellMasks_1567_valid
  checked := pellMatching_1567_checked
  large := pellMagnitudes_1567_large

def pellMagnitudes_1583 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1583

def pellMasks_1583 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1583.map pellLightMasksToOriginal

def pellWitnesses_1583 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1583

theorem pellMasks_1583_valid : ∀ m ∈ pellMasks_1583, m.Valid 1583 := by
  exact pellLightMasks_valid 1583 PellMatchingLightProduction.pellMasks_1583 PellMatchingLightProduction.pellMasks_1583_valid

theorem pellMatching_1583_checked :
    pellMatchingCheck pellMasks_1583 pellMagnitudes_1583 pellWitnesses_1583 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1583
    PellMatchingLightProduction.pellMagnitudes_1583 PellMatchingLightProduction.pellWitnesses_1583).symm.trans
      PellMatchingLightProduction.pellMatching_1583_checked

theorem pellMagnitudes_1583_large : ∀ x ∈ pellMagnitudes_1583, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1583 PellMatchingLightProduction.pellMagnitudes_1583_large

def pellGraphCertificate_1583 : PellMatchingCertificate 1583 where
  magnitudes := pellMagnitudes_1583
  masks := pellMasks_1583
  witnesses := pellWitnesses_1583
  masks_valid := pellMasks_1583_valid
  checked := pellMatching_1583_checked
  large := pellMagnitudes_1583_large

def pellMagnitudes_1607 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1607

def pellMasks_1607 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1607.map pellLightMasksToOriginal

def pellWitnesses_1607 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1607

theorem pellMasks_1607_valid : ∀ m ∈ pellMasks_1607, m.Valid 1607 := by
  exact pellLightMasks_valid 1607 PellMatchingLightProduction.pellMasks_1607 PellMatchingLightProduction.pellMasks_1607_valid

theorem pellMatching_1607_checked :
    pellMatchingCheck pellMasks_1607 pellMagnitudes_1607 pellWitnesses_1607 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1607
    PellMatchingLightProduction.pellMagnitudes_1607 PellMatchingLightProduction.pellWitnesses_1607).symm.trans
      PellMatchingLightProduction.pellMatching_1607_checked

theorem pellMagnitudes_1607_large : ∀ x ∈ pellMagnitudes_1607, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1607 PellMatchingLightProduction.pellMagnitudes_1607_large

def pellGraphCertificate_1607 : PellMatchingCertificate 1607 where
  magnitudes := pellMagnitudes_1607
  masks := pellMasks_1607
  witnesses := pellWitnesses_1607
  masks_valid := pellMasks_1607_valid
  checked := pellMatching_1607_checked
  large := pellMagnitudes_1607_large

def pellMagnitudes_1663 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1663

def pellMasks_1663 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1663.map pellLightMasksToOriginal

def pellWitnesses_1663 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1663

theorem pellMasks_1663_valid : ∀ m ∈ pellMasks_1663, m.Valid 1663 := by
  exact pellLightMasks_valid 1663 PellMatchingLightProduction.pellMasks_1663 PellMatchingLightProduction.pellMasks_1663_valid

theorem pellMatching_1663_checked :
    pellMatchingCheck pellMasks_1663 pellMagnitudes_1663 pellWitnesses_1663 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1663
    PellMatchingLightProduction.pellMagnitudes_1663 PellMatchingLightProduction.pellWitnesses_1663).symm.trans
      PellMatchingLightProduction.pellMatching_1663_checked

theorem pellMagnitudes_1663_large : ∀ x ∈ pellMagnitudes_1663, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1663 PellMatchingLightProduction.pellMagnitudes_1663_large

def pellGraphCertificate_1663 : PellMatchingCertificate 1663 where
  magnitudes := pellMagnitudes_1663
  masks := pellMasks_1663
  witnesses := pellWitnesses_1663
  masks_valid := pellMasks_1663_valid
  checked := pellMatching_1663_checked
  large := pellMagnitudes_1663_large

def pellMagnitudes_1679 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1679

def pellMasks_1679 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1679.map pellLightMasksToOriginal

def pellWitnesses_1679 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1679

theorem pellMasks_1679_valid : ∀ m ∈ pellMasks_1679, m.Valid 1679 := by
  exact pellLightMasks_valid 1679 PellMatchingLightProduction.pellMasks_1679 PellMatchingLightProduction.pellMasks_1679_valid

theorem pellMatching_1679_checked :
    pellMatchingCheck pellMasks_1679 pellMagnitudes_1679 pellWitnesses_1679 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1679
    PellMatchingLightProduction.pellMagnitudes_1679 PellMatchingLightProduction.pellWitnesses_1679).symm.trans
      PellMatchingLightProduction.pellMatching_1679_checked

theorem pellMagnitudes_1679_large : ∀ x ∈ pellMagnitudes_1679, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1679 PellMatchingLightProduction.pellMagnitudes_1679_large

def pellGraphCertificate_1679 : PellMatchingCertificate 1679 where
  magnitudes := pellMagnitudes_1679
  masks := pellMasks_1679
  witnesses := pellWitnesses_1679
  masks_valid := pellMasks_1679_valid
  checked := pellMatching_1679_checked
  large := pellMagnitudes_1679_large

def pellMagnitudes_1687 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1687

def pellMasks_1687 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1687.map pellLightMasksToOriginal

def pellWitnesses_1687 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1687

theorem pellMasks_1687_valid : ∀ m ∈ pellMasks_1687, m.Valid 1687 := by
  exact pellLightMasks_valid 1687 PellMatchingLightProduction.pellMasks_1687 PellMatchingLightProduction.pellMasks_1687_valid

theorem pellMatching_1687_checked :
    pellMatchingCheck pellMasks_1687 pellMagnitudes_1687 pellWitnesses_1687 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1687
    PellMatchingLightProduction.pellMagnitudes_1687 PellMatchingLightProduction.pellWitnesses_1687).symm.trans
      PellMatchingLightProduction.pellMatching_1687_checked

theorem pellMagnitudes_1687_large : ∀ x ∈ pellMagnitudes_1687, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1687 PellMatchingLightProduction.pellMagnitudes_1687_large

def pellGraphCertificate_1687 : PellMatchingCertificate 1687 where
  magnitudes := pellMagnitudes_1687
  masks := pellMasks_1687
  witnesses := pellWitnesses_1687
  masks_valid := pellMasks_1687_valid
  checked := pellMatching_1687_checked
  large := pellMagnitudes_1687_large

def pellMagnitudes_1759 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1759

def pellMasks_1759 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1759.map pellLightMasksToOriginal

def pellWitnesses_1759 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1759

theorem pellMasks_1759_valid : ∀ m ∈ pellMasks_1759, m.Valid 1759 := by
  exact pellLightMasks_valid 1759 PellMatchingLightProduction.pellMasks_1759 PellMatchingLightProduction.pellMasks_1759_valid

theorem pellMatching_1759_checked :
    pellMatchingCheck pellMasks_1759 pellMagnitudes_1759 pellWitnesses_1759 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1759
    PellMatchingLightProduction.pellMagnitudes_1759 PellMatchingLightProduction.pellWitnesses_1759).symm.trans
      PellMatchingLightProduction.pellMatching_1759_checked

theorem pellMagnitudes_1759_large : ∀ x ∈ pellMagnitudes_1759, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1759 PellMatchingLightProduction.pellMagnitudes_1759_large

def pellGraphCertificate_1759 : PellMatchingCertificate 1759 where
  magnitudes := pellMagnitudes_1759
  masks := pellMasks_1759
  witnesses := pellWitnesses_1759
  masks_valid := pellMasks_1759_valid
  checked := pellMatching_1759_checked
  large := pellMagnitudes_1759_large

def pellMagnitudes_1783 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1783

def pellMasks_1783 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1783.map pellLightMasksToOriginal

def pellWitnesses_1783 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1783

theorem pellMasks_1783_valid : ∀ m ∈ pellMasks_1783, m.Valid 1783 := by
  exact pellLightMasks_valid 1783 PellMatchingLightProduction.pellMasks_1783 PellMatchingLightProduction.pellMasks_1783_valid

theorem pellMatching_1783_checked :
    pellMatchingCheck pellMasks_1783 pellMagnitudes_1783 pellWitnesses_1783 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1783
    PellMatchingLightProduction.pellMagnitudes_1783 PellMatchingLightProduction.pellWitnesses_1783).symm.trans
      PellMatchingLightProduction.pellMatching_1783_checked

theorem pellMagnitudes_1783_large : ∀ x ∈ pellMagnitudes_1783, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1783 PellMatchingLightProduction.pellMagnitudes_1783_large

def pellGraphCertificate_1783 : PellMatchingCertificate 1783 where
  magnitudes := pellMagnitudes_1783
  masks := pellMasks_1783
  witnesses := pellWitnesses_1783
  masks_valid := pellMasks_1783_valid
  checked := pellMatching_1783_checked
  large := pellMagnitudes_1783_large

def pellMagnitudes_1799 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1799

def pellMasks_1799 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1799.map pellLightMasksToOriginal

def pellWitnesses_1799 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1799

theorem pellMasks_1799_valid : ∀ m ∈ pellMasks_1799, m.Valid 1799 := by
  exact pellLightMasks_valid 1799 PellMatchingLightProduction.pellMasks_1799 PellMatchingLightProduction.pellMasks_1799_valid

theorem pellMatching_1799_checked :
    pellMatchingCheck pellMasks_1799 pellMagnitudes_1799 pellWitnesses_1799 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1799
    PellMatchingLightProduction.pellMagnitudes_1799 PellMatchingLightProduction.pellWitnesses_1799).symm.trans
      PellMatchingLightProduction.pellMatching_1799_checked

theorem pellMagnitudes_1799_large : ∀ x ∈ pellMagnitudes_1799, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1799 PellMatchingLightProduction.pellMagnitudes_1799_large

def pellGraphCertificate_1799 : PellMatchingCertificate 1799 where
  magnitudes := pellMagnitudes_1799
  masks := pellMasks_1799
  witnesses := pellWitnesses_1799
  masks_valid := pellMasks_1799_valid
  checked := pellMatching_1799_checked
  large := pellMagnitudes_1799_large

def pellMagnitudes_1823 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1823

def pellMasks_1823 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1823.map pellLightMasksToOriginal

def pellWitnesses_1823 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1823

theorem pellMasks_1823_valid : ∀ m ∈ pellMasks_1823, m.Valid 1823 := by
  exact pellLightMasks_valid 1823 PellMatchingLightProduction.pellMasks_1823 PellMatchingLightProduction.pellMasks_1823_valid

theorem pellMatching_1823_checked :
    pellMatchingCheck pellMasks_1823 pellMagnitudes_1823 pellWitnesses_1823 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1823
    PellMatchingLightProduction.pellMagnitudes_1823 PellMatchingLightProduction.pellWitnesses_1823).symm.trans
      PellMatchingLightProduction.pellMatching_1823_checked

theorem pellMagnitudes_1823_large : ∀ x ∈ pellMagnitudes_1823, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1823 PellMatchingLightProduction.pellMagnitudes_1823_large

def pellGraphCertificate_1823 : PellMatchingCertificate 1823 where
  magnitudes := pellMagnitudes_1823
  masks := pellMasks_1823
  witnesses := pellWitnesses_1823
  masks_valid := pellMasks_1823_valid
  checked := pellMatching_1823_checked
  large := pellMagnitudes_1823_large

def pellMagnitudes_1831 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1831

def pellMasks_1831 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1831.map pellLightMasksToOriginal

def pellWitnesses_1831 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1831

theorem pellMasks_1831_valid : ∀ m ∈ pellMasks_1831, m.Valid 1831 := by
  exact pellLightMasks_valid 1831 PellMatchingLightProduction.pellMasks_1831 PellMatchingLightProduction.pellMasks_1831_valid

theorem pellMatching_1831_checked :
    pellMatchingCheck pellMasks_1831 pellMagnitudes_1831 pellWitnesses_1831 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1831
    PellMatchingLightProduction.pellMagnitudes_1831 PellMatchingLightProduction.pellWitnesses_1831).symm.trans
      PellMatchingLightProduction.pellMatching_1831_checked

theorem pellMagnitudes_1831_large : ∀ x ∈ pellMagnitudes_1831, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1831 PellMatchingLightProduction.pellMagnitudes_1831_large

def pellGraphCertificate_1831 : PellMatchingCertificate 1831 where
  magnitudes := pellMagnitudes_1831
  masks := pellMasks_1831
  witnesses := pellWitnesses_1831
  masks_valid := pellMasks_1831_valid
  checked := pellMatching_1831_checked
  large := pellMagnitudes_1831_large

def pellMagnitudes_1847 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1847

def pellMasks_1847 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1847.map pellLightMasksToOriginal

def pellWitnesses_1847 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1847

theorem pellMasks_1847_valid : ∀ m ∈ pellMasks_1847, m.Valid 1847 := by
  exact pellLightMasks_valid 1847 PellMatchingLightProduction.pellMasks_1847 PellMatchingLightProduction.pellMasks_1847_valid

theorem pellMatching_1847_checked :
    pellMatchingCheck pellMasks_1847 pellMagnitudes_1847 pellWitnesses_1847 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1847
    PellMatchingLightProduction.pellMagnitudes_1847 PellMatchingLightProduction.pellWitnesses_1847).symm.trans
      PellMatchingLightProduction.pellMatching_1847_checked

theorem pellMagnitudes_1847_large : ∀ x ∈ pellMagnitudes_1847, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1847 PellMatchingLightProduction.pellMagnitudes_1847_large

def pellGraphCertificate_1847 : PellMatchingCertificate 1847 where
  magnitudes := pellMagnitudes_1847
  masks := pellMasks_1847
  witnesses := pellWitnesses_1847
  masks_valid := pellMasks_1847_valid
  checked := pellMatching_1847_checked
  large := pellMagnitudes_1847_large

def pellMagnitudes_1871 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1871

def pellMasks_1871 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1871.map pellLightMasksToOriginal

def pellWitnesses_1871 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1871

theorem pellMasks_1871_valid : ∀ m ∈ pellMasks_1871, m.Valid 1871 := by
  exact pellLightMasks_valid 1871 PellMatchingLightProduction.pellMasks_1871 PellMatchingLightProduction.pellMasks_1871_valid

theorem pellMatching_1871_checked :
    pellMatchingCheck pellMasks_1871 pellMagnitudes_1871 pellWitnesses_1871 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1871
    PellMatchingLightProduction.pellMagnitudes_1871 PellMatchingLightProduction.pellWitnesses_1871).symm.trans
      PellMatchingLightProduction.pellMatching_1871_checked

theorem pellMagnitudes_1871_large : ∀ x ∈ pellMagnitudes_1871, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1871 PellMatchingLightProduction.pellMagnitudes_1871_large

def pellGraphCertificate_1871 : PellMatchingCertificate 1871 where
  magnitudes := pellMagnitudes_1871
  masks := pellMasks_1871
  witnesses := pellWitnesses_1871
  masks_valid := pellMasks_1871_valid
  checked := pellMatching_1871_checked
  large := pellMagnitudes_1871_large

def pellMagnitudes_1879 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1879

def pellMasks_1879 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1879.map pellLightMasksToOriginal

def pellWitnesses_1879 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1879

theorem pellMasks_1879_valid : ∀ m ∈ pellMasks_1879, m.Valid 1879 := by
  exact pellLightMasks_valid 1879 PellMatchingLightProduction.pellMasks_1879 PellMatchingLightProduction.pellMasks_1879_valid

theorem pellMatching_1879_checked :
    pellMatchingCheck pellMasks_1879 pellMagnitudes_1879 pellWitnesses_1879 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1879
    PellMatchingLightProduction.pellMagnitudes_1879 PellMatchingLightProduction.pellWitnesses_1879).symm.trans
      PellMatchingLightProduction.pellMatching_1879_checked

theorem pellMagnitudes_1879_large : ∀ x ∈ pellMagnitudes_1879, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1879 PellMatchingLightProduction.pellMagnitudes_1879_large

def pellGraphCertificate_1879 : PellMatchingCertificate 1879 where
  magnitudes := pellMagnitudes_1879
  masks := pellMasks_1879
  witnesses := pellWitnesses_1879
  masks_valid := pellMasks_1879_valid
  checked := pellMatching_1879_checked
  large := pellMagnitudes_1879_large

def pellMagnitudes_1927 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1927

def pellMasks_1927 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1927.map pellLightMasksToOriginal

def pellWitnesses_1927 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1927

theorem pellMasks_1927_valid : ∀ m ∈ pellMasks_1927, m.Valid 1927 := by
  exact pellLightMasks_valid 1927 PellMatchingLightProduction.pellMasks_1927 PellMatchingLightProduction.pellMasks_1927_valid

theorem pellMatching_1927_checked :
    pellMatchingCheck pellMasks_1927 pellMagnitudes_1927 pellWitnesses_1927 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1927
    PellMatchingLightProduction.pellMagnitudes_1927 PellMatchingLightProduction.pellWitnesses_1927).symm.trans
      PellMatchingLightProduction.pellMatching_1927_checked

theorem pellMagnitudes_1927_large : ∀ x ∈ pellMagnitudes_1927, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1927 PellMatchingLightProduction.pellMagnitudes_1927_large

def pellGraphCertificate_1927 : PellMatchingCertificate 1927 where
  magnitudes := pellMagnitudes_1927
  masks := pellMasks_1927
  witnesses := pellWitnesses_1927
  masks_valid := pellMasks_1927_valid
  checked := pellMatching_1927_checked
  large := pellMagnitudes_1927_large

def pellMagnitudes_1951 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1951

def pellMasks_1951 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1951.map pellLightMasksToOriginal

def pellWitnesses_1951 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1951

theorem pellMasks_1951_valid : ∀ m ∈ pellMasks_1951, m.Valid 1951 := by
  exact pellLightMasks_valid 1951 PellMatchingLightProduction.pellMasks_1951 PellMatchingLightProduction.pellMasks_1951_valid

theorem pellMatching_1951_checked :
    pellMatchingCheck pellMasks_1951 pellMagnitudes_1951 pellWitnesses_1951 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1951
    PellMatchingLightProduction.pellMagnitudes_1951 PellMatchingLightProduction.pellWitnesses_1951).symm.trans
      PellMatchingLightProduction.pellMatching_1951_checked

theorem pellMagnitudes_1951_large : ∀ x ∈ pellMagnitudes_1951, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1951 PellMatchingLightProduction.pellMagnitudes_1951_large

def pellGraphCertificate_1951 : PellMatchingCertificate 1951 where
  magnitudes := pellMagnitudes_1951
  masks := pellMasks_1951
  witnesses := pellWitnesses_1951
  masks_valid := pellMasks_1951_valid
  checked := pellMatching_1951_checked
  large := pellMagnitudes_1951_large

def pellMagnitudes_1999 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_1999

def pellMasks_1999 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_1999.map pellLightMasksToOriginal

def pellWitnesses_1999 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_1999

theorem pellMasks_1999_valid : ∀ m ∈ pellMasks_1999, m.Valid 1999 := by
  exact pellLightMasks_valid 1999 PellMatchingLightProduction.pellMasks_1999 PellMatchingLightProduction.pellMasks_1999_valid

theorem pellMatching_1999_checked :
    pellMatchingCheck pellMasks_1999 pellMagnitudes_1999 pellWitnesses_1999 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_1999
    PellMatchingLightProduction.pellMagnitudes_1999 PellMatchingLightProduction.pellWitnesses_1999).symm.trans
      PellMatchingLightProduction.pellMatching_1999_checked

theorem pellMagnitudes_1999_large : ∀ x ∈ pellMagnitudes_1999, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_1999 PellMatchingLightProduction.pellMagnitudes_1999_large

def pellGraphCertificate_1999 : PellMatchingCertificate 1999 where
  magnitudes := pellMagnitudes_1999
  masks := pellMasks_1999
  witnesses := pellWitnesses_1999
  masks_valid := pellMasks_1999_valid
  checked := pellMatching_1999_checked
  large := pellMagnitudes_1999_large

def pellMagnitudes_2039 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2039

def pellMasks_2039 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2039.map pellLightMasksToOriginal

def pellWitnesses_2039 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2039

theorem pellMasks_2039_valid : ∀ m ∈ pellMasks_2039, m.Valid 2039 := by
  exact pellLightMasks_valid 2039 PellMatchingLightProduction.pellMasks_2039 PellMatchingLightProduction.pellMasks_2039_valid

theorem pellMatching_2039_checked :
    pellMatchingCheck pellMasks_2039 pellMagnitudes_2039 pellWitnesses_2039 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2039
    PellMatchingLightProduction.pellMagnitudes_2039 PellMatchingLightProduction.pellWitnesses_2039).symm.trans
      PellMatchingLightProduction.pellMatching_2039_checked

theorem pellMagnitudes_2039_large : ∀ x ∈ pellMagnitudes_2039, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2039 PellMatchingLightProduction.pellMagnitudes_2039_large

def pellGraphCertificate_2039 : PellMatchingCertificate 2039 where
  magnitudes := pellMagnitudes_2039
  masks := pellMasks_2039
  witnesses := pellWitnesses_2039
  masks_valid := pellMasks_2039_valid
  checked := pellMatching_2039_checked
  large := pellMagnitudes_2039_large

def pellMagnitudes_2047 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2047

def pellMasks_2047 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2047.map pellLightMasksToOriginal

def pellWitnesses_2047 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2047

theorem pellMasks_2047_valid : ∀ m ∈ pellMasks_2047, m.Valid 2047 := by
  exact pellLightMasks_valid 2047 PellMatchingLightProduction.pellMasks_2047 PellMatchingLightProduction.pellMasks_2047_valid

theorem pellMatching_2047_checked :
    pellMatchingCheck pellMasks_2047 pellMagnitudes_2047 pellWitnesses_2047 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2047
    PellMatchingLightProduction.pellMagnitudes_2047 PellMatchingLightProduction.pellWitnesses_2047).symm.trans
      PellMatchingLightProduction.pellMatching_2047_checked

theorem pellMagnitudes_2047_large : ∀ x ∈ pellMagnitudes_2047, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2047 PellMatchingLightProduction.pellMagnitudes_2047_large

def pellGraphCertificate_2047 : PellMatchingCertificate 2047 where
  magnitudes := pellMagnitudes_2047
  masks := pellMasks_2047
  witnesses := pellWitnesses_2047
  masks_valid := pellMasks_2047_valid
  checked := pellMatching_2047_checked
  large := pellMagnitudes_2047_large

def pellMagnitudes_2063 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2063

def pellMasks_2063 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2063.map pellLightMasksToOriginal

def pellWitnesses_2063 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2063

theorem pellMasks_2063_valid : ∀ m ∈ pellMasks_2063, m.Valid 2063 := by
  exact pellLightMasks_valid 2063 PellMatchingLightProduction.pellMasks_2063 PellMatchingLightProduction.pellMasks_2063_valid

theorem pellMatching_2063_checked :
    pellMatchingCheck pellMasks_2063 pellMagnitudes_2063 pellWitnesses_2063 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2063
    PellMatchingLightProduction.pellMagnitudes_2063 PellMatchingLightProduction.pellWitnesses_2063).symm.trans
      PellMatchingLightProduction.pellMatching_2063_checked

theorem pellMagnitudes_2063_large : ∀ x ∈ pellMagnitudes_2063, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2063 PellMatchingLightProduction.pellMagnitudes_2063_large

def pellGraphCertificate_2063 : PellMatchingCertificate 2063 where
  magnitudes := pellMagnitudes_2063
  masks := pellMasks_2063
  witnesses := pellWitnesses_2063
  masks_valid := pellMasks_2063_valid
  checked := pellMatching_2063_checked
  large := pellMagnitudes_2063_large

def pellMagnitudes_2087 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2087

def pellMasks_2087 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2087.map pellLightMasksToOriginal

def pellWitnesses_2087 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2087

theorem pellMasks_2087_valid : ∀ m ∈ pellMasks_2087, m.Valid 2087 := by
  exact pellLightMasks_valid 2087 PellMatchingLightProduction.pellMasks_2087 PellMatchingLightProduction.pellMasks_2087_valid

theorem pellMatching_2087_checked :
    pellMatchingCheck pellMasks_2087 pellMagnitudes_2087 pellWitnesses_2087 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2087
    PellMatchingLightProduction.pellMagnitudes_2087 PellMatchingLightProduction.pellWitnesses_2087).symm.trans
      PellMatchingLightProduction.pellMatching_2087_checked

theorem pellMagnitudes_2087_large : ∀ x ∈ pellMagnitudes_2087, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2087 PellMatchingLightProduction.pellMagnitudes_2087_large

def pellGraphCertificate_2087 : PellMatchingCertificate 2087 where
  magnitudes := pellMagnitudes_2087
  masks := pellMasks_2087
  witnesses := pellWitnesses_2087
  masks_valid := pellMasks_2087_valid
  checked := pellMatching_2087_checked
  large := pellMagnitudes_2087_large

def pellMagnitudes_2111 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2111

def pellMasks_2111 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2111.map pellLightMasksToOriginal

def pellWitnesses_2111 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2111

theorem pellMasks_2111_valid : ∀ m ∈ pellMasks_2111, m.Valid 2111 := by
  exact pellLightMasks_valid 2111 PellMatchingLightProduction.pellMasks_2111 PellMatchingLightProduction.pellMasks_2111_valid

theorem pellMatching_2111_checked :
    pellMatchingCheck pellMasks_2111 pellMagnitudes_2111 pellWitnesses_2111 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2111
    PellMatchingLightProduction.pellMagnitudes_2111 PellMatchingLightProduction.pellWitnesses_2111).symm.trans
      PellMatchingLightProduction.pellMatching_2111_checked

theorem pellMagnitudes_2111_large : ∀ x ∈ pellMagnitudes_2111, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2111 PellMatchingLightProduction.pellMagnitudes_2111_large

def pellGraphCertificate_2111 : PellMatchingCertificate 2111 where
  magnitudes := pellMagnitudes_2111
  masks := pellMasks_2111
  witnesses := pellWitnesses_2111
  masks_valid := pellMasks_2111_valid
  checked := pellMatching_2111_checked
  large := pellMagnitudes_2111_large

def pellMagnitudes_2143 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2143

def pellMasks_2143 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2143.map pellLightMasksToOriginal

def pellWitnesses_2143 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2143

theorem pellMasks_2143_valid : ∀ m ∈ pellMasks_2143, m.Valid 2143 := by
  exact pellLightMasks_valid 2143 PellMatchingLightProduction.pellMasks_2143 PellMatchingLightProduction.pellMasks_2143_valid

theorem pellMatching_2143_checked :
    pellMatchingCheck pellMasks_2143 pellMagnitudes_2143 pellWitnesses_2143 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2143
    PellMatchingLightProduction.pellMagnitudes_2143 PellMatchingLightProduction.pellWitnesses_2143).symm.trans
      PellMatchingLightProduction.pellMatching_2143_checked

theorem pellMagnitudes_2143_large : ∀ x ∈ pellMagnitudes_2143, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2143 PellMatchingLightProduction.pellMagnitudes_2143_large

def pellGraphCertificate_2143 : PellMatchingCertificate 2143 where
  magnitudes := pellMagnitudes_2143
  masks := pellMasks_2143
  witnesses := pellWitnesses_2143
  masks_valid := pellMasks_2143_valid
  checked := pellMatching_2143_checked
  large := pellMagnitudes_2143_large

def pellMagnitudes_2191 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2191

def pellMasks_2191 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2191.map pellLightMasksToOriginal

def pellWitnesses_2191 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2191

theorem pellMasks_2191_valid : ∀ m ∈ pellMasks_2191, m.Valid 2191 := by
  exact pellLightMasks_valid 2191 PellMatchingLightProduction.pellMasks_2191 PellMatchingLightProduction.pellMasks_2191_valid

theorem pellMatching_2191_checked :
    pellMatchingCheck pellMasks_2191 pellMagnitudes_2191 pellWitnesses_2191 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2191
    PellMatchingLightProduction.pellMagnitudes_2191 PellMatchingLightProduction.pellWitnesses_2191).symm.trans
      PellMatchingLightProduction.pellMatching_2191_checked

theorem pellMagnitudes_2191_large : ∀ x ∈ pellMagnitudes_2191, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2191 PellMatchingLightProduction.pellMagnitudes_2191_large

def pellGraphCertificate_2191 : PellMatchingCertificate 2191 where
  magnitudes := pellMagnitudes_2191
  masks := pellMasks_2191
  witnesses := pellWitnesses_2191
  masks_valid := pellMasks_2191_valid
  checked := pellMatching_2191_checked
  large := pellMagnitudes_2191_large

def pellMagnitudes_2207 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2207

def pellMasks_2207 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2207.map pellLightMasksToOriginal

def pellWitnesses_2207 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2207

theorem pellMasks_2207_valid : ∀ m ∈ pellMasks_2207, m.Valid 2207 := by
  exact pellLightMasks_valid 2207 PellMatchingLightProduction.pellMasks_2207 PellMatchingLightProduction.pellMasks_2207_valid

theorem pellMatching_2207_checked :
    pellMatchingCheck pellMasks_2207 pellMagnitudes_2207 pellWitnesses_2207 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2207
    PellMatchingLightProduction.pellMagnitudes_2207 PellMatchingLightProduction.pellWitnesses_2207).symm.trans
      PellMatchingLightProduction.pellMatching_2207_checked

theorem pellMagnitudes_2207_large : ∀ x ∈ pellMagnitudes_2207, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2207 PellMatchingLightProduction.pellMagnitudes_2207_large

def pellGraphCertificate_2207 : PellMatchingCertificate 2207 where
  magnitudes := pellMagnitudes_2207
  masks := pellMasks_2207
  witnesses := pellWitnesses_2207
  masks_valid := pellMasks_2207_valid
  checked := pellMatching_2207_checked
  large := pellMagnitudes_2207_large

def pellMagnitudes_2231 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2231

def pellMasks_2231 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2231.map pellLightMasksToOriginal

def pellWitnesses_2231 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2231

theorem pellMasks_2231_valid : ∀ m ∈ pellMasks_2231, m.Valid 2231 := by
  exact pellLightMasks_valid 2231 PellMatchingLightProduction.pellMasks_2231 PellMatchingLightProduction.pellMasks_2231_valid

theorem pellMatching_2231_checked :
    pellMatchingCheck pellMasks_2231 pellMagnitudes_2231 pellWitnesses_2231 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2231
    PellMatchingLightProduction.pellMagnitudes_2231 PellMatchingLightProduction.pellWitnesses_2231).symm.trans
      PellMatchingLightProduction.pellMatching_2231_checked

theorem pellMagnitudes_2231_large : ∀ x ∈ pellMagnitudes_2231, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2231 PellMatchingLightProduction.pellMagnitudes_2231_large

def pellGraphCertificate_2231 : PellMatchingCertificate 2231 where
  magnitudes := pellMagnitudes_2231
  masks := pellMasks_2231
  witnesses := pellWitnesses_2231
  masks_valid := pellMasks_2231_valid
  checked := pellMatching_2231_checked
  large := pellMagnitudes_2231_large

def pellMagnitudes_2239 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2239

def pellMasks_2239 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2239.map pellLightMasksToOriginal

def pellWitnesses_2239 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2239

theorem pellMasks_2239_valid : ∀ m ∈ pellMasks_2239, m.Valid 2239 := by
  exact pellLightMasks_valid 2239 PellMatchingLightProduction.pellMasks_2239 PellMatchingLightProduction.pellMasks_2239_valid

theorem pellMatching_2239_checked :
    pellMatchingCheck pellMasks_2239 pellMagnitudes_2239 pellWitnesses_2239 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2239
    PellMatchingLightProduction.pellMagnitudes_2239 PellMatchingLightProduction.pellWitnesses_2239).symm.trans
      PellMatchingLightProduction.pellMatching_2239_checked

theorem pellMagnitudes_2239_large : ∀ x ∈ pellMagnitudes_2239, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2239 PellMatchingLightProduction.pellMagnitudes_2239_large

def pellGraphCertificate_2239 : PellMatchingCertificate 2239 where
  magnitudes := pellMagnitudes_2239
  masks := pellMasks_2239
  witnesses := pellWitnesses_2239
  masks_valid := pellMasks_2239_valid
  checked := pellMatching_2239_checked
  large := pellMagnitudes_2239_large

def pellMagnitudes_2263 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2263

def pellMasks_2263 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2263.map pellLightMasksToOriginal

def pellWitnesses_2263 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2263

theorem pellMasks_2263_valid : ∀ m ∈ pellMasks_2263, m.Valid 2263 := by
  exact pellLightMasks_valid 2263 PellMatchingLightProduction.pellMasks_2263 PellMatchingLightProduction.pellMasks_2263_valid

theorem pellMatching_2263_checked :
    pellMatchingCheck pellMasks_2263 pellMagnitudes_2263 pellWitnesses_2263 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2263
    PellMatchingLightProduction.pellMagnitudes_2263 PellMatchingLightProduction.pellWitnesses_2263).symm.trans
      PellMatchingLightProduction.pellMatching_2263_checked

theorem pellMagnitudes_2263_large : ∀ x ∈ pellMagnitudes_2263, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2263 PellMatchingLightProduction.pellMagnitudes_2263_large

def pellGraphCertificate_2263 : PellMatchingCertificate 2263 where
  magnitudes := pellMagnitudes_2263
  masks := pellMasks_2263
  witnesses := pellWitnesses_2263
  masks_valid := pellMasks_2263_valid
  checked := pellMatching_2263_checked
  large := pellMagnitudes_2263_large

def pellMagnitudes_2287 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2287

def pellMasks_2287 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2287.map pellLightMasksToOriginal

def pellWitnesses_2287 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2287

theorem pellMasks_2287_valid : ∀ m ∈ pellMasks_2287, m.Valid 2287 := by
  exact pellLightMasks_valid 2287 PellMatchingLightProduction.pellMasks_2287 PellMatchingLightProduction.pellMasks_2287_valid

theorem pellMatching_2287_checked :
    pellMatchingCheck pellMasks_2287 pellMagnitudes_2287 pellWitnesses_2287 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2287
    PellMatchingLightProduction.pellMagnitudes_2287 PellMatchingLightProduction.pellWitnesses_2287).symm.trans
      PellMatchingLightProduction.pellMatching_2287_checked

theorem pellMagnitudes_2287_large : ∀ x ∈ pellMagnitudes_2287, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2287 PellMatchingLightProduction.pellMagnitudes_2287_large

def pellGraphCertificate_2287 : PellMatchingCertificate 2287 where
  magnitudes := pellMagnitudes_2287
  masks := pellMasks_2287
  witnesses := pellWitnesses_2287
  masks_valid := pellMasks_2287_valid
  checked := pellMatching_2287_checked
  large := pellMagnitudes_2287_large

def pellMagnitudes_2311 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2311

def pellMasks_2311 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2311.map pellLightMasksToOriginal

def pellWitnesses_2311 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2311

theorem pellMasks_2311_valid : ∀ m ∈ pellMasks_2311, m.Valid 2311 := by
  exact pellLightMasks_valid 2311 PellMatchingLightProduction.pellMasks_2311 PellMatchingLightProduction.pellMasks_2311_valid

theorem pellMatching_2311_checked :
    pellMatchingCheck pellMasks_2311 pellMagnitudes_2311 pellWitnesses_2311 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2311
    PellMatchingLightProduction.pellMagnitudes_2311 PellMatchingLightProduction.pellWitnesses_2311).symm.trans
      PellMatchingLightProduction.pellMatching_2311_checked

theorem pellMagnitudes_2311_large : ∀ x ∈ pellMagnitudes_2311, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2311 PellMatchingLightProduction.pellMagnitudes_2311_large

def pellGraphCertificate_2311 : PellMatchingCertificate 2311 where
  magnitudes := pellMagnitudes_2311
  masks := pellMasks_2311
  witnesses := pellWitnesses_2311
  masks_valid := pellMasks_2311_valid
  checked := pellMatching_2311_checked
  large := pellMagnitudes_2311_large

def pellMagnitudes_2351 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2351

def pellMasks_2351 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2351.map pellLightMasksToOriginal

def pellWitnesses_2351 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2351

theorem pellMasks_2351_valid : ∀ m ∈ pellMasks_2351, m.Valid 2351 := by
  exact pellLightMasks_valid 2351 PellMatchingLightProduction.pellMasks_2351 PellMatchingLightProduction.pellMasks_2351_valid

theorem pellMatching_2351_checked :
    pellMatchingCheck pellMasks_2351 pellMagnitudes_2351 pellWitnesses_2351 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2351
    PellMatchingLightProduction.pellMagnitudes_2351 PellMatchingLightProduction.pellWitnesses_2351).symm.trans
      PellMatchingLightProduction.pellMatching_2351_checked

theorem pellMagnitudes_2351_large : ∀ x ∈ pellMagnitudes_2351, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2351 PellMatchingLightProduction.pellMagnitudes_2351_large

def pellGraphCertificate_2351 : PellMatchingCertificate 2351 where
  magnitudes := pellMagnitudes_2351
  masks := pellMasks_2351
  witnesses := pellWitnesses_2351
  masks_valid := pellMasks_2351_valid
  checked := pellMatching_2351_checked
  large := pellMagnitudes_2351_large

def pellMagnitudes_2383 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2383

def pellMasks_2383 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2383.map pellLightMasksToOriginal

def pellWitnesses_2383 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2383

theorem pellMasks_2383_valid : ∀ m ∈ pellMasks_2383, m.Valid 2383 := by
  exact pellLightMasks_valid 2383 PellMatchingLightProduction.pellMasks_2383 PellMatchingLightProduction.pellMasks_2383_valid

theorem pellMatching_2383_checked :
    pellMatchingCheck pellMasks_2383 pellMagnitudes_2383 pellWitnesses_2383 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2383
    PellMatchingLightProduction.pellMagnitudes_2383 PellMatchingLightProduction.pellWitnesses_2383).symm.trans
      PellMatchingLightProduction.pellMatching_2383_checked

theorem pellMagnitudes_2383_large : ∀ x ∈ pellMagnitudes_2383, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2383 PellMatchingLightProduction.pellMagnitudes_2383_large

def pellGraphCertificate_2383 : PellMatchingCertificate 2383 where
  magnitudes := pellMagnitudes_2383
  masks := pellMasks_2383
  witnesses := pellWitnesses_2383
  masks_valid := pellMasks_2383_valid
  checked := pellMatching_2383_checked
  large := pellMagnitudes_2383_large

def pellMagnitudes_2399 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2399

def pellMasks_2399 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2399.map pellLightMasksToOriginal

def pellWitnesses_2399 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2399

theorem pellMasks_2399_valid : ∀ m ∈ pellMasks_2399, m.Valid 2399 := by
  exact pellLightMasks_valid 2399 PellMatchingLightProduction.pellMasks_2399 PellMatchingLightProduction.pellMasks_2399_valid

theorem pellMatching_2399_checked :
    pellMatchingCheck pellMasks_2399 pellMagnitudes_2399 pellWitnesses_2399 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2399
    PellMatchingLightProduction.pellMagnitudes_2399 PellMatchingLightProduction.pellWitnesses_2399).symm.trans
      PellMatchingLightProduction.pellMatching_2399_checked

theorem pellMagnitudes_2399_large : ∀ x ∈ pellMagnitudes_2399, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2399 PellMatchingLightProduction.pellMagnitudes_2399_large

def pellGraphCertificate_2399 : PellMatchingCertificate 2399 where
  magnitudes := pellMagnitudes_2399
  masks := pellMasks_2399
  witnesses := pellWitnesses_2399
  masks_valid := pellMasks_2399_valid
  checked := pellMatching_2399_checked
  large := pellMagnitudes_2399_large

def pellMagnitudes_2423 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2423

def pellMasks_2423 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2423.map pellLightMasksToOriginal

def pellWitnesses_2423 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2423

theorem pellMasks_2423_valid : ∀ m ∈ pellMasks_2423, m.Valid 2423 := by
  exact pellLightMasks_valid 2423 PellMatchingLightProduction.pellMasks_2423 PellMatchingLightProduction.pellMasks_2423_valid

theorem pellMatching_2423_checked :
    pellMatchingCheck pellMasks_2423 pellMagnitudes_2423 pellWitnesses_2423 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2423
    PellMatchingLightProduction.pellMagnitudes_2423 PellMatchingLightProduction.pellWitnesses_2423).symm.trans
      PellMatchingLightProduction.pellMatching_2423_checked

theorem pellMagnitudes_2423_large : ∀ x ∈ pellMagnitudes_2423, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2423 PellMatchingLightProduction.pellMagnitudes_2423_large

def pellGraphCertificate_2423 : PellMatchingCertificate 2423 where
  magnitudes := pellMagnitudes_2423
  masks := pellMasks_2423
  witnesses := pellWitnesses_2423
  masks_valid := pellMasks_2423_valid
  checked := pellMatching_2423_checked
  large := pellMagnitudes_2423_large

def pellMagnitudes_2447 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2447

def pellMasks_2447 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2447.map pellLightMasksToOriginal

def pellWitnesses_2447 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2447

theorem pellMasks_2447_valid : ∀ m ∈ pellMasks_2447, m.Valid 2447 := by
  exact pellLightMasks_valid 2447 PellMatchingLightProduction.pellMasks_2447 PellMatchingLightProduction.pellMasks_2447_valid

theorem pellMatching_2447_checked :
    pellMatchingCheck pellMasks_2447 pellMagnitudes_2447 pellWitnesses_2447 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2447
    PellMatchingLightProduction.pellMagnitudes_2447 PellMatchingLightProduction.pellWitnesses_2447).symm.trans
      PellMatchingLightProduction.pellMatching_2447_checked

theorem pellMagnitudes_2447_large : ∀ x ∈ pellMagnitudes_2447, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2447 PellMatchingLightProduction.pellMagnitudes_2447_large

def pellGraphCertificate_2447 : PellMatchingCertificate 2447 where
  magnitudes := pellMagnitudes_2447
  masks := pellMasks_2447
  witnesses := pellWitnesses_2447
  masks_valid := pellMasks_2447_valid
  checked := pellMatching_2447_checked
  large := pellMagnitudes_2447_large

def pellMagnitudes_2471 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2471

def pellMasks_2471 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2471.map pellLightMasksToOriginal

def pellWitnesses_2471 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2471

theorem pellMasks_2471_valid : ∀ m ∈ pellMasks_2471, m.Valid 2471 := by
  exact pellLightMasks_valid 2471 PellMatchingLightProduction.pellMasks_2471 PellMatchingLightProduction.pellMasks_2471_valid

theorem pellMatching_2471_checked :
    pellMatchingCheck pellMasks_2471 pellMagnitudes_2471 pellWitnesses_2471 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2471
    PellMatchingLightProduction.pellMagnitudes_2471 PellMatchingLightProduction.pellWitnesses_2471).symm.trans
      PellMatchingLightProduction.pellMatching_2471_checked

theorem pellMagnitudes_2471_large : ∀ x ∈ pellMagnitudes_2471, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2471 PellMatchingLightProduction.pellMagnitudes_2471_large

def pellGraphCertificate_2471 : PellMatchingCertificate 2471 where
  magnitudes := pellMagnitudes_2471
  masks := pellMasks_2471
  witnesses := pellWitnesses_2471
  masks_valid := pellMasks_2471_valid
  checked := pellMatching_2471_checked
  large := pellMagnitudes_2471_large

def pellMagnitudes_2503 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2503

def pellMasks_2503 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2503.map pellLightMasksToOriginal

def pellWitnesses_2503 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2503

theorem pellMasks_2503_valid : ∀ m ∈ pellMasks_2503, m.Valid 2503 := by
  exact pellLightMasks_valid 2503 PellMatchingLightProduction.pellMasks_2503 PellMatchingLightProduction.pellMasks_2503_valid

theorem pellMatching_2503_checked :
    pellMatchingCheck pellMasks_2503 pellMagnitudes_2503 pellWitnesses_2503 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2503
    PellMatchingLightProduction.pellMagnitudes_2503 PellMatchingLightProduction.pellWitnesses_2503).symm.trans
      PellMatchingLightProduction.pellMatching_2503_checked

theorem pellMagnitudes_2503_large : ∀ x ∈ pellMagnitudes_2503, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2503 PellMatchingLightProduction.pellMagnitudes_2503_large

def pellGraphCertificate_2503 : PellMatchingCertificate 2503 where
  magnitudes := pellMagnitudes_2503
  masks := pellMasks_2503
  witnesses := pellWitnesses_2503
  masks_valid := pellMasks_2503_valid
  checked := pellMatching_2503_checked
  large := pellMagnitudes_2503_large

def pellMagnitudes_2543 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2543

def pellMasks_2543 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2543.map pellLightMasksToOriginal

def pellWitnesses_2543 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2543

theorem pellMasks_2543_valid : ∀ m ∈ pellMasks_2543, m.Valid 2543 := by
  exact pellLightMasks_valid 2543 PellMatchingLightProduction.pellMasks_2543 PellMatchingLightProduction.pellMasks_2543_valid

theorem pellMatching_2543_checked :
    pellMatchingCheck pellMasks_2543 pellMagnitudes_2543 pellWitnesses_2543 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2543
    PellMatchingLightProduction.pellMagnitudes_2543 PellMatchingLightProduction.pellWitnesses_2543).symm.trans
      PellMatchingLightProduction.pellMatching_2543_checked

theorem pellMagnitudes_2543_large : ∀ x ∈ pellMagnitudes_2543, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2543 PellMatchingLightProduction.pellMagnitudes_2543_large

def pellGraphCertificate_2543 : PellMatchingCertificate 2543 where
  magnitudes := pellMagnitudes_2543
  masks := pellMasks_2543
  witnesses := pellWitnesses_2543
  masks_valid := pellMasks_2543_valid
  checked := pellMatching_2543_checked
  large := pellMagnitudes_2543_large

def pellMagnitudes_2551 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2551

def pellMasks_2551 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2551.map pellLightMasksToOriginal

def pellWitnesses_2551 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2551

theorem pellMasks_2551_valid : ∀ m ∈ pellMasks_2551, m.Valid 2551 := by
  exact pellLightMasks_valid 2551 PellMatchingLightProduction.pellMasks_2551 PellMatchingLightProduction.pellMasks_2551_valid

theorem pellMatching_2551_checked :
    pellMatchingCheck pellMasks_2551 pellMagnitudes_2551 pellWitnesses_2551 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2551
    PellMatchingLightProduction.pellMagnitudes_2551 PellMatchingLightProduction.pellWitnesses_2551).symm.trans
      PellMatchingLightProduction.pellMatching_2551_checked

theorem pellMagnitudes_2551_large : ∀ x ∈ pellMagnitudes_2551, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2551 PellMatchingLightProduction.pellMagnitudes_2551_large

def pellGraphCertificate_2551 : PellMatchingCertificate 2551 where
  magnitudes := pellMagnitudes_2551
  masks := pellMasks_2551
  witnesses := pellWitnesses_2551
  masks_valid := pellMasks_2551_valid
  checked := pellMatching_2551_checked
  large := pellMagnitudes_2551_large

def pellMagnitudes_2591 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2591

def pellMasks_2591 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2591.map pellLightMasksToOriginal

def pellWitnesses_2591 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2591

theorem pellMasks_2591_valid : ∀ m ∈ pellMasks_2591, m.Valid 2591 := by
  exact pellLightMasks_valid 2591 PellMatchingLightProduction.pellMasks_2591 PellMatchingLightProduction.pellMasks_2591_valid

theorem pellMatching_2591_checked :
    pellMatchingCheck pellMasks_2591 pellMagnitudes_2591 pellWitnesses_2591 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2591
    PellMatchingLightProduction.pellMagnitudes_2591 PellMatchingLightProduction.pellWitnesses_2591).symm.trans
      PellMatchingLightProduction.pellMatching_2591_checked

theorem pellMagnitudes_2591_large : ∀ x ∈ pellMagnitudes_2591, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2591 PellMatchingLightProduction.pellMagnitudes_2591_large

def pellGraphCertificate_2591 : PellMatchingCertificate 2591 where
  magnitudes := pellMagnitudes_2591
  masks := pellMasks_2591
  witnesses := pellWitnesses_2591
  masks_valid := pellMasks_2591_valid
  checked := pellMatching_2591_checked
  large := pellMagnitudes_2591_large

def pellMagnitudes_2599 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2599

def pellMasks_2599 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2599.map pellLightMasksToOriginal

def pellWitnesses_2599 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2599

theorem pellMasks_2599_valid : ∀ m ∈ pellMasks_2599, m.Valid 2599 := by
  exact pellLightMasks_valid 2599 PellMatchingLightProduction.pellMasks_2599 PellMatchingLightProduction.pellMasks_2599_valid

theorem pellMatching_2599_checked :
    pellMatchingCheck pellMasks_2599 pellMagnitudes_2599 pellWitnesses_2599 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2599
    PellMatchingLightProduction.pellMagnitudes_2599 PellMatchingLightProduction.pellWitnesses_2599).symm.trans
      PellMatchingLightProduction.pellMatching_2599_checked

theorem pellMagnitudes_2599_large : ∀ x ∈ pellMagnitudes_2599, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2599 PellMatchingLightProduction.pellMagnitudes_2599_large

def pellGraphCertificate_2599 : PellMatchingCertificate 2599 where
  magnitudes := pellMagnitudes_2599
  masks := pellMasks_2599
  witnesses := pellWitnesses_2599
  masks_valid := pellMasks_2599_valid
  checked := pellMatching_2599_checked
  large := pellMagnitudes_2599_large

def pellMagnitudes_2647 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2647

def pellMasks_2647 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2647.map pellLightMasksToOriginal

def pellWitnesses_2647 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2647

theorem pellMasks_2647_valid : ∀ m ∈ pellMasks_2647, m.Valid 2647 := by
  exact pellLightMasks_valid 2647 PellMatchingLightProduction.pellMasks_2647 PellMatchingLightProduction.pellMasks_2647_valid

theorem pellMatching_2647_checked :
    pellMatchingCheck pellMasks_2647 pellMagnitudes_2647 pellWitnesses_2647 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2647
    PellMatchingLightProduction.pellMagnitudes_2647 PellMatchingLightProduction.pellWitnesses_2647).symm.trans
      PellMatchingLightProduction.pellMatching_2647_checked

theorem pellMagnitudes_2647_large : ∀ x ∈ pellMagnitudes_2647, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2647 PellMatchingLightProduction.pellMagnitudes_2647_large

def pellGraphCertificate_2647 : PellMatchingCertificate 2647 where
  magnitudes := pellMagnitudes_2647
  masks := pellMasks_2647
  witnesses := pellWitnesses_2647
  masks_valid := pellMasks_2647_valid
  checked := pellMatching_2647_checked
  large := pellMagnitudes_2647_large

def pellMagnitudes_2663 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2663

def pellMasks_2663 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2663.map pellLightMasksToOriginal

def pellWitnesses_2663 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2663

theorem pellMasks_2663_valid : ∀ m ∈ pellMasks_2663, m.Valid 2663 := by
  exact pellLightMasks_valid 2663 PellMatchingLightProduction.pellMasks_2663 PellMatchingLightProduction.pellMasks_2663_valid

theorem pellMatching_2663_checked :
    pellMatchingCheck pellMasks_2663 pellMagnitudes_2663 pellWitnesses_2663 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2663
    PellMatchingLightProduction.pellMagnitudes_2663 PellMatchingLightProduction.pellWitnesses_2663).symm.trans
      PellMatchingLightProduction.pellMatching_2663_checked

theorem pellMagnitudes_2663_large : ∀ x ∈ pellMagnitudes_2663, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2663 PellMatchingLightProduction.pellMagnitudes_2663_large

def pellGraphCertificate_2663 : PellMatchingCertificate 2663 where
  magnitudes := pellMagnitudes_2663
  masks := pellMasks_2663
  witnesses := pellWitnesses_2663
  masks_valid := pellMasks_2663_valid
  checked := pellMatching_2663_checked
  large := pellMagnitudes_2663_large

def pellMagnitudes_2671 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2671

def pellMasks_2671 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2671.map pellLightMasksToOriginal

def pellWitnesses_2671 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2671

theorem pellMasks_2671_valid : ∀ m ∈ pellMasks_2671, m.Valid 2671 := by
  exact pellLightMasks_valid 2671 PellMatchingLightProduction.pellMasks_2671 PellMatchingLightProduction.pellMasks_2671_valid

theorem pellMatching_2671_checked :
    pellMatchingCheck pellMasks_2671 pellMagnitudes_2671 pellWitnesses_2671 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2671
    PellMatchingLightProduction.pellMagnitudes_2671 PellMatchingLightProduction.pellWitnesses_2671).symm.trans
      PellMatchingLightProduction.pellMatching_2671_checked

theorem pellMagnitudes_2671_large : ∀ x ∈ pellMagnitudes_2671, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2671 PellMatchingLightProduction.pellMagnitudes_2671_large

def pellGraphCertificate_2671 : PellMatchingCertificate 2671 where
  magnitudes := pellMagnitudes_2671
  masks := pellMasks_2671
  witnesses := pellWitnesses_2671
  masks_valid := pellMasks_2671_valid
  checked := pellMatching_2671_checked
  large := pellMagnitudes_2671_large

def pellMagnitudes_2687 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2687

def pellMasks_2687 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2687.map pellLightMasksToOriginal

def pellWitnesses_2687 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2687

theorem pellMasks_2687_valid : ∀ m ∈ pellMasks_2687, m.Valid 2687 := by
  exact pellLightMasks_valid 2687 PellMatchingLightProduction.pellMasks_2687 PellMatchingLightProduction.pellMasks_2687_valid

theorem pellMatching_2687_checked :
    pellMatchingCheck pellMasks_2687 pellMagnitudes_2687 pellWitnesses_2687 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2687
    PellMatchingLightProduction.pellMagnitudes_2687 PellMatchingLightProduction.pellWitnesses_2687).symm.trans
      PellMatchingLightProduction.pellMatching_2687_checked

theorem pellMagnitudes_2687_large : ∀ x ∈ pellMagnitudes_2687, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2687 PellMatchingLightProduction.pellMagnitudes_2687_large

def pellGraphCertificate_2687 : PellMatchingCertificate 2687 where
  magnitudes := pellMagnitudes_2687
  masks := pellMasks_2687
  witnesses := pellWitnesses_2687
  masks_valid := pellMasks_2687_valid
  checked := pellMatching_2687_checked
  large := pellMagnitudes_2687_large

def pellMagnitudes_2711 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2711

def pellMasks_2711 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2711.map pellLightMasksToOriginal

def pellWitnesses_2711 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2711

theorem pellMasks_2711_valid : ∀ m ∈ pellMasks_2711, m.Valid 2711 := by
  exact pellLightMasks_valid 2711 PellMatchingLightProduction.pellMasks_2711 PellMatchingLightProduction.pellMasks_2711_valid

theorem pellMatching_2711_checked :
    pellMatchingCheck pellMasks_2711 pellMagnitudes_2711 pellWitnesses_2711 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2711
    PellMatchingLightProduction.pellMagnitudes_2711 PellMatchingLightProduction.pellWitnesses_2711).symm.trans
      PellMatchingLightProduction.pellMatching_2711_checked

theorem pellMagnitudes_2711_large : ∀ x ∈ pellMagnitudes_2711, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2711 PellMatchingLightProduction.pellMagnitudes_2711_large

def pellGraphCertificate_2711 : PellMatchingCertificate 2711 where
  magnitudes := pellMagnitudes_2711
  masks := pellMasks_2711
  witnesses := pellWitnesses_2711
  masks_valid := pellMasks_2711_valid
  checked := pellMatching_2711_checked
  large := pellMagnitudes_2711_large

def pellMagnitudes_2719 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2719

def pellMasks_2719 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2719.map pellLightMasksToOriginal

def pellWitnesses_2719 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2719

theorem pellMasks_2719_valid : ∀ m ∈ pellMasks_2719, m.Valid 2719 := by
  exact pellLightMasks_valid 2719 PellMatchingLightProduction.pellMasks_2719 PellMatchingLightProduction.pellMasks_2719_valid

theorem pellMatching_2719_checked :
    pellMatchingCheck pellMasks_2719 pellMagnitudes_2719 pellWitnesses_2719 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2719
    PellMatchingLightProduction.pellMagnitudes_2719 PellMatchingLightProduction.pellWitnesses_2719).symm.trans
      PellMatchingLightProduction.pellMatching_2719_checked

theorem pellMagnitudes_2719_large : ∀ x ∈ pellMagnitudes_2719, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2719 PellMatchingLightProduction.pellMagnitudes_2719_large

def pellGraphCertificate_2719 : PellMatchingCertificate 2719 where
  magnitudes := pellMagnitudes_2719
  masks := pellMasks_2719
  witnesses := pellWitnesses_2719
  masks_valid := pellMasks_2719_valid
  checked := pellMatching_2719_checked
  large := pellMagnitudes_2719_large

def pellMagnitudes_2759 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2759

def pellMasks_2759 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2759.map pellLightMasksToOriginal

def pellWitnesses_2759 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2759

theorem pellMasks_2759_valid : ∀ m ∈ pellMasks_2759, m.Valid 2759 := by
  exact pellLightMasks_valid 2759 PellMatchingLightProduction.pellMasks_2759 PellMatchingLightProduction.pellMasks_2759_valid

theorem pellMatching_2759_checked :
    pellMatchingCheck pellMasks_2759 pellMagnitudes_2759 pellWitnesses_2759 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2759
    PellMatchingLightProduction.pellMagnitudes_2759 PellMatchingLightProduction.pellWitnesses_2759).symm.trans
      PellMatchingLightProduction.pellMatching_2759_checked

theorem pellMagnitudes_2759_large : ∀ x ∈ pellMagnitudes_2759, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2759 PellMatchingLightProduction.pellMagnitudes_2759_large

def pellGraphCertificate_2759 : PellMatchingCertificate 2759 where
  magnitudes := pellMagnitudes_2759
  masks := pellMasks_2759
  witnesses := pellWitnesses_2759
  masks_valid := pellMasks_2759_valid
  checked := pellMatching_2759_checked
  large := pellMagnitudes_2759_large

def pellMagnitudes_2767 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2767

def pellMasks_2767 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2767.map pellLightMasksToOriginal

def pellWitnesses_2767 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2767

theorem pellMasks_2767_valid : ∀ m ∈ pellMasks_2767, m.Valid 2767 := by
  exact pellLightMasks_valid 2767 PellMatchingLightProduction.pellMasks_2767 PellMatchingLightProduction.pellMasks_2767_valid

theorem pellMatching_2767_checked :
    pellMatchingCheck pellMasks_2767 pellMagnitudes_2767 pellWitnesses_2767 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2767
    PellMatchingLightProduction.pellMagnitudes_2767 PellMatchingLightProduction.pellWitnesses_2767).symm.trans
      PellMatchingLightProduction.pellMatching_2767_checked

theorem pellMagnitudes_2767_large : ∀ x ∈ pellMagnitudes_2767, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2767 PellMatchingLightProduction.pellMagnitudes_2767_large

def pellGraphCertificate_2767 : PellMatchingCertificate 2767 where
  magnitudes := pellMagnitudes_2767
  masks := pellMasks_2767
  witnesses := pellWitnesses_2767
  masks_valid := pellMasks_2767_valid
  checked := pellMatching_2767_checked
  large := pellMagnitudes_2767_large

def pellMagnitudes_2791 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2791

def pellMasks_2791 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2791.map pellLightMasksToOriginal

def pellWitnesses_2791 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2791

theorem pellMasks_2791_valid : ∀ m ∈ pellMasks_2791, m.Valid 2791 := by
  exact pellLightMasks_valid 2791 PellMatchingLightProduction.pellMasks_2791 PellMatchingLightProduction.pellMasks_2791_valid

theorem pellMatching_2791_checked :
    pellMatchingCheck pellMasks_2791 pellMagnitudes_2791 pellWitnesses_2791 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2791
    PellMatchingLightProduction.pellMagnitudes_2791 PellMatchingLightProduction.pellWitnesses_2791).symm.trans
      PellMatchingLightProduction.pellMatching_2791_checked

theorem pellMagnitudes_2791_large : ∀ x ∈ pellMagnitudes_2791, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2791 PellMatchingLightProduction.pellMagnitudes_2791_large

def pellGraphCertificate_2791 : PellMatchingCertificate 2791 where
  magnitudes := pellMagnitudes_2791
  masks := pellMasks_2791
  witnesses := pellWitnesses_2791
  masks_valid := pellMasks_2791_valid
  checked := pellMatching_2791_checked
  large := pellMagnitudes_2791_large

def pellMagnitudes_2807 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2807

def pellMasks_2807 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2807.map pellLightMasksToOriginal

def pellWitnesses_2807 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2807

theorem pellMasks_2807_valid : ∀ m ∈ pellMasks_2807, m.Valid 2807 := by
  exact pellLightMasks_valid 2807 PellMatchingLightProduction.pellMasks_2807 PellMatchingLightProduction.pellMasks_2807_valid

theorem pellMatching_2807_checked :
    pellMatchingCheck pellMasks_2807 pellMagnitudes_2807 pellWitnesses_2807 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2807
    PellMatchingLightProduction.pellMagnitudes_2807 PellMatchingLightProduction.pellWitnesses_2807).symm.trans
      PellMatchingLightProduction.pellMatching_2807_checked

theorem pellMagnitudes_2807_large : ∀ x ∈ pellMagnitudes_2807, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2807 PellMatchingLightProduction.pellMagnitudes_2807_large

def pellGraphCertificate_2807 : PellMatchingCertificate 2807 where
  magnitudes := pellMagnitudes_2807
  masks := pellMasks_2807
  witnesses := pellWitnesses_2807
  masks_valid := pellMasks_2807_valid
  checked := pellMatching_2807_checked
  large := pellMagnitudes_2807_large

def pellMagnitudes_2839 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2839

def pellMasks_2839 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2839.map pellLightMasksToOriginal

def pellWitnesses_2839 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2839

theorem pellMasks_2839_valid : ∀ m ∈ pellMasks_2839, m.Valid 2839 := by
  exact pellLightMasks_valid 2839 PellMatchingLightProduction.pellMasks_2839 PellMatchingLightProduction.pellMasks_2839_valid

theorem pellMatching_2839_checked :
    pellMatchingCheck pellMasks_2839 pellMagnitudes_2839 pellWitnesses_2839 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2839
    PellMatchingLightProduction.pellMagnitudes_2839 PellMatchingLightProduction.pellWitnesses_2839).symm.trans
      PellMatchingLightProduction.pellMatching_2839_checked

theorem pellMagnitudes_2839_large : ∀ x ∈ pellMagnitudes_2839, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2839 PellMatchingLightProduction.pellMagnitudes_2839_large

def pellGraphCertificate_2839 : PellMatchingCertificate 2839 where
  magnitudes := pellMagnitudes_2839
  masks := pellMasks_2839
  witnesses := pellWitnesses_2839
  masks_valid := pellMasks_2839_valid
  checked := pellMatching_2839_checked
  large := pellMagnitudes_2839_large

def pellMagnitudes_2863 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2863

def pellMasks_2863 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2863.map pellLightMasksToOriginal

def pellWitnesses_2863 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2863

theorem pellMasks_2863_valid : ∀ m ∈ pellMasks_2863, m.Valid 2863 := by
  exact pellLightMasks_valid 2863 PellMatchingLightProduction.pellMasks_2863 PellMatchingLightProduction.pellMasks_2863_valid

theorem pellMatching_2863_checked :
    pellMatchingCheck pellMasks_2863 pellMagnitudes_2863 pellWitnesses_2863 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2863
    PellMatchingLightProduction.pellMagnitudes_2863 PellMatchingLightProduction.pellWitnesses_2863).symm.trans
      PellMatchingLightProduction.pellMatching_2863_checked

theorem pellMagnitudes_2863_large : ∀ x ∈ pellMagnitudes_2863, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2863 PellMatchingLightProduction.pellMagnitudes_2863_large

def pellGraphCertificate_2863 : PellMatchingCertificate 2863 where
  magnitudes := pellMagnitudes_2863
  masks := pellMasks_2863
  witnesses := pellWitnesses_2863
  masks_valid := pellMasks_2863_valid
  checked := pellMatching_2863_checked
  large := pellMagnitudes_2863_large

def pellMagnitudes_2879 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2879

def pellMasks_2879 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2879.map pellLightMasksToOriginal

def pellWitnesses_2879 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2879

theorem pellMasks_2879_valid : ∀ m ∈ pellMasks_2879, m.Valid 2879 := by
  exact pellLightMasks_valid 2879 PellMatchingLightProduction.pellMasks_2879 PellMatchingLightProduction.pellMasks_2879_valid

theorem pellMatching_2879_checked :
    pellMatchingCheck pellMasks_2879 pellMagnitudes_2879 pellWitnesses_2879 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2879
    PellMatchingLightProduction.pellMagnitudes_2879 PellMatchingLightProduction.pellWitnesses_2879).symm.trans
      PellMatchingLightProduction.pellMatching_2879_checked

theorem pellMagnitudes_2879_large : ∀ x ∈ pellMagnitudes_2879, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2879 PellMatchingLightProduction.pellMagnitudes_2879_large

def pellGraphCertificate_2879 : PellMatchingCertificate 2879 where
  magnitudes := pellMagnitudes_2879
  masks := pellMasks_2879
  witnesses := pellWitnesses_2879
  masks_valid := pellMasks_2879_valid
  checked := pellMatching_2879_checked
  large := pellMagnitudes_2879_large

def pellMagnitudes_2887 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2887

def pellMasks_2887 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2887.map pellLightMasksToOriginal

def pellWitnesses_2887 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2887

theorem pellMasks_2887_valid : ∀ m ∈ pellMasks_2887, m.Valid 2887 := by
  exact pellLightMasks_valid 2887 PellMatchingLightProduction.pellMasks_2887 PellMatchingLightProduction.pellMasks_2887_valid

theorem pellMatching_2887_checked :
    pellMatchingCheck pellMasks_2887 pellMagnitudes_2887 pellWitnesses_2887 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2887
    PellMatchingLightProduction.pellMagnitudes_2887 PellMatchingLightProduction.pellWitnesses_2887).symm.trans
      PellMatchingLightProduction.pellMatching_2887_checked

theorem pellMagnitudes_2887_large : ∀ x ∈ pellMagnitudes_2887, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2887 PellMatchingLightProduction.pellMagnitudes_2887_large

def pellGraphCertificate_2887 : PellMatchingCertificate 2887 where
  magnitudes := pellMagnitudes_2887
  masks := pellMasks_2887
  witnesses := pellWitnesses_2887
  masks_valid := pellMasks_2887_valid
  checked := pellMatching_2887_checked
  large := pellMagnitudes_2887_large

def pellMagnitudes_2903 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2903

def pellMasks_2903 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2903.map pellLightMasksToOriginal

def pellWitnesses_2903 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2903

theorem pellMasks_2903_valid : ∀ m ∈ pellMasks_2903, m.Valid 2903 := by
  exact pellLightMasks_valid 2903 PellMatchingLightProduction.pellMasks_2903 PellMatchingLightProduction.pellMasks_2903_valid

theorem pellMatching_2903_checked :
    pellMatchingCheck pellMasks_2903 pellMagnitudes_2903 pellWitnesses_2903 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2903
    PellMatchingLightProduction.pellMagnitudes_2903 PellMatchingLightProduction.pellWitnesses_2903).symm.trans
      PellMatchingLightProduction.pellMatching_2903_checked

theorem pellMagnitudes_2903_large : ∀ x ∈ pellMagnitudes_2903, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2903 PellMatchingLightProduction.pellMagnitudes_2903_large

def pellGraphCertificate_2903 : PellMatchingCertificate 2903 where
  magnitudes := pellMagnitudes_2903
  masks := pellMasks_2903
  witnesses := pellWitnesses_2903
  masks_valid := pellMasks_2903_valid
  checked := pellMatching_2903_checked
  large := pellMagnitudes_2903_large

def pellMagnitudes_2911 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2911

def pellMasks_2911 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2911.map pellLightMasksToOriginal

def pellWitnesses_2911 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2911

theorem pellMasks_2911_valid : ∀ m ∈ pellMasks_2911, m.Valid 2911 := by
  exact pellLightMasks_valid 2911 PellMatchingLightProduction.pellMasks_2911 PellMatchingLightProduction.pellMasks_2911_valid

theorem pellMatching_2911_checked :
    pellMatchingCheck pellMasks_2911 pellMagnitudes_2911 pellWitnesses_2911 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2911
    PellMatchingLightProduction.pellMagnitudes_2911 PellMatchingLightProduction.pellWitnesses_2911).symm.trans
      PellMatchingLightProduction.pellMatching_2911_checked

theorem pellMagnitudes_2911_large : ∀ x ∈ pellMagnitudes_2911, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2911 PellMatchingLightProduction.pellMagnitudes_2911_large

def pellGraphCertificate_2911 : PellMatchingCertificate 2911 where
  magnitudes := pellMagnitudes_2911
  masks := pellMasks_2911
  witnesses := pellWitnesses_2911
  masks_valid := pellMasks_2911_valid
  checked := pellMatching_2911_checked
  large := pellMagnitudes_2911_large

def pellMagnitudes_2927 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2927

def pellMasks_2927 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2927.map pellLightMasksToOriginal

def pellWitnesses_2927 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2927

theorem pellMasks_2927_valid : ∀ m ∈ pellMasks_2927, m.Valid 2927 := by
  exact pellLightMasks_valid 2927 PellMatchingLightProduction.pellMasks_2927 PellMatchingLightProduction.pellMasks_2927_valid

theorem pellMatching_2927_checked :
    pellMatchingCheck pellMasks_2927 pellMagnitudes_2927 pellWitnesses_2927 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2927
    PellMatchingLightProduction.pellMagnitudes_2927 PellMatchingLightProduction.pellWitnesses_2927).symm.trans
      PellMatchingLightProduction.pellMatching_2927_checked

theorem pellMagnitudes_2927_large : ∀ x ∈ pellMagnitudes_2927, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2927 PellMatchingLightProduction.pellMagnitudes_2927_large

def pellGraphCertificate_2927 : PellMatchingCertificate 2927 where
  magnitudes := pellMagnitudes_2927
  masks := pellMasks_2927
  witnesses := pellWitnesses_2927
  masks_valid := pellMasks_2927_valid
  checked := pellMatching_2927_checked
  large := pellMagnitudes_2927_large

def pellMagnitudes_2999 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_2999

def pellMasks_2999 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_2999.map pellLightMasksToOriginal

def pellWitnesses_2999 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_2999

theorem pellMasks_2999_valid : ∀ m ∈ pellMasks_2999, m.Valid 2999 := by
  exact pellLightMasks_valid 2999 PellMatchingLightProduction.pellMasks_2999 PellMatchingLightProduction.pellMasks_2999_valid

theorem pellMatching_2999_checked :
    pellMatchingCheck pellMasks_2999 pellMagnitudes_2999 pellWitnesses_2999 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_2999
    PellMatchingLightProduction.pellMagnitudes_2999 PellMatchingLightProduction.pellWitnesses_2999).symm.trans
      PellMatchingLightProduction.pellMatching_2999_checked

theorem pellMagnitudes_2999_large : ∀ x ∈ pellMagnitudes_2999, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_2999 PellMatchingLightProduction.pellMagnitudes_2999_large

def pellGraphCertificate_2999 : PellMatchingCertificate 2999 where
  magnitudes := pellMagnitudes_2999
  masks := pellMasks_2999
  witnesses := pellWitnesses_2999
  masks_valid := pellMasks_2999_valid
  checked := pellMatching_2999_checked
  large := pellMagnitudes_2999_large

def pellMagnitudes_3007 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3007

def pellMasks_3007 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3007.map pellLightMasksToOriginal

def pellWitnesses_3007 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3007

theorem pellMasks_3007_valid : ∀ m ∈ pellMasks_3007, m.Valid 3007 := by
  exact pellLightMasks_valid 3007 PellMatchingLightProduction.pellMasks_3007 PellMatchingLightProduction.pellMasks_3007_valid

theorem pellMatching_3007_checked :
    pellMatchingCheck pellMasks_3007 pellMagnitudes_3007 pellWitnesses_3007 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3007
    PellMatchingLightProduction.pellMagnitudes_3007 PellMatchingLightProduction.pellWitnesses_3007).symm.trans
      PellMatchingLightProduction.pellMatching_3007_checked

theorem pellMagnitudes_3007_large : ∀ x ∈ pellMagnitudes_3007, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3007 PellMatchingLightProduction.pellMagnitudes_3007_large

def pellGraphCertificate_3007 : PellMatchingCertificate 3007 where
  magnitudes := pellMagnitudes_3007
  masks := pellMasks_3007
  witnesses := pellWitnesses_3007
  masks_valid := pellMasks_3007_valid
  checked := pellMatching_3007_checked
  large := pellMagnitudes_3007_large

def pellMagnitudes_3023 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3023

def pellMasks_3023 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3023.map pellLightMasksToOriginal

def pellWitnesses_3023 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3023

theorem pellMasks_3023_valid : ∀ m ∈ pellMasks_3023, m.Valid 3023 := by
  exact pellLightMasks_valid 3023 PellMatchingLightProduction.pellMasks_3023 PellMatchingLightProduction.pellMasks_3023_valid

theorem pellMatching_3023_checked :
    pellMatchingCheck pellMasks_3023 pellMagnitudes_3023 pellWitnesses_3023 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3023
    PellMatchingLightProduction.pellMagnitudes_3023 PellMatchingLightProduction.pellWitnesses_3023).symm.trans
      PellMatchingLightProduction.pellMatching_3023_checked

theorem pellMagnitudes_3023_large : ∀ x ∈ pellMagnitudes_3023, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3023 PellMatchingLightProduction.pellMagnitudes_3023_large

def pellGraphCertificate_3023 : PellMatchingCertificate 3023 where
  magnitudes := pellMagnitudes_3023
  masks := pellMasks_3023
  witnesses := pellWitnesses_3023
  masks_valid := pellMasks_3023_valid
  checked := pellMatching_3023_checked
  large := pellMagnitudes_3023_large

def pellMagnitudes_3031 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3031

def pellMasks_3031 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3031.map pellLightMasksToOriginal

def pellWitnesses_3031 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3031

theorem pellMasks_3031_valid : ∀ m ∈ pellMasks_3031, m.Valid 3031 := by
  exact pellLightMasks_valid 3031 PellMatchingLightProduction.pellMasks_3031 PellMatchingLightProduction.pellMasks_3031_valid

theorem pellMatching_3031_checked :
    pellMatchingCheck pellMasks_3031 pellMagnitudes_3031 pellWitnesses_3031 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3031
    PellMatchingLightProduction.pellMagnitudes_3031 PellMatchingLightProduction.pellWitnesses_3031).symm.trans
      PellMatchingLightProduction.pellMatching_3031_checked

theorem pellMagnitudes_3031_large : ∀ x ∈ pellMagnitudes_3031, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3031 PellMatchingLightProduction.pellMagnitudes_3031_large

def pellGraphCertificate_3031 : PellMatchingCertificate 3031 where
  magnitudes := pellMagnitudes_3031
  masks := pellMasks_3031
  witnesses := pellWitnesses_3031
  masks_valid := pellMasks_3031_valid
  checked := pellMatching_3031_checked
  large := pellMagnitudes_3031_large

def pellMagnitudes_3079 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3079

def pellMasks_3079 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3079.map pellLightMasksToOriginal

def pellWitnesses_3079 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3079

theorem pellMasks_3079_valid : ∀ m ∈ pellMasks_3079, m.Valid 3079 := by
  exact pellLightMasks_valid 3079 PellMatchingLightProduction.pellMasks_3079 PellMatchingLightProduction.pellMasks_3079_valid

theorem pellMatching_3079_checked :
    pellMatchingCheck pellMasks_3079 pellMagnitudes_3079 pellWitnesses_3079 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3079
    PellMatchingLightProduction.pellMagnitudes_3079 PellMatchingLightProduction.pellWitnesses_3079).symm.trans
      PellMatchingLightProduction.pellMatching_3079_checked

theorem pellMagnitudes_3079_large : ∀ x ∈ pellMagnitudes_3079, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3079 PellMatchingLightProduction.pellMagnitudes_3079_large

def pellGraphCertificate_3079 : PellMatchingCertificate 3079 where
  magnitudes := pellMagnitudes_3079
  masks := pellMasks_3079
  witnesses := pellWitnesses_3079
  masks_valid := pellMasks_3079_valid
  checked := pellMatching_3079_checked
  large := pellMagnitudes_3079_large

def pellMagnitudes_3119 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3119

def pellMasks_3119 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3119.map pellLightMasksToOriginal

def pellWitnesses_3119 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3119

theorem pellMasks_3119_valid : ∀ m ∈ pellMasks_3119, m.Valid 3119 := by
  exact pellLightMasks_valid 3119 PellMatchingLightProduction.pellMasks_3119 PellMatchingLightProduction.pellMasks_3119_valid

theorem pellMatching_3119_checked :
    pellMatchingCheck pellMasks_3119 pellMagnitudes_3119 pellWitnesses_3119 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3119
    PellMatchingLightProduction.pellMagnitudes_3119 PellMatchingLightProduction.pellWitnesses_3119).symm.trans
      PellMatchingLightProduction.pellMatching_3119_checked

theorem pellMagnitudes_3119_large : ∀ x ∈ pellMagnitudes_3119, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3119 PellMatchingLightProduction.pellMagnitudes_3119_large

def pellGraphCertificate_3119 : PellMatchingCertificate 3119 where
  magnitudes := pellMagnitudes_3119
  masks := pellMasks_3119
  witnesses := pellWitnesses_3119
  masks_valid := pellMasks_3119_valid
  checked := pellMatching_3119_checked
  large := pellMagnitudes_3119_large

def pellMagnitudes_3151 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3151

def pellMasks_3151 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3151.map pellLightMasksToOriginal

def pellWitnesses_3151 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3151

theorem pellMasks_3151_valid : ∀ m ∈ pellMasks_3151, m.Valid 3151 := by
  exact pellLightMasks_valid 3151 PellMatchingLightProduction.pellMasks_3151 PellMatchingLightProduction.pellMasks_3151_valid

theorem pellMatching_3151_checked :
    pellMatchingCheck pellMasks_3151 pellMagnitudes_3151 pellWitnesses_3151 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3151
    PellMatchingLightProduction.pellMagnitudes_3151 PellMatchingLightProduction.pellWitnesses_3151).symm.trans
      PellMatchingLightProduction.pellMatching_3151_checked

theorem pellMagnitudes_3151_large : ∀ x ∈ pellMagnitudes_3151, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3151 PellMatchingLightProduction.pellMagnitudes_3151_large

def pellGraphCertificate_3151 : PellMatchingCertificate 3151 where
  magnitudes := pellMagnitudes_3151
  masks := pellMasks_3151
  witnesses := pellWitnesses_3151
  masks_valid := pellMasks_3151_valid
  checked := pellMatching_3151_checked
  large := pellMagnitudes_3151_large

def pellMagnitudes_3167 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3167

def pellMasks_3167 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3167.map pellLightMasksToOriginal

def pellWitnesses_3167 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3167

theorem pellMasks_3167_valid : ∀ m ∈ pellMasks_3167, m.Valid 3167 := by
  exact pellLightMasks_valid 3167 PellMatchingLightProduction.pellMasks_3167 PellMatchingLightProduction.pellMasks_3167_valid

theorem pellMatching_3167_checked :
    pellMatchingCheck pellMasks_3167 pellMagnitudes_3167 pellWitnesses_3167 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3167
    PellMatchingLightProduction.pellMagnitudes_3167 PellMatchingLightProduction.pellWitnesses_3167).symm.trans
      PellMatchingLightProduction.pellMatching_3167_checked

theorem pellMagnitudes_3167_large : ∀ x ∈ pellMagnitudes_3167, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3167 PellMatchingLightProduction.pellMagnitudes_3167_large

def pellGraphCertificate_3167 : PellMatchingCertificate 3167 where
  magnitudes := pellMagnitudes_3167
  masks := pellMasks_3167
  witnesses := pellWitnesses_3167
  masks_valid := pellMasks_3167_valid
  checked := pellMatching_3167_checked
  large := pellMagnitudes_3167_large

def pellMagnitudes_3191 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3191

def pellMasks_3191 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3191.map pellLightMasksToOriginal

def pellWitnesses_3191 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3191

theorem pellMasks_3191_valid : ∀ m ∈ pellMasks_3191, m.Valid 3191 := by
  exact pellLightMasks_valid 3191 PellMatchingLightProduction.pellMasks_3191 PellMatchingLightProduction.pellMasks_3191_valid

theorem pellMatching_3191_checked :
    pellMatchingCheck pellMasks_3191 pellMagnitudes_3191 pellWitnesses_3191 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3191
    PellMatchingLightProduction.pellMagnitudes_3191 PellMatchingLightProduction.pellWitnesses_3191).symm.trans
      PellMatchingLightProduction.pellMatching_3191_checked

theorem pellMagnitudes_3191_large : ∀ x ∈ pellMagnitudes_3191, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3191 PellMatchingLightProduction.pellMagnitudes_3191_large

def pellGraphCertificate_3191 : PellMatchingCertificate 3191 where
  magnitudes := pellMagnitudes_3191
  masks := pellMasks_3191
  witnesses := pellWitnesses_3191
  masks_valid := pellMasks_3191_valid
  checked := pellMatching_3191_checked
  large := pellMagnitudes_3191_large

def pellMagnitudes_3239 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3239

def pellMasks_3239 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3239.map pellLightMasksToOriginal

def pellWitnesses_3239 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3239

theorem pellMasks_3239_valid : ∀ m ∈ pellMasks_3239, m.Valid 3239 := by
  exact pellLightMasks_valid 3239 PellMatchingLightProduction.pellMasks_3239 PellMatchingLightProduction.pellMasks_3239_valid

theorem pellMatching_3239_checked :
    pellMatchingCheck pellMasks_3239 pellMagnitudes_3239 pellWitnesses_3239 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3239
    PellMatchingLightProduction.pellMagnitudes_3239 PellMatchingLightProduction.pellWitnesses_3239).symm.trans
      PellMatchingLightProduction.pellMatching_3239_checked

theorem pellMagnitudes_3239_large : ∀ x ∈ pellMagnitudes_3239, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3239 PellMatchingLightProduction.pellMagnitudes_3239_large

def pellGraphCertificate_3239 : PellMatchingCertificate 3239 where
  magnitudes := pellMagnitudes_3239
  masks := pellMasks_3239
  witnesses := pellWitnesses_3239
  masks_valid := pellMasks_3239_valid
  checked := pellMatching_3239_checked
  large := pellMagnitudes_3239_large

def pellMagnitudes_3247 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3247

def pellMasks_3247 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3247.map pellLightMasksToOriginal

def pellWitnesses_3247 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3247

theorem pellMasks_3247_valid : ∀ m ∈ pellMasks_3247, m.Valid 3247 := by
  exact pellLightMasks_valid 3247 PellMatchingLightProduction.pellMasks_3247 PellMatchingLightProduction.pellMasks_3247_valid

theorem pellMatching_3247_checked :
    pellMatchingCheck pellMasks_3247 pellMagnitudes_3247 pellWitnesses_3247 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3247
    PellMatchingLightProduction.pellMagnitudes_3247 PellMatchingLightProduction.pellWitnesses_3247).symm.trans
      PellMatchingLightProduction.pellMatching_3247_checked

theorem pellMagnitudes_3247_large : ∀ x ∈ pellMagnitudes_3247, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3247 PellMatchingLightProduction.pellMagnitudes_3247_large

def pellGraphCertificate_3247 : PellMatchingCertificate 3247 where
  magnitudes := pellMagnitudes_3247
  masks := pellMasks_3247
  witnesses := pellWitnesses_3247
  masks_valid := pellMasks_3247_valid
  checked := pellMatching_3247_checked
  large := pellMagnitudes_3247_large

def pellMagnitudes_3271 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3271

def pellMasks_3271 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3271.map pellLightMasksToOriginal

def pellWitnesses_3271 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3271

theorem pellMasks_3271_valid : ∀ m ∈ pellMasks_3271, m.Valid 3271 := by
  exact pellLightMasks_valid 3271 PellMatchingLightProduction.pellMasks_3271 PellMatchingLightProduction.pellMasks_3271_valid

theorem pellMatching_3271_checked :
    pellMatchingCheck pellMasks_3271 pellMagnitudes_3271 pellWitnesses_3271 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3271
    PellMatchingLightProduction.pellMagnitudes_3271 PellMatchingLightProduction.pellWitnesses_3271).symm.trans
      PellMatchingLightProduction.pellMatching_3271_checked

theorem pellMagnitudes_3271_large : ∀ x ∈ pellMagnitudes_3271, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3271 PellMatchingLightProduction.pellMagnitudes_3271_large

def pellGraphCertificate_3271 : PellMatchingCertificate 3271 where
  magnitudes := pellMagnitudes_3271
  masks := pellMasks_3271
  witnesses := pellWitnesses_3271
  masks_valid := pellMasks_3271_valid
  checked := pellMatching_3271_checked
  large := pellMagnitudes_3271_large

def pellMagnitudes_3319 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3319

def pellMasks_3319 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3319.map pellLightMasksToOriginal

def pellWitnesses_3319 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3319

theorem pellMasks_3319_valid : ∀ m ∈ pellMasks_3319, m.Valid 3319 := by
  exact pellLightMasks_valid 3319 PellMatchingLightProduction.pellMasks_3319 PellMatchingLightProduction.pellMasks_3319_valid

theorem pellMatching_3319_checked :
    pellMatchingCheck pellMasks_3319 pellMagnitudes_3319 pellWitnesses_3319 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3319
    PellMatchingLightProduction.pellMagnitudes_3319 PellMatchingLightProduction.pellWitnesses_3319).symm.trans
      PellMatchingLightProduction.pellMatching_3319_checked

theorem pellMagnitudes_3319_large : ∀ x ∈ pellMagnitudes_3319, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3319 PellMatchingLightProduction.pellMagnitudes_3319_large

def pellGraphCertificate_3319 : PellMatchingCertificate 3319 where
  magnitudes := pellMagnitudes_3319
  masks := pellMasks_3319
  witnesses := pellWitnesses_3319
  masks_valid := pellMasks_3319_valid
  checked := pellMatching_3319_checked
  large := pellMagnitudes_3319_large

def pellMagnitudes_3343 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3343

def pellMasks_3343 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3343.map pellLightMasksToOriginal

def pellWitnesses_3343 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3343

theorem pellMasks_3343_valid : ∀ m ∈ pellMasks_3343, m.Valid 3343 := by
  exact pellLightMasks_valid 3343 PellMatchingLightProduction.pellMasks_3343 PellMatchingLightProduction.pellMasks_3343_valid

theorem pellMatching_3343_checked :
    pellMatchingCheck pellMasks_3343 pellMagnitudes_3343 pellWitnesses_3343 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3343
    PellMatchingLightProduction.pellMagnitudes_3343 PellMatchingLightProduction.pellWitnesses_3343).symm.trans
      PellMatchingLightProduction.pellMatching_3343_checked

theorem pellMagnitudes_3343_large : ∀ x ∈ pellMagnitudes_3343, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3343 PellMatchingLightProduction.pellMagnitudes_3343_large

def pellGraphCertificate_3343 : PellMatchingCertificate 3343 where
  magnitudes := pellMagnitudes_3343
  masks := pellMasks_3343
  witnesses := pellWitnesses_3343
  masks_valid := pellMasks_3343_valid
  checked := pellMatching_3343_checked
  large := pellMagnitudes_3343_large

def pellMagnitudes_3359 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3359

def pellMasks_3359 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3359.map pellLightMasksToOriginal

def pellWitnesses_3359 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3359

theorem pellMasks_3359_valid : ∀ m ∈ pellMasks_3359, m.Valid 3359 := by
  exact pellLightMasks_valid 3359 PellMatchingLightProduction.pellMasks_3359 PellMatchingLightProduction.pellMasks_3359_valid

theorem pellMatching_3359_checked :
    pellMatchingCheck pellMasks_3359 pellMagnitudes_3359 pellWitnesses_3359 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3359
    PellMatchingLightProduction.pellMagnitudes_3359 PellMatchingLightProduction.pellWitnesses_3359).symm.trans
      PellMatchingLightProduction.pellMatching_3359_checked

theorem pellMagnitudes_3359_large : ∀ x ∈ pellMagnitudes_3359, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3359 PellMatchingLightProduction.pellMagnitudes_3359_large

def pellGraphCertificate_3359 : PellMatchingCertificate 3359 where
  magnitudes := pellMagnitudes_3359
  masks := pellMasks_3359
  witnesses := pellWitnesses_3359
  masks_valid := pellMasks_3359_valid
  checked := pellMatching_3359_checked
  large := pellMagnitudes_3359_large

def pellMagnitudes_3383 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3383

def pellMasks_3383 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3383.map pellLightMasksToOriginal

def pellWitnesses_3383 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3383

theorem pellMasks_3383_valid : ∀ m ∈ pellMasks_3383, m.Valid 3383 := by
  exact pellLightMasks_valid 3383 PellMatchingLightProduction.pellMasks_3383 PellMatchingLightProduction.pellMasks_3383_valid

theorem pellMatching_3383_checked :
    pellMatchingCheck pellMasks_3383 pellMagnitudes_3383 pellWitnesses_3383 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3383
    PellMatchingLightProduction.pellMagnitudes_3383 PellMatchingLightProduction.pellWitnesses_3383).symm.trans
      PellMatchingLightProduction.pellMatching_3383_checked

theorem pellMagnitudes_3383_large : ∀ x ∈ pellMagnitudes_3383, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3383 PellMatchingLightProduction.pellMagnitudes_3383_large

def pellGraphCertificate_3383 : PellMatchingCertificate 3383 where
  magnitudes := pellMagnitudes_3383
  masks := pellMasks_3383
  witnesses := pellWitnesses_3383
  masks_valid := pellMasks_3383_valid
  checked := pellMatching_3383_checked
  large := pellMagnitudes_3383_large

def pellMagnitudes_3391 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3391

def pellMasks_3391 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3391.map pellLightMasksToOriginal

def pellWitnesses_3391 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3391

theorem pellMasks_3391_valid : ∀ m ∈ pellMasks_3391, m.Valid 3391 := by
  exact pellLightMasks_valid 3391 PellMatchingLightProduction.pellMasks_3391 PellMatchingLightProduction.pellMasks_3391_valid

theorem pellMatching_3391_checked :
    pellMatchingCheck pellMasks_3391 pellMagnitudes_3391 pellWitnesses_3391 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3391
    PellMatchingLightProduction.pellMagnitudes_3391 PellMatchingLightProduction.pellWitnesses_3391).symm.trans
      PellMatchingLightProduction.pellMatching_3391_checked

theorem pellMagnitudes_3391_large : ∀ x ∈ pellMagnitudes_3391, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3391 PellMatchingLightProduction.pellMagnitudes_3391_large

def pellGraphCertificate_3391 : PellMatchingCertificate 3391 where
  magnitudes := pellMagnitudes_3391
  masks := pellMasks_3391
  witnesses := pellWitnesses_3391
  masks_valid := pellMasks_3391_valid
  checked := pellMatching_3391_checked
  large := pellMagnitudes_3391_large

def pellMagnitudes_3407 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3407

def pellMasks_3407 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3407.map pellLightMasksToOriginal

def pellWitnesses_3407 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3407

theorem pellMasks_3407_valid : ∀ m ∈ pellMasks_3407, m.Valid 3407 := by
  exact pellLightMasks_valid 3407 PellMatchingLightProduction.pellMasks_3407 PellMatchingLightProduction.pellMasks_3407_valid

theorem pellMatching_3407_checked :
    pellMatchingCheck pellMasks_3407 pellMagnitudes_3407 pellWitnesses_3407 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3407
    PellMatchingLightProduction.pellMagnitudes_3407 PellMatchingLightProduction.pellWitnesses_3407).symm.trans
      PellMatchingLightProduction.pellMatching_3407_checked

theorem pellMagnitudes_3407_large : ∀ x ∈ pellMagnitudes_3407, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3407 PellMatchingLightProduction.pellMagnitudes_3407_large

def pellGraphCertificate_3407 : PellMatchingCertificate 3407 where
  magnitudes := pellMagnitudes_3407
  masks := pellMasks_3407
  witnesses := pellWitnesses_3407
  masks_valid := pellMasks_3407_valid
  checked := pellMatching_3407_checked
  large := pellMagnitudes_3407_large

def pellMagnitudes_3431 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3431

def pellMasks_3431 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3431.map pellLightMasksToOriginal

def pellWitnesses_3431 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3431

theorem pellMasks_3431_valid : ∀ m ∈ pellMasks_3431, m.Valid 3431 := by
  exact pellLightMasks_valid 3431 PellMatchingLightProduction.pellMasks_3431 PellMatchingLightProduction.pellMasks_3431_valid

theorem pellMatching_3431_checked :
    pellMatchingCheck pellMasks_3431 pellMagnitudes_3431 pellWitnesses_3431 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3431
    PellMatchingLightProduction.pellMagnitudes_3431 PellMatchingLightProduction.pellWitnesses_3431).symm.trans
      PellMatchingLightProduction.pellMatching_3431_checked

theorem pellMagnitudes_3431_large : ∀ x ∈ pellMagnitudes_3431, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3431 PellMatchingLightProduction.pellMagnitudes_3431_large

def pellGraphCertificate_3431 : PellMatchingCertificate 3431 where
  magnitudes := pellMagnitudes_3431
  masks := pellMasks_3431
  witnesses := pellWitnesses_3431
  masks_valid := pellMasks_3431_valid
  checked := pellMatching_3431_checked
  large := pellMagnitudes_3431_large

def pellMagnitudes_3463 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3463

def pellMasks_3463 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3463.map pellLightMasksToOriginal

def pellWitnesses_3463 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3463

theorem pellMasks_3463_valid : ∀ m ∈ pellMasks_3463, m.Valid 3463 := by
  exact pellLightMasks_valid 3463 PellMatchingLightProduction.pellMasks_3463 PellMatchingLightProduction.pellMasks_3463_valid

theorem pellMatching_3463_checked :
    pellMatchingCheck pellMasks_3463 pellMagnitudes_3463 pellWitnesses_3463 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3463
    PellMatchingLightProduction.pellMagnitudes_3463 PellMatchingLightProduction.pellWitnesses_3463).symm.trans
      PellMatchingLightProduction.pellMatching_3463_checked

theorem pellMagnitudes_3463_large : ∀ x ∈ pellMagnitudes_3463, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3463 PellMatchingLightProduction.pellMagnitudes_3463_large

def pellGraphCertificate_3463 : PellMatchingCertificate 3463 where
  magnitudes := pellMagnitudes_3463
  masks := pellMasks_3463
  witnesses := pellWitnesses_3463
  masks_valid := pellMasks_3463_valid
  checked := pellMatching_3463_checked
  large := pellMagnitudes_3463_large

def pellMagnitudes_3511 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3511

def pellMasks_3511 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3511.map pellLightMasksToOriginal

def pellWitnesses_3511 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3511

theorem pellMasks_3511_valid : ∀ m ∈ pellMasks_3511, m.Valid 3511 := by
  exact pellLightMasks_valid 3511 PellMatchingLightProduction.pellMasks_3511 PellMatchingLightProduction.pellMasks_3511_valid

theorem pellMatching_3511_checked :
    pellMatchingCheck pellMasks_3511 pellMagnitudes_3511 pellWitnesses_3511 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3511
    PellMatchingLightProduction.pellMagnitudes_3511 PellMatchingLightProduction.pellWitnesses_3511).symm.trans
      PellMatchingLightProduction.pellMatching_3511_checked

theorem pellMagnitudes_3511_large : ∀ x ∈ pellMagnitudes_3511, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3511 PellMatchingLightProduction.pellMagnitudes_3511_large

def pellGraphCertificate_3511 : PellMatchingCertificate 3511 where
  magnitudes := pellMagnitudes_3511
  masks := pellMasks_3511
  witnesses := pellWitnesses_3511
  masks_valid := pellMasks_3511_valid
  checked := pellMatching_3511_checked
  large := pellMagnitudes_3511_large

def pellMagnitudes_3527 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3527

def pellMasks_3527 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3527.map pellLightMasksToOriginal

def pellWitnesses_3527 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3527

theorem pellMasks_3527_valid : ∀ m ∈ pellMasks_3527, m.Valid 3527 := by
  exact pellLightMasks_valid 3527 PellMatchingLightProduction.pellMasks_3527 PellMatchingLightProduction.pellMasks_3527_valid

theorem pellMatching_3527_checked :
    pellMatchingCheck pellMasks_3527 pellMagnitudes_3527 pellWitnesses_3527 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3527
    PellMatchingLightProduction.pellMagnitudes_3527 PellMatchingLightProduction.pellWitnesses_3527).symm.trans
      PellMatchingLightProduction.pellMatching_3527_checked

theorem pellMagnitudes_3527_large : ∀ x ∈ pellMagnitudes_3527, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3527 PellMatchingLightProduction.pellMagnitudes_3527_large

def pellGraphCertificate_3527 : PellMatchingCertificate 3527 where
  magnitudes := pellMagnitudes_3527
  masks := pellMasks_3527
  witnesses := pellWitnesses_3527
  masks_valid := pellMasks_3527_valid
  checked := pellMatching_3527_checked
  large := pellMagnitudes_3527_large

def pellMagnitudes_3559 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3559

def pellMasks_3559 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3559.map pellLightMasksToOriginal

def pellWitnesses_3559 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3559

theorem pellMasks_3559_valid : ∀ m ∈ pellMasks_3559, m.Valid 3559 := by
  exact pellLightMasks_valid 3559 PellMatchingLightProduction.pellMasks_3559 PellMatchingLightProduction.pellMasks_3559_valid

theorem pellMatching_3559_checked :
    pellMatchingCheck pellMasks_3559 pellMagnitudes_3559 pellWitnesses_3559 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3559
    PellMatchingLightProduction.pellMagnitudes_3559 PellMatchingLightProduction.pellWitnesses_3559).symm.trans
      PellMatchingLightProduction.pellMatching_3559_checked

theorem pellMagnitudes_3559_large : ∀ x ∈ pellMagnitudes_3559, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3559 PellMatchingLightProduction.pellMagnitudes_3559_large

def pellGraphCertificate_3559 : PellMatchingCertificate 3559 where
  magnitudes := pellMagnitudes_3559
  masks := pellMasks_3559
  witnesses := pellWitnesses_3559
  masks_valid := pellMasks_3559_valid
  checked := pellMatching_3559_checked
  large := pellMagnitudes_3559_large

def pellMagnitudes_3583 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3583

def pellMasks_3583 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3583.map pellLightMasksToOriginal

def pellWitnesses_3583 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3583

theorem pellMasks_3583_valid : ∀ m ∈ pellMasks_3583, m.Valid 3583 := by
  exact pellLightMasks_valid 3583 PellMatchingLightProduction.pellMasks_3583 PellMatchingLightProduction.pellMasks_3583_valid

theorem pellMatching_3583_checked :
    pellMatchingCheck pellMasks_3583 pellMagnitudes_3583 pellWitnesses_3583 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3583
    PellMatchingLightProduction.pellMagnitudes_3583 PellMatchingLightProduction.pellWitnesses_3583).symm.trans
      PellMatchingLightProduction.pellMatching_3583_checked

theorem pellMagnitudes_3583_large : ∀ x ∈ pellMagnitudes_3583, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3583 PellMatchingLightProduction.pellMagnitudes_3583_large

def pellGraphCertificate_3583 : PellMatchingCertificate 3583 where
  magnitudes := pellMagnitudes_3583
  masks := pellMasks_3583
  witnesses := pellWitnesses_3583
  masks_valid := pellMasks_3583_valid
  checked := pellMatching_3583_checked
  large := pellMagnitudes_3583_large

def pellMagnitudes_3607 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3607

def pellMasks_3607 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3607.map pellLightMasksToOriginal

def pellWitnesses_3607 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3607

theorem pellMasks_3607_valid : ∀ m ∈ pellMasks_3607, m.Valid 3607 := by
  exact pellLightMasks_valid 3607 PellMatchingLightProduction.pellMasks_3607 PellMatchingLightProduction.pellMasks_3607_valid

theorem pellMatching_3607_checked :
    pellMatchingCheck pellMasks_3607 pellMagnitudes_3607 pellWitnesses_3607 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3607
    PellMatchingLightProduction.pellMagnitudes_3607 PellMatchingLightProduction.pellWitnesses_3607).symm.trans
      PellMatchingLightProduction.pellMatching_3607_checked

theorem pellMagnitudes_3607_large : ∀ x ∈ pellMagnitudes_3607, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3607 PellMatchingLightProduction.pellMagnitudes_3607_large

def pellGraphCertificate_3607 : PellMatchingCertificate 3607 where
  magnitudes := pellMagnitudes_3607
  masks := pellMasks_3607
  witnesses := pellWitnesses_3607
  masks_valid := pellMasks_3607_valid
  checked := pellMatching_3607_checked
  large := pellMagnitudes_3607_large

def pellMagnitudes_3623 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3623

def pellMasks_3623 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3623.map pellLightMasksToOriginal

def pellWitnesses_3623 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3623

theorem pellMasks_3623_valid : ∀ m ∈ pellMasks_3623, m.Valid 3623 := by
  exact pellLightMasks_valid 3623 PellMatchingLightProduction.pellMasks_3623 PellMatchingLightProduction.pellMasks_3623_valid

theorem pellMatching_3623_checked :
    pellMatchingCheck pellMasks_3623 pellMagnitudes_3623 pellWitnesses_3623 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3623
    PellMatchingLightProduction.pellMagnitudes_3623 PellMatchingLightProduction.pellWitnesses_3623).symm.trans
      PellMatchingLightProduction.pellMatching_3623_checked

theorem pellMagnitudes_3623_large : ∀ x ∈ pellMagnitudes_3623, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3623 PellMatchingLightProduction.pellMagnitudes_3623_large

def pellGraphCertificate_3623 : PellMatchingCertificate 3623 where
  magnitudes := pellMagnitudes_3623
  masks := pellMasks_3623
  witnesses := pellWitnesses_3623
  masks_valid := pellMasks_3623_valid
  checked := pellMatching_3623_checked
  large := pellMagnitudes_3623_large

def pellMagnitudes_3631 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3631

def pellMasks_3631 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3631.map pellLightMasksToOriginal

def pellWitnesses_3631 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3631

theorem pellMasks_3631_valid : ∀ m ∈ pellMasks_3631, m.Valid 3631 := by
  exact pellLightMasks_valid 3631 PellMatchingLightProduction.pellMasks_3631 PellMatchingLightProduction.pellMasks_3631_valid

theorem pellMatching_3631_checked :
    pellMatchingCheck pellMasks_3631 pellMagnitudes_3631 pellWitnesses_3631 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3631
    PellMatchingLightProduction.pellMagnitudes_3631 PellMatchingLightProduction.pellWitnesses_3631).symm.trans
      PellMatchingLightProduction.pellMatching_3631_checked

theorem pellMagnitudes_3631_large : ∀ x ∈ pellMagnitudes_3631, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3631 PellMatchingLightProduction.pellMagnitudes_3631_large

def pellGraphCertificate_3631 : PellMatchingCertificate 3631 where
  magnitudes := pellMagnitudes_3631
  masks := pellMasks_3631
  witnesses := pellWitnesses_3631
  masks_valid := pellMasks_3631_valid
  checked := pellMatching_3631_checked
  large := pellMagnitudes_3631_large

def pellMagnitudes_3647 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3647

def pellMasks_3647 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3647.map pellLightMasksToOriginal

def pellWitnesses_3647 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3647

theorem pellMasks_3647_valid : ∀ m ∈ pellMasks_3647, m.Valid 3647 := by
  exact pellLightMasks_valid 3647 PellMatchingLightProduction.pellMasks_3647 PellMatchingLightProduction.pellMasks_3647_valid

theorem pellMatching_3647_checked :
    pellMatchingCheck pellMasks_3647 pellMagnitudes_3647 pellWitnesses_3647 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3647
    PellMatchingLightProduction.pellMagnitudes_3647 PellMatchingLightProduction.pellWitnesses_3647).symm.trans
      PellMatchingLightProduction.pellMatching_3647_checked

theorem pellMagnitudes_3647_large : ∀ x ∈ pellMagnitudes_3647, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3647 PellMatchingLightProduction.pellMagnitudes_3647_large

def pellGraphCertificate_3647 : PellMatchingCertificate 3647 where
  magnitudes := pellMagnitudes_3647
  masks := pellMasks_3647
  witnesses := pellWitnesses_3647
  masks_valid := pellMasks_3647_valid
  checked := pellMatching_3647_checked
  large := pellMagnitudes_3647_large

def pellMagnitudes_3671 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3671

def pellMasks_3671 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3671.map pellLightMasksToOriginal

def pellWitnesses_3671 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3671

theorem pellMasks_3671_valid : ∀ m ∈ pellMasks_3671, m.Valid 3671 := by
  exact pellLightMasks_valid 3671 PellMatchingLightProduction.pellMasks_3671 PellMatchingLightProduction.pellMasks_3671_valid

theorem pellMatching_3671_checked :
    pellMatchingCheck pellMasks_3671 pellMagnitudes_3671 pellWitnesses_3671 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3671
    PellMatchingLightProduction.pellMagnitudes_3671 PellMatchingLightProduction.pellWitnesses_3671).symm.trans
      PellMatchingLightProduction.pellMatching_3671_checked

theorem pellMagnitudes_3671_large : ∀ x ∈ pellMagnitudes_3671, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3671 PellMatchingLightProduction.pellMagnitudes_3671_large

def pellGraphCertificate_3671 : PellMatchingCertificate 3671 where
  magnitudes := pellMagnitudes_3671
  masks := pellMasks_3671
  witnesses := pellWitnesses_3671
  masks_valid := pellMasks_3671_valid
  checked := pellMatching_3671_checked
  large := pellMagnitudes_3671_large

def pellMagnitudes_3719 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3719

def pellMasks_3719 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3719.map pellLightMasksToOriginal

def pellWitnesses_3719 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3719

theorem pellMasks_3719_valid : ∀ m ∈ pellMasks_3719, m.Valid 3719 := by
  exact pellLightMasks_valid 3719 PellMatchingLightProduction.pellMasks_3719 PellMatchingLightProduction.pellMasks_3719_valid

theorem pellMatching_3719_checked :
    pellMatchingCheck pellMasks_3719 pellMagnitudes_3719 pellWitnesses_3719 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3719
    PellMatchingLightProduction.pellMagnitudes_3719 PellMatchingLightProduction.pellWitnesses_3719).symm.trans
      PellMatchingLightProduction.pellMatching_3719_checked

theorem pellMagnitudes_3719_large : ∀ x ∈ pellMagnitudes_3719, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3719 PellMatchingLightProduction.pellMagnitudes_3719_large

def pellGraphCertificate_3719 : PellMatchingCertificate 3719 where
  magnitudes := pellMagnitudes_3719
  masks := pellMasks_3719
  witnesses := pellWitnesses_3719
  masks_valid := pellMasks_3719_valid
  checked := pellMatching_3719_checked
  large := pellMagnitudes_3719_large

def pellMagnitudes_3727 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3727

def pellMasks_3727 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3727.map pellLightMasksToOriginal

def pellWitnesses_3727 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3727

theorem pellMasks_3727_valid : ∀ m ∈ pellMasks_3727, m.Valid 3727 := by
  exact pellLightMasks_valid 3727 PellMatchingLightProduction.pellMasks_3727 PellMatchingLightProduction.pellMasks_3727_valid

theorem pellMatching_3727_checked :
    pellMatchingCheck pellMasks_3727 pellMagnitudes_3727 pellWitnesses_3727 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3727
    PellMatchingLightProduction.pellMagnitudes_3727 PellMatchingLightProduction.pellWitnesses_3727).symm.trans
      PellMatchingLightProduction.pellMatching_3727_checked

theorem pellMagnitudes_3727_large : ∀ x ∈ pellMagnitudes_3727, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3727 PellMatchingLightProduction.pellMagnitudes_3727_large

def pellGraphCertificate_3727 : PellMatchingCertificate 3727 where
  magnitudes := pellMagnitudes_3727
  masks := pellMasks_3727
  witnesses := pellWitnesses_3727
  masks_valid := pellMasks_3727_valid
  checked := pellMatching_3727_checked
  large := pellMagnitudes_3727_large

def pellMagnitudes_3767 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3767

def pellMasks_3767 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3767.map pellLightMasksToOriginal

def pellWitnesses_3767 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3767

theorem pellMasks_3767_valid : ∀ m ∈ pellMasks_3767, m.Valid 3767 := by
  exact pellLightMasks_valid 3767 PellMatchingLightProduction.pellMasks_3767 PellMatchingLightProduction.pellMasks_3767_valid

theorem pellMatching_3767_checked :
    pellMatchingCheck pellMasks_3767 pellMagnitudes_3767 pellWitnesses_3767 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3767
    PellMatchingLightProduction.pellMagnitudes_3767 PellMatchingLightProduction.pellWitnesses_3767).symm.trans
      PellMatchingLightProduction.pellMatching_3767_checked

theorem pellMagnitudes_3767_large : ∀ x ∈ pellMagnitudes_3767, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3767 PellMatchingLightProduction.pellMagnitudes_3767_large

def pellGraphCertificate_3767 : PellMatchingCertificate 3767 where
  magnitudes := pellMagnitudes_3767
  masks := pellMasks_3767
  witnesses := pellWitnesses_3767
  masks_valid := pellMasks_3767_valid
  checked := pellMatching_3767_checked
  large := pellMagnitudes_3767_large

def pellMagnitudes_3791 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3791

def pellMasks_3791 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3791.map pellLightMasksToOriginal

def pellWitnesses_3791 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3791

theorem pellMasks_3791_valid : ∀ m ∈ pellMasks_3791, m.Valid 3791 := by
  exact pellLightMasks_valid 3791 PellMatchingLightProduction.pellMasks_3791 PellMatchingLightProduction.pellMasks_3791_valid

theorem pellMatching_3791_checked :
    pellMatchingCheck pellMasks_3791 pellMagnitudes_3791 pellWitnesses_3791 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3791
    PellMatchingLightProduction.pellMagnitudes_3791 PellMatchingLightProduction.pellWitnesses_3791).symm.trans
      PellMatchingLightProduction.pellMatching_3791_checked

theorem pellMagnitudes_3791_large : ∀ x ∈ pellMagnitudes_3791, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3791 PellMatchingLightProduction.pellMagnitudes_3791_large

def pellGraphCertificate_3791 : PellMatchingCertificate 3791 where
  magnitudes := pellMagnitudes_3791
  masks := pellMasks_3791
  witnesses := pellWitnesses_3791
  masks_valid := pellMasks_3791_valid
  checked := pellMatching_3791_checked
  large := pellMagnitudes_3791_large

def pellMagnitudes_3823 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3823

def pellMasks_3823 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3823.map pellLightMasksToOriginal

def pellWitnesses_3823 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3823

theorem pellMasks_3823_valid : ∀ m ∈ pellMasks_3823, m.Valid 3823 := by
  exact pellLightMasks_valid 3823 PellMatchingLightProduction.pellMasks_3823 PellMatchingLightProduction.pellMasks_3823_valid

theorem pellMatching_3823_checked :
    pellMatchingCheck pellMasks_3823 pellMagnitudes_3823 pellWitnesses_3823 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3823
    PellMatchingLightProduction.pellMagnitudes_3823 PellMatchingLightProduction.pellWitnesses_3823).symm.trans
      PellMatchingLightProduction.pellMatching_3823_checked

theorem pellMagnitudes_3823_large : ∀ x ∈ pellMagnitudes_3823, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3823 PellMatchingLightProduction.pellMagnitudes_3823_large

def pellGraphCertificate_3823 : PellMatchingCertificate 3823 where
  magnitudes := pellMagnitudes_3823
  masks := pellMasks_3823
  witnesses := pellWitnesses_3823
  masks_valid := pellMasks_3823_valid
  checked := pellMatching_3823_checked
  large := pellMagnitudes_3823_large

def pellMagnitudes_3847 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3847

def pellMasks_3847 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3847.map pellLightMasksToOriginal

def pellWitnesses_3847 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3847

theorem pellMasks_3847_valid : ∀ m ∈ pellMasks_3847, m.Valid 3847 := by
  exact pellLightMasks_valid 3847 PellMatchingLightProduction.pellMasks_3847 PellMatchingLightProduction.pellMasks_3847_valid

theorem pellMatching_3847_checked :
    pellMatchingCheck pellMasks_3847 pellMagnitudes_3847 pellWitnesses_3847 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3847
    PellMatchingLightProduction.pellMagnitudes_3847 PellMatchingLightProduction.pellWitnesses_3847).symm.trans
      PellMatchingLightProduction.pellMatching_3847_checked

theorem pellMagnitudes_3847_large : ∀ x ∈ pellMagnitudes_3847, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3847 PellMatchingLightProduction.pellMagnitudes_3847_large

def pellGraphCertificate_3847 : PellMatchingCertificate 3847 where
  magnitudes := pellMagnitudes_3847
  masks := pellMasks_3847
  witnesses := pellWitnesses_3847
  masks_valid := pellMasks_3847_valid
  checked := pellMatching_3847_checked
  large := pellMagnitudes_3847_large

def pellMagnitudes_3863 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3863

def pellMasks_3863 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3863.map pellLightMasksToOriginal

def pellWitnesses_3863 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3863

theorem pellMasks_3863_valid : ∀ m ∈ pellMasks_3863, m.Valid 3863 := by
  exact pellLightMasks_valid 3863 PellMatchingLightProduction.pellMasks_3863 PellMatchingLightProduction.pellMasks_3863_valid

theorem pellMatching_3863_checked :
    pellMatchingCheck pellMasks_3863 pellMagnitudes_3863 pellWitnesses_3863 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3863
    PellMatchingLightProduction.pellMagnitudes_3863 PellMatchingLightProduction.pellWitnesses_3863).symm.trans
      PellMatchingLightProduction.pellMatching_3863_checked

theorem pellMagnitudes_3863_large : ∀ x ∈ pellMagnitudes_3863, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3863 PellMatchingLightProduction.pellMagnitudes_3863_large

def pellGraphCertificate_3863 : PellMatchingCertificate 3863 where
  magnitudes := pellMagnitudes_3863
  masks := pellMasks_3863
  witnesses := pellWitnesses_3863
  masks_valid := pellMasks_3863_valid
  checked := pellMatching_3863_checked
  large := pellMagnitudes_3863_large

def pellMagnitudes_3911 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3911

def pellMasks_3911 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3911.map pellLightMasksToOriginal

def pellWitnesses_3911 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3911

theorem pellMasks_3911_valid : ∀ m ∈ pellMasks_3911, m.Valid 3911 := by
  exact pellLightMasks_valid 3911 PellMatchingLightProduction.pellMasks_3911 PellMatchingLightProduction.pellMasks_3911_valid

theorem pellMatching_3911_checked :
    pellMatchingCheck pellMasks_3911 pellMagnitudes_3911 pellWitnesses_3911 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3911
    PellMatchingLightProduction.pellMagnitudes_3911 PellMatchingLightProduction.pellWitnesses_3911).symm.trans
      PellMatchingLightProduction.pellMatching_3911_checked

theorem pellMagnitudes_3911_large : ∀ x ∈ pellMagnitudes_3911, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3911 PellMatchingLightProduction.pellMagnitudes_3911_large

def pellGraphCertificate_3911 : PellMatchingCertificate 3911 where
  magnitudes := pellMagnitudes_3911
  masks := pellMasks_3911
  witnesses := pellWitnesses_3911
  masks_valid := pellMasks_3911_valid
  checked := pellMatching_3911_checked
  large := pellMagnitudes_3911_large

def pellMagnitudes_3919 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3919

def pellMasks_3919 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3919.map pellLightMasksToOriginal

def pellWitnesses_3919 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3919

theorem pellMasks_3919_valid : ∀ m ∈ pellMasks_3919, m.Valid 3919 := by
  exact pellLightMasks_valid 3919 PellMatchingLightProduction.pellMasks_3919 PellMatchingLightProduction.pellMasks_3919_valid

theorem pellMatching_3919_checked :
    pellMatchingCheck pellMasks_3919 pellMagnitudes_3919 pellWitnesses_3919 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3919
    PellMatchingLightProduction.pellMagnitudes_3919 PellMatchingLightProduction.pellWitnesses_3919).symm.trans
      PellMatchingLightProduction.pellMatching_3919_checked

theorem pellMagnitudes_3919_large : ∀ x ∈ pellMagnitudes_3919, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3919 PellMatchingLightProduction.pellMagnitudes_3919_large

def pellGraphCertificate_3919 : PellMatchingCertificate 3919 where
  magnitudes := pellMagnitudes_3919
  masks := pellMasks_3919
  witnesses := pellWitnesses_3919
  masks_valid := pellMasks_3919_valid
  checked := pellMatching_3919_checked
  large := pellMagnitudes_3919_large

def pellMagnitudes_3943 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3943

def pellMasks_3943 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3943.map pellLightMasksToOriginal

def pellWitnesses_3943 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3943

theorem pellMasks_3943_valid : ∀ m ∈ pellMasks_3943, m.Valid 3943 := by
  exact pellLightMasks_valid 3943 PellMatchingLightProduction.pellMasks_3943 PellMatchingLightProduction.pellMasks_3943_valid

theorem pellMatching_3943_checked :
    pellMatchingCheck pellMasks_3943 pellMagnitudes_3943 pellWitnesses_3943 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3943
    PellMatchingLightProduction.pellMagnitudes_3943 PellMatchingLightProduction.pellWitnesses_3943).symm.trans
      PellMatchingLightProduction.pellMatching_3943_checked

theorem pellMagnitudes_3943_large : ∀ x ∈ pellMagnitudes_3943, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3943 PellMatchingLightProduction.pellMagnitudes_3943_large

def pellGraphCertificate_3943 : PellMatchingCertificate 3943 where
  magnitudes := pellMagnitudes_3943
  masks := pellMasks_3943
  witnesses := pellWitnesses_3943
  masks_valid := pellMasks_3943_valid
  checked := pellMatching_3943_checked
  large := pellMagnitudes_3943_large

def pellMagnitudes_3967 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_3967

def pellMasks_3967 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_3967.map pellLightMasksToOriginal

def pellWitnesses_3967 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_3967

theorem pellMasks_3967_valid : ∀ m ∈ pellMasks_3967, m.Valid 3967 := by
  exact pellLightMasks_valid 3967 PellMatchingLightProduction.pellMasks_3967 PellMatchingLightProduction.pellMasks_3967_valid

theorem pellMatching_3967_checked :
    pellMatchingCheck pellMasks_3967 pellMagnitudes_3967 pellWitnesses_3967 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_3967
    PellMatchingLightProduction.pellMagnitudes_3967 PellMatchingLightProduction.pellWitnesses_3967).symm.trans
      PellMatchingLightProduction.pellMatching_3967_checked

theorem pellMagnitudes_3967_large : ∀ x ∈ pellMagnitudes_3967, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_3967 PellMatchingLightProduction.pellMagnitudes_3967_large

def pellGraphCertificate_3967 : PellMatchingCertificate 3967 where
  magnitudes := pellMagnitudes_3967
  masks := pellMasks_3967
  witnesses := pellWitnesses_3967
  masks_valid := pellMasks_3967_valid
  checked := pellMatching_3967_checked
  large := pellMagnitudes_3967_large

def pellMagnitudes_4007 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4007

def pellMasks_4007 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4007.map pellLightMasksToOriginal

def pellWitnesses_4007 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4007

theorem pellMasks_4007_valid : ∀ m ∈ pellMasks_4007, m.Valid 4007 := by
  exact pellLightMasks_valid 4007 PellMatchingLightProduction.pellMasks_4007 PellMatchingLightProduction.pellMasks_4007_valid

theorem pellMatching_4007_checked :
    pellMatchingCheck pellMasks_4007 pellMagnitudes_4007 pellWitnesses_4007 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4007
    PellMatchingLightProduction.pellMagnitudes_4007 PellMatchingLightProduction.pellWitnesses_4007).symm.trans
      PellMatchingLightProduction.pellMatching_4007_checked

theorem pellMagnitudes_4007_large : ∀ x ∈ pellMagnitudes_4007, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4007 PellMatchingLightProduction.pellMagnitudes_4007_large

def pellGraphCertificate_4007 : PellMatchingCertificate 4007 where
  magnitudes := pellMagnitudes_4007
  masks := pellMasks_4007
  witnesses := pellWitnesses_4007
  masks_valid := pellMasks_4007_valid
  checked := pellMatching_4007_checked
  large := pellMagnitudes_4007_large

def pellMagnitudes_4039 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4039

def pellMasks_4039 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4039.map pellLightMasksToOriginal

def pellWitnesses_4039 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4039

theorem pellMasks_4039_valid : ∀ m ∈ pellMasks_4039, m.Valid 4039 := by
  exact pellLightMasks_valid 4039 PellMatchingLightProduction.pellMasks_4039 PellMatchingLightProduction.pellMasks_4039_valid

theorem pellMatching_4039_checked :
    pellMatchingCheck pellMasks_4039 pellMagnitudes_4039 pellWitnesses_4039 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4039
    PellMatchingLightProduction.pellMagnitudes_4039 PellMatchingLightProduction.pellWitnesses_4039).symm.trans
      PellMatchingLightProduction.pellMatching_4039_checked

theorem pellMagnitudes_4039_large : ∀ x ∈ pellMagnitudes_4039, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4039 PellMatchingLightProduction.pellMagnitudes_4039_large

def pellGraphCertificate_4039 : PellMatchingCertificate 4039 where
  magnitudes := pellMagnitudes_4039
  masks := pellMasks_4039
  witnesses := pellWitnesses_4039
  masks_valid := pellMasks_4039_valid
  checked := pellMatching_4039_checked
  large := pellMagnitudes_4039_large

def pellMagnitudes_4079 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4079

def pellMasks_4079 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4079.map pellLightMasksToOriginal

def pellWitnesses_4079 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4079

theorem pellMasks_4079_valid : ∀ m ∈ pellMasks_4079, m.Valid 4079 := by
  exact pellLightMasks_valid 4079 PellMatchingLightProduction.pellMasks_4079 PellMatchingLightProduction.pellMasks_4079_valid

theorem pellMatching_4079_checked :
    pellMatchingCheck pellMasks_4079 pellMagnitudes_4079 pellWitnesses_4079 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4079
    PellMatchingLightProduction.pellMagnitudes_4079 PellMatchingLightProduction.pellWitnesses_4079).symm.trans
      PellMatchingLightProduction.pellMatching_4079_checked

theorem pellMagnitudes_4079_large : ∀ x ∈ pellMagnitudes_4079, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4079 PellMatchingLightProduction.pellMagnitudes_4079_large

def pellGraphCertificate_4079 : PellMatchingCertificate 4079 where
  magnitudes := pellMagnitudes_4079
  masks := pellMasks_4079
  witnesses := pellWitnesses_4079
  masks_valid := pellMasks_4079_valid
  checked := pellMatching_4079_checked
  large := pellMagnitudes_4079_large

def pellMagnitudes_4111 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4111

def pellMasks_4111 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4111.map pellLightMasksToOriginal

def pellWitnesses_4111 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4111

theorem pellMasks_4111_valid : ∀ m ∈ pellMasks_4111, m.Valid 4111 := by
  exact pellLightMasks_valid 4111 PellMatchingLightProduction.pellMasks_4111 PellMatchingLightProduction.pellMasks_4111_valid

theorem pellMatching_4111_checked :
    pellMatchingCheck pellMasks_4111 pellMagnitudes_4111 pellWitnesses_4111 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4111
    PellMatchingLightProduction.pellMagnitudes_4111 PellMatchingLightProduction.pellWitnesses_4111).symm.trans
      PellMatchingLightProduction.pellMatching_4111_checked

theorem pellMagnitudes_4111_large : ∀ x ∈ pellMagnitudes_4111, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4111 PellMatchingLightProduction.pellMagnitudes_4111_large

def pellGraphCertificate_4111 : PellMatchingCertificate 4111 where
  magnitudes := pellMagnitudes_4111
  masks := pellMasks_4111
  witnesses := pellWitnesses_4111
  masks_valid := pellMasks_4111_valid
  checked := pellMatching_4111_checked
  large := pellMagnitudes_4111_large

def pellMagnitudes_4127 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4127

def pellMasks_4127 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4127.map pellLightMasksToOriginal

def pellWitnesses_4127 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4127

theorem pellMasks_4127_valid : ∀ m ∈ pellMasks_4127, m.Valid 4127 := by
  exact pellLightMasks_valid 4127 PellMatchingLightProduction.pellMasks_4127 PellMatchingLightProduction.pellMasks_4127_valid

theorem pellMatching_4127_checked :
    pellMatchingCheck pellMasks_4127 pellMagnitudes_4127 pellWitnesses_4127 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4127
    PellMatchingLightProduction.pellMagnitudes_4127 PellMatchingLightProduction.pellWitnesses_4127).symm.trans
      PellMatchingLightProduction.pellMatching_4127_checked

theorem pellMagnitudes_4127_large : ∀ x ∈ pellMagnitudes_4127, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4127 PellMatchingLightProduction.pellMagnitudes_4127_large

def pellGraphCertificate_4127 : PellMatchingCertificate 4127 where
  magnitudes := pellMagnitudes_4127
  masks := pellMasks_4127
  witnesses := pellWitnesses_4127
  masks_valid := pellMasks_4127_valid
  checked := pellMatching_4127_checked
  large := pellMagnitudes_4127_large

def pellMagnitudes_4151 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4151

def pellMasks_4151 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4151.map pellLightMasksToOriginal

def pellWitnesses_4151 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4151

theorem pellMasks_4151_valid : ∀ m ∈ pellMasks_4151, m.Valid 4151 := by
  exact pellLightMasks_valid 4151 PellMatchingLightProduction.pellMasks_4151 PellMatchingLightProduction.pellMasks_4151_valid

theorem pellMatching_4151_checked :
    pellMatchingCheck pellMasks_4151 pellMagnitudes_4151 pellWitnesses_4151 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4151
    PellMatchingLightProduction.pellMagnitudes_4151 PellMatchingLightProduction.pellWitnesses_4151).symm.trans
      PellMatchingLightProduction.pellMatching_4151_checked

theorem pellMagnitudes_4151_large : ∀ x ∈ pellMagnitudes_4151, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4151 PellMatchingLightProduction.pellMagnitudes_4151_large

def pellGraphCertificate_4151 : PellMatchingCertificate 4151 where
  magnitudes := pellMagnitudes_4151
  masks := pellMasks_4151
  witnesses := pellWitnesses_4151
  masks_valid := pellMasks_4151_valid
  checked := pellMatching_4151_checked
  large := pellMagnitudes_4151_large

def pellMagnitudes_4159 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4159

def pellMasks_4159 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4159.map pellLightMasksToOriginal

def pellWitnesses_4159 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4159

theorem pellMasks_4159_valid : ∀ m ∈ pellMasks_4159, m.Valid 4159 := by
  exact pellLightMasks_valid 4159 PellMatchingLightProduction.pellMasks_4159 PellMatchingLightProduction.pellMasks_4159_valid

theorem pellMatching_4159_checked :
    pellMatchingCheck pellMasks_4159 pellMagnitudes_4159 pellWitnesses_4159 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4159
    PellMatchingLightProduction.pellMagnitudes_4159 PellMatchingLightProduction.pellWitnesses_4159).symm.trans
      PellMatchingLightProduction.pellMatching_4159_checked

theorem pellMagnitudes_4159_large : ∀ x ∈ pellMagnitudes_4159, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4159 PellMatchingLightProduction.pellMagnitudes_4159_large

def pellGraphCertificate_4159 : PellMatchingCertificate 4159 where
  magnitudes := pellMagnitudes_4159
  masks := pellMasks_4159
  witnesses := pellWitnesses_4159
  masks_valid := pellMasks_4159_valid
  checked := pellMatching_4159_checked
  large := pellMagnitudes_4159_large

def pellMagnitudes_4183 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4183

def pellMasks_4183 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4183.map pellLightMasksToOriginal

def pellWitnesses_4183 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4183

theorem pellMasks_4183_valid : ∀ m ∈ pellMasks_4183, m.Valid 4183 := by
  exact pellLightMasks_valid 4183 PellMatchingLightProduction.pellMasks_4183 PellMatchingLightProduction.pellMasks_4183_valid

theorem pellMatching_4183_checked :
    pellMatchingCheck pellMasks_4183 pellMagnitudes_4183 pellWitnesses_4183 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4183
    PellMatchingLightProduction.pellMagnitudes_4183 PellMatchingLightProduction.pellWitnesses_4183).symm.trans
      PellMatchingLightProduction.pellMatching_4183_checked

theorem pellMagnitudes_4183_large : ∀ x ∈ pellMagnitudes_4183, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4183 PellMatchingLightProduction.pellMagnitudes_4183_large

def pellGraphCertificate_4183 : PellMatchingCertificate 4183 where
  magnitudes := pellMagnitudes_4183
  masks := pellMasks_4183
  witnesses := pellWitnesses_4183
  masks_valid := pellMasks_4183_valid
  checked := pellMatching_4183_checked
  large := pellMagnitudes_4183_large

def pellMagnitudes_4207 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4207

def pellMasks_4207 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4207.map pellLightMasksToOriginal

def pellWitnesses_4207 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4207

theorem pellMasks_4207_valid : ∀ m ∈ pellMasks_4207, m.Valid 4207 := by
  exact pellLightMasks_valid 4207 PellMatchingLightProduction.pellMasks_4207 PellMatchingLightProduction.pellMasks_4207_valid

theorem pellMatching_4207_checked :
    pellMatchingCheck pellMasks_4207 pellMagnitudes_4207 pellWitnesses_4207 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4207
    PellMatchingLightProduction.pellMagnitudes_4207 PellMatchingLightProduction.pellWitnesses_4207).symm.trans
      PellMatchingLightProduction.pellMatching_4207_checked

theorem pellMagnitudes_4207_large : ∀ x ∈ pellMagnitudes_4207, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4207 PellMatchingLightProduction.pellMagnitudes_4207_large

def pellGraphCertificate_4207 : PellMatchingCertificate 4207 where
  magnitudes := pellMagnitudes_4207
  masks := pellMasks_4207
  witnesses := pellWitnesses_4207
  masks_valid := pellMasks_4207_valid
  checked := pellMatching_4207_checked
  large := pellMagnitudes_4207_large

def pellMagnitudes_4223 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4223

def pellMasks_4223 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4223.map pellLightMasksToOriginal

def pellWitnesses_4223 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4223

theorem pellMasks_4223_valid : ∀ m ∈ pellMasks_4223, m.Valid 4223 := by
  exact pellLightMasks_valid 4223 PellMatchingLightProduction.pellMasks_4223 PellMatchingLightProduction.pellMasks_4223_valid

theorem pellMatching_4223_checked :
    pellMatchingCheck pellMasks_4223 pellMagnitudes_4223 pellWitnesses_4223 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4223
    PellMatchingLightProduction.pellMagnitudes_4223 PellMatchingLightProduction.pellWitnesses_4223).symm.trans
      PellMatchingLightProduction.pellMatching_4223_checked

theorem pellMagnitudes_4223_large : ∀ x ∈ pellMagnitudes_4223, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4223 PellMatchingLightProduction.pellMagnitudes_4223_large

def pellGraphCertificate_4223 : PellMatchingCertificate 4223 where
  magnitudes := pellMagnitudes_4223
  masks := pellMasks_4223
  witnesses := pellWitnesses_4223
  masks_valid := pellMasks_4223_valid
  checked := pellMatching_4223_checked
  large := pellMagnitudes_4223_large

def pellMagnitudes_4231 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4231

def pellMasks_4231 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4231.map pellLightMasksToOriginal

def pellWitnesses_4231 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4231

theorem pellMasks_4231_valid : ∀ m ∈ pellMasks_4231, m.Valid 4231 := by
  exact pellLightMasks_valid 4231 PellMatchingLightProduction.pellMasks_4231 PellMatchingLightProduction.pellMasks_4231_valid

theorem pellMatching_4231_checked :
    pellMatchingCheck pellMasks_4231 pellMagnitudes_4231 pellWitnesses_4231 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4231
    PellMatchingLightProduction.pellMagnitudes_4231 PellMatchingLightProduction.pellWitnesses_4231).symm.trans
      PellMatchingLightProduction.pellMatching_4231_checked

theorem pellMagnitudes_4231_large : ∀ x ∈ pellMagnitudes_4231, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4231 PellMatchingLightProduction.pellMagnitudes_4231_large

def pellGraphCertificate_4231 : PellMatchingCertificate 4231 where
  magnitudes := pellMagnitudes_4231
  masks := pellMasks_4231
  witnesses := pellWitnesses_4231
  masks_valid := pellMasks_4231_valid
  checked := pellMatching_4231_checked
  large := pellMagnitudes_4231_large

def pellMagnitudes_4247 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4247

def pellMasks_4247 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4247.map pellLightMasksToOriginal

def pellWitnesses_4247 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4247

theorem pellMasks_4247_valid : ∀ m ∈ pellMasks_4247, m.Valid 4247 := by
  exact pellLightMasks_valid 4247 PellMatchingLightProduction.pellMasks_4247 PellMatchingLightProduction.pellMasks_4247_valid

theorem pellMatching_4247_checked :
    pellMatchingCheck pellMasks_4247 pellMagnitudes_4247 pellWitnesses_4247 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4247
    PellMatchingLightProduction.pellMagnitudes_4247 PellMatchingLightProduction.pellWitnesses_4247).symm.trans
      PellMatchingLightProduction.pellMatching_4247_checked

theorem pellMagnitudes_4247_large : ∀ x ∈ pellMagnitudes_4247, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4247 PellMatchingLightProduction.pellMagnitudes_4247_large

def pellGraphCertificate_4247 : PellMatchingCertificate 4247 where
  magnitudes := pellMagnitudes_4247
  masks := pellMasks_4247
  witnesses := pellWitnesses_4247
  masks_valid := pellMasks_4247_valid
  checked := pellMatching_4247_checked
  large := pellMagnitudes_4247_large

def pellMagnitudes_4271 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4271

def pellMasks_4271 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4271.map pellLightMasksToOriginal

def pellWitnesses_4271 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4271

theorem pellMasks_4271_valid : ∀ m ∈ pellMasks_4271, m.Valid 4271 := by
  exact pellLightMasks_valid 4271 PellMatchingLightProduction.pellMasks_4271 PellMatchingLightProduction.pellMasks_4271_valid

theorem pellMatching_4271_checked :
    pellMatchingCheck pellMasks_4271 pellMagnitudes_4271 pellWitnesses_4271 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4271
    PellMatchingLightProduction.pellMagnitudes_4271 PellMatchingLightProduction.pellWitnesses_4271).symm.trans
      PellMatchingLightProduction.pellMatching_4271_checked

theorem pellMagnitudes_4271_large : ∀ x ∈ pellMagnitudes_4271, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4271 PellMatchingLightProduction.pellMagnitudes_4271_large

def pellGraphCertificate_4271 : PellMatchingCertificate 4271 where
  magnitudes := pellMagnitudes_4271
  masks := pellMasks_4271
  witnesses := pellWitnesses_4271
  masks_valid := pellMasks_4271_valid
  checked := pellMatching_4271_checked
  large := pellMagnitudes_4271_large

def pellMagnitudes_4319 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4319

def pellMasks_4319 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4319.map pellLightMasksToOriginal

def pellWitnesses_4319 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4319

theorem pellMasks_4319_valid : ∀ m ∈ pellMasks_4319, m.Valid 4319 := by
  exact pellLightMasks_valid 4319 PellMatchingLightProduction.pellMasks_4319 PellMatchingLightProduction.pellMasks_4319_valid

theorem pellMatching_4319_checked :
    pellMatchingCheck pellMasks_4319 pellMagnitudes_4319 pellWitnesses_4319 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4319
    PellMatchingLightProduction.pellMagnitudes_4319 PellMatchingLightProduction.pellWitnesses_4319).symm.trans
      PellMatchingLightProduction.pellMatching_4319_checked

theorem pellMagnitudes_4319_large : ∀ x ∈ pellMagnitudes_4319, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4319 PellMatchingLightProduction.pellMagnitudes_4319_large

def pellGraphCertificate_4319 : PellMatchingCertificate 4319 where
  magnitudes := pellMagnitudes_4319
  masks := pellMasks_4319
  witnesses := pellWitnesses_4319
  masks_valid := pellMasks_4319_valid
  checked := pellMatching_4319_checked
  large := pellMagnitudes_4319_large

def pellMagnitudes_4327 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4327

def pellMasks_4327 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4327.map pellLightMasksToOriginal

def pellWitnesses_4327 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4327

theorem pellMasks_4327_valid : ∀ m ∈ pellMasks_4327, m.Valid 4327 := by
  exact pellLightMasks_valid 4327 PellMatchingLightProduction.pellMasks_4327 PellMatchingLightProduction.pellMasks_4327_valid

theorem pellMatching_4327_checked :
    pellMatchingCheck pellMasks_4327 pellMagnitudes_4327 pellWitnesses_4327 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4327
    PellMatchingLightProduction.pellMagnitudes_4327 PellMatchingLightProduction.pellWitnesses_4327).symm.trans
      PellMatchingLightProduction.pellMatching_4327_checked

theorem pellMagnitudes_4327_large : ∀ x ∈ pellMagnitudes_4327, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4327 PellMatchingLightProduction.pellMagnitudes_4327_large

def pellGraphCertificate_4327 : PellMatchingCertificate 4327 where
  magnitudes := pellMagnitudes_4327
  masks := pellMasks_4327
  witnesses := pellWitnesses_4327
  masks_valid := pellMasks_4327_valid
  checked := pellMatching_4327_checked
  large := pellMagnitudes_4327_large

def pellMagnitudes_4391 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4391

def pellMasks_4391 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4391.map pellLightMasksToOriginal

def pellWitnesses_4391 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4391

theorem pellMasks_4391_valid : ∀ m ∈ pellMasks_4391, m.Valid 4391 := by
  exact pellLightMasks_valid 4391 PellMatchingLightProduction.pellMasks_4391 PellMatchingLightProduction.pellMasks_4391_valid

theorem pellMatching_4391_checked :
    pellMatchingCheck pellMasks_4391 pellMagnitudes_4391 pellWitnesses_4391 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4391
    PellMatchingLightProduction.pellMagnitudes_4391 PellMatchingLightProduction.pellWitnesses_4391).symm.trans
      PellMatchingLightProduction.pellMatching_4391_checked

theorem pellMagnitudes_4391_large : ∀ x ∈ pellMagnitudes_4391, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4391 PellMatchingLightProduction.pellMagnitudes_4391_large

def pellGraphCertificate_4391 : PellMatchingCertificate 4391 where
  magnitudes := pellMagnitudes_4391
  masks := pellMasks_4391
  witnesses := pellWitnesses_4391
  masks_valid := pellMasks_4391_valid
  checked := pellMatching_4391_checked
  large := pellMagnitudes_4391_large

def pellMagnitudes_4423 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4423

def pellMasks_4423 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4423.map pellLightMasksToOriginal

def pellWitnesses_4423 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4423

theorem pellMasks_4423_valid : ∀ m ∈ pellMasks_4423, m.Valid 4423 := by
  exact pellLightMasks_valid 4423 PellMatchingLightProduction.pellMasks_4423 PellMatchingLightProduction.pellMasks_4423_valid

theorem pellMatching_4423_checked :
    pellMatchingCheck pellMasks_4423 pellMagnitudes_4423 pellWitnesses_4423 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4423
    PellMatchingLightProduction.pellMagnitudes_4423 PellMatchingLightProduction.pellWitnesses_4423).symm.trans
      PellMatchingLightProduction.pellMatching_4423_checked

theorem pellMagnitudes_4423_large : ∀ x ∈ pellMagnitudes_4423, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4423 PellMatchingLightProduction.pellMagnitudes_4423_large

def pellGraphCertificate_4423 : PellMatchingCertificate 4423 where
  magnitudes := pellMagnitudes_4423
  masks := pellMasks_4423
  witnesses := pellWitnesses_4423
  masks_valid := pellMasks_4423_valid
  checked := pellMatching_4423_checked
  large := pellMagnitudes_4423_large

def pellMagnitudes_4447 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4447

def pellMasks_4447 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4447.map pellLightMasksToOriginal

def pellWitnesses_4447 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4447

theorem pellMasks_4447_valid : ∀ m ∈ pellMasks_4447, m.Valid 4447 := by
  exact pellLightMasks_valid 4447 PellMatchingLightProduction.pellMasks_4447 PellMatchingLightProduction.pellMasks_4447_valid

theorem pellMatching_4447_checked :
    pellMatchingCheck pellMasks_4447 pellMagnitudes_4447 pellWitnesses_4447 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4447
    PellMatchingLightProduction.pellMagnitudes_4447 PellMatchingLightProduction.pellWitnesses_4447).symm.trans
      PellMatchingLightProduction.pellMatching_4447_checked

theorem pellMagnitudes_4447_large : ∀ x ∈ pellMagnitudes_4447, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4447 PellMatchingLightProduction.pellMagnitudes_4447_large

def pellGraphCertificate_4447 : PellMatchingCertificate 4447 where
  magnitudes := pellMagnitudes_4447
  masks := pellMasks_4447
  witnesses := pellWitnesses_4447
  masks_valid := pellMasks_4447_valid
  checked := pellMatching_4447_checked
  large := pellMagnitudes_4447_large

def pellMagnitudes_4463 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4463

def pellMasks_4463 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4463.map pellLightMasksToOriginal

def pellWitnesses_4463 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4463

theorem pellMasks_4463_valid : ∀ m ∈ pellMasks_4463, m.Valid 4463 := by
  exact pellLightMasks_valid 4463 PellMatchingLightProduction.pellMasks_4463 PellMatchingLightProduction.pellMasks_4463_valid

theorem pellMatching_4463_checked :
    pellMatchingCheck pellMasks_4463 pellMagnitudes_4463 pellWitnesses_4463 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4463
    PellMatchingLightProduction.pellMagnitudes_4463 PellMatchingLightProduction.pellWitnesses_4463).symm.trans
      PellMatchingLightProduction.pellMatching_4463_checked

theorem pellMagnitudes_4463_large : ∀ x ∈ pellMagnitudes_4463, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4463 PellMatchingLightProduction.pellMagnitudes_4463_large

def pellGraphCertificate_4463 : PellMatchingCertificate 4463 where
  magnitudes := pellMagnitudes_4463
  masks := pellMasks_4463
  witnesses := pellWitnesses_4463
  masks_valid := pellMasks_4463_valid
  checked := pellMatching_4463_checked
  large := pellMagnitudes_4463_large

def pellMagnitudes_4487 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4487

def pellMasks_4487 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4487.map pellLightMasksToOriginal

def pellWitnesses_4487 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4487

theorem pellMasks_4487_valid : ∀ m ∈ pellMasks_4487, m.Valid 4487 := by
  exact pellLightMasks_valid 4487 PellMatchingLightProduction.pellMasks_4487 PellMatchingLightProduction.pellMasks_4487_valid

theorem pellMatching_4487_checked :
    pellMatchingCheck pellMasks_4487 pellMagnitudes_4487 pellWitnesses_4487 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4487
    PellMatchingLightProduction.pellMagnitudes_4487 PellMatchingLightProduction.pellWitnesses_4487).symm.trans
      PellMatchingLightProduction.pellMatching_4487_checked

theorem pellMagnitudes_4487_large : ∀ x ∈ pellMagnitudes_4487, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4487 PellMatchingLightProduction.pellMagnitudes_4487_large

def pellGraphCertificate_4487 : PellMatchingCertificate 4487 where
  magnitudes := pellMagnitudes_4487
  masks := pellMasks_4487
  witnesses := pellWitnesses_4487
  masks_valid := pellMasks_4487_valid
  checked := pellMatching_4487_checked
  large := pellMagnitudes_4487_large

def pellMagnitudes_4567 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4567

def pellMasks_4567 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4567.map pellLightMasksToOriginal

def pellWitnesses_4567 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4567

theorem pellMasks_4567_valid : ∀ m ∈ pellMasks_4567, m.Valid 4567 := by
  exact pellLightMasks_valid 4567 PellMatchingLightProduction.pellMasks_4567 PellMatchingLightProduction.pellMasks_4567_valid

theorem pellMatching_4567_checked :
    pellMatchingCheck pellMasks_4567 pellMagnitudes_4567 pellWitnesses_4567 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4567
    PellMatchingLightProduction.pellMagnitudes_4567 PellMatchingLightProduction.pellWitnesses_4567).symm.trans
      PellMatchingLightProduction.pellMatching_4567_checked

theorem pellMagnitudes_4567_large : ∀ x ∈ pellMagnitudes_4567, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4567 PellMatchingLightProduction.pellMagnitudes_4567_large

def pellGraphCertificate_4567 : PellMatchingCertificate 4567 where
  magnitudes := pellMagnitudes_4567
  masks := pellMasks_4567
  witnesses := pellWitnesses_4567
  masks_valid := pellMasks_4567_valid
  checked := pellMatching_4567_checked
  large := pellMagnitudes_4567_large

def pellMagnitudes_4583 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4583

def pellMasks_4583 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4583.map pellLightMasksToOriginal

def pellWitnesses_4583 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4583

theorem pellMasks_4583_valid : ∀ m ∈ pellMasks_4583, m.Valid 4583 := by
  exact pellLightMasks_valid 4583 PellMatchingLightProduction.pellMasks_4583 PellMatchingLightProduction.pellMasks_4583_valid

theorem pellMatching_4583_checked :
    pellMatchingCheck pellMasks_4583 pellMagnitudes_4583 pellWitnesses_4583 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4583
    PellMatchingLightProduction.pellMagnitudes_4583 PellMatchingLightProduction.pellWitnesses_4583).symm.trans
      PellMatchingLightProduction.pellMatching_4583_checked

theorem pellMagnitudes_4583_large : ∀ x ∈ pellMagnitudes_4583, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4583 PellMatchingLightProduction.pellMagnitudes_4583_large

def pellGraphCertificate_4583 : PellMatchingCertificate 4583 where
  magnitudes := pellMagnitudes_4583
  masks := pellMasks_4583
  witnesses := pellWitnesses_4583
  masks_valid := pellMasks_4583_valid
  checked := pellMatching_4583_checked
  large := pellMagnitudes_4583_large

def pellMagnitudes_4591 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4591

def pellMasks_4591 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4591.map pellLightMasksToOriginal

def pellWitnesses_4591 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4591

theorem pellMasks_4591_valid : ∀ m ∈ pellMasks_4591, m.Valid 4591 := by
  exact pellLightMasks_valid 4591 PellMatchingLightProduction.pellMasks_4591 PellMatchingLightProduction.pellMasks_4591_valid

theorem pellMatching_4591_checked :
    pellMatchingCheck pellMasks_4591 pellMagnitudes_4591 pellWitnesses_4591 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4591
    PellMatchingLightProduction.pellMagnitudes_4591 PellMatchingLightProduction.pellWitnesses_4591).symm.trans
      PellMatchingLightProduction.pellMatching_4591_checked

theorem pellMagnitudes_4591_large : ∀ x ∈ pellMagnitudes_4591, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4591 PellMatchingLightProduction.pellMagnitudes_4591_large

def pellGraphCertificate_4591 : PellMatchingCertificate 4591 where
  magnitudes := pellMagnitudes_4591
  masks := pellMasks_4591
  witnesses := pellWitnesses_4591
  masks_valid := pellMasks_4591_valid
  checked := pellMatching_4591_checked
  large := pellMagnitudes_4591_large

def pellMagnitudes_4639 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4639

def pellMasks_4639 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4639.map pellLightMasksToOriginal

def pellWitnesses_4639 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4639

theorem pellMasks_4639_valid : ∀ m ∈ pellMasks_4639, m.Valid 4639 := by
  exact pellLightMasks_valid 4639 PellMatchingLightProduction.pellMasks_4639 PellMatchingLightProduction.pellMasks_4639_valid

theorem pellMatching_4639_checked :
    pellMatchingCheck pellMasks_4639 pellMagnitudes_4639 pellWitnesses_4639 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4639
    PellMatchingLightProduction.pellMagnitudes_4639 PellMatchingLightProduction.pellWitnesses_4639).symm.trans
      PellMatchingLightProduction.pellMatching_4639_checked

theorem pellMagnitudes_4639_large : ∀ x ∈ pellMagnitudes_4639, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4639 PellMatchingLightProduction.pellMagnitudes_4639_large

def pellGraphCertificate_4639 : PellMatchingCertificate 4639 where
  magnitudes := pellMagnitudes_4639
  masks := pellMasks_4639
  witnesses := pellWitnesses_4639
  masks_valid := pellMasks_4639_valid
  checked := pellMatching_4639_checked
  large := pellMagnitudes_4639_large

def pellMagnitudes_4663 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4663

def pellMasks_4663 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4663.map pellLightMasksToOriginal

def pellWitnesses_4663 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4663

theorem pellMasks_4663_valid : ∀ m ∈ pellMasks_4663, m.Valid 4663 := by
  exact pellLightMasks_valid 4663 PellMatchingLightProduction.pellMasks_4663 PellMatchingLightProduction.pellMasks_4663_valid

theorem pellMatching_4663_checked :
    pellMatchingCheck pellMasks_4663 pellMagnitudes_4663 pellWitnesses_4663 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4663
    PellMatchingLightProduction.pellMagnitudes_4663 PellMatchingLightProduction.pellWitnesses_4663).symm.trans
      PellMatchingLightProduction.pellMatching_4663_checked

theorem pellMagnitudes_4663_large : ∀ x ∈ pellMagnitudes_4663, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4663 PellMatchingLightProduction.pellMagnitudes_4663_large

def pellGraphCertificate_4663 : PellMatchingCertificate 4663 where
  magnitudes := pellMagnitudes_4663
  masks := pellMasks_4663
  witnesses := pellWitnesses_4663
  masks_valid := pellMasks_4663_valid
  checked := pellMatching_4663_checked
  large := pellMagnitudes_4663_large

def pellMagnitudes_4679 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4679

def pellMasks_4679 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4679.map pellLightMasksToOriginal

def pellWitnesses_4679 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4679

theorem pellMasks_4679_valid : ∀ m ∈ pellMasks_4679, m.Valid 4679 := by
  exact pellLightMasks_valid 4679 PellMatchingLightProduction.pellMasks_4679 PellMatchingLightProduction.pellMasks_4679_valid

theorem pellMatching_4679_checked :
    pellMatchingCheck pellMasks_4679 pellMagnitudes_4679 pellWitnesses_4679 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4679
    PellMatchingLightProduction.pellMagnitudes_4679 PellMatchingLightProduction.pellWitnesses_4679).symm.trans
      PellMatchingLightProduction.pellMatching_4679_checked

theorem pellMagnitudes_4679_large : ∀ x ∈ pellMagnitudes_4679, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4679 PellMatchingLightProduction.pellMagnitudes_4679_large

def pellGraphCertificate_4679 : PellMatchingCertificate 4679 where
  magnitudes := pellMagnitudes_4679
  masks := pellMasks_4679
  witnesses := pellWitnesses_4679
  masks_valid := pellMasks_4679_valid
  checked := pellMatching_4679_checked
  large := pellMagnitudes_4679_large

def pellMagnitudes_4703 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4703

def pellMasks_4703 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4703.map pellLightMasksToOriginal

def pellWitnesses_4703 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4703

theorem pellMasks_4703_valid : ∀ m ∈ pellMasks_4703, m.Valid 4703 := by
  exact pellLightMasks_valid 4703 PellMatchingLightProduction.pellMasks_4703 PellMatchingLightProduction.pellMasks_4703_valid

theorem pellMatching_4703_checked :
    pellMatchingCheck pellMasks_4703 pellMagnitudes_4703 pellWitnesses_4703 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4703
    PellMatchingLightProduction.pellMagnitudes_4703 PellMatchingLightProduction.pellWitnesses_4703).symm.trans
      PellMatchingLightProduction.pellMatching_4703_checked

theorem pellMagnitudes_4703_large : ∀ x ∈ pellMagnitudes_4703, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4703 PellMatchingLightProduction.pellMagnitudes_4703_large

def pellGraphCertificate_4703 : PellMatchingCertificate 4703 where
  magnitudes := pellMagnitudes_4703
  masks := pellMasks_4703
  witnesses := pellWitnesses_4703
  masks_valid := pellMasks_4703_valid
  checked := pellMatching_4703_checked
  large := pellMagnitudes_4703_large

def pellMagnitudes_4751 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4751

def pellMasks_4751 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4751.map pellLightMasksToOriginal

def pellWitnesses_4751 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4751

theorem pellMasks_4751_valid : ∀ m ∈ pellMasks_4751, m.Valid 4751 := by
  exact pellLightMasks_valid 4751 PellMatchingLightProduction.pellMasks_4751 PellMatchingLightProduction.pellMasks_4751_valid

theorem pellMatching_4751_checked :
    pellMatchingCheck pellMasks_4751 pellMagnitudes_4751 pellWitnesses_4751 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4751
    PellMatchingLightProduction.pellMagnitudes_4751 PellMatchingLightProduction.pellWitnesses_4751).symm.trans
      PellMatchingLightProduction.pellMatching_4751_checked

theorem pellMagnitudes_4751_large : ∀ x ∈ pellMagnitudes_4751, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4751 PellMatchingLightProduction.pellMagnitudes_4751_large

def pellGraphCertificate_4751 : PellMatchingCertificate 4751 where
  magnitudes := pellMagnitudes_4751
  masks := pellMasks_4751
  witnesses := pellWitnesses_4751
  masks_valid := pellMasks_4751_valid
  checked := pellMatching_4751_checked
  large := pellMagnitudes_4751_large

def pellMagnitudes_4759 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4759

def pellMasks_4759 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4759.map pellLightMasksToOriginal

def pellWitnesses_4759 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4759

theorem pellMasks_4759_valid : ∀ m ∈ pellMasks_4759, m.Valid 4759 := by
  exact pellLightMasks_valid 4759 PellMatchingLightProduction.pellMasks_4759 PellMatchingLightProduction.pellMasks_4759_valid

theorem pellMatching_4759_checked :
    pellMatchingCheck pellMasks_4759 pellMagnitudes_4759 pellWitnesses_4759 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4759
    PellMatchingLightProduction.pellMagnitudes_4759 PellMatchingLightProduction.pellWitnesses_4759).symm.trans
      PellMatchingLightProduction.pellMatching_4759_checked

theorem pellMagnitudes_4759_large : ∀ x ∈ pellMagnitudes_4759, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4759 PellMatchingLightProduction.pellMagnitudes_4759_large

def pellGraphCertificate_4759 : PellMatchingCertificate 4759 where
  magnitudes := pellMagnitudes_4759
  masks := pellMasks_4759
  witnesses := pellWitnesses_4759
  masks_valid := pellMasks_4759_valid
  checked := pellMatching_4759_checked
  large := pellMagnitudes_4759_large

def pellMagnitudes_4783 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4783

def pellMasks_4783 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4783.map pellLightMasksToOriginal

def pellWitnesses_4783 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4783

theorem pellMasks_4783_valid : ∀ m ∈ pellMasks_4783, m.Valid 4783 := by
  exact pellLightMasks_valid 4783 PellMatchingLightProduction.pellMasks_4783 PellMatchingLightProduction.pellMasks_4783_valid

theorem pellMatching_4783_checked :
    pellMatchingCheck pellMasks_4783 pellMagnitudes_4783 pellWitnesses_4783 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4783
    PellMatchingLightProduction.pellMagnitudes_4783 PellMatchingLightProduction.pellWitnesses_4783).symm.trans
      PellMatchingLightProduction.pellMatching_4783_checked

theorem pellMagnitudes_4783_large : ∀ x ∈ pellMagnitudes_4783, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4783 PellMatchingLightProduction.pellMagnitudes_4783_large

def pellGraphCertificate_4783 : PellMatchingCertificate 4783 where
  magnitudes := pellMagnitudes_4783
  masks := pellMasks_4783
  witnesses := pellWitnesses_4783
  masks_valid := pellMasks_4783_valid
  checked := pellMatching_4783_checked
  large := pellMagnitudes_4783_large

def pellMagnitudes_4799 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4799

def pellMasks_4799 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4799.map pellLightMasksToOriginal

def pellWitnesses_4799 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4799

theorem pellMasks_4799_valid : ∀ m ∈ pellMasks_4799, m.Valid 4799 := by
  exact pellLightMasks_valid 4799 PellMatchingLightProduction.pellMasks_4799 PellMatchingLightProduction.pellMasks_4799_valid

theorem pellMatching_4799_checked :
    pellMatchingCheck pellMasks_4799 pellMagnitudes_4799 pellWitnesses_4799 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4799
    PellMatchingLightProduction.pellMagnitudes_4799 PellMatchingLightProduction.pellWitnesses_4799).symm.trans
      PellMatchingLightProduction.pellMatching_4799_checked

theorem pellMagnitudes_4799_large : ∀ x ∈ pellMagnitudes_4799, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4799 PellMatchingLightProduction.pellMagnitudes_4799_large

def pellGraphCertificate_4799 : PellMatchingCertificate 4799 where
  magnitudes := pellMagnitudes_4799
  masks := pellMasks_4799
  witnesses := pellWitnesses_4799
  masks_valid := pellMasks_4799_valid
  checked := pellMatching_4799_checked
  large := pellMagnitudes_4799_large

def pellMagnitudes_4831 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4831

def pellMasks_4831 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4831.map pellLightMasksToOriginal

def pellWitnesses_4831 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4831

theorem pellMasks_4831_valid : ∀ m ∈ pellMasks_4831, m.Valid 4831 := by
  exact pellLightMasks_valid 4831 PellMatchingLightProduction.pellMasks_4831 PellMatchingLightProduction.pellMasks_4831_valid

theorem pellMatching_4831_checked :
    pellMatchingCheck pellMasks_4831 pellMagnitudes_4831 pellWitnesses_4831 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4831
    PellMatchingLightProduction.pellMagnitudes_4831 PellMatchingLightProduction.pellWitnesses_4831).symm.trans
      PellMatchingLightProduction.pellMatching_4831_checked

theorem pellMagnitudes_4831_large : ∀ x ∈ pellMagnitudes_4831, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4831 PellMatchingLightProduction.pellMagnitudes_4831_large

def pellGraphCertificate_4831 : PellMatchingCertificate 4831 where
  magnitudes := pellMagnitudes_4831
  masks := pellMasks_4831
  witnesses := pellWitnesses_4831
  masks_valid := pellMasks_4831_valid
  checked := pellMatching_4831_checked
  large := pellMagnitudes_4831_large

def pellMagnitudes_4871 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4871

def pellMasks_4871 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4871.map pellLightMasksToOriginal

def pellWitnesses_4871 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4871

theorem pellMasks_4871_valid : ∀ m ∈ pellMasks_4871, m.Valid 4871 := by
  exact pellLightMasks_valid 4871 PellMatchingLightProduction.pellMasks_4871 PellMatchingLightProduction.pellMasks_4871_valid

theorem pellMatching_4871_checked :
    pellMatchingCheck pellMasks_4871 pellMagnitudes_4871 pellWitnesses_4871 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4871
    PellMatchingLightProduction.pellMagnitudes_4871 PellMatchingLightProduction.pellWitnesses_4871).symm.trans
      PellMatchingLightProduction.pellMatching_4871_checked

theorem pellMagnitudes_4871_large : ∀ x ∈ pellMagnitudes_4871, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4871 PellMatchingLightProduction.pellMagnitudes_4871_large

def pellGraphCertificate_4871 : PellMatchingCertificate 4871 where
  magnitudes := pellMagnitudes_4871
  masks := pellMasks_4871
  witnesses := pellWitnesses_4871
  masks_valid := pellMasks_4871_valid
  checked := pellMatching_4871_checked
  large := pellMagnitudes_4871_large

def pellMagnitudes_4879 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4879

def pellMasks_4879 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4879.map pellLightMasksToOriginal

def pellWitnesses_4879 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4879

theorem pellMasks_4879_valid : ∀ m ∈ pellMasks_4879, m.Valid 4879 := by
  exact pellLightMasks_valid 4879 PellMatchingLightProduction.pellMasks_4879 PellMatchingLightProduction.pellMasks_4879_valid

theorem pellMatching_4879_checked :
    pellMatchingCheck pellMasks_4879 pellMagnitudes_4879 pellWitnesses_4879 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4879
    PellMatchingLightProduction.pellMagnitudes_4879 PellMatchingLightProduction.pellWitnesses_4879).symm.trans
      PellMatchingLightProduction.pellMatching_4879_checked

theorem pellMagnitudes_4879_large : ∀ x ∈ pellMagnitudes_4879, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4879 PellMatchingLightProduction.pellMagnitudes_4879_large

def pellGraphCertificate_4879 : PellMatchingCertificate 4879 where
  magnitudes := pellMagnitudes_4879
  masks := pellMasks_4879
  witnesses := pellWitnesses_4879
  masks_valid := pellMasks_4879_valid
  checked := pellMatching_4879_checked
  large := pellMagnitudes_4879_large

def pellMagnitudes_4903 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4903

def pellMasks_4903 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4903.map pellLightMasksToOriginal

def pellWitnesses_4903 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4903

theorem pellMasks_4903_valid : ∀ m ∈ pellMasks_4903, m.Valid 4903 := by
  exact pellLightMasks_valid 4903 PellMatchingLightProduction.pellMasks_4903 PellMatchingLightProduction.pellMasks_4903_valid

theorem pellMatching_4903_checked :
    pellMatchingCheck pellMasks_4903 pellMagnitudes_4903 pellWitnesses_4903 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4903
    PellMatchingLightProduction.pellMagnitudes_4903 PellMatchingLightProduction.pellWitnesses_4903).symm.trans
      PellMatchingLightProduction.pellMatching_4903_checked

theorem pellMagnitudes_4903_large : ∀ x ∈ pellMagnitudes_4903, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4903 PellMatchingLightProduction.pellMagnitudes_4903_large

def pellGraphCertificate_4903 : PellMatchingCertificate 4903 where
  magnitudes := pellMagnitudes_4903
  masks := pellMasks_4903
  witnesses := pellWitnesses_4903
  masks_valid := pellMasks_4903_valid
  checked := pellMatching_4903_checked
  large := pellMagnitudes_4903_large

def pellMagnitudes_4919 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4919

def pellMasks_4919 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4919.map pellLightMasksToOriginal

def pellWitnesses_4919 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4919

theorem pellMasks_4919_valid : ∀ m ∈ pellMasks_4919, m.Valid 4919 := by
  exact pellLightMasks_valid 4919 PellMatchingLightProduction.pellMasks_4919 PellMatchingLightProduction.pellMasks_4919_valid

theorem pellMatching_4919_checked :
    pellMatchingCheck pellMasks_4919 pellMagnitudes_4919 pellWitnesses_4919 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4919
    PellMatchingLightProduction.pellMagnitudes_4919 PellMatchingLightProduction.pellWitnesses_4919).symm.trans
      PellMatchingLightProduction.pellMatching_4919_checked

theorem pellMagnitudes_4919_large : ∀ x ∈ pellMagnitudes_4919, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4919 PellMatchingLightProduction.pellMagnitudes_4919_large

def pellGraphCertificate_4919 : PellMatchingCertificate 4919 where
  magnitudes := pellMagnitudes_4919
  masks := pellMasks_4919
  witnesses := pellWitnesses_4919
  masks_valid := pellMasks_4919_valid
  checked := pellMatching_4919_checked
  large := pellMagnitudes_4919_large

def pellMagnitudes_4943 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4943

def pellMasks_4943 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4943.map pellLightMasksToOriginal

def pellWitnesses_4943 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4943

theorem pellMasks_4943_valid : ∀ m ∈ pellMasks_4943, m.Valid 4943 := by
  exact pellLightMasks_valid 4943 PellMatchingLightProduction.pellMasks_4943 PellMatchingLightProduction.pellMasks_4943_valid

theorem pellMatching_4943_checked :
    pellMatchingCheck pellMasks_4943 pellMagnitudes_4943 pellWitnesses_4943 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4943
    PellMatchingLightProduction.pellMagnitudes_4943 PellMatchingLightProduction.pellWitnesses_4943).symm.trans
      PellMatchingLightProduction.pellMatching_4943_checked

theorem pellMagnitudes_4943_large : ∀ x ∈ pellMagnitudes_4943, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4943 PellMatchingLightProduction.pellMagnitudes_4943_large

def pellGraphCertificate_4943 : PellMatchingCertificate 4943 where
  magnitudes := pellMagnitudes_4943
  masks := pellMasks_4943
  witnesses := pellWitnesses_4943
  masks_valid := pellMasks_4943_valid
  checked := pellMatching_4943_checked
  large := pellMagnitudes_4943_large

def pellMagnitudes_4951 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4951

def pellMasks_4951 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4951.map pellLightMasksToOriginal

def pellWitnesses_4951 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4951

theorem pellMasks_4951_valid : ∀ m ∈ pellMasks_4951, m.Valid 4951 := by
  exact pellLightMasks_valid 4951 PellMatchingLightProduction.pellMasks_4951 PellMatchingLightProduction.pellMasks_4951_valid

theorem pellMatching_4951_checked :
    pellMatchingCheck pellMasks_4951 pellMagnitudes_4951 pellWitnesses_4951 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4951
    PellMatchingLightProduction.pellMagnitudes_4951 PellMatchingLightProduction.pellWitnesses_4951).symm.trans
      PellMatchingLightProduction.pellMatching_4951_checked

theorem pellMagnitudes_4951_large : ∀ x ∈ pellMagnitudes_4951, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4951 PellMatchingLightProduction.pellMagnitudes_4951_large

def pellGraphCertificate_4951 : PellMatchingCertificate 4951 where
  magnitudes := pellMagnitudes_4951
  masks := pellMasks_4951
  witnesses := pellWitnesses_4951
  masks_valid := pellMasks_4951_valid
  checked := pellMatching_4951_checked
  large := pellMagnitudes_4951_large

def pellMagnitudes_4967 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4967

def pellMasks_4967 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4967.map pellLightMasksToOriginal

def pellWitnesses_4967 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4967

theorem pellMasks_4967_valid : ∀ m ∈ pellMasks_4967, m.Valid 4967 := by
  exact pellLightMasks_valid 4967 PellMatchingLightProduction.pellMasks_4967 PellMatchingLightProduction.pellMasks_4967_valid

theorem pellMatching_4967_checked :
    pellMatchingCheck pellMasks_4967 pellMagnitudes_4967 pellWitnesses_4967 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4967
    PellMatchingLightProduction.pellMagnitudes_4967 PellMatchingLightProduction.pellWitnesses_4967).symm.trans
      PellMatchingLightProduction.pellMatching_4967_checked

theorem pellMagnitudes_4967_large : ∀ x ∈ pellMagnitudes_4967, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4967 PellMatchingLightProduction.pellMagnitudes_4967_large

def pellGraphCertificate_4967 : PellMatchingCertificate 4967 where
  magnitudes := pellMagnitudes_4967
  masks := pellMasks_4967
  witnesses := pellWitnesses_4967
  masks_valid := pellMasks_4967_valid
  checked := pellMatching_4967_checked
  large := pellMagnitudes_4967_large

def pellMagnitudes_4991 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4991

def pellMasks_4991 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4991.map pellLightMasksToOriginal

def pellWitnesses_4991 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4991

theorem pellMasks_4991_valid : ∀ m ∈ pellMasks_4991, m.Valid 4991 := by
  exact pellLightMasks_valid 4991 PellMatchingLightProduction.pellMasks_4991 PellMatchingLightProduction.pellMasks_4991_valid

theorem pellMatching_4991_checked :
    pellMatchingCheck pellMasks_4991 pellMagnitudes_4991 pellWitnesses_4991 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4991
    PellMatchingLightProduction.pellMagnitudes_4991 PellMatchingLightProduction.pellWitnesses_4991).symm.trans
      PellMatchingLightProduction.pellMatching_4991_checked

theorem pellMagnitudes_4991_large : ∀ x ∈ pellMagnitudes_4991, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4991 PellMatchingLightProduction.pellMagnitudes_4991_large

def pellGraphCertificate_4991 : PellMatchingCertificate 4991 where
  magnitudes := pellMagnitudes_4991
  masks := pellMasks_4991
  witnesses := pellWitnesses_4991
  masks_valid := pellMasks_4991_valid
  checked := pellMatching_4991_checked
  large := pellMagnitudes_4991_large

def pellMagnitudes_4999 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_4999

def pellMasks_4999 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_4999.map pellLightMasksToOriginal

def pellWitnesses_4999 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_4999

theorem pellMasks_4999_valid : ∀ m ∈ pellMasks_4999, m.Valid 4999 := by
  exact pellLightMasks_valid 4999 PellMatchingLightProduction.pellMasks_4999 PellMatchingLightProduction.pellMasks_4999_valid

theorem pellMatching_4999_checked :
    pellMatchingCheck pellMasks_4999 pellMagnitudes_4999 pellWitnesses_4999 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_4999
    PellMatchingLightProduction.pellMagnitudes_4999 PellMatchingLightProduction.pellWitnesses_4999).symm.trans
      PellMatchingLightProduction.pellMatching_4999_checked

theorem pellMagnitudes_4999_large : ∀ x ∈ pellMagnitudes_4999, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_4999 PellMatchingLightProduction.pellMagnitudes_4999_large

def pellGraphCertificate_4999 : PellMatchingCertificate 4999 where
  magnitudes := pellMagnitudes_4999
  masks := pellMasks_4999
  witnesses := pellWitnesses_4999
  masks_valid := pellMasks_4999_valid
  checked := pellMatching_4999_checked
  large := pellMagnitudes_4999_large

def pellMagnitudes_5023 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5023

def pellMasks_5023 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5023.map pellLightMasksToOriginal

def pellWitnesses_5023 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5023

theorem pellMasks_5023_valid : ∀ m ∈ pellMasks_5023, m.Valid 5023 := by
  exact pellLightMasks_valid 5023 PellMatchingLightProduction.pellMasks_5023 PellMatchingLightProduction.pellMasks_5023_valid

theorem pellMatching_5023_checked :
    pellMatchingCheck pellMasks_5023 pellMagnitudes_5023 pellWitnesses_5023 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5023
    PellMatchingLightProduction.pellMagnitudes_5023 PellMatchingLightProduction.pellWitnesses_5023).symm.trans
      PellMatchingLightProduction.pellMatching_5023_checked

theorem pellMagnitudes_5023_large : ∀ x ∈ pellMagnitudes_5023, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5023 PellMatchingLightProduction.pellMagnitudes_5023_large

def pellGraphCertificate_5023 : PellMatchingCertificate 5023 where
  magnitudes := pellMagnitudes_5023
  masks := pellMasks_5023
  witnesses := pellWitnesses_5023
  masks_valid := pellMasks_5023_valid
  checked := pellMatching_5023_checked
  large := pellMagnitudes_5023_large

def pellMagnitudes_5039 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5039

def pellMasks_5039 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5039.map pellLightMasksToOriginal

def pellWitnesses_5039 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5039

theorem pellMasks_5039_valid : ∀ m ∈ pellMasks_5039, m.Valid 5039 := by
  exact pellLightMasks_valid 5039 PellMatchingLightProduction.pellMasks_5039 PellMatchingLightProduction.pellMasks_5039_valid

theorem pellMatching_5039_checked :
    pellMatchingCheck pellMasks_5039 pellMagnitudes_5039 pellWitnesses_5039 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5039
    PellMatchingLightProduction.pellMagnitudes_5039 PellMatchingLightProduction.pellWitnesses_5039).symm.trans
      PellMatchingLightProduction.pellMatching_5039_checked

theorem pellMagnitudes_5039_large : ∀ x ∈ pellMagnitudes_5039, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5039 PellMatchingLightProduction.pellMagnitudes_5039_large

def pellGraphCertificate_5039 : PellMatchingCertificate 5039 where
  magnitudes := pellMagnitudes_5039
  masks := pellMasks_5039
  witnesses := pellWitnesses_5039
  masks_valid := pellMasks_5039_valid
  checked := pellMatching_5039_checked
  large := pellMagnitudes_5039_large

def pellMagnitudes_5087 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5087

def pellMasks_5087 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5087.map pellLightMasksToOriginal

def pellWitnesses_5087 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5087

theorem pellMasks_5087_valid : ∀ m ∈ pellMasks_5087, m.Valid 5087 := by
  exact pellLightMasks_valid 5087 PellMatchingLightProduction.pellMasks_5087 PellMatchingLightProduction.pellMasks_5087_valid

theorem pellMatching_5087_checked :
    pellMatchingCheck pellMasks_5087 pellMagnitudes_5087 pellWitnesses_5087 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5087
    PellMatchingLightProduction.pellMagnitudes_5087 PellMatchingLightProduction.pellWitnesses_5087).symm.trans
      PellMatchingLightProduction.pellMatching_5087_checked

theorem pellMagnitudes_5087_large : ∀ x ∈ pellMagnitudes_5087, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5087 PellMatchingLightProduction.pellMagnitudes_5087_large

def pellGraphCertificate_5087 : PellMatchingCertificate 5087 where
  magnitudes := pellMagnitudes_5087
  masks := pellMasks_5087
  witnesses := pellWitnesses_5087
  masks_valid := pellMasks_5087_valid
  checked := pellMatching_5087_checked
  large := pellMagnitudes_5087_large

def pellMagnitudes_5119 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5119

def pellMasks_5119 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5119.map pellLightMasksToOriginal

def pellWitnesses_5119 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5119

theorem pellMasks_5119_valid : ∀ m ∈ pellMasks_5119, m.Valid 5119 := by
  exact pellLightMasks_valid 5119 PellMatchingLightProduction.pellMasks_5119 PellMatchingLightProduction.pellMasks_5119_valid

theorem pellMatching_5119_checked :
    pellMatchingCheck pellMasks_5119 pellMagnitudes_5119 pellWitnesses_5119 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5119
    PellMatchingLightProduction.pellMagnitudes_5119 PellMatchingLightProduction.pellWitnesses_5119).symm.trans
      PellMatchingLightProduction.pellMatching_5119_checked

theorem pellMagnitudes_5119_large : ∀ x ∈ pellMagnitudes_5119, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5119 PellMatchingLightProduction.pellMagnitudes_5119_large

def pellGraphCertificate_5119 : PellMatchingCertificate 5119 where
  magnitudes := pellMagnitudes_5119
  masks := pellMasks_5119
  witnesses := pellWitnesses_5119
  masks_valid := pellMasks_5119_valid
  checked := pellMatching_5119_checked
  large := pellMagnitudes_5119_large

def pellMagnitudes_5167 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5167

def pellMasks_5167 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5167.map pellLightMasksToOriginal

def pellWitnesses_5167 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5167

theorem pellMasks_5167_valid : ∀ m ∈ pellMasks_5167, m.Valid 5167 := by
  exact pellLightMasks_valid 5167 PellMatchingLightProduction.pellMasks_5167 PellMatchingLightProduction.pellMasks_5167_valid

theorem pellMatching_5167_checked :
    pellMatchingCheck pellMasks_5167 pellMagnitudes_5167 pellWitnesses_5167 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5167
    PellMatchingLightProduction.pellMagnitudes_5167 PellMatchingLightProduction.pellWitnesses_5167).symm.trans
      PellMatchingLightProduction.pellMatching_5167_checked

theorem pellMagnitudes_5167_large : ∀ x ∈ pellMagnitudes_5167, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5167 PellMatchingLightProduction.pellMagnitudes_5167_large

def pellGraphCertificate_5167 : PellMatchingCertificate 5167 where
  magnitudes := pellMagnitudes_5167
  masks := pellMasks_5167
  witnesses := pellWitnesses_5167
  masks_valid := pellMasks_5167_valid
  checked := pellMatching_5167_checked
  large := pellMagnitudes_5167_large

def pellMagnitudes_5231 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5231

def pellMasks_5231 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5231.map pellLightMasksToOriginal

def pellWitnesses_5231 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5231

theorem pellMasks_5231_valid : ∀ m ∈ pellMasks_5231, m.Valid 5231 := by
  exact pellLightMasks_valid 5231 PellMatchingLightProduction.pellMasks_5231 PellMatchingLightProduction.pellMasks_5231_valid

theorem pellMatching_5231_checked :
    pellMatchingCheck pellMasks_5231 pellMagnitudes_5231 pellWitnesses_5231 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5231
    PellMatchingLightProduction.pellMagnitudes_5231 PellMatchingLightProduction.pellWitnesses_5231).symm.trans
      PellMatchingLightProduction.pellMatching_5231_checked

theorem pellMagnitudes_5231_large : ∀ x ∈ pellMagnitudes_5231, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5231 PellMatchingLightProduction.pellMagnitudes_5231_large

def pellGraphCertificate_5231 : PellMatchingCertificate 5231 where
  magnitudes := pellMagnitudes_5231
  masks := pellMasks_5231
  witnesses := pellWitnesses_5231
  masks_valid := pellMasks_5231_valid
  checked := pellMatching_5231_checked
  large := pellMagnitudes_5231_large

def pellMagnitudes_5279 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5279

def pellMasks_5279 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5279.map pellLightMasksToOriginal

def pellWitnesses_5279 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5279

theorem pellMasks_5279_valid : ∀ m ∈ pellMasks_5279, m.Valid 5279 := by
  exact pellLightMasks_valid 5279 PellMatchingLightProduction.pellMasks_5279 PellMatchingLightProduction.pellMasks_5279_valid

theorem pellMatching_5279_checked :
    pellMatchingCheck pellMasks_5279 pellMagnitudes_5279 pellWitnesses_5279 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5279
    PellMatchingLightProduction.pellMagnitudes_5279 PellMatchingLightProduction.pellWitnesses_5279).symm.trans
      PellMatchingLightProduction.pellMatching_5279_checked

theorem pellMagnitudes_5279_large : ∀ x ∈ pellMagnitudes_5279, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5279 PellMatchingLightProduction.pellMagnitudes_5279_large

def pellGraphCertificate_5279 : PellMatchingCertificate 5279 where
  magnitudes := pellMagnitudes_5279
  masks := pellMasks_5279
  witnesses := pellWitnesses_5279
  masks_valid := pellMasks_5279_valid
  checked := pellMatching_5279_checked
  large := pellMagnitudes_5279_large

def pellMagnitudes_5287 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5287

def pellMasks_5287 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5287.map pellLightMasksToOriginal

def pellWitnesses_5287 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5287

theorem pellMasks_5287_valid : ∀ m ∈ pellMasks_5287, m.Valid 5287 := by
  exact pellLightMasks_valid 5287 PellMatchingLightProduction.pellMasks_5287 PellMatchingLightProduction.pellMasks_5287_valid

theorem pellMatching_5287_checked :
    pellMatchingCheck pellMasks_5287 pellMagnitudes_5287 pellWitnesses_5287 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5287
    PellMatchingLightProduction.pellMagnitudes_5287 PellMatchingLightProduction.pellWitnesses_5287).symm.trans
      PellMatchingLightProduction.pellMatching_5287_checked

theorem pellMagnitudes_5287_large : ∀ x ∈ pellMagnitudes_5287, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5287 PellMatchingLightProduction.pellMagnitudes_5287_large

def pellGraphCertificate_5287 : PellMatchingCertificate 5287 where
  magnitudes := pellMagnitudes_5287
  masks := pellMasks_5287
  witnesses := pellWitnesses_5287
  masks_valid := pellMasks_5287_valid
  checked := pellMatching_5287_checked
  large := pellMagnitudes_5287_large

def pellMagnitudes_5303 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5303

def pellMasks_5303 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5303.map pellLightMasksToOriginal

def pellWitnesses_5303 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5303

theorem pellMasks_5303_valid : ∀ m ∈ pellMasks_5303, m.Valid 5303 := by
  exact pellLightMasks_valid 5303 PellMatchingLightProduction.pellMasks_5303 PellMatchingLightProduction.pellMasks_5303_valid

theorem pellMatching_5303_checked :
    pellMatchingCheck pellMasks_5303 pellMagnitudes_5303 pellWitnesses_5303 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5303
    PellMatchingLightProduction.pellMagnitudes_5303 PellMatchingLightProduction.pellWitnesses_5303).symm.trans
      PellMatchingLightProduction.pellMatching_5303_checked

theorem pellMagnitudes_5303_large : ∀ x ∈ pellMagnitudes_5303, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5303 PellMatchingLightProduction.pellMagnitudes_5303_large

def pellGraphCertificate_5303 : PellMatchingCertificate 5303 where
  magnitudes := pellMagnitudes_5303
  masks := pellMasks_5303
  witnesses := pellWitnesses_5303
  masks_valid := pellMasks_5303_valid
  checked := pellMatching_5303_checked
  large := pellMagnitudes_5303_large

def pellMagnitudes_5311 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5311

def pellMasks_5311 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5311.map pellLightMasksToOriginal

def pellWitnesses_5311 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5311

theorem pellMasks_5311_valid : ∀ m ∈ pellMasks_5311, m.Valid 5311 := by
  exact pellLightMasks_valid 5311 PellMatchingLightProduction.pellMasks_5311 PellMatchingLightProduction.pellMasks_5311_valid

theorem pellMatching_5311_checked :
    pellMatchingCheck pellMasks_5311 pellMagnitudes_5311 pellWitnesses_5311 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5311
    PellMatchingLightProduction.pellMagnitudes_5311 PellMatchingLightProduction.pellWitnesses_5311).symm.trans
      PellMatchingLightProduction.pellMatching_5311_checked

theorem pellMagnitudes_5311_large : ∀ x ∈ pellMagnitudes_5311, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5311 PellMatchingLightProduction.pellMagnitudes_5311_large

def pellGraphCertificate_5311 : PellMatchingCertificate 5311 where
  magnitudes := pellMagnitudes_5311
  masks := pellMasks_5311
  witnesses := pellWitnesses_5311
  masks_valid := pellMasks_5311_valid
  checked := pellMatching_5311_checked
  large := pellMagnitudes_5311_large

def pellMagnitudes_5327 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5327

def pellMasks_5327 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5327.map pellLightMasksToOriginal

def pellWitnesses_5327 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5327

theorem pellMasks_5327_valid : ∀ m ∈ pellMasks_5327, m.Valid 5327 := by
  exact pellLightMasks_valid 5327 PellMatchingLightProduction.pellMasks_5327 PellMatchingLightProduction.pellMasks_5327_valid

theorem pellMatching_5327_checked :
    pellMatchingCheck pellMasks_5327 pellMagnitudes_5327 pellWitnesses_5327 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5327
    PellMatchingLightProduction.pellMagnitudes_5327 PellMatchingLightProduction.pellWitnesses_5327).symm.trans
      PellMatchingLightProduction.pellMatching_5327_checked

theorem pellMagnitudes_5327_large : ∀ x ∈ pellMagnitudes_5327, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5327 PellMatchingLightProduction.pellMagnitudes_5327_large

def pellGraphCertificate_5327 : PellMatchingCertificate 5327 where
  magnitudes := pellMagnitudes_5327
  masks := pellMasks_5327
  witnesses := pellWitnesses_5327
  masks_valid := pellMasks_5327_valid
  checked := pellMatching_5327_checked
  large := pellMagnitudes_5327_large

def pellMagnitudes_5351 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5351

def pellMasks_5351 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5351.map pellLightMasksToOriginal

def pellWitnesses_5351 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5351

theorem pellMasks_5351_valid : ∀ m ∈ pellMasks_5351, m.Valid 5351 := by
  exact pellLightMasks_valid 5351 PellMatchingLightProduction.pellMasks_5351 PellMatchingLightProduction.pellMasks_5351_valid

theorem pellMatching_5351_checked :
    pellMatchingCheck pellMasks_5351 pellMagnitudes_5351 pellWitnesses_5351 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5351
    PellMatchingLightProduction.pellMagnitudes_5351 PellMatchingLightProduction.pellWitnesses_5351).symm.trans
      PellMatchingLightProduction.pellMatching_5351_checked

theorem pellMagnitudes_5351_large : ∀ x ∈ pellMagnitudes_5351, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5351 PellMatchingLightProduction.pellMagnitudes_5351_large

def pellGraphCertificate_5351 : PellMatchingCertificate 5351 where
  magnitudes := pellMagnitudes_5351
  masks := pellMasks_5351
  witnesses := pellWitnesses_5351
  masks_valid := pellMasks_5351_valid
  checked := pellMatching_5351_checked
  large := pellMagnitudes_5351_large

def pellMagnitudes_5383 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5383

def pellMasks_5383 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5383.map pellLightMasksToOriginal

def pellWitnesses_5383 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5383

theorem pellMasks_5383_valid : ∀ m ∈ pellMasks_5383, m.Valid 5383 := by
  exact pellLightMasks_valid 5383 PellMatchingLightProduction.pellMasks_5383 PellMatchingLightProduction.pellMasks_5383_valid

theorem pellMatching_5383_checked :
    pellMatchingCheck pellMasks_5383 pellMagnitudes_5383 pellWitnesses_5383 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5383
    PellMatchingLightProduction.pellMagnitudes_5383 PellMatchingLightProduction.pellWitnesses_5383).symm.trans
      PellMatchingLightProduction.pellMatching_5383_checked

theorem pellMagnitudes_5383_large : ∀ x ∈ pellMagnitudes_5383, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5383 PellMatchingLightProduction.pellMagnitudes_5383_large

def pellGraphCertificate_5383 : PellMatchingCertificate 5383 where
  magnitudes := pellMagnitudes_5383
  masks := pellMasks_5383
  witnesses := pellWitnesses_5383
  masks_valid := pellMasks_5383_valid
  checked := pellMatching_5383_checked
  large := pellMagnitudes_5383_large

def pellMagnitudes_5399 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5399

def pellMasks_5399 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5399.map pellLightMasksToOriginal

def pellWitnesses_5399 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5399

theorem pellMasks_5399_valid : ∀ m ∈ pellMasks_5399, m.Valid 5399 := by
  exact pellLightMasks_valid 5399 PellMatchingLightProduction.pellMasks_5399 PellMatchingLightProduction.pellMasks_5399_valid

theorem pellMatching_5399_checked :
    pellMatchingCheck pellMasks_5399 pellMagnitudes_5399 pellWitnesses_5399 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5399
    PellMatchingLightProduction.pellMagnitudes_5399 PellMatchingLightProduction.pellWitnesses_5399).symm.trans
      PellMatchingLightProduction.pellMatching_5399_checked

theorem pellMagnitudes_5399_large : ∀ x ∈ pellMagnitudes_5399, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5399 PellMatchingLightProduction.pellMagnitudes_5399_large

def pellGraphCertificate_5399 : PellMatchingCertificate 5399 where
  magnitudes := pellMagnitudes_5399
  masks := pellMasks_5399
  witnesses := pellWitnesses_5399
  masks_valid := pellMasks_5399_valid
  checked := pellMatching_5399_checked
  large := pellMagnitudes_5399_large

def pellMagnitudes_5407 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5407

def pellMasks_5407 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5407.map pellLightMasksToOriginal

def pellWitnesses_5407 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5407

theorem pellMasks_5407_valid : ∀ m ∈ pellMasks_5407, m.Valid 5407 := by
  exact pellLightMasks_valid 5407 PellMatchingLightProduction.pellMasks_5407 PellMatchingLightProduction.pellMasks_5407_valid

theorem pellMatching_5407_checked :
    pellMatchingCheck pellMasks_5407 pellMagnitudes_5407 pellWitnesses_5407 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5407
    PellMatchingLightProduction.pellMagnitudes_5407 PellMatchingLightProduction.pellWitnesses_5407).symm.trans
      PellMatchingLightProduction.pellMatching_5407_checked

theorem pellMagnitudes_5407_large : ∀ x ∈ pellMagnitudes_5407, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5407 PellMatchingLightProduction.pellMagnitudes_5407_large

def pellGraphCertificate_5407 : PellMatchingCertificate 5407 where
  magnitudes := pellMagnitudes_5407
  masks := pellMasks_5407
  witnesses := pellWitnesses_5407
  masks_valid := pellMasks_5407_valid
  checked := pellMatching_5407_checked
  large := pellMagnitudes_5407_large

def pellMagnitudes_5431 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5431

def pellMasks_5431 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5431.map pellLightMasksToOriginal

def pellWitnesses_5431 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5431

theorem pellMasks_5431_valid : ∀ m ∈ pellMasks_5431, m.Valid 5431 := by
  exact pellLightMasks_valid 5431 PellMatchingLightProduction.pellMasks_5431 PellMatchingLightProduction.pellMasks_5431_valid

theorem pellMatching_5431_checked :
    pellMatchingCheck pellMasks_5431 pellMagnitudes_5431 pellWitnesses_5431 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5431
    PellMatchingLightProduction.pellMagnitudes_5431 PellMatchingLightProduction.pellWitnesses_5431).symm.trans
      PellMatchingLightProduction.pellMatching_5431_checked

theorem pellMagnitudes_5431_large : ∀ x ∈ pellMagnitudes_5431, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5431 PellMatchingLightProduction.pellMagnitudes_5431_large

def pellGraphCertificate_5431 : PellMatchingCertificate 5431 where
  magnitudes := pellMagnitudes_5431
  masks := pellMasks_5431
  witnesses := pellWitnesses_5431
  masks_valid := pellMasks_5431_valid
  checked := pellMatching_5431_checked
  large := pellMagnitudes_5431_large

def pellMagnitudes_5471 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5471

def pellMasks_5471 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5471.map pellLightMasksToOriginal

def pellWitnesses_5471 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5471

theorem pellMasks_5471_valid : ∀ m ∈ pellMasks_5471, m.Valid 5471 := by
  exact pellLightMasks_valid 5471 PellMatchingLightProduction.pellMasks_5471 PellMatchingLightProduction.pellMasks_5471_valid

theorem pellMatching_5471_checked :
    pellMatchingCheck pellMasks_5471 pellMagnitudes_5471 pellWitnesses_5471 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5471
    PellMatchingLightProduction.pellMagnitudes_5471 PellMatchingLightProduction.pellWitnesses_5471).symm.trans
      PellMatchingLightProduction.pellMatching_5471_checked

theorem pellMagnitudes_5471_large : ∀ x ∈ pellMagnitudes_5471, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5471 PellMatchingLightProduction.pellMagnitudes_5471_large

def pellGraphCertificate_5471 : PellMatchingCertificate 5471 where
  magnitudes := pellMagnitudes_5471
  masks := pellMasks_5471
  witnesses := pellWitnesses_5471
  masks_valid := pellMasks_5471_valid
  checked := pellMatching_5471_checked
  large := pellMagnitudes_5471_large

def pellMagnitudes_5479 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5479

def pellMasks_5479 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5479.map pellLightMasksToOriginal

def pellWitnesses_5479 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5479

theorem pellMasks_5479_valid : ∀ m ∈ pellMasks_5479, m.Valid 5479 := by
  exact pellLightMasks_valid 5479 PellMatchingLightProduction.pellMasks_5479 PellMatchingLightProduction.pellMasks_5479_valid

theorem pellMatching_5479_checked :
    pellMatchingCheck pellMasks_5479 pellMagnitudes_5479 pellWitnesses_5479 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5479
    PellMatchingLightProduction.pellMagnitudes_5479 PellMatchingLightProduction.pellWitnesses_5479).symm.trans
      PellMatchingLightProduction.pellMatching_5479_checked

theorem pellMagnitudes_5479_large : ∀ x ∈ pellMagnitudes_5479, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5479 PellMatchingLightProduction.pellMagnitudes_5479_large

def pellGraphCertificate_5479 : PellMatchingCertificate 5479 where
  magnitudes := pellMagnitudes_5479
  masks := pellMasks_5479
  witnesses := pellWitnesses_5479
  masks_valid := pellMasks_5479_valid
  checked := pellMatching_5479_checked
  large := pellMagnitudes_5479_large

def pellMagnitudes_5503 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5503

def pellMasks_5503 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5503.map pellLightMasksToOriginal

def pellWitnesses_5503 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5503

theorem pellMasks_5503_valid : ∀ m ∈ pellMasks_5503, m.Valid 5503 := by
  exact pellLightMasks_valid 5503 PellMatchingLightProduction.pellMasks_5503 PellMatchingLightProduction.pellMasks_5503_valid

theorem pellMatching_5503_checked :
    pellMatchingCheck pellMasks_5503 pellMagnitudes_5503 pellWitnesses_5503 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5503
    PellMatchingLightProduction.pellMagnitudes_5503 PellMatchingLightProduction.pellWitnesses_5503).symm.trans
      PellMatchingLightProduction.pellMatching_5503_checked

theorem pellMagnitudes_5503_large : ∀ x ∈ pellMagnitudes_5503, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5503 PellMatchingLightProduction.pellMagnitudes_5503_large

def pellGraphCertificate_5503 : PellMatchingCertificate 5503 where
  magnitudes := pellMagnitudes_5503
  masks := pellMasks_5503
  witnesses := pellWitnesses_5503
  masks_valid := pellMasks_5503_valid
  checked := pellMatching_5503_checked
  large := pellMagnitudes_5503_large

def pellMagnitudes_5519 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5519

def pellMasks_5519 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5519.map pellLightMasksToOriginal

def pellWitnesses_5519 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5519

theorem pellMasks_5519_valid : ∀ m ∈ pellMasks_5519, m.Valid 5519 := by
  exact pellLightMasks_valid 5519 PellMatchingLightProduction.pellMasks_5519 PellMatchingLightProduction.pellMasks_5519_valid

theorem pellMatching_5519_checked :
    pellMatchingCheck pellMasks_5519 pellMagnitudes_5519 pellWitnesses_5519 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5519
    PellMatchingLightProduction.pellMagnitudes_5519 PellMatchingLightProduction.pellWitnesses_5519).symm.trans
      PellMatchingLightProduction.pellMatching_5519_checked

theorem pellMagnitudes_5519_large : ∀ x ∈ pellMagnitudes_5519, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5519 PellMatchingLightProduction.pellMagnitudes_5519_large

def pellGraphCertificate_5519 : PellMatchingCertificate 5519 where
  magnitudes := pellMagnitudes_5519
  masks := pellMasks_5519
  witnesses := pellWitnesses_5519
  masks_valid := pellMasks_5519_valid
  checked := pellMatching_5519_checked
  large := pellMagnitudes_5519_large

def pellMagnitudes_5527 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5527

def pellMasks_5527 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5527.map pellLightMasksToOriginal

def pellWitnesses_5527 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5527

theorem pellMasks_5527_valid : ∀ m ∈ pellMasks_5527, m.Valid 5527 := by
  exact pellLightMasks_valid 5527 PellMatchingLightProduction.pellMasks_5527 PellMatchingLightProduction.pellMasks_5527_valid

theorem pellMatching_5527_checked :
    pellMatchingCheck pellMasks_5527 pellMagnitudes_5527 pellWitnesses_5527 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5527
    PellMatchingLightProduction.pellMagnitudes_5527 PellMatchingLightProduction.pellWitnesses_5527).symm.trans
      PellMatchingLightProduction.pellMatching_5527_checked

theorem pellMagnitudes_5527_large : ∀ x ∈ pellMagnitudes_5527, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5527 PellMatchingLightProduction.pellMagnitudes_5527_large

def pellGraphCertificate_5527 : PellMatchingCertificate 5527 where
  magnitudes := pellMagnitudes_5527
  masks := pellMasks_5527
  witnesses := pellWitnesses_5527
  masks_valid := pellMasks_5527_valid
  checked := pellMatching_5527_checked
  large := pellMagnitudes_5527_large

def pellMagnitudes_5543 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5543

def pellMasks_5543 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5543.map pellLightMasksToOriginal

def pellWitnesses_5543 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5543

theorem pellMasks_5543_valid : ∀ m ∈ pellMasks_5543, m.Valid 5543 := by
  exact pellLightMasks_valid 5543 PellMatchingLightProduction.pellMasks_5543 PellMatchingLightProduction.pellMasks_5543_valid

theorem pellMatching_5543_checked :
    pellMatchingCheck pellMasks_5543 pellMagnitudes_5543 pellWitnesses_5543 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5543
    PellMatchingLightProduction.pellMagnitudes_5543 PellMatchingLightProduction.pellWitnesses_5543).symm.trans
      PellMatchingLightProduction.pellMatching_5543_checked

theorem pellMagnitudes_5543_large : ∀ x ∈ pellMagnitudes_5543, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5543 PellMatchingLightProduction.pellMagnitudes_5543_large

def pellGraphCertificate_5543 : PellMatchingCertificate 5543 where
  magnitudes := pellMagnitudes_5543
  masks := pellMasks_5543
  witnesses := pellWitnesses_5543
  masks_valid := pellMasks_5543_valid
  checked := pellMatching_5543_checked
  large := pellMagnitudes_5543_large

def pellMagnitudes_5591 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5591

def pellMasks_5591 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5591.map pellLightMasksToOriginal

def pellWitnesses_5591 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5591

theorem pellMasks_5591_valid : ∀ m ∈ pellMasks_5591, m.Valid 5591 := by
  exact pellLightMasks_valid 5591 PellMatchingLightProduction.pellMasks_5591 PellMatchingLightProduction.pellMasks_5591_valid

theorem pellMatching_5591_checked :
    pellMatchingCheck pellMasks_5591 pellMagnitudes_5591 pellWitnesses_5591 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5591
    PellMatchingLightProduction.pellMagnitudes_5591 PellMatchingLightProduction.pellWitnesses_5591).symm.trans
      PellMatchingLightProduction.pellMatching_5591_checked

theorem pellMagnitudes_5591_large : ∀ x ∈ pellMagnitudes_5591, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5591 PellMatchingLightProduction.pellMagnitudes_5591_large

def pellGraphCertificate_5591 : PellMatchingCertificate 5591 where
  magnitudes := pellMagnitudes_5591
  masks := pellMasks_5591
  witnesses := pellWitnesses_5591
  masks_valid := pellMasks_5591_valid
  checked := pellMatching_5591_checked
  large := pellMagnitudes_5591_large

def pellMagnitudes_5623 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5623

def pellMasks_5623 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5623.map pellLightMasksToOriginal

def pellWitnesses_5623 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5623

theorem pellMasks_5623_valid : ∀ m ∈ pellMasks_5623, m.Valid 5623 := by
  exact pellLightMasks_valid 5623 PellMatchingLightProduction.pellMasks_5623 PellMatchingLightProduction.pellMasks_5623_valid

theorem pellMatching_5623_checked :
    pellMatchingCheck pellMasks_5623 pellMagnitudes_5623 pellWitnesses_5623 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5623
    PellMatchingLightProduction.pellMagnitudes_5623 PellMatchingLightProduction.pellWitnesses_5623).symm.trans
      PellMatchingLightProduction.pellMatching_5623_checked

theorem pellMagnitudes_5623_large : ∀ x ∈ pellMagnitudes_5623, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5623 PellMatchingLightProduction.pellMagnitudes_5623_large

def pellGraphCertificate_5623 : PellMatchingCertificate 5623 where
  magnitudes := pellMagnitudes_5623
  masks := pellMasks_5623
  witnesses := pellWitnesses_5623
  masks_valid := pellMasks_5623_valid
  checked := pellMatching_5623_checked
  large := pellMagnitudes_5623_large

def pellMagnitudes_5639 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5639

def pellMasks_5639 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5639.map pellLightMasksToOriginal

def pellWitnesses_5639 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5639

theorem pellMasks_5639_valid : ∀ m ∈ pellMasks_5639, m.Valid 5639 := by
  exact pellLightMasks_valid 5639 PellMatchingLightProduction.pellMasks_5639 PellMatchingLightProduction.pellMasks_5639_valid

theorem pellMatching_5639_checked :
    pellMatchingCheck pellMasks_5639 pellMagnitudes_5639 pellWitnesses_5639 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5639
    PellMatchingLightProduction.pellMagnitudes_5639 PellMatchingLightProduction.pellWitnesses_5639).symm.trans
      PellMatchingLightProduction.pellMatching_5639_checked

theorem pellMagnitudes_5639_large : ∀ x ∈ pellMagnitudes_5639, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5639 PellMatchingLightProduction.pellMagnitudes_5639_large

def pellGraphCertificate_5639 : PellMatchingCertificate 5639 where
  magnitudes := pellMagnitudes_5639
  masks := pellMasks_5639
  witnesses := pellWitnesses_5639
  masks_valid := pellMasks_5639_valid
  checked := pellMatching_5639_checked
  large := pellMagnitudes_5639_large

def pellMagnitudes_5647 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5647

def pellMasks_5647 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5647.map pellLightMasksToOriginal

def pellWitnesses_5647 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5647

theorem pellMasks_5647_valid : ∀ m ∈ pellMasks_5647, m.Valid 5647 := by
  exact pellLightMasks_valid 5647 PellMatchingLightProduction.pellMasks_5647 PellMatchingLightProduction.pellMasks_5647_valid

theorem pellMatching_5647_checked :
    pellMatchingCheck pellMasks_5647 pellMagnitudes_5647 pellWitnesses_5647 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5647
    PellMatchingLightProduction.pellMagnitudes_5647 PellMatchingLightProduction.pellWitnesses_5647).symm.trans
      PellMatchingLightProduction.pellMatching_5647_checked

theorem pellMagnitudes_5647_large : ∀ x ∈ pellMagnitudes_5647, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5647 PellMatchingLightProduction.pellMagnitudes_5647_large

def pellGraphCertificate_5647 : PellMatchingCertificate 5647 where
  magnitudes := pellMagnitudes_5647
  masks := pellMasks_5647
  witnesses := pellWitnesses_5647
  masks_valid := pellMasks_5647_valid
  checked := pellMatching_5647_checked
  large := pellMagnitudes_5647_large

def pellMagnitudes_5711 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5711

def pellMasks_5711 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5711.map pellLightMasksToOriginal

def pellWitnesses_5711 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5711

theorem pellMasks_5711_valid : ∀ m ∈ pellMasks_5711, m.Valid 5711 := by
  exact pellLightMasks_valid 5711 PellMatchingLightProduction.pellMasks_5711 PellMatchingLightProduction.pellMasks_5711_valid

theorem pellMatching_5711_checked :
    pellMatchingCheck pellMasks_5711 pellMagnitudes_5711 pellWitnesses_5711 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5711
    PellMatchingLightProduction.pellMagnitudes_5711 PellMatchingLightProduction.pellWitnesses_5711).symm.trans
      PellMatchingLightProduction.pellMatching_5711_checked

theorem pellMagnitudes_5711_large : ∀ x ∈ pellMagnitudes_5711, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5711 PellMatchingLightProduction.pellMagnitudes_5711_large

def pellGraphCertificate_5711 : PellMatchingCertificate 5711 where
  magnitudes := pellMagnitudes_5711
  masks := pellMasks_5711
  witnesses := pellWitnesses_5711
  masks_valid := pellMasks_5711_valid
  checked := pellMatching_5711_checked
  large := pellMagnitudes_5711_large

def pellMagnitudes_5743 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5743

def pellMasks_5743 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5743.map pellLightMasksToOriginal

def pellWitnesses_5743 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5743

theorem pellMasks_5743_valid : ∀ m ∈ pellMasks_5743, m.Valid 5743 := by
  exact pellLightMasks_valid 5743 PellMatchingLightProduction.pellMasks_5743 PellMatchingLightProduction.pellMasks_5743_valid

theorem pellMatching_5743_checked :
    pellMatchingCheck pellMasks_5743 pellMagnitudes_5743 pellWitnesses_5743 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5743
    PellMatchingLightProduction.pellMagnitudes_5743 PellMatchingLightProduction.pellWitnesses_5743).symm.trans
      PellMatchingLightProduction.pellMatching_5743_checked

theorem pellMagnitudes_5743_large : ∀ x ∈ pellMagnitudes_5743, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5743 PellMatchingLightProduction.pellMagnitudes_5743_large

def pellGraphCertificate_5743 : PellMatchingCertificate 5743 where
  magnitudes := pellMagnitudes_5743
  masks := pellMasks_5743
  witnesses := pellWitnesses_5743
  masks_valid := pellMasks_5743_valid
  checked := pellMatching_5743_checked
  large := pellMagnitudes_5743_large

def pellMagnitudes_5767 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5767

def pellMasks_5767 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5767.map pellLightMasksToOriginal

def pellWitnesses_5767 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5767

theorem pellMasks_5767_valid : ∀ m ∈ pellMasks_5767, m.Valid 5767 := by
  exact pellLightMasks_valid 5767 PellMatchingLightProduction.pellMasks_5767 PellMatchingLightProduction.pellMasks_5767_valid

theorem pellMatching_5767_checked :
    pellMatchingCheck pellMasks_5767 pellMagnitudes_5767 pellWitnesses_5767 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5767
    PellMatchingLightProduction.pellMagnitudes_5767 PellMatchingLightProduction.pellWitnesses_5767).symm.trans
      PellMatchingLightProduction.pellMatching_5767_checked

theorem pellMagnitudes_5767_large : ∀ x ∈ pellMagnitudes_5767, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5767 PellMatchingLightProduction.pellMagnitudes_5767_large

def pellGraphCertificate_5767 : PellMatchingCertificate 5767 where
  magnitudes := pellMagnitudes_5767
  masks := pellMasks_5767
  witnesses := pellWitnesses_5767
  masks_valid := pellMasks_5767_valid
  checked := pellMatching_5767_checked
  large := pellMagnitudes_5767_large

def pellMagnitudes_5783 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5783

def pellMasks_5783 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5783.map pellLightMasksToOriginal

def pellWitnesses_5783 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5783

theorem pellMasks_5783_valid : ∀ m ∈ pellMasks_5783, m.Valid 5783 := by
  exact pellLightMasks_valid 5783 PellMatchingLightProduction.pellMasks_5783 PellMatchingLightProduction.pellMasks_5783_valid

theorem pellMatching_5783_checked :
    pellMatchingCheck pellMasks_5783 pellMagnitudes_5783 pellWitnesses_5783 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5783
    PellMatchingLightProduction.pellMagnitudes_5783 PellMatchingLightProduction.pellWitnesses_5783).symm.trans
      PellMatchingLightProduction.pellMatching_5783_checked

theorem pellMagnitudes_5783_large : ∀ x ∈ pellMagnitudes_5783, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5783 PellMatchingLightProduction.pellMagnitudes_5783_large

def pellGraphCertificate_5783 : PellMatchingCertificate 5783 where
  magnitudes := pellMagnitudes_5783
  masks := pellMasks_5783
  witnesses := pellWitnesses_5783
  masks_valid := pellMasks_5783_valid
  checked := pellMatching_5783_checked
  large := pellMagnitudes_5783_large

def pellMagnitudes_5791 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5791

def pellMasks_5791 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5791.map pellLightMasksToOriginal

def pellWitnesses_5791 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5791

theorem pellMasks_5791_valid : ∀ m ∈ pellMasks_5791, m.Valid 5791 := by
  exact pellLightMasks_valid 5791 PellMatchingLightProduction.pellMasks_5791 PellMatchingLightProduction.pellMasks_5791_valid

theorem pellMatching_5791_checked :
    pellMatchingCheck pellMasks_5791 pellMagnitudes_5791 pellWitnesses_5791 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5791
    PellMatchingLightProduction.pellMagnitudes_5791 PellMatchingLightProduction.pellWitnesses_5791).symm.trans
      PellMatchingLightProduction.pellMatching_5791_checked

theorem pellMagnitudes_5791_large : ∀ x ∈ pellMagnitudes_5791, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5791 PellMatchingLightProduction.pellMagnitudes_5791_large

def pellGraphCertificate_5791 : PellMatchingCertificate 5791 where
  magnitudes := pellMagnitudes_5791
  masks := pellMasks_5791
  witnesses := pellWitnesses_5791
  masks_valid := pellMasks_5791_valid
  checked := pellMatching_5791_checked
  large := pellMagnitudes_5791_large

def pellMagnitudes_5807 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5807

def pellMasks_5807 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5807.map pellLightMasksToOriginal

def pellWitnesses_5807 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5807

theorem pellMasks_5807_valid : ∀ m ∈ pellMasks_5807, m.Valid 5807 := by
  exact pellLightMasks_valid 5807 PellMatchingLightProduction.pellMasks_5807 PellMatchingLightProduction.pellMasks_5807_valid

theorem pellMatching_5807_checked :
    pellMatchingCheck pellMasks_5807 pellMagnitudes_5807 pellWitnesses_5807 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5807
    PellMatchingLightProduction.pellMagnitudes_5807 PellMatchingLightProduction.pellWitnesses_5807).symm.trans
      PellMatchingLightProduction.pellMatching_5807_checked

theorem pellMagnitudes_5807_large : ∀ x ∈ pellMagnitudes_5807, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5807 PellMatchingLightProduction.pellMagnitudes_5807_large

def pellGraphCertificate_5807 : PellMatchingCertificate 5807 where
  magnitudes := pellMagnitudes_5807
  masks := pellMasks_5807
  witnesses := pellWitnesses_5807
  masks_valid := pellMasks_5807_valid
  checked := pellMatching_5807_checked
  large := pellMagnitudes_5807_large

def pellMagnitudes_5839 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5839

def pellMasks_5839 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5839.map pellLightMasksToOriginal

def pellWitnesses_5839 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5839

theorem pellMasks_5839_valid : ∀ m ∈ pellMasks_5839, m.Valid 5839 := by
  exact pellLightMasks_valid 5839 PellMatchingLightProduction.pellMasks_5839 PellMatchingLightProduction.pellMasks_5839_valid

theorem pellMatching_5839_checked :
    pellMatchingCheck pellMasks_5839 pellMagnitudes_5839 pellWitnesses_5839 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5839
    PellMatchingLightProduction.pellMagnitudes_5839 PellMatchingLightProduction.pellWitnesses_5839).symm.trans
      PellMatchingLightProduction.pellMatching_5839_checked

theorem pellMagnitudes_5839_large : ∀ x ∈ pellMagnitudes_5839, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5839 PellMatchingLightProduction.pellMagnitudes_5839_large

def pellGraphCertificate_5839 : PellMatchingCertificate 5839 where
  magnitudes := pellMagnitudes_5839
  masks := pellMasks_5839
  witnesses := pellWitnesses_5839
  masks_valid := pellMasks_5839_valid
  checked := pellMatching_5839_checked
  large := pellMagnitudes_5839_large

def pellMagnitudes_5879 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5879

def pellMasks_5879 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5879.map pellLightMasksToOriginal

def pellWitnesses_5879 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5879

theorem pellMasks_5879_valid : ∀ m ∈ pellMasks_5879, m.Valid 5879 := by
  exact pellLightMasks_valid 5879 PellMatchingLightProduction.pellMasks_5879 PellMatchingLightProduction.pellMasks_5879_valid

theorem pellMatching_5879_checked :
    pellMatchingCheck pellMasks_5879 pellMagnitudes_5879 pellWitnesses_5879 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5879
    PellMatchingLightProduction.pellMagnitudes_5879 PellMatchingLightProduction.pellWitnesses_5879).symm.trans
      PellMatchingLightProduction.pellMatching_5879_checked

theorem pellMagnitudes_5879_large : ∀ x ∈ pellMagnitudes_5879, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5879 PellMatchingLightProduction.pellMagnitudes_5879_large

def pellGraphCertificate_5879 : PellMatchingCertificate 5879 where
  magnitudes := pellMagnitudes_5879
  masks := pellMasks_5879
  witnesses := pellWitnesses_5879
  masks_valid := pellMasks_5879_valid
  checked := pellMatching_5879_checked
  large := pellMagnitudes_5879_large

def pellMagnitudes_5903 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5903

def pellMasks_5903 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5903.map pellLightMasksToOriginal

def pellWitnesses_5903 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5903

theorem pellMasks_5903_valid : ∀ m ∈ pellMasks_5903, m.Valid 5903 := by
  exact pellLightMasks_valid 5903 PellMatchingLightProduction.pellMasks_5903 PellMatchingLightProduction.pellMasks_5903_valid

theorem pellMatching_5903_checked :
    pellMatchingCheck pellMasks_5903 pellMagnitudes_5903 pellWitnesses_5903 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5903
    PellMatchingLightProduction.pellMagnitudes_5903 PellMatchingLightProduction.pellWitnesses_5903).symm.trans
      PellMatchingLightProduction.pellMatching_5903_checked

theorem pellMagnitudes_5903_large : ∀ x ∈ pellMagnitudes_5903, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5903 PellMatchingLightProduction.pellMagnitudes_5903_large

def pellGraphCertificate_5903 : PellMatchingCertificate 5903 where
  magnitudes := pellMagnitudes_5903
  masks := pellMasks_5903
  witnesses := pellWitnesses_5903
  masks_valid := pellMasks_5903_valid
  checked := pellMatching_5903_checked
  large := pellMagnitudes_5903_large

def pellMagnitudes_5927 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5927

def pellMasks_5927 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5927.map pellLightMasksToOriginal

def pellWitnesses_5927 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5927

theorem pellMasks_5927_valid : ∀ m ∈ pellMasks_5927, m.Valid 5927 := by
  exact pellLightMasks_valid 5927 PellMatchingLightProduction.pellMasks_5927 PellMatchingLightProduction.pellMasks_5927_valid

theorem pellMatching_5927_checked :
    pellMatchingCheck pellMasks_5927 pellMagnitudes_5927 pellWitnesses_5927 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5927
    PellMatchingLightProduction.pellMagnitudes_5927 PellMatchingLightProduction.pellWitnesses_5927).symm.trans
      PellMatchingLightProduction.pellMatching_5927_checked

theorem pellMagnitudes_5927_large : ∀ x ∈ pellMagnitudes_5927, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5927 PellMatchingLightProduction.pellMagnitudes_5927_large

def pellGraphCertificate_5927 : PellMatchingCertificate 5927 where
  magnitudes := pellMagnitudes_5927
  masks := pellMasks_5927
  witnesses := pellWitnesses_5927
  masks_valid := pellMasks_5927_valid
  checked := pellMatching_5927_checked
  large := pellMagnitudes_5927_large

def pellMagnitudes_5999 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_5999

def pellMasks_5999 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_5999.map pellLightMasksToOriginal

def pellWitnesses_5999 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_5999

theorem pellMasks_5999_valid : ∀ m ∈ pellMasks_5999, m.Valid 5999 := by
  exact pellLightMasks_valid 5999 PellMatchingLightProduction.pellMasks_5999 PellMatchingLightProduction.pellMasks_5999_valid

theorem pellMatching_5999_checked :
    pellMatchingCheck pellMasks_5999 pellMagnitudes_5999 pellWitnesses_5999 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_5999
    PellMatchingLightProduction.pellMagnitudes_5999 PellMatchingLightProduction.pellWitnesses_5999).symm.trans
      PellMatchingLightProduction.pellMatching_5999_checked

theorem pellMagnitudes_5999_large : ∀ x ∈ pellMagnitudes_5999, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_5999 PellMatchingLightProduction.pellMagnitudes_5999_large

def pellGraphCertificate_5999 : PellMatchingCertificate 5999 where
  magnitudes := pellMagnitudes_5999
  masks := pellMasks_5999
  witnesses := pellWitnesses_5999
  masks_valid := pellMasks_5999_valid
  checked := pellMatching_5999_checked
  large := pellMagnitudes_5999_large

def pellMagnitudes_6007 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6007

def pellMasks_6007 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6007.map pellLightMasksToOriginal

def pellWitnesses_6007 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6007

theorem pellMasks_6007_valid : ∀ m ∈ pellMasks_6007, m.Valid 6007 := by
  exact pellLightMasks_valid 6007 PellMatchingLightProduction.pellMasks_6007 PellMatchingLightProduction.pellMasks_6007_valid

theorem pellMatching_6007_checked :
    pellMatchingCheck pellMasks_6007 pellMagnitudes_6007 pellWitnesses_6007 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6007
    PellMatchingLightProduction.pellMagnitudes_6007 PellMatchingLightProduction.pellWitnesses_6007).symm.trans
      PellMatchingLightProduction.pellMatching_6007_checked

theorem pellMagnitudes_6007_large : ∀ x ∈ pellMagnitudes_6007, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6007 PellMatchingLightProduction.pellMagnitudes_6007_large

def pellGraphCertificate_6007 : PellMatchingCertificate 6007 where
  magnitudes := pellMagnitudes_6007
  masks := pellMasks_6007
  witnesses := pellWitnesses_6007
  masks_valid := pellMasks_6007_valid
  checked := pellMatching_6007_checked
  large := pellMagnitudes_6007_large

def pellMagnitudes_6047 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6047

def pellMasks_6047 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6047.map pellLightMasksToOriginal

def pellWitnesses_6047 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6047

theorem pellMasks_6047_valid : ∀ m ∈ pellMasks_6047, m.Valid 6047 := by
  exact pellLightMasks_valid 6047 PellMatchingLightProduction.pellMasks_6047 PellMatchingLightProduction.pellMasks_6047_valid

theorem pellMatching_6047_checked :
    pellMatchingCheck pellMasks_6047 pellMagnitudes_6047 pellWitnesses_6047 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6047
    PellMatchingLightProduction.pellMagnitudes_6047 PellMatchingLightProduction.pellWitnesses_6047).symm.trans
      PellMatchingLightProduction.pellMatching_6047_checked

theorem pellMagnitudes_6047_large : ∀ x ∈ pellMagnitudes_6047, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6047 PellMatchingLightProduction.pellMagnitudes_6047_large

def pellGraphCertificate_6047 : PellMatchingCertificate 6047 where
  magnitudes := pellMagnitudes_6047
  masks := pellMasks_6047
  witnesses := pellWitnesses_6047
  masks_valid := pellMasks_6047_valid
  checked := pellMatching_6047_checked
  large := pellMagnitudes_6047_large

def pellMagnitudes_6079 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6079

def pellMasks_6079 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6079.map pellLightMasksToOriginal

def pellWitnesses_6079 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6079

theorem pellMasks_6079_valid : ∀ m ∈ pellMasks_6079, m.Valid 6079 := by
  exact pellLightMasks_valid 6079 PellMatchingLightProduction.pellMasks_6079 PellMatchingLightProduction.pellMasks_6079_valid

theorem pellMatching_6079_checked :
    pellMatchingCheck pellMasks_6079 pellMagnitudes_6079 pellWitnesses_6079 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6079
    PellMatchingLightProduction.pellMagnitudes_6079 PellMatchingLightProduction.pellWitnesses_6079).symm.trans
      PellMatchingLightProduction.pellMatching_6079_checked

theorem pellMagnitudes_6079_large : ∀ x ∈ pellMagnitudes_6079, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6079 PellMatchingLightProduction.pellMagnitudes_6079_large

def pellGraphCertificate_6079 : PellMatchingCertificate 6079 where
  magnitudes := pellMagnitudes_6079
  masks := pellMasks_6079
  witnesses := pellWitnesses_6079
  masks_valid := pellMasks_6079_valid
  checked := pellMatching_6079_checked
  large := pellMagnitudes_6079_large

def pellMagnitudes_6103 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6103

def pellMasks_6103 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6103.map pellLightMasksToOriginal

def pellWitnesses_6103 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6103

theorem pellMasks_6103_valid : ∀ m ∈ pellMasks_6103, m.Valid 6103 := by
  exact pellLightMasks_valid 6103 PellMatchingLightProduction.pellMasks_6103 PellMatchingLightProduction.pellMasks_6103_valid

theorem pellMatching_6103_checked :
    pellMatchingCheck pellMasks_6103 pellMagnitudes_6103 pellWitnesses_6103 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6103
    PellMatchingLightProduction.pellMagnitudes_6103 PellMatchingLightProduction.pellWitnesses_6103).symm.trans
      PellMatchingLightProduction.pellMatching_6103_checked

theorem pellMagnitudes_6103_large : ∀ x ∈ pellMagnitudes_6103, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6103 PellMatchingLightProduction.pellMagnitudes_6103_large

def pellGraphCertificate_6103 : PellMatchingCertificate 6103 where
  magnitudes := pellMagnitudes_6103
  masks := pellMasks_6103
  witnesses := pellWitnesses_6103
  masks_valid := pellMasks_6103_valid
  checked := pellMatching_6103_checked
  large := pellMagnitudes_6103_large

def pellMagnitudes_6143 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6143

def pellMasks_6143 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6143.map pellLightMasksToOriginal

def pellWitnesses_6143 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6143

theorem pellMasks_6143_valid : ∀ m ∈ pellMasks_6143, m.Valid 6143 := by
  exact pellLightMasks_valid 6143 PellMatchingLightProduction.pellMasks_6143 PellMatchingLightProduction.pellMasks_6143_valid

theorem pellMatching_6143_checked :
    pellMatchingCheck pellMasks_6143 pellMagnitudes_6143 pellWitnesses_6143 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6143
    PellMatchingLightProduction.pellMagnitudes_6143 PellMatchingLightProduction.pellWitnesses_6143).symm.trans
      PellMatchingLightProduction.pellMatching_6143_checked

theorem pellMagnitudes_6143_large : ∀ x ∈ pellMagnitudes_6143, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6143 PellMatchingLightProduction.pellMagnitudes_6143_large

def pellGraphCertificate_6143 : PellMatchingCertificate 6143 where
  magnitudes := pellMagnitudes_6143
  masks := pellMasks_6143
  witnesses := pellWitnesses_6143
  masks_valid := pellMasks_6143_valid
  checked := pellMatching_6143_checked
  large := pellMagnitudes_6143_large

def pellMagnitudes_6151 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6151

def pellMasks_6151 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6151.map pellLightMasksToOriginal

def pellWitnesses_6151 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6151

theorem pellMasks_6151_valid : ∀ m ∈ pellMasks_6151, m.Valid 6151 := by
  exact pellLightMasks_valid 6151 PellMatchingLightProduction.pellMasks_6151 PellMatchingLightProduction.pellMasks_6151_valid

theorem pellMatching_6151_checked :
    pellMatchingCheck pellMasks_6151 pellMagnitudes_6151 pellWitnesses_6151 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6151
    PellMatchingLightProduction.pellMagnitudes_6151 PellMatchingLightProduction.pellWitnesses_6151).symm.trans
      PellMatchingLightProduction.pellMatching_6151_checked

theorem pellMagnitudes_6151_large : ∀ x ∈ pellMagnitudes_6151, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6151 PellMatchingLightProduction.pellMagnitudes_6151_large

def pellGraphCertificate_6151 : PellMatchingCertificate 6151 where
  magnitudes := pellMagnitudes_6151
  masks := pellMasks_6151
  witnesses := pellWitnesses_6151
  masks_valid := pellMasks_6151_valid
  checked := pellMatching_6151_checked
  large := pellMagnitudes_6151_large

def pellMagnitudes_6167 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6167

def pellMasks_6167 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6167.map pellLightMasksToOriginal

def pellWitnesses_6167 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6167

theorem pellMasks_6167_valid : ∀ m ∈ pellMasks_6167, m.Valid 6167 := by
  exact pellLightMasks_valid 6167 PellMatchingLightProduction.pellMasks_6167 PellMatchingLightProduction.pellMasks_6167_valid

theorem pellMatching_6167_checked :
    pellMatchingCheck pellMasks_6167 pellMagnitudes_6167 pellWitnesses_6167 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6167
    PellMatchingLightProduction.pellMagnitudes_6167 PellMatchingLightProduction.pellWitnesses_6167).symm.trans
      PellMatchingLightProduction.pellMatching_6167_checked

theorem pellMagnitudes_6167_large : ∀ x ∈ pellMagnitudes_6167, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6167 PellMatchingLightProduction.pellMagnitudes_6167_large

def pellGraphCertificate_6167 : PellMatchingCertificate 6167 where
  magnitudes := pellMagnitudes_6167
  masks := pellMasks_6167
  witnesses := pellWitnesses_6167
  masks_valid := pellMasks_6167_valid
  checked := pellMatching_6167_checked
  large := pellMagnitudes_6167_large

def pellMagnitudes_6191 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6191

def pellMasks_6191 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6191.map pellLightMasksToOriginal

def pellWitnesses_6191 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6191

theorem pellMasks_6191_valid : ∀ m ∈ pellMasks_6191, m.Valid 6191 := by
  exact pellLightMasks_valid 6191 PellMatchingLightProduction.pellMasks_6191 PellMatchingLightProduction.pellMasks_6191_valid

theorem pellMatching_6191_checked :
    pellMatchingCheck pellMasks_6191 pellMagnitudes_6191 pellWitnesses_6191 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6191
    PellMatchingLightProduction.pellMagnitudes_6191 PellMatchingLightProduction.pellWitnesses_6191).symm.trans
      PellMatchingLightProduction.pellMatching_6191_checked

theorem pellMagnitudes_6191_large : ∀ x ∈ pellMagnitudes_6191, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6191 PellMatchingLightProduction.pellMagnitudes_6191_large

def pellGraphCertificate_6191 : PellMatchingCertificate 6191 where
  magnitudes := pellMagnitudes_6191
  masks := pellMasks_6191
  witnesses := pellWitnesses_6191
  masks_valid := pellMasks_6191_valid
  checked := pellMatching_6191_checked
  large := pellMagnitudes_6191_large

def pellMagnitudes_6199 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6199

def pellMasks_6199 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6199.map pellLightMasksToOriginal

def pellWitnesses_6199 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6199

theorem pellMasks_6199_valid : ∀ m ∈ pellMasks_6199, m.Valid 6199 := by
  exact pellLightMasks_valid 6199 PellMatchingLightProduction.pellMasks_6199 PellMatchingLightProduction.pellMasks_6199_valid

theorem pellMatching_6199_checked :
    pellMatchingCheck pellMasks_6199 pellMagnitudes_6199 pellWitnesses_6199 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6199
    PellMatchingLightProduction.pellMagnitudes_6199 PellMatchingLightProduction.pellWitnesses_6199).symm.trans
      PellMatchingLightProduction.pellMatching_6199_checked

theorem pellMagnitudes_6199_large : ∀ x ∈ pellMagnitudes_6199, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6199 PellMatchingLightProduction.pellMagnitudes_6199_large

def pellGraphCertificate_6199 : PellMatchingCertificate 6199 where
  magnitudes := pellMagnitudes_6199
  masks := pellMasks_6199
  witnesses := pellWitnesses_6199
  masks_valid := pellMasks_6199_valid
  checked := pellMatching_6199_checked
  large := pellMagnitudes_6199_large

def pellMagnitudes_6239 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6239

def pellMasks_6239 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6239.map pellLightMasksToOriginal

def pellWitnesses_6239 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6239

theorem pellMasks_6239_valid : ∀ m ∈ pellMasks_6239, m.Valid 6239 := by
  exact pellLightMasks_valid 6239 PellMatchingLightProduction.pellMasks_6239 PellMatchingLightProduction.pellMasks_6239_valid

theorem pellMatching_6239_checked :
    pellMatchingCheck pellMasks_6239 pellMagnitudes_6239 pellWitnesses_6239 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6239
    PellMatchingLightProduction.pellMagnitudes_6239 PellMatchingLightProduction.pellWitnesses_6239).symm.trans
      PellMatchingLightProduction.pellMatching_6239_checked

theorem pellMagnitudes_6239_large : ∀ x ∈ pellMagnitudes_6239, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6239 PellMatchingLightProduction.pellMagnitudes_6239_large

def pellGraphCertificate_6239 : PellMatchingCertificate 6239 where
  magnitudes := pellMagnitudes_6239
  masks := pellMasks_6239
  witnesses := pellWitnesses_6239
  masks_valid := pellMasks_6239_valid
  checked := pellMatching_6239_checked
  large := pellMagnitudes_6239_large

def pellMagnitudes_6247 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6247

def pellMasks_6247 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6247.map pellLightMasksToOriginal

def pellWitnesses_6247 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6247

theorem pellMasks_6247_valid : ∀ m ∈ pellMasks_6247, m.Valid 6247 := by
  exact pellLightMasks_valid 6247 PellMatchingLightProduction.pellMasks_6247 PellMatchingLightProduction.pellMasks_6247_valid

theorem pellMatching_6247_checked :
    pellMatchingCheck pellMasks_6247 pellMagnitudes_6247 pellWitnesses_6247 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6247
    PellMatchingLightProduction.pellMagnitudes_6247 PellMatchingLightProduction.pellWitnesses_6247).symm.trans
      PellMatchingLightProduction.pellMatching_6247_checked

theorem pellMagnitudes_6247_large : ∀ x ∈ pellMagnitudes_6247, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6247 PellMatchingLightProduction.pellMagnitudes_6247_large

def pellGraphCertificate_6247 : PellMatchingCertificate 6247 where
  magnitudes := pellMagnitudes_6247
  masks := pellMasks_6247
  witnesses := pellWitnesses_6247
  masks_valid := pellMasks_6247_valid
  checked := pellMatching_6247_checked
  large := pellMagnitudes_6247_large

def pellMagnitudes_6263 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6263

def pellMasks_6263 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6263.map pellLightMasksToOriginal

def pellWitnesses_6263 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6263

theorem pellMasks_6263_valid : ∀ m ∈ pellMasks_6263, m.Valid 6263 := by
  exact pellLightMasks_valid 6263 PellMatchingLightProduction.pellMasks_6263 PellMatchingLightProduction.pellMasks_6263_valid

theorem pellMatching_6263_checked :
    pellMatchingCheck pellMasks_6263 pellMagnitudes_6263 pellWitnesses_6263 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6263
    PellMatchingLightProduction.pellMagnitudes_6263 PellMatchingLightProduction.pellWitnesses_6263).symm.trans
      PellMatchingLightProduction.pellMatching_6263_checked

theorem pellMagnitudes_6263_large : ∀ x ∈ pellMagnitudes_6263, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6263 PellMatchingLightProduction.pellMagnitudes_6263_large

def pellGraphCertificate_6263 : PellMatchingCertificate 6263 where
  magnitudes := pellMagnitudes_6263
  masks := pellMasks_6263
  witnesses := pellWitnesses_6263
  masks_valid := pellMasks_6263_valid
  checked := pellMatching_6263_checked
  large := pellMagnitudes_6263_large

def pellMagnitudes_6271 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6271

def pellMasks_6271 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6271.map pellLightMasksToOriginal

def pellWitnesses_6271 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6271

theorem pellMasks_6271_valid : ∀ m ∈ pellMasks_6271, m.Valid 6271 := by
  exact pellLightMasks_valid 6271 PellMatchingLightProduction.pellMasks_6271 PellMatchingLightProduction.pellMasks_6271_valid

theorem pellMatching_6271_checked :
    pellMatchingCheck pellMasks_6271 pellMagnitudes_6271 pellWitnesses_6271 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6271
    PellMatchingLightProduction.pellMagnitudes_6271 PellMatchingLightProduction.pellWitnesses_6271).symm.trans
      PellMatchingLightProduction.pellMatching_6271_checked

theorem pellMagnitudes_6271_large : ∀ x ∈ pellMagnitudes_6271, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6271 PellMatchingLightProduction.pellMagnitudes_6271_large

def pellGraphCertificate_6271 : PellMatchingCertificate 6271 where
  magnitudes := pellMagnitudes_6271
  masks := pellMasks_6271
  witnesses := pellWitnesses_6271
  masks_valid := pellMasks_6271_valid
  checked := pellMatching_6271_checked
  large := pellMagnitudes_6271_large

def pellMagnitudes_6287 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6287

def pellMasks_6287 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6287.map pellLightMasksToOriginal

def pellWitnesses_6287 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6287

theorem pellMasks_6287_valid : ∀ m ∈ pellMasks_6287, m.Valid 6287 := by
  exact pellLightMasks_valid 6287 PellMatchingLightProduction.pellMasks_6287 PellMatchingLightProduction.pellMasks_6287_valid

theorem pellMatching_6287_checked :
    pellMatchingCheck pellMasks_6287 pellMagnitudes_6287 pellWitnesses_6287 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6287
    PellMatchingLightProduction.pellMagnitudes_6287 PellMatchingLightProduction.pellWitnesses_6287).symm.trans
      PellMatchingLightProduction.pellMatching_6287_checked

theorem pellMagnitudes_6287_large : ∀ x ∈ pellMagnitudes_6287, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6287 PellMatchingLightProduction.pellMagnitudes_6287_large

def pellGraphCertificate_6287 : PellMatchingCertificate 6287 where
  magnitudes := pellMagnitudes_6287
  masks := pellMasks_6287
  witnesses := pellWitnesses_6287
  masks_valid := pellMasks_6287_valid
  checked := pellMatching_6287_checked
  large := pellMagnitudes_6287_large

def pellMagnitudes_6311 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6311

def pellMasks_6311 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6311.map pellLightMasksToOriginal

def pellWitnesses_6311 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6311

theorem pellMasks_6311_valid : ∀ m ∈ pellMasks_6311, m.Valid 6311 := by
  exact pellLightMasks_valid 6311 PellMatchingLightProduction.pellMasks_6311 PellMatchingLightProduction.pellMasks_6311_valid

theorem pellMatching_6311_checked :
    pellMatchingCheck pellMasks_6311 pellMagnitudes_6311 pellWitnesses_6311 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6311
    PellMatchingLightProduction.pellMagnitudes_6311 PellMatchingLightProduction.pellWitnesses_6311).symm.trans
      PellMatchingLightProduction.pellMatching_6311_checked

theorem pellMagnitudes_6311_large : ∀ x ∈ pellMagnitudes_6311, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6311 PellMatchingLightProduction.pellMagnitudes_6311_large

def pellGraphCertificate_6311 : PellMatchingCertificate 6311 where
  magnitudes := pellMagnitudes_6311
  masks := pellMasks_6311
  witnesses := pellWitnesses_6311
  masks_valid := pellMasks_6311_valid
  checked := pellMatching_6311_checked
  large := pellMagnitudes_6311_large

def pellMagnitudes_6319 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6319

def pellMasks_6319 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6319.map pellLightMasksToOriginal

def pellWitnesses_6319 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6319

theorem pellMasks_6319_valid : ∀ m ∈ pellMasks_6319, m.Valid 6319 := by
  exact pellLightMasks_valid 6319 PellMatchingLightProduction.pellMasks_6319 PellMatchingLightProduction.pellMasks_6319_valid

theorem pellMatching_6319_checked :
    pellMatchingCheck pellMasks_6319 pellMagnitudes_6319 pellWitnesses_6319 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6319
    PellMatchingLightProduction.pellMagnitudes_6319 PellMatchingLightProduction.pellWitnesses_6319).symm.trans
      PellMatchingLightProduction.pellMatching_6319_checked

theorem pellMagnitudes_6319_large : ∀ x ∈ pellMagnitudes_6319, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6319 PellMatchingLightProduction.pellMagnitudes_6319_large

def pellGraphCertificate_6319 : PellMatchingCertificate 6319 where
  magnitudes := pellMagnitudes_6319
  masks := pellMasks_6319
  witnesses := pellWitnesses_6319
  masks_valid := pellMasks_6319_valid
  checked := pellMatching_6319_checked
  large := pellMagnitudes_6319_large

def pellMagnitudes_6343 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6343

def pellMasks_6343 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6343.map pellLightMasksToOriginal

def pellWitnesses_6343 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6343

theorem pellMasks_6343_valid : ∀ m ∈ pellMasks_6343, m.Valid 6343 := by
  exact pellLightMasks_valid 6343 PellMatchingLightProduction.pellMasks_6343 PellMatchingLightProduction.pellMasks_6343_valid

theorem pellMatching_6343_checked :
    pellMatchingCheck pellMasks_6343 pellMagnitudes_6343 pellWitnesses_6343 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6343
    PellMatchingLightProduction.pellMagnitudes_6343 PellMatchingLightProduction.pellWitnesses_6343).symm.trans
      PellMatchingLightProduction.pellMatching_6343_checked

theorem pellMagnitudes_6343_large : ∀ x ∈ pellMagnitudes_6343, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6343 PellMatchingLightProduction.pellMagnitudes_6343_large

def pellGraphCertificate_6343 : PellMatchingCertificate 6343 where
  magnitudes := pellMagnitudes_6343
  masks := pellMasks_6343
  witnesses := pellWitnesses_6343
  masks_valid := pellMasks_6343_valid
  checked := pellMatching_6343_checked
  large := pellMagnitudes_6343_large

def pellMagnitudes_6359 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6359

def pellMasks_6359 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6359.map pellLightMasksToOriginal

def pellWitnesses_6359 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6359

theorem pellMasks_6359_valid : ∀ m ∈ pellMasks_6359, m.Valid 6359 := by
  exact pellLightMasks_valid 6359 PellMatchingLightProduction.pellMasks_6359 PellMatchingLightProduction.pellMasks_6359_valid

theorem pellMatching_6359_checked :
    pellMatchingCheck pellMasks_6359 pellMagnitudes_6359 pellWitnesses_6359 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6359
    PellMatchingLightProduction.pellMagnitudes_6359 PellMatchingLightProduction.pellWitnesses_6359).symm.trans
      PellMatchingLightProduction.pellMatching_6359_checked

theorem pellMagnitudes_6359_large : ∀ x ∈ pellMagnitudes_6359, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6359 PellMatchingLightProduction.pellMagnitudes_6359_large

def pellGraphCertificate_6359 : PellMatchingCertificate 6359 where
  magnitudes := pellMagnitudes_6359
  masks := pellMasks_6359
  witnesses := pellWitnesses_6359
  masks_valid := pellMasks_6359_valid
  checked := pellMatching_6359_checked
  large := pellMagnitudes_6359_large

def pellMagnitudes_6367 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6367

def pellMasks_6367 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6367.map pellLightMasksToOriginal

def pellWitnesses_6367 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6367

theorem pellMasks_6367_valid : ∀ m ∈ pellMasks_6367, m.Valid 6367 := by
  exact pellLightMasks_valid 6367 PellMatchingLightProduction.pellMasks_6367 PellMatchingLightProduction.pellMasks_6367_valid

theorem pellMatching_6367_checked :
    pellMatchingCheck pellMasks_6367 pellMagnitudes_6367 pellWitnesses_6367 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6367
    PellMatchingLightProduction.pellMagnitudes_6367 PellMatchingLightProduction.pellWitnesses_6367).symm.trans
      PellMatchingLightProduction.pellMatching_6367_checked

theorem pellMagnitudes_6367_large : ∀ x ∈ pellMagnitudes_6367, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6367 PellMatchingLightProduction.pellMagnitudes_6367_large

def pellGraphCertificate_6367 : PellMatchingCertificate 6367 where
  magnitudes := pellMagnitudes_6367
  masks := pellMasks_6367
  witnesses := pellWitnesses_6367
  masks_valid := pellMasks_6367_valid
  checked := pellMatching_6367_checked
  large := pellMagnitudes_6367_large

def pellMagnitudes_6439 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6439

def pellMasks_6439 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6439.map pellLightMasksToOriginal

def pellWitnesses_6439 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6439

theorem pellMasks_6439_valid : ∀ m ∈ pellMasks_6439, m.Valid 6439 := by
  exact pellLightMasks_valid 6439 PellMatchingLightProduction.pellMasks_6439 PellMatchingLightProduction.pellMasks_6439_valid

theorem pellMatching_6439_checked :
    pellMatchingCheck pellMasks_6439 pellMagnitudes_6439 pellWitnesses_6439 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6439
    PellMatchingLightProduction.pellMagnitudes_6439 PellMatchingLightProduction.pellWitnesses_6439).symm.trans
      PellMatchingLightProduction.pellMatching_6439_checked

theorem pellMagnitudes_6439_large : ∀ x ∈ pellMagnitudes_6439, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6439 PellMatchingLightProduction.pellMagnitudes_6439_large

def pellGraphCertificate_6439 : PellMatchingCertificate 6439 where
  magnitudes := pellMagnitudes_6439
  masks := pellMasks_6439
  witnesses := pellWitnesses_6439
  masks_valid := pellMasks_6439_valid
  checked := pellMatching_6439_checked
  large := pellMagnitudes_6439_large

def pellMagnitudes_6463 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6463

def pellMasks_6463 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6463.map pellLightMasksToOriginal

def pellWitnesses_6463 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6463

theorem pellMasks_6463_valid : ∀ m ∈ pellMasks_6463, m.Valid 6463 := by
  exact pellLightMasks_valid 6463 PellMatchingLightProduction.pellMasks_6463 PellMatchingLightProduction.pellMasks_6463_valid

theorem pellMatching_6463_checked :
    pellMatchingCheck pellMasks_6463 pellMagnitudes_6463 pellWitnesses_6463 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6463
    PellMatchingLightProduction.pellMagnitudes_6463 PellMatchingLightProduction.pellWitnesses_6463).symm.trans
      PellMatchingLightProduction.pellMatching_6463_checked

theorem pellMagnitudes_6463_large : ∀ x ∈ pellMagnitudes_6463, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6463 PellMatchingLightProduction.pellMagnitudes_6463_large

def pellGraphCertificate_6463 : PellMatchingCertificate 6463 where
  magnitudes := pellMagnitudes_6463
  masks := pellMasks_6463
  witnesses := pellWitnesses_6463
  masks_valid := pellMasks_6463_valid
  checked := pellMatching_6463_checked
  large := pellMagnitudes_6463_large

def pellMagnitudes_6503 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6503

def pellMasks_6503 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6503.map pellLightMasksToOriginal

def pellWitnesses_6503 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6503

theorem pellMasks_6503_valid : ∀ m ∈ pellMasks_6503, m.Valid 6503 := by
  exact pellLightMasks_valid 6503 PellMatchingLightProduction.pellMasks_6503 PellMatchingLightProduction.pellMasks_6503_valid

theorem pellMatching_6503_checked :
    pellMatchingCheck pellMasks_6503 pellMagnitudes_6503 pellWitnesses_6503 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6503
    PellMatchingLightProduction.pellMagnitudes_6503 PellMatchingLightProduction.pellWitnesses_6503).symm.trans
      PellMatchingLightProduction.pellMatching_6503_checked

theorem pellMagnitudes_6503_large : ∀ x ∈ pellMagnitudes_6503, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6503 PellMatchingLightProduction.pellMagnitudes_6503_large

def pellGraphCertificate_6503 : PellMatchingCertificate 6503 where
  magnitudes := pellMagnitudes_6503
  masks := pellMasks_6503
  witnesses := pellWitnesses_6503
  masks_valid := pellMasks_6503_valid
  checked := pellMatching_6503_checked
  large := pellMagnitudes_6503_large

def pellMagnitudes_6551 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6551

def pellMasks_6551 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6551.map pellLightMasksToOriginal

def pellWitnesses_6551 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6551

theorem pellMasks_6551_valid : ∀ m ∈ pellMasks_6551, m.Valid 6551 := by
  exact pellLightMasks_valid 6551 PellMatchingLightProduction.pellMasks_6551 PellMatchingLightProduction.pellMasks_6551_valid

theorem pellMatching_6551_checked :
    pellMatchingCheck pellMasks_6551 pellMagnitudes_6551 pellWitnesses_6551 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6551
    PellMatchingLightProduction.pellMagnitudes_6551 PellMatchingLightProduction.pellWitnesses_6551).symm.trans
      PellMatchingLightProduction.pellMatching_6551_checked

theorem pellMagnitudes_6551_large : ∀ x ∈ pellMagnitudes_6551, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6551 PellMatchingLightProduction.pellMagnitudes_6551_large

def pellGraphCertificate_6551 : PellMatchingCertificate 6551 where
  magnitudes := pellMagnitudes_6551
  masks := pellMasks_6551
  witnesses := pellWitnesses_6551
  masks_valid := pellMasks_6551_valid
  checked := pellMatching_6551_checked
  large := pellMagnitudes_6551_large

def pellMagnitudes_6559 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6559

def pellMasks_6559 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6559.map pellLightMasksToOriginal

def pellWitnesses_6559 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6559

theorem pellMasks_6559_valid : ∀ m ∈ pellMasks_6559, m.Valid 6559 := by
  exact pellLightMasks_valid 6559 PellMatchingLightProduction.pellMasks_6559 PellMatchingLightProduction.pellMasks_6559_valid

theorem pellMatching_6559_checked :
    pellMatchingCheck pellMasks_6559 pellMagnitudes_6559 pellWitnesses_6559 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6559
    PellMatchingLightProduction.pellMagnitudes_6559 PellMatchingLightProduction.pellWitnesses_6559).symm.trans
      PellMatchingLightProduction.pellMatching_6559_checked

theorem pellMagnitudes_6559_large : ∀ x ∈ pellMagnitudes_6559, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6559 PellMatchingLightProduction.pellMagnitudes_6559_large

def pellGraphCertificate_6559 : PellMatchingCertificate 6559 where
  magnitudes := pellMagnitudes_6559
  masks := pellMasks_6559
  witnesses := pellWitnesses_6559
  masks_valid := pellMasks_6559_valid
  checked := pellMatching_6559_checked
  large := pellMagnitudes_6559_large

def pellMagnitudes_6599 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6599

def pellMasks_6599 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6599.map pellLightMasksToOriginal

def pellWitnesses_6599 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6599

theorem pellMasks_6599_valid : ∀ m ∈ pellMasks_6599, m.Valid 6599 := by
  exact pellLightMasks_valid 6599 PellMatchingLightProduction.pellMasks_6599 PellMatchingLightProduction.pellMasks_6599_valid

theorem pellMatching_6599_checked :
    pellMatchingCheck pellMasks_6599 pellMagnitudes_6599 pellWitnesses_6599 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6599
    PellMatchingLightProduction.pellMagnitudes_6599 PellMatchingLightProduction.pellWitnesses_6599).symm.trans
      PellMatchingLightProduction.pellMatching_6599_checked

theorem pellMagnitudes_6599_large : ∀ x ∈ pellMagnitudes_6599, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6599 PellMatchingLightProduction.pellMagnitudes_6599_large

def pellGraphCertificate_6599 : PellMatchingCertificate 6599 where
  magnitudes := pellMagnitudes_6599
  masks := pellMasks_6599
  witnesses := pellWitnesses_6599
  masks_valid := pellMasks_6599_valid
  checked := pellMatching_6599_checked
  large := pellMagnitudes_6599_large

def pellMagnitudes_6607 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6607

def pellMasks_6607 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6607.map pellLightMasksToOriginal

def pellWitnesses_6607 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6607

theorem pellMasks_6607_valid : ∀ m ∈ pellMasks_6607, m.Valid 6607 := by
  exact pellLightMasks_valid 6607 PellMatchingLightProduction.pellMasks_6607 PellMatchingLightProduction.pellMasks_6607_valid

theorem pellMatching_6607_checked :
    pellMatchingCheck pellMasks_6607 pellMagnitudes_6607 pellWitnesses_6607 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6607
    PellMatchingLightProduction.pellMagnitudes_6607 PellMatchingLightProduction.pellWitnesses_6607).symm.trans
      PellMatchingLightProduction.pellMatching_6607_checked

theorem pellMagnitudes_6607_large : ∀ x ∈ pellMagnitudes_6607, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6607 PellMatchingLightProduction.pellMagnitudes_6607_large

def pellGraphCertificate_6607 : PellMatchingCertificate 6607 where
  magnitudes := pellMagnitudes_6607
  masks := pellMasks_6607
  witnesses := pellWitnesses_6607
  masks_valid := pellMasks_6607_valid
  checked := pellMatching_6607_checked
  large := pellMagnitudes_6607_large

def pellMagnitudes_6679 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6679

def pellMasks_6679 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6679.map pellLightMasksToOriginal

def pellWitnesses_6679 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6679

theorem pellMasks_6679_valid : ∀ m ∈ pellMasks_6679, m.Valid 6679 := by
  exact pellLightMasks_valid 6679 PellMatchingLightProduction.pellMasks_6679 PellMatchingLightProduction.pellMasks_6679_valid

theorem pellMatching_6679_checked :
    pellMatchingCheck pellMasks_6679 pellMagnitudes_6679 pellWitnesses_6679 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6679
    PellMatchingLightProduction.pellMagnitudes_6679 PellMatchingLightProduction.pellWitnesses_6679).symm.trans
      PellMatchingLightProduction.pellMatching_6679_checked

theorem pellMagnitudes_6679_large : ∀ x ∈ pellMagnitudes_6679, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6679 PellMatchingLightProduction.pellMagnitudes_6679_large

def pellGraphCertificate_6679 : PellMatchingCertificate 6679 where
  magnitudes := pellMagnitudes_6679
  masks := pellMasks_6679
  witnesses := pellWitnesses_6679
  masks_valid := pellMasks_6679_valid
  checked := pellMatching_6679_checked
  large := pellMagnitudes_6679_large

def pellMagnitudes_6703 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6703

def pellMasks_6703 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6703.map pellLightMasksToOriginal

def pellWitnesses_6703 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6703

theorem pellMasks_6703_valid : ∀ m ∈ pellMasks_6703, m.Valid 6703 := by
  exact pellLightMasks_valid 6703 PellMatchingLightProduction.pellMasks_6703 PellMatchingLightProduction.pellMasks_6703_valid

theorem pellMatching_6703_checked :
    pellMatchingCheck pellMasks_6703 pellMagnitudes_6703 pellWitnesses_6703 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6703
    PellMatchingLightProduction.pellMagnitudes_6703 PellMatchingLightProduction.pellWitnesses_6703).symm.trans
      PellMatchingLightProduction.pellMatching_6703_checked

theorem pellMagnitudes_6703_large : ∀ x ∈ pellMagnitudes_6703, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6703 PellMatchingLightProduction.pellMagnitudes_6703_large

def pellGraphCertificate_6703 : PellMatchingCertificate 6703 where
  magnitudes := pellMagnitudes_6703
  masks := pellMasks_6703
  witnesses := pellWitnesses_6703
  masks_valid := pellMasks_6703_valid
  checked := pellMatching_6703_checked
  large := pellMagnitudes_6703_large

def pellMagnitudes_6719 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6719

def pellMasks_6719 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6719.map pellLightMasksToOriginal

def pellWitnesses_6719 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6719

theorem pellMasks_6719_valid : ∀ m ∈ pellMasks_6719, m.Valid 6719 := by
  exact pellLightMasks_valid 6719 PellMatchingLightProduction.pellMasks_6719 PellMatchingLightProduction.pellMasks_6719_valid

theorem pellMatching_6719_checked :
    pellMatchingCheck pellMasks_6719 pellMagnitudes_6719 pellWitnesses_6719 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6719
    PellMatchingLightProduction.pellMagnitudes_6719 PellMatchingLightProduction.pellWitnesses_6719).symm.trans
      PellMatchingLightProduction.pellMatching_6719_checked

theorem pellMagnitudes_6719_large : ∀ x ∈ pellMagnitudes_6719, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6719 PellMatchingLightProduction.pellMagnitudes_6719_large

def pellGraphCertificate_6719 : PellMatchingCertificate 6719 where
  magnitudes := pellMagnitudes_6719
  masks := pellMasks_6719
  witnesses := pellWitnesses_6719
  masks_valid := pellMasks_6719_valid
  checked := pellMatching_6719_checked
  large := pellMagnitudes_6719_large

def pellMagnitudes_6791 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6791

def pellMasks_6791 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6791.map pellLightMasksToOriginal

def pellWitnesses_6791 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6791

theorem pellMasks_6791_valid : ∀ m ∈ pellMasks_6791, m.Valid 6791 := by
  exact pellLightMasks_valid 6791 PellMatchingLightProduction.pellMasks_6791 PellMatchingLightProduction.pellMasks_6791_valid

theorem pellMatching_6791_checked :
    pellMatchingCheck pellMasks_6791 pellMagnitudes_6791 pellWitnesses_6791 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6791
    PellMatchingLightProduction.pellMagnitudes_6791 PellMatchingLightProduction.pellWitnesses_6791).symm.trans
      PellMatchingLightProduction.pellMatching_6791_checked

theorem pellMagnitudes_6791_large : ∀ x ∈ pellMagnitudes_6791, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6791 PellMatchingLightProduction.pellMagnitudes_6791_large

def pellGraphCertificate_6791 : PellMatchingCertificate 6791 where
  magnitudes := pellMagnitudes_6791
  masks := pellMasks_6791
  witnesses := pellWitnesses_6791
  masks_valid := pellMasks_6791_valid
  checked := pellMatching_6791_checked
  large := pellMagnitudes_6791_large

def pellMagnitudes_6823 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6823

def pellMasks_6823 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6823.map pellLightMasksToOriginal

def pellWitnesses_6823 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6823

theorem pellMasks_6823_valid : ∀ m ∈ pellMasks_6823, m.Valid 6823 := by
  exact pellLightMasks_valid 6823 PellMatchingLightProduction.pellMasks_6823 PellMatchingLightProduction.pellMasks_6823_valid

theorem pellMatching_6823_checked :
    pellMatchingCheck pellMasks_6823 pellMagnitudes_6823 pellWitnesses_6823 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6823
    PellMatchingLightProduction.pellMagnitudes_6823 PellMatchingLightProduction.pellWitnesses_6823).symm.trans
      PellMatchingLightProduction.pellMatching_6823_checked

theorem pellMagnitudes_6823_large : ∀ x ∈ pellMagnitudes_6823, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6823 PellMatchingLightProduction.pellMagnitudes_6823_large

def pellGraphCertificate_6823 : PellMatchingCertificate 6823 where
  magnitudes := pellMagnitudes_6823
  masks := pellMasks_6823
  witnesses := pellWitnesses_6823
  masks_valid := pellMasks_6823_valid
  checked := pellMatching_6823_checked
  large := pellMagnitudes_6823_large

def pellMagnitudes_6847 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6847

def pellMasks_6847 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6847.map pellLightMasksToOriginal

def pellWitnesses_6847 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6847

theorem pellMasks_6847_valid : ∀ m ∈ pellMasks_6847, m.Valid 6847 := by
  exact pellLightMasks_valid 6847 PellMatchingLightProduction.pellMasks_6847 PellMatchingLightProduction.pellMasks_6847_valid

theorem pellMatching_6847_checked :
    pellMatchingCheck pellMasks_6847 pellMagnitudes_6847 pellWitnesses_6847 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6847
    PellMatchingLightProduction.pellMagnitudes_6847 PellMatchingLightProduction.pellWitnesses_6847).symm.trans
      PellMatchingLightProduction.pellMatching_6847_checked

theorem pellMagnitudes_6847_large : ∀ x ∈ pellMagnitudes_6847, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6847 PellMatchingLightProduction.pellMagnitudes_6847_large

def pellGraphCertificate_6847 : PellMatchingCertificate 6847 where
  magnitudes := pellMagnitudes_6847
  masks := pellMasks_6847
  witnesses := pellWitnesses_6847
  masks_valid := pellMasks_6847_valid
  checked := pellMatching_6847_checked
  large := pellMagnitudes_6847_large

def pellMagnitudes_6863 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6863

def pellMasks_6863 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6863.map pellLightMasksToOriginal

def pellWitnesses_6863 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6863

theorem pellMasks_6863_valid : ∀ m ∈ pellMasks_6863, m.Valid 6863 := by
  exact pellLightMasks_valid 6863 PellMatchingLightProduction.pellMasks_6863 PellMatchingLightProduction.pellMasks_6863_valid

theorem pellMatching_6863_checked :
    pellMatchingCheck pellMasks_6863 pellMagnitudes_6863 pellWitnesses_6863 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6863
    PellMatchingLightProduction.pellMagnitudes_6863 PellMatchingLightProduction.pellWitnesses_6863).symm.trans
      PellMatchingLightProduction.pellMatching_6863_checked

theorem pellMagnitudes_6863_large : ∀ x ∈ pellMagnitudes_6863, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6863 PellMatchingLightProduction.pellMagnitudes_6863_large

def pellGraphCertificate_6863 : PellMatchingCertificate 6863 where
  magnitudes := pellMagnitudes_6863
  masks := pellMasks_6863
  witnesses := pellWitnesses_6863
  masks_valid := pellMasks_6863_valid
  checked := pellMatching_6863_checked
  large := pellMagnitudes_6863_large

def pellMagnitudes_6871 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6871

def pellMasks_6871 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6871.map pellLightMasksToOriginal

def pellWitnesses_6871 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6871

theorem pellMasks_6871_valid : ∀ m ∈ pellMasks_6871, m.Valid 6871 := by
  exact pellLightMasks_valid 6871 PellMatchingLightProduction.pellMasks_6871 PellMatchingLightProduction.pellMasks_6871_valid

theorem pellMatching_6871_checked :
    pellMatchingCheck pellMasks_6871 pellMagnitudes_6871 pellWitnesses_6871 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6871
    PellMatchingLightProduction.pellMagnitudes_6871 PellMatchingLightProduction.pellWitnesses_6871).symm.trans
      PellMatchingLightProduction.pellMatching_6871_checked

theorem pellMagnitudes_6871_large : ∀ x ∈ pellMagnitudes_6871, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6871 PellMatchingLightProduction.pellMagnitudes_6871_large

def pellGraphCertificate_6871 : PellMatchingCertificate 6871 where
  magnitudes := pellMagnitudes_6871
  masks := pellMasks_6871
  witnesses := pellWitnesses_6871
  masks_valid := pellMasks_6871_valid
  checked := pellMatching_6871_checked
  large := pellMagnitudes_6871_large

def pellMagnitudes_6887 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6887

def pellMasks_6887 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6887.map pellLightMasksToOriginal

def pellWitnesses_6887 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6887

theorem pellMasks_6887_valid : ∀ m ∈ pellMasks_6887, m.Valid 6887 := by
  exact pellLightMasks_valid 6887 PellMatchingLightProduction.pellMasks_6887 PellMatchingLightProduction.pellMasks_6887_valid

theorem pellMatching_6887_checked :
    pellMatchingCheck pellMasks_6887 pellMagnitudes_6887 pellWitnesses_6887 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6887
    PellMatchingLightProduction.pellMagnitudes_6887 PellMatchingLightProduction.pellWitnesses_6887).symm.trans
      PellMatchingLightProduction.pellMatching_6887_checked

theorem pellMagnitudes_6887_large : ∀ x ∈ pellMagnitudes_6887, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6887 PellMatchingLightProduction.pellMagnitudes_6887_large

def pellGraphCertificate_6887 : PellMatchingCertificate 6887 where
  magnitudes := pellMagnitudes_6887
  masks := pellMasks_6887
  witnesses := pellWitnesses_6887
  masks_valid := pellMasks_6887_valid
  checked := pellMatching_6887_checked
  large := pellMagnitudes_6887_large

def pellMagnitudes_6911 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6911

def pellMasks_6911 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6911.map pellLightMasksToOriginal

def pellWitnesses_6911 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6911

theorem pellMasks_6911_valid : ∀ m ∈ pellMasks_6911, m.Valid 6911 := by
  exact pellLightMasks_valid 6911 PellMatchingLightProduction.pellMasks_6911 PellMatchingLightProduction.pellMasks_6911_valid

theorem pellMatching_6911_checked :
    pellMatchingCheck pellMasks_6911 pellMagnitudes_6911 pellWitnesses_6911 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6911
    PellMatchingLightProduction.pellMagnitudes_6911 PellMatchingLightProduction.pellWitnesses_6911).symm.trans
      PellMatchingLightProduction.pellMatching_6911_checked

theorem pellMagnitudes_6911_large : ∀ x ∈ pellMagnitudes_6911, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6911 PellMatchingLightProduction.pellMagnitudes_6911_large

def pellGraphCertificate_6911 : PellMatchingCertificate 6911 where
  magnitudes := pellMagnitudes_6911
  masks := pellMasks_6911
  witnesses := pellWitnesses_6911
  masks_valid := pellMasks_6911_valid
  checked := pellMatching_6911_checked
  large := pellMagnitudes_6911_large

def pellMagnitudes_6959 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6959

def pellMasks_6959 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6959.map pellLightMasksToOriginal

def pellWitnesses_6959 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6959

theorem pellMasks_6959_valid : ∀ m ∈ pellMasks_6959, m.Valid 6959 := by
  exact pellLightMasks_valid 6959 PellMatchingLightProduction.pellMasks_6959 PellMatchingLightProduction.pellMasks_6959_valid

theorem pellMatching_6959_checked :
    pellMatchingCheck pellMasks_6959 pellMagnitudes_6959 pellWitnesses_6959 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6959
    PellMatchingLightProduction.pellMagnitudes_6959 PellMatchingLightProduction.pellWitnesses_6959).symm.trans
      PellMatchingLightProduction.pellMatching_6959_checked

theorem pellMagnitudes_6959_large : ∀ x ∈ pellMagnitudes_6959, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6959 PellMatchingLightProduction.pellMagnitudes_6959_large

def pellGraphCertificate_6959 : PellMatchingCertificate 6959 where
  magnitudes := pellMagnitudes_6959
  masks := pellMasks_6959
  witnesses := pellWitnesses_6959
  masks_valid := pellMasks_6959_valid
  checked := pellMatching_6959_checked
  large := pellMagnitudes_6959_large

def pellMagnitudes_6967 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6967

def pellMasks_6967 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6967.map pellLightMasksToOriginal

def pellWitnesses_6967 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6967

theorem pellMasks_6967_valid : ∀ m ∈ pellMasks_6967, m.Valid 6967 := by
  exact pellLightMasks_valid 6967 PellMatchingLightProduction.pellMasks_6967 PellMatchingLightProduction.pellMasks_6967_valid

theorem pellMatching_6967_checked :
    pellMatchingCheck pellMasks_6967 pellMagnitudes_6967 pellWitnesses_6967 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6967
    PellMatchingLightProduction.pellMagnitudes_6967 PellMatchingLightProduction.pellWitnesses_6967).symm.trans
      PellMatchingLightProduction.pellMatching_6967_checked

theorem pellMagnitudes_6967_large : ∀ x ∈ pellMagnitudes_6967, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6967 PellMatchingLightProduction.pellMagnitudes_6967_large

def pellGraphCertificate_6967 : PellMatchingCertificate 6967 where
  magnitudes := pellMagnitudes_6967
  masks := pellMasks_6967
  witnesses := pellWitnesses_6967
  masks_valid := pellMasks_6967_valid
  checked := pellMatching_6967_checked
  large := pellMagnitudes_6967_large

def pellMagnitudes_6983 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6983

def pellMasks_6983 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6983.map pellLightMasksToOriginal

def pellWitnesses_6983 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6983

theorem pellMasks_6983_valid : ∀ m ∈ pellMasks_6983, m.Valid 6983 := by
  exact pellLightMasks_valid 6983 PellMatchingLightProduction.pellMasks_6983 PellMatchingLightProduction.pellMasks_6983_valid

theorem pellMatching_6983_checked :
    pellMatchingCheck pellMasks_6983 pellMagnitudes_6983 pellWitnesses_6983 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6983
    PellMatchingLightProduction.pellMagnitudes_6983 PellMatchingLightProduction.pellWitnesses_6983).symm.trans
      PellMatchingLightProduction.pellMatching_6983_checked

theorem pellMagnitudes_6983_large : ∀ x ∈ pellMagnitudes_6983, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6983 PellMatchingLightProduction.pellMagnitudes_6983_large

def pellGraphCertificate_6983 : PellMatchingCertificate 6983 where
  magnitudes := pellMagnitudes_6983
  masks := pellMasks_6983
  witnesses := pellWitnesses_6983
  masks_valid := pellMasks_6983_valid
  checked := pellMatching_6983_checked
  large := pellMagnitudes_6983_large

def pellMagnitudes_6991 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_6991

def pellMasks_6991 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_6991.map pellLightMasksToOriginal

def pellWitnesses_6991 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_6991

theorem pellMasks_6991_valid : ∀ m ∈ pellMasks_6991, m.Valid 6991 := by
  exact pellLightMasks_valid 6991 PellMatchingLightProduction.pellMasks_6991 PellMatchingLightProduction.pellMasks_6991_valid

theorem pellMatching_6991_checked :
    pellMatchingCheck pellMasks_6991 pellMagnitudes_6991 pellWitnesses_6991 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_6991
    PellMatchingLightProduction.pellMagnitudes_6991 PellMatchingLightProduction.pellWitnesses_6991).symm.trans
      PellMatchingLightProduction.pellMatching_6991_checked

theorem pellMagnitudes_6991_large : ∀ x ∈ pellMagnitudes_6991, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_6991 PellMatchingLightProduction.pellMagnitudes_6991_large

def pellGraphCertificate_6991 : PellMatchingCertificate 6991 where
  magnitudes := pellMagnitudes_6991
  masks := pellMasks_6991
  witnesses := pellWitnesses_6991
  masks_valid := pellMasks_6991_valid
  checked := pellMatching_6991_checked
  large := pellMagnitudes_6991_large

def pellMagnitudes_7031 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7031

def pellMasks_7031 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7031.map pellLightMasksToOriginal

def pellWitnesses_7031 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7031

theorem pellMasks_7031_valid : ∀ m ∈ pellMasks_7031, m.Valid 7031 := by
  exact pellLightMasks_valid 7031 PellMatchingLightProduction.pellMasks_7031 PellMatchingLightProduction.pellMasks_7031_valid

theorem pellMatching_7031_checked :
    pellMatchingCheck pellMasks_7031 pellMagnitudes_7031 pellWitnesses_7031 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7031
    PellMatchingLightProduction.pellMagnitudes_7031 PellMatchingLightProduction.pellWitnesses_7031).symm.trans
      PellMatchingLightProduction.pellMatching_7031_checked

theorem pellMagnitudes_7031_large : ∀ x ∈ pellMagnitudes_7031, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7031 PellMatchingLightProduction.pellMagnitudes_7031_large

def pellGraphCertificate_7031 : PellMatchingCertificate 7031 where
  magnitudes := pellMagnitudes_7031
  masks := pellMasks_7031
  witnesses := pellWitnesses_7031
  masks_valid := pellMasks_7031_valid
  checked := pellMatching_7031_checked
  large := pellMagnitudes_7031_large

def pellMagnitudes_7039 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7039

def pellMasks_7039 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7039.map pellLightMasksToOriginal

def pellWitnesses_7039 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7039

theorem pellMasks_7039_valid : ∀ m ∈ pellMasks_7039, m.Valid 7039 := by
  exact pellLightMasks_valid 7039 PellMatchingLightProduction.pellMasks_7039 PellMatchingLightProduction.pellMasks_7039_valid

theorem pellMatching_7039_checked :
    pellMatchingCheck pellMasks_7039 pellMagnitudes_7039 pellWitnesses_7039 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7039
    PellMatchingLightProduction.pellMagnitudes_7039 PellMatchingLightProduction.pellWitnesses_7039).symm.trans
      PellMatchingLightProduction.pellMatching_7039_checked

theorem pellMagnitudes_7039_large : ∀ x ∈ pellMagnitudes_7039, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7039 PellMatchingLightProduction.pellMagnitudes_7039_large

def pellGraphCertificate_7039 : PellMatchingCertificate 7039 where
  magnitudes := pellMagnitudes_7039
  masks := pellMasks_7039
  witnesses := pellWitnesses_7039
  masks_valid := pellMasks_7039_valid
  checked := pellMatching_7039_checked
  large := pellMagnitudes_7039_large

def pellMagnitudes_7079 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7079

def pellMasks_7079 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7079.map pellLightMasksToOriginal

def pellWitnesses_7079 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7079

theorem pellMasks_7079_valid : ∀ m ∈ pellMasks_7079, m.Valid 7079 := by
  exact pellLightMasks_valid 7079 PellMatchingLightProduction.pellMasks_7079 PellMatchingLightProduction.pellMasks_7079_valid

theorem pellMatching_7079_checked :
    pellMatchingCheck pellMasks_7079 pellMagnitudes_7079 pellWitnesses_7079 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7079
    PellMatchingLightProduction.pellMagnitudes_7079 PellMatchingLightProduction.pellWitnesses_7079).symm.trans
      PellMatchingLightProduction.pellMatching_7079_checked

theorem pellMagnitudes_7079_large : ∀ x ∈ pellMagnitudes_7079, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7079 PellMatchingLightProduction.pellMagnitudes_7079_large

def pellGraphCertificate_7079 : PellMatchingCertificate 7079 where
  magnitudes := pellMagnitudes_7079
  masks := pellMasks_7079
  witnesses := pellWitnesses_7079
  masks_valid := pellMasks_7079_valid
  checked := pellMatching_7079_checked
  large := pellMagnitudes_7079_large

def pellMagnitudes_7103 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7103

def pellMasks_7103 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7103.map pellLightMasksToOriginal

def pellWitnesses_7103 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7103

theorem pellMasks_7103_valid : ∀ m ∈ pellMasks_7103, m.Valid 7103 := by
  exact pellLightMasks_valid 7103 PellMatchingLightProduction.pellMasks_7103 PellMatchingLightProduction.pellMasks_7103_valid

theorem pellMatching_7103_checked :
    pellMatchingCheck pellMasks_7103 pellMagnitudes_7103 pellWitnesses_7103 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7103
    PellMatchingLightProduction.pellMagnitudes_7103 PellMatchingLightProduction.pellWitnesses_7103).symm.trans
      PellMatchingLightProduction.pellMatching_7103_checked

theorem pellMagnitudes_7103_large : ∀ x ∈ pellMagnitudes_7103, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7103 PellMatchingLightProduction.pellMagnitudes_7103_large

def pellGraphCertificate_7103 : PellMatchingCertificate 7103 where
  magnitudes := pellMagnitudes_7103
  masks := pellMasks_7103
  witnesses := pellWitnesses_7103
  masks_valid := pellMasks_7103_valid
  checked := pellMatching_7103_checked
  large := pellMagnitudes_7103_large

def pellMagnitudes_7127 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7127

def pellMasks_7127 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7127.map pellLightMasksToOriginal

def pellWitnesses_7127 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7127

theorem pellMasks_7127_valid : ∀ m ∈ pellMasks_7127, m.Valid 7127 := by
  exact pellLightMasks_valid 7127 PellMatchingLightProduction.pellMasks_7127 PellMatchingLightProduction.pellMasks_7127_valid

theorem pellMatching_7127_checked :
    pellMatchingCheck pellMasks_7127 pellMagnitudes_7127 pellWitnesses_7127 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7127
    PellMatchingLightProduction.pellMagnitudes_7127 PellMatchingLightProduction.pellWitnesses_7127).symm.trans
      PellMatchingLightProduction.pellMatching_7127_checked

theorem pellMagnitudes_7127_large : ∀ x ∈ pellMagnitudes_7127, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7127 PellMatchingLightProduction.pellMagnitudes_7127_large

def pellGraphCertificate_7127 : PellMatchingCertificate 7127 where
  magnitudes := pellMagnitudes_7127
  masks := pellMasks_7127
  witnesses := pellWitnesses_7127
  masks_valid := pellMasks_7127_valid
  checked := pellMatching_7127_checked
  large := pellMagnitudes_7127_large

def pellMagnitudes_7151 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7151

def pellMasks_7151 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7151.map pellLightMasksToOriginal

def pellWitnesses_7151 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7151

theorem pellMasks_7151_valid : ∀ m ∈ pellMasks_7151, m.Valid 7151 := by
  exact pellLightMasks_valid 7151 PellMatchingLightProduction.pellMasks_7151 PellMatchingLightProduction.pellMasks_7151_valid

theorem pellMatching_7151_checked :
    pellMatchingCheck pellMasks_7151 pellMagnitudes_7151 pellWitnesses_7151 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7151
    PellMatchingLightProduction.pellMagnitudes_7151 PellMatchingLightProduction.pellWitnesses_7151).symm.trans
      PellMatchingLightProduction.pellMatching_7151_checked

theorem pellMagnitudes_7151_large : ∀ x ∈ pellMagnitudes_7151, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7151 PellMatchingLightProduction.pellMagnitudes_7151_large

def pellGraphCertificate_7151 : PellMatchingCertificate 7151 where
  magnitudes := pellMagnitudes_7151
  masks := pellMasks_7151
  witnesses := pellWitnesses_7151
  masks_valid := pellMasks_7151_valid
  checked := pellMatching_7151_checked
  large := pellMagnitudes_7151_large

def pellMagnitudes_7159 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7159

def pellMasks_7159 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7159.map pellLightMasksToOriginal

def pellWitnesses_7159 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7159

theorem pellMasks_7159_valid : ∀ m ∈ pellMasks_7159, m.Valid 7159 := by
  exact pellLightMasks_valid 7159 PellMatchingLightProduction.pellMasks_7159 PellMatchingLightProduction.pellMasks_7159_valid

theorem pellMatching_7159_checked :
    pellMatchingCheck pellMasks_7159 pellMagnitudes_7159 pellWitnesses_7159 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7159
    PellMatchingLightProduction.pellMagnitudes_7159 PellMatchingLightProduction.pellWitnesses_7159).symm.trans
      PellMatchingLightProduction.pellMatching_7159_checked

theorem pellMagnitudes_7159_large : ∀ x ∈ pellMagnitudes_7159, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7159 PellMatchingLightProduction.pellMagnitudes_7159_large

def pellGraphCertificate_7159 : PellMatchingCertificate 7159 where
  magnitudes := pellMagnitudes_7159
  masks := pellMasks_7159
  witnesses := pellWitnesses_7159
  masks_valid := pellMasks_7159_valid
  checked := pellMatching_7159_checked
  large := pellMagnitudes_7159_large

def pellMagnitudes_7199 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7199

def pellMasks_7199 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7199.map pellLightMasksToOriginal

def pellWitnesses_7199 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7199

theorem pellMasks_7199_valid : ∀ m ∈ pellMasks_7199, m.Valid 7199 := by
  exact pellLightMasks_valid 7199 PellMatchingLightProduction.pellMasks_7199 PellMatchingLightProduction.pellMasks_7199_valid

theorem pellMatching_7199_checked :
    pellMatchingCheck pellMasks_7199 pellMagnitudes_7199 pellWitnesses_7199 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7199
    PellMatchingLightProduction.pellMagnitudes_7199 PellMatchingLightProduction.pellWitnesses_7199).symm.trans
      PellMatchingLightProduction.pellMatching_7199_checked

theorem pellMagnitudes_7199_large : ∀ x ∈ pellMagnitudes_7199, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7199 PellMatchingLightProduction.pellMagnitudes_7199_large

def pellGraphCertificate_7199 : PellMatchingCertificate 7199 where
  magnitudes := pellMagnitudes_7199
  masks := pellMasks_7199
  witnesses := pellWitnesses_7199
  masks_valid := pellMasks_7199_valid
  checked := pellMatching_7199_checked
  large := pellMagnitudes_7199_large

def pellMagnitudes_7207 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7207

def pellMasks_7207 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7207.map pellLightMasksToOriginal

def pellWitnesses_7207 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7207

theorem pellMasks_7207_valid : ∀ m ∈ pellMasks_7207, m.Valid 7207 := by
  exact pellLightMasks_valid 7207 PellMatchingLightProduction.pellMasks_7207 PellMatchingLightProduction.pellMasks_7207_valid

theorem pellMatching_7207_checked :
    pellMatchingCheck pellMasks_7207 pellMagnitudes_7207 pellWitnesses_7207 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7207
    PellMatchingLightProduction.pellMagnitudes_7207 PellMatchingLightProduction.pellWitnesses_7207).symm.trans
      PellMatchingLightProduction.pellMatching_7207_checked

theorem pellMagnitudes_7207_large : ∀ x ∈ pellMagnitudes_7207, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7207 PellMatchingLightProduction.pellMagnitudes_7207_large

def pellGraphCertificate_7207 : PellMatchingCertificate 7207 where
  magnitudes := pellMagnitudes_7207
  masks := pellMasks_7207
  witnesses := pellWitnesses_7207
  masks_valid := pellMasks_7207_valid
  checked := pellMatching_7207_checked
  large := pellMagnitudes_7207_large

def pellMagnitudes_7223 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7223

def pellMasks_7223 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7223.map pellLightMasksToOriginal

def pellWitnesses_7223 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7223

theorem pellMasks_7223_valid : ∀ m ∈ pellMasks_7223, m.Valid 7223 := by
  exact pellLightMasks_valid 7223 PellMatchingLightProduction.pellMasks_7223 PellMatchingLightProduction.pellMasks_7223_valid

theorem pellMatching_7223_checked :
    pellMatchingCheck pellMasks_7223 pellMagnitudes_7223 pellWitnesses_7223 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7223
    PellMatchingLightProduction.pellMagnitudes_7223 PellMatchingLightProduction.pellWitnesses_7223).symm.trans
      PellMatchingLightProduction.pellMatching_7223_checked

theorem pellMagnitudes_7223_large : ∀ x ∈ pellMagnitudes_7223, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7223 PellMatchingLightProduction.pellMagnitudes_7223_large

def pellGraphCertificate_7223 : PellMatchingCertificate 7223 where
  magnitudes := pellMagnitudes_7223
  masks := pellMasks_7223
  witnesses := pellWitnesses_7223
  masks_valid := pellMasks_7223_valid
  checked := pellMatching_7223_checked
  large := pellMagnitudes_7223_large

def pellMagnitudes_7247 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7247

def pellMasks_7247 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7247.map pellLightMasksToOriginal

def pellWitnesses_7247 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7247

theorem pellMasks_7247_valid : ∀ m ∈ pellMasks_7247, m.Valid 7247 := by
  exact pellLightMasks_valid 7247 PellMatchingLightProduction.pellMasks_7247 PellMatchingLightProduction.pellMasks_7247_valid

theorem pellMatching_7247_checked :
    pellMatchingCheck pellMasks_7247 pellMagnitudes_7247 pellWitnesses_7247 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7247
    PellMatchingLightProduction.pellMagnitudes_7247 PellMatchingLightProduction.pellWitnesses_7247).symm.trans
      PellMatchingLightProduction.pellMatching_7247_checked

theorem pellMagnitudes_7247_large : ∀ x ∈ pellMagnitudes_7247, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7247 PellMatchingLightProduction.pellMagnitudes_7247_large

def pellGraphCertificate_7247 : PellMatchingCertificate 7247 where
  magnitudes := pellMagnitudes_7247
  masks := pellMasks_7247
  witnesses := pellWitnesses_7247
  masks_valid := pellMasks_7247_valid
  checked := pellMatching_7247_checked
  large := pellMagnitudes_7247_large

def pellMagnitudes_7327 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7327

def pellMasks_7327 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7327.map pellLightMasksToOriginal

def pellWitnesses_7327 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7327

theorem pellMasks_7327_valid : ∀ m ∈ pellMasks_7327, m.Valid 7327 := by
  exact pellLightMasks_valid 7327 PellMatchingLightProduction.pellMasks_7327 PellMatchingLightProduction.pellMasks_7327_valid

theorem pellMatching_7327_checked :
    pellMatchingCheck pellMasks_7327 pellMagnitudes_7327 pellWitnesses_7327 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7327
    PellMatchingLightProduction.pellMagnitudes_7327 PellMatchingLightProduction.pellWitnesses_7327).symm.trans
      PellMatchingLightProduction.pellMatching_7327_checked

theorem pellMagnitudes_7327_large : ∀ x ∈ pellMagnitudes_7327, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7327 PellMatchingLightProduction.pellMagnitudes_7327_large

def pellGraphCertificate_7327 : PellMatchingCertificate 7327 where
  magnitudes := pellMagnitudes_7327
  masks := pellMasks_7327
  witnesses := pellWitnesses_7327
  masks_valid := pellMasks_7327_valid
  checked := pellMatching_7327_checked
  large := pellMagnitudes_7327_large

def pellMagnitudes_7343 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7343

def pellMasks_7343 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7343.map pellLightMasksToOriginal

def pellWitnesses_7343 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7343

theorem pellMasks_7343_valid : ∀ m ∈ pellMasks_7343, m.Valid 7343 := by
  exact pellLightMasks_valid 7343 PellMatchingLightProduction.pellMasks_7343 PellMatchingLightProduction.pellMasks_7343_valid

theorem pellMatching_7343_checked :
    pellMatchingCheck pellMasks_7343 pellMagnitudes_7343 pellWitnesses_7343 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7343
    PellMatchingLightProduction.pellMagnitudes_7343 PellMatchingLightProduction.pellWitnesses_7343).symm.trans
      PellMatchingLightProduction.pellMatching_7343_checked

theorem pellMagnitudes_7343_large : ∀ x ∈ pellMagnitudes_7343, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7343 PellMatchingLightProduction.pellMagnitudes_7343_large

def pellGraphCertificate_7343 : PellMatchingCertificate 7343 where
  magnitudes := pellMagnitudes_7343
  masks := pellMasks_7343
  witnesses := pellWitnesses_7343
  masks_valid := pellMasks_7343_valid
  checked := pellMatching_7343_checked
  large := pellMagnitudes_7343_large

def pellMagnitudes_7351 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7351

def pellMasks_7351 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7351.map pellLightMasksToOriginal

def pellWitnesses_7351 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7351

theorem pellMasks_7351_valid : ∀ m ∈ pellMasks_7351, m.Valid 7351 := by
  exact pellLightMasks_valid 7351 PellMatchingLightProduction.pellMasks_7351 PellMatchingLightProduction.pellMasks_7351_valid

theorem pellMatching_7351_checked :
    pellMatchingCheck pellMasks_7351 pellMagnitudes_7351 pellWitnesses_7351 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7351
    PellMatchingLightProduction.pellMagnitudes_7351 PellMatchingLightProduction.pellWitnesses_7351).symm.trans
      PellMatchingLightProduction.pellMatching_7351_checked

theorem pellMagnitudes_7351_large : ∀ x ∈ pellMagnitudes_7351, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7351 PellMatchingLightProduction.pellMagnitudes_7351_large

def pellGraphCertificate_7351 : PellMatchingCertificate 7351 where
  magnitudes := pellMagnitudes_7351
  masks := pellMasks_7351
  witnesses := pellWitnesses_7351
  masks_valid := pellMasks_7351_valid
  checked := pellMatching_7351_checked
  large := pellMagnitudes_7351_large

def pellMagnitudes_7463 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7463

def pellMasks_7463 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7463.map pellLightMasksToOriginal

def pellWitnesses_7463 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7463

theorem pellMasks_7463_valid : ∀ m ∈ pellMasks_7463, m.Valid 7463 := by
  exact pellLightMasks_valid 7463 PellMatchingLightProduction.pellMasks_7463 PellMatchingLightProduction.pellMasks_7463_valid

theorem pellMatching_7463_checked :
    pellMatchingCheck pellMasks_7463 pellMagnitudes_7463 pellWitnesses_7463 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7463
    PellMatchingLightProduction.pellMagnitudes_7463 PellMatchingLightProduction.pellWitnesses_7463).symm.trans
      PellMatchingLightProduction.pellMatching_7463_checked

theorem pellMagnitudes_7463_large : ∀ x ∈ pellMagnitudes_7463, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7463 PellMatchingLightProduction.pellMagnitudes_7463_large

def pellGraphCertificate_7463 : PellMatchingCertificate 7463 where
  magnitudes := pellMagnitudes_7463
  masks := pellMasks_7463
  witnesses := pellWitnesses_7463
  masks_valid := pellMasks_7463_valid
  checked := pellMatching_7463_checked
  large := pellMagnitudes_7463_large

def pellMagnitudes_7471 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7471

def pellMasks_7471 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7471.map pellLightMasksToOriginal

def pellWitnesses_7471 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7471

theorem pellMasks_7471_valid : ∀ m ∈ pellMasks_7471, m.Valid 7471 := by
  exact pellLightMasks_valid 7471 PellMatchingLightProduction.pellMasks_7471 PellMatchingLightProduction.pellMasks_7471_valid

theorem pellMatching_7471_checked :
    pellMatchingCheck pellMasks_7471 pellMagnitudes_7471 pellWitnesses_7471 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7471
    PellMatchingLightProduction.pellMagnitudes_7471 PellMatchingLightProduction.pellWitnesses_7471).symm.trans
      PellMatchingLightProduction.pellMatching_7471_checked

theorem pellMagnitudes_7471_large : ∀ x ∈ pellMagnitudes_7471, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7471 PellMatchingLightProduction.pellMagnitudes_7471_large

def pellGraphCertificate_7471 : PellMatchingCertificate 7471 where
  magnitudes := pellMagnitudes_7471
  masks := pellMasks_7471
  witnesses := pellWitnesses_7471
  masks_valid := pellMasks_7471_valid
  checked := pellMatching_7471_checked
  large := pellMagnitudes_7471_large

def pellMagnitudes_7487 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7487

def pellMasks_7487 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7487.map pellLightMasksToOriginal

def pellWitnesses_7487 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7487

theorem pellMasks_7487_valid : ∀ m ∈ pellMasks_7487, m.Valid 7487 := by
  exact pellLightMasks_valid 7487 PellMatchingLightProduction.pellMasks_7487 PellMatchingLightProduction.pellMasks_7487_valid

theorem pellMatching_7487_checked :
    pellMatchingCheck pellMasks_7487 pellMagnitudes_7487 pellWitnesses_7487 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7487
    PellMatchingLightProduction.pellMagnitudes_7487 PellMatchingLightProduction.pellWitnesses_7487).symm.trans
      PellMatchingLightProduction.pellMatching_7487_checked

theorem pellMagnitudes_7487_large : ∀ x ∈ pellMagnitudes_7487, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7487 PellMatchingLightProduction.pellMagnitudes_7487_large

def pellGraphCertificate_7487 : PellMatchingCertificate 7487 where
  magnitudes := pellMagnitudes_7487
  masks := pellMasks_7487
  witnesses := pellWitnesses_7487
  masks_valid := pellMasks_7487_valid
  checked := pellMatching_7487_checked
  large := pellMagnitudes_7487_large

def pellMagnitudes_7519 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7519

def pellMasks_7519 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7519.map pellLightMasksToOriginal

def pellWitnesses_7519 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7519

theorem pellMasks_7519_valid : ∀ m ∈ pellMasks_7519, m.Valid 7519 := by
  exact pellLightMasks_valid 7519 PellMatchingLightProduction.pellMasks_7519 PellMatchingLightProduction.pellMasks_7519_valid

theorem pellMatching_7519_checked :
    pellMatchingCheck pellMasks_7519 pellMagnitudes_7519 pellWitnesses_7519 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7519
    PellMatchingLightProduction.pellMagnitudes_7519 PellMatchingLightProduction.pellWitnesses_7519).symm.trans
      PellMatchingLightProduction.pellMatching_7519_checked

theorem pellMagnitudes_7519_large : ∀ x ∈ pellMagnitudes_7519, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7519 PellMatchingLightProduction.pellMagnitudes_7519_large

def pellGraphCertificate_7519 : PellMatchingCertificate 7519 where
  magnitudes := pellMagnitudes_7519
  masks := pellMasks_7519
  witnesses := pellWitnesses_7519
  masks_valid := pellMasks_7519_valid
  checked := pellMatching_7519_checked
  large := pellMagnitudes_7519_large

def pellMagnitudes_7559 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7559

def pellMasks_7559 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7559.map pellLightMasksToOriginal

def pellWitnesses_7559 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7559

theorem pellMasks_7559_valid : ∀ m ∈ pellMasks_7559, m.Valid 7559 := by
  exact pellLightMasks_valid 7559 PellMatchingLightProduction.pellMasks_7559 PellMatchingLightProduction.pellMasks_7559_valid

theorem pellMatching_7559_checked :
    pellMatchingCheck pellMasks_7559 pellMagnitudes_7559 pellWitnesses_7559 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7559
    PellMatchingLightProduction.pellMagnitudes_7559 PellMatchingLightProduction.pellWitnesses_7559).symm.trans
      PellMatchingLightProduction.pellMatching_7559_checked

theorem pellMagnitudes_7559_large : ∀ x ∈ pellMagnitudes_7559, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7559 PellMatchingLightProduction.pellMagnitudes_7559_large

def pellGraphCertificate_7559 : PellMatchingCertificate 7559 where
  magnitudes := pellMagnitudes_7559
  masks := pellMasks_7559
  witnesses := pellWitnesses_7559
  masks_valid := pellMasks_7559_valid
  checked := pellMatching_7559_checked
  large := pellMagnitudes_7559_large

def pellMagnitudes_7567 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7567

def pellMasks_7567 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7567.map pellLightMasksToOriginal

def pellWitnesses_7567 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7567

theorem pellMasks_7567_valid : ∀ m ∈ pellMasks_7567, m.Valid 7567 := by
  exact pellLightMasks_valid 7567 PellMatchingLightProduction.pellMasks_7567 PellMatchingLightProduction.pellMasks_7567_valid

theorem pellMatching_7567_checked :
    pellMatchingCheck pellMasks_7567 pellMagnitudes_7567 pellWitnesses_7567 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7567
    PellMatchingLightProduction.pellMagnitudes_7567 PellMatchingLightProduction.pellWitnesses_7567).symm.trans
      PellMatchingLightProduction.pellMatching_7567_checked

theorem pellMagnitudes_7567_large : ∀ x ∈ pellMagnitudes_7567, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7567 PellMatchingLightProduction.pellMagnitudes_7567_large

def pellGraphCertificate_7567 : PellMatchingCertificate 7567 where
  magnitudes := pellMagnitudes_7567
  masks := pellMasks_7567
  witnesses := pellWitnesses_7567
  masks_valid := pellMasks_7567_valid
  checked := pellMatching_7567_checked
  large := pellMagnitudes_7567_large

def pellMagnitudes_7583 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7583

def pellMasks_7583 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7583.map pellLightMasksToOriginal

def pellWitnesses_7583 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7583

theorem pellMasks_7583_valid : ∀ m ∈ pellMasks_7583, m.Valid 7583 := by
  exact pellLightMasks_valid 7583 PellMatchingLightProduction.pellMasks_7583 PellMatchingLightProduction.pellMasks_7583_valid

theorem pellMatching_7583_checked :
    pellMatchingCheck pellMasks_7583 pellMagnitudes_7583 pellWitnesses_7583 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7583
    PellMatchingLightProduction.pellMagnitudes_7583 PellMatchingLightProduction.pellWitnesses_7583).symm.trans
      PellMatchingLightProduction.pellMatching_7583_checked

theorem pellMagnitudes_7583_large : ∀ x ∈ pellMagnitudes_7583, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7583 PellMatchingLightProduction.pellMagnitudes_7583_large

def pellGraphCertificate_7583 : PellMatchingCertificate 7583 where
  magnitudes := pellMagnitudes_7583
  masks := pellMasks_7583
  witnesses := pellWitnesses_7583
  masks_valid := pellMasks_7583_valid
  checked := pellMatching_7583_checked
  large := pellMagnitudes_7583_large

def pellMagnitudes_7591 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7591

def pellMasks_7591 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7591.map pellLightMasksToOriginal

def pellWitnesses_7591 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7591

theorem pellMasks_7591_valid : ∀ m ∈ pellMasks_7591, m.Valid 7591 := by
  exact pellLightMasks_valid 7591 PellMatchingLightProduction.pellMasks_7591 PellMatchingLightProduction.pellMasks_7591_valid

theorem pellMatching_7591_checked :
    pellMatchingCheck pellMasks_7591 pellMagnitudes_7591 pellWitnesses_7591 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7591
    PellMatchingLightProduction.pellMagnitudes_7591 PellMatchingLightProduction.pellWitnesses_7591).symm.trans
      PellMatchingLightProduction.pellMatching_7591_checked

theorem pellMagnitudes_7591_large : ∀ x ∈ pellMagnitudes_7591, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7591 PellMatchingLightProduction.pellMagnitudes_7591_large

def pellGraphCertificate_7591 : PellMatchingCertificate 7591 where
  magnitudes := pellMagnitudes_7591
  masks := pellMasks_7591
  witnesses := pellWitnesses_7591
  masks_valid := pellMasks_7591_valid
  checked := pellMatching_7591_checked
  large := pellMagnitudes_7591_large

def pellMagnitudes_7607 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7607

def pellMasks_7607 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7607.map pellLightMasksToOriginal

def pellWitnesses_7607 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7607

theorem pellMasks_7607_valid : ∀ m ∈ pellMasks_7607, m.Valid 7607 := by
  exact pellLightMasks_valid 7607 PellMatchingLightProduction.pellMasks_7607 PellMatchingLightProduction.pellMasks_7607_valid

theorem pellMatching_7607_checked :
    pellMatchingCheck pellMasks_7607 pellMagnitudes_7607 pellWitnesses_7607 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7607
    PellMatchingLightProduction.pellMagnitudes_7607 PellMatchingLightProduction.pellWitnesses_7607).symm.trans
      PellMatchingLightProduction.pellMatching_7607_checked

theorem pellMagnitudes_7607_large : ∀ x ∈ pellMagnitudes_7607, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7607 PellMatchingLightProduction.pellMagnitudes_7607_large

def pellGraphCertificate_7607 : PellMatchingCertificate 7607 where
  magnitudes := pellMagnitudes_7607
  masks := pellMasks_7607
  witnesses := pellWitnesses_7607
  masks_valid := pellMasks_7607_valid
  checked := pellMatching_7607_checked
  large := pellMagnitudes_7607_large

def pellMagnitudes_7639 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7639

def pellMasks_7639 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7639.map pellLightMasksToOriginal

def pellWitnesses_7639 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7639

theorem pellMasks_7639_valid : ∀ m ∈ pellMasks_7639, m.Valid 7639 := by
  exact pellLightMasks_valid 7639 PellMatchingLightProduction.pellMasks_7639 PellMatchingLightProduction.pellMasks_7639_valid

theorem pellMatching_7639_checked :
    pellMatchingCheck pellMasks_7639 pellMagnitudes_7639 pellWitnesses_7639 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7639
    PellMatchingLightProduction.pellMagnitudes_7639 PellMatchingLightProduction.pellWitnesses_7639).symm.trans
      PellMatchingLightProduction.pellMatching_7639_checked

theorem pellMagnitudes_7639_large : ∀ x ∈ pellMagnitudes_7639, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7639 PellMatchingLightProduction.pellMagnitudes_7639_large

def pellGraphCertificate_7639 : PellMatchingCertificate 7639 where
  magnitudes := pellMagnitudes_7639
  masks := pellMasks_7639
  witnesses := pellWitnesses_7639
  masks_valid := pellMasks_7639_valid
  checked := pellMatching_7639_checked
  large := pellMagnitudes_7639_large

def pellMagnitudes_7679 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7679

def pellMasks_7679 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7679.map pellLightMasksToOriginal

def pellWitnesses_7679 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7679

theorem pellMasks_7679_valid : ∀ m ∈ pellMasks_7679, m.Valid 7679 := by
  exact pellLightMasks_valid 7679 PellMatchingLightProduction.pellMasks_7679 PellMatchingLightProduction.pellMasks_7679_valid

theorem pellMatching_7679_checked :
    pellMatchingCheck pellMasks_7679 pellMagnitudes_7679 pellWitnesses_7679 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7679
    PellMatchingLightProduction.pellMagnitudes_7679 PellMatchingLightProduction.pellWitnesses_7679).symm.trans
      PellMatchingLightProduction.pellMatching_7679_checked

theorem pellMagnitudes_7679_large : ∀ x ∈ pellMagnitudes_7679, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7679 PellMatchingLightProduction.pellMagnitudes_7679_large

def pellGraphCertificate_7679 : PellMatchingCertificate 7679 where
  magnitudes := pellMagnitudes_7679
  masks := pellMasks_7679
  witnesses := pellWitnesses_7679
  masks_valid := pellMasks_7679_valid
  checked := pellMatching_7679_checked
  large := pellMagnitudes_7679_large

def pellMagnitudes_7687 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7687

def pellMasks_7687 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7687.map pellLightMasksToOriginal

def pellWitnesses_7687 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7687

theorem pellMasks_7687_valid : ∀ m ∈ pellMasks_7687, m.Valid 7687 := by
  exact pellLightMasks_valid 7687 PellMatchingLightProduction.pellMasks_7687 PellMatchingLightProduction.pellMasks_7687_valid

theorem pellMatching_7687_checked :
    pellMatchingCheck pellMasks_7687 pellMagnitudes_7687 pellWitnesses_7687 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7687
    PellMatchingLightProduction.pellMagnitudes_7687 PellMatchingLightProduction.pellWitnesses_7687).symm.trans
      PellMatchingLightProduction.pellMatching_7687_checked

theorem pellMagnitudes_7687_large : ∀ x ∈ pellMagnitudes_7687, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7687 PellMatchingLightProduction.pellMagnitudes_7687_large

def pellGraphCertificate_7687 : PellMatchingCertificate 7687 where
  magnitudes := pellMagnitudes_7687
  masks := pellMasks_7687
  witnesses := pellWitnesses_7687
  masks_valid := pellMasks_7687_valid
  checked := pellMatching_7687_checked
  large := pellMagnitudes_7687_large

def pellMagnitudes_7703 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7703

def pellMasks_7703 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7703.map pellLightMasksToOriginal

def pellWitnesses_7703 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7703

theorem pellMasks_7703_valid : ∀ m ∈ pellMasks_7703, m.Valid 7703 := by
  exact pellLightMasks_valid 7703 PellMatchingLightProduction.pellMasks_7703 PellMatchingLightProduction.pellMasks_7703_valid

theorem pellMatching_7703_checked :
    pellMatchingCheck pellMasks_7703 pellMagnitudes_7703 pellWitnesses_7703 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7703
    PellMatchingLightProduction.pellMagnitudes_7703 PellMatchingLightProduction.pellWitnesses_7703).symm.trans
      PellMatchingLightProduction.pellMatching_7703_checked

theorem pellMagnitudes_7703_large : ∀ x ∈ pellMagnitudes_7703, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7703 PellMatchingLightProduction.pellMagnitudes_7703_large

def pellGraphCertificate_7703 : PellMatchingCertificate 7703 where
  magnitudes := pellMagnitudes_7703
  masks := pellMasks_7703
  witnesses := pellWitnesses_7703
  masks_valid := pellMasks_7703_valid
  checked := pellMatching_7703_checked
  large := pellMagnitudes_7703_large

def pellMagnitudes_7727 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7727

def pellMasks_7727 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7727.map pellLightMasksToOriginal

def pellWitnesses_7727 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7727

theorem pellMasks_7727_valid : ∀ m ∈ pellMasks_7727, m.Valid 7727 := by
  exact pellLightMasks_valid 7727 PellMatchingLightProduction.pellMasks_7727 PellMatchingLightProduction.pellMasks_7727_valid

theorem pellMatching_7727_checked :
    pellMatchingCheck pellMasks_7727 pellMagnitudes_7727 pellWitnesses_7727 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7727
    PellMatchingLightProduction.pellMagnitudes_7727 PellMatchingLightProduction.pellWitnesses_7727).symm.trans
      PellMatchingLightProduction.pellMatching_7727_checked

theorem pellMagnitudes_7727_large : ∀ x ∈ pellMagnitudes_7727, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7727 PellMatchingLightProduction.pellMagnitudes_7727_large

def pellGraphCertificate_7727 : PellMatchingCertificate 7727 where
  magnitudes := pellMagnitudes_7727
  masks := pellMasks_7727
  witnesses := pellWitnesses_7727
  masks_valid := pellMasks_7727_valid
  checked := pellMatching_7727_checked
  large := pellMagnitudes_7727_large

def pellMagnitudes_7751 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7751

def pellMasks_7751 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7751.map pellLightMasksToOriginal

def pellWitnesses_7751 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7751

theorem pellMasks_7751_valid : ∀ m ∈ pellMasks_7751, m.Valid 7751 := by
  exact pellLightMasks_valid 7751 PellMatchingLightProduction.pellMasks_7751 PellMatchingLightProduction.pellMasks_7751_valid

theorem pellMatching_7751_checked :
    pellMatchingCheck pellMasks_7751 pellMagnitudes_7751 pellWitnesses_7751 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7751
    PellMatchingLightProduction.pellMagnitudes_7751 PellMatchingLightProduction.pellWitnesses_7751).symm.trans
      PellMatchingLightProduction.pellMatching_7751_checked

theorem pellMagnitudes_7751_large : ∀ x ∈ pellMagnitudes_7751, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7751 PellMatchingLightProduction.pellMagnitudes_7751_large

def pellGraphCertificate_7751 : PellMatchingCertificate 7751 where
  magnitudes := pellMagnitudes_7751
  masks := pellMasks_7751
  witnesses := pellWitnesses_7751
  masks_valid := pellMasks_7751_valid
  checked := pellMatching_7751_checked
  large := pellMagnitudes_7751_large

def pellMagnitudes_7759 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7759

def pellMasks_7759 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7759.map pellLightMasksToOriginal

def pellWitnesses_7759 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7759

theorem pellMasks_7759_valid : ∀ m ∈ pellMasks_7759, m.Valid 7759 := by
  exact pellLightMasks_valid 7759 PellMatchingLightProduction.pellMasks_7759 PellMatchingLightProduction.pellMasks_7759_valid

theorem pellMatching_7759_checked :
    pellMatchingCheck pellMasks_7759 pellMagnitudes_7759 pellWitnesses_7759 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7759
    PellMatchingLightProduction.pellMagnitudes_7759 PellMatchingLightProduction.pellWitnesses_7759).symm.trans
      PellMatchingLightProduction.pellMatching_7759_checked

theorem pellMagnitudes_7759_large : ∀ x ∈ pellMagnitudes_7759, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7759 PellMatchingLightProduction.pellMagnitudes_7759_large

def pellGraphCertificate_7759 : PellMatchingCertificate 7759 where
  magnitudes := pellMagnitudes_7759
  masks := pellMasks_7759
  witnesses := pellWitnesses_7759
  masks_valid := pellMasks_7759_valid
  checked := pellMatching_7759_checked
  large := pellMagnitudes_7759_large

def pellMagnitudes_7823 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7823

def pellMasks_7823 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7823.map pellLightMasksToOriginal

def pellWitnesses_7823 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7823

theorem pellMasks_7823_valid : ∀ m ∈ pellMasks_7823, m.Valid 7823 := by
  exact pellLightMasks_valid 7823 PellMatchingLightProduction.pellMasks_7823 PellMatchingLightProduction.pellMasks_7823_valid

theorem pellMatching_7823_checked :
    pellMatchingCheck pellMasks_7823 pellMagnitudes_7823 pellWitnesses_7823 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7823
    PellMatchingLightProduction.pellMagnitudes_7823 PellMatchingLightProduction.pellWitnesses_7823).symm.trans
      PellMatchingLightProduction.pellMatching_7823_checked

theorem pellMagnitudes_7823_large : ∀ x ∈ pellMagnitudes_7823, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7823 PellMatchingLightProduction.pellMagnitudes_7823_large

def pellGraphCertificate_7823 : PellMatchingCertificate 7823 where
  magnitudes := pellMagnitudes_7823
  masks := pellMasks_7823
  witnesses := pellWitnesses_7823
  masks_valid := pellMasks_7823_valid
  checked := pellMatching_7823_checked
  large := pellMagnitudes_7823_large

def pellMagnitudes_7831 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7831

def pellMasks_7831 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7831.map pellLightMasksToOriginal

def pellWitnesses_7831 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7831

theorem pellMasks_7831_valid : ∀ m ∈ pellMasks_7831, m.Valid 7831 := by
  exact pellLightMasks_valid 7831 PellMatchingLightProduction.pellMasks_7831 PellMatchingLightProduction.pellMasks_7831_valid

theorem pellMatching_7831_checked :
    pellMatchingCheck pellMasks_7831 pellMagnitudes_7831 pellWitnesses_7831 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7831
    PellMatchingLightProduction.pellMagnitudes_7831 PellMatchingLightProduction.pellWitnesses_7831).symm.trans
      PellMatchingLightProduction.pellMatching_7831_checked

theorem pellMagnitudes_7831_large : ∀ x ∈ pellMagnitudes_7831, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7831 PellMatchingLightProduction.pellMagnitudes_7831_large

def pellGraphCertificate_7831 : PellMatchingCertificate 7831 where
  magnitudes := pellMagnitudes_7831
  masks := pellMasks_7831
  witnesses := pellWitnesses_7831
  masks_valid := pellMasks_7831_valid
  checked := pellMatching_7831_checked
  large := pellMagnitudes_7831_large

def pellMagnitudes_7879 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7879

def pellMasks_7879 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7879.map pellLightMasksToOriginal

def pellWitnesses_7879 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7879

theorem pellMasks_7879_valid : ∀ m ∈ pellMasks_7879, m.Valid 7879 := by
  exact pellLightMasks_valid 7879 PellMatchingLightProduction.pellMasks_7879 PellMatchingLightProduction.pellMasks_7879_valid

theorem pellMatching_7879_checked :
    pellMatchingCheck pellMasks_7879 pellMagnitudes_7879 pellWitnesses_7879 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7879
    PellMatchingLightProduction.pellMagnitudes_7879 PellMatchingLightProduction.pellWitnesses_7879).symm.trans
      PellMatchingLightProduction.pellMatching_7879_checked

theorem pellMagnitudes_7879_large : ∀ x ∈ pellMagnitudes_7879, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7879 PellMatchingLightProduction.pellMagnitudes_7879_large

def pellGraphCertificate_7879 : PellMatchingCertificate 7879 where
  magnitudes := pellMagnitudes_7879
  masks := pellMasks_7879
  witnesses := pellWitnesses_7879
  masks_valid := pellMasks_7879_valid
  checked := pellMatching_7879_checked
  large := pellMagnitudes_7879_large

def pellMagnitudes_7903 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7903

def pellMasks_7903 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7903.map pellLightMasksToOriginal

def pellWitnesses_7903 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7903

theorem pellMasks_7903_valid : ∀ m ∈ pellMasks_7903, m.Valid 7903 := by
  exact pellLightMasks_valid 7903 PellMatchingLightProduction.pellMasks_7903 PellMatchingLightProduction.pellMasks_7903_valid

theorem pellMatching_7903_checked :
    pellMatchingCheck pellMasks_7903 pellMagnitudes_7903 pellWitnesses_7903 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7903
    PellMatchingLightProduction.pellMagnitudes_7903 PellMatchingLightProduction.pellWitnesses_7903).symm.trans
      PellMatchingLightProduction.pellMatching_7903_checked

theorem pellMagnitudes_7903_large : ∀ x ∈ pellMagnitudes_7903, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7903 PellMatchingLightProduction.pellMagnitudes_7903_large

def pellGraphCertificate_7903 : PellMatchingCertificate 7903 where
  magnitudes := pellMagnitudes_7903
  masks := pellMasks_7903
  witnesses := pellWitnesses_7903
  masks_valid := pellMasks_7903_valid
  checked := pellMatching_7903_checked
  large := pellMagnitudes_7903_large

def pellMagnitudes_7919 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7919

def pellMasks_7919 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7919.map pellLightMasksToOriginal

def pellWitnesses_7919 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7919

theorem pellMasks_7919_valid : ∀ m ∈ pellMasks_7919, m.Valid 7919 := by
  exact pellLightMasks_valid 7919 PellMatchingLightProduction.pellMasks_7919 PellMatchingLightProduction.pellMasks_7919_valid

theorem pellMatching_7919_checked :
    pellMatchingCheck pellMasks_7919 pellMagnitudes_7919 pellWitnesses_7919 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7919
    PellMatchingLightProduction.pellMagnitudes_7919 PellMatchingLightProduction.pellWitnesses_7919).symm.trans
      PellMatchingLightProduction.pellMatching_7919_checked

theorem pellMagnitudes_7919_large : ∀ x ∈ pellMagnitudes_7919, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7919 PellMatchingLightProduction.pellMagnitudes_7919_large

def pellGraphCertificate_7919 : PellMatchingCertificate 7919 where
  magnitudes := pellMagnitudes_7919
  masks := pellMasks_7919
  witnesses := pellWitnesses_7919
  masks_valid := pellMasks_7919_valid
  checked := pellMatching_7919_checked
  large := pellMagnitudes_7919_large

def pellMagnitudes_7927 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7927

def pellMasks_7927 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7927.map pellLightMasksToOriginal

def pellWitnesses_7927 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7927

theorem pellMasks_7927_valid : ∀ m ∈ pellMasks_7927, m.Valid 7927 := by
  exact pellLightMasks_valid 7927 PellMatchingLightProduction.pellMasks_7927 PellMatchingLightProduction.pellMasks_7927_valid

theorem pellMatching_7927_checked :
    pellMatchingCheck pellMasks_7927 pellMagnitudes_7927 pellWitnesses_7927 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7927
    PellMatchingLightProduction.pellMagnitudes_7927 PellMatchingLightProduction.pellWitnesses_7927).symm.trans
      PellMatchingLightProduction.pellMatching_7927_checked

theorem pellMagnitudes_7927_large : ∀ x ∈ pellMagnitudes_7927, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7927 PellMatchingLightProduction.pellMagnitudes_7927_large

def pellGraphCertificate_7927 : PellMatchingCertificate 7927 where
  magnitudes := pellMagnitudes_7927
  masks := pellMasks_7927
  witnesses := pellWitnesses_7927
  masks_valid := pellMasks_7927_valid
  checked := pellMatching_7927_checked
  large := pellMagnitudes_7927_large

def pellMagnitudes_7951 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7951

def pellMasks_7951 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7951.map pellLightMasksToOriginal

def pellWitnesses_7951 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7951

theorem pellMasks_7951_valid : ∀ m ∈ pellMasks_7951, m.Valid 7951 := by
  exact pellLightMasks_valid 7951 PellMatchingLightProduction.pellMasks_7951 PellMatchingLightProduction.pellMasks_7951_valid

theorem pellMatching_7951_checked :
    pellMatchingCheck pellMasks_7951 pellMagnitudes_7951 pellWitnesses_7951 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7951
    PellMatchingLightProduction.pellMagnitudes_7951 PellMatchingLightProduction.pellWitnesses_7951).symm.trans
      PellMatchingLightProduction.pellMatching_7951_checked

theorem pellMagnitudes_7951_large : ∀ x ∈ pellMagnitudes_7951, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7951 PellMatchingLightProduction.pellMagnitudes_7951_large

def pellGraphCertificate_7951 : PellMatchingCertificate 7951 where
  magnitudes := pellMagnitudes_7951
  masks := pellMasks_7951
  witnesses := pellWitnesses_7951
  masks_valid := pellMasks_7951_valid
  checked := pellMatching_7951_checked
  large := pellMagnitudes_7951_large

def pellMagnitudes_7967 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_7967

def pellMasks_7967 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_7967.map pellLightMasksToOriginal

def pellWitnesses_7967 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_7967

theorem pellMasks_7967_valid : ∀ m ∈ pellMasks_7967, m.Valid 7967 := by
  exact pellLightMasks_valid 7967 PellMatchingLightProduction.pellMasks_7967 PellMatchingLightProduction.pellMasks_7967_valid

theorem pellMatching_7967_checked :
    pellMatchingCheck pellMasks_7967 pellMagnitudes_7967 pellWitnesses_7967 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_7967
    PellMatchingLightProduction.pellMagnitudes_7967 PellMatchingLightProduction.pellWitnesses_7967).symm.trans
      PellMatchingLightProduction.pellMatching_7967_checked

theorem pellMagnitudes_7967_large : ∀ x ∈ pellMagnitudes_7967, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_7967 PellMatchingLightProduction.pellMagnitudes_7967_large

def pellGraphCertificate_7967 : PellMatchingCertificate 7967 where
  magnitudes := pellMagnitudes_7967
  masks := pellMasks_7967
  witnesses := pellWitnesses_7967
  masks_valid := pellMasks_7967_valid
  checked := pellMatching_7967_checked
  large := pellMagnitudes_7967_large

def pellMagnitudes_8023 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8023

def pellMasks_8023 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8023.map pellLightMasksToOriginal

def pellWitnesses_8023 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8023

theorem pellMasks_8023_valid : ∀ m ∈ pellMasks_8023, m.Valid 8023 := by
  exact pellLightMasks_valid 8023 PellMatchingLightProduction.pellMasks_8023 PellMatchingLightProduction.pellMasks_8023_valid

theorem pellMatching_8023_checked :
    pellMatchingCheck pellMasks_8023 pellMagnitudes_8023 pellWitnesses_8023 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8023
    PellMatchingLightProduction.pellMagnitudes_8023 PellMatchingLightProduction.pellWitnesses_8023).symm.trans
      PellMatchingLightProduction.pellMatching_8023_checked

theorem pellMagnitudes_8023_large : ∀ x ∈ pellMagnitudes_8023, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8023 PellMatchingLightProduction.pellMagnitudes_8023_large

def pellGraphCertificate_8023 : PellMatchingCertificate 8023 where
  magnitudes := pellMagnitudes_8023
  masks := pellMasks_8023
  witnesses := pellWitnesses_8023
  masks_valid := pellMasks_8023_valid
  checked := pellMatching_8023_checked
  large := pellMagnitudes_8023_large

def pellMagnitudes_8039 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8039

def pellMasks_8039 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8039.map pellLightMasksToOriginal

def pellWitnesses_8039 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8039

theorem pellMasks_8039_valid : ∀ m ∈ pellMasks_8039, m.Valid 8039 := by
  exact pellLightMasks_valid 8039 PellMatchingLightProduction.pellMasks_8039 PellMatchingLightProduction.pellMasks_8039_valid

theorem pellMatching_8039_checked :
    pellMatchingCheck pellMasks_8039 pellMagnitudes_8039 pellWitnesses_8039 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8039
    PellMatchingLightProduction.pellMagnitudes_8039 PellMatchingLightProduction.pellWitnesses_8039).symm.trans
      PellMatchingLightProduction.pellMatching_8039_checked

theorem pellMagnitudes_8039_large : ∀ x ∈ pellMagnitudes_8039, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8039 PellMatchingLightProduction.pellMagnitudes_8039_large

def pellGraphCertificate_8039 : PellMatchingCertificate 8039 where
  magnitudes := pellMagnitudes_8039
  masks := pellMasks_8039
  witnesses := pellWitnesses_8039
  masks_valid := pellMasks_8039_valid
  checked := pellMatching_8039_checked
  large := pellMagnitudes_8039_large

def pellMagnitudes_8071 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8071

def pellMasks_8071 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8071.map pellLightMasksToOriginal

def pellWitnesses_8071 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8071

theorem pellMasks_8071_valid : ∀ m ∈ pellMasks_8071, m.Valid 8071 := by
  exact pellLightMasks_valid 8071 PellMatchingLightProduction.pellMasks_8071 PellMatchingLightProduction.pellMasks_8071_valid

theorem pellMatching_8071_checked :
    pellMatchingCheck pellMasks_8071 pellMagnitudes_8071 pellWitnesses_8071 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8071
    PellMatchingLightProduction.pellMagnitudes_8071 PellMatchingLightProduction.pellWitnesses_8071).symm.trans
      PellMatchingLightProduction.pellMatching_8071_checked

theorem pellMagnitudes_8071_large : ∀ x ∈ pellMagnitudes_8071, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8071 PellMatchingLightProduction.pellMagnitudes_8071_large

def pellGraphCertificate_8071 : PellMatchingCertificate 8071 where
  magnitudes := pellMagnitudes_8071
  masks := pellMasks_8071
  witnesses := pellWitnesses_8071
  masks_valid := pellMasks_8071_valid
  checked := pellMatching_8071_checked
  large := pellMagnitudes_8071_large

def pellMagnitudes_8087 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8087

def pellMasks_8087 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8087.map pellLightMasksToOriginal

def pellWitnesses_8087 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8087

theorem pellMasks_8087_valid : ∀ m ∈ pellMasks_8087, m.Valid 8087 := by
  exact pellLightMasks_valid 8087 PellMatchingLightProduction.pellMasks_8087 PellMatchingLightProduction.pellMasks_8087_valid

theorem pellMatching_8087_checked :
    pellMatchingCheck pellMasks_8087 pellMagnitudes_8087 pellWitnesses_8087 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8087
    PellMatchingLightProduction.pellMagnitudes_8087 PellMatchingLightProduction.pellWitnesses_8087).symm.trans
      PellMatchingLightProduction.pellMatching_8087_checked

theorem pellMagnitudes_8087_large : ∀ x ∈ pellMagnitudes_8087, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8087 PellMatchingLightProduction.pellMagnitudes_8087_large

def pellGraphCertificate_8087 : PellMatchingCertificate 8087 where
  magnitudes := pellMagnitudes_8087
  masks := pellMasks_8087
  witnesses := pellWitnesses_8087
  masks_valid := pellMasks_8087_valid
  checked := pellMatching_8087_checked
  large := pellMagnitudes_8087_large

def pellMagnitudes_8111 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8111

def pellMasks_8111 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8111.map pellLightMasksToOriginal

def pellWitnesses_8111 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8111

theorem pellMasks_8111_valid : ∀ m ∈ pellMasks_8111, m.Valid 8111 := by
  exact pellLightMasks_valid 8111 PellMatchingLightProduction.pellMasks_8111 PellMatchingLightProduction.pellMasks_8111_valid

theorem pellMatching_8111_checked :
    pellMatchingCheck pellMasks_8111 pellMagnitudes_8111 pellWitnesses_8111 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8111
    PellMatchingLightProduction.pellMagnitudes_8111 PellMatchingLightProduction.pellWitnesses_8111).symm.trans
      PellMatchingLightProduction.pellMatching_8111_checked

theorem pellMagnitudes_8111_large : ∀ x ∈ pellMagnitudes_8111, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8111 PellMatchingLightProduction.pellMagnitudes_8111_large

def pellGraphCertificate_8111 : PellMatchingCertificate 8111 where
  magnitudes := pellMagnitudes_8111
  masks := pellMasks_8111
  witnesses := pellWitnesses_8111
  masks_valid := pellMasks_8111_valid
  checked := pellMatching_8111_checked
  large := pellMagnitudes_8111_large

def pellMagnitudes_8119 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8119

def pellMasks_8119 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8119.map pellLightMasksToOriginal

def pellWitnesses_8119 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8119

theorem pellMasks_8119_valid : ∀ m ∈ pellMasks_8119, m.Valid 8119 := by
  exact pellLightMasks_valid 8119 PellMatchingLightProduction.pellMasks_8119 PellMatchingLightProduction.pellMasks_8119_valid

theorem pellMatching_8119_checked :
    pellMatchingCheck pellMasks_8119 pellMagnitudes_8119 pellWitnesses_8119 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8119
    PellMatchingLightProduction.pellMagnitudes_8119 PellMatchingLightProduction.pellWitnesses_8119).symm.trans
      PellMatchingLightProduction.pellMatching_8119_checked

theorem pellMagnitudes_8119_large : ∀ x ∈ pellMagnitudes_8119, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8119 PellMatchingLightProduction.pellMagnitudes_8119_large

def pellGraphCertificate_8119 : PellMatchingCertificate 8119 where
  magnitudes := pellMagnitudes_8119
  masks := pellMasks_8119
  witnesses := pellWitnesses_8119
  masks_valid := pellMasks_8119_valid
  checked := pellMatching_8119_checked
  large := pellMagnitudes_8119_large

def pellMagnitudes_8143 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8143

def pellMasks_8143 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8143.map pellLightMasksToOriginal

def pellWitnesses_8143 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8143

theorem pellMasks_8143_valid : ∀ m ∈ pellMasks_8143, m.Valid 8143 := by
  exact pellLightMasks_valid 8143 PellMatchingLightProduction.pellMasks_8143 PellMatchingLightProduction.pellMasks_8143_valid

theorem pellMatching_8143_checked :
    pellMatchingCheck pellMasks_8143 pellMagnitudes_8143 pellWitnesses_8143 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8143
    PellMatchingLightProduction.pellMagnitudes_8143 PellMatchingLightProduction.pellWitnesses_8143).symm.trans
      PellMatchingLightProduction.pellMatching_8143_checked

theorem pellMagnitudes_8143_large : ∀ x ∈ pellMagnitudes_8143, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8143 PellMatchingLightProduction.pellMagnitudes_8143_large

def pellGraphCertificate_8143 : PellMatchingCertificate 8143 where
  magnitudes := pellMagnitudes_8143
  masks := pellMasks_8143
  witnesses := pellWitnesses_8143
  masks_valid := pellMasks_8143_valid
  checked := pellMatching_8143_checked
  large := pellMagnitudes_8143_large

def pellMagnitudes_8159 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8159

def pellMasks_8159 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8159.map pellLightMasksToOriginal

def pellWitnesses_8159 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8159

theorem pellMasks_8159_valid : ∀ m ∈ pellMasks_8159, m.Valid 8159 := by
  exact pellLightMasks_valid 8159 PellMatchingLightProduction.pellMasks_8159 PellMatchingLightProduction.pellMasks_8159_valid

theorem pellMatching_8159_checked :
    pellMatchingCheck pellMasks_8159 pellMagnitudes_8159 pellWitnesses_8159 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8159
    PellMatchingLightProduction.pellMagnitudes_8159 PellMatchingLightProduction.pellWitnesses_8159).symm.trans
      PellMatchingLightProduction.pellMatching_8159_checked

theorem pellMagnitudes_8159_large : ∀ x ∈ pellMagnitudes_8159, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8159 PellMatchingLightProduction.pellMagnitudes_8159_large

def pellGraphCertificate_8159 : PellMatchingCertificate 8159 where
  magnitudes := pellMagnitudes_8159
  masks := pellMasks_8159
  witnesses := pellWitnesses_8159
  masks_valid := pellMasks_8159_valid
  checked := pellMatching_8159_checked
  large := pellMagnitudes_8159_large

def pellMagnitudes_8167 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8167

def pellMasks_8167 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8167.map pellLightMasksToOriginal

def pellWitnesses_8167 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8167

theorem pellMasks_8167_valid : ∀ m ∈ pellMasks_8167, m.Valid 8167 := by
  exact pellLightMasks_valid 8167 PellMatchingLightProduction.pellMasks_8167 PellMatchingLightProduction.pellMasks_8167_valid

theorem pellMatching_8167_checked :
    pellMatchingCheck pellMasks_8167 pellMagnitudes_8167 pellWitnesses_8167 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8167
    PellMatchingLightProduction.pellMagnitudes_8167 PellMatchingLightProduction.pellWitnesses_8167).symm.trans
      PellMatchingLightProduction.pellMatching_8167_checked

theorem pellMagnitudes_8167_large : ∀ x ∈ pellMagnitudes_8167, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8167 PellMatchingLightProduction.pellMagnitudes_8167_large

def pellGraphCertificate_8167 : PellMatchingCertificate 8167 where
  magnitudes := pellMagnitudes_8167
  masks := pellMasks_8167
  witnesses := pellWitnesses_8167
  masks_valid := pellMasks_8167_valid
  checked := pellMatching_8167_checked
  large := pellMagnitudes_8167_large

def pellMagnitudes_8191 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8191

def pellMasks_8191 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8191.map pellLightMasksToOriginal

def pellWitnesses_8191 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8191

theorem pellMasks_8191_valid : ∀ m ∈ pellMasks_8191, m.Valid 8191 := by
  exact pellLightMasks_valid 8191 PellMatchingLightProduction.pellMasks_8191 PellMatchingLightProduction.pellMasks_8191_valid

theorem pellMatching_8191_checked :
    pellMatchingCheck pellMasks_8191 pellMagnitudes_8191 pellWitnesses_8191 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8191
    PellMatchingLightProduction.pellMagnitudes_8191 PellMatchingLightProduction.pellWitnesses_8191).symm.trans
      PellMatchingLightProduction.pellMatching_8191_checked

theorem pellMagnitudes_8191_large : ∀ x ∈ pellMagnitudes_8191, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8191 PellMatchingLightProduction.pellMagnitudes_8191_large

def pellGraphCertificate_8191 : PellMatchingCertificate 8191 where
  magnitudes := pellMagnitudes_8191
  masks := pellMasks_8191
  witnesses := pellWitnesses_8191
  masks_valid := pellMasks_8191_valid
  checked := pellMatching_8191_checked
  large := pellMagnitudes_8191_large

def pellMagnitudes_8231 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8231

def pellMasks_8231 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8231.map pellLightMasksToOriginal

def pellWitnesses_8231 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8231

theorem pellMasks_8231_valid : ∀ m ∈ pellMasks_8231, m.Valid 8231 := by
  exact pellLightMasks_valid 8231 PellMatchingLightProduction.pellMasks_8231 PellMatchingLightProduction.pellMasks_8231_valid

theorem pellMatching_8231_checked :
    pellMatchingCheck pellMasks_8231 pellMagnitudes_8231 pellWitnesses_8231 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8231
    PellMatchingLightProduction.pellMagnitudes_8231 PellMatchingLightProduction.pellWitnesses_8231).symm.trans
      PellMatchingLightProduction.pellMatching_8231_checked

theorem pellMagnitudes_8231_large : ∀ x ∈ pellMagnitudes_8231, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8231 PellMatchingLightProduction.pellMagnitudes_8231_large

def pellGraphCertificate_8231 : PellMatchingCertificate 8231 where
  magnitudes := pellMagnitudes_8231
  masks := pellMasks_8231
  witnesses := pellWitnesses_8231
  masks_valid := pellMasks_8231_valid
  checked := pellMatching_8231_checked
  large := pellMagnitudes_8231_large

def pellMagnitudes_8263 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8263

def pellMasks_8263 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8263.map pellLightMasksToOriginal

def pellWitnesses_8263 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8263

theorem pellMasks_8263_valid : ∀ m ∈ pellMasks_8263, m.Valid 8263 := by
  exact pellLightMasks_valid 8263 PellMatchingLightProduction.pellMasks_8263 PellMatchingLightProduction.pellMasks_8263_valid

theorem pellMatching_8263_checked :
    pellMatchingCheck pellMasks_8263 pellMagnitudes_8263 pellWitnesses_8263 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8263
    PellMatchingLightProduction.pellMagnitudes_8263 PellMatchingLightProduction.pellWitnesses_8263).symm.trans
      PellMatchingLightProduction.pellMatching_8263_checked

theorem pellMagnitudes_8263_large : ∀ x ∈ pellMagnitudes_8263, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8263 PellMatchingLightProduction.pellMagnitudes_8263_large

def pellGraphCertificate_8263 : PellMatchingCertificate 8263 where
  magnitudes := pellMagnitudes_8263
  masks := pellMasks_8263
  witnesses := pellWitnesses_8263
  masks_valid := pellMasks_8263_valid
  checked := pellMatching_8263_checked
  large := pellMagnitudes_8263_large

def pellMagnitudes_8279 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8279

def pellMasks_8279 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8279.map pellLightMasksToOriginal

def pellWitnesses_8279 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8279

theorem pellMasks_8279_valid : ∀ m ∈ pellMasks_8279, m.Valid 8279 := by
  exact pellLightMasks_valid 8279 PellMatchingLightProduction.pellMasks_8279 PellMatchingLightProduction.pellMasks_8279_valid

theorem pellMatching_8279_checked :
    pellMatchingCheck pellMasks_8279 pellMagnitudes_8279 pellWitnesses_8279 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8279
    PellMatchingLightProduction.pellMagnitudes_8279 PellMatchingLightProduction.pellWitnesses_8279).symm.trans
      PellMatchingLightProduction.pellMatching_8279_checked

theorem pellMagnitudes_8279_large : ∀ x ∈ pellMagnitudes_8279, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8279 PellMatchingLightProduction.pellMagnitudes_8279_large

def pellGraphCertificate_8279 : PellMatchingCertificate 8279 where
  magnitudes := pellMagnitudes_8279
  masks := pellMasks_8279
  witnesses := pellWitnesses_8279
  masks_valid := pellMasks_8279_valid
  checked := pellMatching_8279_checked
  large := pellMagnitudes_8279_large

def pellMagnitudes_8287 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8287

def pellMasks_8287 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8287.map pellLightMasksToOriginal

def pellWitnesses_8287 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8287

theorem pellMasks_8287_valid : ∀ m ∈ pellMasks_8287, m.Valid 8287 := by
  exact pellLightMasks_valid 8287 PellMatchingLightProduction.pellMasks_8287 PellMatchingLightProduction.pellMasks_8287_valid

theorem pellMatching_8287_checked :
    pellMatchingCheck pellMasks_8287 pellMagnitudes_8287 pellWitnesses_8287 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8287
    PellMatchingLightProduction.pellMagnitudes_8287 PellMatchingLightProduction.pellWitnesses_8287).symm.trans
      PellMatchingLightProduction.pellMatching_8287_checked

theorem pellMagnitudes_8287_large : ∀ x ∈ pellMagnitudes_8287, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8287 PellMatchingLightProduction.pellMagnitudes_8287_large

def pellGraphCertificate_8287 : PellMatchingCertificate 8287 where
  magnitudes := pellMagnitudes_8287
  masks := pellMasks_8287
  witnesses := pellWitnesses_8287
  masks_valid := pellMasks_8287_valid
  checked := pellMatching_8287_checked
  large := pellMagnitudes_8287_large

def pellMagnitudes_8311 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8311

def pellMasks_8311 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8311.map pellLightMasksToOriginal

def pellWitnesses_8311 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8311

theorem pellMasks_8311_valid : ∀ m ∈ pellMasks_8311, m.Valid 8311 := by
  exact pellLightMasks_valid 8311 PellMatchingLightProduction.pellMasks_8311 PellMatchingLightProduction.pellMasks_8311_valid

theorem pellMatching_8311_checked :
    pellMatchingCheck pellMasks_8311 pellMagnitudes_8311 pellWitnesses_8311 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8311
    PellMatchingLightProduction.pellMagnitudes_8311 PellMatchingLightProduction.pellWitnesses_8311).symm.trans
      PellMatchingLightProduction.pellMatching_8311_checked

theorem pellMagnitudes_8311_large : ∀ x ∈ pellMagnitudes_8311, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8311 PellMatchingLightProduction.pellMagnitudes_8311_large

def pellGraphCertificate_8311 : PellMatchingCertificate 8311 where
  magnitudes := pellMagnitudes_8311
  masks := pellMasks_8311
  witnesses := pellWitnesses_8311
  masks_valid := pellMasks_8311_valid
  checked := pellMatching_8311_checked
  large := pellMagnitudes_8311_large

def pellMagnitudes_8351 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8351

def pellMasks_8351 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8351.map pellLightMasksToOriginal

def pellWitnesses_8351 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8351

theorem pellMasks_8351_valid : ∀ m ∈ pellMasks_8351, m.Valid 8351 := by
  exact pellLightMasks_valid 8351 PellMatchingLightProduction.pellMasks_8351 PellMatchingLightProduction.pellMasks_8351_valid

theorem pellMatching_8351_checked :
    pellMatchingCheck pellMasks_8351 pellMagnitudes_8351 pellWitnesses_8351 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8351
    PellMatchingLightProduction.pellMagnitudes_8351 PellMatchingLightProduction.pellWitnesses_8351).symm.trans
      PellMatchingLightProduction.pellMatching_8351_checked

theorem pellMagnitudes_8351_large : ∀ x ∈ pellMagnitudes_8351, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8351 PellMatchingLightProduction.pellMagnitudes_8351_large

def pellGraphCertificate_8351 : PellMatchingCertificate 8351 where
  magnitudes := pellMagnitudes_8351
  masks := pellMasks_8351
  witnesses := pellWitnesses_8351
  masks_valid := pellMasks_8351_valid
  checked := pellMatching_8351_checked
  large := pellMagnitudes_8351_large

def pellMagnitudes_8423 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8423

def pellMasks_8423 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8423.map pellLightMasksToOriginal

def pellWitnesses_8423 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8423

theorem pellMasks_8423_valid : ∀ m ∈ pellMasks_8423, m.Valid 8423 := by
  exact pellLightMasks_valid 8423 PellMatchingLightProduction.pellMasks_8423 PellMatchingLightProduction.pellMasks_8423_valid

theorem pellMatching_8423_checked :
    pellMatchingCheck pellMasks_8423 pellMagnitudes_8423 pellWitnesses_8423 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8423
    PellMatchingLightProduction.pellMagnitudes_8423 PellMatchingLightProduction.pellWitnesses_8423).symm.trans
      PellMatchingLightProduction.pellMatching_8423_checked

theorem pellMagnitudes_8423_large : ∀ x ∈ pellMagnitudes_8423, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8423 PellMatchingLightProduction.pellMagnitudes_8423_large

def pellGraphCertificate_8423 : PellMatchingCertificate 8423 where
  magnitudes := pellMagnitudes_8423
  masks := pellMasks_8423
  witnesses := pellWitnesses_8423
  masks_valid := pellMasks_8423_valid
  checked := pellMatching_8423_checked
  large := pellMagnitudes_8423_large

def pellMagnitudes_8431 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8431

def pellMasks_8431 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8431.map pellLightMasksToOriginal

def pellWitnesses_8431 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8431

theorem pellMasks_8431_valid : ∀ m ∈ pellMasks_8431, m.Valid 8431 := by
  exact pellLightMasks_valid 8431 PellMatchingLightProduction.pellMasks_8431 PellMatchingLightProduction.pellMasks_8431_valid

theorem pellMatching_8431_checked :
    pellMatchingCheck pellMasks_8431 pellMagnitudes_8431 pellWitnesses_8431 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8431
    PellMatchingLightProduction.pellMagnitudes_8431 PellMatchingLightProduction.pellWitnesses_8431).symm.trans
      PellMatchingLightProduction.pellMatching_8431_checked

theorem pellMagnitudes_8431_large : ∀ x ∈ pellMagnitudes_8431, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8431 PellMatchingLightProduction.pellMagnitudes_8431_large

def pellGraphCertificate_8431 : PellMatchingCertificate 8431 where
  magnitudes := pellMagnitudes_8431
  masks := pellMasks_8431
  witnesses := pellWitnesses_8431
  masks_valid := pellMasks_8431_valid
  checked := pellMatching_8431_checked
  large := pellMagnitudes_8431_large

def pellMagnitudes_8447 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8447

def pellMasks_8447 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8447.map pellLightMasksToOriginal

def pellWitnesses_8447 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8447

theorem pellMasks_8447_valid : ∀ m ∈ pellMasks_8447, m.Valid 8447 := by
  exact pellLightMasks_valid 8447 PellMatchingLightProduction.pellMasks_8447 PellMatchingLightProduction.pellMasks_8447_valid

theorem pellMatching_8447_checked :
    pellMatchingCheck pellMasks_8447 pellMagnitudes_8447 pellWitnesses_8447 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8447
    PellMatchingLightProduction.pellMagnitudes_8447 PellMatchingLightProduction.pellWitnesses_8447).symm.trans
      PellMatchingLightProduction.pellMatching_8447_checked

theorem pellMagnitudes_8447_large : ∀ x ∈ pellMagnitudes_8447, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8447 PellMatchingLightProduction.pellMagnitudes_8447_large

def pellGraphCertificate_8447 : PellMatchingCertificate 8447 where
  magnitudes := pellMagnitudes_8447
  masks := pellMasks_8447
  witnesses := pellWitnesses_8447
  masks_valid := pellMasks_8447_valid
  checked := pellMatching_8447_checked
  large := pellMagnitudes_8447_large

def pellMagnitudes_8519 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8519

def pellMasks_8519 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8519.map pellLightMasksToOriginal

def pellWitnesses_8519 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8519

theorem pellMasks_8519_valid : ∀ m ∈ pellMasks_8519, m.Valid 8519 := by
  exact pellLightMasks_valid 8519 PellMatchingLightProduction.pellMasks_8519 PellMatchingLightProduction.pellMasks_8519_valid

theorem pellMatching_8519_checked :
    pellMatchingCheck pellMasks_8519 pellMagnitudes_8519 pellWitnesses_8519 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8519
    PellMatchingLightProduction.pellMagnitudes_8519 PellMatchingLightProduction.pellWitnesses_8519).symm.trans
      PellMatchingLightProduction.pellMatching_8519_checked

theorem pellMagnitudes_8519_large : ∀ x ∈ pellMagnitudes_8519, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8519 PellMatchingLightProduction.pellMagnitudes_8519_large

def pellGraphCertificate_8519 : PellMatchingCertificate 8519 where
  magnitudes := pellMagnitudes_8519
  masks := pellMasks_8519
  witnesses := pellWitnesses_8519
  masks_valid := pellMasks_8519_valid
  checked := pellMatching_8519_checked
  large := pellMagnitudes_8519_large

def pellMagnitudes_8527 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8527

def pellMasks_8527 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8527.map pellLightMasksToOriginal

def pellWitnesses_8527 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8527

theorem pellMasks_8527_valid : ∀ m ∈ pellMasks_8527, m.Valid 8527 := by
  exact pellLightMasks_valid 8527 PellMatchingLightProduction.pellMasks_8527 PellMatchingLightProduction.pellMasks_8527_valid

theorem pellMatching_8527_checked :
    pellMatchingCheck pellMasks_8527 pellMagnitudes_8527 pellWitnesses_8527 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8527
    PellMatchingLightProduction.pellMagnitudes_8527 PellMatchingLightProduction.pellWitnesses_8527).symm.trans
      PellMatchingLightProduction.pellMatching_8527_checked

theorem pellMagnitudes_8527_large : ∀ x ∈ pellMagnitudes_8527, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8527 PellMatchingLightProduction.pellMagnitudes_8527_large

def pellGraphCertificate_8527 : PellMatchingCertificate 8527 where
  magnitudes := pellMagnitudes_8527
  masks := pellMasks_8527
  witnesses := pellWitnesses_8527
  masks_valid := pellMasks_8527_valid
  checked := pellMatching_8527_checked
  large := pellMagnitudes_8527_large

def pellMagnitudes_8543 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8543

def pellMasks_8543 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8543.map pellLightMasksToOriginal

def pellWitnesses_8543 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8543

theorem pellMasks_8543_valid : ∀ m ∈ pellMasks_8543, m.Valid 8543 := by
  exact pellLightMasks_valid 8543 PellMatchingLightProduction.pellMasks_8543 PellMatchingLightProduction.pellMasks_8543_valid

theorem pellMatching_8543_checked :
    pellMatchingCheck pellMasks_8543 pellMagnitudes_8543 pellWitnesses_8543 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8543
    PellMatchingLightProduction.pellMagnitudes_8543 PellMatchingLightProduction.pellWitnesses_8543).symm.trans
      PellMatchingLightProduction.pellMatching_8543_checked

theorem pellMagnitudes_8543_large : ∀ x ∈ pellMagnitudes_8543, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8543 PellMatchingLightProduction.pellMagnitudes_8543_large

def pellGraphCertificate_8543 : PellMatchingCertificate 8543 where
  magnitudes := pellMagnitudes_8543
  masks := pellMasks_8543
  witnesses := pellWitnesses_8543
  masks_valid := pellMasks_8543_valid
  checked := pellMatching_8543_checked
  large := pellMagnitudes_8543_large

def pellMagnitudes_8551 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8551

def pellMasks_8551 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8551.map pellLightMasksToOriginal

def pellWitnesses_8551 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8551

theorem pellMasks_8551_valid : ∀ m ∈ pellMasks_8551, m.Valid 8551 := by
  exact pellLightMasks_valid 8551 PellMatchingLightProduction.pellMasks_8551 PellMatchingLightProduction.pellMasks_8551_valid

theorem pellMatching_8551_checked :
    pellMatchingCheck pellMasks_8551 pellMagnitudes_8551 pellWitnesses_8551 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8551
    PellMatchingLightProduction.pellMagnitudes_8551 PellMatchingLightProduction.pellWitnesses_8551).symm.trans
      PellMatchingLightProduction.pellMatching_8551_checked

theorem pellMagnitudes_8551_large : ∀ x ∈ pellMagnitudes_8551, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8551 PellMatchingLightProduction.pellMagnitudes_8551_large

def pellGraphCertificate_8551 : PellMatchingCertificate 8551 where
  magnitudes := pellMagnitudes_8551
  masks := pellMasks_8551
  witnesses := pellWitnesses_8551
  masks_valid := pellMasks_8551_valid
  checked := pellMatching_8551_checked
  large := pellMagnitudes_8551_large

def pellMagnitudes_8599 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8599

def pellMasks_8599 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8599.map pellLightMasksToOriginal

def pellWitnesses_8599 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8599

theorem pellMasks_8599_valid : ∀ m ∈ pellMasks_8599, m.Valid 8599 := by
  exact pellLightMasks_valid 8599 PellMatchingLightProduction.pellMasks_8599 PellMatchingLightProduction.pellMasks_8599_valid

theorem pellMatching_8599_checked :
    pellMatchingCheck pellMasks_8599 pellMagnitudes_8599 pellWitnesses_8599 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8599
    PellMatchingLightProduction.pellMagnitudes_8599 PellMatchingLightProduction.pellWitnesses_8599).symm.trans
      PellMatchingLightProduction.pellMatching_8599_checked

theorem pellMagnitudes_8599_large : ∀ x ∈ pellMagnitudes_8599, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8599 PellMatchingLightProduction.pellMagnitudes_8599_large

def pellGraphCertificate_8599 : PellMatchingCertificate 8599 where
  magnitudes := pellMagnitudes_8599
  masks := pellMasks_8599
  witnesses := pellWitnesses_8599
  masks_valid := pellMasks_8599_valid
  checked := pellMatching_8599_checked
  large := pellMagnitudes_8599_large

def pellMagnitudes_8623 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8623

def pellMasks_8623 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8623.map pellLightMasksToOriginal

def pellWitnesses_8623 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8623

theorem pellMasks_8623_valid : ∀ m ∈ pellMasks_8623, m.Valid 8623 := by
  exact pellLightMasks_valid 8623 PellMatchingLightProduction.pellMasks_8623 PellMatchingLightProduction.pellMasks_8623_valid

theorem pellMatching_8623_checked :
    pellMatchingCheck pellMasks_8623 pellMagnitudes_8623 pellWitnesses_8623 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8623
    PellMatchingLightProduction.pellMagnitudes_8623 PellMatchingLightProduction.pellWitnesses_8623).symm.trans
      PellMatchingLightProduction.pellMatching_8623_checked

theorem pellMagnitudes_8623_large : ∀ x ∈ pellMagnitudes_8623, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8623 PellMatchingLightProduction.pellMagnitudes_8623_large

def pellGraphCertificate_8623 : PellMatchingCertificate 8623 where
  magnitudes := pellMagnitudes_8623
  masks := pellMasks_8623
  witnesses := pellWitnesses_8623
  masks_valid := pellMasks_8623_valid
  checked := pellMatching_8623_checked
  large := pellMagnitudes_8623_large

def pellMagnitudes_8647 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8647

def pellMasks_8647 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8647.map pellLightMasksToOriginal

def pellWitnesses_8647 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8647

theorem pellMasks_8647_valid : ∀ m ∈ pellMasks_8647, m.Valid 8647 := by
  exact pellLightMasks_valid 8647 PellMatchingLightProduction.pellMasks_8647 PellMatchingLightProduction.pellMasks_8647_valid

theorem pellMatching_8647_checked :
    pellMatchingCheck pellMasks_8647 pellMagnitudes_8647 pellWitnesses_8647 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8647
    PellMatchingLightProduction.pellMagnitudes_8647 PellMatchingLightProduction.pellWitnesses_8647).symm.trans
      PellMatchingLightProduction.pellMatching_8647_checked

theorem pellMagnitudes_8647_large : ∀ x ∈ pellMagnitudes_8647, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8647 PellMatchingLightProduction.pellMagnitudes_8647_large

def pellGraphCertificate_8647 : PellMatchingCertificate 8647 where
  magnitudes := pellMagnitudes_8647
  masks := pellMasks_8647
  witnesses := pellWitnesses_8647
  masks_valid := pellMasks_8647_valid
  checked := pellMatching_8647_checked
  large := pellMagnitudes_8647_large

def pellMagnitudes_8663 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8663

def pellMasks_8663 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8663.map pellLightMasksToOriginal

def pellWitnesses_8663 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8663

theorem pellMasks_8663_valid : ∀ m ∈ pellMasks_8663, m.Valid 8663 := by
  exact pellLightMasks_valid 8663 PellMatchingLightProduction.pellMasks_8663 PellMatchingLightProduction.pellMasks_8663_valid

theorem pellMatching_8663_checked :
    pellMatchingCheck pellMasks_8663 pellMagnitudes_8663 pellWitnesses_8663 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8663
    PellMatchingLightProduction.pellMagnitudes_8663 PellMatchingLightProduction.pellWitnesses_8663).symm.trans
      PellMatchingLightProduction.pellMatching_8663_checked

theorem pellMagnitudes_8663_large : ∀ x ∈ pellMagnitudes_8663, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8663 PellMatchingLightProduction.pellMagnitudes_8663_large

def pellGraphCertificate_8663 : PellMatchingCertificate 8663 where
  magnitudes := pellMagnitudes_8663
  masks := pellMasks_8663
  witnesses := pellWitnesses_8663
  masks_valid := pellMasks_8663_valid
  checked := pellMatching_8663_checked
  large := pellMagnitudes_8663_large

def pellMagnitudes_8687 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8687

def pellMasks_8687 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8687.map pellLightMasksToOriginal

def pellWitnesses_8687 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8687

theorem pellMasks_8687_valid : ∀ m ∈ pellMasks_8687, m.Valid 8687 := by
  exact pellLightMasks_valid 8687 PellMatchingLightProduction.pellMasks_8687 PellMatchingLightProduction.pellMasks_8687_valid

theorem pellMatching_8687_checked :
    pellMatchingCheck pellMasks_8687 pellMagnitudes_8687 pellWitnesses_8687 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8687
    PellMatchingLightProduction.pellMagnitudes_8687 PellMatchingLightProduction.pellWitnesses_8687).symm.trans
      PellMatchingLightProduction.pellMatching_8687_checked

theorem pellMagnitudes_8687_large : ∀ x ∈ pellMagnitudes_8687, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8687 PellMatchingLightProduction.pellMagnitudes_8687_large

def pellGraphCertificate_8687 : PellMatchingCertificate 8687 where
  magnitudes := pellMagnitudes_8687
  masks := pellMasks_8687
  witnesses := pellWitnesses_8687
  masks_valid := pellMasks_8687_valid
  checked := pellMatching_8687_checked
  large := pellMagnitudes_8687_large

def pellMagnitudes_8719 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8719

def pellMasks_8719 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8719.map pellLightMasksToOriginal

def pellWitnesses_8719 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8719

theorem pellMasks_8719_valid : ∀ m ∈ pellMasks_8719, m.Valid 8719 := by
  exact pellLightMasks_valid 8719 PellMatchingLightProduction.pellMasks_8719 PellMatchingLightProduction.pellMasks_8719_valid

theorem pellMatching_8719_checked :
    pellMatchingCheck pellMasks_8719 pellMagnitudes_8719 pellWitnesses_8719 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8719
    PellMatchingLightProduction.pellMagnitudes_8719 PellMatchingLightProduction.pellWitnesses_8719).symm.trans
      PellMatchingLightProduction.pellMatching_8719_checked

theorem pellMagnitudes_8719_large : ∀ x ∈ pellMagnitudes_8719, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8719 PellMatchingLightProduction.pellMagnitudes_8719_large

def pellGraphCertificate_8719 : PellMatchingCertificate 8719 where
  magnitudes := pellMagnitudes_8719
  masks := pellMasks_8719
  witnesses := pellWitnesses_8719
  masks_valid := pellMasks_8719_valid
  checked := pellMatching_8719_checked
  large := pellMagnitudes_8719_large

def pellMagnitudes_8743 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8743

def pellMasks_8743 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8743.map pellLightMasksToOriginal

def pellWitnesses_8743 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8743

theorem pellMasks_8743_valid : ∀ m ∈ pellMasks_8743, m.Valid 8743 := by
  exact pellLightMasks_valid 8743 PellMatchingLightProduction.pellMasks_8743 PellMatchingLightProduction.pellMasks_8743_valid

theorem pellMatching_8743_checked :
    pellMatchingCheck pellMasks_8743 pellMagnitudes_8743 pellWitnesses_8743 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8743
    PellMatchingLightProduction.pellMagnitudes_8743 PellMatchingLightProduction.pellWitnesses_8743).symm.trans
      PellMatchingLightProduction.pellMatching_8743_checked

theorem pellMagnitudes_8743_large : ∀ x ∈ pellMagnitudes_8743, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8743 PellMatchingLightProduction.pellMagnitudes_8743_large

def pellGraphCertificate_8743 : PellMatchingCertificate 8743 where
  magnitudes := pellMagnitudes_8743
  masks := pellMasks_8743
  witnesses := pellWitnesses_8743
  masks_valid := pellMasks_8743_valid
  checked := pellMatching_8743_checked
  large := pellMagnitudes_8743_large

def pellMagnitudes_8783 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8783

def pellMasks_8783 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8783.map pellLightMasksToOriginal

def pellWitnesses_8783 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8783

theorem pellMasks_8783_valid : ∀ m ∈ pellMasks_8783, m.Valid 8783 := by
  exact pellLightMasks_valid 8783 PellMatchingLightProduction.pellMasks_8783 PellMatchingLightProduction.pellMasks_8783_valid

theorem pellMatching_8783_checked :
    pellMatchingCheck pellMasks_8783 pellMagnitudes_8783 pellWitnesses_8783 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8783
    PellMatchingLightProduction.pellMagnitudes_8783 PellMatchingLightProduction.pellWitnesses_8783).symm.trans
      PellMatchingLightProduction.pellMatching_8783_checked

theorem pellMagnitudes_8783_large : ∀ x ∈ pellMagnitudes_8783, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8783 PellMatchingLightProduction.pellMagnitudes_8783_large

def pellGraphCertificate_8783 : PellMatchingCertificate 8783 where
  magnitudes := pellMagnitudes_8783
  masks := pellMasks_8783
  witnesses := pellWitnesses_8783
  masks_valid := pellMasks_8783_valid
  checked := pellMatching_8783_checked
  large := pellMagnitudes_8783_large

def pellMagnitudes_8807 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8807

def pellMasks_8807 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8807.map pellLightMasksToOriginal

def pellWitnesses_8807 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8807

theorem pellMasks_8807_valid : ∀ m ∈ pellMasks_8807, m.Valid 8807 := by
  exact pellLightMasks_valid 8807 PellMatchingLightProduction.pellMasks_8807 PellMatchingLightProduction.pellMasks_8807_valid

theorem pellMatching_8807_checked :
    pellMatchingCheck pellMasks_8807 pellMagnitudes_8807 pellWitnesses_8807 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8807
    PellMatchingLightProduction.pellMagnitudes_8807 PellMatchingLightProduction.pellWitnesses_8807).symm.trans
      PellMatchingLightProduction.pellMatching_8807_checked

theorem pellMagnitudes_8807_large : ∀ x ∈ pellMagnitudes_8807, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8807 PellMatchingLightProduction.pellMagnitudes_8807_large

def pellGraphCertificate_8807 : PellMatchingCertificate 8807 where
  magnitudes := pellMagnitudes_8807
  masks := pellMasks_8807
  witnesses := pellWitnesses_8807
  masks_valid := pellMasks_8807_valid
  checked := pellMatching_8807_checked
  large := pellMagnitudes_8807_large

def pellMagnitudes_8831 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8831

def pellMasks_8831 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8831.map pellLightMasksToOriginal

def pellWitnesses_8831 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8831

theorem pellMasks_8831_valid : ∀ m ∈ pellMasks_8831, m.Valid 8831 := by
  exact pellLightMasks_valid 8831 PellMatchingLightProduction.pellMasks_8831 PellMatchingLightProduction.pellMasks_8831_valid

theorem pellMatching_8831_checked :
    pellMatchingCheck pellMasks_8831 pellMagnitudes_8831 pellWitnesses_8831 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8831
    PellMatchingLightProduction.pellMagnitudes_8831 PellMatchingLightProduction.pellWitnesses_8831).symm.trans
      PellMatchingLightProduction.pellMatching_8831_checked

theorem pellMagnitudes_8831_large : ∀ x ∈ pellMagnitudes_8831, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8831 PellMatchingLightProduction.pellMagnitudes_8831_large

def pellGraphCertificate_8831 : PellMatchingCertificate 8831 where
  magnitudes := pellMagnitudes_8831
  masks := pellMasks_8831
  witnesses := pellWitnesses_8831
  masks_valid := pellMasks_8831_valid
  checked := pellMatching_8831_checked
  large := pellMagnitudes_8831_large

def pellMagnitudes_8839 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8839

def pellMasks_8839 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8839.map pellLightMasksToOriginal

def pellWitnesses_8839 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8839

theorem pellMasks_8839_valid : ∀ m ∈ pellMasks_8839, m.Valid 8839 := by
  exact pellLightMasks_valid 8839 PellMatchingLightProduction.pellMasks_8839 PellMatchingLightProduction.pellMasks_8839_valid

theorem pellMatching_8839_checked :
    pellMatchingCheck pellMasks_8839 pellMagnitudes_8839 pellWitnesses_8839 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8839
    PellMatchingLightProduction.pellMagnitudes_8839 PellMatchingLightProduction.pellWitnesses_8839).symm.trans
      PellMatchingLightProduction.pellMatching_8839_checked

theorem pellMagnitudes_8839_large : ∀ x ∈ pellMagnitudes_8839, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8839 PellMatchingLightProduction.pellMagnitudes_8839_large

def pellGraphCertificate_8839 : PellMatchingCertificate 8839 where
  magnitudes := pellMagnitudes_8839
  masks := pellMasks_8839
  witnesses := pellWitnesses_8839
  masks_valid := pellMasks_8839_valid
  checked := pellMatching_8839_checked
  large := pellMagnitudes_8839_large

def pellMagnitudes_8863 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8863

def pellMasks_8863 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8863.map pellLightMasksToOriginal

def pellWitnesses_8863 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8863

theorem pellMasks_8863_valid : ∀ m ∈ pellMasks_8863, m.Valid 8863 := by
  exact pellLightMasks_valid 8863 PellMatchingLightProduction.pellMasks_8863 PellMatchingLightProduction.pellMasks_8863_valid

theorem pellMatching_8863_checked :
    pellMatchingCheck pellMasks_8863 pellMagnitudes_8863 pellWitnesses_8863 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8863
    PellMatchingLightProduction.pellMagnitudes_8863 PellMatchingLightProduction.pellWitnesses_8863).symm.trans
      PellMatchingLightProduction.pellMatching_8863_checked

theorem pellMagnitudes_8863_large : ∀ x ∈ pellMagnitudes_8863, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8863 PellMatchingLightProduction.pellMagnitudes_8863_large

def pellGraphCertificate_8863 : PellMatchingCertificate 8863 where
  magnitudes := pellMagnitudes_8863
  masks := pellMasks_8863
  witnesses := pellWitnesses_8863
  masks_valid := pellMasks_8863_valid
  checked := pellMatching_8863_checked
  large := pellMagnitudes_8863_large

def pellMagnitudes_8887 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8887

def pellMasks_8887 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8887.map pellLightMasksToOriginal

def pellWitnesses_8887 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8887

theorem pellMasks_8887_valid : ∀ m ∈ pellMasks_8887, m.Valid 8887 := by
  exact pellLightMasks_valid 8887 PellMatchingLightProduction.pellMasks_8887 PellMatchingLightProduction.pellMasks_8887_valid

theorem pellMatching_8887_checked :
    pellMatchingCheck pellMasks_8887 pellMagnitudes_8887 pellWitnesses_8887 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8887
    PellMatchingLightProduction.pellMagnitudes_8887 PellMatchingLightProduction.pellWitnesses_8887).symm.trans
      PellMatchingLightProduction.pellMatching_8887_checked

theorem pellMagnitudes_8887_large : ∀ x ∈ pellMagnitudes_8887, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8887 PellMatchingLightProduction.pellMagnitudes_8887_large

def pellGraphCertificate_8887 : PellMatchingCertificate 8887 where
  magnitudes := pellMagnitudes_8887
  masks := pellMasks_8887
  witnesses := pellWitnesses_8887
  masks_valid := pellMasks_8887_valid
  checked := pellMatching_8887_checked
  large := pellMagnitudes_8887_large

def pellMagnitudes_8927 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8927

def pellMasks_8927 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8927.map pellLightMasksToOriginal

def pellWitnesses_8927 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8927

theorem pellMasks_8927_valid : ∀ m ∈ pellMasks_8927, m.Valid 8927 := by
  exact pellLightMasks_valid 8927 PellMatchingLightProduction.pellMasks_8927 PellMatchingLightProduction.pellMasks_8927_valid

theorem pellMatching_8927_checked :
    pellMatchingCheck pellMasks_8927 pellMagnitudes_8927 pellWitnesses_8927 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8927
    PellMatchingLightProduction.pellMagnitudes_8927 PellMatchingLightProduction.pellWitnesses_8927).symm.trans
      PellMatchingLightProduction.pellMatching_8927_checked

theorem pellMagnitudes_8927_large : ∀ x ∈ pellMagnitudes_8927, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8927 PellMatchingLightProduction.pellMagnitudes_8927_large

def pellGraphCertificate_8927 : PellMatchingCertificate 8927 where
  magnitudes := pellMagnitudes_8927
  masks := pellMasks_8927
  witnesses := pellWitnesses_8927
  masks_valid := pellMasks_8927_valid
  checked := pellMatching_8927_checked
  large := pellMagnitudes_8927_large

def pellMagnitudes_8951 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8951

def pellMasks_8951 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8951.map pellLightMasksToOriginal

def pellWitnesses_8951 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8951

theorem pellMasks_8951_valid : ∀ m ∈ pellMasks_8951, m.Valid 8951 := by
  exact pellLightMasks_valid 8951 PellMatchingLightProduction.pellMasks_8951 PellMatchingLightProduction.pellMasks_8951_valid

theorem pellMatching_8951_checked :
    pellMatchingCheck pellMasks_8951 pellMagnitudes_8951 pellWitnesses_8951 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8951
    PellMatchingLightProduction.pellMagnitudes_8951 PellMatchingLightProduction.pellWitnesses_8951).symm.trans
      PellMatchingLightProduction.pellMatching_8951_checked

theorem pellMagnitudes_8951_large : ∀ x ∈ pellMagnitudes_8951, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8951 PellMatchingLightProduction.pellMagnitudes_8951_large

def pellGraphCertificate_8951 : PellMatchingCertificate 8951 where
  magnitudes := pellMagnitudes_8951
  masks := pellMasks_8951
  witnesses := pellWitnesses_8951
  masks_valid := pellMasks_8951_valid
  checked := pellMatching_8951_checked
  large := pellMagnitudes_8951_large

def pellMagnitudes_8999 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_8999

def pellMasks_8999 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_8999.map pellLightMasksToOriginal

def pellWitnesses_8999 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_8999

theorem pellMasks_8999_valid : ∀ m ∈ pellMasks_8999, m.Valid 8999 := by
  exact pellLightMasks_valid 8999 PellMatchingLightProduction.pellMasks_8999 PellMatchingLightProduction.pellMasks_8999_valid

theorem pellMatching_8999_checked :
    pellMatchingCheck pellMasks_8999 pellMagnitudes_8999 pellWitnesses_8999 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_8999
    PellMatchingLightProduction.pellMagnitudes_8999 PellMatchingLightProduction.pellWitnesses_8999).symm.trans
      PellMatchingLightProduction.pellMatching_8999_checked

theorem pellMagnitudes_8999_large : ∀ x ∈ pellMagnitudes_8999, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_8999 PellMatchingLightProduction.pellMagnitudes_8999_large

def pellGraphCertificate_8999 : PellMatchingCertificate 8999 where
  magnitudes := pellMagnitudes_8999
  masks := pellMasks_8999
  witnesses := pellWitnesses_8999
  masks_valid := pellMasks_8999_valid
  checked := pellMatching_8999_checked
  large := pellMagnitudes_8999_large

def pellMagnitudes_9007 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9007

def pellMasks_9007 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9007.map pellLightMasksToOriginal

def pellWitnesses_9007 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9007

theorem pellMasks_9007_valid : ∀ m ∈ pellMasks_9007, m.Valid 9007 := by
  exact pellLightMasks_valid 9007 PellMatchingLightProduction.pellMasks_9007 PellMatchingLightProduction.pellMasks_9007_valid

theorem pellMatching_9007_checked :
    pellMatchingCheck pellMasks_9007 pellMagnitudes_9007 pellWitnesses_9007 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9007
    PellMatchingLightProduction.pellMagnitudes_9007 PellMatchingLightProduction.pellWitnesses_9007).symm.trans
      PellMatchingLightProduction.pellMatching_9007_checked

theorem pellMagnitudes_9007_large : ∀ x ∈ pellMagnitudes_9007, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9007 PellMatchingLightProduction.pellMagnitudes_9007_large

def pellGraphCertificate_9007 : PellMatchingCertificate 9007 where
  magnitudes := pellMagnitudes_9007
  masks := pellMasks_9007
  witnesses := pellWitnesses_9007
  masks_valid := pellMasks_9007_valid
  checked := pellMatching_9007_checked
  large := pellMagnitudes_9007_large

def pellMagnitudes_9023 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9023

def pellMasks_9023 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9023.map pellLightMasksToOriginal

def pellWitnesses_9023 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9023

theorem pellMasks_9023_valid : ∀ m ∈ pellMasks_9023, m.Valid 9023 := by
  exact pellLightMasks_valid 9023 PellMatchingLightProduction.pellMasks_9023 PellMatchingLightProduction.pellMasks_9023_valid

theorem pellMatching_9023_checked :
    pellMatchingCheck pellMasks_9023 pellMagnitudes_9023 pellWitnesses_9023 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9023
    PellMatchingLightProduction.pellMagnitudes_9023 PellMatchingLightProduction.pellWitnesses_9023).symm.trans
      PellMatchingLightProduction.pellMatching_9023_checked

theorem pellMagnitudes_9023_large : ∀ x ∈ pellMagnitudes_9023, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9023 PellMatchingLightProduction.pellMagnitudes_9023_large

def pellGraphCertificate_9023 : PellMatchingCertificate 9023 where
  magnitudes := pellMagnitudes_9023
  masks := pellMasks_9023
  witnesses := pellWitnesses_9023
  masks_valid := pellMasks_9023_valid
  checked := pellMatching_9023_checked
  large := pellMagnitudes_9023_large

def pellMagnitudes_9071 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9071

def pellMasks_9071 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9071.map pellLightMasksToOriginal

def pellWitnesses_9071 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9071

theorem pellMasks_9071_valid : ∀ m ∈ pellMasks_9071, m.Valid 9071 := by
  exact pellLightMasks_valid 9071 PellMatchingLightProduction.pellMasks_9071 PellMatchingLightProduction.pellMasks_9071_valid

theorem pellMatching_9071_checked :
    pellMatchingCheck pellMasks_9071 pellMagnitudes_9071 pellWitnesses_9071 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9071
    PellMatchingLightProduction.pellMagnitudes_9071 PellMatchingLightProduction.pellWitnesses_9071).symm.trans
      PellMatchingLightProduction.pellMatching_9071_checked

theorem pellMagnitudes_9071_large : ∀ x ∈ pellMagnitudes_9071, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9071 PellMatchingLightProduction.pellMagnitudes_9071_large

def pellGraphCertificate_9071 : PellMatchingCertificate 9071 where
  magnitudes := pellMagnitudes_9071
  masks := pellMasks_9071
  witnesses := pellWitnesses_9071
  masks_valid := pellMasks_9071_valid
  checked := pellMatching_9071_checked
  large := pellMagnitudes_9071_large

def pellMagnitudes_9079 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9079

def pellMasks_9079 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9079.map pellLightMasksToOriginal

def pellWitnesses_9079 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9079

theorem pellMasks_9079_valid : ∀ m ∈ pellMasks_9079, m.Valid 9079 := by
  exact pellLightMasks_valid 9079 PellMatchingLightProduction.pellMasks_9079 PellMatchingLightProduction.pellMasks_9079_valid

theorem pellMatching_9079_checked :
    pellMatchingCheck pellMasks_9079 pellMagnitudes_9079 pellWitnesses_9079 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9079
    PellMatchingLightProduction.pellMagnitudes_9079 PellMatchingLightProduction.pellWitnesses_9079).symm.trans
      PellMatchingLightProduction.pellMatching_9079_checked

theorem pellMagnitudes_9079_large : ∀ x ∈ pellMagnitudes_9079, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9079 PellMatchingLightProduction.pellMagnitudes_9079_large

def pellGraphCertificate_9079 : PellMatchingCertificate 9079 where
  magnitudes := pellMagnitudes_9079
  masks := pellMasks_9079
  witnesses := pellWitnesses_9079
  masks_valid := pellMasks_9079_valid
  checked := pellMatching_9079_checked
  large := pellMagnitudes_9079_large

def pellMagnitudes_9103 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9103

def pellMasks_9103 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9103.map pellLightMasksToOriginal

def pellWitnesses_9103 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9103

theorem pellMasks_9103_valid : ∀ m ∈ pellMasks_9103, m.Valid 9103 := by
  exact pellLightMasks_valid 9103 PellMatchingLightProduction.pellMasks_9103 PellMatchingLightProduction.pellMasks_9103_valid

theorem pellMatching_9103_checked :
    pellMatchingCheck pellMasks_9103 pellMagnitudes_9103 pellWitnesses_9103 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9103
    PellMatchingLightProduction.pellMagnitudes_9103 PellMatchingLightProduction.pellWitnesses_9103).symm.trans
      PellMatchingLightProduction.pellMatching_9103_checked

theorem pellMagnitudes_9103_large : ∀ x ∈ pellMagnitudes_9103, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9103 PellMatchingLightProduction.pellMagnitudes_9103_large

def pellGraphCertificate_9103 : PellMatchingCertificate 9103 where
  magnitudes := pellMagnitudes_9103
  masks := pellMasks_9103
  witnesses := pellWitnesses_9103
  masks_valid := pellMasks_9103_valid
  checked := pellMatching_9103_checked
  large := pellMagnitudes_9103_large

def pellMagnitudes_9127 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9127

def pellMasks_9127 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9127.map pellLightMasksToOriginal

def pellWitnesses_9127 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9127

theorem pellMasks_9127_valid : ∀ m ∈ pellMasks_9127, m.Valid 9127 := by
  exact pellLightMasks_valid 9127 PellMatchingLightProduction.pellMasks_9127 PellMatchingLightProduction.pellMasks_9127_valid

theorem pellMatching_9127_checked :
    pellMatchingCheck pellMasks_9127 pellMagnitudes_9127 pellWitnesses_9127 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9127
    PellMatchingLightProduction.pellMagnitudes_9127 PellMatchingLightProduction.pellWitnesses_9127).symm.trans
      PellMatchingLightProduction.pellMatching_9127_checked

theorem pellMagnitudes_9127_large : ∀ x ∈ pellMagnitudes_9127, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9127 PellMatchingLightProduction.pellMagnitudes_9127_large

def pellGraphCertificate_9127 : PellMatchingCertificate 9127 where
  magnitudes := pellMagnitudes_9127
  masks := pellMasks_9127
  witnesses := pellWitnesses_9127
  masks_valid := pellMasks_9127_valid
  checked := pellMatching_9127_checked
  large := pellMagnitudes_9127_large

def pellMagnitudes_9151 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9151

def pellMasks_9151 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9151.map pellLightMasksToOriginal

def pellWitnesses_9151 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9151

theorem pellMasks_9151_valid : ∀ m ∈ pellMasks_9151, m.Valid 9151 := by
  exact pellLightMasks_valid 9151 PellMatchingLightProduction.pellMasks_9151 PellMatchingLightProduction.pellMasks_9151_valid

theorem pellMatching_9151_checked :
    pellMatchingCheck pellMasks_9151 pellMagnitudes_9151 pellWitnesses_9151 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9151
    PellMatchingLightProduction.pellMagnitudes_9151 PellMatchingLightProduction.pellWitnesses_9151).symm.trans
      PellMatchingLightProduction.pellMatching_9151_checked

theorem pellMagnitudes_9151_large : ∀ x ∈ pellMagnitudes_9151, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9151 PellMatchingLightProduction.pellMagnitudes_9151_large

def pellGraphCertificate_9151 : PellMatchingCertificate 9151 where
  magnitudes := pellMagnitudes_9151
  masks := pellMasks_9151
  witnesses := pellWitnesses_9151
  masks_valid := pellMasks_9151_valid
  checked := pellMatching_9151_checked
  large := pellMagnitudes_9151_large

def pellMagnitudes_9167 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9167

def pellMasks_9167 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9167.map pellLightMasksToOriginal

def pellWitnesses_9167 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9167

theorem pellMasks_9167_valid : ∀ m ∈ pellMasks_9167, m.Valid 9167 := by
  exact pellLightMasks_valid 9167 PellMatchingLightProduction.pellMasks_9167 PellMatchingLightProduction.pellMasks_9167_valid

theorem pellMatching_9167_checked :
    pellMatchingCheck pellMasks_9167 pellMagnitudes_9167 pellWitnesses_9167 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9167
    PellMatchingLightProduction.pellMagnitudes_9167 PellMatchingLightProduction.pellWitnesses_9167).symm.trans
      PellMatchingLightProduction.pellMatching_9167_checked

theorem pellMagnitudes_9167_large : ∀ x ∈ pellMagnitudes_9167, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9167 PellMatchingLightProduction.pellMagnitudes_9167_large

def pellGraphCertificate_9167 : PellMatchingCertificate 9167 where
  magnitudes := pellMagnitudes_9167
  masks := pellMasks_9167
  witnesses := pellWitnesses_9167
  masks_valid := pellMasks_9167_valid
  checked := pellMatching_9167_checked
  large := pellMagnitudes_9167_large

def pellMagnitudes_9199 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9199

def pellMasks_9199 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9199.map pellLightMasksToOriginal

def pellWitnesses_9199 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9199

theorem pellMasks_9199_valid : ∀ m ∈ pellMasks_9199, m.Valid 9199 := by
  exact pellLightMasks_valid 9199 PellMatchingLightProduction.pellMasks_9199 PellMatchingLightProduction.pellMasks_9199_valid

theorem pellMatching_9199_checked :
    pellMatchingCheck pellMasks_9199 pellMagnitudes_9199 pellWitnesses_9199 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9199
    PellMatchingLightProduction.pellMagnitudes_9199 PellMatchingLightProduction.pellWitnesses_9199).symm.trans
      PellMatchingLightProduction.pellMatching_9199_checked

theorem pellMagnitudes_9199_large : ∀ x ∈ pellMagnitudes_9199, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9199 PellMatchingLightProduction.pellMagnitudes_9199_large

def pellGraphCertificate_9199 : PellMatchingCertificate 9199 where
  magnitudes := pellMagnitudes_9199
  masks := pellMasks_9199
  witnesses := pellWitnesses_9199
  masks_valid := pellMasks_9199_valid
  checked := pellMatching_9199_checked
  large := pellMagnitudes_9199_large

def pellMagnitudes_9223 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9223

def pellMasks_9223 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9223.map pellLightMasksToOriginal

def pellWitnesses_9223 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9223

theorem pellMasks_9223_valid : ∀ m ∈ pellMasks_9223, m.Valid 9223 := by
  exact pellLightMasks_valid 9223 PellMatchingLightProduction.pellMasks_9223 PellMatchingLightProduction.pellMasks_9223_valid

theorem pellMatching_9223_checked :
    pellMatchingCheck pellMasks_9223 pellMagnitudes_9223 pellWitnesses_9223 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9223
    PellMatchingLightProduction.pellMagnitudes_9223 PellMatchingLightProduction.pellWitnesses_9223).symm.trans
      PellMatchingLightProduction.pellMatching_9223_checked

theorem pellMagnitudes_9223_large : ∀ x ∈ pellMagnitudes_9223, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9223 PellMatchingLightProduction.pellMagnitudes_9223_large

def pellGraphCertificate_9223 : PellMatchingCertificate 9223 where
  magnitudes := pellMagnitudes_9223
  masks := pellMasks_9223
  witnesses := pellWitnesses_9223
  masks_valid := pellMasks_9223_valid
  checked := pellMatching_9223_checked
  large := pellMagnitudes_9223_large

def pellMagnitudes_9239 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9239

def pellMasks_9239 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9239.map pellLightMasksToOriginal

def pellWitnesses_9239 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9239

theorem pellMasks_9239_valid : ∀ m ∈ pellMasks_9239, m.Valid 9239 := by
  exact pellLightMasks_valid 9239 PellMatchingLightProduction.pellMasks_9239 PellMatchingLightProduction.pellMasks_9239_valid

theorem pellMatching_9239_checked :
    pellMatchingCheck pellMasks_9239 pellMagnitudes_9239 pellWitnesses_9239 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9239
    PellMatchingLightProduction.pellMagnitudes_9239 PellMatchingLightProduction.pellWitnesses_9239).symm.trans
      PellMatchingLightProduction.pellMatching_9239_checked

theorem pellMagnitudes_9239_large : ∀ x ∈ pellMagnitudes_9239, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9239 PellMatchingLightProduction.pellMagnitudes_9239_large

def pellGraphCertificate_9239 : PellMatchingCertificate 9239 where
  magnitudes := pellMagnitudes_9239
  masks := pellMasks_9239
  witnesses := pellWitnesses_9239
  masks_valid := pellMasks_9239_valid
  checked := pellMatching_9239_checked
  large := pellMagnitudes_9239_large

def pellMagnitudes_9247 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9247

def pellMasks_9247 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9247.map pellLightMasksToOriginal

def pellWitnesses_9247 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9247

theorem pellMasks_9247_valid : ∀ m ∈ pellMasks_9247, m.Valid 9247 := by
  exact pellLightMasks_valid 9247 PellMatchingLightProduction.pellMasks_9247 PellMatchingLightProduction.pellMasks_9247_valid

theorem pellMatching_9247_checked :
    pellMatchingCheck pellMasks_9247 pellMagnitudes_9247 pellWitnesses_9247 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9247
    PellMatchingLightProduction.pellMagnitudes_9247 PellMatchingLightProduction.pellWitnesses_9247).symm.trans
      PellMatchingLightProduction.pellMatching_9247_checked

theorem pellMagnitudes_9247_large : ∀ x ∈ pellMagnitudes_9247, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9247 PellMatchingLightProduction.pellMagnitudes_9247_large

def pellGraphCertificate_9247 : PellMatchingCertificate 9247 where
  magnitudes := pellMagnitudes_9247
  masks := pellMasks_9247
  witnesses := pellWitnesses_9247
  masks_valid := pellMasks_9247_valid
  checked := pellMatching_9247_checked
  large := pellMagnitudes_9247_large

def pellMagnitudes_9311 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9311

def pellMasks_9311 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9311.map pellLightMasksToOriginal

def pellWitnesses_9311 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9311

theorem pellMasks_9311_valid : ∀ m ∈ pellMasks_9311, m.Valid 9311 := by
  exact pellLightMasks_valid 9311 PellMatchingLightProduction.pellMasks_9311 PellMatchingLightProduction.pellMasks_9311_valid

theorem pellMatching_9311_checked :
    pellMatchingCheck pellMasks_9311 pellMagnitudes_9311 pellWitnesses_9311 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9311
    PellMatchingLightProduction.pellMagnitudes_9311 PellMatchingLightProduction.pellWitnesses_9311).symm.trans
      PellMatchingLightProduction.pellMatching_9311_checked

theorem pellMagnitudes_9311_large : ∀ x ∈ pellMagnitudes_9311, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9311 PellMatchingLightProduction.pellMagnitudes_9311_large

def pellGraphCertificate_9311 : PellMatchingCertificate 9311 where
  magnitudes := pellMagnitudes_9311
  masks := pellMasks_9311
  witnesses := pellWitnesses_9311
  masks_valid := pellMasks_9311_valid
  checked := pellMatching_9311_checked
  large := pellMagnitudes_9311_large

def pellMagnitudes_9319 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9319

def pellMasks_9319 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9319.map pellLightMasksToOriginal

def pellWitnesses_9319 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9319

theorem pellMasks_9319_valid : ∀ m ∈ pellMasks_9319, m.Valid 9319 := by
  exact pellLightMasks_valid 9319 PellMatchingLightProduction.pellMasks_9319 PellMatchingLightProduction.pellMasks_9319_valid

theorem pellMatching_9319_checked :
    pellMatchingCheck pellMasks_9319 pellMagnitudes_9319 pellWitnesses_9319 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9319
    PellMatchingLightProduction.pellMagnitudes_9319 PellMatchingLightProduction.pellWitnesses_9319).symm.trans
      PellMatchingLightProduction.pellMatching_9319_checked

theorem pellMagnitudes_9319_large : ∀ x ∈ pellMagnitudes_9319, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9319 PellMatchingLightProduction.pellMagnitudes_9319_large

def pellGraphCertificate_9319 : PellMatchingCertificate 9319 where
  magnitudes := pellMagnitudes_9319
  masks := pellMasks_9319
  witnesses := pellWitnesses_9319
  masks_valid := pellMasks_9319_valid
  checked := pellMatching_9319_checked
  large := pellMagnitudes_9319_large

def pellMagnitudes_9343 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9343

def pellMasks_9343 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9343.map pellLightMasksToOriginal

def pellWitnesses_9343 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9343

theorem pellMasks_9343_valid : ∀ m ∈ pellMasks_9343, m.Valid 9343 := by
  exact pellLightMasks_valid 9343 PellMatchingLightProduction.pellMasks_9343 PellMatchingLightProduction.pellMasks_9343_valid

theorem pellMatching_9343_checked :
    pellMatchingCheck pellMasks_9343 pellMagnitudes_9343 pellWitnesses_9343 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9343
    PellMatchingLightProduction.pellMagnitudes_9343 PellMatchingLightProduction.pellWitnesses_9343).symm.trans
      PellMatchingLightProduction.pellMatching_9343_checked

theorem pellMagnitudes_9343_large : ∀ x ∈ pellMagnitudes_9343, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9343 PellMatchingLightProduction.pellMagnitudes_9343_large

def pellGraphCertificate_9343 : PellMatchingCertificate 9343 where
  magnitudes := pellMagnitudes_9343
  masks := pellMasks_9343
  witnesses := pellWitnesses_9343
  masks_valid := pellMasks_9343_valid
  checked := pellMatching_9343_checked
  large := pellMagnitudes_9343_large

def pellMagnitudes_9391 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9391

def pellMasks_9391 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9391.map pellLightMasksToOriginal

def pellWitnesses_9391 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9391

theorem pellMasks_9391_valid : ∀ m ∈ pellMasks_9391, m.Valid 9391 := by
  exact pellLightMasks_valid 9391 PellMatchingLightProduction.pellMasks_9391 PellMatchingLightProduction.pellMasks_9391_valid

theorem pellMatching_9391_checked :
    pellMatchingCheck pellMasks_9391 pellMagnitudes_9391 pellWitnesses_9391 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9391
    PellMatchingLightProduction.pellMagnitudes_9391 PellMatchingLightProduction.pellWitnesses_9391).symm.trans
      PellMatchingLightProduction.pellMatching_9391_checked

theorem pellMagnitudes_9391_large : ∀ x ∈ pellMagnitudes_9391, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9391 PellMatchingLightProduction.pellMagnitudes_9391_large

def pellGraphCertificate_9391 : PellMatchingCertificate 9391 where
  magnitudes := pellMagnitudes_9391
  masks := pellMasks_9391
  witnesses := pellWitnesses_9391
  masks_valid := pellMasks_9391_valid
  checked := pellMatching_9391_checked
  large := pellMagnitudes_9391_large

def pellMagnitudes_9407 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9407

def pellMasks_9407 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9407.map pellLightMasksToOriginal

def pellWitnesses_9407 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9407

theorem pellMasks_9407_valid : ∀ m ∈ pellMasks_9407, m.Valid 9407 := by
  exact pellLightMasks_valid 9407 PellMatchingLightProduction.pellMasks_9407 PellMatchingLightProduction.pellMasks_9407_valid

theorem pellMatching_9407_checked :
    pellMatchingCheck pellMasks_9407 pellMagnitudes_9407 pellWitnesses_9407 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9407
    PellMatchingLightProduction.pellMagnitudes_9407 PellMatchingLightProduction.pellWitnesses_9407).symm.trans
      PellMatchingLightProduction.pellMatching_9407_checked

theorem pellMagnitudes_9407_large : ∀ x ∈ pellMagnitudes_9407, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9407 PellMatchingLightProduction.pellMagnitudes_9407_large

def pellGraphCertificate_9407 : PellMatchingCertificate 9407 where
  magnitudes := pellMagnitudes_9407
  masks := pellMasks_9407
  witnesses := pellWitnesses_9407
  masks_valid := pellMasks_9407_valid
  checked := pellMatching_9407_checked
  large := pellMagnitudes_9407_large

def pellMagnitudes_9431 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9431

def pellMasks_9431 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9431.map pellLightMasksToOriginal

def pellWitnesses_9431 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9431

theorem pellMasks_9431_valid : ∀ m ∈ pellMasks_9431, m.Valid 9431 := by
  exact pellLightMasks_valid 9431 PellMatchingLightProduction.pellMasks_9431 PellMatchingLightProduction.pellMasks_9431_valid

theorem pellMatching_9431_checked :
    pellMatchingCheck pellMasks_9431 pellMagnitudes_9431 pellWitnesses_9431 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9431
    PellMatchingLightProduction.pellMagnitudes_9431 PellMatchingLightProduction.pellWitnesses_9431).symm.trans
      PellMatchingLightProduction.pellMatching_9431_checked

theorem pellMagnitudes_9431_large : ∀ x ∈ pellMagnitudes_9431, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9431 PellMatchingLightProduction.pellMagnitudes_9431_large

def pellGraphCertificate_9431 : PellMatchingCertificate 9431 where
  magnitudes := pellMagnitudes_9431
  masks := pellMasks_9431
  witnesses := pellWitnesses_9431
  masks_valid := pellMasks_9431_valid
  checked := pellMatching_9431_checked
  large := pellMagnitudes_9431_large

def pellMagnitudes_9439 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9439

def pellMasks_9439 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9439.map pellLightMasksToOriginal

def pellWitnesses_9439 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9439

theorem pellMasks_9439_valid : ∀ m ∈ pellMasks_9439, m.Valid 9439 := by
  exact pellLightMasks_valid 9439 PellMatchingLightProduction.pellMasks_9439 PellMatchingLightProduction.pellMasks_9439_valid

theorem pellMatching_9439_checked :
    pellMatchingCheck pellMasks_9439 pellMagnitudes_9439 pellWitnesses_9439 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9439
    PellMatchingLightProduction.pellMagnitudes_9439 PellMatchingLightProduction.pellWitnesses_9439).symm.trans
      PellMatchingLightProduction.pellMatching_9439_checked

theorem pellMagnitudes_9439_large : ∀ x ∈ pellMagnitudes_9439, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9439 PellMatchingLightProduction.pellMagnitudes_9439_large

def pellGraphCertificate_9439 : PellMatchingCertificate 9439 where
  magnitudes := pellMagnitudes_9439
  masks := pellMasks_9439
  witnesses := pellWitnesses_9439
  masks_valid := pellMasks_9439_valid
  checked := pellMatching_9439_checked
  large := pellMagnitudes_9439_large

def pellMagnitudes_9463 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9463

def pellMasks_9463 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9463.map pellLightMasksToOriginal

def pellWitnesses_9463 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9463

theorem pellMasks_9463_valid : ∀ m ∈ pellMasks_9463, m.Valid 9463 := by
  exact pellLightMasks_valid 9463 PellMatchingLightProduction.pellMasks_9463 PellMatchingLightProduction.pellMasks_9463_valid

theorem pellMatching_9463_checked :
    pellMatchingCheck pellMasks_9463 pellMagnitudes_9463 pellWitnesses_9463 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9463
    PellMatchingLightProduction.pellMagnitudes_9463 PellMatchingLightProduction.pellWitnesses_9463).symm.trans
      PellMatchingLightProduction.pellMatching_9463_checked

theorem pellMagnitudes_9463_large : ∀ x ∈ pellMagnitudes_9463, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9463 PellMatchingLightProduction.pellMagnitudes_9463_large

def pellGraphCertificate_9463 : PellMatchingCertificate 9463 where
  magnitudes := pellMagnitudes_9463
  masks := pellMasks_9463
  witnesses := pellWitnesses_9463
  masks_valid := pellMasks_9463_valid
  checked := pellMatching_9463_checked
  large := pellMagnitudes_9463_large

def pellMagnitudes_9479 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9479

def pellMasks_9479 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9479.map pellLightMasksToOriginal

def pellWitnesses_9479 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9479

theorem pellMasks_9479_valid : ∀ m ∈ pellMasks_9479, m.Valid 9479 := by
  exact pellLightMasks_valid 9479 PellMatchingLightProduction.pellMasks_9479 PellMatchingLightProduction.pellMasks_9479_valid

theorem pellMatching_9479_checked :
    pellMatchingCheck pellMasks_9479 pellMagnitudes_9479 pellWitnesses_9479 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9479
    PellMatchingLightProduction.pellMagnitudes_9479 PellMatchingLightProduction.pellWitnesses_9479).symm.trans
      PellMatchingLightProduction.pellMatching_9479_checked

theorem pellMagnitudes_9479_large : ∀ x ∈ pellMagnitudes_9479, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9479 PellMatchingLightProduction.pellMagnitudes_9479_large

def pellGraphCertificate_9479 : PellMatchingCertificate 9479 where
  magnitudes := pellMagnitudes_9479
  masks := pellMasks_9479
  witnesses := pellWitnesses_9479
  masks_valid := pellMasks_9479_valid
  checked := pellMatching_9479_checked
  large := pellMagnitudes_9479_large

def pellMagnitudes_9511 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9511

def pellMasks_9511 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9511.map pellLightMasksToOriginal

def pellWitnesses_9511 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9511

theorem pellMasks_9511_valid : ∀ m ∈ pellMasks_9511, m.Valid 9511 := by
  exact pellLightMasks_valid 9511 PellMatchingLightProduction.pellMasks_9511 PellMatchingLightProduction.pellMasks_9511_valid

theorem pellMatching_9511_checked :
    pellMatchingCheck pellMasks_9511 pellMagnitudes_9511 pellWitnesses_9511 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9511
    PellMatchingLightProduction.pellMagnitudes_9511 PellMatchingLightProduction.pellWitnesses_9511).symm.trans
      PellMatchingLightProduction.pellMatching_9511_checked

theorem pellMagnitudes_9511_large : ∀ x ∈ pellMagnitudes_9511, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9511 PellMatchingLightProduction.pellMagnitudes_9511_large

def pellGraphCertificate_9511 : PellMatchingCertificate 9511 where
  magnitudes := pellMagnitudes_9511
  masks := pellMasks_9511
  witnesses := pellWitnesses_9511
  masks_valid := pellMasks_9511_valid
  checked := pellMatching_9511_checked
  large := pellMagnitudes_9511_large

def pellMagnitudes_9527 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9527

def pellMasks_9527 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9527.map pellLightMasksToOriginal

def pellWitnesses_9527 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9527

theorem pellMasks_9527_valid : ∀ m ∈ pellMasks_9527, m.Valid 9527 := by
  exact pellLightMasks_valid 9527 PellMatchingLightProduction.pellMasks_9527 PellMatchingLightProduction.pellMasks_9527_valid

theorem pellMatching_9527_checked :
    pellMatchingCheck pellMasks_9527 pellMagnitudes_9527 pellWitnesses_9527 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9527
    PellMatchingLightProduction.pellMagnitudes_9527 PellMatchingLightProduction.pellWitnesses_9527).symm.trans
      PellMatchingLightProduction.pellMatching_9527_checked

theorem pellMagnitudes_9527_large : ∀ x ∈ pellMagnitudes_9527, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9527 PellMatchingLightProduction.pellMagnitudes_9527_large

def pellGraphCertificate_9527 : PellMatchingCertificate 9527 where
  magnitudes := pellMagnitudes_9527
  masks := pellMasks_9527
  witnesses := pellWitnesses_9527
  masks_valid := pellMasks_9527_valid
  checked := pellMatching_9527_checked
  large := pellMagnitudes_9527_large

def pellMagnitudes_9551 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9551

def pellMasks_9551 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9551.map pellLightMasksToOriginal

def pellWitnesses_9551 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9551

theorem pellMasks_9551_valid : ∀ m ∈ pellMasks_9551, m.Valid 9551 := by
  exact pellLightMasks_valid 9551 PellMatchingLightProduction.pellMasks_9551 PellMatchingLightProduction.pellMasks_9551_valid

theorem pellMatching_9551_checked :
    pellMatchingCheck pellMasks_9551 pellMagnitudes_9551 pellWitnesses_9551 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9551
    PellMatchingLightProduction.pellMagnitudes_9551 PellMatchingLightProduction.pellWitnesses_9551).symm.trans
      PellMatchingLightProduction.pellMatching_9551_checked

theorem pellMagnitudes_9551_large : ∀ x ∈ pellMagnitudes_9551, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9551 PellMatchingLightProduction.pellMagnitudes_9551_large

def pellGraphCertificate_9551 : PellMatchingCertificate 9551 where
  magnitudes := pellMagnitudes_9551
  masks := pellMasks_9551
  witnesses := pellWitnesses_9551
  masks_valid := pellMasks_9551_valid
  checked := pellMatching_9551_checked
  large := pellMagnitudes_9551_large

def pellMagnitudes_9623 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9623

def pellMasks_9623 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9623.map pellLightMasksToOriginal

def pellWitnesses_9623 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9623

theorem pellMasks_9623_valid : ∀ m ∈ pellMasks_9623, m.Valid 9623 := by
  exact pellLightMasks_valid 9623 PellMatchingLightProduction.pellMasks_9623 PellMatchingLightProduction.pellMasks_9623_valid

theorem pellMatching_9623_checked :
    pellMatchingCheck pellMasks_9623 pellMagnitudes_9623 pellWitnesses_9623 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9623
    PellMatchingLightProduction.pellMagnitudes_9623 PellMatchingLightProduction.pellWitnesses_9623).symm.trans
      PellMatchingLightProduction.pellMatching_9623_checked

theorem pellMagnitudes_9623_large : ∀ x ∈ pellMagnitudes_9623, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9623 PellMatchingLightProduction.pellMagnitudes_9623_large

def pellGraphCertificate_9623 : PellMatchingCertificate 9623 where
  magnitudes := pellMagnitudes_9623
  masks := pellMasks_9623
  witnesses := pellWitnesses_9623
  masks_valid := pellMasks_9623_valid
  checked := pellMatching_9623_checked
  large := pellMagnitudes_9623_large

def pellMagnitudes_9631 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9631

def pellMasks_9631 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9631.map pellLightMasksToOriginal

def pellWitnesses_9631 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9631

theorem pellMasks_9631_valid : ∀ m ∈ pellMasks_9631, m.Valid 9631 := by
  exact pellLightMasks_valid 9631 PellMatchingLightProduction.pellMasks_9631 PellMatchingLightProduction.pellMasks_9631_valid

theorem pellMatching_9631_checked :
    pellMatchingCheck pellMasks_9631 pellMagnitudes_9631 pellWitnesses_9631 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9631
    PellMatchingLightProduction.pellMagnitudes_9631 PellMatchingLightProduction.pellWitnesses_9631).symm.trans
      PellMatchingLightProduction.pellMatching_9631_checked

theorem pellMagnitudes_9631_large : ∀ x ∈ pellMagnitudes_9631, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9631 PellMatchingLightProduction.pellMagnitudes_9631_large

def pellGraphCertificate_9631 : PellMatchingCertificate 9631 where
  magnitudes := pellMagnitudes_9631
  masks := pellMasks_9631
  witnesses := pellWitnesses_9631
  masks_valid := pellMasks_9631_valid
  checked := pellMatching_9631_checked
  large := pellMagnitudes_9631_large

def pellMagnitudes_9679 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9679

def pellMasks_9679 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9679.map pellLightMasksToOriginal

def pellWitnesses_9679 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9679

theorem pellMasks_9679_valid : ∀ m ∈ pellMasks_9679, m.Valid 9679 := by
  exact pellLightMasks_valid 9679 PellMatchingLightProduction.pellMasks_9679 PellMatchingLightProduction.pellMasks_9679_valid

theorem pellMatching_9679_checked :
    pellMatchingCheck pellMasks_9679 pellMagnitudes_9679 pellWitnesses_9679 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9679
    PellMatchingLightProduction.pellMagnitudes_9679 PellMatchingLightProduction.pellWitnesses_9679).symm.trans
      PellMatchingLightProduction.pellMatching_9679_checked

theorem pellMagnitudes_9679_large : ∀ x ∈ pellMagnitudes_9679, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9679 PellMatchingLightProduction.pellMagnitudes_9679_large

def pellGraphCertificate_9679 : PellMatchingCertificate 9679 where
  magnitudes := pellMagnitudes_9679
  masks := pellMasks_9679
  witnesses := pellWitnesses_9679
  masks_valid := pellMasks_9679_valid
  checked := pellMatching_9679_checked
  large := pellMagnitudes_9679_large

def pellMagnitudes_9703 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9703

def pellMasks_9703 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9703.map pellLightMasksToOriginal

def pellWitnesses_9703 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9703

theorem pellMasks_9703_valid : ∀ m ∈ pellMasks_9703, m.Valid 9703 := by
  exact pellLightMasks_valid 9703 PellMatchingLightProduction.pellMasks_9703 PellMatchingLightProduction.pellMasks_9703_valid

theorem pellMatching_9703_checked :
    pellMatchingCheck pellMasks_9703 pellMagnitudes_9703 pellWitnesses_9703 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9703
    PellMatchingLightProduction.pellMagnitudes_9703 PellMatchingLightProduction.pellWitnesses_9703).symm.trans
      PellMatchingLightProduction.pellMatching_9703_checked

theorem pellMagnitudes_9703_large : ∀ x ∈ pellMagnitudes_9703, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9703 PellMatchingLightProduction.pellMagnitudes_9703_large

def pellGraphCertificate_9703 : PellMatchingCertificate 9703 where
  magnitudes := pellMagnitudes_9703
  masks := pellMasks_9703
  witnesses := pellWitnesses_9703
  masks_valid := pellMasks_9703_valid
  checked := pellMatching_9703_checked
  large := pellMagnitudes_9703_large

def pellMagnitudes_9719 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9719

def pellMasks_9719 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9719.map pellLightMasksToOriginal

def pellWitnesses_9719 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9719

theorem pellMasks_9719_valid : ∀ m ∈ pellMasks_9719, m.Valid 9719 := by
  exact pellLightMasks_valid 9719 PellMatchingLightProduction.pellMasks_9719 PellMatchingLightProduction.pellMasks_9719_valid

theorem pellMatching_9719_checked :
    pellMatchingCheck pellMasks_9719 pellMagnitudes_9719 pellWitnesses_9719 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9719
    PellMatchingLightProduction.pellMagnitudes_9719 PellMatchingLightProduction.pellWitnesses_9719).symm.trans
      PellMatchingLightProduction.pellMatching_9719_checked

theorem pellMagnitudes_9719_large : ∀ x ∈ pellMagnitudes_9719, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9719 PellMatchingLightProduction.pellMagnitudes_9719_large

def pellGraphCertificate_9719 : PellMatchingCertificate 9719 where
  magnitudes := pellMagnitudes_9719
  masks := pellMasks_9719
  witnesses := pellWitnesses_9719
  masks_valid := pellMasks_9719_valid
  checked := pellMatching_9719_checked
  large := pellMagnitudes_9719_large

def pellMagnitudes_9727 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9727

def pellMasks_9727 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9727.map pellLightMasksToOriginal

def pellWitnesses_9727 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9727

theorem pellMasks_9727_valid : ∀ m ∈ pellMasks_9727, m.Valid 9727 := by
  exact pellLightMasks_valid 9727 PellMatchingLightProduction.pellMasks_9727 PellMatchingLightProduction.pellMasks_9727_valid

theorem pellMatching_9727_checked :
    pellMatchingCheck pellMasks_9727 pellMagnitudes_9727 pellWitnesses_9727 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9727
    PellMatchingLightProduction.pellMagnitudes_9727 PellMatchingLightProduction.pellWitnesses_9727).symm.trans
      PellMatchingLightProduction.pellMatching_9727_checked

theorem pellMagnitudes_9727_large : ∀ x ∈ pellMagnitudes_9727, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9727 PellMatchingLightProduction.pellMagnitudes_9727_large

def pellGraphCertificate_9727 : PellMatchingCertificate 9727 where
  magnitudes := pellMagnitudes_9727
  masks := pellMasks_9727
  witnesses := pellWitnesses_9727
  masks_valid := pellMasks_9727_valid
  checked := pellMatching_9727_checked
  large := pellMagnitudes_9727_large

def pellMagnitudes_9743 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9743

def pellMasks_9743 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9743.map pellLightMasksToOriginal

def pellWitnesses_9743 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9743

theorem pellMasks_9743_valid : ∀ m ∈ pellMasks_9743, m.Valid 9743 := by
  exact pellLightMasks_valid 9743 PellMatchingLightProduction.pellMasks_9743 PellMatchingLightProduction.pellMasks_9743_valid

theorem pellMatching_9743_checked :
    pellMatchingCheck pellMasks_9743 pellMagnitudes_9743 pellWitnesses_9743 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9743
    PellMatchingLightProduction.pellMagnitudes_9743 PellMatchingLightProduction.pellWitnesses_9743).symm.trans
      PellMatchingLightProduction.pellMatching_9743_checked

theorem pellMagnitudes_9743_large : ∀ x ∈ pellMagnitudes_9743, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9743 PellMatchingLightProduction.pellMagnitudes_9743_large

def pellGraphCertificate_9743 : PellMatchingCertificate 9743 where
  magnitudes := pellMagnitudes_9743
  masks := pellMasks_9743
  witnesses := pellWitnesses_9743
  masks_valid := pellMasks_9743_valid
  checked := pellMatching_9743_checked
  large := pellMagnitudes_9743_large

def pellMagnitudes_9767 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9767

def pellMasks_9767 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9767.map pellLightMasksToOriginal

def pellWitnesses_9767 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9767

theorem pellMasks_9767_valid : ∀ m ∈ pellMasks_9767, m.Valid 9767 := by
  exact pellLightMasks_valid 9767 PellMatchingLightProduction.pellMasks_9767 PellMatchingLightProduction.pellMasks_9767_valid

theorem pellMatching_9767_checked :
    pellMatchingCheck pellMasks_9767 pellMagnitudes_9767 pellWitnesses_9767 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9767
    PellMatchingLightProduction.pellMagnitudes_9767 PellMatchingLightProduction.pellWitnesses_9767).symm.trans
      PellMatchingLightProduction.pellMatching_9767_checked

theorem pellMagnitudes_9767_large : ∀ x ∈ pellMagnitudes_9767, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9767 PellMatchingLightProduction.pellMagnitudes_9767_large

def pellGraphCertificate_9767 : PellMatchingCertificate 9767 where
  magnitudes := pellMagnitudes_9767
  masks := pellMasks_9767
  witnesses := pellWitnesses_9767
  masks_valid := pellMasks_9767_valid
  checked := pellMatching_9767_checked
  large := pellMagnitudes_9767_large

def pellMagnitudes_9791 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9791

def pellMasks_9791 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9791.map pellLightMasksToOriginal

def pellWitnesses_9791 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9791

theorem pellMasks_9791_valid : ∀ m ∈ pellMasks_9791, m.Valid 9791 := by
  exact pellLightMasks_valid 9791 PellMatchingLightProduction.pellMasks_9791 PellMatchingLightProduction.pellMasks_9791_valid

theorem pellMatching_9791_checked :
    pellMatchingCheck pellMasks_9791 pellMagnitudes_9791 pellWitnesses_9791 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9791
    PellMatchingLightProduction.pellMagnitudes_9791 PellMatchingLightProduction.pellWitnesses_9791).symm.trans
      PellMatchingLightProduction.pellMatching_9791_checked

theorem pellMagnitudes_9791_large : ∀ x ∈ pellMagnitudes_9791, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9791 PellMatchingLightProduction.pellMagnitudes_9791_large

def pellGraphCertificate_9791 : PellMatchingCertificate 9791 where
  magnitudes := pellMagnitudes_9791
  masks := pellMasks_9791
  witnesses := pellWitnesses_9791
  masks_valid := pellMasks_9791_valid
  checked := pellMatching_9791_checked
  large := pellMagnitudes_9791_large

def pellMagnitudes_9799 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9799

def pellMasks_9799 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9799.map pellLightMasksToOriginal

def pellWitnesses_9799 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9799

theorem pellMasks_9799_valid : ∀ m ∈ pellMasks_9799, m.Valid 9799 := by
  exact pellLightMasks_valid 9799 PellMatchingLightProduction.pellMasks_9799 PellMatchingLightProduction.pellMasks_9799_valid

theorem pellMatching_9799_checked :
    pellMatchingCheck pellMasks_9799 pellMagnitudes_9799 pellWitnesses_9799 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9799
    PellMatchingLightProduction.pellMagnitudes_9799 PellMatchingLightProduction.pellWitnesses_9799).symm.trans
      PellMatchingLightProduction.pellMatching_9799_checked

theorem pellMagnitudes_9799_large : ∀ x ∈ pellMagnitudes_9799, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9799 PellMatchingLightProduction.pellMagnitudes_9799_large

def pellGraphCertificate_9799 : PellMatchingCertificate 9799 where
  magnitudes := pellMagnitudes_9799
  masks := pellMasks_9799
  witnesses := pellWitnesses_9799
  masks_valid := pellMasks_9799_valid
  checked := pellMatching_9799_checked
  large := pellMagnitudes_9799_large

def pellMagnitudes_9839 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9839

def pellMasks_9839 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9839.map pellLightMasksToOriginal

def pellWitnesses_9839 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9839

theorem pellMasks_9839_valid : ∀ m ∈ pellMasks_9839, m.Valid 9839 := by
  exact pellLightMasks_valid 9839 PellMatchingLightProduction.pellMasks_9839 PellMatchingLightProduction.pellMasks_9839_valid

theorem pellMatching_9839_checked :
    pellMatchingCheck pellMasks_9839 pellMagnitudes_9839 pellWitnesses_9839 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9839
    PellMatchingLightProduction.pellMagnitudes_9839 PellMatchingLightProduction.pellWitnesses_9839).symm.trans
      PellMatchingLightProduction.pellMatching_9839_checked

theorem pellMagnitudes_9839_large : ∀ x ∈ pellMagnitudes_9839, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9839 PellMatchingLightProduction.pellMagnitudes_9839_large

def pellGraphCertificate_9839 : PellMatchingCertificate 9839 where
  magnitudes := pellMagnitudes_9839
  masks := pellMasks_9839
  witnesses := pellWitnesses_9839
  masks_valid := pellMasks_9839_valid
  checked := pellMatching_9839_checked
  large := pellMagnitudes_9839_large

def pellMagnitudes_9871 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9871

def pellMasks_9871 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9871.map pellLightMasksToOriginal

def pellWitnesses_9871 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9871

theorem pellMasks_9871_valid : ∀ m ∈ pellMasks_9871, m.Valid 9871 := by
  exact pellLightMasks_valid 9871 PellMatchingLightProduction.pellMasks_9871 PellMatchingLightProduction.pellMasks_9871_valid

theorem pellMatching_9871_checked :
    pellMatchingCheck pellMasks_9871 pellMagnitudes_9871 pellWitnesses_9871 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9871
    PellMatchingLightProduction.pellMagnitudes_9871 PellMatchingLightProduction.pellWitnesses_9871).symm.trans
      PellMatchingLightProduction.pellMatching_9871_checked

theorem pellMagnitudes_9871_large : ∀ x ∈ pellMagnitudes_9871, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9871 PellMatchingLightProduction.pellMagnitudes_9871_large

def pellGraphCertificate_9871 : PellMatchingCertificate 9871 where
  magnitudes := pellMagnitudes_9871
  masks := pellMasks_9871
  witnesses := pellWitnesses_9871
  masks_valid := pellMasks_9871_valid
  checked := pellMatching_9871_checked
  large := pellMagnitudes_9871_large

def pellMagnitudes_9887 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9887

def pellMasks_9887 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9887.map pellLightMasksToOriginal

def pellWitnesses_9887 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9887

theorem pellMasks_9887_valid : ∀ m ∈ pellMasks_9887, m.Valid 9887 := by
  exact pellLightMasks_valid 9887 PellMatchingLightProduction.pellMasks_9887 PellMatchingLightProduction.pellMasks_9887_valid

theorem pellMatching_9887_checked :
    pellMatchingCheck pellMasks_9887 pellMagnitudes_9887 pellWitnesses_9887 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9887
    PellMatchingLightProduction.pellMagnitudes_9887 PellMatchingLightProduction.pellWitnesses_9887).symm.trans
      PellMatchingLightProduction.pellMatching_9887_checked

theorem pellMagnitudes_9887_large : ∀ x ∈ pellMagnitudes_9887, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9887 PellMatchingLightProduction.pellMagnitudes_9887_large

def pellGraphCertificate_9887 : PellMatchingCertificate 9887 where
  magnitudes := pellMagnitudes_9887
  masks := pellMasks_9887
  witnesses := pellWitnesses_9887
  masks_valid := pellMasks_9887_valid
  checked := pellMatching_9887_checked
  large := pellMagnitudes_9887_large

def pellMagnitudes_9959 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9959

def pellMasks_9959 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9959.map pellLightMasksToOriginal

def pellWitnesses_9959 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9959

theorem pellMasks_9959_valid : ∀ m ∈ pellMasks_9959, m.Valid 9959 := by
  exact pellLightMasks_valid 9959 PellMatchingLightProduction.pellMasks_9959 PellMatchingLightProduction.pellMasks_9959_valid

theorem pellMatching_9959_checked :
    pellMatchingCheck pellMasks_9959 pellMagnitudes_9959 pellWitnesses_9959 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9959
    PellMatchingLightProduction.pellMagnitudes_9959 PellMatchingLightProduction.pellWitnesses_9959).symm.trans
      PellMatchingLightProduction.pellMatching_9959_checked

theorem pellMagnitudes_9959_large : ∀ x ∈ pellMagnitudes_9959, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9959 PellMatchingLightProduction.pellMagnitudes_9959_large

def pellGraphCertificate_9959 : PellMatchingCertificate 9959 where
  magnitudes := pellMagnitudes_9959
  masks := pellMasks_9959
  witnesses := pellWitnesses_9959
  masks_valid := pellMasks_9959_valid
  checked := pellMatching_9959_checked
  large := pellMagnitudes_9959_large

def pellMagnitudes_9967 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9967

def pellMasks_9967 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9967.map pellLightMasksToOriginal

def pellWitnesses_9967 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9967

theorem pellMasks_9967_valid : ∀ m ∈ pellMasks_9967, m.Valid 9967 := by
  exact pellLightMasks_valid 9967 PellMatchingLightProduction.pellMasks_9967 PellMatchingLightProduction.pellMasks_9967_valid

theorem pellMatching_9967_checked :
    pellMatchingCheck pellMasks_9967 pellMagnitudes_9967 pellWitnesses_9967 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9967
    PellMatchingLightProduction.pellMagnitudes_9967 PellMatchingLightProduction.pellWitnesses_9967).symm.trans
      PellMatchingLightProduction.pellMatching_9967_checked

theorem pellMagnitudes_9967_large : ∀ x ∈ pellMagnitudes_9967, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9967 PellMatchingLightProduction.pellMagnitudes_9967_large

def pellGraphCertificate_9967 : PellMatchingCertificate 9967 where
  magnitudes := pellMagnitudes_9967
  masks := pellMasks_9967
  witnesses := pellWitnesses_9967
  masks_valid := pellMasks_9967_valid
  checked := pellMatching_9967_checked
  large := pellMagnitudes_9967_large

def pellMagnitudes_9991 : List ℤ :=
  PellMatchingLightProduction.pellMagnitudes_9991

def pellMasks_9991 : List PellSquareMasks :=
  PellMatchingLightProduction.pellMasks_9991.map pellLightMasksToOriginal

def pellWitnesses_9991 : List (List (ℕ × ℕ)) :=
  PellMatchingLightProduction.pellWitnesses_9991

theorem pellMasks_9991_valid : ∀ m ∈ pellMasks_9991, m.Valid 9991 := by
  exact pellLightMasks_valid 9991 PellMatchingLightProduction.pellMasks_9991 PellMatchingLightProduction.pellMasks_9991_valid

theorem pellMatching_9991_checked :
    pellMatchingCheck pellMasks_9991 pellMagnitudes_9991 pellWitnesses_9991 = true := by
  exact (pellLightMatchingCheck_eq PellMatchingLightProduction.pellMasks_9991
    PellMatchingLightProduction.pellMagnitudes_9991 PellMatchingLightProduction.pellWitnesses_9991).symm.trans
      PellMatchingLightProduction.pellMatching_9991_checked

theorem pellMagnitudes_9991_large : ∀ x ∈ pellMagnitudes_9991, 2 ≤ x := by
  exact pellLightMagnitudes_large PellMatchingLightProduction.pellMagnitudes_9991 PellMatchingLightProduction.pellMagnitudes_9991_large

def pellGraphCertificate_9991 : PellMatchingCertificate 9991 where
  magnitudes := pellMagnitudes_9991
  masks := pellMasks_9991
  witnesses := pellWitnesses_9991
  masks_valid := pellMasks_9991_valid
  checked := pellMatching_9991_checked
  large := pellMagnitudes_9991_large

end D1Bound5
