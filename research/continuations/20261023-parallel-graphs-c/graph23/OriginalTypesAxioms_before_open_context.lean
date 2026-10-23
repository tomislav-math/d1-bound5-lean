import D1Bound5.SmallPairGraphData23
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
noncomputable section

namespace D1Bound5
example :
    pairSeedsCoveredBool smallPairA_23 smallPairB_23
      seedRootDisk_1_1 smallPairClosure_23 = true := smallPairSeeds_23_checked
end D1Bound5

namespace D1Bound5
example :
    largePairVertices smallPairA_23 smallPairB_23 smallPairClosure_23 = smallPairLarge_23 := smallPairFilter_23_checked
end D1Bound5

namespace D1Bound5
example : smallPairLarge_23.length = 962 := smallPairLarge_23_count
end D1Bound5

namespace D1Bound5
example :
    pairClosureIndexedWitnessBool smallPairA_23 smallPairB_23 anchorRoot
      (10^1100) smallPairClosure_23 witnesses destinations = true := PairGraphPrepared23.indexed_checked
end D1Bound5

namespace D1Bound5
example :
    pairClosureBool smallPairA_23 smallPairB_23
      (10^1100) smallPairClosure_23 = true := smallPairClosure_23_checked
end D1Bound5

namespace D1Bound5
example : QuadInt 1 1 := smallPairA_23
end D1Bound5

namespace D1Bound5
example : QuadInt 1 1 := smallPairB_23
end D1Bound5

namespace D1Bound5
example : List (QuadInt 1 1) := smallPairClosure_23
end D1Bound5

namespace D1Bound5
example : List (QuadInt 1 1) := smallPairLarge_23
end D1Bound5

namespace D1Bound5.PairGraphPrepared23
example : ℕ := colors
end D1Bound5.PairGraphPrepared23

namespace D1Bound5.PairGraphPrepared23
example : QuadInt 1 1 := anchorRoot
end D1Bound5.PairGraphPrepared23

namespace D1Bound5.PairGraphPrepared23
example : List (QuadInt 1 1 × QuadInt 1 1) := rootPairs
end D1Bound5.PairGraphPrepared23

namespace D1Bound5.PairGraphPrepared23
example : List (PairRootWitness 1 1) := witnesses
end D1Bound5.PairGraphPrepared23

namespace D1Bound5.PairGraphPrepared23
example : List (Option ℕ × Option ℕ) := destinations
end D1Bound5.PairGraphPrepared23

namespace D1Bound5.PairSelectedPrepared23
example : List (PairResidueVertex 1 1) := leftCached
end D1Bound5.PairSelectedPrepared23

namespace D1Bound5.PairSelectedPrepared23
example : List (ℕ × List ℕ) := leftRows
end D1Bound5.PairSelectedPrepared23

namespace D1Bound5.PairSelectedPrepared23
example : List (PairResidueVertex 1 1) := rightCached
end D1Bound5.PairSelectedPrepared23

namespace D1Bound5.PairSelectedPrepared23
example : List (ℕ × List ℕ) := rightRows
end D1Bound5.PairSelectedPrepared23

namespace D1Bound5.PairLightPrepared23
example : sieve = smallPairSieve_1_1 := sieve_eq
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example :
    leftVertices = (pairSplitByMask smallPairLarge_23 PairGraphPrepared23.colors).1.map pairLightCoordinates := leftVertices_eq
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example :
    leftCached = PairSelectedPrepared23.leftCached.map pairLightCachedCoordinates := leftCached_eq
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example : leftRows = PairSelectedPrepared23.leftRows := leftRows_eq
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example :
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_23 PairGraphPrepared23.colors).1 = true := left_checked
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example :
    rightVertices = (pairSplitByMask smallPairLarge_23 PairGraphPrepared23.colors).2.map pairLightCoordinates := rightVertices_eq
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example :
    rightCached = PairSelectedPrepared23.rightCached.map pairLightCachedCoordinates := rightCached_eq
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example : rightRows = PairSelectedPrepared23.rightRows := rightRows_eq
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example :
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_23 PairGraphPrepared23.colors).2 = true := right_checked
end D1Bound5.PairLightPrepared23

namespace D1Bound5
example :
    pairGraphTriangleFreeBool smallPairSieve_1_1 smallPairLarge_23 = true := smallPairNoTriangle_23_checked
end D1Bound5

