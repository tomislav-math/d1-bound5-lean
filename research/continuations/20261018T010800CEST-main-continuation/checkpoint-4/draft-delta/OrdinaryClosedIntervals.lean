import D1Bound5.BennettRootTransfer
import D1Bound5.BennettRateLower
import D1Bound5.FiniteClosedWindow
import D1Bound5.IntervalChain

open scoped NumberField
open Module

namespace D1Bound5

noncomputable def ordinaryWindowLower (B C : ℝ) (k : ℕ) : ℝ :=
  36*(42*B^3*C)^(2*k)*C/(B^2*(1-1/4000 : ℝ))

noncomputable def ordinaryWindowUpper (A B C : ℝ) (k : ℕ) : ℝ :=
  (2*A*C^2/(5*B))^(2*k)/(C*(1+1/4000 : ℝ))

/-- Every positive-order ordinary window is excluded by the actual
integral Bennett form. The quadratic residual rate is derived from the
actual node separation, and the terminal square root is supplied by the
tuple. No approximation bound or list of orders is assumed. -/
theorem IsD1Tuple.ordinary_closed_interval_excluded
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 4 → 𝓞 K) (ht : IsD1Tuple t)
    (hAB : ‖phi (t 0 : K)‖ ≤ ‖phi (t 1 : K)‖)
    (hAC : 1000 ≤ ‖phi (t 0 : K)‖*‖phi (t 2 : K)‖)
    (hC : 4*‖phi (t 1 : K)‖ < ‖phi (t 2 : K)‖)
    (hCD : ‖phi (t 2 : K)‖ ≤ ‖phi (t 3 : K)‖)
    (k : ℕ) (hk : 1 ≤ k)
    (hleft : ordinaryWindowLower ‖phi (t 1 : K)‖ ‖phi (t 2 : K)‖ k ≤
      ‖phi (t 3 : K)‖)
    (hright : ‖phi (t 3 : K)‖ ≤
      ordinaryWindowUpper ‖phi (t 0 : K)‖ ‖phi (t 1 : K)‖ ‖phi (t 2 : K)‖ k) :
    False := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let A := ‖f (t 0)‖
  let B := ‖f (t 1)‖
  let C := ‖f (t 2)‖
  let D := ‖f (t 3)‖
  let H := 42*B^3*C
  let R := 2*A*C^2/(5*B)
  have hA1 : 1 ≤ A := one_le_norm_integer hK phi (ht.2.1 0)
  have hB1 : 1 ≤ B := one_le_norm_integer hK phi (ht.2.1 1)
  have hA0 : 0 < A := by linarith only [hA1]
  have hB0 : 0 < B := by linarith only [hB1]
  change A ≤ B at hAB
  change 1000 ≤ A*C at hAC
  change 4*B < C at hC
  change C ≤ D at hCD
  have hC0 : 0 < C := by linarith only [hC,hB0]
  have hH : 0 < H := by dsimp [H]; positivity
  have hR : 0 < R := by dsimp [R]; positivity
  have hAD : 4*A ≤ D := by linarith only [hAB,hC,hCD]
  have hCD4000 : 4000 ≤ C*D := by
    have hm := mul_le_mul_of_nonneg_left hAD hC0.le
    nlinarith only [hm,hAC]
  obtain ⟨rA,hrA⟩ := ht.2.2 0 2 (by decide)
  obtain ⟨rB,hrB⟩ := ht.2.2 1 2 (by decide)
  obtain ⟨vA,hvA⟩ := ht.2.2 0 3 (by decide)
  obtain ⟨vB,hvB⟩ := ht.2.2 1 3 (by decide)
  obtain ⟨z,hz⟩ := ht.2.2 2 3 (by decide)
  have hz' : z^2=t 2*t 3+1 := by simpa only [pow_two] using hz
  have hform := full_ring_bennett_two_integer_k hK phi
    (t 0) (t 1) (t 2) (t 3) rA rB vA vB z
    (ht.2.1 0) (ht.2.1 1) (ht.2.1 2) (ht.2.1 3)
    (ht.1.ne (by decide : (0 : Fin 4) ≠ 1))
    (by simpa only [pow_two] using hrA) (by simpa only [pow_two] using hrB)
    (by simpa only [pow_two] using hvA) (by simpa only [pow_two] using hvB)
    hz' hAB hAC hC k hk
  let Z := ‖f z‖
  let Ractual := bennettTwoResidualRate A B C ‖f (t 0)-f (t 1)‖
  change 1 < 3*C*H^k/(B*Z)+Z/(2*Ractual^k) at hform
  have hZ : 0 < Z := by
    by_contra h
    have hzero : Z=0 := le_antisymm (le_of_not_gt h) (norm_nonneg (f z))
    rw [hzero] at hform
    norm_num at hform
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  have hr : R < Ractual := bennettTwoResidualRate_norm_lower
    (f (t 0)) (f (t 1)) (f (t 2))
    (norm_pos_iff.mp hA0) (norm_pos_iff.mp hB0)
    (hf.ne (ht.1.ne (by decide : (0 : Fin 4) ≠ 1))) hAB hAC
  have hpow : R^k ≤ Ractual^k := by gcongr
  have hres : Z/(2*Ractual^k) ≤ Z/(2*R^k) :=
    div_le_div_of_nonneg_left hZ.le (by positivity)
      (mul_le_mul_of_nonneg_left hpow (by norm_num))
  let U := 3*C*H^k/B
  let V := 1/(2*R^k)
  have hform' : 1 < U/Z+V*Z := by
    have hh := hform.trans_le (add_le_add_left hres _)
    convert hh using 1 <;> dsimp [U,V] <;> ring
  have hzC : (f z)^2=f (t 2)*f (t 3)+1 := by
    simpa only [map_pow,map_mul,map_add,map_one] using congrArg f hz'
  obtain ⟨hrootlo,hroothi⟩ := finite_tuple_root_relative_norm
    (f (t 2)) (f (t 3)) (f z) hzC hCD4000
  have heqlo : 4*U^2/(C*(1-1/4000 : ℝ)) = ordinaryWindowLower B C k := by
    dsimp [U,ordinaryWindowLower,H]
    rw [Nat.mul_comm 2 k,pow_mul]
    field_simp [hB0.ne',hC0.ne']
    <;> ring
  have heqhi : 1/(4*V^2*C*(1+1/4000 : ℝ)) = ordinaryWindowUpper A B C k := by
    dsimp [V,ordinaryWindowUpper]
    change 1/(4*(1/(2*R^k))^2*C*(1+1/4000 : ℝ)) = R^(2*k)/(C*(1+1/4000 : ℝ))
    rw [Nat.mul_comm 2 k,pow_mul]
    field_simp [hR.ne',hC0.ne']
    <;> ring
  apply finite_closed_window_incompatible C D Z U V (1/4000)
    hC0 hZ (by dsimp [U]; positivity) (by dsimp [V]; positivity)
    (by norm_num) (by norm_num) hrootlo hroothi hform'
  · rw [heqlo]
    exact hleft
  · rw [heqhi]
    exact hright

