import D1Bound5.ComplexHalfBinomial
import D1Bound5.HalfBinomialAnalytic
import D1Bound5.HalfBinomialLowDegree
import Lean.Util.CollectAxioms

open Lean Elab Command

run_cmd do
  let names : List Name := [
    `D1Bound5.halfBinomialWeightedCoeff,
    `D1Bound5.halfBinomialWeightedCoeff_norm_le,
    `D1Bound5.halfBinomialWeightedCoeff_tail_norm_le,
    `D1Bound5.coherent_half_binomial_tail_summable_and_norm_le,
    `D1Bound5.halfBinomialCoeff_hasSum_cpow,
    `D1Bound5.halfBinomialCoeff_cauchy_hasSum,
    `D1Bound5.halfBinomialCoeff_cauchy_rearrange,
    `D1Bound5.halfBinomialCoeff_weighted_hasSum,
    `D1Bound5.halfBinomialWeightedCoeff_two,
    `D1Bound5.halfBinomialWeightedCoeff_three,
    `D1Bound5.halfBinomialWeightedCoeff_four]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axioms ← Lean.collectAxioms n
    let extra := axioms.filter fun a => !allowed.contains a
    unless extra.isEmpty do
      throwError "Forbidden axioms in {n}: {extra}"
    logInfo m!"RECOVERY_AXIOMS {n}: {axioms}"
  logInfo m!"RECOVERY_AXIOMS_PASS: {names.length} declarations"

#check @D1Bound5.halfBinomialWeightedCoeff
#check @D1Bound5.halfBinomialWeightedCoeff_norm_le
#check @D1Bound5.halfBinomialWeightedCoeff_tail_norm_le
#check @D1Bound5.coherent_half_binomial_tail_summable_and_norm_le
#check @D1Bound5.halfBinomialCoeff_hasSum_cpow
#check @D1Bound5.halfBinomialCoeff_cauchy_hasSum
#check @D1Bound5.halfBinomialCoeff_cauchy_rearrange
#check @D1Bound5.halfBinomialCoeff_weighted_hasSum
#check @D1Bound5.halfBinomialWeightedCoeff_two
#check @D1Bound5.halfBinomialWeightedCoeff_three
#check @D1Bound5.halfBinomialWeightedCoeff_four
