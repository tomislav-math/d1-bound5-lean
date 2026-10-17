import D1Bound5.CoherentIntegralForms

namespace D1Bound5

/-- Vanishing of the two-anchor coherent form forces the precise
regular-quadruple equation used in the proof of the strong two-anchor
lemma.  The argument does not divide by any square root, so zero roots
are allowed. -/
theorem coherent_two_vanishing_regular_equation
    {F : Type*} [Field F] (a b p q Ra Rb z : F) (hab : a ≠ b)
    (hRa : Ra ^ 2 = (a * p + 1) * (a * q + 1))
    (hRb : Rb ^ 2 = (b * p + 1) * (b * q + 1))
    (hz : z ^ 2 = p * q + 1)
    (hL : Ra - Rb - (a - b) * z = 0) :
    (a + b - p - q) ^ 2 = 4 * (a * b + 1) * (p * q + 1) := by
  have hd : a - b ≠ 0 := sub_ne_zero.mpr hab
  have hlin : z * (Ra + Rb) = (a + b) * p * q + p + q := by
    apply (mul_left_cancel₀ hd)
    linear_combination -(Ra + Rb) * hL + hRa - hRb
  have htwice : 2 * z * Ra = 2 * a * p * q + p + q + a - b := by
    linear_combination hlin + z * hL + (a - b) * hz
  have hsq := congrArg (fun x : F => x ^ 2) htwice
  linear_combination -hsq + 4 * Ra ^ 2 * hz + 4 * (p * q + 1) * hRa

/-- The actual analytic coherent form is nonzero whenever the
regular-quadruple equation fails.  All of its square identities are
derived from the branch-fixed analytic construction. -/
theorem coherent_analytic_two_ne_zero_of_not_regular
    (a b p q eta : ℂ) (ha : a ≠ 0) (hb : b ≠ 0)
    (hp : p ≠ 0) (hq : q ≠ 0) (hab : a ≠ b)
    (heta : eta ^ 2 = p * q)
    (hreg : (a + b - p - q) ^ 2 ≠ 4 * (a * b + 1) * (p * q + 1)) :
    coherentAnchorRoot a p q eta - coherentAnchorRoot b p q eta -
      (a - b) * coherentTerminalRoot p q eta ≠ 0 := by
  intro hzero
  apply hreg
  exact coherent_two_vanishing_regular_equation a b p q
    (coherentAnchorRoot a p q eta) (coherentAnchorRoot b p q eta)
    (coherentTerminalRoot p q eta) hab
    (coherent_analytic_anchor_root_sq a p q eta ha hp hq heta)
    (coherent_analytic_anchor_root_sq b p q eta hb hp hq heta)
    (coherent_analytic_terminal_root_sq p q eta hp hq heta) hzero

end D1Bound5

#print axioms D1Bound5.coherent_two_vanishing_regular_equation
#print axioms D1Bound5.coherent_analytic_two_ne_zero_of_not_regular
