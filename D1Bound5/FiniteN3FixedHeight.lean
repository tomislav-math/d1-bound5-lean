import D1Bound5.FiniteN3Height
import D1Bound5.FiniteFixedCoefficientNorm

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- The exact N3 coefficients after division by the integral row factor. -/
def finiteN3FixedPolynomial {R : Type*} [CommRing R] (x y : R)
    (i : Fin 3) (j : Fin 2) : Fin 4 → R :=
  ![finiteHomogeneousTwo 4 (finiteN3Coeff0 i j) x y,
    finiteHomogeneousTwo 5 (finiteN3Coeff1 i j) x y,
    finiteHomogeneousTwo 6 (finiteN3Coeff2 i j) x y,
    finiteHomogeneousTwo 7 (finiteN3Coeff3 i j) x y]

theorem finiteN3_root_coeff_sum {R : Type*} [CommRing R]
    (x y c : R) (i : Fin 3) (j : Fin 2) :
    ![finiteN3Left x y c i,finiteN3Right x y c i] j =
      ∑ ell : Fin 4, finiteN3FixedPolynomial x y i j ell*c^(ell : ℕ) := by
  rw [finiteN3_root_coeff_decomposition]
  simp [finiteN3FixedPolynomial,Fin.sum_univ_succ]
  <;> ring


/-- An exact evaluated-coefficient certificate for N3. Coefficients already
include the integer row divisor g; no additional normalization is implicit. -/
def FiniteN3FixedBound {tau nu : ℤ} (a b : QuadInt tau nu) (M : ℚ)
    (w : Fin 3 → Fin 2 → Fin 4 → ℚ) : Prop :=
  (∀ i j ell, 0 ≤ w i j ell) ∧
  (∀ i j ell,
    ((finiteN3FixedPolynomial a b i j ell).norm : ℚ) ≤
      if b.norm ≤ 25 then
        (w i j ell)^2*(b.norm : ℚ)^7*1000^(6-2*(ell : ℕ))
      else (w i j ell)^2*(b.norm : ℚ)^(10-(ell : ℕ))*200^(6-2*(ell : ℕ))) ∧
  (∀ i, (101/100 : ℚ)*(∑ j, ∑ ell, w i j ell) < M)

instance {tau nu : ℤ} (a b : QuadInt tau nu) (M : ℚ)
    (w : Fin 3 → Fin 2 → Fin 4 → ℚ) :
    Decidable (FiniteN3FixedBound a b M w) := by
  unfold FiniteN3FixedBound
  infer_instance

