import D1Bound5.FiniteA5FixedHeight
import D1Bound5.FiniteRationalCoefficientNorm

open scoped NumberField

namespace D1Bound5
open QuadInt

/-- Exact coefficient norm identities suffice for height transfer; no
identification of the ambient field with a coordinate ring is needed. -/
theorem finiteA5_fixed_height_of_norm_sq {tau nu : ℤ}
    (a b : QuadInt tau nu) (M : ℚ)
    (w : Fin 3 → Fin 2 → Fin 6 → ℚ) (hbound : FiniteA5FixedBound a b M w)
    (X Y Z : ℂ) (hBsq : ‖Y‖^2 = (b.norm : ℝ))
    (hnorm : ∀ i j ell, ‖finiteA5RootCoeff X Y i j ell‖^2 =
      ((finiteA5RootCoeff a b i j ell).norm : ℝ))
    (hy0 : Y ≠ 0) (hC : 1000 ≤ ‖Z‖) (hCB : 200*‖Y‖ ≤ ‖Z‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteA5Left X Y Z i‖+‖finiteA5Right X Y Z i‖) <
      (M : ℝ)*‖Y‖^12*‖Z‖^5 := by
  let B := ‖Y‖
  let C := ‖Z‖
  have hB : 0 < B := norm_pos_iff.mpr hy0
  have hC0 : 0 < C := by dsimp [C]; linarith only [hC]
  obtain ⟨hw,hsq,hrow⟩ := hbound
  have hcoef (j : Fin 2) (ell : Fin 6) :
      ‖finiteA5RootCoeff X Y i j ell‖*C^(ell : ℕ) ≤
        (w i j ell : ℝ)*B^12*C^5 := by
    have hn := hnorm i j ell
    have hb : ‖finiteA5RootCoeff X Y i j ell‖^2 ≤
        if B^2 ≤ 25 then (w i j ell : ℝ)^2*(B^2)^12*1000^(10-2*(ell : ℕ))
        else (w i j ell : ℝ)^2*(B^2)^(17-(ell : ℕ))*200^(10-2*(ell : ℕ)) := by
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
    exact finiteA5RootCoeff_scaled_le B C (w i j ell : ℝ)
      ‖finiteA5RootCoeff X Y i j ell‖ ell hB hC hCB
      (by exact_mod_cast hw i j ell) (norm_nonneg _) hb
  have hcolumn (j : Fin 2) :
      ‖![finiteA5Left X Y Z i,finiteA5Right X Y Z i] j‖ ≤
        (∑ ell, (w i j ell : ℝ))*B^12*C^5 := by
    rw [finiteA5_root_coeff_decomposition]
    apply (finitePolynomial_norm_le 5 (finiteA5RootCoeff X Y i j) Z).trans
    calc
      _ ≤ ∑ ell, (w i j ell : ℝ)*B^12*C^5 := Finset.sum_le_sum (fun ell _ => hcoef j ell)
      _ = _ := by rw [Finset.sum_mul,Finset.sum_mul]
  have hsum := add_le_add (hcolumn 0) (hcolumn 1)
  change ‖finiteA5Left X Y Z i‖+‖finiteA5Right X Y Z i‖ ≤ _ at hsum
  have hheight : (101/100 : ℝ)*((∑ ell, (w i 0 ell : ℝ))+
      (∑ ell, (w i 1 ell : ℝ))) < (M : ℝ) := by
    have hh : (101/100 : ℝ)*(∑ j, ∑ ell, (w i j ell : ℝ)) < (M : ℝ) := by
      have hhq := (Rat.cast_lt (K := ℝ)).2 (hrow i)
      push_cast at hhq
      exact hhq
    simpa only [Fin.sum_univ_two] using hh
  have hfirst := mul_le_mul_of_nonneg_left hsum (by norm_num : (0 : ℝ) ≤ 101/100)
  have hlast := mul_lt_mul_of_pos_right hheight (by positivity : 0 < B^12*C^5)
  nlinarith only [hfirst,hlast]

/-- Signed integer anchors have the certified coefficient norms in every
number field. Conjugation fixes the integer anchors automatically. -/
theorem finiteA5RootCoeff_rational_norm_sq
    {K : Type*} [Field K] [NumberField K] (phi : K →+* ℂ)
    (tau nu : ℤ) (X Y : ℤ) (sgn : Bool) (x y : 𝓞 K)
    (hx : x = if sgn then -(X : 𝓞 K) else (X : 𝓞 K))
    (hy : y = if sgn then -(Y : 𝓞 K) else (Y : 𝓞 K))
    (i : Fin 3) (j : Fin 2) (ell : Fin 6) :
    ‖finiteA5RootCoeff (phi (x : K)) (phi (y : K)) i j ell‖^2 =
      ((finiteA5RootCoeff (X : QuadInt tau nu) (Y : QuadInt tau nu) i j ell).norm : ℝ) := by
  fin_cases ell
  all_goals
    simp only [finiteA5RootCoeff, Matrix.cons_val_zero, Matrix.cons_val_succ]
    exact full_ring_finiteFixedHomogeneous_rational_norm_sq phi tau nu _ _ X Y sgn x y hx hy

end D1Bound5
