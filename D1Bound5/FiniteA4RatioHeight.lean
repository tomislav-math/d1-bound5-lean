import D1Bound5.FiniteA4Coefficients
import D1Bound5.FiniteHomogeneousRatio

noncomputable section

namespace D1Bound5

def finiteA4RatioWeights (r : ℝ) (i : Fin 3) : Fin 5 → ℝ :=
  ![finiteHomogeneousRatioWeight 5 (finiteA4Coeff0 i 0) r+finiteHomogeneousRatioWeight 5 (finiteA4Coeff0 i 1) r,
    finiteHomogeneousRatioWeight 6 (finiteA4Coeff1 i 0) r+finiteHomogeneousRatioWeight 6 (finiteA4Coeff1 i 1) r,
    finiteHomogeneousRatioWeight 7 (finiteA4Coeff2 i 0) r+finiteHomogeneousRatioWeight 7 (finiteA4Coeff2 i 1) r,
    finiteHomogeneousRatioWeight 8 (finiteA4Coeff3 i 0) r+finiteHomogeneousRatioWeight 8 (finiteA4Coeff3 i 1) r,
    finiteHomogeneousRatioWeight 9 (finiteA4Coeff4 i 0) r+finiteHomogeneousRatioWeight 9 (finiteA4Coeff4 i 1) r]

def fiveRegionA4Height : Fin 5 → ℝ := ![4605,14771,34919,48019,134712]

theorem finiteA4RatioWeights_nonneg (r : ℝ) (hr : 0 ≤ r) (i : Fin 3) (ell : Fin 5) :
    0 ≤ finiteA4RatioWeights r i ell := by
  fin_cases ell
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 5 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 5 _ r hr)
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 6 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 6 _ r hr)
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 7 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 7 _ r hr)
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 8 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 8 _ r hr)
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 9 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 9 _ r hr)

theorem finiteA4_root_coefficient_norm_le_ratio (x y : ℂ) (r : ℝ)
    (hr : 0 ≤ r) (hxy : ‖x‖ ≤ r*‖y‖) (i : Fin 3) (ell : Fin 5) :
    ‖finiteA4RootCoeff x y i 0 ell‖+‖finiteA4RootCoeff x y i 1 ell‖ ≤
      finiteA4RatioWeights r i ell*‖y‖^(5+(ell : ℕ)) := by
  fin_cases ell
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 5 (finiteA4Coeff0 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 5 (finiteA4Coeff0 i 1) x y r hr hxy)
    simpa [finiteA4RootCoeff,finiteA4RatioWeights,add_mul] using h
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 6 (finiteA4Coeff1 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 6 (finiteA4Coeff1 i 1) x y r hr hxy)
    simpa [finiteA4RootCoeff,finiteA4RatioWeights,add_mul] using h
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 7 (finiteA4Coeff2 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 7 (finiteA4Coeff2 i 1) x y r hr hxy)
    simpa [finiteA4RootCoeff,finiteA4RatioWeights,add_mul] using h
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 8 (finiteA4Coeff3 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 8 (finiteA4Coeff3 i 1) x y r hr hxy)
    simpa [finiteA4RootCoeff,finiteA4RatioWeights,add_mul] using h
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 9 (finiteA4Coeff4 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 9 (finiteA4Coeff4 i 1) x y r hr hxy)
    simpa [finiteA4RootCoeff,finiteA4RatioWeights,add_mul] using h

set_option maxHeartbeats 4000000 in
/-- The five displayed coefficient constants are checked directly from the
actual integer coefficient vectors at their exact rational anchor ratios. -/
theorem finiteA4_five_region_height_slack (region : Fin 5) (i : Fin 3) :
    (101/100 : ℝ)*(∑ ell : Fin 5,
      finiteA4RatioWeights (fiveRegionAnchorRatio region) i ell/(1000 : ℝ)^(4-(ell : ℕ))) <
      fiveRegionA4Height region := by
  fin_cases region <;> fin_cases i <;>
    norm_num [finiteA4RatioWeights,fiveRegionAnchorRatio,fiveRegionA4Height,finiteHomogeneousRatioWeight,
      finiteA4Coeff0, finiteA4Coeff1, finiteA4Coeff2, finiteA4Coeff3, finiteA4Coeff4,Fin.sum_univ_succ,
      Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.head_cons, Matrix.tail_cons]

/-- Actual ratio-refined height for the constructed finite family. The
statement supplies no coefficient or height certificate: the integer rows
and all five rational table margins are proved above. -/
theorem finiteA4_height_five_regions (region : Fin 5) (x y c : ℂ)
    (hy : y ≠ 0) (hxy : ‖x‖ ≤ fiveRegionAnchorRatio region*‖y‖)
    (hYC : 1000 ≤ ‖y‖*‖c‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteA4Left x y c i‖+‖finiteA4Right x y c i‖) <
      fiveRegionA4Height region*‖y‖^9*‖c‖^4 := by
  let r := fiveRegionAnchorRatio region
  have hr : 0 ≤ r := fiveRegionAnchorRatio_nonneg region
  have hcoeff := finitePolynomial_two_columns_norm_le 4 5
    (finiteA4RootCoeff x y i) (finiteA4RatioWeights r i) c ‖y‖
    (finiteA4_root_coefficient_norm_le_ratio x y r hr hxy i)
  have hleft := finiteA4_root_coeff_decomposition x y c i 0
  have hright := finiteA4_root_coeff_decomposition x y c i 1
  change finiteA4Left x y c i = _ at hleft
  change finiteA4Right x y c i = _ at hright
  rw [← hleft,← hright] at hcoeff
  have hscaled := mul_le_mul_of_nonneg_left hcoeff (show (0 : ℝ) ≤ 101/100 by norm_num)
  have hs := finitePolynomial_height_scalar 4 (finiteA4RatioWeights r i)
    (finiteA4RatioWeights_nonneg r hr i) (fiveRegionA4Height region) (‖y‖*‖c‖) hYC
    (finiteA4_five_region_height_slack region i)
  have hm := mul_lt_mul_of_pos_left hs (pow_pos (norm_pos_iff.mpr hy) 5)
  apply hscaled.trans_lt
  convert hm using 1 <;> simp only [mul_pow] <;> ring

end D1Bound5
