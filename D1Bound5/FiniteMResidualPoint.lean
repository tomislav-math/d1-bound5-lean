import D1Bound5.FiniteMBennettIdentity
import D1Bound5.BennettResidualBound
import D1Bound5.FiniteEtaBound

open Finset Polynomial

namespace D1Bound5

noncomputable def finiteMResidual (a b s c : ℂ) (i : Fin 4) : ℂ :=
  ∑ j, finiteMMatrix a b s c i j *
    (1+finiteMNodes a b s j*(a*b*s*c)⁻¹)^(1/2 : ℂ)

theorem finiteM_choose_abs : |Ring.choose (5/2 : ℝ) 8| = 45/32768 := by
  have h := bennett_factorial_mul_abs_choose (5/2 : ℝ) 8
  norm_num [descPochhammer_eval_eq_prod_range, Finset.prod_range_succ] at h
  linarith only [h]

theorem finiteMRowFactor_ne_zero (a b s : ℂ)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0)
    (hab : a ≠ b) (has : a ≠ s) (hbs : b ≠ s) (i : Fin 4) :
    finiteMRowFactor a b s i ≠ 0 := by
  fin_cases i <;> simp [finiteMRowFactor, ha, hb, hs,
    sub_ne_zero.mpr hab, sub_ne_zero.mpr has, sub_ne_zero.mpr hbs]

theorem finiteM_residual_identity (a b s c : ℂ)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0)
    (hab : a ≠ b) (has : a ≠ s) (hbs : b ≠ s) (i : Fin 4) :
    finiteMRowFactor a b s i * finiteMResidual a b s c i =
      ∑ j, finiteMBennettEntry a b s c i j *
        (1+finiteMNodes a b s j*(a*b*s*c)⁻¹)^(1/2 : ℂ) := by
  unfold finiteMResidual
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _
  rw [finiteM_bennett_identity a b s c ha hb hs hab has hbs]
  ring

