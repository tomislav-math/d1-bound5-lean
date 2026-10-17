import D1Bound5.ProductFiveCompatibleSigns
import D1Bound5.ProductFiveInverseVector
import D1Bound5.WeightedSchur

open scoped Matrix.Norms.L2Operator
open Matrix

namespace D1Bound5

/-- The prefix from a single five-entry signed original-ring root matrix
satisfies the mixed operator-norm bound. -/
theorem five_compatible_prefix_operator_bound
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a : Fin 5 → R) (u : Fin 5 → ℂ)
    (S : Matrix (Fin 5) (Fin 5) R)
    (hu : ∀ i, (u i)^2 = f (a i))
    (hdiag : ∀ i, S i i = a i)
    (hgood : ∀ i j, i ≠ j → FiveSignedEntryGood f a u i j (S i j)) :
    ‖fivePrefixError (normalizedRootError (fun i => f (a i)) u
        (fun i j => f (S i j))) - halfOffDiagonal‖ ≤
      (11/96 : ℝ) := by
  let E := normalizedRootError (fun i => f (a i)) u (fun i j => f (S i j))
  let F := fivePrefixError E
  have hd : ∀ i, F i i = 0 := by
    intro i
    exact normalizedRootError_diag (fun k => f (a k)) u
      (fun k l => f (S k l)) hu
      (fun k => congrArg f (hdiag k)) (Fin.castAdd 1 i)
  have hg := fiveSignedEntryGood_prefix f a u S hgood
  have hf : ∀ i j, i ≠ j → i = 0 ∨ j = 0 →
      ‖F i j - (1/2 : ℂ)‖ < (1/18 : ℝ) := by
    intro i j hij hz
    have h : SignedEntryBounds f (a (Fin.castAdd 1 i))
        (a (Fin.castAdd 1 j)) (u (Fin.castAdd 1 i)) (u (Fin.castAdd 1 j))
        (S (Fin.castAdd 1 i) (Fin.castAdd 1 j)) (5/9) (25/486) := by
      simpa [MixedSignedEntryGood, hz] using hg i j hij
    change ‖(u (Fin.castAdd 1 i) * f (S (Fin.castAdd 1 i) (Fin.castAdd 1 j)) *
      u (Fin.castAdd 1 j) - f (a (Fin.castAdd 1 i)) *
      f (a (Fin.castAdd 1 j))) - (1/2 : ℂ)‖ < (1/18 : ℝ)
    exact lt_trans h.2 (by norm_num)
  have hl : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      ‖F i j - (1/2 : ℂ)‖ < (1/64 : ℝ) := by
    intro i j hij hz
    have h : SignedEntryBounds f (a (Fin.castAdd 1 i))
        (a (Fin.castAdd 1 j)) (u (Fin.castAdd 1 i)) (u (Fin.castAdd 1 j))
        (S (Fin.castAdd 1 i) (Fin.castAdd 1 j)) (7/13) (1/64) := by
      simpa [MixedSignedEntryGood, hz] using hg i j hij
    change ‖(u (Fin.castAdd 1 i) * f (S (Fin.castAdd 1 i) (Fin.castAdd 1 j)) *
      u (Fin.castAdd 1 j) - f (a (Fin.castAdd 1 i)) *
      f (a (Fin.castAdd 1 j))) - (1/2 : ℂ)‖ < (1/64 : ℝ)
    exact h.2
  have hd' : ∀ i, (F - halfOffDiagonal) i i = 0 := by
    intro i
    simpa [Matrix.sub_apply, halfOffDiagonal, hd i]
  have hf' : ∀ i j, i ≠ j → i = 0 ∨ j = 0 →
      ‖(F - halfOffDiagonal) i j‖ < (1/18 : ℝ) := by
    intro i j hij hz
    simpa [Matrix.sub_apply, halfOffDiagonal, hij] using hf i j hij hz
  have hl' : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      ‖(F - halfOffDiagonal) i j‖ < (1/64 : ℝ) := by
    intro i j hij hz
    simpa [Matrix.sub_apply, halfOffDiagonal, hij] using hl i j hij hz
  exact mixedFour_operator_norm_le (F - halfOffDiagonal) hd' hf' hl'

/-- The inverse last-column estimate uses the same five-entry sign choice
as the sharp prefix determinant bound. -/
theorem five_compatible_inverse_vector_bound
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a : Fin 5 → R) (u : Fin 5 → ℂ)
    (S : Matrix (Fin 5) (Fin 5) R)
    (hu : ∀ i, (u i)^2 = f (a i))
    (hdiag : ∀ i, S i i = a i)
    (hgood : ∀ i j, i ≠ j → FiveSignedEntryGood f a u i j (S i j)) :
    let E := normalizedRootError (fun i => f (a i)) u (fun i j => f (S i j))
    let F := fivePrefixError E
    let v := fiveLastError E
    ‖(WithLp.toLp 2 (F⁻¹ *ᵥ v) : EuclideanSpace ℂ (Fin 4))‖ <
      (11/12 : ℝ) := by
  let E := normalizedRootError (fun i => f (a i)) u (fun i j => f (S i j))
  let F := fivePrefixError E
  let v := fiveLastError E
  have hnear := five_compatible_prefix_operator_bound f a u S hu hdiag hgood
  have hlast := fiveSignedEntryGood_last_column f a u S hgood
  have hv := (fiveLastColumn_l2_bounds v (fun i => (hlast i).2)).1
  exact productFive_inverse_vector_bound F v hnear hv

