import D1Bound5.RankOneDeterminantBound

open Matrix

namespace D1Bound5

/-- A four-by-four determinant under a rank-two update reduces exactly
to a two-by-two determinant; no adjoints or Hermitian hypotheses. -/
theorem rankTwo_det_factor
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (U : Matrix (Fin 4) (Fin 2) ℂ)
    (V : Matrix (Fin 2) (Fin 4) ℂ)
    (hF : F.det ≠ 0) :
    (F + U * V).det =
      F.det * ((1 : Matrix (Fin 2) (Fin 2) ℂ) + V * F⁻¹ * U).det := by
  have hu : IsUnit F.det := isUnit_iff_ne_zero.mpr hF
  have hfactor : F * (1 + (F⁻¹ * U) * V) = F + U * V := by
    calc
      F * (1 + (F⁻¹ * U) * V) =
        F + ((F * F⁻¹) * U) * V := by
          rw [Matrix.mul_add, Matrix.mul_one, ← Matrix.mul_assoc,
            ← Matrix.mul_assoc]
      _ = F + U * V := by
        rw [Matrix.mul_nonsing_inv F hu, Matrix.one_mul]
  rw [← hfactor, Matrix.det_mul]
  congr 1
  simpa only [Matrix.mul_assoc] using
    (Matrix.det_one_add_mul_comm (F⁻¹ * U) V)

/-- The explicit two-by-two determinant, with both off-diagonal products
retained. This is valid even for nonsymmetric complex F. -/
theorem rankTwo_det_entries
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (U : Matrix (Fin 4) (Fin 2) ℂ)
    (V : Matrix (Fin 2) (Fin 4) ℂ)
    (hF : F.det ≠ 0) :
    (F + U * V).det = F.det *
      ((1 + (V * F⁻¹ * U) 0 0) *
        (1 + (V * F⁻¹ * U) 1 1) -
        (V * F⁻¹ * U) 0 1 * (V * F⁻¹ * U) 1 0) := by
  rw [rankTwo_det_factor F U V hF]
  simp only [Matrix.det_fin_two, Matrix.add_apply]
  norm_num [Matrix.one_apply]

/-- Two columns encoding the two low-rank directions of the fifth-entry
Schur complement. -/
def productFiveColumns (f w : Fin 4 → ℂ) :
    Matrix (Fin 4) (Fin 2) ℂ :=
  fun i k => if k = 0 then f i else w i

/-- Rows encoding the exact non-Hermitian low-rank perturbation. -/
noncomputable def productFiveRows (f w : Fin 4 → ℂ) (d : ℂ) :
    Matrix (Fin 2) (Fin 4) ℂ :=
  fun k i => if k = 0 then -(w i / d + f i / d^2) else -(f i / d)

/-- Exact matrix equality before applying the rank-two determinant lemma.
No nonzero or invertibility assumptions are required for this identity. -/
theorem productFive_update_entry (f w : Fin 4 → ℂ) (d : ℂ)
    (i j : Fin 4) :
    (productFiveColumns f w * productFiveRows f w d) i j =
      -((w i * f j + f i * w j) / d) - f i * f j / d^2 := by
  simp [Matrix.mul_apply, Fin.sum_univ_two,
    productFiveColumns, productFiveRows]
  ring

/-- All four entries of the two-by-two compressed correction. Its
two mixed bilinear terms are deliberately kept distinct, so this lemma
does not assume that the inverse matrix is symmetric. -/
theorem productFive_compressed_entry
    (X : Matrix (Fin 4) (Fin 4) ℂ)
    (f w : Fin 4 → ℂ) (d : ℂ) (i j : Fin 2) :
    (productFiveRows f w d * X * productFiveColumns f w) i j =
      if i = 0 then
        (if j = 0 then
          -(w ⬝ᵥ (X *ᵥ f)) / d - (f ⬝ᵥ (X *ᵥ f)) / d^2
         else
          -(w ⬝ᵥ (X *ᵥ w)) / d - (f ⬝ᵥ (X *ᵥ w)) / d^2)
      else
        (if j = 0 then
          -(f ⬝ᵥ (X *ᵥ f)) / d
         else
          -(f ⬝ᵥ (X *ᵥ w)) / d) := by
  fin_cases i <;> fin_cases j <;>
    simp [productFiveColumns, productFiveRows, Matrix.mul_apply,
      Matrix.mulVec, dotProduct, Fin.sum_univ_four] <;> ring

