import D1Bound5.RationalSquares
import Mathlib.Algebra.Order.Ring.Abs

namespace D1Bound5

/-- An integer strictly between consecutive nonnegative integer squares
cannot itself be a square. The witness is checked by integer arithmetic. -/
theorem integer_square_floor_obstruction {m k : ℤ}
    (hk : 0 ≤ k) (hlo : k ^ 2 < m) (hhi : m < (k + 1) ^ 2) :
    ¬ ∃ n : ℤ, m = n ^ 2 := by
  rintro ⟨n, rfl⟩
  have hlo' : k ^ 2 < |n| ^ 2 := by simpa only [sq_abs] using hlo
  have hhi' : |n| ^ 2 < (k + 1) ^ 2 := by simpa only [sq_abs] using hhi
  have hnlo : k < |n| := (sq_lt_sq₀ hk (abs_nonneg n)).mp hlo'
  have hnhi : |n| < k + 1 := (sq_lt_sq₀ (abs_nonneg n) (by omega)).mp hhi'
  omega

/-- The same obstruction after multiplication by a positive integer.
No divisibility hypothesis or integer division is required. -/
theorem integer_scaled_square_floor_obstruction {scale m k : ℤ}
    (hscale : 0 < scale) (hk : 0 ≤ k)
    (hlo : scale * k ^ 2 < m) (hhi : m < scale * (k + 1) ^ 2) :
    ¬ ∃ n : ℤ, m = scale * n ^ 2 := by
  rintro ⟨n, rfl⟩
  exact integer_square_floor_obstruction hk
    ((mul_lt_mul_iff_of_pos_left hscale).mp hlo)
    ((mul_lt_mul_iff_of_pos_left hscale).mp hhi) ⟨n, rfl⟩

/-- Positive rational radicands in an imaginary quadratic coordinate
ring reduce to ordinary integer squares. -/
theorem positive_integer_square_floor_obstruction {tau nu m k : ℤ}
    (hd : 0 < QuadInt.discriminant tau nu) (hk : 0 ≤ k)
    (hlo : k ^ 2 < m) (hhi : m < (k + 1) ^ 2) :
    ¬ ∃ r : QuadInt tau nu, r * r = (m : QuadInt tau nu) := by
  intro hr
  have hm : 0 < m := lt_of_le_of_lt (sq_nonneg k) hlo
  exact integer_square_floor_obstruction hk hlo hhi
    (positive_integer_square_is_integer hd hm hr)

/-- Negative rational radicands in the trace-zero model reduce to
minus the defining parameter times an ordinary integer square. -/
theorem negative_integer_square_floor_obstruction_trace_zero {nu m k : ℤ}
    (hnu : 0 < nu) (hk : 0 ≤ k)
    (hlo : nu * k ^ 2 < -m) (hhi : -m < nu * (k + 1) ^ 2) :
    ¬ ∃ r : QuadInt 0 nu, r * r = (m : QuadInt 0 nu) := by
  intro hr
  have hneg : 0 < -m := lt_of_le_of_lt (mul_nonneg hnu.le (sq_nonneg k)) hlo
  have hm : m < 0 := by omega
  obtain ⟨n, hn⟩ := negative_integer_square_trace_zero hm hr
  apply integer_scaled_square_floor_obstruction hnu hk hlo hhi
  exact ⟨n, by nlinarith only [hn]⟩

/-- Negative rational radicands in the trace-one model reduce to
minus the discriminant times an ordinary integer square. -/
theorem negative_integer_square_floor_obstruction_trace_one {nu m k : ℤ}
    (hd : 0 < 4 * nu - 1) (hk : 0 ≤ k)
    (hlo : (4 * nu - 1) * k ^ 2 < -m)
    (hhi : -m < (4 * nu - 1) * (k + 1) ^ 2) :
    ¬ ∃ r : QuadInt 1 nu, r * r = (m : QuadInt 1 nu) := by
  intro hr
  have hneg : 0 < -m := lt_of_le_of_lt (mul_nonneg hd.le (sq_nonneg k)) hlo
  have hm : m < 0 := by omega
  obtain ⟨n, hn⟩ := negative_integer_square_trace_one hm hr
  apply integer_scaled_square_floor_obstruction hd hk hlo hhi
  exact ⟨n, by nlinarith only [hn]⟩

namespace QuadInt

/-- A nonsquare algebraic norm rules out a square radicand, without
any discriminant, nonzero, or coordinate-sign hypothesis. -/
theorem norm_nonsquare_obstruction {tau nu : ℤ} (z : QuadInt tau nu)
    (h : ¬ ∃ n : ℤ, z.norm = n ^ 2) :
    ¬ ∃ r : QuadInt tau nu, r * r = z := by
  rintro ⟨r, hr⟩
  apply h
  refine ⟨r.norm, ?_⟩
  rw [← hr, map_mul, pow_two]

