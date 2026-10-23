import D1Bound5.FiniteN2Height
import D1Bound5.FiniteHomogeneousRatio

noncomputable section

namespace D1Bound5

def finiteN2RatioRootCoeff {R : Type*} [CommRing R] (x y : R) (i : Fin 3) (j : Fin 2) : Fin 3 → R :=
  ![finiteHomogeneousTwo 2 (finiteN2Coeff0 i j) x y,
    finiteHomogeneousTwo 3 (finiteN2Coeff1 i j) x y,
    finiteHomogeneousTwo 4 (finiteN2Coeff2 i j) x y]

theorem finiteN2_ratio_root_decomposition {R : Type*} [CommRing R]
    (x y c : R) (i : Fin 3) (j : Fin 2) :
    ![finiteN2Left x y c i,finiteN2Right x y c i] j =
      ∑ ell : Fin 3, finiteN2RatioRootCoeff x y i j ell*c^(ell : ℕ) := by
  rw [finiteN2_root_coeff_decomposition]
  simp [finiteN2RatioRootCoeff,Fin.sum_univ_succ]
  <;> ring

def finiteN2RatioWeights (r : ℝ) (i : Fin 3) : Fin 3 → ℝ :=
  ![finiteHomogeneousRatioWeight 2 (finiteN2Coeff0 i 0) r+finiteHomogeneousRatioWeight 2 (finiteN2Coeff0 i 1) r,
    finiteHomogeneousRatioWeight 3 (finiteN2Coeff1 i 0) r+finiteHomogeneousRatioWeight 3 (finiteN2Coeff1 i 1) r,
    finiteHomogeneousRatioWeight 4 (finiteN2Coeff2 i 0) r+finiteHomogeneousRatioWeight 4 (finiteN2Coeff2 i 1) r]

def fiveRegionN2Height : Fin 5 → ℝ := ![36,69,109,130,220]

theorem finiteN2RatioWeights_nonneg (r : ℝ) (hr : 0 ≤ r) (i : Fin 3) (ell : Fin 3) :
    0 ≤ finiteN2RatioWeights r i ell := by
  fin_cases ell
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 2 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 2 _ r hr)
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 3 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 3 _ r hr)
  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg 4 _ r hr)
      (finiteHomogeneousRatioWeight_nonneg 4 _ r hr)

theorem finiteN2_root_coefficient_norm_le_ratio (x y : ℂ) (r : ℝ)
    (hr : 0 ≤ r) (hxy : ‖x‖ ≤ r*‖y‖) (i : Fin 3) (ell : Fin 3) :
    ‖finiteN2RatioRootCoeff x y i 0 ell‖+‖finiteN2RatioRootCoeff x y i 1 ell‖ ≤
      finiteN2RatioWeights r i ell*‖y‖^(2+(ell : ℕ)) := by
  fin_cases ell
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 2 (finiteN2Coeff0 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 2 (finiteN2Coeff0 i 1) x y r hr hxy)
    simpa [finiteN2RatioRootCoeff,finiteN2RatioWeights,add_mul] using h
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 3 (finiteN2Coeff1 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 3 (finiteN2Coeff1 i 1) x y r hr hxy)
    simpa [finiteN2RatioRootCoeff,finiteN2RatioWeights,add_mul] using h
  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio 4 (finiteN2Coeff2 i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio 4 (finiteN2Coeff2 i 1) x y r hr hxy)
    simpa [finiteN2RatioRootCoeff,finiteN2RatioWeights,add_mul] using h

set_option maxHeartbeats 4000000 in
/-- The five displayed coefficient constants are checked directly from the
actual integer coefficient vectors at their exact rational anchor ratios. -/
theorem finiteN2_five_region_height_slack (region : Fin 5) (i : Fin 3) :
    (101/100 : ℝ)*(∑ ell : Fin 3,
      finiteN2RatioWeights (fiveRegionAnchorRatio region) i ell/(1000 : ℝ)^(2-(ell : ℕ))) <
      fiveRegionN2Height region := by
  fin_cases region <;> fin_cases i <;>
    norm_num [finiteN2RatioWeights,fiveRegionAnchorRatio,fiveRegionN2Height,finiteHomogeneousRatioWeight,
      finiteN2Coeff0, finiteN2Coeff1, finiteN2Coeff2,Fin.sum_univ_succ]

/-- Actual ratio-refined height for the constructed finite family. The
statement supplies no coefficient or height certificate: the integer rows
and all five rational table margins are proved above. -/
theorem finiteN2_height_five_regions (region : Fin 5) (x y c : ℂ)
    (hy : y ≠ 0) (hxy : ‖x‖ ≤ fiveRegionAnchorRatio region*‖y‖)
    (hYC : 1000 ≤ ‖y‖*‖c‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteN2Left x y c i‖+‖finiteN2Right x y c i‖) <
      fiveRegionN2Height region*‖y‖^4*‖c‖^2 := by
  let r := fiveRegionAnchorRatio region
  have hr : 0 ≤ r := fiveRegionAnchorRatio_nonneg region
  have hcoeff := finitePolynomial_two_columns_norm_le 2 2
    (finiteN2RatioRootCoeff x y i) (finiteN2RatioWeights r i) c ‖y‖
    (finiteN2_root_coefficient_norm_le_ratio x y r hr hxy i)
  have hleft := finiteN2_ratio_root_decomposition x y c i 0
  have hright := finiteN2_ratio_root_decomposition x y c i 1
  change finiteN2Left x y c i = _ at hleft
  change finiteN2Right x y c i = _ at hright
  rw [← hleft,← hright] at hcoeff
  have hscaled := mul_le_mul_of_nonneg_left hcoeff (show (0 : ℝ) ≤ 101/100 by norm_num)
  have hs := finitePolynomial_height_scalar 2 (finiteN2RatioWeights r i)
    (finiteN2RatioWeights_nonneg r hr i) (fiveRegionN2Height region) (‖y‖*‖c‖) hYC
    (finiteN2_five_region_height_slack region i)
  have hm := mul_lt_mul_of_pos_left hs (pow_pos (norm_pos_iff.mpr hy) 2)
  apply hscaled.trans_lt
  convert hm using 1 <;> simp only [mul_pow] <;> ring

end D1Bound5
