import D1Bound5.BennettRootApproximation
import D1Bound5.BennettIntegralRowSelection
import D1Bound5.BennettWeightedHeight
import D1Bound5.BennettTwoResidualRate

open scoped NumberField
open Module

namespace D1Bound5

/-- Exact comparison of an actual integral row with its analytic residual.
The two signed root products are the same throughout the identity. -/
theorem bennettTwoRowForm_norm_le
    (a b c z sA sB : ℂ) (ha : a ≠ 0) (hb : b ≠ 0)
    (hc : c ≠ 0) (hz : z ≠ 0) (k : ℕ) (i : Fin 3) :
    ‖bennettTwoRowForm a b c z sA sB k i‖ ≤
      ‖z‖ * ‖∑ j, bennettTwoClearedEntry a b c k i j *
        (1 + bennettTwoNodes a b j * (a * b * c)⁻¹) ^ (1 / 2 : ℂ)‖ +
      ‖z‖ * (‖bennettTwoClearedEntry a b c k i 1‖ *
          ‖(1 + 1 / (a * c)) ^ (1 / 2 : ℂ) - sA / (a * z)‖ +
        ‖bennettTwoClearedEntry a b c k i 2‖ *
          ‖(1 + 1 / (b * c)) ^ (1 / 2 : ℂ) - sB / (b * z)‖) := by
  let Q : Fin 3 → ℂ := fun j => bennettTwoClearedEntry a b c k i j
  let θA : ℂ := (1 + 1 / (a * c)) ^ (1 / 2 : ℂ)
  let θB : ℂ := (1 + 1 / (b * c)) ^ (1 / 2 : ℂ)
  let R : ℂ := ∑ j, Q j *
    (1 + bennettTwoNodes a b j * (a * b * c)⁻¹) ^ (1 / 2 : ℂ)
  obtain ⟨hA, hB⟩ := bennettTwoNodes_branch_one_two a b c ha hb hc
  have hres : R = Q 0 + Q 1 * θA + Q 2 * θB := by
    dsimp only [R]
    rw [Fin.sum_univ_three, hA, hB]
    simp [bennettTwoNodes_zero, θA, θB]
  have hform : bennettTwoRowForm a b c z sA sB k i =
      z * R + z * (Q 1 * (sA / (a * z) - θA) +
        Q 2 * (sB / (b * z) - θB)) := by
    change Q 0 * z + Q 1 * (sA / a) + Q 2 * (sB / b) = _
    rw [hres]
    field_simp [ha, hb, hz]
    <;> ring
  have hnormA : ‖sA / (a * z) - θA‖ = ‖θA - sA / (a * z)‖ :=
    norm_sub_rev _ _
  have hnormB : ‖sB / (b * z) - θB‖ = ‖θB - sB / (b * z)‖ :=
    norm_sub_rev _ _
  change ‖bennettTwoRowForm a b c z sA sB k i‖ ≤
    ‖z‖ * ‖R‖ + ‖z‖ * (‖Q 1‖ * ‖θA - sA / (a * z)‖ +
      ‖Q 2‖ * ‖θB - sB / (b * z)‖)
  calc
    _ = ‖z * R + z * (Q 1 * (sA / (a * z) - θA) +
        Q 2 * (sB / (b * z) - θB))‖ := congrArg norm hform
    _ ≤ ‖z * R‖ + ‖z * (Q 1 * (sA / (a * z) - θA) +
        Q 2 * (sB / (b * z) - θB))‖ := norm_add_le _ _
    _ = ‖z‖ * ‖R‖ + ‖z‖ * ‖Q 1 * (sA / (a * z) - θA) +
        Q 2 * (sB / (b * z) - θB)‖ := by rw [norm_mul, norm_mul]
    _ ≤ ‖z‖ * ‖R‖ + ‖z‖ * (‖Q 1 * (sA / (a * z) - θA)‖ +
        ‖Q 2 * (sB / (b * z) - θB)‖) :=
      add_le_add_left (mul_le_mul_of_nonneg_left (norm_add_le _ _) (norm_nonneg z)) _
    _ = _ := by rw [norm_mul, norm_mul, hnormA, hnormB]

