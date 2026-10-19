import D1Bound5.FiniteMMatrix
import D1Bound5.BennettDeterminantNonzero
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.LinearCombination

open Finset Polynomial

namespace D1Bound5

variable {F : Type*} [Field F] [CharZero F]

def finiteMNodes (a b s : F) : Fin 4 → F := ![0,b*s,a*s,a*b]

noncomputable def finiteMBennettEntry (a b s c : F) (i j : Fin 4) : F :=
  (4*(a*b*s)^2*((a-b)*(a-s)*(b-s))^2)^2 *
    (bennettClearedResidue univ (finiteMNodes a b s) 2 (1/2 : F) i j).eval (a*b*s*c)

private theorem finiteM_prod_erase_four {M : Type*} [CommMonoid M]
    (g : Fin 4 → M) (j : Fin 4) :
    (∏ l ∈ (Finset.univ : Finset (Fin 4)).erase j, g l) =
      (if (0 : Fin 4) = j then 1 else g 0) *
      (if (1 : Fin 4) = j then 1 else g 1) *
      (if (2 : Fin 4) = j then 1 else g 2) *
      (if (3 : Fin 4) = j then 1 else g 3) := by
  classical
  calc
    _ = ∏ l ∈ (Finset.univ : Finset (Fin 4)).erase j,
        (if l = j then 1 else g l) := by
      apply Finset.prod_congr rfl
      intro l hl
      have hne : l ≠ j := (Finset.mem_erase.mp hl).1
      simp only [if_neg hne]
    _ = ∏ l : Fin 4, (if l = j then 1 else g l) :=
      Finset.prod_erase Finset.univ (by simp)
    _ = _ := Fin.prod_univ_four _

private theorem finiteM_pole_constantCoeff (d : F) (k : ℕ) :
    PowerSeries.constantCoeff (bennettPoleSeries d k) = (d⁻¹)^k := by
  simpa only [PowerSeries.coeff_zero_eq_constantCoeff, Ring.choose_zero_right,
    one_mul, add_zero] using bennettPoleSeries_coeff d k 0

private theorem finiteM_choose_two (r : F) : Ring.choose r 2 = r*(r-1)/2 := by
  have h := Ring.choose_smul_choose (r := r) (n := 2) (k := 1) (by decide)
  norm_num [nsmul_eq_mul, Ring.choose_one_right] at h
  apply (eq_div_iff (by norm_num : (2 : F) ≠ 0)).mpr
  linear_combination h

set_option maxHeartbeats 6000000 in
set_option maxRecDepth 4096 in
/-- Exact comparison with the actual arbitrary-order residue construction.
All row and root-column divisions are accounted for by integer polynomials;
no residue decomposition or formal identity is assumed. -/
theorem finiteM_bennett_identity (a b s c : F)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0)
    (hab : a ≠ b) (has : a ≠ s) (hbs : b ≠ s) (i j : Fin 4) :
    finiteMBennettEntry a b s c i j =
      finiteMRowFactor a b s i * finiteMMatrix a b s c i j := by
  have hfi01 : (0 : Fin 4) ≠ 1 := by decide
  have hfi02 : (0 : Fin 4) ≠ 2 := by decide
  have hfi03 : (0 : Fin 4) ≠ 3 := by decide
  have hfi12 : (1 : Fin 4) ≠ 2 := by decide
  have hfi13 : (1 : Fin 4) ≠ 3 := by decide
  have hfi23 : (2 : Fin 4) ≠ 3 := by decide
  have hnode0 : finiteMNodes a b s 0 = 0 := rfl
  have hnode1 : finiteMNodes a b s 1 = b*s := rfl
  have hnode2 : finiteMNodes a b s 2 = a*s := rfl
  have hnode3 : finiteMNodes a b s 3 = a*b := rfl
  have hu4 : (univ : Finset (Fin 4)) = {0,1,2,3} := by decide
  have hanti0 : Finset.antidiagonal 0 = {(0,0)} := by decide
  have hanti1 : Finset.antidiagonal 1 = {(0,1),(1,0)} := by decide
  have hanti2 : Finset.antidiagonal 2 = {(0,2),(1,1),(2,0)} := by decide
  have hs0 : (univ : Finset (Fin 4)).erase 0 = {1,2,3} := by decide
  have hs1 : (univ : Finset (Fin 4)).erase 1 = {0,2,3} := by decide
  have hs2 : (univ : Finset (Fin 4)).erase 2 = {0,1,3} := by decide
  have hs3 : (univ : Finset (Fin 4)).erase 3 = {0,1,2} := by decide
  have hab0 : a-b ≠ 0 := sub_ne_zero.mpr hab
  have has0 : a-s ≠ 0 := sub_ne_zero.mpr has
  have hbs0 : b-s ≠ 0 := sub_ne_zero.mpr hbs
  have hba0 : b-a ≠ 0 := sub_ne_zero.mpr hab.symm
  have hsa0 : s-a ≠ 0 := sub_ne_zero.mpr has.symm
  have hsb0 : s-b ≠ 0 := sub_ne_zero.mpr hbs.symm
  have hcases : ∀ x : Fin 4, x = 0 ∨ x = 1 ∨ x = 2 ∨ x = 3 := by decide
  rcases hcases i with rfl | rfl | rfl | rfl <;>
    rcases hcases j with rfl | rfl | rfl | rfl
  all_goals
    norm_num [finiteMBennettEntry, bennettClearedResidue,
      bennettClearedTaylor, bennettOtherPoles, finiteM_prod_erase_four,
      hnode0, hnode1, hnode2, hnode3,
      hfi01, hfi01.symm, hfi02, hfi02.symm, hfi03, hfi03.symm, hfi12, hfi12.symm, hfi13, hfi13.symm, hfi23, hfi23.symm,
      Matrix.cons_val_two, Matrix.cons_val_three, Matrix.vecHead, Matrix.vecTail,
      hanti1, hanti2, hanti0,
      PowerSeries.coeff_mul, bennettPoleSeries_coeff, finiteM_pole_constantCoeff,
      Ring.choose_zero_right, Ring.choose_one_right, finiteM_choose_two,
      finiteMRowFactor, finiteMMatrix, Matrix.mul_diagonal,
      finiteMDividedMatrix, finiteMTerms, finiteMTermEval]
  all_goals
    try simp only [show b*s-a*s = (b-a)*s by ring,
      show b*s-a*b = b*(s-a) by ring,
      show a*s-b*s = (a-b)*s by ring,
      show a*s-a*b = a*(s-b) by ring,
      show a*b-b*s = b*(a-s) by ring,
      show a*b-a*s = a*(b-s) by ring]
    field_simp [ha, hb, hs, hab0, has0, hbs0, hba0, hsa0, hsb0]
    <;> ring

