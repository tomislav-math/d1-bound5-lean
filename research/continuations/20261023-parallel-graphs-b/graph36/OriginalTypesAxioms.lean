import D1Bound5.SmallPairGraphData36
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
noncomputable section

namespace D1Bound5
open QuadInt
example :
    pairSeedsCoveredBool smallPairA_36 smallPairB_36
      seedRootDisk_1_2 smallPairClosure_36 = true := smallPairSeeds_36_checked
end D1Bound5

namespace D1Bound5
open QuadInt
example :
    largePairVertices smallPairA_36 smallPairB_36 smallPairClosure_36 = smallPairLarge_36 := smallPairFilter_36_checked
end D1Bound5

namespace D1Bound5
open QuadInt
example : smallPairLarge_36.length = 1121 := smallPairLarge_36_count
end D1Bound5

namespace D1Bound5
open QuadInt
open PairGraphPrepared36
example :
    pairClosureIndexedWitnessBool smallPairA_36 smallPairB_36 anchorRoot
      (10^1100) smallPairClosure_36 witnesses destinations = true := PairGraphPrepared36.indexed_checked
end D1Bound5

namespace D1Bound5
open QuadInt
open PairGraphPrepared36
example :
    pairClosureBool smallPairA_36 smallPairB_36
      (10^1100) smallPairClosure_36 = true := smallPairClosure_36_checked
end D1Bound5

namespace D1Bound5
open QuadInt
example : QuadInt 1 2 := smallPairA_36
end D1Bound5

namespace D1Bound5
open QuadInt
example : QuadInt 1 2 := smallPairB_36
end D1Bound5

namespace D1Bound5
open QuadInt
example : List (QuadInt 1 2) := smallPairClosure_36
end D1Bound5

namespace D1Bound5
open QuadInt
example : List (QuadInt 1 2) := smallPairLarge_36
end D1Bound5

namespace D1Bound5.PairGraphPrepared36
open QuadInt
example : ℕ := colors
end D1Bound5.PairGraphPrepared36

namespace D1Bound5.PairGraphPrepared36
example : QuadInt 1 2 := anchorRoot
end D1Bound5.PairGraphPrepared36

namespace D1Bound5.PairGraphPrepared36
example : List (QuadInt 1 2 × QuadInt 1 2) := rootPairs
end D1Bound5.PairGraphPrepared36

namespace D1Bound5.PairGraphPrepared36
example : List (PairRootWitness 1 2) := witnesses
end D1Bound5.PairGraphPrepared36

namespace D1Bound5.PairGraphPrepared36
example : List (Option ℕ × Option ℕ) := destinations
end D1Bound5.PairGraphPrepared36

namespace D1Bound5.PairSelectedPrepared36
example : List (PairResidueVertex 1 2) := leftCached
end D1Bound5.PairSelectedPrepared36

namespace D1Bound5.PairSelectedPrepared36
example : List (ℕ × List ℕ) := leftRows
end D1Bound5.PairSelectedPrepared36

namespace D1Bound5.PairSelectedPrepared36
example : List (PairResidueVertex 1 2) := rightCached
end D1Bound5.PairSelectedPrepared36

namespace D1Bound5.PairSelectedPrepared36
example : List (ℕ × List ℕ) := rightRows
end D1Bound5.PairSelectedPrepared36

namespace D1Bound5.PairLightPrepared36
example : sieve = smallPairSieve_1_2 := sieve_eq
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example :
    leftVertices = (pairSplitByMask smallPairLarge_36 PairGraphPrepared36.colors).1.map pairLightCoordinates := leftVertices_eq
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example :
    leftCached = PairSelectedPrepared36.leftCached.map pairLightCachedCoordinates := leftCached_eq
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example : leftRows = PairSelectedPrepared36.leftRows := leftRows_eq
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example :
    pairIndependentBool smallPairSieve_1_2 (pairSplitByMask smallPairLarge_36 PairGraphPrepared36.colors).1 = true := left_checked
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example :
    rightVertices = (pairSplitByMask smallPairLarge_36 PairGraphPrepared36.colors).2.map pairLightCoordinates := rightVertices_eq
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example :
    rightCached = PairSelectedPrepared36.rightCached.map pairLightCachedCoordinates := rightCached_eq
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example : rightRows = PairSelectedPrepared36.rightRows := rightRows_eq
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example :
    pairIndependentBool smallPairSieve_1_2 (pairSplitByMask smallPairLarge_36 PairGraphPrepared36.colors).2 = true := right_checked
