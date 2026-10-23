import D1Bound5.SmallPairGraphData30
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
noncomputable section

namespace D1Bound5
example :
    pairSeedsCoveredBool smallPairA_30 smallPairB_30
      seedRootDisk_1_1 smallPairClosure_30 = true := smallPairSeeds_30_checked
end D1Bound5

namespace D1Bound5
example :
    largePairVertices smallPairA_30 smallPairB_30 smallPairClosure_30 = smallPairLarge_30 := smallPairFilter_30_checked
end D1Bound5

namespace D1Bound5
example : smallPairLarge_30.length = 962 := smallPairLarge_30_count
end D1Bound5

namespace D1Bound5
example :
    pairClosureIndexedWitnessBool smallPairA_30 smallPairB_30 anchorRoot
      (10^1100) smallPairClosure_30 witnesses destinations = true := PairGraphPrepared30.indexed_checked
end D1Bound5

namespace D1Bound5
example :
    pairClosureBool smallPairA_30 smallPairB_30
      (10^1100) smallPairClosure_30 = true := smallPairClosure_30_checked
end D1Bound5

namespace D1Bound5
example : QuadInt 1 1 := smallPairA_30
end D1Bound5

namespace D1Bound5
example : QuadInt 1 1 := smallPairB_30
end D1Bound5

namespace D1Bound5
example : List (QuadInt 1 1) := smallPairClosure_30
end D1Bound5

namespace D1Bound5
example : List (QuadInt 1 1) := smallPairLarge_30
end D1Bound5

namespace D1Bound5.PairGraphPrepared30
example : ℕ := colors
end D1Bound5.PairGraphPrepared30

namespace D1Bound5.PairGraphPrepared30
example : QuadInt 1 1 := anchorRoot
end D1Bound5.PairGraphPrepared30

namespace D1Bound5.PairGraphPrepared30
example : List (QuadInt 1 1 × QuadInt 1 1) := rootPairs
end D1Bound5.PairGraphPrepared30

namespace D1Bound5.PairGraphPrepared30
example : List (PairRootWitness 1 1) := witnesses
end D1Bound5.PairGraphPrepared30

namespace D1Bound5.PairGraphPrepared30
example : List (Option ℕ × Option ℕ) := destinations
end D1Bound5.PairGraphPrepared30

namespace D1Bound5.PairSelectedPrepared30
example : List (PairResidueVertex 1 1) := leftCached
end D1Bound5.PairSelectedPrepared30

namespace D1Bound5.PairSelectedPrepared30
example : List (ℕ × List ℕ) := leftRows
end D1Bound5.PairSelectedPrepared30

namespace D1Bound5.PairSelectedPrepared30
example : List (PairResidueVertex 1 1) := rightCached
end D1Bound5.PairSelectedPrepared30

namespace D1Bound5.PairSelectedPrepared30
example : List (ℕ × List ℕ) := rightRows
end D1Bound5.PairSelectedPrepared30

namespace D1Bound5.PairLightPrepared30
example : sieve = smallPairSieve_1_1 := sieve_eq
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example :
    leftVertices = (pairSplitByMask smallPairLarge_30 PairGraphPrepared30.colors).1.map pairLightCoordinates := leftVertices_eq
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example :
    leftCached = PairSelectedPrepared30.leftCached.map pairLightCachedCoordinates := leftCached_eq
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example : leftRows = PairSelectedPrepared30.leftRows := leftRows_eq
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example :
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_30 PairGraphPrepared30.colors).1 = true := left_checked
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example :
    rightVertices = (pairSplitByMask smallPairLarge_30 PairGraphPrepared30.colors).2.map pairLightCoordinates := rightVertices_eq
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example :
    rightCached = PairSelectedPrepared30.rightCached.map pairLightCachedCoordinates := rightCached_eq
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example : rightRows = PairSelectedPrepared30.rightRows := rightRows_eq
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example :
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_30 PairGraphPrepared30.colors).2 = true := right_checked
end D1Bound5.PairLightPrepared30

namespace D1Bound5
example :
    pairGraphTriangleFreeBool smallPairSieve_1_1 smallPairLarge_30 = true := smallPairNoTriangle_30_checked
end D1Bound5

