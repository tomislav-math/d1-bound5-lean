import D1Bound5.SmallPairGraphData26
import Lean.Elab.Command
import Lean.Util.CollectAxioms

open Lean Elab Command
set_option autoImplicit false
set_option maxRecDepth 100000

run_cmd do
  let names : List Name := [
    `D1Bound5.pairIndexedWitnessesPrefixBool,
    `D1Bound5.pairIndexedWitnessesCheckedBool_eq_prefix_drop,
    `D1Bound5.pairIndexedWitnessesCheckedBool_of_prefix_drop,
    `D1Bound5.pairIndexedWitnessesPrefixBool_add,
    `D1Bound5.pairClosureIndexedWitnessBool_of_checked_parts,
    `D1Bound5.smallPairA_26,
    `D1Bound5.smallPairB_26,
    `D1Bound5.smallPairClosure_26,
    `D1Bound5.smallPairLarge_26,
    `D1Bound5.PairGraphPrepared26.colors,
    `D1Bound5.smallPairSeeds_26_checked,
    `D1Bound5.smallPairFilter_26_checked,
    `D1Bound5.smallPairLarge_26_count,
    `D1Bound5.PairGraphPrepared26.anchorRoot,
    `D1Bound5.PairGraphPrepared26.rootPairs,
    `D1Bound5.PairGraphPrepared26.witnesses,
    `D1Bound5.PairGraphPrepared26.destinations,
    `D1Bound5.PairGraphPrepared26.indexed_checked,
    `D1Bound5.smallPairClosure_26_checked,
    `D1Bound5.PairSelectedPrepared26.leftCached,
    `D1Bound5.PairSelectedPrepared26.leftRows,
    `D1Bound5.PairSelectedPrepared26.rightCached,
    `D1Bound5.PairSelectedPrepared26.rightRows,
    `D1Bound5.PairLightPrepared26.sieve_eq,
    `D1Bound5.PairLightPrepared26.leftVertices_eq,
    `D1Bound5.PairLightPrepared26.leftCached_eq,
    `D1Bound5.PairLightPrepared26.leftRows_eq,
    `D1Bound5.PairLightPrepared26.left_checked,
    `D1Bound5.PairLightPrepared26.rightVertices_eq,
    `D1Bound5.PairLightPrepared26.rightCached_eq,
    `D1Bound5.PairLightPrepared26.rightRows_eq,
    `D1Bound5.PairLightPrepared26.right_checked,
    `D1Bound5.smallPairNoTriangle_26_checked,
    `D1Bound5.PairGraphPrepared26.indexed_chunk128_00_checked,
    `D1Bound5.PairGraphPrepared26.indexed_chunk128_01_checked,
    `D1Bound5.PairGraphPrepared26.indexed_chunk128_02_checked,
    `D1Bound5.PairGraphPrepared26.indexed_chunk128_03_checked,
    `D1Bound5.PairGraphPrepared26.indexed_chunk128_04_checked,
    `D1Bound5.PairGraphPrepared26.indexed_chunk128_05_checked,
    `D1Bound5.PairGraphPrepared26.indexed_chunk128_06_checked,
    `D1Bound5.PairGraphPrepared26.indexed_chunk128_07_checked,
    `D1Bound5.PairGraphPrepared26.indexed_chunk128_08_checked,
    `D1Bound5.PairGraphPrepared26.indexed_chunk128_09_checked,
    `D1Bound5.PairGraphPrepared26.indexed_chunk128_10_checked,
    `D1Bound5.PairGraphPrepared26.indexed_tail128_checked,
    `D1Bound5.PairGraphPrepared26.indexed_coverage_checked,
    `D1Bound5.PairGraphPrepared26.indexed_chunk128_00_part0_checked,
    `D1Bound5.PairGraphPrepared26.indexed_chunk128_00_part1_checked,
    `D1Bound5.PairGraphPrepared26.indexed_chunk128_00_part2_checked,
    `D1Bound5.PairGraphPrepared26.indexed_chunk128_00_part3_checked,
    `D1Bound5.PairGraphPrepared26.indexed_chunk128_03_part0_checked,
    `D1Bound5.PairGraphPrepared26.indexed_chunk128_03_part1_checked,
    `D1Bound5.PairGraphPrepared26.indexed_chunk128_03_part2_checked,
    `D1Bound5.PairGraphPrepared26.indexed_chunk128_03_part3_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.pairIndexedWitnessesPrefixBool
#check @D1Bound5.pairIndexedWitnessesCheckedBool_eq_prefix_drop
#check @D1Bound5.pairIndexedWitnessesCheckedBool_of_prefix_drop
#check @D1Bound5.pairIndexedWitnessesPrefixBool_add
#check @D1Bound5.pairClosureIndexedWitnessBool_of_checked_parts
#check @D1Bound5.smallPairA_26
#check @D1Bound5.smallPairB_26
#check @D1Bound5.smallPairClosure_26
#check @D1Bound5.smallPairLarge_26
#check @D1Bound5.PairGraphPrepared26.colors
#check @D1Bound5.smallPairSeeds_26_checked
#check @D1Bound5.smallPairFilter_26_checked
#check @D1Bound5.smallPairLarge_26_count
#check @D1Bound5.PairGraphPrepared26.anchorRoot
#check @D1Bound5.PairGraphPrepared26.rootPairs
#check @D1Bound5.PairGraphPrepared26.witnesses
#check @D1Bound5.PairGraphPrepared26.destinations
#check @D1Bound5.PairGraphPrepared26.indexed_checked
#check @D1Bound5.smallPairClosure_26_checked
#check @D1Bound5.PairSelectedPrepared26.leftCached
#check @D1Bound5.PairSelectedPrepared26.leftRows
#check @D1Bound5.PairSelectedPrepared26.rightCached
#check @D1Bound5.PairSelectedPrepared26.rightRows
#check @D1Bound5.PairLightPrepared26.sieve_eq
#check @D1Bound5.PairLightPrepared26.leftVertices_eq
#check @D1Bound5.PairLightPrepared26.leftCached_eq
#check @D1Bound5.PairLightPrepared26.leftRows_eq
#check @D1Bound5.PairLightPrepared26.left_checked
#check @D1Bound5.PairLightPrepared26.rightVertices_eq
#check @D1Bound5.PairLightPrepared26.rightCached_eq
#check @D1Bound5.PairLightPrepared26.rightRows_eq
#check @D1Bound5.PairLightPrepared26.right_checked
#check @D1Bound5.smallPairNoTriangle_26_checked
#check @D1Bound5.PairGraphPrepared26.indexed_chunk128_00_checked
#check @D1Bound5.PairGraphPrepared26.indexed_chunk128_01_checked
#check @D1Bound5.PairGraphPrepared26.indexed_chunk128_02_checked
#check @D1Bound5.PairGraphPrepared26.indexed_chunk128_03_checked
#check @D1Bound5.PairGraphPrepared26.indexed_chunk128_04_checked
#check @D1Bound5.PairGraphPrepared26.indexed_chunk128_05_checked
#check @D1Bound5.PairGraphPrepared26.indexed_chunk128_06_checked
#check @D1Bound5.PairGraphPrepared26.indexed_chunk128_07_checked
#check @D1Bound5.PairGraphPrepared26.indexed_chunk128_08_checked
#check @D1Bound5.PairGraphPrepared26.indexed_chunk128_09_checked
#check @D1Bound5.PairGraphPrepared26.indexed_chunk128_10_checked
#check @D1Bound5.PairGraphPrepared26.indexed_tail128_checked
#check @D1Bound5.PairGraphPrepared26.indexed_coverage_checked
#check @D1Bound5.PairGraphPrepared26.indexed_chunk128_00_part0_checked
#check @D1Bound5.PairGraphPrepared26.indexed_chunk128_00_part1_checked
#check @D1Bound5.PairGraphPrepared26.indexed_chunk128_00_part2_checked
#check @D1Bound5.PairGraphPrepared26.indexed_chunk128_00_part3_checked
#check @D1Bound5.PairGraphPrepared26.indexed_chunk128_03_part0_checked
#check @D1Bound5.PairGraphPrepared26.indexed_chunk128_03_part1_checked
#check @D1Bound5.PairGraphPrepared26.indexed_chunk128_03_part2_checked
#check @D1Bound5.PairGraphPrepared26.indexed_chunk128_03_part3_checked

namespace D1Bound5
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (∀ {tau nu : ℤ} (a b r0 : QuadInt tau nu)
    (bound : ℤ) (vertices : List (QuadInt tau nu)), ℕ → List (PairRootWitness tau nu) → List (Option Nat × Option Nat) → Bool) := @D1Bound5.pairIndexedWitnessesPrefixBool
end D1Bound5

namespace D1Bound5
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (∀ {tau nu : ℤ}
    (a b r0 : QuadInt tau nu) (bound : ℤ) (vertices : List (QuadInt tau nu))
    (n : ℕ) (witnesses : List (PairRootWitness tau nu))
    (destinations : List (Option Nat × Option Nat)), pairIndexedWitnessesCheckedBool a b r0 bound vertices witnesses destinations =
      (pairIndexedWitnessesPrefixBool a b r0 bound vertices n witnesses destinations &&
        pairIndexedWitnessesCheckedBool a b r0 bound vertices
          (witnesses.drop n) (destinations.drop n))) := @D1Bound5.pairIndexedWitnessesCheckedBool_eq_prefix_drop
end D1Bound5

namespace D1Bound5
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (∀ {tau nu : ℤ}
    (a b r0 : QuadInt tau nu) (bound : ℤ) (vertices : List (QuadInt tau nu))
    (n : ℕ) (witnesses : List (PairRootWitness tau nu))
    (destinations : List (Option Nat × Option Nat))
    (hprefix : pairIndexedWitnessesPrefixBool a b r0 bound vertices n
      witnesses destinations = true)
    (htail : pairIndexedWitnessesCheckedBool a b r0 bound vertices
      (witnesses.drop n) (destinations.drop n) = true), pairIndexedWitnessesCheckedBool a b r0 bound vertices witnesses destinations = true) := @D1Bound5.pairIndexedWitnessesCheckedBool_of_prefix_drop
end D1Bound5

namespace D1Bound5
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (∀ {tau nu : ℤ}
    (a b r0 : QuadInt tau nu) (bound : ℤ) (vertices : List (QuadInt tau nu))
    (m n : ℕ) (witnesses : List (PairRootWitness tau nu))
    (destinations : List (Option Nat × Option Nat)), pairIndexedWitnessesPrefixBool a b r0 bound vertices (m + n) witnesses destinations =
      (pairIndexedWitnessesPrefixBool a b r0 bound vertices m witnesses destinations &&
        pairIndexedWitnessesPrefixBool a b r0 bound vertices n
          (witnesses.drop m) (destinations.drop m))) := @D1Bound5.pairIndexedWitnessesPrefixBool_add
end D1Bound5

namespace D1Bound5
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (∀ {tau nu : ℤ}
    (a b r0 : QuadInt tau nu) (bound : ℤ) (vertices : List (QuadInt tau nu))
    (witnesses : List (PairRootWitness tau nu))
    (destinations : List (Option Nat × Option Nat))
    (hcoverage : decide (r0 * r0 = a * b + 1 ∧
      witnesses.map PairRootWitness.vertex = vertices) = true)
    (hwitnesses : pairIndexedWitnessesCheckedBool a b r0 bound vertices
      witnesses destinations = true), pairClosureIndexedWitnessBool a b r0 bound vertices witnesses destinations = true) := @D1Bound5.pairClosureIndexedWitnessBool_of_checked_parts
end D1Bound5

namespace D1Bound5
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (QuadInt 1 1) := @D1Bound5.smallPairA_26
end D1Bound5

namespace D1Bound5
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (QuadInt 1 1) := @D1Bound5.smallPairB_26
end D1Bound5

namespace D1Bound5
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (List (QuadInt 1 1)) := @D1Bound5.smallPairClosure_26
end D1Bound5

namespace D1Bound5
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (List (QuadInt 1 1)) := @D1Bound5.smallPairLarge_26
end D1Bound5

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (ℕ) := @D1Bound5.PairGraphPrepared26.colors
end D1Bound5.PairGraphPrepared26

namespace D1Bound5
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairSeedsCoveredBool smallPairA_26 smallPairB_26
      seedRootDisk_1_1 smallPairClosure_26 = true) := @D1Bound5.smallPairSeeds_26_checked
