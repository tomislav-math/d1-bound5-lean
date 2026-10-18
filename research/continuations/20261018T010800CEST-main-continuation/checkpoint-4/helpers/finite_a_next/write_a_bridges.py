from pathlib import Path
BASE=Path('finite_a_next')
for k,m,g in [(3,2,4),(4,3,2),(5,4,4)]:
 n=f'finiteA{k}'
 src=f'''import D1Bound5.FiniteA{k}Matrix
import D1Bound5.FiniteUnequalEntry
import D1Bound5.FiniteChooseFive

namespace D1Bound5
variable {{F : Type*}} [Field F] [CharZero F]

set_option maxHeartbeats 12000000 in
/-- Every actual integral A{k} entry equals its unequal-pole residue.
The finite sums, row factors and common divisor g are all verified here. -/
theorem {n}_residue_identity (x y c : F)
    (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i j : Fin 3) :
    finiteUnequalClearedEntry x y c {k} {m} i j =
      {g}*{n}RowFactor x y i*{n}Matrix x y c i j := by
'''
 for h in range(1,k+1):
  src+=f'  have hanti{h} : Finset.antidiagonal {h} = '+'{'+','.join(f'({i},{h-i})'for i in range(h+1))+'} := by decide\n'
 src+='''  have hd : x-y ≠ 0 := sub_ne_zero.mpr hxy
  have hd' : y-x ≠ 0 := sub_ne_zero.mpr hxy.symm
  fin_cases i <;> fin_cases j
  all_goals
    unfold finiteUnequalClearedEntry
'''
 src+=f'''    simp only [finiteUnequalOtherPoles_zero x y {k} {m} (by decide) (by decide),
      finiteUnequalOtherPoles_one x y {k} {m} (by decide) (by decide),
      finiteUnequalOtherPoles_two x y {k} {m} (by decide) (by decide),
      bennettTwoNodes_zero,bennettTwoNodes_one,bennettTwoNodes_two]
    rw [bennettClearedTaylor_two_poles_scaled_eval]
    norm_num [{','.join('hanti'+str(h)for h in range(1,k+1))},Finset.antidiagonal_zero,
      finiteUnequalOrders,Ring.choose_zero_right,Ring.choose_one_right,
      finiteA_choose_two,finiteA_choose_three,finiteA_choose_four,finiteA_choose_five,
      {n}RowFactor,{n}Matrix,{n}DividedMatrix,Matrix.mul_diagonal,
      {n}Constant,{n}Left,{n}Right]
    field_simp [hx,hy,hd,hd']
    <;> ring

end D1Bound5
'''
 (BASE/f'FiniteA{k}ResidueIdentity.lean').write_text(src)
 src=Path('finite_n3_next/FiniteN3IntegralRows.lean').read_text().replace('finiteN3','finiteA'+str(k)).replace('FiniteN3','FiniteA'+str(k)).replace('N3',f'A{k}')
 src=src.replace('(hxy : x ≠ y) (hz : z ≠ 0)', '(hc : c ≠ 0) (hxy : x ≠ y) (hz : z ≠ 0)')
 src=src.replace(f'finiteA{k}DividedMatrix_det_ne_zero x y c hx hy hxy',f'finiteA{k}DividedMatrix_det_ne_zero x y c hx hy hc hxy')
 src=src.replace('(hnonzero x hx) (hnonzero y hy) (fun h => hxy (hf h)) hz\'', '(hnonzero x hx) (hnonzero y hy) (hnonzero c hc) (fun h => hxy (hf h)) hz\'')
 (BASE/f'FiniteA{k}IntegralRows.lean').write_text(src)
 print(f'A{k} identities and actual full-ring row selection generated')
