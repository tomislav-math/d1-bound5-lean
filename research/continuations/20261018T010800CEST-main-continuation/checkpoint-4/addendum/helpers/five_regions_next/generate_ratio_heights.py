from pathlib import Path
cfg=[('N2',2,2,[36,69,109,130,220]),('N3',3,4,[282,697,1306,1652,3553]),('A3',3,3,[145,326,663,863,1944]),('A4',4,5,[4605,14771,34919,48019,134712]),('A5',5,7,[38390,171856,482131,701908,2400382])]
for fam,k,d0,values in cfg:
 co=f'finite{fam}'; rc=co+('RatioRootCoeff' if fam[0]=='N' else 'RootCoeff'); ws=co+'RatioWeights'; M='fiveRegion'+fam+'Height'
 imp=f'Finite{fam}'+('Height' if fam[0]=='N' else 'Coefficients')
 s=f'import D1Bound5.{imp}\nimport D1Bound5.FiniteHomogeneousRatio\n\nnoncomputable section\n\nnamespace D1Bound5\n\n'
 if fam[0]=='N':
  s+=f'def {rc} {{R : Type*}} [CommRing R] (x y : R) (i : Fin 3) (j : Fin 2) : Fin {k+1} → R :=\n  !['+',\n    '.join(f'finiteHomogeneousTwo {d0+l} ({co}Coeff{l} i j) x y' for l in range(k+1))+']\n\n'
  s+=f'''theorem {co}_ratio_root_decomposition {{R : Type*}} [CommRing R]
    (x y c : R) (i : Fin 3) (j : Fin 2) :
    ![{co}Left x y c i,{co}Right x y c i] j =
      ∑ ell : Fin {k+1}, {rc} x y i j ell*c^(ell : ℕ) := by
  rw [{co}_root_coeff_decomposition]
  simp [{rc},Fin.sum_univ_succ]
  <;> ring

'''
 s+=f'def {ws} (r : ℝ) (i : Fin 3) : Fin {k+1} → ℝ :=\n  !['+',\n    '.join(f'finiteHomogeneousRatioWeight {d0+l} ({co}Coeff{l} i 0) r+finiteHomogeneousRatioWeight {d0+l} ({co}Coeff{l} i 1) r' for l in range(k+1))+']\n\n'
 s+=f'def {M} : Fin 5 → ℝ := !['+','.join(map(str,values))+']\n\n'
 s+=f'''theorem {ws}_nonneg (r : ℝ) (hr : 0 ≤ r) (i : Fin 3) (ell : Fin {k+1}) :
    0 ≤ {ws} r i ell := by
  fin_cases ell
'''
 for l in range(k+1):s+=f'  · exact add_nonneg (finiteHomogeneousRatioWeight_nonneg {d0+l} _ r hr)\n      (finiteHomogeneousRatioWeight_nonneg {d0+l} _ r hr)\n'
 s+=f'''
theorem {co}_root_coefficient_norm_le_ratio (x y : ℂ) (r : ℝ)
    (hr : 0 ≤ r) (hxy : ‖x‖ ≤ r*‖y‖) (i : Fin 3) (ell : Fin {k+1}) :
    ‖{rc} x y i 0 ell‖+‖{rc} x y i 1 ell‖ ≤
      {ws} r i ell*‖y‖^({d0}+(ell : ℕ)) := by
  fin_cases ell
'''
 for l in range(k+1):s+=f'''  · have h := add_le_add
      (finiteHomogeneousTwo_norm_le_ratio {d0+l} ({co}Coeff{l} i 0) x y r hr hxy)
      (finiteHomogeneousTwo_norm_le_ratio {d0+l} ({co}Coeff{l} i 1) x y r hr hxy)
    simpa [{rc},{ws},add_mul] using h
'''
 s+=f'''
set_option maxHeartbeats 4000000 in
/-- The five displayed coefficient constants are checked directly from the
actual integer coefficient vectors at their exact rational anchor ratios. -/
theorem {co}_five_region_height_slack (region : Fin 5) (i : Fin 3) :
    (101/100 : ℝ)*(∑ ell : Fin {k+1},
      {ws} (fiveRegionAnchorRatio region) i ell/(1000 : ℝ)^({k}-(ell : ℕ))) <
      {M} region := by
  fin_cases region <;> fin_cases i <;>
    norm_num [{ws},fiveRegionAnchorRatio,{M},finiteHomogeneousRatioWeight,
      '''+', '.join(co+'Coeff'+str(l) for l in range(k+1))+''',Fin.sum_univ_succ]

'''
 dec=co+('_ratio_root_decomposition' if fam[0]=='N' else '_root_coeff_decomposition')
 s+=f'''/-- Actual ratio-refined height for the constructed finite family. The
statement supplies no coefficient or height certificate: the integer rows
and all five rational table margins are proved above. -/
theorem {co}_height_five_regions (region : Fin 5) (x y c : ℂ)
    (hy : y ≠ 0) (hxy : ‖x‖ ≤ fiveRegionAnchorRatio region*‖y‖)
    (hYC : 1000 ≤ ‖y‖*‖c‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖{co}Left x y c i‖+‖{co}Right x y c i‖) <
      {M} region*‖y‖^{d0+k}*‖c‖^{k} := by
  let r := fiveRegionAnchorRatio region
  have hr : 0 ≤ r := fiveRegionAnchorRatio_nonneg region
  have hcoeff := finitePolynomial_two_columns_norm_le {k} {d0}
    ({rc} x y i) ({ws} r i) c ‖y‖
    ({co}_root_coefficient_norm_le_ratio x y r hr hxy i)
  have hleft := {dec} x y c i 0
  have hright := {dec} x y c i 1
  change {co}Left x y c i = _ at hleft
  change {co}Right x y c i = _ at hright
  rw [← hleft,← hright] at hcoeff
  have hscaled := mul_le_mul_of_nonneg_left hcoeff (show (0 : ℝ) ≤ 101/100 by norm_num)
  have hs := finitePolynomial_height_scalar {k} ({ws} r i)
    ({ws}_nonneg r hr i) ({M} region) (‖y‖*‖c‖) hYC
    ({co}_five_region_height_slack region i)
  have hm := mul_lt_mul_of_pos_left hs (pow_pos (norm_pos_iff.mpr hy) {d0})
  apply hscaled.trans_lt
  convert hm using 1 <;> simp only [mul_pow] <;> ring

end D1Bound5
'''
 Path(f'five_regions_next/Finite{fam}RatioHeight.lean').write_text(s)
