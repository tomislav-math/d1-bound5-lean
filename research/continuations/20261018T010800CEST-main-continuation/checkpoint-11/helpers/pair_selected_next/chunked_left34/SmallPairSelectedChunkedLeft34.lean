import D1Bound5.SmallPairLiteralCachedData34
import D1Bound5.SmallPairSelectedData34
import D1Bound5.PairSelectedFloorChunks

namespace D1Bound5.PairSelectedChunkedPilot34
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- Exact original left class. No coordinate or residue is duplicated. -/
def cached00 : List (PairResidueVertex 1 2) := PairLiteralPilot34.leftCached
def rows00 : List (ℕ × List ℕ) := PairSelectedPilot34.leftRows

def cached01 : List (PairResidueVertex 1 2) := cached00.drop 16
def rows01 : List (ℕ × List ℕ) := rows00.drop 16

def cached02 : List (PairResidueVertex 1 2) := cached01.drop 16
def rows02 : List (ℕ × List ℕ) := rows01.drop 16

def cached03 : List (PairResidueVertex 1 2) := cached02.drop 16
def rows03 : List (ℕ × List ℕ) := rows02.drop 16

def cached04 : List (PairResidueVertex 1 2) := cached03.drop 16
def rows04 : List (ℕ × List ℕ) := rows03.drop 16

def cached05 : List (PairResidueVertex 1 2) := cached04.drop 16
def rows05 : List (ℕ × List ℕ) := rows04.drop 16

def cached06 : List (PairResidueVertex 1 2) := cached05.drop 16
def rows06 : List (ℕ × List ℕ) := rows05.drop 16

def cached07 : List (PairResidueVertex 1 2) := cached06.drop 16
def rows07 : List (ℕ × List ℕ) := rows06.drop 16

def cached08 : List (PairResidueVertex 1 2) := cached07.drop 16
def rows08 : List (ℕ × List ℕ) := rows07.drop 16

def cached09 : List (PairResidueVertex 1 2) := cached08.drop 16
def rows09 : List (ℕ × List ℕ) := rows08.drop 16

def cached10 : List (PairResidueVertex 1 2) := cached09.drop 16
def rows10 : List (ℕ × List ℕ) := rows09.drop 16

def cached11 : List (PairResidueVertex 1 2) := cached10.drop 16
def rows11 : List (ℕ × List ℕ) := rows10.drop 16

def cached12 : List (PairResidueVertex 1 2) := cached11.drop 16
def rows12 : List (ℕ × List ℕ) := rows11.drop 16

def cached13 : List (PairResidueVertex 1 2) := cached12.drop 16
def rows13 : List (ℕ × List ℕ) := rows12.drop 16

def cached14 : List (PairResidueVertex 1 2) := cached13.drop 16
def rows14 : List (ℕ × List ℕ) := rows13.drop 16

def cached15 : List (PairResidueVertex 1 2) := cached14.drop 16
def rows15 : List (ℕ × List ℕ) := rows14.drop 16

/-- Full original vertex projection, checked separately from row work. -/
theorem left_coverage_checked :
    PairLiteralPilot34.leftCached.map PairResidueVertex.vertex =
      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).1 := by
  decide +kernel

/-- Every original cached signature, checked separately from row work. -/
theorem left_signatures_checked :
    (PairLiteralPilot34.leftCached.all fun x =>
      decide (x.signature = pairCoordinateSignature smallPairSieve_1_2 x.vertex)) = true := by
  decide +kernel

/-- Heads 0 through 15, each against its full actual tail. -/
theorem left_prefix_00_checked :
    pairSelectedFloorPrefixBool smallPairSieve_1_2 16 cached00 rows00 = true := by
  decide +kernel

/-- Heads 16 through 31, each against its full actual tail. -/
theorem left_prefix_01_checked :
    pairSelectedFloorPrefixBool smallPairSieve_1_2 16 cached01 rows01 = true := by
  decide +kernel

/-- Heads 32 through 47, each against its full actual tail. -/
theorem left_prefix_02_checked :
    pairSelectedFloorPrefixBool smallPairSieve_1_2 16 cached02 rows02 = true := by
  decide +kernel

/-- Heads 48 through 63, each against its full actual tail. -/
theorem left_prefix_03_checked :
    pairSelectedFloorPrefixBool smallPairSieve_1_2 16 cached03 rows03 = true := by
  decide +kernel

