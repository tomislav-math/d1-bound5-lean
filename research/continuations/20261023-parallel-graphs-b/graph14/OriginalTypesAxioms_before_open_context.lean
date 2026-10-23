import D1Bound5.SmallPairGraphData14
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
noncomputable section

namespace D1Bound5
example :
    pairSeedsCoveredBool smallPairA_14 smallPairB_14
      seedRootDisk_0_2 smallPairClosure_14 = true := smallPairSeeds_14_checked
end D1Bound5

namespace D1Bound5
example :
    largePairVertices smallPairA_14 smallPairB_14 smallPairClosure_14 = smallPairLarge_14 := smallPairFilter_14_checked
end D1Bound5

namespace D1Bound5
example : smallPairLarge_14.length = 991 := smallPairLarge_14_count
end D1Bound5

namespace D1Bound5
example :
    pairClosureIndexedWitnessBool smallPairA_14 smallPairB_14 anchorRoot
      (10^1100) smallPairClosure_14 witnesses destinations = true := PairGraphPrepared14.indexed_checked
end D1Bound5

namespace D1Bound5
example :
    pairClosureBool smallPairA_14 smallPairB_14
      (10^1100) smallPairClosure_14 = true := smallPairClosure_14_checked
end D1Bound5

namespace D1Bound5
example : QuadInt 0 2 := smallPairA_14
end D1Bound5

namespace D1Bound5
example : QuadInt 0 2 := smallPairB_14
end D1Bound5

namespace D1Bound5
example : List (QuadInt 0 2) := smallPairClosure_14
end D1Bound5

namespace D1Bound5
example : List (QuadInt 0 2) := smallPairLarge_14
end D1Bound5

namespace D1Bound5.PairGraphPrepared14
example : ℕ := colors
end D1Bound5.PairGraphPrepared14

namespace D1Bound5.PairGraphPrepared14
example : QuadInt 0 2 := anchorRoot
end D1Bound5.PairGraphPrepared14

namespace D1Bound5.PairGraphPrepared14
example : List (QuadInt 0 2 × QuadInt 0 2) := rootPairs
end D1Bound5.PairGraphPrepared14

namespace D1Bound5.PairGraphPrepared14
example : List (PairRootWitness 0 2) := witnesses
end D1Bound5.PairGraphPrepared14

namespace D1Bound5.PairGraphPrepared14
example : List (Option ℕ × Option ℕ) := destinations
end D1Bound5.PairGraphPrepared14

namespace D1Bound5.PairSelectedPrepared14
example : List (PairResidueVertex 0 2) := leftCached
end D1Bound5.PairSelectedPrepared14

namespace D1Bound5.PairSelectedPrepared14
example : List (ℕ × List ℕ) := leftRows
end D1Bound5.PairSelectedPrepared14

namespace D1Bound5.PairSelectedPrepared14
example : List (PairResidueVertex 0 2) := rightCached
end D1Bound5.PairSelectedPrepared14

namespace D1Bound5.PairSelectedPrepared14
example : List (ℕ × List ℕ) := rightRows
end D1Bound5.PairSelectedPrepared14

namespace D1Bound5.PairLightPrepared14
example : sieve = smallPairSieve_0_2 := sieve_eq
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example :
    leftVertices = (pairSplitByMask smallPairLarge_14 PairGraphPrepared14.colors).1.map pairLightCoordinates := leftVertices_eq
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example :
    leftCached = PairSelectedPrepared14.leftCached.map pairLightCachedCoordinates := leftCached_eq
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example : leftRows = PairSelectedPrepared14.leftRows := leftRows_eq
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example :
    pairIndependentBool smallPairSieve_0_2 (pairSplitByMask smallPairLarge_14 PairGraphPrepared14.colors).1 = true := left_checked
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example :
    rightVertices = (pairSplitByMask smallPairLarge_14 PairGraphPrepared14.colors).2.map pairLightCoordinates := rightVertices_eq
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example :
    rightCached = PairSelectedPrepared14.rightCached.map pairLightCachedCoordinates := rightCached_eq
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example : rightRows = PairSelectedPrepared14.rightRows := rightRows_eq
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example :
    pairIndependentBool smallPairSieve_0_2 (pairSplitByMask smallPairLarge_14 PairGraphPrepared14.colors).2 = true := right_checked
end D1Bound5.PairLightPrepared14

namespace D1Bound5
example :
    pairGraphTriangleFreeBool smallPairSieve_0_2 smallPairLarge_14 = true := smallPairNoTriangle_14_checked
end D1Bound5

