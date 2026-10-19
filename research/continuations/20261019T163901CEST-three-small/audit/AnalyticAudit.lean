import D1Bound5.SmallTripleCheck
import D1Bound5.SmallTripleData
import D1Bound5.SmallTripleClassification
import D1Bound5.SmallTripleExtensionData4
import D1Bound5.SmallTripleExtensionData5
import D1Bound5.SmallTripleExtensionData6
import D1Bound5.SmallTripleExtensionData7
import D1Bound5.SmallTripleExtensionData8
import D1Bound5.SmallTripleExtensionData9
import D1Bound5.SmallTripleExtensions
import D1Bound5.SmallExtensionSymmetry
import D1Bound5.SmallTripleRepresentativeProperties
import D1Bound5.SmallTripleOrbitProperties
import D1Bound5.SmallTripleBoundedExtensions
import D1Bound5.ThreeSmallSextuple
import Lean.Elab.Command
import Lean.Util.CollectAxioms

open Lean Elab Command

set_option maxRecDepth 32768

run_cmd do
  let names : List Name := [
    `D1Bound5.tripleCoordinates,
    `D1Bound5.smallTripleClassifiedBool,
    `D1Bound5.smallTripleClassified_of_explicit_list,
    `D1Bound5.smallTriples_0_1,
    `D1Bound5.smallTriples_0_2,
    `D1Bound5.smallTriples_0_4,
    `D1Bound5.smallTriples_1_1,
    `D1Bound5.smallTriples_1_2,
    `D1Bound5.smallTripleOrbit,
    `D1Bound5.smallTripleRepresentatives_0_1,
    `D1Bound5.smallTripleRepresentatives_0_2,
    `D1Bound5.smallTripleRepresentatives_1_1,
    `D1Bound5.smallTripleRepresentatives_1_2,
    `D1Bound5.smallTripleTable_orbits,
    `D1Bound5.smallTripleTable,
    `D1Bound5.smallTripleTable_models,
    `D1Bound5.smallTripleTable_counts,
    `D1Bound5.smallTriples_0_1_checked,
    `D1Bound5.smallTriple_classified_0_1,
    `D1Bound5.smallTriples_0_2_checked,
    `D1Bound5.smallTriple_classified_0_2,
    `D1Bound5.smallTriples_0_3_checked,
    `D1Bound5.smallTriple_classified_0_3,
    `D1Bound5.smallTriples_0_4_checked,
    `D1Bound5.smallTriple_classified_0_4,
    `D1Bound5.smallTriples_0_5_checked,
    `D1Bound5.smallTriple_classified_0_5,
    `D1Bound5.smallTriples_0_6_checked,
    `D1Bound5.smallTriple_classified_0_6,
    `D1Bound5.smallTriples_0_7_checked,
    `D1Bound5.smallTriple_classified_0_7,
    `D1Bound5.smallTriples_0_8_checked,
    `D1Bound5.smallTriple_classified_0_8,
    `D1Bound5.smallTriples_1_1_checked,
    `D1Bound5.smallTriple_classified_1_1,
    `D1Bound5.smallTriples_1_2_checked,
    `D1Bound5.smallTriple_classified_1_2,
    `D1Bound5.smallTriples_1_3_checked,
    `D1Bound5.smallTriple_classified_1_3,
    `D1Bound5.smallTriples_1_4_checked,
    `D1Bound5.smallTriple_classified_1_4,
    `D1Bound5.smallTriples_1_5_checked,
    `D1Bound5.smallTriple_classified_1_5,
    `D1Bound5.smallTriples_1_6_checked,
    `D1Bound5.smallTriple_classified_1_6,
    `D1Bound5.smallTriples_1_7_checked,
    `D1Bound5.smallTriple_classified_1_7,
    `D1Bound5.smallTriples_1_8_checked,
    `D1Bound5.smallTriple_classified_1_8,
    `D1Bound5.smallTriple_classified_rectangular,
    `D1Bound5.noSmallTriple_of_large_discriminant,
    `D1Bound5.smallTriple_classified_normalized,
    `D1Bound5.IsD1Tuple.small_triple_classification,
    `D1Bound5.smallTripleAnchorA_4,
    `D1Bound5.smallTripleAnchorB_4,
    `D1Bound5.smallTripleAnchorC_4,
    `D1Bound5.smallTriplePairClosure_4,
    `D1Bound5.smallTripleAllowed_4,
    `D1Bound5.smallTripleSeeds_4_checked,
    `D1Bound5.smallTripleClosure_4_checked,
    `D1Bound5.smallTripleFilter_4_checked,
    `D1Bound5.smallTripleClosure_4_count,
    `D1Bound5.smallTripleAnchorA_5,
    `D1Bound5.smallTripleAnchorB_5,
    `D1Bound5.smallTripleAnchorC_5,
    `D1Bound5.smallTriplePairClosure_5,
    `D1Bound5.smallTripleAllowed_5,
    `D1Bound5.smallTripleSeeds_5_checked,
    `D1Bound5.smallTripleClosure_5_checked,
    `D1Bound5.smallTripleFilter_5_checked,
    `D1Bound5.smallTripleClosure_5_count,
    `D1Bound5.smallTripleAnchorA_6,
    `D1Bound5.smallTripleAnchorB_6,
    `D1Bound5.smallTripleAnchorC_6,
    `D1Bound5.smallTriplePairClosure_6,
    `D1Bound5.smallTripleAllowed_6,
    `D1Bound5.smallTripleSeeds_6_checked,
    `D1Bound5.smallTripleClosure_6_checked,
    `D1Bound5.smallTripleFilter_6_checked,
    `D1Bound5.smallTripleClosure_6_count,
    `D1Bound5.smallTripleAnchorA_7,
    `D1Bound5.smallTripleAnchorB_7,
    `D1Bound5.smallTripleAnchorC_7,
    `D1Bound5.smallTriplePairClosure_7,
    `D1Bound5.smallTripleAllowed_7,
    `D1Bound5.smallTripleSeeds_7_checked,
    `D1Bound5.smallTripleClosure_7_checked,
    `D1Bound5.smallTripleFilter_7_checked,
    `D1Bound5.smallTripleClosure_7_count,
    `D1Bound5.smallTripleAnchorA_8,
    `D1Bound5.smallTripleAnchorB_8,
    `D1Bound5.smallTripleAnchorC_8,
    `D1Bound5.smallTriplePairClosure_8,
    `D1Bound5.smallTripleAllowed_8,
    `D1Bound5.smallTripleSeeds_8_checked,
    `D1Bound5.smallTripleClosure_8_checked,
    `D1Bound5.smallTripleFilter_8_checked,
    `D1Bound5.smallTripleClosure_8_count,
    `D1Bound5.smallTripleAnchorA_9,
    `D1Bound5.smallTripleAnchorB_9,
    `D1Bound5.smallTripleAnchorC_9,
    `D1Bound5.smallTriplePairClosure_9,
    `D1Bound5.smallTripleAllowed_9,
    `D1Bound5.smallTripleSeeds_9_checked,
    `D1Bound5.smallTripleClosure_9_checked,
    `D1Bound5.smallTripleFilter_9_checked,
    `D1Bound5.smallTripleClosure_9_count,
    `D1Bound5.smallTripleExtension_1_complete_full_ring,
    `D1Bound5.smallTripleExtension_2_complete_full_ring,
    `D1Bound5.smallTripleExtension_3_complete_full_ring,
    `D1Bound5.smallTripleExtension_4_complete_full_ring,
    `D1Bound5.smallTripleExtension_5_complete_full_ring,
    `D1Bound5.smallTripleExtension_6_complete_full_ring,
    `D1Bound5.smallTripleExtension_7_complete_full_ring,
    `D1Bound5.smallTripleExtension_8_complete_full_ring,
    `D1Bound5.smallTripleExtension_9_complete_full_ring,
    `D1Bound5.smallTripleExtension_10_complete_full_ring,
    `D1Bound5.ProperCommonExtension,
    `D1Bound5.SmallTripleExtensionProperty,
    `D1Bound5.ProperCommonExtension.map_equiv,
    `D1Bound5.smallExtensionSymmetry,
    `D1Bound5.smallExtensionSymmetry_involutive,
    `D1Bound5.smallExtensionSymmetry_zero,
    `D1Bound5.smallExtensionSymmetry_norm,
    `D1Bound5.SmallTripleExtensionProperty.symmetry,
    `D1Bound5.smallCoordinateSet,
    `D1Bound5.smallCoordinateSet_triple,
    `D1Bound5.smallTripleExtensionProperty_of_orbit,
    `D1Bound5.smallTripleRepresentative_1_property,
    `D1Bound5.smallTripleRepresentative_2_property,
    `D1Bound5.smallTripleRepresentative_3_property,
    `D1Bound5.smallTripleRepresentative_4_property,
    `D1Bound5.smallTripleRepresentative_5_property,
    `D1Bound5.smallTripleRepresentative_6_property,
    `D1Bound5.smallTripleRepresentative_7_property,
    `D1Bound5.smallTripleRepresentative_8_property,
    `D1Bound5.smallTripleRepresentative_9_property,
    `D1Bound5.smallTripleRepresentative_10_property,
    `D1Bound5.smallTripleTable_0_1_extension_property_full_ring,
    `D1Bound5.smallTripleTable_0_2_extension_property_full_ring,
    `D1Bound5.smallTripleTable_1_1_extension_property_full_ring,
    `D1Bound5.smallTripleTable_1_2_extension_property_full_ring,
    `D1Bound5.smallTripleTable_extension_property_full_ring,
    `D1Bound5.SmallTripleExtensionProperty.full_ring,
    `D1Bound5.IsD1Tuple.small_triple_bounded_extensions,
    `D1Bound5.IsD1Tuple.properCommonExtension_first_three,
    `D1Bound5.IsD1Tuple.three_small_fifth_large]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"THREE_SMALL_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.tripleCoordinates
#check @D1Bound5.smallTripleClassifiedBool
#check @D1Bound5.smallTripleClassified_of_explicit_list
#check @D1Bound5.smallTriples_0_1
#check @D1Bound5.smallTriples_0_2
#check @D1Bound5.smallTriples_0_4
#check @D1Bound5.smallTriples_1_1
#check @D1Bound5.smallTriples_1_2
#check @D1Bound5.smallTripleOrbit
#check @D1Bound5.smallTripleRepresentatives_0_1
#check @D1Bound5.smallTripleRepresentatives_0_2
#check @D1Bound5.smallTripleRepresentatives_1_1
#check @D1Bound5.smallTripleRepresentatives_1_2
#check @D1Bound5.smallTripleTable_orbits
#check @D1Bound5.smallTripleTable
#check @D1Bound5.smallTripleTable_models
#check @D1Bound5.smallTripleTable_counts
#check @D1Bound5.smallTriples_0_1_checked
#check @D1Bound5.smallTriple_classified_0_1
#check @D1Bound5.smallTriples_0_2_checked
#check @D1Bound5.smallTriple_classified_0_2
#check @D1Bound5.smallTriples_0_3_checked
#check @D1Bound5.smallTriple_classified_0_3
#check @D1Bound5.smallTriples_0_4_checked
#check @D1Bound5.smallTriple_classified_0_4
#check @D1Bound5.smallTriples_0_5_checked
#check @D1Bound5.smallTriple_classified_0_5
#check @D1Bound5.smallTriples_0_6_checked
#check @D1Bound5.smallTriple_classified_0_6
#check @D1Bound5.smallTriples_0_7_checked
#check @D1Bound5.smallTriple_classified_0_7
#check @D1Bound5.smallTriples_0_8_checked
#check @D1Bound5.smallTriple_classified_0_8
#check @D1Bound5.smallTriples_1_1_checked
#check @D1Bound5.smallTriple_classified_1_1
#check @D1Bound5.smallTriples_1_2_checked
#check @D1Bound5.smallTriple_classified_1_2
#check @D1Bound5.smallTriples_1_3_checked
#check @D1Bound5.smallTriple_classified_1_3
#check @D1Bound5.smallTriples_1_4_checked
#check @D1Bound5.smallTriple_classified_1_4
#check @D1Bound5.smallTriples_1_5_checked
#check @D1Bound5.smallTriple_classified_1_5
#check @D1Bound5.smallTriples_1_6_checked
#check @D1Bound5.smallTriple_classified_1_6
#check @D1Bound5.smallTriples_1_7_checked
#check @D1Bound5.smallTriple_classified_1_7
#check @D1Bound5.smallTriples_1_8_checked
#check @D1Bound5.smallTriple_classified_1_8
#check @D1Bound5.smallTriple_classified_rectangular
#check @D1Bound5.noSmallTriple_of_large_discriminant
#check @D1Bound5.smallTriple_classified_normalized
#check @D1Bound5.IsD1Tuple.small_triple_classification
#check @D1Bound5.smallTripleAnchorA_4
#check @D1Bound5.smallTripleAnchorB_4
#check @D1Bound5.smallTripleAnchorC_4
#check @D1Bound5.smallTriplePairClosure_4
#check @D1Bound5.smallTripleAllowed_4
#check @D1Bound5.smallTripleSeeds_4_checked
#check @D1Bound5.smallTripleClosure_4_checked
#check @D1Bound5.smallTripleFilter_4_checked
#check @D1Bound5.smallTripleClosure_4_count
#check @D1Bound5.smallTripleAnchorA_5
#check @D1Bound5.smallTripleAnchorB_5
#check @D1Bound5.smallTripleAnchorC_5
#check @D1Bound5.smallTriplePairClosure_5
#check @D1Bound5.smallTripleAllowed_5
#check @D1Bound5.smallTripleSeeds_5_checked
#check @D1Bound5.smallTripleClosure_5_checked
#check @D1Bound5.smallTripleFilter_5_checked
#check @D1Bound5.smallTripleClosure_5_count
#check @D1Bound5.smallTripleAnchorA_6
#check @D1Bound5.smallTripleAnchorB_6
#check @D1Bound5.smallTripleAnchorC_6
#check @D1Bound5.smallTriplePairClosure_6
#check @D1Bound5.smallTripleAllowed_6
#check @D1Bound5.smallTripleSeeds_6_checked
#check @D1Bound5.smallTripleClosure_6_checked
#check @D1Bound5.smallTripleFilter_6_checked
#check @D1Bound5.smallTripleClosure_6_count
#check @D1Bound5.smallTripleAnchorA_7
#check @D1Bound5.smallTripleAnchorB_7
#check @D1Bound5.smallTripleAnchorC_7
#check @D1Bound5.smallTriplePairClosure_7
#check @D1Bound5.smallTripleAllowed_7
#check @D1Bound5.smallTripleSeeds_7_checked
#check @D1Bound5.smallTripleClosure_7_checked
#check @D1Bound5.smallTripleFilter_7_checked
#check @D1Bound5.smallTripleClosure_7_count
#check @D1Bound5.smallTripleAnchorA_8
#check @D1Bound5.smallTripleAnchorB_8
#check @D1Bound5.smallTripleAnchorC_8
#check @D1Bound5.smallTriplePairClosure_8
#check @D1Bound5.smallTripleAllowed_8
#check @D1Bound5.smallTripleSeeds_8_checked
#check @D1Bound5.smallTripleClosure_8_checked
#check @D1Bound5.smallTripleFilter_8_checked
#check @D1Bound5.smallTripleClosure_8_count
#check @D1Bound5.smallTripleAnchorA_9
#check @D1Bound5.smallTripleAnchorB_9
#check @D1Bound5.smallTripleAnchorC_9
#check @D1Bound5.smallTriplePairClosure_9
#check @D1Bound5.smallTripleAllowed_9
#check @D1Bound5.smallTripleSeeds_9_checked
#check @D1Bound5.smallTripleClosure_9_checked
#check @D1Bound5.smallTripleFilter_9_checked
#check @D1Bound5.smallTripleClosure_9_count
#check @D1Bound5.smallTripleExtension_1_complete_full_ring
#check @D1Bound5.smallTripleExtension_2_complete_full_ring
#check @D1Bound5.smallTripleExtension_3_complete_full_ring
#check @D1Bound5.smallTripleExtension_4_complete_full_ring
#check @D1Bound5.smallTripleExtension_5_complete_full_ring
#check @D1Bound5.smallTripleExtension_6_complete_full_ring
#check @D1Bound5.smallTripleExtension_7_complete_full_ring
#check @D1Bound5.smallTripleExtension_8_complete_full_ring
#check @D1Bound5.smallTripleExtension_9_complete_full_ring
#check @D1Bound5.smallTripleExtension_10_complete_full_ring
#check @D1Bound5.ProperCommonExtension
#check @D1Bound5.SmallTripleExtensionProperty
#check @D1Bound5.ProperCommonExtension.map_equiv
#check @D1Bound5.smallExtensionSymmetry
#check @D1Bound5.smallExtensionSymmetry_involutive
#check @D1Bound5.smallExtensionSymmetry_zero
#check @D1Bound5.smallExtensionSymmetry_norm
#check @D1Bound5.SmallTripleExtensionProperty.symmetry
#check @D1Bound5.smallCoordinateSet
#check @D1Bound5.smallCoordinateSet_triple
#check @D1Bound5.smallTripleExtensionProperty_of_orbit
#check @D1Bound5.smallTripleRepresentative_1_property
#check @D1Bound5.smallTripleRepresentative_2_property
#check @D1Bound5.smallTripleRepresentative_3_property
#check @D1Bound5.smallTripleRepresentative_4_property
#check @D1Bound5.smallTripleRepresentative_5_property
#check @D1Bound5.smallTripleRepresentative_6_property
#check @D1Bound5.smallTripleRepresentative_7_property
#check @D1Bound5.smallTripleRepresentative_8_property
#check @D1Bound5.smallTripleRepresentative_9_property
#check @D1Bound5.smallTripleRepresentative_10_property
#check @D1Bound5.smallTripleTable_0_1_extension_property_full_ring
#check @D1Bound5.smallTripleTable_0_2_extension_property_full_ring
#check @D1Bound5.smallTripleTable_1_1_extension_property_full_ring
#check @D1Bound5.smallTripleTable_1_2_extension_property_full_ring
#check @D1Bound5.smallTripleTable_extension_property_full_ring
#check @D1Bound5.SmallTripleExtensionProperty.full_ring
#check @D1Bound5.IsD1Tuple.small_triple_bounded_extensions
#check @D1Bound5.IsD1Tuple.properCommonExtension_first_three
#check @D1Bound5.IsD1Tuple.three_small_fifth_large

open scoped NumberField Classical
open Module
namespace D1Bound5
open QuadInt

example : ∀ {tau nu : ℤ}
    (hpos : 0 < discriminant tau nu)
    (xs : List (QuadInt tau nu)) (rows : List (Finset (ℤ × ℤ)))
    (cover : ∀ z ∈ disk tau nu 8, z ∈ xs)
    (checked : smallTripleClassifiedBool xs rows = true)
    (t : Fin 3 → QuadInt tau nu) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8),
    tripleCoordinates (t 0) (t 1) (t 2) ∈ rows := @D1Bound5.smallTripleClassified_of_explicit_list

example : smallTriples_0_1.toFinset = smallTripleRepresentatives_0_1.biUnion (smallTripleOrbit 0) ∧
    smallTriples_0_2.toFinset = smallTripleRepresentatives_0_2.biUnion (smallTripleOrbit 0) ∧
    smallTriples_1_1.toFinset = smallTripleRepresentatives_1_1.biUnion (smallTripleOrbit 1) ∧
    smallTriples_1_2.toFinset = smallTripleRepresentatives_1_2.biUnion (smallTripleOrbit 1) := @D1Bound5.smallTripleTable_orbits

example : ∀ {tau nu : ℤ} {row : Finset (ℤ × ℤ)}
    (h : row ∈ smallTripleTable tau nu),
    (tau = 0 ∧ nu = 1) ∨ (tau = 0 ∧ nu = 2) ∨ (tau = 0 ∧ nu = 4) ∨
    (tau = 1 ∧ nu = 1) ∨ (tau = 1 ∧ nu = 2) := @D1Bound5.smallTripleTable_models

example : smallTriples_0_1.length = 10 ∧ smallTriples_0_1.Nodup ∧
    smallTriples_0_2.length = 2 ∧ smallTriples_0_2.Nodup ∧
    smallTriples_1_1.length = 8 ∧ smallTriples_1_1.Nodup ∧
    smallTriples_1_2.length = 4 ∧ smallTriples_1_2.Nodup := @D1Bound5.smallTripleTable_counts

example : smallTripleClassifiedBool smallDisk_0_1 (smallTripleTable 0 1) = true := @D1Bound5.smallTriples_0_1_checked

example : ∀ (t : Fin 3 → QuadInt 0 1) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8),
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 0 1 := @D1Bound5.smallTriple_classified_0_1

example : smallTripleClassifiedBool smallDisk_0_2 (smallTripleTable 0 2) = true := @D1Bound5.smallTriples_0_2_checked

example : ∀ (t : Fin 3 → QuadInt 0 2) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8),
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 0 2 := @D1Bound5.smallTriple_classified_0_2

example : smallTripleClassifiedBool smallDisk_0_3 (smallTripleTable 0 3) = true := @D1Bound5.smallTriples_0_3_checked

example : ∀ (t : Fin 3 → QuadInt 0 3) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8),
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 0 3 := @D1Bound5.smallTriple_classified_0_3

example : smallTripleClassifiedBool smallDisk_0_4 (smallTripleTable 0 4) = true := @D1Bound5.smallTriples_0_4_checked

example : ∀ (t : Fin 3 → QuadInt 0 4) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8),
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 0 4 := @D1Bound5.smallTriple_classified_0_4

example : smallTripleClassifiedBool smallDisk_0_5 (smallTripleTable 0 5) = true := @D1Bound5.smallTriples_0_5_checked

example : ∀ (t : Fin 3 → QuadInt 0 5) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8),
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 0 5 := @D1Bound5.smallTriple_classified_0_5

example : smallTripleClassifiedBool smallDisk_0_6 (smallTripleTable 0 6) = true := @D1Bound5.smallTriples_0_6_checked

example : ∀ (t : Fin 3 → QuadInt 0 6) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8),
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 0 6 := @D1Bound5.smallTriple_classified_0_6

example : smallTripleClassifiedBool smallDisk_0_7 (smallTripleTable 0 7) = true := @D1Bound5.smallTriples_0_7_checked

example : ∀ (t : Fin 3 → QuadInt 0 7) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8),
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 0 7 := @D1Bound5.smallTriple_classified_0_7

example : smallTripleClassifiedBool smallDisk_0_8 (smallTripleTable 0 8) = true := @D1Bound5.smallTriples_0_8_checked

example : ∀ (t : Fin 3 → QuadInt 0 8) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8),
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 0 8 := @D1Bound5.smallTriple_classified_0_8

example : smallTripleClassifiedBool smallDisk_1_1 (smallTripleTable 1 1) = true := @D1Bound5.smallTriples_1_1_checked

example : ∀ (t : Fin 3 → QuadInt 1 1) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8),
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 1 1 := @D1Bound5.smallTriple_classified_1_1

example : smallTripleClassifiedBool smallDisk_1_2 (smallTripleTable 1 2) = true := @D1Bound5.smallTriples_1_2_checked

example : ∀ (t : Fin 3 → QuadInt 1 2) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8),
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 1 2 := @D1Bound5.smallTriple_classified_1_2

example : smallTripleClassifiedBool smallDisk_1_3 (smallTripleTable 1 3) = true := @D1Bound5.smallTriples_1_3_checked

example : ∀ (t : Fin 3 → QuadInt 1 3) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8),
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 1 3 := @D1Bound5.smallTriple_classified_1_3

example : smallTripleClassifiedBool smallDisk_1_4 (smallTripleTable 1 4) = true := @D1Bound5.smallTriples_1_4_checked

example : ∀ (t : Fin 3 → QuadInt 1 4) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8),
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 1 4 := @D1Bound5.smallTriple_classified_1_4

example : smallTripleClassifiedBool smallDisk_1_5 (smallTripleTable 1 5) = true := @D1Bound5.smallTriples_1_5_checked

example : ∀ (t : Fin 3 → QuadInt 1 5) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8),
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 1 5 := @D1Bound5.smallTriple_classified_1_5

example : smallTripleClassifiedBool smallDisk_1_6 (smallTripleTable 1 6) = true := @D1Bound5.smallTriples_1_6_checked

example : ∀ (t : Fin 3 → QuadInt 1 6) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8),
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 1 6 := @D1Bound5.smallTriple_classified_1_6

example : smallTripleClassifiedBool smallDisk_1_7 (smallTripleTable 1 7) = true := @D1Bound5.smallTriples_1_7_checked

example : ∀ (t : Fin 3 → QuadInt 1 7) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8),
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 1 7 := @D1Bound5.smallTriple_classified_1_7

example : smallTripleClassifiedBool smallDisk_1_8 (smallTripleTable 1 8) = true := @D1Bound5.smallTriples_1_8_checked

example : ∀ (t : Fin 3 → QuadInt 1 8) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8),
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable 1 8 := @D1Bound5.smallTriple_classified_1_8

example : ∀ {tau nu : ℤ}
    (htau : tau = 0 ∨ tau = 1) (hlo : 1 ≤ nu) (hhi : nu ≤ 8)
    (t : Fin 3 → QuadInt tau nu) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8),
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable tau nu := @D1Bound5.smallTriple_classified_rectangular

example : ∀ {tau nu : ℤ}
    (hlarge : 32 < discriminant tau nu),
    ∀ t : Fin 3 → QuadInt tau nu,
      IsD1Tuple t → (∀ i, (t i).norm ≤ 8) → False := @D1Bound5.noSmallTriple_of_large_discriminant

example : ∀ {tau nu : ℤ}
    (htau : tau = 0 ∨ tau = 1) (hpos : 0 < discriminant tau nu)
    (t : Fin 3 → QuadInt tau nu) (ht : IsD1Tuple t)
    (hnorm : ∀ i, (t i).norm ≤ 8),
    tripleCoordinates (t 0) (t 1) (t 2) ∈ smallTripleTable tau nu := @D1Bound5.smallTriple_classified_normalized

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 3 → 𝓞 K) (ht : IsD1Tuple t)
    (hsmall : ∀ i, ‖phi (t i : K)‖ < 3),
    ∃ (tau nu : ℤ) (e : QuadInt tau nu ≃+* 𝓞 K),
      ((tau = 0 ∧ nu = 1) ∨ (tau = 0 ∧ nu = 2) ∨
       (tau = 1 ∧ nu = 1) ∨ (tau = 1 ∧ nu = 2)) ∧
      tripleCoordinates (e.symm (t 0)) (e.symm (t 1)) (e.symm (t 2)) ∈
        smallTripleTable tau nu := @D1Bound5.IsD1Tuple.small_triple_classification

example : pairSeedsCoveredBool smallTripleAnchorA_4 smallTripleAnchorB_4
      seedRootDisk_0_1 smallTriplePairClosure_4 = true := @D1Bound5.smallTripleSeeds_4_checked

example : pairClosureBool smallTripleAnchorA_4 smallTripleAnchorB_4
      (10^80) smallTriplePairClosure_4 = true := @D1Bound5.smallTripleClosure_4_checked

example : tripleExtensionFilterBool smallTripleAnchorA_4 smallTripleAnchorB_4
      smallTripleAnchorC_4 smallTriplePairClosure_4 smallTripleAllowed_4 = true := @D1Bound5.smallTripleFilter_4_checked

example : smallTriplePairClosure_4.length = 105 := @D1Bound5.smallTripleClosure_4_count

example : pairSeedsCoveredBool smallTripleAnchorA_5 smallTripleAnchorB_5
      seedRootDisk_0_2 smallTriplePairClosure_5 = true := @D1Bound5.smallTripleSeeds_5_checked

example : pairClosureBool smallTripleAnchorA_5 smallTripleAnchorB_5
      (10^80) smallTriplePairClosure_5 = true := @D1Bound5.smallTripleClosure_5_checked

example : tripleExtensionFilterBool smallTripleAnchorA_5 smallTripleAnchorB_5
      smallTripleAnchorC_5 smallTriplePairClosure_5 smallTripleAllowed_5 = true := @D1Bound5.smallTripleFilter_5_checked

example : smallTriplePairClosure_5.length = 71 := @D1Bound5.smallTripleClosure_5_count

example : pairSeedsCoveredBool smallTripleAnchorA_6 smallTripleAnchorB_6
      seedRootDisk_1_1 smallTriplePairClosure_6 = true := @D1Bound5.smallTripleSeeds_6_checked

example : pairClosureBool smallTripleAnchorA_6 smallTripleAnchorB_6
      (10^80) smallTriplePairClosure_6 = true := @D1Bound5.smallTripleClosure_6_checked

example : tripleExtensionFilterBool smallTripleAnchorA_6 smallTripleAnchorB_6
      smallTripleAnchorC_6 smallTriplePairClosure_6 smallTripleAllowed_6 = true := @D1Bound5.smallTripleFilter_6_checked

example : smallTriplePairClosure_6.length = 112 := @D1Bound5.smallTripleClosure_6_count

example : pairSeedsCoveredBool smallTripleAnchorA_7 smallTripleAnchorB_7
      seedRootDisk_1_1 smallTriplePairClosure_7 = true := @D1Bound5.smallTripleSeeds_7_checked

example : pairClosureBool smallTripleAnchorA_7 smallTripleAnchorB_7
      (10^80) smallTriplePairClosure_7 = true := @D1Bound5.smallTripleClosure_7_checked

example : tripleExtensionFilterBool smallTripleAnchorA_7 smallTripleAnchorB_7
      smallTripleAnchorC_7 smallTriplePairClosure_7 smallTripleAllowed_7 = true := @D1Bound5.smallTripleFilter_7_checked

example : smallTriplePairClosure_7.length = 112 := @D1Bound5.smallTripleClosure_7_count

example : pairSeedsCoveredBool smallTripleAnchorA_8 smallTripleAnchorB_8
      seedRootDisk_1_1 smallTriplePairClosure_8 = true := @D1Bound5.smallTripleSeeds_8_checked

example : pairClosureBool smallTripleAnchorA_8 smallTripleAnchorB_8
      (10^80) smallTriplePairClosure_8 = true := @D1Bound5.smallTripleClosure_8_checked

example : tripleExtensionFilterBool smallTripleAnchorA_8 smallTripleAnchorB_8
      smallTripleAnchorC_8 smallTriplePairClosure_8 smallTripleAllowed_8 = true := @D1Bound5.smallTripleFilter_8_checked

example : smallTriplePairClosure_8.length = 57 := @D1Bound5.smallTripleClosure_8_count

example : pairSeedsCoveredBool smallTripleAnchorA_9 smallTripleAnchorB_9
      seedRootDisk_1_2 smallTriplePairClosure_9 = true := @D1Bound5.smallTripleSeeds_9_checked

example : pairClosureBool smallTripleAnchorA_9 smallTripleAnchorB_9
      (10^80) smallTriplePairClosure_9 = true := @D1Bound5.smallTripleClosure_9_checked

example : tripleExtensionFilterBool smallTripleAnchorA_9 smallTripleAnchorB_9
      smallTripleAnchorC_9 smallTriplePairClosure_9 smallTripleAllowed_9 = true := @D1Bound5.smallTripleFilter_9_checked

example : smallTriplePairClosure_9.length = 83 := @D1Bound5.smallTripleClosure_9_count

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (z : QuadInt 0 1)
    (hpair : PairExtension smallTripleAnchorA_1 smallTripleAnchorB_1 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_1*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_1)
    (hb : z ≠ smallTripleAnchorB_1) (hc : z ≠ smallTripleAnchorC_1)
    (hNz : z.norm ≤ 10^80),
    z ∈ smallTripleAllowed_1 := @D1Bound5.smallTripleExtension_1_complete_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (z : QuadInt 0 1)
    (hpair : PairExtension smallTripleAnchorA_2 smallTripleAnchorB_2 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_2*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_2)
    (hb : z ≠ smallTripleAnchorB_2) (hc : z ≠ smallTripleAnchorC_2)
    (hNz : z.norm ≤ 10^80),
    z ∈ smallTripleAllowed_2 := @D1Bound5.smallTripleExtension_2_complete_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (z : QuadInt 0 1)
    (hpair : PairExtension smallTripleAnchorA_3 smallTripleAnchorB_3 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_3*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_3)
    (hb : z ≠ smallTripleAnchorB_3) (hc : z ≠ smallTripleAnchorC_3)
    (hNz : z.norm ≤ 10^80),
    z ∈ smallTripleAllowed_3 := @D1Bound5.smallTripleExtension_3_complete_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K) (z : QuadInt 0 1)
    (hpair : PairExtension smallTripleAnchorA_4 smallTripleAnchorB_4 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_4*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_4)
    (hb : z ≠ smallTripleAnchorB_4) (hc : z ≠ smallTripleAnchorC_4)
    (hNz : z.norm ≤ 10^80),
    z ∈ smallTripleAllowed_4 := @D1Bound5.smallTripleExtension_4_complete_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K) (z : QuadInt 0 2)
    (hpair : PairExtension smallTripleAnchorA_5 smallTripleAnchorB_5 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_5*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_5)
    (hb : z ≠ smallTripleAnchorB_5) (hc : z ≠ smallTripleAnchorC_5)
    (hNz : z.norm ≤ 10^80),
    z ∈ smallTripleAllowed_5 := @D1Bound5.smallTripleExtension_5_complete_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (z : QuadInt 1 1)
    (hpair : PairExtension smallTripleAnchorA_6 smallTripleAnchorB_6 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_6*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_6)
    (hb : z ≠ smallTripleAnchorB_6) (hc : z ≠ smallTripleAnchorC_6)
    (hNz : z.norm ≤ 10^80),
    z ∈ smallTripleAllowed_6 := @D1Bound5.smallTripleExtension_6_complete_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (z : QuadInt 1 1)
    (hpair : PairExtension smallTripleAnchorA_7 smallTripleAnchorB_7 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_7*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_7)
    (hb : z ≠ smallTripleAnchorB_7) (hc : z ≠ smallTripleAnchorC_7)
    (hNz : z.norm ≤ 10^80),
    z ∈ smallTripleAllowed_7 := @D1Bound5.smallTripleExtension_7_complete_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K) (z : QuadInt 1 1)
    (hpair : PairExtension smallTripleAnchorA_8 smallTripleAnchorB_8 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_8*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_8)
    (hb : z ≠ smallTripleAnchorB_8) (hc : z ≠ smallTripleAnchorC_8)
    (hNz : z.norm ≤ 10^80),
    z ∈ smallTripleAllowed_8 := @D1Bound5.smallTripleExtension_8_complete_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (z : QuadInt 1 2)
    (hpair : PairExtension smallTripleAnchorA_9 smallTripleAnchorB_9 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_9*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_9)
    (hb : z ≠ smallTripleAnchorB_9) (hc : z ≠ smallTripleAnchorC_9)
    (hNz : z.norm ≤ 10^80),
    z ∈ smallTripleAllowed_9 := @D1Bound5.smallTripleExtension_9_complete_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K) (z : QuadInt 1 2)
    (hpair : PairExtension smallTripleAnchorA_10 smallTripleAnchorB_10 z)
    (hthird : ∃ r, r*r = smallTripleAnchorC_10*z+1)
    (hz : z ≠ 0) (ha : z ≠ smallTripleAnchorA_10)
    (hb : z ≠ smallTripleAnchorB_10) (hc : z ≠ smallTripleAnchorC_10)
    (hNz : z.norm ≤ 10^80),
    z ∈ smallTripleAllowed_10 := @D1Bound5.smallTripleExtension_10_complete_full_ring

example : ∀ {R S : Type*} [CommRing R] [CommRing S] [DecidableEq R] [DecidableEq S]
    (e : R ≃+* S) (A : Finset R) (z : R) (hz : ProperCommonExtension A z),
    ProperCommonExtension (A.image e) (e z) := @D1Bound5.ProperCommonExtension.map_equiv

example : ∀ {tau nu : ℤ} (sgn conj : Bool),
    Function.Involutive (smallExtensionSymmetry (tau := tau) (nu := nu) sgn conj) := @D1Bound5.smallExtensionSymmetry_involutive

example : ∀ {tau nu : ℤ} (sgn conj : Bool),
    smallExtensionSymmetry (tau := tau) (nu := nu) sgn conj 0 = 0 := @D1Bound5.smallExtensionSymmetry_zero

example : ∀ {tau nu : ℤ} (sgn conj : Bool)
    (z : QuadInt tau nu),
    (smallExtensionSymmetry sgn conj z).norm = z.norm := @D1Bound5.smallExtensionSymmetry_norm

example : ∀ {tau nu : ℤ}
    (A : Finset (QuadInt tau nu)) (hA : SmallTripleExtensionProperty A)
    (sgn conj : Bool),
    SmallTripleExtensionProperty (A.image (smallExtensionSymmetry sgn conj)) := @D1Bound5.SmallTripleExtensionProperty.symmetry

example : ∀ {tau nu : ℤ} (a b c : QuadInt tau nu),
    smallCoordinateSet tau nu (tripleCoordinates a b c) = {a,b,c} := @D1Bound5.smallCoordinateSet_triple

example : ∀ {tau nu : ℤ}
    (row row' : Finset (ℤ × ℤ))
    (hrow : SmallTripleExtensionProperty (smallCoordinateSet tau nu row))
    (horbit : row' ∈ smallTripleOrbit tau row),
    SmallTripleExtensionProperty (smallCoordinateSet tau nu row') := @D1Bound5.smallTripleExtensionProperty_of_orbit

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K),
    SmallTripleExtensionProperty
      {smallTripleAnchorA_1, smallTripleAnchorB_1, smallTripleAnchorC_1} := @D1Bound5.smallTripleRepresentative_1_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K),
    SmallTripleExtensionProperty
      {smallTripleAnchorA_2, smallTripleAnchorB_2, smallTripleAnchorC_2} := @D1Bound5.smallTripleRepresentative_2_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K),
    SmallTripleExtensionProperty
      {smallTripleAnchorA_3, smallTripleAnchorB_3, smallTripleAnchorC_3} := @D1Bound5.smallTripleRepresentative_3_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K),
    SmallTripleExtensionProperty
      {smallTripleAnchorA_4, smallTripleAnchorB_4, smallTripleAnchorC_4} := @D1Bound5.smallTripleRepresentative_4_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K),
    SmallTripleExtensionProperty
      {smallTripleAnchorA_5, smallTripleAnchorB_5, smallTripleAnchorC_5} := @D1Bound5.smallTripleRepresentative_5_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K),
    SmallTripleExtensionProperty
      {smallTripleAnchorA_6, smallTripleAnchorB_6, smallTripleAnchorC_6} := @D1Bound5.smallTripleRepresentative_6_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K),
    SmallTripleExtensionProperty
      {smallTripleAnchorA_7, smallTripleAnchorB_7, smallTripleAnchorC_7} := @D1Bound5.smallTripleRepresentative_7_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K),
    SmallTripleExtensionProperty
      {smallTripleAnchorA_8, smallTripleAnchorB_8, smallTripleAnchorC_8} := @D1Bound5.smallTripleRepresentative_8_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K),
    SmallTripleExtensionProperty
      {smallTripleAnchorA_9, smallTripleAnchorB_9, smallTripleAnchorC_9} := @D1Bound5.smallTripleRepresentative_9_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K),
    SmallTripleExtensionProperty
      {smallTripleAnchorA_10, smallTripleAnchorB_10, smallTripleAnchorC_10} := @D1Bound5.smallTripleRepresentative_10_property

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 1 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallTripleTable 0 1),
    SmallTripleExtensionProperty (smallCoordinateSet 0 1 row) := @D1Bound5.smallTripleTable_0_1_extension_property_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 0 2 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallTripleTable 0 2),
    SmallTripleExtensionProperty (smallCoordinateSet 0 2 row) := @D1Bound5.smallTripleTable_0_2_extension_property_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 1 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallTripleTable 1 1),
    SmallTripleExtensionProperty (smallCoordinateSet 1 1 row) := @D1Bound5.smallTripleTable_1_1_extension_property_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt 1 2 ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallTripleTable 1 2),
    SmallTripleExtensionProperty (smallCoordinateSet 1 2 row) := @D1Bound5.smallTripleTable_1_2_extension_property_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K)
    (hmodel : (tau = 0 ∧ nu = 1) ∨ (tau = 0 ∧ nu = 2) ∨
      (tau = 1 ∧ nu = 1) ∨ (tau = 1 ∧ nu = 2))
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallTripleTable tau nu),
    SmallTripleExtensionProperty (smallCoordinateSet tau nu row) := @D1Bound5.smallTripleTable_extension_property_full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K) (phi : K →+* ℂ)
    (A : Finset (QuadInt tau nu)) (hA : SmallTripleExtensionProperty A),
    (∀ z : 𝓞 K, ProperCommonExtension (A.image e) z →
      ‖phi (z : K)‖^2 ≤ (10 : ℝ)^80 → ‖phi (z : K)‖ < 85) ∧
    (∀ z w : 𝓞 K, ProperCommonExtension (A.image e) z →
      ProperCommonExtension (A.image e) w →
      ‖phi (z : K)‖^2 ≤ (10 : ℝ)^80 →
      ‖phi (w : K)‖^2 ≤ (10 : ℝ)^80 → z = w) := @D1Bound5.SmallTripleExtensionProperty.full_ring

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 3 → 𝓞 K) (ht : IsD1Tuple t)
    (hsmall : ∀ i, ‖phi (t i : K)‖ < 3),
    (∀ z : 𝓞 K, ProperCommonExtension {t 0,t 1,t 2} z →
      ‖phi (z : K)‖^2 ≤ (10 : ℝ)^80 → ‖phi (z : K)‖ < 85) ∧
    (∀ z w : 𝓞 K, ProperCommonExtension {t 0,t 1,t 2} z →
      ProperCommonExtension {t 0,t 1,t 2} w →
      ‖phi (z : K)‖^2 ≤ (10 : ℝ)^80 →
      ‖phi (w : K)‖^2 ≤ (10 : ℝ)^80 → z = w) := @D1Bound5.IsD1Tuple.small_triple_bounded_extensions

example : ∀ {R : Type*} [CommRing R] [DecidableEq R]
    (t : Fin 6 → R) (ht : IsD1Tuple t) (j : Fin 6) (hj : 3 ≤ j),
    ProperCommonExtension {t 0,t 1,t 2} (t j) := @D1Bound5.IsD1Tuple.properCommonExtension_first_three

example : ∀ {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 6 → 𝓞 K) (ht : IsD1Tuple t)
    (hmon : Monotone (fun i => ‖phi (t i : K)‖))
    (hsmall : ‖phi (t 2 : K)‖ < 3),
    (10 : ℝ)^40 < ‖phi (t 4 : K)‖ ∧
      (‖phi (t 3 : K)‖ < 85 ∨ (10 : ℝ)^40 < ‖phi (t 3 : K)‖) := @D1Bound5.IsD1Tuple.three_small_fifth_large

end D1Bound5
