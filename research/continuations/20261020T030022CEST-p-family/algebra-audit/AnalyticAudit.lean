import D1Bound5.FinitePMatrix
import D1Bound5.FinitePIntegralRows
import D1Bound5.FinitePMonomial
import Lean.Elab.Command
import Lean.Util.CollectAxioms
open Lean Elab Command
open scoped NumberField
open Module
set_option maxRecDepth 32768
run_cmd do
  let names : List Name := [
    `D1Bound5.finitePRLeftCoeff,
    `D1Bound5.finitePRRightCoeff,
    `D1Bound5.finitePTLeftCoeff,
    `D1Bound5.finitePTRightCoeff,
    `D1Bound5.finitePairQuadratic,
    `D1Bound5.finitePRLeft,
    `D1Bound5.finitePRRight,
    `D1Bound5.finitePTLeft,
    `D1Bound5.finitePTRight,
    `D1Bound5.finitePRConstant,
    `D1Bound5.finitePTConstant,
    `D1Bound5.finitePDividedMatrix,
    `D1Bound5.finitePMatrix,
    `D1Bound5.finitePDetFactor,
    `D1Bound5.finitePDividedMatrix_det,
    `D1Bound5.finitePMatrix_det,
    `D1Bound5.finitePLeadingFactor,
    `D1Bound5.finitePLinearFactor,
    `D1Bound5.finiteP_factor_identity,
    `D1Bound5.map_finitePLeadingFactor,
    `D1Bound5.map_finitePDividedMatrix,
    `D1Bound5.full_ring_finitePDetFactor_ne_zero,
    `D1Bound5.full_ring_finitePDividedMatrix_det_ne_zero,
    `D1Bound5.finitePRowForm,
    `D1Bound5.map_finitePRowForm,
    `D1Bound5.full_ring_finitePRowForm_exists_one_le_norm,
    `D1Bound5.finiteP_monomial_bound]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.finitePRLeftCoeff
#check @D1Bound5.finitePRRightCoeff
#check @D1Bound5.finitePTLeftCoeff
#check @D1Bound5.finitePTRightCoeff
#check @D1Bound5.finitePairQuadratic
#check @D1Bound5.finitePRLeft
#check @D1Bound5.finitePRRight
#check @D1Bound5.finitePTLeft
#check @D1Bound5.finitePTRight
#check @D1Bound5.finitePRConstant
#check @D1Bound5.finitePTConstant
#check @D1Bound5.finitePDividedMatrix
#check @D1Bound5.finitePMatrix
#check @D1Bound5.finitePDetFactor
#check @D1Bound5.finitePDividedMatrix_det
#check @D1Bound5.finitePMatrix_det
#check @D1Bound5.finitePLeadingFactor
#check @D1Bound5.finitePLinearFactor
#check @D1Bound5.finiteP_factor_identity
#check @D1Bound5.map_finitePLeadingFactor
#check @D1Bound5.map_finitePDividedMatrix
#check @D1Bound5.full_ring_finitePDetFactor_ne_zero
#check @D1Bound5.full_ring_finitePDividedMatrix_det_ne_zero
#check @D1Bound5.finitePRowForm
#check @D1Bound5.map_finitePRowForm
#check @D1Bound5.full_ring_finitePRowForm_exists_one_le_norm
#check @D1Bound5.finiteP_monomial_bound

open Finset Polynomial
namespace D1Bound5
section
variable {R : Type*} [CommRing R]

example (a b s c : R) :
    (finitePDividedMatrix a b s c).det =
      -78750*a*b*s*(a-b)^5*(a-s)*(b-s)*finitePDetFactor a b s c := by
  exact finitePDividedMatrix_det a b s c

example (a b s c : R) :
    (finitePMatrix a b s c).det =
      -78750*a^2*b^2*s^2*(a-b)^5*(a-s)*(b-s)*finitePDetFactor a b s c := by
  exact finitePMatrix_det a b s c

end

section


example {R : Type*} [CommRing R] (a b s : R) :
    (a-b)^2 = 4*finitePLeadingFactor a b s-(6*s+a+b)*finitePLinearFactor a b s := by
  exact finiteP_factor_identity a b s

example {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (a b s : R) :
    f (finitePLeadingFactor a b s) = finitePLeadingFactor (f a) (f b) (f s) := by
  exact map_finitePLeadingFactor f a b s

example {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (a b s c : R) (i j : Fin 4) :
    f (finitePDividedMatrix a b s c i j) =
      finitePDividedMatrix (f a) (f b) (f s) (f c) i j := by
  exact map_finitePDividedMatrix f a b s c i j

example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ) (a b s c : 𝓞 K)
    (hs : s ≠ 0) (hab : a ≠ b)
    (hAB : ‖phi (a : K)‖ ≤ ‖phi (b : K)‖)
    (hBS : ‖phi (b : K)‖ ≤ ‖phi (s : K)‖)
    (hC : 200*‖phi (s : K)‖ ≤ ‖phi (c : K)‖) :
    finitePDetFactor (phi (a : K)) (phi (b : K)) (phi (s : K)) (phi (c : K)) ≠ 0 := by
  exact full_ring_finitePDetFactor_ne_zero hK phi a b s c hs hab hAB hBS hC

example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ) (a b s c : 𝓞 K)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0)
    (hab : a ≠ b) (has : a ≠ s) (hbs : b ≠ s)
    (hAB : ‖phi (a : K)‖ ≤ ‖phi (b : K)‖)
    (hBS : ‖phi (b : K)‖ ≤ ‖phi (s : K)‖)
    (hC : 200*‖phi (s : K)‖ ≤ ‖phi (c : K)‖) :
    (finitePDividedMatrix (phi (a : K)) (phi (b : K)) (phi (s : K)) (phi (c : K))).det ≠ 0 := by
  exact full_ring_finitePDividedMatrix_det_ne_zero hK phi a b s c ha hb hs hab has hbs hAB hBS hC

example {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (a b s c z rA rB rS : R) (i : Fin 4) :
    f (finitePRowForm a b s c z rA rB rS i) =
      finitePRowForm (f a) (f b) (f s) (f c) (f z) (f rA) (f rB) (f rS) i := by
  exact map_finitePRowForm f a b s c z rA rB rS i

example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a b s c z rA rB rS : 𝓞 K)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0)
    (hab : a ≠ b) (has : a ≠ s) (hbs : b ≠ s) (hz : z ≠ 0)
    (hAB : ‖phi (a : K)‖ ≤ ‖phi (b : K)‖)
    (hBS : ‖phi (b : K)‖ ≤ ‖phi (s : K)‖)
    (hC : 200*‖phi (s : K)‖ ≤ ‖phi (c : K)‖) :
    ∃ i : Fin 4, 1 ≤ ‖finitePRowForm (phi (a : K)) (phi (b : K)) (phi (s : K))
      (phi (c : K)) (phi (z : K)) (phi (rA : K)) (phi (rB : K)) (phi (rS : K)) i‖ := by
  exact full_ring_finitePRowForm_exists_one_le_norm hK phi a b s c z rA rB rS ha hb hs hab has hbs hz hAB hBS hC

end

section


example (A S U V : ℝ) (q n d e : ℕ)
    (hA1 : 1 ≤ A) (hAU : A ≤ U) (hAV : A ≤ V)
    (hUS : U ≤ S) (hVS : V ≤ S) (he : e ≤ 2)
    (hsum : d+e+q ≤ n+2) :
    U^d*V^e/U^n ≤ S^2/A^q := by
  exact finiteP_monomial_bound A S U V q n d e hA1 hAU hAV hUS hVS he hsum

end

end D1Bound5