namespace D1Bound5.PairLightAdaptivePrepared23
example : List PairLightCachedVertex := leftCached000
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example : List (Nat × List Nat) := leftRows000
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example : List PairLightCachedVertex := leftCached001
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example : List (Nat × List Nat) := leftRows001
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example : List PairLightCachedVertex := leftCached002
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example : List (Nat × List Nat) := leftRows002
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example : List PairLightCachedVertex := leftCached003
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example : List (Nat × List Nat) := leftRows003
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example : List PairLightCachedVertex := rightCached000
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example : List (Nat × List Nat) := rightRows000
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example : List PairLightCachedVertex := rightCached001
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example : List (Nat × List Nat) := rightRows001
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example : List PairLightCachedVertex := rightCached002
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example : List (Nat × List Nat) := rightRows002
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example : List PairLightCachedVertex := rightCached003
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example : List (Nat × List Nat) := rightRows003
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared23.sieve 91
      leftCached000 leftRows000 = true := left_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared23.sieve 121
      leftCached001 leftRows001 = true := left_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared23.sieve 270
      leftCached002 leftRows002 = true := left_prefix_002_checked
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared23.sieve 92
      rightCached000 rightRows000 = true := right_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared23.sieve 122
      rightCached001 rightRows001 = true := right_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared23.sieve 266
      rightCached002 rightRows002 = true := right_prefix_002_checked
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example :
    decide (PairLightPrepared23.leftCached.map Prod.fst = PairLightPrepared23.leftVertices) = true := left_coverage_checked
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example :
    (PairLightPrepared23.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared23.sieve x.1)) = true := left_signatures_checked
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example :
    decide (PairLightPrepared23.rightCached.map Prod.fst = PairLightPrepared23.rightVertices) = true := right_coverage_checked
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightAdaptivePrepared23
example :
    (PairLightPrepared23.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared23.sieve x.1)) = true := right_signatures_checked
end D1Bound5.PairLightAdaptivePrepared23

namespace D1Bound5.PairLightPrepared23
example : List (Nat × Nat) := sieve
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example : List PairLightCoordinate := leftVertices
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example : List PairLightCachedVertex := leftCached
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example : List (Nat × List Nat) := leftRows
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example : List PairLightCoordinate := rightVertices
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example : List PairLightCachedVertex := rightCached
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example : List (Nat × List Nat) := rightRows
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example :
    decide (leftCached.map Prod.fst = leftVertices) = true := left_coverage_checked
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true := left_signatures_checked
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example :
    pairLightSelectedFloorIndependentBool 1 1 sieve leftCached leftRows = true := left_independent_checked
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example :
    pairLightSelectedFloorIndependentCertificateBool 1 1 sieve
      leftVertices leftCached leftRows = true := left_certificate_checked
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example :
    decide (rightCached.map Prod.fst = rightVertices) = true := right_coverage_checked
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true := right_signatures_checked
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example :
    pairLightSelectedFloorIndependentBool 1 1 sieve rightCached rightRows = true := right_independent_checked
end D1Bound5.PairLightPrepared23

namespace D1Bound5.PairLightPrepared23
example :
    pairLightSelectedFloorIndependentCertificateBool 1 1 sieve
      rightVertices rightCached rightRows = true := right_certificate_checked
end D1Bound5.PairLightPrepared23

