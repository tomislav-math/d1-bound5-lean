import D1Bound5.SmallPairGraphData15
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
noncomputable section

namespace D1Bound5
example :
    pairSeedsCoveredBool smallPairA_15 smallPairB_15
      seedRootDisk_0_2 smallPairClosure_15 = true := smallPairSeeds_15_checked
end D1Bound5

namespace D1Bound5
example :
    largePairVertices smallPairA_15 smallPairB_15 smallPairClosure_15 = smallPairLarge_15 := smallPairFilter_15_checked
end D1Bound5

namespace D1Bound5
example : smallPairLarge_15.length = 961 := smallPairLarge_15_count
end D1Bound5

namespace D1Bound5
example :
    pairClosureIndexedWitnessBool smallPairA_15 smallPairB_15 anchorRoot
      (10^1100) smallPairClosure_15 witnesses destinations = true := PairGraphPrepared15.indexed_checked
end D1Bound5

namespace D1Bound5
example :
    pairClosureBool smallPairA_15 smallPairB_15
      (10^1100) smallPairClosure_15 = true := smallPairClosure_15_checked
end D1Bound5

namespace D1Bound5
example : QuadInt 0 2 := smallPairA_15
end D1Bound5

namespace D1Bound5
example : QuadInt 0 2 := smallPairB_15
end D1Bound5

namespace D1Bound5
example : List (QuadInt 0 2) := smallPairClosure_15
end D1Bound5

namespace D1Bound5
example : List (QuadInt 0 2) := smallPairLarge_15
end D1Bound5

namespace D1Bound5.PairGraphPrepared15
example : ℕ := colors
end D1Bound5.PairGraphPrepared15

namespace D1Bound5.PairGraphPrepared15
example : QuadInt 0 2 := anchorRoot
end D1Bound5.PairGraphPrepared15

namespace D1Bound5.PairGraphPrepared15
example : List (QuadInt 0 2 × QuadInt 0 2) := rootPairs
end D1Bound5.PairGraphPrepared15

namespace D1Bound5.PairGraphPrepared15
example : List (PairRootWitness 0 2) := witnesses
end D1Bound5.PairGraphPrepared15

namespace D1Bound5.PairGraphPrepared15
example : List (Option ℕ × Option ℕ) := destinations
end D1Bound5.PairGraphPrepared15

namespace D1Bound5.PairSelectedPrepared15
example : List (PairResidueVertex 0 2) := leftCached
end D1Bound5.PairSelectedPrepared15

namespace D1Bound5.PairSelectedPrepared15
example : List (ℕ × List ℕ) := leftRows
end D1Bound5.PairSelectedPrepared15

namespace D1Bound5.PairSelectedPrepared15
example : List (PairResidueVertex 0 2) := rightCached
end D1Bound5.PairSelectedPrepared15

namespace D1Bound5.PairSelectedPrepared15
example : List (ℕ × List ℕ) := rightRows
end D1Bound5.PairSelectedPrepared15

namespace D1Bound5.PairLightPrepared15
example : sieve = smallPairSieve_0_2 := sieve_eq
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example :
    leftVertices = (pairSplitByMask smallPairLarge_15 PairGraphPrepared15.colors).1.map pairLightCoordinates := leftVertices_eq
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example :
    leftCached = PairSelectedPrepared15.leftCached.map pairLightCachedCoordinates := leftCached_eq
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example : leftRows = PairSelectedPrepared15.leftRows := leftRows_eq
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example :
    pairIndependentBool smallPairSieve_0_2 (pairSplitByMask smallPairLarge_15 PairGraphPrepared15.colors).1 = true := left_checked
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example :
    rightVertices = (pairSplitByMask smallPairLarge_15 PairGraphPrepared15.colors).2.map pairLightCoordinates := rightVertices_eq
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example :
    rightCached = PairSelectedPrepared15.rightCached.map pairLightCachedCoordinates := rightCached_eq
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example : rightRows = PairSelectedPrepared15.rightRows := rightRows_eq
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example :
    pairIndependentBool smallPairSieve_0_2 (pairSplitByMask smallPairLarge_15 PairGraphPrepared15.colors).2 = true := right_checked
end D1Bound5.PairLightPrepared15

namespace D1Bound5
example :
    pairGraphTriangleFreeBool smallPairSieve_0_2 smallPairLarge_15 = true := smallPairNoTriangle_15_checked
end D1Bound5