/-- The actual determinant row, coefficient bounds, and residual bound
give the manuscript's all-order upper estimate once the two root errors
have been produced. The following full-ring theorem produces them. -/
theorem bennettTwoRowForm_norm_lt
    (a b c z sA sB : ℂ) (ha : a ≠ 0) (hb : b ≠ 0)
    (hc : c ≠ 0) (hab : a ≠ b) (hz : z ≠ 0)
    (hAB : ‖a‖ ≤ ‖b‖) (hAC : 1000 ≤ ‖a‖ * ‖c‖)
    (herrorA : ‖(1 + 1 / (a * c)) ^ (1 / 2 : ℂ) - sA / (a * z)‖ <
      (3 / 2 : ℝ) * ‖c‖ / (‖a‖ * ‖z‖ ^ 2))
    (herrorB : ‖(1 + 1 / (b * c)) ^ (1 / 2 : ℂ) - sB / (b * z)‖ <
      (3 / 2 : ℝ) * ‖c‖ / (‖b‖ * ‖z‖ ^ 2))
    (k : ℕ) (hk : 1 ≤ k) (i : Fin 3) :
    ‖bennettTwoRowForm a b c z sA sB k i‖ <
      3 * ‖c‖ * (42 * ‖b‖ ^ 3 * ‖c‖) ^ k / (‖b‖ * ‖z‖) +
        ‖z‖ / (2 * (bennettTwoResidualRate ‖a‖ ‖b‖ ‖c‖ ‖a - b‖) ^ k) := by
  let Q : Fin 3 → ℂ := fun j => bennettTwoClearedEntry a b c k i j
  let θA : ℂ := (1 + 1 / (a * c)) ^ (1 / 2 : ℂ)
  let θB : ℂ := (1 + 1 / (b * c)) ^ (1 / 2 : ℂ)
  let R : ℂ := ∑ j, Q j *
    (1 + bennettTwoNodes a b j * (a * b * c)⁻¹) ^ (1 / 2 : ℂ)
  have hA : 0 < ‖a‖ := norm_pos_iff.mpr ha
  have hB : 0 < ‖b‖ := norm_pos_iff.mpr hb
  have hC : 0 < ‖c‖ := norm_pos_iff.mpr hc
  have hZ : 0 < ‖z‖ := norm_pos_iff.mpr hz
  have hres := bennettTwoClearedEntry_residual_norm_lt_half_rate
    a b c ha hb hc hab hAB (by linarith) k hk i
  have hres' : ‖z‖ * ‖R‖ <
      ‖z‖ / (2 * (bennettTwoResidualRate ‖a‖ ‖b‖ ‖c‖ ‖a - b‖) ^ k) := by
    calc
      _ < ‖z‖ * (1 / (2 * (bennettTwoResidualRate ‖a‖ ‖b‖ ‖c‖ ‖a - b‖) ^ k)) :=
        mul_lt_mul_of_pos_left hres hZ
      _ = _ := by ring
  have herrors : ‖z‖ * (‖Q 1‖ * ‖θA - sA / (a * z)‖ +
        ‖Q 2‖ * ‖θB - sB / (b * z)‖) ≤
      ‖z‖ * (‖Q 1‖ * ((3 / 2 : ℝ) * ‖c‖ / (‖a‖ * ‖z‖ ^ 2)) +
        ‖Q 2‖ * ((3 / 2 : ℝ) * ‖c‖ / (‖b‖ * ‖z‖ ^ 2))) := by
    apply mul_le_mul_of_nonneg_left _ hZ.le
    exact add_le_add
      (mul_le_mul_of_nonneg_left herrorA.le (norm_nonneg _))
      (mul_le_mul_of_nonneg_left herrorB.le (norm_nonneg _))
  have hscale : ‖z‖ * (‖Q 1‖ * ((3 / 2 : ℝ) * ‖c‖ / (‖a‖ * ‖z‖ ^ 2)) +
        ‖Q 2‖ * ((3 / 2 : ℝ) * ‖c‖ / (‖b‖ * ‖z‖ ^ 2))) =
      ((3 / 2 : ℝ) * ‖c‖ / ‖z‖) * (‖Q 1‖ / ‖a‖ + ‖Q 2‖ / ‖b‖) := by
    field_simp [hA.ne', hB.ne', hZ.ne']
    <;> ring
  have hheight := bennettTwoClearedEntry_weighted_height
    a b c ha hb hc hab hAB hAC k hk i
  have herror' : ‖z‖ * (‖Q 1‖ * ‖θA - sA / (a * z)‖ +
        ‖Q 2‖ * ‖θB - sB / (b * z)‖) <
      3 * ‖c‖ * (42 * ‖b‖ ^ 3 * ‖c‖) ^ k / (‖b‖ * ‖z‖) := by
    calc
      _ ≤ _ := herrors
      _ = ((3 / 2 : ℝ) * ‖c‖ / ‖z‖) * (‖Q 1‖ / ‖a‖ + ‖Q 2‖ / ‖b‖) := hscale
      _ < ((3 / 2 : ℝ) * ‖c‖ / ‖z‖) *
          (2 * (42 * ‖b‖ ^ 3 * ‖c‖) ^ k / ‖b‖) :=
        mul_lt_mul_of_pos_left hheight (by positivity)
      _ = _ := by field_simp [hB.ne', hZ.ne']; ring
  calc
    _ ≤ ‖z‖ * ‖R‖ + ‖z‖ * (‖Q 1‖ * ‖θA - sA / (a * z)‖ +
        ‖Q 2‖ * ‖θB - sB / (b * z)‖) :=
      bennettTwoRowForm_norm_le a b c z sA sB ha hb hc hz k i
    _ < ‖z‖ / (2 * (bennettTwoResidualRate ‖a‖ ‖b‖ ‖c‖ ‖a - b‖) ^ k) +
        3 * ‖c‖ * (42 * ‖b‖ ^ 3 * ‖c‖) ^ k / (‖b‖ * ‖z‖) :=
      add_lt_add hres' herror'
    _ = _ := add_comm _ _

