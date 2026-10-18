import D1Bound5.PairLightArithmetic
import D1Bound5.PairRawSelectedFloorWitnesses

namespace D1Bound5

/-- Forget only the quadratic-algebra structure, retaining both coordinates. -/
def pairLightCoordinates {tau nu : ℤ} (z : QuadInt tau nu) : PairLightCoordinate :=
  (z.re, z.im)

/-- Retain the exact vertex coordinates and the entire supplied signature. -/
def pairLightCachedCoordinates {tau nu : ℤ} (x : PairResidueVertex tau nu) :
    PairLightCachedVertex :=
  (pairLightCoordinates x.vertex, x.signature)

theorem pairLightCoordinates_injective {tau nu : ℤ} :
    Function.Injective (pairLightCoordinates (tau := tau) (nu := nu)) := by
  intro x y h
  apply QuadraticAlgebra.ext
  · exact congrArg Prod.fst h
  · exact congrArg Prod.snd h

theorem pairLightCoordinates_eq_iff {tau nu : ℤ} (x y : QuadInt tau nu) :
    pairLightCoordinates x = pairLightCoordinates y ↔ x = y :=
  ⟨pairLightCoordinates_injective, congrArg pairLightCoordinates⟩

theorem pairLightCoordinates_list_eq_iff {tau nu : ℤ}
    (xs ys : List (QuadInt tau nu)) :
    xs.map pairLightCoordinates = ys.map pairLightCoordinates ↔ xs = ys := by
  induction xs generalizing ys with
  | nil => cases ys <;> simp
  | cons x xs ih =>
      cases ys with
      | nil => simp
      | cons y ys => simp only [List.map_cons, List.cons.injEq,
          pairLightCoordinates_eq_iff, ih]

/-- This is the pinned integer-cast residue identity, including negative z
and modulus one. The modulus k+1 supplies the required nonzero instance. -/
theorem pairLight_intCast_val (k : ℕ) (z : ℤ) :
    (z : ZMod (k + 1)).val = (z % Int.ofNat (k + 1)).toNat := by
  simpa only [Int.toNat_natCast] using
    congrArg Int.toNat (ZMod.val_intCast (n := k + 1) z)

theorem pairLightCoordinateResidues_eq {tau nu : ℤ} (k : ℕ) (z : QuadInt tau nu) :
    pairLightCoordinateResidues k (pairLightCoordinates z) = pairCoordinateResidues k z := by
  simp only [pairLightCoordinateResidues, pairLightCoordinates, pairCoordinateResidues,
    pairLight_intCast_val]

