import D1Bound5.SmallPairGraphData28
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
noncomputable section

namespace D1Bound5
open QuadInt
example :
    pairSeedsCoveredBool smallPairA_28 smallPairB_28
      seedRootDisk_1_1 smallPairClosure_28 = true := smallPairSeeds_28_checked
end D1Bound5

namespace D1Bound5
open QuadInt
example :
    largePairVertices smallPairA_28 smallPairB_28 smallPairClosure_28 = smallPairLarge_28 := smallPairFilter_28_checked
end D1Bound5

namespace D1Bound5
open QuadInt
example : smallPairLarge_28.length = 1048 := smallPairLarge_28_count
end D1Bound5

namespace D1Bound5
open QuadInt
open PairGraphPrepared28
example :
    pairClosureIndexedWitnessBool smallPairA_28 smallPairB_28 anchorRoot
      (10^1100) smallPairClosure_28 witnesses destinations = true := PairGraphPrepared28.indexed_checked
end D1Bound5

namespace D1Bound5
open QuadInt
open PairGraphPrepared28
example :
    pairClosureBool smallPairA_28 smallPairB_28
      (10^1100) smallPairClosure_28 = true := smallPairClosure_28_checked
end D1Bound5

namespace D1Bound5
open QuadInt
example : QuadInt 1 1 := smallPairA_28
end D1Bound5

namespace D1Bound5
open QuadInt
example : QuadInt 1 1 := smallPairB_28
end D1Bound5

namespace D1Bound5
open QuadInt
example : List (QuadInt 1 1) := smallPairClosure_28
end D1Bound5

namespace D1Bound5
open QuadInt
example : List (QuadInt 1 1) := smallPairLarge_28
end D1Bound5

namespace D1Bound5.PairGraphPrepared28
open QuadInt
example : ℕ := colors
end D1Bound5.PairGraphPrepared28

namespace D1Bound5.PairGraphPrepared28
example : QuadInt 1 1 := anchorRoot
end D1Bound5.PairGraphPrepared28

namespace D1Bound5.PairGraphPrepared28
example : List (QuadInt 1 1 × QuadInt 1 1) := rootPairs
end D1Bound5.PairGraphPrepared28

namespace D1Bound5.PairGraphPrepared28
example : List (PairRootWitness 1 1) := witnesses
end D1Bound5.PairGraphPrepared28

namespace D1Bound5.PairGraphPrepared28
example : List (Option ℕ × Option ℕ) := destinations
end D1Bound5.PairGraphPrepared28

namespace D1Bound5.PairSelectedPrepared28
example : List (PairResidueVertex 1 1) := leftCached
end D1Bound5.PairSelectedPrepared28

namespace D1Bound5.PairSelectedPrepared28
example : List (ℕ × List ℕ) := leftRows
end D1Bound5.PairSelectedPrepared28

namespace D1Bound5.PairSelectedPrepared28
example : List (PairResidueVertex 1 1) := rightCached
end D1Bound5.PairSelectedPrepared28

namespace D1Bound5.PairSelectedPrepared28
example : List (ℕ × List ℕ) := rightRows
end D1Bound5.PairSelectedPrepared28

namespace D1Bound5.PairLightPrepared28
example : sieve = smallPairSieve_1_1 := sieve_eq
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example :
    leftVertices = (pairSplitByMask smallPairLarge_28 PairGraphPrepared28.colors).1.map pairLightCoordinates := leftVertices_eq
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example :
    leftCached = PairSelectedPrepared28.leftCached.map pairLightCachedCoordinates := leftCached_eq
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example : leftRows = PairSelectedPrepared28.leftRows := leftRows_eq
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example :
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_28 PairGraphPrepared28.colors).1 = true := left_checked
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example :
    rightVertices = (pairSplitByMask smallPairLarge_28 PairGraphPrepared28.colors).2.map pairLightCoordinates := rightVertices_eq
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example :
    rightCached = PairSelectedPrepared28.rightCached.map pairLightCachedCoordinates := rightCached_eq
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example : rightRows = PairSelectedPrepared28.rightRows := rightRows_eq
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example :
    pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_28 PairGraphPrepared28.colors).2 = true := right_checked