/-- The manuscript's two-anchor Bennett inequality for actual roots in
the full integer ring of an imaginary quadratic field. Nonsingularity,
integrality, the norm lower bound, both approximation bounds, and the
nonzero terminal root are derived, not supplied as certificates. -/
theorem full_ring_bennett_two_integer_k
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a b c d rA rB vA vB z : 𝓞 K)
    (ha : a ≠ 0) (hb : b ≠ 0) (hc : c ≠ 0) (hd : d ≠ 0) (hab : a ≠ b)
    (hrA : rA ^ 2 = a * c + 1) (hrB : rB ^ 2 = b * c + 1)
    (hvA : vA ^ 2 = a * d + 1) (hvB : vB ^ 2 = b * d + 1)
    (hzsq : z ^ 2 = c * d + 1)
    (hAB : ‖phi (a : K)‖ ≤ ‖phi (b : K)‖)
    (hAC : 1000 ≤ ‖phi (a : K)‖ * ‖phi (c : K)‖)
    (hC : 4 * ‖phi (b : K)‖ < ‖phi (c : K)‖)
    (k : ℕ) (hk : 1 ≤ k) :
    1 < 3 * ‖phi (c : K)‖ * (42 * ‖phi (b : K)‖ ^ 3 * ‖phi (c : K)‖) ^ k /
        (‖phi (b : K)‖ * ‖phi (z : K)‖) +
      ‖phi (z : K)‖ / (2 * (bennettTwoResidualRate
        ‖phi (a : K)‖ ‖phi (b : K)‖ ‖phi (c : K)‖
          ‖phi (a : K) - phi (b : K)‖) ^ k) := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  have hnonzero (x : 𝓞 K) (hx : x ≠ 0) : f x ≠ 0 := by
    intro h
    apply hx
    apply hf
    simpa only [map_zero] using h
  have ha' := hnonzero a ha
  have hb' := hnonzero b hb
  have hc' := hnonzero c hc
  have hab' : f a ≠ f b := fun h => hab (hf h)
  change ‖f a‖ ≤ ‖f b‖ at hAB
  change 1000 ≤ ‖f a‖ * ‖f c‖ at hAC
  change 4 * ‖f b‖ < ‖f c‖ at hC
  have hz : z ≠ 0 := by
    intro hz0
    have hzC : (f z) ^ 2 = f c * f d + 1 := by
      simpa only [map_pow, map_mul, map_add, map_one] using congrArg f hzsq
    rw [hz0, map_zero, zero_pow (by decide : 2 ≠ 0)] at hzC
    have hcd : f c * f d = -1 := by linear_combination -hzC
    have hnorm : ‖f c‖ * ‖f d‖ = 1 := by
      rw [← norm_mul, hcd]
      norm_num
    have hB1 : 1 ≤ ‖f b‖ := one_le_norm_integer hK phi hb
    have hD1 : 1 ≤ ‖f d‖ := one_le_norm_integer hK phi hd
    have hmul := mul_le_mul_of_nonneg_left hD1 (norm_nonneg (f c))
    nlinarith only [hC, hB1, hnorm, hmul]
  have hz' := hnonzero z hz
  have hBC : 1000 ≤ ‖f b‖ * ‖f c‖ :=
    hAC.trans (mul_le_mul_of_nonneg_right hAB (norm_nonneg (f c)))
  have hCa : 4 * ‖f a‖ < ‖f c‖ := by linarith
  obtain ⟨sA, _, herrorA⟩ := bennett_exists_integral_root_ratio_bound
    f a c d z rA vA ha' hc' hz' hrA hvA hzsq hAC hCa.le
  obtain ⟨sB, _, herrorB⟩ := bennett_exists_integral_root_ratio_bound
    f b c d z rB vB hb' hc' hz' hrB hvB hzsq hBC hC.le
  obtain ⟨i, hi⟩ := full_ring_bennettTwoRowForm_exists_one_le_norm
    hK phi a b c z sA sB ha hb hab hz k hk
  change 1 ≤ ‖bennettTwoRowForm (f a) (f b) (f c) (f z) (f sA) (f sB) k i‖ at hi
  exact hi.trans_lt (bennettTwoRowForm_norm_lt (f a) (f b) (f c) (f z) (f sA) (f sB)
    ha' hb' hc' hab' hz' hAB hAC herrorA herrorB k hk i)

end D1Bound5
