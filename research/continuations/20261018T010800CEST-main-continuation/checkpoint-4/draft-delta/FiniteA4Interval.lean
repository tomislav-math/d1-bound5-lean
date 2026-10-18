import D1Bound5.FiniteA4Approximation
import D1Bound5.FiniteClosedWindow

open scoped NumberField
open Module

namespace D1Bound5

/-- The A4 family on any actual four-entry subtuple. The matrix uses the unequal pole orders specified in the article. -/
theorem IsD1Tuple.finiteA4_inequality
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 4 → 𝓞 K) (ht : IsD1Tuple t)
    (hXY : ‖phi (t 0 : K)‖ ≤ ‖phi (t 1 : K)‖)
    (hXC : 1000 ≤ ‖phi (t 0 : K)‖*‖phi (t 2 : K)‖)
    (hC : 200*‖phi (t 1 : K)‖ ≤ ‖phi (t 2 : K)‖) :
    ∃ z : 𝓞 K, z^2=t 2*t 3+1 ∧
      1 < 165763*‖phi (t 1 : K)‖^9*‖phi (t 2 : K)‖^5/‖phi (z : K)‖ +
        (63/8 : ℝ)*‖phi (t 1 : K)‖^4*‖phi (z : K)‖/
          (‖phi (t 0 : K)‖^5*‖phi (t 2 : K)‖^7) := by
  obtain ⟨rX,hrX⟩ := ht.2.2 0 2 (by decide)
  obtain ⟨rY,hrY⟩ := ht.2.2 1 2 (by decide)
  obtain ⟨vX,hvX⟩ := ht.2.2 0 3 (by decide)
  obtain ⟨vY,hvY⟩ := ht.2.2 1 3 (by decide)
  obtain ⟨z,hz⟩ := ht.2.2 2 3 (by decide)
  have hz' : z^2=t 2*t 3+1 := by simpa only [pow_two] using hz
  refine ⟨z,hz',?_⟩
  exact full_ring_finiteA4_integer hK phi (t 0) (t 1) (t 2) (t 3) rX rY vX vY z
    (ht.2.1 0) (ht.2.1 1) (ht.2.1 2) (ht.2.1 3)
    (fun h => (by decide : (0 : Fin 4) ≠ 1) (ht.1 h))
    (by simpa only [pow_two] using hrX) (by simpa only [pow_two] using hrY)
    (by simpa only [pow_two] using hvX) (by simpa only [pow_two] using hvY)
    hz' hXY hXC hC

/-- The whole closed A4 window is excluded for an actual full-ring
subtuple. This also supplies A4 after selecting the b,s,c,d subtuple. -/
theorem IsD1Tuple.finiteA4_closed_interval_excluded
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 4 → 𝓞 K) (ht : IsD1Tuple t)
    (hXY : ‖phi (t 0 : K)‖ ≤ ‖phi (t 1 : K)‖)
    (hXC : 1000 ≤ ‖phi (t 0 : K)‖*‖phi (t 2 : K)‖)
    (hC : 200*‖phi (t 1 : K)‖ ≤ ‖phi (t 2 : K)‖)
    (hCD : ‖phi (t 2 : K)‖ ≤ ‖phi (t 3 : K)‖)
    (hleft : 4*165763^2*‖phi (t 1 : K)‖^18*‖phi (t 2 : K)‖^9 /
      (1-1/4000 : ℝ) ≤ ‖phi (t 3 : K)‖)
    (hright : ‖phi (t 3 : K)‖ ≤
      16*‖phi (t 0 : K)‖^10*‖phi (t 2 : K)‖^13 /
        (3969*‖phi (t 1 : K)‖^8*(1+1/4000 : ℝ))) : False := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let X := ‖f (t 0)‖
  let Y := ‖f (t 1)‖
  let C := ‖f (t 2)‖
  let D := ‖f (t 3)‖
  have hX1 : 1 ≤ X := one_le_norm_integer hK phi (ht.2.1 0)
  have hY1 : 1 ≤ Y := one_le_norm_integer hK phi (ht.2.1 1)
  have hXpos : 0 < X := by linarith only [hX1]
  have hYpos : 0 < Y := by linarith only [hY1]
  change 200*Y ≤ C at hC
  change C ≤ D at hCD
  have hC200 : 200 ≤ C := by linarith only [hC,hY1]
  have hCpos : 0 < C := by linarith only [hC200]
  have hCD4000 : 4000 ≤ C*D := by
    have hm := mul_le_mul_of_nonneg_left hCD hCpos.le
    nlinarith only [hm,hC200,sq_nonneg (C-200)]
  obtain ⟨z,hz,hform⟩ := IsD1Tuple.finiteA4_inequality hK phi t ht hXY hXC hC
  let Z := ‖f z‖
  have hZpos : 0 < Z := by
    by_contra h
    have hzero : Z=0 := le_antisymm (le_of_not_gt h) (norm_nonneg (f z))
    change 1 < 165763*Y^9*C^5/Z+(63/8 : ℝ)*Y^4*Z/(X^5*C^7) at hform
    rw [hzero] at hform
    norm_num at hform
  have hzC : (f z)^2=f (t 2)*f (t 3)+1 := by
    simpa only [map_pow,map_mul,map_add,map_one] using congrArg f hz
  obtain ⟨hrootlo,hroothi⟩ := finite_tuple_root_relative_norm
    (f (t 2)) (f (t 3)) (f z) hzC hCD4000
  let U := 165763*Y^9*C^5
  let V := (63/8 : ℝ)*Y^4/(X^5*C^7)
  have hU : 0 < U := by dsimp [U]; positivity
  have hV : 0 < V := by dsimp [V]; positivity
  have hform' : 1 < U/Z+V*Z := by
    change 1 < 165763*Y^9*C^5/Z+(63/8 : ℝ)*Y^4*Z/(X^5*C^7) at hform
    convert hform using 1 <;> dsimp [U,V] <;> ring
  have heqlo : 4*U^2/(C*(1-1/4000 : ℝ)) =
      4*165763^2*Y^18*C^9/(1-1/4000 : ℝ) := by
    dsimp [U]
    field_simp [hCpos.ne']
    <;> ring
  have heqhi : 1/(4*V^2*C*(1+1/4000 : ℝ)) =
      16*X^10*C^13/(3969*Y^8*(1+1/4000 : ℝ)) := by
    dsimp [V]
    field_simp [hXpos.ne',hYpos.ne',hCpos.ne']
    <;> ring
  apply finite_closed_window_incompatible C D Z U V (1/4000)
    hCpos hZpos hU hV (by norm_num) (by norm_num) hrootlo hroothi hform'
  · rw [heqlo]
    exact hleft
  · rw [heqhi]
    exact hright

end D1Bound5