namespace D1Bound5.PairLightAdaptivePrepared30
example : List PairLightCachedVertex := leftCached000
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example : List (Nat × List Nat) := leftRows000
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example : List PairLightCachedVertex := leftCached001
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example : List (Nat × List Nat) := leftRows001
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example : List PairLightCachedVertex := leftCached002
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example : List (Nat × List Nat) := leftRows002
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example : List PairLightCachedVertex := leftCached003
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example : List (Nat × List Nat) := leftRows003
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example : List PairLightCachedVertex := rightCached000
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example : List (Nat × List Nat) := rightRows000
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example : List PairLightCachedVertex := rightCached001
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example : List (Nat × List Nat) := rightRows001
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example : List PairLightCachedVertex := rightCached002
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example : List (Nat × List Nat) := rightRows002
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example : List PairLightCachedVertex := rightCached003
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example : List (Nat × List Nat) := rightRows003
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 91
      leftCached000 leftRows000 = true := left_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 121
      leftCached001 leftRows001 = true := left_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 270
      leftCached002 leftRows002 = true := left_prefix_002_checked
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 92
      rightCached000 rightRows000 = true := right_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 122
      rightCached001 rightRows001 = true := right_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared30.sieve 266
      rightCached002 rightRows002 = true := right_prefix_002_checked
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example :
    decide (PairLightPrepared30.leftCached.map Prod.fst = PairLightPrepared30.leftVertices) = true := left_coverage_checked
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example :
    (PairLightPrepared30.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared30.sieve x.1)) = true := left_signatures_checked
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example :
    decide (PairLightPrepared30.rightCached.map Prod.fst = PairLightPrepared30.rightVertices) = true := right_coverage_checked
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightAdaptivePrepared30
example :
    (PairLightPrepared30.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared30.sieve x.1)) = true := right_signatures_checked
end D1Bound5.PairLightAdaptivePrepared30

namespace D1Bound5.PairLightPrepared30
example : List (Nat × Nat) := sieve
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example : List PairLightCoordinate := leftVertices
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example : List PairLightCachedVertex := leftCached
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example : List (Nat × List Nat) := leftRows
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example : List PairLightCoordinate := rightVertices
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example : List PairLightCachedVertex := rightCached
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example : List (Nat × List Nat) := rightRows
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example :
    decide (leftCached.map Prod.fst = leftVertices) = true := left_coverage_checked
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true := left_signatures_checked
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example :
    pairLightSelectedFloorIndependentBool 1 1 sieve leftCached leftRows = true := left_independent_checked
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example :
    pairLightSelectedFloorIndependentCertificateBool 1 1 sieve
      leftVertices leftCached leftRows = true := left_certificate_checked
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example :
    decide (rightCached.map Prod.fst = rightVertices) = true := right_coverage_checked
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true := right_signatures_checked
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example :
    pairLightSelectedFloorIndependentBool 1 1 sieve rightCached rightRows = true := right_independent_checked
end D1Bound5.PairLightPrepared30

namespace D1Bound5.PairLightPrepared30
example :
    pairLightSelectedFloorIndependentCertificateBool 1 1 sieve
      rightVertices rightCached rightRows = true := right_certificate_checked
end D1Bound5.PairLightPrepared30

