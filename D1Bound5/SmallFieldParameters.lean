import D1Bound5.FullRingClassification

namespace D1Bound5

/-- All trace-zero coordinate parameters that could occur in the
small-tail case with discriminant at most 60. Non-squarefree parameters
are intentionally retained, so this is a purely arithmetic reduction. -/
def smallTraceZeroParameters : Finset ℤ :=
  {1, 2, 4, 5, 6, 8, 9, 10, 12, 13, 14}

/-- All trace-one coordinate parameters of discriminant at most 60.
Again, the list deliberately contains the non-squarefree value 27. -/
def smallTraceOneParameters : Finset ℤ :=
  {3, 7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47, 51, 55, 59}

/-- Finite parameter completeness for the trace-zero model.
No prime factorization, squarefree decision or analytic estimate is used. -/
theorem small_trace_zero_parameter_complete (d : ℤ)
    (hd : 0 < d) (hmod : d % 4 ≠ 3) (hDelta : 4*d ≤ 60) :
    d ∈ smallTraceZeroParameters := by
  simp only [smallTraceZeroParameters, Finset.mem_insert,
    Finset.mem_singleton]
  omega

/-- Finite parameter completeness for the half-integral trace-one model. -/
theorem small_trace_one_parameter_complete (d : ℤ)
    (hd : 0 < d) (hmod : d % 4 = 3) (hDelta : d ≤ 60) :
    d ∈ smallTraceOneParameters := by
  simp only [smallTraceOneParameters, Finset.mem_insert,
    Finset.mem_singleton]
  omega

end D1Bound5
