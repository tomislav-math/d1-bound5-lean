import D1Bound5.BennettTwoResidualBound
import D1Bound5.BennettTwoBetaBound
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace D1Bound5

noncomputable def bennettTwoResidualRate (A B C δ : ℝ) : ℝ :=
  27 * B * (A * C - 1) ^ 2 / (16 * A * δ ^ 2)

noncomputable def bennettTwoResidualGammaBound (A B C δ : ℝ) (k : ℕ) : ℝ :=
  (4 * δ ^ 2 / (A * B * C ^ 2)) ^ k *
    (Real.Gamma ((k : ℝ) + 3 / 2) * Real.Gamma (2 * (k : ℝ) - 1 / 2) /
      (Real.pi * Real.Gamma (3 * (k : ℝ) + 1))) /
        (1 - 1 / (A * C)) ^ (2 * (k : ℝ) - 1 / 2)

theorem bennettTwoResidualRate_pos (A B C δ : ℝ)
    (hA : 0 < A) (hB : 0 < B) (hδ : 0 < δ) (hAC : 1 < A * C) :
    0 < bennettTwoResidualRate A B C δ := by
  unfold bennettTwoResidualRate
  exact div_pos
    (mul_pos (mul_pos (by norm_num) hB) (sq_pos_of_pos (sub_pos.mpr hAC)))
    (mul_pos (mul_pos (by norm_num) hA) (sq_pos_of_pos hδ))

/-- Exact normalization of the proved Gamma residual bound by the paper's
exponential rate. No approximation inequality is assumed. -/
theorem bennettTwoResidualGammaBound_mul_rate
    (A B C δ : ℝ) (hA : 0 < A) (hB : 0 < B) (hC : 0 < C)
    (hδ : 0 < δ) (hAC : 1 < A * C) (k : ℕ) :
    bennettTwoResidualGammaBound A B C δ k * (bennettTwoResidualRate A B C δ) ^ k =
      Real.sqrt (1 - 1 / (A * C)) * bennettTwoBetaFactor k := by
  let η : ℝ := 1 - 1 / (A * C)
  let L : ℝ := 4 * δ ^ 2 / (A * B * C ^ 2)
  let R : ℝ := bennettTwoResidualRate A B C δ
  let G : ℝ := Real.Gamma ((k : ℝ) + 3 / 2) * Real.Gamma (2 * (k : ℝ) - 1 / 2) /
    (Real.pi * Real.Gamma (3 * (k : ℝ) + 1))
  have hη : 0 < η := by
    dsimp [η]
    have hdiv := (div_lt_one (mul_pos hA hC)).mpr hAC
    linarith
  have hsqrt : Real.sqrt η ≠ 0 := (Real.sqrt_pos.2 hη).ne'
  have hbase : L * R = (27 / 4 : ℝ) * η ^ 2 := by
    dsimp [L, R, η, bennettTwoResidualRate]
    field_simp [hA.ne', hB.ne', hC.ne', hδ.ne']
    <;> ring
  have hexp : η ^ (2 * (k : ℝ) - 1 / 2) = η ^ (2 * k) / Real.sqrt η := by
    rw [Real.rpow_sub hη, ← Real.sqrt_eq_rpow]
    have hcast : 2 * (k : ℝ) = ((2 * k : ℕ) : ℝ) := by push_cast; ring
    rw [hcast, Real.rpow_natCast]
  have hratio : η ^ (2 * k) / η ^ (2 * (k : ℝ) - 1 / 2) = Real.sqrt η := by
    rw [hexp]
    field_simp [hη.ne', hsqrt]
  change (L ^ k * G / η ^ (2 * (k : ℝ) - 1 / 2)) * R ^ k =
    Real.sqrt η * bennettTwoBetaFactor k
  calc
    _ = (L * R) ^ k * G / η ^ (2 * (k : ℝ) - 1 / 2) := by rw [mul_pow]; ring
    _ = ((27 / 4 : ℝ) ^ k * G) *
        (η ^ (2 * k) / η ^ (2 * (k : ℝ) - 1 / 2)) := by
      rw [hbase, mul_pow, ← pow_mul]
      ring
    _ = Real.sqrt η * bennettTwoBetaFactor k := by
      rw [hratio]
      unfold bennettTwoBetaFactor
      dsimp [G]
      ring

theorem bennettTwoResidualGammaBound_lt_half_rate
    (A B C δ : ℝ) (hA : 0 < A) (hB : 0 < B) (hC : 0 < C)
    (hδ : 0 < δ) (hAC : 1 < A * C) (k : ℕ) (hk : 1 ≤ k) :
    bennettTwoResidualGammaBound A B C δ k <
      1 / (2 * (bennettTwoResidualRate A B C δ) ^ k) := by
  have hR := bennettTwoResidualRate_pos A B C δ hA hB hδ hAC
  have hη : 0 < 1 - 1 / (A * C) := by
    have hdiv := (div_lt_one (mul_pos hA hC)).mpr hAC
    linarith
  have hη1 : 1 - 1 / (A * C) ≤ 1 :=
    sub_le_self _ (div_nonneg (by norm_num) (mul_pos hA hC).le)
  have hbound := bennettTwoBetaFactor_sqrt_mul_lt_half
    (1 - 1 / (A * C)) hη.le hη1 k hk
  rw [← bennettTwoResidualGammaBound_mul_rate A B C δ hA hB hC hδ hAC k] at hbound
  have hdiv : bennettTwoResidualGammaBound A B C δ k <
      (1 / 2 : ℝ) / (bennettTwoResidualRate A B C δ) ^ k :=
    (lt_div_iff₀ (pow_pos hR k)).mpr hbound
  simpa only [div_div, mul_comm] using hdiv

/-- Final residual inequality for every actual row of the integral Q-matrix,
with exactly the manuscript's rate R2 and factor one half. -/
theorem bennettTwoClearedEntry_residual_norm_lt_half_rate
    (a b c : ℂ) (ha : a ≠ 0) (hb : b ≠ 0) (hc : c ≠ 0) (hab : a ≠ b)
    (hAB : ‖a‖ ≤ ‖b‖) (hAC : 1 < ‖a‖ * ‖c‖)
    (k : ℕ) (hk : 1 ≤ k) (i : Fin 3) :
    ‖∑ j, bennettTwoClearedEntry a b c k i j *
        (1 + bennettTwoNodes a b j * (a * b * c)⁻¹) ^ (1 / 2 : ℂ)‖ <
      1 / (2 * (bennettTwoResidualRate ‖a‖ ‖b‖ ‖c‖ ‖a - b‖) ^ k) := by
  exact (bennettTwoClearedEntry_residual_norm_le a b c ha hb hc hab hAB hAC k hk i).trans_lt
    (bennettTwoResidualGammaBound_lt_half_rate ‖a‖ ‖b‖ ‖c‖ ‖a - b‖
      (norm_pos_iff.mpr ha) (norm_pos_iff.mpr hb) (norm_pos_iff.mpr hc)
      (norm_pos_iff.mpr (sub_ne_zero.mpr hab)) hAC k hk)

end D1Bound5
