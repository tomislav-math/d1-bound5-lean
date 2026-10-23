import D1Bound5.Basic
import D1Bound5.SquareTest
import D1Bound5.DiskEnumeration

namespace D1Bound5

open QuadInt

/-- The no-four-small-elements assertion, expressed in integer coordinates.
The norm bound eight is exactly the strict modulus bound three. -/
def NoSmallQuadruple (tau nu : ℤ) : Prop :=
  ∀ t : Fin 4 → QuadInt tau nu,
    IsD1Tuple t → (∀ i, (t i).norm ≤ 8) → False

/-- A finite complete-clique checker. Square roots may be zero, and the
input list may include zero; only the tuple entries must be nonzero. -/
def smallQuadrupleListBool {tau nu : ℤ} (xs : List (QuadInt tau nu)) : Bool :=
  xs.all fun a =>
    if decide (a ≠ 0) then
      xs.all fun b =>
        if decide (b ≠ 0 ∧ a ≠ b) then
          if hasSquareRoot (a*b+1) then
            xs.all fun c =>
              if decide (c ≠ 0 ∧ a ≠ c ∧ b ≠ c) then
                if hasSquareRoot (a*c+1) && hasSquareRoot (b*c+1) then
                  xs.all fun d =>
                    if decide (d ≠ 0 ∧ a ≠ d ∧ b ≠ d ∧ c ≠ d) then
                      !(hasSquareRoot (a*d+1) && hasSquareRoot (b*d+1) &&
                        hasSquareRoot (c*d+1))
                    else true
                else true
              else true
          else true
        else true
    else true

/-- A kernel-checked list plus proved disk coverage establishes the whole
mathematical statement; no untrusted search output is used as an assumption. -/
theorem noSmallQuadruple_of_explicit_list {tau nu : ℤ}
    (hpos : 0 < discriminant tau nu)
    (xs : List (QuadInt tau nu))
    (cover : ∀ z ∈ disk tau nu 8, z ∈ xs)
    (checked : smallQuadrupleListBool xs = true) :
    NoSmallQuadruple tau nu := by
  intro t ht hnorm
  have hmem (i : Fin 4) : t i ∈ xs :=
    cover (t i) ((mem_disk_iff hpos 8 (t i)).2 (hnorm i))
  have hne (i j : Fin 4) (hij : i ≠ j) : t i ≠ t j :=
    fun h => hij (ht.1 h)
  have hs (i j : Fin 4) (hij : i ≠ j) :
      hasSquareRoot (t i*t j+1) = true :=
    (hasSquareRoot_iff hpos _).2 (ht.2.2 i j hij)
  have Ha := List.all_eq_true.mp checked (t 0) (hmem 0)
  have ga : decide (t 0 ≠ 0) = true := by simp [ht.2.1 0]
  simp only [ga, if_true] at Ha
  have Hb := List.all_eq_true.mp Ha (t 1) (hmem 1)
  have gb : decide (t 1 ≠ 0 ∧ t 0 ≠ t 1) = true := by
    simp [ht.2.1 1, hne 0 1 (by decide)]
  have hs01 := hs 0 1 (by decide)
  simp only [gb, hs01, if_true] at Hb
  have Hc := List.all_eq_true.mp Hb (t 2) (hmem 2)
  have gc : decide (t 2 ≠ 0 ∧ t 0 ≠ t 2 ∧ t 1 ≠ t 2) = true := by
    simp [ht.2.1 2, hne 0 2 (by decide), hne 1 2 (by decide)]
  have hs02 := hs 0 2 (by decide)
  have hs12 := hs 1 2 (by decide)
  simp only [gc, hs02, hs12, Bool.true_and, if_true] at Hc
  have Hd := List.all_eq_true.mp Hc (t 3) (hmem 3)
  have gd : decide (t 3 ≠ 0 ∧ t 0 ≠ t 3 ∧ t 1 ≠ t 3 ∧ t 2 ≠ t 3) = true := by
    simp [ht.2.1 3, hne 0 3 (by decide), hne 1 3 (by decide),
      hne 2 3 (by decide)]
  have hs03 := hs 0 3 (by decide)
  have hs13 := hs 1 3 (by decide)
  have hs23 := hs 2 3 (by decide)
  simpa [gd, hs03, hs13, hs23] using Hd

end D1Bound5
