import D1Bound5.FiniteQResidualIdentity
import Mathlib.Tactic.GCongr

namespace D1Bound5

theorem finiteQHalfRemainder_small_norm_le (n : ℕ) (z : ℂ)
    (hn : 4 ≤ n) (hz : ‖z‖ ≤ (1/1000 : ℝ)) :
    ‖finiteQHalfRemainder n z‖ ≤ (625/15984 : ℝ)*‖z‖^n := by
  have hz1 : ‖z‖ < 1 := by linarith
  apply (finiteQHalfRemainder_norm_le n z hn hz1).trans
  apply (div_le_iff₀ (sub_pos.mpr hz1)).2
  have hm := mul_le_mul_of_nonneg_right hz (pow_nonneg (norm_nonneg z) n)
  nlinarith only [hm]

noncomputable def finiteQTailSide (u v c : ℂ) : ℂ :=
  u*(u^2-5*u*v)*finiteQHalfRemainder 4 (1/(u*c)) +
    u*(4*u^3-8*u^2*v)*c*finiteQHalfRemainder 5 (1/(u*c))

/-- Each of the two anchor sides is bounded using its actual fourth- and
fifth-order Taylor tails. Cancellation of the anchor and c powers leaves
exactly the monomials1/U and V/U². -/
theorem finiteQTailSide_norm_le
    (u v c : ℂ) (A T : ℝ) (hA : 0 < A)
    (hAu : A ≤ ‖u‖) (huT : ‖u‖ ≤ T) (hvT : ‖v‖ ≤ T)
    (hAC : 1000 ≤ A*‖c‖) :
    ‖finiteQTailSide u v c‖ ≤ (625/888 : ℝ)*T/(A^2*‖c‖^4) := by
  let U := ‖u‖
  let V := ‖v‖
  let C := ‖c‖
  let M : ℝ := 625/15984
  have hU : 0 < U := hA.trans_le hAu
  have hT : 0 < T := hU.trans_le huT
  have hV : 0 ≤ V := norm_nonneg v
  have hC : 0 < C := by
    by_contra h
    have hzero : C = 0 := le_antisymm (le_of_not_gt h) (norm_nonneg c)
    change 1000 ≤ A*C at hAC
    rw [hzero, mul_zero] at hAC
    norm_num at hAC
  have hUC : 1000 ≤ U*C := hAC.trans
    (mul_le_mul_of_nonneg_right hAu hC.le)
  have hz : ‖1/(u*c)‖ ≤ (1/1000 : ℝ) := by
    rw [norm_div, norm_one, norm_mul]
    apply (div_le_div_iff₀ (mul_pos hU hC) (by norm_num : (0 : ℝ) < 1000)).2
    simpa using hUC
  have hrem4 := finiteQHalfRemainder_small_norm_le 4 (1/(u*c)) (by decide) hz
  have hrem5 := finiteQHalfRemainder_small_norm_le 5 (1/(u*c)) (by decide) hz
  rw [norm_div, norm_one, norm_mul] at hrem4 hrem5
  have hw0 : ‖u*(u^2-5*u*v)‖ ≤ U^3+5*U^2*V := by
    rw [norm_mul]
    calc
      _ ≤ ‖u‖*(‖u^2‖+‖5*u*v‖) :=
        mul_le_mul_of_nonneg_left (norm_sub_le _ _) (norm_nonneg _)
      _ = _ := by dsimp [U, V]; norm_num [norm_mul, norm_pow]; ring
  have hw1 : ‖u*(4*u^3-8*u^2*v)*c‖ ≤ (4*U^4+8*U^3*V)*C := by
    simp only [norm_mul]
    calc
      _ ≤ (‖u‖*(‖4*u^3‖+‖8*u^2*v‖))*‖c‖ := by
        exact mul_le_mul_of_nonneg_right
          (mul_le_mul_of_nonneg_left (norm_sub_le _ _) (norm_nonneg _)) (norm_nonneg _)
      _ = _ := by dsimp [U, V, C]; norm_num [norm_mul, norm_pow]; ring
  have ht0 : ‖u*(u^2-5*u*v)*finiteQHalfRemainder 4 (1/(u*c))‖ ≤
      (U^3+5*U^2*V)*(M*(1/(U*C))^4) := by
    rw [norm_mul]
    exact mul_le_mul hw0 hrem4 (norm_nonneg _) (by positivity)
  have ht1 : ‖u*(4*u^3-8*u^2*v)*c*finiteQHalfRemainder 5 (1/(u*c))‖ ≤
      ((4*U^4+8*U^3*V)*C)*(M*(1/(U*C))^5) := by
    rw [norm_mul]
    exact mul_le_mul hw1 hrem5 (norm_nonneg _) (by positivity)
  have hAT : A ≤ T := hAu.trans huT
  have hmono0 : 1/U ≤ T/A^2 := by
    apply (div_le_div_iff₀ hU (pow_pos hA 2)).2
    have hm := mul_le_mul hAT hAu hA.le hT.le
    nlinarith only [hm]
  have hmono1 : V/U^2 ≤ T/A^2 := by
    apply (div_le_div_iff₀ (pow_pos hU 2) (pow_pos hA 2)).2
    exact mul_le_mul hvT (pow_le_pow_left₀ hA.le hAu 2) (sq_nonneg A) hT.le
  calc
    _ ≤ ‖u*(u^2-5*u*v)*finiteQHalfRemainder 4 (1/(u*c))‖ +
        ‖u*(4*u^3-8*u^2*v)*c*finiteQHalfRemainder 5 (1/(u*c))‖ := norm_add_le _ _
    _ ≤ (U^3+5*U^2*V)*(M*(1/(U*C))^4) +
        ((4*U^4+8*U^3*V)*C)*(M*(1/(U*C))^5) := add_le_add ht0 ht1
    _ = M*(5*(1/U)+13*(V/U^2))/C^4 := by
      field_simp [hU.ne', hC.ne']
      <;> ring
    _ ≤ M*(5*(T/A^2)+13*(T/A^2))/C^4 := by
      dsimp [M]
      gcongr
    _ = (625/888 : ℝ)*T/(A^2*‖c‖^4) := by
      dsimp [M, C]
      ring

