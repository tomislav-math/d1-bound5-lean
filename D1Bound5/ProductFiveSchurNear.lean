import D1Bound5.ProductFiveNormalizedQuadratic
import D1Bound5.MatrixOperatorNorm

open Matrix
open scoped Matrix.Norms.L2Operator

namespace D1Bound5

/-- An entrywise estimate for the complex L2 operator norm in dimension four. -/
theorem four_all_entries_operator_norm_lt
    (E : Matrix (Fin 4) (Fin 4) ℂ) (δ : ℝ)
    (hδ : 0 < δ) (h : ∀ i j, ‖E i j‖ < δ) :
    ‖E‖ < 4 * δ := by
  let D : Matrix (Fin 4) (Fin 4) ℂ := diagonal (fun i => E i i)
  let R : Matrix (Fin 4) (Fin 4) ℂ := E - D
  have hD : ‖D‖ < δ := by
    dsimp [D]
    rw [Matrix.l2_opNorm_diagonal]
    exact (pi_norm_lt_iff hδ).2 (fun i => h i i)
  have hdiag : ∀ i, R i i = 0 := by
    intro i
    simp [R, D, Matrix.sub_apply]
  have hoff : ∀ i j, i ≠ j → ‖R i j‖ < δ := by
    intro i j hij
    simpa [R, D, Matrix.sub_apply, Matrix.diagonal_apply, hij] using h i j
  have hR : ‖R‖ < 3 * δ :=
    four_zero_diagonal_operator_norm_lt R δ hδ hdiag hoff
  have hsplit : E = D + R := by
    dsimp [R]
    abel
  calc
    ‖E‖ = ‖D + R‖ := congrArg norm hsplit
    _ ≤ ‖D‖ + ‖R‖ := norm_add_le D R
    _ < δ + 3 * δ := add_lt_add hD hR
    _ = 4 * δ := by ring

/-- A determinant-free proximity criterion for a four-by-four Schur matrix. -/
theorem productFive_schur_near_of_entrywise
    (F G : Matrix (Fin 4) (Fin 4) ℂ)
    (hF : ‖F - halfOffDiagonal‖ ≤ (11/96 : ℝ))
    (hG : ∀ i j, ‖(G - F) i j‖ < (9/100 : ℝ)) :
    ‖G - halfOffDiagonal‖ < (1/2 : ℝ) := by
  have hpert : ‖G - F‖ < (4 : ℝ) * (9/100 : ℝ) :=
    four_all_entries_operator_norm_lt (G-F) (9/100) (by norm_num) hG
  have hdecomp : G - halfOffDiagonal =
      (G - F) + (F - halfOffDiagonal) := by abel
  calc
    ‖G - halfOffDiagonal‖ =
        ‖(G - F) + (F - halfOffDiagonal)‖ := congrArg norm hdecomp
    _ ≤ ‖G-F‖ + ‖F-halfOffDiagonal‖ := norm_add_le _ _
    _ < (4 : ℝ)*(9/100) + (11/96) := by linarith only [hpert,hF]
    _ < 1/2 := by norm_num

/-- Scalar bound for one entry of the rank-two Schur correction.
Only ordinary complex division and triangle inequalities are used. -/
theorem productFive_schur_scalar_correction_lt
    (wi wj vi vj d : ℂ)
    (hd : (54 : ℝ) ≤ ‖d‖)
    (hwi : ‖wi/d‖ < (1/18 : ℝ))
    (hwj : ‖wj/d‖ < (1/18 : ℝ))
    (hvi : ‖vi‖ < (3/4 : ℝ))
    (hvj : ‖vj‖ < (3/4 : ℝ)) :
    ‖(wi*vj + vi*wj)/d + vi*vj/d^2‖ < (9/100 : ℝ) := by
  have hdpos : (0 : ℝ) < ‖d‖ := by linarith only [hd]
  have hdn : d ≠ 0 := norm_pos_iff.mp hdpos
  have hvid : ‖vi/d‖ < (1/72 : ℝ) := by
    rw [norm_div]
    apply (div_lt_iff₀ hdpos).mpr
    linarith only [hvi, hd]
  have hvjd : ‖vj/d‖ < (1/72 : ℝ) := by
    rw [norm_div]
    apply (div_lt_iff₀ hdpos).mpr
    linarith only [hvj, hd]
  have h1 : ‖wi*vj/d‖ < (1/24 : ℝ) := by
    have heq : wi*vj/d = (wi/d)*vj := by field_simp [hdn]
    rw [heq, norm_mul]
    calc
      ‖wi/d‖ * ‖vj‖ ≤ (1/18 : ℝ)*‖vj‖ :=
        mul_le_mul_of_nonneg_right hwi.le (norm_nonneg _)
      _ < (1/18 : ℝ)*(3/4 : ℝ) :=
        mul_lt_mul_of_pos_left hvj (by norm_num)
      _ = 1/24 := by norm_num
  have h2 : ‖vi*wj/d‖ < (1/24 : ℝ) := by
    have heq : vi*wj/d = vi*(wj/d) := by field_simp [hdn]
    rw [heq, norm_mul]
    calc
      ‖vi‖ * ‖wj/d‖ ≤ (3/4 : ℝ)*‖wj/d‖ :=
        mul_le_mul_of_nonneg_right hvi.le (norm_nonneg _)
      _ < (3/4 : ℝ)*(1/18 : ℝ) :=
        mul_lt_mul_of_pos_left hwj (by norm_num)
      _ = 1/24 := by norm_num
  have h3 : ‖vi*vj/d^2‖ < (1/5184 : ℝ) := by
    have heq : vi*vj/d^2 = (vi/d)*(vj/d) := by field_simp [hdn]
    rw [heq, norm_mul]
    calc
      ‖vi/d‖*‖vj/d‖ ≤ (1/72 : ℝ)*‖vj/d‖ :=
        mul_le_mul_of_nonneg_right hvid.le (norm_nonneg _)
      _ < (1/72 : ℝ)*(1/72 : ℝ) :=
        mul_lt_mul_of_pos_left hvjd (by norm_num)
      _ = 1/5184 := by norm_num
  have hpair : ‖(wi*vj + vi*wj)/d‖ < (1/12 : ℝ) := by
    rw [add_div]
    have hh := norm_add_le (wi*vj/d) (vi*wj/d)
    linarith only [hh,h1,h2]
  have hh := norm_add_le ((wi*vj+vi*wj)/d) (vi*vj/d^2)
  have hnum : (1/12 : ℝ) + 1/5184 < 9/100 := by norm_num
  linarith only [hh,hpair,h3,hnum]

