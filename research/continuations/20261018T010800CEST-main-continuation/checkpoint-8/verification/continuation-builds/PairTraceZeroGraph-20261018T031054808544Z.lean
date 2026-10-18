import D1Bound5.PairGraphNoThreeTransfer
import D1Bound5.PairTraceZeroNoThree

namespace D1Bound5
open QuadInt

/-- In the trace-zero model with nu>1, checking the trace of every listed
vertex replaces all pair comparisons. The original graph predicate remains
unchanged, and its nonzero guards supply the algebraic endpoint's hypotheses. -/
theorem pairGraphTriangleFreeBool_of_trace_zero_tau_zero {nu : ℤ}
    (hnu : 1 < nu) (sieve : List (ℕ × ℕ))
    (hvalid : CoordinateSquareSieveValid 0 nu sieve)
    (vertices : List (QuadInt 0 nu))
    (htrace : pairAllTraceZeroBool vertices = true) :
    pairGraphTriangleFreeBool sieve vertices = true := by
  have hd : 0 < discriminant 0 nu := by
    dsimp [discriminant]
    nlinarith
  apply pairGraphTriangleFreeBool_of_no_three_nonzero hd sieve hvalid vertices
  intro x y z hx hy hz hx0 hy0 hz0 hxy hxz hyz
  exact trace_zero_no_three_tau_zero hnu x y z hx0 hy0 hz0
    (by simpa only [zero_mul, add_zero] using pairAllTraceZeroBool_sound vertices htrace x hx)
    (by simpa only [zero_mul, add_zero] using pairAllTraceZeroBool_sound vertices htrace y hy)
    (by simpa only [zero_mul, add_zero] using pairAllTraceZeroBool_sound vertices htrace z hz)
    hxy hxz hyz

/-- The half-integral trace-one model has the same structural graph proof
when 4nu-1>1. No color mask, edge table or pairwise calculation is required. -/
theorem pairGraphTriangleFreeBool_of_trace_zero_tau_one {nu : ℤ}
    (hnu : 1 < 4*nu-1) (sieve : List (ℕ × ℕ))
    (hvalid : CoordinateSquareSieveValid 1 nu sieve)
    (vertices : List (QuadInt 1 nu))
    (htrace : pairAllTraceZeroBool vertices = true) :
    pairGraphTriangleFreeBool sieve vertices = true := by
  have hd : 0 < discriminant 1 nu := by
    dsimp [discriminant]
    nlinarith
  apply pairGraphTriangleFreeBool_of_no_three_nonzero hd sieve hvalid vertices
  intro x y z hx hy hz hx0 hy0 hz0 hxy hxz hyz
  exact trace_zero_no_three_tau_one hnu x y z hx0 hy0 hz0
    (by simpa only [one_mul] using pairAllTraceZeroBool_sound vertices htrace x hx)
    (by simpa only [one_mul] using pairAllTraceZeroBool_sound vertices htrace y hy)
    (by simpa only [one_mul] using pairAllTraceZeroBool_sound vertices htrace z hz)
    hxy hxz hyz

end D1Bound5
