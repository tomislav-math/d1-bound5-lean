import D1Bound5.SmallPairLargeDiscriminant
import D1Bound5.SmallQuadrupleData

namespace D1Bound5
open QuadInt

def pairCoordinates {tau nu : ℤ} (a b : QuadInt tau nu) : Finset (ℤ × ℤ) :=
  {(a.re,a.im), (b.re,b.im)}

/-- Complete classification checker for nondegenerate compatible small pairs. -/
def smallPairClassifiedBool {tau nu : ℤ} (xs : List (QuadInt tau nu))
    (rows : List (Finset (ℤ × ℤ))) : Bool :=
  xs.all fun a =>
    if decide (a ≠ 0) then
      xs.all fun b =>
        if decide (b ≠ 0 ∧ a ≠ b ∧ a*b+1 ≠ 0) then
          if hasSquareRoot (a*b+1) then decide (pairCoordinates a b ∈ rows) else true
        else true
    else true

theorem smallPairClassified_of_explicit_list {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (xs : List (QuadInt tau nu))
    (rows : List (Finset (ℤ × ℤ)))
    (cover : ∀ z ∈ disk tau nu 8, z ∈ xs)
    (checked : smallPairClassifiedBool xs rows = true)
    (a b : QuadInt tau nu) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) : pairCoordinates a b ∈ rows := by
  have hma := cover a ((mem_disk_iff hd 8 a).2 hNa)
  have hmb := cover b ((mem_disk_iff hd 8 b).2 hNb)
  have Ha := List.all_eq_true.mp checked a hma
  have ga : decide (a ≠ 0) = true := by simp [ha]
  simp only [ga, if_true] at Ha
  have Hb := List.all_eq_true.mp Ha b hmb
  have gb : decide (b ≠ 0 ∧ a ≠ b ∧ a*b+1 ≠ 0) = true := by
    simp [hb, hab, hnondeg]
  have hs := (hasSquareRoot_iff hd _).2 hroot
  simpa [gb, hs] using Hb

end D1Bound5
