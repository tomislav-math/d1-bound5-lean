import D1Bound5.ProductFiveBlockDet
import D1Bound5.DeterminantNormalization

open Matrix

namespace D1Bound5

/-- The four-entry prefix, using the canonical inclusion into five indices. -/
def fivePrefixError (E : Matrix (Fin 5) (Fin 5) ℂ) :
    Matrix (Fin 4) (Fin 4) ℂ :=
  fun i j => E (Fin.castAdd 1 i) (Fin.castAdd 1 j)

/-- The last column of a five-entry correction matrix. -/
def fiveLastError (E : Matrix (Fin 5) (Fin 5) ℂ) : Fin 4 → ℂ :=
  fun i => E (Fin.castAdd 1 i) (Fin.natAdd 4 (0 : Fin 1))

/-- The first four tuple elements. -/
def fivePrefixValues (t : Fin 5 → ℂ) : Fin 4 → ℂ :=
  fun i => t (Fin.castAdd 1 i)

/-- The last tuple element, without introducing square roots or division. -/
def fiveLastValue (t : Fin 5 → ℂ) : ℂ :=
  t (Fin.natAdd 4 (0 : Fin 1))

/-- The exact five-by-five block structure of a symmetric normalized root
matrix. No invertibility or nonzero tuple hypotheses are needed. -/
theorem five_reindex_rankOne_plus_error
    (t : Fin 5 → ℂ) (E : Matrix (Fin 5) (Fin 5) ℂ)
    (hdiag : E (Fin.natAdd 4 (0 : Fin 1)) (Fin.natAdd 4 (0 : Fin 1)) = 0)
    (hsym : Eᵀ = E) :
    Matrix.reindex (finSumFinEquiv : Fin 4 ⊕ Fin 1 ≃ Fin 5).symm
      (finSumFinEquiv : Fin 4 ⊕ Fin 1 ≃ Fin 5).symm
      (fun i j => t i * t j + E i j) =
      productFiveIntegratedBlock
        (fivePrefixError E) (fiveLastError E)
        (fivePrefixValues t) (fiveLastValue t) := by
  classical
  ext i j
  rcases i with i | i <;> rcases j with j | j
  · change t (Fin.castAdd 1 i) * t (Fin.castAdd 1 j) +
        E (Fin.castAdd 1 i) (Fin.castAdd 1 j) =
      fivePrefixError E i j + fivePrefixValues t i * fivePrefixValues t j
    simp [fivePrefixError, fivePrefixValues]
    ring
  · fin_cases j
    change t (Fin.castAdd 1 i) * t (Fin.natAdd 4 (0 : Fin 1)) +
        E (Fin.castAdd 1 i) (Fin.natAdd 4 (0 : Fin 1)) =
      fiveLastError E i + fiveLastValue t * fivePrefixValues t i
    simp [fiveLastError, fiveLastValue, fivePrefixValues]
    ring
  · fin_cases i
    have he : E (Fin.natAdd 4 (0 : Fin 1)) (Fin.castAdd 1 j) =
        E (Fin.castAdd 1 j) (Fin.natAdd 4 (0 : Fin 1)) := by
      have hh := congrArg
        (fun H : Matrix (Fin 5) (Fin 5) ℂ =>
          H (Fin.castAdd 1 j) (Fin.natAdd 4 (0 : Fin 1))) hsym
      simpa only [Matrix.transpose_apply] using hh
    change t (Fin.natAdd 4 (0 : Fin 1)) * t (Fin.castAdd 1 j) +
        E (Fin.natAdd 4 (0 : Fin 1)) (Fin.castAdd 1 j) =
      fiveLastError E j + fiveLastValue t * fivePrefixValues t j
    dsimp [fiveLastError, fiveLastValue, fivePrefixValues]
    change E (4 : Fin 5) (Fin.castAdd 1 j) = E (Fin.castAdd 1 j) 4 at he
    rw [he]
    ring
  · fin_cases i
    fin_cases j
    change t (Fin.natAdd 4 (0 : Fin 1)) *
      t (Fin.natAdd 4 (0 : Fin 1)) +
      E (Fin.natAdd 4 (0 : Fin 1)) (Fin.natAdd 4 (0 : Fin 1)) =
      (fiveLastValue t)^2
    rw [hdiag]
    simp [fiveLastValue, pow_two]

/-- The determinant of the actual Fin 5 matrix is the scalar-block
Schur determinant. The equivalence reindexes both rows and columns
simultaneously and therefore introduces no permutation sign. -/
theorem five_integrated_det_of_symmetric_error
    (t : Fin 5 → ℂ) (E : Matrix (Fin 5) (Fin 5) ℂ)
    (hdiag : E (Fin.natAdd 4 (0 : Fin 1)) (Fin.natAdd 4 (0 : Fin 1)) = 0)
    (hsym : Eᵀ = E) (hd : fiveLastValue t ≠ 0) :
    (Matrix.of (fun i j => t i * t j + E i j)).det =
      (fiveLastValue t)^2 *
        (productFiveSchur (fivePrefixError E) (fiveLastError E)
          (fivePrefixValues t) (fiveLastValue t)).det := by
  have hm := five_reindex_rankOne_plus_error t E hdiag hsym
  have hdet := congrArg Matrix.det hm
  have hr := Matrix.det_reindex_self
    (finSumFinEquiv : Fin 4 ⊕ Fin 1 ≃ Fin 5).symm
    (Matrix.of (fun i j => t i * t j + E i j))
  exact hr.symm.trans (hdet.trans
    (productFiveIntegratedBlock_det (fivePrefixError E) (fiveLastError E)
      (fivePrefixValues t) (fiveLastValue t) hd))

/-- The fully normalized five-entry determinant identity for symmetric
square-root matrices. Only the final tuple element must be nonzero.
The other tuple entries and every off-diagonal square root may vanish. -/
theorem five_normalized_root_det
    (t u : Fin 5 → ℂ) (M : Matrix (Fin 5) (Fin 5) ℂ)
    (hu : ∀ i, (u i)^2 = t i)
    (hdiag : ∀ i, M i i = t i)
    (hsym : Mᵀ = M)
    (hd : fiveLastValue t ≠ 0) :
    (∏ i, t i) * M.det =
      (fiveLastValue t)^2 *
        (productFiveSchur
          (fivePrefixError (normalizedRootError t u M))
          (fiveLastError (normalizedRootError t u M))
          (fivePrefixValues t) (fiveLastValue t)).det := by
  let E := normalizedRootError t u M
  have hEdiag :
      E (Fin.natAdd 4 (0 : Fin 1)) (Fin.natAdd 4 (0 : Fin 1)) = 0 :=
    normalizedRootError_diag t u M hu hdiag _
  have hEsym : Eᵀ = E := by
    ext i j
    change u j * M j i * u i - t j * t i =
      u i * M i j * u j - t i * t j
    have hm := congrArg (fun N : Matrix (Fin 5) (Fin 5) ℂ => N i j) hsym
    change M j i = M i j at hm
    rw [hm]
    ring
  have hp := normalizedRootError_det t u M hu
  exact hp.symm.trans (five_integrated_det_of_symmetric_error t E hEdiag hEsym hd)

end D1Bound5
