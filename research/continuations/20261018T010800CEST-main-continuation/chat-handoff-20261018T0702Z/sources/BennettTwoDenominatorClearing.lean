import D1Bound5.BennettClearedResidues

namespace D1Bound5

variable {F : Type*} [Field F] [CharZero F]

/-- Exact monomial cancellation when the exponent left after clearing is
known to be nonnegative. -/
theorem bennett_cancel_power_denominator (x : F) (hx : x ≠ 0)
    (u v t : ℕ) (h : u = v + t) : x ^ u * (x⁻¹) ^ v = x ^ t := by
  rw [h, pow_add]
  calc
    _ = (x ^ v * (x⁻¹) ^ v) * x ^ t := by ring
    _ = _ := by rw [← mul_pow, mul_inv_cancel₀ hx, one_pow, one_mul]

/-- Column zero of the two-anchor construction: clearing the pole denominators
leaves an ordinary polynomial monomial. The omitted signs and generalized
choose factors are scalar factors, handled independently. -/
theorem bennett_two_clear_column_zero
    (a b c : F) (ha : a ≠ 0) (hb : b ≠ 0)
    (k d0 d1 d2 h0 h1 h2 : ℕ) (hk : 1 ≤ k)
    (hd : d0 + d1 + d2 = 1) (hh : h0 + h1 + h2 + 1 = k + d0) :
    (a * b * (a - b) ^ 2) ^ k * (a * b * c) ^ (k - h0) *
        (b⁻¹) ^ (k + d1 + h1) * (a⁻¹) ^ (k + d2 + h2) =
      a ^ (d1 + h1) * b ^ (d2 + h2) * c ^ (k - h0) *
        (a - b) ^ (2 * k) := by
  have hA : a ^ k * a ^ (k - h0) * (a⁻¹) ^ (k + d2 + h2) =
      a ^ (d1 + h1) := by
    rw [← pow_add]
    apply bennett_cancel_power_denominator a ha
    omega
  have hB : b ^ k * b ^ (k - h0) * (b⁻¹) ^ (k + d1 + h1) =
      b ^ (d2 + h2) := by
    rw [← pow_add]
    apply bennett_cancel_power_denominator b hb
    omega
  calc
    _ = (a ^ k * a ^ (k - h0) * (a⁻¹) ^ (k + d2 + h2)) *
        (b ^ k * b ^ (k - h0) * (b⁻¹) ^ (k + d1 + h1)) *
          c ^ (k - h0) * (a - b) ^ (2 * k) := by
      simp only [mul_pow, ← pow_mul]
      ring
    _ = _ := by rw [hA, hB]

/-- Column one of the two-anchor construction. The exact remaining factor
`a^k` is the column divisibility used by the arithmetic row-form argument. -/
theorem bennett_two_clear_column_one
    (a b c : F) (hb : b ≠ 0) (hab : a ≠ b)
    (k d0 d1 d2 h0 h1 h2 : ℕ) (hk : 1 ≤ k)
    (hd : d0 + d1 + d2 = 1) (hh : h0 + h1 + h2 + 1 = k + d1) :
    (a * b * (a - b) ^ 2) ^ k * (a * b * c + b) ^ (k - h1) *
        (b⁻¹) ^ (k + d0 + h0) * ((a - b)⁻¹) ^ (k + d2 + h2) =
      a ^ k * (a * c + 1) ^ (k - h1) * b ^ (d2 + h2) *
        (a - b) ^ (k - (d2 + h2)) := by
  have hbase : a * b * c + b = b * (a * c + 1) := by ring
  have hB : b ^ k * b ^ (k - h1) * (b⁻¹) ^ (k + d0 + h0) =
      b ^ (d2 + h2) := by
    rw [← pow_add]
    apply bennett_cancel_power_denominator b hb
    omega
  have hD : (a - b) ^ (2 * k) * ((a - b)⁻¹) ^ (k + d2 + h2) =
      (a - b) ^ (k - (d2 + h2)) := by
    apply bennett_cancel_power_denominator (a - b) (sub_ne_zero.mpr hab)
    omega
  rw [hbase]
  calc
    _ = a ^ k * (a * c + 1) ^ (k - h1) *
        (b ^ k * b ^ (k - h1) * (b⁻¹) ^ (k + d0 + h0)) *
          ((a - b) ^ (2 * k) * ((a - b)⁻¹) ^ (k + d2 + h2)) := by
      simp only [mul_pow, ← pow_mul]
      ring
    _ = _ := by rw [hB, hD]

