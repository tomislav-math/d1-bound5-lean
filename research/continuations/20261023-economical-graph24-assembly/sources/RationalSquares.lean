import D1Bound5.SquareTest

namespace D1Bound5

open QuadInt

/-- A square which is a rational integer is either the square of a
rational integer or comes from a trace-zero, purely imaginary root.
No assumptions on the quadratic coordinate ring are needed. -/
theorem rational_integer_square_cases {tau nu m : ℤ}
    (r : QuadInt tau nu) (hr : r*r = (m : QuadInt tau nu)) :
    (r.im = 0 ∧ r.re*r.re = m) ∨
    (2*r.re+tau*r.im = 0 ∧ 4*m = -discriminant tau nu*r.im^2) := by
  have hre : r.re*r.re-nu*r.im*r.im = m := by
    have h := congrArg QuadraticAlgebra.re hr
    simp only [QuadraticAlgebra.re_mul, QuadraticAlgebra.re_intCast] at h
    calc
      r.re*r.re-nu*r.im*r.im = r.re*r.re+(-nu)*r.im*r.im := by ring
      _ = m := h
  have him : (2*r.re+tau*r.im)*r.im = 0 := by
    have h := congrArg QuadraticAlgebra.im hr
    simp only [QuadraticAlgebra.im_mul, QuadraticAlgebra.im_intCast] at h
    nlinarith only [h]
  rcases mul_eq_zero.mp him with he | hi
  · right
    refine ⟨he, ?_⟩
    have ht : 4*r.re*r.re-tau^2*r.im^2=0 := by
      calc
        _ = (2*r.re+tau*r.im)*(2*r.re-tau*r.im) := by ring
        _ = 0 := by rw [he]; ring
    dsimp [discriminant]
    nlinarith only [hre, ht]
  · left
    refine ⟨hi, ?_⟩
    rw [hi] at hre
    simpa using hre

/-- A negative rational integer square has a purely imaginary root.
Its imaginary coordinate obeys the discriminant identity and parity. -/
theorem negative_integer_square_constraint {tau nu m : ℤ} (hm : m < 0)
    (hr : ∃ r : QuadInt tau nu, r*r = (m : QuadInt tau nu)) :
    ∃ y : ℤ, y ≠ 0 ∧ (tau*y)%2 = 0 ∧
      4*(-m) = discriminant tau nu*y^2 := by
  obtain ⟨r,hr⟩ := hr
  rcases rational_integer_square_cases r hr with h | h
  · have hnonneg := sq_nonneg r.re
    rcases h with ⟨_,hrm⟩
    nlinarith only [hm, hnonneg, hrm]
  · rcases h with ⟨he,heq⟩
    refine ⟨r.im, ?_, ?_, ?_⟩
    · intro hz
      rw [hz] at heq
      norm_num at heq
      omega
    · omega
    · nlinarith only [heq]

/-- The trace-zero model requires negative rational squares to be
minus the defining parameter times an integer square. -/
theorem negative_integer_square_trace_zero {nu m : ℤ} (hm : m < 0)
    (hr : ∃ r : QuadInt 0 nu, r*r = (m : QuadInt 0 nu)) :
    ∃ y : ℤ, m = -nu*y^2 := by
  obtain ⟨y,_,_,h⟩ := negative_integer_square_constraint hm hr
  refine ⟨y, ?_⟩
  dsimp [discriminant] at h
  norm_num at h
  nlinarith only [h]

/-- In the half-integral basis with trace one, a negative rational square
is minus the discriminant times an integer square. -/
theorem negative_integer_square_trace_one {nu m : ℤ} (hm : m < 0)
    (hr : ∃ r : QuadInt 1 nu, r*r = (m : QuadInt 1 nu)) :
    ∃ y : ℤ, m = -(4*nu-1)*y^2 := by
  obtain ⟨r,hr⟩ := hr
  rcases rational_integer_square_cases r hr with ⟨_,hrm⟩ | ⟨he,heq⟩
  · have hsq := sq_nonneg r.re
    nlinarith only [hm, hsq, hrm]
  · have hp : r.im % 2 = 0 := by omega
    let y := r.im/2
    have hy : r.im = 2*y := by dsimp [y]; omega
    refine ⟨y, ?_⟩
    rw [hy] at heq
    dsimp [discriminant] at heq
    nlinarith only [heq]

/-- A positive rational integer that is a square in an imaginary quadratic
integer ring is already an ordinary integer square. -/
theorem positive_integer_square_is_integer {tau nu m : ℤ}
    (hd : 0 < discriminant tau nu) (hm : 0 < m)
    (hr : ∃ r : QuadInt tau nu, r*r = (m : QuadInt tau nu)) :
    ∃ n : ℤ, m = n^2 := by
  obtain ⟨r,hr⟩ := hr
  rcases rational_integer_square_cases r hr with ⟨_, h⟩ | ⟨_, h⟩
  · exact ⟨r.re, by nlinarith only [h]⟩
  · have hp := mul_nonneg hd.le (sq_nonneg r.im)
    exfalso
    nlinarith only [hm, hp, h]

end D1Bound5