namespace D1Bound5.PairLightAdaptivePrepared14
example : List PairLightCachedVertex := leftCached000
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example : List (Nat × List Nat) := leftRows000
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example : List PairLightCachedVertex := leftCached001
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example : List (Nat × List Nat) := leftRows001
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example : List PairLightCachedVertex := leftCached002
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example : List (Nat × List Nat) := leftRows002
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example : List PairLightCachedVertex := leftCached003
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example : List (Nat × List Nat) := leftRows003
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example : List PairLightCachedVertex := leftCached004
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example : List (Nat × List Nat) := leftRows004
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example : List PairLightCachedVertex := rightCached000
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example : List (Nat × List Nat) := rightRows000
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example : List PairLightCachedVertex := rightCached001
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example : List (Nat × List Nat) := rightRows001
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example : List PairLightCachedVertex := rightCached002
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example : List (Nat × List Nat) := rightRows002
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example : List PairLightCachedVertex := rightCached003
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example : List (Nat × List Nat) := rightRows003
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example : List PairLightCachedVertex := rightCached004
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example : List (Nat × List Nat) := rightRows004
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 88
      leftCached000 leftRows000 = true := left_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 114
      leftCached001 leftRows001 = true := left_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 217
      leftCached002 leftRows002 = true := left_prefix_002_checked
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 76
      leftCached003 leftRows003 = true := left_prefix_003_checked
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 88
      rightCached000 rightRows000 = true := right_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 114
      rightCached001 rightRows001 = true := right_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 215
      rightCached002 rightRows002 = true := right_prefix_002_checked
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared14.sieve 79
      rightCached003 rightRows003 = true := right_prefix_003_checked
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example :
    decide (PairLightPrepared14.leftCached.map Prod.fst = PairLightPrepared14.leftVertices) = true := left_coverage_checked
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example :
    (PairLightPrepared14.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared14.sieve x.1)) = true := left_signatures_checked
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example :
    decide (PairLightPrepared14.rightCached.map Prod.fst = PairLightPrepared14.rightVertices) = true := right_coverage_checked
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightAdaptivePrepared14
example :
    (PairLightPrepared14.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared14.sieve x.1)) = true := right_signatures_checked
end D1Bound5.PairLightAdaptivePrepared14

namespace D1Bound5.PairLightPrepared14
example : List (Nat × Nat) := sieve
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example : List PairLightCoordinate := leftVertices
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example : List PairLightCachedVertex := leftCached
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example : List (Nat × List Nat) := leftRows
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example : List PairLightCoordinate := rightVertices
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example : List PairLightCachedVertex := rightCached
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example : List (Nat × List Nat) := rightRows
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example :
    decide (leftCached.map Prod.fst = leftVertices) = true := left_coverage_checked
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true := left_signatures_checked
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example :
    pairLightSelectedFloorIndependentBool 0 2 sieve leftCached leftRows = true := left_independent_checked
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example :
    pairLightSelectedFloorIndependentCertificateBool 0 2 sieve
      leftVertices leftCached leftRows = true := left_certificate_checked
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example :
    decide (rightCached.map Prod.fst = rightVertices) = true := right_coverage_checked
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true := right_signatures_checked
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example :
    pairLightSelectedFloorIndependentBool 0 2 sieve rightCached rightRows = true := right_independent_checked
end D1Bound5.PairLightPrepared14

namespace D1Bound5.PairLightPrepared14
example :
    pairLightSelectedFloorIndependentCertificateBool 0 2 sieve
      rightVertices rightCached rightRows = true := right_certificate_checked
end D1Bound5.PairLightPrepared14

