import D1Bound5.FiniteN2FullRing

open scoped NumberField
open Module

namespace D1Bound5

/-- An explicit coefficient-height refinement for the actual finite N2 row.
The full-ring application supplies the actual residual bound separately. -/
theorem finiteN2RowForm_norm_lt_refined
    (x y c z sX sY : ℂ) (hx : x ≠ 0) (hy : y ≠ 0) (hz : z ≠ 0)
    (i : Fin 3) (M : ℝ)
    (hheightScaled : (101/100 : ℝ)*(‖finiteN2Left x y c i‖+‖finiteN2Right x y c i‖) <
      M*‖y‖^4*‖c‖^2)
    (herr : ∀ j : Fin 2,
      ‖(1+1/(![x,y] j*c))^(1/2 : ℂ)-![sX,sY] j/(![x,y] j*z)‖ ≤
        (101/100 : ℝ)*‖c‖/(‖![x,y] j‖*‖z‖^2))
    (R : ℝ) (hres : ‖finiteN2Residual x y c i‖ < R) :
    ‖finiteN2RowForm x y c z sX sY i‖ <
      M*‖y‖^4*‖c‖^3/‖z‖+R*‖z‖ := by
  have ha (j : Fin 2) : ![x,y] j ≠ 0 := by fin_cases j <;> assumption
  have hh := hheightScaled
  have hheight : (∑ j : Fin 2, ‖![finiteN2Left x y c i,finiteN2Right x y c i] j‖) ≤
      (M*‖y‖^4*‖c‖^2)/(101/100 : ℝ) := by
    simp only [Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one]
    apply (le_div_iff₀ (by norm_num : (0 : ℝ) < 101/100)).mpr
    nlinarith only [hh.le]
  have hres' : ‖finiteN2Constant x y c i +
      ∑ j : Fin 2, ![x,y] j * ![finiteN2Left x y c i,finiteN2Right x y c i] j *
        (1+1/(![x,y] j*c))^(1/2 : ℂ)‖ < R := by
    simpa [Fin.sum_univ_two, finiteN2Residual, add_assoc] using hres
  have h := finite_row_root_transfer_norm_lt (finiteN2Constant x y c i) z
    ![x,y] ![finiteN2Left x y c i,finiteN2Right x y c i]
    (fun j => (1+1/(![x,y] j*c))^(1/2 : ℂ)) ![sX,sY]
    ha hz ((101/100 : ℝ)*‖c‖) ((M*‖y‖^4*‖c‖^2)/(101/100 : ℝ)) R
    (by positivity) herr hheight hres'
  rw [finiteN2RowForm_eq_root_sum]
  convert h using 1 <;> ring

