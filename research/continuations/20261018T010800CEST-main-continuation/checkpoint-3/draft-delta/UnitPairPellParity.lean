import D1Bound5.UnitPairPellBounds
import D1Bound5.FullRingRationalSquares

open scoped NumberField
open Module

namespace D1Bound5

private theorem integer_square_mod_eight (u : ℤ) :
    u ^ 2 % 8 = 0 ∨ u ^ 2 % 8 = 1 ∨ u ^ 2 % 8 = 4 := by
  have h0 : 0 ≤ u % 8 := Int.emod_nonneg _ (by decide)
  have h8 : u % 8 < 8 := Int.emod_lt_of_pos _ (by decide)
  interval_cases hu : u % 8 <;> norm_num [Int.pow_emod, hu]

/-- A norm-two Pell solution has one of precisely the two relevant
parameter congruences. No primitivity or positive-root assumption is used. -/
theorem unit_pair_pell_parameter_parity (d u v : ℤ)
    (h : u ^ 2 - d * v ^ 2 = 2) : d % 8 = 7 ∨ d % 4 = 2 := by
  have hm := congrArg (fun x : ℤ => x % 8) h
  have hd0 : 0 ≤ d % 8 := Int.emod_nonneg _ (by decide)
  have hd8 : d % 8 < 8 := Int.emod_lt_of_pos _ (by decide)
  rcases integer_square_mod_eight u with hu | hu | hu <;>
    rcases integer_square_mod_eight v with hv | hv | hv <;>
    interval_cases hd : d % 8 <;>
    norm_num [Int.sub_emod, Int.mul_emod, hu, hv, hd] at hm <;> omega

/-- For even parameter, every real unit-pair magnitude is three modulo
four, including negative choices of either Pell coordinate. -/
theorem unit_pair_pell_even_magnitude (d u v : ℤ)
    (hd : d % 2 = 0) (h : u ^ 2 - d * v ^ 2 = 2) :
    (d * v ^ 2 + 1) % 4 = 3 := by
  have hm := congrArg (fun x : ℤ => x % 8) h
  have hd0 : 0 ≤ d % 8 := Int.emod_nonneg _ (by decide)
  have hd8 : d % 8 < 8 := Int.emod_lt_of_pos _ (by decide)
  have hv4 : v ^ 2 % 4 = (v ^ 2 % 8) % 4 := by omega
  rcases integer_square_mod_eight u with hu | hu | hu <;>
    rcases integer_square_mod_eight v with hv | hv | hv <;>
    interval_cases hd' : d % 8 <;>
    norm_num [Int.sub_emod, Int.mul_emod, hu, hv, hd'] at hm
  all_goals
    have hd4 : d % 4 = 2 := by omega
    have hvs : v ^ 2 % 4 = 1 := by omega
    norm_num [Int.add_emod, Int.mul_emod, hd4, hvs]

theorem unit_pair_pell_odd_parameter (d u v : ℤ)
    (hd : d % 2 ≠ 0) (h : u ^ 2 - d * v ^ 2 = 2) : d % 8 = 7 := by
  rcases unit_pair_pell_parameter_parity d u v h with h7 | h2
  · exact h7
  · omega

/-- Two positive magnitudes three modulo four cannot have their product
plus one a square in any imaginary quadratic full integer ring. -/
theorem full_ring_unit_pair_even_same_sign_impossible
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (m n : ℤ)
    (hm : 0 < m) (hn : 0 < n) (hm4 : m % 4 = 3) (hn4 : n % 4 = 3)
    (hs : ∃ r : 𝓞 K, r * r = ((m * n + 1 : ℤ) : 𝓞 K)) : False := by
  have hpos : 0 < m * n + 1 := by nlinarith [mul_pos hm hn]
  obtain ⟨r, hr⟩ := full_ring_positive_integer_square hK hpos hs
  have hmod := congrArg (fun x : ℤ => x % 4) hr
  have hr0 : 0 ≤ r % 4 := Int.emod_nonneg _ (by decide)
  have hr4 : r % 4 < 4 := Int.emod_lt_of_pos _ (by decide)
  interval_cases hr' : r % 4 <;>
    norm_num [Int.add_emod, Int.mul_emod, Int.pow_emod, hm4, hn4, hr'] at hmod

end D1Bound5
