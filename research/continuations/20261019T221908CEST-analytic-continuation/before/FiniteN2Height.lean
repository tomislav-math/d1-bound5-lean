import D1Bound5.FiniteN2Matrix
import D1Bound5.FiniteHomogeneousTwo
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace D1Bound5

def finiteN2Coeff0 : Fin 3 → Fin 2 → Fin 3 → ℤ :=
  ![![![0,20,-4], ![4,-20,0]],
    ![![15,10,-1], ![-4,-20,0]],
    ![![0,-20,-4], ![-1,10,15]]]

def finiteN2Coeff1 : Fin 3 → Fin 2 → Fin 4 → ℤ :=
  ![![![0,0,60,-28], ![28,-60,0,0]],
    ![![0,80,-40,8], ![12,-60,0,0]],
    ![![0,0,-60,12], ![8,-40,80,0]]]

def finiteN2Coeff2 : Fin 3 → Fin 2 → Fin 5 → ℤ :=
  ![![![0,0,0,40,-24], ![24,-40,0,0,0]],
    ![![0,0,80,-80,24], ![16,-40,0,0,0]],
    ![![0,0,0,-40,16], ![24,-80,80,0,0]]]

/-- Exact homogeneous decomposition of both divided root columns. -/
theorem finiteN2_root_coeff_decomposition {R : Type*} [CommRing R]
    (x y c : R) (i : Fin 3) (j : Fin 2) :
    ![finiteN2Left x y c i, finiteN2Right x y c i] j =
      finiteHomogeneousTwo 2 (finiteN2Coeff0 i j) x y +
      finiteHomogeneousTwo 3 (finiteN2Coeff1 i j) x y*c +
      finiteHomogeneousTwo 4 (finiteN2Coeff2 i j) x y*c^2 := by
  fin_cases i <;> fin_cases j
  all_goals
    norm_num [finiteN2Left, finiteN2Right, finiteN2Coeff0, finiteN2Coeff1,
      finiteN2Coeff2, finiteHomogeneousTwo, Fin.sum_univ_succ]
    <;> ring

/-- The coefficient sums are computed from the actual integer vectors,
not supplied as table data in a hypothesis. -/
theorem finiteN2_coefficient_sums (i : Fin 3) :
    ((∑ j, |(finiteN2Coeff0 i 0 j : ℝ)|) +
      (∑ j, |(finiteN2Coeff0 i 1 j : ℝ)|) ≤ 50) ∧
    ((∑ j, |(finiteN2Coeff1 i 0 j : ℝ)|) +
      (∑ j, |(finiteN2Coeff1 i 1 j : ℝ)|) ≤ 200) ∧
    ((∑ j, |(finiteN2Coeff2 i 0 j : ℝ)|) +
      (∑ j, |(finiteN2Coeff2 i 1 j : ℝ)|) ≤ 240) := by
  fin_cases i <;> norm_num [finiteN2Coeff0, finiteN2Coeff1, finiteN2Coeff2,
    Fin.sum_univ_succ]

theorem finiteN2_root_columns_norm_le (x y c : ℂ) (hxy : ‖x‖ ≤ ‖y‖) (i : Fin 3) :
    ‖finiteN2Left x y c i‖+‖finiteN2Right x y c i‖ ≤
      50*‖y‖^2+200*‖y‖^3*‖c‖+240*‖y‖^4*‖c‖^2 := by
  have hroot (j : Fin 2) :
      ‖![finiteN2Left x y c i,finiteN2Right x y c i] j‖ ≤
        (∑ r, |(finiteN2Coeff0 i j r : ℝ)|)*‖y‖^2 +
        (∑ r, |(finiteN2Coeff1 i j r : ℝ)|)*‖y‖^3*‖c‖ +
        (∑ r, |(finiteN2Coeff2 i j r : ℝ)|)*‖y‖^4*‖c‖^2 := by
    rw [finiteN2_root_coeff_decomposition]
    apply (finite_norm_quadratic_le _ _ _ _).trans
    have h0 := finiteHomogeneousTwo_norm_le 2 (finiteN2Coeff0 i j) x y hxy
    have h1 := finiteHomogeneousTwo_norm_le 3 (finiteN2Coeff1 i j) x y hxy
    have h2 := finiteHomogeneousTwo_norm_le 4 (finiteN2Coeff2 i j) x y hxy
    gcongr
  obtain ⟨h0,h1,h2⟩ := finiteN2_coefficient_sums i
  have h := add_le_add (hroot 0) (hroot 1)
  change ‖finiteN2Left x y c i‖+‖finiteN2Right x y c i‖ ≤ _ at h
  calc
    _ ≤ _ := h
    _ = ((∑ r, |(finiteN2Coeff0 i 0 r : ℝ)|)+
          (∑ r, |(finiteN2Coeff0 i 1 r : ℝ)|))*‖y‖^2 +
        ((∑ r, |(finiteN2Coeff1 i 0 r : ℝ)|)+
          (∑ r, |(finiteN2Coeff1 i 1 r : ℝ)|))*‖y‖^3*‖c‖ +
        ((∑ r, |(finiteN2Coeff2 i 0 r : ℝ)|)+
          (∑ r, |(finiteN2Coeff2 i 1 r : ℝ)|))*‖y‖^4*‖c‖^2 := by ring
    _ ≤ _ := by gcongr

/-- Exact rational slack producing the manuscript's integer constant243. -/
theorem finiteN2_height_scalar (T : ℝ) (hT : 1000 ≤ T) :
    (101/100 : ℝ)*(50+200*T+240*T^2) < 243*T^2 := by
  have hp := mul_nonneg (sub_nonneg.mpr hT) (show 0 ≤ T by linarith only [hT])
  nlinarith only [hp,hT]

/-- Actual N2 root-column height, with the paper's sharp constant. -/
theorem finiteN2_height_scaled (x y c : ℂ) (hy : y ≠ 0)
    (hxy : ‖x‖ ≤ ‖y‖) (hYC : 1000 ≤ ‖y‖*‖c‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteN2Left x y c i‖+‖finiteN2Right x y c i‖) <
      243*‖y‖^4*‖c‖^2 := by
  have hnorm := mul_le_mul_of_nonneg_left (finiteN2_root_columns_norm_le x y c hxy i)
    (show (0 : ℝ) ≤ 101/100 by norm_num)
  have hs := mul_lt_mul_of_pos_left (finiteN2_height_scalar (‖y‖*‖c‖) hYC)
    (sq_pos_of_pos (norm_pos_iff.mpr hy))
  have heq : (101/100 : ℝ)*(50*‖y‖^2+200*‖y‖^3*‖c‖+240*‖y‖^4*‖c‖^2) <
      243*‖y‖^4*‖c‖^2 := by nlinarith only [hs]
  exact hnorm.trans_lt heq

end D1Bound5
