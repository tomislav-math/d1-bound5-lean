from pathlib import Path
from fractions import Fraction as F
BASE=Path('finite_a_next')
def rat(q):return str(q.numerator) if q.denominator==1 else f'{q.numerator}/{q.denominator}'
for k,m,g,beta,R in [(3,2,4,F(35,32768),F(35,16)),(4,3,2,F(63,524288),F(63,8)),(5,4,4,F(495,33554432),F(495,64))]:
 n=f'finiteA{k}';P=m+2*k;expo=F(2*(m+k)-1,2);K=F(101,100)*beta*4**k/g
 src=f'''import D1Bound5.FiniteA{k}ResidueIdentity
import D1Bound5.FiniteEtaBound
import D1Bound5.BennettChooseGamma

namespace D1Bound5

noncomputable def {n}Residual (x y c : ℂ) (i : Fin 3) : ℂ :=
  ∑ j, {n}Matrix x y c i j*
    (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ)

theorem {n}_beta : |Ring.choose ({2*k+1}/2 : ℝ) {P}| = {rat(beta)} := by
  have h := bennett_factorial_mul_abs_choose ({2*k+1}/2 : ℝ) {P}
  norm_num [descPochhammer_eval_eq_prod_range,Finset.prod_range_succ] at h
  nlinarith only [h]

theorem {n}_residual_sum_identity (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y) (i : Fin 3) :
    {g}*{n}RowFactor x y i*{n}Residual x y c i =
      ∑ j, finiteUnequalClearedEntry x y c {k} {m} i j*
        (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ) := by
  unfold {n}Residual
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j hj
  rw [{n}_residue_identity x y c hx hy hxy]
  ring

theorem {n}RowFactor_ne_zero (x y : ℂ) (hx : x ≠ 0) (hy : y ≠ 0)
    (hxy : x ≠ y) (i : Fin 3) : {n}RowFactor x y i ≠ 0 := by
  fin_cases i <;> simp [{n}RowFactor,hx,hy,sub_ne_zero.mpr hxy]

/-- Exact pointwise residual with the actual row factor retained, suitable
for the fixed-anchor refinement as well as the uniform family bound. -/
theorem {n}_residual_norm_lt_point (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖{n}Residual x y c i‖ <
      (101/100 : ℝ)*({rat(beta)})*(4^{k}*‖x-y‖^{2*k}/(‖x‖^{k}*‖y‖^{k}*‖c‖^{m+k})) /
        ({g}*‖{n}RowFactor x y i‖) := by
  have hbase : 0 < 4^{k}*‖x-y‖^{2*k}/(‖x‖^{k}*‖y‖^{k}*‖c‖^{m+k}) := by
    have hX := norm_pos_iff.mpr hx
    have hY := norm_pos_iff.mpr hy
    have hC := norm_pos_iff.mpr hc
    have hD := norm_pos_iff.mpr (sub_ne_zero.mpr hxy)
    positivity
  have hrow : 0 < ‖{n}RowFactor x y i‖ :=
    norm_pos_iff.mpr ({n}RowFactor_ne_zero x y hx hy hxy i)
  have hres := finiteUnequalClearedEntry_residual_norm_le x y c hx hy hc hxy
    hXY (by linarith) {k} {m} (by decide) (by decide) (by decide) (by norm_num) i
  norm_num only [Nat.cast_ofNat] at hres
  rw [{n}_beta] at hres
  have heta := finite_eta_reciprocal_lt (‖x‖*‖c‖) ({rat(expo)} : ℝ) hXC (by norm_num)
  have hbound :
      ‖∑ j, finiteUnequalClearedEntry x y c {k} {m} i j*
          (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ)‖ <
        (101/100 : ℝ)*({rat(beta)})*(4^{k}*‖x-y‖^{2*k}/(‖x‖^{k}*‖y‖^{k}*‖c‖^{m+k})) := by
    apply hres.trans_lt
    have hm := mul_lt_mul_of_pos_left heta (mul_pos hbase (by norm_num : (0 : ℝ) < {rat(beta)}))
    convert hm using 1 <;> ring
  rw [← {n}_residual_sum_identity x y c hx hy hxy i,norm_mul,norm_mul] at hbound
  norm_num only [norm_ofNat] at hbound
  exact (lt_div_iff₀ (by positivity)).mpr (by nlinarith only [hbound])

private theorem {n}_rowfactor_scalar (X Y delta r : ℝ)
    (hX : 0 < X) (hY : 0 < Y) (hD : 0 < delta) (hXY : X ≤ Y)
    (hdelta : delta ≤ X+Y) (hr : r=delta ∨ r=X ∨ r=Y) :
    X*delta^{2*k} ≤ {4**k}*Y^{2*k}*r := by
  have hdY : delta ≤ 2*Y := by linarith only [hXY,hdelta]
  have hprev : delta^{2*k-1} ≤ (2*Y)^{2*k-1} := by gcongr
  have hpow : delta^{2*k} ≤ (2*Y)^{2*k} := by gcongr
  rcases hr with rfl | rfl | rfl
  · have hh := mul_le_mul hXY hprev (by positivity) hY.le
    have hm := mul_le_mul_of_nonneg_right hh hD.le
    nlinarith only [hm,mul_nonneg (pow_nonneg hY.le {2*k}) hD.le]
  · have hm := mul_le_mul_of_nonneg_left hpow hX.le
    nlinarith only [hm]
  · have hh := mul_le_mul hXY hpow (by positivity) hY.le
    nlinarith only [hh]

/-- The manuscript's uniform R*={rat(R)}, derived from the actual residual. -/
theorem {n}_residual_norm_lt (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖{n}Residual x y c i‖ < ({rat(R)} : ℝ)*‖y‖^{k}/(‖x‖^{k+1}*‖c‖^{m+k}) := by
  have hX := norm_pos_iff.mpr hx
  have hY := norm_pos_iff.mpr hy
  have hC := norm_pos_iff.mpr hc
  have hD := norm_pos_iff.mpr (sub_ne_zero.mpr hxy)
  have hrow := norm_pos_iff.mpr ({n}RowFactor_ne_zero x y hx hy hxy i)
  have hr : ‖{n}RowFactor x y i‖=‖x-y‖ ∨
      ‖{n}RowFactor x y i‖=‖x‖ ∨ ‖{n}RowFactor x y i‖=‖y‖ := by
    fin_cases i <;> simp [{n}RowFactor]
  have hh := {n}_rowfactor_scalar ‖x‖ ‖y‖ ‖x-y‖ ‖{n}RowFactor x y i‖
    hX hY hD hXY (norm_sub_le _ _) hr
  apply ({n}_residual_norm_lt_point x y c hx hy hc hxy hXY hXC i).trans_le
  have hfrac : ‖x‖*‖x-y‖^{2*k}/(‖y‖^{2*k}*‖{n}RowFactor x y i‖) ≤ {4**k} :=
    (div_le_iff₀ (by positivity)).mpr (by nlinarith only [hh])
  have halg :
      (101/100 : ℝ)*({rat(beta)})*(4^{k}*‖x-y‖^{2*k}/(‖x‖^{k}*‖y‖^{k}*‖c‖^{m+k})) /
        ({g}*‖{n}RowFactor x y i‖) =
      ({rat(K)} : ℝ)*(‖x‖*‖x-y‖^{2*k}/(‖y‖^{2*k}*‖{n}RowFactor x y i‖))*
        (‖y‖^{k}/(‖x‖^{k+1}*‖c‖^{m+k})) := by
    field_simp [hX.ne',hY.ne',hC.ne',hrow.ne']
    <;> ring
  rw [halg]
  calc
    _ ≤ ({rat(K)} : ℝ)*{4**k}*(‖y‖^{k}/(‖x‖^{k+1}*‖c‖^{m+k})) := by gcongr
    _ ≤ ({rat(R)} : ℝ)*(‖y‖^{k}/(‖x‖^{k+1}*‖c‖^{m+k})) :=
      mul_le_mul_of_nonneg_right (by norm_num) (by positivity)
    _ = _ := by ring

end D1Bound5
'''
 (BASE/f'FiniteA{k}Residual.lean').write_text(src)
 print(f'A{k} actual residual, beta {rat(beta)}, R* {rat(R)}')