/-- The exact order-eight residual zero gives a C^-6 bound for the
constructed order-two M family, before the row-factor geometry is bounded. -/
theorem finiteM_residual_norm_lt_point (a b s c : ℂ)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0) (hc : c ≠ 0)
    (hab : a ≠ b) (has : a ≠ s) (hbs : b ≠ s)
    (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖)
    (hAC : 1000 ≤ ‖a‖*‖c‖) (i : Fin 4) :
    ‖finiteMResidual a b s c i‖ <
      (101/100 : ℝ)*(45/2048)*(‖a-b‖*‖a-s‖*‖b-s‖)^4 /
        (‖a‖^2*‖b‖^2*‖s‖^2*‖c‖^6*‖finiteMRowFactor a b s i‖) := by
  have hA := norm_pos_iff.mpr ha
  have hB := norm_pos_iff.mpr hb
  have hS := norm_pos_iff.mpr hs
  have hC := norm_pos_iff.mpr hc
  have hD1 := norm_pos_iff.mpr (sub_ne_zero.mpr hab)
  have hD2 := norm_pos_iff.mpr (sub_ne_zero.mpr has)
  have hD3 := norm_pos_iff.mpr (sub_ne_zero.mpr hbs)
  have hrow := norm_pos_iff.mpr (finiteMRowFactor_ne_zero a b s ha hb hs hab has hbs i)
  have hN : a*b*s*c ≠ 0 := mul_ne_zero (mul_ne_zero (mul_ne_zero ha hb) hs) hc
  have hr : (‖b‖*‖s‖)*‖(a*b*s*c)⁻¹‖ = 1/(‖a‖*‖c‖) := by
    simp only [norm_inv, norm_mul]
    field_simp [hA.ne', hB.ne', hS.ne', hC.ne']
    <;> ring
  have hradius : (‖b‖*‖s‖)*‖(a*b*s*c)⁻¹‖ < 1 := by
    rw [hr]
    exact (div_lt_one (mul_pos hA hC)).mpr (by linarith only [hAC])
  have hnodes (j : Fin 4) : ‖finiteMNodes a b s j‖ ≤ ‖b‖*‖s‖ := by
    fin_cases j
    · simpa [finiteMNodes] using mul_nonneg hB.le hS.le
    · simp [finiteMNodes, norm_mul]
    · simpa [finiteMNodes, norm_mul] using mul_le_mul_of_nonneg_right hAB hS.le
    · simpa [finiteMNodes, norm_mul, mul_comm] using
        mul_le_mul_of_nonneg_left (hAB.trans hBS) hB.le
  have hp := bennettPolynomialResidue_residual_norm_le
    (finiteMNodes a b s) (finiteMNodes_injective a b s ha hb hs hab has hbs)
    2 (by decide) (1/2 : ℝ) (‖b‖*‖s‖) ((a*b*s*c)⁻¹) i
    (by norm_num) (mul_nonneg hB.le hS.le) hnodes hradius
  have hpoly :
      ‖∑ j, (bennettPolynomialResidue univ (finiteMNodes a b s) 2
        (1/2 : ℂ) i j).eval ((a*b*s*c)⁻¹) *
          (1+finiteMNodes a b s j*(a*b*s*c)⁻¹)^(1/2 : ℂ)‖ ≤
      (45/32768 : ℝ)*‖(a*b*s*c)⁻¹‖^8 /
        (1-1/(‖a‖*‖c‖))^(11/2 : ℝ) := by
    rw [hr] at hp
    norm_num [finiteM_choose_abs] at hp ⊢
    exact hp
  let scale : ℂ := (4*(a*b*s)^2*((a-b)*(a-s)*(b-s))^2)^2 * (a*b*s*c)^2
  have hscaleRow :
      (∑ j, finiteMBennettEntry a b s c i j *
        (1+finiteMNodes a b s j*(a*b*s*c)⁻¹)^(1/2 : ℂ)) =
      scale * ∑ j, (bennettPolynomialResidue univ (finiteMNodes a b s) 2
        (1/2 : ℂ) i j).eval ((a*b*s*c)⁻¹) *
          (1+finiteMNodes a b s j*(a*b*s*c)⁻¹)^(1/2 : ℂ) := by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro j _
    rw [finiteMBennettEntry,
      ← bennettPolynomialResidue_homogenize univ (finiteMNodes a b s) 2
        (1/2 : ℂ) (a*b*s*c) i j hN]
    dsimp [scale]
    ring
  have heta0 : 0 < 1-1/(‖a‖*‖c‖) := by
    apply sub_pos.mpr
    exact (div_lt_one (mul_pos hA hC)).mpr (by linarith only [hAC])
  have hepow := Real.rpow_pos_of_pos heta0 (11/2 : ℝ)
  have hfour : ‖(4 : ℂ)‖ = (4 : ℝ) := by norm_num
  have halg : ‖scale‖*((45/32768 : ℝ)*‖(a*b*s*c)⁻¹‖^8 /
        (1-1/(‖a‖*‖c‖))^(11/2 : ℝ)) =
      ((45/2048 : ℝ)*(‖a-b‖*‖a-s‖*‖b-s‖)^4 /
        (‖a‖^2*‖b‖^2*‖s‖^2*‖c‖^6)) *
          (1/(1-1/(‖a‖*‖c‖))^(11/2 : ℝ)) := by
    simp only [scale, norm_mul, norm_pow, hfour, norm_inv]
    field_simp [hA.ne', hB.ne', hS.ne', hC.ne', hepow.ne']
    <;> ring
  have heta := finite_eta_reciprocal_lt (‖a‖*‖c‖) (11/2 : ℝ) hAC (by norm_num)
  have hmain : ‖finiteMRowFactor a b s i‖*‖finiteMResidual a b s c i‖ <
      ((45/2048 : ℝ)*(‖a-b‖*‖a-s‖*‖b-s‖)^4 /
        (‖a‖^2*‖b‖^2*‖s‖^2*‖c‖^6))*(101/100 : ℝ) := by
    rw [← norm_mul, finiteM_residual_identity a b s c ha hb hs hab has hbs i,
      hscaleRow, norm_mul]
    apply (mul_le_mul_of_nonneg_left hpoly (norm_nonneg scale)).trans_lt
    rw [halg]
    exact mul_lt_mul_of_pos_left heta (by positivity)
  have hm := (lt_div_iff₀ hrow).mpr
    (show ‖finiteMResidual a b s c i‖*‖finiteMRowFactor a b s i‖ <
      ((45/2048 : ℝ)*(‖a-b‖*‖a-s‖*‖b-s‖)^4 /
        (‖a‖^2*‖b‖^2*‖s‖^2*‖c‖^6))*(101/100 : ℝ) from by
      simpa only [mul_comm] using hmain)
  calc
    ‖finiteMResidual a b s c i‖ <
        ((45/2048 : ℝ)*(‖a-b‖*‖a-s‖*‖b-s‖)^4 /
          (‖a‖^2*‖b‖^2*‖s‖^2*‖c‖^6))*(101/100 : ℝ) /
            ‖finiteMRowFactor a b s i‖ := hm
    _ = _ := by
      simp only [div_eq_mul_inv, mul_inv_rev]
      ring

end D1Bound5
