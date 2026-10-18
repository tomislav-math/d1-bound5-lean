import D1Bound5.FinitePFullRing
import D1Bound5.FiniteClosedWindow

open scoped NumberField
open Module

namespace D1Bound5

/-- The full closed finite P window, using the same
relative root error 1/4000 as the neighboring finite families. -/
theorem full_ring_finiteP_closed_interval_excluded
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {S : Finset (𝓞 K)} (hS : IsD1 S) (a : Fin 3 → 𝓞 K) (c d : 𝓞 K)
    (haS : ∀ j, a j ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hinj : Function.Injective a) (hac : ∀ j, a j ≠ c)
    (had : ∀ j, a j ≠ d) (hcd : c ≠ d)
    (hmon : Monotone (fun j => ‖phi (a j : K)‖))
    (hCT : 200*‖phi (a 2 : K)‖ ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖)
    (hAC : 1000 ≤ ‖phi (a 0 : K)‖*‖phi (c : K)‖)
    (hleft : 4*(2400 : ℝ)^2*
      (max (‖phi (a 1 : K)‖*‖phi (a 2 : K)‖^3)
        (‖phi (a 1 : K)‖^3*‖phi (a 2 : K)‖^2))^2*
      ‖phi (c : K)‖^5/(1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤ ‖phi (a 0 : K)‖^6*‖phi (c : K)‖^9/
      (36*‖phi (a 2 : K)‖^4*(1+1/4000 : ℝ))) : False := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let A := ‖f (a 0)‖
  let B := ‖f (a 1)‖
  let T := ‖f (a 2)‖
  let C := ‖f c‖
  let D := ‖f d‖
  let H := max (B*T^3) (B^3*T^2)
  have hn (j : Fin 3) : 1 ≤ ‖f (a j)‖ := one_le_norm_integer hK phi (hS.1 _ (haS j))
  have hA : 0 < A := by have hh := hn 0; linarith only [hh]
  have hB : 0 < B := by have hh := hn 1; linarith only [hh]
  have hT : 0 < T := by have hh := hn 2; linarith only [hh]
  have hC : 0 < C := by change 0 < ‖phi (c : K)‖; linarith only [hCT,hT]
  have hAT : A ≤ T := hmon (by decide)
  have hAD : 4*A ≤ D := by change 4*A ≤ ‖phi (d : K)‖; linarith only [hAT,hCT,hCD,hT]
  have hCD4000 : 4000 ≤ C*D := by
    have hh := mul_le_mul_of_nonneg_left hAD hC.le
    nlinarith only [hh,hAC]
  obtain ⟨z,hz,hform⟩ := full_ring_finiteP_inequality hK phi hS a c d
    haS hcS hdS hinj hac had hcd hmon hCT hCD hAC
  let Z := ‖f z‖
  have hZ : 0 < Z := by
    by_contra h
    have hzero : Z = 0 := le_antisymm (le_of_not_gt h) (norm_nonneg (f z))
    change 1 < 2400*H*C^3/Z+3*T^2*Z/(A^3*C^5) at hform
    rw [hzero] at hform
    norm_num at hform
  have hzC : (f z)^2 = f c*f d+1 := by
    simpa only [map_pow,map_mul,map_add,map_one] using congrArg f hz
  obtain ⟨hlo,hhi⟩ := finite_tuple_root_relative_norm (f c) (f d) (f z) hzC hCD4000
  let U := (2400 : ℝ)*H*C^3
  let V := 3*T^2/(A^3*C^5)
  have hH : 0 < H := lt_of_lt_of_le (by positivity) (le_max_left _ _)
  have hU : 0 < U := by dsimp [U]; positivity
  have hV : 0 < V := by dsimp [V]; positivity
  have hform' : 1 < U/Z+V*Z := by
    change 1 < 2400*H*C^3/Z+3*T^2*Z/(A^3*C^5) at hform
    convert hform using 1 <;> dsimp [U,V] <;> ring
  have heqlo : 4*U^2/(C*(1-1/4000 : ℝ)) =
      4*(2400 : ℝ)^2*H^2*C^5/(1-1/4000 : ℝ) := by
    dsimp [U]
    field_simp [hC.ne']
    <;> ring
  have heqhi : 1/(4*V^2*C*(1+1/4000 : ℝ)) =
      A^6*C^9/(36*T^4*(1+1/4000 : ℝ)) := by
    dsimp [V]
    field_simp [hA.ne',hB.ne',hT.ne',hC.ne']
    <;> ring
  apply finite_closed_window_incompatible C D Z U V (1/4000) hC hZ hU hV
    (by norm_num) (by norm_num) hlo hhi hform'
  · rw [heqlo]
    exact hleft
  · rw [heqhi]
    exact hright

end D1Bound5