namespace D1Bound5.PairLightAdaptivePrepared15
example : List PairLightCachedVertex := leftCached000
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example : List (Nat × List Nat) := leftRows000
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example : List PairLightCachedVertex := leftCached001
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example : List (Nat × List Nat) := leftRows001
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example : List PairLightCachedVertex := leftCached002
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example : List (Nat × List Nat) := leftRows002
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example : List PairLightCachedVertex := leftCached003
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example : List (Nat × List Nat) := leftRows003
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example : List PairLightCachedVertex := rightCached000
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example : List (Nat × List Nat) := rightRows000
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example : List PairLightCachedVertex := rightCached001
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example : List (Nat × List Nat) := rightRows001
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example : List PairLightCachedVertex := rightCached002
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example : List (Nat × List Nat) := rightRows002
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example : List PairLightCachedVertex := rightCached003
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example : List (Nat × List Nat) := rightRows003
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared15.sieve 92
      leftCached000 leftRows000 = true := left_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared15.sieve 122
      leftCached001 leftRows001 = true := left_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared15.sieve 267
      leftCached002 leftRows002 = true := left_prefix_002_checked
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared15.sieve 92
      rightCached000 rightRows000 = true := right_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared15.sieve 122
      rightCached001 rightRows001 = true := right_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example :
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared15.sieve 266
      rightCached002 rightRows002 = true := right_prefix_002_checked
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example :
    decide (PairLightPrepared15.leftCached.map Prod.fst = PairLightPrepared15.leftVertices) = true := left_coverage_checked
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example :
    (PairLightPrepared15.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared15.sieve x.1)) = true := left_signatures_checked
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example :
    decide (PairLightPrepared15.rightCached.map Prod.fst = PairLightPrepared15.rightVertices) = true := right_coverage_checked
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightAdaptivePrepared15
example :
    (PairLightPrepared15.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared15.sieve x.1)) = true := right_signatures_checked
end D1Bound5.PairLightAdaptivePrepared15

namespace D1Bound5.PairLightPrepared15
example : List (Nat × Nat) := sieve
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example : List PairLightCoordinate := leftVertices
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example : List PairLightCachedVertex := leftCached
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example : List (Nat × List Nat) := leftRows
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example : List PairLightCoordinate := rightVertices
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example : List PairLightCachedVertex := rightCached
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example : List (Nat × List Nat) := rightRows
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example :
    decide (leftCached.map Prod.fst = leftVertices) = true := left_coverage_checked
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true := left_signatures_checked
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example :
    pairLightSelectedFloorIndependentBool 0 2 sieve leftCached leftRows = true := left_independent_checked
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example :
    pairLightSelectedFloorIndependentCertificateBool 0 2 sieve
      leftVertices leftCached leftRows = true := left_certificate_checked
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example :
    decide (rightCached.map Prod.fst = rightVertices) = true := right_coverage_checked
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true := right_signatures_checked
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example :
    pairLightSelectedFloorIndependentBool 0 2 sieve rightCached rightRows = true := right_independent_checked
end D1Bound5.PairLightPrepared15

namespace D1Bound5.PairLightPrepared15
example :
    pairLightSelectedFloorIndependentCertificateBool 0 2 sieve
      rightVertices rightCached rightRows = true := right_certificate_checked
end D1Bound5.PairLightPrepared15

