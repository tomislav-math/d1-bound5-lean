import D1Bound5.FiniteTail

namespace D1Bound5
open QuadInt

/-- Check the two regular completions against every candidate first entry.
The list may contain zero and anchor coincidences; the guards handle them. -/
def tailPairBool {tau nu : ℤ} (xs : List (QuadInt tau nu))
    (b c : QuadInt tau nu) : Bool :=
  let r := rootCandidate (b*c+1)
  [b+c+2*r,b+c-2*r].all fun d =>
    if decide (d ≠ 0 ∧ d ≠ b ∧ d ≠ c ∧ c.norm ≤ d.norm) then
      xs.all fun a =>
        if decide (a ≠ 0 ∧ a ≠ b ∧ a ≠ c ∧ a ≠ d ∧ a.norm ≤ b.norm) then
          if hasSquareRoot (a*b+1) && hasSquareRoot (a*c+1) then
            !(hasSquareRoot (a*d+1))
          else true
        else true
    else true

/-- A fully explicit list checker, avoiding noncomputable list conversion. -/
def tailListBool {tau nu : ℤ} (xs : List (QuadInt tau nu)) : Bool :=
  xs.all fun b => xs.all fun c =>
    if decide (9 ≤ b.norm ∧ b.norm ≤ c.norm ∧ b ≠ c) then
      if hasSquareRoot (b*c+1) then tailPairBool xs b c else true
    else true

/-- The explicit finite list covers the entire mathematical small-tail
statement when it covers the closed disk. The list need not be minimal. -/
theorem smallTailCheck_of_explicit_list {tau nu : ℤ}
    (xs : List (QuadInt tau nu))
    (cover : ∀ z ∈ disk tau nu 15, z ∈ xs)
    (checked : tailListBool xs = true) : SmallTailCheck tau nu := by
  intro b hb c hc h9 hbc hne hsq d hd hd0 hdb hdc hcd
    a ha ha0 hab hac had hNa hsab hsac
  have Hbc := (List.all_eq_true.mp
    ((List.all_eq_true.mp checked) b (cover b hb))) c (cover c hc)
  have Hguard : decide (9 ≤ b.norm ∧ b.norm ≤ c.norm ∧ b ≠ c) = true := by
    simp [h9,hbc,hne]
  have Hp : tailPairBool xs b c = true := by
    simpa only [Hguard,hsq,if_true] using Hbc
  have Hdmem : d ∈ [b+c+2*rootCandidate (b*c+1),b+c-2*rootCandidate (b*c+1)] := by
    simpa using hd
  have Hd := (List.all_eq_true.mp Hp) d Hdmem
  have Hdguard : decide (d ≠ 0 ∧ d ≠ b ∧ d ≠ c ∧ c.norm ≤ d.norm) = true := by
    simp [hd0,hdb,hdc,hcd]
  simp only [Hdguard,if_true] at Hd
  have Ha := (List.all_eq_true.mp Hd) a (cover a ha)
  have Haguard : decide (a ≠ 0 ∧ a ≠ b ∧ a ≠ c ∧ a ≠ d ∧ a.norm ≤ b.norm) = true := by
    simp [ha0,hab,hac,had,hNa]
  cases h : hasSquareRoot (a*d+1) with
  | false => rfl
  | true => simp [Haguard,hsab,hsac,h] at Ha

end D1Bound5
