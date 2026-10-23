import D1Bound5.FiniteA3Coefficients
import D1Bound5.FiniteHomogeneousRatio

noncomputable section

namespace D1Bound5

def finiteA3RatioWeights (r : ℝ) (i : Fin 3) : Fin 4 → ℝ :=
  ![finiteHomogeneousRatioWeight 3 (finiteA3Coeff0 i 0) r+finiteHomogeneousRatioWeight 3 (finiteA3Coeff0 i 1) r,
    finiteHomogeneousRatioWeight 4 (finiteA3Coeff1 i 0) r+finiteHomogeneousRatioWeight 4 (finiteA3Coeff1 i 1) r,
    finiteHomogeneousRatioWeight 5 (finiteA3Coeff2 i 0) r+finiteHomogeneousRatioWeight 5 (finiteA3Coeff2 i 1) r,
    finiteHomogeneousRatioWeight 6 (finiteA3Coeff3 i 0) r+finiteHomogeneousRatioWeight 6 (finiteA3Coeff3 i 1) r]

def fiveRegionA3Height : Fin 5 → ℝ := ![145,326,663,863,1944]

theorem finiteA3RatioWeights_nonneg (r : ℝ) (hr : 0 ≤ r) (i : Fin 3) (ell : Fin 4) :
    0 ≤ finiteA3RatioWeights r i ell := by
  fin_cases ell
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 3 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 3 _ r hr)
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 4 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 4 _ r hr)
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 5 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 5 _ r hr)
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 6 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 6 _ r hr)

theorem finiteA3_root_coefficient_norm_le_ratio (x y : ℂ) (r : ℝ)
    (hr : 0 ≤ r) (hxy : ‖x‖ ≤ r*‖y‖) (i : Fin 3) (ell : Fin 4) :
    ‖finiteA3RootCoeff x y i 0 ell‖+‖finiteA3RootCoeff x y i 1 ell‖ ≤
      finiteA3RatioWeights r i ell*‖y‖^(3+(ell : ℕ)) := by
  fin_cases ell
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 3 (finiteA3Coeff0 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 3 (finiteA3Coeff0 i 1) x y r hr hxy)
    simpa [finiteA3RootCoeff,finiteA3RatioWeights,add_mul] using h
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 4 (finiteA3Coeff1 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 4 (finiteA3Coeff1 i 1) x y r hr hxy)
    simpa [finiteA3RootCoeff,finiteA3RatioWeights,add_mul] using h
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 5 (finiteA3Coeff2 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 5 (finiteA3Coeff2 i 1) x y r hr hxy)
    simpa [finiteA3RootCoeff,finiteA3RatioWeights,add_mul] using h
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 6 (finiteA3Coeff3 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 6 (finiteA3Coeff3 i 1) x y r hr hxy)
    simpa [finiteA3RootCoeff,finiteA3RatioWeights,add_mul] using h

set_option maxHeartbeats 4000000 in
/-- The five displayed coefficient constants are checked directly from the
actual integer coefficient vectors at their exact rational anchor ratios. -/
theorem finiteA3_five_region_height_slack (region : Fin 5) (i : Fin 3) :
    (101/100 : ℝ)*(∑ ell : Fin 4,
      finiteA3RatioWeights (fiveRegionAnchorRatio region) i ell/(1000 : ℝ)^(3-(ell : ℕ))) <
      fiveRegionA3Height region := by
  fin_cases region <;> fin_cases i <;>
    norm_num [finiteA3RatioWeights,fiveRegionAnchorRatio,fiveRegionA3Height,finiteHomogeneousRatioWeight,
      finiteA3Coeff0, finiteA3Coeff1, finiteA3Coeff2, finiteA3Coeff3,Fin.sum_univ_succ,
      Matrix.cons_val_two, Matrix.cons_val_three, Matrix.head_cons, Matrix.tail_cons]

/-- Actual ratio-refined height for the constructed finite family. The
statement supplies no coefficient or height certificate: the integer rows
and all five rational table margins are proved above. -/
theorem finiteA3_height_five_regions (region : Fin 5) (x y c : ℂ)
    (hy : y ≠ 0) (hxy : ‖x‖ ≤ fiveRegionAnchorRatio region*‖y‖)
    (hYC : 1000 ≤ ‖y‖*‖c‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteA3Left x y c i‖+‖finiteA3Right x y c i‖) <
      fiveRegionA3Height region*‖y‖^6*‖c‖^3 := by
  let r := fiveRegionAnchorRatio region
  have hr : 0 ≤ r := fiveRegionAnchorRatio_nonneg region
  have hcoeff := finitePolynomial_two_columns_norm_le 3 3
    (finiteA3RootCoeff x y i) (finiteA3RatioWeights r i) c ‖y‖
    (finiteA3_root_coefficient_norm_le_ratio x y r hr hxy i)
  have hleft := finiteA3_root_coeff_decomposition x y c i 0
  have hright := finiteA3_root_coeff_decomposition x y c i 1
  change finiteA3Left x y c i = _ at hleft
  change finiteA3Right x y c i = _ at hright
  rw [← hleft,← hright] at hcoeff
  have hscaled := mul_le_mul_of_nonneg_left hcoeff (show (0 : ℝ) ≤ 101/100 by norm_num)
  have hs := finitePolynomial_height_scalar 3 (finiteA3RatioWeights r i)
    (finiteA3RatioWeights_nonneg r hr i) (fiveRegionA3Height region) (‖y‖*‖c‖) hYC
    (finiteA3_five_region_height_slack region i)
  have hm := mul_lt_mul_of_pos_left hs (pow_pos (norm_pos_iff.mpr hy) 3)
  apply hscaled.trans_lt
  convert hm using 1 <;> simp only [mul_pow] <;> ring

end D1Bound5