end D1Bound5

open scoped InnerProductSpace

namespace D1Bound5

/-- Complex bilinear Cauchy--Schwarz, with the conjugate used only
inside the Hilbert-space inner product. -/
theorem productFive_bilinear_l2_le (v w : Fin 4 → ℂ) :
    ‖v ⬝ᵥ w‖ ≤
      ‖(WithLp.toLp 2 v : EuclideanSpace ℂ (Fin 4))‖ *
      ‖(WithLp.toLp 2 w : EuclideanSpace ℂ (Fin 4))‖ := by
  let x : EuclideanSpace ℂ (Fin 4) := WithLp.toLp 2 v
  let y : EuclideanSpace ℂ (Fin 4) := WithLp.toLp 2 (star v)
  have hy : ‖y‖ = ‖x‖ := by
    have hsq : ‖y‖ ^ 2 = ‖x‖ ^ 2 := by
      rw [EuclideanSpace.norm_sq_eq y, EuclideanSpace.norm_sq_eq x]
      simp [x, y]
    nlinarith only [hsq, norm_nonneg x, norm_nonneg y]
  have hinner : v ⬝ᵥ w =
      inner ℂ y (WithLp.toLp 2 w : EuclideanSpace ℂ (Fin 4)) := by
    change v ⬝ᵥ w = inner ℂ (WithLp.toLp 2 (star v))
      (WithLp.toLp 2 w)
    rw [EuclideanSpace.inner_toLp_toLp]
    simp [dotProduct_comm]
  calc
    ‖v ⬝ᵥ w‖ =
        ‖inner ℂ y (WithLp.toLp 2 w : EuclideanSpace ℂ (Fin 4))‖ :=
          congrArg norm hinner
    _ ≤ ‖y‖ * ‖(WithLp.toLp 2 w : EuclideanSpace ℂ (Fin 4))‖ :=
          norm_inner_le_norm _ _
    _ = ‖(WithLp.toLp 2 v : EuclideanSpace ℂ (Fin 4))‖ *
          ‖(WithLp.toLp 2 w : EuclideanSpace ℂ (Fin 4))‖ := by rw [hy]

/-- The bilinear p-form is bounded by one under the quantitative last-column
and inverse-vector estimates. -/
theorem productFive_selfBilinear_norm_lt_one
    (F : Matrix (Fin 4) (Fin 4) ℂ) (v : Fin 4 → ℂ)
    (hv : ‖(WithLp.toLp 2 v : EuclideanSpace ℂ (Fin 4))‖ <
      (201/200 : ℝ))
    (hFv : ‖(WithLp.toLp 2 (F⁻¹ *ᵥ v) : EuclideanSpace ℂ (Fin 4))‖ <
      (11/12 : ℝ)) :
    ‖v ⬝ᵥ (F⁻¹ *ᵥ v)‖ < 1 := by
  calc
    ‖v ⬝ᵥ (F⁻¹ *ᵥ v)‖ ≤
        ‖(WithLp.toLp 2 v : EuclideanSpace ℂ (Fin 4))‖ *
          ‖(WithLp.toLp 2 (F⁻¹ *ᵥ v) : EuclideanSpace ℂ (Fin 4))‖ :=
      productFive_bilinear_l2_le v (F⁻¹ *ᵥ v)
    _ ≤ (201/200 : ℝ) *
          ‖(WithLp.toLp 2 (F⁻¹ *ᵥ v) : EuclideanSpace ℂ (Fin 4))‖ :=
      mul_le_mul_of_nonneg_right hv.le (norm_nonneg _)
    _ < (201/200 : ℝ) * (11/12 : ℝ) :=
      mul_lt_mul_of_pos_left hFv (by norm_num)
    _ < 1 := by norm_num

/-- A single five-entry original-ring sign choice supplies the p-bound
needed by the rank-two Schur determinant argument. -/
theorem five_compatible_bilinear_p_bound
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a : Fin 5 → R) (u : Fin 5 → ℂ)
    (S : Matrix (Fin 5) (Fin 5) R)
    (hu : ∀ i, (u i)^2 = f (a i))
    (hdiag : ∀ i, S i i = a i)
    (hgood : ∀ i j, i ≠ j → FiveSignedEntryGood f a u i j (S i j)) :
    let E := normalizedRootError (fun i => f (a i)) u (fun i j => f (S i j))
    let F := fivePrefixError E
    let v := fiveLastError E
    ‖v ⬝ᵥ (F⁻¹ *ᵥ v)‖ < (1 : ℝ) := by
  let E := normalizedRootError (fun i => f (a i)) u (fun i j => f (S i j))
  let F := fivePrefixError E
  let v := fiveLastError E
  have hlast := fiveSignedEntryGood_last_column f a u S hgood
  have hv := (fiveLastColumn_l2_bounds v (fun i => (hlast i).2)).2
  have hInv := five_compatible_inverse_vector_bound f a u S hu hdiag hgood
  exact productFive_selfBilinear_norm_lt_one F v hv hInv

end D1Bound5
