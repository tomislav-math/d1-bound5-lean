import D1Bound5.SmallPairClassificationData
import D1Bound5.FirstPairData
import D1Bound5.OneSmallDisks
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 32768
run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.smallPairs_0_1,
    `D1Bound5.smallPairs_0_2,
    `D1Bound5.smallPairs_0_3,
    `D1Bound5.smallPairs_0_4,
    `D1Bound5.smallPairs_0_5,
    `D1Bound5.smallPairs_0_6,
    `D1Bound5.smallPairs_0_7,
    `D1Bound5.smallPairs_0_8,
    `D1Bound5.smallPairs_1_1,
    `D1Bound5.smallPairs_1_2,
    `D1Bound5.smallPairs_1_3,
    `D1Bound5.smallPairs_1_4,
    `D1Bound5.smallPairs_1_5,
    `D1Bound5.smallPairs_1_6,
    `D1Bound5.smallPairs_1_7,
    `D1Bound5.smallPairs_1_8,
    `D1Bound5.smallPairTable,
    `D1Bound5.smallPairRepresentatives_0_1,
    `D1Bound5.smallPairTable_0_1_orbits,
    `D1Bound5.smallPairRepresentatives_0_2,
    `D1Bound5.smallPairTable_0_2_orbits,
    `D1Bound5.smallPairRepresentatives_1_1,
    `D1Bound5.smallPairTable_1_1_orbits,
    `D1Bound5.smallPairRepresentatives_0_5,
    `D1Bound5.smallPairTable_0_5_orbits,
    `D1Bound5.smallPairRepresentatives_0_6,
    `D1Bound5.smallPairTable_0_6_orbits,
    `D1Bound5.smallPairRepresentatives_1_2,
    `D1Bound5.smallPairTable_1_2_orbits,
    `D1Bound5.smallPairRepresentatives_1_3,
    `D1Bound5.smallPairTable_1_3_orbits,
    `D1Bound5.smallPairRepresentatives_1_4,
    `D1Bound5.smallPairTable_1_4_orbits,
    `D1Bound5.smallPairRepresentatives_1_5,
    `D1Bound5.smallPairTable_1_5_orbits,
    `D1Bound5.smallPairRepresentatives_1_6,
    `D1Bound5.smallPairTable_1_6_orbits,
    `D1Bound5.smallPairRepresentatives_1_8,
    `D1Bound5.smallPairTable_1_8_orbits,
    `D1Bound5.smallPairs_0_1_checked,
    `D1Bound5.smallPair_classified_0_1,
    `D1Bound5.smallPairs_0_2_checked,
    `D1Bound5.smallPair_classified_0_2,
    `D1Bound5.smallPairs_0_3_checked,
    `D1Bound5.smallPair_classified_0_3,
    `D1Bound5.smallPairs_0_4_checked,
    `D1Bound5.smallPair_classified_0_4,
    `D1Bound5.smallPairs_0_5_checked,
    `D1Bound5.smallPair_classified_0_5,
    `D1Bound5.smallPairs_0_6_checked,
    `D1Bound5.smallPair_classified_0_6,
    `D1Bound5.smallPairs_0_7_checked,
    `D1Bound5.smallPair_classified_0_7,
    `D1Bound5.smallPairs_0_8_checked,
    `D1Bound5.smallPair_classified_0_8,
    `D1Bound5.smallPairs_1_1_checked,
    `D1Bound5.smallPair_classified_1_1,
    `D1Bound5.smallPairs_1_2_checked,
    `D1Bound5.smallPair_classified_1_2,
    `D1Bound5.smallPairs_1_3_checked,
    `D1Bound5.smallPair_classified_1_3,
    `D1Bound5.smallPairs_1_4_checked,
    `D1Bound5.smallPair_classified_1_4,
    `D1Bound5.smallPairs_1_5_checked,
    `D1Bound5.smallPair_classified_1_5,
    `D1Bound5.smallPairs_1_6_checked,
    `D1Bound5.smallPair_classified_1_6,
    `D1Bound5.smallPairs_1_7_checked,
    `D1Bound5.smallPair_classified_1_7,
    `D1Bound5.smallPairs_1_8_checked,
    `D1Bound5.smallPair_classified_1_8,
    `D1Bound5.smallPair_classified_rectangular,
    `D1Bound5.firstPairOrbit,
    `D1Bound5.firstPairs_0_1,
    `D1Bound5.firstPairs_0_2,
    `D1Bound5.firstPairs_0_3,
    `D1Bound5.firstPairs_0_4,
    `D1Bound5.firstPairs_0_5,
    `D1Bound5.firstPairs_0_6,
    `D1Bound5.firstPairs_0_7,
    `D1Bound5.firstPairs_0_8,
    `D1Bound5.firstPairs_1_1,
    `D1Bound5.firstPairs_1_2,
    `D1Bound5.firstPairs_1_3,
    `D1Bound5.firstPairs_1_4,
    `D1Bound5.firstPairs_1_5,
    `D1Bound5.firstPairs_1_6,
    `D1Bound5.firstPairs_1_7,
    `D1Bound5.firstPairs_1_8,
    `D1Bound5.firstPairTable,
    `D1Bound5.firstPairRepresentatives_0_1,
    `D1Bound5.firstPairTable_0_1_orbits,
    `D1Bound5.firstPairRepresentatives_0_2,
    `D1Bound5.firstPairTable_0_2_orbits,
    `D1Bound5.firstPairRepresentatives_0_5,
    `D1Bound5.firstPairTable_0_5_orbits,
    `D1Bound5.firstPairRepresentatives_0_6,
    `D1Bound5.firstPairTable_0_6_orbits,
    `D1Bound5.firstPairRepresentatives_1_1,
    `D1Bound5.firstPairTable_1_1_orbits,
    `D1Bound5.firstPairRepresentatives_1_2,
    `D1Bound5.firstPairTable_1_2_orbits,
    `D1Bound5.firstPairRepresentatives_1_3,
    `D1Bound5.firstPairTable_1_3_orbits,
    `D1Bound5.firstPairRepresentatives_1_4,
    `D1Bound5.firstPairTable_1_4_orbits,
    `D1Bound5.firstPairRepresentatives_1_5,
    `D1Bound5.firstPairTable_1_5_orbits,
    `D1Bound5.firstPairRepresentatives_1_6,
    `D1Bound5.firstPairTable_1_6_orbits,
    `D1Bound5.firstPair_0_1_checked,
    `D1Bound5.firstPair_classified_0_1,
    `D1Bound5.firstPair_0_2_checked,
    `D1Bound5.firstPair_classified_0_2,
    `D1Bound5.firstPair_0_3_checked,
    `D1Bound5.firstPair_classified_0_3,
    `D1Bound5.firstPair_0_4_checked,
    `D1Bound5.firstPair_classified_0_4,
    `D1Bound5.firstPair_0_5_checked,
    `D1Bound5.firstPair_classified_0_5,
    `D1Bound5.firstPair_0_6_checked,
    `D1Bound5.firstPair_classified_0_6,
    `D1Bound5.firstPair_0_7_checked,
    `D1Bound5.firstPair_classified_0_7,
    `D1Bound5.firstPair_0_8_checked,
    `D1Bound5.firstPair_classified_0_8,
    `D1Bound5.firstPair_1_1_checked,
    `D1Bound5.firstPair_classified_1_1,
    `D1Bound5.firstPair_1_2_checked,
    `D1Bound5.firstPair_classified_1_2,
    `D1Bound5.firstPair_1_3_checked,
    `D1Bound5.firstPair_classified_1_3,
    `D1Bound5.firstPair_1_4_checked,
    `D1Bound5.firstPair_classified_1_4,
    `D1Bound5.firstPair_1_5_checked,
    `D1Bound5.firstPair_classified_1_5,
    `D1Bound5.firstPair_1_6_checked,
    `D1Bound5.firstPair_classified_1_6,
    `D1Bound5.firstPair_1_7_checked,
    `D1Bound5.firstPair_classified_1_7,
    `D1Bound5.firstPair_1_8_checked,
    `D1Bound5.firstPair_classified_1_8,
    `D1Bound5.firstPair_classified_rectangular,
    `D1Bound5.oneSmallDisk_224_0_1,
    `D1Bound5.oneSmallDisk_224_0_1_eq,
    `D1Bound5.oneSmallDisk_300_0_1,
    `D1Bound5.oneSmallDisk_300_0_1_eq,
    `D1Bound5.oneSmallDisk_224_0_2,
    `D1Bound5.oneSmallDisk_224_0_2_eq,
    `D1Bound5.oneSmallDisk_300_0_2,
    `D1Bound5.oneSmallDisk_300_0_2_eq,
    `D1Bound5.oneSmallDisk_224_0_5,
    `D1Bound5.oneSmallDisk_224_0_5_eq,
    `D1Bound5.oneSmallDisk_300_0_5,
    `D1Bound5.oneSmallDisk_300_0_5_eq,
    `D1Bound5.oneSmallDisk_224_0_6,
    `D1Bound5.oneSmallDisk_224_0_6_eq,
    `D1Bound5.oneSmallDisk_300_0_6,
    `D1Bound5.oneSmallDisk_300_0_6_eq,
    `D1Bound5.oneSmallDisk_224_1_1,
    `D1Bound5.oneSmallDisk_224_1_1_eq,
    `D1Bound5.oneSmallDisk_300_1_1,
    `D1Bound5.oneSmallDisk_300_1_1_eq,
    `D1Bound5.oneSmallDisk_224_1_2,
    `D1Bound5.oneSmallDisk_224_1_2_eq,
    `D1Bound5.oneSmallDisk_300_1_2,
    `D1Bound5.oneSmallDisk_300_1_2_eq,
    `D1Bound5.oneSmallDisk_224_1_3,
    `D1Bound5.oneSmallDisk_224_1_3_eq,
    `D1Bound5.oneSmallDisk_300_1_3,
    `D1Bound5.oneSmallDisk_300_1_3_eq,
    `D1Bound5.oneSmallDisk_224_1_4,
    `D1Bound5.oneSmallDisk_224_1_4_eq,
    `D1Bound5.oneSmallDisk_300_1_4,
    `D1Bound5.oneSmallDisk_300_1_4_eq,
    `D1Bound5.oneSmallDisk_224_1_5,
    `D1Bound5.oneSmallDisk_224_1_5_eq,
    `D1Bound5.oneSmallDisk_300_1_5,
    `D1Bound5.oneSmallDisk_300_1_5_eq,
    `D1Bound5.oneSmallDisk_224_1_6,
    `D1Bound5.oneSmallDisk_224_1_6_eq,
    `D1Bound5.oneSmallDisk_300_1_6,
    `D1Bound5.oneSmallDisk_300_1_6_eq]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"
