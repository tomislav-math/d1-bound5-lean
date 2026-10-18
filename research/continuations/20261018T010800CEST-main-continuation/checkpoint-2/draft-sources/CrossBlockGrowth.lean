import D1Bound5.CrossBlockUpper
import D1Bound5.RootMatrixSigns

open scoped BigOperators NumberField
open Module

namespace D1Bound5

private theorem crossBlock_ordered_pair_le
    (A : Fin 3 → ℝ) (hA0 : ∀ i, 0 ≤ A i) (hA : Monotone A)
    (i j : Fin 3) (hij : i ≠ j) : A i*A j ≤ A 1*A 2 := by
  rcases lt_or_gt_of_ne hij with hlt | hgt
  · exact mul_le_mul (hA (by omega : i ≤ 1)) (hA (by omega : j ≤ 2))
      (hA0 j) (hA0 1)
  · rw [mul_comm (A i) (A j)]
    exact mul_le_mul (hA (by omega : j ≤ 1)) (hA (by omega : i ≤ 2))
      (hA0 i) (hA0 1)

private theorem crossBlock_ordered_cubic_le
    (A : Fin 3 → ℝ) (hA0 : ∀ i, 0 ≤ A i) (hA : Monotone A)
    (i j : Fin 3) (hij : i ≠ j) : (A i)^2*A j ≤ (A 2)^2*A 1 := by
  calc
    (A i)^2*A j = A i*(A i*A j) := by ring
    _ ≤ A 2*(A 1*A 2) := mul_le_mul (hA (by omega : i ≤ 2))
      (crossBlock_ordered_pair_le A hA0 hA i j hij)
      (mul_nonneg (hA0 i) (hA0 j)) (hA0 2)
    _ = (A 2)^2*A 1 := by ring

/-- The finite rank-layer estimate specialized to ordered complex moduli.
The constant two fifteenths is a strict upper bound for 128/961 supplied
by the algebraic square-root perturbation estimate. -/
theorem crossBlock_ordered_error_det_upper
    (a b : Fin 3 → ℂ) (E : Matrix (Fin 3) (Fin 3) ℂ)
    (ha : Monotone (fun i => ‖a i‖)) (hb : Monotone (fun i => ‖b i‖))
    (hE : ∀ i j, ‖E i j‖ ≤ (2/15 : ℝ))
    (hW1 : 9 ≤ ‖a 1‖*‖b 1‖) (hW2 : 9 ≤ ‖a 2‖*‖b 2‖) :
    ‖Matrix.det (fun i j => (a i*b j)^2+(1/2 : ℂ)*(a i*b j)+E i j :
        Matrix (Fin 3) (Fin 3) ℂ)‖ <
      (5/2 : ℝ)*(‖a 2‖*‖b 2‖)^2*(‖a 1‖*‖b 1‖) := by
  let M : ℝ := ‖a 2‖*‖b 2‖
  let V : ℝ := ‖a 1‖*‖b 1‖
  have hM : 0 ≤ M := mul_nonneg (norm_nonneg _) (norm_nonneg _)
  have hV : 0 ≤ V := mul_nonneg (norm_nonneg _) (norm_nonneg _)
  have hentry (i j : Fin 3) : ‖a i*b j‖ ≤ M := by
    rw [norm_mul]
    exact mul_le_mul (ha (by omega : i ≤ 2)) (hb (by omega : j ≤ 2))
      (norm_nonneg _) (norm_nonneg _)
  have hpair (i j k l : Fin 3) (hij : i ≠ j) (hkl : k ≠ l) :
      ‖(a i*b k)^2*(a j*b l)‖ ≤ M^2*V := by
    rw [norm_mul, norm_pow, norm_mul, norm_mul]
    calc
      (‖a i‖*‖b k‖)^2*(‖a j‖*‖b l‖) =
          (‖a i‖^2*‖a j‖)*(‖b k‖^2*‖b l‖) := by ring
      _ ≤ (‖a 2‖^2*‖a 1‖)*(‖b 2‖^2*‖b 1‖) :=
        mul_le_mul
          (crossBlock_ordered_cubic_le _ (fun _ => norm_nonneg _) ha i j hij)
          (crossBlock_ordered_cubic_le _ (fun _ => norm_nonneg _) hb k l hkl)
          (by positivity) (by positivity)
      _ = M^2*V := by dsimp [M, V]; ring
  have hup := crossBlock_quadratic_linear_error_det_upper a b E M (M^2*V)
    (2/15) hM (mul_nonneg (sq_nonneg _) hV) (by norm_num) hentry hpair hE
  have h9M : 9 ≤ M := hW2
  have h9V : 9 ≤ V := hW1
  have hprod : 9*M^2 ≤ M^2*V := by
    nlinarith only [mul_nonneg (sq_nonneg M) (sub_nonneg.mpr h9V)]
  have hMlow : 81 ≤ M^2 := by nlinarith only [h9M, sq_nonneg (M-9)]
  have hMlin : 9*M ≤ M^2 := by
    nlinarith only [mul_nonneg hM (sub_nonneg.mpr h9M)]
  have hnumeric :
      18*(M^2*V)*(2/15)+18*M^2*(2/15)^2+9*M*(2/15)^2+6*(2/15)^3 <
      (5/2 : ℝ)*M^2*V := by
    nlinarith only [hprod, hMlow, hMlin]
  exact hup.trans_lt hnumeric

