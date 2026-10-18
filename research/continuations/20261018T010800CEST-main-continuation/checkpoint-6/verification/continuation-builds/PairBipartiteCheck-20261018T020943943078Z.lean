import D1Bound5.SmallPairGraphCheck

namespace D1Bound5
open QuadInt

/-- An arbitrary bit mask partitions every input occurrence. No correctness
condition on the mask, disjointness, or absence of duplicates is needed. -/
def pairSplitByMask {α : Type*} : List α → ℕ → List α × List α
  | [], _ => ([], [])
  | x::xs, colors =>
      let tail := pairSplitByMask xs (colors / 2)
      if colors.testBit 0 then (tail.1, x::tail.2) else (x::tail.1, tail.2)

theorem pairSplitByMask_covers {α : Type*} (vertices : List α) (colors : ℕ)
    (z : α) (hz : z ∈ vertices) :
    z ∈ (pairSplitByMask vertices colors).1 ∨
      z ∈ (pairSplitByMask vertices colors).2 := by
  induction vertices generalizing colors with
  | nil => cases hz
  | cons x xs ih =>
      rcases List.mem_cons.mp hz with he | ht
      · subst z
        cases hb : colors.testBit 0 <;> simp [pairSplitByMask, hb]
      · rcases ih (colors / 2) ht with hl | hr
        · cases hb : colors.testBit 0 <;> simp [pairSplitByMask, hb, hl]
        · cases hb : colors.testBit 0 <;> simp [pairSplitByMask, hb, hr]

/-- Each unordered pair of distinct values is tested once. Repetitions are
allowed; a square root of zero is treated exactly as every other root. -/
def pairIndependentBool {tau nu : ℤ} (sieve : List (ℕ × ℕ)) :
    List (QuadInt tau nu) → Bool
  | [] => true
  | x::xs =>
      (xs.all fun y => if decide (x = y) then true
        else !(hasSquareRootFast sieve (x*y+1))) && pairIndependentBool sieve xs

theorem pairIndependentBool_sound {tau nu : ℤ} (sieve : List (ℕ × ℕ))
    (vertices : List (QuadInt tau nu)) (hcheck : pairIndependentBool sieve vertices = true)
    (x y : QuadInt tau nu) (hx : x ∈ vertices) (hy : y ∈ vertices) (hxy : x ≠ y) :
    hasSquareRootFast sieve (x*y+1) = false := by
  induction vertices with
  | nil => cases hx
  | cons z zs ih =>
      have hh : (zs.all fun w => if decide (z = w) then true
          else !(hasSquareRootFast sieve (z*w+1))) = true ∧
          pairIndependentBool sieve zs = true := by
        simpa only [pairIndependentBool, Bool.and_eq_true] using hcheck
      rcases List.mem_cons.mp hx with hxz | hx
      · subst x
        have hy : y ∈ zs := (List.mem_cons.mp hy).resolve_left (Ne.symm hxy)
        have H := List.all_eq_true.mp hh.1 y hy
        simpa [hxy] using H
      · rcases List.mem_cons.mp hy with hyz | hy
        · subst y
          have H := List.all_eq_true.mp hh.1 x hx
          simpa [Ne.symm hxy, mul_comm] using H
        · exact ih hh.2 hx hy

/-- A certified two-color overgraph supplies the original triangle Boolean.
Only within-color nonedges are checked; cross-color pairs remain arbitrary. -/
theorem pairGraphTriangleFreeBool_of_independent_cover {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (vertices left right : List (QuadInt tau nu))
    (hcover : ∀ z ∈ vertices, z ∈ left ∨ z ∈ right)
    (hleft : pairIndependentBool sieve left = true)
    (hright : pairIndependentBool sieve right = true) :
    pairGraphTriangleFreeBool sieve vertices = true := by
  have no_triangle (a b c : QuadInt tau nu)
      (ha : a ∈ vertices) (hb : b ∈ vertices) (hc : c ∈ vertices)
      (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
      (hsab : hasSquareRootFast sieve (a*b+1) = true)
      (hsac : hasSquareRootFast sieve (a*c+1) = true)
      (hsbc : hasSquareRootFast sieve (b*c+1) = true) : False := by
    have reject_left (x y : QuadInt tau nu) (hx : x ∈ left) (hy : y ∈ left)
        (hxy : x ≠ y) (hs : hasSquareRootFast sieve (x*y+1) = true) : False := by
      have hf := pairIndependentBool_sound sieve left hleft x y hx hy hxy
      simp only [hf, Bool.false_eq_true] at hs
    have reject_right (x y : QuadInt tau nu) (hx : x ∈ right) (hy : y ∈ right)
        (hxy : x ≠ y) (hs : hasSquareRootFast sieve (x*y+1) = true) : False := by
      have hf := pairIndependentBool_sound sieve right hright x y hx hy hxy
      simp only [hf, Bool.false_eq_true] at hs
    rcases hcover a ha with hal | har
    · rcases hcover b hb with hbl | hbr
      · exact reject_left a b hal hbl hab hsab
      · rcases hcover c hc with hcl | hcr
        · exact reject_left a c hal hcl hac hsac
        · exact reject_right b c hbr hcr hbc hsbc
    · rcases hcover b hb with hbl | hbr
      · rcases hcover c hc with hcl | hcr
        · exact reject_left b c hbl hcl hbc hsbc
        · exact reject_right a c har hcr hac hsac
      · exact reject_right a b har hbr hab hsab
  unfold pairGraphTriangleFreeBool
  apply List.all_eq_true.mpr
  intro a ha
  by_cases hga : a ≠ 0
  · simp only [hga, decide_true, if_true]
    apply List.all_eq_true.mpr
    intro b hb
    by_cases hgb : b ≠ 0 ∧ a ≠ b
    · simp only [hgb, decide_true, if_true]
      cases hsab : hasSquareRootFast sieve (a*b+1) with
      | false => simp
      | true =>
          simp only [if_true]
          apply List.all_eq_true.mpr
          intro c hc
          by_cases hgc : c ≠ 0 ∧ a ≠ c ∧ b ≠ c
          · simp only [hgc, decide_true, if_true]
            cases hsac : hasSquareRootFast sieve (a*c+1) <;>
              cases hsbc : hasSquareRootFast sieve (b*c+1) <;> try rfl
            exact (no_triangle a b c ha hb hc hgb.2 hgc.2.1 hgc.2.2
              hsab hsac hsbc).elim
          · simp [hgc]
    · simp [hgb]
  · simp [hga]

theorem pairGraphTriangleFreeBool_of_split {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (vertices : List (QuadInt tau nu)) (colors : ℕ)
    (hleft : pairIndependentBool sieve (pairSplitByMask vertices colors).1 = true)
    (hright : pairIndependentBool sieve (pairSplitByMask vertices colors).2 = true) :
    pairGraphTriangleFreeBool sieve vertices = true := by
  apply pairGraphTriangleFreeBool_of_independent_cover sieve vertices
    (pairSplitByMask vertices colors).1 (pairSplitByMask vertices colors).2
    (fun z hz => pairSplitByMask_covers vertices colors z hz) hleft hright

end D1Bound5
