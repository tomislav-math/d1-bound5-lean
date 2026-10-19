import D1Bound5.PellLightMatchingField23
import D1Bound5.PellLightMatchingField31
import D1Bound5.PellLightPrefixData6
import D1Bound5.PellLightPrefixData7
import Lean.Util.CollectAxioms
import Lean.Elab.Command

open Lean Elab Command

run_cmd do
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let names : List Name := [
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_23,
    `D1Bound5.PellMatchingLightProduction.pellMasks_23,
    `D1Bound5.PellMatchingLightProduction.pellWitnesses_23,
    `D1Bound5.PellMatchingLightProduction.pellMasks_23_valid,
    `D1Bound5.PellMatchingLightProduction.pellMatching_23_checked,
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_23_large,
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_31,
    `D1Bound5.PellMatchingLightProduction.pellMasks_31,
    `D1Bound5.PellMatchingLightProduction.pellWitnesses_31,
    `D1Bound5.PellMatchingLightProduction.pellMasks_31_valid,
    `D1Bound5.PellMatchingLightProduction.pellMatching_31_checked,
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_31_large,
    `D1Bound5.PellLightProduction.magnitudes_767,
    `D1Bound5.PellLightProduction.checked_767,
    `D1Bound5.PellLightProduction.magnitudes_791,
    `D1Bound5.PellLightProduction.checked_791,
    `D1Bound5.PellLightProduction.magnitudes_799,
    `D1Bound5.PellLightProduction.checked_799,
    `D1Bound5.PellLightProduction.magnitudes_807,
    `D1Bound5.PellLightProduction.checked_807,
    `D1Bound5.PellLightProduction.magnitudes_815,
    `D1Bound5.PellLightProduction.checked_815,
    `D1Bound5.PellLightProduction.magnitudes_823,
    `D1Bound5.PellLightProduction.checked_823,
    `D1Bound5.PellLightProduction.magnitudes_831,
    `D1Bound5.PellLightProduction.checked_831,
    `D1Bound5.PellLightProduction.magnitudes_839,
    `D1Bound5.PellLightProduction.checked_839,
    `D1Bound5.PellLightProduction.magnitudes_863,
    `D1Bound5.PellLightProduction.checked_863,
    `D1Bound5.PellLightProduction.magnitudes_871,
    `D1Bound5.PellLightProduction.checked_871,
    `D1Bound5.PellLightProduction.magnitudes_879,
    `D1Bound5.PellLightProduction.checked_879,
    `D1Bound5.PellLightProduction.magnitudes_887,
    `D1Bound5.PellLightProduction.checked_887,
    `D1Bound5.PellLightProduction.magnitudes_895,
    `D1Bound5.PellLightProduction.checked_895,
    `D1Bound5.PellLightProduction.magnitudes_903,
    `D1Bound5.PellLightProduction.checked_903,
    `D1Bound5.PellLightProduction.magnitudes_911,
    `D1Bound5.PellLightProduction.checked_911,
    `D1Bound5.PellLightProduction.magnitudes_919,
    `D1Bound5.PellLightProduction.checked_919,
    `D1Bound5.PellLightProduction.magnitudes_935,
    `D1Bound5.PellLightProduction.checked_935,
    `D1Bound5.PellLightProduction.magnitudes_943,
    `D1Bound5.PellLightProduction.checked_943,
    `D1Bound5.PellLightProduction.magnitudes_951,
    `D1Bound5.PellLightProduction.checked_951,
    `D1Bound5.PellLightProduction.magnitudes_959,
    `D1Bound5.PellLightProduction.checked_959,
    `D1Bound5.PellLightProduction.magnitudes_967,
    `D1Bound5.PellLightProduction.checked_967,
    `D1Bound5.PellLightProduction.magnitudes_983,
    `D1Bound5.PellLightProduction.checked_983,
    `D1Bound5.PellLightProduction.magnitudes_991,
    `D1Bound5.PellLightProduction.checked_991,
    `D1Bound5.PellLightProduction.magnitudes_1007,
    `D1Bound5.PellLightProduction.checked_1007,
    `D1Bound5.PellLightProduction.magnitudes_1015,
    `D1Bound5.PellLightProduction.checked_1015,
    `D1Bound5.PellLightProduction.magnitudes_1023,
    `D1Bound5.PellLightProduction.checked_1023,
    `D1Bound5.PellLightProduction.magnitudes_1031,
    `D1Bound5.PellLightProduction.checked_1031,
    `D1Bound5.PellLightProduction.magnitudes_1039,
    `D1Bound5.PellLightProduction.checked_1039,
    `D1Bound5.PellLightProduction.magnitudes_1047,
    `D1Bound5.PellLightProduction.checked_1047,
    `D1Bound5.PellLightProduction.magnitudes_1055,
    `D1Bound5.PellLightProduction.checked_1055,
    `D1Bound5.PellLightProduction.magnitudes_1063,
    `D1Bound5.PellLightProduction.checked_1063,
    `D1Bound5.PellLightProduction.magnitudes_1079,
    `D1Bound5.PellLightProduction.checked_1079]
  for name in names do
    let axioms ← Lean.collectAxioms name
    let bad := axioms.filter fun x => !allowed.contains x
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"PAPER_PELL_AXIOMS_PASS {name}: {axioms}"