/-- A selected signed root has an absolutely bounded second scaled error.
This is a finite algebraic consequence of the existing root perturbation
lemma, with no analytic square-root branch. -/
theorem signed_entry_crossBlock_scaled_error
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a b r : R) (u v : ℂ)
    (hu : u^2 = f a) (hv : v^2 = f b) (hr : r^2 = a*b+1)
    (hgood : SignedEntryGood f a b u v r) :
    ‖(f a*f b)*(u*f r*v)-(f a*f b)^2-(1/2 : ℂ)*(f a*f b)‖ <
      (2/15 : ℝ) := by
  have hrC : (f r)^2 = f a*f b+1 := by
    simpa only [map_pow, map_mul, map_add, map_one] using congrArg f hr
  have hsq : (u*f r*v)^2 = (f a*f b)*(f a*f b+1) := by
    rw [mul_pow, mul_pow, hu, hv, hrC]
    ring
  have hid : (f a*f b)*(u*f r*v)-(f a*f b)^2-(1/2 : ℂ)*(f a*f b) =
      -(u*f r*v-f a*f b)^2/2 := by
    linear_combination (1/2 : ℂ)*hsq
  have hnear : ‖u*f r*v-f a*f b‖ < (16/31 : ℝ) := hgood.1
  have hsquare : ‖u*f r*v-f a*f b‖^2 < (16/31 : ℝ)^2 := by
    nlinarith [norm_nonneg (u*f r*v-f a*f b)]
  rw [hid, norm_div, norm_neg, norm_pow, Complex.norm_two]
  nlinarith only [hsquare]

/-- The final real arithmetic of the cross-block argument, in a form that
does not use square roots or division by a possibly zero determinant. -/
theorem crossBlock_growth_of_scaled_determinant
    (W0 W1 W2 d : ℝ) (hW0 : 9 ≤ W0) (hW1 : 9 ≤ W1) (hW2 : 9 ≤ W2)
    (hd : 0 ≤ d) (hlower : (W0*W1*W2)^3 ≤ d^2)
    (hupper : d < (5/2 : ℝ)*W2^2*W1) :
    W0^3*W1/7 < W2 := by
  have hW1p : 0 < W1 := by linarith
  have hW2p : 0 < W2 := by linarith
  have hupperp : 0 < (5/2 : ℝ)*W2^2*W1 := by positivity
  have hsquare : d^2 < ((5/2 : ℝ)*W2^2*W1)^2 := by
    nlinarith only [mul_pos (sub_pos.mpr hupper) (add_pos_of_pos_of_nonneg hupperp hd)]
  have hmul : (W0^3*W1)*(W1^2*W2^3) <
      ((25/4 : ℝ)*W2)*(W1^2*W2^3) := by
    nlinarith only [hlower, hsquare]
  have hcancel : W0^3*W1 < (25/4 : ℝ)*W2 := by
    by_contra hbad
    have hnonneg := mul_nonneg (sub_nonneg.mpr (le_of_not_gt hbad))
      (by positivity : 0 ≤ W1^2*W2^3)
    nlinarith only [hmul, hnonneg]
  nlinarith only [hcancel, hW2p]

end D1Bound5