end D1Bound5.PairLightPrepared36

namespace D1Bound5
example :
    pairGraphTriangleFreeBool smallPairSieve_1_2 smallPairLarge_36 = true := smallPairNoTriangle_36_checked
end D1Bound5

namespace D1Bound5.PairLightAdaptivePrepared36
example : List PairLightCachedVertex := leftCached000
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example : List (Nat × List Nat) := leftRows000
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example : List PairLightCachedVertex := leftCached001
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example : List (Nat × List Nat) := leftRows001
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example : List PairLightCachedVertex := leftCached002
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example : List (Nat × List Nat) := leftRows002
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example : List PairLightCachedVertex := leftCached003
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example : List (Nat × List Nat) := leftRows003
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example : List PairLightCachedVertex := leftCached004
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example : List (Nat × List Nat) := leftRows004
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example : List PairLightCachedVertex := rightCached000
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example : List (Nat × List Nat) := rightRows000
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example : List PairLightCachedVertex := rightCached001
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example : List (Nat × List Nat) := rightRows001
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example : List PairLightCachedVertex := rightCached002
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example : List (Nat × List Nat) := rightRows002
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example : List PairLightCachedVertex := rightCached003
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example : List (Nat × List Nat) := rightRows003
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example : List PairLightCachedVertex := rightCached004
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example : List (Nat × List Nat) := rightRows004
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 76
      leftCached000 leftRows000 = true := left_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 91
      leftCached001 leftRows001 = true := left_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 119
      leftCached002 leftRows002 = true := left_prefix_002_checked
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 275
      leftCached003 leftRows003 = true := left_prefix_003_checked
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 76
      rightCached000 rightRows000 = true := right_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 91
      rightCached001 rightRows001 = true := right_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 120
      rightCached002 rightRows002 = true := right_prefix_002_checked
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example :
    pairLightSelectedFloorPrefixBool 1 2 PairLightPrepared36.sieve 273
      rightCached003 rightRows003 = true := right_prefix_003_checked
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example :
    decide (PairLightPrepared36.leftCached.map Prod.fst = PairLightPrepared36.leftVertices) = true := left_coverage_checked
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example :
    (PairLightPrepared36.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared36.sieve x.1)) = true := left_signatures_checked
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example :
    decide (PairLightPrepared36.rightCached.map Prod.fst = PairLightPrepared36.rightVertices) = true := right_coverage_checked
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightAdaptivePrepared36
example :
    (PairLightPrepared36.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared36.sieve x.1)) = true := right_signatures_checked
end D1Bound5.PairLightAdaptivePrepared36

namespace D1Bound5.PairLightPrepared36
example : List (Nat × Nat) := sieve
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example : List PairLightCoordinate := leftVertices
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example : List PairLightCachedVertex := leftCached
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example : List (Nat × List Nat) := leftRows
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example : List PairLightCoordinate := rightVertices
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example : List PairLightCachedVertex := rightCached
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example : List (Nat × List Nat) := rightRows
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example :
    decide (leftCached.map Prod.fst = leftVertices) = true := left_coverage_checked
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true := left_signatures_checked
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example :
    pairLightSelectedFloorIndependentBool 1 2 sieve leftCached leftRows = true := left_independent_checked
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example :
    pairLightSelectedFloorIndependentCertificateBool 1 2 sieve
      leftVertices leftCached leftRows = true := left_certificate_checked
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example :
    decide (rightCached.map Prod.fst = rightVertices) = true := right_coverage_checked
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true := right_signatures_checked
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example :
    pairLightSelectedFloorIndependentBool 1 2 sieve rightCached rightRows = true := right_independent_checked
