import D1Bound5.FiniteA5Coefficients
import D1Bound5.FiniteHomogeneousRatio

namespace D1Bound5

def finiteA5RatioWeights (r : ℝ) (i : Fin 3) : Fin 6 → ℝ :=
  ![finiteHomogeneousRatioWeight 7 (finiteA5Coeff0 i 0) r+finiteHomogeneousRatioWeight 7 (finiteA5Coeff0 i 1) r,
    finiteHomogeneousRatioWeight 8 (finiteA5Coeff1 i 0) r+finiteHomogeneousRatioWeight 8 (finiteA5Coeff1 i 1) r,
    finiteHomogeneousRatioWeight 9 (finiteA5Coeff2 i 0) r+finiteHomogeneousRatioWeight 9 (finiteA5Coeff2 i 1) r,
    finiteHomogeneousRatioWeight 10 (finiteA5Coeff3 i 0) r+finiteHomogeneousRatioWeight 10 (finiteA5Coeff3 i 1) r,
    finiteHomogeneousRatioWeight 11 (finiteA5Coeff4 i 0) r+finiteHomogeneousRatioWeight 11 (finiteA5Coeff4 i 1) r,
    finiteHomogeneousRatioWeight 12 (finiteA5Coeff5 i 0) r+finiteHomogeneousRatioWeight 12 (finiteA5Coeff5 i 1) r]

def fiveRegionA5Height : Fin 5 → ℝ := ![38390,171856,482131,701908,2400382]

theorem finiteA5RatioWeights_nonneg (r : ℝ) (hr : 0 ≤ r) (i : Fin 3) (ell : Fin 6) :
    0 ≤ finiteA5RatioWeights r i ell := by
  fin_cases ell
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 7 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 7 _ r hr)
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 8 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 8 _ r hr)
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 9 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 9 _ r hr)
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 10 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 10 _ r hr)
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 11 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 11 _ r hr)
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 12 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 12 _ r hr)

theorem finiteA5_root_coefficient_norm_le_ratio (x y : ℂ) (r : ℝ)
    (hr : 0 ≤ r) (hxy : ‖x‖ ≤ r*‖y‖) (i : Fin 3) (ell : Fin 6) :
    ‖finiteA5RootCoeff x y i 0 ell‖+‖finiteA5RootCoeff x y i 1 ell‖ ≤
      finiteA5RatioWeights r i ell*‖y‖^(7+(ell : ℕ)) := by
  fin_cases ell
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 7 (finiteA5Coeff0 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 7 (finiteA5Coeff0 i 1) x y r hr hxy)
    simpa [finiteA5RootCoeff,finiteA5RatioWeights,add_mul] using h
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 8 (finiteA5Coeff1 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 8 (finiteA5Coeff1 i 1) x y r hr hxy)
    simpa [finiteA5RootCoeff,finiteA5RatioWeights,add_mul] using h
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 9 (finiteA5Coeff2 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 9 (finiteA5Coeff2 i 1) x y r hr hxy)
    simpa [finiteA5RootCoeff,finiteA5RatioWeights,add_mul] using h
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 10 (finiteA5Coeff3 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 10 (finiteA5Coeff3 i 1) x y r hr hxy)
    simpa [finiteA5RootCoeff,finiteA5RatioWeights,add_mul] using h
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 11 (finiteA5Coeff4 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 11 (finiteA5Coeff4 i 1) x y r hr hxy)
    simpa [finiteA5RootCoeff,finiteA5RatioWeights,add_mul] using h
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 12 (finiteA5Coeff5 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 12 (finiteA5Coeff5 i 1) x y r hr hxy)
    simpa [finiteA5RootCoeff,finiteA5RatioWeights,add_mul] using h

set_option maxHeartbeats 4000000 in
/-- The five displayed coefficient constants are checked directly from the
actual integer coefficient vectors at their exact rational anchor ratios. -/
theorem finiteA5_five_region_height_slack (region : Fin 5) (i : Fin 3) :
    (101/100 : ℝ)*(∑ ell : Fin 6,
      finiteA5RatioWeights (fiveRegionAnchorRatio region) i ell/(1000 : ℝ)^(5-(ell : ℕ))) <
      fiveRegionA5Height region := by
  fin_cases region <;> fin_cases i <;>
    norm_num [finiteA5RatioWeights,fiveRegionAnchorRatio,fiveRegionA5Height,finiteHomogeneousRatioWeight,
      finiteA5Coeff0, finiteA5Coeff1, finiteA5Coeff2, finiteA5Coeff3, finiteA5Coeff4, finiteA5Coeff5,Fin.sum_univ_succ]

/-- Actual ratio-refined height for the constructed finite family. The
statement supplies no coefficient or height certificate: the integer rows
and all five rational table margins are proved above. -/
theorem finiteA5_height_five_regions (region : Fin 5) (x y c : ℂ)
    (hy : y ≠ 0) (hxy : ‖x‖ ≤ fiveRegionAnchorRatio region*‖y‖)
    (hYC : 1000 ≤ ‖y‖*‖c‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteA5Left x y c i‖+‖finiteA5Right x y c i‖) <
      fiveRegionA5Height region*‖y‖^12*‖c‖^5 := by
  let r := fiveRegionAnchorRatio region
  have hr : 0 ≤ r := fiveRegionAnchorRatio_nonneg region
  have hcoeff := finitePolynomial_two_columns_norm_le 5 7
    (finiteA5RootCoeff x y i) (finiteA5RatioWeights r i) c ‖y‖
    (finiteA5_root_coefficient_norm_le_ratio x y r hr hxy i)
  have hleft := finiteA5_root_coeff_decomposition x y c i 0
  have hright := finiteA5_root_coeff_decomposition x y c i 1
  change finiteA5Left x y c i = _ at hleft
  change finiteA5Right x y c i = _ at hright
  rw [← hleft,← hright] at hcoeff
  have hscaled := mul_le_mul_of_nonneg_left hcoeff (show (0 : ℝ) ≤ 101/100 by norm_num)
  have hs := finitePolynomial_height_scalar 5 (finiteA5RatioWeights r i)
    (finiteA5RatioWeights_nonneg r hr i) (fiveRegionA5Height region) (‖y‖*‖c‖) hYC
    (finiteA5_five_region_height_slack region i)
  have hm := mul_lt_mul_of_pos_left hs (pow_pos (norm_pos_iff.mpr hy) 7)
  apply hscaled.trans_lt
  convert hm using 1 <;> simp only [mul_pow] <;> ring

end D1Bound5
