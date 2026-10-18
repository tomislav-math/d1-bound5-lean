import D1Bound5.FiniteN3HeightRefinement
import D1Bound5.FiniteClosedWindow

open scoped NumberField
open Module

namespace D1Bound5

/-- The complete fixed-anchor N3 window from proved actual coefficients
and the explicit anchor-distance bound. Integrality supplies A≥1 in the
upper endpoint; roots, signs, and nonzero row selection are constructed. -/
theorem full_ring_finiteN3_fixed_interval_of_bounds
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
      (101/100 : ℝ)*(‖finiteN3Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
        ‖finiteN3Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
          M*‖phi (y : K)‖^7*‖phi (c : K)‖^3)
    (hR : (3535/409600 : ℝ)*max (‖phi (x : K)-phi (y : K)‖^6)
      (‖phi (x : K)‖*‖phi (x : K)-phi (y : K)‖^5) ≤ R*‖phi (y : K)‖^6)
    (hleft : 4*M^2*‖phi (y : K)‖^14*‖phi (c : K)‖^7/
      (1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤ ‖phi (c : K)‖^11/
      (4*R^2*‖phi (y : K)‖^6*(1+1/4000 : ℝ))) : False := by
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
    nlinarith only [hA1,hC1000]
  obtain ⟨z,hz,hform⟩ := full_ring_finiteN3_inequality_of_height hK phi hS x y c d
    hxS hyS hcS hdS hxy hxc hyc hxd hyd hcd hXY hXC hCY M R hheight hR
  let Z := ‖f z‖
  change 1 < M*B^7*C^4/Z+R*B^3*Z/(A^4*C^6) at hform
  have hZ : 0 < Z := by
    by_contra h
    have hz0 : Z=0 := le_antisymm (le_of_not_gt h) (norm_nonneg _)
    rw [hz0] at hform
    norm_num at hform
  have hCD4000 : 4000 ≤ C*D := by
    change 1000 ≤ C at hC1000
    have hm := mul_le_mul_of_nonneg_left hCD hC.le
    nlinarith only [hm,hC1000,sq_nonneg (C-1000)]
  have hzC : (f z)^2=f c*f d+1 := by
    simpa only [map_pow,map_mul,map_add,map_one] using congrArg f hz
  obtain ⟨hrootlo,hroothi⟩ := finite_tuple_root_relative_norm (f c) (f d) (f z) hzC hCD4000
  let U := M*B^7*C^4
  let V := R*B^3/(A^4*C^6)
  have hU : 0 < U := by dsimp [U]; positivity
  have hV : 0 < V := by dsimp [V]; positivity
  have hf : 1 < U/Z+V*Z := by convert hform using 1 <;> dsimp [U,V] <;> ring
  have heqlo : 4*U^2/(C*(1-1/4000 : ℝ)) =
      4*M^2*B^14*C^7/(1-1/4000 : ℝ) := by
    dsimp [U]
    field_simp [hC.ne']
    <;> ring
  have heqhi : 1/(4*V^2*C*(1+1/4000 : ℝ)) =
      A^8*C^11/(4*R^2*B^6*(1+1/4000 : ℝ)) := by
    dsimp [V]
    field_simp [hA.ne',hB.ne',hC.ne',hRpos.ne']
    <;> ring
  apply finite_closed_window_incompatible C D Z U V (1/4000) hC hZ hU hV
    (by norm_num) (by norm_num) hrootlo hroothi hf
  · rw [heqlo]
    exact hleft
  · rw [heqhi]
    apply hright.trans
    have hAp : 1 ≤ A^8 := by
      have hh : (1 : ℝ)^8 ≤ A^8 := by gcongr
      simpa using hh
    apply div_le_div_of_nonneg_right _ (by positivity)
    simpa only [one_mul] using mul_le_mul_of_nonneg_right hAp (pow_nonneg hC.le 11)

end D1Bound5