run_cmd do
  for name in ([`D1Bound5.PairGraphPrepared23.anchorRoot, `D1Bound5.PairGraphPrepared23.colors, `D1Bound5.PairGraphPrepared23.destinations, `D1Bound5.PairGraphPrepared23.indexed_checked, `D1Bound5.PairGraphPrepared23.indexed_coverage_checked, `D1Bound5.PairGraphPrepared23.rootPairs, `D1Bound5.PairGraphPrepared23.witnesses, `D1Bound5.PairLightAdaptivePrepared23.leftCached000, `D1Bound5.PairLightAdaptivePrepared23.leftCached001, `D1Bound5.PairLightAdaptivePrepared23.leftCached002, `D1Bound5.PairLightAdaptivePrepared23.leftCached003, `D1Bound5.PairLightAdaptivePrepared23.leftRows000, `D1Bound5.PairLightAdaptivePrepared23.leftRows001, `D1Bound5.PairLightAdaptivePrepared23.leftRows002, `D1Bound5.PairLightAdaptivePrepared23.leftRows003, `D1Bound5.PairLightAdaptivePrepared23.left_coverage_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_000_part00_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_000_part01_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_000_part02_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_000_part03_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_000_part04_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_000_part05_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_000_part06_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_000_part07_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_001_part07_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_001_part08_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_001_part09_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_001_part10_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part07_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part08_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part09_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part10_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part11_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part12_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part13_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part14_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part15_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part16_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part17_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part18_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part19_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part20_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part21_checked, `D1Bound5.PairLightAdaptivePrepared23.left_parallel_002_part22_checked, `D1Bound5.PairLightAdaptivePrepared23.left_prefix_000_checked, `D1Bound5.PairLightAdaptivePrepared23.left_prefix_001_checked, `D1Bound5.PairLightAdaptivePrepared23.left_prefix_002_checked, `D1Bound5.PairLightAdaptivePrepared23.left_signatures_checked, `D1Bound5.PairLightAdaptivePrepared23.rightCached000, `D1Bound5.PairLightAdaptivePrepared23.rightCached001, `D1Bound5.PairLightAdaptivePrepared23.rightCached002, `D1Bound5.PairLightAdaptivePrepared23.rightCached003, `D1Bound5.PairLightAdaptivePrepared23.rightRows000, `D1Bound5.PairLightAdaptivePrepared23.rightRows001, `D1Bound5.PairLightAdaptivePrepared23.rightRows002, `D1Bound5.PairLightAdaptivePrepared23.rightRows003, `D1Bound5.PairLightAdaptivePrepared23.right_coverage_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_000_part00_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_000_part01_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_000_part02_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_000_part03_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_000_part04_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_000_part05_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_000_part06_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_000_part07_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_001_part07_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_001_part08_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_001_part09_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_001_part10_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part07_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part08_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part09_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part10_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part11_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part12_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part13_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part14_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part15_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part16_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part17_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part18_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part19_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part20_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part21_checked, `D1Bound5.PairLightAdaptivePrepared23.right_parallel_002_part22_checked, `D1Bound5.PairLightAdaptivePrepared23.right_prefix_000_checked, `D1Bound5.PairLightAdaptivePrepared23.right_prefix_001_checked, `D1Bound5.PairLightAdaptivePrepared23.right_prefix_002_checked, `D1Bound5.PairLightAdaptivePrepared23.right_signatures_checked, `D1Bound5.PairLightClosurePrepared23.a, `D1Bound5.PairLightClosurePrepared23.a_eq, `D1Bound5.PairLightClosurePrepared23.all_checked, `D1Bound5.PairLightClosurePrepared23.anchorRoot, `D1Bound5.PairLightClosurePrepared23.anchorRoot_eq, `D1Bound5.PairLightClosurePrepared23.b, `D1Bound5.PairLightClosurePrepared23.b_eq, `D1Bound5.PairLightClosurePrepared23.chunk00_checked, `D1Bound5.PairLightClosurePrepared23.chunk01_checked, `D1Bound5.PairLightClosurePrepared23.chunk02_checked, `D1Bound5.PairLightClosurePrepared23.chunk03_checked, `D1Bound5.PairLightClosurePrepared23.chunk04_checked, `D1Bound5.PairLightClosurePrepared23.chunk05_checked, `D1Bound5.PairLightClosurePrepared23.chunk06_checked, `D1Bound5.PairLightClosurePrepared23.chunk07_checked, `D1Bound5.PairLightClosurePrepared23.chunk08_checked, `D1Bound5.PairLightClosurePrepared23.chunk09_checked, `D1Bound5.PairLightClosurePrepared23.chunk10_checked, `D1Bound5.PairLightClosurePrepared23.chunk11_checked, `D1Bound5.PairLightClosurePrepared23.chunk12_checked, `D1Bound5.PairLightClosurePrepared23.chunk13_checked, `D1Bound5.PairLightClosurePrepared23.chunk14_checked, `D1Bound5.PairLightClosurePrepared23.chunk15_checked, `D1Bound5.PairLightClosurePrepared23.destinations, `D1Bound5.PairLightClosurePrepared23.destinationsChunk00, `D1Bound5.PairLightClosurePrepared23.destinationsChunk01, `D1Bound5.PairLightClosurePrepared23.destinationsChunk02, `D1Bound5.PairLightClosurePrepared23.destinationsChunk03, `D1Bound5.PairLightClosurePrepared23.destinationsChunk04, `D1Bound5.PairLightClosurePrepared23.destinationsChunk05, `D1Bound5.PairLightClosurePrepared23.destinationsChunk06, `D1Bound5.PairLightClosurePrepared23.destinationsChunk07, `D1Bound5.PairLightClosurePrepared23.destinations_eq, `D1Bound5.PairLightClosurePrepared23.original_indexed_checked, `D1Bound5.PairLightClosurePrepared23.original_witnesses_checked, `D1Bound5.PairLightClosurePrepared23.rootPairs, `D1Bound5.PairLightClosurePrepared23.rootPairsChunk00, `D1Bound5.PairLightClosurePrepared23.rootPairsChunk01, `D1Bound5.PairLightClosurePrepared23.rootPairsChunk02, `D1Bound5.PairLightClosurePrepared23.rootPairsChunk03, `D1Bound5.PairLightClosurePrepared23.rootPairsChunk04, `D1Bound5.PairLightClosurePrepared23.rootPairsChunk05, `D1Bound5.PairLightClosurePrepared23.rootPairsChunk06, `D1Bound5.PairLightClosurePrepared23.rootPairsChunk07, `D1Bound5.PairLightClosurePrepared23.vertices, `D1Bound5.PairLightClosurePrepared23.verticesChunk00, `D1Bound5.PairLightClosurePrepared23.verticesChunk01, `D1Bound5.PairLightClosurePrepared23.verticesChunk02, `D1Bound5.PairLightClosurePrepared23.verticesChunk03, `D1Bound5.PairLightClosurePrepared23.verticesChunk04, `D1Bound5.PairLightClosurePrepared23.verticesChunk05, `D1Bound5.PairLightClosurePrepared23.verticesChunk06, `D1Bound5.PairLightClosurePrepared23.verticesChunk07, `D1Bound5.PairLightClosurePrepared23.vertices_eq, `D1Bound5.PairLightClosurePrepared23.witnesses, `D1Bound5.PairLightClosurePrepared23.witnesses_eq, `D1Bound5.PairLightPrepared23.leftCached, `D1Bound5.PairLightPrepared23.leftCachedChunk00, `D1Bound5.PairLightPrepared23.leftCachedChunk01, `D1Bound5.PairLightPrepared23.leftCachedChunk02, `D1Bound5.PairLightPrepared23.leftCachedChunk03, `D1Bound5.PairLightPrepared23.leftCachedChunk04, `D1Bound5.PairLightPrepared23.leftCached_eq, `D1Bound5.PairLightPrepared23.leftRows, `D1Bound5.PairLightPrepared23.leftRows_eq, `D1Bound5.PairLightPrepared23.leftVertices, `D1Bound5.PairLightPrepared23.leftVertices_eq, `D1Bound5.PairLightPrepared23.left_certificate_checked, `D1Bound5.PairLightPrepared23.left_checked, `D1Bound5.PairLightPrepared23.left_coverage_checked, `D1Bound5.PairLightPrepared23.left_independent_checked, `D1Bound5.PairLightPrepared23.left_signatures_checked, `D1Bound5.PairLightPrepared23.rightCached, `D1Bound5.PairLightPrepared23.rightCachedChunk00, `D1Bound5.PairLightPrepared23.rightCachedChunk01, `D1Bound5.PairLightPrepared23.rightCachedChunk02, `D1Bound5.PairLightPrepared23.rightCachedChunk03, `D1Bound5.PairLightPrepared23.rightCached_eq, `D1Bound5.PairLightPrepared23.rightRows, `D1Bound5.PairLightPrepared23.rightRows_eq, `D1Bound5.PairLightPrepared23.rightVertices, `D1Bound5.PairLightPrepared23.rightVertices_eq, `D1Bound5.PairLightPrepared23.right_certificate_checked, `D1Bound5.PairLightPrepared23.right_checked, `D1Bound5.PairLightPrepared23.right_coverage_checked, `D1Bound5.PairLightPrepared23.right_independent_checked, `D1Bound5.PairLightPrepared23.right_signatures_checked, `D1Bound5.PairLightPrepared23.sieve, `D1Bound5.PairLightPrepared23.sieve_eq, `D1Bound5.PairSelectedPrepared23.leftCached, `D1Bound5.PairSelectedPrepared23.leftRows, `D1Bound5.PairSelectedPrepared23.rightCached, `D1Bound5.PairSelectedPrepared23.rightRows, `D1Bound5.smallPairA_23, `D1Bound5.smallPairB_23, `D1Bound5.smallPairClosure_23, `D1Bound5.smallPairClosure_23_checked, `D1Bound5.smallPairFilter_23_checked, `D1Bound5.smallPairLarge_23, `D1Bound5.smallPairLarge_23_count, `D1Bound5.smallPairNoTriangle_23_checked, `D1Bound5.smallPairSeeds_23_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
