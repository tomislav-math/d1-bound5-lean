import D1Bound5.CoherentAnalyticInterpolation

namespace D1Bound5

/-- The principal branch used by the two-anchor approximation has the
required square and is nonzero throughout the actual size range. -/
theorem bennett_two_root_branch_sq_ne_zero
    (a c : ℂ) (hsize : 1 < ‖a‖*‖c‖) :
    ((1+1/(a*c))^(1/2 : ℂ))^(2 : ℕ) = 1+1/(a*c) ∧
      (1+1/(a*c))^(1/2 : ℂ) ≠ 0 := by
  have hsquare := coherent_cpow_half_sq (1+1/(a*c))
  refine ⟨hsquare, ?_⟩
  have hprod : 0 < ‖a‖*‖c‖ := by linarith
  have hsmall : ‖1/(a*c)‖ < 1 := by
    rw [norm_div, norm_one, norm_mul]
    exact (div_lt_one hprod).2 hsize
  have hbase : (1 : ℂ)+1/(a*c) ≠ 0 := by
    intro hzero
    have heq : 1/(a*c) = -(1 : ℂ) :=
      eq_neg_iff_add_eq_zero.mpr (by simpa only [add_comm] using hzero)
    have hn : ‖1/(a*c)‖ = 1 := by rw [heq]; norm_num
    linarith
  intro hzero
  rw [hzero, zero_pow (by decide : (2 : ℕ) ≠ 0)] at hsquare
  exact hbase hsquare.symm

/-- A uniform bound on the same actual branch. The weak rational constant
is chosen to leave room in the later signed-root approximation. -/
theorem bennett_two_root_branch_norm_lt
    (a c : ℂ) (hsize : 1000 ≤ ‖a‖*‖c‖) :
    ‖(1+1/(a*c))^(1/2 : ℂ)‖ < (6/5 : ℝ) := by
  have hprod : 0 < ‖a‖*‖c‖ := by linarith
  have hinv : ‖1/(a*c)‖ ≤ (1/1000 : ℝ) := by
    rw [norm_div, norm_one, norm_mul]
    apply (div_le_div_iff₀ hprod (by norm_num : (0 : ℝ) < 1000)).2
    simpa using hsize
  have hnorm : ‖(1+1/(a*c))^(1/2 : ℂ)‖^2 = ‖1+1/(a*c)‖ := by
    rw [← norm_pow, coherent_cpow_half_sq]
  have hbound := norm_add_le (1 : ℂ) (1/(a*c))
  rw [norm_one] at hbound
  have hnonneg := norm_nonneg ((1+1/(a*c))^(1/2 : ℂ))
  nlinarith only [hinv, hnorm, hbound, hnonneg]

end D1Bound5
