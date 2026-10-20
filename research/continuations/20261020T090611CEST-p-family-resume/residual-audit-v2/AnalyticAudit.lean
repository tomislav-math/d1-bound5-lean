import D1Bound5.FinitePResidualIdentity
import D1Bound5.FinitePLeadingBound
import D1Bound5.FinitePTailCoefficients
import D1Bound5.FinitePTailBound
import Lean.Elab.Command
import Lean.Util.CollectAxioms
open Lean Elab Command
open Module
set_option maxRecDepth 32768
run_cmd do
  let names : List Name := [
    `D1Bound5.finiteP_half_coefficients,
    `D1Bound5.finitePHalfRemainder_norm_le,
    `D1Bound5.finitePPairCoeff,
    `D1Bound5.finitePPairResidual,
    `D1Bound5.finitePPairTail,
    `D1Bound5.finitePLeadingR,
    `D1Bound5.finitePLeadingT,
    `D1Bound5.finitePPairResidual_eq_leading_tail,
    `D1Bound5.finitePResidual,
    `D1Bound5.finitePLeadingV,
    `D1Bound5.finitePLeading,
    `D1Bound5.finitePTail,
    `D1Bound5.finitePResidual_eq_pairs,
    `D1Bound5.finitePResidual_eq_leading_tail,
    `D1Bound5.FinitePLeadingTerm,
    `D1Bound5.finitePLeadingTerms,
    `D1Bound5.finitePLeadingTermValue,
    `D1Bound5.finitePLeading_eq_terms,
    `D1Bound5.finitePLeadingTerms_exponents,
    `D1Bound5.finitePLeadingTerms_sum,
    `D1Bound5.finitePLeading_norm_le,
    `D1Bound5.finitePTailCoeffTerms,
    `D1Bound5.finitePTailCoeffWeight,
    `D1Bound5.finitePTailCoeffTerms_admissible,
    `D1Bound5.finitePTailCoeffWeight_sum,
    `D1Bound5.finitePPairCoeff_eq_terms,
    `D1Bound5.finitePPairCoeff_norm_le,
    `D1Bound5.finitePPairTail_norm_le,
    `D1Bound5.finitePTail_norm_lt]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.finiteP_half_coefficients
#check @D1Bound5.finitePHalfRemainder_norm_le
#check @D1Bound5.finitePPairCoeff
#check @D1Bound5.finitePPairResidual
#check @D1Bound5.finitePPairTail
#check @D1Bound5.finitePLeadingR
#check @D1Bound5.finitePLeadingT
#check @D1Bound5.finitePPairResidual_eq_leading_tail
#check @D1Bound5.finitePResidual
#check @D1Bound5.finitePLeadingV
#check @D1Bound5.finitePLeading
#check @D1Bound5.finitePTail
#check @D1Bound5.finitePResidual_eq_pairs
#check @D1Bound5.finitePResidual_eq_leading_tail
#check @D1Bound5.FinitePLeadingTerm
#check @D1Bound5.finitePLeadingTerms
#check @D1Bound5.finitePLeadingTermValue
#check @D1Bound5.finitePLeading_eq_terms
#check @D1Bound5.finitePLeadingTerms_exponents
#check @D1Bound5.finitePLeadingTerms_sum
#check @D1Bound5.finitePLeading_norm_le
#check @D1Bound5.finitePTailCoeffTerms
#check @D1Bound5.finitePTailCoeffWeight
#check @D1Bound5.finitePTailCoeffTerms_admissible
#check @D1Bound5.finitePTailCoeffWeight_sum
#check @D1Bound5.finitePPairCoeff_eq_terms
#check @D1Bound5.finitePPairCoeff_norm_le
#check @D1Bound5.finitePPairTail_norm_le
#check @D1Bound5.finitePTail_norm_lt

open Finset Polynomial
namespace D1Bound5
section


example :
    halfBinomialCoeff 5 = 7/256 ∧ halfBinomialCoeff 6 = -21/1024 ∧
    halfBinomialCoeff 7 = 33/2048 := by
  exact finiteP_half_coefficients

example (n : ℕ) (z : ℂ)
    (hn : 6 ≤ n) (hz : ‖z‖ < 1) :
    ‖finiteQHalfRemainder n z‖ ≤ (21/1024 : ℝ)*‖z‖^n/(1-‖z‖) := by
  exact finitePHalfRemainder_norm_le n z hn hz

example (u v c : ℂ)
    (hu : u ≠ 0) (hv : v ≠ 0) (hc : c ≠ 0) (kind : Fin 2) :
    finitePPairResidual u v c kind =
      ![finitePLeadingR u v,finitePLeadingT u v] kind/c^5+finitePPairTail u v c kind := by
  exact finitePPairResidual_eq_leading_tail u v c hu hv hc kind

example (a b s c : ℂ) (i : Fin 4) :
    finitePResidual a b s c i =
      ![finitePPairResidual a b c 0,
        finitePPairResidual a b c 0+finitePPairResidual b s c 0-finitePPairResidual a s c 0,
        finitePPairResidual a b c 1,finitePPairResidual a s c 1-finitePPairResidual b s c 1] i := by
  exact finitePResidual_eq_pairs a b s c i

example (a b s c : ℂ)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0) (hc : c ≠ 0) (i : Fin 4) :
    finitePResidual a b s c i = finitePLeading a b s i/c^5+finitePTail a b s c i := by
  exact finitePResidual_eq_leading_tail a b s c ha hb hs hc i

end

section


example (a b s : ℂ) (ha : a ≠ 0) (hb : b ≠ 0)
    (hs : s ≠ 0) (i : Fin 4) :
    finitePLeading a b s i =
      (∑ t, finitePLeadingTermValue ![a,b,s] (finitePLeadingTerms i t))/256 := by
  exact finitePLeading_eq_terms a b s ha hb hs i

example (i : Fin 4) (t : Fin 12) :
    let u := finitePLeadingTerms i t
    u.2.2.2.1 ≤ 2 ∧ u.2.2.2.1+3 ≤ u.2.2.2.2+2 := by
  exact finitePLeadingTerms_exponents i t

example (i : Fin 4) :
    (∑ t, |((finitePLeadingTerms i t).1 : ℝ)|) ≤ 560 := by
  exact finitePLeadingTerms_sum i

example (a b s : ℂ)
    (hA : 1 ≤ ‖a‖) (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖) (i : Fin 4) :
    ‖finitePLeading a b s i‖ ≤ (35/16 : ℝ)*‖s‖^2/‖a‖^3 := by
  exact finitePLeading_norm_le a b s hA hAB hBS i

end

section


example (kind side : Fin 2) (l t : Fin 3) :
    (finitePTailCoeffTerms kind side l t).2.2 ≤ 2 ∧
      (finitePTailCoeffTerms kind side l t).2.1+
        (finitePTailCoeffTerms kind side l t).2.2 ≤ 3+(l : ℕ) := by
  exact finitePTailCoeffTerms_admissible kind side l t

example (kind : Fin 2) :
    (∑ side : Fin 2, ∑ l : Fin 3, finitePTailCoeffWeight kind side l) =
      ![876,2676] kind := by
  exact finitePTailCoeffWeight_sum kind

example (u v : ℂ) (kind side : Fin 2) (l : Fin 3) :
    finitePPairCoeff u v kind side l =
      ∑ t : Fin 3, ((finitePTailCoeffTerms kind side l t).1 : ℂ)*
        (![u,v] side)^(finitePTailCoeffTerms kind side l t).2.1*
        (![v,u] side)^(finitePTailCoeffTerms kind side l t).2.2 := by
  exact finitePPairCoeff_eq_terms u v kind side l

example (u v : ℂ) (A S : ℝ)
    (hA1 : 1 ≤ A) (hAu : A ≤ ‖u‖) (hAv : A ≤ ‖v‖)
    (huS : ‖u‖ ≤ S) (hvS : ‖v‖ ≤ S)
    (kind side : Fin 2) (l : Fin 3) :
    ‖finitePPairCoeff u v kind side l‖ ≤
      (finitePTailCoeffWeight kind side l : ℝ)*(S^2/A^4)*
        ‖![u,v] side‖^(5+(l : ℕ)) := by
  exact finitePPairCoeff_norm_le u v A S hA1 hAu hAv huS hvS kind side l

end

section


example (u v c : ℂ) (A S : ℝ)
    (hA1 : 1 ≤ A) (hAu : A ≤ ‖u‖) (hAv : A ≤ ‖v‖)
    (huS : ‖u‖ ≤ S) (hvS : ‖v‖ ≤ S) (hAC : 1000 ≤ A*‖c‖) (kind : Fin 2) :
    ‖finitePPairTail u v c kind‖ ≤ (![876,2676] kind : ℕ)*
      ((21/1024 : ℝ)*(1000/999)*S^2/(A^4*‖c‖^6)) := by
  exact finitePPairTail_norm_le u v c A S hA1 hAu hAv huS hvS hAC kind

example (a b s c : ℂ)
    (hA : 1 ≤ ‖a‖) (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖)
    (hAC : 1000 ≤ ‖a‖*‖c‖) (i : Fin 4) :
    ‖finitePTail a b s c i‖ < (1/8 : ℝ)*‖s‖^2/(‖a‖^3*‖c‖^5) := by
  exact finitePTail_norm_lt a b s c hA hAB hBS hAC i

end

end D1Bound5
