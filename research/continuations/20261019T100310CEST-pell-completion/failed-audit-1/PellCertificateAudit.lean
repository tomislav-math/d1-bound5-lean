import D1Bound5.PellLightMatchingField359
import D1Bound5.PellLightMatchingField367
import D1Bound5.PellLightMatchingField383
import D1Bound5.PellLightMatchingField391
import D1Bound5.PellLightMatchingField431
import D1Bound5.PellLightMatchingField439
import D1Bound5.PellLightMatchingField463
import D1Bound5.PellLightMatchingField479
import D1Bound5.PellLightPrefixData48
import D1Bound5.PellLightPrefixData49
import D1Bound5.PellLightPrefixData50
import D1Bound5.PellLightPrefixData51
import D1Bound5.PellLightPrefixData52
import D1Bound5.PellLightPrefixData53
import D1Bound5.PellLightPrefixData54
import D1Bound5.PellLightPrefixData55
import D1Bound5.PellLightPrefixData56
import D1Bound5.PellLightPrefixData57
import D1Bound5.PellLightPrefixData58
import D1Bound5.PellLightPrefixData59
import D1Bound5.PellLightPrefixData60
import D1Bound5.PellLightPrefixData61
import D1Bound5.PellLightPrefixData62
import D1Bound5.PellLightPrefixData63
import D1Bound5.PellLightPrefixData64
import Lean.Elab.Command
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let names : List Name := [
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_359,
    `D1Bound5.PellMatchingLightProduction.pellMasks_359,
    `D1Bound5.PellMatchingLightProduction.pellWitnesses_359,
    `D1Bound5.PellMatchingLightProduction.pellMasks_359_valid,
    `D1Bound5.PellMatchingLightProduction.pellMatching_359_checked,
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_359_large,
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_367,
    `D1Bound5.PellMatchingLightProduction.pellMasks_367,
    `D1Bound5.PellMatchingLightProduction.pellWitnesses_367,
    `D1Bound5.PellMatchingLightProduction.pellMasks_367_valid,
    `D1Bound5.PellMatchingLightProduction.pellMatching_367_checked,
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_367_large,
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_383,
    `D1Bound5.PellMatchingLightProduction.pellMasks_383,
    `D1Bound5.PellMatchingLightProduction.pellWitnesses_383,
    `D1Bound5.PellMatchingLightProduction.pellMasks_383_valid,
    `D1Bound5.PellMatchingLightProduction.pellMatching_383_checked,
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_383_large,
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_391,
    `D1Bound5.PellMatchingLightProduction.pellMasks_391,
    `D1Bound5.PellMatchingLightProduction.pellWitnesses_391,
    `D1Bound5.PellMatchingLightProduction.pellMasks_391_valid,
    `D1Bound5.PellMatchingLightProduction.pellMatching_391_checked,
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_391_large,
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_431,
    `D1Bound5.PellMatchingLightProduction.pellMasks_431,
    `D1Bound5.PellMatchingLightProduction.pellWitnesses_431,
    `D1Bound5.PellMatchingLightProduction.pellMasks_431_valid,
    `D1Bound5.PellMatchingLightProduction.pellMatching_431_checked,
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_431_large,
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_439,
    `D1Bound5.PellMatchingLightProduction.pellMasks_439,
    `D1Bound5.PellMatchingLightProduction.pellWitnesses_439,
    `D1Bound5.PellMatchingLightProduction.pellMasks_439_valid,
    `D1Bound5.PellMatchingLightProduction.pellMatching_439_checked,
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_439_large,
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_463,
    `D1Bound5.PellMatchingLightProduction.pellMasks_463,
    `D1Bound5.PellMatchingLightProduction.pellWitnesses_463,
    `D1Bound5.PellMatchingLightProduction.pellMasks_463_valid,
    `D1Bound5.PellMatchingLightProduction.pellMatching_463_checked,
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_463_large,
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_479,
    `D1Bound5.PellMatchingLightProduction.pellMasks_479,
    `D1Bound5.PellMatchingLightProduction.pellWitnesses_479,
    `D1Bound5.PellMatchingLightProduction.pellMasks_479_valid,
    `D1Bound5.PellMatchingLightProduction.pellMatching_479_checked,
    `D1Bound5.PellMatchingLightProduction.pellMagnitudes_479_large,
    `D1Bound5.PellLightProduction.magnitudes_7415,
    `D1Bound5.PellLightProduction.magnitudes_7423,
    `D1Bound5.PellLightProduction.magnitudes_7431,
    `D1Bound5.PellLightProduction.magnitudes_7439,
    `D1Bound5.PellLightProduction.magnitudes_7447,
    `D1Bound5.PellLightProduction.magnitudes_7455,
    `D1Bound5.PellLightProduction.magnitudes_7463,
    `D1Bound5.PellLightProduction.magnitudes_7471,
    `D1Bound5.PellLightProduction.magnitudes_7487,
    `D1Bound5.PellLightProduction.magnitudes_7495,
    `D1Bound5.PellLightProduction.magnitudes_7503,
    `D1Bound5.PellLightProduction.magnitudes_7511,
    `D1Bound5.PellLightProduction.magnitudes_7519,
    `D1Bound5.PellLightProduction.magnitudes_7527,
    `D1Bound5.PellLightProduction.magnitudes_7535,
    `D1Bound5.PellLightProduction.magnitudes_7543,
    `D1Bound5.PellLightProduction.checked_7415,
    `D1Bound5.PellLightProduction.checked_7423,
    `D1Bound5.PellLightProduction.checked_7431,
    `D1Bound5.PellLightProduction.checked_7439,
    `D1Bound5.PellLightProduction.checked_7447,
    `D1Bound5.PellLightProduction.checked_7455,
    `D1Bound5.PellLightProduction.checked_7463,
    `D1Bound5.PellLightProduction.checked_7471,
    `D1Bound5.PellLightProduction.checked_7487,
    `D1Bound5.PellLightProduction.checked_7495,
    `D1Bound5.PellLightProduction.checked_7503,
    `D1Bound5.PellLightProduction.checked_7511,
    `D1Bound5.PellLightProduction.checked_7519,
    `D1Bound5.PellLightProduction.checked_7527,
    `D1Bound5.PellLightProduction.checked_7535,
    `D1Bound5.PellLightProduction.checked_7543,
    `D1Bound5.PellLightProduction.magnitudes_7559,
    `D1Bound5.PellLightProduction.magnitudes_7567,
    `D1Bound5.PellLightProduction.magnitudes_7583,
    `D1Bound5.PellLightProduction.magnitudes_7591,
    `D1Bound5.PellLightProduction.magnitudes_7599,
    `D1Bound5.PellLightProduction.magnitudes_7607,
    `D1Bound5.PellLightProduction.magnitudes_7615,
    `D1Bound5.PellLightProduction.magnitudes_7631,
    `D1Bound5.PellLightProduction.magnitudes_7639,
    `D1Bound5.PellLightProduction.magnitudes_7647,
    `D1Bound5.PellLightProduction.magnitudes_7655,
    `D1Bound5.PellLightProduction.magnitudes_7663,
    `D1Bound5.PellLightProduction.magnitudes_7671,
    `D1Bound5.PellLightProduction.magnitudes_7679,
    `D1Bound5.PellLightProduction.magnitudes_7687,
    `D1Bound5.PellLightProduction.magnitudes_7703,
    `D1Bound5.PellLightProduction.checked_7559,
    `D1Bound5.PellLightProduction.checked_7567,
    `D1Bound5.PellLightProduction.checked_7583,
    `D1Bound5.PellLightProduction.checked_7591,
    `D1Bound5.PellLightProduction.checked_7599,
    `D1Bound5.PellLightProduction.checked_7607,
    `D1Bound5.PellLightProduction.checked_7615,
    `D1Bound5.PellLightProduction.checked_7631,
    `D1Bound5.PellLightProduction.checked_7639,
    `D1Bound5.PellLightProduction.checked_7647,
    `D1Bound5.PellLightProduction.checked_7655,
    `D1Bound5.PellLightProduction.checked_7663,
    `D1Bound5.PellLightProduction.checked_7671,
    `D1Bound5.PellLightProduction.checked_7679,
    `D1Bound5.PellLightProduction.checked_7687,
    `D1Bound5.PellLightProduction.checked_7703,
    `D1Bound5.PellLightProduction.magnitudes_7711,
    `D1Bound5.PellLightProduction.magnitudes_7719,
    `D1Bound5.PellLightProduction.magnitudes_7727,
    `D1Bound5.PellLightProduction.magnitudes_7735,
    `D1Bound5.PellLightProduction.magnitudes_7743,
    `D1Bound5.PellLightProduction.magnitudes_7751,
    `D1Bound5.PellLightProduction.magnitudes_7759,
    `D1Bound5.PellLightProduction.magnitudes_7783,
    `D1Bound5.PellLightProduction.magnitudes_7799,
    `D1Bound5.PellLightProduction.magnitudes_7807,
    `D1Bound5.PellLightProduction.magnitudes_7815,
    `D1Bound5.PellLightProduction.magnitudes_7823,
    `D1Bound5.PellLightProduction.magnitudes_7831,
    `D1Bound5.PellLightProduction.magnitudes_7847,
    `D1Bound5.PellLightProduction.magnitudes_7855,
    `D1Bound5.PellLightProduction.magnitudes_7863,
    `D1Bound5.PellLightProduction.checked_7711,
    `D1Bound5.PellLightProduction.checked_7719,
    `D1Bound5.PellLightProduction.checked_7727,
    `D1Bound5.PellLightProduction.checked_7735,
    `D1Bound5.PellLightProduction.checked_7743,
    `D1Bound5.PellLightProduction.checked_7751,
    `D1Bound5.PellLightProduction.checked_7759,
    `D1Bound5.PellLightProduction.checked_7783,
    `D1Bound5.PellLightProduction.checked_7799,
    `D1Bound5.PellLightProduction.checked_7807,
    `D1Bound5.PellLightProduction.checked_7815,
    `D1Bound5.PellLightProduction.checked_7823,
    `D1Bound5.PellLightProduction.checked_7831,
    `D1Bound5.PellLightProduction.checked_7847,
    `D1Bound5.PellLightProduction.checked_7855,
    `D1Bound5.PellLightProduction.checked_7863,
    `D1Bound5.PellLightProduction.magnitudes_7871,
    `D1Bound5.PellLightProduction.magnitudes_7879,
    `D1Bound5.PellLightProduction.magnitudes_7887,
    `D1Bound5.PellLightProduction.magnitudes_7895,
    `D1Bound5.PellLightProduction.magnitudes_7903,
    `D1Bound5.PellLightProduction.magnitudes_7919,
    `D1Bound5.PellLightProduction.magnitudes_7927,
    `D1Bound5.PellLightProduction.magnitudes_7951,
    `D1Bound5.PellLightProduction.magnitudes_7959,
    `D1Bound5.PellLightProduction.magnitudes_7967,
    `D1Bound5.PellLightProduction.magnitudes_7991,
    `D1Bound5.PellLightProduction.magnitudes_7999,
    `D1Bound5.PellLightProduction.magnitudes_8007,
    `D1Bound5.PellLightProduction.magnitudes_8015,
    `D1Bound5.PellLightProduction.magnitudes_8023,
    `D1Bound5.PellLightProduction.magnitudes_8031,
    `D1Bound5.PellLightProduction.checked_7871,
    `D1Bound5.PellLightProduction.checked_7879,
    `D1Bound5.PellLightProduction.checked_7887,
    `D1Bound5.PellLightProduction.checked_7895,
    `D1Bound5.PellLightProduction.checked_7903,
    `D1Bound5.PellLightProduction.checked_7919,
    `D1Bound5.PellLightProduction.checked_7927,
    `D1Bound5.PellLightProduction.checked_7951,
    `D1Bound5.PellLightProduction.checked_7959,
    `D1Bound5.PellLightProduction.checked_7967,
    `D1Bound5.PellLightProduction.checked_7991,
    `D1Bound5.PellLightProduction.checked_7999,
    `D1Bound5.PellLightProduction.checked_8007,
    `D1Bound5.PellLightProduction.checked_8015,
    `D1Bound5.PellLightProduction.checked_8023,
    `D1Bound5.PellLightProduction.checked_8031,
    `D1Bound5.PellLightProduction.magnitudes_8039,
    `D1Bound5.PellLightProduction.magnitudes_8047,
    `D1Bound5.PellLightProduction.magnitudes_8063,
    `D1Bound5.PellLightProduction.magnitudes_8071,
    `D1Bound5.PellLightProduction.magnitudes_8079,
    `D1Bound5.PellLightProduction.magnitudes_8087,
    `D1Bound5.PellLightProduction.magnitudes_8095,
    `D1Bound5.PellLightProduction.magnitudes_8103,
    `D1Bound5.PellLightProduction.magnitudes_8111,
    `D1Bound5.PellLightProduction.magnitudes_8119,
    `D1Bound5.PellLightProduction.magnitudes_8135,
    `D1Bound5.PellLightProduction.magnitudes_8143,
    `D1Bound5.PellLightProduction.magnitudes_8151,
    `D1Bound5.PellLightProduction.magnitudes_8159,
    `D1Bound5.PellLightProduction.magnitudes_8167,
    `D1Bound5.PellLightProduction.magnitudes_8191,
    `D1Bound5.PellLightProduction.checked_8039,
    `D1Bound5.PellLightProduction.checked_8047,
    `D1Bound5.PellLightProduction.checked_8063,
    `D1Bound5.PellLightProduction.checked_8071,
    `D1Bound5.PellLightProduction.checked_8079,
    `D1Bound5.PellLightProduction.checked_8087,
    `D1Bound5.PellLightProduction.checked_8095,
    `D1Bound5.PellLightProduction.checked_8103,
    `D1Bound5.PellLightProduction.checked_8111,
    `D1Bound5.PellLightProduction.checked_8119,
    `D1Bound5.PellLightProduction.checked_8135,
    `D1Bound5.PellLightProduction.checked_8143,
    `D1Bound5.PellLightProduction.checked_8151,
    `D1Bound5.PellLightProduction.checked_8159,
    `D1Bound5.PellLightProduction.checked_8167,
    `D1Bound5.PellLightProduction.checked_8191,
    `D1Bound5.PellLightProduction.magnitudes_8207,
    `D1Bound5.PellLightProduction.magnitudes_8215,
    `D1Bound5.PellLightProduction.magnitudes_8223,
    `D1Bound5.PellLightProduction.magnitudes_8231,
    `D1Bound5.PellLightProduction.magnitudes_8239,
    `D1Bound5.PellLightProduction.magnitudes_8247,
    `D1Bound5.PellLightProduction.magnitudes_8255,
    `D1Bound5.PellLightProduction.magnitudes_8263,
    `D1Bound5.PellLightProduction.magnitudes_8279,
    `D1Bound5.PellLightProduction.magnitudes_8287,
    `D1Bound5.PellLightProduction.magnitudes_8295,
    `D1Bound5.PellLightProduction.magnitudes_8311,
    `D1Bound5.PellLightProduction.magnitudes_8319,
    `D1Bound5.PellLightProduction.magnitudes_8327,
    `D1Bound5.PellLightProduction.magnitudes_8335,
    `D1Bound5.PellLightProduction.magnitudes_8351,
    `D1Bound5.PellLightProduction.checked_8207,
    `D1Bound5.PellLightProduction.checked_8215,
    `D1Bound5.PellLightProduction.checked_8223,
    `D1Bound5.PellLightProduction.checked_8231,
    `D1Bound5.PellLightProduction.checked_8239,
    `D1Bound5.PellLightProduction.checked_8247,
    `D1Bound5.PellLightProduction.checked_8255,
    `D1Bound5.PellLightProduction.checked_8263,
    `D1Bound5.PellLightProduction.checked_8279,
    `D1Bound5.PellLightProduction.checked_8287,
    `D1Bound5.PellLightProduction.checked_8295,
    `D1Bound5.PellLightProduction.checked_8311,
    `D1Bound5.PellLightProduction.checked_8319,
    `D1Bound5.PellLightProduction.checked_8327,
    `D1Bound5.PellLightProduction.checked_8335,
    `D1Bound5.PellLightProduction.checked_8351,
    `D1Bound5.PellLightProduction.magnitudes_8359,
    `D1Bound5.PellLightProduction.magnitudes_8367,
    `D1Bound5.PellLightProduction.magnitudes_8383,
    `D1Bound5.PellLightProduction.magnitudes_8391,
    `D1Bound5.PellLightProduction.magnitudes_8399,
    `D1Bound5.PellLightProduction.magnitudes_8407,
    `D1Bound5.PellLightProduction.magnitudes_8423,
    `D1Bound5.PellLightProduction.magnitudes_8431,
    `D1Bound5.PellLightProduction.magnitudes_8439,
    `D1Bound5.PellLightProduction.magnitudes_8447,
    `D1Bound5.PellLightProduction.magnitudes_8455,
    `D1Bound5.PellLightProduction.magnitudes_8463,
    `D1Bound5.PellLightProduction.magnitudes_8471,
    `D1Bound5.PellLightProduction.magnitudes_8479,
    `D1Bound5.PellLightProduction.magnitudes_8495,
    `D1Bound5.PellLightProduction.magnitudes_8503,
    `D1Bound5.PellLightProduction.checked_8359,
    `D1Bound5.PellLightProduction.checked_8367,
    `D1Bound5.PellLightProduction.checked_8383,
    `D1Bound5.PellLightProduction.checked_8391,
    `D1Bound5.PellLightProduction.checked_8399,
    `D1Bound5.PellLightProduction.checked_8407,
    `D1Bound5.PellLightProduction.checked_8423,
    `D1Bound5.PellLightProduction.checked_8431,
    `D1Bound5.PellLightProduction.checked_8439,
    `D1Bound5.PellLightProduction.checked_8447,
    `D1Bound5.PellLightProduction.checked_8455,
    `D1Bound5.PellLightProduction.checked_8463,
    `D1Bound5.PellLightProduction.checked_8471,
    `D1Bound5.PellLightProduction.checked_8479,
    `D1Bound5.PellLightProduction.checked_8495,
    `D1Bound5.PellLightProduction.checked_8503,
    `D1Bound5.PellLightProduction.magnitudes_8511,
    `D1Bound5.PellLightProduction.magnitudes_8519,
    `D1Bound5.PellLightProduction.magnitudes_8527,
    `D1Bound5.PellLightProduction.magnitudes_8535,
    `D1Bound5.PellLightProduction.magnitudes_8543,
    `D1Bound5.PellLightProduction.magnitudes_8551,
    `D1Bound5.PellLightProduction.magnitudes_8567,
    `D1Bound5.PellLightProduction.magnitudes_8583,
    `D1Bound5.PellLightProduction.magnitudes_8599,
    `D1Bound5.PellLightProduction.magnitudes_8607,
    `D1Bound5.PellLightProduction.magnitudes_8615,
    `D1Bound5.PellLightProduction.magnitudes_8623,
    `D1Bound5.PellLightProduction.magnitudes_8639,
    `D1Bound5.PellLightProduction.magnitudes_8647,
    `D1Bound5.PellLightProduction.magnitudes_8655,
    `D1Bound5.PellLightProduction.magnitudes_8663,
    `D1Bound5.PellLightProduction.checked_8511,
    `D1Bound5.PellLightProduction.checked_8519,
    `D1Bound5.PellLightProduction.checked_8527,
    `D1Bound5.PellLightProduction.checked_8535,
    `D1Bound5.PellLightProduction.checked_8543,
    `D1Bound5.PellLightProduction.checked_8551,
    `D1Bound5.PellLightProduction.checked_8567,
    `D1Bound5.PellLightProduction.checked_8583,
    `D1Bound5.PellLightProduction.checked_8599,
    `D1Bound5.PellLightProduction.checked_8607,
    `D1Bound5.PellLightProduction.checked_8615,
    `D1Bound5.PellLightProduction.checked_8623,
    `D1Bound5.PellLightProduction.checked_8639,
    `D1Bound5.PellLightProduction.checked_8647,
    `D1Bound5.PellLightProduction.checked_8655,
    `D1Bound5.PellLightProduction.checked_8663,
    `D1Bound5.PellLightProduction.magnitudes_8671,
    `D1Bound5.PellLightProduction.magnitudes_8679,
    `D1Bound5.PellLightProduction.magnitudes_8687,
    `D1Bound5.PellLightProduction.magnitudes_8695,
    `D1Bound5.PellLightProduction.magnitudes_8711,
    `D1Bound5.PellLightProduction.magnitudes_8719,
    `D1Bound5.PellLightProduction.magnitudes_8727,
    `D1Bound5.PellLightProduction.magnitudes_8735,
    `D1Bound5.PellLightProduction.magnitudes_8743,
    `D1Bound5.PellLightProduction.magnitudes_8751,
    `D1Bound5.PellLightProduction.magnitudes_8759,
    `D1Bound5.PellLightProduction.magnitudes_8767,
    `D1Bound5.PellLightProduction.magnitudes_8783,
    `D1Bound5.PellLightProduction.magnitudes_8791,
    `D1Bound5.PellLightProduction.magnitudes_8799,
    `D1Bound5.PellLightProduction.magnitudes_8807,
    `D1Bound5.PellLightProduction.checked_8671,
    `D1Bound5.PellLightProduction.checked_8679,
    `D1Bound5.PellLightProduction.checked_8687,
    `D1Bound5.PellLightProduction.checked_8695,
    `D1Bound5.PellLightProduction.checked_8711,
    `D1Bound5.PellLightProduction.checked_8719,
    `D1Bound5.PellLightProduction.checked_8727,
    `D1Bound5.PellLightProduction.checked_8735,
    `D1Bound5.PellLightProduction.checked_8743,
    `D1Bound5.PellLightProduction.checked_8751,
    `D1Bound5.PellLightProduction.checked_8759,
    `D1Bound5.PellLightProduction.checked_8767,
    `D1Bound5.PellLightProduction.checked_8783,
    `D1Bound5.PellLightProduction.checked_8791,
    `D1Bound5.PellLightProduction.checked_8799,
    `D1Bound5.PellLightProduction.checked_8807,
    `D1Bound5.PellLightProduction.magnitudes_8815,
    `D1Bound5.PellLightProduction.magnitudes_8823,
    `D1Bound5.PellLightProduction.magnitudes_8831,
    `D1Bound5.PellLightProduction.magnitudes_8839,
    `D1Bound5.PellLightProduction.magnitudes_8855,
    `D1Bound5.PellLightProduction.magnitudes_8863,
    `D1Bound5.PellLightProduction.magnitudes_8871,
    `D1Bound5.PellLightProduction.magnitudes_8879,
    `D1Bound5.PellLightProduction.magnitudes_8887,
    `D1Bound5.PellLightProduction.magnitudes_8895,
    `D1Bound5.PellLightProduction.magnitudes_8903,
    `D1Bound5.PellLightProduction.magnitudes_8911,
    `D1Bound5.PellLightProduction.magnitudes_8927,
    `D1Bound5.PellLightProduction.magnitudes_8935,
    `D1Bound5.PellLightProduction.magnitudes_8943,
    `D1Bound5.PellLightProduction.magnitudes_8951,
    `D1Bound5.PellLightProduction.checked_8815,
    `D1Bound5.PellLightProduction.checked_8823,
    `D1Bound5.PellLightProduction.checked_8831,
    `D1Bound5.PellLightProduction.checked_8839,
    `D1Bound5.PellLightProduction.checked_8855,
    `D1Bound5.PellLightProduction.checked_8863,
    `D1Bound5.PellLightProduction.checked_8871,
    `D1Bound5.PellLightProduction.checked_8879,
    `D1Bound5.PellLightProduction.checked_8887,
    `D1Bound5.PellLightProduction.checked_8895,
    `D1Bound5.PellLightProduction.checked_8903,
    `D1Bound5.PellLightProduction.checked_8911,
    `D1Bound5.PellLightProduction.checked_8927,
    `D1Bound5.PellLightProduction.checked_8935,
    `D1Bound5.PellLightProduction.checked_8943,
    `D1Bound5.PellLightProduction.checked_8951,
    `D1Bound5.PellLightProduction.magnitudes_8983,
    `D1Bound5.PellLightProduction.magnitudes_8999,
    `D1Bound5.PellLightProduction.magnitudes_9007,
    `D1Bound5.PellLightProduction.magnitudes_9015,
    `D1Bound5.PellLightProduction.magnitudes_9023,
    `D1Bound5.PellLightProduction.magnitudes_9031,
    `D1Bound5.PellLightProduction.magnitudes_9039,
    `D1Bound5.PellLightProduction.magnitudes_9047,
    `D1Bound5.PellLightProduction.magnitudes_9055,
    `D1Bound5.PellLightProduction.magnitudes_9071,
    `D1Bound5.PellLightProduction.magnitudes_9079,
    `D1Bound5.PellLightProduction.magnitudes_9087,
    `D1Bound5.PellLightProduction.magnitudes_9095,
    `D1Bound5.PellLightProduction.magnitudes_9103,
    `D1Bound5.PellLightProduction.magnitudes_9111,
    `D1Bound5.PellLightProduction.magnitudes_9119,
    `D1Bound5.PellLightProduction.checked_8983,
    `D1Bound5.PellLightProduction.checked_8999,
    `D1Bound5.PellLightProduction.checked_9007,
    `D1Bound5.PellLightProduction.checked_9015,
    `D1Bound5.PellLightProduction.checked_9023,
    `D1Bound5.PellLightProduction.checked_9031,
    `D1Bound5.PellLightProduction.checked_9039,
    `D1Bound5.PellLightProduction.checked_9047,
    `D1Bound5.PellLightProduction.checked_9055,
    `D1Bound5.PellLightProduction.checked_9071,
    `D1Bound5.PellLightProduction.checked_9079,
    `D1Bound5.PellLightProduction.checked_9087,
    `D1Bound5.PellLightProduction.checked_9095,
    `D1Bound5.PellLightProduction.checked_9103,
    `D1Bound5.PellLightProduction.checked_9111,
    `D1Bound5.PellLightProduction.checked_9119,
    `D1Bound5.PellLightProduction.magnitudes_9127,
    `D1Bound5.PellLightProduction.magnitudes_9143,
    `D1Bound5.PellLightProduction.magnitudes_9151,
    `D1Bound5.PellLightProduction.magnitudes_9159,
    `D1Bound5.PellLightProduction.magnitudes_9167,
    `D1Bound5.PellLightProduction.magnitudes_9183,
    `D1Bound5.PellLightProduction.magnitudes_9191,
    `D1Bound5.PellLightProduction.magnitudes_9199,
    `D1Bound5.PellLightProduction.magnitudes_9215,
    `D1Bound5.PellLightProduction.magnitudes_9223,
    `D1Bound5.PellLightProduction.magnitudes_9231,
    `D1Bound5.PellLightProduction.magnitudes_9239,
    `D1Bound5.PellLightProduction.magnitudes_9247,
    `D1Bound5.PellLightProduction.magnitudes_9255,
    `D1Bound5.PellLightProduction.magnitudes_9263,
    `D1Bound5.PellLightProduction.magnitudes_9271,
    `D1Bound5.PellLightProduction.checked_9127,
    `D1Bound5.PellLightProduction.checked_9143,
    `D1Bound5.PellLightProduction.checked_9151,
    `D1Bound5.PellLightProduction.checked_9159,
    `D1Bound5.PellLightProduction.checked_9167,
    `D1Bound5.PellLightProduction.checked_9183,
    `D1Bound5.PellLightProduction.checked_9191,
    `D1Bound5.PellLightProduction.checked_9199,
    `D1Bound5.PellLightProduction.checked_9215,
    `D1Bound5.PellLightProduction.checked_9223,
    `D1Bound5.PellLightProduction.checked_9231,
    `D1Bound5.PellLightProduction.checked_9239,
    `D1Bound5.PellLightProduction.checked_9247,
    `D1Bound5.PellLightProduction.checked_9255,
    `D1Bound5.PellLightProduction.checked_9263,
    `D1Bound5.PellLightProduction.checked_9271,
    `D1Bound5.PellLightProduction.magnitudes_9287,
    `D1Bound5.PellLightProduction.magnitudes_9303,
    `D1Bound5.PellLightProduction.magnitudes_9311,
    `D1Bound5.PellLightProduction.magnitudes_9319,
    `D1Bound5.PellLightProduction.magnitudes_9327,
    `D1Bound5.PellLightProduction.magnitudes_9335,
    `D1Bound5.PellLightProduction.magnitudes_9343,
    `D1Bound5.PellLightProduction.magnitudes_9367,
    `D1Bound5.PellLightProduction.magnitudes_9383,
    `D1Bound5.PellLightProduction.magnitudes_9391,
    `D1Bound5.PellLightProduction.magnitudes_9399,
    `D1Bound5.PellLightProduction.magnitudes_9407,
    `D1Bound5.PellLightProduction.magnitudes_9415,
    `D1Bound5.PellLightProduction.magnitudes_9431,
    `D1Bound5.PellLightProduction.magnitudes_9439,
    `D1Bound5.PellLightProduction.magnitudes_9447,
    `D1Bound5.PellLightProduction.checked_9287,
    `D1Bound5.PellLightProduction.checked_9303,
    `D1Bound5.PellLightProduction.checked_9311,
    `D1Bound5.PellLightProduction.checked_9319,
    `D1Bound5.PellLightProduction.checked_9327,
    `D1Bound5.PellLightProduction.checked_9335,
    `D1Bound5.PellLightProduction.checked_9343,
    `D1Bound5.PellLightProduction.checked_9367,
    `D1Bound5.PellLightProduction.checked_9383,
    `D1Bound5.PellLightProduction.checked_9391,
    `D1Bound5.PellLightProduction.checked_9399,
    `D1Bound5.PellLightProduction.checked_9407,
    `D1Bound5.PellLightProduction.checked_9415,
    `D1Bound5.PellLightProduction.checked_9431,
    `D1Bound5.PellLightProduction.checked_9439,
    `D1Bound5.PellLightProduction.checked_9447,
    `D1Bound5.PellLightProduction.magnitudes_9455,
    `D1Bound5.PellLightProduction.magnitudes_9463,
    `D1Bound5.PellLightProduction.magnitudes_9471,
    `D1Bound5.PellLightProduction.magnitudes_9479,
    `D1Bound5.PellLightProduction.magnitudes_9487,
    `D1Bound5.PellLightProduction.magnitudes_9503,
    `D1Bound5.PellLightProduction.magnitudes_9511,
    `D1Bound5.PellLightProduction.magnitudes_9519,
    `D1Bound5.PellLightProduction.magnitudes_9527,
    `D1Bound5.PellLightProduction.magnitudes_9535,
    `D1Bound5.PellLightProduction.magnitudes_9543,
    `D1Bound5.PellLightProduction.magnitudes_9551,
    `D1Bound5.PellLightProduction.magnitudes_9591,
    `D1Bound5.PellLightProduction.magnitudes_9599,
    `D1Bound5.PellLightProduction.magnitudes_9607,
    `D1Bound5.PellLightProduction.magnitudes_9615,
    `D1Bound5.PellLightProduction.checked_9455,
    `D1Bound5.PellLightProduction.checked_9463,
    `D1Bound5.PellLightProduction.checked_9471,
    `D1Bound5.PellLightProduction.checked_9479,
    `D1Bound5.PellLightProduction.checked_9487,
    `D1Bound5.PellLightProduction.checked_9503,
    `D1Bound5.PellLightProduction.checked_9511,
    `D1Bound5.PellLightProduction.checked_9519,
    `D1Bound5.PellLightProduction.checked_9527,
    `D1Bound5.PellLightProduction.checked_9535,
    `D1Bound5.PellLightProduction.checked_9543,
    `D1Bound5.PellLightProduction.checked_9551,
    `D1Bound5.PellLightProduction.checked_9591,
    `D1Bound5.PellLightProduction.checked_9599,
    `D1Bound5.PellLightProduction.checked_9607,
    `D1Bound5.PellLightProduction.checked_9615,
    `D1Bound5.PellLightProduction.magnitudes_9623,
    `D1Bound5.PellLightProduction.magnitudes_9631,
    `D1Bound5.PellLightProduction.magnitudes_9647,
    `D1Bound5.PellLightProduction.magnitudes_9655,
    `D1Bound5.PellLightProduction.magnitudes_9663,
    `D1Bound5.PellLightProduction.magnitudes_9671,
    `D1Bound5.PellLightProduction.magnitudes_9679,
    `D1Bound5.PellLightProduction.magnitudes_9687,
    `D1Bound5.PellLightProduction.magnitudes_9695,
    `D1Bound5.PellLightProduction.magnitudes_9703,
    `D1Bound5.PellLightProduction.magnitudes_9719,
    `D1Bound5.PellLightProduction.magnitudes_9727,
    `D1Bound5.PellLightProduction.magnitudes_9735,
    `D1Bound5.PellLightProduction.magnitudes_9743,
    `D1Bound5.PellLightProduction.magnitudes_9759,
    `D1Bound5.PellLightProduction.magnitudes_9767,
    `D1Bound5.PellLightProduction.checked_9623,
    `D1Bound5.PellLightProduction.checked_9631,
    `D1Bound5.PellLightProduction.checked_9647,
    `D1Bound5.PellLightProduction.checked_9655,
    `D1Bound5.PellLightProduction.checked_9663,
    `D1Bound5.PellLightProduction.checked_9671,
    `D1Bound5.PellLightProduction.checked_9679,
    `D1Bound5.PellLightProduction.checked_9687,
    `D1Bound5.PellLightProduction.checked_9695,
    `D1Bound5.PellLightProduction.checked_9703,
    `D1Bound5.PellLightProduction.checked_9719,
    `D1Bound5.PellLightProduction.checked_9727,
    `D1Bound5.PellLightProduction.checked_9735,
    `D1Bound5.PellLightProduction.checked_9743,
    `D1Bound5.PellLightProduction.checked_9759,
    `D1Bound5.PellLightProduction.checked_9767,
    `D1Bound5.PellLightProduction.magnitudes_9791,
    `D1Bound5.PellLightProduction.magnitudes_9799,
    `D1Bound5.PellLightProduction.magnitudes_9807,
    `D1Bound5.PellLightProduction.magnitudes_9815,
    `D1Bound5.PellLightProduction.magnitudes_9823,
    `D1Bound5.PellLightProduction.magnitudes_9831,
    `D1Bound5.PellLightProduction.magnitudes_9839,
    `D1Bound5.PellLightProduction.magnitudes_9847,
    `D1Bound5.PellLightProduction.magnitudes_9863,
    `D1Bound5.PellLightProduction.magnitudes_9871,
    `D1Bound5.PellLightProduction.magnitudes_9879,
    `D1Bound5.PellLightProduction.magnitudes_9887,
    `D1Bound5.PellLightProduction.magnitudes_9895,
    `D1Bound5.PellLightProduction.magnitudes_9903,
    `D1Bound5.PellLightProduction.magnitudes_9911,
    `D1Bound5.PellLightProduction.magnitudes_9919,
    `D1Bound5.PellLightProduction.checked_9791,
    `D1Bound5.PellLightProduction.checked_9799,
    `D1Bound5.PellLightProduction.checked_9807,
    `D1Bound5.PellLightProduction.checked_9815,
    `D1Bound5.PellLightProduction.checked_9823,
    `D1Bound5.PellLightProduction.checked_9831,
    `D1Bound5.PellLightProduction.checked_9839,
    `D1Bound5.PellLightProduction.checked_9847,
    `D1Bound5.PellLightProduction.checked_9863,
    `D1Bound5.PellLightProduction.checked_9871,
    `D1Bound5.PellLightProduction.checked_9879,
    `D1Bound5.PellLightProduction.checked_9887,
    `D1Bound5.PellLightProduction.checked_9895,
    `D1Bound5.PellLightProduction.checked_9903,
    `D1Bound5.PellLightProduction.checked_9911,
    `D1Bound5.PellLightProduction.checked_9919,
    `D1Bound5.PellLightProduction.magnitudes_9935,
    `D1Bound5.PellLightProduction.magnitudes_9943,
    `D1Bound5.PellLightProduction.magnitudes_9951,
    `D1Bound5.PellLightProduction.magnitudes_9959,
    `D1Bound5.PellLightProduction.magnitudes_9967,
    `D1Bound5.PellLightProduction.magnitudes_9983,
    `D1Bound5.PellLightProduction.magnitudes_9991,
    `D1Bound5.PellLightProduction.checked_9935,
    `D1Bound5.PellLightProduction.checked_9943,
    `D1Bound5.PellLightProduction.checked_9951,
    `D1Bound5.PellLightProduction.checked_9959,
    `D1Bound5.PellLightProduction.checked_9967,
    `D1Bound5.PellLightProduction.checked_9983,
    `D1Bound5.PellLightProduction.checked_9991]
  for name in names do
    let axs ← Lean.collectAxioms name
    let other := axs.filter fun x => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains x
    unless other.isEmpty do
      throwError "Unexpected axioms in {name}: {other}"
    logInfo m!"PELL_COMPLETE_AXIOMS_PASS {name}: {axs}"

namespace D1Bound5.PellMatchingLightProduction
#check D1Bound5.PellMatchingLightProduction.pellMagnitudes_359
#check D1Bound5.PellMatchingLightProduction.pellMasks_359
#check D1Bound5.PellMatchingLightProduction.pellWitnesses_359
#check D1Bound5.PellMatchingLightProduction.pellMasks_359_valid
example : (pellMasks_359.all fun m => m.validBool 359) = true := D1Bound5.PellMatchingLightProduction.pellMasks_359_valid
#check D1Bound5.PellMatchingLightProduction.pellMatching_359_checked
example : pellLightMatchingCheck pellMasks_359 pellMagnitudes_359 pellWitnesses_359 = true := D1Bound5.PellMatchingLightProduction.pellMatching_359_checked
#check D1Bound5.PellMatchingLightProduction.pellMagnitudes_359_large
example : (pellMagnitudes_359.all fun x => decide (2 ≤ x)) = true := D1Bound5.PellMatchingLightProduction.pellMagnitudes_359_large
end

namespace D1Bound5.PellMatchingLightProduction
#check D1Bound5.PellMatchingLightProduction.pellMagnitudes_367
#check D1Bound5.PellMatchingLightProduction.pellMasks_367
#check D1Bound5.PellMatchingLightProduction.pellWitnesses_367
#check D1Bound5.PellMatchingLightProduction.pellMasks_367_valid
example : (pellMasks_367.all fun m => m.validBool 367) = true := D1Bound5.PellMatchingLightProduction.pellMasks_367_valid
#check D1Bound5.PellMatchingLightProduction.pellMatching_367_checked
example : pellLightMatchingCheck pellMasks_367 pellMagnitudes_367 pellWitnesses_367 = true := D1Bound5.PellMatchingLightProduction.pellMatching_367_checked
#check D1Bound5.PellMatchingLightProduction.pellMagnitudes_367_large
example : (pellMagnitudes_367.all fun x => decide (2 ≤ x)) = true := D1Bound5.PellMatchingLightProduction.pellMagnitudes_367_large
end

namespace D1Bound5.PellMatchingLightProduction
#check D1Bound5.PellMatchingLightProduction.pellMagnitudes_383
#check D1Bound5.PellMatchingLightProduction.pellMasks_383
#check D1Bound5.PellMatchingLightProduction.pellWitnesses_383
#check D1Bound5.PellMatchingLightProduction.pellMasks_383_valid
example : (pellMasks_383.all fun m => m.validBool 383) = true := D1Bound5.PellMatchingLightProduction.pellMasks_383_valid
#check D1Bound5.PellMatchingLightProduction.pellMatching_383_checked
example : pellLightMatchingCheck pellMasks_383 pellMagnitudes_383 pellWitnesses_383 = true := D1Bound5.PellMatchingLightProduction.pellMatching_383_checked
#check D1Bound5.PellMatchingLightProduction.pellMagnitudes_383_large
example : (pellMagnitudes_383.all fun x => decide (2 ≤ x)) = true := D1Bound5.PellMatchingLightProduction.pellMagnitudes_383_large
end

namespace D1Bound5.PellMatchingLightProduction
#check D1Bound5.PellMatchingLightProduction.pellMagnitudes_391
#check D1Bound5.PellMatchingLightProduction.pellMasks_391
#check D1Bound5.PellMatchingLightProduction.pellWitnesses_391
#check D1Bound5.PellMatchingLightProduction.pellMasks_391_valid
example : (pellMasks_391.all fun m => m.validBool 391) = true := D1Bound5.PellMatchingLightProduction.pellMasks_391_valid
#check D1Bound5.PellMatchingLightProduction.pellMatching_391_checked
example : pellLightMatchingCheck pellMasks_391 pellMagnitudes_391 pellWitnesses_391 = true := D1Bound5.PellMatchingLightProduction.pellMatching_391_checked
#check D1Bound5.PellMatchingLightProduction.pellMagnitudes_391_large
example : (pellMagnitudes_391.all fun x => decide (2 ≤ x)) = true := D1Bound5.PellMatchingLightProduction.pellMagnitudes_391_large
end

namespace D1Bound5.PellMatchingLightProduction
#check D1Bound5.PellMatchingLightProduction.pellMagnitudes_431
#check D1Bound5.PellMatchingLightProduction.pellMasks_431
#check D1Bound5.PellMatchingLightProduction.pellWitnesses_431
#check D1Bound5.PellMatchingLightProduction.pellMasks_431_valid
example : (pellMasks_431.all fun m => m.validBool 431) = true := D1Bound5.PellMatchingLightProduction.pellMasks_431_valid
#check D1Bound5.PellMatchingLightProduction.pellMatching_431_checked
example : pellLightMatchingCheck pellMasks_431 pellMagnitudes_431 pellWitnesses_431 = true := D1Bound5.PellMatchingLightProduction.pellMatching_431_checked
#check D1Bound5.PellMatchingLightProduction.pellMagnitudes_431_large
example : (pellMagnitudes_431.all fun x => decide (2 ≤ x)) = true := D1Bound5.PellMatchingLightProduction.pellMagnitudes_431_large
end

namespace D1Bound5.PellMatchingLightProduction
#check D1Bound5.PellMatchingLightProduction.pellMagnitudes_439
#check D1Bound5.PellMatchingLightProduction.pellMasks_439
#check D1Bound5.PellMatchingLightProduction.pellWitnesses_439
#check D1Bound5.PellMatchingLightProduction.pellMasks_439_valid
example : (pellMasks_439.all fun m => m.validBool 439) = true := D1Bound5.PellMatchingLightProduction.pellMasks_439_valid
#check D1Bound5.PellMatchingLightProduction.pellMatching_439_checked
example : pellLightMatchingCheck pellMasks_439 pellMagnitudes_439 pellWitnesses_439 = true := D1Bound5.PellMatchingLightProduction.pellMatching_439_checked
#check D1Bound5.PellMatchingLightProduction.pellMagnitudes_439_large
example : (pellMagnitudes_439.all fun x => decide (2 ≤ x)) = true := D1Bound5.PellMatchingLightProduction.pellMagnitudes_439_large
end

namespace D1Bound5.PellMatchingLightProduction
#check D1Bound5.PellMatchingLightProduction.pellMagnitudes_463
#check D1Bound5.PellMatchingLightProduction.pellMasks_463
#check D1Bound5.PellMatchingLightProduction.pellWitnesses_463
#check D1Bound5.PellMatchingLightProduction.pellMasks_463_valid
example : (pellMasks_463.all fun m => m.validBool 463) = true := D1Bound5.PellMatchingLightProduction.pellMasks_463_valid
#check D1Bound5.PellMatchingLightProduction.pellMatching_463_checked
example : pellLightMatchingCheck pellMasks_463 pellMagnitudes_463 pellWitnesses_463 = true := D1Bound5.PellMatchingLightProduction.pellMatching_463_checked
#check D1Bound5.PellMatchingLightProduction.pellMagnitudes_463_large
example : (pellMagnitudes_463.all fun x => decide (2 ≤ x)) = true := D1Bound5.PellMatchingLightProduction.pellMagnitudes_463_large
end

namespace D1Bound5.PellMatchingLightProduction
#check D1Bound5.PellMatchingLightProduction.pellMagnitudes_479
#check D1Bound5.PellMatchingLightProduction.pellMasks_479
#check D1Bound5.PellMatchingLightProduction.pellWitnesses_479
#check D1Bound5.PellMatchingLightProduction.pellMasks_479_valid
example : (pellMasks_479.all fun m => m.validBool 479) = true := D1Bound5.PellMatchingLightProduction.pellMasks_479_valid
#check D1Bound5.PellMatchingLightProduction.pellMatching_479_checked
example : pellLightMatchingCheck pellMasks_479 pellMagnitudes_479 pellWitnesses_479 = true := D1Bound5.PellMatchingLightProduction.pellMatching_479_checked
#check D1Bound5.PellMatchingLightProduction.pellMagnitudes_479_large
example : (pellMagnitudes_479.all fun x => decide (2 ≤ x)) = true := D1Bound5.PellMatchingLightProduction.pellMagnitudes_479_large
end

namespace D1Bound5.PellLightProduction
#check D1Bound5.PellLightProduction.magnitudes_7415
#check D1Bound5.PellLightProduction.magnitudes_7423
#check D1Bound5.PellLightProduction.magnitudes_7431
#check D1Bound5.PellLightProduction.magnitudes_7439
#check D1Bound5.PellLightProduction.magnitudes_7447
#check D1Bound5.PellLightProduction.magnitudes_7455
#check D1Bound5.PellLightProduction.magnitudes_7463
#check D1Bound5.PellLightProduction.magnitudes_7471
#check D1Bound5.PellLightProduction.magnitudes_7487
#check D1Bound5.PellLightProduction.magnitudes_7495
#check D1Bound5.PellLightProduction.magnitudes_7503
#check D1Bound5.PellLightProduction.magnitudes_7511
#check D1Bound5.PellLightProduction.magnitudes_7519
#check D1Bound5.PellLightProduction.magnitudes_7527
#check D1Bound5.PellLightProduction.magnitudes_7535
#check D1Bound5.PellLightProduction.magnitudes_7543
#check D1Bound5.PellLightProduction.checked_7415
example : pellLightFiniteCheck 7415 86 (10^275) 204 magnitudes_7415 = true := D1Bound5.PellLightProduction.checked_7415
#check D1Bound5.PellLightProduction.checked_7423
example : pellLightFiniteCheck 7423 86 (10^275) 486 magnitudes_7423 = true := D1Bound5.PellLightProduction.checked_7423
#check D1Bound5.PellLightProduction.checked_7431
example : pellLightFiniteCheck 7431 86 (10^275) 550 magnitudes_7431 = true := D1Bound5.PellLightProduction.checked_7431
#check D1Bound5.PellLightProduction.checked_7439
example : pellLightFiniteCheck 7439 86 (10^275) 193 magnitudes_7439 = true := D1Bound5.PellLightProduction.checked_7439
#check D1Bound5.PellLightProduction.checked_7447
example : pellLightFiniteCheck 7447 86 (10^275) 582 magnitudes_7447 = true := D1Bound5.PellLightProduction.checked_7447
#check D1Bound5.PellLightProduction.checked_7455
example : pellLightFiniteCheck 7455 86 (10^275) 384 magnitudes_7455 = true := D1Bound5.PellLightProduction.checked_7455
#check D1Bound5.PellLightProduction.checked_7463
example : pellLightFiniteCheck 7463 86 (10^275) 570 magnitudes_7463 = true := D1Bound5.PellLightProduction.checked_7463
#check D1Bound5.PellLightProduction.checked_7471
example : pellLightFiniteCheck 7471 86 (10^275) 555 magnitudes_7471 = true := D1Bound5.PellLightProduction.checked_7471
#check D1Bound5.PellLightProduction.checked_7487
example : pellLightFiniteCheck 7487 86 (10^275) 552 magnitudes_7487 = true := D1Bound5.PellLightProduction.checked_7487
#check D1Bound5.PellLightProduction.checked_7495
example : pellLightFiniteCheck 7495 86 (10^275) 545 magnitudes_7495 = true := D1Bound5.PellLightProduction.checked_7495
#check D1Bound5.PellLightProduction.checked_7503
example : pellLightFiniteCheck 7503 86 (10^275) 720 magnitudes_7503 = true := D1Bound5.PellLightProduction.checked_7503
#check D1Bound5.PellLightProduction.checked_7511
example : pellLightFiniteCheck 7511 86 (10^275) 404 magnitudes_7511 = true := D1Bound5.PellLightProduction.checked_7511
#check D1Bound5.PellLightProduction.checked_7519
example : pellLightFiniteCheck 7519 86 (10^275) 533 magnitudes_7519 = true := D1Bound5.PellLightProduction.checked_7519
#check D1Bound5.PellLightProduction.checked_7527
example : pellLightFiniteCheck 7527 86 (10^275) 425 magnitudes_7527 = true := D1Bound5.PellLightProduction.checked_7527
#check D1Bound5.PellLightProduction.checked_7535
example : pellLightFiniteCheck 7535 86 (10^275) 405 magnitudes_7535 = true := D1Bound5.PellLightProduction.checked_7535
#check D1Bound5.PellLightProduction.checked_7543
example : pellLightFiniteCheck 7543 86 (10^275) 596 magnitudes_7543 = true := D1Bound5.PellLightProduction.checked_7543
end

namespace D1Bound5.PellLightProduction
#check D1Bound5.PellLightProduction.magnitudes_7559
#check D1Bound5.PellLightProduction.magnitudes_7567
#check D1Bound5.PellLightProduction.magnitudes_7583
#check D1Bound5.PellLightProduction.magnitudes_7591
#check D1Bound5.PellLightProduction.magnitudes_7599
#check D1Bound5.PellLightProduction.magnitudes_7607
#check D1Bound5.PellLightProduction.magnitudes_7615
#check D1Bound5.PellLightProduction.magnitudes_7631
#check D1Bound5.PellLightProduction.magnitudes_7639
#check D1Bound5.PellLightProduction.magnitudes_7647
#check D1Bound5.PellLightProduction.magnitudes_7655
#check D1Bound5.PellLightProduction.magnitudes_7663
#check D1Bound5.PellLightProduction.magnitudes_7671
#check D1Bound5.PellLightProduction.magnitudes_7679
#check D1Bound5.PellLightProduction.magnitudes_7687
#check D1Bound5.PellLightProduction.magnitudes_7703
#check D1Bound5.PellLightProduction.checked_7559
example : pellLightFiniteCheck 7559 86 (10^275) 538 magnitudes_7559 = true := D1Bound5.PellLightProduction.checked_7559
#check D1Bound5.PellLightProduction.checked_7567
example : pellLightFiniteCheck 7567 86 (10^275) 262 magnitudes_7567 = true := D1Bound5.PellLightProduction.checked_7567
#check D1Bound5.PellLightProduction.checked_7583
example : pellLightFiniteCheck 7583 87 (10^275) 541 magnitudes_7583 = true := D1Bound5.PellLightProduction.checked_7583
#check D1Bound5.PellLightProduction.checked_7591
example : pellLightFiniteCheck 7591 87 (10^275) 437 magnitudes_7591 = true := D1Bound5.PellLightProduction.checked_7591
#check D1Bound5.PellLightProduction.checked_7599
example : pellLightFiniteCheck 7599 87 (10^275) 570 magnitudes_7599 = true := D1Bound5.PellLightProduction.checked_7599
#check D1Bound5.PellLightProduction.checked_7607
example : pellLightFiniteCheck 7607 87 (10^275) 472 magnitudes_7607 = true := D1Bound5.PellLightProduction.checked_7607
#check D1Bound5.PellLightProduction.checked_7615
example : pellLightFiniteCheck 7615 87 (10^275) 572 magnitudes_7615 = true := D1Bound5.PellLightProduction.checked_7615
#check D1Bound5.PellLightProduction.checked_7631
example : pellLightFiniteCheck 7631 87 (10^275) 528 magnitudes_7631 = true := D1Bound5.PellLightProduction.checked_7631
#check D1Bound5.PellLightProduction.checked_7639
example : pellLightFiniteCheck 7639 87 (10^275) 437 magnitudes_7639 = true := D1Bound5.PellLightProduction.checked_7639
#check D1Bound5.PellLightProduction.checked_7647
example : pellLightFiniteCheck 7647 87 (10^275) 552 magnitudes_7647 = true := D1Bound5.PellLightProduction.checked_7647
#check D1Bound5.PellLightProduction.checked_7655
example : pellLightFiniteCheck 7655 87 (10^275) 250 magnitudes_7655 = true := D1Bound5.PellLightProduction.checked_7655
#check D1Bound5.PellLightProduction.checked_7663
example : pellLightFiniteCheck 7663 87 (10^275) 442 magnitudes_7663 = true := D1Bound5.PellLightProduction.checked_7663
#check D1Bound5.PellLightProduction.checked_7671
example : pellLightFiniteCheck 7671 87 (10^275) 412 magnitudes_7671 = true := D1Bound5.PellLightProduction.checked_7671
#check D1Bound5.PellLightProduction.checked_7679
example : pellLightFiniteCheck 7679 87 (10^275) 589 magnitudes_7679 = true := D1Bound5.PellLightProduction.checked_7679
#check D1Bound5.PellLightProduction.checked_7687
example : pellLightFiniteCheck 7687 87 (10^275) 551 magnitudes_7687 = true := D1Bound5.PellLightProduction.checked_7687
#check D1Bound5.PellLightProduction.checked_7703
example : pellLightFiniteCheck 7703 87 (10^275) 544 magnitudes_7703 = true := D1Bound5.PellLightProduction.checked_7703
end

namespace D1Bound5.PellLightProduction
#check D1Bound5.PellLightProduction.magnitudes_7711
#check D1Bound5.PellLightProduction.magnitudes_7719
#check D1Bound5.PellLightProduction.magnitudes_7727
#check D1Bound5.PellLightProduction.magnitudes_7735
#check D1Bound5.PellLightProduction.magnitudes_7743
#check D1Bound5.PellLightProduction.magnitudes_7751
#check D1Bound5.PellLightProduction.magnitudes_7759
#check D1Bound5.PellLightProduction.magnitudes_7783
#check D1Bound5.PellLightProduction.magnitudes_7799
#check D1Bound5.PellLightProduction.magnitudes_7807
#check D1Bound5.PellLightProduction.magnitudes_7815
#check D1Bound5.PellLightProduction.magnitudes_7823
#check D1Bound5.PellLightProduction.magnitudes_7831
#check D1Bound5.PellLightProduction.magnitudes_7847
#check D1Bound5.PellLightProduction.magnitudes_7855
#check D1Bound5.PellLightProduction.magnitudes_7863
#check D1Bound5.PellLightProduction.checked_7711
example : pellLightFiniteCheck 7711 87 (10^275) 378 magnitudes_7711 = true := D1Bound5.PellLightProduction.checked_7711
#check D1Bound5.PellLightProduction.checked_7719
example : pellLightFiniteCheck 7719 87 (10^275) 304 magnitudes_7719 = true := D1Bound5.PellLightProduction.checked_7719
#check D1Bound5.PellLightProduction.checked_7727
example : pellLightFiniteCheck 7727 87 (10^275) 520 magnitudes_7727 = true := D1Bound5.PellLightProduction.checked_7727
#check D1Bound5.PellLightProduction.checked_7735
example : pellLightFiniteCheck 7735 87 (10^275) 448 magnitudes_7735 = true := D1Bound5.PellLightProduction.checked_7735
#check D1Bound5.PellLightProduction.checked_7743
example : pellLightFiniteCheck 7743 87 (10^275) 244 magnitudes_7743 = true := D1Bound5.PellLightProduction.checked_7743
#check D1Bound5.PellLightProduction.checked_7751
example : pellLightFiniteCheck 7751 88 (10^275) 499 magnitudes_7751 = true := D1Bound5.PellLightProduction.checked_7751
#check D1Bound5.PellLightProduction.checked_7759
example : pellLightFiniteCheck 7759 88 (10^275) 566 magnitudes_7759 = true := D1Bound5.PellLightProduction.checked_7759
#check D1Bound5.PellLightProduction.checked_7783
example : pellLightFiniteCheck 7783 88 (10^275) 450 magnitudes_7783 = true := D1Bound5.PellLightProduction.checked_7783
#check D1Bound5.PellLightProduction.checked_7799
example : pellLightFiniteCheck 7799 88 (10^275) 455 magnitudes_7799 = true := D1Bound5.PellLightProduction.checked_7799
#check D1Bound5.PellLightProduction.checked_7807
example : pellLightFiniteCheck 7807 88 (10^275) 488 magnitudes_7807 = true := D1Bound5.PellLightProduction.checked_7807
#check D1Bound5.PellLightProduction.checked_7815
example : pellLightFiniteCheck 7815 88 (10^275) 398 magnitudes_7815 = true := D1Bound5.PellLightProduction.checked_7815
#check D1Bound5.PellLightProduction.checked_7823
example : pellLightFiniteCheck 7823 88 (10^275) 579 magnitudes_7823 = true := D1Bound5.PellLightProduction.checked_7823
#check D1Bound5.PellLightProduction.checked_7831
example : pellLightFiniteCheck 7831 88 (10^275) 510 magnitudes_7831 = true := D1Bound5.PellLightProduction.checked_7831
#check D1Bound5.PellLightProduction.checked_7847
example : pellLightFiniteCheck 7847 88 (10^275) 494 magnitudes_7847 = true := D1Bound5.PellLightProduction.checked_7847
#check D1Bound5.PellLightProduction.checked_7855
example : pellLightFiniteCheck 7855 88 (10^275) 591 magnitudes_7855 = true := D1Bound5.PellLightProduction.checked_7855
#check D1Bound5.PellLightProduction.checked_7863
example : pellLightFiniteCheck 7863 88 (10^275) 575 magnitudes_7863 = true := D1Bound5.PellLightProduction.checked_7863
end

namespace D1Bound5.PellLightProduction
#check D1Bound5.PellLightProduction.magnitudes_7871
#check D1Bound5.PellLightProduction.magnitudes_7879
#check D1Bound5.PellLightProduction.magnitudes_7887
#check D1Bound5.PellLightProduction.magnitudes_7895
#check D1Bound5.PellLightProduction.magnitudes_7903
#check D1Bound5.PellLightProduction.magnitudes_7919
#check D1Bound5.PellLightProduction.magnitudes_7927
#check D1Bound5.PellLightProduction.magnitudes_7951
#check D1Bound5.PellLightProduction.magnitudes_7959
#check D1Bound5.PellLightProduction.magnitudes_7967
#check D1Bound5.PellLightProduction.magnitudes_7991
#check D1Bound5.PellLightProduction.magnitudes_7999
#check D1Bound5.PellLightProduction.magnitudes_8007
#check D1Bound5.PellLightProduction.magnitudes_8015
#check D1Bound5.PellLightProduction.magnitudes_8023
#check D1Bound5.PellLightProduction.magnitudes_8031
#check D1Bound5.PellLightProduction.checked_7871
example : pellLightFiniteCheck 7871 88 (10^275) 523 magnitudes_7871 = true := D1Bound5.PellLightProduction.checked_7871
#check D1Bound5.PellLightProduction.checked_7879
example : pellLightFiniteCheck 7879 88 (10^275) 542 magnitudes_7879 = true := D1Bound5.PellLightProduction.checked_7879
#check D1Bound5.PellLightProduction.checked_7887
example : pellLightFiniteCheck 7887 88 (10^275) 494 magnitudes_7887 = true := D1Bound5.PellLightProduction.checked_7887
#check D1Bound5.PellLightProduction.checked_7895
example : pellLightFiniteCheck 7895 88 (10^275) 525 magnitudes_7895 = true := D1Bound5.PellLightProduction.checked_7895
#check D1Bound5.PellLightProduction.checked_7903
example : pellLightFiniteCheck 7903 88 (10^275) 484 magnitudes_7903 = true := D1Bound5.PellLightProduction.checked_7903
#check D1Bound5.PellLightProduction.checked_7919
example : pellLightFiniteCheck 7919 88 (10^275) 262 magnitudes_7919 = true := D1Bound5.PellLightProduction.checked_7919
#check D1Bound5.PellLightProduction.checked_7927
example : pellLightFiniteCheck 7927 89 (10^275) 472 magnitudes_7927 = true := D1Bound5.PellLightProduction.checked_7927
#check D1Bound5.PellLightProduction.checked_7951
example : pellLightFiniteCheck 7951 89 (10^275) 544 magnitudes_7951 = true := D1Bound5.PellLightProduction.checked_7951
#check D1Bound5.PellLightProduction.checked_7959
example : pellLightFiniteCheck 7959 89 (10^275) 524 magnitudes_7959 = true := D1Bound5.PellLightProduction.checked_7959
#check D1Bound5.PellLightProduction.checked_7967
example : pellLightFiniteCheck 7967 89 (10^275) 305 magnitudes_7967 = true := D1Bound5.PellLightProduction.checked_7967
#check D1Bound5.PellLightProduction.checked_7991
example : pellLightFiniteCheck 7991 89 (10^275) 600 magnitudes_7991 = true := D1Bound5.PellLightProduction.checked_7991
#check D1Bound5.PellLightProduction.checked_7999
example : pellLightFiniteCheck 7999 89 (10^275) 473 magnitudes_7999 = true := D1Bound5.PellLightProduction.checked_7999
#check D1Bound5.PellLightProduction.checked_8007
example : pellLightFiniteCheck 8007 89 (10^275) 400 magnitudes_8007 = true := D1Bound5.PellLightProduction.checked_8007
#check D1Bound5.PellLightProduction.checked_8015
example : pellLightFiniteCheck 8015 89 (10^275) 463 magnitudes_8015 = true := D1Bound5.PellLightProduction.checked_8015
#check D1Bound5.PellLightProduction.checked_8023
example : pellLightFiniteCheck 8023 89 (10^275) 372 magnitudes_8023 = true := D1Bound5.PellLightProduction.checked_8023
#check D1Bound5.PellLightProduction.checked_8031
example : pellLightFiniteCheck 8031 89 (10^275) 499 magnitudes_8031 = true := D1Bound5.PellLightProduction.checked_8031
end

namespace D1Bound5.PellLightProduction
#check D1Bound5.PellLightProduction.magnitudes_8039
#check D1Bound5.PellLightProduction.magnitudes_8047
#check D1Bound5.PellLightProduction.magnitudes_8063
#check D1Bound5.PellLightProduction.magnitudes_8071
#check D1Bound5.PellLightProduction.magnitudes_8079
#check D1Bound5.PellLightProduction.magnitudes_8087
#check D1Bound5.PellLightProduction.magnitudes_8095
#check D1Bound5.PellLightProduction.magnitudes_8103
#check D1Bound5.PellLightProduction.magnitudes_8111
#check D1Bound5.PellLightProduction.magnitudes_8119
#check D1Bound5.PellLightProduction.magnitudes_8135
#check D1Bound5.PellLightProduction.magnitudes_8143
#check D1Bound5.PellLightProduction.magnitudes_8151
#check D1Bound5.PellLightProduction.magnitudes_8159
#check D1Bound5.PellLightProduction.magnitudes_8167
#check D1Bound5.PellLightProduction.magnitudes_8191
#check D1Bound5.PellLightProduction.checked_8039
example : pellLightFiniteCheck 8039 89 (10^275) 545 magnitudes_8039 = true := D1Bound5.PellLightProduction.checked_8039
#check D1Bound5.PellLightProduction.checked_8047
example : pellLightFiniteCheck 8047 89 (10^275) 500 magnitudes_8047 = true := D1Bound5.PellLightProduction.checked_8047
#check D1Bound5.PellLightProduction.checked_8063
example : pellLightFiniteCheck 8063 89 (10^275) 572 magnitudes_8063 = true := D1Bound5.PellLightProduction.checked_8063
#check D1Bound5.PellLightProduction.checked_8071
example : pellLightFiniteCheck 8071 89 (10^275) 499 magnitudes_8071 = true := D1Bound5.PellLightProduction.checked_8071
#check D1Bound5.PellLightProduction.checked_8079
example : pellLightFiniteCheck 8079 89 (10^275) 534 magnitudes_8079 = true := D1Bound5.PellLightProduction.checked_8079
#check D1Bound5.PellLightProduction.checked_8087
example : pellLightFiniteCheck 8087 89 (10^275) 547 magnitudes_8087 = true := D1Bound5.PellLightProduction.checked_8087
#check D1Bound5.PellLightProduction.checked_8095
example : pellLightFiniteCheck 8095 89 (10^275) 288 magnitudes_8095 = true := D1Bound5.PellLightProduction.checked_8095
#check D1Bound5.PellLightProduction.checked_8103
example : pellLightFiniteCheck 8103 90 (10^275) 136 magnitudes_8103 = true := D1Bound5.PellLightProduction.checked_8103
#check D1Bound5.PellLightProduction.checked_8111
example : pellLightFiniteCheck 8111 90 (10^275) 509 magnitudes_8111 = true := D1Bound5.PellLightProduction.checked_8111
#check D1Bound5.PellLightProduction.checked_8119
example : pellLightFiniteCheck 8119 90 (10^275) 483 magnitudes_8119 = true := D1Bound5.PellLightProduction.checked_8119
#check D1Bound5.PellLightProduction.checked_8135
example : pellLightFiniteCheck 8135 90 (10^275) 560 magnitudes_8135 = true := D1Bound5.PellLightProduction.checked_8135
#check D1Bound5.PellLightProduction.checked_8143
example : pellLightFiniteCheck 8143 90 (10^275) 578 magnitudes_8143 = true := D1Bound5.PellLightProduction.checked_8143
#check D1Bound5.PellLightProduction.checked_8151
example : pellLightFiniteCheck 8151 90 (10^275) 536 magnitudes_8151 = true := D1Bound5.PellLightProduction.checked_8151
#check D1Bound5.PellLightProduction.checked_8159
example : pellLightFiniteCheck 8159 90 (10^275) 467 magnitudes_8159 = true := D1Bound5.PellLightProduction.checked_8159
#check D1Bound5.PellLightProduction.checked_8167
example : pellLightFiniteCheck 8167 90 (10^275) 582 magnitudes_8167 = true := D1Bound5.PellLightProduction.checked_8167
#check D1Bound5.PellLightProduction.checked_8191
example : pellLightFiniteCheck 8191 90 (10^275) 543 magnitudes_8191 = true := D1Bound5.PellLightProduction.checked_8191
end

namespace D1Bound5.PellLightProduction
#check D1Bound5.PellLightProduction.magnitudes_8207
#check D1Bound5.PellLightProduction.magnitudes_8215
#check D1Bound5.PellLightProduction.magnitudes_8223
#check D1Bound5.PellLightProduction.magnitudes_8231
#check D1Bound5.PellLightProduction.magnitudes_8239
#check D1Bound5.PellLightProduction.magnitudes_8247
#check D1Bound5.PellLightProduction.magnitudes_8255
#check D1Bound5.PellLightProduction.magnitudes_8263
#check D1Bound5.PellLightProduction.magnitudes_8279
#check D1Bound5.PellLightProduction.magnitudes_8287
#check D1Bound5.PellLightProduction.magnitudes_8295
#check D1Bound5.PellLightProduction.magnitudes_8311
#check D1Bound5.PellLightProduction.magnitudes_8319
#check D1Bound5.PellLightProduction.magnitudes_8327
#check D1Bound5.PellLightProduction.magnitudes_8335
#check D1Bound5.PellLightProduction.magnitudes_8351
#check D1Bound5.PellLightProduction.checked_8207
example : pellLightFiniteCheck 8207 90 (10^275) 439 magnitudes_8207 = true := D1Bound5.PellLightProduction.checked_8207
#check D1Bound5.PellLightProduction.checked_8215
example : pellLightFiniteCheck 8215 90 (10^275) 558 magnitudes_8215 = true := D1Bound5.PellLightProduction.checked_8215
#check D1Bound5.PellLightProduction.checked_8223
example : pellLightFiniteCheck 8223 90 (10^275) 654 magnitudes_8223 = true := D1Bound5.PellLightProduction.checked_8223
#check D1Bound5.PellLightProduction.checked_8231
example : pellLightFiniteCheck 8231 90 (10^275) 591 magnitudes_8231 = true := D1Bound5.PellLightProduction.checked_8231
#check D1Bound5.PellLightProduction.checked_8239
example : pellLightFiniteCheck 8239 90 (10^275) 456 magnitudes_8239 = true := D1Bound5.PellLightProduction.checked_8239
#check D1Bound5.PellLightProduction.checked_8247
example : pellLightFiniteCheck 8247 90 (10^275) 538 magnitudes_8247 = true := D1Bound5.PellLightProduction.checked_8247
#check D1Bound5.PellLightProduction.checked_8255
example : pellLightFiniteCheck 8255 90 (10^275) 352 magnitudes_8255 = true := D1Bound5.PellLightProduction.checked_8255
#check D1Bound5.PellLightProduction.checked_8263
example : pellLightFiniteCheck 8263 90 (10^275) 506 magnitudes_8263 = true := D1Bound5.PellLightProduction.checked_8263
#check D1Bound5.PellLightProduction.checked_8279
example : pellLightFiniteCheck 8279 90 (10^275) 260 magnitudes_8279 = true := D1Bound5.PellLightProduction.checked_8279
#check D1Bound5.PellLightProduction.checked_8287
example : pellLightFiniteCheck 8287 91 (10^275) 563 magnitudes_8287 = true := D1Bound5.PellLightProduction.checked_8287
#check D1Bound5.PellLightProduction.checked_8295
example : pellLightFiniteCheck 8295 91 (10^275) 162 magnitudes_8295 = true := D1Bound5.PellLightProduction.checked_8295
#check D1Bound5.PellLightProduction.checked_8311
example : pellLightFiniteCheck 8311 91 (10^275) 276 magnitudes_8311 = true := D1Bound5.PellLightProduction.checked_8311
#check D1Bound5.PellLightProduction.checked_8319
example : pellLightFiniteCheck 8319 91 (10^275) 461 magnitudes_8319 = true := D1Bound5.PellLightProduction.checked_8319
#check D1Bound5.PellLightProduction.checked_8327
example : pellLightFiniteCheck 8327 91 (10^275) 525 magnitudes_8327 = true := D1Bound5.PellLightProduction.checked_8327
#check D1Bound5.PellLightProduction.checked_8335
example : pellLightFiniteCheck 8335 91 (10^275) 516 magnitudes_8335 = true := D1Bound5.PellLightProduction.checked_8335
#check D1Bound5.PellLightProduction.checked_8351
example : pellLightFiniteCheck 8351 91 (10^275) 596 magnitudes_8351 = true := D1Bound5.PellLightProduction.checked_8351
end

namespace D1Bound5.PellLightProduction
#check D1Bound5.PellLightProduction.magnitudes_8359
#check D1Bound5.PellLightProduction.magnitudes_8367
#check D1Bound5.PellLightProduction.magnitudes_8383
#check D1Bound5.PellLightProduction.magnitudes_8391
#check D1Bound5.PellLightProduction.magnitudes_8399
#check D1Bound5.PellLightProduction.magnitudes_8407
#check D1Bound5.PellLightProduction.magnitudes_8423
#check D1Bound5.PellLightProduction.magnitudes_8431
#check D1Bound5.PellLightProduction.magnitudes_8439
#check D1Bound5.PellLightProduction.magnitudes_8447
#check D1Bound5.PellLightProduction.magnitudes_8455
#check D1Bound5.PellLightProduction.magnitudes_8463
#check D1Bound5.PellLightProduction.magnitudes_8471
#check D1Bound5.PellLightProduction.magnitudes_8479
#check D1Bound5.PellLightProduction.magnitudes_8495
#check D1Bound5.PellLightProduction.magnitudes_8503
#check D1Bound5.PellLightProduction.checked_8359
example : pellLightFiniteCheck 8359 91 (10^275) 568 magnitudes_8359 = true := D1Bound5.PellLightProduction.checked_8359
#check D1Bound5.PellLightProduction.checked_8367
example : pellLightFiniteCheck 8367 91 (10^275) 527 magnitudes_8367 = true := D1Bound5.PellLightProduction.checked_8367
#check D1Bound5.PellLightProduction.checked_8383
example : pellLightFiniteCheck 8383 91 (10^275) 497 magnitudes_8383 = true := D1Bound5.PellLightProduction.checked_8383
#check D1Bound5.PellLightProduction.checked_8391
example : pellLightFiniteCheck 8391 91 (10^275) 517 magnitudes_8391 = true := D1Bound5.PellLightProduction.checked_8391
#check D1Bound5.PellLightProduction.checked_8399
example : pellLightFiniteCheck 8399 91 (10^275) 700 magnitudes_8399 = true := D1Bound5.PellLightProduction.checked_8399
#check D1Bound5.PellLightProduction.checked_8407
example : pellLightFiniteCheck 8407 91 (10^275) 384 magnitudes_8407 = true := D1Bound5.PellLightProduction.checked_8407
#check D1Bound5.PellLightProduction.checked_8423
example : pellLightFiniteCheck 8423 91 (10^275) 560 magnitudes_8423 = true := D1Bound5.PellLightProduction.checked_8423
#check D1Bound5.PellLightProduction.checked_8431
example : pellLightFiniteCheck 8431 91 (10^275) 534 magnitudes_8431 = true := D1Bound5.PellLightProduction.checked_8431
#check D1Bound5.PellLightProduction.checked_8439
example : pellLightFiniteCheck 8439 91 (10^275) 550 magnitudes_8439 = true := D1Bound5.PellLightProduction.checked_8439
#check D1Bound5.PellLightProduction.checked_8447
example : pellLightFiniteCheck 8447 91 (10^275) 392 magnitudes_8447 = true := D1Bound5.PellLightProduction.checked_8447
#check D1Bound5.PellLightProduction.checked_8455
example : pellLightFiniteCheck 8455 91 (10^275) 452 magnitudes_8455 = true := D1Bound5.PellLightProduction.checked_8455
#check D1Bound5.PellLightProduction.checked_8463
example : pellLightFiniteCheck 8463 91 (10^275) 242 magnitudes_8463 = true := D1Bound5.PellLightProduction.checked_8463
#check D1Bound5.PellLightProduction.checked_8471
example : pellLightFiniteCheck 8471 92 (10^275) 427 magnitudes_8471 = true := D1Bound5.PellLightProduction.checked_8471
#check D1Bound5.PellLightProduction.checked_8479
example : pellLightFiniteCheck 8479 92 (10^275) 432 magnitudes_8479 = true := D1Bound5.PellLightProduction.checked_8479
#check D1Bound5.PellLightProduction.checked_8495
example : pellLightFiniteCheck 8495 92 (10^275) 501 magnitudes_8495 = true := D1Bound5.PellLightProduction.checked_8495
#check D1Bound5.PellLightProduction.checked_8503
example : pellLightFiniteCheck 8503 92 (10^275) 603 magnitudes_8503 = true := D1Bound5.PellLightProduction.checked_8503
end

namespace D1Bound5.PellLightProduction
#check D1Bound5.PellLightProduction.magnitudes_8511
#check D1Bound5.PellLightProduction.magnitudes_8519
#check D1Bound5.PellLightProduction.magnitudes_8527
#check D1Bound5.PellLightProduction.magnitudes_8535
#check D1Bound5.PellLightProduction.magnitudes_8543
#check D1Bound5.PellLightProduction.magnitudes_8551
#check D1Bound5.PellLightProduction.magnitudes_8567
#check D1Bound5.PellLightProduction.magnitudes_8583
#check D1Bound5.PellLightProduction.magnitudes_8599
#check D1Bound5.PellLightProduction.magnitudes_8607
#check D1Bound5.PellLightProduction.magnitudes_8615
#check D1Bound5.PellLightProduction.magnitudes_8623
#check D1Bound5.PellLightProduction.magnitudes_8639
#check D1Bound5.PellLightProduction.magnitudes_8647
#check D1Bound5.PellLightProduction.magnitudes_8655
#check D1Bound5.PellLightProduction.magnitudes_8663
#check D1Bound5.PellLightProduction.checked_8511
example : pellLightFiniteCheck 8511 92 (10^275) 432 magnitudes_8511 = true := D1Bound5.PellLightProduction.checked_8511
#check D1Bound5.PellLightProduction.checked_8519
example : pellLightFiniteCheck 8519 92 (10^275) 497 magnitudes_8519 = true := D1Bound5.PellLightProduction.checked_8519
#check D1Bound5.PellLightProduction.checked_8527
example : pellLightFiniteCheck 8527 92 (10^275) 520 magnitudes_8527 = true := D1Bound5.PellLightProduction.checked_8527
#check D1Bound5.PellLightProduction.checked_8535
example : pellLightFiniteCheck 8535 92 (10^275) 588 magnitudes_8535 = true := D1Bound5.PellLightProduction.checked_8535
#check D1Bound5.PellLightProduction.checked_8543
example : pellLightFiniteCheck 8543 92 (10^275) 370 magnitudes_8543 = true := D1Bound5.PellLightProduction.checked_8543
#check D1Bound5.PellLightProduction.checked_8551
example : pellLightFiniteCheck 8551 92 (10^275) 535 magnitudes_8551 = true := D1Bound5.PellLightProduction.checked_8551
#check D1Bound5.PellLightProduction.checked_8567
example : pellLightFiniteCheck 8567 92 (10^275) 474 magnitudes_8567 = true := D1Bound5.PellLightProduction.checked_8567
#check D1Bound5.PellLightProduction.checked_8583
example : pellLightFiniteCheck 8583 92 (10^275) 533 magnitudes_8583 = true := D1Bound5.PellLightProduction.checked_8583
#check D1Bound5.PellLightProduction.checked_8599
example : pellLightFiniteCheck 8599 92 (10^275) 515 magnitudes_8599 = true := D1Bound5.PellLightProduction.checked_8599
#check D1Bound5.PellLightProduction.checked_8607
example : pellLightFiniteCheck 8607 92 (10^275) 474 magnitudes_8607 = true := D1Bound5.PellLightProduction.checked_8607
#check D1Bound5.PellLightProduction.checked_8615
example : pellLightFiniteCheck 8615 92 (10^275) 675 magnitudes_8615 = true := D1Bound5.PellLightProduction.checked_8615
#check D1Bound5.PellLightProduction.checked_8623
example : pellLightFiniteCheck 8623 92 (10^275) 547 magnitudes_8623 = true := D1Bound5.PellLightProduction.checked_8623
#check D1Bound5.PellLightProduction.checked_8639
example : pellLightFiniteCheck 8639 92 (10^275) 499 magnitudes_8639 = true := D1Bound5.PellLightProduction.checked_8639
#check D1Bound5.PellLightProduction.checked_8647
example : pellLightFiniteCheck 8647 92 (10^275) 258 magnitudes_8647 = true := D1Bound5.PellLightProduction.checked_8647
#check D1Bound5.PellLightProduction.checked_8655
example : pellLightFiniteCheck 8655 93 (10^275) 146 magnitudes_8655 = true := D1Bound5.PellLightProduction.checked_8655
#check D1Bound5.PellLightProduction.checked_8663
example : pellLightFiniteCheck 8663 93 (10^275) 478 magnitudes_8663 = true := D1Bound5.PellLightProduction.checked_8663
end

namespace D1Bound5.PellLightProduction
#check D1Bound5.PellLightProduction.magnitudes_8671
#check D1Bound5.PellLightProduction.magnitudes_8679
#check D1Bound5.PellLightProduction.magnitudes_8687
#check D1Bound5.PellLightProduction.magnitudes_8695
#check D1Bound5.PellLightProduction.magnitudes_8711
#check D1Bound5.PellLightProduction.magnitudes_8719
#check D1Bound5.PellLightProduction.magnitudes_8727
#check D1Bound5.PellLightProduction.magnitudes_8735
#check D1Bound5.PellLightProduction.magnitudes_8743
#check D1Bound5.PellLightProduction.magnitudes_8751
#check D1Bound5.PellLightProduction.magnitudes_8759
#check D1Bound5.PellLightProduction.magnitudes_8767
#check D1Bound5.PellLightProduction.magnitudes_8783
#check D1Bound5.PellLightProduction.magnitudes_8791
#check D1Bound5.PellLightProduction.magnitudes_8799
#check D1Bound5.PellLightProduction.magnitudes_8807
#check D1Bound5.PellLightProduction.checked_8671
example : pellLightFiniteCheck 8671 93 (10^275) 451 magnitudes_8671 = true := D1Bound5.PellLightProduction.checked_8671
#check D1Bound5.PellLightProduction.checked_8679
example : pellLightFiniteCheck 8679 93 (10^275) 539 magnitudes_8679 = true := D1Bound5.PellLightProduction.checked_8679
#check D1Bound5.PellLightProduction.checked_8687
example : pellLightFiniteCheck 8687 93 (10^275) 288 magnitudes_8687 = true := D1Bound5.PellLightProduction.checked_8687
#check D1Bound5.PellLightProduction.checked_8695
example : pellLightFiniteCheck 8695 93 (10^275) 459 magnitudes_8695 = true := D1Bound5.PellLightProduction.checked_8695
#check D1Bound5.PellLightProduction.checked_8711
example : pellLightFiniteCheck 8711 93 (10^275) 200 magnitudes_8711 = true := D1Bound5.PellLightProduction.checked_8711
#check D1Bound5.PellLightProduction.checked_8719
example : pellLightFiniteCheck 8719 93 (10^275) 562 magnitudes_8719 = true := D1Bound5.PellLightProduction.checked_8719
#check D1Bound5.PellLightProduction.checked_8727
example : pellLightFiniteCheck 8727 93 (10^275) 495 magnitudes_8727 = true := D1Bound5.PellLightProduction.checked_8727
#check D1Bound5.PellLightProduction.checked_8735
example : pellLightFiniteCheck 8735 93 (10^275) 380 magnitudes_8735 = true := D1Bound5.PellLightProduction.checked_8735
#check D1Bound5.PellLightProduction.checked_8743
example : pellLightFiniteCheck 8743 93 (10^275) 496 magnitudes_8743 = true := D1Bound5.PellLightProduction.checked_8743
#check D1Bound5.PellLightProduction.checked_8751
example : pellLightFiniteCheck 8751 93 (10^275) 621 magnitudes_8751 = true := D1Bound5.PellLightProduction.checked_8751
#check D1Bound5.PellLightProduction.checked_8759
example : pellLightFiniteCheck 8759 93 (10^275) 591 magnitudes_8759 = true := D1Bound5.PellLightProduction.checked_8759
#check D1Bound5.PellLightProduction.checked_8767
example : pellLightFiniteCheck 8767 93 (10^275) 592 magnitudes_8767 = true := D1Bound5.PellLightProduction.checked_8767
#check D1Bound5.PellLightProduction.checked_8783
example : pellLightFiniteCheck 8783 93 (10^275) 570 magnitudes_8783 = true := D1Bound5.PellLightProduction.checked_8783
#check D1Bound5.PellLightProduction.checked_8791
example : pellLightFiniteCheck 8791 93 (10^275) 499 magnitudes_8791 = true := D1Bound5.PellLightProduction.checked_8791
#check D1Bound5.PellLightProduction.checked_8799
example : pellLightFiniteCheck 8799 93 (10^275) 342 magnitudes_8799 = true := D1Bound5.PellLightProduction.checked_8799
#check D1Bound5.PellLightProduction.checked_8807
example : pellLightFiniteCheck 8807 93 (10^275) 608 magnitudes_8807 = true := D1Bound5.PellLightProduction.checked_8807
end

namespace D1Bound5.PellLightProduction
#check D1Bound5.PellLightProduction.magnitudes_8815
#check D1Bound5.PellLightProduction.magnitudes_8823
#check D1Bound5.PellLightProduction.magnitudes_8831
#check D1Bound5.PellLightProduction.magnitudes_8839
#check D1Bound5.PellLightProduction.magnitudes_8855
#check D1Bound5.PellLightProduction.magnitudes_8863
#check D1Bound5.PellLightProduction.magnitudes_8871
#check D1Bound5.PellLightProduction.magnitudes_8879
#check D1Bound5.PellLightProduction.magnitudes_8887
#check D1Bound5.PellLightProduction.magnitudes_8895
#check D1Bound5.PellLightProduction.magnitudes_8903
#check D1Bound5.PellLightProduction.magnitudes_8911
#check D1Bound5.PellLightProduction.magnitudes_8927
#check D1Bound5.PellLightProduction.magnitudes_8935
#check D1Bound5.PellLightProduction.magnitudes_8943
#check D1Bound5.PellLightProduction.magnitudes_8951
#check D1Bound5.PellLightProduction.checked_8815
example : pellLightFiniteCheck 8815 93 (10^275) 402 magnitudes_8815 = true := D1Bound5.PellLightProduction.checked_8815
#check D1Bound5.PellLightProduction.checked_8823
example : pellLightFiniteCheck 8823 93 (10^275) 437 magnitudes_8823 = true := D1Bound5.PellLightProduction.checked_8823
#check D1Bound5.PellLightProduction.checked_8831
example : pellLightFiniteCheck 8831 93 (10^275) 528 magnitudes_8831 = true := D1Bound5.PellLightProduction.checked_8831
#check D1Bound5.PellLightProduction.checked_8839
example : pellLightFiniteCheck 8839 94 (10^275) 555 magnitudes_8839 = true := D1Bound5.PellLightProduction.checked_8839
#check D1Bound5.PellLightProduction.checked_8855
example : pellLightFiniteCheck 8855 94 (10^275) 256 magnitudes_8855 = true := D1Bound5.PellLightProduction.checked_8855
#check D1Bound5.PellLightProduction.checked_8863
example : pellLightFiniteCheck 8863 94 (10^275) 392 magnitudes_8863 = true := D1Bound5.PellLightProduction.checked_8863
#check D1Bound5.PellLightProduction.checked_8871
example : pellLightFiniteCheck 8871 94 (10^275) 501 magnitudes_8871 = true := D1Bound5.PellLightProduction.checked_8871
#check D1Bound5.PellLightProduction.checked_8879
example : pellLightFiniteCheck 8879 94 (10^275) 581 magnitudes_8879 = true := D1Bound5.PellLightProduction.checked_8879
#check D1Bound5.PellLightProduction.checked_8887
example : pellLightFiniteCheck 8887 94 (10^275) 543 magnitudes_8887 = true := D1Bound5.PellLightProduction.checked_8887
#check D1Bound5.PellLightProduction.checked_8895
example : pellLightFiniteCheck 8895 94 (10^275) 490 magnitudes_8895 = true := D1Bound5.PellLightProduction.checked_8895
#check D1Bound5.PellLightProduction.checked_8903
example : pellLightFiniteCheck 8903 94 (10^275) 507 magnitudes_8903 = true := D1Bound5.PellLightProduction.checked_8903
#check D1Bound5.PellLightProduction.checked_8911
example : pellLightFiniteCheck 8911 94 (10^275) 499 magnitudes_8911 = true := D1Bound5.PellLightProduction.checked_8911
#check D1Bound5.PellLightProduction.checked_8927
example : pellLightFiniteCheck 8927 94 (10^275) 413 magnitudes_8927 = true := D1Bound5.PellLightProduction.checked_8927
#check D1Bound5.PellLightProduction.checked_8935
example : pellLightFiniteCheck 8935 94 (10^275) 524 magnitudes_8935 = true := D1Bound5.PellLightProduction.checked_8935
#check D1Bound5.PellLightProduction.checked_8943
example : pellLightFiniteCheck 8943 94 (10^275) 513 magnitudes_8943 = true := D1Bound5.PellLightProduction.checked_8943
#check D1Bound5.PellLightProduction.checked_8951
example : pellLightFiniteCheck 8951 94 (10^275) 573 magnitudes_8951 = true := D1Bound5.PellLightProduction.checked_8951
end

namespace D1Bound5.PellLightProduction
#check D1Bound5.PellLightProduction.magnitudes_8983
#check D1Bound5.PellLightProduction.magnitudes_8999
#check D1Bound5.PellLightProduction.magnitudes_9007
#check D1Bound5.PellLightProduction.magnitudes_9015
#check D1Bound5.PellLightProduction.magnitudes_9023
#check D1Bound5.PellLightProduction.magnitudes_9031
#check D1Bound5.PellLightProduction.magnitudes_9039
#check D1Bound5.PellLightProduction.magnitudes_9047
#check D1Bound5.PellLightProduction.magnitudes_9055
#check D1Bound5.PellLightProduction.magnitudes_9071
#check D1Bound5.PellLightProduction.magnitudes_9079
#check D1Bound5.PellLightProduction.magnitudes_9087
#check D1Bound5.PellLightProduction.magnitudes_9095
#check D1Bound5.PellLightProduction.magnitudes_9103
#check D1Bound5.PellLightProduction.magnitudes_9111
#check D1Bound5.PellLightProduction.magnitudes_9119
#check D1Bound5.PellLightProduction.checked_8983
example : pellLightFiniteCheck 8983 94 (10^275) 579 magnitudes_8983 = true := D1Bound5.PellLightProduction.checked_8983
#check D1Bound5.PellLightProduction.checked_8999
example : pellLightFiniteCheck 8999 94 (10^275) 574 magnitudes_8999 = true := D1Bound5.PellLightProduction.checked_8999
#check D1Bound5.PellLightProduction.checked_9007
example : pellLightFiniteCheck 9007 94 (10^275) 491 magnitudes_9007 = true := D1Bound5.PellLightProduction.checked_9007
#check D1Bound5.PellLightProduction.checked_9015
example : pellLightFiniteCheck 9015 94 (10^275) 308 magnitudes_9015 = true := D1Bound5.PellLightProduction.checked_9015
#check D1Bound5.PellLightProduction.checked_9023
example : pellLightFiniteCheck 9023 94 (10^275) 258 magnitudes_9023 = true := D1Bound5.PellLightProduction.checked_9023
#check D1Bound5.PellLightProduction.checked_9031
example : pellLightFiniteCheck 9031 95 (10^275) 530 magnitudes_9031 = true := D1Bound5.PellLightProduction.checked_9031
#check D1Bound5.PellLightProduction.checked_9039
example : pellLightFiniteCheck 9039 95 (10^275) 414 magnitudes_9039 = true := D1Bound5.PellLightProduction.checked_9039
#check D1Bound5.PellLightProduction.checked_9047
example : pellLightFiniteCheck 9047 95 (10^275) 579 magnitudes_9047 = true := D1Bound5.PellLightProduction.checked_9047
#check D1Bound5.PellLightProduction.checked_9055
example : pellLightFiniteCheck 9055 95 (10^275) 489 magnitudes_9055 = true := D1Bound5.PellLightProduction.checked_9055
#check D1Bound5.PellLightProduction.checked_9071
example : pellLightFiniteCheck 9071 95 (10^275) 506 magnitudes_9071 = true := D1Bound5.PellLightProduction.checked_9071
#check D1Bound5.PellLightProduction.checked_9079
example : pellLightFiniteCheck 9079 95 (10^275) 321 magnitudes_9079 = true := D1Bound5.PellLightProduction.checked_9079
#check D1Bound5.PellLightProduction.checked_9087
example : pellLightFiniteCheck 9087 95 (10^275) 249 magnitudes_9087 = true := D1Bound5.PellLightProduction.checked_9087
#check D1Bound5.PellLightProduction.checked_9095
example : pellLightFiniteCheck 9095 95 (10^275) 568 magnitudes_9095 = true := D1Bound5.PellLightProduction.checked_9095
#check D1Bound5.PellLightProduction.checked_9103
example : pellLightFiniteCheck 9103 95 (10^275) 536 magnitudes_9103 = true := D1Bound5.PellLightProduction.checked_9103
#check D1Bound5.PellLightProduction.checked_9111
example : pellLightFiniteCheck 9111 95 (10^275) 518 magnitudes_9111 = true := D1Bound5.PellLightProduction.checked_9111
#check D1Bound5.PellLightProduction.checked_9119
example : pellLightFiniteCheck 9119 95 (10^275) 412 magnitudes_9119 = true := D1Bound5.PellLightProduction.checked_9119
end

namespace D1Bound5.PellLightProduction
#check D1Bound5.PellLightProduction.magnitudes_9127
#check D1Bound5.PellLightProduction.magnitudes_9143
#check D1Bound5.PellLightProduction.magnitudes_9151
#check D1Bound5.PellLightProduction.magnitudes_9159
#check D1Bound5.PellLightProduction.magnitudes_9167
#check D1Bound5.PellLightProduction.magnitudes_9183
#check D1Bound5.PellLightProduction.magnitudes_9191
#check D1Bound5.PellLightProduction.magnitudes_9199
#check D1Bound5.PellLightProduction.magnitudes_9215
#check D1Bound5.PellLightProduction.magnitudes_9223
#check D1Bound5.PellLightProduction.magnitudes_9231
#check D1Bound5.PellLightProduction.magnitudes_9239
#check D1Bound5.PellLightProduction.magnitudes_9247
#check D1Bound5.PellLightProduction.magnitudes_9255
#check D1Bound5.PellLightProduction.magnitudes_9263
#check D1Bound5.PellLightProduction.magnitudes_9271
#check D1Bound5.PellLightProduction.checked_9127
example : pellLightFiniteCheck 9127 95 (10^275) 552 magnitudes_9127 = true := D1Bound5.PellLightProduction.checked_9127
#check D1Bound5.PellLightProduction.checked_9143
example : pellLightFiniteCheck 9143 95 (10^275) 608 magnitudes_9143 = true := D1Bound5.PellLightProduction.checked_9143
#check D1Bound5.PellLightProduction.checked_9151
example : pellLightFiniteCheck 9151 95 (10^275) 518 magnitudes_9151 = true := D1Bound5.PellLightProduction.checked_9151
#check D1Bound5.PellLightProduction.checked_9159
example : pellLightFiniteCheck 9159 95 (10^275) 542 magnitudes_9159 = true := D1Bound5.PellLightProduction.checked_9159
#check D1Bound5.PellLightProduction.checked_9167
example : pellLightFiniteCheck 9167 95 (10^275) 514 magnitudes_9167 = true := D1Bound5.PellLightProduction.checked_9167
#check D1Bound5.PellLightProduction.checked_9183
example : pellLightFiniteCheck 9183 95 (10^275) 581 magnitudes_9183 = true := D1Bound5.PellLightProduction.checked_9183
#check D1Bound5.PellLightProduction.checked_9191
example : pellLightFiniteCheck 9191 95 (10^275) 446 magnitudes_9191 = true := D1Bound5.PellLightProduction.checked_9191
#check D1Bound5.PellLightProduction.checked_9199
example : pellLightFiniteCheck 9199 95 (10^275) 545 magnitudes_9199 = true := D1Bound5.PellLightProduction.checked_9199
#check D1Bound5.PellLightProduction.checked_9215
example : pellLightFiniteCheck 9215 95 (10^275) 240 magnitudes_9215 = true := D1Bound5.PellLightProduction.checked_9215
#check D1Bound5.PellLightProduction.checked_9223
example : pellLightFiniteCheck 9223 96 (10^275) 524 magnitudes_9223 = true := D1Bound5.PellLightProduction.checked_9223
#check D1Bound5.PellLightProduction.checked_9231
example : pellLightFiniteCheck 9231 96 (10^275) 356 magnitudes_9231 = true := D1Bound5.PellLightProduction.checked_9231
#check D1Bound5.PellLightProduction.checked_9239
example : pellLightFiniteCheck 9239 96 (10^275) 566 magnitudes_9239 = true := D1Bound5.PellLightProduction.checked_9239
#check D1Bound5.PellLightProduction.checked_9247
example : pellLightFiniteCheck 9247 96 (10^275) 482 magnitudes_9247 = true := D1Bound5.PellLightProduction.checked_9247
#check D1Bound5.PellLightProduction.checked_9255
example : pellLightFiniteCheck 9255 96 (10^275) 525 magnitudes_9255 = true := D1Bound5.PellLightProduction.checked_9255
#check D1Bound5.PellLightProduction.checked_9263
example : pellLightFiniteCheck 9263 96 (10^275) 428 magnitudes_9263 = true := D1Bound5.PellLightProduction.checked_9263
#check D1Bound5.PellLightProduction.checked_9271
example : pellLightFiniteCheck 9271 96 (10^275) 480 magnitudes_9271 = true := D1Bound5.PellLightProduction.checked_9271
end

namespace D1Bound5.PellLightProduction
#check D1Bound5.PellLightProduction.magnitudes_9287
#check D1Bound5.PellLightProduction.magnitudes_9303
#check D1Bound5.PellLightProduction.magnitudes_9311
#check D1Bound5.PellLightProduction.magnitudes_9319
#check D1Bound5.PellLightProduction.magnitudes_9327
#check D1Bound5.PellLightProduction.magnitudes_9335
#check D1Bound5.PellLightProduction.magnitudes_9343
#check D1Bound5.PellLightProduction.magnitudes_9367
#check D1Bound5.PellLightProduction.magnitudes_9383
#check D1Bound5.PellLightProduction.magnitudes_9391
#check D1Bound5.PellLightProduction.magnitudes_9399
#check D1Bound5.PellLightProduction.magnitudes_9407
#check D1Bound5.PellLightProduction.magnitudes_9415
#check D1Bound5.PellLightProduction.magnitudes_9431
#check D1Bound5.PellLightProduction.magnitudes_9439
#check D1Bound5.PellLightProduction.magnitudes_9447
#check D1Bound5.PellLightProduction.checked_9287
example : pellLightFiniteCheck 9287 96 (10^275) 521 magnitudes_9287 = true := D1Bound5.PellLightProduction.checked_9287
#check D1Bound5.PellLightProduction.checked_9303
example : pellLightFiniteCheck 9303 96 (10^275) 511 magnitudes_9303 = true := D1Bound5.PellLightProduction.checked_9303
#check D1Bound5.PellLightProduction.checked_9311
example : pellLightFiniteCheck 9311 96 (10^275) 567 magnitudes_9311 = true := D1Bound5.PellLightProduction.checked_9311
#check D1Bound5.PellLightProduction.checked_9319
example : pellLightFiniteCheck 9319 96 (10^275) 549 magnitudes_9319 = true := D1Bound5.PellLightProduction.checked_9319
#check D1Bound5.PellLightProduction.checked_9327
example : pellLightFiniteCheck 9327 96 (10^275) 546 magnitudes_9327 = true := D1Bound5.PellLightProduction.checked_9327
#check D1Bound5.PellLightProduction.checked_9335
example : pellLightFiniteCheck 9335 96 (10^275) 602 magnitudes_9335 = true := D1Bound5.PellLightProduction.checked_9335
#check D1Bound5.PellLightProduction.checked_9343
example : pellLightFiniteCheck 9343 96 (10^275) 591 magnitudes_9343 = true := D1Bound5.PellLightProduction.checked_9343
#check D1Bound5.PellLightProduction.checked_9367
example : pellLightFiniteCheck 9367 96 (10^275) 570 magnitudes_9367 = true := D1Bound5.PellLightProduction.checked_9367
#check D1Bound5.PellLightProduction.checked_9383
example : pellLightFiniteCheck 9383 96 (10^275) 434 magnitudes_9383 = true := D1Bound5.PellLightProduction.checked_9383
#check D1Bound5.PellLightProduction.checked_9391
example : pellLightFiniteCheck 9391 96 (10^275) 564 magnitudes_9391 = true := D1Bound5.PellLightProduction.checked_9391
#check D1Bound5.PellLightProduction.checked_9399
example : pellLightFiniteCheck 9399 96 (10^275) 398 magnitudes_9399 = true := D1Bound5.PellLightProduction.checked_9399
#check D1Bound5.PellLightProduction.checked_9407
example : pellLightFiniteCheck 9407 96 (10^275) 256 magnitudes_9407 = true := D1Bound5.PellLightProduction.checked_9407
#check D1Bound5.PellLightProduction.checked_9415
example : pellLightFiniteCheck 9415 97 (10^275) 360 magnitudes_9415 = true := D1Bound5.PellLightProduction.checked_9415
#check D1Bound5.PellLightProduction.checked_9431
example : pellLightFiniteCheck 9431 97 (10^275) 393 magnitudes_9431 = true := D1Bound5.PellLightProduction.checked_9431
#check D1Bound5.PellLightProduction.checked_9439
example : pellLightFiniteCheck 9439 97 (10^275) 525 magnitudes_9439 = true := D1Bound5.PellLightProduction.checked_9439
#check D1Bound5.PellLightProduction.checked_9447
example : pellLightFiniteCheck 9447 97 (10^275) 413 magnitudes_9447 = true := D1Bound5.PellLightProduction.checked_9447
end

namespace D1Bound5.PellLightProduction
#check D1Bound5.PellLightProduction.magnitudes_9455
#check D1Bound5.PellLightProduction.magnitudes_9463
#check D1Bound5.PellLightProduction.magnitudes_9471
#check D1Bound5.PellLightProduction.magnitudes_9479
#check D1Bound5.PellLightProduction.magnitudes_9487
#check D1Bound5.PellLightProduction.magnitudes_9503
#check D1Bound5.PellLightProduction.magnitudes_9511
#check D1Bound5.PellLightProduction.magnitudes_9519
#check D1Bound5.PellLightProduction.magnitudes_9527
#check D1Bound5.PellLightProduction.magnitudes_9535
#check D1Bound5.PellLightProduction.magnitudes_9543
#check D1Bound5.PellLightProduction.magnitudes_9551
#check D1Bound5.PellLightProduction.magnitudes_9591
#check D1Bound5.PellLightProduction.magnitudes_9599
#check D1Bound5.PellLightProduction.magnitudes_9607
#check D1Bound5.PellLightProduction.magnitudes_9615
#check D1Bound5.PellLightProduction.checked_9455
example : pellLightFiniteCheck 9455 97 (10^275) 312 magnitudes_9455 = true := D1Bound5.PellLightProduction.checked_9455
#check D1Bound5.PellLightProduction.checked_9463
example : pellLightFiniteCheck 9463 97 (10^275) 542 magnitudes_9463 = true := D1Bound5.PellLightProduction.checked_9463
#check D1Bound5.PellLightProduction.checked_9471
example : pellLightFiniteCheck 9471 97 (10^275) 422 magnitudes_9471 = true := D1Bound5.PellLightProduction.checked_9471
#check D1Bound5.PellLightProduction.checked_9479
example : pellLightFiniteCheck 9479 97 (10^275) 472 magnitudes_9479 = true := D1Bound5.PellLightProduction.checked_9479
#check D1Bound5.PellLightProduction.checked_9487
example : pellLightFiniteCheck 9487 97 (10^275) 561 magnitudes_9487 = true := D1Bound5.PellLightProduction.checked_9487
#check D1Bound5.PellLightProduction.checked_9503
example : pellLightFiniteCheck 9503 97 (10^275) 270 magnitudes_9503 = true := D1Bound5.PellLightProduction.checked_9503
#check D1Bound5.PellLightProduction.checked_9511
example : pellLightFiniteCheck 9511 97 (10^275) 549 magnitudes_9511 = true := D1Bound5.PellLightProduction.checked_9511
#check D1Bound5.PellLightProduction.checked_9519
example : pellLightFiniteCheck 9519 97 (10^275) 643 magnitudes_9519 = true := D1Bound5.PellLightProduction.checked_9519
#check D1Bound5.PellLightProduction.checked_9527
example : pellLightFiniteCheck 9527 97 (10^275) 530 magnitudes_9527 = true := D1Bound5.PellLightProduction.checked_9527
#check D1Bound5.PellLightProduction.checked_9535
example : pellLightFiniteCheck 9535 97 (10^275) 536 magnitudes_9535 = true := D1Bound5.PellLightProduction.checked_9535
#check D1Bound5.PellLightProduction.checked_9543
example : pellLightFiniteCheck 9543 97 (10^275) 513 magnitudes_9543 = true := D1Bound5.PellLightProduction.checked_9543
#check D1Bound5.PellLightProduction.checked_9551
example : pellLightFiniteCheck 9551 97 (10^275) 568 magnitudes_9551 = true := D1Bound5.PellLightProduction.checked_9551
#check D1Bound5.PellLightProduction.checked_9591
example : pellLightFiniteCheck 9591 97 (10^275) 378 magnitudes_9591 = true := D1Bound5.PellLightProduction.checked_9591
#check D1Bound5.PellLightProduction.checked_9599
example : pellLightFiniteCheck 9599 97 (10^275) 517 magnitudes_9599 = true := D1Bound5.PellLightProduction.checked_9599
#check D1Bound5.PellLightProduction.checked_9607
example : pellLightFiniteCheck 9607 98 (10^275) 438 magnitudes_9607 = true := D1Bound5.PellLightProduction.checked_9607
#check D1Bound5.PellLightProduction.checked_9615
example : pellLightFiniteCheck 9615 98 (10^275) 472 magnitudes_9615 = true := D1Bound5.PellLightProduction.checked_9615
end

namespace D1Bound5.PellLightProduction
#check D1Bound5.PellLightProduction.magnitudes_9623
#check D1Bound5.PellLightProduction.magnitudes_9631
#check D1Bound5.PellLightProduction.magnitudes_9647
#check D1Bound5.PellLightProduction.magnitudes_9655
#check D1Bound5.PellLightProduction.magnitudes_9663
#check D1Bound5.PellLightProduction.magnitudes_9671
#check D1Bound5.PellLightProduction.magnitudes_9679
#check D1Bound5.PellLightProduction.magnitudes_9687
#check D1Bound5.PellLightProduction.magnitudes_9695
#check D1Bound5.PellLightProduction.magnitudes_9703
#check D1Bound5.PellLightProduction.magnitudes_9719
#check D1Bound5.PellLightProduction.magnitudes_9727
#check D1Bound5.PellLightProduction.magnitudes_9735
#check D1Bound5.PellLightProduction.magnitudes_9743
#check D1Bound5.PellLightProduction.magnitudes_9759
#check D1Bound5.PellLightProduction.magnitudes_9767
#check D1Bound5.PellLightProduction.checked_9623
example : pellLightFiniteCheck 9623 98 (10^275) 485 magnitudes_9623 = true := D1Bound5.PellLightProduction.checked_9623
#check D1Bound5.PellLightProduction.checked_9631
example : pellLightFiniteCheck 9631 98 (10^275) 518 magnitudes_9631 = true := D1Bound5.PellLightProduction.checked_9631
#check D1Bound5.PellLightProduction.checked_9647
example : pellLightFiniteCheck 9647 98 (10^275) 521 magnitudes_9647 = true := D1Bound5.PellLightProduction.checked_9647
#check D1Bound5.PellLightProduction.checked_9655
example : pellLightFiniteCheck 9655 98 (10^275) 510 magnitudes_9655 = true := D1Bound5.PellLightProduction.checked_9655
#check D1Bound5.PellLightProduction.checked_9663
example : pellLightFiniteCheck 9663 98 (10^275) 549 magnitudes_9663 = true := D1Bound5.PellLightProduction.checked_9663
#check D1Bound5.PellLightProduction.checked_9671
example : pellLightFiniteCheck 9671 98 (10^275) 552 magnitudes_9671 = true := D1Bound5.PellLightProduction.checked_9671
#check D1Bound5.PellLightProduction.checked_9679
example : pellLightFiniteCheck 9679 98 (10^275) 477 magnitudes_9679 = true := D1Bound5.PellLightProduction.checked_9679
#check D1Bound5.PellLightProduction.checked_9687
example : pellLightFiniteCheck 9687 98 (10^275) 484 magnitudes_9687 = true := D1Bound5.PellLightProduction.checked_9687
#check D1Bound5.PellLightProduction.checked_9695
example : pellLightFiniteCheck 9695 98 (10^275) 504 magnitudes_9695 = true := D1Bound5.PellLightProduction.checked_9695
#check D1Bound5.PellLightProduction.checked_9703
example : pellLightFiniteCheck 9703 98 (10^275) 442 magnitudes_9703 = true := D1Bound5.PellLightProduction.checked_9703
#check D1Bound5.PellLightProduction.checked_9719
example : pellLightFiniteCheck 9719 98 (10^275) 508 magnitudes_9719 = true := D1Bound5.PellLightProduction.checked_9719
#check D1Bound5.PellLightProduction.checked_9727
example : pellLightFiniteCheck 9727 98 (10^275) 531 magnitudes_9727 = true := D1Bound5.PellLightProduction.checked_9727
#check D1Bound5.PellLightProduction.checked_9735
example : pellLightFiniteCheck 9735 98 (10^275) 396 magnitudes_9735 = true := D1Bound5.PellLightProduction.checked_9735
#check D1Bound5.PellLightProduction.checked_9743
example : pellLightFiniteCheck 9743 98 (10^275) 582 magnitudes_9743 = true := D1Bound5.PellLightProduction.checked_9743
#check D1Bound5.PellLightProduction.checked_9759
example : pellLightFiniteCheck 9759 98 (10^275) 559 magnitudes_9759 = true := D1Bound5.PellLightProduction.checked_9759
#check D1Bound5.PellLightProduction.checked_9767
example : pellLightFiniteCheck 9767 98 (10^275) 552 magnitudes_9767 = true := D1Bound5.PellLightProduction.checked_9767
end

namespace D1Bound5.PellLightProduction
#check D1Bound5.PellLightProduction.magnitudes_9791
#check D1Bound5.PellLightProduction.magnitudes_9799
#check D1Bound5.PellLightProduction.magnitudes_9807
#check D1Bound5.PellLightProduction.magnitudes_9815
#check D1Bound5.PellLightProduction.magnitudes_9823
#check D1Bound5.PellLightProduction.magnitudes_9831
#check D1Bound5.PellLightProduction.magnitudes_9839
#check D1Bound5.PellLightProduction.magnitudes_9847
#check D1Bound5.PellLightProduction.magnitudes_9863
#check D1Bound5.PellLightProduction.magnitudes_9871
#check D1Bound5.PellLightProduction.magnitudes_9879
#check D1Bound5.PellLightProduction.magnitudes_9887
#check D1Bound5.PellLightProduction.magnitudes_9895
#check D1Bound5.PellLightProduction.magnitudes_9903
#check D1Bound5.PellLightProduction.magnitudes_9911
#check D1Bound5.PellLightProduction.magnitudes_9919
#check D1Bound5.PellLightProduction.checked_9791
example : pellLightFiniteCheck 9791 98 (10^275) 527 magnitudes_9791 = true := D1Bound5.PellLightProduction.checked_9791
#check D1Bound5.PellLightProduction.checked_9799
example : pellLightFiniteCheck 9799 98 (10^275) 256 magnitudes_9799 = true := D1Bound5.PellLightProduction.checked_9799
#check D1Bound5.PellLightProduction.checked_9807
example : pellLightFiniteCheck 9807 99 (10^275) 144 magnitudes_9807 = true := D1Bound5.PellLightProduction.checked_9807
#check D1Bound5.PellLightProduction.checked_9815
example : pellLightFiniteCheck 9815 99 (10^275) 376 magnitudes_9815 = true := D1Bound5.PellLightProduction.checked_9815
#check D1Bound5.PellLightProduction.checked_9823
example : pellLightFiniteCheck 9823 99 (10^275) 168 magnitudes_9823 = true := D1Bound5.PellLightProduction.checked_9823
#check D1Bound5.PellLightProduction.checked_9831
example : pellLightFiniteCheck 9831 99 (10^275) 472 magnitudes_9831 = true := D1Bound5.PellLightProduction.checked_9831
#check D1Bound5.PellLightProduction.checked_9839
example : pellLightFiniteCheck 9839 99 (10^275) 519 magnitudes_9839 = true := D1Bound5.PellLightProduction.checked_9839
#check D1Bound5.PellLightProduction.checked_9847
example : pellLightFiniteCheck 9847 99 (10^275) 318 magnitudes_9847 = true := D1Bound5.PellLightProduction.checked_9847
#check D1Bound5.PellLightProduction.checked_9863
example : pellLightFiniteCheck 9863 99 (10^275) 267 magnitudes_9863 = true := D1Bound5.PellLightProduction.checked_9863
#check D1Bound5.PellLightProduction.checked_9871
example : pellLightFiniteCheck 9871 99 (10^275) 324 magnitudes_9871 = true := D1Bound5.PellLightProduction.checked_9871
#check D1Bound5.PellLightProduction.checked_9879
example : pellLightFiniteCheck 9879 99 (10^275) 523 magnitudes_9879 = true := D1Bound5.PellLightProduction.checked_9879
#check D1Bound5.PellLightProduction.checked_9887
example : pellLightFiniteCheck 9887 99 (10^275) 529 magnitudes_9887 = true := D1Bound5.PellLightProduction.checked_9887
#check D1Bound5.PellLightProduction.checked_9895
example : pellLightFiniteCheck 9895 99 (10^275) 340 magnitudes_9895 = true := D1Bound5.PellLightProduction.checked_9895
#check D1Bound5.PellLightProduction.checked_9903
example : pellLightFiniteCheck 9903 99 (10^275) 491 magnitudes_9903 = true := D1Bound5.PellLightProduction.checked_9903
#check D1Bound5.PellLightProduction.checked_9911
example : pellLightFiniteCheck 9911 99 (10^275) 498 magnitudes_9911 = true := D1Bound5.PellLightProduction.checked_9911
#check D1Bound5.PellLightProduction.checked_9919
example : pellLightFiniteCheck 9919 99 (10^275) 529 magnitudes_9919 = true := D1Bound5.PellLightProduction.checked_9919
end

namespace D1Bound5.PellLightProduction
#check D1Bound5.PellLightProduction.magnitudes_9935
#check D1Bound5.PellLightProduction.magnitudes_9943
#check D1Bound5.PellLightProduction.magnitudes_9951
#check D1Bound5.PellLightProduction.magnitudes_9959
#check D1Bound5.PellLightProduction.magnitudes_9967
#check D1Bound5.PellLightProduction.magnitudes_9983
#check D1Bound5.PellLightProduction.magnitudes_9991
#check D1Bound5.PellLightProduction.checked_9935
example : pellLightFiniteCheck 9935 99 (10^275) 504 magnitudes_9935 = true := D1Bound5.PellLightProduction.checked_9935
#check D1Bound5.PellLightProduction.checked_9943
example : pellLightFiniteCheck 9943 99 (10^275) 590 magnitudes_9943 = true := D1Bound5.PellLightProduction.checked_9943
#check D1Bound5.PellLightProduction.checked_9951
example : pellLightFiniteCheck 9951 99 (10^275) 329 magnitudes_9951 = true := D1Bound5.PellLightProduction.checked_9951
#check D1Bound5.PellLightProduction.checked_9959
example : pellLightFiniteCheck 9959 99 (10^275) 470 magnitudes_9959 = true := D1Bound5.PellLightProduction.checked_9959
#check D1Bound5.PellLightProduction.checked_9967
example : pellLightFiniteCheck 9967 99 (10^275) 567 magnitudes_9967 = true := D1Bound5.PellLightProduction.checked_9967
#check D1Bound5.PellLightProduction.checked_9983
example : pellLightFiniteCheck 9983 99 (10^275) 450 magnitudes_9983 = true := D1Bound5.PellLightProduction.checked_9983
#check D1Bound5.PellLightProduction.checked_9991
example : pellLightFiniteCheck 9991 99 (10^275) 440 magnitudes_9991 = true := D1Bound5.PellLightProduction.checked_9991
end

