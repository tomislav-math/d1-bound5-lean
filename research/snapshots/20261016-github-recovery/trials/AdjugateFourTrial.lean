import D1Bound5.ProductFourNumericalClosure
import D1Bound5.MatrixOperatorNorm
import D1Bound5.ReferenceMatrixSpectral
import Mathlib.Tactic.FinCases
import Lean.Util.CollectAxioms

open scoped Matrix.Norms.L2Operator
open Matrix

namespace D1Bound5

/-- In dimension four, the L2 operator norm is bounded by a diagonal
entry bound plus three times an off-diagonal entry bound. -/
theorem four_operator_norm_lt_of_entry_bounds
    (E : Matrix (Fin 4) (Fin 4) ℂ) (a b : ℝ)
    (ha : 0 < a) (hb : 0 < b)
    (hd : ∀ i, ‖E i i‖ < a)
    (hoff : ∀ i j, i ≠ j → ‖E i j‖ < b) :
    ‖E‖ < a + 3*b := by
  let D : Matrix (Fin 4) (Fin 4) ℂ := Matrix.diagonal (fun i => E i i)
  let U : Matrix (Fin 4) (Fin 4) ℂ := fun i j => if i = j then 0 else E i j
  have hsplit : E = D + U := by
    ext i j
    change E i j = D i j + U i j
    by_cases hij : i = j
    · subst j
      simp [D, U]
    · simp [D, U, hij]
  have hD : ‖D‖ < a := by
    dsimp [D]
    rw [Matrix.l2_opNorm_diagonal]
    exact (pi_norm_lt_iff ha).2 hd
  have hUdiag : ∀ i, U i i = 0 := by intro i; simp [U]
  have hUoff : ∀ i j, i ≠ j → ‖U i j‖ < b := by
    intro i j hij
    simpa [U, hij] using hoff i j hij
  have hU := four_zero_diagonal_operator_norm_lt U b hb hUdiag hUoff
  calc
    ‖E‖ = ‖D + U‖ := congrArg norm hsplit
    _ ≤ ‖D‖ + ‖U‖ := norm_add_le _ _
    _ < a + 3*b := by linarith

/-- Exact diagonal cofactor of a symmetric zero-diagonal 4x4 matrix. -/
theorem symmetricZeroFour_adjugate_00 (x y z u v w : ℂ) :
    ( !![0,x,y,z; x,0,u,v; y,u,0,w; z,v,w,0] :
      Matrix (Fin 4) (Fin 4) ℂ).adjugate 0 0 = 2*u*v*w := by
  rw [Matrix.adjugate_apply, Matrix.det_succ_row_zero]
  simp (config := {decide := true})
    [Matrix.updateRow_apply, Pi.single_apply, Fin.sum_univ_succ,
     Matrix.det_fin_three, Matrix.submatrix_apply, Matrix.of_apply, Fin.succAbove]
  ring

/-- Exact off-diagonal cofactor of a symmetric zero-diagonal 4x4 matrix. -/
theorem symmetricZeroFour_adjugate_01 (x y z u v w : ℂ) :
    ( !![0,x,y,z; x,0,u,v; y,u,0,w; z,v,w,0] :
      Matrix (Fin 4) (Fin 4) ℂ).adjugate 0 1 =
    w^2*x - w*z*u - w*y*v := by
  rw [Matrix.adjugate_apply, Matrix.det_succ_row_zero]
  simp (config := {decide := true})
    [Matrix.updateRow_apply, Pi.single_apply, Fin.sum_univ_succ,
     Matrix.det_fin_three, Matrix.submatrix_apply, Matrix.of_apply, Fin.succAbove]
  ring

end D1Bound5


namespace D1Bound5

/-- The exact numerical margin in the four-by-four cofactor estimate. -/
theorem four_adjugate_numeric_margin :
    (3/8 : ℝ) + (23/1000 : ℝ) + 3*(197/10000 : ℝ) <
      productFourH * productFourS^2 := by
  unfold productFourH productFourS
  norm_num