/-- A floor witness for the algebraic norm is a square obstruction for
an arbitrary radicand. In particular, the radicand need not be real. -/
theorem norm_floor_obstruction {tau nu k : ℤ} (z : QuadInt tau nu)
    (hk : 0 ≤ k) (hlo : k ^ 2 < z.norm) (hhi : z.norm < (k + 1) ^ 2) :
    ¬ ∃ r : QuadInt tau nu, r * r = z :=
  norm_nonsquare_obstruction z (integer_square_floor_obstruction hk hlo hhi)

/-- Check one natural-number floor witness for a radicand. The branch
is determined entirely by the radicand and coordinate ring: nonreal
radicands use the norm, positive real ones use the ordinary square gap,
and negative real ones use the exact trace-zero or trace-one scale. -/
def floorObstructionBool {tau nu : ℤ} (z : QuadInt tau nu) (k : ℕ) : Bool :=
  if z.im = 0 then
    if 0 < z.re then
      decide ((k : ℤ) ^ 2 < z.re ∧ z.re < ((k : ℤ) + 1) ^ 2)
    else if tau = 0 then
      decide (nu * (k : ℤ) ^ 2 < -z.re ∧ -z.re < nu * ((k : ℤ) + 1) ^ 2)
    else if tau = 1 then
      decide ((4 * nu - 1) * (k : ℤ) ^ 2 < -z.re ∧
        -z.re < (4 * nu - 1) * ((k : ℤ) + 1) ^ 2)
    else false
  else
    decide ((k : ℤ) ^ 2 < z.norm ∧ z.norm < ((k : ℤ) + 1) ^ 2)

/-- Soundness of the inexpensive floor-witness checker. It uses the
accepted rational-square classification and multiplicativity of norm;
no candidate square root is computed. -/
theorem floorObstructionBool_sound {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) {z : QuadInt tau nu} {k : ℕ}
    (h : floorObstructionBool z k = true) :
    ¬ ∃ r : QuadInt tau nu, r * r = z := by
  have hk : (0 : ℤ) ≤ k := Int.natCast_nonneg k
  by_cases him : z.im = 0
  · have hz : z = (z.re : QuadInt tau nu) := by
      apply QuadraticAlgebra.ext
      · simp only [QuadraticAlgebra.re_intCast, Int.cast_id]
      · simpa only [QuadraticAlgebra.im_intCast] using him
    by_cases hm : 0 < z.re
    · have hf : (k : ℤ) ^ 2 < z.re ∧ z.re < ((k : ℤ) + 1) ^ 2 := by
        simpa only [floorObstructionBool, if_pos him, if_pos hm, decide_eq_true_eq] using h
      intro hr
      apply positive_integer_square_floor_obstruction hd hk hf.1 hf.2
      simpa only [← hz] using hr
    · by_cases ht0 : tau = 0
      · subst tau
        have hnu : 0 < nu := by
          dsimp [discriminant] at hd
          norm_num at hd
          omega
        have hf : nu * (k : ℤ) ^ 2 < -z.re ∧
            -z.re < nu * ((k : ℤ) + 1) ^ 2 := by
          simpa only [floorObstructionBool, if_pos him, if_neg hm,
            if_pos (rfl : (0 : ℤ) = 0), decide_eq_true_eq] using h
        intro hr
        apply negative_integer_square_floor_obstruction_trace_zero hnu hk hf.1 hf.2
        simpa only [← hz] using hr
      · by_cases ht1 : tau = 1
        · subst tau
          have hd' : 0 < 4 * nu - 1 := by simpa only [discriminant, one_pow] using hd
          have hf : (4 * nu - 1) * (k : ℤ) ^ 2 < -z.re ∧
              -z.re < (4 * nu - 1) * ((k : ℤ) + 1) ^ 2 := by
            simpa only [floorObstructionBool, if_pos him, if_neg hm,
              if_neg ht0, if_pos (rfl : (1 : ℤ) = 1), decide_eq_true_eq] using h
          intro hr
          apply negative_integer_square_floor_obstruction_trace_one hd' hk hf.1 hf.2
          simpa only [← hz] using hr
        · simp only [floorObstructionBool, if_pos him, if_neg hm,
            if_neg ht0, if_neg ht1, Bool.false_eq_true] at h
  · have hf : (k : ℤ) ^ 2 < z.norm ∧ z.norm < ((k : ℤ) + 1) ^ 2 := by
      simpa only [floorObstructionBool, if_neg him, decide_eq_true_eq] using h
    exact norm_floor_obstruction z hk hf.1 hf.2

end QuadInt
end D1Bound5
