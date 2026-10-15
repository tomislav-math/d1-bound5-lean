import D1Bound5.FiniteTail
import Mathlib.Data.Prod.Lex

namespace D1Bound5

open QuadInt

/-- A decidable lexicographic order used exclusively to enumerate the
finite coordinate disk. It makes no order claim about a number field. -/
@[instance_reducible]
def coordinateLinearOrder (tau nu : ℤ) : LinearOrder (QuadInt tau nu) :=
  LinearOrder.lift' (β := ℤ ×ₗ ℤ) (fun z : QuadInt tau nu => ((z.re,z.im) : ℤ ×ₗ ℤ))
    (by
      intro x y h
      apply QuadraticAlgebra.ext
      · exact congrArg (fun p : ℤ ×ₗ ℤ => p.1) h
      · exact congrArg (fun p : ℤ ×ₗ ℤ => p.2) h)

/-- The computably sorted closed norm disk. -/
def diskOrderedList (tau nu : ℤ) : List (QuadInt tau nu) := by
  letI := coordinateLinearOrder tau nu
  exact (disk tau nu 15).sort

theorem mem_diskOrderedList_iff {tau nu : ℤ} (z : QuadInt tau nu) :
    z ∈ diskOrderedList tau nu ↔ z ∈ disk tau nu 15 := by
  unfold diskOrderedList
  simp only [Finset.mem_sort]

/-- A boolean, nested finite checker. Each guard is evaluated before
examining the next list. No unbounded search or floating point is used. -/
def smallTailCheckBool (tau nu : ℤ) : Bool :=
  let xs := diskOrderedList tau nu
  xs.all fun b =>
    xs.all fun c =>
      if decide (9 ≤ b.norm ∧ b.norm ≤ c.norm ∧ b ≠ c) then
        if hasSquareRoot (b*c+1) then
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
        else true
      else true

/-- A positive boolean certificate covers all eligible quadruples.
In particular, zero/anchor coincidences are checked before exclusion. -/
theorem smallTailCheckBool_sound {tau nu : ℤ}
    (h : smallTailCheckBool tau nu = true) : SmallTailCheck tau nu := by
  intro b hb c hc h9 hbc hne hsq d hd hd0 hdb hdc hcd a ha ha0 hab hac had hNa hsab hsac
  let xs := diskOrderedList tau nu
  have htop : xs.all (fun b =>
      xs.all fun c =>
        if decide (9 ≤ b.norm ∧ b.norm ≤ c.norm ∧ b ≠ c) then
          if hasSquareRoot (b*c+1) then
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
          else true
        else true) = true := h
  have hb' : b ∈ xs := (mem_diskOrderedList_iff b).2 hb
  have hc' : c ∈ xs := (mem_diskOrderedList_iff c).2 hc
  have ha' : a ∈ xs := (mem_diskOrderedList_iff a).2 ha
  have Hbc := (List.all_eq_true.mp ((List.all_eq_true.mp htop) b hb')) c hc'
  have HP : 9 ≤ b.norm ∧ b.norm ≤ c.norm ∧ b ≠ c := ⟨h9,hbc,hne⟩
  have HPb : decide (9 ≤ b.norm ∧ b.norm ≤ c.norm ∧ b ≠ c) = true := by simp [HP]
  have Hbc' : [b+c+2*rootCandidate (b*c+1),b+c-2*rootCandidate (b*c+1)].all
      (fun d => if decide (d ≠ 0 ∧ d ≠ b ∧ d ≠ c ∧ c.norm ≤ d.norm) then
        xs.all fun a => if decide (a ≠ 0 ∧ a ≠ b ∧ a ≠ c ∧ a ≠ d ∧ a.norm ≤ b.norm) then
          if hasSquareRoot (a*b+1) && hasSquareRoot (a*c+1) then
            !(hasSquareRoot (a*d+1)) else true else true else true) = true := by
    simpa only [HPb, hsq, if_true] using Hbc
  have Hd : d ∈ [b+c+2*rootCandidate (b*c+1),b+c-2*rootCandidate (b*c+1)] := by
    simpa using hd
  have Hd' := (List.all_eq_true.mp Hbc') d Hd
  have Hdp : d ≠ 0 ∧ d ≠ b ∧ d ≠ c ∧ c.norm ≤ d.norm := ⟨hd0,hdb,hdc,hcd⟩
  have Hdb : decide (d ≠ 0 ∧ d ≠ b ∧ d ≠ c ∧ c.norm ≤ d.norm) = true := by simp [Hdp]
  have Hd'' : xs.all (fun a => if decide
      (a ≠ 0 ∧ a ≠ b ∧ a ≠ c ∧ a ≠ d ∧ a.norm ≤ b.norm) then
      if hasSquareRoot (a*b+1) && hasSquareRoot (a*c+1) then
        !(hasSquareRoot (a*d+1)) else true else true) = true := by
    simpa only [Hdb, if_true] using Hd'
  have Ha' := (List.all_eq_true.mp Hd'') a ha'
  have Hap : a ≠ 0 ∧ a ≠ b ∧ a ≠ c ∧ a ≠ d ∧ a.norm ≤ b.norm :=
    ⟨ha0,hab,hac,had,hNa⟩
  have Hab : decide (a ≠ 0 ∧ a ≠ b ∧ a ≠ c ∧ a ≠ d ∧ a.norm ≤ b.norm) = true := by
    simp [Hap]
  have Hs : hasSquareRoot (a*b+1) && hasSquareRoot (a*c+1) = true := by
    simp [hsab,hsac]
  have Hresult : !(hasSquareRoot (a*d+1)) = true := by
    simpa [Hab,hsab,hsac] using Ha'
  cases hlast : hasSquareRoot (a*d+1) <;> simp_all

end D1Bound5