end D1Bound5

namespace D1Bound5
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (largePairVertices smallPairA_26 smallPairB_26 smallPairClosure_26 = smallPairLarge_26) := @D1Bound5.smallPairFilter_26_checked
end D1Bound5

namespace D1Bound5
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (smallPairLarge_26.length = 1522) := @D1Bound5.smallPairLarge_26_count
end D1Bound5

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (QuadInt 1 1) := @D1Bound5.PairGraphPrepared26.anchorRoot
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (List (QuadInt 1 1 × QuadInt 1 1)) := @D1Bound5.PairGraphPrepared26.rootPairs
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (List (PairRootWitness 1 1)) := @D1Bound5.PairGraphPrepared26.witnesses
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (List (Option ℕ × Option ℕ)) := @D1Bound5.PairGraphPrepared26.destinations
end D1Bound5.PairGraphPrepared26

namespace D1Bound5
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairClosureIndexedWitnessBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 witnesses destinations = true) := @D1Bound5.PairGraphPrepared26.indexed_checked
end D1Bound5

namespace D1Bound5
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairClosureBool smallPairA_26 smallPairB_26
      (10^1100) smallPairClosure_26 = true) := @D1Bound5.smallPairClosure_26_checked
end D1Bound5

namespace D1Bound5.PairSelectedPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (List (PairResidueVertex 1 1)) := @D1Bound5.PairSelectedPrepared26.leftCached
end D1Bound5.PairSelectedPrepared26

