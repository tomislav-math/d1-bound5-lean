import D1Bound5.ProductFiveRankTwo
import Mathlib.LinearAlgebra.Matrix.SchurComplement

open Matrix

namespace D1Bound5

/-- Scalar Schur determinant identity without invertibility of the leading block. -/
theorem scalar_last_block_det
    {n : Type*} [Fintype n] [DecidableEq n]
    (A : Matrix n n ℂ) (b c : n → ℂ) (d : ℂ) (hd : d ≠ 0) :
    (Matrix.fromBlocks A (fun i (_ : Fin 1) => b i)
      (fun (_ : Fin 1) j => c j)
      (fun (_ _ : Fin 1) => d)).det =
      d * (A - Matrix.of (fun i j => b i * c j / d)).det := by
  let B : Matrix n (Fin 1) ℂ := fun i _ => b i
  let C : Matrix (Fin 1) n ℂ := fun _ j => c j
  let D : Matrix (Fin 1) (Fin 1) ℂ := fun _ _ => d
  have hi : D * Matrix.of (fun (_ _ : Fin 1) => d⁻¹) = 1 := by
    ext i j
    fin_cases i
    fin_cases j
    change (∑ k : Fin 1, D 0 k * d⁻¹) = 1
    simp only [Fin.sum_univ_one]
    change d * d⁻¹ = 1
    exact mul_inv_cancel₀ hd
  have hj : Matrix.of (fun (_ _ : Fin 1) => d⁻¹) * D = 1 := by
    ext i j
    fin_cases i
    fin_cases j
    change (∑ k : Fin 1, d⁻¹ * D k 0) = 1
    simp only [Fin.sum_univ_one]
    change d⁻¹ * d = 1
    exact inv_mul_cancel₀ hd
  letI : Invertible D := ⟨Matrix.of (fun (_ _ : Fin 1) => d⁻¹), hj, hi⟩
  have hc : A - B * ⅟D * C =
      A - Matrix.of (fun i j => b i * c j / d) := by
    ext i j
    change A i j - (∑ k : Fin 1, (∑ l : Fin 1, b i * d⁻¹) * c j) =
      A i j - b i * c j / d
    simp only [Fin.sum_univ_one]
    simp [div_eq_mul_inv]
    ring
  change (Matrix.fromBlocks A B C D).det =
    d * (A - Matrix.of (fun i j => b i * c j / d)).det
  rw [Matrix.det_fromBlocks₂₂ A B C D]
  simp only [Matrix.det_fin_one, show D 0 0 = d from rfl, hc]

/-- The five-by-five block matrix in equation (integrated-3), indexed by
Fin 4 ⊕ Fin 1. All products are bilinear, without complex conjugation. -/
noncomputable def productFiveIntegratedBlock
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (f w : Fin 4 → ℂ) (d : ℂ) :
    Matrix (Fin 4 ⊕ Fin 1) (Fin 4 ⊕ Fin 1) ℂ :=
  Matrix.fromBlocks
    (F + Matrix.of (fun i j => w i * w j))
    (fun i (_ : Fin 1) => f i + d * w i)
    (fun (_ : Fin 1) j => f j + d * w j)
    (fun (_ _ : Fin 1) => d^2)

/-- Exact block determinant in equation (integrated-3), without requiring
the leading four-by-four matrix to be nonsingular. -/
theorem productFiveIntegratedBlock_det
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (f w : Fin 4 → ℂ) (d : ℂ) (hd : d ≠ 0) :
    (productFiveIntegratedBlock F f w d).det =
      d^2 * (productFiveSchur F f w d).det := by
  have hmat :
      F + Matrix.of (fun i j => w i * w j) -
          Matrix.of (fun i j => (f i + d * w i) * (f j + d * w j) / d^2) =
        productFiveSchur F f w d := by
    ext i j
    simp only [Matrix.add_apply, Matrix.sub_apply, Matrix.of_apply,
      productFiveSchur]
    field_simp [hd]
    ring
  unfold productFiveIntegratedBlock
  rw [scalar_last_block_det _ (fun i => f i + d * w i)
    (fun j => f j + d * w j) (d^2) (pow_ne_zero 2 hd)]
  rw [hmat]

end D1Bound5
