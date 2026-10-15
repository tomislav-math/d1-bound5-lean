import Mathlib.Algebra.Order.Archimedean.Real.Basic

namespace D1Bound5

/-- The logical interval-chain step used in Section common-intervals.
All endpoints are closed. The input intervals need not have distinct ends. -/
theorem forbidden_interval_chain {R : Type*} [LinearOrder R]
    (lower upper : ℕ → R) (x : R)
    (hstart : lower 0 ≤ x)
    (hoverlap : ∀ n, lower (n+1) ≤ upper n)
    (hexcluded : ∀ n, ¬ (lower n ≤ x ∧ x ≤ upper n))
    (hunbounded : ∃ n, x < lower n) : False := by
  have hle : ∀ n, lower n ≤ x := by
    intro n
    induction n with
    | zero => exact hstart
    | succ n ih =>
      have hupper : upper n < x := lt_of_not_ge fun h => hexcluded n ⟨ih, h⟩
      exact (hoverlap n).trans hupper.le
  obtain ⟨n, hn⟩ := hunbounded
  exact (not_lt_of_ge (hle n)) hn

/-- Positive geometric lower endpoints tend beyond every fixed candidate.
This is an all-orders argument, not a finite sample of interval checks. -/
theorem scaled_power_unbounded (c a x : ℝ) (hc : 0 < c) (ha : 1 < a) :
    ∃ n : ℕ, x < c*a^n := by
  obtain ⟨n, hn⟩ := pow_unbounded_of_one_lt (x/c) ha
  refine ⟨n, ?_⟩
  have h := (div_lt_iff₀ hc).mp hn
  simpa only [mul_comm] using h

/-- Assembly of an already-proved geometric forbidden-interval family.
The interval exclusions and overlap estimates remain explicit hypotheses. -/
theorem geometric_forbidden_interval_chain (c a x : ℝ) (upper : ℕ → ℝ)
    (hc : 0 < c) (ha : 1 < a) (hstart : c ≤ x)
    (hoverlap : ∀ n, c*a^(n+1) ≤ upper n)
    (hexcluded : ∀ n, ¬ (c*a^n ≤ x ∧ x ≤ upper n)) : False := by
  apply forbidden_interval_chain (fun n => c*a^n) upper x
  · simpa using hstart
  · exact hoverlap
  · exact hexcluded
  · exact scaled_power_unbounded c a x hc ha

/-- Exact transfer from normalized squared-root bounds to a closed forbidden
interval for the terminal modulus; see (pr-transfer). -/
theorem transfer_forbidden_interval (x d l u alpha beta : ℝ)
    (ha : 0 < alpha) (hb : 0 < beta)
    (hlo : alpha*d ≤ x) (hhi : x ≤ beta*d)
    (hexcluded : ¬ (l ≤ x ∧ x ≤ u)) :
    ¬ (l/alpha ≤ d ∧ d ≤ u/beta) := by
  rintro ⟨hl, hu⟩
  apply hexcluded
  have hl' : l ≤ alpha*d := by
    simpa only [mul_comm] using (div_le_iff₀ ha).mp hl
  have hu' : beta*d ≤ u := by
    simpa only [mul_comm] using (le_div_iff₀ hb).mp hu
  exact ⟨hl'.trans hlo, hhi.trans hu'⟩

end D1Bound5
