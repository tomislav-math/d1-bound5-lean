import D1Bound5.SmallPairGraphData39
import Lean.Util.CollectAxioms
import Lean.Elab.Command
noncomputable section
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5
open QuadInt
example : QuadInt 1 2 := smallPairA_39
end D1Bound5
namespace D1Bound5
open QuadInt
example : QuadInt 1 2 := smallPairB_39
end D1Bound5
namespace D1Bound5
open QuadInt
example : List (QuadInt 1 2) := smallPairClosure_39
end D1Bound5
namespace D1Bound5
open QuadInt
example : List (QuadInt 1 2) := smallPairLarge_39
end D1Bound5
namespace D1Bound5.PairGraphPrepared39
open QuadInt
example : ℕ := colors
end D1Bound5.PairGraphPrepared39
namespace D1Bound5
open QuadInt
example :
    pairSeedsCoveredBool smallPairA_39 smallPairB_39
      seedRootDisk_1_2 smallPairClosure_39 = true := smallPairSeeds_39_checked
end D1Bound5
namespace D1Bound5
open QuadInt
example :
    largePairVertices smallPairA_39 smallPairB_39 smallPairClosure_39 = smallPairLarge_39 := smallPairFilter_39_checked
end D1Bound5
namespace D1Bound5
open QuadInt
example : smallPairLarge_39.length = 914 := smallPairLarge_39_count
end D1Bound5
namespace D1Bound5.PairGraphPrepared39
open QuadInt
example : QuadInt 1 2 := anchorRoot
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39
open QuadInt
example : List (QuadInt 1 2 × QuadInt 1 2) := rootPairs
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39
open QuadInt
example : List (PairRootWitness 1 2) := witnesses
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39
open QuadInt
example : List (Option ℕ × Option ℕ) := destinations
end D1Bound5.PairGraphPrepared39
namespace D1Bound5
open QuadInt
open PairGraphPrepared39
example :
    pairClosureIndexedWitnessBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 witnesses destinations = true := PairGraphPrepared39.indexed_checked
end D1Bound5
namespace D1Bound5
open QuadInt
open PairGraphPrepared39
example :
    pairClosureBool smallPairA_39 smallPairB_39
      (10^1100) smallPairClosure_39 = true := smallPairClosure_39_checked
end D1Bound5
namespace D1Bound5.PairSelectedPrepared39
open QuadInt
open PairGraphPrepared39
example : List (PairResidueVertex 1 2) := leftCached
end D1Bound5.PairSelectedPrepared39
namespace D1Bound5.PairSelectedPrepared39
open QuadInt
open PairGraphPrepared39
example : List (ℕ × List ℕ) := leftRows
end D1Bound5.PairSelectedPrepared39
namespace D1Bound5.PairSelectedPrepared39
open QuadInt
open PairGraphPrepared39
example : List (PairResidueVertex 1 2) := rightCached
end D1Bound5.PairSelectedPrepared39
namespace D1Bound5.PairSelectedPrepared39
open QuadInt
open PairGraphPrepared39
example : List (ℕ × List ℕ) := rightRows
end D1Bound5.PairSelectedPrepared39
namespace D1Bound5.PairLightPrepared39
open QuadInt
open PairGraphPrepared39
example : sieve = smallPairSieve_1_2 := sieve_eq
end D1Bound5.PairLightPrepared39
namespace D1Bound5.PairLightPrepared39
open QuadInt
open PairGraphPrepared39
example :
    leftVertices = (pairSplitByMask smallPairLarge_39 PairGraphPrepared39.colors).1.map pairLightCoordinates := leftVertices_eq
end D1Bound5.PairLightPrepared39
namespace D1Bound5.PairLightPrepared39
open QuadInt
open PairGraphPrepared39
example :
    leftCached = PairSelectedPrepared39.leftCached.map pairLightCachedCoordinates := leftCached_eq
end D1Bound5.PairLightPrepared39
namespace D1Bound5.PairLightPrepared39
open QuadInt
open PairGraphPrepared39
example : leftRows = PairSelectedPrepared39.leftRows := leftRows_eq
end D1Bound5.PairLightPrepared39
namespace D1Bound5.PairLightPrepared39
open QuadInt
open PairGraphPrepared39
example :
    pairIndependentBool smallPairSieve_1_2 (pairSplitByMask smallPairLarge_39 PairGraphPrepared39.colors).1 = true := left_checked
end D1Bound5.PairLightPrepared39
namespace D1Bound5.PairLightPrepared39
open QuadInt
open PairGraphPrepared39
example :
    rightVertices = (pairSplitByMask smallPairLarge_39 PairGraphPrepared39.colors).2.map pairLightCoordinates := rightVertices_eq
end D1Bound5.PairLightPrepared39
namespace D1Bound5.PairLightPrepared39
open QuadInt
open PairGraphPrepared39
example :
    rightCached = PairSelectedPrepared39.rightCached.map pairLightCachedCoordinates := rightCached_eq
