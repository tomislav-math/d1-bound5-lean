import D1Bound5.OneSmallN2FixedArithmetic
import D1Bound5.CoherentFixedCutoffGap

open Finset
open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Homogeneous coefficient evaluation commutes with ring maps. -/
theorem finiteHomogeneousTwo_map {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (n : ℕ) (v : Fin (n+1) → ℤ) (x y : R) :
    f (finiteHomogeneousTwo n v x y) = finiteHomogeneousTwo n v (f x) (f y) := by
  simp [finiteHomogeneousTwo]

/-- Simultaneous negation changes a homogeneous polynomial only by its
degree sign, so the evaluated coefficient norm is preserved. -/
theorem finiteHomogeneousTwo_neg {R : Type*} [CommRing R]
    (n : ℕ) (v : Fin (n+1) → ℤ) (x y : R) :
    finiteHomogeneousTwo n v (-x) (-y) = (-1)^n*finiteHomogeneousTwo n v x y := by
  unfold finiteHomogeneousTwo
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _
  have hj : (j : ℕ) ≤ n := by omega
  have hsum : (j : ℕ)+(n-(j : ℕ)) = n := by omega
  simp only [neg_pow]
  calc
    _ = ((-1 : R)^(j : ℕ)*(-1)^(n-(j : ℕ)))*
        ((v j : R)*x^(j : ℕ)*y^(n-(j : ℕ))) := by ring
    _ = _ := by rw [←pow_add,hsum]

theorem finiteHomogeneousTwo_star {tau nu : ℤ}
    (n : ℕ) (v : Fin (n+1) → ℤ) (x y : QuadInt tau nu) :
    finiteHomogeneousTwo n v (star x) (star y) =
      star (finiteHomogeneousTwo n v x y) := by
  simp [finiteHomogeneousTwo,mul_comm,mul_left_comm,mul_assoc]

theorem finiteN2FixedPolynomial_map {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (x y : R) (i : Fin 3) (j : Fin 2) (ell : Fin 3) :
    f (finiteN2FixedPolynomial x y i j ell) =
      finiteN2FixedPolynomial (f x) (f y) i j ell := by
  fin_cases ell <;> simp [finiteN2FixedPolynomial,finiteHomogeneousTwo_map]

/-- Evaluation and coefficient norms are invariant under the exact
simultaneous sign/conjugation symmetries used by the finite pair table. -/
theorem finiteN2FixedPolynomial_symmetry_norm {tau nu : ℤ}
    (sgn conj : Bool) (x y : QuadInt tau nu) (i : Fin 3) (j : Fin 2) (ell : Fin 3) :
    (finiteN2FixedPolynomial (smallExtensionSymmetry sgn conj x)
      (smallExtensionSymmetry sgn conj y) i j ell).norm =
      (finiteN2FixedPolynomial x y i j ell).norm := by
  cases sgn <;> cases conj <;> fin_cases ell
  all_goals
    simp [smallExtensionSymmetry,finiteN2FixedPolynomial,finiteHomogeneousTwo_neg,
      finiteHomogeneousTwo_star,QuadraticAlgebra.norm_star,QuadraticAlgebra.norm_neg]

/-- The exact field norm of each evaluated coefficient is its squared
complex modulus, including half-integral full rings and all four
allowed normalization symmetries. -/
theorem finiteN2FixedPolynomial_norm_sq
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (phi : K →+* ℂ) {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K)
    (sgn conj : Bool) (x y : 𝓞 K) (i : Fin 3) (j : Fin 2) (ell : Fin 3) :
    ‖finiteN2FixedPolynomial (phi (x : K)) (phi (y : K)) i j ell‖^2 =
      ((finiteN2FixedPolynomial
        (smallExtensionSymmetry sgn conj (e.symm x))
        (smallExtensionSymmetry sgn conj (e.symm y)) i j ell).norm : ℝ) := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have h := norm_sq_full_ring_equiv e phi
    (finiteN2FixedPolynomial (e.symm x) (e.symm y) i j ell)
  have he : e (finiteN2FixedPolynomial (e.symm x) (e.symm y) i j ell) =
      finiteN2FixedPolynomial x y i j ell := by
    simpa only [RingEquiv.coe_toRingHom,RingEquiv.apply_symm_apply] using
      finiteN2FixedPolynomial_map e.toRingHom (e.symm x) (e.symm y) i j ell
  have hf := finiteN2FixedPolynomial_map f x y i j ell
  have hnorm : ‖finiteN2FixedPolynomial (f x) (f y) i j ell‖^2 =
      ((finiteN2FixedPolynomial (e.symm x) (e.symm y) i j ell).norm : ℝ) := by
    rw [←hf]
    simpa only [he] using h
  rw [finiteN2FixedPolynomial_symmetry_norm]
  exact hnorm

/-- A square certificate at radius1000 or radius200B bounds the actual
coefficient for every larger terminal modulus. -/
theorem finiteN2FixedPolynomial_scaled_le
    (B C W X : ℝ) (ell : Fin 3) (hB : 0 < B) (hC : 1000 ≤ C)
    (hCB : 200*B ≤ C) (hW : 0 ≤ W) (hX : 0 ≤ X)
    (hsq : X^2 ≤ if B^2 ≤ 25 then W^2*(B^2)^4*1000^(4-2*(ell : ℕ))
      else W^2*(B^2)^(6-(ell : ℕ))*200^(4-2*(ell : ℕ))) :
    X*C^(ell : ℕ) ≤ W*B^4*C^2 := by
  have hC0 : 0 < C := by linarith only [hC]
  have hcoeff : X ≤ W*B^4*C^(2-(ell : ℕ)) := by
    apply (sq_le_sq₀ hX (by positivity)).mp
    split_ifs at hsq with hcase
    · have hp : (1000 : ℝ)^(4-2*(ell : ℕ)) ≤ C^(4-2*(ell : ℕ)) := by gcongr
      have hh := hsq.trans (mul_le_mul_of_nonneg_left hp (by positivity : 0 ≤ W^2*(B^2)^4))
      fin_cases ell <;> norm_num at hh ⊢
      all_goals nlinarith only [hh]
    · have hp : (200*B)^(4-2*(ell : ℕ)) ≤ C^(4-2*(ell : ℕ)) := by gcongr
      have hh := mul_le_mul_of_nonneg_left hp (by positivity : 0 ≤ W^2*B^8)
      fin_cases ell <;> norm_num at hsq hh ⊢
      all_goals nlinarith only [hsq,hh]
  have hh := mul_le_mul_of_nonneg_right hcoeff (pow_nonneg hC0.le (ell : ℕ))
  have he : (2-(ell : ℕ))+(ell : ℕ) = 2 := by omega
  simpa only [mul_assoc,←pow_add,he] using hh

/-- The kernel-checked fixed-pair coefficients give the actual strict
N2 height with the printed M2, with cancellation preserved separately
at every degree of the terminal parameter. -/
theorem finiteN2_fixed_height
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (phi : K →+* ℂ) (r : OneSmallCutoffRow) (hr : r ∈ oneSmallCutoffRows)
    (e : QuadInt r.triple.tau r.triple.nu ≃+* 𝓞 K)
    (sgn conj : Bool) (x y c : 𝓞 K)
    (hx : smallExtensionSymmetry sgn conj (e.symm x) = r.triple.anchorA)
    (hy : smallExtensionSymmetry sgn conj (e.symm y) = r.triple.anchorB)
    (hy0 : phi (y : K) ≠ 0) (hC : 1000 ≤ ‖phi (c : K)‖)
    (hCB : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteN2Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
      ‖finiteN2Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
      (r.M2 : ℝ)*‖phi (y : K)‖^4*‖phi (c : K)‖^2 := by
  let X := phi (x : K)
  let Y := phi (y : K)
  let Z := phi (c : K)
  let B := ‖Y‖
  let C := ‖Z‖
  have hB : 0 < B := norm_pos_iff.mpr hy0
  have hC0 : 0 < C := by change 0 < ‖phi (c : K)‖; linarith only [hC]
  have hBsq : B^2 = (r.b0 : ℝ) := by
    have hn : B^2 = ((smallExtensionSymmetry sgn conj (e.symm y)).norm : ℝ) := by
      simpa only [smallExtensionSymmetry_norm,RingEquiv.apply_symm_apply] using
        norm_sq_full_ring_equiv e phi (e.symm y)
    rw [hy] at hn
    simpa [OneSmallCutoffRow.b0] using hn
  obtain ⟨w,hw,hsq,hrow⟩ := oneSmallCutoffRows_finiteN2FixedBound r hr
  have hcoef (j : Fin 2) (ell : Fin 3) :
      ‖finiteN2FixedPolynomial X Y i j ell‖*C^(ell : ℕ) ≤
        (w i j ell : ℝ)*B^4*C^2 := by
    have hn := finiteN2FixedPolynomial_norm_sq phi e sgn conj x y i j ell
    rw [hx,hy] at hn
    have hb : ‖finiteN2FixedPolynomial X Y i j ell‖^2 ≤
        if B^2 ≤ 25 then (w i j ell : ℝ)^2*(B^2)^4*1000^(4-2*(ell : ℕ))
        else (w i j ell : ℝ)^2*(B^2)^(6-(ell : ℕ))*200^(4-2*(ell : ℕ)) := by
      rw [hBsq,hn]
      split_ifs with hcase
      · have hc : r.b0 ≤ 25 := by exact_mod_cast hcase
        have h := hsq i j ell
        rw [if_pos hc] at h
        exact_mod_cast h
      · have hc : ¬ r.b0 ≤ 25 := by exact_mod_cast hcase
        have h := hsq i j ell
        rw [if_neg hc] at h
        exact_mod_cast h
    exact finiteN2FixedPolynomial_scaled_le B C (w i j ell : ℝ)
      ‖finiteN2FixedPolynomial X Y i j ell‖ ell hB hC hCB
      (by exact_mod_cast hw i j ell) (norm_nonneg _) hb
  have hcolumn (j : Fin 2) :
      ‖![finiteN2Left X Y Z i,finiteN2Right X Y Z i] j‖ ≤
        ((w i j 0 : ℝ)+(w i j 1 : ℝ)+(w i j 2 : ℝ))*B^4*C^2 := by
    rw [finiteN2_root_coeff_decomposition]
    have hh := finite_norm_quadratic_le
      (finiteHomogeneousTwo 2 (finiteN2Coeff0 i j) X Y)
      (finiteHomogeneousTwo 3 (finiteN2Coeff1 i j) X Y)
      (finiteHomogeneousTwo 4 (finiteN2Coeff2 i j) X Y) Z
    have h0 := hcoef j 0
    have h1 := hcoef j 1
    have h2 := hcoef j 2
    norm_num [finiteN2FixedPolynomial] at h0 h1 h2
    change ‖finiteHomogeneousTwo 2 (finiteN2Coeff0 i j) X Y+
      finiteHomogeneousTwo 3 (finiteN2Coeff1 i j) X Y*Z+
      finiteHomogeneousTwo 4 (finiteN2Coeff2 i j) X Y*Z^2‖ ≤
      ‖finiteHomogeneousTwo 2 (finiteN2Coeff0 i j) X Y‖+
      ‖finiteHomogeneousTwo 3 (finiteN2Coeff1 i j) X Y‖*C+
      ‖finiteHomogeneousTwo 4 (finiteN2Coeff2 i j) X Y‖*C^2 at hh
    nlinarith only [hh,h0,h1,h2]
  have hsum := add_le_add (hcolumn 0) (hcolumn 1)
  change ‖finiteN2Left X Y Z i‖+‖finiteN2Right X Y Z i‖ ≤ _ at hsum
  have hheight : (101/100 : ℝ)*
      ((w i 0 0 : ℝ)+(w i 0 1 : ℝ)+(w i 0 2 : ℝ)+
        ((w i 1 0 : ℝ)+(w i 1 1 : ℝ)+(w i 1 2 : ℝ))) < (r.M2 : ℝ) := by
    have hh : (101/100 : ℝ)*(∑ j, ∑ ell, (w i j ell : ℝ)) < (r.M2 : ℝ) := by
      exact_mod_cast hrow i
    simpa [Fin.sum_univ_succ,add_assoc] using hh
  have hfirst := mul_le_mul_of_nonneg_left hsum (by norm_num : (0 : ℝ) ≤ 101/100)
  have hlast := mul_lt_mul_of_pos_right hheight (by positivity : 0 < B^4*C^2)
  nlinarith only [hfirst,hlast]

end D1Bound5

#print axioms D1Bound5.finiteN2FixedPolynomial_norm_sq
#print axioms D1Bound5.finiteN2_fixed_height