#check @_root_.D1Bound5.smallPairs_0_1
#check @_root_.D1Bound5.smallPairs_0_2
#check @_root_.D1Bound5.smallPairs_0_3
#check @_root_.D1Bound5.smallPairs_0_4
#check @_root_.D1Bound5.smallPairs_0_5
#check @_root_.D1Bound5.smallPairs_0_6
#check @_root_.D1Bound5.smallPairs_0_7
#check @_root_.D1Bound5.smallPairs_0_8
#check @_root_.D1Bound5.smallPairs_1_1
#check @_root_.D1Bound5.smallPairs_1_2
#check @_root_.D1Bound5.smallPairs_1_3
#check @_root_.D1Bound5.smallPairs_1_4
#check @_root_.D1Bound5.smallPairs_1_5
#check @_root_.D1Bound5.smallPairs_1_6
#check @_root_.D1Bound5.smallPairs_1_7
#check @_root_.D1Bound5.smallPairs_1_8
#check @_root_.D1Bound5.smallPairTable
#check @_root_.D1Bound5.smallPairRepresentatives_0_1
#check @_root_.D1Bound5.smallPairTable_0_1_orbits
#check @_root_.D1Bound5.smallPairRepresentatives_0_2
#check @_root_.D1Bound5.smallPairTable_0_2_orbits
#check @_root_.D1Bound5.smallPairRepresentatives_1_1
#check @_root_.D1Bound5.smallPairTable_1_1_orbits
#check @_root_.D1Bound5.smallPairRepresentatives_0_5
#check @_root_.D1Bound5.smallPairTable_0_5_orbits
#check @_root_.D1Bound5.smallPairRepresentatives_0_6
#check @_root_.D1Bound5.smallPairTable_0_6_orbits
#check @_root_.D1Bound5.smallPairRepresentatives_1_2
#check @_root_.D1Bound5.smallPairTable_1_2_orbits
#check @_root_.D1Bound5.smallPairRepresentatives_1_3
#check @_root_.D1Bound5.smallPairTable_1_3_orbits
#check @_root_.D1Bound5.smallPairRepresentatives_1_4
#check @_root_.D1Bound5.smallPairTable_1_4_orbits
#check @_root_.D1Bound5.smallPairRepresentatives_1_5
#check @_root_.D1Bound5.smallPairTable_1_5_orbits
#check @_root_.D1Bound5.smallPairRepresentatives_1_6
#check @_root_.D1Bound5.smallPairTable_1_6_orbits
#check @_root_.D1Bound5.smallPairRepresentatives_1_8
#check @_root_.D1Bound5.smallPairTable_1_8_orbits
#check @_root_.D1Bound5.smallPairs_0_1_checked
#check @_root_.D1Bound5.smallPair_classified_0_1
#check @_root_.D1Bound5.smallPairs_0_2_checked
#check @_root_.D1Bound5.smallPair_classified_0_2
#check @_root_.D1Bound5.smallPairs_0_3_checked
#check @_root_.D1Bound5.smallPair_classified_0_3
#check @_root_.D1Bound5.smallPairs_0_4_checked
#check @_root_.D1Bound5.smallPair_classified_0_4
#check @_root_.D1Bound5.smallPairs_0_5_checked
#check @_root_.D1Bound5.smallPair_classified_0_5
#check @_root_.D1Bound5.smallPairs_0_6_checked
#check @_root_.D1Bound5.smallPair_classified_0_6
#check @_root_.D1Bound5.smallPairs_0_7_checked
#check @_root_.D1Bound5.smallPair_classified_0_7
#check @_root_.D1Bound5.smallPairs_0_8_checked
#check @_root_.D1Bound5.smallPair_classified_0_8
#check @_root_.D1Bound5.smallPairs_1_1_checked
#check @_root_.D1Bound5.smallPair_classified_1_1
#check @_root_.D1Bound5.smallPairs_1_2_checked
#check @_root_.D1Bound5.smallPair_classified_1_2
#check @_root_.D1Bound5.smallPairs_1_3_checked
#check @_root_.D1Bound5.smallPair_classified_1_3
#check @_root_.D1Bound5.smallPairs_1_4_checked
#check @_root_.D1Bound5.smallPair_classified_1_4
#check @_root_.D1Bound5.smallPairs_1_5_checked
#check @_root_.D1Bound5.smallPair_classified_1_5
#check @_root_.D1Bound5.smallPairs_1_6_checked
#check @_root_.D1Bound5.smallPair_classified_1_6
#check @_root_.D1Bound5.smallPairs_1_7_checked
#check @_root_.D1Bound5.smallPair_classified_1_7
#check @_root_.D1Bound5.smallPairs_1_8_checked
#check @_root_.D1Bound5.smallPair_classified_1_8
#check @_root_.D1Bound5.smallPair_classified_rectangular
#check @_root_.D1Bound5.firstPairOrbit
#check @_root_.D1Bound5.firstPairs_0_1
#check @_root_.D1Bound5.firstPairs_0_2
#check @_root_.D1Bound5.firstPairs_0_3
#check @_root_.D1Bound5.firstPairs_0_4
#check @_root_.D1Bound5.firstPairs_0_5
#check @_root_.D1Bound5.firstPairs_0_6
#check @_root_.D1Bound5.firstPairs_0_7
#check @_root_.D1Bound5.firstPairs_0_8
#check @_root_.D1Bound5.firstPairs_1_1
#check @_root_.D1Bound5.firstPairs_1_2
#check @_root_.D1Bound5.firstPairs_1_3
#check @_root_.D1Bound5.firstPairs_1_4
#check @_root_.D1Bound5.firstPairs_1_5
#check @_root_.D1Bound5.firstPairs_1_6
#check @_root_.D1Bound5.firstPairs_1_7
#check @_root_.D1Bound5.firstPairs_1_8
#check @_root_.D1Bound5.firstPairTable
#check @_root_.D1Bound5.firstPairRepresentatives_0_1
#check @_root_.D1Bound5.firstPairTable_0_1_orbits
#check @_root_.D1Bound5.firstPairRepresentatives_0_2
#check @_root_.D1Bound5.firstPairTable_0_2_orbits
#check @_root_.D1Bound5.firstPairRepresentatives_0_5
#check @_root_.D1Bound5.firstPairTable_0_5_orbits
#check @_root_.D1Bound5.firstPairRepresentatives_0_6
#check @_root_.D1Bound5.firstPairTable_0_6_orbits
#check @_root_.D1Bound5.firstPairRepresentatives_1_1
#check @_root_.D1Bound5.firstPairTable_1_1_orbits
#check @_root_.D1Bound5.firstPairRepresentatives_1_2
#check @_root_.D1Bound5.firstPairTable_1_2_orbits
#check @_root_.D1Bound5.firstPairRepresentatives_1_3
#check @_root_.D1Bound5.firstPairTable_1_3_orbits
#check @_root_.D1Bound5.firstPairRepresentatives_1_4
#check @_root_.D1Bound5.firstPairTable_1_4_orbits
#check @_root_.D1Bound5.firstPairRepresentatives_1_5
#check @_root_.D1Bound5.firstPairTable_1_5_orbits
#check @_root_.D1Bound5.firstPairRepresentatives_1_6
#check @_root_.D1Bound5.firstPairTable_1_6_orbits
#check @_root_.D1Bound5.firstPair_0_1_checked
#check @_root_.D1Bound5.firstPair_classified_0_1
#check @_root_.D1Bound5.firstPair_0_2_checked
#check @_root_.D1Bound5.firstPair_classified_0_2
#check @_root_.D1Bound5.firstPair_0_3_checked
#check @_root_.D1Bound5.firstPair_classified_0_3
#check @_root_.D1Bound5.firstPair_0_4_checked
#check @_root_.D1Bound5.firstPair_classified_0_4
#check @_root_.D1Bound5.firstPair_0_5_checked
#check @_root_.D1Bound5.firstPair_classified_0_5
#check @_root_.D1Bound5.firstPair_0_6_checked
#check @_root_.D1Bound5.firstPair_classified_0_6
#check @_root_.D1Bound5.firstPair_0_7_checked
#check @_root_.D1Bound5.firstPair_classified_0_7
#check @_root_.D1Bound5.firstPair_0_8_checked
#check @_root_.D1Bound5.firstPair_classified_0_8
#check @_root_.D1Bound5.firstPair_1_1_checked
#check @_root_.D1Bound5.firstPair_classified_1_1
#check @_root_.D1Bound5.firstPair_1_2_checked
#check @_root_.D1Bound5.firstPair_classified_1_2
#check @_root_.D1Bound5.firstPair_1_3_checked
#check @_root_.D1Bound5.firstPair_classified_1_3
#check @_root_.D1Bound5.firstPair_1_4_checked
#check @_root_.D1Bound5.firstPair_classified_1_4
#check @_root_.D1Bound5.firstPair_1_5_checked
#check @_root_.D1Bound5.firstPair_classified_1_5
#check @_root_.D1Bound5.firstPair_1_6_checked
#check @_root_.D1Bound5.firstPair_classified_1_6
#check @_root_.D1Bound5.firstPair_1_7_checked
#check @_root_.D1Bound5.firstPair_classified_1_7
#check @_root_.D1Bound5.firstPair_1_8_checked
#check @_root_.D1Bound5.firstPair_classified_1_8
#check @_root_.D1Bound5.firstPair_classified_rectangular
#check @_root_.D1Bound5.oneSmallDisk_224_0_1
#check @_root_.D1Bound5.oneSmallDisk_224_0_1_eq
#check @_root_.D1Bound5.oneSmallDisk_300_0_1
#check @_root_.D1Bound5.oneSmallDisk_300_0_1_eq
#check @_root_.D1Bound5.oneSmallDisk_224_0_2
#check @_root_.D1Bound5.oneSmallDisk_224_0_2_eq
#check @_root_.D1Bound5.oneSmallDisk_300_0_2
#check @_root_.D1Bound5.oneSmallDisk_300_0_2_eq
#check @_root_.D1Bound5.oneSmallDisk_224_0_5
#check @_root_.D1Bound5.oneSmallDisk_224_0_5_eq
#check @_root_.D1Bound5.oneSmallDisk_300_0_5
#check @_root_.D1Bound5.oneSmallDisk_300_0_5_eq
#check @_root_.D1Bound5.oneSmallDisk_224_0_6
#check @_root_.D1Bound5.oneSmallDisk_224_0_6_eq
#check @_root_.D1Bound5.oneSmallDisk_300_0_6
#check @_root_.D1Bound5.oneSmallDisk_300_0_6_eq
#check @_root_.D1Bound5.oneSmallDisk_224_1_1
#check @_root_.D1Bound5.oneSmallDisk_224_1_1_eq
#check @_root_.D1Bound5.oneSmallDisk_300_1_1
#check @_root_.D1Bound5.oneSmallDisk_300_1_1_eq
#check @_root_.D1Bound5.oneSmallDisk_224_1_2
#check @_root_.D1Bound5.oneSmallDisk_224_1_2_eq
#check @_root_.D1Bound5.oneSmallDisk_300_1_2
#check @_root_.D1Bound5.oneSmallDisk_300_1_2_eq
#check @_root_.D1Bound5.oneSmallDisk_224_1_3
#check @_root_.D1Bound5.oneSmallDisk_224_1_3_eq
#check @_root_.D1Bound5.oneSmallDisk_300_1_3
#check @_root_.D1Bound5.oneSmallDisk_300_1_3_eq
#check @_root_.D1Bound5.oneSmallDisk_224_1_4
#check @_root_.D1Bound5.oneSmallDisk_224_1_4_eq
#check @_root_.D1Bound5.oneSmallDisk_300_1_4
#check @_root_.D1Bound5.oneSmallDisk_300_1_4_eq
#check @_root_.D1Bound5.oneSmallDisk_224_1_5
#check @_root_.D1Bound5.oneSmallDisk_224_1_5_eq
#check @_root_.D1Bound5.oneSmallDisk_300_1_5
#check @_root_.D1Bound5.oneSmallDisk_300_1_5_eq
#check @_root_.D1Bound5.oneSmallDisk_224_1_6
#check @_root_.D1Bound5.oneSmallDisk_224_1_6_eq
#check @_root_.D1Bound5.oneSmallDisk_300_1_6
#check @_root_.D1Bound5.oneSmallDisk_300_1_6_eq

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairs_0_1.toFinset = smallPairRepresentatives_0_1.biUnion (smallTripleOrbit 0) := by
  exact _root_.D1Bound5.smallPairTable_0_1_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairs_0_2.toFinset = smallPairRepresentatives_0_2.biUnion (smallTripleOrbit 0) := by
  exact _root_.D1Bound5.smallPairTable_0_2_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairs_1_1.toFinset = smallPairRepresentatives_1_1.biUnion (smallTripleOrbit 1) := by
  exact _root_.D1Bound5.smallPairTable_1_1_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairs_0_5.toFinset = smallPairRepresentatives_0_5.biUnion (smallTripleOrbit 0) := by
  exact _root_.D1Bound5.smallPairTable_0_5_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairs_0_6.toFinset = smallPairRepresentatives_0_6.biUnion (smallTripleOrbit 0) := by
  exact _root_.D1Bound5.smallPairTable_0_6_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairs_1_2.toFinset = smallPairRepresentatives_1_2.biUnion (smallTripleOrbit 1) := by
  exact _root_.D1Bound5.smallPairTable_1_2_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairs_1_3.toFinset = smallPairRepresentatives_1_3.biUnion (smallTripleOrbit 1) := by
  exact _root_.D1Bound5.smallPairTable_1_3_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairs_1_4.toFinset = smallPairRepresentatives_1_4.biUnion (smallTripleOrbit 1) := by
  exact _root_.D1Bound5.smallPairTable_1_4_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairs_1_5.toFinset = smallPairRepresentatives_1_5.biUnion (smallTripleOrbit 1) := by
  exact _root_.D1Bound5.smallPairTable_1_5_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairs_1_6.toFinset = smallPairRepresentatives_1_6.biUnion (smallTripleOrbit 1) := by
  exact _root_.D1Bound5.smallPairTable_1_6_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairs_1_8.toFinset = smallPairRepresentatives_1_8.biUnion (smallTripleOrbit 1) := by
  exact _root_.D1Bound5.smallPairTable_1_8_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairClassifiedBool smallDisk_0_1 (smallPairTable 0 1) = true := by
  exact _root_.D1Bound5.smallPairs_0_1_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 0 1) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 0 1 := by
  exact _root_.D1Bound5.smallPair_classified_0_1 (a := a) (b := b) (ha := ha) (hb := hb) (hab := hab) (hroot := hroot) (hnondeg := hnondeg) (hNa := hNa) (hNb := hNb)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairClassifiedBool smallDisk_0_2 (smallPairTable 0 2) = true := by
  exact _root_.D1Bound5.smallPairs_0_2_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 0 2) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 0 2 := by
  exact _root_.D1Bound5.smallPair_classified_0_2 (a := a) (b := b) (ha := ha) (hb := hb) (hab := hab) (hroot := hroot) (hnondeg := hnondeg) (hNa := hNa) (hNb := hNb)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairClassifiedBool smallDisk_0_3 (smallPairTable 0 3) = true := by
  exact _root_.D1Bound5.smallPairs_0_3_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 0 3) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 0 3 := by
  exact _root_.D1Bound5.smallPair_classified_0_3 (a := a) (b := b) (ha := ha) (hb := hb) (hab := hab) (hroot := hroot) (hnondeg := hnondeg) (hNa := hNa) (hNb := hNb)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairClassifiedBool smallDisk_0_4 (smallPairTable 0 4) = true := by
  exact _root_.D1Bound5.smallPairs_0_4_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 0 4) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 0 4 := by
  exact _root_.D1Bound5.smallPair_classified_0_4 (a := a) (b := b) (ha := ha) (hb := hb) (hab := hab) (hroot := hroot) (hnondeg := hnondeg) (hNa := hNa) (hNb := hNb)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairClassifiedBool smallDisk_0_5 (smallPairTable 0 5) = true := by
  exact _root_.D1Bound5.smallPairs_0_5_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 0 5) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 0 5 := by
  exact _root_.D1Bound5.smallPair_classified_0_5 (a := a) (b := b) (ha := ha) (hb := hb) (hab := hab) (hroot := hroot) (hnondeg := hnondeg) (hNa := hNa) (hNb := hNb)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairClassifiedBool smallDisk_0_6 (smallPairTable 0 6) = true := by
  exact _root_.D1Bound5.smallPairs_0_6_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 0 6) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 0 6 := by
  exact _root_.D1Bound5.smallPair_classified_0_6 (a := a) (b := b) (ha := ha) (hb := hb) (hab := hab) (hroot := hroot) (hnondeg := hnondeg) (hNa := hNa) (hNb := hNb)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairClassifiedBool smallDisk_0_7 (smallPairTable 0 7) = true := by
  exact _root_.D1Bound5.smallPairs_0_7_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 0 7) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 0 7 := by
  exact _root_.D1Bound5.smallPair_classified_0_7 (a := a) (b := b) (ha := ha) (hb := hb) (hab := hab) (hroot := hroot) (hnondeg := hnondeg) (hNa := hNa) (hNb := hNb)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairClassifiedBool smallDisk_0_8 (smallPairTable 0 8) = true := by
  exact _root_.D1Bound5.smallPairs_0_8_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 0 8) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 0 8 := by
  exact _root_.D1Bound5.smallPair_classified_0_8 (a := a) (b := b) (ha := ha) (hb := hb) (hab := hab) (hroot := hroot) (hnondeg := hnondeg) (hNa := hNa) (hNb := hNb)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairClassifiedBool smallDisk_1_1 (smallPairTable 1 1) = true := by
  exact _root_.D1Bound5.smallPairs_1_1_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 1 1) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 1 1 := by
  exact _root_.D1Bound5.smallPair_classified_1_1 (a := a) (b := b) (ha := ha) (hb := hb) (hab := hab) (hroot := hroot) (hnondeg := hnondeg) (hNa := hNa) (hNb := hNb)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairClassifiedBool smallDisk_1_2 (smallPairTable 1 2) = true := by
  exact _root_.D1Bound5.smallPairs_1_2_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 1 2) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 1 2 := by
  exact _root_.D1Bound5.smallPair_classified_1_2 (a := a) (b := b) (ha := ha) (hb := hb) (hab := hab) (hroot := hroot) (hnondeg := hnondeg) (hNa := hNa) (hNb := hNb)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairClassifiedBool smallDisk_1_3 (smallPairTable 1 3) = true := by
  exact _root_.D1Bound5.smallPairs_1_3_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 1 3) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 1 3 := by
  exact _root_.D1Bound5.smallPair_classified_1_3 (a := a) (b := b) (ha := ha) (hb := hb) (hab := hab) (hroot := hroot) (hnondeg := hnondeg) (hNa := hNa) (hNb := hNb)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairClassifiedBool smallDisk_1_4 (smallPairTable 1 4) = true := by
  exact _root_.D1Bound5.smallPairs_1_4_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 1 4) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 1 4 := by
  exact _root_.D1Bound5.smallPair_classified_1_4 (a := a) (b := b) (ha := ha) (hb := hb) (hab := hab) (hroot := hroot) (hnondeg := hnondeg) (hNa := hNa) (hNb := hNb)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairClassifiedBool smallDisk_1_5 (smallPairTable 1 5) = true := by
  exact _root_.D1Bound5.smallPairs_1_5_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 1 5) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 1 5 := by
  exact _root_.D1Bound5.smallPair_classified_1_5 (a := a) (b := b) (ha := ha) (hb := hb) (hab := hab) (hroot := hroot) (hnondeg := hnondeg) (hNa := hNa) (hNb := hNb)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairClassifiedBool smallDisk_1_6 (smallPairTable 1 6) = true := by
  exact _root_.D1Bound5.smallPairs_1_6_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 1 6) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 1 6 := by
  exact _root_.D1Bound5.smallPair_classified_1_6 (a := a) (b := b) (ha := ha) (hb := hb) (hab := hab) (hroot := hroot) (hnondeg := hnondeg) (hNa := hNa) (hNb := hNb)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairClassifiedBool smallDisk_1_7 (smallPairTable 1 7) = true := by
  exact _root_.D1Bound5.smallPairs_1_7_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 1 7) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 1 7 := by
  exact _root_.D1Bound5.smallPair_classified_1_7 (a := a) (b := b) (ha := ha) (hb := hb) (hab := hab) (hroot := hroot) (hnondeg := hnondeg) (hNa := hNa) (hNb := hNb)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    smallPairClassifiedBool smallDisk_1_8 (smallPairTable 1 8) = true := by
  exact _root_.D1Bound5.smallPairs_1_8_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 1 8) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable 1 8 := by
  exact _root_.D1Bound5.smallPair_classified_1_8 (a := a) (b := b) (ha := ha) (hb := hb) (hab := hab) (hroot := hroot) (hnondeg := hnondeg) (hNa := hNa) (hNb := hNb)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example {tau nu : ℤ}
    (htau : tau = 0 ∨ tau = 1) (hlo : 1 ≤ nu) (hhi : nu ≤ 8)
    (a b : QuadInt tau nu) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) :
    pairCoordinates a b ∈ smallPairTable tau nu := by
  exact _root_.D1Bound5.smallPair_classified_rectangular (htau := htau) (hlo := hlo) (hhi := hhi) (a := a) (b := b) (ha := ha) (hb := hb) (hab := hab) (hroot := hroot) (hnondeg := hnondeg) (hNa := hNa) (hNb := hNb)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairs_0_1.toFinset = firstPairRepresentatives_0_1.biUnion (firstPairOrbit 0) := by
  exact _root_.D1Bound5.firstPairTable_0_1_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairs_0_2.toFinset = firstPairRepresentatives_0_2.biUnion (firstPairOrbit 0) := by
  exact _root_.D1Bound5.firstPairTable_0_2_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairs_0_5.toFinset = firstPairRepresentatives_0_5.biUnion (firstPairOrbit 0) := by
  exact _root_.D1Bound5.firstPairTable_0_5_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairs_0_6.toFinset = firstPairRepresentatives_0_6.biUnion (firstPairOrbit 0) := by
  exact _root_.D1Bound5.firstPairTable_0_6_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairs_1_1.toFinset = firstPairRepresentatives_1_1.biUnion (firstPairOrbit 1) := by
  exact _root_.D1Bound5.firstPairTable_1_1_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairs_1_2.toFinset = firstPairRepresentatives_1_2.biUnion (firstPairOrbit 1) := by
  exact _root_.D1Bound5.firstPairTable_1_2_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairs_1_3.toFinset = firstPairRepresentatives_1_3.biUnion (firstPairOrbit 1) := by
  exact _root_.D1Bound5.firstPairTable_1_3_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairs_1_4.toFinset = firstPairRepresentatives_1_4.biUnion (firstPairOrbit 1) := by
  exact _root_.D1Bound5.firstPairTable_1_4_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairs_1_5.toFinset = firstPairRepresentatives_1_5.biUnion (firstPairOrbit 1) := by
  exact _root_.D1Bound5.firstPairTable_1_5_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairs_1_6.toFinset = firstPairRepresentatives_1_6.biUnion (firstPairOrbit 1) := by
  exact _root_.D1Bound5.firstPairTable_1_6_orbits
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairClassifiedBool smallDisk_0_1 smallDisk_0_1 (firstPairTable 0 1) = true := by
  exact _root_.D1Bound5.firstPair_0_1_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 0 1) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 0 1 := by
  exact _root_.D1Bound5.firstPair_classified_0_1 (a := a) (b := b) (hnorm := hnorm) (hroot := hroot)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairClassifiedBool smallDisk_0_2 smallDisk_0_2 (firstPairTable 0 2) = true := by
  exact _root_.D1Bound5.firstPair_0_2_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 0 2) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 0 2 := by
  exact _root_.D1Bound5.firstPair_classified_0_2 (a := a) (b := b) (hnorm := hnorm) (hroot := hroot)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairClassifiedBool smallDisk_0_3 smallDisk_0_3 (firstPairTable 0 3) = true := by
  exact _root_.D1Bound5.firstPair_0_3_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 0 3) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 0 3 := by
  exact _root_.D1Bound5.firstPair_classified_0_3 (a := a) (b := b) (hnorm := hnorm) (hroot := hroot)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairClassifiedBool smallDisk_0_4 smallDisk_0_4 (firstPairTable 0 4) = true := by
  exact _root_.D1Bound5.firstPair_0_4_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 0 4) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 0 4 := by
  exact _root_.D1Bound5.firstPair_classified_0_4 (a := a) (b := b) (hnorm := hnorm) (hroot := hroot)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairClassifiedBool smallDisk_0_5 smallDisk_0_5 (firstPairTable 0 5) = true := by
  exact _root_.D1Bound5.firstPair_0_5_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 0 5) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 0 5 := by
  exact _root_.D1Bound5.firstPair_classified_0_5 (a := a) (b := b) (hnorm := hnorm) (hroot := hroot)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairClassifiedBool smallDisk_0_6 smallDisk_0_6 (firstPairTable 0 6) = true := by
  exact _root_.D1Bound5.firstPair_0_6_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 0 6) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 0 6 := by
  exact _root_.D1Bound5.firstPair_classified_0_6 (a := a) (b := b) (hnorm := hnorm) (hroot := hroot)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairClassifiedBool smallDisk_0_7 smallDisk_0_7 (firstPairTable 0 7) = true := by
  exact _root_.D1Bound5.firstPair_0_7_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 0 7) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 0 7 := by
  exact _root_.D1Bound5.firstPair_classified_0_7 (a := a) (b := b) (hnorm := hnorm) (hroot := hroot)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairClassifiedBool smallDisk_0_8 smallDisk_0_8 (firstPairTable 0 8) = true := by
  exact _root_.D1Bound5.firstPair_0_8_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 0 8) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 0 8 := by
  exact _root_.D1Bound5.firstPair_classified_0_8 (a := a) (b := b) (hnorm := hnorm) (hroot := hroot)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairClassifiedBool smallDisk_1_1 smallDisk_1_1 (firstPairTable 1 1) = true := by
  exact _root_.D1Bound5.firstPair_1_1_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 1 1) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 1 1 := by
  exact _root_.D1Bound5.firstPair_classified_1_1 (a := a) (b := b) (hnorm := hnorm) (hroot := hroot)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairClassifiedBool smallDisk_1_2 smallDisk_1_2 (firstPairTable 1 2) = true := by
  exact _root_.D1Bound5.firstPair_1_2_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 1 2) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 1 2 := by
  exact _root_.D1Bound5.firstPair_classified_1_2 (a := a) (b := b) (hnorm := hnorm) (hroot := hroot)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairClassifiedBool smallDisk_1_3 smallDisk_1_3 (firstPairTable 1 3) = true := by
  exact _root_.D1Bound5.firstPair_1_3_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 1 3) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 1 3 := by
  exact _root_.D1Bound5.firstPair_classified_1_3 (a := a) (b := b) (hnorm := hnorm) (hroot := hroot)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairClassifiedBool smallDisk_1_4 smallDisk_1_4 (firstPairTable 1 4) = true := by
  exact _root_.D1Bound5.firstPair_1_4_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 1 4) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 1 4 := by
  exact _root_.D1Bound5.firstPair_classified_1_4 (a := a) (b := b) (hnorm := hnorm) (hroot := hroot)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairClassifiedBool smallDisk_1_5 smallDisk_1_5 (firstPairTable 1 5) = true := by
  exact _root_.D1Bound5.firstPair_1_5_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 1 5) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 1 5 := by
  exact _root_.D1Bound5.firstPair_classified_1_5 (a := a) (b := b) (hnorm := hnorm) (hroot := hroot)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairClassifiedBool smallDisk_1_6 smallDisk_1_6 (firstPairTable 1 6) = true := by
  exact _root_.D1Bound5.firstPair_1_6_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 1 6) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 1 6 := by
  exact _root_.D1Bound5.firstPair_classified_1_6 (a := a) (b := b) (hnorm := hnorm) (hroot := hroot)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairClassifiedBool smallDisk_1_7 smallDisk_1_7 (firstPairTable 1 7) = true := by
  exact _root_.D1Bound5.firstPair_1_7_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 1 7) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 1 7 := by
  exact _root_.D1Bound5.firstPair_classified_1_7 (a := a) (b := b) (hnorm := hnorm) (hroot := hroot)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    firstPairClassifiedBool smallDisk_1_8 smallDisk_1_8 (firstPairTable 1 8) = true := by
  exact _root_.D1Bound5.firstPair_1_8_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    (a b : QuadInt 1 8) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable 1 8 := by
  exact _root_.D1Bound5.firstPair_classified_1_8 (a := a) (b := b) (hnorm := hnorm) (hroot := hroot)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example {tau nu : ℤ}
    (htau : tau = 0 ∨ tau = 1) (hlo : 1 ≤ nu) (hhi : nu ≤ 8)
    (a b : QuadInt tau nu) (hnorm : FirstPairNorms a b) (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ firstPairTable tau nu := by
  exact _root_.D1Bound5.firstPair_classified_rectangular (htau := htau) (hlo := hlo) (hhi := hhi) (a := a) (b := b) (hnorm := hnorm) (hroot := hroot)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 0 1 224 = oneSmallDisk_224_0_1.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_224_0_1_eq
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 0 1 300 = oneSmallDisk_300_0_1.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_300_0_1_eq
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 0 2 224 = oneSmallDisk_224_0_2.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_224_0_2_eq
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 0 2 300 = oneSmallDisk_300_0_2.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_300_0_2_eq
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 0 5 224 = oneSmallDisk_224_0_5.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_224_0_5_eq
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 0 5 300 = oneSmallDisk_300_0_5.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_300_0_5_eq
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 0 6 224 = oneSmallDisk_224_0_6.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_224_0_6_eq
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 0 6 300 = oneSmallDisk_300_0_6.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_300_0_6_eq
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 1 1 224 = oneSmallDisk_224_1_1.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_224_1_1_eq
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 1 1 300 = oneSmallDisk_300_1_1.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_300_1_1_eq
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 1 2 224 = oneSmallDisk_224_1_2.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_224_1_2_eq
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 1 2 300 = oneSmallDisk_300_1_2.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_300_1_2_eq
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 1 3 224 = oneSmallDisk_224_1_3.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_224_1_3_eq
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 1 3 300 = oneSmallDisk_300_1_3.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_300_1_3_eq
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 1 4 224 = oneSmallDisk_224_1_4.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_224_1_4_eq
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 1 4 300 = oneSmallDisk_300_1_4.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_300_1_4_eq
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 1 5 224 = oneSmallDisk_224_1_5.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_224_1_5_eq
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 1 5 300 = oneSmallDisk_300_1_5.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_300_1_5_eq
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 1 6 224 = oneSmallDisk_224_1_6.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_224_1_6_eq
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : disk 1 6 300 = oneSmallDisk_300_1_6.toFinset := by
  exact _root_.D1Bound5.oneSmallDisk_300_1_6_eq
end D1Bound5
end