/-- Schur proximity from prefix and componentwise coordinate estimates. -/
theorem productFive_schur_near_of_coordinate_bounds
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (v w : Fin 4 → ℂ) (d : ℂ)
    (hF : ‖F - halfOffDiagonal‖ ≤ (11/96 : ℝ))
    (hd : (54 : ℝ) ≤ ‖d‖)
    (hw : ∀ i, ‖w i/d‖ < (1/18 : ℝ))
    (hv : ∀ i, ‖v i‖ < (3/4 : ℝ)) :
    ‖productFiveSchur F v w d - halfOffDiagonal‖ < (1/2 : ℝ) := by
  have hentry : ∀ i j,
      ‖(productFiveSchur F v w d - F) i j‖ < (9/100 : ℝ) := by
    intro i j
    have hh := productFive_schur_scalar_correction_lt
      (w i) (w j) (v i) (v j) d hd (hw i) (hw j) (hv i) (hv j)
    have heq : (productFiveSchur F v w d - F) i j =
        -((w i * v j + v i * w j) / d + v i * v j / d^2) := by
      simp only [Matrix.sub_apply, productFiveSchur]
      ring
    rw [heq, norm_neg]
    exact hh
  exact productFive_schur_near_of_entrywise F
    (productFiveSchur F v w d) hF hentry

/-- Ordered last-four-entry growth implies a ratio bound for every prefix coordinate. -/
theorem productFive_prefix_coordinate_div_lt_eighteenth
    (t : Fin 5 → ℂ)
    (hmon : Monotone (fun i => ‖t i‖))
    (hb : (3 : ℝ) ≤ ‖t 1‖)
    (hlarge : 2 * ‖t 1‖ * ‖t 2‖ * ‖t 3‖ < ‖t 4‖)
    (i : Fin 4) :
    ‖fivePrefixValues t i / t 4‖ < (1/18 : ℝ) := by
  have hbc : ‖t 1‖ ≤ ‖t 2‖ := hmon (by decide)
  have hc : (3 : ℝ) ≤ ‖t 2‖ := hb.trans hbc
  have hbc9 : (9 : ℝ) ≤ ‖t 1‖ * ‖t 2‖ := by
    nlinarith [mul_nonneg (sub_nonneg.mpr hb) (sub_nonneg.mpr hc)]
  have hs0 : (0 : ℝ) ≤ ‖t 3‖ := norm_nonneg _
  have h18 : (18 : ℝ) * ‖t 3‖ < ‖t 4‖ := by
    have hcoef : (18 : ℝ) ≤ 2 * ‖t 1‖ * ‖t 2‖ := by
      nlinarith only [hbc9]
    have hh := mul_le_mul_of_nonneg_right hcoef hs0
    nlinarith only [hh, hlarge]
  have hlastpos : (0 : ℝ) < ‖t 4‖ := by
    have hx : (0 : ℝ) ≤ 2 * ‖t 1‖ * ‖t 2‖ * ‖t 3‖ := by positivity
    linarith only [hx, hlarge]
  have hindex : ‖t (Fin.castAdd 1 i)‖ ≤ ‖t 3‖ := by
    apply hmon
    fin_cases i <;> decide
  change ‖t (Fin.castAdd 1 i) / t 4‖ < (1/18 : ℝ)
  rw [norm_div]
  apply (div_lt_iff₀ hlastpos).mpr
  linarith only [hindex, h18]

end D1Bound5