/-- Reusable fixed-anchor join. The height premise refers to the actual
integer coefficient polynomials, allowing evaluated coefficient bounds to
feed the same actual root and integral-row construction. Applications must
prove this height premise for their chosen anchors. -/
theorem full_ring_finiteN2_inequalities_of_height
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {S : Finset (𝓞 K)} (hS : IsD1 S) (x y c d : 𝓞 K)
    (hxS : x ∈ S) (hyS : y ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hxy : x ≠ y) (hxc : x ≠ c) (hyc : y ≠ c)
    (hxd : x ≠ d) (hyd : y ≠ d) (hcd : c ≠ d)
    (hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖)
    (hXC : 1000 ≤ ‖phi (x : K)‖*‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖)
    (M : ℝ)
    (hheight : ∀ i : Fin 3,
      (101/100 : ℝ)*(‖finiteN2Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
        ‖finiteN2Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
          M*‖phi (y : K)‖^4*‖phi (c : K)‖^2) :
    ∃ z : 𝓞 K, z^2 = c*d+1 ∧
      (1 < M*‖phi (y : K)‖^4*‖phi (c : K)‖^3/‖phi (z : K)‖ +
        (5/4 : ℝ)*‖phi (y : K)‖^2*‖phi (z : K)‖ /
          (‖phi (x : K)‖^3*‖phi (c : K)‖^4)) ∧
      (1 < M*‖phi (y : K)‖^4*‖phi (c : K)‖^3/‖phi (z : K)‖ +
        (101/2560 : ℝ)*max (‖phi (x : K)-phi (y : K)‖^4)
          (‖phi (x : K)‖*‖phi (x : K)-phi (y : K)‖^3)*‖phi (z : K)‖ /
            (‖phi (x : K)‖^3*‖phi (y : K)‖^2*‖phi (c : K)‖^4)) := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hf : Function.Injective f := by
    intro a b hab
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hab
  have hnonzero (a : 𝓞 K) (haS : a ∈ S) : f a ≠ 0 := by
    intro h
    apply hS.1 a haS
    apply hf
    simpa only [map_zero] using h
  have hx0 := hnonzero x hxS
  have hy0 := hnonzero y hyS
  have hc0 := hnonzero c hcS
  have hxy0 : f x ≠ f y := fun h => hxy (hf h)
  change ‖f x‖ ≤ ‖f y‖ at hXY
  change 1000 ≤ ‖f x‖*‖f c‖ at hXC
  change 200*‖f y‖ ≤ ‖f c‖ at hCY
  change ‖f c‖ ≤ ‖f d‖ at hCD
  have hXD : ‖f x‖ ≤ ‖f d‖ := by
    have hY := norm_nonneg (f y)
    linarith only [hXY,hCY,hCD,hY]
  have hCDlarge : 1000 ≤ ‖f c‖*‖f d‖ := by
    have hm := mul_le_mul_of_nonneg_right hXD (norm_nonneg (f c))
    nlinarith only [hXC,hm]
  obtain ⟨z,hz⟩ := hS.2 c hcS d hdS hcd
  have hzsq : z^2 = c*d+1 := by simpa only [pow_two] using hz
  have hzC : (f z)^2 = f c*f d+1 := by
    simpa only [map_pow,map_mul,map_add,map_one] using congrArg f hzsq
  have hz0 : f z ≠ 0 := by
    intro hzero
    have heq : f c*f d = -(1 : ℂ) := by
      apply eq_neg_iff_add_eq_zero.mpr
      simpa only [hzero,zero_pow (by decide : (2 : ℕ) ≠ 0)] using hzC.symm
    have hn := congrArg norm heq
    simp only [norm_mul,norm_neg,norm_one] at hn
    linarith only [hCDlarge,hn]
  have hzR : z ≠ 0 := by intro hzero; apply hz0; rw [hzero,map_zero]
  obtain ⟨rX,hrX⟩ := hS.2 x hxS c hcS hxc
  obtain ⟨rY,hrY⟩ := hS.2 y hyS c hcS hyc
  obtain ⟨vX,hvX⟩ := hS.2 x hxS d hdS hxd
  obtain ⟨vY,hvY⟩ := hS.2 y hyS d hdS hyd
  have hYC := hXC.trans (mul_le_mul_of_nonneg_right hXY (norm_nonneg (f c)))
  have hCX : 200*‖f x‖ ≤ ‖f c‖ :=
    (mul_le_mul_of_nonneg_left hXY (by norm_num)).trans hCY
  obtain ⟨sX,_,herrX⟩ := bennett_exists_integral_root_ratio_bound_finite
    f x c d z rX vX hx0 hc0 hz0 (by simpa only [pow_two] using hrX)
      (by simpa only [pow_two] using hvX) hzsq hXC hCX
  obtain ⟨sY,_,herrY⟩ := bennett_exists_integral_root_ratio_bound_finite
    f y c d z rY vY hy0 hc0 hz0 (by simpa only [pow_two] using hrY)
      (by simpa only [pow_two] using hvY) hzsq hYC hCY
  have herr (j : Fin 2) :
      ‖(1+1/(![f x,f y] j*f c))^(1/2 : ℂ)-![f sX,f sY] j/(![f x,f y] j*f z)‖ ≤
        (101/100 : ℝ)*‖f c‖/(‖![f x,f y] j‖*‖f z‖^2) := by
    fin_cases j
    · exact herrX.le
    · exact herrY.le
  obtain ⟨i,hi⟩ := full_ring_finiteN2RowForm_exists_one_le_norm
    hK phi x y c z sX sY hxy hzR
  change 1 ≤ ‖finiteN2RowForm (f x) (f y) (f c) (f z) (f sX) (f sY) i‖ at hi
  refine ⟨z,hzsq,?_,?_⟩
  · have h := hi.trans_lt (finiteN2RowForm_norm_lt_refined
      (f x) (f y) (f c) (f z) (f sX) (f sY) hx0 hy0 hz0 i M (hheight i) herr _
      (finiteN2_residual_norm_lt (f x) (f y) (f c) hx0 hy0 hc0 hxy0 hXY hXC i))
    convert h using 1 <;> ring
  · have h := hi.trans_lt (finiteN2RowForm_norm_lt_refined
      (f x) (f y) (f c) (f z) (f sX) (f sY) hx0 hy0 hz0 i M (hheight i) herr _
      (finiteN2_residual_norm_lt_point (f x) (f y) (f c) hx0 hy0 hc0 hxy0 hXY hXC i))
    convert h using 1 <;> ring

end D1Bound5
