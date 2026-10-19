import D1Bound5.UnitPairFieldBound
import D1Bound5.PellLightPrefixPilot
import D1Bound5.PellLightPrefixData2
import D1Bound5.PellLightPrefixData3
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  let names : List Name := [
    `D1Bound5.IsD1Tuple.unit_pair_finite_field_model,
    `D1Bound5.PellLightProduction.magnitudes_4519,
    `D1Bound5.PellLightProduction.checked_4519,
    `D1Bound5.PellLightProduction.magnitudes_151,
    `D1Bound5.PellLightProduction.checked_151,
    `D1Bound5.PellLightProduction.magnitudes_159,
    `D1Bound5.PellLightProduction.checked_159,
    `D1Bound5.PellLightProduction.magnitudes_167,
    `D1Bound5.PellLightProduction.checked_167,
    `D1Bound5.PellLightProduction.magnitudes_183,
    `D1Bound5.PellLightProduction.checked_183,
    `D1Bound5.PellLightProduction.magnitudes_191,
    `D1Bound5.PellLightProduction.checked_191,
    `D1Bound5.PellLightProduction.magnitudes_199,
    `D1Bound5.PellLightProduction.checked_199,
    `D1Bound5.PellLightProduction.magnitudes_215,
    `D1Bound5.PellLightProduction.checked_215,
    `D1Bound5.PellLightProduction.magnitudes_223,
    `D1Bound5.PellLightProduction.checked_223,
    `D1Bound5.PellLightProduction.magnitudes_231,
    `D1Bound5.PellLightProduction.checked_231,
    `D1Bound5.PellLightProduction.magnitudes_239,
    `D1Bound5.PellLightProduction.checked_239,
    `D1Bound5.PellLightProduction.magnitudes_247,
    `D1Bound5.PellLightProduction.checked_247,
    `D1Bound5.PellLightProduction.magnitudes_255,
    `D1Bound5.PellLightProduction.checked_255,
    `D1Bound5.PellLightProduction.magnitudes_263,
    `D1Bound5.PellLightProduction.checked_263,
    `D1Bound5.PellLightProduction.magnitudes_271,
    `D1Bound5.PellLightProduction.checked_271,
    `D1Bound5.PellLightProduction.magnitudes_287,
    `D1Bound5.PellLightProduction.checked_287,
    `D1Bound5.PellLightProduction.magnitudes_295,
    `D1Bound5.PellLightProduction.checked_295,
    `D1Bound5.PellLightProduction.magnitudes_303,
    `D1Bound5.PellLightProduction.checked_303,
    `D1Bound5.PellLightProduction.magnitudes_311,
    `D1Bound5.PellLightProduction.checked_311,
    `D1Bound5.PellLightProduction.magnitudes_319,
    `D1Bound5.PellLightProduction.checked_319,
    `D1Bound5.PellLightProduction.magnitudes_327,
    `D1Bound5.PellLightProduction.checked_327,
    `D1Bound5.PellLightProduction.magnitudes_335,
    `D1Bound5.PellLightProduction.checked_335,
    `D1Bound5.PellLightProduction.magnitudes_359,
    `D1Bound5.PellLightProduction.checked_359,
    `D1Bound5.PellLightProduction.magnitudes_367,
    `D1Bound5.PellLightProduction.checked_367,
    `D1Bound5.PellLightProduction.magnitudes_383,
    `D1Bound5.PellLightProduction.checked_383,
    `D1Bound5.PellLightProduction.magnitudes_391,
    `D1Bound5.PellLightProduction.checked_391,
    `D1Bound5.PellLightProduction.magnitudes_399,
    `D1Bound5.PellLightProduction.checked_399,
    `D1Bound5.PellLightProduction.magnitudes_407,
    `D1Bound5.PellLightProduction.checked_407,
    `D1Bound5.PellLightProduction.magnitudes_415,
    `D1Bound5.PellLightProduction.checked_415,
    `D1Bound5.PellLightProduction.magnitudes_431,
    `D1Bound5.PellLightProduction.checked_431,
    `D1Bound5.PellLightProduction.magnitudes_439,
    `D1Bound5.PellLightProduction.checked_439,
    `D1Bound5.PellLightProduction.magnitudes_447,
    `D1Bound5.PellLightProduction.checked_447,
    `D1Bound5.PellLightProduction.magnitudes_455,
    `D1Bound5.PellLightProduction.checked_455]
  for name in names do
    let axioms ← Lean.collectAxioms name
    let other := axioms.filter fun x => !allowed.contains x
    unless other.isEmpty do
      throwError "Unexpected axioms in {name}: {other}"
    logInfo m!"FIELD_PREFIX_AXIOMS_PASS {name}: {axioms}"

#check @D1Bound5.IsD1Tuple.unit_pair_finite_field_model
#check @D1Bound5.PellLightProduction.magnitudes_4519
#check @D1Bound5.PellLightProduction.checked_4519
#check @D1Bound5.PellLightProduction.magnitudes_151
#check @D1Bound5.PellLightProduction.checked_151
#check @D1Bound5.PellLightProduction.magnitudes_159
#check @D1Bound5.PellLightProduction.checked_159
#check @D1Bound5.PellLightProduction.magnitudes_167
#check @D1Bound5.PellLightProduction.checked_167
#check @D1Bound5.PellLightProduction.magnitudes_183
#check @D1Bound5.PellLightProduction.checked_183
#check @D1Bound5.PellLightProduction.magnitudes_191
#check @D1Bound5.PellLightProduction.checked_191
#check @D1Bound5.PellLightProduction.magnitudes_199
#check @D1Bound5.PellLightProduction.checked_199
#check @D1Bound5.PellLightProduction.magnitudes_215
#check @D1Bound5.PellLightProduction.checked_215
#check @D1Bound5.PellLightProduction.magnitudes_223
#check @D1Bound5.PellLightProduction.checked_223
#check @D1Bound5.PellLightProduction.magnitudes_231
#check @D1Bound5.PellLightProduction.checked_231
#check @D1Bound5.PellLightProduction.magnitudes_239
#check @D1Bound5.PellLightProduction.checked_239
#check @D1Bound5.PellLightProduction.magnitudes_247
#check @D1Bound5.PellLightProduction.checked_247
#check @D1Bound5.PellLightProduction.magnitudes_255
#check @D1Bound5.PellLightProduction.checked_255
#check @D1Bound5.PellLightProduction.magnitudes_263
#check @D1Bound5.PellLightProduction.checked_263
#check @D1Bound5.PellLightProduction.magnitudes_271
#check @D1Bound5.PellLightProduction.checked_271
#check @D1Bound5.PellLightProduction.magnitudes_287
#check @D1Bound5.PellLightProduction.checked_287
#check @D1Bound5.PellLightProduction.magnitudes_295
#check @D1Bound5.PellLightProduction.checked_295
#check @D1Bound5.PellLightProduction.magnitudes_303
#check @D1Bound5.PellLightProduction.checked_303
#check @D1Bound5.PellLightProduction.magnitudes_311
#check @D1Bound5.PellLightProduction.checked_311
#check @D1Bound5.PellLightProduction.magnitudes_319
#check @D1Bound5.PellLightProduction.checked_319
#check @D1Bound5.PellLightProduction.magnitudes_327
#check @D1Bound5.PellLightProduction.checked_327
#check @D1Bound5.PellLightProduction.magnitudes_335
#check @D1Bound5.PellLightProduction.checked_335
#check @D1Bound5.PellLightProduction.magnitudes_359
#check @D1Bound5.PellLightProduction.checked_359
#check @D1Bound5.PellLightProduction.magnitudes_367
#check @D1Bound5.PellLightProduction.checked_367
#check @D1Bound5.PellLightProduction.magnitudes_383
#check @D1Bound5.PellLightProduction.checked_383
#check @D1Bound5.PellLightProduction.magnitudes_391
#check @D1Bound5.PellLightProduction.checked_391
#check @D1Bound5.PellLightProduction.magnitudes_399
#check @D1Bound5.PellLightProduction.checked_399
#check @D1Bound5.PellLightProduction.magnitudes_407
#check @D1Bound5.PellLightProduction.checked_407
#check @D1Bound5.PellLightProduction.magnitudes_415
#check @D1Bound5.PellLightProduction.checked_415
#check @D1Bound5.PellLightProduction.magnitudes_431
#check @D1Bound5.PellLightProduction.checked_431
#check @D1Bound5.PellLightProduction.magnitudes_439
#check @D1Bound5.PellLightProduction.checked_439
#check @D1Bound5.PellLightProduction.magnitudes_447
#check @D1Bound5.PellLightProduction.checked_447
#check @D1Bound5.PellLightProduction.magnitudes_455
#check @D1Bound5.PellLightProduction.checked_455
#print D1Bound5.UnitPairRealDescription
#print D1Bound5.UnitPairArithmeticModel
