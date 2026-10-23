import D1Bound5.FiniteQFullRing
import D1Bound5.FiniteClosedWindow

open scoped NumberField
open Module

namespace D1Bound5

/-- The actual finite Q family excludes the manuscript's entire closed
interval, including its endpoints, for six distinct full-ring tuple
entries in the stated size range. -/
theorem full_ring_finiteQ_closed_interval_excluded
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {S : Finset (𝓞 K)} (hS : IsD1 S) (a : Fin 4 → 𝓞 K) (c d : 𝓞 K)
    (haS : ∀ j, a j ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hinj : Function.Injective a) (hac : ∀ j, a j ≠ c)
    (had : ∀ j, a j ≠ d) (hcd : c ≠ d)
    (A T : ℝ) (hA : 0 < A)
    (hlower : ∀ j, A ≤ ‖phi (a j : K)‖)
    (hupper : ∀ j, ‖phi (a j : K)‖ ≤ T)
    (hCT : 4*T ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖)
    (hAC : 1000 ≤ A*‖phi (c : K)‖)
    (hleft : 4*55^2*T^6*‖phi (c : K)‖^3/(1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤
      A^4*‖phi (c : K)‖^7/(9*T^2*(1+1/4000 : ℝ))) : False := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let C := ‖f c‖
  let D := ‖f d‖
  have hT : 0 < T := (hA.trans_le (hlower 0)).trans_le (hupper 0)
  have hAT : A ≤ T := (hlower 0).trans (hupper 0)
  have hC : 0 < C := by change 0 < ‖phi (c : K)‖; linarith
  have hAD : 4*A ≤ D := by change 4*A ≤ ‖phi (d : K)‖; linarith
  have hCD4000 : 4000 ≤ C*D := by
    have hm := mul_le_mul_of_nonneg_left hAD hC.le
    change 1000 ≤ A*C at hAC
    nlinarith only [hm, hAC]
  obtain ⟨z, hz, hform⟩ := full_ring_finiteQ_inequality hK phi hS a c d
    haS hcS hdS hinj hac had hcd A T hA hlower hupper hCT hCD hAC
  let Z := ‖f z‖
  have hZ : 0 < Z := by
    by_contra h
    have hzero : Z = 0 := le_antisymm (le_of_not_gt h) (norm_nonneg (f z))
    change 1 < 55*T^3*C^2/Z+3*T*Z/(2*A^2*C^4) at hform
    rw [hzero] at hform
    norm_num at hform
  have hzC : (f z)^2 = f c*f d+1 := by
    simpa only [map_pow, map_mul, map_add, map_one] using congrArg f hz
  obtain ⟨hrootlo, hroothi⟩ := finite_tuple_root_relative_norm (f c) (f d) (f z) hzC hCD4000
  let U := 55*T^3*C^2
  let V := 3*T/(2*A^2*C^4)
  have hU : 0 < U := by dsimp [U]; positivity
  have hV : 0 < V := by dsimp [V]; positivity
  have hform' : 1 < U/Z+V*Z := by
    change 1 < 55*T^3*C^2/Z+3*T*Z/(2*A^2*C^4) at hform
    convert hform using 1 <;> dsimp [U, V] <;> ring
  have heqlo : 4*U^2/(C*(1-1/4000 : ℝ)) =
      4*55^2*T^6*C^3/(1-1/4000 : ℝ) := by
    dsimp [U]
    field_simp [hC.ne']
    <;> ring
  have heqhi : 1/(4*V^2*C*(1+1/4000 : ℝ)) =
      A^4*C^7/(9*T^2*(1+1/4000 : ℝ)) := by
    dsimp [V]
    field_simp [hA.ne', hT.ne', hC.ne']
    <;> ring
  apply finite_closed_window_incompatible C D Z U V (1/4000) hC hZ hU hV
    (by norm_num) (by norm_num) hrootlo hroothi hform'
  · rw [heqlo]
    exact hleft
  · rw [heqhi]
    exact hright

end D1Bound5