run_cmd do
  for name in ([`D1Bound5.PairGraphPrepared15.anchorRoot, `D1Bound5.PairGraphPrepared15.colors, `D1Bound5.PairGraphPrepared15.destinations, `D1Bound5.PairGraphPrepared15.indexed_checked, `D1Bound5.PairGraphPrepared15.indexed_coverage_checked, `D1Bound5.PairGraphPrepared15.rootPairs, `D1Bound5.PairGraphPrepared15.witnesses, `D1Bound5.PairLightAdaptivePrepared15.leftCached000, `D1Bound5.PairLightAdaptivePrepared15.leftCached001, `D1Bound5.PairLightAdaptivePrepared15.leftCached002, `D1Bound5.PairLightAdaptivePrepared15.leftCached003, `D1Bound5.PairLightAdaptivePrepared15.leftRows000, `D1Bound5.PairLightAdaptivePrepared15.leftRows001, `D1Bound5.PairLightAdaptivePrepared15.leftRows002, `D1Bound5.PairLightAdaptivePrepared15.leftRows003, `D1Bound5.PairLightAdaptivePrepared15.left_coverage_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_000_part00_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_000_part01_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_000_part02_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_000_part03_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_000_part04_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_000_part05_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_000_part06_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_000_part07_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_001_part07_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_001_part08_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_001_part09_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_001_part10_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part07_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part08_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part09_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part10_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part11_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part12_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part13_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part14_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part15_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part16_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part17_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part18_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part19_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part20_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part21_checked, `D1Bound5.PairLightAdaptivePrepared15.left_parallel_002_part22_checked, `D1Bound5.PairLightAdaptivePrepared15.left_prefix_000_checked, `D1Bound5.PairLightAdaptivePrepared15.left_prefix_001_checked, `D1Bound5.PairLightAdaptivePrepared15.left_prefix_002_checked, `D1Bound5.PairLightAdaptivePrepared15.left_signatures_checked, `D1Bound5.PairLightAdaptivePrepared15.rightCached000, `D1Bound5.PairLightAdaptivePrepared15.rightCached001, `D1Bound5.PairLightAdaptivePrepared15.rightCached002, `D1Bound5.PairLightAdaptivePrepared15.rightCached003, `D1Bound5.PairLightAdaptivePrepared15.rightRows000, `D1Bound5.PairLightAdaptivePrepared15.rightRows001, `D1Bound5.PairLightAdaptivePrepared15.rightRows002, `D1Bound5.PairLightAdaptivePrepared15.rightRows003, `D1Bound5.PairLightAdaptivePrepared15.right_coverage_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_000_part00_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_000_part01_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_000_part02_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_000_part03_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_000_part04_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_000_part05_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_000_part06_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_000_part07_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_001_part07_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_001_part08_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_001_part09_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_001_part10_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part07_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part08_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part09_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part10_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part11_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part12_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part13_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part14_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part15_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part16_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part17_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part18_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part19_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part20_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part21_checked, `D1Bound5.PairLightAdaptivePrepared15.right_parallel_002_part22_checked, `D1Bound5.PairLightAdaptivePrepared15.right_prefix_000_checked, `D1Bound5.PairLightAdaptivePrepared15.right_prefix_001_checked, `D1Bound5.PairLightAdaptivePrepared15.right_prefix_002_checked, `D1Bound5.PairLightAdaptivePrepared15.right_signatures_checked, `D1Bound5.PairLightClosurePrepared15.a, `D1Bound5.PairLightClosurePrepared15.a_eq, `D1Bound5.PairLightClosurePrepared15.all_checked, `D1Bound5.PairLightClosurePrepared15.anchorRoot, `D1Bound5.PairLightClosurePrepared15.anchorRoot_eq, `D1Bound5.PairLightClosurePrepared15.b, `D1Bound5.PairLightClosurePrepared15.b_eq, `D1Bound5.PairLightClosurePrepared15.chunk00_checked, `D1Bound5.PairLightClosurePrepared15.chunk01_checked, `D1Bound5.PairLightClosurePrepared15.chunk02_checked, `D1Bound5.PairLightClosurePrepared15.chunk03_checked, `D1Bound5.PairLightClosurePrepared15.chunk04_checked, `D1Bound5.PairLightClosurePrepared15.chunk05_checked, `D1Bound5.PairLightClosurePrepared15.chunk06_checked, `D1Bound5.PairLightClosurePrepared15.chunk07_checked, `D1Bound5.PairLightClosurePrepared15.chunk08_checked, `D1Bound5.PairLightClosurePrepared15.chunk09_checked, `D1Bound5.PairLightClosurePrepared15.chunk10_checked, `D1Bound5.PairLightClosurePrepared15.chunk11_checked, `D1Bound5.PairLightClosurePrepared15.chunk12_checked, `D1Bound5.PairLightClosurePrepared15.chunk13_checked, `D1Bound5.PairLightClosurePrepared15.chunk14_checked, `D1Bound5.PairLightClosurePrepared15.chunk15_checked, `D1Bound5.PairLightClosurePrepared15.destinations, `D1Bound5.PairLightClosurePrepared15.destinationsChunk00, `D1Bound5.PairLightClosurePrepared15.destinationsChunk01, `D1Bound5.PairLightClosurePrepared15.destinationsChunk02, `D1Bound5.PairLightClosurePrepared15.destinationsChunk03, `D1Bound5.PairLightClosurePrepared15.destinationsChunk04, `D1Bound5.PairLightClosurePrepared15.destinationsChunk05, `D1Bound5.PairLightClosurePrepared15.destinationsChunk06, `D1Bound5.PairLightClosurePrepared15.destinationsChunk07, `D1Bound5.PairLightClosurePrepared15.destinations_eq, `D1Bound5.PairLightClosurePrepared15.original_indexed_checked, `D1Bound5.PairLightClosurePrepared15.original_witnesses_checked, `D1Bound5.PairLightClosurePrepared15.rootPairs, `D1Bound5.PairLightClosurePrepared15.rootPairsChunk00, `D1Bound5.PairLightClosurePrepared15.rootPairsChunk01, `D1Bound5.PairLightClosurePrepared15.rootPairsChunk02, `D1Bound5.PairLightClosurePrepared15.rootPairsChunk03, `D1Bound5.PairLightClosurePrepared15.rootPairsChunk04, `D1Bound5.PairLightClosurePrepared15.rootPairsChunk05, `D1Bound5.PairLightClosurePrepared15.rootPairsChunk06, `D1Bound5.PairLightClosurePrepared15.rootPairsChunk07, `D1Bound5.PairLightClosurePrepared15.vertices, `D1Bound5.PairLightClosurePrepared15.verticesChunk00, `D1Bound5.PairLightClosurePrepared15.verticesChunk01, `D1Bound5.PairLightClosurePrepared15.verticesChunk02, `D1Bound5.PairLightClosurePrepared15.verticesChunk03, `D1Bound5.PairLightClosurePrepared15.verticesChunk04, `D1Bound5.PairLightClosurePrepared15.verticesChunk05, `D1Bound5.PairLightClosurePrepared15.verticesChunk06, `D1Bound5.PairLightClosurePrepared15.verticesChunk07, `D1Bound5.PairLightClosurePrepared15.vertices_eq, `D1Bound5.PairLightClosurePrepared15.witnesses, `D1Bound5.PairLightClosurePrepared15.witnesses_eq, `D1Bound5.PairLightPrepared15.leftCached, `D1Bound5.PairLightPrepared15.leftCachedChunk00, `D1Bound5.PairLightPrepared15.leftCachedChunk01, `D1Bound5.PairLightPrepared15.leftCachedChunk02, `D1Bound5.PairLightPrepared15.leftCachedChunk03, `D1Bound5.PairLightPrepared15.leftCachedChunk04, `D1Bound5.PairLightPrepared15.leftCached_eq, `D1Bound5.PairLightPrepared15.leftRows, `D1Bound5.PairLightPrepared15.leftRows_eq, `D1Bound5.PairLightPrepared15.leftVertices, `D1Bound5.PairLightPrepared15.leftVertices_eq, `D1Bound5.PairLightPrepared15.left_certificate_checked, `D1Bound5.PairLightPrepared15.left_checked, `D1Bound5.PairLightPrepared15.left_coverage_checked, `D1Bound5.PairLightPrepared15.left_independent_checked, `D1Bound5.PairLightPrepared15.left_signatures_checked, `D1Bound5.PairLightPrepared15.rightCached, `D1Bound5.PairLightPrepared15.rightCachedChunk00, `D1Bound5.PairLightPrepared15.rightCachedChunk01, `D1Bound5.PairLightPrepared15.rightCachedChunk02, `D1Bound5.PairLightPrepared15.rightCachedChunk03, `D1Bound5.PairLightPrepared15.rightCached_eq, `D1Bound5.PairLightPrepared15.rightRows, `D1Bound5.PairLightPrepared15.rightRows_eq, `D1Bound5.PairLightPrepared15.rightVertices, `D1Bound5.PairLightPrepared15.rightVertices_eq, `D1Bound5.PairLightPrepared15.right_certificate_checked, `D1Bound5.PairLightPrepared15.right_checked, `D1Bound5.PairLightPrepared15.right_coverage_checked, `D1Bound5.PairLightPrepared15.right_independent_checked, `D1Bound5.PairLightPrepared15.right_signatures_checked, `D1Bound5.PairLightPrepared15.sieve, `D1Bound5.PairLightPrepared15.sieve_eq, `D1Bound5.PairSelectedPrepared15.leftCached, `D1Bound5.PairSelectedPrepared15.leftRows, `D1Bound5.PairSelectedPrepared15.rightCached, `D1Bound5.PairSelectedPrepared15.rightRows, `D1Bound5.smallPairA_15, `D1Bound5.smallPairB_15, `D1Bound5.smallPairClosure_15, `D1Bound5.smallPairClosure_15_checked, `D1Bound5.smallPairFilter_15_checked, `D1Bound5.smallPairLarge_15, `D1Bound5.smallPairLarge_15_count, `D1Bound5.smallPairNoTriangle_15_checked, `D1Bound5.smallPairSeeds_15_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
