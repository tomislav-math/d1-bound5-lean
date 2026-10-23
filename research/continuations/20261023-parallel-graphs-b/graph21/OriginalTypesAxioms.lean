import D1Bound5.SmallPairGraphData21
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
noncomputable section

namespace D1Bound5
open QuadInt
example :
    pairSeedsCoveredBool smallPairA_21 smallPairB_21
      seedRootDisk_1_1 smallPairClosure_21 = true := smallPairSeeds_21_checked
end D1Bound5

namespace D1Bound5
open QuadInt
example :
    largePairVertices smallPairA_21 smallPairB_21 smallPairClosure_21 = smallPairLarge_21 := smallPairFilter_21_checked
end D1Bound5

namespace D1Bound5
open QuadInt
example : smallPairLarge_21.length = 1048 := smallPairLarge_21_count
end D1Bound5

namespace D1Bound5
open QuadInt
open PairGraphPrepared21
example :
    pairClosureIndexedWitnessBool smallPairA_21 smallPairB_21 anchorRoot
      (10^1100) smallPairClosure_21 witnesses destinations = true := PairGraphPrepared21.indexed_checked
end D1Bound5

namespace D1Bound5
open QuadInt
open PairGraphPrepared21
example :
    pairClosureBool smallPairA_21 smallPairB_21
      (10^1100) smallPairClosure_21 = true := smallPairClosure_21_checked
end D1Bound5

namespace D1Bound5
open QuadInt
example : QuadInt 1 1 := smallPairA_21
end D1Bound5

namespace D1Bound5
open QuadInt
example : QuadInt 1 1 := smallPairB_21
end D1Bound5

namespace D1Bound5
open QuadInt
example : List (QuadInt 1 1) := smallPairClosure_21
end D1Bound5

namespace D1Bound5
open QuadInt
example : List (QuadInt 1 1) := smallPairLarge_21
end D1Bound5

namespace D1Bound5.PairGraphPrepared21
open QuadInt
example : ℕ := colors
end D1Bound5.PairGraphPrepared21

namespace D1Bound5.PairGraphPrepared21
example : QuadInt 1 1 := anchorRoot
end D1Bound5.PairGraphPrepared21

namespace D1Bound5.PairGraphPrepared21
example : List (QuadInt 1 1 × QuadInt 1 1) := rootPairs
end D1Bound5.PairGraphPrepared21

namespace D1Bound5.PairGraphPrepared21
example : List (PairRootWitness 1 1) := witnesses
end D1Bound5.PairGraphPrepared21

namespace D1Bound5.PairGraphPrepared21
example : List (Option ℕ × Option ℕ) := destinations
end D1Bound5.PairGraphPrepared21

namespace D1Bound5.PairSelectedPrepared21
example : List (PairResidueVertex 1 1) := leftCached
end D1Bound5.PairSelectedPrepared21

namespace D1Bound5.PairSelectedPrepared21
example : List (ℕ × List ℕ) := leftRows
end D1Bound5.PairSelectedPrepared21

namespace D1Bound5.PairSelectedPrepared21
example : List (PairResidueVertex 1 1) := rightCached
end D1Bound5.PairSelectedPrepared21

namespace D1Bound5.PairSelectedPrepared21
example : List (ℕ × List ℕ) := rightRows
end D1Bound5.PairSelectedPrepared21

namespace D1Bound5.PairLightPrepared21
example : sieve = smallPairSieve_1_1 := sieve_eq
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example :
    leftVertices = (pairSplitByMask smallPairLarge_21 PairGraphPrepared21.colors).1.map pairLightCoordinates := leftVertices_eq
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example :
    leftCached = PairSelectedPrepared21.leftCached.map pairLightCachedCoordinates := leftCached_eq
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example : leftRows = PairSelectedPrepared21.leftRows := leftRows_eq
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example :
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_21 PairGraphPrepared21.colors).1 = true := left_checked
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example :
    rightVertices = (pairSplitByMask smallPairLarge_21 PairGraphPrepared21.colors).2.map pairLightCoordinates := rightVertices_eq
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example :
    rightCached = PairSelectedPrepared21.rightCached.map pairLightCachedCoordinates := rightCached_eq
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example : rightRows = PairSelectedPrepared21.rightRows := rightRows_eq
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example :
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_21 PairGraphPrepared21.colors).2 = true := right_checked
end D1Bound5.PairLightPrepared21

