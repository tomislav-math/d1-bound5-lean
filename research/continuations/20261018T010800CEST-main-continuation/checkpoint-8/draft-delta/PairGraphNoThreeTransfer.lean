import D1Bound5.SmallPairGraphCheck

namespace D1Bound5
open QuadInt

/-- A mathematical exclusion of three nonzero compatible points supplies
exactly the original triangle Boolean, without enumerating the pairs. -/
theorem pairGraphTriangleFreeBool_of_no_three_nonzero {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (sieve : List (ℕ × ℕ))
    (hvalid : CoordinateSquareSieveValid tau nu sieve)
    (vertices : List (QuadInt tau nu))
    (hno : ∀ x y z : QuadInt tau nu,
      x ∈ vertices → y ∈ vertices → z ∈ vertices →
      x ≠ 0 → y ≠ 0 → z ≠ 0 →
      (∃ r, r*r = x*y+1) → (∃ r, r*r = x*z+1) →
      (∃ r, r*r = y*z+1) → False) :
    pairGraphTriangleFreeBool sieve vertices = true := by
  unfold pairGraphTriangleFreeBool
  apply List.all_eq_true.mpr
  intro a ha
  by_cases hga : decide (a ≠ 0) = true
  · rw [if_pos hga]
    have ha0 : a ≠ 0 := of_decide_eq_true hga
    apply List.all_eq_true.mpr
    intro b hb
    by_cases hgb : decide (b ≠ 0 ∧ a ≠ b) = true
    · rw [if_pos hgb]
      have hgb' : b ≠ 0 ∧ a ≠ b := of_decide_eq_true hgb
      by_cases hsab : hasSquareRootFast sieve (a*b+1) = true
      · rw [if_pos hsab]
        apply List.all_eq_true.mpr
        intro c hc
        by_cases hgc : decide (c ≠ 0 ∧ a ≠ c ∧ b ≠ c) = true
        · rw [if_pos hgc]
          have hgc' : c ≠ 0 ∧ a ≠ c ∧ b ≠ c := of_decide_eq_true hgc
          cases hsac : hasSquareRootFast sieve (a*c+1) <;>
            cases hsbc : hasSquareRootFast sieve (b*c+1) <;> try rfl
          exact (hno a b c ha hb hc ha0 hgb'.1 hgc'.1
            ((hasSquareRootFast_iff hd sieve hvalid _).1 hsab)
            ((hasSquareRootFast_iff hd sieve hvalid _).1 hsac)
            ((hasSquareRootFast_iff hd sieve hvalid _).1 hsbc)).elim
        · rw [if_neg hgc]
      · rw [if_neg hsab]
    · rw [if_neg hgb]
  · rw [if_neg hga]

/-- This certificate is linear in the number of vertices. It checks the
actual trace coordinate for every occurrence, including zero if present. -/
def pairAllTraceZeroBool {tau nu : ℤ} (vertices : List (QuadInt tau nu)) : Bool :=
  vertices.all fun z => decide (2*z.re+tau*z.im = 0)

theorem pairAllTraceZeroBool_sound {tau nu : ℤ} (vertices : List (QuadInt tau nu))
    (hcheck : pairAllTraceZeroBool vertices = true) (z : QuadInt tau nu)
    (hz : z ∈ vertices) : 2*z.re+tau*z.im = 0 := by
  exact of_decide_eq_true (List.all_eq_true.mp hcheck z hz)

end D1Bound5
