import D1Bound5.HalfBinomialAnalytic

namespace D1Bound5

/-- Squaring the principal half power recovers its argument, including
zero.  No change of logarithm branch is used. -/
theorem coherent_cpow_half_sq (z : ℂ) :
    (z ^ (1 / 2 : ℂ)) ^ (2 : ℕ) = z := by
  simpa only [one_div] using
    (Complex.cpow_nat_inv_pow z (n := 2) (by decide))

/-- The chosen coherent terminal root has square `pq + 1`, for either
choice of the square root `eta` of `pq`. -/
theorem coherent_analytic_terminal_root_sq
    (p q eta : ℂ) (hp : p ≠ 0) (hq : q ≠ 0)
    (heta : eta ^ 2 = p * q) :
    (eta * ((1 + p⁻¹ * q⁻¹) ^ (1 / 2 : ℂ))) ^ 2 = p * q + 1 := by
  rw [mul_pow, coherent_cpow_half_sq, heta]
  field_simp [hp, hq] <;> ring

/-- The coherent analytic anchor root has precisely the product square
claimed in the manuscript.  Consequently any integral product root of
the same expression agrees with it up to sign. -/
theorem coherent_analytic_anchor_root_sq
    (a p q eta : ℂ) (ha : a ≠ 0) (hp : p ≠ 0) (hq : q ≠ 0)
    (heta : eta ^ 2 = p * q) :
    (a * eta * ((1 + p⁻¹ * a⁻¹) ^ (1 / 2 : ℂ)) *
      ((1 + q⁻¹ * a⁻¹) ^ (1 / 2 : ℂ))) ^ 2 =
      (a * p + 1) * (a * q + 1) := by
  simp only [mul_pow, coherent_cpow_half_sq, heta]
  field_simp [ha, hp, hq] <;> ring

/-- An independently chosen product of square roots agrees with the
coherent analytic anchor root up to sign.  This includes vanishing roots. -/
theorem coherent_analytic_anchor_root_eq_or_eq_neg
    (a p q eta r t : ℂ) (ha : a ≠ 0) (hp : p ≠ 0) (hq : q ≠ 0)
    (heta : eta ^ 2 = p * q)
    (hr : r ^ 2 = a * p + 1) (ht : t ^ 2 = a * q + 1) :
    (a * eta * ((1 + p⁻¹ * a⁻¹) ^ (1 / 2 : ℂ)) *
      ((1 + q⁻¹ * a⁻¹) ^ (1 / 2 : ℂ))) = r * t ∨
    (a * eta * ((1 + p⁻¹ * a⁻¹) ^ (1 / 2 : ℂ)) *
      ((1 + q⁻¹ * a⁻¹) ^ (1 / 2 : ℂ))) = -(r * t) := by
  apply sq_eq_sq_iff_eq_or_eq_neg.mp
  rw [coherent_analytic_anchor_root_sq a p q eta ha hp hq heta, mul_pow, hr, ht]

end D1Bound5

#print axioms D1Bound5.coherent_cpow_half_sq
#print axioms D1Bound5.coherent_analytic_terminal_root_sq
#print axioms D1Bound5.coherent_analytic_anchor_root_sq
#print axioms D1Bound5.coherent_analytic_anchor_root_eq_or_eq_neg
