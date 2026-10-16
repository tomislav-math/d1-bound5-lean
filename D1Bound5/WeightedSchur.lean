import D1Bound5.WeightedRowCertificate
import Mathlib.Algebra.Order.BigOperators.Ring.Finset
import Mathlib.Analysis.InnerProductSpace.PiL2

open scoped Matrix.Norms.L2Operator
open Matrix

namespace D1Bound5

/-- Weighted finite Cauchy--Schwarz without square roots or positivity of x. -/
theorem weightedCS_four_row (b w x : Fin 4 → ℝ)
    (hb : ∀ j, 0 ≤ b j) (hw : ∀ j, 0 < w j) :
    (∑ j, b j * x j)^2 ≤
      (∑ j, b j * w j) * (∑ j, b j * (x j)^2 / w j) := by
  apply Finset.sum_sq_le_sum_mul_sum_of_sq_le_mul Finset.univ
  · intro j _
    exact mul_nonneg (hb j) (hw j).le
  · intro j _
    exact div_nonneg (mul_nonneg (hb j) (sq_nonneg _)) (hw j).le
  · intro j _
    have hj : w j ≠ 0 := ne_of_gt (hw j)
    apply le_of_eq
    field_simp

end D1Bound5

namespace D1Bound5

/-- The four-dimensional real weighted Schur estimate, stated as a
squared-energy bound. The matrix entries need only be nonnegative and
symmetric, and the input vector may have arbitrary signs. -/
theorem weightedSchur_four_energy
    (b : Matrix (Fin 4) (Fin 4) ℝ) (w x : Fin 4 → ℝ) (c : ℝ)
    (hb : ∀ i j, 0 ≤ b i j)
    (hw : ∀ i, 0 < w i) (hc : 0 ≤ c)
    (hsymm : ∀ i j, b i j = b j i)
    (hrows : ∀ i, (∑ j, b i j * w j) ≤ c * w i) :
    (∑ i, (∑ j, b i j * x j)^2) ≤ c^2 * (∑ j, (x j)^2) := by
  have hnon (i : Fin 4) : 0 ≤ ∑ j, b i j * (x j)^2 / w j :=
    Finset.sum_nonneg (fun j _ =>
      div_nonneg (mul_nonneg (hb i j) (sq_nonneg _)) (hw j).le)
  have hcol (j : Fin 4) : (∑ i, w i * b i j) ≤ c * w j := by
    calc
      (∑ i, w i * b i j) = ∑ i, b j i * w i := by
        apply Finset.sum_congr rfl
        intro i _
        rw [hsymm i j]
        ring
      _ ≤ c * w j := hrows j
  have hrow (i : Fin 4) :
      (∑ j, b i j * x j)^2 ≤
        (c * w i) * (∑ j, b i j * (x j)^2 / w j) := by
    calc
      _ ≤ (∑ j, b i j * w j) * (∑ j, b i j * (x j)^2 / w j) :=
        weightedCS_four_row (b i) w x (hb i) hw
      _ ≤ (c * w i) * (∑ j, b i j * (x j)^2 / w j) :=
        mul_le_mul_of_nonneg_right (hrows i) (hnon i)
  calc
    (∑ i, (∑ j, b i j * x j)^2) ≤
        ∑ i, (c * w i) * (∑ j, b i j * (x j)^2 / w j) := by
          apply Finset.sum_le_sum
          intro i _
          exact hrow i
    _ = ∑ i, ∑ j, (x j)^2 / w j * (c * (w i * b i j)) := by
          apply Finset.sum_congr rfl
          intro i _
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro j _
          ring
    _ = ∑ j, ∑ i, (x j)^2 / w j * (c * (w i * b i j)) := Finset.sum_comm
    _ = ∑ j, ((x j)^2 / w j) * (c * (∑ i, w i * b i j)) := by
          apply Finset.sum_congr rfl
          intro j _
          simp only [Finset.mul_sum]
    _ ≤ ∑ j, ((x j)^2 / w j) * (c * (c * w j)) := by
          apply Finset.sum_le_sum
          intro j _
          exact mul_le_mul_of_nonneg_left
            (mul_le_mul_of_nonneg_left (hcol j) hc)
            (div_nonneg (sq_nonneg _) (hw j).le)
    _ = c^2 * (∑ j, (x j)^2) := by
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro j _
          have hj : w j ≠ 0 := ne_of_gt (hw j)
          field_simp

end D1Bound5

namespace D1Bound5