theorem pairLightCoordinateSignature_eq {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (z : QuadInt tau nu) :
    pairLightCoordinateSignature sieve (pairLightCoordinates z) =
      pairCoordinateSignature sieve z := by
  simp only [pairLightCoordinateSignature, pairCoordinateSignature,
    pairLightCoordinateResidues_eq]

theorem pairLightProductPlusOne_eq {tau nu : ℤ} (x y : QuadInt tau nu) :
    pairLightProductPlusOne tau nu (pairLightCoordinates x) (pairLightCoordinates y) =
      pairLightCoordinates (x * y + 1) := by
  apply Prod.ext <;>
    simp only [pairLightProductPlusOne, pairLightCoordinates,
      QuadraticAlgebra.re_add, QuadraticAlgebra.im_add,
      QuadraticAlgebra.re_mul, QuadraticAlgebra.im_mul,
      QuadraticAlgebra.re_one, QuadraticAlgebra.im_one] <;> ring

theorem pairLightNorm_eq {tau nu : ℤ} (z : QuadInt tau nu) :
    pairLightNorm tau nu (pairLightCoordinates z) = z.norm := by
  simpa only [pairLightNorm, pairLightCoordinates] using (QuadInt.norm_formula z).symm

/-- Equality is unconditional, so unsupported traces and all malformed
natural signatures retain exactly the accepted mask behavior. -/
theorem pairLightResidueMaskNatBool_eq_raw (tau nu : ℤ) (k mask : ℕ) (u v : ℕ × ℕ) :
    pairLightResidueMaskNatBool tau nu k mask u v = pairResidueMaskNatBool tau nu k mask u v := by
  have hn : (-(nu : ZMod (k + 1))).val = ((-nu) % Int.ofNat (k + 1)).toNat := by
    simpa only [Int.cast_neg] using pairLight_intCast_val k (-nu)
  simp only [pairLightResidueMaskNatBool, pairResidueMaskNatBool, hn, pairLight_intCast_val]

theorem pairLightSelectedMaskRejectBool_eq_raw (tau nu : ℤ) (sieve : List (ℕ × ℕ))
    (xs ys : PairLightSignature) (i : ℕ) :
    pairLightSelectedMaskRejectBool tau nu sieve xs ys i =
      pairSelectedCachedMaskNatRejectBool tau nu sieve xs ys i := by
  cases hm : sieve[i]? with
  | none => simp only [pairLightSelectedMaskRejectBool, pairSelectedCachedMaskNatRejectBool, hm]
  | some item =>
      rcases item with ⟨k, mask⟩
      cases hx : xs[i]? <;> cases hy : ys[i]? <;>
        simp only [pairLightSelectedMaskRejectBool, pairSelectedCachedMaskNatRejectBool,
          hm, hx, hy, pairLightResidueMaskNatBool_eq_raw]

theorem pairLightNegativeIntegerObstructionBool_eq {tau nu : ℤ} (z : QuadInt tau nu) :
    pairLightNegativeIntegerObstructionBool tau nu (pairLightCoordinates z) =
      pairNegativeIntegerObstructionBool z := by
  rfl

theorem pairLightFloorObstructionBool_eq {tau nu : ℤ} (z : QuadInt tau nu) (k : ℕ) :
    pairLightFloorObstructionBool tau nu (pairLightCoordinates z) k =
      QuadInt.floorObstructionBool z k := by
  simp only [pairLightFloorObstructionBool, QuadInt.floorObstructionBool,
    pairLightNorm, pairLightCoordinates, QuadInt.norm_formula]

/-- Every tail position, invalid tag, duplicate, guard branch and floor-list
case has exactly the old result. There is no data-validity premise. -/
theorem pairLightSelectedFloorRowBool_eq_raw {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (x : PairResidueVertex tau nu)
    (ys : List (PairResidueVertex tau nu)) (code : ℕ) (ks : List ℕ) :
    pairLightSelectedFloorRowBool tau nu sieve (pairLightCachedCoordinates x)
      (ys.map pairLightCachedCoordinates) code ks =
      pairRawSelectedFloorRowBool sieve x ys code ks := by
  induction ys generalizing code ks with
  | nil => rfl
  | cons y ys ih =>
      cases ks <;>
        simp only [List.map_cons, pairLightSelectedFloorRowBool,
          pairRawSelectedFloorRowBool, pairLightCachedCoordinates,
          pairLightSelectedMaskRejectBool_eq_raw, pairLightCoordinates_eq_iff,
          pairLightProductPlusOne_eq, pairLightNegativeIntegerObstructionBool_eq,
          pairLightFloorObstructionBool_eq, ih]

theorem pairLightSelectedFloorIndependentBool_eq_raw {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (cached : List (PairResidueVertex tau nu))
    (rows : List (ℕ × List ℕ)) :
    pairLightSelectedFloorIndependentBool tau nu sieve
      (cached.map pairLightCachedCoordinates) rows =
      pairRawSelectedFloorIndependentBool sieve cached rows := by
  induction cached generalizing rows with
  | nil => cases rows <;> rfl
  | cons x xs ih =>
      cases rows with
      | nil => rfl
      | cons item rows =>
          rcases item with ⟨code, ks⟩
          simp only [List.map_cons, pairLightSelectedFloorIndependentBool,
            pairRawSelectedFloorIndependentBool, pairLightSelectedFloorRowBool_eq_raw, ih]

theorem pairLightCachedCoordinates_coverage_iff {tau nu : ℤ}
    (cached : List (PairResidueVertex tau nu)) (vertices : List (QuadInt tau nu)) :
    (cached.map pairLightCachedCoordinates).map Prod.fst = vertices.map pairLightCoordinates ↔
      cached.map PairResidueVertex.vertex = vertices := by
  have hmap : (cached.map pairLightCachedCoordinates).map Prod.fst =
      (cached.map PairResidueVertex.vertex).map pairLightCoordinates := by
    simp only [List.map_map, Function.comp_def, pairLightCachedCoordinates]
  rw [hmap, pairLightCoordinates_list_eq_iff]

theorem pairLightCachedCoordinates_signatures_eq {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (cached : List (PairResidueVertex tau nu)) :
    ((cached.map pairLightCachedCoordinates).all fun x =>
      decide (x.2 = pairLightCoordinateSignature sieve x.1)) =
      (cached.all fun x => decide (x.signature = pairCoordinateSignature sieve x.vertex)) := by
  induction cached with
  | nil => rfl
  | cons x xs ih =>
      simp only [List.map_cons, List.all_cons, pairLightCachedCoordinates,
        pairLightCoordinateSignature_eq, ih]

/-- The complete arithmetic-only certificate is exactly the accepted raw
certificate for all parameters and all supplied lists. Ordered vertex coverage
and every canonical signature are preserved, including malformed data. -/
theorem pairLightSelectedFloorIndependentCertificateBool_eq_raw {tau nu : ℤ}
    (sieve : List (ℕ × ℕ)) (vertices : List (QuadInt tau nu))
    (cached : List (PairResidueVertex tau nu)) (rows : List (ℕ × List ℕ)) :
    pairLightSelectedFloorIndependentCertificateBool tau nu sieve
      (vertices.map pairLightCoordinates) (cached.map pairLightCachedCoordinates) rows =
      pairRawSelectedFloorIndependentCertificateBool sieve vertices cached rows := by
  simp only [pairLightSelectedFloorIndependentCertificateBool,
    pairRawSelectedFloorIndependentCertificateBool, pairLightCachedCoordinates_coverage_iff,
    pairLightCachedCoordinates_signatures_eq, pairLightSelectedFloorIndependentBool_eq_raw]

/-- Mathematical soundness is reused from the accepted checker only after
the unconditional Boolean identity. Positive discriminant is exactly the
original soundness premise and is not needed for the computation equality. -/
theorem pairIndependentBool_of_light_selected_floor_certificate {tau nu : ℤ}
    (hd : 0 < QuadInt.discriminant tau nu) (sieve : List (ℕ × ℕ))
    (vertices : List (QuadInt tau nu)) (cached : List (PairResidueVertex tau nu))
    (rows : List (ℕ × List ℕ))
    (hcheck : pairLightSelectedFloorIndependentCertificateBool tau nu sieve
      (vertices.map pairLightCoordinates) (cached.map pairLightCachedCoordinates) rows = true) :
    pairIndependentBool sieve vertices = true :=
  pairIndependentBool_of_raw_selected_floor_certificate hd sieve vertices cached rows
    ((pairLightSelectedFloorIndependentCertificateBool_eq_raw sieve vertices cached rows).symm.trans hcheck)

end D1Bound5