run_cmd do
  for name in ([`D1Bound5.PairGraphPrepared30.anchorRoot, `D1Bound5.PairGraphPrepared30.colors, `D1Bound5.PairGraphPrepared30.destinations, `D1Bound5.PairGraphPrepared30.indexed_checked, `D1Bound5.PairGraphPrepared30.indexed_coverage_checked, `D1Bound5.PairGraphPrepared30.rootPairs, `D1Bound5.PairGraphPrepared30.witnesses, `D1Bound5.PairLightAdaptivePrepared30.leftCached000, `D1Bound5.PairLightAdaptivePrepared30.leftCached001, `D1Bound5.PairLightAdaptivePrepared30.leftCached002, `D1Bound5.PairLightAdaptivePrepared30.leftCached003, `D1Bound5.PairLightAdaptivePrepared30.leftRows000, `D1Bound5.PairLightAdaptivePrepared30.leftRows001, `D1Bound5.PairLightAdaptivePrepared30.leftRows002, `D1Bound5.PairLightAdaptivePrepared30.leftRows003, `D1Bound5.PairLightAdaptivePrepared30.left_coverage_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_000_part00_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_000_part01_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_000_part02_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_000_part03_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_000_part04_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_000_part05_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_000_part06_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_000_part07_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_001_part07_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_001_part08_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_001_part09_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_001_part10_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part07_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part08_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part09_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part10_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part11_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part12_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part13_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part14_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part15_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part16_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part17_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part18_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part19_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part20_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part21_checked, `D1Bound5.PairLightAdaptivePrepared30.left_parallel_002_part22_checked, `D1Bound5.PairLightAdaptivePrepared30.left_prefix_000_checked, `D1Bound5.PairLightAdaptivePrepared30.left_prefix_001_checked, `D1Bound5.PairLightAdaptivePrepared30.left_prefix_002_checked, `D1Bound5.PairLightAdaptivePrepared30.left_signatures_checked, `D1Bound5.PairLightAdaptivePrepared30.rightCached000, `D1Bound5.PairLightAdaptivePrepared30.rightCached001, `D1Bound5.PairLightAdaptivePrepared30.rightCached002, `D1Bound5.PairLightAdaptivePrepared30.rightCached003, `D1Bound5.PairLightAdaptivePrepared30.rightRows000, `D1Bound5.PairLightAdaptivePrepared30.rightRows001, `D1Bound5.PairLightAdaptivePrepared30.rightRows002, `D1Bound5.PairLightAdaptivePrepared30.rightRows003, `D1Bound5.PairLightAdaptivePrepared30.right_coverage_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_000_part00_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_000_part01_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_000_part02_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_000_part03_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_000_part04_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_000_part05_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_000_part06_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_000_part07_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_001_part07_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_001_part08_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_001_part09_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_001_part10_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part07_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part08_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part09_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part10_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part11_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part12_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part13_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part14_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part15_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part16_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part17_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part18_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part19_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part20_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part21_checked, `D1Bound5.PairLightAdaptivePrepared30.right_parallel_002_part22_checked, `D1Bound5.PairLightAdaptivePrepared30.right_prefix_000_checked, `D1Bound5.PairLightAdaptivePrepared30.right_prefix_001_checked, `D1Bound5.PairLightAdaptivePrepared30.right_prefix_002_checked, `D1Bound5.PairLightAdaptivePrepared30.right_signatures_checked, `D1Bound5.PairLightClosurePrepared30.a, `D1Bound5.PairLightClosurePrepared30.a_eq, `D1Bound5.PairLightClosurePrepared30.all_checked, `D1Bound5.PairLightClosurePrepared30.anchorRoot, `D1Bound5.PairLightClosurePrepared30.anchorRoot_eq, `D1Bound5.PairLightClosurePrepared30.b, `D1Bound5.PairLightClosurePrepared30.b_eq, `D1Bound5.PairLightClosurePrepared30.chunk00_checked, `D1Bound5.PairLightClosurePrepared30.chunk01_checked, `D1Bound5.PairLightClosurePrepared30.chunk02_checked, `D1Bound5.PairLightClosurePrepared30.chunk03_checked, `D1Bound5.PairLightClosurePrepared30.chunk04_checked, `D1Bound5.PairLightClosurePrepared30.chunk05_checked, `D1Bound5.PairLightClosurePrepared30.chunk06_checked, `D1Bound5.PairLightClosurePrepared30.chunk07_checked, `D1Bound5.PairLightClosurePrepared30.chunk08_checked, `D1Bound5.PairLightClosurePrepared30.chunk09_checked, `D1Bound5.PairLightClosurePrepared30.chunk10_checked, `D1Bound5.PairLightClosurePrepared30.chunk11_checked, `D1Bound5.PairLightClosurePrepared30.chunk12_checked, `D1Bound5.PairLightClosurePrepared30.chunk13_checked, `D1Bound5.PairLightClosurePrepared30.chunk14_checked, `D1Bound5.PairLightClosurePrepared30.chunk15_checked, `D1Bound5.PairLightClosurePrepared30.destinations, `D1Bound5.PairLightClosurePrepared30.destinationsChunk00, `D1Bound5.PairLightClosurePrepared30.destinationsChunk01, `D1Bound5.PairLightClosurePrepared30.destinationsChunk02, `D1Bound5.PairLightClosurePrepared30.destinationsChunk03, `D1Bound5.PairLightClosurePrepared30.destinationsChunk04, `D1Bound5.PairLightClosurePrepared30.destinationsChunk05, `D1Bound5.PairLightClosurePrepared30.destinationsChunk06, `D1Bound5.PairLightClosurePrepared30.destinationsChunk07, `D1Bound5.PairLightClosurePrepared30.destinations_eq, `D1Bound5.PairLightClosurePrepared30.original_indexed_checked, `D1Bound5.PairLightClosurePrepared30.original_witnesses_checked, `D1Bound5.PairLightClosurePrepared30.rootPairs, `D1Bound5.PairLightClosurePrepared30.rootPairsChunk00, `D1Bound5.PairLightClosurePrepared30.rootPairsChunk01, `D1Bound5.PairLightClosurePrepared30.rootPairsChunk02, `D1Bound5.PairLightClosurePrepared30.rootPairsChunk03, `D1Bound5.PairLightClosurePrepared30.rootPairsChunk04, `D1Bound5.PairLightClosurePrepared30.rootPairsChunk05, `D1Bound5.PairLightClosurePrepared30.rootPairsChunk06, `D1Bound5.PairLightClosurePrepared30.rootPairsChunk07, `D1Bound5.PairLightClosurePrepared30.vertices, `D1Bound5.PairLightClosurePrepared30.verticesChunk00, `D1Bound5.PairLightClosurePrepared30.verticesChunk01, `D1Bound5.PairLightClosurePrepared30.verticesChunk02, `D1Bound5.PairLightClosurePrepared30.verticesChunk03, `D1Bound5.PairLightClosurePrepared30.verticesChunk04, `D1Bound5.PairLightClosurePrepared30.verticesChunk05, `D1Bound5.PairLightClosurePrepared30.verticesChunk06, `D1Bound5.PairLightClosurePrepared30.verticesChunk07, `D1Bound5.PairLightClosurePrepared30.vertices_eq, `D1Bound5.PairLightClosurePrepared30.witnesses, `D1Bound5.PairLightClosurePrepared30.witnesses_eq, `D1Bound5.PairLightPrepared30.leftCached, `D1Bound5.PairLightPrepared30.leftCachedChunk00, `D1Bound5.PairLightPrepared30.leftCachedChunk01, `D1Bound5.PairLightPrepared30.leftCachedChunk02, `D1Bound5.PairLightPrepared30.leftCachedChunk03, `D1Bound5.PairLightPrepared30.leftCachedChunk04, `D1Bound5.PairLightPrepared30.leftCached_eq, `D1Bound5.PairLightPrepared30.leftRows, `D1Bound5.PairLightPrepared30.leftRows_eq, `D1Bound5.PairLightPrepared30.leftVertices, `D1Bound5.PairLightPrepared30.leftVertices_eq, `D1Bound5.PairLightPrepared30.left_certificate_checked, `D1Bound5.PairLightPrepared30.left_checked, `D1Bound5.PairLightPrepared30.left_coverage_checked, `D1Bound5.PairLightPrepared30.left_independent_checked, `D1Bound5.PairLightPrepared30.left_signatures_checked, `D1Bound5.PairLightPrepared30.rightCached, `D1Bound5.PairLightPrepared30.rightCachedChunk00, `D1Bound5.PairLightPrepared30.rightCachedChunk01, `D1Bound5.PairLightPrepared30.rightCachedChunk02, `D1Bound5.PairLightPrepared30.rightCachedChunk03, `D1Bound5.PairLightPrepared30.rightCached_eq, `D1Bound5.PairLightPrepared30.rightRows, `D1Bound5.PairLightPrepared30.rightRows_eq, `D1Bound5.PairLightPrepared30.rightVertices, `D1Bound5.PairLightPrepared30.rightVertices_eq, `D1Bound5.PairLightPrepared30.right_certificate_checked, `D1Bound5.PairLightPrepared30.right_checked, `D1Bound5.PairLightPrepared30.right_coverage_checked, `D1Bound5.PairLightPrepared30.right_independent_checked, `D1Bound5.PairLightPrepared30.right_signatures_checked, `D1Bound5.PairLightPrepared30.sieve, `D1Bound5.PairLightPrepared30.sieve_eq, `D1Bound5.PairSelectedPrepared30.leftCached, `D1Bound5.PairSelectedPrepared30.leftRows, `D1Bound5.PairSelectedPrepared30.rightCached, `D1Bound5.PairSelectedPrepared30.rightRows, `D1Bound5.smallPairA_30, `D1Bound5.smallPairB_30, `D1Bound5.smallPairClosure_30, `D1Bound5.smallPairClosure_30_checked, `D1Bound5.smallPairFilter_30_checked, `D1Bound5.smallPairLarge_30, `D1Bound5.smallPairLarge_30_count, `D1Bound5.smallPairNoTriangle_30_checked, `D1Bound5.smallPairSeeds_30_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