/-- Once the diagonal/off-diagonal cofactor errors have their explicit
cubic estimates, the required L2 adjugate bound follows. This statement
exposes the two scalar inequalities as hypotheses. -/
theorem four_adjugate_bound_of_entry_bounds
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (hd : ∀ i, ‖(F.adjugate - halfOffDiagonal.adjugate) i i‖ <
      (23/1000 : ℝ))
    (hoff : ∀ i j, i ≠ j →
      ‖(F.adjugate - halfOffDiagonal.adjugate) i j‖ <
        (197/10000 : ℝ)) :
    ‖F.adjugate‖ < productFourH * productFourS^2 := by
  have href : ‖halfOffDiagonal.adjugate‖ = (3/8 : ℝ) := by
    rw [halfOffDiagonal_adjugate, norm_smul, halfOffDiagonalInverse_norm]
    norm_num
  have herr :=
    four_operator_norm_lt_of_entry_bounds
      (F.adjugate - halfOffDiagonal.adjugate)
      (23/1000 : ℝ) (197/10000 : ℝ)
      (by norm_num) (by norm_num) hd hoff
  have hdecomp : F.adjugate = halfOffDiagonal.adjugate +
      (F.adjugate - halfOffDiagonal.adjugate) := by abel
  calc
    ‖F.adjugate‖ =
      ‖halfOffDiagonal.adjugate +
        (F.adjugate - halfOffDiagonal.adjugate)‖ := congrArg norm hdecomp
    _ ≤ ‖halfOffDiagonal.adjugate‖ +
        ‖F.adjugate - halfOffDiagonal.adjugate‖ := norm_add_le _ _
    _ < (3/8 : ℝ) + (23/1000 : ℝ) + 3*(197/10000 : ℝ) := by
      rw [href]
      linarith only [herr]
    _ < productFourH * productFourS^2 := four_adjugate_numeric_margin

end D1Bound5

namespace D1Bound5