end D1Bound5.PairLightPrepared28

namespace D1Bound5
example :
    pairGraphTriangleFreeBool smallPairSieve_1_1 smallPairLarge_28 = true := smallPairNoTriangle_28_checked
end D1Bound5

namespace D1Bound5.PairLightAdaptivePrepared28
example : List PairLightCachedVertex := leftCached000
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example : List (Nat × List Nat) := leftRows000
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example : List PairLightCachedVertex := leftCached001
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example : List (Nat × List Nat) := leftRows001
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example : List PairLightCachedVertex := leftCached002
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example : List (Nat × List Nat) := leftRows002
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example : List PairLightCachedVertex := leftCached003
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example : List (Nat × List Nat) := leftRows003
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example : List PairLightCachedVertex := leftCached004
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example : List (Nat × List Nat) := leftRows004
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example : List PairLightCachedVertex := rightCached000
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example : List (Nat × List Nat) := rightRows000
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example : List PairLightCachedVertex := rightCached001
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example : List (Nat × List Nat) := rightRows001
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example : List PairLightCachedVertex := rightCached002
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example : List (Nat × List Nat) := rightRows002
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example : List PairLightCachedVertex := rightCached003
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example : List (Nat × List Nat) := rightRows003
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example : List PairLightCachedVertex := rightCached004
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example : List (Nat × List Nat) := rightRows004
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 82
      leftCached000 leftRows000 = true := left_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 102
      leftCached001 leftRows001 = true := left_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 151
      leftCached002 leftRows002 = true := left_prefix_002_checked
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 189
      leftCached003 leftRows003 = true := left_prefix_003_checked
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 82
      rightCached000 rightRows000 = true := right_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 102
      rightCached001 rightRows001 = true := right_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 151
      rightCached002 rightRows002 = true := right_prefix_002_checked
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared28.sieve 189
      rightCached003 rightRows003 = true := right_prefix_003_checked
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example :
    decide (PairLightPrepared28.leftCached.map Prod.fst = PairLightPrepared28.leftVertices) = true := left_coverage_checked
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example :
    (PairLightPrepared28.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared28.sieve x.1)) = true := left_signatures_checked
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example :
    decide (PairLightPrepared28.rightCached.map Prod.fst = PairLightPrepared28.rightVertices) = true := right_coverage_checked
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightAdaptivePrepared28
example :
    (PairLightPrepared28.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared28.sieve x.1)) = true := right_signatures_checked
end D1Bound5.PairLightAdaptivePrepared28

namespace D1Bound5.PairLightPrepared28
example : List (Nat × Nat) := sieve
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example : List PairLightCoordinate := leftVertices
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example : List PairLightCachedVertex := leftCached
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example : List (Nat × List Nat) := leftRows
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example : List PairLightCoordinate := rightVertices
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example : List PairLightCachedVertex := rightCached
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example : List (Nat × List Nat) := rightRows
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example :
    decide (leftCached.map Prod.fst = leftVertices) = true := left_coverage_checked
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true := left_signatures_checked
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example :
    pairLightSelectedFloorIndependentBool 1 1 sieve leftCached leftRows = true := left_independent_checked
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example :
    pairLightSelectedFloorIndependentCertificateBool 1 1 sieve
      leftVertices leftCached leftRows = true := left_certificate_checked
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example :
    decide (rightCached.map Prod.fst = rightVertices) = true := right_coverage_checked
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true := right_signatures_checked
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example :
    pairLightSelectedFloorIndependentBool 1 1 sieve rightCached rightRows = true := right_independent_checked
end D1Bound5.PairLightPrepared28

namespace D1Bound5.PairLightPrepared28
example :
    pairLightSelectedFloorIndependentCertificateBool 1 1 sieve
      rightVertices rightCached rightRows = true := right_certificate_checked