namespace D1Bound5.PairSelectedPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (List (ℕ × List ℕ)) := @D1Bound5.PairSelectedPrepared26.leftRows
end D1Bound5.PairSelectedPrepared26

namespace D1Bound5.PairSelectedPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (List (PairResidueVertex 1 1)) := @D1Bound5.PairSelectedPrepared26.rightCached
end D1Bound5.PairSelectedPrepared26

namespace D1Bound5.PairSelectedPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (List (ℕ × List ℕ)) := @D1Bound5.PairSelectedPrepared26.rightRows
end D1Bound5.PairSelectedPrepared26

namespace D1Bound5.PairLightPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (sieve = smallPairSieve_1_1) := @D1Bound5.PairLightPrepared26.sieve_eq
end D1Bound5.PairLightPrepared26

namespace D1Bound5.PairLightPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (leftVertices = (pairSplitByMask smallPairLarge_26 PairGraphPrepared26.colors).1.map pairLightCoordinates) := @D1Bound5.PairLightPrepared26.leftVertices_eq
end D1Bound5.PairLightPrepared26

namespace D1Bound5.PairLightPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (leftCached = PairSelectedPrepared26.leftCached.map pairLightCachedCoordinates) := @D1Bound5.PairLightPrepared26.leftCached_eq
end D1Bound5.PairLightPrepared26

