import D1Bound5.PairBipartiteCheck

namespace D1Bound5

/-- Canonical coordinate residues at one positive modulus. They are computed
once per vertex and stored as ordinary natural numbers in a certificate. -/
def pairCoordinateResidues {tau nu : ℤ} (k : ℕ) (z : QuadInt tau nu) : ℕ × ℕ :=
  ((z.re : ZMod (k + 1)).val, (z.im : ZMod (k + 1)).val)

/-- The existing square mask applied to the product-plus-one coordinates,
computed entirely from two supplied pairs of small residues. -/
def pairResidueMaskBool (tau nu : ℤ) (k mask : ℕ) (u v : ℕ × ℕ) : Bool :=
  mask.testBit
    (((u.1 : ZMod (k + 1)) * (v.1 : ZMod (k + 1)) +
        (-(nu : ZMod (k + 1))) * (u.2 : ZMod (k + 1)) * (v.2 : ZMod (k + 1)) + 1).val *
      (k + 1) +
      ((u.1 : ZMod (k + 1)) * (v.2 : ZMod (k + 1)) +
        (u.2 : ZMod (k + 1)) * (v.1 : ZMod (k + 1)) +
        (tau : ZMod (k + 1)) * (u.2 : ZMod (k + 1)) * (v.2 : ZMod (k + 1))).val)

/-- This is equality of the actual computational mask predicates; no
primality, mask-validity, nonzero, or square-root assumption is used. -/
theorem pairResidueMaskBool_coordinates {tau nu : ℤ} (k mask : ℕ)
    (x y : QuadInt tau nu) :
    pairResidueMaskBool tau nu k mask (pairCoordinateResidues k x)
      (pairCoordinateResidues k y) = coordinateSquareMaskBool k mask (x * y + 1) := by
  simp only [pairResidueMaskBool, pairCoordinateResidues, coordinateSquareMaskBool,
    ZMod.natCast_zmod_val, QuadraticAlgebra.re_add, QuadraticAlgebra.im_add,
    QuadraticAlgebra.re_mul, QuadraticAlgebra.im_mul,
    QuadraticAlgebra.re_one, QuadraticAlgebra.im_one,
    Int.cast_add, Int.cast_mul, Int.cast_neg, Int.cast_one, Int.cast_zero, add_zero]

def pairCoordinateSignature {tau nu : ℤ} (sieve : List (ℕ × ℕ))
    (z : QuadInt tau nu) : List (ℕ × ℕ) :=
  sieve.map fun item => pairCoordinateResidues item.1 z

/-- The original ordered sieve evaluated on cached residues. Malformed or
truncated signatures are rejected, never accepted by a default lookup. -/
def pairCachedCoordinateSieveBool (tau nu : ℤ) :
    List (ℕ × ℕ) → List (ℕ × ℕ) → List (ℕ × ℕ) → Bool
  | [], [], [] => true
  | (k, mask) :: sieve, u :: us, v :: vs =>
      pairResidueMaskBool tau nu k mask u v &&
        pairCachedCoordinateSieveBool tau nu sieve us vs
  | _, _, _ => false