end D1Bound5.PairLightPrepared36

namespace D1Bound5.PairLightPrepared36
example :
    pairLightSelectedFloorIndependentCertificateBool 1 2 sieve
      rightVertices rightCached rightRows = true := right_certificate_checked
end D1Bound5.PairLightPrepared36

run_cmd do
  for name in ([`D1Bound5.PairGraphPrepared36.anchorRoot, `D1Bound5.PairGraphPrepared36.colors, `D1Bound5.PairGraphPrepared36.destinations, `D1Bound5.PairGraphPrepared36.indexed_checked, `D1Bound5.PairGraphPrepared36.indexed_coverage_checked, `D1Bound5.PairGraphPrepared36.rootPairs, `D1Bound5.PairGraphPrepared36.witnesses, `D1Bound5.PairLightAdaptivePrepared36.leftCached000, `D1Bound5.PairLightAdaptivePrepared36.leftCached001, `D1Bound5.PairLightAdaptivePrepared36.leftCached002, `D1Bound5.PairLightAdaptivePrepared36.leftCached003, `D1Bound5.PairLightAdaptivePrepared36.leftCached004, `D1Bound5.PairLightAdaptivePrepared36.leftRows000, `D1Bound5.PairLightAdaptivePrepared36.leftRows001, `D1Bound5.PairLightAdaptivePrepared36.leftRows002, `D1Bound5.PairLightAdaptivePrepared36.leftRows003, `D1Bound5.PairLightAdaptivePrepared36.leftRows004, `D1Bound5.PairLightAdaptivePrepared36.left_coverage_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_000_part00_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_000_part01_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_000_part02_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_000_part03_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_000_part04_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_000_part05_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_000_part06_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_001_part07_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_002_part07_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_002_part08_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_002_part09_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part00_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part01_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part02_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part03_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part04_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part05_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part06_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part07_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part08_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part09_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part10_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part11_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part12_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part13_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part14_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part15_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part16_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part17_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part18_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part19_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part20_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part21_checked, `D1Bound5.PairLightAdaptivePrepared36.left_parallel_003_part22_checked, `D1Bound5.PairLightAdaptivePrepared36.left_prefix_000_checked, `D1Bound5.PairLightAdaptivePrepared36.left_prefix_001_checked, `D1Bound5.PairLightAdaptivePrepared36.left_prefix_002_checked, `D1Bound5.PairLightAdaptivePrepared36.left_prefix_003_checked, `D1Bound5.PairLightAdaptivePrepared36.left_signatures_checked, `D1Bound5.PairLightAdaptivePrepared36.rightCached000, `D1Bound5.PairLightAdaptivePrepared36.rightCached001, `D1Bound5.PairLightAdaptivePrepared36.rightCached002, `D1Bound5.PairLightAdaptivePrepared36.rightCached003, `D1Bound5.PairLightAdaptivePrepared36.rightCached004, `D1Bound5.PairLightAdaptivePrepared36.rightRows000, `D1Bound5.PairLightAdaptivePrepared36.rightRows001, `D1Bound5.PairLightAdaptivePrepared36.rightRows002, `D1Bound5.PairLightAdaptivePrepared36.rightRows003, `D1Bound5.PairLightAdaptivePrepared36.rightRows004, `D1Bound5.PairLightAdaptivePrepared36.right_coverage_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_000_part00_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_000_part01_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_000_part02_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_000_part03_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_000_part04_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_000_part05_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_000_part06_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_001_part07_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_002_part07_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_002_part08_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_002_part09_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part00_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part01_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part02_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part03_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part04_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part05_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part06_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part07_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part08_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part09_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part10_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part11_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part12_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part13_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part14_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part15_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part16_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part17_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part18_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part19_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part20_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part21_checked, `D1Bound5.PairLightAdaptivePrepared36.right_parallel_003_part22_checked, `D1Bound5.PairLightAdaptivePrepared36.right_prefix_000_checked, `D1Bound5.PairLightAdaptivePrepared36.right_prefix_001_checked, `D1Bound5.PairLightAdaptivePrepared36.right_prefix_002_checked, `D1Bound5.PairLightAdaptivePrepared36.right_prefix_003_checked, `D1Bound5.PairLightAdaptivePrepared36.right_signatures_checked, `D1Bound5.PairLightClosurePrepared36.a, `D1Bound5.PairLightClosurePrepared36.a_eq, `D1Bound5.PairLightClosurePrepared36.all_checked, `D1Bound5.PairLightClosurePrepared36.anchorRoot, `D1Bound5.PairLightClosurePrepared36.anchorRoot_eq, `D1Bound5.PairLightClosurePrepared36.b, `D1Bound5.PairLightClosurePrepared36.b_eq, `D1Bound5.PairLightClosurePrepared36.chunk00_checked, `D1Bound5.PairLightClosurePrepared36.chunk01_checked, `D1Bound5.PairLightClosurePrepared36.chunk02_checked, `D1Bound5.PairLightClosurePrepared36.chunk03_checked, `D1Bound5.PairLightClosurePrepared36.chunk04_checked, `D1Bound5.PairLightClosurePrepared36.chunk05_checked, `D1Bound5.PairLightClosurePrepared36.chunk06_checked, `D1Bound5.PairLightClosurePrepared36.chunk07_checked, `D1Bound5.PairLightClosurePrepared36.chunk08_checked, `D1Bound5.PairLightClosurePrepared36.chunk09_checked, `D1Bound5.PairLightClosurePrepared36.chunk10_checked, `D1Bound5.PairLightClosurePrepared36.chunk11_checked, `D1Bound5.PairLightClosurePrepared36.chunk12_checked, `D1Bound5.PairLightClosurePrepared36.chunk13_checked, `D1Bound5.PairLightClosurePrepared36.chunk14_checked, `D1Bound5.PairLightClosurePrepared36.chunk15_checked, `D1Bound5.PairLightClosurePrepared36.chunk16_checked, `D1Bound5.PairLightClosurePrepared36.chunk17_checked, `D1Bound5.PairLightClosurePrepared36.destinations, `D1Bound5.PairLightClosurePrepared36.destinationsChunk00, `D1Bound5.PairLightClosurePrepared36.destinationsChunk01, `D1Bound5.PairLightClosurePrepared36.destinationsChunk02, `D1Bound5.PairLightClosurePrepared36.destinationsChunk03, `D1Bound5.PairLightClosurePrepared36.destinationsChunk04, `D1Bound5.PairLightClosurePrepared36.destinationsChunk05, `D1Bound5.PairLightClosurePrepared36.destinationsChunk06, `D1Bound5.PairLightClosurePrepared36.destinationsChunk07, `D1Bound5.PairLightClosurePrepared36.destinationsChunk08, `D1Bound5.PairLightClosurePrepared36.destinations_eq, `D1Bound5.PairLightClosurePrepared36.original_indexed_checked, `D1Bound5.PairLightClosurePrepared36.original_witnesses_checked, `D1Bound5.PairLightClosurePrepared36.rootPairs, `D1Bound5.PairLightClosurePrepared36.rootPairsChunk00, `D1Bound5.PairLightClosurePrepared36.rootPairsChunk01, `D1Bound5.PairLightClosurePrepared36.rootPairsChunk02, `D1Bound5.PairLightClosurePrepared36.rootPairsChunk03, `D1Bound5.PairLightClosurePrepared36.rootPairsChunk04, `D1Bound5.PairLightClosurePrepared36.rootPairsChunk05, `D1Bound5.PairLightClosurePrepared36.rootPairsChunk06, `D1Bound5.PairLightClosurePrepared36.rootPairsChunk07, `D1Bound5.PairLightClosurePrepared36.rootPairsChunk08, `D1Bound5.PairLightClosurePrepared36.vertices, `D1Bound5.PairLightClosurePrepared36.verticesChunk00, `D1Bound5.PairLightClosurePrepared36.verticesChunk01, `D1Bound5.PairLightClosurePrepared36.verticesChunk02, `D1Bound5.PairLightClosurePrepared36.verticesChunk03, `D1Bound5.PairLightClosurePrepared36.verticesChunk04, `D1Bound5.PairLightClosurePrepared36.verticesChunk05, `D1Bound5.PairLightClosurePrepared36.verticesChunk06, `D1Bound5.PairLightClosurePrepared36.verticesChunk07, `D1Bound5.PairLightClosurePrepared36.verticesChunk08, `D1Bound5.PairLightClosurePrepared36.vertices_eq, `D1Bound5.PairLightClosurePrepared36.witnesses, `D1Bound5.PairLightClosurePrepared36.witnesses_eq, `D1Bound5.PairLightPrepared36.leftCached, `D1Bound5.PairLightPrepared36.leftCachedChunk00, `D1Bound5.PairLightPrepared36.leftCachedChunk01, `D1Bound5.PairLightPrepared36.leftCachedChunk02, `D1Bound5.PairLightPrepared36.leftCachedChunk03, `D1Bound5.PairLightPrepared36.leftCachedChunk04, `D1Bound5.PairLightPrepared36.leftCached_eq, `D1Bound5.PairLightPrepared36.leftRows, `D1Bound5.PairLightPrepared36.leftRows_eq, `D1Bound5.PairLightPrepared36.leftVertices, `D1Bound5.PairLightPrepared36.leftVertices_eq, `D1Bound5.PairLightPrepared36.left_certificate_checked, `D1Bound5.PairLightPrepared36.left_checked, `D1Bound5.PairLightPrepared36.left_coverage_checked, `D1Bound5.PairLightPrepared36.left_independent_checked, `D1Bound5.PairLightPrepared36.left_signatures_checked, `D1Bound5.PairLightPrepared36.rightCached, `D1Bound5.PairLightPrepared36.rightCachedChunk00, `D1Bound5.PairLightPrepared36.rightCachedChunk01, `D1Bound5.PairLightPrepared36.rightCachedChunk02, `D1Bound5.PairLightPrepared36.rightCachedChunk03, `D1Bound5.PairLightPrepared36.rightCachedChunk04, `D1Bound5.PairLightPrepared36.rightCached_eq, `D1Bound5.PairLightPrepared36.rightRows, `D1Bound5.PairLightPrepared36.rightRows_eq, `D1Bound5.PairLightPrepared36.rightVertices, `D1Bound5.PairLightPrepared36.rightVertices_eq, `D1Bound5.PairLightPrepared36.right_certificate_checked, `D1Bound5.PairLightPrepared36.right_checked, `D1Bound5.PairLightPrepared36.right_coverage_checked, `D1Bound5.PairLightPrepared36.right_independent_checked, `D1Bound5.PairLightPrepared36.right_signatures_checked, `D1Bound5.PairLightPrepared36.sieve, `D1Bound5.PairLightPrepared36.sieve_eq, `D1Bound5.PairSelectedPrepared36.leftCached, `D1Bound5.PairSelectedPrepared36.leftRows, `D1Bound5.PairSelectedPrepared36.rightCached, `D1Bound5.PairSelectedPrepared36.rightRows, `D1Bound5.smallPairA_36, `D1Bound5.smallPairB_36, `D1Bound5.smallPairClosure_36, `D1Bound5.smallPairClosure_36_checked, `D1Bound5.smallPairFilter_36_checked, `D1Bound5.smallPairLarge_36, `D1Bound5.smallPairLarge_36_count, `D1Bound5.smallPairNoTriangle_36_checked, `D1Bound5.smallPairSeeds_36_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