namespace D1Bound5.PairLightPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (leftRows = PairSelectedPrepared26.leftRows) := @D1Bound5.PairLightPrepared26.leftRows_eq
end D1Bound5.PairLightPrepared26

namespace D1Bound5.PairLightPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_26 PairGraphPrepared26.colors).1 = true) := @D1Bound5.PairLightPrepared26.left_checked
end D1Bound5.PairLightPrepared26

namespace D1Bound5.PairLightPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (rightVertices = (pairSplitByMask smallPairLarge_26 PairGraphPrepared26.colors).2.map pairLightCoordinates) := @D1Bound5.PairLightPrepared26.rightVertices_eq
end D1Bound5.PairLightPrepared26

namespace D1Bound5.PairLightPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (rightCached = PairSelectedPrepared26.rightCached.map pairLightCachedCoordinates) := @D1Bound5.PairLightPrepared26.rightCached_eq
end D1Bound5.PairLightPrepared26

namespace D1Bound5.PairLightPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (rightRows = PairSelectedPrepared26.rightRows) := @D1Bound5.PairLightPrepared26.rightRows_eq
end D1Bound5.PairLightPrepared26

namespace D1Bound5.PairLightPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndependentBool smallPairSieve_1_1 (pairSplitByMask smallPairLarge_26 PairGraphPrepared26.colors).2 = true) := @D1Bound5.PairLightPrepared26.right_checked
end D1Bound5.PairLightPrepared26