#check @D1Bound5.PellMatchingLightProduction.pellMagnitudes_23
#check @D1Bound5.PellMatchingLightProduction.pellMasks_23
#check @D1Bound5.PellMatchingLightProduction.pellWitnesses_23
#check @D1Bound5.PellMatchingLightProduction.pellMasks_23_valid
#check @D1Bound5.PellMatchingLightProduction.pellMatching_23_checked
#check @D1Bound5.PellMatchingLightProduction.pellMagnitudes_23_large
#check @D1Bound5.PellMatchingLightProduction.pellMagnitudes_31
#check @D1Bound5.PellMatchingLightProduction.pellMasks_31
#check @D1Bound5.PellMatchingLightProduction.pellWitnesses_31
#check @D1Bound5.PellMatchingLightProduction.pellMasks_31_valid
#check @D1Bound5.PellMatchingLightProduction.pellMatching_31_checked
#check @D1Bound5.PellMatchingLightProduction.pellMagnitudes_31_large
#check @D1Bound5.PellLightProduction.magnitudes_767
#check @D1Bound5.PellLightProduction.checked_767
#check @D1Bound5.PellLightProduction.magnitudes_791
#check @D1Bound5.PellLightProduction.checked_791
#check @D1Bound5.PellLightProduction.magnitudes_799
#check @D1Bound5.PellLightProduction.checked_799
#check @D1Bound5.PellLightProduction.magnitudes_807
#check @D1Bound5.PellLightProduction.checked_807
#check @D1Bound5.PellLightProduction.magnitudes_815
#check @D1Bound5.PellLightProduction.checked_815
#check @D1Bound5.PellLightProduction.magnitudes_823
#check @D1Bound5.PellLightProduction.checked_823
#check @D1Bound5.PellLightProduction.magnitudes_831
#check @D1Bound5.PellLightProduction.checked_831
#check @D1Bound5.PellLightProduction.magnitudes_839
#check @D1Bound5.PellLightProduction.checked_839
#check @D1Bound5.PellLightProduction.magnitudes_863
#check @D1Bound5.PellLightProduction.checked_863
#check @D1Bound5.PellLightProduction.magnitudes_871
#check @D1Bound5.PellLightProduction.checked_871
#check @D1Bound5.PellLightProduction.magnitudes_879
#check @D1Bound5.PellLightProduction.checked_879
#check @D1Bound5.PellLightProduction.magnitudes_887
#check @D1Bound5.PellLightProduction.checked_887
#check @D1Bound5.PellLightProduction.magnitudes_895
#check @D1Bound5.PellLightProduction.checked_895
#check @D1Bound5.PellLightProduction.magnitudes_903
#check @D1Bound5.PellLightProduction.checked_903
#check @D1Bound5.PellLightProduction.magnitudes_911
#check @D1Bound5.PellLightProduction.checked_911
#check @D1Bound5.PellLightProduction.magnitudes_919
#check @D1Bound5.PellLightProduction.checked_919
#check @D1Bound5.PellLightProduction.magnitudes_935
#check @D1Bound5.PellLightProduction.checked_935
#check @D1Bound5.PellLightProduction.magnitudes_943
#check @D1Bound5.PellLightProduction.checked_943
#check @D1Bound5.PellLightProduction.magnitudes_951
#check @D1Bound5.PellLightProduction.checked_951
#check @D1Bound5.PellLightProduction.magnitudes_959
#check @D1Bound5.PellLightProduction.checked_959
#check @D1Bound5.PellLightProduction.magnitudes_967
#check @D1Bound5.PellLightProduction.checked_967
#check @D1Bound5.PellLightProduction.magnitudes_983
#check @D1Bound5.PellLightProduction.checked_983
#check @D1Bound5.PellLightProduction.magnitudes_991
#check @D1Bound5.PellLightProduction.checked_991
#check @D1Bound5.PellLightProduction.magnitudes_1007
#check @D1Bound5.PellLightProduction.checked_1007
#check @D1Bound5.PellLightProduction.magnitudes_1015
#check @D1Bound5.PellLightProduction.checked_1015
#check @D1Bound5.PellLightProduction.magnitudes_1023
#check @D1Bound5.PellLightProduction.checked_1023
#check @D1Bound5.PellLightProduction.magnitudes_1031
#check @D1Bound5.PellLightProduction.checked_1031
#check @D1Bound5.PellLightProduction.magnitudes_1039
#check @D1Bound5.PellLightProduction.checked_1039
#check @D1Bound5.PellLightProduction.magnitudes_1047
#check @D1Bound5.PellLightProduction.checked_1047
#check @D1Bound5.PellLightProduction.magnitudes_1055
#check @D1Bound5.PellLightProduction.checked_1055
#check @D1Bound5.PellLightProduction.magnitudes_1063
#check @D1Bound5.PellLightProduction.checked_1063
#check @D1Bound5.PellLightProduction.magnitudes_1079
#check @D1Bound5.PellLightProduction.checked_1079
