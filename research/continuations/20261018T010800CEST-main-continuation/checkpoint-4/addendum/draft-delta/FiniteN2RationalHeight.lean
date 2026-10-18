import D1Bound5.OneSmallN2FixedHeight
import D1Bound5.FiniteRationalCoefficientNorm

open scoped NumberField

namespace D1Bound5
open QuadInt

/-- N2 height transfer from actual squared coefficient norms. -/
theorem finiteN2_fixed_height_of_norm_sq
    (r : OneSmallCutoffRow) (hr : r ∈ oneSmallCutoffRows)
    (X Y Z : ℂ) (hBsq : ‖Y‖^2 = (r.b0 : ℝ))
    (hnorm : ∀ i j ell, ‖finiteN2FixedPolynomial X Y i j ell‖^2 =
      ((finiteN2FixedPolynomial r.triple.anchorA r.triple.anchorB i j ell).norm : ℝ))
    (hy0 : Y ≠ 0) (hC : 1000 ≤ ‖Z‖) (hCB : 200*‖Y‖ ≤ ‖Z‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteN2Left X Y Z i‖+‖finiteN2Right X Y Z i‖) <
      (r.M2 : ℝ)*‖Y‖^4*‖Z‖^2 := by
  let B := ‖Y‖
  let C := ‖Z‖
  have hB : 0 < B := norm_pos_iff.mpr hy0
  have hC0 : 0 < C := by dsimp [C]; linarith only [hC]
  obtain ⟨w,hw,hsq,hrow⟩ := oneSmallCutoffRows_finiteN2FixedBound r hr
  have hcoef (j : Fin 2) (ell : Fin 3) :
      ‖finiteN2FixedPolynomial X Y i j ell‖*C^(ell : ℕ) ≤
        (w i j ell : ℝ)*B^4*C^2 := by
    have hn := hnorm i j ell
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

theorem finiteN2FixedPolynomial_rational_norm_sq
    {K : Type*} [Field K] [NumberField K] (phi : K →+* ℂ)
    (tau nu : ℤ) (X Y : ℤ) (sgn : Bool) (x y : 𝓞 K)
    (hx : x = if sgn then -(X : 𝓞 K) else (X : 𝓞 K))
    (hy : y = if sgn then -(Y : 𝓞 K) else (Y : 𝓞 K))
    (i : Fin 3) (j : Fin 2) (ell : Fin 3) :
    ‖finiteN2FixedPolynomial (phi (x : K)) (phi (y : K)) i j ell‖^2 =
      ((finiteN2FixedPolynomial (X : QuadInt tau nu) (Y : QuadInt tau nu) i j ell).norm : ℝ) := by
  fin_cases ell
  all_goals
    simp only [finiteN2FixedPolynomial, Matrix.cons_val_zero, Matrix.cons_val_succ]
    exact full_ring_finiteFixedHomogeneous_rational_norm_sq phi tau nu _ _ X Y sgn x y hx hy

end D1Bound5
