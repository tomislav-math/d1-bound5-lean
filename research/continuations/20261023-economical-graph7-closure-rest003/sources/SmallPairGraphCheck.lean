import D1Bound5.FastSquareTest
import D1Bound5.PairExtensionComplete

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Filtering is performed only after the full reversible closure has been
certified. Zero, anchors and small entries are retained in that closure. -/
def largePairVertices {tau nu : ℤ} (a b : QuadInt tau nu)
    (vertices : List (QuadInt tau nu)) : List (QuadInt tau nu) :=
  vertices.filter fun z => decide (9 ≤ z.norm ∧ z ≠ 0 ∧ z ≠ a ∧ z ≠ b)

/-- A lazy triangle checker. The outer square edge gates the third-vertex
scan, and the proved modular prefilter rejects most huge nonsquares. -/
def pairGraphTriangleFreeBool {tau nu : ℤ} (sieve : List (ℕ × ℕ))
    (vertices : List (QuadInt tau nu)) : Bool :=
  vertices.all fun a =>
    if decide (a ≠ 0) then
      vertices.all fun b =>
        if decide (b ≠ 0 ∧ a ≠ b) then
          if hasSquareRootFast sieve (a*b+1) then
            vertices.all fun c =>
              if decide (c ≠ 0 ∧ a ≠ c ∧ b ≠ c) then
                !(hasSquareRootFast sieve (a*c+1) && hasSquareRootFast sieve (b*c+1))
              else true
          else true
        else true
    else true

/-- The finite graph certificate rules out three compatible vertices with
arbitrary coordinate size. There is no unverified graph computation. -/
theorem no_three_of_graph_certificate {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (sieve : List (ℕ × ℕ))
    (hvalid : CoordinateSquareSieveValid tau nu sieve) (vertices : List (QuadInt tau nu))
    (hcheck : pairGraphTriangleFreeBool sieve vertices = true)
    (t : Fin 3 → QuadInt tau nu) (ht : IsD1Tuple t)
    (hmem : ∀ i, t i ∈ vertices) : False := by
  have hne (i j : Fin 3) (hij : i ≠ j) : t i ≠ t j := fun h => hij (ht.1 h)
  have hs (i j : Fin 3) (hij : i ≠ j) :
      hasSquareRootFast sieve (t i*t j+1) = true :=
    (hasSquareRootFast_iff hd sieve hvalid _).2 (ht.2.2 i j hij)
  have Ha := List.all_eq_true.mp hcheck (t 0) (hmem 0)
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
  simpa [gc, hs02, hs12] using Hc

/-- Complete finite-graph exclusion for actual full-ring common extensions.
Every input hypothesis is either mathematical anchor data or a finite,
kernel-checkable seed, closure, filtering or triangle certificate. -/
theorem small_pair_graph_excludes_three_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {tau nu : ℤ} (hd : 0 < discriminant tau nu)
    (e : QuadInt tau nu ≃+* 𝓞 K) (a b : QuadInt tau nu)
    (ha : a ≠ 0) (hb : b ≠ 0) (hab : a*b+1 ≠ 0)
    (hroot : ∃ r0, r0*r0 = a*b+1) (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8)
    (bound : ℤ) (roots vertices large : List (QuadInt tau nu))
    (sieve : List (ℕ × ℕ)) (hvalid : CoordinateSquareSieveValid tau nu sieve)
    (hrootdisk : ∀ q ∈ disk tau nu 132, q ∈ roots)
    (hseeds : pairSeedsCoveredBool a b roots vertices = true)
    (hclosed : pairClosureBool a b bound vertices = true)
    (hfilter : largePairVertices a b vertices = large)
    (htriangle : pairGraphTriangleFreeBool sieve large = true)
    (t : Fin 3 → QuadInt tau nu) (ht : IsD1Tuple t)
    (hpair : ∀ i, PairExtension a b (t i))
    (hlarge : ∀ i, 9 ≤ (t i).norm)
    (hbound : ∀ i, (t i).norm ≤ bound)
    (hneA : ∀ i, t i ≠ a) (hneB : ∀ i, t i ≠ b) : False := by
  apply no_three_of_graph_certificate hd sieve hvalid large htriangle t ht
  intro i
  have hmem : t i ∈ vertices := by
    apply pairClosure_complete_full_ring hK phi hd e a b ha hb hab hroot hNa hNb
      bound vertices ?_ ?_ (t i) (hpair i) (hbound i)
    · intro z hz hNz
      exact pairSeedsCovered_of_checked hd a b ha hNa roots vertices
        hrootdisk hseeds z hz hNz
    · intro z hz w hw hNw
      exact pairClosure_of_checked a b bound vertices hclosed hz hw hNw
  rw [← hfilter]
  apply List.mem_filter.mpr
  refine ⟨hmem, ?_⟩
  simp only [decide_eq_true_eq]
  exact ⟨hlarge i, ht.2.1 i, hneA i, hneB i⟩

end D1Bound5
