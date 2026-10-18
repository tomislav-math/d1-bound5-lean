import D1Bound5.FiniteN3FixedHeight
import D1Bound5.FiniteRationalCoefficientNorm

open scoped NumberField

namespace D1Bound5
open QuadInt

/-- Exact coefficient norm identities suffice for height transfer; no
identification of the ambient field with a coordinate ring is needed. -/
theorem finiteN3_fixed_height_of_norm_sq {tau nu : ℤ}
    (a b : QuadInt tau nu) (M : ℚ)
    (w : Fin 3 → Fin 2 → Fin 4 → ℚ) (hbound : FiniteN3FixedBound a b M w)
    (X Y Z : ℂ) (hBsq : ‖Y‖^2 = (b.norm : ℝ))
    (hnorm : ∀ i j ell, ‖finiteN3FixedPolynomial X Y i j ell‖^2 =
      ((finiteN3FixedPolynomial a b i j ell).norm : ℝ))
    (hy0 : Y ≠ 0) (hC : 1000 ≤ ‖Z‖) (hCB : 200*‖Y‖ ≤ ‖Z‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteN3Left X Y Z i‖+‖finiteN3Right X Y Z i‖) <
      (M : ℝ)*‖Y‖^7*‖Z‖^3 := by
  let B := ‖Y‖
  let C := ‖Z‖
  have hB : 0 < B := norm_pos_iff.mpr hy0
  have hC0 : 0 < C := by dsimp [C]; linarith only [hC]
  obtain ⟨hw,hsq,hrow⟩ := hbound
  have hcoef (j : Fin 2) (ell : Fin 4) :
      ‖finiteN3FixedPolynomial X Y i j ell‖*C^(ell : ℕ) ≤
        (w i j ell : ℝ)*B^7*C^3 := by
    have hn := hnorm i j ell
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
      exact_mod_cast hrow i
    simpa only [Fin.sum_univ_two] using hh
  have hfirst := mul_le_mul_of_nonneg_left hsum (by norm_num : (0 : ℝ) ≤ 101/100)
  have hlast := mul_lt_mul_of_pos_right hheight (by positivity : 0 < B^7*C^3)
  nlinarith only [hfirst,hlast]

/-- Signed integer anchors have the certified coefficient norms in every
number field. Conjugation fixes the integer anchors automatically. -/
theorem finiteN3FixedPolynomial_rational_norm_sq
    {K : Type*} [Field K] [NumberField K] (phi : K →+* ℂ)
    (tau nu : ℤ) (X Y : ℤ) (sgn : Bool) (x y : 𝓞 K)
    (hx : x = if sgn then -(X : 𝓞 K) else (X : 𝓞 K))
    (hy : y = if sgn then -(Y : 𝓞 K) else (Y : 𝓞 K))
    (i : Fin 3) (j : Fin 2) (ell : Fin 4) :
    ‖finiteN3FixedPolynomial (phi (x : K)) (phi (y : K)) i j ell‖^2 =
      ((finiteN3FixedPolynomial (X : QuadInt tau nu) (Y : QuadInt tau nu) i j ell).norm : ℝ) := by
  fin_cases ell
  all_goals
    simp only [finiteN3FixedPolynomial, Matrix.cons_val_zero, Matrix.cons_val_succ]
    exact full_ring_finiteFixedHomogeneous_rational_norm_sq phi tau nu _ _ X Y sgn x y hx hy

end D1Bound5