/-- Uniform diagonal cofactor error for three entries near one half. -/
theorem nearHalf_triple_cofactor_bound (x y z : ℂ)
    (hx : ‖x - (1/2 : ℂ)‖ < (128/8649 : ℝ))
    (hy : ‖y - (1/2 : ℂ)‖ < (128/8649 : ℝ))
    (hz : ‖z - (1/2 : ℂ)‖ < (128/8649 : ℝ)) :
    ‖2*x*y*z - (1/4 : ℂ)‖ < (23/1000 : ℝ) := by
  let e : ℝ := 128/8649
  let t : ℝ := 1/2 + e
  have hxe : ‖x - (1/2 : ℂ)‖ ≤ e := hx.le
  have hye : ‖y - (1/2 : ℂ)‖ ≤ e := hy.le
  have hze : ‖z - (1/2 : ℂ)‖ ≤ e := hz.le
  have hny : ‖y‖ ≤ t := by
    have hn := norm_add_le (y-(1/2 : ℂ)) (1/2 : ℂ)
    have heq : y-(1/2 : ℂ)+(1/2 : ℂ)=y := by ring
    rw [heq] at hn
    have hn2 : ‖(1/2 : ℂ)‖ = (1/2 : ℝ) := by norm_num
    rw [hn2] at hn
    dsimp [t]
    linarith only [hn, hye]
  have hnz : ‖z‖ ≤ t := by
    have hn := norm_add_le (z-(1/2 : ℂ)) (1/2 : ℂ)
    have heq : z-(1/2 : ℂ)+(1/2 : ℂ)=z := by ring
    rw [heq] at hn
    have hn2 : ‖(1/2 : ℂ)‖ = (1/2 : ℝ) := by norm_num
    rw [hn2] at hn
    dsimp [t]
    linarith only [hn, hze]
  have hp : ‖x-(1/2 : ℂ)‖*‖y‖*‖z‖ ≤ e*t*t := by
    have h1 : ‖x-(1/2 : ℂ)‖*‖y‖ ≤ e*‖y‖ :=
      mul_le_mul_of_nonneg_right hxe (norm_nonneg _)
    have h2 : e*‖y‖ ≤ e*t :=
      mul_le_mul_of_nonneg_left hny (by norm_num [e])
    have h3 : (‖x-(1/2 : ℂ)‖*‖y‖)*‖z‖ ≤ (e*t)*‖z‖ :=
      mul_le_mul_of_nonneg_right (le_trans h1 h2) (norm_nonneg _)
    have h4 : (e*t)*‖z‖ ≤ (e*t)*t :=
      mul_le_mul_of_nonneg_left hnz (by norm_num [e,t])
    exact le_trans h3 h4
  have hq : ‖y-(1/2 : ℂ)‖*‖z‖ ≤ e*t := by
    have h1 := mul_le_mul_of_nonneg_right hye (norm_nonneg z)
    have h2 : e*‖z‖ ≤ e*t :=
      mul_le_mul_of_nonneg_left hnz (by norm_num [e])
    exact le_trans h1 h2
  have hid : 2*x*y*z - (1/4 : ℂ) =
      2*(x-1/2)*y*z + (y-1/2)*z + (z-1/2)/2 := by ring
  rw [hid]
  have htri :
      ‖2*(x-1/2)*y*z + (y-1/2)*z + (z-1/2)/2‖ ≤
      ‖2*(x-1/2)*y*z‖ + ‖(y-1/2)*z‖ + ‖(z-1/2)/2‖ := by
    have h1 := norm_add_le (2*(x-1/2)*y*z + (y-1/2)*z) ((z-1/2)/2)
    have h2 := norm_add_le (2*(x-1/2)*y*z) ((y-1/2)*z)
    linarith only [h1,h2]
  have hn1 : ‖2*(x-1/2)*y*z‖ ≤ 2*(e*t*t) := by
    have heq : ‖2*(x-1/2)*y*z‖ = 2*(‖x-1/2‖*‖y‖*‖z‖) := by
      simp [norm_mul]
      ring
    rw [heq]
    exact mul_le_mul_of_nonneg_left hp (by norm_num)
  have hn2 : ‖(y-1/2)*z‖ ≤ e*t := by
    rw [norm_mul]
    exact hq
  have hn3 : ‖(z-1/2)/2‖ ≤ e/2 := by
    have heq : ‖(z-1/2)/2‖ = ‖z-1/2‖/2 := by
      simp [norm_div]
    rw [heq]
    linarith only [hze]
  have hn : (2*(e*t*t) + e*t + e/2 : ℝ) < 23/1000 := by
    dsimp [e,t]
    norm_num
  linarith only [htri, hn1, hn2, hn3, hn]

end D1Bound5

open Lean Elab Command

/- Check the transitive axiom dependencies of every declaration proved here. -/
run_cmd do
  let names : List Name := [
    `D1Bound5.four_operator_norm_lt_of_entry_bounds,
    `D1Bound5.symmetricZeroFour_adjugate_00,
    `D1Bound5.symmetricZeroFour_adjugate_01,
    `D1Bound5.four_adjugate_numeric_margin,
    `D1Bound5.four_adjugate_bound_of_entry_bounds,
    `D1Bound5.nearHalf_triple_cofactor_bound]
  let allowed : List Name := [`propext, `Classical.choice, `Quot.sound]
  for n in names do
    let axs ← Lean.collectAxioms n
    let bad := axs.filter fun a => !allowed.contains a
    unless bad.isEmpty do
      throwError "Forbidden axioms for {n}: {bad}"
    logInfo m!"ADJUGATE_TRIAL_AXIOMS {n}: {axs}"
  logInfo m!"ADJUGATE_TRIAL_AXIOM_PASS: {names.length} theorems"