namespace D1Bound5
example :
    pairGraphTriangleFreeBool smallPairSieve_1_1 smallPairLarge_21 = true := smallPairNoTriangle_21_checked
end D1Bound5

namespace D1Bound5.PairLightAdaptivePrepared21
example : List PairLightCachedVertex := leftCached000
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example : List (Nat × List Nat) := leftRows000
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example : List PairLightCachedVertex := leftCached001
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example : List (Nat × List Nat) := leftRows001
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example : List PairLightCachedVertex := leftCached002
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example : List (Nat × List Nat) := leftRows002
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example : List PairLightCachedVertex := leftCached003
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example : List (Nat × List Nat) := leftRows003
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example : List PairLightCachedVertex := leftCached004
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example : List (Nat × List Nat) := leftRows004
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example : List PairLightCachedVertex := rightCached000
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example : List (Nat × List Nat) := rightRows000
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example : List PairLightCachedVertex := rightCached001
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example : List (Nat × List Nat) := rightRows001
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example : List PairLightCachedVertex := rightCached002
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example : List (Nat × List Nat) := rightRows002
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example : List PairLightCachedVertex := rightCached003
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example : List (Nat × List Nat) := rightRows003
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example : List PairLightCachedVertex := rightCached004
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example : List (Nat × List Nat) := rightRows004
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared21.sieve 82
      leftCached000 leftRows000 = true := left_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared21.sieve 102
      leftCached001 leftRows001 = true := left_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared21.sieve 151
      leftCached002 leftRows002 = true := left_prefix_002_checked
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared21.sieve 189
      leftCached003 leftRows003 = true := left_prefix_003_checked
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared21.sieve 82
      rightCached000 rightRows000 = true := right_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared21.sieve 102
      rightCached001 rightRows001 = true := right_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared21.sieve 151
      rightCached002 rightRows002 = true := right_prefix_002_checked
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared21.sieve 189
      rightCached003 rightRows003 = true := right_prefix_003_checked
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example :
    decide (PairLightPrepared21.leftCached.map Prod.fst = PairLightPrepared21.leftVertices) = true := left_coverage_checked
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example :
    (PairLightPrepared21.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared21.sieve x.1)) = true := left_signatures_checked
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example :
    decide (PairLightPrepared21.rightCached.map Prod.fst = PairLightPrepared21.rightVertices) = true := right_coverage_checked
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightAdaptivePrepared21
example :
    (PairLightPrepared21.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared21.sieve x.1)) = true := right_signatures_checked
end D1Bound5.PairLightAdaptivePrepared21

namespace D1Bound5.PairLightPrepared21
example : List (Nat × Nat) := sieve
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example : List PairLightCoordinate := leftVertices
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example : List PairLightCachedVertex := leftCached
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example : List (Nat × List Nat) := leftRows
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example : List PairLightCoordinate := rightVertices
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example : List PairLightCachedVertex := rightCached
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example : List (Nat × List Nat) := rightRows
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example :
    decide (leftCached.map Prod.fst = leftVertices) = true := left_coverage_checked
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true := left_signatures_checked
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example :
    pairLightSelectedFloorIndependentBool 1 1 sieve leftCached leftRows = true := left_independent_checked
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example :
    pairLightSelectedFloorIndependentCertificateBool 1 1 sieve
      leftVertices leftCached leftRows = true := left_certificate_checked
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example :
    decide (rightCached.map Prod.fst = rightVertices) = true := right_coverage_checked
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true := right_signatures_checked
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example :
    pairLightSelectedFloorIndependentBool 1 1 sieve rightCached rightRows = true := right_independent_checked
