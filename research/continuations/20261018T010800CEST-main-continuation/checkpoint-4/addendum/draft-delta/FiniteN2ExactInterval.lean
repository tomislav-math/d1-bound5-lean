import D1Bound5.FiniteN2HeightRefinement
import D1Bound5.FiniteClosedWindow

open scoped NumberField
open Module

namespace D1Bound5

/-- The complete fixed-anchor N2 window from proved actual coefficients
and the explicit anchor-distance bound. The full A⁶ factor is retained in the
upper endpoint; roots, signs, and nonzero row selection are constructed. -/
theorem full_ring_finiteN2_exact_interval_of_bounds
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {S : Finset (𝓞 K)} (hS : IsD1 S) (x y c d : 𝓞 K)
    (hxS : x ∈ S) (hyS : y ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hxy : x ≠ y) (hxc : x ≠ c) (hyc : y ≠ c)
    (hxd : x ≠ d) (hyd : y ≠ d) (hcd : c ≠ d)
    (hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖)
    (hC1000 : 1000 ≤ ‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖)
    (M R : ℝ) (hM : 0 < M) (hRpos : 0 < R)
    (hheight : ∀ i : Fin 3,
      (101/100 : ℝ)*(‖finiteN2Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
        ‖finiteN2Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
          M*‖phi (y : K)‖^4*‖phi (c : K)‖^2)
    (hR : (101/2560 : ℝ)*max (‖phi (x : K)-phi (y : K)‖^4)
      (‖phi (x : K)‖*‖phi (x : K)-phi (y : K)‖^3) ≤ R*‖phi (y : K)‖^4)
    (hleft : 4*M^2*‖phi (y : K)‖^8*‖phi (c : K)‖^5/
      (1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤ ‖phi (x : K)‖^6*‖phi (c : K)‖^7/
      (4*R^2*‖phi (y : K)‖^4*(1+1/4000 : ℝ))) : False := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let A := ‖f x‖
  let B := ‖f y‖
  let C := ‖f c‖
  let D := ‖f d‖
  have hA1 : 1 ≤ A := one_le_norm_integer hK phi (hS.1 x hxS)
  have hA : 0 < A := by linarith only [hA1]
  have hB : 0 < B := hA.trans_le hXY
  have hC : 0 < C := by change 1000 ≤ C at hC1000; linarith only [hC1000]
  change C ≤ D at hCD
  have hXC : 1000 ≤ ‖phi (x : K)‖*‖phi (c : K)‖ := by
    change 1000 ≤ A*C
    change 1000 ≤ C at hC1000
    have hh := mul_le_mul_of_nonneg_right hA1 hC.le
    nlinarith only [hh,hC1000]
  obtain ⟨z,hz,_,hpoint⟩ := full_ring_finiteN2_inequalities_of_height hK phi hS x y c d
    hxS hyS hcS hdS hxy hxc hyc hxd hyd hcd hXY hXC hCY hCD M hheight
  let Z := ‖f z‖
  let delta := ‖f x-f y‖
  change 1 < M*B^4*C^3/Z+
    (101/2560 : ℝ)*max (delta^4) (A*delta^3)*Z/(A^3*B^2*C^4) at hpoint
  have hZ : 0 < Z := by
    by_contra h
    have hz0 : Z=0 := le_antisymm (le_of_not_gt h) (norm_nonneg _)
    rw [hz0] at hpoint
    norm_num at hpoint
  have hterm : (101/2560 : ℝ)*max (delta^4) (A*delta^3)*Z/(A^3*B^2*C^4) ≤
      R*B^2*Z/(A^3*C^4) := by
    have hh := mul_le_mul_of_nonneg_right hR hZ.le
    change (101/2560 : ℝ)*max (delta^4) (A*delta^3)*Z ≤ R*B^4*Z at hh
    have hd := div_le_div_of_nonneg_right hh (show 0 ≤ A^3*B^2*C^4 by positivity)
    apply hd.trans_eq
    field_simp [hA.ne',hB.ne',hC.ne']
    <;> ring
  have hform : 1 < M*B^4*C^3/Z+R*B^2*Z/(A^3*C^4) :=
    hpoint.trans_le (add_le_add_left hterm _)
  have hCD4000 : 4000 ≤ C*D := by
    change 1000 ≤ C at hC1000
    have hm := mul_le_mul_of_nonneg_left hCD hC.le
    nlinarith only [hm,hC1000,sq_nonneg (C-1000)]
  have hzC : (f z)^2=f c*f d+1 := by
    simpa only [map_pow,map_mul,map_add,map_one] using congrArg f hz
  obtain ⟨hrootlo,hroothi⟩ := finite_tuple_root_relative_norm (f c) (f d) (f z) hzC hCD4000
  let U := M*B^4*C^3
  let V := R*B^2/(A^3*C^4)
  have hU : 0 < U := by dsimp [U]; positivity
  have hV : 0 < V := by dsimp [V]; positivity
  have hf : 1 < U/Z+V*Z := by convert hform using 1 <;> dsimp [U,V] <;> ring
  have heqlo : 4*U^2/(C*(1-1/4000 : ℝ)) =
      4*M^2*B^8*C^5/(1-1/4000 : ℝ) := by
    dsimp [U]
    field_simp [hC.ne']
    <;> ring
  have heqhi : 1/(4*V^2*C*(1+1/4000 : ℝ)) =
      A^6*C^7/(4*R^2*B^4*(1+1/4000 : ℝ)) := by
    dsimp [V]
    field_simp [hA.ne',hB.ne',hC.ne',hRpos.ne']
    <;> ring
  apply finite_closed_window_incompatible C D Z U V (1/4000) hC hZ hU hV
    (by norm_num) (by norm_num) hrootlo hroothi hf
  · rw [heqlo]
    exact hleft
  · rw [heqhi]
    exact hright

end D1Bound5
