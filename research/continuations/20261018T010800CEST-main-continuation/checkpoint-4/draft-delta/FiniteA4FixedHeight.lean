import D1Bound5.FiniteA4Coefficients
import D1Bound5.FiniteFixedCoefficientNorm

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- An exact evaluated-coefficient certificate for A4. Coefficients already
include the integer row divisor g; no additional normalization is implicit. -/
def FiniteA4FixedBound {tau nu : ℤ} (a b : QuadInt tau nu) (M : ℚ)
    (w : Fin 3 → Fin 2 → Fin 5 → ℚ) : Prop :=
  (∀ i j ell, 0 ≤ w i j ell) ∧
  (∀ i j ell,
    ((finiteA4RootCoeff a b i j ell).norm : ℚ) ≤
      if b.norm ≤ 25 then
        (w i j ell)^2*(b.norm : ℚ)^9*1000^(8-2*(ell : ℕ))
      else (w i j ell)^2*(b.norm : ℚ)^(13-(ell : ℕ))*200^(8-2*(ell : ℕ))) ∧
  (∀ i, (101/100 : ℚ)*(∑ j, ∑ ell, w i j ell) < M)

instance {tau nu : ℤ} (a b : QuadInt tau nu) (M : ℚ)
    (w : Fin 3 → Fin 2 → Fin 5 → ℚ) :
    Decidable (FiniteA4FixedBound a b M w) := by
  unfold FiniteA4FixedBound
  infer_instance