/-- The exact rank-two determinant formula for the fifth-entry
Schur complement. No symmetry is assumed: both cross forms occur.
In the symmetric case the two cross forms coincide. -/
theorem productFive_rankTwo_det_general
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (f w : Fin 4 → ℂ) (d : ℂ)
    (hF : F.det ≠ 0) (hd : d ≠ 0) :
    (F + productFiveColumns f w * productFiveRows f w d).det =
      F.det *
        (1 - ((w ⬝ᵥ (F⁻¹ *ᵥ f)) + (f ⬝ᵥ (F⁻¹ *ᵥ w))) / d +
          ((w ⬝ᵥ (F⁻¹ *ᵥ f)) * (f ⬝ᵥ (F⁻¹ *ᵥ w)) -
            (f ⬝ᵥ (F⁻¹ *ᵥ f)) * (w ⬝ᵥ (F⁻¹ *ᵥ w)) -
            (f ⬝ᵥ (F⁻¹ *ᵥ f))) / d^2) := by
  let k := w ⬝ᵥ (F⁻¹ *ᵥ f)
  let h := f ⬝ᵥ (F⁻¹ *ᵥ w)
  let p := f ⬝ᵥ (F⁻¹ *ᵥ f)
  let q := w ⬝ᵥ (F⁻¹ *ᵥ w)
  change _ = F.det * (1 - (k + h) / d + (k * h - p * q - p) / d^2)
  have h00 : (productFiveRows f w d * F⁻¹ *
        productFiveColumns f w) 0 0 = -k / d - p / d^2 := by
    simpa [k, p] using productFive_compressed_entry (F⁻¹) f w d 0 0
  have h01 : (productFiveRows f w d * F⁻¹ *
        productFiveColumns f w) 0 1 = -q / d - h / d^2 := by
    simpa [q, h] using productFive_compressed_entry (F⁻¹) f w d 0 1
  have h10 : (productFiveRows f w d * F⁻¹ *
        productFiveColumns f w) 1 0 = -p / d := by
    simpa [p] using productFive_compressed_entry (F⁻¹) f w d 1 0
  have h11 : (productFiveRows f w d * F⁻¹ *
        productFiveColumns f w) 1 1 = -h / d := by
    simpa [h] using productFive_compressed_entry (F⁻¹) f w d 1 1
  calc
    _ = F.det *
        ((1 + (productFiveRows f w d * F⁻¹ *
          productFiveColumns f w) 0 0) *
         (1 + (productFiveRows f w d * F⁻¹ *
          productFiveColumns f w) 1 1) -
         (productFiveRows f w d * F⁻¹ *
          productFiveColumns f w) 0 1 *
         (productFiveRows f w d * F⁻¹ *
          productFiveColumns f w) 1 0) :=
          rankTwo_det_entries F _ _ hF
    _ = _ := by
      rw [h00, h11, h01, h10]
      field_simp [hd]
      ring

/-- Symmetry of the complex bilinear form of the inverse. No complex
conjugation occurs; this is the ordinary transpose. -/
theorem symmetric_inverse_bilinear_swap
    (F : Matrix (Fin 4) (Fin 4) ℂ) (f w : Fin 4 → ℂ)
    (hsym : Fᵀ = F) :
    w ⬝ᵥ (F⁻¹ *ᵥ f) = f ⬝ᵥ (F⁻¹ *ᵥ w) := by
  have hinv : (F⁻¹)ᵀ = F⁻¹ := by
    rw [Matrix.transpose_nonsing_inv, hsym]
  simpa only [hinv] using
    (Matrix.dotProduct_transpose_mulVec (F⁻¹) w f)

/-- Exactly the manuscript's rank-two determinant polynomial, before
identifying the four-by-four update with the Schur complement. -/
theorem productFive_rankTwo_det_symmetric
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (f w : Fin 4 → ℂ) (d : ℂ)
    (hF : F.det ≠ 0) (hd : d ≠ 0)
    (hsym : Fᵀ = F) :
    (F + productFiveColumns f w * productFiveRows f w d).det =
      F.det *
        (1 - 2 * (f ⬝ᵥ (F⁻¹ *ᵥ w)) / d +
          ((f ⬝ᵥ (F⁻¹ *ᵥ w))^2 -
            (f ⬝ᵥ (F⁻¹ *ᵥ f)) * (w ⬝ᵥ (F⁻¹ *ᵥ w)) -
            (f ⬝ᵥ (F⁻¹ *ᵥ f))) / d^2) := by
  rw [productFive_rankTwo_det_general F f w d hF hd,
    symmetric_inverse_bilinear_swap F f w hsym]
  ring

/-- The four-by-four Schur complement from (integrated-3), written
entrywise so it does not depend on any matrix-divide conventions. -/
noncomputable def productFiveSchur
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (f w : Fin 4 → ℂ) (d : ℂ) :
    Matrix (Fin 4) (Fin 4) ℂ :=
  fun i j => F i j - (w i * f j + f i * w j) / d -
    f i * f j / d^2

/-- The Schur complement is exactly the rank-two perturbation. -/
theorem productFiveSchur_eq
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (f w : Fin 4 → ℂ) (d : ℂ) :
    productFiveSchur F f w d =
      F + productFiveColumns f w * productFiveRows f w d := by
  ext i j
  change F i j - (w i * f j + f i * w j) / d -
    f i * f j / d^2 =
      F i j + (productFiveColumns f w *
        productFiveRows f w d) i j
  rw [productFive_update_entry]
  ring

/-- Exact equation (integrated-3)'s determinant identity in the manuscript:
the complex bilinear transpose is NOT a conjugate transpose. -/
theorem productFiveSchur_det
    (F : Matrix (Fin 4) (Fin 4) ℂ)
    (f w : Fin 4 → ℂ) (d : ℂ)
    (hF : F.det ≠ 0) (hd : d ≠ 0)
    (hsym : Fᵀ = F) :
    (productFiveSchur F f w d).det =
      F.det *
        (1 - 2 * (f ⬝ᵥ (F⁻¹ *ᵥ w)) / d +
          ((f ⬝ᵥ (F⁻¹ *ᵥ w))^2 -
            (f ⬝ᵥ (F⁻¹ *ᵥ f)) * (w ⬝ᵥ (F⁻¹ *ᵥ w)) -
            (f ⬝ᵥ (F⁻¹ *ᵥ f))) / d^2) := by
  rw [productFiveSchur_eq]
  exact productFive_rankTwo_det_symmetric F f w d hF hd hsym

end D1Bound5
