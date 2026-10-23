import D1Bound5.FiniteMResidualPoint
import Mathlib.Tactic.GCongr

namespace D1Bound5

/-- Uniform row-factor geometry. Only the elementary upper bounds for the
three differences enter; no lower separation estimate is assumed. -/
theorem finiteM_rowfactor_scalar (A B S x y z r : ℝ)
    (hA : 1 ≤ A) (hAB : A ≤ B) (hBS : B ≤ S)
    (hx : 0 < x) (hy : 0 < y) (hz : 0 < z)
    (hxB : x ≤ 2*B) (hyS : y ≤ 2*S) (hzS : z ≤ 2*S)
    (hr : r=x*y*z ∨ r=A*z ∨ r=B*y ∨ r=S*x) :
    A*(x*y*z)^4 ≤ 2048*B^4*S^7*r := by
  have hA0 : 0 ≤ A := by linarith
  have hB0 : 0 ≤ B := by linarith
  have hS0 : 0 ≤ S := by linarith
  have hS1 : 1 ≤ S := hA.trans (hAB.trans hBS)
  rcases hr with rfl | rfl | rfl | rfl
  · have hcomp : A*x^3*y^3*z^3 ≤ B*(2*B)^3*(2*S)^3*(2*S)^3 := by gcongr
    have hsp : S^6 ≤ S^7 := pow_le_pow_right₀ hS1 (by decide)
    have hwide : A*x^3*y^3*z^3 ≤ 2048*B^4*S^7 := by
      have hpow := mul_le_mul_of_nonneg_left hsp (show 0 ≤ 512*B^4 by positivity)
      have hpos : 0 ≤ B^4*S^7 := by positivity
      nlinarith only [hcomp,hpow,hpos]
    have hm := mul_le_mul_of_nonneg_right hwide (show 0 ≤ x*y*z by positivity)
    nlinarith only [hm]
  · have hcomp : x^4*y^4*z^3 ≤ (2*B)^4*(2*S)^4*(2*S)^3 := by gcongr
    have hm := mul_le_mul_of_nonneg_right hcomp (show 0 ≤ A*z by positivity)
    nlinarith only [hm]
  · have hcomp : A*x^4*y^3*z^4 ≤ B*(2*B)^4*(2*S)^3*(2*S)^4 := by gcongr
    have hm := mul_le_mul_of_nonneg_right hcomp hy.le
    nlinarith only [hm]
  · have hcomp : A*x^3*y^4*z^4 ≤ B*(2*B)^3*(2*S)^4*(2*S)^4 := by gcongr
    have hm := mul_le_mul_of_nonneg_right hcomp hx.le
    nlinarith only [hm]

/-- The actual constructed M matrix has the manuscript's residual bound.
Its constant comes from |choose(5/2,8)|=45/32768 and the proved exact
arbitrary-order residue cancellation. -/
theorem finiteM_residual_norm_lt (a b s c : ℂ)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0) (hc : c ≠ 0)
    (hab : a ≠ b) (has : a ≠ s) (hbs : b ≠ s)
    (hA1 : 1 ≤ ‖a‖) (hAB : ‖a‖ ≤ ‖b‖) (hBS : ‖b‖ ≤ ‖s‖)
    (hAC : 1000 ≤ ‖a‖*‖c‖) (i : Fin 4) :
    ‖finiteMResidual a b s c i‖ <
      (3920/81 : ℝ)*‖b‖^2*‖s‖^5/(‖a‖^3*‖c‖^6) := by
  have hA := norm_pos_iff.mpr ha
  have hB := norm_pos_iff.mpr hb
  have hS := norm_pos_iff.mpr hs
  have hC := norm_pos_iff.mpr hc
  have hx := norm_pos_iff.mpr (sub_ne_zero.mpr hab)
  have hy := norm_pos_iff.mpr (sub_ne_zero.mpr has)
  have hz := norm_pos_iff.mpr (sub_ne_zero.mpr hbs)
  have hrow := norm_pos_iff.mpr (finiteMRowFactor_ne_zero a b s ha hb hs hab has hbs i)
  have hr : ‖finiteMRowFactor a b s i‖ = ‖a-b‖*‖a-s‖*‖b-s‖ ∨
      ‖finiteMRowFactor a b s i‖ = ‖a‖*‖b-s‖ ∨
      ‖finiteMRowFactor a b s i‖ = ‖b‖*‖a-s‖ ∨
      ‖finiteMRowFactor a b s i‖ = ‖s‖*‖a-b‖ := by
    fin_cases i <;> simp [finiteMRowFactor, norm_mul]
  have hdiffAB : ‖a-b‖ ≤ 2*‖b‖ := (norm_sub_le a b).trans (by linarith)
  have hdiffAS : ‖a-s‖ ≤ 2*‖s‖ := (norm_sub_le a s).trans (by linarith)
  have hdiffBS : ‖b-s‖ ≤ 2*‖s‖ := (norm_sub_le b s).trans (by linarith)
  have hgeom := finiteM_rowfactor_scalar ‖a‖ ‖b‖ ‖s‖ ‖a-b‖ ‖a-s‖ ‖b-s‖
    ‖finiteMRowFactor a b s i‖ hA1 hAB hBS hx hy hz hdiffAB hdiffAS hdiffBS hr
  have hratio : ‖a‖*(‖a-b‖*‖a-s‖*‖b-s‖)^4 /
      (‖b‖^4*‖s‖^7*‖finiteMRowFactor a b s i‖) ≤ 2048 :=
    (div_le_iff₀ (by positivity)).mpr (by nlinarith only [hgeom])
  apply (finiteM_residual_norm_lt_point a b s c ha hb hs hc hab has hbs hAB hBS hAC i).trans_le
  have halg : (101/100 : ℝ)*(45/2048)*(‖a-b‖*‖a-s‖*‖b-s‖)^4 /
      (‖a‖^2*‖b‖^2*‖s‖^2*‖c‖^6*‖finiteMRowFactor a b s i‖) =
      (909/40960 : ℝ)*(‖a‖*(‖a-b‖*‖a-s‖*‖b-s‖)^4 /
        (‖b‖^4*‖s‖^7*‖finiteMRowFactor a b s i‖))*
          (‖b‖^2*‖s‖^5/(‖a‖^3*‖c‖^6)) := by
    field_simp [hA.ne', hB.ne', hS.ne', hC.ne', hrow.ne']
    <;> ring
  rw [halg]
  calc
    _ ≤ (909/40960 : ℝ)*2048*(‖b‖^2*‖s‖^5/(‖a‖^3*‖c‖^6)) := by gcongr
    _ ≤ (3920/81 : ℝ)*(‖b‖^2*‖s‖^5/(‖a‖^3*‖c‖^6)) :=
      mul_le_mul_of_nonneg_right (by norm_num) (by positivity)
    _ = _ := by ring

end D1Bound5
