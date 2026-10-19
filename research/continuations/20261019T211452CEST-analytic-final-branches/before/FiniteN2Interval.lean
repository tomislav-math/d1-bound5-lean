import D1Bound5.FiniteN2FullRing
import D1Bound5.FiniteClosedWindow

open scoped NumberField
open Module

namespace D1Bound5

/-- The complete uniform N2 closed forbidden interval, derived from the
actual full-ring family. Both endpoints belong to the excluded window. -/
theorem full_ring_finiteN2_closed_interval_excluded
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
    (hleft : 4*243^2*‖phi (y : K)‖^8*‖phi (c : K)‖^5 /
      (1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤
      4*‖phi (x : K)‖^6*‖phi (c : K)‖^7 /
        (25*‖phi (y : K)‖^4*(1+1/4000 : ℝ))) : False := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let A := ‖f x‖
  let B := ‖f y‖
  let C := ‖f c‖
  let D := ‖f d‖
  have hA1 : 1 ≤ A := one_le_norm_integer hK phi (hS.1 x hxS)
  have hA : 0 < A := by linarith only [hA1]
  have hB : 0 < B := hA.trans_le hXY
  have hC : 0 < C := by change 200*B ≤ C at hCY; linarith only [hCY,hB]
  have hAD : 4*A ≤ D := by
    change A ≤ B at hXY
    change 200*B ≤ C at hCY
    change C ≤ D at hCD
    linarith only [hXY,hCY,hCD,hB]
  have hCD4000 : 4000 ≤ C*D := by
    have hm := mul_le_mul_of_nonneg_left hAD hC.le
    change 1000 ≤ A*C at hXC
    nlinarith only [hm,hXC]
  obtain ⟨z,hz,hform,_⟩ := full_ring_finiteN2_inequalities hK phi hS x y c d
    hxS hyS hcS hdS hxy hxc hyc hxd hyd hcd hXY hXC hCY hCD
  let Z := ‖f z‖
  change 1 < 243*B^4*C^3/Z+(5/4 : ℝ)*B^2*Z/(A^3*C^4) at hform
  have hZ : 0 < Z := by
    by_contra h
    have hzero : Z = 0 := le_antisymm (le_of_not_gt h) (norm_nonneg (f z))
    rw [hzero] at hform
    norm_num at hform
  have hzC : (f z)^2 = f c*f d+1 := by
    simpa only [map_pow,map_mul,map_add,map_one] using congrArg f hz
  obtain ⟨hrootlo,hroothi⟩ := finite_tuple_root_relative_norm (f c) (f d) (f z) hzC hCD4000
  let U := 243*B^4*C^3
  let V := (5/4 : ℝ)*B^2/(A^3*C^4)
  have hU : 0 < U := by dsimp [U]; positivity
  have hV : 0 < V := by dsimp [V]; positivity
  have hform' : 1 < U/Z+V*Z := by convert hform using 1 <;> dsimp [U,V] <;> ring
  have heqlo : 4*U^2/(C*(1-1/4000 : ℝ)) =
      4*243^2*B^8*C^5/(1-1/4000 : ℝ) := by
    dsimp [U]
    field_simp [hC.ne']
    <;> ring
  have heqhi : 1/(4*V^2*C*(1+1/4000 : ℝ)) =
      4*A^6*C^7/(25*B^4*(1+1/4000 : ℝ)) := by
    dsimp [V]
    field_simp [hA.ne',hB.ne',hC.ne']
    <;> ring
  apply finite_closed_window_incompatible C D Z U V (1/4000) hC hZ hU hV
    (by norm_num) (by norm_num) hrootlo hroothi hform'
  · rw [heqlo]
    exact hleft
  · rw [heqhi]
    exact hright

end D1Bound5