end D1Bound5.PairLightPrepared28

run_cmd do
  for name in ([`D1Bound5.PairGraphPrepared28.anchorRoot, `D1Bound5.PairGraphPrepared28.colors, `D1Bound5.PairGraphPrepared28.destinations, `D1Bound5.PairGraphPrepared28.indexed_checked, `D1Bound5.PairGraphPrepared28.indexed_coverage_checked, `D1Bound5.PairGraphPrepared28.rootPairs, `D1Bound5.PairGraphPrepared28.witnesses, `D1Bound5.PairLightAdaptivePrepared28.leftCached000, `D1Bound5.PairLightAdaptivePrepared28.leftCached001, `D1Bound5.PairLightAdaptivePrepared28.leftCached002, `D1Bound5.PairLightAdaptivePrepared28.leftCached003, `D1Bound5.PairLightAdaptivePrepared28.leftCached004, `D1Bound5.PairLightAdaptivePrepared28.leftRows000, `D1Bound5.PairLightAdaptivePrepared28.leftRows001, `D1Bound5.PairLightAdaptivePrepared28.leftRows002, `D1Bound5.PairLightAdaptivePrepared28.leftRows003, `D1Bound5.PairLightAdaptivePrepared28.leftRows004, `D1Bound5.PairLightAdaptivePrepared28.left_coverage_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_000_part00_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_000_part01_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_000_part02_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_000_part03_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_000_part04_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_000_part05_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_000_part06_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_001_part07_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_001_part08_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_002_part07_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_002_part08_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_002_part09_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_002_part10_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_002_part11_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_002_part12_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_003_part00_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_003_part01_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_003_part02_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_003_part03_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_003_part04_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_003_part05_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_003_part06_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_003_part07_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_003_part08_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_003_part09_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_003_part10_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_003_part11_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_003_part12_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_003_part13_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_003_part14_checked, `D1Bound5.PairLightAdaptivePrepared28.left_parallel_003_part15_checked, `D1Bound5.PairLightAdaptivePrepared28.left_prefix_000_checked, `D1Bound5.PairLightAdaptivePrepared28.left_prefix_001_checked, `D1Bound5.PairLightAdaptivePrepared28.left_prefix_002_checked, `D1Bound5.PairLightAdaptivePrepared28.left_prefix_003_checked, `D1Bound5.PairLightAdaptivePrepared28.left_signatures_checked, `D1Bound5.PairLightAdaptivePrepared28.rightCached000, `D1Bound5.PairLightAdaptivePrepared28.rightCached001, `D1Bound5.PairLightAdaptivePrepared28.rightCached002, `D1Bound5.PairLightAdaptivePrepared28.rightCached003, `D1Bound5.PairLightAdaptivePrepared28.rightCached004, `D1Bound5.PairLightAdaptivePrepared28.rightRows000, `D1Bound5.PairLightAdaptivePrepared28.rightRows001, `D1Bound5.PairLightAdaptivePrepared28.rightRows002, `D1Bound5.PairLightAdaptivePrepared28.rightRows003, `D1Bound5.PairLightAdaptivePrepared28.rightRows004, `D1Bound5.PairLightAdaptivePrepared28.right_coverage_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_000_part00_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_000_part01_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_000_part02_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_000_part03_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_000_part04_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_000_part05_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_000_part06_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_001_part00_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_001_part01_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_001_part02_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_001_part03_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_001_part04_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_001_part05_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_001_part06_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_001_part07_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_001_part08_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_002_part00_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_002_part01_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_002_part02_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_002_part03_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_002_part04_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_002_part05_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_002_part06_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_002_part07_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_002_part08_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_002_part09_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_002_part10_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_002_part11_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_002_part12_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_003_part00_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_003_part01_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_003_part02_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_003_part03_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_003_part04_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_003_part05_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_003_part06_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_003_part07_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_003_part08_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_003_part09_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_003_part10_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_003_part11_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_003_part12_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_003_part13_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_003_part14_checked, `D1Bound5.PairLightAdaptivePrepared28.right_parallel_003_part15_checked, `D1Bound5.PairLightAdaptivePrepared28.right_prefix_000_checked, `D1Bound5.PairLightAdaptivePrepared28.right_prefix_001_checked, `D1Bound5.PairLightAdaptivePrepared28.right_prefix_002_checked, `D1Bound5.PairLightAdaptivePrepared28.right_prefix_003_checked, `D1Bound5.PairLightAdaptivePrepared28.right_signatures_checked, `D1Bound5.PairLightClosurePrepared28.a, `D1Bound5.PairLightClosurePrepared28.a_eq, `D1Bound5.PairLightClosurePrepared28.all_checked, `D1Bound5.PairLightClosurePrepared28.anchorRoot, `D1Bound5.PairLightClosurePrepared28.anchorRoot_eq, `D1Bound5.PairLightClosurePrepared28.b, `D1Bound5.PairLightClosurePrepared28.b_eq, `D1Bound5.PairLightClosurePrepared28.chunk00_checked, `D1Bound5.PairLightClosurePrepared28.chunk01_checked, `D1Bound5.PairLightClosurePrepared28.chunk02_checked, `D1Bound5.PairLightClosurePrepared28.chunk03_checked, `D1Bound5.PairLightClosurePrepared28.chunk04_checked, `D1Bound5.PairLightClosurePrepared28.chunk05_checked, `D1Bound5.PairLightClosurePrepared28.chunk06_checked, `D1Bound5.PairLightClosurePrepared28.chunk07_checked, `D1Bound5.PairLightClosurePrepared28.chunk08_checked, `D1Bound5.PairLightClosurePrepared28.chunk09_checked, `D1Bound5.PairLightClosurePrepared28.chunk10_checked, `D1Bound5.PairLightClosurePrepared28.chunk11_checked, `D1Bound5.PairLightClosurePrepared28.chunk12_checked, `D1Bound5.PairLightClosurePrepared28.chunk13_checked, `D1Bound5.PairLightClosurePrepared28.chunk14_checked, `D1Bound5.PairLightClosurePrepared28.chunk15_checked, `D1Bound5.PairLightClosurePrepared28.chunk16_checked, `D1Bound5.PairLightClosurePrepared28.destinations, `D1Bound5.PairLightClosurePrepared28.destinationsChunk00, `D1Bound5.PairLightClosurePrepared28.destinationsChunk01, `D1Bound5.PairLightClosurePrepared28.destinationsChunk02, `D1Bound5.PairLightClosurePrepared28.destinationsChunk03, `D1Bound5.PairLightClosurePrepared28.destinationsChunk04, `D1Bound5.PairLightClosurePrepared28.destinationsChunk05, `D1Bound5.PairLightClosurePrepared28.destinationsChunk06, `D1Bound5.PairLightClosurePrepared28.destinationsChunk07, `D1Bound5.PairLightClosurePrepared28.destinationsChunk08, `D1Bound5.PairLightClosurePrepared28.destinations_eq, `D1Bound5.PairLightClosurePrepared28.original_indexed_checked, `D1Bound5.PairLightClosurePrepared28.original_witnesses_checked, `D1Bound5.PairLightClosurePrepared28.rootPairs, `D1Bound5.PairLightClosurePrepared28.rootPairsChunk00, `D1Bound5.PairLightClosurePrepared28.rootPairsChunk01, `D1Bound5.PairLightClosurePrepared28.rootPairsChunk02, `D1Bound5.PairLightClosurePrepared28.rootPairsChunk03, `D1Bound5.PairLightClosurePrepared28.rootPairsChunk04, `D1Bound5.PairLightClosurePrepared28.rootPairsChunk05, `D1Bound5.PairLightClosurePrepared28.rootPairsChunk06, `D1Bound5.PairLightClosurePrepared28.rootPairsChunk07, `D1Bound5.PairLightClosurePrepared28.rootPairsChunk08, `D1Bound5.PairLightClosurePrepared28.vertices, `D1Bound5.PairLightClosurePrepared28.verticesChunk00, `D1Bound5.PairLightClosurePrepared28.verticesChunk01, `D1Bound5.PairLightClosurePrepared28.verticesChunk02, `D1Bound5.PairLightClosurePrepared28.verticesChunk03, `D1Bound5.PairLightClosurePrepared28.verticesChunk04, `D1Bound5.PairLightClosurePrepared28.verticesChunk05, `D1Bound5.PairLightClosurePrepared28.verticesChunk06, `D1Bound5.PairLightClosurePrepared28.verticesChunk07, `D1Bound5.PairLightClosurePrepared28.verticesChunk08, `D1Bound5.PairLightClosurePrepared28.vertices_eq, `D1Bound5.PairLightClosurePrepared28.witnesses, `D1Bound5.PairLightClosurePrepared28.witnesses_eq, `D1Bound5.PairLightPrepared28.leftCached, `D1Bound5.PairLightPrepared28.leftCachedChunk00, `D1Bound5.PairLightPrepared28.leftCachedChunk01, `D1Bound5.PairLightPrepared28.leftCachedChunk02, `D1Bound5.PairLightPrepared28.leftCachedChunk03, `D1Bound5.PairLightPrepared28.leftCachedChunk04, `D1Bound5.PairLightPrepared28.leftCached_eq, `D1Bound5.PairLightPrepared28.leftRows, `D1Bound5.PairLightPrepared28.leftRows_eq, `D1Bound5.PairLightPrepared28.leftVertices, `D1Bound5.PairLightPrepared28.leftVertices_eq, `D1Bound5.PairLightPrepared28.left_certificate_checked, `D1Bound5.PairLightPrepared28.left_checked, `D1Bound5.PairLightPrepared28.left_coverage_checked, `D1Bound5.PairLightPrepared28.left_independent_checked, `D1Bound5.PairLightPrepared28.left_signatures_checked, `D1Bound5.PairLightPrepared28.rightCached, `D1Bound5.PairLightPrepared28.rightCachedChunk00, `D1Bound5.PairLightPrepared28.rightCachedChunk01, `D1Bound5.PairLightPrepared28.rightCachedChunk02, `D1Bound5.PairLightPrepared28.rightCachedChunk03, `D1Bound5.PairLightPrepared28.rightCachedChunk04, `D1Bound5.PairLightPrepared28.rightCached_eq, `D1Bound5.PairLightPrepared28.rightRows, `D1Bound5.PairLightPrepared28.rightRows_eq, `D1Bound5.PairLightPrepared28.rightVertices, `D1Bound5.PairLightPrepared28.rightVertices_eq, `D1Bound5.PairLightPrepared28.right_certificate_checked, `D1Bound5.PairLightPrepared28.right_checked, `D1Bound5.PairLightPrepared28.right_coverage_checked, `D1Bound5.PairLightPrepared28.right_independent_checked, `D1Bound5.PairLightPrepared28.right_signatures_checked, `D1Bound5.PairLightPrepared28.sieve, `D1Bound5.PairLightPrepared28.sieve_eq, `D1Bound5.PairSelectedPrepared28.leftCached, `D1Bound5.PairSelectedPrepared28.leftRows, `D1Bound5.PairSelectedPrepared28.rightCached, `D1Bound5.PairSelectedPrepared28.rightRows, `D1Bound5.smallPairA_28, `D1Bound5.smallPairB_28, `D1Bound5.smallPairClosure_28, `D1Bound5.smallPairClosure_28_checked, `D1Bound5.smallPairFilter_28_checked, `D1Bound5.smallPairLarge_28, `D1Bound5.smallPairLarge_28_count, `D1Bound5.smallPairNoTriangle_28_checked, `D1Bound5.smallPairSeeds_28_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
