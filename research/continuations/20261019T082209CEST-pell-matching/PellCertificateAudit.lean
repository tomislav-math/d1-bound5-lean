import D1Bound5.PellLightMatchingPilot
import D1Bound5.PellLightPrefixData4
import D1Bound5.PellLightPrefixData5
import Lean.Util.CollectAxioms
import Lean.Elab.Command

open Lean Elab Command

run_cmd do
  let names : List Name := [`D1Bound5.PellMatchingLightProduction.pellMagnitudes_4519,
    `D1Bound5.PellMatchingLightProduction.pellMasks_4519,
    `D1Bound5.PellMatchingLightProduction.pellWitnesses_4519,
    `D1Bound5.PellMatchingLightProduction.pellMasks_4519_valid,
    `D1Bound5.PellMatchingLightProduction.pellMatching_4519_checked,
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_4519_large,
    `D1Bound5.PellLightProduction.magnitudes_463,
    `D1Bound5.PellLightProduction.checked_463,
    `D1Bound5.PellLightProduction.magnitudes_471,
    `D1Bound5.PellLightProduction.checked_471,
    `D1Bound5.PellLightProduction.magnitudes_479,
    `D1Bound5.PellLightProduction.checked_479,
    `D1Bound5.PellLightProduction.magnitudes_487,
    `D1Bound5.PellLightProduction.checked_487,
    `D1Bound5.PellLightProduction.magnitudes_503,
    `D1Bound5.PellLightProduction.checked_503,
    `D1Bound5.PellLightProduction.magnitudes_511,
    `D1Bound5.PellLightProduction.checked_511,
    `D1Bound5.PellLightProduction.magnitudes_519,
    `D1Bound5.PellLightProduction.checked_519,
    `D1Bound5.PellLightProduction.magnitudes_527,
    `D1Bound5.PellLightProduction.checked_527,
    `D1Bound5.PellLightProduction.magnitudes_535,
    `D1Bound5.PellLightProduction.checked_535,
    `D1Bound5.PellLightProduction.magnitudes_543,
    `D1Bound5.PellLightProduction.checked_543,
    `D1Bound5.PellLightProduction.magnitudes_551,
    `D1Bound5.PellLightProduction.checked_551,
    `D1Bound5.PellLightProduction.magnitudes_559,
    `D1Bound5.PellLightProduction.checked_559,
    `D1Bound5.PellLightProduction.magnitudes_583,
    `D1Bound5.PellLightProduction.checked_583,
    `D1Bound5.PellLightProduction.magnitudes_591,
    `D1Bound5.PellLightProduction.checked_591,
    `D1Bound5.PellLightProduction.magnitudes_599,
    `D1Bound5.PellLightProduction.checked_599,
    `D1Bound5.PellLightProduction.magnitudes_607,
    `D1Bound5.PellLightProduction.checked_607,
    `D1Bound5.PellLightProduction.magnitudes_615,
    `D1Bound5.PellLightProduction.checked_615,
    `D1Bound5.PellLightProduction.magnitudes_623,
    `D1Bound5.PellLightProduction.checked_623,
    `D1Bound5.PellLightProduction.magnitudes_631,
    `D1Bound5.PellLightProduction.checked_631,
    `D1Bound5.PellLightProduction.magnitudes_647,
    `D1Bound5.PellLightProduction.checked_647,
    `D1Bound5.PellLightProduction.magnitudes_655,
    `D1Bound5.PellLightProduction.checked_655,
    `D1Bound5.PellLightProduction.magnitudes_663,
    `D1Bound5.PellLightProduction.checked_663,
    `D1Bound5.PellLightProduction.magnitudes_671,
    `D1Bound5.PellLightProduction.checked_671,
    `D1Bound5.PellLightProduction.magnitudes_679,
    `D1Bound5.PellLightProduction.checked_679,
    `D1Bound5.PellLightProduction.magnitudes_687,
    `D1Bound5.PellLightProduction.checked_687,
    `D1Bound5.PellLightProduction.magnitudes_695,
    `D1Bound5.PellLightProduction.checked_695,
    `D1Bound5.PellLightProduction.magnitudes_703,
    `D1Bound5.PellLightProduction.checked_703,
    `D1Bound5.PellLightProduction.magnitudes_719,
    `D1Bound5.PellLightProduction.checked_719,
    `D1Bound5.PellLightProduction.magnitudes_727,
    `D1Bound5.PellLightProduction.checked_727,
    `D1Bound5.PellLightProduction.magnitudes_743,
    `D1Bound5.PellLightProduction.checked_743,
    `D1Bound5.PellLightProduction.magnitudes_751,
    `D1Bound5.PellLightProduction.checked_751,
    `D1Bound5.PellLightProduction.magnitudes_759,
    `D1Bound5.PellLightProduction.checked_759]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for name in names do
    let axioms ← Lean.collectAxioms name
    let unexpected := axioms.filter fun a => !allowed.contains a
    unless unexpected.isEmpty do
      throwError "Unexpected axioms in {name}: {axioms}"
    logInfo m!"PELL_CERTIFICATE_AXIOMS_PASS {name}: {axioms}"

#check @D1Bound5.PellMatchingLightProduction.pellMagnitudes_4519
#check @D1Bound5.PellMatchingLightProduction.pellMasks_4519
#check @D1Bound5.PellMatchingLightProduction.pellWitnesses_4519
#check @D1Bound5.PellMatchingLightProduction.pellMasks_4519_valid
#check @D1Bound5.PellMatchingLightProduction.pellMatching_4519_checked
#check @D1Bound5.PellMatchingLightProduction.pellMagnitudes_4519_large
#check @D1Bound5.PellLightProduction.magnitudes_463
#check @D1Bound5.PellLightProduction.checked_463
#check @D1Bound5.PellLightProduction.magnitudes_471
#check @D1Bound5.PellLightProduction.checked_471
#check @D1Bound5.PellLightProduction.magnitudes_479
#check @D1Bound5.PellLightProduction.checked_479
#check @D1Bound5.PellLightProduction.magnitudes_487
#check @D1Bound5.PellLightProduction.checked_487
#check @D1Bound5.PellLightProduction.magnitudes_503
#check @D1Bound5.PellLightProduction.checked_503
#check @D1Bound5.PellLightProduction.magnitudes_511
#check @D1Bound5.PellLightProduction.checked_511
#check @D1Bound5.PellLightProduction.magnitudes_519
#check @D1Bound5.PellLightProduction.checked_519
#check @D1Bound5.PellLightProduction.magnitudes_527
#check @D1Bound5.PellLightProduction.checked_527
#check @D1Bound5.PellLightProduction.magnitudes_535
#check @D1Bound5.PellLightProduction.checked_535
#check @D1Bound5.PellLightProduction.magnitudes_543
#check @D1Bound5.PellLightProduction.checked_543
#check @D1Bound5.PellLightProduction.magnitudes_551
#check @D1Bound5.PellLightProduction.checked_551
#check @D1Bound5.PellLightProduction.magnitudes_559
#check @D1Bound5.PellLightProduction.checked_559
#check @D1Bound5.PellLightProduction.magnitudes_583
#check @D1Bound5.PellLightProduction.checked_583
#check @D1Bound5.PellLightProduction.magnitudes_591
#check @D1Bound5.PellLightProduction.checked_591
#check @D1Bound5.PellLightProduction.magnitudes_599
#check @D1Bound5.PellLightProduction.checked_599
#check @D1Bound5.PellLightProduction.magnitudes_607
#check @D1Bound5.PellLightProduction.checked_607
#check @D1Bound5.PellLightProduction.magnitudes_615
#check @D1Bound5.PellLightProduction.checked_615
#check @D1Bound5.PellLightProduction.magnitudes_623
#check @D1Bound5.PellLightProduction.checked_623
#check @D1Bound5.PellLightProduction.magnitudes_631
#check @D1Bound5.PellLightProduction.checked_631
#check @D1Bound5.PellLightProduction.magnitudes_647
#check @D1Bound5.PellLightProduction.checked_647
#check @D1Bound5.PellLightProduction.magnitudes_655
#check @D1Bound5.PellLightProduction.checked_655
#check @D1Bound5.PellLightProduction.magnitudes_663
#check @D1Bound5.PellLightProduction.checked_663
#check @D1Bound5.PellLightProduction.magnitudes_671
#check @D1Bound5.PellLightProduction.checked_671
#check @D1Bound5.PellLightProduction.magnitudes_679
#check @D1Bound5.PellLightProduction.checked_679
#check @D1Bound5.PellLightProduction.magnitudes_687
#check @D1Bound5.PellLightProduction.checked_687
#check @D1Bound5.PellLightProduction.magnitudes_695
#check @D1Bound5.PellLightProduction.checked_695
#check @D1Bound5.PellLightProduction.magnitudes_703
#check @D1Bound5.PellLightProduction.checked_703
#check @D1Bound5.PellLightProduction.magnitudes_719
#check @D1Bound5.PellLightProduction.checked_719
#check @D1Bound5.PellLightProduction.magnitudes_727
#check @D1Bound5.PellLightProduction.checked_727
#check @D1Bound5.PellLightProduction.magnitudes_743
#check @D1Bound5.PellLightProduction.checked_743
#check @D1Bound5.PellLightProduction.magnitudes_751
#check @D1Bound5.PellLightProduction.checked_751
#check @D1Bound5.PellLightProduction.magnitudes_759
#check @D1Bound5.PellLightProduction.checked_759
