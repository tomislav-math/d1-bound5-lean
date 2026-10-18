import D1Bound5.CoupledPhaseGeometry
import Mathlib.Analysis.Calculus.Deriv.MeanValue
import Mathlib.Analysis.Calculus.Deriv.Pow

namespace D1Bound5.PhaseDerivativePilot

noncomputable def phaseHalfPolynomial (q x : ℝ) : ℝ := (4-x^2)^2*(1+(1/q)^2+x/q)
noncomputable def phaseCritical (q x : ℝ) : ℝ := 5*x^2/q+4*(1+(1/q)^2)*x-4/q

theorem phaseHalfPolynomial_deriv (q x : ℝ) :
    HasDerivAt (phaseHalfPolynomial q) (-(4-x^2)*phaseCritical q x) x := by
  have hsq : HasDerivAt (fun y : ℝ => y^2) (2*x) x := by
    simpa using! (hasDerivAt_id x).pow 2
  have hbase : HasDerivAt (fun y : ℝ => 4-y^2) (-2*x) x := by
    simpa using! (hasDerivAt_const x (4 : ℝ)).sub hsq
  have h₁ : HasDerivAt (fun y : ℝ => (4-y^2)^2)
      (2*(4-x^2)*(-2*x)) x := by
    simpa using! hbase.pow 2
  have h₂ : HasDerivAt (fun y : ℝ => 1+(1/q)^2+y/q) (1/q) x := by
    exact ((hasDerivAt_id x).div_const q).const_add (1+(1/q)^2)
  have h : HasDerivAt (phaseHalfPolynomial q)
      ((2*(4-x^2)*(-2*x))*(1+(1/q)^2+x/q)+(4-x^2)^2*(1/q)) x :=
    h₁.mul h₂
  have heq : (2*(4-x^2)*(-2*x))*(1+(1/q)^2+x/q)+(4-x^2)^2*(1/q) =
      -(4-x^2)*phaseCritical q x := by
    unfold phaseCritical
    ring
  rw [heq] at h
  exact h


#print axioms phaseHalfPolynomial_deriv
end D1Bound5.PhaseDerivativePilot
