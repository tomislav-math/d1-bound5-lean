import D1Bound5.HalfBinomialCoefficients
import Lean.Util.CollectAxioms

open Lean Elab Command

/- Check the fully elaborated types and reject any additional transitive axioms. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.halfBinomialCoeff_recurrence,
    `D1Bound5.halfBinomialCoeff_signed_nonneg,
    `D1Bound5.halfBinomialCoeff_abs_next_le,
    `D1Bound5.halfBinomialCoeff_abs_antitone,
    `D1Bound5.halfBinomialCoeff_abs_le_half,
    `D1Bound5.halfBinomialCoeff_signed_pair_nonneg,
    `D1Bound5.halfBinomialCoeff_convolution_zero]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let forbidden := axs.filter fun a => !allowed.contains a
    unless forbidden.isEmpty do
      throwError "Forbidden axioms for {n}: {forbidden}"
    logInfo m!"HALF_BINOMIAL_AXIOMS {n}: {axs}"
  logInfo m!"HALF_BINOMIAL_AXIOMS_PASS: {names.length} theorems"

#check @D1Bound5.halfBinomialCoeff
#check @D1Bound5.halfBinomialCoeff_recurrence
#check @D1Bound5.halfBinomialCoeff_signed_nonneg
#check @D1Bound5.halfBinomialCoeff_abs_next_le
#check @D1Bound5.halfBinomialCoeff_abs_antitone
#check @D1Bound5.halfBinomialCoeff_abs_le_half
#check @D1Bound5.halfBinomialCoeff_signed_pair_nonneg
#check @D1Bound5.halfBinomialCoeff_convolution_zero