namespace D1Bound5
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairGraphTriangleFreeBool smallPairSieve_1_1 smallPairLarge_26 = true) := @D1Bound5.smallPairNoTriangle_26_checked
end D1Bound5

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 128
      (witnesses.drop 0) (destinations.drop 0) = true) := @D1Bound5.PairGraphPrepared26.indexed_chunk128_00_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 128
      (witnesses.drop 128) (destinations.drop 128) = true) := @D1Bound5.PairGraphPrepared26.indexed_chunk128_01_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 128
      (witnesses.drop 256) (destinations.drop 256) = true) := @D1Bound5.PairGraphPrepared26.indexed_chunk128_02_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 128
      (witnesses.drop 384) (destinations.drop 384) = true) := @D1Bound5.PairGraphPrepared26.indexed_chunk128_03_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 128
      (witnesses.drop 512) (destinations.drop 512) = true) := @D1Bound5.PairGraphPrepared26.indexed_chunk128_04_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 128
      (witnesses.drop 640) (destinations.drop 640) = true) := @D1Bound5.PairGraphPrepared26.indexed_chunk128_05_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 128
      (witnesses.drop 768) (destinations.drop 768) = true) := @D1Bound5.PairGraphPrepared26.indexed_chunk128_06_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 128
      (witnesses.drop 896) (destinations.drop 896) = true) := @D1Bound5.PairGraphPrepared26.indexed_chunk128_07_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 128
      (witnesses.drop 1024) (destinations.drop 1024) = true) := @D1Bound5.PairGraphPrepared26.indexed_chunk128_08_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 128
      (witnesses.drop 1152) (destinations.drop 1152) = true) := @D1Bound5.PairGraphPrepared26.indexed_chunk128_09_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 117
      (witnesses.drop 1280) (destinations.drop 1280) = true) := @D1Bound5.PairGraphPrepared26.indexed_chunk128_10_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 128
      (witnesses.drop 1397) (destinations.drop 1397) = true) := @D1Bound5.PairGraphPrepared26.indexed_tail128_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (decide (anchorRoot * anchorRoot = smallPairA_26 * smallPairB_26 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_26) = true) := @D1Bound5.PairGraphPrepared26.indexed_coverage_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 32
      (witnesses.drop 0) (destinations.drop 0) = true) := @D1Bound5.PairGraphPrepared26.indexed_chunk128_00_part0_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 32
      (witnesses.drop 32) (destinations.drop 32) = true) := @D1Bound5.PairGraphPrepared26.indexed_chunk128_00_part1_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 32
      (witnesses.drop 64) (destinations.drop 64) = true) := @D1Bound5.PairGraphPrepared26.indexed_chunk128_00_part2_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 32
      (witnesses.drop 96) (destinations.drop 96) = true) := @D1Bound5.PairGraphPrepared26.indexed_chunk128_00_part3_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 32
      (witnesses.drop 384) (destinations.drop 384) = true) := @D1Bound5.PairGraphPrepared26.indexed_chunk128_03_part0_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 32
      (witnesses.drop 416) (destinations.drop 416) = true) := @D1Bound5.PairGraphPrepared26.indexed_chunk128_03_part1_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 32
      (witnesses.drop 448) (destinations.drop 448) = true) := @D1Bound5.PairGraphPrepared26.indexed_chunk128_03_part2_checked
end D1Bound5.PairGraphPrepared26

namespace D1Bound5.PairGraphPrepared26
open D1Bound5 QuadInt D1Bound5.PairGraphPrepared26
example : (pairIndexedWitnessesPrefixBool smallPairA_26 smallPairB_26 anchorRoot
      (10^1100) smallPairClosure_26 32
      (witnesses.drop 480) (destinations.drop 480) = true) := @D1Bound5.PairGraphPrepared26.indexed_chunk128_03_part3_checked
end D1Bound5.PairGraphPrepared26

