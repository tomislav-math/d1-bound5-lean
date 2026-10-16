import D1Bound5.EvenDeterminant
import D1Bound5.DeterminantNormalization
import Mathlib.Analysis.Normed.Group.Basic

open scoped NumberField BigOperators
open Module

namespace D1Bound5

/-- Exact determinant modulus after scaling a root matrix. This identity
works in an arbitrary source commutative ring and in every finite dimension,
including zero entries and zero auxiliary square roots. -/
theorem scaledRootMatrix_det_norm_identity
    {R n : Type*} [CommRing R] [Fintype n] [DecidableEq n]
    (f : R →+* ℂ) (a : n → R) (u : n → ℂ)
    (M : Matrix n n R) (hu : ∀ i, (u i)^2 = f (a i)) :
    ‖(scaledRootMatrix u (M.map f)).det‖ =
      (∏ i, ‖f (a i)‖) * ‖f M.det‖ := by
  have hp : (∏ i, u i)^2 = (∏ i, f (a i)) := by
    rw [← Finset.prod_pow]
    exact Finset.prod_congr rfl (fun i _ => hu i)
  have hmap := RingHom.map_det f M
  change f M.det = (M.map f).det at hmap
  rw [scaledRootMatrix_det, hp, ← hmap, norm_mul, norm_prod]

/-- The determinant bound needs only a lower bound for the unscaled
integral determinant; no nonvanishing hypothesis on the coordinates. -/
theorem scaledRootMatrix_det_norm_lower
    {R n : Type*} [CommRing R] [Fintype n] [DecidableEq n]
    (f : R →+* ℂ) (a : n → R) (u : n → ℂ)
    (M : Matrix n n R) (hu : ∀ i, (u i)^2 = f (a i))
    (hdet : 1 ≤ ‖f M.det‖) :
    (∏ i, ‖f (a i)‖) ≤ ‖(scaledRootMatrix u (M.map f)).det‖ := by
  rw [scaledRootMatrix_det_norm_identity f a u M hu]
  have hnonneg : 0 ≤ (∏ i, ‖f (a i)‖) := by positivity
  nlinarith [mul_le_mul_of_nonneg_left hdet hnonneg]

/-- For every imaginary quadratic FULL integer ring, the root-square
relations give the arithmetic determinant lower bound in even dimension. -/
theorem full_ring_scaledRootMatrix_det_norm_lower
    {K n : Type*} [Field K] [NumberField K]
    [NumberField.IsTotallyComplex K] [Fintype n] [DecidableEq n]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (hn : Even (Fintype.card n))
    (a : n → 𝓞 K) (M : Matrix n n (𝓞 K))
    (hd : ∀ i, M i i = a i)
    (hs : ∀ i j, i ≠ j → (M i j)^2 = a i*a j+1)
    (u : n → ℂ) (hu : ∀ i, (u i)^2 = phi (a i : K)) :
    (∏ i, ‖phi (a i : K)‖) ≤
      ‖(scaledRootMatrix u
        (M.map (phi.comp (algebraMap (𝓞 K) K)))).det‖ := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hdet : 1 ≤ ‖f M.det‖ := even_root_matrix_one_le_norm hK phi hn a M hd hs
  exact scaledRootMatrix_det_norm_lower f a u M hu hdet

end D1Bound5