end D1Bound5.PairLightPrepared39
namespace D1Bound5.PairLightPrepared39
open QuadInt
open PairGraphPrepared39
example : rightRows = PairSelectedPrepared39.rightRows := rightRows_eq
end D1Bound5.PairLightPrepared39
namespace D1Bound5.PairLightPrepared39
open QuadInt
open PairGraphPrepared39
example :
    pairIndependentBool smallPairSieve_1_2 (pairSplitByMask smallPairLarge_39 PairGraphPrepared39.colors).2 = true := right_checked
end D1Bound5.PairLightPrepared39
namespace D1Bound5
open QuadInt
open PairGraphPrepared39
example :
    pairGraphTriangleFreeBool smallPairSieve_1_2 smallPairLarge_39 = true := smallPairNoTriangle_39_checked
end D1Bound5
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 0) (destinations.drop 0) = true := indexed_chunk00_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 64) (destinations.drop 64) = true := indexed_chunk01_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 128) (destinations.drop 128) = true := indexed_chunk02_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 192) (destinations.drop 192) = true := indexed_chunk03_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 256) (destinations.drop 256) = true := indexed_chunk04_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 320) (destinations.drop 320) = true := indexed_chunk05_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 384) (destinations.drop 384) = true := indexed_chunk06_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 448) (destinations.drop 448) = true := indexed_chunk07_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 512) (destinations.drop 512) = true := indexed_chunk08_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 576) (destinations.drop 576) = true := indexed_chunk09_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 640) (destinations.drop 640) = true := indexed_chunk10_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 704) (destinations.drop 704) = true := indexed_chunk11_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 768) (destinations.drop 768) = true := indexed_chunk12_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 832) (destinations.drop 832) = true := indexed_chunk13_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 19
      (witnesses.drop 896) (destinations.drop 896) = true := indexed_chunk14_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    decide (anchorRoot * anchorRoot = smallPairA_39 * smallPairB_39 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_39) = true := indexed_coverage_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairLightPrepared39

example : List PairLightCachedVertex := leftCached
end D1Bound5.PairLightPrepared39
namespace D1Bound5.PairLightAdaptivePrepared39

example : List PairLightCachedVertex := leftCached000
end D1Bound5.PairLightAdaptivePrepared39
namespace D1Bound5.PairLightAdaptivePrepared39

example : List PairLightCachedVertex := leftCached001
end D1Bound5.PairLightAdaptivePrepared39
namespace D1Bound5.PairLightAdaptivePrepared39

example : List PairLightCachedVertex := leftCached002
end D1Bound5.PairLightAdaptivePrepared39
namespace D1Bound5.PairLightAdaptivePrepared39

example : List PairLightCachedVertex := leftCached003
end D1Bound5.PairLightAdaptivePrepared39
run_cmd do
  for name in ([`D1Bound5.smallPairA_39, `D1Bound5.smallPairB_39, `D1Bound5.smallPairClosure_39, `D1Bound5.smallPairLarge_39, `D1Bound5.PairGraphPrepared39.colors, `D1Bound5.smallPairSeeds_39_checked, `D1Bound5.smallPairFilter_39_checked, `D1Bound5.smallPairLarge_39_count, `D1Bound5.PairGraphPrepared39.anchorRoot, `D1Bound5.PairGraphPrepared39.rootPairs, `D1Bound5.PairGraphPrepared39.witnesses, `D1Bound5.PairGraphPrepared39.destinations, `D1Bound5.PairGraphPrepared39.indexed_checked, `D1Bound5.smallPairClosure_39_checked, `D1Bound5.PairSelectedPrepared39.leftCached, `D1Bound5.PairSelectedPrepared39.leftRows, `D1Bound5.PairSelectedPrepared39.rightCached, `D1Bound5.PairSelectedPrepared39.rightRows, `D1Bound5.PairLightPrepared39.sieve_eq, `D1Bound5.PairLightPrepared39.leftVertices_eq, `D1Bound5.PairLightPrepared39.leftCached_eq, `D1Bound5.PairLightPrepared39.leftRows_eq, `D1Bound5.PairLightPrepared39.left_checked, `D1Bound5.PairLightPrepared39.rightVertices_eq, `D1Bound5.PairLightPrepared39.rightCached_eq, `D1Bound5.PairLightPrepared39.rightRows_eq, `D1Bound5.PairLightPrepared39.right_checked, `D1Bound5.smallPairNoTriangle_39_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk00_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk01_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk02_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk03_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk04_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk05_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk06_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk07_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk08_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk09_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk10_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk11_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk12_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk13_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk14_checked, `D1Bound5.PairGraphPrepared39.indexed_coverage_checked, `D1Bound5.PairLightPrepared39.leftCached, `D1Bound5.PairLightAdaptivePrepared39.leftCached000, `D1Bound5.PairLightAdaptivePrepared39.leftCached001, `D1Bound5.PairLightAdaptivePrepared39.leftCached002, `D1Bound5.PairLightAdaptivePrepared39.leftCached003] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
