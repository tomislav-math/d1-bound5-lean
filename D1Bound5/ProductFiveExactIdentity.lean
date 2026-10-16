import D1Bound5.ProductFiveMatrixBridge

open Matrix

namespace D1Bound5

/-- A symmetric five-by-five matrix has a symmetric four-by-four leading block. -/
theorem five_prefix_symmetric
    (E : Matrix (Fin 5) (Fin 5) ℂ) (hsym : Eᵀ = E) :
    (fivePrefixError E)ᵀ = fivePrefixError E := by
  ext i j
  change E (Fin.castAdd 1 j) (Fin.castAdd 1 i) =
    E (Fin.castAdd 1 i) (Fin.castAdd 1 j)
  have h := congrArg
    (fun N : Matrix (Fin 5) (Fin 5) ℂ =>
      N (Fin.castAdd 1 i) (Fin.castAdd 1 j)) hsym
  simpa only [Matrix.transpose_apply] using h

/-- Symmetry survives the square-root normalization, with no nonzero
hypotheses on tuple entries or auxiliary roots. -/
theorem five_normalized_error_symmetric
    (t u : Fin 5 → ℂ) (M : Matrix (Fin 5) (Fin 5) ℂ)
    (hsym : Mᵀ = M) :
    (normalizedRootError t u M)ᵀ = normalizedRootError t u M := by
  ext i j
  change u j * M j i * u i - t j * t i =
    u i * M i j * u j - t i * t j
  have h := congrArg
    (fun N : Matrix (Fin 5) (Fin 5) ℂ => N i j) hsym
  change M j i = M i j at h
  rw [h]
  ring

/-- The exact rank-two determinant identity for an actual normalized
five-entry symmetric root matrix. This links the five-entry normalization
to the four-by-four inverse quadratic forms without an additional
hypothesis on any prefix tuple element or on off-diagonal roots. -/
theorem five_normalized_root_det_rankTwo
    (t u : Fin 5 → ℂ) (M : Matrix (Fin 5) (Fin 5) ℂ)
    (hu : ∀ i, (u i)^2 = t i)
    (hdiag : ∀ i, M i i = t i)
    (hsym : Mᵀ = M)
    (hd : fiveLastValue t ≠ 0)
    (hF : (fivePrefixError (normalizedRootError t u M)).det ≠ 0) :
    let E := normalizedRootError t u M
    let F := fivePrefixError E
    let f := fiveLastError E
    let w := fivePrefixValues t
    let d := fiveLastValue t
    (∏ i, t i) * M.det =
      d^2 * F.det *
        (1 - 2 * (f ⬝ᵥ (F⁻¹ *ᵥ w)) / d +
          ((f ⬝ᵥ (F⁻¹ *ᵥ w))^2 -
            (f ⬝ᵥ (F⁻¹ *ᵥ f)) * (w ⬝ᵥ (F⁻¹ *ᵥ w)) -
            (f ⬝ᵥ (F⁻¹ *ᵥ f))) / d^2) := by
  let E := normalizedRootError t u M
  let F := fivePrefixError E
  let f := fiveLastError E
  let w := fivePrefixValues t
  let d := fiveLastValue t
  change (∏ i, t i) * M.det =
    d^2 * F.det *
      (1 - 2 * (f ⬝ᵥ (F⁻¹ *ᵥ w)) / d +
        ((f ⬝ᵥ (F⁻¹ *ᵥ w))^2 -
          (f ⬝ᵥ (F⁻¹ *ᵥ f)) * (w ⬝ᵥ (F⁻¹ *ᵥ w)) -
          (f ⬝ᵥ (F⁻¹ *ᵥ f))) / d^2)
  have hFs : Fᵀ = F :=
    five_prefix_symmetric E (five_normalized_error_symmetric t u M hsym)
  calc
    (∏ i, t i) * M.det = d^2 * (productFiveSchur F f w d).det :=
      five_normalized_root_det t u M hu hdiag hsym hd
    _ = d^2 * F.det *
          (1 - 2 * (f ⬝ᵥ (F⁻¹ *ᵥ w)) / d +
            ((f ⬝ᵥ (F⁻¹ *ᵥ w))^2 -
              (f ⬝ᵥ (F⁻¹ *ᵥ f)) * (w ⬝ᵥ (F⁻¹ *ᵥ w)) -
              (f ⬝ᵥ (F⁻¹ *ᵥ f))) / d^2) := by
      rw [productFiveSchur_det F f w d hF hd hFs]
      ring

end D1Bound5
