import D1Bound5.FiniteN3Height
import D1Bound5.FiniteHomogeneousRatio

noncomputable section

namespace D1Bound5

def finiteN3RatioRootCoeff {R : Type*} [CommRing R] (x y : R) (i : Fin 3) (j : Fin 2) : Fin 4 → R :=
  ![finiteHomogeneousTwo 4 (finiteN3Coeff0 i j) x y,
    finiteHomogeneousTwo 5 (finiteN3Coeff1 i j) x y,
    finiteHomogeneousTwo 6 (finiteN3Coeff2 i j) x y,
    finiteHomogeneousTwo 7 (finiteN3Coeff3 i j) x y]

theorem finiteN3_ratio_root_decomposition {R : Type*} [CommRing R]
    (x y c : R) (i : Fin 3) (j : Fin 2) :
    ![finiteN3Left x y c i,finiteN3Right x y c i] j =
      ∑ ell : Fin 4, finiteN3RatioRootCoeff x y i j ell*c^(ell : ℕ) := by
  rw [finiteN3_root_coeff_decomposition]
  simp [finiteN3RatioRootCoeff,Fin.sum_univ_succ]
  <;> ring

def finiteN3RatioWeights (r : ℝ) (i : Fin 3) : Fin 4 → ℝ :=
  ![finiteHomogeneousRatioWeight 4 (finiteN3Coeff0 i 0) r+finiteHomogeneousRatioWeight 4 (finiteN3Coeff0 i 1) r,
    finiteHomogeneousRatioWeight 5 (finiteN3Coeff1 i 0) r+finiteHomogeneousRatioWeight 5 (finiteN3Coeff1 i 1) r,
    finiteHomogeneousRatioWeight 6 (finiteN3Coeff2 i 0) r+finiteHomogeneousRatioWeight 6 (finiteN3Coeff2 i 1) r,
    finiteHomogeneousRatioWeight 7 (finiteN3Coeff3 i 0) r+finiteHomogeneousRatioWeight 7 (finiteN3Coeff3 i 1) r]

def fiveRegionN3Height : Fin 5 → ℝ := ![282,697,1306,1652,3553]

theorem finiteN3RatioWeights_nonneg (r : ℝ) (hr : 0 ≤ r) (i : Fin 3) (ell : Fin 4) :
    0 ≤ finiteN3RatioWeights r i ell := by
  fin_cases ell
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 4 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 4 _ r hr)
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 5 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 5 _ r hr)
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 6 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 6 _ r hr)
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 7 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 7 _ r hr)

theorem finiteN3_root_coefficient_norm_le_ratio (x y : ℂ) (r : ℝ)
    (hr : 0 ≤ r) (hxy : ‖x‖ ≤ r*‖y‖) (i : Fin 3) (ell : Fin 4) :
    ‖finiteN3RatioRootCoeff x y i 0 ell‖+‖finiteN3RatioRootCoeff x y i 1 ell‖ ≤
      finiteN3RatioWeights r i ell*‖y‖^(4+(ell : ℕ)) := by
  fin_cases ell
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 4 (finiteN3Coeff0 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 4 (finiteN3Coeff0 i 1) x y r hr hxy)
    simpa [finiteN3RatioRootCoeff,finiteN3RatioWeights,add_mul] using h
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 5 (finiteN3Coeff1 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 5 (finiteN3Coeff1 i 1) x y r hr hxy)
    simpa [finiteN3RatioRootCoeff,finiteN3RatioWeights,add_mul] using h
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 6 (finiteN3Coeff2 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 6 (finiteN3Coeff2 i 1) x y r hr hxy)
    simpa [finiteN3RatioRootCoeff,finiteN3RatioWeights,add_mul] using h
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 7 (finiteN3Coeff3 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 7 (finiteN3Coeff3 i 1) x y r hr hxy)
    simpa [finiteN3RatioRootCoeff,finiteN3RatioWeights,add_mul] using h

set_option maxHeartbeats 4000000 in
/-- The five displayed coefficient constants are checked directly from the
actual integer coefficient vectors at their exact rational anchor ratios. -/
theorem finiteN3_five_region_height_slack (region : Fin 5) (i : Fin 3) :
    (101/100 : ℝ)*(∑ ell : Fin 4,
      finiteN3RatioWeights (fiveRegionAnchorRatio region) i ell/(1000 : ℝ)^(3-(ell : ℕ))) <
      fiveRegionN3Height region := by
  fin_cases region <;> fin_cases i <;>
    norm_num [finiteN3RatioWeights,fiveRegionAnchorRatio,fiveRegionN3Height,finiteHomogeneousRatioWeight,
      finiteN3Coeff0, finiteN3Coeff1, finiteN3Coeff2, finiteN3Coeff3,Fin.sum_univ_succ]

/-- Actual ratio-refined height for the constructed finite family. The
statement supplies no coefficient or height certificate: the integer rows
and all five rational table margins are proved above. -/
theorem finiteN3_height_five_regions (region : Fin 5) (x y c : ℂ)
    (hy : y ≠ 0) (hxy : ‖x‖ ≤ fiveRegionAnchorRatio region*‖y‖)
    (hYC : 1000 ≤ ‖y‖*‖c‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteN3Left x y c i‖+‖finiteN3Right x y c i‖) <
      fiveRegionN3Height region*‖y‖^7*‖c‖^3 := by
  let r := fiveRegionAnchorRatio region
  have hr : 0 ≤ r := fiveRegionAnchorRatio_nonneg region
  have hcoeff := finitePolynomial_two_columns_norm_le 3 4
    (finiteN3RatioRootCoeff x y i) (finiteN3RatioWeights r i) c ‖y‖
    (finiteN3_root_coefficient_norm_le_ratio x y r hr hxy i)
  have hleft := finiteN3_ratio_root_decomposition x y c i 0
  have hright := finiteN3_ratio_root_decomposition x y c i 1
  change finiteN3Left x y c i = _ at hleft
  change finiteN3Right x y c i = _ at hright
  rw [← hleft,← hright] at hcoeff
  have hscaled := mul_le_mul_of_nonneg_left hcoeff (show (0 : ℝ) ≤ 101/100 by norm_num)
  have hs := finitePolynomial_height_scalar 3 (finiteN3RatioWeights r i)
    (finiteN3RatioWeights_nonneg r hr i) (fiveRegionN3Height region) (‖y‖*‖c‖) hYC
    (finiteN3_five_region_height_slack region i)
  have hm := mul_lt_mul_of_pos_left hs (pow_pos (norm_pos_iff.mpr hy) 4)
  apply hscaled.trans_lt
  convert hm using 1 <;> simp only [mul_pow] <;> ring

end D1Bound5
