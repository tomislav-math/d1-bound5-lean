import D1Bound5.OrdinaryHeightEnvelope

namespace D1Bound5

theorem unit_pair_residual_rate_lower (S : ℝ) (hS : 1000 ≤ S) :
    (2/5 : ℝ)*S^2 < 27*(S-1)^2/64 := by
  have hp := mul_nonneg (sub_nonneg.mpr hS)
    (show 0 ≤ S by linarith only [hS])
  nlinarith only [hp,hS]

theorem ordinaryLog10_ge_four {S : ℝ} (hS : 10000 ≤ S) :
    4 ≤ ordinaryLog10 S := by
  have h := ordinaryLog10_mono (by norm_num : (0 : ℝ) < 10^4)
    (show (10 : ℝ)^4 ≤ S by norm_num; exact hS)
  simpa only [ordinaryLog10_pow,ordinaryLog10_ten,mul_one,Nat.cast_ofNat] using h

/-- Specialization of the ordinary envelope to the unit-pair anchors.
The three logarithmic parameters are certified by exact power comparisons. -/
theorem unit_pair_height_upper_from_orders (S D Z : ℝ)
    (hS : 10000 ≤ S) (hD : 0 < D) (hZ : 1 ≤ Z) (hprod : S*D < 2*Z^2)
    (horders : ∀ k : ℕ, 1 ≤ k →
      1 < 3*S*(42*S)^k/Z+Z/(2*(27*(S-1)^2/64)^k)) :
    ordinaryLog10 D < 7*ordinaryLog10 S+617/25+
      (118401/2500)/(ordinaryLog10 S-203/100) := by
  have hS0 : 0 < S := by linarith only [hS]
  have hS1 : 1 < S := by linarith only [hS]
  have hlogS : 4 ≤ ordinaryLog10 S := ordinaryLog10_ge_four hS
  obtain ⟨h42,h25,h253⟩ := ordinaryLog10_unit_parameters
  have hrate := unit_pair_residual_rate_lower S (by linarith only [hS])
  have hR : 0 < 27*(S-1)^2/64 :=
    (show 0 < (2/5 : ℝ)*S^2 by positivity).trans hrate
  have hHlog : ordinaryLog10 (42*1^3*S) < ordinaryLog10 S+(163/100 : ℝ) := by
    norm_num only [one_pow,mul_one]
    rw [ordinaryLog10_mul 42 S (by norm_num) hS0.ne']
    linarith only [h42]
  have hRlog : 2*ordinaryLog10 S-(2/5 : ℝ) < ordinaryLog10 (27*(S-1)^2/64) := by
    have h := ordinaryLog10_strictMono (by positivity : 0 < (2/5 : ℝ)*S^2) hrate
    rw [ordinaryLog10_mul (2/5) (S^2) (by norm_num) (by positivity),
      ordinaryLog10_pow] at h
    norm_num only [Nat.cast_ofNat] at h
    linarith only [h,h25]
  have h := ordinary_height_envelope_from_orders 1 S D Z (27*(S-1)^2/64)
    (163/100) (-2/5) (241/100) (by norm_num) hS1 hD hZ hR hprod
    hHlog (by simpa only [sub_eq_add_neg,neg_div] using hRlog)
    (by simpa only [one_pow,mul_one] using h253)
    (by linarith only [hlogS]) (by linarith only [hlogS])
    (by intro k hk; simpa only [one_pow,mul_one,one_mul] using horders k hk)
  norm_num at h
  exact h

/-- The unit-pair cubic iteration and the actual all-order inequalities
force the first extension below 10^4. The conditional input merely
restricts the analytic estimates to the large regime where they apply. -/
theorem unit_pair_height_cutoff_from_orders (S D Z : ℝ)
    (hS : 0 < S) (hD : 0 < D) (hZ : 1 ≤ Z) (hprod : S*D < 2*Z^2)
    (hgrowth : S^27/8192 < D)
    (horders : 10000 ≤ S → ∀ k : ℕ, 1 ≤ k →
      1 < 3*S*(42*S)^k/Z+Z/(2*(27*(S-1)^2/64)^k)) : S < 10000 := by
  by_contra hbad
  have hSbig : 10000 ≤ S := le_of_not_gt hbad
  have hlogS : 4 ≤ ordinaryLog10 S := ordinaryLog10_ge_four hSbig
  have hupper := unit_pair_height_upper_from_orders S D Z hSbig hD hZ hprod
    (horders hSbig)
  have hpow : S^27 < (10 : ℝ)^4*D := by
    norm_num
    nlinarith only [hgrowth,hD]
  have hlower := ordinaryLog10_strictMono (pow_pos hS 27) hpow
  rw [ordinaryLog10_pow,ordinaryLog10_mul (10^4) D (by norm_num) hD.ne',
    ordinaryLog10_pow,ordinaryLog10_ten] at hlower
  norm_num at hlower
  exact unit_pair_height_cutoff_scalar (ordinaryLog10 S) (ordinaryLog10 D) hlogS
    (by linarith only [hlower]) hupper

end D1Bound5