theorem ordinaryWindowLower_succ (B C : ℝ) (k : ℕ) :
    ordinaryWindowLower B C (k+1) = ordinaryWindowLower B C k*(42*B^3*C)^2 := by
  unfold ordinaryWindowLower
  rw [Nat.mul_add,pow_add]
  ring

theorem ordinaryWindowUpper_succ (A B C : ℝ) (k : ℕ) :
    ordinaryWindowUpper A B C (k+1) =
      ordinaryWindowUpper A B C k*(2*A*C^2/(5*B))^2 := by
  unfold ordinaryWindowUpper
  rw [Nat.mul_add,pow_add]
  ring

/-- The ordinary tail is genuinely infinite. A single checked overlap
at orders 5 and 6 propagates because the actual quadratic lower rate
exceeds the height rate; geometric lower endpoints are unbounded. -/
theorem IsD1Tuple.ordinary_tail_incompatible
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 4 → 𝓞 K) (ht : IsD1Tuple t)
    (hAB : ‖phi (t 0 : K)‖ ≤ ‖phi (t 1 : K)‖)
    (hAC : 1000 ≤ ‖phi (t 0 : K)‖*‖phi (t 2 : K)‖)
    (hC : 4*‖phi (t 1 : K)‖ < ‖phi (t 2 : K)‖)
    (hCD : ‖phi (t 2 : K)‖ ≤ ‖phi (t 3 : K)‖)
    (hrate : 42*‖phi (t 1 : K)‖^3*‖phi (t 2 : K)‖ <
      2*‖phi (t 0 : K)‖*‖phi (t 2 : K)‖^2/(5*‖phi (t 1 : K)‖))
    (hoverlap : ordinaryWindowLower ‖phi (t 1 : K)‖ ‖phi (t 2 : K)‖ 6 ≤
      ordinaryWindowUpper ‖phi (t 0 : K)‖ ‖phi (t 1 : K)‖ ‖phi (t 2 : K)‖ 5)
    (hstart : ordinaryWindowLower ‖phi (t 1 : K)‖ ‖phi (t 2 : K)‖ 5 ≤
      ‖phi (t 3 : K)‖) : False := by
  let A := ‖phi (t 0 : K)‖
  let B := ‖phi (t 1 : K)‖
  let C := ‖phi (t 2 : K)‖
  let D := ‖phi (t 3 : K)‖
  let H := 42*B^3*C
  let R := 2*A*C^2/(5*B)
  have hA1 : 1 ≤ A := one_le_norm_integer hK phi (ht.2.1 0)
  have hA0 : 0 < A := by linarith only [hA1]
  have hB1 : 1 ≤ B := one_le_norm_integer hK phi (ht.2.1 1)
  have hB0 : 0 < B := by linarith only [hB1]
  have hC1 : 1 < C := by change 4*B<C at hC; linarith only [hC,hB1]
  have hC0 : 0 < C := lt_trans (by norm_num) hC1
  have hH1 : 1 < H := by
    have hB3 : 1 ≤ B^3 := by
      calc
        (1 : ℝ) = 1^3 := by norm_num
        _ ≤ B^3 := by gcongr
    have hh := mul_le_mul_of_nonneg_right hB3 hC0.le
    dsimp [H]
    linarith only [hh,hC1]
  have hH0 : 0 < H := lt_trans (by norm_num) hH1
  change H < R at hrate
  have hR0 : 0 < R := hH0.trans hrate
  have hHR : H^2 ≤ R^2 := by gcongr
  have hpos (k : ℕ) : 0 < ordinaryWindowUpper A B C k := by
    unfold ordinaryWindowUpper
    positivity
  have hov (n : ℕ) : ordinaryWindowLower B C (n+6) ≤ ordinaryWindowUpper A B C (n+5) := by
    induction n with
    | zero => exact hoverlap
    | succ n ih =>
      rw [show n+1+6=(n+6)+1 by omega, show n+1+5=(n+5)+1 by omega,
        ordinaryWindowLower_succ,ordinaryWindowUpper_succ]
      exact (mul_le_mul_of_nonneg_right ih (sq_nonneg H)).trans
        (mul_le_mul_of_nonneg_left hHR (hpos _).le)
  have hgeom (n : ℕ) : ordinaryWindowLower B C (n+5) = ordinaryWindowLower B C 5*(H^2)^n := by
    induction n with
    | zero => simp
    | succ n ih =>
      rw [show n+1+5=(n+5)+1 by omega,ordinaryWindowLower_succ,ih,pow_succ]
      ring
  have hbase : 0 < ordinaryWindowLower B C 5 := by
    unfold ordinaryWindowLower
    positivity
  have hHsquared : 1 < H^2 := by nlinarith only [hH1,sq_nonneg (H-1)]
  apply forbidden_interval_chain (fun n => ordinaryWindowLower B C (n+5))
    (fun n => ordinaryWindowUpper A B C (n+5)) D hstart
  · intro n
    convert hov n using 1 <;> congr 1 <;> omega
  · intro n hn
    exact IsD1Tuple.ordinary_closed_interval_excluded hK phi t ht
      hAB hAC hC hCD (n+5) (by omega) hn.1 hn.2
  · obtain ⟨n,hn⟩ := scaled_power_unbounded (ordinaryWindowLower B C 5) (H^2) D hbase hHsquared
    exact ⟨n,by rw [hgeom]; exact hn⟩

end D1Bound5