/-- Heads 64 through 79, each against its full actual tail. -/
theorem left_prefix_04_checked :
    pairSelectedFloorPrefixBool smallPairSieve_1_2 16 cached04 rows04 = true := by
  decide +kernel

/-- Heads 80 through 95, each against its full actual tail. -/
theorem left_prefix_05_checked :
    pairSelectedFloorPrefixBool smallPairSieve_1_2 16 cached05 rows05 = true := by
  decide +kernel

/-- Heads 96 through 111, each against its full actual tail. -/
theorem left_prefix_06_checked :
    pairSelectedFloorPrefixBool smallPairSieve_1_2 16 cached06 rows06 = true := by
  decide +kernel

/-- Heads 112 through 127, each against its full actual tail. -/
theorem left_prefix_07_checked :
    pairSelectedFloorPrefixBool smallPairSieve_1_2 16 cached07 rows07 = true := by
  decide +kernel

/-- Heads 128 through 143, each against its full actual tail. -/
theorem left_prefix_08_checked :
    pairSelectedFloorPrefixBool smallPairSieve_1_2 16 cached08 rows08 = true := by
  decide +kernel

/-- Heads 144 through 159, each against its full actual tail. -/
theorem left_prefix_09_checked :
    pairSelectedFloorPrefixBool smallPairSieve_1_2 16 cached09 rows09 = true := by
  decide +kernel

/-- Heads 160 through 175, each against its full actual tail. -/
theorem left_prefix_10_checked :
    pairSelectedFloorPrefixBool smallPairSieve_1_2 16 cached10 rows10 = true := by
  decide +kernel

/-- Heads 176 through 191, each against its full actual tail. -/
theorem left_prefix_11_checked :
    pairSelectedFloorPrefixBool smallPairSieve_1_2 16 cached11 rows11 = true := by
  decide +kernel

/-- Heads 192 through 207, each against its full actual tail. -/
theorem left_prefix_12_checked :
    pairSelectedFloorPrefixBool smallPairSieve_1_2 16 cached12 rows12 = true := by
  decide +kernel

/-- Heads 208 through 223, each against its full actual tail. -/
theorem left_prefix_13_checked :
    pairSelectedFloorPrefixBool smallPairSieve_1_2 16 cached13 rows13 = true := by
  decide +kernel

/-- Heads 224 through 228, each against its full actual tail. -/
theorem left_prefix_14_checked :
    pairSelectedFloorPrefixBool smallPairSieve_1_2 16 cached14 rows14 = true := by
  decide +kernel

/-- After the15 complete blocks, both original lists are exhausted. -/
theorem left_remainder_15_checked :
    pairSelectedFloorIndependentBool smallPairSieve_1_2 cached15 rows15 = true := by
  rfl

theorem left_remainder_14_checked :
    pairSelectedFloorIndependentBool smallPairSieve_1_2 cached14 rows14 = true :=
  pairSelectedFloorIndependentBool_of_prefix_drop smallPairSieve_1_2 16
    cached14 rows14 left_prefix_14_checked left_remainder_15_checked

theorem left_remainder_13_checked :
    pairSelectedFloorIndependentBool smallPairSieve_1_2 cached13 rows13 = true :=
  pairSelectedFloorIndependentBool_of_prefix_drop smallPairSieve_1_2 16
    cached13 rows13 left_prefix_13_checked left_remainder_14_checked

theorem left_remainder_12_checked :
    pairSelectedFloorIndependentBool smallPairSieve_1_2 cached12 rows12 = true :=
  pairSelectedFloorIndependentBool_of_prefix_drop smallPairSieve_1_2 16
    cached12 rows12 left_prefix_12_checked left_remainder_13_checked

theorem left_remainder_11_checked :
    pairSelectedFloorIndependentBool smallPairSieve_1_2 cached11 rows11 = true :=
  pairSelectedFloorIndependentBool_of_prefix_drop smallPairSieve_1_2 16
    cached11 rows11 left_prefix_11_checked left_remainder_12_checked

theorem left_remainder_10_checked :
    pairSelectedFloorIndependentBool smallPairSieve_1_2 cached10 rows10 = true :=
  pairSelectedFloorIndependentBool_of_prefix_drop smallPairSieve_1_2 16
    cached10 rows10 left_prefix_10_checked left_remainder_11_checked