theorem finiteMNodes_injective (a b s : F)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0)
    (hab : a ≠ b) (has : a ≠ s) (hbs : b ≠ s) :
    Function.Injective (finiteMNodes a b s) := by
  have h01 : b*s ≠ 0 := mul_ne_zero hb hs
  have h02 : a*s ≠ 0 := mul_ne_zero ha hs
  have h03 : a*b ≠ 0 := mul_ne_zero ha hb
  have h12 : b*s ≠ a*s := by
    intro h
    exact hab (mul_right_cancel₀ hs h).symm
  have h13 : b*s ≠ a*b := by
    intro h
    apply has
    apply mul_left_cancel₀ hb
    calc
      b*a = a*b := mul_comm _ _
      _ = b*s := h.symm
  have h23 : a*s ≠ a*b := by
    intro h
    exact hbs (mul_left_cancel₀ ha h).symm
  intro i j hij
  fin_cases i <;> fin_cases j <;> simp_all [finiteMNodes, eq_comm]

/-- Nonsingularity of the actual integer polynomial matrix is inherited
from the proved arbitrary-order Bennett determinant. -/
theorem finiteMDividedMatrix_det_ne_zero (a b s c : F)
    (ha : a ≠ 0) (hb : b ≠ 0) (hs : s ≠ 0)
    (hab : a ≠ b) (has : a ≠ s) (hbs : b ≠ s) :
    (finiteMDividedMatrix a b s c).det ≠ 0 := by
  let nodes := finiteMNodes a b s
  let G := bennettClearedMatrix nodes 2 (1/2 : F)
  let ev := Polynomial.evalRingHom (a*b*s*c)
  let scale : F := (4*(a*b*s)^2*((a-b)*(a-s)*(b-s))^2)^2
  have hscale : scale ≠ 0 := by
    dsimp [scale]
    exact pow_ne_zero _ (mul_ne_zero (mul_ne_zero (by norm_num)
      (pow_ne_zero _ (mul_ne_zero (mul_ne_zero ha hb) hs)))
      (pow_ne_zero _ (mul_ne_zero (mul_ne_zero (sub_ne_zero.mpr hab)
        (sub_ne_zero.mpr has)) (sub_ne_zero.mpr hbs))))
  have hG : G.det.eval (a*b*s*c) ≠ 0 :=
    bennettClearedMatrix_det_half_eval_ne_zero 3 nodes
      (finiteMNodes_injective a b s ha hb hs hab has hbs) 2 (by decide) rfl _
  have hev : (G.map ev).det ≠ 0 := by
    have hm := ev.map_det G
    change ev G.det = (G.map ev).det at hm
    rw [← hm]
    exact hG
  have hscaled : (scale • G.map ev).det ≠ 0 := by
    rw [Matrix.det_smul]
    exact mul_ne_zero (pow_ne_zero _ hscale) hev
  have heq : scale • G.map ev =
      Matrix.diagonal (finiteMRowFactor a b s) * finiteMMatrix a b s c := by
    ext i j
    change finiteMBennettEntry a b s c i j = _
    rw [Matrix.diagonal_mul]
    exact finiteM_bennett_identity a b s c ha hb hs hab has hbs i j
  rw [heq, Matrix.det_mul, finiteMMatrix, Matrix.det_mul] at hscaled
  exact fun h => hscaled (by rw [h, zero_mul, mul_zero])

end D1Bound5