end D1Bound5.PairLightPrepared21

namespace D1Bound5.PairLightPrepared21
example :
    pairLightSelectedFloorIndependentCertificateBool 1 1 sieve
      rightVertices rightCached rightRows = true := right_certificate_checked
end D1Bound5.PairLightPrepared21

run_cmd do
  for name in ([`D1Bound5.PairGraphPrepared21.anchorRoot, `D1Bound5.PairGraphPrepared21.colors, `D1Bound5.PairGraphPrepared21.destinations, `D1Bound5.PairGraphPrepared21.indexed_checked, `D1Bound5.PairGraphPrepared21.indexed_coverage_checked, `D1Bound5.PairGraphPrepared21.rootPairs, `D1Bound5.PairGraphPrepared21.witnesses, `D1Bound5.PairLightAdaptivePrepared21.leftCached000, `D1Bound5.PairLightAdaptivePrepared21.leftCached001, `D1Bound5.PairLightAdaptivePrepared21.leftCached002, `D1Bound5.PairLightAdaptivePrepared21.leftCached003, `D1Bound5.PairLightAdaptivePrepared21.leftCached004, `D1Bound5.PairLightAdaptivePrepared21.leftRows000, `D1Bound5.PairLightAdaptivePrepared21.leftRows001, `D1Bound5.PairLightAdaptivePrepared21.leftRows002, `D1Bound5.PairLightAdaptivePrepared21.leftRows003, `D1Bound5.PairLightAdaptivePrepared21.leftRows004, `D1Bound5.PairLightAdaptivePrepared21.left_coverage_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_000_part00_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_000_part01_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_000_part02_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_000_part03_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_000_part04_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_000_part05_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_000_part06_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_001_part07_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_001_part08_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_002_part07_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_002_part08_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_002_part09_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_002_part10_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_002_part11_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_002_part12_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_003_part00_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_003_part01_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_003_part02_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_003_part03_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_003_part04_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_003_part05_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_003_part06_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_003_part07_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_003_part08_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_003_part09_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_003_part10_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_003_part11_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_003_part12_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_003_part13_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_003_part14_checked, `D1Bound5.PairLightAdaptivePrepared21.left_parallel_003_part15_checked, `D1Bound5.PairLightAdaptivePrepared21.left_prefix_000_checked, `D1Bound5.PairLightAdaptivePrepared21.left_prefix_001_checked, `D1Bound5.PairLightAdaptivePrepared21.left_prefix_002_checked, `D1Bound5.PairLightAdaptivePrepared21.left_prefix_003_checked, `D1Bound5.PairLightAdaptivePrepared21.left_signatures_checked, `D1Bound5.PairLightAdaptivePrepared21.rightCached000, `D1Bound5.PairLightAdaptivePrepared21.rightCached001, `D1Bound5.PairLightAdaptivePrepared21.rightCached002, `D1Bound5.PairLightAdaptivePrepared21.rightCached003, `D1Bound5.PairLightAdaptivePrepared21.rightCached004, `D1Bound5.PairLightAdaptivePrepared21.rightRows000, `D1Bound5.PairLightAdaptivePrepared21.rightRows001, `D1Bound5.PairLightAdaptivePrepared21.rightRows002, `D1Bound5.PairLightAdaptivePrepared21.rightRows003, `D1Bound5.PairLightAdaptivePrepared21.rightRows004, `D1Bound5.PairLightAdaptivePrepared21.right_coverage_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_000_part00_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_000_part01_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_000_part02_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_000_part03_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_000_part04_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_000_part05_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_000_part06_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_001_part07_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_001_part08_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_002_part07_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_002_part08_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_002_part09_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_002_part10_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_002_part11_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_002_part12_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_003_part00_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_003_part01_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_003_part02_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_003_part03_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_003_part04_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_003_part05_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_003_part06_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_003_part07_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_003_part08_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_003_part09_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_003_part10_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_003_part11_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_003_part12_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_003_part13_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_003_part14_checked, `D1Bound5.PairLightAdaptivePrepared21.right_parallel_003_part15_checked, `D1Bound5.PairLightAdaptivePrepared21.right_prefix_000_checked, `D1Bound5.PairLightAdaptivePrepared21.right_prefix_001_checked, `D1Bound5.PairLightAdaptivePrepared21.right_prefix_002_checked, `D1Bound5.PairLightAdaptivePrepared21.right_prefix_003_checked, `D1Bound5.PairLightAdaptivePrepared21.right_signatures_checked, `D1Bound5.PairLightClosurePrepared21.a, `D1Bound5.PairLightClosurePrepared21.a_eq, `D1Bound5.PairLightClosurePrepared21.all_checked, `D1Bound5.PairLightClosurePrepared21.anchorRoot, `D1Bound5.PairLightClosurePrepared21.anchorRoot_eq, `D1Bound5.PairLightClosurePrepared21.b, `D1Bound5.PairLightClosurePrepared21.b_eq, `D1Bound5.PairLightClosurePrepared21.chunk00_checked, `D1Bound5.PairLightClosurePrepared21.chunk01_checked, `D1Bound5.PairLightClosurePrepared21.chunk02_checked, `D1Bound5.PairLightClosurePrepared21.chunk03_checked, `D1Bound5.PairLightClosurePrepared21.chunk04_checked, `D1Bound5.PairLightClosurePrepared21.chunk05_checked, `D1Bound5.PairLightClosurePrepared21.chunk06_checked, `D1Bound5.PairLightClosurePrepared21.chunk07_checked, `D1Bound5.PairLightClosurePrepared21.chunk08_checked, `D1Bound5.PairLightClosurePrepared21.chunk09_checked, `D1Bound5.PairLightClosurePrepared21.chunk10_checked, `D1Bound5.PairLightClosurePrepared21.chunk11_checked, `D1Bound5.PairLightClosurePrepared21.chunk12_checked, `D1Bound5.PairLightClosurePrepared21.chunk13_checked, `D1Bound5.PairLightClosurePrepared21.chunk14_checked, `D1Bound5.PairLightClosurePrepared21.chunk15_checked, `D1Bound5.PairLightClosurePrepared21.chunk16_checked, `D1Bound5.PairLightClosurePrepared21.destinations, `D1Bound5.PairLightClosurePrepared21.destinationsChunk00, `D1Bound5.PairLightClosurePrepared21.destinationsChunk01, `D1Bound5.PairLightClosurePrepared21.destinationsChunk02, `D1Bound5.PairLightClosurePrepared21.destinationsChunk03, `D1Bound5.PairLightClosurePrepared21.destinationsChunk04, `D1Bound5.PairLightClosurePrepared21.destinationsChunk05, `D1Bound5.PairLightClosurePrepared21.destinationsChunk06, `D1Bound5.PairLightClosurePrepared21.destinationsChunk07, `D1Bound5.PairLightClosurePrepared21.destinationsChunk08, `D1Bound5.PairLightClosurePrepared21.destinations_eq, `D1Bound5.PairLightClosurePrepared21.original_indexed_checked, `D1Bound5.PairLightClosurePrepared21.original_witnesses_checked, `D1Bound5.PairLightClosurePrepared21.rootPairs, `D1Bound5.PairLightClosurePrepared21.rootPairsChunk00, `D1Bound5.PairLightClosurePrepared21.rootPairsChunk01, `D1Bound5.PairLightClosurePrepared21.rootPairsChunk02, `D1Bound5.PairLightClosurePrepared21.rootPairsChunk03, `D1Bound5.PairLightClosurePrepared21.rootPairsChunk04, `D1Bound5.PairLightClosurePrepared21.rootPairsChunk05, `D1Bound5.PairLightClosurePrepared21.rootPairsChunk06, `D1Bound5.PairLightClosurePrepared21.rootPairsChunk07, `D1Bound5.PairLightClosurePrepared21.rootPairsChunk08, `D1Bound5.PairLightClosurePrepared21.vertices, `D1Bound5.PairLightClosurePrepared21.verticesChunk00, `D1Bound5.PairLightClosurePrepared21.verticesChunk01, `D1Bound5.PairLightClosurePrepared21.verticesChunk02, `D1Bound5.PairLightClosurePrepared21.verticesChunk03, `D1Bound5.PairLightClosurePrepared21.verticesChunk04, `D1Bound5.PairLightClosurePrepared21.verticesChunk05, `D1Bound5.PairLightClosurePrepared21.verticesChunk06, `D1Bound5.PairLightClosurePrepared21.verticesChunk07, `D1Bound5.PairLightClosurePrepared21.verticesChunk08, `D1Bound5.PairLightClosurePrepared21.vertices_eq, `D1Bound5.PairLightClosurePrepared21.witnesses, `D1Bound5.PairLightClosurePrepared21.witnesses_eq, `D1Bound5.PairLightPrepared21.leftCached, `D1Bound5.PairLightPrepared21.leftCachedChunk00, `D1Bound5.PairLightPrepared21.leftCachedChunk01, `D1Bound5.PairLightPrepared21.leftCachedChunk02, `D1Bound5.PairLightPrepared21.leftCachedChunk03, `D1Bound5.PairLightPrepared21.leftCachedChunk04, `D1Bound5.PairLightPrepared21.leftCached_eq, `D1Bound5.PairLightPrepared21.leftRows, `D1Bound5.PairLightPrepared21.leftRows_eq, `D1Bound5.PairLightPrepared21.leftVertices, `D1Bound5.PairLightPrepared21.leftVertices_eq, `D1Bound5.PairLightPrepared21.left_certificate_checked, `D1Bound5.PairLightPrepared21.left_checked, `D1Bound5.PairLightPrepared21.left_coverage_checked, `D1Bound5.PairLightPrepared21.left_independent_checked, `D1Bound5.PairLightPrepared21.left_signatures_checked, `D1Bound5.PairLightPrepared21.rightCached, `D1Bound5.PairLightPrepared21.rightCachedChunk00, `D1Bound5.PairLightPrepared21.rightCachedChunk01, `D1Bound5.PairLightPrepared21.rightCachedChunk02, `D1Bound5.PairLightPrepared21.rightCachedChunk03, `D1Bound5.PairLightPrepared21.rightCachedChunk04, `D1Bound5.PairLightPrepared21.rightCached_eq, `D1Bound5.PairLightPrepared21.rightRows, `D1Bound5.PairLightPrepared21.rightRows_eq, `D1Bound5.PairLightPrepared21.rightVertices, `D1Bound5.PairLightPrepared21.rightVertices_eq, `D1Bound5.PairLightPrepared21.right_certificate_checked, `D1Bound5.PairLightPrepared21.right_checked, `D1Bound5.PairLightPrepared21.right_coverage_checked, `D1Bound5.PairLightPrepared21.right_independent_checked, `D1Bound5.PairLightPrepared21.right_signatures_checked, `D1Bound5.PairLightPrepared21.sieve, `D1Bound5.PairLightPrepared21.sieve_eq, `D1Bound5.PairSelectedPrepared21.leftCached, `D1Bound5.PairSelectedPrepared21.leftRows, `D1Bound5.PairSelectedPrepared21.rightCached, `D1Bound5.PairSelectedPrepared21.rightRows, `D1Bound5.smallPairA_21, `D1Bound5.smallPairB_21, `D1Bound5.smallPairClosure_21, `D1Bound5.smallPairClosure_21_checked, `D1Bound5.smallPairFilter_21_checked, `D1Bound5.smallPairLarge_21, `D1Bound5.smallPairLarge_21_count, `D1Bound5.smallPairNoTriangle_21_checked, `D1Bound5.smallPairSeeds_21_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
