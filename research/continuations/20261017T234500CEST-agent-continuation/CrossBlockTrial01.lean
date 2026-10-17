import D1Bound5.FullRingBridge
import Mathlib.LinearAlgebra.Matrix.ToLinearEquiv
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.FinCases

open scoped BigOperators NumberField
open Module

namespace D1Bound5

/-- A quadratic over an integral domain that vanishes at three distinct
points has all three coefficients zero. This elementary form is convenient
for the cross-block argument. -/
private theorem crossBlock_quadratic_coefficients
    {K : Type*} [CommRing K] [IsDomain K]
    (A B C x y z : K) (hxy : x ≠ y) (hxz : x ≠ z) (hyz : y ≠ z)
    (hx : A*x^2 + B*x + C = 0)
    (hy : A*y^2 + B*y + C = 0)
    (hz : A*z^2 + B*z + C = 0) :
    A = 0 ∧ B = 0 ∧ C = 0 := by
  have hxy' : (x-y)*(A*(x+y)+B) = 0 := by
    linear_combination hx - hy
  have hxz' : (x-z)*(A*(x+z)+B) = 0 := by
    linear_combination hx - hz
  have hxy'' : A*(x+y)+B = 0 :=
    (mul_eq_zero.mp hxy').resolve_left (sub_ne_zero.mpr hxy)
  have hxz'' : A*(x+z)+B = 0 :=
    (mul_eq_zero.mp hxz').resolve_left (sub_ne_zero.mpr hxz)
  have hA' : A*(y-z) = 0 := by
    linear_combination hxy'' - hxz''
  have hA : A = 0 :=
    (mul_eq_zero.mp hA').resolve_right (sub_ne_zero.mpr hyz)
  have hB : B = 0 := by simpa [hA] using hxy''
  have hC : C = 0 := by simpa [hA, hB] using hx
  exact ⟨hA, hB, hC⟩

/-- Any two rows of a root matrix with distinct row parameters are linearly
independent, provided two column parameters are distinct. Zero root entries
are permitted. -/
private theorem crossBlock_two_rows
    {K : Type*} [CommRing K] [IsDomain K]
    (a c : K) (b r s : Fin 3 → K) (hac : a ≠ c)
    (hb : b 0 ≠ b 1)
    (hr : ∀ j, (r j)^2 = a*b j+1)
    (hs : ∀ j, (s j)^2 = c*b j+1)
    (λ μ : K) (hrel : ∀ j, λ*r j+μ*s j = 0) :
    λ = 0 ∧ μ = 0 := by
  have heq (j : Fin 3) :
      (λ^2*a-μ^2*c)*b j+(λ^2-μ^2) = 0 := by
    linear_combination
      (λ*r j-μ*s j) * hrel j - λ^2 * hr j + μ^2 * hs j
  have hprod : (b 0-b 1)*(λ^2*a-μ^2*c) = 0 := by
    linear_combination heq 0 - heq 1
  have hA : λ^2*a-μ^2*c = 0 :=
    (mul_eq_zero.mp hprod).resolve_left (sub_ne_zero.mpr hb)
  have hC : λ^2-μ^2 = 0 := by
    simpa [hA] using heq 0
  have hλprod : λ^2*(a-c) = 0 := by
    linear_combination hA - c*hC
  have hλsq : λ^2 = 0 :=
    (mul_eq_zero.mp hλprod).resolve_right (sub_ne_zero.mpr hac)
  have hλ : λ = 0 := sq_eq_zero_iff.mp hλsq
  have hμsq : μ^2 = 0 := by
    linear_combination hλsq - hC
  exact ⟨hλ, sq_eq_zero_iff.mp hμsq⟩

/-- In a linear relation among three root rows, the product of the first two
coefficients is zero. Squaring the relation twice yields a quadratic in the
column parameter. Its discriminant forces this product to vanish. -/
private theorem crossBlock_relation_product
    {K : Type*} [CommRing K] [IsDomain K] [CharZero K]
    (a b : Fin 3 → K) (R : Matrix (Fin 3) (Fin 3) K)
    (ha : a 0 ≠ a 1) (hb : Function.Injective b)
    (hroot : ∀ i j, (R i j)^2 = a i*b j+1)
    (λ μ ν : K)
    (hrel : ∀ j, λ*R 0 j+μ*R 1 j+ν*R 2 j = 0) :
    λ*μ = 0 := by
  let P : K := ν^2*a 2-λ^2*a 0-μ^2*a 1
  let Q : K := ν^2-λ^2-μ^2
  let L : K := 4*λ^2*μ^2
  have hcross (j : Fin 3) :
      2*λ*μ*R 0 j*R 1 j = P*b j+Q := by
    dsimp [P, Q]
    linear_combination
      (λ*R 0 j+μ*R 1 j-ν*R 2 j) * hrel j -
      λ^2 * hroot 0 j - μ^2 * hroot 1 j + ν^2 * hroot 2 j
  have hsquare (j : Fin 3) :
      (P*b j+Q)^2 = L*(a 0*b j+1)*(a 1*b j+1) := by
    calc
      (P*b j+Q)^2 = (2*λ*μ*R 0 j*R 1 j)^2 := by rw [hcross j]
      _ = L*(R 0 j)^2*(R 1 j)^2 := by dsimp [L]; ring
      _ = L*(a 0*b j+1)*(a 1*b j+1) := by rw [hroot 0 j, hroot 1 j]
  have heval (j : Fin 3) :
      (P^2-L*a 0*a 1)*(b j)^2 +
        (2*P*Q-L*(a 0+a 1))*b j + (Q^2-L) = 0 := by
    linear_combination hsquare j
  obtain ⟨hA, hB, hC⟩ := crossBlock_quadratic_coefficients
    (P^2-L*a 0*a 1) (2*P*Q-L*(a 0+a 1)) (Q^2-L)
    (b 0) (b 1) (b 2)
    (hb.ne (by decide)) (hb.ne (by decide)) (hb.ne (by decide))
    (heval 0) (heval 1) (heval 2)
  have hdisc : L^2*(a 0-a 1)^2 = 0 := by
    linear_combination
      4*Q^2*hA - (2*P*Q+L*(a 0+a 1))*hB + 4*L*a 0*a 1*hC
  by_contra hλμ
  have hλ : λ ≠ 0 := by
    intro h
    apply hλμ
    simp [h]
  have hμ : μ ≠ 0 := by
    intro h
    apply hλμ
    simp [h]
  have hL : L ≠ 0 := by
    dsimp [L]
    exact mul_ne_zero (mul_ne_zero (by norm_num) (pow_ne_zero 2 hλ))
      (pow_ne_zero 2 hμ)
  exact (mul_ne_zero (pow_ne_zero 2 hL)
    (pow_ne_zero 2 (sub_ne_zero.mpr ha))) hdisc

/-- The algebraic nonvanishing assertion in the cross-block lemma.

A three-by-three matrix of arbitrarily signed square roots of `a i*b j+1`
has nonzero determinant whenever the three row parameters and three column
parameters are separately distinct. No nonzero-coordinate or nonzero-root
hypothesis is needed. The proof works in every characteristic-zero integral
domain, in particular in the full ring of integers of a number field. -/
theorem crossBlock_rootMatrix_det_ne_zero
    {K : Type*} [CommRing K] [IsDomain K] [CharZero K]
    (a b : Fin 3 → K) (R : Matrix (Fin 3) (Fin 3) K)
    (ha : Function.Injective a) (hb : Function.Injective b)
    (hroot : ∀ i j, (R i j)^2 = a i*b j+1) :
    R.det ≠ 0 := by
  intro hdet
  obtain ⟨v, hv, hzero⟩ := Matrix.exists_vecMul_eq_zero_iff.mpr hdet
  have hrel (j : Fin 3) :
      v 0*R 0 j+v 1*R 1 j+v 2*R 2 j = 0 := by
    have hj := congrFun hzero j
    simpa [Matrix.vecMul, dotProduct, Fin.sum_univ_succ, add_assoc] using hj
  have hp : v 0*v 1 = 0 := crossBlock_relation_product
    a b R (ha.ne (by decide)) hb hroot (v 0) (v 1) (v 2) hrel
  rcases mul_eq_zero.mp hp with hv0 | hv1
  · obtain ⟨hv1, hv2⟩ := crossBlock_two_rows
      (a 1) (a 2) b (R 1) (R 2)
      (ha.ne (by decide)) (hb.ne (by decide))
      (hroot 1) (hroot 2) (v 1) (v 2)
      (fun j => by simpa [hv0] using hrel j)
    apply hv
    funext i
    fin_cases i <;> simp_all
  · obtain ⟨hv0, hv2⟩ := crossBlock_two_rows
      (a 0) (a 2) b (R 0) (R 2)
      (ha.ne (by decide)) (hb.ne (by decide))
      (hroot 0) (hroot 2) (v 0) (v 2)
      (fun j => by simpa [hv1] using hrel j)
    apply hv
    funext i
    fin_cases i <;> simp_all

/-- The arithmetic lower bound for the cross-block determinant in the full
integer ring of any imaginary quadratic field. This is unconditional on
coordinate bounds and on choices of root signs. -/
theorem full_ring_crossBlock_rootMatrix_one_le_norm
    {K : Type*} [Field K] [NumberField K]
    [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a b : Fin 3 → 𝓞 K) (R : Matrix (Fin 3) (Fin 3) (𝓞 K))
    (ha : Function.Injective a) (hb : Function.Injective b)
    (hroot : ∀ i j, (R i j)^2 = a i*b j+1) :
    1 ≤ ‖phi (R.det : K)‖ := by
  exact one_le_norm_integer hK phi
    (crossBlock_rootMatrix_det_ne_zero a b R ha hb hroot)

end D1Bound5