theorem pairCachedCoordinateSieveBool_signatures {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (x y : QuadInt tau nu) :
    pairCachedCoordinateSieveBool tau nu sieve (pairCoordinateSignature sieve x)
      (pairCoordinateSignature sieve y) = coordinateSquareSieveBool sieve (x * y + 1) := by
  induction sieve with
  | nil => rfl
  | cons item sieve ih =>
      rcases item with ⟨k, mask⟩
      change
        (pairResidueMaskBool tau nu k mask (pairCoordinateResidues k x)
          (pairCoordinateResidues k y) &&
          pairCachedCoordinateSieveBool tau nu sieve (pairCoordinateSignature sieve x)
            (pairCoordinateSignature sieve y)) =
        (coordinateSquareMaskBool k mask (x * y + 1) &&
          coordinateSquareSieveBool sieve (x * y + 1))
      rw [pairResidueMaskBool_coordinates, ih]

/-- A stored vertex and its untrusted modular signature. -/
structure PairResidueVertex (tau nu : ℤ) where
  vertex : QuadInt tau nu
  signature : List (ℕ × ℕ)

/-- The huge integral product and exact root test are evaluated only after
all cached modular masks accept the pair. -/
def pairCachedHasSquareRoot {tau nu : ℤ} (sieve : List (ℕ × ℕ))
    (x y : PairResidueVertex tau nu) : Bool :=
  pairCachedCoordinateSieveBool tau nu sieve x.signature y.signature &&
    QuadInt.hasSquareRoot (x.vertex * y.vertex + 1)

/-- Validated signatures give precisely the original fast square predicate. -/
theorem pairCachedHasSquareRoot_eq {tau nu : ℤ} (sieve : List (ℕ × ℕ))
    (x y : PairResidueVertex tau nu)
    (hx : x.signature = pairCoordinateSignature sieve x.vertex)
    (hy : y.signature = pairCoordinateSignature sieve y.vertex) :
    pairCachedHasSquareRoot sieve x y = hasSquareRootFast sieve (x.vertex * y.vertex + 1) := by
  unfold pairCachedHasSquareRoot
  rw [hx, hy, pairCachedCoordinateSieveBool_signatures] <;> rfl

/-- The accepted independent-class checker with its pair test replaced by
the computationally equivalent cached test. Repetitions still cause no edge. -/
def pairCachedIndependentBool {tau nu : ℤ} (sieve : List (ℕ × ℕ)) :
    List (PairResidueVertex tau nu) → Bool
  | [] => true
  | x :: xs =>
      (xs.all fun y => if decide (x.vertex = y.vertex) then true
        else !(pairCachedHasSquareRoot sieve x y)) && pairCachedIndependentBool sieve xs

theorem pairCachedIndependentBool_sound {tau nu : ℤ} (sieve : List (ℕ × ℕ))
    (cached : List (PairResidueVertex tau nu))
    (hvalid : ∀ x ∈ cached, x.signature = pairCoordinateSignature sieve x.vertex)
    (hcheck : pairCachedIndependentBool sieve cached = true) :
    pairIndependentBool sieve (cached.map PairResidueVertex.vertex) = true := by
  revert hvalid hcheck
  induction cached with
  | nil =>
      intro hvalid hcheck
      rfl
  | cons x xs ih =>
      intro hvalid hcheck
      have hx := hvalid x (by simp)
      have htail : ∀ y ∈ xs, y.signature = pairCoordinateSignature sieve y.vertex := by
        intro y hy
        exact hvalid y (List.mem_cons.mpr (Or.inr hy))
      have hparts := Bool.and_eq_true_iff.mp hcheck
      change
        ((xs.map PairResidueVertex.vertex).all (fun y =>
          if decide (x.vertex = y) then true else !(hasSquareRootFast sieve (x.vertex * y + 1))) &&
          pairIndependentBool sieve (xs.map PairResidueVertex.vertex)) = true
      apply Bool.and_eq_true_iff.mpr
      constructor
      · apply List.all_eq_true.mpr
        intro y hy
        obtain ⟨w, hw, rfl⟩ := List.mem_map.mp hy
        have hrow := List.all_eq_true.mp hparts.1 w hw
        have heq := pairCachedHasSquareRoot_eq sieve x w hx (htail w hw)
        simpa only [heq] using hrow
      · exact ih htail hparts.2

/-- The full certificate validates exact vertex-list coverage and every
signature before using the cached independent-class computation. -/
def pairCachedIndependentCertificateBool {tau nu : ℤ} (sieve : List (ℕ × ℕ))
    (vertices : List (QuadInt tau nu)) (cached : List (PairResidueVertex tau nu)) : Bool :=
  decide (cached.map PairResidueVertex.vertex = vertices) &&
    ((cached.all fun x => decide (x.signature = pairCoordinateSignature sieve x.vertex)) &&
      pairCachedIndependentBool sieve cached)

/-- Existing two-color and full-ring graph consumers need no changes: the
cached certificate proves the exact old independent-class Boolean. -/
theorem pairIndependentBool_of_cached_certificate {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (vertices : List (QuadInt tau nu))
    (cached : List (PairResidueVertex tau nu))
    (hcheck : pairCachedIndependentCertificateBool sieve vertices cached = true) :
    pairIndependentBool sieve vertices = true := by
  have hparts := Bool.and_eq_true_iff.mp hcheck
  have hcover : cached.map PairResidueVertex.vertex = vertices := of_decide_eq_true hparts.1
  have hrest := Bool.and_eq_true_iff.mp hparts.2
  have hvalid : ∀ x ∈ cached, x.signature = pairCoordinateSignature sieve x.vertex := by
    intro x hx
    exact of_decide_eq_true (List.all_eq_true.mp hrest.1 x hx)
  rw [← hcover]
  exact pairCachedIndependentBool_sound sieve cached hvalid hrest.2

end D1Bound5