theorem left_remainder_09_checked :
    pairSelectedFloorIndependentBool smallPairSieve_1_2 cached09 rows09 = true :=
  pairSelectedFloorIndependentBool_of_prefix_drop smallPairSieve_1_2 16
    cached09 rows09 left_prefix_09_checked left_remainder_10_checked

theorem left_remainder_08_checked :
    pairSelectedFloorIndependentBool smallPairSieve_1_2 cached08 rows08 = true :=
  pairSelectedFloorIndependentBool_of_prefix_drop smallPairSieve_1_2 16
    cached08 rows08 left_prefix_08_checked left_remainder_09_checked

theorem left_remainder_07_checked :
    pairSelectedFloorIndependentBool smallPairSieve_1_2 cached07 rows07 = true :=
  pairSelectedFloorIndependentBool_of_prefix_drop smallPairSieve_1_2 16
    cached07 rows07 left_prefix_07_checked left_remainder_08_checked

theorem left_remainder_06_checked :
    pairSelectedFloorIndependentBool smallPairSieve_1_2 cached06 rows06 = true :=
  pairSelectedFloorIndependentBool_of_prefix_drop smallPairSieve_1_2 16
    cached06 rows06 left_prefix_06_checked left_remainder_07_checked

theorem left_remainder_05_checked :
    pairSelectedFloorIndependentBool smallPairSieve_1_2 cached05 rows05 = true :=
  pairSelectedFloorIndependentBool_of_prefix_drop smallPairSieve_1_2 16
    cached05 rows05 left_prefix_05_checked left_remainder_06_checked

theorem left_remainder_04_checked :
    pairSelectedFloorIndependentBool smallPairSieve_1_2 cached04 rows04 = true :=
  pairSelectedFloorIndependentBool_of_prefix_drop smallPairSieve_1_2 16
    cached04 rows04 left_prefix_04_checked left_remainder_05_checked

theorem left_remainder_03_checked :
    pairSelectedFloorIndependentBool smallPairSieve_1_2 cached03 rows03 = true :=
  pairSelectedFloorIndependentBool_of_prefix_drop smallPairSieve_1_2 16
    cached03 rows03 left_prefix_03_checked left_remainder_04_checked

theorem left_remainder_02_checked :
    pairSelectedFloorIndependentBool smallPairSieve_1_2 cached02 rows02 = true :=
  pairSelectedFloorIndependentBool_of_prefix_drop smallPairSieve_1_2 16
    cached02 rows02 left_prefix_02_checked left_remainder_03_checked

theorem left_remainder_01_checked :
    pairSelectedFloorIndependentBool smallPairSieve_1_2 cached01 rows01 = true :=
  pairSelectedFloorIndependentBool_of_prefix_drop smallPairSieve_1_2 16
    cached01 rows01 left_prefix_01_checked left_remainder_02_checked

theorem left_remainder_00_checked :
    pairSelectedFloorIndependentBool smallPairSieve_1_2 cached00 rows00 = true :=
  pairSelectedFloorIndependentBool_of_prefix_drop smallPairSieve_1_2 16
    cached00 rows00 left_prefix_00_checked left_remainder_01_checked

/-- Assemble proof constants; do not recompute a monolithic checker here. -/
theorem left_certificate_checked :
    pairSelectedFloorIndependentCertificateBool smallPairSieve_1_2
      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).1
      PairLiteralPilot34.leftCached PairSelectedPilot34.leftRows = true := by
  apply Bool.and_eq_true_iff.mpr
  refine ⟨?_, Bool.and_eq_true_iff.mpr
    ⟨left_signatures_checked, left_remainder_00_checked⟩⟩
  simp [left_coverage_checked]

/-- Exactly the original left independent-class target. -/
theorem left_checked :
    pairIndependentBool smallPairSieve_1_2
      (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).1 = true :=
  pairIndependentBool_of_selected_floor_certificate (by decide) smallPairSieve_1_2
    (pairSplitByMask smallPairLarge_34 PairGraphPrepared34.colors).1
    PairLiteralPilot34.leftCached PairSelectedPilot34.leftRows left_certificate_checked

end D1Bound5.PairSelectedChunkedPilot34
