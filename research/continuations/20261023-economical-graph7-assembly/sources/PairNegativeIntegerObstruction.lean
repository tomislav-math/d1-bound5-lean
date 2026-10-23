import D1Bound5.RationalSquares

namespace D1Bound5

/-- An element with zero imaginary coordinate is its ordinary integer
real coordinate. No sign or discriminant hypothesis is needed. -/
theorem quadInt_eq_intCast_of_im_eq_zero {tau nu : ℤ}
    (z : QuadInt tau nu) (him : z.im = 0) :
    z = (z.re : QuadInt tau nu) := by
  apply QuadraticAlgebra.ext
  · simp only [QuadraticAlgebra.re_intCast, Int.cast_id]
  · simpa only [QuadraticAlgebra.im_intCast] using him

/-- In the trace-zero model, a negative rational integer square has
real coordinate divisible by nu. The existing coordinate classification
includes all possible roots, including zero-coordinate cases. -/
theorem negative_integer_square_dvd_trace_zero {nu : ℤ}
    (z : QuadInt 0 nu) (him : z.im = 0) (hre : z.re < 0)
    (hsquare : ∃ r : QuadInt 0 nu, r * r = z) : nu ∣ z.re := by
  obtain ⟨r, hr⟩ := hsquare
  have hcast : r * r = (z.re : QuadInt 0 nu) :=
    hr.trans (quadInt_eq_intCast_of_im_eq_zero z him)
  obtain ⟨y, hy⟩ := negative_integer_square_trace_zero hre ⟨r, hcast⟩
  refine ⟨-(y ^ 2), ?_⟩
  rw [hy]
  ring

/-- In the trace-one model, a negative rational integer square has
real coordinate divisible by 4*nu-1. No positivity assumption on this
parameter is required for the necessary divisibility condition. -/
theorem negative_integer_square_dvd_trace_one {nu : ℤ}
    (z : QuadInt 1 nu) (him : z.im = 0) (hre : z.re < 0)
    (hsquare : ∃ r : QuadInt 1 nu, r * r = z) : (4 * nu - 1) ∣ z.re := by
  obtain ⟨r, hr⟩ := hsquare
  have hcast : r * r = (z.re : QuadInt 1 nu) :=
    hr.trans (quadInt_eq_intCast_of_im_eq_zero z him)
  obtain ⟨y, hy⟩ := negative_integer_square_trace_one hre ⟨r, hcast⟩
  refine ⟨-(y ^ 2), ?_⟩
  rw [hy]
  ring

/-- A root-free rejection check for negative rational integers. It accepts
an obstruction only for the two supported coordinate traces; other traces
return false. No square roots, norms, or auxiliary witnesses are computed. -/
def pairNegativeIntegerObstructionBool {tau nu : ℤ}
    (z : QuadInt tau nu) : Bool :=
  decide (z.im = 0 ∧ z.re < 0) &&
    (if tau = 0 then decide (¬ nu ∣ z.re)
     else if tau = 1 then decide (¬ (4 * nu - 1) ∣ z.re)
     else false)

/-- A successful negative-integer obstruction excludes every square root.
In particular, rejection cannot discard a genuine zero root. -/
theorem pairNegativeIntegerObstructionBool_sound {tau nu : ℤ}
    (z : QuadInt tau nu) (h : pairNegativeIntegerObstructionBool z = true) :
    ¬ ∃ r : QuadInt tau nu, r * r = z := by
  unfold pairNegativeIntegerObstructionBool at h
  have hparts := Bool.and_eq_true_iff.mp h
  have hsign : z.im = 0 ∧ z.re < 0 := of_decide_eq_true hparts.1
  intro hsquare
  by_cases ht : tau = 0
  · have hfail : ¬ nu ∣ z.re :=
      of_decide_eq_true (by simpa only [if_pos ht] using hparts.2)
    subst tau
    exact hfail (negative_integer_square_dvd_trace_zero z hsign.1 hsign.2 hsquare)
  · by_cases ht1 : tau = 1
    · have hfail : ¬ (4 * nu - 1) ∣ z.re :=
        of_decide_eq_true (by simpa only [if_neg ht, if_pos ht1] using hparts.2)
      subst tau
      exact hfail (negative_integer_square_dvd_trace_one z hsign.1 hsign.2 hsquare)
    · simpa only [if_neg ht, if_neg ht1, Bool.false_eq_true] using hparts.2

end D1Bound5