run_cmd do
  for name in ([`D1Bound5.PairGraphPrepared14.anchorRoot, `D1Bound5.PairGraphPrepared14.colors, `D1Bound5.PairGraphPrepared14.destinations, `D1Bound5.PairGraphPrepared14.indexed_checked, `D1Bound5.PairGraphPrepared14.indexed_coverage_checked, `D1Bound5.PairGraphPrepared14.rootPairs, `D1Bound5.PairGraphPrepared14.witnesses, `D1Bound5.PairLightAdaptivePrepared14.leftCached000, `D1Bound5.PairLightAdaptivePrepared14.leftCached001, `D1Bound5.PairLightAdaptivePrepared14.leftCached002, `D1Bound5.PairLightAdaptivePrepared14.leftCached003, `D1Bound5.PairLightAdaptivePrepared14.leftCached004, `D1Bound5.PairLightAdaptivePrepared14.leftRows000, `D1Bound5.PairLightAdaptivePrepared14.leftRows001, `D1Bound5.PairLightAdaptivePrepared14.leftRows002, `D1Bound5.PairLightAdaptivePrepared14.leftRows003, `D1Bound5.PairLightAdaptivePrepared14.leftRows004, `D1Bound5.PairLightAdaptivePrepared14.left_coverage_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_000_part00_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_000_part01_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_000_part02_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_000_part03_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_000_part04_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_000_part05_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_000_part06_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_000_part07_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_001_part07_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_001_part08_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_001_part09_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_002_part07_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_002_part08_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_002_part09_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_002_part10_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_002_part11_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_002_part12_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_002_part13_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_002_part14_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_002_part15_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_002_part16_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_002_part17_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_002_part18_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_003_part00_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_003_part01_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_003_part02_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_003_part03_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_003_part04_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_003_part05_checked, `D1Bound5.PairLightAdaptivePrepared14.left_parallel_003_part06_checked, `D1Bound5.PairLightAdaptivePrepared14.left_prefix_000_checked, `D1Bound5.PairLightAdaptivePrepared14.left_prefix_001_checked, `D1Bound5.PairLightAdaptivePrepared14.left_prefix_002_checked, `D1Bound5.PairLightAdaptivePrepared14.left_prefix_003_checked, `D1Bound5.PairLightAdaptivePrepared14.left_signatures_checked, `D1Bound5.PairLightAdaptivePrepared14.rightCached000, `D1Bound5.PairLightAdaptivePrepared14.rightCached001, `D1Bound5.PairLightAdaptivePrepared14.rightCached002, `D1Bound5.PairLightAdaptivePrepared14.rightCached003, `D1Bound5.PairLightAdaptivePrepared14.rightCached004, `D1Bound5.PairLightAdaptivePrepared14.rightRows000, `D1Bound5.PairLightAdaptivePrepared14.rightRows001, `D1Bound5.PairLightAdaptivePrepared14.rightRows002, `D1Bound5.PairLightAdaptivePrepared14.rightRows003, `D1Bound5.PairLightAdaptivePrepared14.rightRows004, `D1Bound5.PairLightAdaptivePrepared14.right_coverage_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_000_part00_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_000_part01_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_000_part02_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_000_part03_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_000_part04_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_000_part05_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_000_part06_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_000_part07_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_001_part07_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_001_part08_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_001_part09_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_002_part07_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_002_part08_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_002_part09_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_002_part10_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_002_part11_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_002_part12_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_002_part13_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_002_part14_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_002_part15_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_002_part16_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_002_part17_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_003_part00_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_003_part01_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_003_part02_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_003_part03_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_003_part04_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_003_part05_checked, `D1Bound5.PairLightAdaptivePrepared14.right_parallel_003_part06_checked, `D1Bound5.PairLightAdaptivePrepared14.right_prefix_000_checked, `D1Bound5.PairLightAdaptivePrepared14.right_prefix_001_checked, `D1Bound5.PairLightAdaptivePrepared14.right_prefix_002_checked, `D1Bound5.PairLightAdaptivePrepared14.right_prefix_003_checked, `D1Bound5.PairLightAdaptivePrepared14.right_signatures_checked, `D1Bound5.PairLightClosurePrepared14.a, `D1Bound5.PairLightClosurePrepared14.a_eq, `D1Bound5.PairLightClosurePrepared14.all_checked, `D1Bound5.PairLightClosurePrepared14.anchorRoot, `D1Bound5.PairLightClosurePrepared14.anchorRoot_eq, `D1Bound5.PairLightClosurePrepared14.b, `D1Bound5.PairLightClosurePrepared14.b_eq, `D1Bound5.PairLightClosurePrepared14.chunk00_checked, `D1Bound5.PairLightClosurePrepared14.chunk01_checked, `D1Bound5.PairLightClosurePrepared14.chunk02_checked, `D1Bound5.PairLightClosurePrepared14.chunk03_checked, `D1Bound5.PairLightClosurePrepared14.chunk04_checked, `D1Bound5.PairLightClosurePrepared14.chunk05_checked, `D1Bound5.PairLightClosurePrepared14.chunk06_checked, `D1Bound5.PairLightClosurePrepared14.chunk07_checked, `D1Bound5.PairLightClosurePrepared14.chunk08_checked, `D1Bound5.PairLightClosurePrepared14.chunk09_checked, `D1Bound5.PairLightClosurePrepared14.chunk10_checked, `D1Bound5.PairLightClosurePrepared14.chunk11_checked, `D1Bound5.PairLightClosurePrepared14.chunk12_checked, `D1Bound5.PairLightClosurePrepared14.chunk13_checked, `D1Bound5.PairLightClosurePrepared14.chunk14_checked, `D1Bound5.PairLightClosurePrepared14.chunk15_checked, `D1Bound5.PairLightClosurePrepared14.destinations, `D1Bound5.PairLightClosurePrepared14.destinationsChunk00, `D1Bound5.PairLightClosurePrepared14.destinationsChunk01, `D1Bound5.PairLightClosurePrepared14.destinationsChunk02, `D1Bound5.PairLightClosurePrepared14.destinationsChunk03, `D1Bound5.PairLightClosurePrepared14.destinationsChunk04, `D1Bound5.PairLightClosurePrepared14.destinationsChunk05, `D1Bound5.PairLightClosurePrepared14.destinationsChunk06, `D1Bound5.PairLightClosurePrepared14.destinationsChunk07, `D1Bound5.PairLightClosurePrepared14.destinations_eq, `D1Bound5.PairLightClosurePrepared14.original_indexed_checked, `D1Bound5.PairLightClosurePrepared14.original_witnesses_checked, `D1Bound5.PairLightClosurePrepared14.rootPairs, `D1Bound5.PairLightClosurePrepared14.rootPairsChunk00, `D1Bound5.PairLightClosurePrepared14.rootPairsChunk01, `D1Bound5.PairLightClosurePrepared14.rootPairsChunk02, `D1Bound5.PairLightClosurePrepared14.rootPairsChunk03, `D1Bound5.PairLightClosurePrepared14.rootPairsChunk04, `D1Bound5.PairLightClosurePrepared14.rootPairsChunk05, `D1Bound5.PairLightClosurePrepared14.rootPairsChunk06, `D1Bound5.PairLightClosurePrepared14.rootPairsChunk07, `D1Bound5.PairLightClosurePrepared14.vertices, `D1Bound5.PairLightClosurePrepared14.verticesChunk00, `D1Bound5.PairLightClosurePrepared14.verticesChunk01, `D1Bound5.PairLightClosurePrepared14.verticesChunk02, `D1Bound5.PairLightClosurePrepared14.verticesChunk03, `D1Bound5.PairLightClosurePrepared14.verticesChunk04, `D1Bound5.PairLightClosurePrepared14.verticesChunk05, `D1Bound5.PairLightClosurePrepared14.verticesChunk06, `D1Bound5.PairLightClosurePrepared14.verticesChunk07, `D1Bound5.PairLightClosurePrepared14.vertices_eq, `D1Bound5.PairLightClosurePrepared14.witnesses, `D1Bound5.PairLightClosurePrepared14.witnesses_eq, `D1Bound5.PairLightPrepared14.leftCached, `D1Bound5.PairLightPrepared14.leftCachedChunk00, `D1Bound5.PairLightPrepared14.leftCachedChunk01, `D1Bound5.PairLightPrepared14.leftCachedChunk02, `D1Bound5.PairLightPrepared14.leftCachedChunk03, `D1Bound5.PairLightPrepared14.leftCachedChunk04, `D1Bound5.PairLightPrepared14.leftCached_eq, `D1Bound5.PairLightPrepared14.leftRows, `D1Bound5.PairLightPrepared14.leftRows_eq, `D1Bound5.PairLightPrepared14.leftVertices, `D1Bound5.PairLightPrepared14.leftVertices_eq, `D1Bound5.PairLightPrepared14.left_certificate_checked, `D1Bound5.PairLightPrepared14.left_checked, `D1Bound5.PairLightPrepared14.left_coverage_checked, `D1Bound5.PairLightPrepared14.left_independent_checked, `D1Bound5.PairLightPrepared14.left_signatures_checked, `D1Bound5.PairLightPrepared14.rightCached, `D1Bound5.PairLightPrepared14.rightCachedChunk00, `D1Bound5.PairLightPrepared14.rightCachedChunk01, `D1Bound5.PairLightPrepared14.rightCachedChunk02, `D1Bound5.PairLightPrepared14.rightCachedChunk03, `D1Bound5.PairLightPrepared14.rightCachedChunk04, `D1Bound5.PairLightPrepared14.rightCached_eq, `D1Bound5.PairLightPrepared14.rightRows, `D1Bound5.PairLightPrepared14.rightRows_eq, `D1Bound5.PairLightPrepared14.rightVertices, `D1Bound5.PairLightPrepared14.rightVertices_eq, `D1Bound5.PairLightPrepared14.right_certificate_checked, `D1Bound5.PairLightPrepared14.right_checked, `D1Bound5.PairLightPrepared14.right_coverage_checked, `D1Bound5.PairLightPrepared14.right_independent_checked, `D1Bound5.PairLightPrepared14.right_signatures_checked, `D1Bound5.PairLightPrepared14.sieve, `D1Bound5.PairLightPrepared14.sieve_eq, `D1Bound5.PairSelectedPrepared14.leftCached, `D1Bound5.PairSelectedPrepared14.leftRows, `D1Bound5.PairSelectedPrepared14.rightCached, `D1Bound5.PairSelectedPrepared14.rightRows, `D1Bound5.smallPairA_14, `D1Bound5.smallPairB_14, `D1Bound5.smallPairClosure_14, `D1Bound5.smallPairClosure_14_checked, `D1Bound5.smallPairFilter_14_checked, `D1Bound5.smallPairLarge_14, `D1Bound5.smallPairLarge_14_count, `D1Bound5.smallPairNoTriangle_14_checked, `D1Bound5.smallPairSeeds_14_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
