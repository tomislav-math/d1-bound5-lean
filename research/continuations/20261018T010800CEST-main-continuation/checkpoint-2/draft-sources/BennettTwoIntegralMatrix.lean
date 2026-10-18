import D1Bound5.BennettTwoIntegralEntries
import D1Bound5.BennettDeterminantNonzero
import Mathlib.Tactic.FinCases

namespace D1Bound5

variable {F : Type*} [Field F] [CharZero F]

theorem bennettTwoNodes_injective (a b : F)
    (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b) :
    Function.Injective (bennettTwoNodes a b) := by
  intro i j hij
  fin_cases i <;> fin_cases j <;> simp_all [bennettTwoNodes]

/-- The actual integral matrix for two anchors, with the manuscript's exact
clearing factor and column divisibilities. -/
noncomputable def bennettTwoClearedMatrix (a b c : F) (k : ℕ) : Matrix (Fin 3) (Fin 3) F :=
  Matrix.of fun i j ↦ bennettTwoClearedEntry a b c k i j

/-- Nonsingularity of the actual integral two-anchor matrix. All of its
ingredients are constructed explicitly; no determinant certificate is input. -/
theorem bennettTwoClearedMatrix_det_ne_zero
    (a b c : F) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (k : ℕ) (hk : 1 ≤ k) : (bennettTwoClearedMatrix a b c k).det ≠ 0 := by
  have hnodes := bennettTwoNodes_injective a b ha hb hab
  have hzero : bennettTwoNodes a b 0 = 0 := rfl
  have hdet := bennettClearedMatrix_det_half_eval_ne_zero 2 (bennettTwoNodes a b)
    hnodes k hk hzero (a * b * c)
  have hscale : (4 * a * b * (a - b) ^ 2 : F) ^ k ≠ 0 :=
    pow_ne_zero _ (mul_ne_zero (mul_ne_zero (mul_ne_zero (by norm_num) ha) hb)
      (pow_ne_zero _ (sub_ne_zero.mpr hab)))
  have hmatrix : bennettTwoClearedMatrix a b c k =
      (4 * a * b * (a - b) ^ 2 : F) ^ k •
        (bennettClearedMatrix (bennettTwoNodes a b) k (1 / 2 : F)).map
          (Polynomial.evalRingHom (a * b * c)) := by
    apply Matrix.ext
    intro i j
    rfl
  rw [hmatrix, Matrix.det_smul, ← RingHom.map_det]
  exact mul_ne_zero (pow_ne_zero _ hscale) hdet

end D1Bound5
