import D1Bound5.BennettTwoHeightBounds

namespace D1Bound5

/-- Dividing a positive-order even power by its own anchor preserves
monotonicity. This is the scalar cancellation needed for the two columns. -/
theorem bennett_weighted_even_power_le
    (A B H : ℝ) (hA : 0 < A) (hB : 0 < B) (hAB : A ≤ B)
    (hH : 0 ≤ H) (k : ℕ) (hk : 1 ≤ k) :
    (A^2*H)^k/A ≤ (B^2*H)^k/B := by
  obtain ⟨n, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (by omega : k ≠ 0)
  have hleft : (A^2*H)^(n+1)/A = A*(A^2*H)^n*H := by
    rw [pow_succ]
    field_simp [hA.ne']
    <;> ring
  have hright : (B^2*H)^(n+1)/B = B*(B^2*H)^n*H := by
    rw [pow_succ]
    field_simp [hB.ne']
    <;> ring
  rw [hleft, hright]
  gcongr

/-- The actual two anchor columns satisfy the combined height bound used
in the integral approximation form, with no coefficient bound premise. -/
theorem bennettTwoClearedEntry_weighted_height
    (a b c : ℂ) (ha : a ≠ 0) (hb : b ≠ 0) (hc : c ≠ 0) (hab : a ≠ b)
    (hAB : ‖a‖ ≤ ‖b‖) (hAC : 1000 ≤ ‖a‖*‖c‖)
    (k : ℕ) (hk : 1 ≤ k) (i : Fin 3) :
    ‖bennettTwoClearedEntry a b c k i 1‖/‖a‖ +
        ‖bennettTwoClearedEntry a b c k i 2‖/‖b‖ <
      2*(42*‖b‖^3*‖c‖)^k/‖b‖ := by
  have hA : 0 < ‖a‖ := norm_pos_iff.mpr ha
  have hB : 0 < ‖b‖ := norm_pos_iff.mpr hb
  obtain ⟨h1, h2⟩ := bennettTwoClearedEntry_height_bounds
    a b c ha hb hc hab hAB hAC k hk i
  have hpower : (42*‖a‖^2*‖b‖*‖c‖)^k/‖a‖ ≤
      (42*‖b‖^3*‖c‖)^k/‖b‖ := by
    have heqA : 42*‖a‖^2*‖b‖*‖c‖ = ‖a‖^2*(42*‖b‖*‖c‖) := by ring
    have heqB : 42*‖b‖^3*‖c‖ = ‖b‖^2*(42*‖b‖*‖c‖) := by ring
    rw [heqA, heqB]
    exact bennett_weighted_even_power_le ‖a‖ ‖b‖ (42*‖b‖*‖c‖)
      hA hB hAB (by positivity) k hk
  have hfirst := (div_lt_div_of_pos_right h1 hA).trans_le hpower
  have hsecond := div_lt_div_of_pos_right h2 hB
  linarith only [hfirst, hsecond]

end D1Bound5
