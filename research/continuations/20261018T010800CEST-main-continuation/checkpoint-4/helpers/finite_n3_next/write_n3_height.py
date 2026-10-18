from pathlib import Path
import json
Q=json.loads(Path('finite_n3_next/n3_coefficients.json').read_text())
defs=[]
for ell in range(4):
    rows=[]
    for i in range(3):
        cols=[]
        for j in [1,2]:
            v=[0]*(ell+5)
            for e,a in Q[i][j]:
                if e[2]!=ell:continue
                e=e.copy();e[j-1]-=1
                assert e[0]+e[1]==ell+4
                v[e[0]]=a
            cols.append('!['+','.join(map(str,v))+']')
        rows.append('!['+', '.join(cols)+']')
    defs.append(f'def finiteN3Coeff{ell} : Fin 3 → Fin 2 → Fin {ell+5} → ℤ :=\n  !['+',\n    '.join(rows)+']\n')
text='''import D1Bound5.FiniteN3Matrix
import D1Bound5.FiniteHomogeneousTwo
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace D1Bound5

'''+ '\n'.join(defs)+'''

theorem finite_norm_cubic_le (u v w t c : ℂ) :
    ‖u+v*c+w*c^2+t*c^3‖ ≤
      ‖u‖+‖v‖*‖c‖+‖w‖*‖c‖^2+‖t‖*‖c‖^3 := by
  calc
    _ ≤ ‖u+v*c+w*c^2‖+‖t*c^3‖ := norm_add_le _ _
    _ ≤ (‖u‖+‖v‖*‖c‖+‖w‖*‖c‖^2)+‖t*c^3‖ :=
      add_le_add_right (finite_norm_quadratic_le _ _ _ _) _
    _ = _ := by rw [norm_mul,norm_pow]

/-- Exact coefficient vectors, checked against the actual N3 matrix. -/
theorem finiteN3_root_coeff_decomposition {R : Type*} [CommRing R]
    (x y c : R) (i : Fin 3) (j : Fin 2) :
    ![finiteN3Left x y c i,finiteN3Right x y c i] j =
      finiteHomogeneousTwo 4 (finiteN3Coeff0 i j) x y +
      finiteHomogeneousTwo 5 (finiteN3Coeff1 i j) x y*c +
      finiteHomogeneousTwo 6 (finiteN3Coeff2 i j) x y*c^2 +
      finiteHomogeneousTwo 7 (finiteN3Coeff3 i j) x y*c^3 := by
  fin_cases i <;> fin_cases j
  all_goals
    norm_num [finiteN3Left,finiteN3Right,finiteN3Coeff0,finiteN3Coeff1,
      finiteN3Coeff2,finiteN3Coeff3,finiteHomogeneousTwo,Fin.sum_univ_succ]
    <;> ring

/-- Integer coefficient sums computed from the actual vectors. Taking
the maximum separately in each degree still leaves strict slack at4143. -/
theorem finiteN3_coefficient_sums (i : Fin 3) :
    ((∑ j, |(finiteN3Coeff0 i 0 j : ℝ)|)+
      (∑ j, |(finiteN3Coeff0 i 1 j : ℝ)|) ≤ 342) ∧
    ((∑ j, |(finiteN3Coeff1 i 0 j : ℝ)|)+
      (∑ j, |(finiteN3Coeff1 i 1 j : ℝ)|) ≤ 2352) ∧
    ((∑ j, |(finiteN3Coeff2 i 0 j : ℝ)|)+
      (∑ j, |(finiteN3Coeff2 i 1 j : ℝ)|) ≤ 5792) ∧
    ((∑ j, |(finiteN3Coeff3 i 0 j : ℝ)|)+
      (∑ j, |(finiteN3Coeff3 i 1 j : ℝ)|) ≤ 4096) := by
  fin_cases i <;> norm_num [finiteN3Coeff0,finiteN3Coeff1,finiteN3Coeff2,
    finiteN3Coeff3,Fin.sum_univ_succ]

theorem finiteN3_root_columns_norm_le (x y c : ℂ) (hxy : ‖x‖ ≤ ‖y‖) (i : Fin 3) :
    ‖finiteN3Left x y c i‖+‖finiteN3Right x y c i‖ ≤
      342*‖y‖^4+2352*‖y‖^5*‖c‖+5792*‖y‖^6*‖c‖^2+4096*‖y‖^7*‖c‖^3 := by
  have hroot (j : Fin 2) :
      ‖![finiteN3Left x y c i,finiteN3Right x y c i] j‖ ≤
        (∑ r, |(finiteN3Coeff0 i j r : ℝ)|)*‖y‖^4 +
        (∑ r, |(finiteN3Coeff1 i j r : ℝ)|)*‖y‖^5*‖c‖ +
        (∑ r, |(finiteN3Coeff2 i j r : ℝ)|)*‖y‖^6*‖c‖^2 +
        (∑ r, |(finiteN3Coeff3 i j r : ℝ)|)*‖y‖^7*‖c‖^3 := by
    rw [finiteN3_root_coeff_decomposition]
    apply (finite_norm_cubic_le _ _ _ _ _).trans
    have h0 := finiteHomogeneousTwo_norm_le 4 (finiteN3Coeff0 i j) x y hxy
    have h1 := finiteHomogeneousTwo_norm_le 5 (finiteN3Coeff1 i j) x y hxy
    have h2 := finiteHomogeneousTwo_norm_le 6 (finiteN3Coeff2 i j) x y hxy
    have h3 := finiteHomogeneousTwo_norm_le 7 (finiteN3Coeff3 i j) x y hxy
    gcongr
  obtain ⟨h0,h1,h2,h3⟩ := finiteN3_coefficient_sums i
  have h := add_le_add (hroot 0) (hroot 1)
  change ‖finiteN3Left x y c i‖+‖finiteN3Right x y c i‖ ≤ _ at h
  calc
    _ ≤ _ := h
    _ = ((∑ r, |(finiteN3Coeff0 i 0 r : ℝ)|)+
          (∑ r, |(finiteN3Coeff0 i 1 r : ℝ)|))*‖y‖^4 +
        ((∑ r, |(finiteN3Coeff1 i 0 r : ℝ)|)+
          (∑ r, |(finiteN3Coeff1 i 1 r : ℝ)|))*‖y‖^5*‖c‖ +
        ((∑ r, |(finiteN3Coeff2 i 0 r : ℝ)|)+
          (∑ r, |(finiteN3Coeff2 i 1 r : ℝ)|))*‖y‖^6*‖c‖^2 +
        ((∑ r, |(finiteN3Coeff3 i 0 r : ℝ)|)+
          (∑ r, |(finiteN3Coeff3 i 1 r : ℝ)|))*‖y‖^7*‖c‖^3 := by ring
    _ ≤ _ := by gcongr

theorem finiteN3_height_scalar (T : ℝ) (hT : 1000 ≤ T) :
    (101/100 : ℝ)*(342+2352*T+5792*T^2+4096*T^3) < 4143*T^3 := by
  have hT0 : 0 ≤ T := by linarith only [hT]
  have h1 := mul_nonneg (sub_nonneg.mpr hT) hT0
  have h2 := mul_nonneg (sub_nonneg.mpr hT) (sq_nonneg T)
  nlinarith only [hT,h1,h2]

/-- The actual finite N3 coefficient height with the manuscript's4143. -/
theorem finiteN3_height_scaled (x y c : ℂ) (hy : y ≠ 0)
    (hxy : ‖x‖ ≤ ‖y‖) (hYC : 1000 ≤ ‖y‖*‖c‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteN3Left x y c i‖+‖finiteN3Right x y c i‖) <
      4143*‖y‖^7*‖c‖^3 := by
  have hnorm := mul_le_mul_of_nonneg_left (finiteN3_root_columns_norm_le x y c hxy i)
    (show (0 : ℝ) ≤ 101/100 by norm_num)
  have hs := mul_lt_mul_of_pos_left (finiteN3_height_scalar (‖y‖*‖c‖) hYC)
    (pow_pos (norm_pos_iff.mpr hy) 4)
  have heq : (101/100 : ℝ)*(342*‖y‖^4+2352*‖y‖^5*‖c‖+
        5792*‖y‖^6*‖c‖^2+4096*‖y‖^7*‖c‖^3) <
      4143*‖y‖^7*‖c‖^3 := by nlinarith only [hs]
  exact hnorm.trans_lt heq

end D1Bound5
'''
Path('finite_n3_next/FiniteN3Height.lean').write_text(text)