/-- A nonnegative symmetric entrywise envelope with positive weighted
row sums bounds the complex Euclidean L2 operator norm. The complex
matrix itself need not be symmetric or Hermitian. -/
theorem weightedSchur_four_opNorm
    (E : Matrix (Fin 4) (Fin 4) ℂ)
    (b : Matrix (Fin 4) (Fin 4) ℝ) (w : Fin 4 → ℝ) (c : ℝ)
    (hb : ∀ i j, 0 ≤ b i j)
    (hw : ∀ i, 0 < w i) (hc : 0 ≤ c)
    (hsymm : ∀ i j, b i j = b j i)
    (hrows : ∀ i, (∑ j, b i j * w j) ≤ c * w i)
    (hEb : ∀ i j, ‖E i j‖ ≤ b i j) :
    ‖E‖ ≤ c := by
  let T : EuclideanSpace ℂ (Fin 4) →L[ℂ] EuclideanSpace ℂ (Fin 4) :=
    Matrix.toEuclideanCLM (n := Fin 4) (𝕜 := ℂ) E
  change ‖T‖ ≤ c
  refine T.opNorm_le_bound hc (fun y => ?_)
  have hsum (i : Fin 4) :
      ‖(E *ᵥ WithLp.ofLp y) i‖ ≤
        ∑ j, b i j * ‖WithLp.ofLp y j‖ := by
    rw [Matrix.mulVec, dotProduct]
    calc
      ‖∑ j, E i j * WithLp.ofLp y j‖ ≤
          ∑ j, ‖E i j * WithLp.ofLp y j‖ := norm_sum_le _ _
      _ = ∑ j, ‖E i j‖ * ‖WithLp.ofLp y j‖ := by simp_rw [norm_mul]
      _ ≤ ∑ j, b i j * ‖WithLp.ofLp y j‖ := by
        apply Finset.sum_le_sum
        intro j _
        exact mul_le_mul_of_nonneg_right (hEb i j) (norm_nonneg _)
  have hsumpos (i : Fin 4) :
      0 ≤ ∑ j, b i j * ‖WithLp.ofLp y j‖ :=
    Finset.sum_nonneg (fun j _ => mul_nonneg (hb i j) (norm_nonneg _))
  have hsquares (i : Fin 4) :
      ‖(E *ᵥ WithLp.ofLp y) i‖^2 ≤
        (∑ j, b i j * ‖WithLp.ofLp y j‖)^2 :=
    (sq_le_sq₀ (norm_nonneg _) (hsumpos i)).mpr (hsum i)
  have henergy := weightedSchur_four_energy b w
      (fun j => ‖WithLp.ofLp y j‖) c hb hw hc hsymm hrows
  have hbound : ‖T y‖^2 ≤ c^2 * ‖y‖^2 := by
    calc
      ‖T y‖^2 =
          ∑ i, ‖(E *ᵥ WithLp.ofLp y) i‖^2 := by
            rw [EuclideanSpace.norm_sq_eq]
            simp only [T, Matrix.ofLp_toEuclideanCLM]
      _ ≤ ∑ i, (∑ j, b i j * ‖WithLp.ofLp y j‖)^2 := by
            exact Finset.sum_le_sum (fun i _ => hsquares i)
      _ ≤ c^2 * (∑ j, ‖WithLp.ofLp y j‖^2) := henergy
      _ = c^2 * ‖y‖^2 := by rw [EuclideanSpace.norm_sq_eq]
  have hbound' : ‖T y‖^2 ≤ (c * ‖y‖)^2 := by
    nlinarith only [hbound]
  exact (sq_le_sq₀ (norm_nonneg _) (mul_nonneg hc (norm_nonneg y))).mp hbound'

/-- The concrete mixed 4x4 weighted Schur operator-norm estimate needed
in the A >= 1, B >= 3 branch of manuscript Lemma product-four. -/
theorem mixedFour_operator_norm_le
    (E : Matrix (Fin 4) (Fin 4) ℂ)
    (hdiag : ∀ i, E i i = 0)
    (hfirst : ∀ i j, i ≠ j → i = 0 ∨ j = 0 →
      ‖E i j‖ < (1 / 18 : ℝ))
    (hlater : ∀ i j, i ≠ j → ¬(i = 0 ∨ j = 0) →
      ‖E i j‖ < (1 / 64 : ℝ)) :
    ‖E‖ ≤ (11 / 96 : ℝ) := by
  exact weightedSchur_four_opNorm E mixedFourEnvelope weightedFourWeights
    (11 / 96) mixedFourEnvelope_nonneg weightedFourWeights_pos
    (by norm_num) mixedFourEnvelope_symmetric mixedFourEnvelope_weighted_rows
    (mixedFour_entry_norm_le_envelope E hdiag hfirst hlater)

end D1Bound5
