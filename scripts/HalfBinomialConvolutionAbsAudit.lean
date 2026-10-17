import D1Bound5.HalfBinomialConvolutionAbs
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Reject any unexpected transitive axioms in all five new declarations. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.halfBinomialCoeff_interior_convolution,
    `D1Bound5.halfBinomialCoeff_abs_signed,
    `D1Bound5.halfBinomialCoeff_pair_abs_signed,
    `D1Bound5.halfBinomialCoeff_interior_abs_sum,
    `D1Bound5.halfBinomialCoeff_abs_convolution]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axioms ← Lean.collectAxioms n
    let extra := axioms.filter fun a => !allowed.contains a
    unless extra.isEmpty do
      throwError "Forbidden axioms in {n}: {extra}"
    logInfo m!"SHARP_HALF_CONV_AXIOMS {n}: {axioms}"
  logInfo m!"SHARP_HALF_CONV_AXIOMS_PASS: {names.length} declarations"

#check @D1Bound5.halfBinomialCoeff_interior_convolution
#check @D1Bound5.halfBinomialCoeff_abs_signed
#check @D1Bound5.halfBinomialCoeff_pair_abs_signed
#check @D1Bound5.halfBinomialCoeff_interior_abs_sum
#check @D1Bound5.halfBinomialCoeff_abs_convolution