/-- The actual finite-Q pair residual has the manuscript's strict bound.
It follows from convergent Taylor estimates, explicit cancellations, and
the actual anchor moduli. -/
theorem finiteQResidual_norm_lt
    (u v c : ℂ) (A T : ℝ) (hA : 0 < A)
    (hAu : A ≤ ‖u‖) (hAv : A ≤ ‖v‖)
    (huT : ‖u‖ ≤ T) (hvT : ‖v‖ ≤ T) (hAC : 1000 ≤ A*‖c‖) :
    ‖finiteQResidual u v c‖ < 3*T/(2*A^2*‖c‖^4) := by
  have hu : u ≠ 0 := norm_pos_iff.mp (hA.trans_le hAu)
  have hv : v ≠ 0 := norm_pos_iff.mp (hA.trans_le hAv)
  have hc : c ≠ 0 := by
    intro hzero
    rw [hzero, norm_zero, mul_zero] at hAC
    norm_num at hAC
  have hT : 0 < T := (hA.trans_le hAu).trans_le huT
  have hC : 0 < ‖c‖ := norm_pos_iff.mpr hc
  have heq : finiteQResidual u v c = finiteQTailSide u v c-finiteQTailSide v u c := by
    rw [finiteQResidual_eq_remainders u v c hu hv hc]
    unfold finiteQTailSide
    ring
  have hside1 := finiteQTailSide_norm_le u v c A T hA hAu huT hvT hAC
  have hside2 := finiteQTailSide_norm_le v u c A T hA hAv hvT huT hAC
  calc
    _ ≤ ‖finiteQTailSide u v c‖+‖finiteQTailSide v u c‖ := by rw [heq]; exact norm_sub_le _ _
    _ ≤ (625/888 : ℝ)*T/(A^2*‖c‖^4)+(625/888 : ℝ)*T/(A^2*‖c‖^4) :=
      add_le_add hside1 hside2
    _ = (625/444 : ℝ)*T/(A^2*‖c‖^4) := by ring
    _ < 3*T/(2*A^2*‖c‖^4) := by
      apply (div_lt_div_iff₀ (by positivity : 0 < A^2*‖c‖^4)
        (by positivity : 0 < 2*A^2*‖c‖^4)).2
      nlinarith only [mul_pos hT (by positivity : 0 < A^2*‖c‖^4)]

end D1Bound5