/-- Column two of the two-anchor construction, with its exact `b^k`
divisibility and every surviving nonnegative difference exponent. -/
theorem bennett_two_clear_column_two
    (a b c : F) (ha : a ≠ 0) (hab : a ≠ b)
    (k d0 d1 d2 h0 h1 h2 : ℕ) (hk : 1 ≤ k)
    (hd : d0 + d1 + d2 = 1) (hh : h0 + h1 + h2 + 1 = k + d2) :
    (a * b * (a - b) ^ 2) ^ k * (a * b * c + a) ^ (k - h2) *
        (a⁻¹) ^ (k + d0 + h0) * ((a - b)⁻¹) ^ (k + d1 + h1) =
      b ^ k * (b * c + 1) ^ (k - h2) * a ^ (d1 + h1) *
        (a - b) ^ (k - (d1 + h1)) := by
  have hbase : a * b * c + a = a * (b * c + 1) := by ring
  have hA : a ^ k * a ^ (k - h2) * (a⁻¹) ^ (k + d0 + h0) =
      a ^ (d1 + h1) := by
    rw [← pow_add]
    apply bennett_cancel_power_denominator a ha
    omega
  have hD : (a - b) ^ (2 * k) * ((a - b)⁻¹) ^ (k + d1 + h1) =
      (a - b) ^ (k - (d1 + h1)) := by
    apply bennett_cancel_power_denominator (a - b) (sub_ne_zero.mpr hab)
    omega
  rw [hbase]
  calc
    _ = b ^ k * (b * c + 1) ^ (k - h2) *
        (a ^ k * a ^ (k - h2) * (a⁻¹) ^ (k + d0 + h0)) *
          ((a - b) ^ (2 * k) * ((a - b)⁻¹) ^ (k + d1 + h1)) := by
      simp only [mul_pow, ← pow_mul]
      ring
    _ = _ := by rw [hA, hD]

/-- Restoring the signs of the actual poles at zero. -/
theorem bennett_two_clear_column_zero_signed
    (a b c : F) (ha : a ≠ 0) (hb : b ≠ 0)
    (k d0 d1 d2 h0 h1 h2 : ℕ) (hk : 1 ≤ k)
    (hd : d0 + d1 + d2 = 1) (hh : h0 + h1 + h2 + 1 = k + d0) :
    (a * b * (a - b) ^ 2) ^ k * (a * b * c) ^ (k - h0) *
        ((-b)⁻¹) ^ (k + d1 + h1) * ((-a)⁻¹) ^ (k + d2 + h2) =
      (-1 : F) ^ ((k + d1 + h1) + (k + d2 + h2)) *
        (a ^ (d1 + h1) * b ^ (d2 + h2) * c ^ (k - h0) *
          (a - b) ^ (2 * k)) := by
  calc
    _ = (-1 : F) ^ ((k + d1 + h1) + (k + d2 + h2)) *
        ((a * b * (a - b) ^ 2) ^ k * (a * b * c) ^ (k - h0) *
          (b⁻¹) ^ (k + d1 + h1) * (a⁻¹) ^ (k + d2 + h2)) := by
      simp only [inv_neg]
      rw [show -(b⁻¹) = (-1 : F)*b⁻¹ by ring,
        show -(a⁻¹) = (-1 : F)*a⁻¹ by ring]
      simp only [mul_pow, pow_add]
      ring
    _ = _ := by rw [bennett_two_clear_column_zero a b c ha hb k d0 d1 d2 h0 h1 h2 hk hd hh]

/-- Restoring the sign of the actual pole `b-a` in column one. -/
theorem bennett_two_clear_column_one_signed
    (a b c : F) (hb : b ≠ 0) (hab : a ≠ b)
    (k d0 d1 d2 h0 h1 h2 : ℕ) (hk : 1 ≤ k)
    (hd : d0 + d1 + d2 = 1) (hh : h0 + h1 + h2 + 1 = k + d1) :
    (a * b * (a - b) ^ 2) ^ k * (a * b * c + b) ^ (k - h1) *
        (b⁻¹) ^ (k + d0 + h0) * ((b - a)⁻¹) ^ (k + d2 + h2) =
      (-1 : F) ^ (k + d2 + h2) *
        (a ^ k * (a * c + 1) ^ (k - h1) * b ^ (d2 + h2) *
          (a - b) ^ (k - (d2 + h2))) := by
  have hneg : b - a = -(a - b) := by ring
  calc
    _ = (-1 : F) ^ (k + d2 + h2) *
        ((a * b * (a - b) ^ 2) ^ k * (a * b * c + b) ^ (k - h1) *
          (b⁻¹) ^ (k + d0 + h0) * ((a - b)⁻¹) ^ (k + d2 + h2)) := by
      rw [hneg]
      simp only [inv_neg]
      rw [show -((a-b)⁻¹) = (-1 : F)*(a-b)⁻¹ by ring]
      simp only [mul_pow]
      ring
    _ = _ := by rw [bennett_two_clear_column_one a b c hb hab k d0 d1 d2 h0 h1 h2 hk hd hh]

end D1Bound5