theorem finiteN3FixedPolynomial_map {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (x y : R) (i : Fin 3) (j : Fin 2) (ell : Fin 4) :
    f (finiteN3FixedPolynomial x y i j ell) = finiteN3FixedPolynomial (f x) (f y) i j ell := by
  fin_cases ell <;> simp [finiteN3FixedPolynomial,finiteFixedHomogeneous_map]

theorem finiteN3FixedPolynomial_symmetry_norm {tau nu : ℤ}
    (sgn conj : Bool) (x y : QuadInt tau nu) (i : Fin 3) (j : Fin 2) (ell : Fin 4) :
    (finiteN3FixedPolynomial (smallExtensionSymmetry sgn conj x)
      (smallExtensionSymmetry sgn conj y) i j ell).norm =
      (finiteN3FixedPolynomial x y i j ell).norm := by
  cases sgn <;> cases conj <;> fin_cases ell
  all_goals
    simp [smallExtensionSymmetry,finiteN3FixedPolynomial,finiteFixedHomogeneous_neg,
      finiteFixedHomogeneous_star,QuadraticAlgebra.norm_star,QuadraticAlgebra.norm_neg]

theorem finiteN3FixedPolynomial_norm_sq
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (phi : K →+* ℂ) {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K)
    (sgn conj : Bool) (x y : 𝓞 K) (i : Fin 3) (j : Fin 2) (ell : Fin 4) :
    ‖finiteN3FixedPolynomial (phi (x : K)) (phi (y : K)) i j ell‖^2 =
      ((finiteN3FixedPolynomial
        (smallExtensionSymmetry sgn conj (e.symm x))
        (smallExtensionSymmetry sgn conj (e.symm y)) i j ell).norm : ℝ) := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have h := norm_sq_full_ring_equiv e phi
    (finiteN3FixedPolynomial (e.symm x) (e.symm y) i j ell)
  have he : e (finiteN3FixedPolynomial (e.symm x) (e.symm y) i j ell) =
      finiteN3FixedPolynomial x y i j ell := by
    have he' := finiteN3FixedPolynomial_map e.toRingHom (e.symm x) (e.symm y) i j ell
    change e (finiteN3FixedPolynomial (e.symm x) (e.symm y) i j ell) =
      finiteN3FixedPolynomial (e (e.symm x)) (e (e.symm y)) i j ell at he'
    simpa only [RingEquiv.apply_symm_apply] using he'
  have hf := finiteN3FixedPolynomial_map f x y i j ell
  have hnorm : ‖finiteN3FixedPolynomial (f x) (f y) i j ell‖^2 =
      ((finiteN3FixedPolynomial (e.symm x) (e.symm y) i j ell).norm : ℝ) := by
    rw [←hf]
    change ‖phi ((finiteN3FixedPolynomial x y i j ell : 𝓞 K) : K)‖^2 =
      ((finiteN3FixedPolynomial (e.symm x) (e.symm y) i j ell).norm : ℝ)
    simpa only [he] using h
  rw [finiteN3FixedPolynomial_symmetry_norm]
  exact hnorm

theorem finiteN3FixedPolynomial_scaled_le
    (B C W X : ℝ) (ell : Fin 4) (hB : 0 < B) (hC : 1000 ≤ C)
    (hCB : 200*B ≤ C) (hW : 0 ≤ W) (hX : 0 ≤ X)
    (hsq : X^2 ≤ if B^2 ≤ 25 then W^2*(B^2)^7*1000^(6-2*(ell : ℕ))
      else W^2*(B^2)^(10-(ell : ℕ))*200^(6-2*(ell : ℕ))) :
    X*C^(ell : ℕ) ≤ W*B^7*C^3 := by
  have hC0 : 0 < C := by linarith only [hC]
  have hcoeff : X ≤ W*B^7*C^(3-(ell : ℕ)) := by
    apply (sq_le_sq₀ hX (by positivity)).mp
    split_ifs at hsq with hcase
    · have hp : (1000 : ℝ)^(6-2*(ell : ℕ)) ≤ C^(6-2*(ell : ℕ)) := by gcongr
      have hh := hsq.trans (mul_le_mul_of_nonneg_left hp (by positivity : 0 ≤ W^2*(B^2)^7))
      fin_cases ell <;> norm_num at hh ⊢
      all_goals nlinarith only [hh]
    · have hp : (200*B)^(6-2*(ell : ℕ)) ≤ C^(6-2*(ell : ℕ)) := by gcongr
      have hh := mul_le_mul_of_nonneg_left hp (by positivity : 0 ≤ W^2*B^14)
      fin_cases ell <;> norm_num at hsq hh ⊢
      all_goals nlinarith only [hsq,hh]
  have hh := mul_le_mul_of_nonneg_right hcoeff (pow_nonneg hC0.le (ell : ℕ))
  have he : (3-(ell : ℕ))+(ell : ℕ) = 3 := by omega
  simpa only [mul_assoc,←pow_add,he] using hh

/-- Exact finite coefficient certificates transfer to every embedding of the
full ring and every simultaneous sign/conjugation normalization. -/
theorem finiteN3_fixed_height
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (phi : K →+* ℂ) {tau nu : ℤ} (a b : QuadInt tau nu) (M : ℚ)
    (w : Fin 3 → Fin 2 → Fin 4 → ℚ) (hbound : FiniteN3FixedBound a b M w)
    (e : QuadInt tau nu ≃+* 𝓞 K) (sgn conj : Bool) (x y c : 𝓞 K)
    (hx : smallExtensionSymmetry sgn conj (e.symm x) = a)
    (hy : smallExtensionSymmetry sgn conj (e.symm y) = b)
    (hy0 : phi (y : K) ≠ 0) (hC : 1000 ≤ ‖phi (c : K)‖)
    (hCB : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteN3Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
      ‖finiteN3Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
      (M : ℝ)*‖phi (y : K)‖^7*‖phi (c : K)‖^3 := by
  let X := phi (x : K)
  let Y := phi (y : K)
  let Z := phi (c : K)
  let B := ‖Y‖
  let C := ‖Z‖
  have hB : 0 < B := norm_pos_iff.mpr hy0
  have hC0 : 0 < C := by change 0 < ‖phi (c : K)‖; linarith only [hC]
  have hBsq : B^2 = (b.norm : ℝ) := by
    have hn : B^2 = ((smallExtensionSymmetry sgn conj (e.symm y)).norm : ℝ) := by
      simpa only [smallExtensionSymmetry_norm,RingEquiv.apply_symm_apply] using
        norm_sq_full_ring_equiv e phi (e.symm y)
    rw [hy] at hn
    exact hn
  obtain ⟨hw,hsq,hrow⟩ := hbound
  have hcoef (j : Fin 2) (ell : Fin 4) :
      ‖finiteN3FixedPolynomial X Y i j ell‖*C^(ell : ℕ) ≤
        (w i j ell : ℝ)*B^7*C^3 := by
    have hn := finiteN3FixedPolynomial_norm_sq phi e sgn conj x y i j ell
    rw [hx,hy] at hn
    have hb : ‖finiteN3FixedPolynomial X Y i j ell‖^2 ≤
        if B^2 ≤ 25 then (w i j ell : ℝ)^2*(B^2)^7*1000^(6-2*(ell : ℕ))
        else (w i j ell : ℝ)^2*(B^2)^(10-(ell : ℕ))*200^(6-2*(ell : ℕ)) := by
      rw [hBsq,hn]
      split_ifs with hcase
      · have hc : b.norm ≤ 25 := by exact_mod_cast hcase
        have h := hsq i j ell
        rw [if_pos hc] at h
        exact_mod_cast h
      · have hc : ¬ b.norm ≤ 25 := by exact_mod_cast hcase
        have h := hsq i j ell
        rw [if_neg hc] at h
        exact_mod_cast h
    exact finiteN3FixedPolynomial_scaled_le B C (w i j ell : ℝ)
      ‖finiteN3FixedPolynomial X Y i j ell‖ ell hB hC hCB
      (by exact_mod_cast hw i j ell) (norm_nonneg _) hb
  have hcolumn (j : Fin 2) :
      ‖![finiteN3Left X Y Z i,finiteN3Right X Y Z i] j‖ ≤
        (∑ ell, (w i j ell : ℝ))*B^7*C^3 := by
    rw [finiteN3_root_coeff_sum]
    apply (finitePolynomial_norm_le 3 (finiteN3FixedPolynomial X Y i j) Z).trans
    calc
      _ ≤ ∑ ell, (w i j ell : ℝ)*B^7*C^3 := Finset.sum_le_sum (fun ell _ => hcoef j ell)
      _ = _ := by rw [Finset.sum_mul,Finset.sum_mul]
  have hsum := add_le_add (hcolumn 0) (hcolumn 1)
  change ‖finiteN3Left X Y Z i‖+‖finiteN3Right X Y Z i‖ ≤ _ at hsum
  have hheight : (101/100 : ℝ)*((∑ ell, (w i 0 ell : ℝ))+
      (∑ ell, (w i 1 ell : ℝ))) < (M : ℝ) := by
    have hh : (101/100 : ℝ)*(∑ j, ∑ ell, (w i j ell : ℝ)) < (M : ℝ) := by
      have hhq := (Rat.cast_lt (K := ℝ)).2 (hrow i)
      push_cast at hhq
      exact hhq
    simpa only [Fin.sum_univ_two] using hh
  have hfirst := mul_le_mul_of_nonneg_left hsum (by norm_num : (0 : ℝ) ≤ 101/100)
  have hlast := mul_lt_mul_of_pos_right hheight (by positivity : 0 < B^7*C^3)
  nlinarith only [hfirst,hlast]

end D1Bound5

#print axioms D1Bound5.finiteN3_fixed_height