theorem finiteA4RootCoeff_map {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (x y : R) (i : Fin 3) (j : Fin 2) (ell : Fin 5) :
    f (finiteA4RootCoeff x y i j ell) = finiteA4RootCoeff (f x) (f y) i j ell := by
  fin_cases ell <;> simp [finiteA4RootCoeff,finiteFixedHomogeneous_map]

theorem finiteA4RootCoeff_symmetry_norm {tau nu : ℤ}
    (sgn conj : Bool) (x y : QuadInt tau nu) (i : Fin 3) (j : Fin 2) (ell : Fin 5) :
    (finiteA4RootCoeff (smallExtensionSymmetry sgn conj x)
      (smallExtensionSymmetry sgn conj y) i j ell).norm =
      (finiteA4RootCoeff x y i j ell).norm := by
  cases sgn <;> cases conj <;> fin_cases ell
  all_goals
    simp [smallExtensionSymmetry,finiteA4RootCoeff,finiteFixedHomogeneous_neg,
      finiteFixedHomogeneous_star,QuadraticAlgebra.norm_star,QuadraticAlgebra.norm_neg]

theorem finiteA4RootCoeff_norm_sq
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (phi : K →+* ℂ) {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K)
    (sgn conj : Bool) (x y : 𝓞 K) (i : Fin 3) (j : Fin 2) (ell : Fin 5) :
    ‖finiteA4RootCoeff (phi (x : K)) (phi (y : K)) i j ell‖^2 =
      ((finiteA4RootCoeff
        (smallExtensionSymmetry sgn conj (e.symm x))
        (smallExtensionSymmetry sgn conj (e.symm y)) i j ell).norm : ℝ) := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have h := norm_sq_full_ring_equiv e phi
    (finiteA4RootCoeff (e.symm x) (e.symm y) i j ell)
  have he : e (finiteA4RootCoeff (e.symm x) (e.symm y) i j ell) =
      finiteA4RootCoeff x y i j ell := by
    simpa only [RingEquiv.coe_toRingHom,RingEquiv.apply_symm_apply] using
      finiteA4RootCoeff_map e.toRingHom (e.symm x) (e.symm y) i j ell
  have hf := finiteA4RootCoeff_map f x y i j ell
  have hnorm : ‖finiteA4RootCoeff (f x) (f y) i j ell‖^2 =
      ((finiteA4RootCoeff (e.symm x) (e.symm y) i j ell).norm : ℝ) := by
    rw [←hf]
    simpa only [he] using h
  rw [finiteA4RootCoeff_symmetry_norm]
  exact hnorm

theorem finiteA4RootCoeff_scaled_le
    (B C W X : ℝ) (ell : Fin 5) (hB : 0 < B) (hC : 1000 ≤ C)
    (hCB : 200*B ≤ C) (hW : 0 ≤ W) (hX : 0 ≤ X)
    (hsq : X^2 ≤ if B^2 ≤ 25 then W^2*(B^2)^9*1000^(8-2*(ell : ℕ))
      else W^2*(B^2)^(13-(ell : ℕ))*200^(8-2*(ell : ℕ))) :
    X*C^(ell : ℕ) ≤ W*B^9*C^4 := by
  have hC0 : 0 < C := by linarith only [hC]
  have hcoeff : X ≤ W*B^9*C^(4-(ell : ℕ)) := by
    apply (sq_le_sq₀ hX (by positivity)).mp
    split_ifs at hsq with hcase
    · have hp : (1000 : ℝ)^(8-2*(ell : ℕ)) ≤ C^(8-2*(ell : ℕ)) := by gcongr
      have hh := hsq.trans (mul_le_mul_of_nonneg_left hp (by positivity : 0 ≤ W^2*(B^2)^9))
      fin_cases ell <;> norm_num at hh ⊢
      all_goals nlinarith only [hh]
    · have hp : (200*B)^(8-2*(ell : ℕ)) ≤ C^(8-2*(ell : ℕ)) := by gcongr
      have hh := mul_le_mul_of_nonneg_left hp (by positivity : 0 ≤ W^2*B^18)
      fin_cases ell <;> norm_num at hsq hh ⊢
      all_goals nlinarith only [hsq,hh]
  have hh := mul_le_mul_of_nonneg_right hcoeff (pow_nonneg hC0.le (ell : ℕ))
  have he : (4-(ell : ℕ))+(ell : ℕ) = 4 := by omega
  simpa only [mul_assoc,←pow_add,he] using hh

/-- Exact finite coefficient certificates transfer to every embedding of the
full ring and every simultaneous sign/conjugation normalization. -/
theorem finiteA4_fixed_height
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (phi : K →+* ℂ) {tau nu : ℤ} (a b : QuadInt tau nu) (M : ℚ)
    (w : Fin 3 → Fin 2 → Fin 5 → ℚ) (hbound : FiniteA4FixedBound a b M w)
    (e : QuadInt tau nu ≃+* 𝓞 K) (sgn conj : Bool) (x y c : 𝓞 K)
    (hx : smallExtensionSymmetry sgn conj (e.symm x) = a)
    (hy : smallExtensionSymmetry sgn conj (e.symm y) = b)
    (hy0 : phi (y : K) ≠ 0) (hC : 1000 ≤ ‖phi (c : K)‖)
    (hCB : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteA4Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
      ‖finiteA4Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
      (M : ℝ)*‖phi (y : K)‖^9*‖phi (c : K)‖^4 := by
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
  have hcoef (j : Fin 2) (ell : Fin 5) :
      ‖finiteA4RootCoeff X Y i j ell‖*C^(ell : ℕ) ≤
        (w i j ell : ℝ)*B^9*C^4 := by
    have hn := finiteA4RootCoeff_norm_sq phi e sgn conj x y i j ell
    rw [hx,hy] at hn
    have hb : ‖finiteA4RootCoeff X Y i j ell‖^2 ≤
        if B^2 ≤ 25 then (w i j ell : ℝ)^2*(B^2)^9*1000^(8-2*(ell : ℕ))
        else (w i j ell : ℝ)^2*(B^2)^(13-(ell : ℕ))*200^(8-2*(ell : ℕ)) := by
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
    exact finiteA4RootCoeff_scaled_le B C (w i j ell : ℝ)
      ‖finiteA4RootCoeff X Y i j ell‖ ell hB hC hCB
      (by exact_mod_cast hw i j ell) (norm_nonneg _) hb
  have hcolumn (j : Fin 2) :
      ‖![finiteA4Left X Y Z i,finiteA4Right X Y Z i] j‖ ≤
        (∑ ell, (w i j ell : ℝ))*B^9*C^4 := by
    rw [finiteA4_root_coeff_decomposition]
    apply (finitePolynomial_norm_le 4 (finiteA4RootCoeff X Y i j) Z).trans
    calc
      _ ≤ ∑ ell, (w i j ell : ℝ)*B^9*C^4 := Finset.sum_le_sum (fun ell _ => hcoef j ell)
      _ = _ := by rw [Finset.sum_mul,Finset.sum_mul]
  have hsum := add_le_add (hcolumn 0) (hcolumn 1)
  change ‖finiteA4Left X Y Z i‖+‖finiteA4Right X Y Z i‖ ≤ _ at hsum
  have hheight : (101/100 : ℝ)*((∑ ell, (w i 0 ell : ℝ))+
      (∑ ell, (w i 1 ell : ℝ))) < (M : ℝ) := by
    have hh : (101/100 : ℝ)*(∑ j, ∑ ell, (w i j ell : ℝ)) < (M : ℝ) := by
      exact_mod_cast hrow i
    simpa only [Fin.sum_univ_two] using hh
  have hfirst := mul_le_mul_of_nonneg_left hsum (by norm_num : (0 : ℝ) ≤ 101/100)
  have hlast := mul_lt_mul_of_pos_right hheight (by positivity : 0 < B^9*C^4)
  nlinarith only [hfirst,hlast]

end D1Bound5
